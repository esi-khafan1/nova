const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const { act } = React;
const { JSDOM } = require('jsdom');
const dom = new JSDOM('<div id="root"></div>', { url:'https://nova.test/dashboard/admin/registrations' });
global.window = dom.window; global.document = dom.window.document;
global.navigator = dom.window.navigator; global.FormData = dom.window.FormData;
global.IS_REACT_ACT_ENVIRONMENT = true;
const { createRoot } = require('react-dom/client');
const plans = [{ value:'base', label:'پلن پایه' }, { value:'progress', label:'پلن پریمیوم' }];
const durations = [1,3,6,12].map(value => ({ value, label:`${value} ماهه` }));
const courses = { courseDurations:durations,
  courseTypeLabel:value=>plans.find(plan=>plan.value===value)?.label ?? '',
  courseDurationLabel:value=>durations.find(duration=>duration.value===value)?.label ?? '' };
function load(file) {
  const mod={exports:{}};
  vm.runInNewContext(ts.transpileModule(fs.readFileSync(file,'utf8'),{
    compilerOptions:{module:ts.ModuleKind.CommonJS,jsx:ts.JsxEmit.ReactJSX,esModuleInterop:true}
  }).outputText, { module:mod,exports:mod.exports,FormData:dom.window.FormData,window:dom.window,
    require(name){if(name==='react')return React;if(name==='react/jsx-runtime')return require('react/jsx-runtime');
      if(name==='@/lib/course-plans')return {availableCoursePlans:plans};
      if(name==='@/lib/courses')return courses;
      throw Error(name);}
  });
  return mod.exports;
}
const { AdminFinalCoursePicker }=load('components/dashboard/admin-final-course-picker.tsx');
const { CourseChangeSubmitButton }=load('components/dashboard/course-change-submit-button.tsx');
const root=createRoot(document.querySelector('#root'));
const confirmations=[],alerts=[];
dom.window.confirm=message=>{confirmations.push(message);return false;};
dom.window.alert=message=>alerts.push(message);
(async()=>{
 await act(async()=>root.render(React.createElement('form',{onSubmit:event=>event.preventDefault()},
   React.createElement('input',{type:'hidden',name:'expected_service_course_type',value:'base',readOnly:true}),
   React.createElement('input',{type:'hidden',name:'expected_service_course_duration_months',value:'3',readOnly:true}),
   React.createElement(AdminFinalCoursePicker,{initialCourse:'base',initialMonths:3}),
   React.createElement(CourseChangeSubmitButton))));
 const course=()=>document.querySelector('[name=service_course_type]');
 const months=()=>document.querySelector('[name=service_course_duration_months]');
 const submit=()=>document.querySelector('button');
 assert.equal(months().value,'3');assert.equal(months().required,true);
 await act(async()=>submit().click());
 assert.equal(alerts.length,1,'unchanged selection is not submitted');
 assert.equal(confirmations.length,0);
 await act(async()=>{months().value='6';months().dispatchEvent(new dom.window.Event('change',{bubbles:true}));});
 await act(async()=>submit().click());
 assert.match(confirmations.at(-1),/پلن پایه \(3 ماهه\)[\s\S]*پلن پایه \(6 ماهه\)/);
 await act(async()=>{course().value='';course().dispatchEvent(new dom.window.Event('change',{bubbles:true}));});
 assert.equal(months().disabled,true,'blank plan disables duration');
 await act(async()=>submit().click());
 assert.match(confirmations.at(-1),/پلن پایه \(3 ماهه\)[\s\S]*بدون دورهٔ اختصاص‌یافته/);
 await act(async()=>{course().value='progress';course().dispatchEvent(new dom.window.Event('change',{bubbles:true}));});
 assert.equal(months().required,true);
 assert.equal(months().value,'','new plan requires a new duration');
 const before=confirmations.length;
 await act(async()=>submit().click());
 assert.equal(confirmations.length,before,'browser validation blocks incomplete course selection');
 await act(async()=>root.unmount());dom.window.close();
 console.log('PASS: admin correction confirms previous/new course, prevents unchanged and half-filled selections, allows clearing');
})().catch(error=>{console.error(error);process.exitCode=1;dom.window.close()});
