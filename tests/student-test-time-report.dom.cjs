// Synthetic student progress only: real panel and checkbox, no production writes.
const assert=require('node:assert/strict'),esbuild=require('esbuild'),Module=require('node:module'),path=require('node:path'),{JSDOM}=require('jsdom'),React=require('react'),{act}=React;
const dom=new JSDOM('<div id="root"></div>',{url:'https://nova.test/',pretendToBeVisual:true});
global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;global.location=dom.window.location;global.IS_REACT_ACT_ENVIRONMENT=true;
const {createRoot}=require('react-dom/client');
(async()=>{
 const built=await esbuild.build({entryPoints:['components/dashboard/student-planning-panel.tsx'],bundle:true,platform:'node',format:'cjs',jsx:'automatic',write:false,external:['react','react/jsx-runtime','react-dom'],plugins:[{name:'mocks',setup(b){
  b.onResolve({filter:/^(next\/link|@\/app\/dashboard\/actions|@\/components\/dashboard\/(student-daily-note|persian-date-picker|planner-published-reviews|planner-published-week-details|use-published-planner-topics))$/},a=>({path:a.path,namespace:'mock'}));
  b.onLoad({filter:/.*/,namespace:'mock'},a=>({loader:'js',contents:a.path==='next/link'?'import React from "react";export default function Link({children,...p}){return React.createElement("a",p,children)}':a.path.includes('actions')?'export const togglePlanItemCompletion=async(...args)=>{globalThis.progressCalls.push(args);return {ok:true}};export const toggleRoutineCompletion=async()=>({ok:true});':a.path.endsWith('use-published-planner-topics')?'export const usePublishedPlannerTopics=()=>({topics:{},failed:false});':'export const StudentDailyNote=()=>null,PersianDatePicker=()=>null,PlannerPublishedReviews=()=>null,PlannerPublishedWeekDetails=()=>null;'}));
 }}]});
 const file=path.join(process.cwd(),'virtual-test-time-report.cjs'),m=new Module(file,module);m.filename=file;m.paths=Module._nodeModulePaths(process.cwd());m._compile(built.outputFiles[0].text,file);
 global.progressCalls=[];
 const item={id:'item',plan_id:'plan',day_of_week:0,duration_minutes:90,subject:'ریاضی ۱',chapter:'تابع',activity_type:'practice_tests',target_test_count:20,details:null,sort_order:0};
 const today='2026-11-17',plan={id:'plan',title:'برنامه',week_start:today,notes:null,weekly_plan_items:[item]};
 const props={plans:[plan],completions:[],dailyNotes:[],today,profile:{full_name:'دانش‌آموز',grade:10,study_field:'experimental_sciences'}};
 const root=createRoot(document.getElementById('root'));await act(async()=>root.render(React.createElement(m.exports.StudentPlanningPanel,props)));
 const summary=()=>document.querySelector('.sp-summary').textContent,task=()=>document.querySelector('.sp-task');
 assert.match(summary(),/۰ ساعت/);assert.match(task().textContent,/مدت خالی یعنی زمان کامل برنامه/);
 await act(async()=>task().querySelector('input[type=checkbox]').click());
 assert.deepEqual(global.progressCalls.at(-1),['item',true,null,null]);
 assert.match(summary(),/۱ ساعت و ۳۰ دقیقه/);assert.match(task().textContent,/زمان واقعی ثبت نشده؛ زمان برنامه کامل حساب شده/);
 let input=task().querySelector('.student-duration-input');assert.equal(input.value,'');
 const change=async(value)=>act(async()=>{Object.getOwnPropertyDescriptor(dom.window.HTMLInputElement.prototype,'value').set.call(input,value);input.dispatchEvent(new dom.window.Event('input',{bubbles:true}));input.dispatchEvent(new dom.window.FocusEvent('focusout',{bubbles:true}));});
 await change('0:45');assert.deepEqual(global.progressCalls.at(-1),['item',true,null,45]);assert.match(summary(),/۰ ساعت و ۴۵ دقیقه/);assert.match(task().textContent,/۴۵ دقیقهٔ ثبت‌شده/);
 await change('');assert.deepEqual(global.progressCalls.at(-1),['item',true,null,null]);assert.match(summary(),/۱ ساعت و ۳۰ دقیقه/);
 await act(async()=>task().querySelector('input[type=checkbox]').click());assert.match(summary(),/۰ ساعت/);
 const completion={item_id:'item',completed_at:'2026-11-17T08:00:00Z',completed_test_count:10,completed_minutes:null,test_duration_recorded:true};
 await act(async()=>root.render(React.createElement(m.exports.StudentPlanningPanel,{...props,key:'counselor',audience:'counselor',completions:[completion]})));
 assert.match(summary(),/۱ ساعت و ۳۰ دقیقه/);assert.match(task().textContent,/زمان واقعی ثبت نشده؛ زمان برنامه کامل حساب شده/);
 const journey=[...document.querySelectorAll('.sp-tabs button')].find(b=>b.textContent.includes('مسیر مطالعه'));await act(async()=>journey.click());
 assert.match(document.querySelector('#study-journey .sp-journey-totals').textContent,/۱ ساعت و ۳۰ دقیقه/);
 await act(async()=>root.unmount());dom.window.close();delete global.progressCalls;console.log('PASS: blank test time, entered time, clearing, unticking and counselor totals');
})().catch(e=>{console.error(e);process.exitCode=1;dom.window.close()});
