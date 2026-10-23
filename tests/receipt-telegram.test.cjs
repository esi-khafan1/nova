const assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm'),ts=require('typescript');
const React=require('react'),{renderToStaticMarkup}=require('react-dom/server');
const m={exports:{}};
const deps={react:React,'react/jsx-runtime':require('react/jsx-runtime'),
 './course-price':{CoursePrice:()=>null},
 '@/app/dashboard/registration/actions':{submitRegistration:async()=>({})},
 '@/lib/courses':{courseTypeLabel:()=>'',courseDurationLabel:()=>''},
 '@/lib/study-catalog':{studyFieldLabels:{}},
 '@/components/registration/province-city-fields':{ProvinceCityFields:()=>null},
};
vm.runInNewContext(ts.transpileModule(fs.readFileSync('components/registration/registration-form.tsx','utf8'),{fileName:'form.tsx',compilerOptions:{jsx:ts.JsxEmit.ReactJSX,module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText,{module:m,exports:m.exports,require(name){if(!deps[name])throw Error(name);return deps[name];}});
const values={full_name:'Test Student',phone:'',telegram_id:'',grade:12,study_field:'mathematics',province:'',city:'',additional_notes:''};
const render=mode=>renderToStaticMarkup(React.createElement(m.exports.RegistrationForm,{mode,values}));
const enrollment=render('enrollment');
assert.match(enrollment,/href="https:\/\/t.me\/NovaAcademy_Poshtibani"/);
assert.match(enrollment,/@NovaAcademy_Poshtibani/);assert.match(enrollment,/روش جایگزین ارسال فیش/);assert.ok(enrollment.includes('فیش واریزی را برای این آیدی نیز می‌توانید ارسال بکنید تا خیال راحت تری داشته باشید'));assert.ok(!enrollment.includes('ارسال فیش به‌تنهایی خدمات را فعال نمی‌کند'));
assert.match(enrollment,/target="_blank" rel="noopener noreferrer"/);
assert.match(enrollment,/type="file"[^>]*required=""/);
assert.ok(!render('profile').includes('https://t.me/NovaAcademy_Poshtibani'));
console.log('Enrollment-only direct Telegram receipt link, safe new tab, handle text and unchanged required in-site upload passed.');
