const assert=require('node:assert/strict');
const fs=require('node:fs');
const vm=require('node:vm');
const ts=require('typescript');
const student='11111111-1111-4111-8111-111111111111',counselor='22222222-2222-4222-8222-222222222222';
let error=null;const calls=[];
const supabase={
  from(name){assert.equal(name,'counselor_students');return {select:()=>({eq:()=>({limit:async()=>({data:[],error:null})})})};},
  async rpc(name,args){calls.push({name,args});return {error};},
};
const mod={exports:{}};
vm.runInNewContext(ts.transpileModule(fs.readFileSync('app/dashboard/admin/registrations/actions.ts','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText,{
  module:mod,exports:mod.exports,
  require(name){
    if(name==='next/cache')return {revalidatePath:()=>{}};
    if(name==='next/navigation')return {redirect:url=>{throw new Error(url)}};
    if(name==='@/lib/auth')return {requireProfile:async roles=>{assert.deepEqual(Array.from(roles),['admin']);return {supabase}}};
    if(name==='@/lib/registration')return {receiptImageType:()=>null};
    if(name==='@/lib/admin-final-course')return {parseAdminFinalCourse:(fd,prefix='')=>({course:fd.get(prefix+'service_course_type')||null,months:fd.get(prefix+'service_course_duration_months')?Number(fd.get(prefix+'service_course_duration_months')):null})};
    throw Error(name);
  },FormData,String,
});
const form=(receipt,extras={})=>{const fd=new FormData();for(const [k,v] of Object.entries({student_id:student,counselor_id:counselor,expected_receipt_path:receipt,...extras}))fd.set(k,v);return fd;};
(async()=>{
  await assert.rejects(mod.exports.activateStudent(form('student/receipt.jpg',{activation_mode:'manual',manual_confirmation:'on'})),/saved=1/);
  assert.equal(calls[0].name,'admin_activate_student_with_course');
  assert.equal(calls[0].args.expected_receipt_path,'student/receipt.jpg');
  assert.deepEqual(Object.keys(calls[0].args).sort(),['expected_receipt_path','target_counselor_id','target_course_duration_months','target_course_type','target_student_id']);
  await assert.rejects(mod.exports.activateStudent(form('',{service_course_type:'progress',service_course_duration_months:'6'})),/saved=1/);
  assert.equal(calls[1].args.target_course_type,'progress');
  assert.equal(calls[1].args.target_course_duration_months,6);
  assert.equal(calls[1].args.expected_receipt_path,null);
  await assert.rejects(mod.exports.activateStudent(form('',{student_id:'invalid'})),/error=1/);
  assert.equal(calls.length,2,'invalid identifiers must never reach the database');
  error={message:'stale receipt'};
  await assert.rejects(mod.exports.activateStudent(form('student/receipt.jpg')),/error=1/);
  error=null;
  await assert.rejects(mod.exports.changeStudentCourse(form('',{
    expected_service_course_type:'base',expected_service_course_duration_months:'3',
    service_course_type:'progress',service_course_duration_months:'6',
  })),/course_changed=1/);
  assert.equal(calls.at(-1).name,'admin_change_student_course');
  assert.deepEqual(JSON.parse(JSON.stringify(calls.at(-1).args)),{
    target_student_id:student,expected_course_type:'base',expected_course_duration_months:3,
    target_course_type:'progress',target_course_duration_months:6,
  });
  const before=calls.length;
  await assert.rejects(mod.exports.changeStudentCourse(form('',{
    expected_service_course_type:'base',expected_service_course_duration_months:'3',
    service_course_type:'base',service_course_duration_months:'3',
  })),/error=course-change/);
  assert.equal(calls.length,before,'unchanged selection must not reach RPC');
  await assert.rejects(mod.exports.assignCounselor(form('')),/assigned=1/);
  assert.equal(calls.at(-1).name,'admin_assign_student_counselor');
  console.log('PASS: admin action routes via one DB-authoritative activation RPC, requires fresh receipt, and keeps active-only assignment separate');
})().catch(e=>{console.error(e);process.exitCode=1});
