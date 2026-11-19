// Exercise the actual same-origin adapter and route without production accounts.
const assert=require('node:assert/strict'),esbuild=require('esbuild'),Module=require('node:module'),path=require('node:path');
(async()=>{
 const build=async(entry,plugins=[])=>{const result=await esbuild.build({entryPoints:[entry],bundle:true,platform:'node',format:'cjs',write:false,plugins});const filename=path.join(process.cwd(),`virtual-${path.basename(entry)}.cjs`),m=new Module(filename,module);m.filename=filename;m.paths=Module._nodeModulePaths(process.cwd());m._compile(result.outputFiles[0].text,filename);return m.exports;};
 const route=await build('app/api/planner/route.ts',[{name:'server-mock',setup(b){b.onResolve({filter:/^@\/lib\/supabase\/server$/},()=>({path:'server',namespace:'mock'}));b.onLoad({filter:/.*/,namespace:'mock'},()=>({loader:'js',contents:'export async function createClient(){return globalThis.mockServerClient()}'}));}}]);
 const {createPlannerClient}=await build('lib/planner-api-client.ts');
 let user='counselor-one',calls=[];
 global.mockServerClient=()=>({auth:{getUser:async()=>({data:{user:user?{id:user}:null},error:null})},rpc:async(name,args)=>{calls.push({user,name,args});if(name==='planner_save_working_draft_checked'&&args.expected_revision==='stale')return {data:null,error:{code:'40001',message:'private details'}};return {data:{owner:user,name,args},error:null};}});
 const request=(body,options={})=>new Request('https://nova.test/api/planner',{method:'POST',headers:{host:'nova.test',origin:'https://nova.test','content-type':'application/json',...(options.headers||{})},body:typeof body==='string'?body:JSON.stringify(body)});
 let res=await route.POST(request({name:'planner_get_working_draft',args:{target_student_id:'one'}}));assert.equal(res.status,200);assert.equal((await res.json()).data.owner,'counselor-one');assert.equal(res.headers.get('cache-control'),'no-store');
 user='counselor-two';res=await route.POST(request({name:'planner_get_working_draft',args:{target_student_id:'two'}}));assert.equal((await res.json()).data.owner,'counselor-two');
 user=null;res=await route.POST(request({name:'planner_publish_working_draft',args:{}}));assert.equal(res.status,401);assert.equal(calls.length,2);
 user='counselor-one';res=await route.POST(request({name:'planner_get_working_draft',args:{}},{headers:{origin:'https://evil.test'}}));assert.equal(res.status,403);
 res=await route.POST(request({name:'planner_get_working_draft',args:{}},{headers:{'sec-fetch-site':'cross-site'}}));assert.equal(res.status,403);
 // Reverse proxies can terminate TLS and leave an internal HTTP request URL.
 res=await route.POST(new Request('http://localhost/api/planner',{method:'POST',headers:{host:'nova.test',origin:'https://nova.test','x-forwarded-proto':'https','content-type':'application/json'},body:JSON.stringify({name:'current_user'})}));assert.equal(res.status,200);
 res=await route.POST(request({name:'planner_get_working_draft',args:{}},{headers:{'content-type':'text/plain'}}));assert.equal(res.status,415);
 res=await route.POST(request({name:'some_arbitrary_function',args:{}}));assert.equal(res.status,400);
 res=await route.POST(request({name:'planner_get_working_draft',args:[]}));assert.equal(res.status,400);
 res=await route.POST(request('{'));assert.equal(res.status,400);
 res=await route.POST(request(' '.repeat(6*1024*1024+1)));assert.equal(res.status,400);assert.equal(calls.length,2);
 const oldFetch=global.fetch;global.fetch=async(url,options)=>{assert.equal(url,'/api/planner');assert.equal(options.credentials,'same-origin');return route.POST(new Request('https://nova.test/api/planner',{method:'POST',headers:{...options.headers,host:'nova.test',origin:'https://nova.test'},body:options.body}));};
 try {
  const client=createPlannerClient();const auth=await client.auth.getUser();assert.equal(auth.data.user.id,'counselor-one');
  const draft=await client.rpc('planner_get_working_draft',{target_student_id:'one'});assert.equal(draft.data.owner,'counselor-one');
  const stale=await client.rpc('planner_save_working_draft_checked',{expected_revision:'stale'});assert.equal(stale.error.code,'40001');assert.doesNotMatch(stale.error.message,/private/);
  user=null;const denied=await client.rpc('planner_publish_working_draft',{});assert.ok(denied.error);assert.equal(denied.data,null);
  global.fetch=async()=>{throw Error('network down')};const failed=await client.auth.getUser();assert.ok(failed.error);assert.equal(failed.data.user,null);
 } finally {global.fetch=oldFetch;delete global.mockServerClient;}
 console.log('PASS: same-origin planner API, per-request auth, RPC allowlist, CSRF, isolation and failure handling');
})().catch(e=>{console.error(e);process.exitCode=1});
