// Real Next route and Supabase SSR client, with a local synthetic upstream only.
// Run after npm run build. No production data or credentials are used.
const assert=require('node:assert/strict'),http=require('node:http'),net=require('node:net'),{spawn}=require('node:child_process');
const listen=server=>new Promise(resolve=>server.listen(0,'127.0.0.1',()=>resolve(server.address().port)));
(async()=>{
 const calls=[];
 const upstream=http.createServer((req,res)=>{calls.push({url:req.url,authorization:req.headers.authorization});res.setHeader('Content-Type','application/json');if(req.url==='/auth/v1/user'){if(req.headers.authorization!=='Bearer synthetic-user-token'){res.statusCode=401;res.end(JSON.stringify({message:'invalid'}));return;}res.end(JSON.stringify({id:'synthetic-counselor',aud:'authenticated',role:'authenticated'}));return;}if(req.url==='/rest/v1/rpc/planner_get_working_draft'){res.end(JSON.stringify({revision:'7',snapshot:{title:'private'}}));return;}res.statusCode=404;res.end('{}');});
 const upstreamPort=await listen(upstream);const reserve=net.createServer(),appPort=await listen(reserve);await new Promise(resolve=>reserve.close(resolve));
 const env={...process.env,NEXT_PUBLIC_SUPABASE_URL:`http://127.0.0.1:${upstreamPort}`,NEXT_PUBLIC_SUPABASE_ANON_KEY:'synthetic-public-key'};delete env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
 const app=spawn(process.execPath,['node_modules/next/dist/bin/next','start','-H','127.0.0.1','-p',String(appPort)],{env,stdio:['ignore','pipe','pipe']});
 let log='';app.stdout.on('data',d=>log+=d);app.stderr.on('data',d=>log+=d);
 try{
  await new Promise((resolve,reject)=>{const timer=setTimeout(()=>reject(Error(`Next startup timed out: ${log}`)),30000);const onData=()=>{if(/Ready in/.test(log)){clearTimeout(timer);resolve();}};app.stdout.on('data',onData);app.on('exit',code=>{clearTimeout(timer);reject(Error(`Next exited ${code}: ${log}`));});onData();});
  const origin=`http://127.0.0.1:${appPort}`;const session={access_token:'synthetic-user-token',refresh_token:'synthetic-refresh-token',token_type:'bearer',expires_at:Math.floor(Date.now()/1000)+3600,expires_in:3600,user:{id:'synthetic-counselor'}};
  const cookie='sb-127-auth-token=base64-'+Buffer.from(JSON.stringify(session)).toString('base64url');
  const send=(body,headers={})=>fetch(origin+'/api/planner',{method:'POST',headers:{origin,'content-type':'application/json',...headers},body:JSON.stringify(body)});
  const denied=await send({name:'planner_get_working_draft',args:{}});assert.equal(denied.status,401);
  const identity=await send({name:'current_user'},{cookie});assert.equal(identity.status,200);assert.equal((await identity.json()).data.id,'synthetic-counselor');
  const result=await send({name:'planner_get_working_draft',args:{target_student_id:'synthetic-student'}},{cookie});assert.equal(result.status,200);assert.equal((await result.json()).data.revision,'7');
  assert.ok(calls.some(c=>c.url==='/rest/v1/rpc/planner_get_working_draft'&&c.authorization==='Bearer synthetic-user-token'));
  const crossOrigin=await send({name:'planner_get_working_draft',args:{}},{cookie,origin:'https://evil.test'});assert.equal(crossOrigin.status,403);
  console.log('PASS: actual Next route verifies synthetic cookie and forwards the user session to the local Supabase mock');
 } finally {app.kill('SIGTERM');await new Promise(resolve=>upstream.close(resolve));}
})().catch(e=>{console.error(e);process.exitCode=1});
