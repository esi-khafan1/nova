// Real manager component with a mocked RPC; no production calls.
const assert=require('node:assert/strict'),esbuild=require('esbuild'),Module=require('node:module'),path=require('node:path'),{JSDOM}=require('jsdom'),React=require('react'),{act}=React;
const dom=new JSDOM('<div id="root"></div>',{url:'https://nova.test/',pretendToBeVisual:true});
global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;global.IS_REACT_ACT_ENVIRONMENT=true;
const {createRoot}=require('react-dom/client');
(async()=>{
 const result=await esbuild.build({entryPoints:['components/dashboard/planner-topic-bank-manager.tsx'],bundle:true,platform:'node',format:'cjs',jsx:'automatic',write:false,outdir:'virtual-restore-ui',external:['react','react/jsx-runtime'],plugins:[{name:'mock-client',setup(b){b.onResolve({filter:/^@\/lib\/supabase\/client$/},()=>({path:'client',namespace:'mock'}));b.onLoad({filter:/.*/,namespace:'mock'},()=>({contents:'export function createClient(){return {rpc:globalThis.__restoreRpc}}',loader:'js'}));}}]});
 const filename=path.join(process.cwd(),'virtual-restore-ui.cjs'),m=new Module(filename,module);m.filename=filename;m.paths=Module._nodeModulePaths(process.cwd());m._compile(result.outputFiles.find(f=>f.path.endsWith('.js')).text,filename);
 const calls=[];let fail=false,failList=false;const bank=[{id:'hidden',revision:'3',title:'ویرایش مدیر',pageStart:15,pageEnd:17,order:3,hiddenFromSelection:true},{id:'visible',revision:'1',title:'مبحث موجود',pageStart:20,pageEnd:21,order:4,hiddenFromSelection:false}];
 global.__restoreRpc=async(name,args)=>{calls.push([name,args]);if(name==='planner_list_topics')return failList?{data:null,error:{code:'network'}}:{data:structuredClone(bank),error:null};if(name==='planner_restore_hidden_topic'){if(fail)return {error:{code:'40001'}};assert.equal(args.target_id,'hidden');assert.equal(args.expected_revision,'3');bank[0].hiddenFromSelection=false;bank[0].revision='4';return {data:{id:'hidden',revision:'4'},error:null}}throw Error(name)};
 const root=createRoot(document.getElementById('root'));await act(async()=>root.render(React.createElement(m.exports.PlannerTopicBankManager)));
 async function choose(index,value){await act(async()=>{const el=document.querySelectorAll('select')[index];el.value=value;el.dispatchEvent(new dom.window.Event('change',{bubbles:true}));});}
 await choose(3,'شیمی ۳');let chapter=document.querySelectorAll('select')[4];await choose(4,chapter.options[1].value);
 const buttons=()=>[...document.querySelectorAll('button')],get=name=>buttons().find(b=>b.textContent===name),click=async b=>act(async()=>b.click());
 assert.match(document.body.textContent,/ویرایش مدیر.*پنهان از انتخابگر/);assert.equal(buttons().filter(b=>b.textContent==='نمایش دوباره').length,1);
 await click(get('ویرایش'));assert.equal(get('نمایش دوباره').disabled,true,'do not invalidate an unsaved edit');await click(get('انصراف'));assert.equal(get('نمایش دوباره').disabled,false);
 fail=true;await click(get('نمایش دوباره'));assert.match(document.querySelector('[role=alert]').textContent,/ممکن است مبحث تغییر کرده باشد/);assert.equal(bank[0].hiddenFromSelection,true);
 fail=false;await click(get('نمایش دوباره'));assert.match(document.querySelector('[role=status]').textContent,/دوباره در انتخابگر نمایش داده می‌شود/);assert.equal(get('نمایش دوباره'),undefined);assert.equal(bank[0].title,'ویرایش مدیر');assert.deepEqual([bank[0].pageStart,bank[0].pageEnd],[15,17]);assert.equal(calls.filter(c=>c[0]==='planner_restore_hidden_topic').length,2);
 // A failed refresh after a successful write must not claim that the list was reloaded.
 bank[0].hiddenFromSelection=true;bank[0].revision='3';await click(get('تازه‌سازی'));failList=true;await click(get('نمایش دوباره'));assert.match(document.querySelector('[role=alert]').textContent,/دریافت بانک مباحث انجام نشد/);assert.equal(document.querySelector('[role=status]'),null);assert.equal(bank[0].hiddenFromSelection,false);
 await act(async()=>root.unmount());dom.window.close();console.log('PASS: hidden label, restore button, stale failure, pending edits and reload in manager UI');
})().catch(e=>{console.error(e);process.exitCode=1;dom.window.close()});
