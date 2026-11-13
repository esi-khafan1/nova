// Real component, real app CSS and a mocked action; no network or real account.
// Install playwright-core and esbuild separately and set CHROMIUM_PATH.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const {chromium} = require('playwright-core');
const esbuild = require('esbuild');

(async () => {
 assert.ok(process.env.CHROMIUM_PATH, 'Set CHROMIUM_PATH to a Chromium executable');
 const css = ['app/globals.css','app/student-panel.css'].map(p => fs.readFileSync(p,'utf8')).join('\n');
 const font = fs.readFileSync('public/fonts/estedad-arabic-wght-normal.woff2').toString('base64');
 const client = (await esbuild.build({
  stdin: {contents:`import React from 'react'; import {createRoot} from 'react-dom/client';
   import {StudentPlanCheckbox} from './components/dashboard/student-plan-checkbox';
   createRoot(document.getElementById('control')).render(<StudentPlanCheckbox itemId="fixture" defaultChecked={true} canToggle={true} activityType="practice_tests" targetTestCount={8} defaultCompletedTestCount={1} defaultCompletedMinutes={null}/>);`,resolveDir:process.cwd(),loader:'tsx'},
  bundle:true,platform:'browser',format:'iife',jsx:'automatic',write:false,
  plugins:[{name:'stub-action',setup(build){build.onResolve({filter:/^@\/app\/dashboard\/actions$/},()=>({path:'action',namespace:'fixture'}));build.onLoad({filter:/.*/,namespace:'fixture'},()=>({contents:'export async function togglePlanItemCompletion(...args) { window.savedCalls.push(args); return {ok:true}; }',loader:'js'}));}}],
 })).outputFiles[0].text;
 const browser = await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox'],headless:true});
 try {
  for (const scheme of ['light','dark']) for (const width of [320,390,600,768,900,901,1200,1440]) {
   const page=await browser.newPage({viewport:{width,height:900},colorScheme:scheme});
   await page.setContent(`<html lang="fa" dir="rtl"><head><style>@font-face{font-family:'Estedad Variable';src:url(data:font/woff2;base64,${font}) format('woff2');font-weight:100 900}${css}</style></head><body><div class="student-portal"><main class="student-portal-main"><article class="sp-task"><div class="sp-task-heading"><div><span class="sp-tag">تست زنی</span><h3>آمار و احتمال</h3><p>پایه ۱۱ · فصل ۲: احتمال</p></div><div class="sp-task-result"><strong>۱۳٪ تحقق</strong><span>بخشی از هدف تست انجام شده</span></div></div><div class="sp-task-meta"><span>۹۰ دقیقه در برنامه</span><span>۱ از ۸ تست</span><span>زمان تست ثبت نشده؛ صفر حساب شده</span></div><div id="control"></div></article></main></div><script>window.savedCalls=[]</script></body></html>`);
   await page.addScriptTag({content:client});
   await page.evaluate(()=>document.fonts.ready);
   const group=page.locator('.student-test-count--tests'), labels=group.locator('label'), inputs=labels.locator('input'), check=page.locator('.student-plan-check');
   await group.waitFor();
   assert.equal(await labels.count(),2);
   const [a,b] = await Promise.all([inputs.nth(0).boundingBox(),inputs.nth(1).boundingBox()]);
   const groupBox=await group.boundingBox(), action=await check.boundingBox();
   assert.ok(a&&b&&groupBox&&action);
   assert.ok(Math.abs(a.y-b.y)<1,`inputs must align at ${width}`);
   assert.ok(Math.abs(a.width-b.width)<1 && a.width>=85,`equal, usable widths at ${width}`);
   assert.ok(b.x+b.width<=a.x+1,`inputs must stay side by side in RTL at ${width}`);
   assert.ok(action.x+action.width <= width && action.x >= 0,`checkbox stays in viewport at ${width}`);
   assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),`no page overflow at ${width}`);
   assert.ok(await group.locator('.student-progress-optional').isVisible());
   assert.equal(await inputs.nth(0).evaluate(el=>el.labels[0].innerText.trim()),'تست زده شده');
   assert.equal(await inputs.nth(1).evaluate(el=>el.labels[0].innerText.trim()),'مدت تست زنی');
   assert.ok(await page.getByText('مدت خالی یعنی صفر.',{exact:false}).isVisible());
   if(process.env.TEST_SCREENSHOT) await page.screenshot({path:`${process.env.TEST_SCREENSHOT}-${scheme}-${width}.png`});
   await check.locator('input').focus(); await page.keyboard.press('Tab');
   assert.equal(await inputs.nth(0).evaluate(el=>document.activeElement===el),true,'keyboard reaches count');
   await page.keyboard.press('Tab');
   assert.equal(await inputs.nth(1).evaluate(el=>document.activeElement===el),true,'keyboard reaches duration');
   // Real browser editing: blur saves both independent fields and clearing duration.
   await inputs.nth(1).fill('0:45'); await inputs.nth(1).blur();
   await page.waitForFunction(()=>window.savedCalls.length===1);
   assert.deepEqual(await page.evaluate(()=>window.savedCalls[0]),['fixture',true,1,45]);
   await inputs.nth(0).fill('5');await inputs.nth(0).blur();
   await page.waitForFunction(()=>window.savedCalls.length===2);
   assert.deepEqual(await page.evaluate(()=>window.savedCalls[1]),['fixture',true,5,45]);
   await inputs.nth(1).fill('');await inputs.nth(1).blur();
   await page.waitForFunction(()=>window.savedCalls.length===3);
   assert.deepEqual(await page.evaluate(()=>window.savedCalls[2]),['fixture',true,5,null]);
   await inputs.nth(1).fill('1:65');await inputs.nth(1).blur();
   assert.match(await group.locator('[role=alert]').innerText(),/ساعت:دقیقه/);
   assert.equal(await page.evaluate(()=>window.savedCalls.length),3,'invalid duration must not save');
   await page.close();
  }
 } finally { await browser.close(); }
 console.log('PASS: aligned test progress fields, readable help, no overflow, and real browser input/save behavior across eight viewport widths.');
})().catch(err=>{console.error(err);process.exitCode=1});
