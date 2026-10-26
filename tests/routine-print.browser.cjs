// Bundles the real PrintWeeklyPlan component and global CSS; validates sample B.
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');
const esbuild=require('esbuild');
const {chromium}=require('playwright-core');

const activityTypes=['lesson','notes','practice_tests','class','exam','review','homework','summary','other','exam_analysis','simulation_exam','offline_class','textbook_reading'];
const subjects=['درک عمومی ریاضی و فیزیک و آمار','زیست شناسی','فیزیک','شیمی','ادبیات','عربی','انگلیسی'];
const chapters=['فصل ۱: تابع','فصل ۲: ژنتیک','فصل ۱: حرکت','فصل ۳: محلولها','غزل شماره ۵','قواعد ۱ تا ۳','لغات درس ۴'];
const weekly_plan_items=Array.from({length:35},(_,index)=>{
 const activity=activityTypes[index%activityTypes.length];
 return {
  id:`item-${index}`,day_of_week:Math.floor(index/5),duration_minutes:90,
  subject:subjects[index%subjects.length],chapter:chapters[index%chapters.length],
  activity_type:activity,target_test_count:activity==='practice_tests'?20:null,
  details:'نکتههای مشاور',sort_order:index%5,
 };
});
const routines=Array.from({length:7},(_,dayOfWeek)=>({
 dayOfWeek,subject:subjects[dayOfWeek],details:'مرور فرمولها، نکتهها و تمرینهای پرتکرار',
}));
const expectedWeekdays=['پنجشنبه','جمعه','شنبه','یکشنبه','دوشنبه','سه\u200cشنبه','چهارشنبه'];
const plan={id:'plan-1',student_id:'student-1',week_start:'2026-10-22',title:'برنامه هفتگی نمونه',notes:'یادداشت کلی مشاور.',status:'published',routines,weekly_plan_items};
const props={plan,student:{full_name:'نمونه دانشآموز',grade:12,study_field:'experimental_sciences'},counselorName:'مشاور نووا',backHref:'/dashboard/counselor/plans'};

