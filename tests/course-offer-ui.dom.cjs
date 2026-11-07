const assert=require('node:assert/strict');
const fs=require('node:fs');
const vm=require('node:vm');
const ts=require('typescript');
const esbuild=require('esbuild');
const Module=require('module');
const React=require('react');
const {JSDOM}=require('jsdom');
const {renderToStaticMarkup}=require('react-dom/server');
function loadTs(path,deps) {
 const code=ts.transpileModule(fs.readFileSync(path,'utf8'),{fileName:path,compilerOptions:{jsx:ts.JsxEmit.ReactJSX,module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText;
 const mod={exports:{}};
 vm.runInThisContext('(function(require,module,exports){'+code+'\n})',{filename:path})(name=>name in deps?deps[name]:require(name),mod,mod.exports);
 return mod.exports;
}
function bundled(path){const text=esbuild.buildSync({entryPoints:[path],bundle:true,platform:'node',format:'cjs',write:false,tsconfig:'tsconfig.json'}).outputFiles[0].text;const m=new Module(path);m.filename=path;m.paths=module.paths;m._compile(text,path);return m.exports;}
(async()=>{
 const offersLib=bundled('lib/course-offers.ts'),courses=bundled('lib/courses.ts');
 const {CoursePrice}=loadTs('components/registration/course-price.tsx',{'@/lib/course-offers':offersLib,'@/lib/courses':courses,'./course-price.css':{}});
 let html=renderToStaticMarkup(React.createElement(CoursePrice,{selection:{grade:12,field:'humanities',course:'base',months:3},offers:offersLib.defaultCourseOffers}));
 assert.match(html,/۸٬۱۰۰٬۰۰۰/);assert.match(html,/۱۵٪ تخفیف/);
 const {RegistrationForm}=loadTs('components/registration/registration-form.tsx',{'@/lib/course-offers':offersLib,'@/lib/courses':courses,'./course-price':{CoursePrice},'@/app/dashboard/registration/actions':{submitRegistration:async()=>({})},'@/lib/study-catalog':{studyFieldLabels:{humanities:'انسانی'}},'@/components/registration/province-city-fields':{ProvinceCityFields:()=>null}});
 const offers=offersLib.defaultCourseOffers.map(o=>({...o,reservation:true}));
 html=renderToStaticMarkup(React.createElement(RegistrationForm,{values:{},selection:{grade:12,field:'humanities',course:'base',months:1},offers}));
 assert.match(html,/رزرو دوره/);assert.match(html,/ارسال اطلاعات و فیش برای رزرو/);assert.match(html,/6219861870360897/);assert.match(html,/type="file"[^>]*required/);
 const dom=new JSDOM('<!doctype html><div id="root"></div>',{url:'http://localhost'});global.window=dom.window;global.document=dom.window.document;global.navigator=dom.window.navigator;global.IS_REACT_ACT_ENVIRONMENT=true;
 const {createRoot}=require('react-dom/client');const {act}=React;
 const {CourseOfferForm}=loadTs('components/dashboard/course-offer-form.tsx',{'@/lib/course-offers':offersLib,'@/app/dashboard/admin/courses/actions':{saveCourseOffer:async()=>{}}});
 const root=createRoot(document.getElementById('root'));await act(async()=>root.render(React.createElement(CourseOfferForm,{offer:offers[6]})));
 const discount=document.querySelector('[name=discount]'),price=document.querySelector('[name=price]');assert.equal(discount.value,'15');assert.equal(price.value,'2700000');assert.equal(discount.step,'1');assert.equal(price.step,'10000');
 const setter=Object.getOwnPropertyDescriptor(dom.window.HTMLInputElement.prototype,'value').set;
 await act(async()=>{setter.call(discount,'20');discount.dispatchEvent(new dom.window.Event('input',{bubbles:true}));});
 assert.equal(price.value,'2560000');
 await act(async()=>{setter.call(price,'2570000');price.dispatchEvent(new dom.window.Event('input',{bubbles:true}));});
 assert.equal(price.value,'2570000');assert.equal(discount.value,'20');
 await act(async()=>root.unmount());dom.window.close();console.log('PASS: reservation and payment display, discount labels, live percentage calculation and manual price correction');
})().catch(e=>{console.error(e);process.exitCode=1});
