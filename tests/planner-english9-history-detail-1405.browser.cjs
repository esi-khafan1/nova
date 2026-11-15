// Real topic editor with the exact database result of the migrations and synthetic RPCs.
const assert=require('node:assert/strict'),fs=require('node:fs'),esbuild=require('esbuild'),{PGlite}=require('@electric-sql/pglite'),{chromium}=require('playwright-core');
(async()=>{
 const db=new PGlite();await db.exec(`create role anon;create role authenticated;create schema private;create table private.planner_topic_bank(id uuid primary key,edition text,study_field text,grade text,preparation_track text,subject text,chapter text,title text,page_start integer,page_end integer,position integer,revision integer default 1,updated_at timestamptz default now());`);
 for(const f of ['136_planner_physics_writing_topics','152_planner_geology_history_topics','164_planner_history10_1405_topics','167_planner_english9_1405_pages','168_planner_history10_finer_1405'])await db.exec(fs.readFileSync(`supabase/migrations/${f}.sql`,'utf8'));
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox']});
 try{for(const [subject,grade,chapter,title,expected,field,track] of [
  ['زبان انگلیسی',9,'درس‌ها','درس 1: Personality — Conversation',[16,16],'all','final_exam'],
  ['زبان انگلیسی',9,'درس‌ها','درس 6: Health and Injuries — Grammar',[101,104],'all','final_exam'],
  ['تاریخ ۱',10,'درس ۱','انتخاب موضوع',[6,6],'humanities','konkur'],
  ['تاریخ ۱',10,'درس ۲','خط زمان',[16,16],'humanities','final_exam']]){
  const records=(await db.query(`select id,grade,preparation_track as track,subject,chapter,title,page_start as "pageStart",page_end as "pageEnd",position as "order" from private.planner_topic_bank where study_field=$4 and preparation_track=$5 and grade=$1 and subject=$2 and chapter=$3 order by position,id`,[String(grade),subject,chapter,field,track])).rows;
  const selected=records.find(r=>r.title===title);assert.ok(selected);assert.deepEqual([selected.pageStart,selected.pageEnd],expected);
  const built=await esbuild.build({stdin:{contents:`import React,{useState} from 'react';import{createRoot}from'react-dom/client';import{PlannerTopicEditor}from'./components/dashboard/planner-topic-editor';function App(){const [topics,setTopics]=useState([]);window.topics=topics;return <PlannerTopicEditor topics={topics} onChange={setTopics} selection={{studentId:'student',field:${JSON.stringify(field)},grade:${grade},track:${JSON.stringify(track)},subject:${JSON.stringify(subject)},chapter:${JSON.stringify(chapter)},weekStart:'2026-11-03',date:'2026-11-03',order:1,uses:[]}}/>}createRoot(document.getElementById('root')).render(<App/>);`,resolveDir:process.cwd(),loader:'tsx'},bundle:true,platform:'browser',format:'iife',jsx:'automatic',write:false,outdir:'virtual-english-history-verified',plugins:[{name:'mock',setup(b){b.onResolve({filter:/^@\/lib\/supabase\/client$/},()=>({path:'client',namespace:'mock'}));b.onLoad({filter:/.*/,namespace:'mock'},()=>({loader:'js',contents:'export function createClient(){return {rpc:window.mockRpc}}'}));}}]});
  const js=built.outputFiles.find(x=>x.path.endsWith('.js')).text,css=built.outputFiles.find(x=>x.path.endsWith('.css')).text,globals=fs.readFileSync('app/globals.css','utf8');
  for(const width of [320,390,768,1200]){
   const page=await browser.newPage({viewport:{width,height:900}}),errors=[];page.on('pageerror',e=>errors.push(e.message));
   await page.setContent(`<html dir="rtl"><style>${globals}\n${css}</style><main style="padding:16px"><div id="root"></div></main></html>`);
   await page.evaluate(({records,subject,chapter,field,track})=>{window.mockRpc=async(name,args)=>{if(name==='planner_topic_history')return {data:[],error:null};if(name==='planner_list_topics'&&args.target_field===field&&args.target_track===track&&args.target_subject===subject&&args.target_chapter===chapter)return {data:records,error:null};throw Error('unexpected request')}},{records,subject,chapter,field,track});
   await page.addScriptTag({content:js});await page.locator('summary').click();const bank=page.getByLabel('بانک مباحث');await bank.locator('option').nth(1).waitFor({state:'attached'});await bank.selectOption(selected.id);
   const val=async label=>(await page.getByLabel(label).inputValue()).replace(/[۰-۹]/g,c=>'۰۱۲۳۴۵۶۷۸۹'.indexOf(c)).replace(/[٠-٩]/g,c=>'٠١٢٣٤٥٦٧٨٩'.indexOf(c));
   assert.equal(await val('از صفحه'),expected[0]===null?'':String(expected[0]));assert.equal(await val('تا صفحه'),expected[1]===null?'':String(expected[1]));
   await page.getByRole('button',{name:'افزودن مبحث'}).click();assert.deepEqual(await page.evaluate(()=>window.topics),[{title:selected.title,pageStart:expected[0],pageEnd:expected[1],bankId:selected.id}]);
   await page.getByRole('button',{name:`ویرایش ${selected.title}`}).click();await page.getByLabel('از صفحه').fill('۲');await page.getByLabel('تا صفحه').fill('۳۰');await page.getByRole('button',{name:'ثبت ویرایش'}).click();
   assert.deepEqual(await page.evaluate(()=>window.topics),[{title:selected.title,pageStart:2,pageEnd:30,bankId:selected.id}]);assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`${subject} overflow ${width}`);assert.deepEqual(errors,[]);await page.close();
  }console.log(`PASS: ${subject} verified range selection and editing at four widths`);
 }}finally{await browser.close();await db.close()}
})().catch(e=>{console.error(e);process.exitCode=1});
