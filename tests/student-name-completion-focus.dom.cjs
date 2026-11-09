const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const {JSDOM} = require('jsdom');
const dom = new JSDOM('<!doctype html><div id="root"></div>', {url:'https://nova.test/dashboard/student/account#student-full-name',pretendToBeVisual:true});
global.window = dom.window; global.document = dom.window.document; global.navigator = dom.window.navigator; global.IS_REACT_ACT_ENVIRONMENT = true;
const {createRoot} = require('react-dom/client');
const {act} = React;
const deps = {
  react: React, 'react/jsx-runtime': require('react/jsx-runtime'),
  'next/link': {default: ({children,...props}) => React.createElement('a',props,children)},
  '@/lib/course-offers': {defaultCourseOffers:[]}, './course-price': {CoursePrice:()=>null},
  '@/app/dashboard/registration/actions': {submitRegistration:async()=>({})},
  '@/lib/courses': {courseTypeLabel:()=>'',courseDurationLabel:()=>''},
  '@/lib/study-catalog': {studyFieldLabels:{}}, '@/components/registration/province-city-fields': {ProvinceCityFields:()=>null},
};
function load(path) {
 const mod={exports:{}};
 const code=ts.transpileModule(fs.readFileSync(path,'utf8'),{fileName:path,compilerOptions:{jsx:ts.JsxEmit.ReactJSX,module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText;
 vm.runInThisContext(`(function(require,module,exports){${code}\n})`)(name=>{if(!(name in deps))throw Error(name);return deps[name];},mod,mod.exports);
 return mod.exports;
}
const Notice=load('components/dashboard/student-profile-completion-notice.tsx').StudentProfileCompletionNotice;
const Form=load('components/registration/registration-form.tsx').RegistrationForm;
const registration=load('lib/registration.ts');
const waitFrame=()=>new Promise(resolve=>window.requestAnimationFrame(resolve));
const root=createRoot(document.getElementById('root'));
let opened=0;
window.HTMLDialogElement.prototype.showModal=function(){opened++;this.setAttribute('open','')};
window.HTMLDialogElement.prototype.close=function(){this.removeAttribute('open')};
function page(onRegistrationPage=false){return React.createElement(React.Fragment,null,
 React.createElement(Notice,{issue:'نام و نام خانوادگی را کامل وارد کن.',focusName:true,onAccountPage:!onRegistrationPage,onRegistrationPage}),
 React.createElement(Form,{mode:onRegistrationPage?'enrollment':'profile',values:{}}));}
(async()=>{
 await act(async()=>{root.render(page());});await act(waitFrame);
 const field=document.getElementById('student-full-name');
 assert.equal(field.required,true);assert.equal(document.activeElement,field);assert.equal(field.checkValidity(),false);
 assert.equal(opened,0,'The completion popup must not hide the destination form.');
 assert.equal(document.querySelector('a').getAttribute('href'),'#student-full-name');
 assert.match(registration.validateRegistration({full_name:'',grade:10,study_field:'humanities',province:'تهران',city:'تهران'},true),/نام و نام خانوادگی/);
 assert.match(registration.validateRegistration({full_name:'نیما',grade:10,study_field:'humanities',province:'تهران',city:'تهران'},true),/نام و نام خانوادگی/);
 assert.equal(registration.validateRegistration({full_name:'نیما رضایی',grade:10,study_field:'humanities',province:'تهران',city:'تهران'},true),null);
 await act(async()=>root.unmount());
 window.history.replaceState(null,'','/dashboard/registration');
 const root2=createRoot(document.getElementById('root'));
 await act(async()=>root2.render(page(true)));
 assert.equal(document.querySelector('dialog').open,true);
 assert.equal(document.querySelector('dialog a').getAttribute('href'),'#student-full-name');
 await act(async()=>{document.querySelector('dialog a').click();await waitFrame();});
 assert.equal(document.querySelector('dialog').open,false);
 assert.equal(document.activeElement,document.getElementById('student-full-name'));
 await act(async()=>root2.unmount());dom.window.close();console.log('PASS: required full name, account and enrollment links focus the name field without repeating the popup');
})().catch(error=>{console.error(error);process.exitCode=1});
