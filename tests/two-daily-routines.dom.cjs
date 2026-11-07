const assert=require('node:assert/strict'),esbuild=require('esbuild'),Module=require('node:module'),path=require('node:path'),{JSDOM}=require('jsdom'),React=require('react'),{act}=React;
const dom=new JSDOM('<div id="root"></div>',{url:'https://nova.test/',pretendToBeVisual:true});global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;global.IS_REACT_ACT_ENVIRONMENT=true;const {createRoot}=require('react-dom/client');
(async()=>{
 const built=await esbuild.build({entryPoints:['components/dashboard/weekly-plan-builder.tsx'],bundle:true,platform:'node',format:'cjs',jsx:'automatic',write:false,external:['react','react/jsx-runtime'],plugins:[{name:'mocks',setup(b){b.onResolve({filter:/^(next\/link|@\/(app\/dashboard\/actions|components\/dashboard\/(persian-date-picker|counselor-student-study-editor)))$/},a=>({path:a.path,namespace:'mock'}));b.onLoad({filter:/.*/,namespace:'mock'},a=>({loader:'js',contents:a.path==='next/link'?'import React from "react";export default function Link({href,children}){return React.createElement("a",{href},children)}':a.path.includes('actions')?'export const saveWeeklyPlan="/save";export const saveCurrentWeeklyPlan=async()=>null;':a.path.includes('persian-date-picker')?'export const PersianDatePicker=()=>null;':'export const CounselorStudentStudyEditor=()=>null;'}));}}]});
 const filename=path.join(process.cwd(),'virtual-two-routines.cjs'),mod=new Module(filename,module);mod.filename=filename;mod.paths=Module._nodeModulePaths(process.cwd());mod._compile(built.outputFiles[0].text,filename);const {WeeklyPlanBuilder}=mod.exports;
 const parts=new Intl.DateTimeFormat('en-US',{timeZone:'Asia/Tehran',year:'numeric',month:'2-digit',day:'2-digit'}).formatToParts(new Date()),v=t=>parts.find(x=>x.type===t).value,today=`${v('year')}-${v('month')}-${v('day')}`;
 const student={student_id:'student',full_name:'دانش‌آموز',grade:9,study_field:null};
 const old=Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:dayOfWeek===0?'ریاضی':'',details:dayOfWeek===0?'متن قدیمی':''}));
 const plan={id:'plan',student_id:'student',week_start:today,title:'برنامه',notes:null,status:'published',routines:old,weekly_plan_items:[]};
 const root=createRoot(document.getElementById('root'));const render=p=>root.render(React.createElement(WeeklyPlanBuilder,{students:[student],plans:[p],initialStudentId:'student',initialPlanId:'plan',initialWeekStart:today,completedItemIds:[]}));
 await act(async()=>render(plan));
 const sections=[...document.querySelectorAll('.plan-routine')];assert.equal(sections.length,7);assert.ok(sections.every(s=>s.querySelectorAll('.plan-routine-entry').length===2));
 const first=sections[0],selects=first.querySelectorAll('select'),texts=first.querySelectorAll('textarea');assert.equal(selects[0].value,'ریاضی');assert.equal(texts[0].value,'متن قدیمی');assert.equal(selects[1].value,'');
 const option=[...selects[1].options].find(o=>o.value&&o.value!=='ریاضی');assert.ok(option);
 await act(async()=>{selects[1].value=option.value;selects[1].dispatchEvent(new dom.window.Event('change',{bubbles:true}));});
 // React tracks textarea input values; invoke the native setter before dispatching.
 await act(async()=>{Object.getOwnPropertyDescriptor(dom.window.HTMLTextAreaElement.prototype,'value').set.call(texts[1],'مرور جدید');texts[1].dispatchEvent(new dom.window.Event('input',{bubbles:true}));});
 let sent=JSON.parse(document.querySelector('input[name="routines"]').value);assert.equal(sent.length,7);assert.equal(sent[0].subject,'ریاضی');assert.equal(sent[0].details,'متن قدیمی');assert.equal(sent[0].secondSubject,option.value);assert.equal(sent[0].secondDetails,'مرور جدید');
 await act(async()=>root.render(React.createElement(WeeklyPlanBuilder,{key:'reload',students:[student],plans:[{...plan,routines:sent}],initialStudentId:'student',initialPlanId:'plan',initialWeekStart:today,completedItemIds:[]})));
 assert.equal(document.querySelectorAll('.plan-routine')[0].querySelectorAll('select')[1].value,option.value);assert.equal(document.querySelectorAll('.plan-routine')[0].querySelectorAll('textarea')[1].value,'مرور جدید');
 await act(async()=>root.unmount());dom.window.close();console.log('PASS: two daily routines edit independently, preserve legacy values, serialize and reload.');
})().catch(e=>{console.error(e);process.exitCode=1;dom.window.close()});
