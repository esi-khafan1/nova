// Real print component + real global CSS; generates an A4 PDF in a mocked browser.
// Covers every activity type and deliberately long subject/chapter/detail strings.
// No database, account change or external request is involved.
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');
const esbuild=require('esbuild');
const {chromium}=require('playwright-core');

const activityTypes=[
  {value:'lesson',label:'مطالعه درسنامه'},
  {value:'textbook_reading',label:'خواندن کتاب درسی'},
  {value:'notes',label:'کار روی جزوه'},
  {value:'practice_tests',label:'تست زنی'},
  {value:'class',label:'کلاس'},
  {value:'offline_class',label:'آفلاین کلاس'},
  {value:'exam',label:'آزمون'},
  {value:'exam_analysis',label:'تحلیل آزمون'},
  {value:'simulation_exam',label:'آزمون شبیه ساز'},
  {value:'review',label:'مرور'},
  {value:'homework',label:'تمرین و تکلیف'},
  {value:'summary',label:'خلاصه\u200cنویسی'},
  {value:'other',label:'فعالیت دیگر'},
];
const longSubject='درک عمومی ریاضی و فیزیک و آمار و احتمال';
const longChapter='فصل ۳: توابع نمایی و لگاریتم، معادلات و نامعادلات و کاربردهای آن';
const longDetails='توضیح تکمیلی مشاور: مرور نکات، حل تمرین\u200cهای منتخب و ثبت نتیجه در دفتر پیگیری.';
const subjects=[longSubject,'خلاقیت تصویری و تجسمی','زبان تخصصی','آمار و احتمال','ریاضی'];
const chapters=[longChapter,'فصل ۲: احتمال',null,'مبحث آزاد','فصل ۱: مقدمات'];
const details=[longDetails,null,'توضیح کوتاه',longDetails,null];
const weekly_plan_items=Array.from({length:35},(_,index)=>{
 const activity=activityTypes[index%activityTypes.length];
 return {
  id:`item-${index}`,day_of_week:Math.floor(index/5),duration_minutes:90,
  subject:subjects[index%subjects.length],chapter:chapters[index%chapters.length],activity_type:activity.value,
  target_test_count:activity.value==='practice_tests'?(index%2?8:null):null,
  details:details[index%details.length],
  sort_order:index%5,
 };
});
const plan={
 id:'plan-1',student_id:'student-1',week_start:'2026-10-24',
 title:'برنامه هفتگی مطالعه و مرور',
 notes:'یادداشت کلی مشاور: تمرکز این هفته روی تثبیت مطالب، تحلیل دقیق آزمون\u200cها و مرور منظم است.',
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

  const bodyText=await page.locator('body').innerText();
  for(const activity of activityTypes)assert.ok(bodyText.includes(activity.label),`missing label: ${activity.label}`);
  assert.ok(bodyText.includes('زده شده:'));
  assert.ok(bodyText.includes(longSubject)&&bodyText.includes(longChapter),'long subject/chapter are missing');
  assert.ok(bodyText.includes('مبحث آزاد')&&bodyText.includes('انجام شد: ☐'),'empty chapter/detail states are missing');
  assert.ok(bodyText.includes('تست زنی'));
  assert.ok(!bodyText.includes('زدهشده')&&!bodyText.includes('زده\u200cشده'),'joined زدهشده remains');
  assert.ok(!bodyText.includes('تست\u200cزنی')&&!bodyText.includes('تستزنی'),'joined تستزنی remains');
  assert.ok(!bodyText.includes('…'),'ellipsis character remains in printed text');

  const durations=await page.locator('.print-activity-duration').allInnerTexts();
  assert.equal(durations.length,35);
  assert.ok(durations.every(text=>/^۹۰ دقیقه$/u.test(text.trim())),'duration must be fully written in Persian digits');

  const typeSizes=await page.evaluate(()=>{
   const px=selector=>Number.parseFloat(getComputedStyle(document.querySelector(selector)).fontSize);
   return {duration:px('.print-activity-duration'),subject:px('.print-activity-title strong'),summary:px('.print-activity-summary'),footer:px('.print-plan-footer')};
  });
  assert.ok(typeSizes.duration>=13,`duration too small: ${typeSizes.duration}px`);
  assert.ok(typeSizes.subject>=13,`subject too small: ${typeSizes.subject}px`);
  assert.ok(typeSizes.summary>=9.5,`activity label too small: ${typeSizes.summary}px`);
  assert.ok(typeSizes.footer>=9.5,`footer too small: ${typeSizes.footer}px`);

  const geometry=await page.evaluate(()=>{
   const root=document.querySelector('.a4-weekly-plan');
   const articles=[...document.querySelectorAll('.print-activity:not(.print-activity-empty)')];
   const inside=(child,parent)=>{const a=child.getBoundingClientRect(),b=parent.getBoundingClientRect();return a.left>=b.left-1&&a.right<=b.right+1&&a.top>=b.top-1&&a.bottom<=b.bottom+1;};
   const textNodes=[...document.querySelectorAll('.print-activity-title strong,.print-activity-chapter,.print-activity-summary,.print-activity-details,.print-activity-test-result')];
   const styles=textNodes.map(node=>{const s=getComputedStyle(node);return {textOverflow:s.textOverflow,whiteSpace:s.whiteSpace,overflow:s.overflow,lineClamp:s.webkitLineClamp,scrollWidth:node.scrollWidth,clientWidth:node.clientWidth};});
   return {
    pageOverflow:root.scrollHeight>root.clientHeight+2||root.scrollWidth>root.clientWidth+2,
    clippedArticles:articles.filter(article=>[...article.children].filter(child=>getComputedStyle(child).display!=='none').some(child=>!inside(child,article))).length,
    articleOverflow:articles.filter(article=>article.scrollHeight>article.clientHeight+2).length,
    rows:articles.map(article=>[...article.children].filter(child=>getComputedStyle(child).display!=='none').length),
    ellipsized:styles.filter(style=>style.textOverflow==='ellipsis'||style.whiteSpace!=='normal'||style.overflow!=='visible'||(style.lineClamp!=='none'&&style.lineClamp!=='unset')).length,
    horizontallyTruncated:styles.filter(style=>style.scrollWidth>style.clientWidth+1).length,
   };
  });
  assert.equal(geometry.pageOverflow,false,'A4 print page overflows');
  assert.equal(geometry.clippedArticles,0,'an activity text block is clipped by its box');
  assert.equal(geometry.articleOverflow,0,'an activity box overflows vertically');
  assert.ok(geometry.rows.every(count=>count===4),`every box must have exactly four rows: ${geometry.rows.join(',')}`);
  assert.equal(geometry.ellipsized,0,'a name or detail still has ellipsis/clamp/hidden overflow');
  assert.equal(geometry.horizontallyTruncated,0,'a name or detail is still horizontally truncated');

  const pdf=await page.pdf({preferCSSPageSize:true,printBackground:true,displayHeaderFooter:false});
  const pageObjects=(pdf.toString('latin1').match(/\/Type\s*\/Page\b/g)||[]).length;
  assert.equal(pageObjects,1,'weekly plan must remain one A4 landscape sheet');
  await page.close();
  console.log('Weekly-plan print: all 13 activity types, long names, no ellipsis/clipping, four rows per box, full «۹۰ دقیقه», one A4 page.');
 }finally{await browser.close();}
})().catch(error=>{console.error(error);process.exitCode=1;});
