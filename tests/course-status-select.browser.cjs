// Browser regression: pass CHROMIUM_PATH and install playwright-core separately.
// Renders the real settings page with local fixtures; never calls a live service.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const {renderToStaticMarkup} = require('react-dom/server');
const {chromium} = require('playwright-core');
const esbuild = require('esbuild');
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
 const picker=load('components/dashboard/course-status-picker.tsx',{});
 const {default:Page}=load('app/dashboard/admin/courses/page.tsx',{
  'next/link':Link, '@/components/dashboard/dashboard-shell':shell, '@/components/dashboard/course-offer-form':offerForm, '@/components/dashboard/course-status-picker':picker,
  '@/lib/load-course-offers':{loadCourseOffers:async()=>offers},
  '@/lib/super-admin':{requireSuperAdmin:async()=>({profile:{full_name:'Test'}})},
  './actions':{saveCourseReservation:async()=>{}},'./settings.css':{},
 });
 const html=renderToStaticMarkup(await Page({searchParams:Promise.resolve({saved:'1'})}));
 const css=['app/globals.css','app/landing-approved.css','app/student-panel.css','app/courses.css','app/counselor-panel.css','app/exam-panel-refresh.css','app/dashboard/admin/courses/settings.css'].map(f=>fs.readFileSync(f,'utf8')).join('\n');
 const client=esbuild.buildSync({stdin:{contents:`import React from 'react'; import {hydrateRoot} from 'react-dom/client'; import {CourseStatusPicker} from './components/dashboard/course-status-picker'; hydrateRoot(document.querySelector('.course-status-root'),React.createElement(CourseStatusPicker,{initialStatus:'reservation'}));`,resolveDir:process.cwd(),loader:'tsx'},bundle:true,platform:'browser',format:'iife',jsx:'automatic',write:false}).outputFiles[0].text;
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
   await page.addScriptTag({content:client});
   const picker=page.locator('.course-status-picker'), menu=picker.locator('details'), summary=picker.locator('summary');
   const options=picker.locator('.course-status-option');
   assert.match(await summary.innerText(),/رزرو/);
   await summary.click();
   assert.equal(await menu.getAttribute('open'),'');
   assert.deepEqual(await options.locator('span').allTextContents(),['ثبت‌نام','رزرو','تکمیل ظرفیت']);
   for(let i=0;i<3;i++) {
    assert.ok(await options.nth(i).isVisible());
    const style=await options.nth(i).evaluate(el=>({color:getComputedStyle(el).color,background:getComputedStyle(el).backgroundColor}));
    assert.ok(['rgb(24, 38, 58)','rgb(16, 42, 67)'].includes(style.color));
    assert.ok(['rgb(255, 255, 255)','rgb(238, 245, 255)'].includes(style.background));
   }
   if(process.env.SELECT_SCREENSHOT) await page.screenshot({path:`${process.env.SELECT_SCREENSHOT}-${scheme}-${width}.png`});
   await picker.getByLabel('تکمیل ظرفیت').click();
   assert.equal(await menu.getAttribute('open'),null,'choosing an option closes the menu');
   assert.match(await summary.innerText(),/تکمیل ظرفیت/);
   assert.equal(await summary.evaluate(el=>new FormData(el.closest('form')).get('reservation')),'sold_out');
   await summary.focus();await page.keyboard.press('Enter');
   assert.equal(await menu.getAttribute('open'),'');
   await picker.getByRole('radio',{name:'رزرو',exact:true}).focus();await page.keyboard.press('Space');
   assert.match(await summary.innerText(),/رزرو/);
   await summary.focus();await page.keyboard.press('Enter');
   await picker.getByRole('radio',{name:'رزرو',exact:true}).focus();await page.keyboard.press('ArrowDown');
   assert.equal(await summary.evaluate(el=>new FormData(el.closest('form')).get('reservation')),'sold_out','radio arrow keys select an option');
   if (await menu.getAttribute('open') === null) { await summary.focus(); await page.keyboard.press('Enter'); }
   await page.keyboard.press('Escape');
   assert.equal(await menu.getAttribute('open'),null);assert.equal(await summary.evaluate(el=>document.activeElement===el),true);
   await page.close();
  }
 }finally{await browser.close();}
 console.log('PASS: course cards remain separated; the rendered status menu is readable, selectable and keyboard accessible in light/dark themes.');
})().catch(e=>{console.error(e);process.exitCode=1;});
