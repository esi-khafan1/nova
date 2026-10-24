import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { normalizeMobile } from "@/lib/phone-auth";
import { isEnglishPasswordInput } from "@/lib/password-input";
import { isTrustedAuthOrigin } from "@/lib/auth-origin";
import { safeReturnPath } from "@/lib/return-path";
export const dynamic="force-dynamic";
const pendingCookie="nova_phone_pending";
const actions=["signup","verify","signin","link","verify-link","resend"];
export async function POST(request:NextRequest){
 const reply=(status:number,message:string)=>NextResponse.json({ok:status===200,message},{status,headers:{"Cache-Control":"no-store"}});
 try{
  if(!isTrustedAuthOrigin(request))return reply(403,"درخواست مجاز نیست.");
  if(!request.headers.get('content-type')?.startsWith('application/json'))return reply(415,"درخواست معتبر نیست.");
  const reader=request.body?.getReader();if(!reader)return reply(400,"درخواست معتبر نیست.");
  const parts:Uint8Array[]=[];let size=0;while(true){const part=await reader.read();if(part.done)break;size+=part.value.length;if(size>8192){await reader.cancel();return reply(413,"درخواست بیش از حد بزرگ است.");}parts.push(part.value);}
  const body=JSON.parse(Buffer.concat(parts).toString('utf8'));
  if(!body||typeof body!=='object'||!actions.includes(body.action))return reply(400,"درخواست معتبر نیست.");
  const email=body.action==='signin'&&typeof body.email==='string'?body.email.trim():null;
  const emailLogin=Boolean(email&&/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email));
  const phone=normalizeMobile(body.phone);if(!phone&&!emailLogin)return reply(400,"شماره تلفن همراه معتبر وارد کن.");
  if(body.action!=="signin"&&process.env.PHONE_SIGNUP_ENABLED!=="true")return reply(503,"ثبت‌نام و اتصال شماره فعلاً در دسترس نیست؛ کمی بعد تلاش کن.");
  const client=await createClient();
  if(body.action!=='signin'&&!phone)return reply(400,'شماره تلفن همراه معتبر وارد کن.');
  const link=body.action==='link'||body.action==='verify-link';
  let currentId:string|undefined;
  if(link){const {data:{user},error}=await client.auth.getUser();if(error||!user)return reply(401,"ابتدا وارد حساب خودت شو.");currentId=user.id;if(body.action==='link'&&user.phone_confirmed_at&&user.phone)return reply(409,'این حساب از قبل شمارهٔ تأییدشده دارد.');}
  const verifying=body.action==='verify'||body.action==='verify-link';
  if(body.action==='resend'){
   if(request.cookies.get(pendingCookie)?.value!==`signup:${phone}`)return reply(400,'ابتدا ثبت‌نام را شروع کن.');
   const {error}=await client.auth.resend({type:'sms',phone:phone!});
   return error?reply(400,'کد جدید ارسال نشد؛ کمی صبر کن.'):reply(200,'کد جدید ارسال شد.');
  }
  if(verifying){
   if(typeof body.token!=='string'||!/^\d{6}$/.test(body.token))return reply(400,"کد شش‌رقمی را وارد کن.");
   const pending=request.cookies.get(pendingCookie)?.value;
   // A challenge must first have been requested through this same-browser flow.
   if(pending!==`${link?'link:'+currentId:'signup'}:${phone}`)return reply(400,"ابتدا دریافت کد را بزن.");
   if(!link&&(typeof body.password!=='string'||body.password.length<8||body.password.length>128||!isEnglishPasswordInput(body.password)))return reply(400,'رمز انتخاب‌شده معتبر نیست.');
   const {data,error}=await client.auth.verifyOtp({phone:phone!,token:body.token,type:link?'phone_change':'sms'});
   if(error||!data.user?.phone_confirmed_at||normalizeMobile(data.user.phone)!==phone||(link&&data.user.id!==currentId))return reply(400,"کد صحیح نیست یا منقضی شده است.");
   const response=reply(200,link?"شماره به همین حساب متصل شد.":"شماره تأیید شد.");response.cookies.delete(pendingCookie);return response;
  }
  if(body.action==='signin'||body.action==='signup'){
   if(typeof body.password!=='string'||body.password.length<8||body.password.length>128||!isEnglishPasswordInput(body.password))return reply(400,"رمز عبور باید بین ۸ تا ۱۲۸ کاراکتر و با صفحه‌کلید انگلیسی باشد.");
  }
  if(body.action==='signin'){
   const {error}=await client.auth.signInWithPassword(emailLogin?{email:email!,password:body.password}:{phone:phone!,password:body.password});
   return error?reply(400,"اطلاعات ورود یا رمز عبور درست نیست."):reply(200,"وارد شدی.");
  }
  if(!phone)return reply(400,'شماره تلفن همراه معتبر وارد کن.');
  let error;
  if(link){({error}=await client.auth.updateUser({phone}));}
  else{
   if(typeof body.fullName!=='string'||body.fullName.trim().length<2||body.fullName.trim().length>100)return reply(400,"نام و نام خانوادگی را کامل وارد کن.");
   const result=await client.auth.signUp({phone,password:body.password,options:{channel:'sms',data:{full_name:body.fullName.trim(),course_return_to:safeReturnPath(body.next)}}});
   error=result.error;
   if(!error&&result.data.user?.identities?.length!==0){
    // Repeated signUp does not overwrite an unconfirmed account's password.
    // Confirm that this form's chosen password actually matches BEFORE allowing
    // confirmation; never silently activate an account with someone else's password.
    const proof=await client.auth.signInWithPassword({phone,password:body.password});
    if(proof.error?.code!=='phone_not_confirmed'){
     if(!proof.error)await client.auth.signOut({scope:'local'});
     return reply(409,'این شماره ثبت‌نام قبلی دارد؛ با رمز قبلی ادامه بده یا از پشتیبانی کمک بگیر.');
    }
   }
   if(!error&&result.data.user?.identities?.length===0)return reply(409,"این حساب قبلاً ساخته شده است؛ وارد شوید.");
  }
  if(error){
   if(error.code==='user_already_exists'||error.code==='phone_exists')return reply(409,link?"این شماره به حساب دیگری متصل است؛ شماره جابه‌جا یا حساب‌ها ادغام نمی‌شوند.":"این حساب قبلاً ساخته شده است؛ وارد شوید.");
   return reply(error.status===429?429:400,"ارسال کد انجام نشد؛ کمی صبر کن. اگر پیام رسیده، قبل از ارسال دوباره وضعیت را بررسی کن.");
  }
  const response=reply(200,"کد به شماره‌ات ارسال شد.");
  response.cookies.set(pendingCookie,`${link?'link:'+currentId:'signup'}:${phone}`,{httpOnly:true,sameSite:'strict',secure:process.env.NODE_ENV==='production',path:'/api/auth/phone',maxAge:600});
  return response;
 }catch{return reply(400,"ارتباط انجام نشد؛ بدون ارسال پیاپی دوباره تلاش کن.");}
}
