const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const jsx = (type, props) => ({type, props});
function load(path, deps) {
 const mod={exports:{}};
 const code=ts.transpileModule(fs.readFileSync(path,'utf8'),{fileName:path,compilerOptions:{jsx:ts.JsxEmit.ReactJSX,module:ts.ModuleKind.CommonJS}}).outputText;
 vm.runInNewContext(code,{module:mod,exports:mod.exports,require(name){if(name==='react/jsx-runtime')return {jsx,jsxs:jsx};if(name in deps)return deps[name];throw Error(name);}});
 return mod.exports;
}
function nodes(value, out=[]) {
 if(Array.isArray(value)) value.forEach(v=>nodes(v,out));
 else if(value && typeof value==='object' && 'props' in value){out.push(value);nodes(value.props.children,out);}
 return out;
}
function text(value){if(Array.isArray(value))return value.map(text).join('');if(value && typeof value==='object'&&'props'in value)return text(value.props.children);return typeof value==='string'?value:'';}
const selected={grade:10,field:'humanities',course:'base',months:3};
const form=()=>null, link=()=>null;
async function registration(offers, status='pending') {
 const {default:Page}=load('app/dashboard/registration/page.tsx',{
  '@/lib/load-course-offers':{loadCourseOffers:async()=>offers},
  '@/lib/phone-auth':{hasConfirmedContact:()=>true,verifiedMobileForAccount:()=>null},
  'next/link':{default:link}, 'next/navigation':{redirect:()=>{throw Error('redirect');}},
  '@/components/dashboard/dashboard-shell':{DashboardShell:()=>null},
  '@/lib/auth':{requireProfile:async()=>({supabase:{},profile:{registration_status:status,full_name:'Test'}})},
  '@/lib/supabase/request-auth':{getRequestUser:async()=>({user:{}})}, '@/lib/return-path':{safeReturnPath:x=>x},
  '@/lib/courses':{parseCourseSelection:()=>selected,courseRegistrationPath:()=>'/dashboard/registration',studentCourseCatalogPath:()=>'/courses'},
  '@/lib/load-student-account':{loadStudentAccount:async()=>({values:{grade:10,study_field:'humanities'},registration:{receipt_name:'old.png',course_type:'base'},error:false})},
  '@/components/registration/registration-form':{RegistrationForm:form}, '@/components/dashboard/student-profile-completion-notice':{StudentProfileCompletionNotice:()=>null},
  '@/lib/registration':{requiredStudentFieldsIssue:()=>null,requiredStudentNameIssue:()=>null},'@/app/registration.css':{},
 });
 return Page({searchParams:Promise.resolve({})});
}
async function details(offers) {
 const {default:Page}=load('app/courses/[grade]/[field]/[plan]/[months]/page.tsx',{
  '@/lib/load-course-offers':{loadCourseOffers:async()=>offers}, '@/components/registration/course-price':{CoursePrice:()=>null},
  'next/image':{default:()=>null},'next/link':{default:link},'next/navigation':{notFound:()=>{throw Error('not found');}},
  '@/lib/courses':{parseCourseSelection:()=>selected,parseCourseContext:()=>({}),courseCatalogPath:()=>'/courses',courseDurationLabel:()=>'',courseLandingPath:()=>'/#courses',courseRegistrationPath:()=>'/dashboard/registration?course=base'},
  '@/lib/course-plans':{getCoursePlan:()=>({label:'Base',summary:'',tagline:'',paragraphs:[],services:[],suitable:'',imageType:'base'})},
  '@/lib/study-catalog':{studyFieldLabels:{humanities:'انسانی'}},
 });
 return Page({params:Promise.resolve({}),searchParams:Promise.resolve({})});
}
(async()=>{
 const closed=[{sold_out:true,reservation:false}], sale=[{sold_out:false,reservation:false}], reserved=[{sold_out:false,reservation:true}];
 for(const offers of [closed,null]) {
  const page=await registration(offers);assert.ok(!nodes(page).some(n=>n.type===form),'no receipt/payment form on closed or unknown status');
  assert.match(text(page),/وجهی واریز نکن/);assert.doesNotMatch(text(page),/می‌توانی اطلاعات یا فیش همین درخواست را اصلاح/);
 }
 const r=await registration(closed);assert.match(text(r),/ظرفیت دوره‌ها تکمیل/);assert.match(text(r),/منتظر بررسی/,'existing pending request is preserved');
 for(const offers of [sale,reserved])assert.ok(nodes(await registration(offers)).some(n=>n.type===form));
 const closedDetails=await details(closed);assert.match(text(closedDetails),/ظرفیت دوره‌ها تکمیل/);assert.match(text(closedDetails),/وجهی واریز نکن/);
 assert.ok(!nodes(closedDetails).some(n=>n.type===link&&String(n.props.href).startsWith('/dashboard/registration')));
 for(const offers of [sale,reserved])assert.ok(nodes(await details(offers)).some(n=>n.type===link&&String(n.props.href).startsWith('/dashboard/registration')));
 const cards=fs.readFileSync('components/registration/course-cards.tsx','utf8');assert.match(cards,/offers\[0\]\.sold_out && <strong>تکمیل ظرفیت/);
 const admin=fs.readFileSync('app/dashboard/admin/courses/page.tsx','utf8');assert.match(admin,/requireSuperAdmin/);assert.match(admin,/<CourseStatusPicker/);
 const picker=fs.readFileSync('components/dashboard/course-status-picker.tsx','utf8');assert.match(picker,/value: "sold_out", label: "تکمیل ظرفیت"/);assert.match(picker,/name="reservation"/);
 console.log('PASS: closed/unknown registration has no payment form; details, pending and open/reservation states');
})().catch(e=>{console.error(e);process.exitCode=1;});
