import { Webhook } from "npm:standardwebhooks@1.0.0";
import { createHandler } from "./handler.mjs";
const env=(name:string)=>Deno.env.get(name);
Deno.serve(createHandler({
 env,
 verify:(raw:string,headers:Record<string,string>,secret:string)=>new Webhook(secret.replace(/^v1,whsec_/, "")).verify(raw,headers),
 claim:async(event:string)=>{
  const response=await fetch(`${env('SUPABASE_URL')}/rest/v1/rpc/claim_sms_test_attempt`,{
   method:'POST',headers:{apikey:env('SUPABASE_SERVICE_ROLE_KEY')!,Authorization:`Bearer ${env('SUPABASE_SERVICE_ROLE_KEY')}`,'Content-Type':'application/json'},
   body:JSON.stringify({event_id:event}),signal:AbortSignal.timeout(1000)
  });
  if(!response.ok)throw Error('Claim failed');
  return await response.json()===true;
 }
}));
