// Bundles the real PrintWeeklyPlan component and global CSS; validates the approved
// larger four-row layout with varied subjects, chapters, activities and test targets.
const assert=require('node:assert/strict');
const fs=require('node:fs');
const os=require('node:os');
const path=require('node:path');
const esbuild=require('esbuild');
const {chromium}=require('playwright-core');

const activityTypes=['lesson','textbook_reading','notes','practice_tests','class','offline_class','exam','exam_analysis','simulation_exam','review','homework','summary','other'];
const subjects=[
 'درک عمومی ریاضی و فیزیک و آمار',
 'زیستشناسی و فناوریهای نوین زیستی',
 'فیزیک ۳ و آزمایشگاه پیشرفته',
 'شیمی ۲',
 'ادبیات فارسی ۳',
 'عربی زبان قرآن ۳',
 'زبان خارجی ۳',
 'زمینشناسی',
 'ریاضیات گسسته و کاربردها',
 'جغرافیای ایران',
];
const chapters=[
 'فصل ۷: فناوریهای نوین زیستی و مهندسی ژنتیک',
 'فصل ۳: حد و پیوستگی و مشتقات پیشرفته',
 'فصل ۱: تابع و مثلثات',
 'فصل ۲: ژنتیک',
 'فصل ۵: از ماده به انرژی',
 'درس ۴: لغات و ترجمه',
 'فصل ۱: دنیای زنده',
 'مبحث آزاد',
];
const details=[
 'نکتههای مشاور: مرور فرمولهای پرتکرار و تمرینهای شب امتحان',
 'حتماً بعد از مطالعه، خلاصهنویسی کن',
 '',
 'تمرکز روی تستهای کنکور سالهای قبل',
 '',
 'زمان استراحت بین هر دو بخش فراموش نشود',
];
const durations=[30,45,60,90,120];
const targets=[8,12,20,25];
const expectedWeekdays=['پنجشنبه','جمعه','شنبه','یکشنبه','دوشنبه','سه\u200cشنبه','چهارشنبه'];

