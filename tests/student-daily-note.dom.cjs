const assert=require('node:assert/strict');
const fs=require('node:fs');const vm=require('node:vm');const ts=require('typescript');
const {JSDOM}=require('jsdom');const React=require('react');const {act}=React;
const dom=new JSDOM('<div id="root"></div>',{url:'https://nova.test/dashboard/student'});
global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;
global.IS_REACT_ACT_ENVIRONMENT=true;
const {createRoot}=require('react-dom/client');
const calls=[],saved=[];let fail=false;
const mod={exports:{}};
vm.runInNewContext(ts.transpileModule(fs.readFileSync('components/dashboard/student-daily-note.tsx','utf8'),{
 compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,esModuleInterop:true}
}).outputText,{module:mod,exports:mod.exports,require(name){
 if(name==='react')return React;if(name==='react/jsx-runtime')return require('react/jsx-runtime');
 if(name==='@/app/dashboard/actions')return {saveStudentDailyNote:async(day,note)=>{calls.push([day,note]);return {ok:!fail};}};
 throw Error(name);
}});
const root=createRoot(document.querySelector('#root'));
const render=(props={})=>act(async()=>root.render(React.createElement(mod.exports.StudentDailyNote,{day:'2026-11-04',initialNote:'',editable:true,onSaved:(day,note)=>saved.push([day,note]),...props})));
const type=(value)=>act(async()=>{const input=document.querySelector('textarea');
 const setter=Object.getOwnPropertyDescriptor(dom.window.HTMLTextAreaElement.prototype,'value').set;
 setter.call(input,value);input.dispatchEvent(new dom.window.Event('input',{bubbles:true}));});
const click=()=>act(async()=>document.querySelector('button').click());
(async()=>{
 await render();assert.equal(document.querySelector('button').disabled,true);
 await type('  نیاز به کمک در برنامه  ');await click();
 assert.deepEqual(calls.at(-1),['2026-11-04','نیاز به کمک در برنامه']);
 assert.deepEqual(saved.at(-1),['2026-11-04','نیاز به کمک در برنامه']);
 assert.match(document.querySelector('[role=status]').textContent,/ذخیره شد/);
 await render({initialNote:'نیاز به کمک در برنامه'});
 await type('نکته جدید');fail=true;await click();
 assert.match(document.querySelector('[role=alert]').textContent,/ذخیره انجام نشد/);
 assert.equal(saved.length,1);
 fail=false;await render({day:'2026-11-03',initialNote:'روز قبل'});
 assert.equal(document.querySelector('textarea').value,'روز قبل');
 await render({day:'2026-11-03',initialNote:'یادداشت فقط برای مشاور',editable:false});
 assert.equal(document.querySelector('textarea'),null);
 assert.match(document.querySelector('.sp-daily-note').textContent,/یادداشت فقط برای مشاور/);
 await render({day:'2026-11-03',initialNote:'',editable:false});
 assert.equal(document.querySelector('.sp-daily-note'),null);
 await act(async()=>root.unmount());dom.window.close();
 console.log('PASS: optional daily note save/failure, day switch, counselor read-only view');
})().catch(error=>{console.error(error);process.exitCode=1;dom.window.close()});
