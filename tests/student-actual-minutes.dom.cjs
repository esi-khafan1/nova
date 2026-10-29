// Mocked student control, no real account or RPC calls.
const assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm'),ts=require('typescript');
const {JSDOM}=require('jsdom'),React=require('react'),{act}=React;
const dom=new JSDOM('<div id="root"></div>',{url:'https://nova.test/dashboard/student',pretendToBeVisual:true});
global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;global.IS_REACT_ACT_ENVIRONMENT=true;
const {createRoot}=require('react-dom/client');
const calls=[];
const durationStub={exports:{}};
vm.runInNewContext(ts.transpileModule(fs.readFileSync('lib/study-duration.ts','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS}}).outputText,{module:durationStub,exports:durationStub.exports});
const stub={exports:{}};
vm.runInNewContext(ts.transpileModule(fs.readFileSync('components/dashboard/student-plan-checkbox.tsx','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,esModuleInterop:true}}).outputText,{
 module:stub,exports:stub.exports,require(name){
  if(name==='react')return React;
  if(name==='react/jsx-runtime')return require('react/jsx-runtime');
  if(name==='next/navigation')return {useRouter:()=>({refresh(){}})};
  if(name==='@/lib/study-duration')return durationStub.exports;
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
 const checkbox=()=>document.querySelector('input[type=checkbox]'),number=()=>document.querySelector('.student-test-count input');
 assert.match(document.body.textContent,/مدت مطالعه \(ساعت:دقیقه\)/);
 assert.equal(number().type,'text');
 assert.equal(number().placeholder,'01:30');
 await click(checkbox());assert.equal(calls.length,0,'Minutes are required before checking');
 assert.match(document.querySelector('[role=alert]').textContent,/ساعت:دقیقه/);
 await change(number(),'1:30');await click(checkbox());
 assert.deepEqual(calls.at(-1),['fake-item',true,null,90]);
 assert.equal(number().value,'01:30','The saved value is displayed as HH:MM');
 await change(number(),'1:60');await act(async()=>number().dispatchEvent(new dom.window.FocusEvent('focusout',{bubbles:true})));
 assert.deepEqual(calls.at(-1),['fake-item',true,null,90],'Invalid edits do not overwrite saved minutes');
 assert.match(document.querySelector('[role=alert]').textContent,/ساعت:دقیقه/);
 await change(number(),'0:45');await act(async()=>number().dispatchEvent(new dom.window.FocusEvent('focusout',{bubbles:true})));
 assert.deepEqual(calls.at(-1),['fake-item',true,null,45]);
 assert.equal(number().value,'00:45');
 await click(checkbox());assert.deepEqual(calls.at(-1),['fake-item',false,null,null]);
 await render({itemId:'legacy-item',defaultChecked:true,defaultCompletedMinutes:null});
 assert.equal(number().value,'','A legacy tick must not claim a recorded duration');
 await render({itemId:'test-item',activityType:'practice_tests',targetTestCount:40,defaultCompletedTestCount:null});
 assert.equal(number().type,'number','Test count remains a number field');
 assert.match(document.body.textContent,/تعداد تست زده شده/);
 await change(number(),'9');await click(checkbox());
 assert.deepEqual(calls.at(-1),['test-item',true,9,null]);
 await act(async()=>root.unmount());dom.window.close();
 console.log('Mocked study/test controls: HH:MM, invalid edit, legacy tick, test count and undo; no real writes.');
})().catch(e=>{console.error(e);process.exitCode=1;dom.window.close();});
