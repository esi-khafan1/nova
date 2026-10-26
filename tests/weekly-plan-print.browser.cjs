// Real print component + real global CSS; generates an A4 PDF in a mocked browser.
// No database, account change or external request is involved.
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');
const esbuild=require('esbuild');
const {chromium}=require('playwright-core');

const activityTypes=[
  'practice_tests','exam_analysis','simulation_exam','offline_class','textbook_reading',
];
const weekly_plan_items=Array.from({length:35},(_,index)=>({
  id:`item-${index}`,
  day_of_week:Math.floor(index/5),
  duration_minutes:90,
  subject:'زیست\u200cشناسی و آمار زیستی',
  chapter:'فصل سوم: ژنتیک، انتقال صفات و مسئله\u200cهای ترکیبی',
  activity_type:activityTypes[index%activityTypes.length],
  target_test_count:activityTypes[index%activityTypes.length]==='practice_tests'?40:null,
  details:'توضیح تکمیلی مشاور: مرور نکات، حل تمرین\u200cهای منتخب و ثبت نتیجه در دفتر پیگیری.',
  sort_order:index%5,
}));
const plan={
  id:'plan-1',student_id:'student-1',week_start:'2026-10-24',
  title:'برنامه هفتگی مطالعه و مرور',notes:'یادداشت کلی مشاور: تمرکز این هفته روی تثبیت مطالب و تحلیل دقیق آزمون\u200cهاست.',
  status:'published',weekly_plan_items,
};
const props={
  plan,
  student:{full_name:'نمونه دانش\u200cآموز',grade:12,study_field:'experimental_sciences'},
  counselorName:'مشاور نووا',backHref:'/dashboard/counselor/plans',
};

(async()=>{
 const stubs={
  'next/link':`import React from 'react';export default function Link({href,children,...rest}){return React.createElement('a',{href,...rest},children);}`,
  '@/components/dashboard/print-plan-button':`export function PrintPlanButton(){return null;}`,
 };
 const bundle=await esbuild.build({
  absWorkingDir:process.cwd(),tsconfig:'tsconfig.json',
  stdin:{contents:`import React from 'react';import {renderToStaticMarkup} from 'react-dom/server';import {PrintWeeklyPlan} from './components/dashboard/print-weekly-plan';const props=${JSON.stringify(props)};export const html=renderToStaticMarkup(React.createElement(PrintWeeklyPlan,props));`,resolveDir:process.cwd(),loader:'ts'},
  bundle:true,write:false,outfile:'/tmp/nova-print-component.cjs',platform:'node',format:'cjs',target:'node22',jsx:'automatic',
  plugins:[{name:'print-component-stubs',setup(build){
   build.onResolve({filter:/^(next\/link|@\/components\/dashboard\/print-plan-button)$/},args=>({path:args.path,namespace:'nova-print-stub'}));
   build.onLoad({filter:/.*/,namespace:'nova-print-stub'},args=>({contents:stubs[args.path],loader:'tsx',resolveDir:process.cwd()}));
  }}],
 });
 const compiled={exports:{}};
 new Function('module','exports','require',bundle.outputFiles[0].text)(compiled,compiled.exports,require);
 const html=compiled.exports.html;
 const globalsCss=fs.readFileSync(path.join(process.cwd(),'app/globals.css'),'utf8');
 const fontFile=fs.readFileSync(path.join(process.cwd(),'node_modules/@fontsource-variable/estedad/files/estedad-arabic-wght-normal.woff2'));
 const fontCss=`@font-face{font-family:'Estedad Variable';src:url('/font.woff2') format('woff2');font-style:normal;font-weight:100 900;font-display:swap}body{font-family:'Estedad Variable',sans-serif}`;
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH||'/tmp/chromium',args:['--no-sandbox','--disable-dev-shm-usage']});
 try{
  const page=await browser.newPage({viewport:{width:1123,height:794}});
  await page.route('**/*',async route=>{
   const requestUrl=new URL(route.request().url());
   if(requestUrl.pathname==='/font.woff2')return route.fulfill({contentType:'font/woff2',body:fontFile});
   if(requestUrl.pathname!=='/')return route.abort();
   return route.fulfill({contentType:'text/html',body:`<!doctype html><html lang="fa" dir="rtl"><head><meta charset="utf-8"><style>${fontCss}\n${globalsCss}</style></head><body>${html}</body></html>`});
  });
  await page.goto('http://nova-print.test/');
  await page.evaluate(()=>document.fonts.ready);
  await page.emulateMedia({media:'print'});
  const durations=await page.locator('.print-activity-title b').allInnerTexts();
  assert.equal(durations.length,35);
  assert.ok(durations.every(text=>/^۹۰ دقیقه$/u.test(text.trim())),'duration must be fully written in Persian digits');
  const typeSizes=await page.evaluate(()=>{
   const px=selector=>Number.parseFloat(getComputedStyle(document.querySelector(selector)).fontSize);
   return {duration:px('.print-activity-title b'),subject:px('.print-activity-title strong'),summary:px('.print-activity-summary'),footer:px('.print-plan-footer')};
  });
  assert.ok(typeSizes.duration>=14.5,`duration too small: ${typeSizes.duration}px`);
  assert.ok(typeSizes.subject>=14,`subject too small: ${typeSizes.subject}px`);
  assert.ok(typeSizes.summary>=12,`activity label too small: ${typeSizes.summary}px`);
  assert.ok(typeSizes.footer>=11,`footer too small: ${typeSizes.footer}px`);
  const geometry=await page.evaluate(()=>{
   const root=document.querySelector('.a4-weekly-plan');
   const articles=[...document.querySelectorAll('.print-activity:not(.print-activity-empty)')];
   const inside=(child,parent)=>{const a=child.getBoundingClientRect(),b=parent.getBoundingClientRect();return a.left>=b.left-1&&a.right<=b.right+1&&a.top>=b.top-1&&a.bottom<=b.bottom+1;};
   return {
    pageOverflow:root.scrollHeight>root.clientHeight+2||root.scrollWidth>root.clientWidth+2,
    clipped:articles.filter(article=>[...article.children].filter(child=>getComputedStyle(child).display!=='none').some(child=>!inside(child,article))).length,
    overlappingTitle:articles.filter(article=>{
     const subject=article.querySelector('.print-activity-title strong'),duration=article.querySelector('.print-activity-title b');
     const a=subject.getBoundingClientRect(),b=duration.getBoundingClientRect();
     return a.right>b.left&&b.right>a.left&&a.bottom>b.top&&b.bottom>a.top;
    }).length,
   };
  });
  assert.equal(geometry.pageOverflow,false,'A4 print page overflows');
  assert.equal(geometry.clipped,0,'an activity text block is clipped');
  assert.equal(geometry.overlappingTitle,0,'subject and full duration overlap');
  const pdf=await page.pdf({preferCSSPageSize:true,printBackground:true,displayHeaderFooter:false});
  const pdfText=pdf.toString('latin1');
  const pageObjects=(pdfText.match(/\/Type\s*\/Page\b/g)||[]).length;
  assert.equal(pageObjects,1,'weekly plan must remain one A4 landscape sheet');
  await page.close();
  console.log('Weekly-plan print: full «۹۰ دقیقه», larger computed type, no clipping/overlap, one A4 landscape page (35 dense activities).');
 }finally{await browser.close();}
})().catch(error=>{console.error(error);process.exitCode=1;});
