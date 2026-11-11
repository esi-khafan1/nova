const assert=require('node:assert/strict');
const {createServerClient}=require('@supabase/ssr');
(async()=>{
 const id='12345678-1234-1234-1234-123456789abc';
 const encode=v=>Buffer.from(JSON.stringify(v)).toString('base64url');
 const token=`${encode({alg:'HS256',typ:'JWT'})}.${encode({sub:id,role:'authenticated',aud:'authenticated',exp:Math.floor(Date.now()/1000)+3600})}.test-signature`;
 const user={id,aud:'authenticated',role:'authenticated'};
 const session={access_token:token,refresh_token:'fake-refresh',token_type:'bearer',expires_in:3600,expires_at:Math.floor(Date.now()/1000)+3600,user};
 const requests=[];let release;const barrier=new Promise(r=>release=r);let timer;
 const s=createServerClient('https://fixture.supabase.co','fake-key',{cookies:{getAll:()=>[{name:'sb-fixture-auth-token',value:'base64-'+encode(session)}],setAll:()=>{}},global:{fetch:async(input,init)=>{
  const url=new URL(String(input));requests.push(url.pathname);
  assert.ok(new Headers(init.headers).get('authorization')?.includes(token));
  if(requests.length===5)release();await barrier;
  const data=url.pathname==='/auth/v1/user'?user:url.pathname.endsWith('counselor_plan_editor_page')?{counselor_id:id,plans:[],has_more:false}:[];
  return new Response(JSON.stringify(data),{status:200,headers:{'content-type':'application/json'}});
 }}});
 try{
  const result=await Promise.race([Promise.all([s.auth.getUser(),s.rpc('counselor_student_directory'),s.rpc('counselor_completed_plan_item_ids'),s.rpc('counselor_plan_editor_page',{page_offset:0,previous_history:false}),s.rpc('counselor_plan_editor_page',{page_offset:0,previous_history:true})]),new Promise((_,reject)=>{timer=setTimeout(()=>reject(Error('requests did not start concurrently')),2000)})]);
  assert.equal(result[0].data.user.id,id);assert.ok(result.every(r=>!r.error));assert.equal(requests.length,5);
 }finally{clearTimeout(timer)}
 console.log('PASS: actual Supabase SDK overlaps fresh Auth and four RLS-scoped reads using mock transport');
})().catch(e=>{console.error(e);process.exitCode=1});
