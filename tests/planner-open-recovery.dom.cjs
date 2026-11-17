// Verify the real builder remains safe but lets the counselor escape a failed open.
const assert=require('node:assert/strict'),esbuild=require('esbuild'),Module=require('node:module'),path=require('node:path'),{JSDOM}=require('jsdom'),React=require('react'),{act}=React;
const dom=new JSDOM('<div id="root"></div>',{url:'https://nova.test/',pretendToBeVisual:true});
global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;global.Element=dom.window.Element;global.IS_REACT_ACT_ENVIRONMENT=true;
const {createRoot}=require('react-dom/client');
(async()=>{
 const result=await esbuild.build({entryPoints:['components/dashboard/weekly-plan-builder.tsx'],bundle:true,platform:'node',format:'cjs',jsx:'automatic',write:false,loader:{'.css':'empty'},external:['react','react/jsx-runtime','react-dom','react-dom/client'],plugins:[{name:'mocks',setup(b){
  b.onResolve({filter:/\.css$/},a=>({path:a.path,namespace:'css-mock'}));
  b.onLoad({filter:/.*/,namespace:'css-mock'},()=>({loader:'js',contents:'export default {}'}));
  b.onResolve({filter:/^(next\/link|@\/app\/dashboard\/actions|@\/lib\/supabase\/client|@\/components\/dashboard\/(planner-insights|planner-published-reviews|planner-week-templates|planner-ready-blocks|planner-draft-print|planner-topic-editor|planner-bank-chapter-input))$/},a=>({path:a.path,namespace:'mock'}));
  b.onLoad({filter:/.*/,namespace:'mock'},a=>({loader:'js',contents:a.path==='next/link'?'import React from "react"; export default function Link({children,...p}){return React.createElement("a",p,children)}':a.path.includes('actions')?'export const saveWeeklyPlan="/save";export const saveCurrentWeeklyPlan=async()=>null;':a.path.includes('supabase/client')?'export function createClient(){return globalThis.testClient()}':'export const PlannerAnalysis=()=>null,PlannerPublishedReviews=()=>null,PlannerWeekTemplates=()=>null,PlannerReadyBlocks=()=>null,PlannerDraftPrint=()=>null,PlannerTopicEditor=()=>null,PlannerBankChapterInput=()=>null;'}));
 }}]});
 const filename=path.join(process.cwd(),'virtual-builder.cjs'),m=new Module(filename,module);m.filename=filename;m.paths=Module._nodeModulePaths(process.cwd());m._compile(result.outputFiles[0].text,filename);
 let fail=true,writes=0;
 global.testClient=()=>{if(fail)throw Error('config');return {auth:{getUser:async()=>({data:{user:{id:'counselor'}},error:null})},rpc:async name=>{
  if(name==='counselor_plan_editor_page')return {data:{counselor_id:'counselor',plans:[],has_more:false},error:null};
  if(name==='counselor_completed_plan_item_ids')return {data:[],error:null};
  if(name==='planner_get_working_draft')return {data:null,error:null};
  writes++;return {data:null,error:{code:'network'}};
 }}};
 const students=['one','two'].map(student_id=>({student_id,full_name:student_id,grade:10,study_field:'experimental_sciences'}));
 const root=createRoot(document.getElementById('root'));
 await act(async()=>root.render(React.createElement(m.exports.WeeklyPlanBuilder,{students,plans:[],privateDrafts:true,counselorId:'counselor',completedItemIds:[]})));
 const student=document.querySelector('select[name=student_id]'),plan=document.querySelector('[aria-label="انتخاب برنامهٔ موجود"]'),date=document.querySelector('.persian-date-trigger'),title=document.querySelector('input[name=title]'),grid=document.querySelector('[aria-label="برنامهٔ هفتگی"]');
 assert.match(document.body.textContent,/تنظیمات اتصال مرورگر/);
 assert.equal(student.matches(':disabled'),false);assert.equal(plan.matches(':disabled'),false);assert.equal(date.matches(':disabled'),false);
 assert.equal(title.matches(':disabled'),true);assert.equal(grid.querySelector('button:last-of-type').matches(':disabled'),true);assert.equal(writes,0);
 const oldWeek=document.querySelector('input[name=week_start]').value;
 await act(async()=>{date.click()});
 const nextDay=document.querySelector('.persian-calendar-days button:not(:disabled):not([aria-pressed="true"])');assert.ok(nextDay);
 await act(async()=>{nextDay.click()});
 assert.notEqual(document.querySelector('input[name=week_start]').value,oldWeek);
 assert.equal(title.matches(':disabled'),true);assert.equal(writes,0);
 fail=false;
 await act(async()=>{student.value='two';student.dispatchEvent(new dom.window.Event('change',{bubbles:true}));});
 assert.equal(student.value,'two');assert.equal(title.matches(':disabled'),false);assert.equal(writes,0);
 // Dirty state must still block switching if its save fails.
 await act(async()=>{Object.getOwnPropertyDescriptor(dom.window.HTMLInputElement.prototype,'value').set.call(title,'ویرایش ذخیره‌نشده');title.dispatchEvent(new dom.window.Event('input',{bubbles:true}));});
 await act(async()=>{student.value='one';student.dispatchEvent(new dom.window.Event('change',{bubbles:true}));});
 assert.equal(student.value,'two');assert.ok(writes>0);assert.match(document.body.textContent,/تغییرات ذخیره نشده‌اند/);
 await act(async()=>root.unmount());dom.window.close();delete global.testClient;console.log('PASS: failed open unlocks context selectors only; new context opens without writes');
})().catch(error=>{console.error(error);process.exitCode=1;dom.window.close()});
