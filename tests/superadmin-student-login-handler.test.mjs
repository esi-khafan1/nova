import assert from 'node:assert/strict';
import {webcrypto} from 'node:crypto';
import {makeHandler} from '../supabase/functions/superadmin-student-login/handler.mjs';
const actor='00000000-0000-4000-8000-000000000001',target='00000000-0000-4000-8000-000000000002',session='00000000-0000-4000-8000-000000000003';
const token=`x.${Buffer.from(JSON.stringify({session_id:session})).toString('base64url')}.x`;
let sent=null,challenge=null,mutations=[],isSuper=true,mailOk=true;
const createClient=(url,key)=>key==='anon'?{
 auth:{getUser:async()=>({data:{user:{id:actor,email:'admin@example.test',email_confirmed_at:'now'}},error:null})},
 rpc:async()=>({data:isSuper?[{user_id:actor}]:[],error:null}),
}:{auth:{admin:{createUser:async attrs=>{mutations.push(['create',attrs]);return {error:null,data:{user:{id:target}}}},updateUserById:async(id,attrs)=>{mutations.push(['update',id,attrs]);return {error:null}}}},
 rpc:async(name,args)=>{
  if(name==='service_student_login_challenge_start'){challenge={id:args.challenge_id,actor:args.actor,session:args.session,digest:args.digest,action:args.operation,phone:args.target_phone,target:args.target,used:false};return {data:true};}
  if(name==='service_student_login_challenge_consume'){
   if(!challenge||challenge.used||args.actor!==challenge.actor||args.session!==challenge.session||args.digest!==challenge.digest)return {data:null};
   challenge.used=true;return {data:{action:challenge.action,phone:challenge.phone,target_id:challenge.target}};
  }
  if(name==='service_student_login_challenge_finish')return {data:null};throw Error(name);
 }};
const env=name=>({SUPABASE_URL:'url',SUPABASE_ANON_KEY:'anon',SUPABASE_SERVICE_ROLE_KEY:'service-secret',NOVA_ADMIN_OTP_RESEND_API_KEY:'resend-secret'})[name];
const fetch=async(url,options)=>{assert.equal(url,'https://api.resend.com/emails');sent=JSON.parse(options.body);return {ok:mailOk};};
const handler=makeHandler({createClient,env,fetch,crypto:webcrypto});
const request=body=>new Request('https://example.test',{method:'POST',headers:{authorization:`Bearer ${token}`,'content-type':'application/json'},body:JSON.stringify(body)});
const body=async response=>response.json();
let res=await handler(request({step:'start',action:'password_confirm',phone:'989123456789',target_id:target}));assert.equal(res.status,200);
let start=await body(res);assert.equal(sent.to[0],'admin@example.test');assert.match(sent.from,/security@auth\.nova-academy\.ir/);
let code=sent.text.match(/کد تأیید: (\d{8})/)[1];assert.ok(!JSON.stringify(challenge).includes(code));
res=await handler(request({step:'verify',challenge_id:start.challenge_id,code:'99999999',password:'abcdefgh'}));assert.equal(res.status,400);assert.equal(mutations.length,0);
res=await handler(request({step:'verify',challenge_id:start.challenge_id,code,password:'English123'}));assert.equal(res.status,200);assert.deepEqual(mutations[0],['update',target,{password:'English123',phone_confirm:true}]);
res=await handler(request({step:'verify',challenge_id:start.challenge_id,code,password:'English123'}));assert.equal(res.status,400);assert.equal(mutations.length,1);
res=await handler(request({step:'start',action:'create',phone:'989123456780',target_id:null}));start=await body(res);code=sent.text.match(/کد تأیید: (\d{8})/)[1];
res=await handler(request({step:'verify',challenge_id:start.challenge_id,code,password:'English123'}));assert.equal(res.status,200);assert.deepEqual(mutations[1],['create',{phone:'989123456780',phone_confirm:true,password:'English123',user_metadata:{}}]);
isSuper=false;res=await handler(request({step:'start',action:'create',phone:'989123456780',target_id:null}));assert.equal(res.status,403);assert.equal(mutations.length,2);
isSuper=true;mailOk=false;res=await handler(request({step:'start',action:'create',phone:'989123456780',target_id:null}));assert.equal(res.status,503);assert.equal(mutations.length,2);
console.log('PASS: OTP email, no plaintext code persistence, super-admin checks, single-use code, create and reset with fake auth and mail');

// The Edge entrypoint must not load the optional JSR type declarations at runtime.
const {readFileSync} = await import('node:fs');
const entry = readFileSync(new URL('../supabase/functions/superadmin-student-login/index.ts', import.meta.url), 'utf8');
assert.doesNotMatch(entry, /(?:import|export)\s+["']jsr:/);
