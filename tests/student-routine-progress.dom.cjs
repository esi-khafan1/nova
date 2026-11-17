const assert=require('node:assert/strict'),esbuild=require('esbuild'),Module=require('node:module'),path=require('node:path'),{JSDOM}=require('jsdom'),React=require('react'),{act}=React;
const dom=new JSDOM('<div id="root"></div>',{url:'https://nova.test/',pretendToBeVisual:true});
global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;global.location=dom.window.location;global.IS_REACT_ACT_ENVIRONMENT=true;
const {createRoot}=require('react-dom/client');
(async()=>{
 const build=await esbuild.build({entryPoints:['components/dashboard/student-planning-panel.tsx'],bundle:true,platform:'node',format:'cjs',jsx:'automatic',write:false,external:['react','react/jsx-runtime','react-dom'],plugins:[{name:'mocks',setup(b){
  b.onResolve({filter:/^(next\/link|@\/app\/dashboard\/actions|@\/components\/dashboard\/(student-daily-note|persian-date-picker|planner-published-reviews|planner-published-week-details|use-published-planner-topics))$/},a=>({path:a.path,namespace:'mock'}));
  b.onLoad({filter:/.*/,namespace:'mock'},a=>({loader:'js',contents:a.path==='next/link'?'import React from "react";export default function Link({children,...p}){return React.createElement("a",p,children)}':a.path.includes('actions')?'export const toggleRoutineCompletion=async(...args)=>{globalThis.calls.push(args);return {ok:!globalThis.fail}}; export const togglePlanItemCompletion=async()=>({ok:true});':a.path.endsWith('use-published-planner-topics')?'export const usePublishedPlannerTopics=()=>({topics:{},failed:false});':'export const StudentDailyNote=()=>null,PersianDatePicker=()=>null,PlannerPublishedReviews=()=>null,PlannerPublishedWeekDetails=()=>null;'}));
 }}]});
 const file=path.join(process.cwd(),'virtual-student-routines.cjs'),m=new Module(file,module);m.filename=file;m.paths=Module._nodeModulePaths(process.cwd());m._compile(build.outputFiles[0].text,file);
 global.calls=[];global.fail=false;
 const plan={id:'plan',title:'برنامه',week_start:'2026-11-17',notes:null,weekly_plan_items:[],routines:[{dayOfWeek:0,subject:'ریاضی',details:'تمرین',secondSubject:'فیزیک',secondDetails:'مرور'},{dayOfWeek:1,subject:'',details:'',secondSubject:'زبان',secondDetails:'واژگان'}]};
 const props={plans:[plan],completions:[],routineCompletions:[],dailyNotes:[],today:'2026-11-17',profile:{full_name:'دانش‌آموز',grade:10,study_field:'experimental_sciences'},studentId:'student'};
 const root=createRoot(document.getElementById('root'));await act(async()=>root.render(React.createElement(m.exports.StudentPlanningPanel,props)));
 const routines=()=>document.querySelector('.sp-routines'),checks=()=>routines().querySelectorAll('input[type=checkbox]');
 assert.match(routines().textContent,/روتین ۱/);assert.match(routines().textContent,/روتین ۲/);assert.equal(checks().length,2);
 await act(async()=>checks()[1].click());assert.deepEqual(global.calls.at(-1),['plan',0,2,'فیزیک','مرور',true]);assert.equal(checks()[1].checked,true);
 global.fail=true;await act(async()=>checks()[0].click());assert.equal(checks()[0].checked,false);assert.match(routines().textContent,/ثبت روتین انجام نشد/);global.fail=false;
 const weekly=[...document.querySelectorAll('.sp-tabs button')].find(b=>b.textContent.includes('هفتگی'));await act(async()=>weekly.click());assert.equal(checks()[1].checked,true,'local tick carries across daily and weekly');
 const dayButtons=document.querySelectorAll('.sp-week-days button');await act(async()=>dayButtons[1].click());assert.match(routines().textContent,/روتین ۱/);assert.doesNotMatch(routines().textContent,/روتین ۲/);assert.match(routines().textContent,/زبان/);assert.equal(checks().length,0,'future cannot be ticked');
 const saved=[{plan_id:'plan',student_id:'student',day_of_week:0,slot:2,subject:'فیزیک',details:'مرور',checked_at:'2026-11-17T08:00:00Z'}];
 await act(async()=>root.render(React.createElement(m.exports.StudentPlanningPanel,{...props,key:'reload',routineCompletions:saved})));assert.equal(checks()[1].checked,true);
 await act(async()=>checks()[1].click());assert.equal(checks()[1].checked,false);assert.deepEqual(global.calls.at(-1),['plan',0,2,'فیزیک','مرور',false]);
 await act(async()=>root.render(React.createElement(m.exports.StudentPlanningPanel,{...props,key:'counselor',audience:'counselor',routineCompletions:saved})));assert.match(routines().textContent,/انجام داده‌ام/);assert.equal(checks().length,0,'counselor is read-only');
 await act(async()=>root.unmount());dom.window.close();delete global.calls;delete global.fail;console.log('PASS: two routine slots, future, error, reload, undo and read-only counselor');
})().catch(e=>{console.error(e);process.exitCode=1;dom.window.close()});
