// Browser/PDF regression for the isolated print suite. Uses synthetic data only.
// Install playwright-core and Chromium separately; set CHROMIUM_PATH and NODE_PATH.
const assert=require('node:assert/strict');
const fs=require('node:fs');
const esbuild=require('esbuild');
const {chromium}=require('playwright-core');
(async()=>{
 const css=fs.readFileSync('components/dashboard/planner-print-suite.module.css','utf8');
 const names=['suite','controls','controlsHead','controlRow','choices','back','printButton','page','planPreview','paper','header','stats','table','bar','description','reviewColumns','reviewDay','reviewRow','box'];
 const suiteCss=css.replace(/:global\(([^)]+)\)/g,'$1');
 const globalCss=fs.readFileSync('app/globals.css','utf8');
 const font=fs.readFileSync('public/fonts/estedad-arabic-wght-normal.woff2').toString('base64');
 const bundle=await esbuild.build({absWorkingDir:process.cwd(),tsconfig:'tsconfig.json',stdin:{contents:`import React from 'react';import {createRoot} from 'react-dom/client';import {PlannerPrintSuite} from './components/dashboard/planner-print-suite';
 const item={id:'a',day_of_week:0,duration_minutes:90,subject:'زیست',chapter:'فصل یک',activity_type:'lesson',target_test_count:10,details:'',sort_order:0};
 const block={key:'a',dayOfWeek:0,durationMinutes:90,subject:'زیست',chapter:'فصل یک',activityType:'lesson',targetTestCount:10,details:'',topics:[{title:'گفتار اول'}]};
 const plan={id:'p',student_id:'s',week_start:'2026-11-03',title:'هفتهٔ نمونه',notes:null,status:'published',weekly_plan_items:[item]};
 const root=createRoot(document.getElementById('root'));const student={full_name:'دانش‌آموز',grade:12,study_field:'experimental_sciences'};
 window.renderRows=()=>root.render(<PlannerPrintSuite plan={plan} student={student} counselorName="مشاور" backHref="/back" sources={[]} completed={new Set()} reviewRows={[{key:'actual',date:'2026-11-04',offset:1,subject:'فیزیک',chapter:'ثبت‌شده',topics:[{title:'زیرمبحث'}],checked:true,historical:false,itemId:'actual',archiveId:null}]}/>);
 window.renderOriginal=()=>root.render(<PlannerPrintSuite plan={plan} student={student} counselorName="مشاور" backHref="/back" weekDetails={{goal:'تکمیل فصل اول',sleepTime:'23:00'}} sources={[{weekStart:'2026-11-03',blocks:[block]}]} completed={new Set([JSON.stringify(['2026-11-03','a',1])])} historical={[{archiveId:'old',date:'2026-11-04',offset:1,subject:'شیمی',chapter:'قبل',topics:[],completed:true}]}/>);
 window.renderDense=()=>{const rows=Array.from({length:70},(_,i)=>({key:'r'+i,itemId:'i'+i,archiveId:null,date:'2026-11-0'+(3+Math.floor(i/10)),offset:1,subject:'درس '+i,chapter:'فصل و متن بلند برای آزمون چاپ',topics:[{title:'مبحث '+i}],checked:i%2===0,historical:false}));root.render(<PlannerPrintSuite plan={plan} student={student} counselorName="مشاور" backHref="/back" sources={[]} completed={new Set()} reviewRows={rows}/>)};window.renderOriginal();`,resolveDir:process.cwd(),loader:'tsx'},bundle:true,format:'iife',platform:'browser',jsx:'automatic',write:false,plugins:[{name:'stubs',setup(b){b.onResolve({filter:/^next\/link$/},()=>({path:'link',namespace:'stub'}));b.onLoad({filter:/link/,namespace:'stub'},()=>({loader:'jsx',resolveDir:process.cwd(),contents:`import React from 'react';export default function Link({href,children,...rest}){return <a href={href} {...rest}>{children}</a>}`}));b.onResolve({filter:/planner-print-suite\.module\.css$/},()=>({path:'css',namespace:'stub'}));b.onLoad({filter:/css/,namespace:'stub'},()=>({loader:'js',contents:`export default ${JSON.stringify(Object.fromEntries(names.map(n=>[n,n])))};`}));}}]});
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox','--disable-dev-shm-usage']});
 try{for(const width of [320,390,768,1440]){
  const page=await browser.newPage({viewport:{width,height:1000},timezoneId:'Asia/Tehran'});const errors=[];page.on('pageerror',e=>errors.push(e.message));
  await page.setContent(`<html lang="fa" dir="rtl"><style>@font-face{font-family:Estedad;src:url(data:font/woff2;base64,${font})}body{font-family:Estedad,sans-serif}${globalCss}\n${suiteCss}</style><div id="root"></div></html>`);await page.addScriptTag({content:bundle.outputFiles[0].text});await page.evaluate(()=>document.fonts.ready);
  assert.equal(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),true,`page overflow ${width}`);
  assert.equal(await page.locator('[data-section]').count(),3);assert.ok(await page.getByText('تکمیل فصل اول').isVisible());assert.ok(await page.getByText('گفتار اول').first().isVisible());assert.equal(await page.locator('.reviewRow .box[aria-label="انجام شده"]').count(),2);
  await page.evaluate(()=>window.renderRows());await page.getByText('ثبت‌شده',{exact:false}).waitFor();assert.equal(await page.locator('.reviewRow').count(),1);assert.equal(await page.locator('.reviewRow .box[aria-label="انجام شده"]').count(),1);assert.ok(await page.getByText('زیرمبحث',{exact:false}).isVisible());
  await page.evaluate(()=>window.renderOriginal());await page.getByText('تکمیل فصل اول').waitFor();
  await page.getByLabel('برنامهٔ هفته').uncheck();assert.equal(await page.locator('[data-section="week"]').count(),0);
  await page.getByLabel('تحلیل برنامه').uncheck();await page.getByLabel(/جدول مرور/).uncheck();assert.equal(await page.getByRole('button',{name:'چاپ / ذخیره PDF'}).isDisabled(),true);
  await page.getByLabel('برنامهٔ هفته').check();await page.getByLabel('تحلیل برنامه').check();await page.getByLabel(/جدول مرور/).check();
  await page.emulateMedia({media:'print'});assert.equal(await page.locator('[data-section="analysis"]').isVisible(),true);assert.equal(await page.locator('[data-section="reviews"]').isVisible(),true);
  if(width===1440){
   await page.pdf({path:'/tmp/planner-print-suite.pdf',format:'A4',landscape:true,printBackground:true,preferCSSPageSize:true});
   if(process.env.TEST_SCREENSHOT)await page.screenshot({path:process.env.TEST_SCREENSHOT,fullPage:true});
   await page.emulateMedia({media:'screen'});
   for(const [name,selected] of [['week',[true,false,false]],['analysis',[false,true,false]],['reviews',[false,false,true]],['analysis-reviews',[false,true,true]]]){
    const labels=[page.getByLabel('برنامهٔ هفته'),page.getByLabel('تحلیل برنامه'),page.getByLabel(/جدول مرور/)];
    for(let i=0;i<labels.length;i++) await labels[i].setChecked(selected[i]);
    await page.emulateMedia({media:'print'});await page.pdf({path:`/tmp/planner-print-${name}.pdf`,format:'A4',landscape:true,printBackground:true,preferCSSPageSize:true});await page.emulateMedia({media:'screen'});
   }
   await page.evaluate(()=>window.renderDense());await page.waitForFunction(()=>document.querySelectorAll('.reviewRow').length===70);
   await page.getByLabel('برنامهٔ هفته').setChecked(false);await page.getByLabel('تحلیل برنامه').setChecked(false);await page.getByLabel(/جدول مرور/).setChecked(true);
   await page.emulateMedia({media:'print'});await page.pdf({path:'/tmp/planner-print-dense-reviews.pdf',format:'A4',landscape:true,printBackground:true,preferCSSPageSize:true});
  }
  assert.deepEqual(errors,[]);await page.close();
 }}finally{await browser.close()}
 const pdfjs=require('pdfjs-dist/legacy/build/pdf.js');const pdf=await pdfjs.getDocument({data:new Uint8Array(fs.readFileSync('/tmp/planner-print-dense-reviews.pdf')),disableFontFace:true}).promise;
 assert.equal(pdf.numPages,2,'dense review output should paginate without a blank page');
 for(let i=1;i<=pdf.numPages;i++){const content=await (await pdf.getPage(i)).getTextContent();assert.ok(content.items.length>0,`page ${i} must contain review text`)}
 console.log('PASS: print suite controls, dense PDF pagination, content and print visibility at four widths');
})().catch(e=>{console.error(e);process.exitCode=1});
