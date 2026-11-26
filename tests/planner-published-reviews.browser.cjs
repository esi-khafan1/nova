// Actual daily review UI against synthetic RPC responses only.
const assert=require('node:assert/strict'),fs=require('node:fs'),esbuild=require('esbuild'),{chromium}=require('playwright-core');
(async()=>{
 const result=await esbuild.build({stdin:{contents:`import React from 'react';import {createRoot} from 'react-dom/client';import {PlannerPublishedReviews} from './components/dashboard/planner-published-reviews';const root=createRoot(document.getElementById('root'));window.show=(canToggle=true,week='2026-11-03')=>root.render(<PlannerPublishedReviews key={week+canToggle} studentId="student" weekStart={week} canToggle={canToggle}/>);window.show();`,resolveDir:process.cwd(),loader:'tsx'},bundle:true,platform:'browser',format:'iife',jsx:'automatic',write:false,outdir:'virtual-reviews-browser',plugins:[{name:'mock-client',setup(b){b.onResolve({filter:/^@\/lib\/supabase\/client$/},()=>({path:'client',namespace:'mock'}));b.onLoad({filter:/.*/,namespace:'mock'},()=>({loader:'js',contents:'export function createClient(){return {rpc:window.mockRpc}}'}));}}]});
 const js=result.outputFiles.find(x=>x.path.endsWith('.js')).text,css=result.outputFiles.find(x=>x.path.endsWith('.css')).text;
 const font=fs.readFileSync('public/fonts/estedad-arabic-wght-normal.woff2').toString('base64');
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox']});
 try{for(const width of [320,390,768,1200]){
  const page=await browser.newPage({viewport:{width,height:900}}),errors=[];page.on('pageerror',e=>errors.push(e.message));
  await page.setContent(`<html dir="rtl" lang="fa"><head><style>@font-face{font-family:Estedad;src:url(data:font/woff2;base64,${font})}*{box-sizing:border-box}body{font-family:Estedad,sans-serif;margin:0;padding:16px}${css}</style></head><body><div id="root"></div></body></html>`);
  await page.evaluate(()=>{window.calls=[];window.checked=false;window.fail=false;window.empty=false;window.mockRpc=async(name,args)=>{window.calls.push({name,args});if(name==='planner_review_today_v2')return {data:window.empty?[]:[{item_id:'item',due_date:'2026-11-04',offset:3,subject:'زیست',chapter:'فصل اول',topics:[{title:'گفتار اول'}],review:{offset:3,kind:'specialist',reading:true,practice:true},completed:window.checked}],error:null};if(name==='planner_spaced_reviews_week')return {data:[],error:null};if(window.fail)return {error:{code:'42501'}};if(name==='planner_set_review_today_v2')window.checked=args.target_completed;return {data:null,error:null}}});
  await page.addScriptTag({content:js});await page.getByText('گفتار اول',{exact:false}).waitFor();
  const boxes=page.locator('input[type=checkbox]');assert.equal(await boxes.count(),1);assert.ok(await page.getByText(/خواندن جمع‌بندی و زدن تست‌های مارکدار/).isVisible());await boxes.first().check();await page.waitForFunction(()=>window.checked);await page.waitForFunction(()=>document.querySelector('input[type=checkbox]')?.checked);assert.equal((await page.evaluate(()=>window.calls.find(c=>c.name==='planner_set_review_today_v2').args)).target_item_id,'item');
  await page.evaluate(()=>{window.fail=true});await boxes.first().click();await page.getByRole('alert').waitFor();assert.equal(await boxes.first().isChecked(),true);
  assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`overflow ${width}`);
  await page.evaluate(()=>window.show(false));await page.getByText('گفتار اول',{exact:false}).waitFor();assert.equal(await page.locator('input[type=checkbox]').first().isDisabled(),true);
  await page.evaluate(()=>{window.empty=true;window.show(true,'2026-11-04')});await page.waitForFunction(()=>!document.querySelector('[aria-label="مرورهای امروز"]'));
  assert.deepEqual(errors,[]);await page.close();
 }}finally{await browser.close()};console.log('PASS: today reviews use one combined row, one tick, read-only counselor and failure recovery at four widths');
})().catch(e=>{console.error(e);process.exitCode=1});
