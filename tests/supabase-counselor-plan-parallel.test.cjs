const assert=require('node:assert/strict');
const {createServerClient}=require('@supabase/ssr');
(async()=>{
 const id='12345678-1234-1234-1234-123456789abc',plan='22222222-2222-4222-8222-222222222222';
 const encode=v=>Buffer.from(JSON.stringify(v)).toString('base64url');
 const token=`${encode({alg:'HS256',typ:'JWT'})}.${encode({sub:id,role:'authenticated',aud:'authenticated',exp:Math.floor(Date.now()/1000)+3600})}.test-signature`;
 const user={id,aud:'authenticated',role:'authenticated'};
 const session={access_token:token,refresh_token:'mock-refresh',token_type:'bearer',expires_in:3600,expires_at:Math.floor(Date.now()/1000)+3600,user};
 const paths=[];let release;const barrier=new Promise(resolve=>{release=resolve});let timer;
 const s=createServerClient('https://fixture.supabase.co','fake-key',{cookies:{getAll:()=>[{name:'sb-fixture-auth-token',value:'base64-'+encode(session)}],setAll:()=>{}},global:{fetch:async(input,init)=>{
  const url=new URL(String(input));paths.push(url.pathname);assert.ok(new Headers(init.headers).get('authorization')?.includes(token));
  if(paths.length===3)release();await barrier;
  let body;if(url.pathname==='/auth/v1/user')body=user;else if(url.pathname==='/rest/v1/rpc/counselor_student_directory')body=[];else if(url.pathname==='/rest/v1/weekly_plans'){assert.equal(url.searchParams.get('id'),`eq.${plan}`);body=[{counselor_id:id,routines:[]}]}else throw Error('unexpected request '+url.pathname);
  return new Response(JSON.stringify(body),{status:200,headers:{'content-type':'application/json'}});
 }}});
 try{
  const [auth,directory,prior]=await Promise.race([Promise.all([s.auth.getUser(),s.rpc('counselor_student_directory'),s.from('weekly_plans').select('counselor_id,routines').eq('id',plan).maybeSingle()]),new Promise((_,reject)=>{timer=setTimeout(()=>reject(Error('SDK requests were not concurrent')),2000)})]);
  assert.equal(auth.data.user.id,id);assert.equal(directory.error,null);assert.equal(prior.data.counselor_id,id);assert.equal(paths.length,3);
 }finally{clearTimeout(timer)}
 console.log('PASS: actual Supabase SDK starts fresh-auth, directory and RLS plan read concurrently using a fake session/transport.');
})().catch(e=>{console.error(e);process.exitCode=1});
