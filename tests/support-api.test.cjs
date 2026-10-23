const assert=require('node:assert/strict'),fs=require('fs'),vm=require('vm'),ts=require('typescript');
const {NextRequest,NextResponse}=require('next/server');let user=null,role='student',profileId='own',fail=false,calls=[];
const client={rpc(name,args){calls.push({name,args,guest:false});if(name==='own_dashboard_profile')return {maybeSingle:async()=>({data:{id:profileId,role}})};return Promise.resolve({data:name==='support_inbox'?[]:name==='support_inbox_topic'?'opaque-inbox':{messages:[]},error:null});}};
const m={exports:{}};vm.runInNewContext(ts.transpileModule(fs.readFileSync('app/api/support/route.ts','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText,{module:m,exports:m.exports,process:{env:{NODE_ENV:'production',NEXT_PUBLIC_SUPABASE_URL:'https://example.com',NEXT_PUBLIC_SUPABASE_ANON_KEY:'test'}},Buffer,URL,require(name){if(name==='node:crypto')return require(name);if(name==='next/server')return {NextRequest,NextResponse};if(name==='@/lib/supabase/server')return {createClient:async()=>client};if(name==='@/lib/supabase/request-auth')return {getRequestUser:async()=>({user})};if(name==='@supabase/supabase-js')return {createClient:()=>({rpc:async(name,args)=>{calls.push({name,args,guest:true});return {data:{messages:[]},error:fail?{code:'42501'}:null};}})};throw Error(name);}});
function request(path='',body,origin='https://nova-academy.ir'){return new NextRequest('https://nova-academy.ir/api/support'+path,{method:body===undefined?'GET':'POST',headers:{host:'nova-academy.ir',origin,'content-type':'application/json'},...(body===undefined?{}:{body:JSON.stringify(body)})});}
(async()=>{
 let res=await m.exports.GET(request());assert.equal(res.status,200);const cookie=res.cookies.get('nova_support_session');assert.match(cookie.value,/^[a-f0-9]{64}$/);assert.match(res.headers.get('set-cookie'),/HttpOnly/);assert.match(res.headers.get('Cache-Control'),/no-store/);assert.equal(calls.at(-1).guest,true);assert.ok(!JSON.stringify(await res.json()).includes(cookie.value));
 assert.equal((await m.exports.POST(request('',{message:'hello'},'https://evil.example'))).status,403);
 assert.equal((await m.exports.POST(request('',{message:'x'.repeat(2001)}))).status,400);
 assert.equal((await m.exports.GET(request('?staff=1'))).status,401);
 user={id:'own'};assert.equal((await m.exports.GET(request('?staff=1'))).status,403);
 role='support_agent';profileId='other';assert.equal((await m.exports.GET(request('?staff=1'))).status,403);
 profileId='own';res=await m.exports.GET(request('?staff=1'));assert.equal(res.status,200);assert.deepEqual(await res.json(),{threads:[],realtime_topic:'opaque-inbox'});
 user=null;fail=true;res=await m.exports.GET(request());assert.equal((await res.json()).reset,true);assert.match(res.headers.get('set-cookie'),/Expires=Thu, 01 Jan 1970/);
 console.log('Support API: guest capability cookie not leaked, no-store responses, fresh staff identity/role, CSRF and length guards, anonymous isolation and session reset passed.');
})().catch(e=>{console.error(e);process.exitCode=1;});
