// Actual Supabase SSR/client transport, fake local session and mocked fetch only.
const assert=require('node:assert/strict');
const {createServerClient}=require('@supabase/ssr');
(async()=>{
 const id='12345678-1234-1234-1234-123456789abc';
 const encode=v=>Buffer.from(JSON.stringify(v)).toString('base64url');
 const token=`${encode({alg:'HS256',typ:'JWT'})}.${encode({sub:id,role:'authenticated',aud:'authenticated',exp:Math.floor(Date.now()/1000)+3600})}.test-signature`;
 const user={id,aud:'authenticated',role:'authenticated',email_confirmed_at:'2026-01-01T00:00:00Z'};
 const profile={id,full_name:'Fixture',role:'admin',registration_status:'active'};
 const session={access_token:token,refresh_token:'local-test-refresh',token_type:'bearer',expires_in:3600,expires_at:Math.floor(Date.now()/1000)+3600,user};
 let release;const both=new Promise(resolve=>{release=resolve;});const calls=[];
 const supabase=createServerClient('https://test.supabase.co','test-anon-key',{
  cookies:{getAll:()=>[{name:'sb-test-auth-token',value:'base64-'+encode(session)}],setAll:()=>{}},
  global:{fetch:async(input,init)=>{
   const path=new URL(String(input)).pathname;calls.push(path);
   assert.ok(['/auth/v1/user','/rest/v1/rpc/own_dashboard_profile'].includes(path),'Unexpected request: '+path);
   if(calls.length===2)release();
   await both;
   return new Response(JSON.stringify(path==='/auth/v1/user'?user:[profile]),{status:200,headers:{'Content-Type':'application/json'}});
  }},
 });
 let timer;
 try{
  const [auth,own]=await Promise.race([
   Promise.all([supabase.auth.getUser(),supabase.rpc('own_dashboard_profile').maybeSingle()]),
   new Promise((_,reject)=>{timer=setTimeout(()=>reject(Error('Actual Supabase SDK serialized auth/profile transport')),2000);}),
  ]);
  assert.equal(auth.error,null);assert.equal(own.error,null);assert.equal(auth.data.user.id,id);assert.equal(own.data.id,id);assert.equal(calls.length,2);
 }finally{clearTimeout(timer);}
 console.log('Actual Supabase SDK sends getUser and own-profile RPC concurrently; no extra refresh request.');
})().catch(e=>{console.error(e);process.exitCode=1;});
