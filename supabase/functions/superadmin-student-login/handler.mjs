// This handler never logs passwords, OTPs, tokens or provider response bodies.
const uuid = /^[0-9a-f]{8}-(?:[0-9a-f]{4}-){3}[0-9a-f]{12}$/i;
const phonePattern = /^989[0-9]{9}$/;
const actions = ['create','password','confirm','password_confirm'];
const json = (status, body) => new Response(JSON.stringify(body), {status,headers:{'content-type':'application/json','cache-control':'no-store'}});
function jwtSession(auth) {
  try {
    const token=auth.replace(/^Bearer /i,'');
    const payload=JSON.parse(atob(token.split('.')[1].replace(/-/g,'+').replace(/_/g,'/')));
    return typeof payload.session_id==='string' && uuid.test(payload.session_id) ? payload.session_id : null;
  } catch { return null; }
}
function generateCode(crypto) {
  const n=new Uint32Array(1);
  do {crypto.getRandomValues(n);} while(n[0]>=4200000000);
  return String(n[0]%100000000).padStart(8,'0');
}
async function digest(crypto, key, id, code) {
  const encoder=new TextEncoder();
  const cryptoKey=await crypto.subtle.importKey('raw',encoder.encode(key),{name:'HMAC',hash:'SHA-256'},false,['sign']);
  const signature=await crypto.subtle.sign('HMAC',cryptoKey,encoder.encode(`nova-student-login-otp:${id}:${code}`));
  return [...new Uint8Array(signature)].map(x=>x.toString(16).padStart(2,'0')).join('');
}
export function makeHandler({createClient,env,fetch,crypto}) {
 return async function(req) {
  if(req.method!=='POST')return json(405,{error:'درخواست نامعتبر است.'});
  const auth=req.headers.get('authorization') ?? '';
  const session=jwtSession(auth);
  if(!/^Bearer /i.test(auth)||!session)return json(401,{error:'ابتدا وارد حساب شو.'});
  const url=env('SUPABASE_URL'), anon=env('SUPABASE_ANON_KEY'), service=env('SUPABASE_SERVICE_ROLE_KEY'), emailKey=env('NOVA_ADMIN_OTP_RESEND_API_KEY');
  if(!url||!anon||!service||!emailKey)return json(503,{error:'امکان ارسال یا تأیید کد فعال نیست.'});
  try {
   const reader=req.body?.getReader(); if(!reader)return json(400,{error:'درخواست نامعتبر است.'});
   const chunks=[];let size=0;
   while(true){const part=await reader.read();if(part.done)break;size+=part.value.length;if(size>4096){await reader.cancel();return json(413,{error:'درخواست نامعتبر است.'});}chunks.push(part.value);}
   const bytes=new Uint8Array(size);let offset=0;for(const chunk of chunks){bytes.set(chunk,offset);offset+=chunk.length;}
   const body=JSON.parse(new TextDecoder().decode(bytes));
   if(!body || typeof body!=='object')return json(400,{error:'درخواست نامعتبر است.'});
   const client=createClient(url,anon,{global:{headers:{Authorization:auth}},auth:{persistSession:false,autoRefreshToken:false}});
   const {data:{user},error:userError}=await client.auth.getUser();
   if(userError||!user?.id||!user.email||!user.email_confirmed_at)return json(403,{error:'ایمیل تأییدشده و دسترسی سوپرادمین لازم است.'});
   const {data:supers,error:superError}=await client.rpc('admin_list_super_admins');
   if(superError||!Array.isArray(supers)||!supers.some(row=>row.user_id===user.id))return json(403,{error:'دسترسی مجاز نیست.'});
   const admin=createClient(url,service,{auth:{persistSession:false,autoRefreshToken:false}});
   if(body.step==='start') {
    if(!actions.includes(body.action)||!phonePattern.test(body.phone)||
       (body.action==='create' ? body.target_id!==null : !uuid.test(body.target_id)))return json(400,{error:'اطلاعات حساب معتبر نیست.'});
    const id=crypto.randomUUID(),code=generateCode(crypto);
    const {data:ok,error}=await admin.rpc('service_student_login_challenge_start',{
      challenge_id:id,actor:user.id,session,verified_email:user.email,operation:body.action,
      target_phone:body.phone,target:body.target_id,digest:await digest(crypto,service,id,code),
    });
    if(error||!ok)return json(400,{error:'درخواست ثبت نشد؛ وضعیت حساب را بررسی کن یا کمی بعد تلاش کن.'});
    const labels={create:'ساخت حساب و اجازه ورود',password:'تغییر رمز',confirm:'تأیید دستی شماره',password_confirm:'تغییر رمز و تأیید دستی شماره'};
    const response=await fetch('https://api.resend.com/emails',{
     method:'POST',headers:{authorization:`Bearer ${emailKey}`,'content-type':'application/json'},
     body:JSON.stringify({from:'Nova Security <security@auth.nova-academy.ir>',to:[user.email],subject:'کد تأیید عملیات حساس نووا',
       text:`عملیات: ${labels[body.action]}\nشماره با چهار رقم پایانی: ${body.phone.slice(-4)}\nکد تأیید: ${code}\nاین کد فقط برای همین درخواست و به مدت پنج دقیقه معتبر است. اگر درخواست متعلق به شما نیست، آن را وارد نکنید.`})
    });
    if(!response.ok)return json(503,{error:'ارسال کد تأیید نشد؛ کمی بعد دوباره تلاش کن.'});
    return json(200,{ok:true,challenge_id:id});
   }
   if(body.step==='verify') {
    if(!uuid.test(body.challenge_id)||!/^\d{8}$/.test(body.code))return json(400,{error:'کد معتبر وارد کن.'});
    const {data:challenge,error}=await admin.rpc('service_student_login_challenge_consume',{
      challenge_id:body.challenge_id,actor:user.id,session,verified_email:user.email,
      digest:await digest(crypto,service,body.challenge_id,body.code),
    });
    if(error||!challenge)return json(400,{error:'کد نامعتبر یا منقضی است، یا وضعیت حساب تغییر کرده است.'});
    let success=false,createdUserId=null,attempted=false;
    try {
     const requiresPassword=['create','password','password_confirm'].includes(challenge.action);
     if(requiresPassword&&(typeof body.password!=='string'||body.password.length<8||body.password.length>128||/[^\x20-\x7e]/.test(body.password)))return json(400,{error:'رمز باید ۸ تا ۱۲۸ نویسه با صفحه‌کلید انگلیسی باشد؛ کد تازه درخواست کن.'});
     let result;
     attempted=true;
     if(challenge.action==='create') {
      result=await admin.auth.admin.createUser({phone:challenge.phone,phone_confirm:true,password:body.password,user_metadata:{}});
     } else {
      const attributes={};
      if(requiresPassword)attributes.password=body.password;
      if(challenge.action==='confirm'||challenge.action==='password_confirm')attributes.phone_confirm=true;
      result=await admin.auth.admin.updateUserById(challenge.target_id,attributes);
     }
     success=!result.error;
     if(challenge.action==='create' && success) {
      createdUserId=result.data?.user?.id;
      if(!createdUserId)throw new Error('Created user unavailable');
     }
     if(!success)return json(400,{error:'نتیجهٔ عملیات قطعی نیست؛ پیش از تلاش دوباره وضعیت حساب را بررسی کن.'});
     return json(200,{ok:true});
    } finally {
      const {error:finishError}=await admin.rpc('service_student_login_challenge_finish',{challenge_id:body.challenge_id,succeeded:success,created_user_id:createdUserId,attempted});
      if(finishError)throw new Error('Audit incomplete');
    }
   }
   return json(400,{error:'درخواست نامعتبر است.'});
  } catch { return json(503,{error:'ارتباط برقرار نشد؛ پیش از تلاش دوباره وضعیت حساب را بررسی کن.'}); }
 };
}
