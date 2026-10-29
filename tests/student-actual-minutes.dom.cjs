// Mocked student control, no real account or RPC calls.
const assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm'),ts=require('typescript');
const {JSDOM}=require('jsdom'),React=require('react'),{act}=React;
const dom=new JSDOM('<div id="root"></div>',{url:'https://nova.test/dashboard/student',pretendToBeVisual:true});
global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;global.IS_REACT_ACT_ENVIRONMENT=true;
const {createRoot}=require('react-dom/client');
const calls=[];
const stub={exports:{}};
vm.runInNewContext(ts.transpileModule(fs.readFileSync('components/dashboard/student-plan-checkbox.tsx','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,esModuleInterop:true}}).outputText,{
 module:stub,exports:stub.exports,require(name){
  if(name==='react')return React;
  if(name==='react/jsx-runtime')return require('react/jsx-runtime');
  if(name==='next/navigation')return {useRouter:()=>({refresh(){}})};
  if(name==='@/app/dashboard/actions')return {togglePlanItemCompletion:async(...args)=>{calls.push(args);return {ok:true};}};
  throw Error(`Unexpected import ${name}`);
 },
});
const {StudentPlanCheckbox}=stub.exports;
const root=createRoot(document.getElementById('root'));
const render=async (props={})=>act(async()=>root.render(React.createElement(StudentPlanCheckbox,{key:props.itemId??'fake-item',itemId:'fake-item',defaultChecked:false,canToggle:true,activityType:'lesson',targetTestCount:null,defaultCompletedTestCount:null,defaultCompletedMinutes:null,...props})));
const change=async(el,value)=>act(async()=>{Object.getOwnPropertyDescriptor(dom.window.HTMLInputElement.prototype,'value').set.call(el,value);el.dispatchEvent(new dom.window.Event('input',{bubbles:true}));});
const click=async el=>act(async()=>el.click());
(async()=>{
 await render();
 const checkbox=()=>document.querySelector('input[type=checkbox]'),number=()=>document.querySelector('input[type=number]');
 assert.match(document.body.textContent,/دقیقهٔ مطالعهٔ واقعی/);
 await click(checkbox());assert.equal(calls.length,0,'Minutes are required before checking');
 assert.match(document.querySelector('[role=alert]').textContent,/دقیقهٔ معتبر/);
 await change(number(),'45');await click(checkbox());
 assert.deepEqual(calls.at(-1),['fake-item',true,null,45]);
 await change(number(),'60');await act(async()=>number().dispatchEvent(new dom.window.FocusEvent('focusout',{bubbles:true})));
 assert.deepEqual(calls.at(-1),['fake-item',true,null,60]);
 await click(checkbox());assert.deepEqual(calls.at(-1),['fake-item',false,null,null]);
 await render({itemId:'test-item',activityType:'practice_tests',targetTestCount:40,defaultCompletedTestCount:null});
 assert.match(document.body.textContent,/تعداد تست زده شده/);
 await change(number(),'9');await click(checkbox());
 assert.deepEqual(calls.at(-1),['test-item',true,9,null]);
 await act(async()=>root.unmount());dom.window.close();
 console.log('Mocked study/test controls: valid minutes vs test count, edit and undo; no real writes.');
})().catch(e=>{console.error(e);process.exitCode=1;dom.window.close();});
