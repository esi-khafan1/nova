// Real planner and student cards, app CSS, and mocked server actions; no real accounts.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const esbuild = require('esbuild');
const {chromium} = require('playwright-core');
(async()=>{
 const css=['app/globals.css','app/student-panel.css','app/counselor-panel.css'].map(p=>fs.readFileSync(p,'utf8')).join('\n');
 const font=fs.readFileSync('public/fonts/estedad-arabic-wght-normal.woff2').toString('base64');
 const js=(await esbuild.build({stdin:{contents:`import React from 'react';import {createRoot} from 'react-dom/client';import {WeeklyPlanBuilder} from './components/dashboard/weekly-plan-builder';import {CounselorStudentCard} from './components/dashboard/counselor-student-card';
 const students=[{student_id:'student-a',full_name:'دانش‌آموز الف',grade:10,study_field:'humanities'},{student_id:'student-b',full_name:'دانش‌آموز ب',grade:9,study_field:null}];
 const root=createRoot(document.getElementById('root'));window.renderDirectory=()=>root.render(<div className="cp-student-grid">{students.map(s=><CounselorStudentCard key={s.student_id} student={s}/>)}</div>);window.renderEmpty=()=>root.render(<WeeklyPlanBuilder students={[]} plans={[]} completedItemIds={[]}/>);root.render(<WeeklyPlanBuilder students={students} plans={[]} completedItemIds={[]} initialStudentId="student-b"/>);`,resolveDir:process.cwd(),loader:'tsx'},bundle:true,platform:'browser',format:'iife',jsx:'automatic',write:false,plugins:[{name:'mocks',setup(build){
 build.onResolve({filter:/^(next\/link|@\/app\/dashboard\/(actions|counselor\/study-actions)|@\/components\/dashboard\/persian-date-picker)$/},a=>({path:a.path,namespace:'mock'}));
 build.onLoad({filter:/.*/,namespace:'mock'},a=>({contents:a.path==='next/link'?'import React from "react"; export default function Link({href,children,...props}){return React.createElement("a",{href,...props},children)}':a.path.includes('study-actions')?'export async function updateCounselorStudentStudy(data){window.studySaves.push(Object.fromEntries(data));return {success:true}}':a.path.includes('persian-date-picker')?'export const PersianDatePicker=()=>null;':'export const saveWeeklyPlan="/save"; export const saveCurrentWeeklyPlan=async()=>null;',loader:'js',resolveDir:process.cwd()}));
 }}]})).outputFiles[0].text;
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox']});
 try {for(const width of [320,390,768,1200]){
  const page=await browser.newPage({viewport:{width,height:900}});
  await page.setContent(`<html lang="fa" dir="rtl"><head><style>@font-face{font-family:'Estedad Variable';src:url(data:font/woff2;base64,${font})}${css}</style></head><body><main class="counselor-portal" style="max-width:1100px;margin:auto;padding:16px"><div id="root"></div></main><script>window.studySaves=[]</script></body></html>`);
  await page.addScriptTag({content:js});await page.evaluate(()=>document.fonts.ready);
  const select=page.locator('select[name=student_id]'), link=page.getByRole('link',{name:'گزارش دانش‌آموز'});
  assert.equal(await select.count(),1);assert.equal(await select.inputValue(),'student-b');assert.equal(await select.evaluate(e=>getComputedStyle(e.options[0]).color),'rgb(20, 38, 59)');assert.equal(await link.getAttribute('href'),'/dashboard/counselor/students/student-b');
  assert.equal(await page.locator('.counselor-study-details').count(),0,'study editor is not in the planner');
  assert.equal(await page.locator('form form').count(),0);
  assert.equal(await select.evaluate(e=>new FormData(e.form).get('student_id')),'student-b');
  await select.selectOption('student-a');assert.equal(await link.getAttribute('href'),'/dashboard/counselor/students/student-a');
  assert.equal(await select.evaluate(e=>new FormData(e.form).get('student_id')),'student-a');
  assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`planner overflow at ${width}`);
  const a=await select.boundingBox(),b=await link.boundingBox();assert.ok(a&&b&&a.x>=0&&a.x+a.width<=width&&b.x>=0&&b.x+b.width<=width,`controls in viewport ${width}`);
  await page.evaluate(()=>window.renderDirectory());
  const card=page.locator('#student-student-a'), other=page.locator('#student-student-b');
  assert.equal(await card.getByRole('link',{name:'برنامه‌ریزی'}).getAttribute('href'),'/dashboard/counselor/plans?student=student-a');
  assert.equal(await card.getByRole('link',{name:'گزارش'}).getAttribute('href'),'/dashboard/counselor/students/student-a');
  const study=card.locator('.counselor-study-details');assert.equal(await study.evaluate(e=>e.open),false);
  await study.locator('summary').click();assert.equal(await other.locator('details').evaluate(e=>e.open),false);
  await study.locator('select').first().selectOption('9');assert.equal(await study.locator('select').count(),1);
  await study.getByRole('button',{name:'ثبت اطلاعات تحصیلی'}).click();await page.waitForFunction(()=>window.studySaves.length===1);
  assert.deepEqual(await page.evaluate(()=>window.studySaves[0]),{student_id:'student-a',grade:'9',study_field:''});
  assert.ok(await study.getByText('اطلاعات تحصیلی ثبت شد.').isVisible());
  await other.locator('summary').click();const otherStudy=other.locator('details');
  await otherStudy.locator('select').first().selectOption('11');await otherStudy.locator('select').nth(1).selectOption('humanities');
  await otherStudy.getByRole('button',{name:'ثبت اطلاعات تحصیلی'}).click();await page.waitForFunction(()=>window.studySaves.length===2);
  assert.deepEqual(await page.evaluate(()=>window.studySaves[1]),{student_id:'student-b',grade:'11',study_field:'humanities'});
  assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`directory overflow at ${width}`);
  for(const control of await study.locator('select,button').all()){const box=await control.boundingBox();assert.ok(box&&box.x>=0&&box.x+box.width<=width,`study editor in viewport ${width}`)}
  if(process.env.TEST_SCREENSHOT)await page.screenshot({path:`${process.env.TEST_SCREENSHOT}-${width}.png`});
  await page.evaluate(()=>window.renderEmpty());assert.ok(await page.getByText('هنوز دانش‌آموزی به شما اختصاص داده نشده است').isVisible());assert.equal(await page.locator('select[name=student_id]').count(),0);
  await page.close();
 }}finally{await browser.close()}
 console.log('PASS: selected student, report link, plan form data, study editor and responsive layout.');
})().catch(e=>{console.error(e);process.exitCode=1});
