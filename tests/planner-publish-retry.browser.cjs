// Synthetic data only: exercise the actual bottom publish button after a
// failed save and rapid repeated clicks. No application server is contacted.
const assert = require('node:assert/strict');
const esbuild = require('esbuild');
const {chromium} = require('playwright-core');

(async () => {
 const built = await esbuild.build({stdin:{contents:`
  import React from 'react'; import {createRoot} from 'react-dom/client';
  import {WeeklyPlanBuilder} from './components/dashboard/weekly-plan-builder';
  const parts=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Tehran',year:'numeric',month:'2-digit',day:'2-digit'}).formatToParts(new Date());
  const get=k=>parts.find(p=>p.type===k).value, today=get('year')+'-'+get('month')+'-'+get('day');
  window.live={id:'plan',student_id:'student',week_start:today,updated_at:'2026-10-19T10:00:00Z',status:'published',title:'برنامه نمونه',notes:'',routines:[],weekly_plan_items:[{id:'item',day_of_week:0,sort_order:0,duration_minutes:60,subject:'زیست‌شناسی ۱',chapter:'',activity_type:'lesson',target_test_count:null,details:'',source_grade:10,preparation_track:'konkur',recommended_publisher:null,exam_year:null,linked_exam_id:null}]};
  createRoot(document.getElementById('root')).render(<WeeklyPlanBuilder privateDrafts counselorId="counselor" students={[{student_id:'student',full_name:'دانش‌آموز نمونه',grade:10,study_field:'experimental_sciences'}]} plans={[window.live]} initialStudentId="student" initialPlanId="plan" initialWeekStart={today} completedItemIds={[]}/>);
 `,resolveDir:process.cwd(),loader:'tsx'},bundle:true,platform:'browser',format:'iife',jsx:'automatic',write:false,outdir:'virtual-publish-retry',plugins:[{name:'mocks',setup(build){
  build.onResolve({filter:/^(next\/link|@\/app\/dashboard\/actions|@\/components\/dashboard\/persian-date-picker|@\/lib\/supabase\/client)$/},a=>({path:a.path,namespace:'mock'}));
  build.onLoad({filter:/.*/,namespace:'mock'},a=>({loader:'js',resolveDir:process.cwd(),contents:a.path==='next/link'?'import React from "react";export default function Link({href,children,...props}){return React.createElement("a",{href,...props},children)}':a.path.includes('supabase/client')?'export {createPlannerClient as createClient} from "@/lib/planner-api-client"':a.path.includes('persian-date-picker')?'export const PersianDatePicker=()=>null;':'export const saveWeeklyPlan="/save";export const saveCurrentWeeklyPlan=async()=>null;'}));
 }}]});
 const js=built.outputFiles.find(x=>x.path.endsWith('.js')).text;
 const args=process.env.CHROMIUM_ARGS ? JSON.parse(process.env.CHROMIUM_ARGS) : ['--no-sandbox'];
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args});
 try {
  const page=await browser.newPage(), errors=[]; page.on('pageerror',e=>errors.push(e.message));
  await page.setContent('<html dir="rtl"><body><div id="root"></div></body></html>');
  await page.evaluate(()=>{
   window.calls=[]; window.offline=false; window.draft=null; window.publishes=0;
   window.fetch=async(url,options)=>{
    if(url!=='/api/planner')throw Error('unexpected request');
    const {name,args}=JSON.parse(options.body); window.calls.push(name); let data=null;
    if(name==='current_user')data={id:'counselor'};
    else if(name==='counselor_plan_editor_page')data={counselor_id:'counselor',plans:[structuredClone(window.live)],has_more:false};
    else if(name==='counselor_completed_plan_item_ids'||name==='planner_review_today_v2'||name==='planner_list_presets'||name==='planner_list_topics'||name==='planner_topic_history')data=[];
    else if(name==='planner_get_published_extras')data={week:{},items:{}};
    else if(name==='planner_get_working_draft')data=window.draft;
    else if(name==='planner_save_working_draft_checked'){
     if(window.offline)throw Error('simulated disconnect');
     if(args.expected_revision!==(window.draft?.revision??null))return new Response(JSON.stringify({data:null,error:{code:'40001'}}),{status:200});
     window.draft={plan_id:'plan',base_plan_updated_at:window.live.updated_at,revision:String(Number(args.expected_revision??0)+1),snapshot:structuredClone(args.target_snapshot)};
     data={revision:window.draft.revision,base_plan_updated_at:window.draft.base_plan_updated_at};
    } else if(name==='planner_publish_working_draft'){
     window.publishes++; window.publishedSnapshot=structuredClone(window.draft.snapshot);
     return new Promise(resolve=>{window.finishPublish=()=>resolve(new Response(JSON.stringify({data:null,error:{code:'test'}}),{status:200}));});
    }
    return new Response(JSON.stringify({data,error:null}),{status:200});
   };
  });
  await page.addScriptTag({content:js}); await page.getByText('آمادهٔ ذخیرهٔ خصوصی تغییرات').waitFor();
  await page.evaluate(()=>{window.calls=[];window.offline=true});
  const button=page.locator('.plan-publish-actions button[value=published]');
  await button.click(); await page.getByText(/تغییرات هنوز در این صفحه هستند/).waitFor();
  assert.equal(await button.isDisabled(),false);
  // A second click while the connection still fails must retain the warning.
  await button.click(); await page.getByText(/تغییرات هنوز در این صفحه هستند/).waitFor();
  assert.equal(await page.evaluate(()=>window.publishes),0);
  await page.evaluate(()=>{window.offline=false}); await button.click();
  await page.waitForFunction(()=>window.publishes===1);
  assert.equal(await button.isDisabled(),true);
  await page.evaluate(()=>{for(let i=0;i<5;i++)document.querySelector('.plan-publish-actions button[value=published]').click()});
  assert.equal(await page.evaluate(()=>window.publishes),1,'in-flight clicks cannot start another publication');
  assert.equal(await page.evaluate(()=>window.publishedSnapshot.items.length),1,'the complete snapshot reaches publication');
  await page.evaluate(()=>window.finishPublish());
  await page.waitForFunction(()=>!document.querySelector('.plan-publish-actions button[value=published]').matches(':disabled'));
  assert.deepEqual(errors,[]); await page.close();
  console.log('PASS: bottom publish retries failed saves, retains warnings and serializes rapid clicks');
 } finally {await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1});
