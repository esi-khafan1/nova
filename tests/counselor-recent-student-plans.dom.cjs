// Render the real planner with mocked external controls; no database or real account is used.
const assert = require('node:assert/strict');
const esbuild = require('esbuild');
const Module = require('node:module');
const path = require('node:path');
const {JSDOM} = require('jsdom');
const React = require('react');
const {act} = React;
const dom = new JSDOM('<div id="root"></div>', {url:'https://nova.test/', pretendToBeVisual:true});
global.window=dom.window; global.document=dom.window.document; global.navigator=dom.window.navigator;
global.IS_REACT_ACT_ENVIRONMENT=true;
const {createRoot} = require('react-dom/client');

(async()=>{
  const built = await esbuild.build({
    entryPoints:['components/dashboard/weekly-plan-builder.tsx'], bundle:true, platform:'node', format:'cjs', jsx:'automatic', write:false,
    external:['react','react/jsx-runtime'],
    plugins:[{name:'mock-planner-dependencies', setup(build){
      build.onResolve({filter:/^(next\/link|@\/(app\/dashboard\/actions|components\/dashboard\/(persian-date-picker|counselor-student-study-editor)))$/}, args=>({path:args.path,namespace:'mock'}));
      build.onLoad({filter:/.*/,namespace:'mock'}, args=>({contents:args.path === 'next/link'
        ? 'import React from "react"; export default function Link({href,children,...rest}) { return React.createElement("a",{href,...rest},children); }'
        : args.path.includes('actions') ? 'export const saveWeeklyPlan="/save";'
        : args.path.includes('persian-date-picker') ? 'export const PersianDatePicker=()=>null;'
        : 'export const CounselorStudentStudyEditor=()=>null;', loader:'js'}));
    }}],
  });
  const filename=path.join(process.cwd(),'virtual-counselor-recent-plans.cjs');
  const mod=new Module(filename,module); mod.filename=filename; mod.paths=Module._nodeModulePaths(process.cwd());
  mod._compile(built.outputFiles[0].text,filename);
  const {WeeklyPlanBuilder}=mod.exports;
  const students=[
    {student_id:'student-a',full_name:'دانش‌آموز الف',grade:10,study_field:'humanities'},
    {student_id:'student-b',full_name:'دانش‌آموز ب',grade:11,study_field:'humanities'},
    {student_id:'student-c',full_name:'دانش‌آموز پ',grade:12,study_field:'humanities'},
  ];
  const history=[
    ...Array.from({length:9},(_,i)=>({id:`a-${i}`,student_id:'student-a',week_start:`2026-11-${String(28-i).padStart(2,'0')}`,title:`الف ${i}`,status:i===0?'draft':'published',counselor_id:i===1?'previous':'current'})),
    {id:'b-0',student_id:'student-b',week_start:'2026-01-03',title:'برنامه ب',status:'published',counselor_id:'current'},
  ];
  const props={students,plans:[],numberingPlans:history,recentPlans:history,counselorId:'current',completedItemIds:[]};
  const root=createRoot(document.getElementById('root'));
  await act(async()=>root.render(React.createElement(WeeklyPlanBuilder,props)));
  const section=()=>document.querySelector('.recent-plans');
  assert.equal(section().querySelectorAll('article').length,8,'filter first, then limit to eight');
  assert.match(section().textContent,/دانش‌آموز الف/);
  assert.doesNotMatch(section().textContent,/دانش‌آموز ب|برنامه ب|الف ۸/);
  assert.match(section().textContent,/برنامهٔ مشاور پیشین · فقط مشاهده/);
  assert.match(section().textContent,/پیش‌نویس/);
  assert.ok(section().querySelector('a[href="/dashboard/counselor/plans/a-0/print"]'));
  const select=document.querySelector('select[name="student_id"]');
  await act(async()=>{select.value='student-b';select.dispatchEvent(new dom.window.Event('change',{bubbles:true}));});
  assert.equal(section().querySelectorAll('article').length,1);
  assert.match(section().textContent,/دانش‌آموز ب/);
  assert.match(section().textContent,/برنامه ب/);
  assert.doesNotMatch(section().textContent,/دانش‌آموز الف|الف ۰/);
  assert.ok(section().querySelector('a[href="/dashboard/counselor/plans/b-0/print"]'));
  await act(async()=>{select.value='student-c';select.dispatchEvent(new dom.window.Event('change',{bubbles:true}));});
  assert.equal(section(),null,'no other student history should appear when selected student has no plans');
  await act(async()=>root.render(React.createElement(WeeklyPlanBuilder,{...props,initialStudentId:'student-b',key:'initial-b'})));
  assert.match(section().textContent,/دانش‌آموز ب/);
  assert.doesNotMatch(section().textContent,/دانش‌آموز الف/);
  await act(async()=>root.unmount());dom.window.close();
  console.log('PASS: recent plans follow the planner selection, filter before limiting and preserve previous-counselor history.');
})().catch(error=>{console.error(error);process.exitCode=1;dom.window.close();});
