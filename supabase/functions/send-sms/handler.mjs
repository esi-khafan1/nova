// No OTPs, phone numbers, credentials or provider response bodies are logged.
export function normalizePhone(value) {
 const n=String(value??'').replace(/^\+/, '');
 return /^989\d{9}$/.test(n)?n:/^09\d{9}$/.test(n)?`98${n.slice(1)}`:null;
}
export function createHandler({env,verify,claim,report=async()=>{},fetcher=fetch,waitUntil=globalThis.EdgeRuntime?.waitUntil?.bind(globalThis.EdgeRuntime),ackWindowMs=1800}) {
 return async request=>{
  const reply=(status,message)=>Response.json(status===200?{}:{error:{http_code:status,message}},{status});
  if(request.method!=='POST')return reply(405,'POST required');
  const publicMode=env('SMS_SIGNUP_ENABLED')==='true';
  if(!publicMode&&env('SMS_TEST_ENABLED')!=='true')return reply(503,'SMS test is disabled');
  const secret=env('SEND_SMS_HOOK_SECRET'),username=env('MELIPAYAMAK_USERNAME'),key=env('MELIPAYAMAK_API_KEY');
  const allowed=normalizePhone(env('SMS_TEST_PHONE'));
  if(!secret||!username||!key||(!allowed&&!publicMode))return reply(503,'SMS configuration missing');
  let body;
  try {
   const reader=request.body?.getReader();if(!reader)return reply(400,'Missing body');
   const chunks=[];let length=0;
   while(true){const r=await reader.read();if(r.done)break;length+=r.value.length;if(length>16384){await reader.cancel();return reply(413,'Body too large');}chunks.push(r.value);}
   const raw=new TextDecoder().decode(await new Blob(chunks).arrayBuffer());
   body=await verify(raw,Object.fromEntries(request.headers),secret);
  }catch{return reply(401,'Invalid hook signature or payload');}
  const recipient=normalizePhone(body?.sms?.phone||body?.user?.phone_change||body?.user?.phone);
  if(!recipient||(!publicMode&&recipient!==allowed))return reply(403,'Only the configured test number is permitted');
  if(!/^\d{6}$/.test(body?.sms?.otp??''))return reply(400,'Invalid OTP');
  const event=request.headers.get('webhook-id');
  if(!event||event.length>200)return reply(400,'Invalid event ID');
  // Durable claim BEFORE network send: ambiguous timeouts must never auto-resend.
  try{if(!await claim(event,recipient))return reply(429,'Duplicate event or test budget exhausted');}
  catch{return reply(503,'Unable to reserve SMS attempt');}
  const started=Date.now();
  const finish=async(outcome,code=null)=>{try{await report(event,outcome,code,Math.min(Date.now()-started,60000));}catch{console.warn('sms_test: diagnostic write failed');}};
  const deliver=async()=>{
   try{
    const result=await fetcher('https://rest.payamak-panel.com/api/SendSMS/BaseServiceNumber',{
     method:'POST',redirect:'error',headers:{'Content-Type':'application/x-www-form-urlencoded'},
     body:new URLSearchParams({username,password:key,text:body.sms.otp,to:`0${recipient.slice(2)}`,bodyId:'566954'}),
     signal:AbortSignal.timeout(8000)
    });
    if(!result.ok){await finish('http_error',result.status);return reply(502,'SMS provider HTTP error; inspect delivery before retrying');}
    // Preserve long recIds as text: JSON number parsing can lose precision.
    const raw=await result.text();
    const match=raw.match(/"Value"\s*:\s*"?(\d{16,})"?\s*[,}]/);
    if(!match){
     const codeMatch=raw.match(/"Value"\s*:\s*"?(-?\d{1,3})"?\s*[,}]/);
     const code=codeMatch?Number(codeMatch[1]):null;
     await finish(code===null?'unrecognized_response':'provider_rejected',code);
     return reply(502,'SMS provider did not confirm acceptance; inspect test diagnostics');
    }
    await finish('accepted');return reply(200);
   }catch(error){
    await finish(error?.name==='TimeoutError'||error?.name==='AbortError'?'timeout':'network_error');
    return reply(502,'SMS delivery unknown; inspect panel before retrying');
   }
  };
  // GoTrue must receive a timely hook response for an unconfirmed signup to
  // exist. The provider has been delivering SMS after our old 2.5s timeout.
  // Keep the single claimed request alive in the Edge runtime; a slow provider
  // response must not roll back an OTP that actually reaches the phone.
  if(!publicMode||typeof waitUntil!=='function')return await deliver();
  const delivery=deliver();
  let timer;
  const pending=new Promise(resolve=>{timer=setTimeout(()=>resolve(null),ackWindowMs);});
  const decision=await Promise.race([delivery,pending]);
  clearTimeout(timer);
  if(decision!==null)return decision;
  try{waitUntil(delivery);}catch{return await delivery;}
  return reply(200);
 };
}