const weekly_plan_items=Array.from({length:35},(_,index)=>{
 const activity=activityTypes[index%activityTypes.length];
 const isTest=activity==='practice_tests';
 return {
  id:`item-${index}`,
  day_of_week:Math.floor(index/5),
  duration_minutes:durations[index%durations.length],
  subject:subjects[(index*3+Math.floor(index/5))%subjects.length],
  chapter:chapters[(index*5+Math.floor(index/5)*2)%chapters.length],
  activity_type:activity,
  target_test_count:isTest?targets[index%targets.length]:null,
  details:isTest?null:details[(index*2+Math.floor(index/5))%details.length],
  sort_order:index%5,
 };
});
const routines=Array.from({length:7},(_,dayOfWeek)=>({
 dayOfWeek,
 subject:subjects[(dayOfWeek*4+1)%subjects.length],
 details:details[(dayOfWeek+2)%details.length]||'توضیحی ثبت نشده',
}));
const plan={id:'plan-1',student_id:'student-1',week_start:'2026-10-22',title:'برنامه هفتگی نمونه',notes:'یادداشت کلی مشاور.',status:'published',routines,weekly_plan_items};
const props={plan,student:{full_name:'شیما حسین زاده',grade:12,study_field:'experimental_sciences'},counselorName:'مشاور نووا',backHref:'/dashboard/counselor/plans'};

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
 const fitScript=`<script>
 (function(){
  function fit(){
   document.querySelectorAll('.print-fit-text').forEach(function(el){
    var base=parseFloat(el.dataset.basePt||'8');
    var min=parseFloat(el.dataset.minPt||'5.5');
    var size=base;
    el.style.width='';el.style.maxWidth='';el.style.transform='';el.style.transformOrigin='';
    el.dataset.fitScale='1';
    el.style.fontSize=size+'pt';
    while(size>min&&el.scrollWidth>el.clientWidth+0.2){size-=0.15;el.style.fontSize=size+'pt';}
    el.dataset.fitSize=size.toFixed(2);
    if(el.scrollWidth>el.clientWidth+0.2){
     var ratio=el.clientWidth/el.scrollWidth;
     el.style.width=(100/ratio)+'%';
     el.style.maxWidth='none';
     el.style.transform='scaleX('+ratio+')';
     el.style.transformOrigin='right center';
     el.dataset.fitScale=ratio.toFixed(3);
    }
   });
  }
  window.fitPrintText=fit;
  window.addEventListener('beforeprint',fit);
  if(document.fonts&&document.fonts.ready)document.fonts.ready.then(fit);else window.addEventListener('load',fit);
 })();
 </script>`;
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH||'/tmp/chromium',args:['--no-sandbox','--disable-dev-shm-usage']});
 try{
  const page=await browser.newPage({viewport:{width:1123,height:794},deviceScaleFactor:2});
  await page.route('**/*',async route=>{
   const url=new URL(route.request().url());
   if(url.pathname==='/font.woff2')return route.fulfill({contentType:'font/woff2',body:fontFile});
   if(url.pathname!=='/')return route.abort();
   return route.fulfill({contentType:'text/html',body:`<!doctype html><html lang="fa" dir="rtl"><head><meta charset="utf-8"><style>${fontCss}\n${globalsCss}</style></head><body>${html}${fitScript}</body></html>`});
  });
  await page.goto('http://nova-routine.test/');
  await page.evaluate(()=>document.fonts.ready);
  await page.emulateMedia({media:'print'});
  await page.evaluate(()=>window.fitPrintText&&window.fitPrintText());
  await page.waitForTimeout(200);
  const checks=await page.evaluate(()=>{
   const root=document.querySelector('.a4-weekly-plan');
   const grid=document.querySelector('.print-week-grid');
   const dayColumns=[...document.querySelectorAll('.print-day-column')];
   const routines=[...document.querySelectorAll('.print-routine')];
   const activities=[...document.querySelectorAll('.print-activity:not(.print-routine):not(.print-activity-empty)')];
   const inside=(child,parent)=>{const a=child.getBoundingClientRect(),b=parent.getBoundingClientRect();return a.left>=b.left-1&&a.right<=b.right+1&&a.top>=b.top-1&&a.bottom<=b.bottom+1;};
   const clippedDetails=[...document.querySelectorAll('.print-activity')].flatMap(box=>[...box.children].filter(c=>getComputedStyle(c).display!=='none'&&!inside(c,box)).map(c=>({text:c.textContent.slice(0,30),rect:c.getBoundingClientRect().toJSON(),box:box.getBoundingClientRect().toJSON(),cls:c.className,style:c.getAttribute('style')})));
   const clipped=clippedDetails.length;
   const badFit=[...document.querySelectorAll('.print-fit-text')].filter(el=>{
    const cs=getComputedStyle(el);
    const fit=parseFloat(el.dataset.fitSize||'0');
    const scale=parseFloat(el.dataset.fitScale||'1');
    const parentW=el.parentElement.clientWidth;
    const visualW=el.getBoundingClientRect().width;
    return el.scrollWidth>el.clientWidth+0.5||visualW>parentW+0.5||cs.textOverflow==='ellipsis'||cs.whiteSpace!=='nowrap'||fit<5.4||scale>1.001;
   }).map(el=>({text:el.textContent,fit:el.dataset.fitSize,scale:el.dataset.fitScale,scroll:el.scrollWidth,client:el.clientWidth,visual:el.getBoundingClientRect().width,parent:el.parentElement.clientWidth}));
   return {
    pageOverflow:root.scrollHeight>root.clientHeight+2||root.scrollWidth>root.clientWidth+2,
    horizontalOverflow:document.documentElement.scrollWidth>innerWidth,
    columns:getComputedStyle(grid).gridTemplateColumns.split(' ').length,
    dayColumns:dayColumns.length,routines:routines.length,activities:activities.length,clipped,clippedDetails,badFit,
    routinePerDay:dayColumns.map(c=>c.querySelectorAll('.print-routine').length),
    routineWidth:routines[0]?.getBoundingClientRect().width,
    routineWeekdays:routines.map(box=>box.getAttribute('data-weekday')),
    dayHeadings:dayColumns.map(column=>column.querySelector('h2')?.textContent?.trim()),
    activityWidth:activities[0]?.getBoundingClientRect().width,
    firstSummary:document.querySelector('.print-activity-summary')?.textContent?.trim(),
    hasTargetText:[...document.querySelectorAll('.print-activity-summary')].some(el=>el.textContent.includes('هدف')),
    testLines:[...document.querySelectorAll('.print-activity-last.is-test')].map(el=>el.textContent.trim()),
    routineTitle:document.querySelector('.print-routine .print-activity-subject')?.textContent?.trim(),
    subjectBase:document.querySelector('.print-activity-subject')?.dataset.basePt,
   };
  });
  assert.equal(checks.pageOverflow,false,'A4 overflow');
  assert.equal(checks.horizontalOverflow,false,'horizontal overflow');
  assert.equal(checks.columns,7,'must remain seven day columns');
  assert.equal(checks.dayColumns,7);
  assert.equal(checks.routines,7,'exactly one routine per day');
  assert.deepEqual(checks.routinePerDay,[1,1,1,1,1,1,1]);
  assert.equal(checks.clipped,0,'clipped box');
  assert.deepEqual(checks.badFit,[],'no overflow, ellipsis, wrapping or under-minimum font');
  assert.ok(checks.routineWidth<checks.activityWidth,'routine must be slightly narrower');
  assert.match(checks.firstSummary,/^[۰-۹]+ دقیقه /,'third row starts with duration');
  assert.equal(checks.hasTargetText,false,'no extra target-test text in third row');
  assert.ok(checks.testLines.length>0,'test boxes exist');
  for(const line of checks.testLines)assert.match(line,/زده شده از [۰-۹]+ تست/);
  assert.equal(checks.routineTitle,'روتین');
  assert.deepEqual(checks.routineWeekdays,expectedWeekdays);
  assert.deepEqual(checks.dayHeadings,expectedWeekdays);
  assert.equal(checks.subjectBase,'10.5');
  await page.screenshot({path:path.join(os.tmpdir(),'nova-actual-print-font.png'),fullPage:false});
  const pdf=await page.pdf({path:path.join(os.tmpdir(),'nova-actual-print-font.pdf'),preferCSSPageSize:true,printBackground:true,displayHeaderFooter:false});
  assert.equal((pdf.toString('latin1').match(/\/Type\s*\/Page\b/g)||[]).length,1,'one A4 page');
  await page.close();
  console.log('Actual PrintWeeklyPlan: approved four-row layout, larger auto-fit fonts, no overflow/ellipsis/wrap, real weekdays, one A4 page.');
 }finally{await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1;});
