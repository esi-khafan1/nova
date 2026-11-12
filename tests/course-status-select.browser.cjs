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
 const {default:Page}=load('app/dashboard/admin/courses/page.tsx',{
  'next/link':{__esModule:true,default:({href,children,...rest})=>React.createElement('a',{href,...rest},children)},
  '@/components/dashboard/dashboard-shell':{DashboardShell:({children})=>React.createElement('div',{className:'portal-shell'},children)},
  '@/components/dashboard/course-offer-form':{CourseOfferForm:()=>null},
  '@/lib/load-course-offers':{loadCourseOffers:async()=>offers},
  '@/lib/super-admin':{requireSuperAdmin:async()=>({profile:{full_name:'Test'}})},
  './actions':{saveCourseReservation:async()=>{}},'./settings.css':{},
 });
 const html=renderToStaticMarkup(await Page({searchParams:Promise.resolve({})}));
 const css=fs.readFileSync('app/globals.css','utf8')+'\n'+fs.readFileSync('app/dashboard/admin/courses/settings.css','utf8');
 const browser=await chromium.launch({executablePath:process.env.CHROMIUM_PATH,args:['--no-sandbox'],headless:true});
 try {
  for(const scheme of ['light','dark']) for(const width of [1200,390]) {
   const page=await browser.newPage({colorScheme:scheme,viewport:{width,height:900}});
   await page.setContent(`<html lang="fa" dir="rtl"><head><style>${css}</style></head><body>${html}</body></html>`);
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
 console.log('PASS: native course status options have explicit readable colors and font in light/dark browser themes, and keyboard selection works.');
})().catch(e=>{console.error(e);process.exitCode=1;});
