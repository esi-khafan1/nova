// Browser regression: pass CHROMIUM_PATH and install playwright-core separately.
// Renders the real settings page with local fixtures; never calls a live service.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const {renderToStaticMarkup} = require('react-dom/server');
const {chromium} = require('playwright-core');
function load(path, deps) {
 const code = ts.transpileModule(fs.readFileSync(path,'utf8'), {fileName:path,compilerOptions:{jsx:ts.JsxEmit.ReactJSX,module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText;
 const mod = {exports:{}};
 vm.runInThisContext('(function(require,module,exports){'+code+'\n})',{filename:path})(name=>Object.hasOwn(deps,name)?deps[name]:require(name),mod,mod.exports);
 return mod.exports;
}
(async()=>{
 assert.ok(process.env.CHROMIUM_PATH,'Set CHROMIUM_PATH to a Chromium executable');
 const offers=[9,10,11,12].flatMap(grade=>['base','progress'].map(plan=>({grade,plan,discount_percent:15,monthly_price:2700000,reservation:true,sold_out:false})));
 const Link={__esModule:true,default:({href,children,...rest})=>React.createElement('a',{href,...rest},children)};
 const shell=load('components/dashboard/dashboard-shell.tsx',{
  'next/link':Link, '@/components/logo':{Logo:()=>React.createElement('span',null,'نوا')},
  '@/components/landing-header':{LandingHeader:()=>null}, '@/app/landing-approved.css':{}, '@/app/student-panel.css':{},
  '@/app/courses.css':{}, '@/app/counselor-panel.css':{}, '@/app/exam-panel-refresh.css':{}, '@/app/dashboard/actions':{signOut:async()=>{}},
 });
 const offerLib=load('lib/course-offers.ts',{});
 const offerForm=load('components/dashboard/course-offer-form.tsx',{'@/lib/course-offers':offerLib,'@/app/dashboard/admin/courses/actions':{saveCourseOffer:async()=>{}}});
 const {default:Page}=load('app/dashboard/admin/courses/page.tsx',{
  'next/link':Link, '@/components/dashboard/dashboard-shell':shell, '@/components/dashboard/course-offer-form':offerForm,
  '@/lib/load-course-offers':{loadCourseOffers:async()=>offers},
  '@/lib/super-admin':{requireSuperAdmin:async()=>({profile:{full_name:'Test'}})},
  './actions':{saveCourseReservation:async()=>{}},'./settings.css':{},
 });
 const html=renderToStaticMarkup(await Page({searchParams:Promise.resolve({saved:'1'})}));
 const css=['app/globals.css','app/landing-approved.css','app/student-panel.css','app/courses.css','app/counselor-panel.css','app/exam-panel-refresh.css','app/dashboard/admin/courses/settings.css'].map(f=>fs.readFileSync(f,'utf8')).join('\n');
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox'],headless:true});
 try {
  for(const scheme of ['light','dark']) for(const width of [1440,1200,768,390,320]) {
   const page=await browser.newPage({colorScheme:scheme,viewport:{width,height:900}});
   await page.setContent(`<html lang="fa" dir="rtl"><head><style>${css}</style></head><body>${html}</body></html>`);
   const cards=page.locator('.course-settings-sections > .portal-card');
   assert.equal(await cards.count(),2,'the two settings cards are present');
   const first=await cards.nth(0).boundingBox(), second=await cards.nth(1).boundingBox();
   assert.ok(first && second);
   assert.ok(Math.abs(second.y-(first.y+first.height)-20)<0.1,`status and pricing cards must have a 20px gap at ${width}px/${scheme}`);
   assert.ok(Math.abs(first.x-second.x)<0.1 && Math.abs(first.width-second.width)<0.1,'cards stay aligned');
   assert.ok(await page.locator('.portal-alert.success').isVisible(),'saved state does not collapse spacing');
   const select=page.locator('.course-settings-status select');
   assert.equal(await select.inputValue(),'reservation');
   const options=await select.locator('option').evaluateAll(elements=>elements.map(el=>({label:el.textContent,value:el.value,color:getComputedStyle(el).color,background:getComputedStyle(el).backgroundColor,font:getComputedStyle(el).fontFamily})));
   assert.deepEqual(options.map(o=>o.label),['ثبت‌نام','رزرو','تکمیل ظرفیت']);
   for(const option of options) {assert.equal(option.color,'rgb(24, 38, 58)');assert.equal(option.background,'rgb(255, 255, 255)');assert.match(option.font,/Tahoma/);}
   assert.equal(await select.evaluate(el=>getComputedStyle(el).colorScheme),'light');
   await select.focus();await page.keyboard.press('ArrowDown');
   assert.equal(await select.inputValue(),'sold_out','keyboard can select full capacity');
   assert.equal(await select.evaluate(el=>new FormData(el.form).get('reservation')),'sold_out','the form submits the chosen value');
   await page.keyboard.press('ArrowUp');assert.equal(await select.inputValue(),'reservation');
   await select.selectOption('sale');assert.equal(await select.inputValue(),'sale');
   if(process.env.SELECT_SCREENSHOT) { await select.click();await page.screenshot({path:`${process.env.SELECT_SCREENSHOT}-${scheme}-${width}.png`}); }
   await page.close();
  }
 }finally{await browser.close();}
 console.log('PASS: course cards are separated and aligned on desktop/mobile; native status options remain readable and keyboard accessible in light/dark themes.');
})().catch(e=>{console.error(e);process.exitCode=1;});