(async()=>{
 const stubs={
  'next/link':`import React from 'react';export default function Link({href,children,...rest}){return React.createElement('a',{href,...rest},children);}`,
  '@/components/dashboard/print-plan-button':`export function PrintPlanButton(){return null;}`,
 };
 const bundle=await esbuild.build({
  absWorkingDir:process.cwd(),tsconfig:'tsconfig.json',
  stdin:{contents:`import React from 'react';import {renderToStaticMarkup} from 'react-dom/server';import {PrintWeeklyPlan} from './components/dashboard/print-weekly-plan';const props=${JSON.stringify(props)};export const html=renderToStaticMarkup(React.createElement(PrintWeeklyPlan,props));`,resolveDir:process.cwd(),loader:'ts'},
  bundle:true,write:false,outfile:'/tmp/nova-routine-component.cjs',platform:'node',format:'cjs',target:'node22',jsx:'automatic',
  plugins:[{name:'print-stubs',setup(build){
   build.onResolve({filter:/^(next\/link|@\/components\/dashboard\/print-plan-button)$/},args=>({path:args.path,namespace:'nova-stub'}));
   build.onLoad({filter:/.*/,namespace:'nova-stub'},args=>({contents:stubs[args.path],loader:'tsx',resolveDir:process.cwd()}));
  }}],
 });
 const compiled={exports:{}};
 new Function('module','exports','require',bundle.outputFiles[0].text)(compiled,compiled.exports,require);
 const html=compiled.exports.html;
 const globalsCss=fs.readFileSync(path.join(process.cwd(),'app/globals.css'),'utf8');
 const fontFile=fs.readFileSync(path.join(process.cwd(),'public/fonts/estedad-arabic-wght-normal.woff2'));
 const fontCss=`@font-face{font-family:'Estedad Variable';src:url('/font.woff2') format('woff2');font-style:normal;font-weight:100 900;font-display:swap}body{font-family:'Estedad Variable',sans-serif}`;
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH||'/tmp/nova-browser-bin/chromium',args:['--no-sandbox','--disable-dev-shm-usage']});
 try{
  const page=await browser.newPage({viewport:{width:1123,height:794},deviceScaleFactor:2});
  await page.route('**/*',async route=>{
   const url=new URL(route.request().url());
   if(url.pathname==='/font.woff2')return route.fulfill({contentType:'font/woff2',body:fontFile});
   if(url.pathname!=='/')return route.abort();
   return route.fulfill({contentType:'text/html',body:`<!doctype html><html lang="fa" dir="rtl"><head><meta charset="utf-8"><style>${fontCss}\n${globalsCss}</style></head><body>${html}</body></html>`});
  });
  await page.goto('http://nova-routine.test/');
  await page.evaluate(()=>document.fonts.ready);
  await page.emulateMedia({media:'print'});
  const checks=await page.evaluate(()=>{
   const root=document.querySelector('.a4-weekly-plan');
   const grid=document.querySelector('.print-week-grid');
   const dayColumns=[...document.querySelectorAll('.print-day-column')];
   const routines=[...document.querySelectorAll('.print-routine')];
   const activities=[...document.querySelectorAll('.print-activity:not(.print-routine):not(.print-activity-empty)')];
   const inside=(child,parent)=>{const a=child.getBoundingClientRect(),b=parent.getBoundingClientRect();return a.left>=b.left-1&&a.right<=b.right+1&&a.top>=b.top-1&&a.bottom<=b.bottom+1;};
   const clipped=[...document.querySelectorAll('.print-activity')].filter(box=>[...box.children].filter(c=>getComputedStyle(c).display!=='none').some(c=>!inside(c,box))).length;
   const px=s=>Number.parseFloat(getComputedStyle(document.querySelector(s)).fontSize);
   return {
    pageOverflow:root.scrollHeight>root.clientHeight+2||root.scrollWidth>root.clientWidth+2,
    horizontalOverflow:document.documentElement.scrollWidth>innerWidth,
    columns:getComputedStyle(grid).gridTemplateColumns.split(' ').length,
    dayColumns:dayColumns.length,routines:routines.length,activities:activities.length,clipped,
    routinePerDay:dayColumns.map(c=>c.querySelectorAll('.print-routine').length),
    routineWidth:routines[0]?.getBoundingClientRect().width,
    routineWeekdays:routines.map(box=>box.getAttribute('data-weekday')),
    dayHeadings:dayColumns.map(column=>column.querySelector('h2')?.textContent?.trim()),
    activityWidth:activities[0]?.getBoundingClientRect().width,
    subjectFont:px('.print-activity-title strong'),durationFont:px('.print-activity-title b'),chapterFont:px('.print-activity-chapter'),
    durationText:document.querySelector('.print-activity-title b')?.textContent?.trim(),
    routineTitle:document.querySelector('.print-routine .print-activity-title strong')?.textContent?.trim(),
   };
  });
  assert.equal(checks.pageOverflow,false,'A4 overflow');
  assert.equal(checks.horizontalOverflow,false,'horizontal overflow');
  assert.equal(checks.columns,7,'must remain seven day columns');
  assert.equal(checks.dayColumns,7);
  assert.equal(checks.routines,7,'exactly one routine per day');
  assert.deepEqual(checks.routinePerDay,[1,1,1,1,1,1,1]);
  assert.equal(checks.clipped,0,'clipped box');
  assert.ok(checks.routineWidth<checks.activityWidth,'routine must be slightly narrower');
  assert.equal(checks.durationText,'۹۰ د');
  assert.equal(checks.routineTitle,'روتین');
  assert.deepEqual(checks.routineWeekdays,expectedWeekdays);
  assert.deepEqual(checks.dayHeadings,expectedWeekdays);
  assert.ok(checks.subjectFont>0&&checks.durationFont>0&&checks.chapterFont>0,'fonts must be unchanged');
  await page.screenshot({path:path.join(process.cwd(),'preview/actual-routine-b.png'),fullPage:false});
  const pdf=await page.pdf({path:path.join(process.cwd(),'preview/actual-routine-b.pdf'),preferCSSPageSize:true,printBackground:true,displayHeaderFooter:false});
  assert.equal((pdf.toString('latin1').match(/\/Type\s*\/Page\b/g)||[]).length,1,'one A4 page');
  await page.close();
  console.log('Actual PrintWeeklyPlan sample B: 7 day columns, real weekdays from week_start, 7 narrower routine boxes titled روتین, 90 د, unchanged fonts, no clipping, one A4 page.');
 }finally{await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1;});
