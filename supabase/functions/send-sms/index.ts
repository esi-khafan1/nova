import { Webhook } from "npm:standardwebhooks@1.0.0";
import { createHandler } from "./handler.mjs";
const env=(name:string)=>Deno.env.get(name);
Deno.serve(createHandler({
 env,
 report:async(event_id:string,outcome:string,provider_code:number|null,elapsed_ms:number)=>{
  const response=await fetch(`${env('SUPABASE_URL')}/rest/v1/rpc/record_sms_test_outcome`,{
   method:'POST',headers:{apikey:env('SUPABASE_SERVICE_ROLE_KEY')!,Authorization:`Bearer ${env('SUPABASE_SERVICE_ROLE_KEY')}`,'Content-Type':'application/json'},
   body:JSON.stringify({event_id,outcome,provider_code,elapsed_ms}),signal:AbortSignal.timeout(500)
  });
  if(!response.ok)throw Error('Diagnostic failed');
 },
 verify:(raw:string,headers:Record<string,string>,secret:string)=>new Webhook(secret.replace(/^v1,whsec_/, "")).verify(raw,headers),
 claim:async(event:string,phone:string)=>{
  const publicMode=env('SMS_SIGNUP_ENABLED')==='true';
  let phoneKey='';
  if(publicMode){
   const key=await crypto.subtle.importKey('raw',new TextEncoder().encode(env('SEND_SMS_HOOK_SECRET')!),{name:'HMAC',hash:'SHA-256'},false,['sign']);
   phoneKey=Array.from(new Uint8Array(await crypto.subtle.sign('HMAC',key,new TextEncoder().encode(phone)))).map(n=>n.toString(16).padStart(2,'0')).join('');
  }
  const response=await fetch(`${env('SUPABASE_URL')}/rest/v1/rpc/${publicMode?'claim_sms_signup_attempt':'claim_sms_test_attempt'}`,{
   method:'POST',headers:{apikey:env('SUPABASE_SERVICE_ROLE_KEY')!,Authorization:`Bearer ${env('SUPABASE_SERVICE_ROLE_KEY')}`,'Content-Type':'application/json'},
   body:JSON.stringify(publicMode?{event_id:event,phone_key:phoneKey}:{event_id:event}),signal:AbortSignal.timeout(1000)
  });
  if(!response.ok)throw Error('Claim failed');
  return await response.json()===true;
 }
}));
