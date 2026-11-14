// Real topic editor, with synthetic RPCs and grade-nine edition data.
const assert=require('node:assert/strict'),fs=require('node:fs'),esbuild=require('esbuild'),{chromium}=require('playwright-core');
(async()=>{
 const books=JSON.parse(fs.readFileSync('supabase/migrations/151_planner_grade9_topics.sql','utf8').split('$books$')[1]);
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox']});
 try{for(const [index,chapter] of [[0,'فصل ۵: عصر یکپارچگی و شکوفایی'],[1,'درس ۱۰'],[2,'درس ۱۱']]){
  const book=books[index],records=book.chapters.find(c=>c.chapter===chapter).topics.map((t,i)=>({id:`seed-${i}`,grade:'9',track:'final_exam',subject:book.subject,chapter,title:t.title,pageStart:t.start??null,pageEnd:t.end??null,order:i}));
  const built=await esbuild.build({stdin:{contents:`import React,{useState} from 'react';import{createRoot}from'react-dom/client';import{PlannerTopicEditor}from'./components/dashboard/planner-topic-editor';function App(){const [topics,setTopics]=useState([]);window.topics=topics;return <PlannerTopicEditor topics={topics} onChange={setTopics} selection={{studentId:'student',field:'all',grade:9,track:'final_exam',subject:${JSON.stringify(book.subject)},chapter:${JSON.stringify(chapter)},weekStart:'2026-11-03',date:'2026-11-03',order:1,uses:[]}}/>}createRoot(document.getElementById('root')).render(<App/>);`,resolveDir:process.cwd(),loader:'tsx'},bundle:true,platform:'browser',format:'iife',jsx:'automatic',write:false,outdir:'virtual-grade9',plugins:[{name:'mock',setup(b){b.onResolve({filter:/^@\/lib\/supabase\/client$/},()=>({path:'client',namespace:'mock'}));b.onLoad({filter:/.*/,namespace:'mock'},()=>({loader:'js',contents:'export function createClient(){return {rpc:window.mockRpc}}'}));}}]});
  const js=built.outputFiles.find(x=>x.path.endsWith('.js')).text,css=built.outputFiles.find(x=>x.path.endsWith('.css')).text,globals=fs.readFileSync('app/globals.css','utf8');
  for(const width of [320,390,768,1200]){
   const page=await browser.newPage({viewport:{width,height:900}}),errors=[];page.on('pageerror',e=>errors.push(e.message));
   await page.setContent(`<html dir="rtl"><style>${globals}\n${css}</style><main style="padding:16px"><div id="root"></div></main></html>`);
   await page.evaluate(({records,subject,chapter})=>{window.mockRpc=async(name,args)=>{if(name==='planner_topic_history')return {data:[],error:null};if(name==='planner_list_topics'&&args.target_field==='all'&&args.target_subject===subject&&args.target_chapter===chapter)return {data:records,error:null};throw Error('unexpected request')}},{records,subject:book.subject,chapter});
   await page.addScriptTag({content:js});await page.locator('summary').click();const bank=page.getByLabel('بانک مباحث');await bank.locator('option').nth(1).waitFor({state:'attached'});await bank.selectOption('seed-0');
   assert.equal(await page.getByLabel('نام زیرمبحث').inputValue(),records[0].title);
   const value=async label=>{const text=await page.getByLabel(label).inputValue();return text.replace(/[۰-۹]/g,c=>'۰۱۲۳۴۵۶۷۸۹'.indexOf(c)).replace(/[٠-٩]/g,c=>'٠١٢٣٤٥٦٧٨٩'.indexOf(c));};
   assert.equal(await value('از صفحه'),records[0].pageStart===null?'':String(records[0].pageStart));assert.equal(await value('تا صفحه'),records[0].pageEnd===null?'':String(records[0].pageEnd));
   await page.getByRole('button',{name:'افزودن مبحث'}).click();assert.deepEqual(await page.evaluate(()=>window.topics),[{title:records[0].title,pageStart:records[0].pageStart,pageEnd:records[0].pageEnd,bankId:'seed-0'}]);
   await page.getByRole('button',{name:`ویرایش ${records[0].title}`}).click();await page.getByLabel('از صفحه').fill('۱۵۰');await page.getByLabel('تا صفحه').fill('۱۵۳');await page.getByRole('button',{name:'ثبت ویرایش'}).click();
   assert.deepEqual(await page.evaluate(()=>window.topics),[{title:records[0].title,pageStart:150,pageEnd:153,bankId:'seed-0'}]);assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`${book.subject} overflow ${width}`);assert.deepEqual(errors,[]);await page.close();
  }console.log(`PASS: ${book.subject} selection and page editing at four widths`);
 }}finally{await browser.close()}
})().catch(e=>{console.error(e);process.exitCode=1});
