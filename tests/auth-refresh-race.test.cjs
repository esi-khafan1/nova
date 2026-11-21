// Models competing requests with the real middleware and SDK, fake cookies and fake Auth.
// It does not predict whether Supabase will actually return these responses concurrently.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const {NextRequest, NextResponse} = require('next/server');
const {createServerClient} = require('@supabase/ssr');
const encode = x => Buffer.from(JSON.stringify(x)).toString('base64url');
const id='12345678-1234-1234-1234-123456789abc', now=Math.floor(Date.now()/1000);
const user={id,aud:'authenticated',role:'authenticated'};
const jwt=exp=>`${encode({alg:'HS256',typ:'JWT'})}.${encode({sub:id,role:'authenticated',aud:'authenticated',exp})}.ZmFrZQ`;
const old={access_token:jwt(now-300),refresh_token:'old-fake',token_type:'bearer',expires_in:3600,expires_at:now-300,user:{...user,padding:'x'.repeat(5000)}};
const fresh={access_token:jwt(now+3600),refresh_token:'new-fake',token_type:'bearer',expires_in:3600,expires_at:now+3600,user};
let calls=0, release, wait;
const reset=()=>{calls=0;wait=new Promise(resolve=>{release=resolve});};
reset();
const fetchMock=async input=>{
 const url=new URL(String(input));
 if(url.pathname==='/auth/v1/token'){
   const call=++calls;
   if(call===1){await wait; return Response.json({code:'refresh_token_not_found',msg:'fake'}, {status:400,headers:{'x-supabase-api-version':'2024-01-01'}})}
   release(); return Response.json(fresh);
 }
 if(url.pathname==='/auth/v1/user')return Response.json(user);
 throw Error('Unexpected request '+url.pathname);
};
const code=ts.transpileModule(fs.readFileSync('middleware.ts','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS}}).outputText;
const stub={exports:{}};
vm.runInNewContext(code,{module:stub,exports:stub.exports,URL,performance,process:{env:{NEXT_PUBLIC_SUPABASE_URL:'https://test.supabase.co',NEXT_PUBLIC_SUPABASE_ANON_KEY:'fake'}},require(name){
 if(name==='next/server')return {NextRequest,NextResponse};
 if(name==='@supabase/ssr')return {createServerClient:(url,key,opts)=>createServerClient(url,key,{...opts,global:{fetch:fetchMock}})};
 throw Error(name);
}});
(async()=>{
 const value='base64-'+encode(old); const chunks=value.match(/.{1,3000}/g);
 const cookie=chunks.map((part,i)=>`sb-test-auth-token.${i}=${part}`).join('; ');
 const make=()=>new NextRequest('https://nova.example/dashboard/student',{headers:{cookie}});
 const responses=await Promise.all([stub.exports.middleware(make()),stub.exports.middleware(make())]);
 assert.equal(calls,2,'independent requests may each refresh');
 const failed=responses.find(r=>r.status===307), success=responses.find(r=>r.status===200);
 assert.ok(failed && success, 'one refresh succeeds and one fails');
 for(let i=0;i<chunks.length;i++) {
   assert.equal(failed.cookies.get(`sb-test-auth-token.${i}`).value,'', 'failure deletes each old chunk');
   assert.equal(failed.cookies.get(`sb-test-auth-token.${i}`).maxAge,0);
 }
 assert.ok(success.cookies.get('sb-test-auth-token').value,'success writes fresh unchunked cookie');
 for(let i=0;i<chunks.length;i++)assert.equal(success.cookies.get(`sb-test-auth-token.${i}`).maxAge,0,'success removes old chunks');
 // A late failed response deletes the old chunk names only, not the new unchunked cookie.
 // Whether this race loses a session depends on the cookie names and actual response order.
 assert.equal(failed.cookies.get('sb-test-auth-token'),undefined);
 // Model the same artificial success/failure race with a small, unchunked session.
 reset();
 const small={...old,user};
 const smallCookie=`sb-test-auth-token=base64-${encode(small)}`;
 const smallRequest=()=>new NextRequest('https://nova.example/dashboard/student',{headers:{cookie:smallCookie}});
 const smallResponses=await Promise.all([stub.exports.middleware(smallRequest()),stub.exports.middleware(smallRequest())]);
 const smallFailure=smallResponses.find(r=>r.status===307), smallSuccess=smallResponses.find(r=>r.status===200);
 assert.equal(calls,2); assert.ok(smallFailure && smallSuccess);
 assert.ok(smallSuccess.cookies.get('sb-test-auth-token').value);
 assert.equal(smallFailure.cookies.get('sb-test-auth-token').maxAge,0);
 console.log('PASS: simulated competing refreshes can overwrite a successful unchunked cookie if a failure response arrives later; chunked cleanup also verified');
})().catch(error=>{console.error(error);process.exitCode=1});
