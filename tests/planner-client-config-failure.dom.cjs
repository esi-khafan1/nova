// A failed open remains fail-closed and can be retried without writing a draft.
const assert=require('node:assert/strict'),esbuild=require('esbuild'),Module=require('node:module'),path=require('node:path'),{JSDOM}=require('jsdom'),React=require('react'),{act}=React;
const dom=new JSDOM('<div id="root"></div>',{url:'https://nova.test/',pretendToBeVisual:true});
global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;global.IS_REACT_ACT_ENVIRONMENT=true;
const {createRoot}=require('react-dom/client');
(async()=>{
 const result=await esbuild.build({entryPoints:['components/dashboard/use-planner-working-copy.ts'],bundle:true,platform:'node',format:'cjs',jsx:'automatic',write:false,external:['react','react/jsx-runtime'],plugins:[{name:'mock-config',setup(b){b.onResolve({filter:/^@\/lib\/supabase\/client$/},()=>({path:'client',namespace:'mock'}));b.onLoad({filter:/.*/,namespace:'mock'},()=>({contents:'export function createClient(){return globalThis.mockPlannerClient()}',loader:'js'}));}}]});
 const filename=path.join(process.cwd(),'virtual-working-copy.cjs'),m=new Module(filename,module);m.filename=filename;m.paths=Module._nodeModulePaths(process.cwd());m._compile(result.outputFiles[0].text,filename);
 const context={studentId:'student',weekStart:'2030-01-01',planId:null};let state, writes=0;
 global.mockPlannerClient=()=>{throw Error('missing Supabase config')};
 function Test(){state=m.exports.usePlannerWorkingCopy({enabled:true,context,counselorId:'counselor',planStatus:null,value:{title:'',notes:'',items:[],routines:[],weekExtra:{}},onRestore(){},onPublished(){}});return React.createElement('div',null,`${state.phase}:${state.warning}`)}
 const root=createRoot(document.getElementById('root'));await act(async()=>root.render(React.createElement(Test)));
 assert.match(document.body.textContent,/error:دریافت اطلاعات یا پیش‌نویس انجام نشد/);
 assert.match(state.warning,/تنظیمات اتصال مرورگر/);
 global.mockPlannerClient=()=>({auth:{getUser:async()=>({data:{user:{id:'counselor'}},error:null})},rpc:async(name)=>{
  if(name==='counselor_plan_editor_page')return {data:{counselor_id:'counselor',plans:[],has_more:false},error:null};
  if(name==='counselor_completed_plan_item_ids')return {data:[],error:null};
  if(name==='planner_get_working_draft')return {data:null,error:null};
  writes++;throw Error('unexpected write');
 }});
 await act(async()=>{state.retryOpen()});
 assert.equal(state.phase,'ready');assert.equal(writes,0);assert.equal(state.warning,'');
 await act(async()=>root.unmount());
 // A hanging read must time out; its late response must not replace the retry.
 const realTimeout=global.setTimeout;global.setTimeout=(fn,ms,...args)=>realTimeout(fn,ms===15000?5:ms,...args);
 let resolveOld;const goodClient=global.mockPlannerClient;
 global.mockPlannerClient=()=>{const client=goodClient();return {...client,auth:{getUser:()=>new Promise(resolve=>{resolveOld=resolve;})}};};
 const second=createRoot(document.getElementById('root'));
 await act(async()=>second.render(React.createElement(Test)));
 await act(async()=>{await new Promise(resolve=>realTimeout(resolve,20));});
 assert.equal(state.phase,'error');assert.match(state.warning,/اطلاعات به‌روز/);
 global.mockPlannerClient=goodClient;
 await act(async()=>{state.retryOpen()});assert.equal(state.phase,'ready');
 await act(async()=>{resolveOld({data:{user:{id:'counselor'}},error:null});});
 assert.equal(state.phase,'ready');assert.equal(writes,0);
 await act(async()=>second.unmount());global.setTimeout=realTimeout;dom.window.close();delete global.mockPlannerClient;console.log('PASS: failed and stalled opens stay safe; retry ignores late responses');
})().catch(error=>{console.error(error);process.exitCode=1;dom.window.close()});
