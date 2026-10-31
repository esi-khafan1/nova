const assert=require('node:assert/strict');
const fs=require('node:fs');
const vm=require('node:vm');
const ts=require('typescript');
const student='11111111-1111-4111-8111-111111111111';
const old='22222222-2222-4222-8222-222222222222';
const next='33333333-3333-4333-8333-333333333333';
let error=null;
const calls=[];
const supabase={async rpc(name,args){calls.push([name,args]);return {error}}};
const mod={exports:{}};
vm.runInNewContext(ts.transpileModule(fs.readFileSync('app/dashboard/admin/registrations/actions.ts','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText,{
  module:mod,exports:mod.exports,FormData,String,
  require(name){
    if(name==='next/cache')return {revalidatePath:()=>{}};
    if(name==='next/navigation')return {redirect:url=>{throw new Error(url)}};
    if(name==='@/lib/auth')return {requireProfile:async roles=>{assert.deepEqual(Array.from(roles),['admin']);return {supabase}}};
    if(name==='@/lib/registration')return {receiptImageType:()=>null};
    throw Error(name);
  },
});
const form=(changes={})=>{const fd=new FormData();for(const [k,v] of Object.entries({student_id:student,expected_counselor_id:old,counselor_id:next,...changes}))fd.set(k,v);return fd};
(async()=>{
  await assert.rejects(mod.exports.disableStudent(form()),/disabled=1/);
  assert.equal(calls[0][0],'admin_disable_student');
  assert.equal(calls[0][1].expected_counselor_id,old);
  await assert.rejects(mod.exports.disableStudent(form({expected_counselor_id:''})),/disabled=1/);
  assert.equal(calls[1][1].expected_counselor_id,null);
  await assert.rejects(mod.exports.resumeStudent(form()),/resumed=1/);
  assert.equal(calls[2][0],'admin_resume_student');
  await assert.rejects(mod.exports.changeStudentCounselor(form()),/reassigned=1/);
  assert.equal(calls[3][0],'admin_change_student_counselor');
  assert.equal(calls[3][1].expected_counselor_id,old);
  const n=calls.length;
  await assert.rejects(mod.exports.disableStudent(form({student_id:'bad'})),/error=disable/);
  await assert.rejects(mod.exports.resumeStudent(form({counselor_id:''})),/error=resume/);
  await assert.rejects(mod.exports.changeStudentCounselor(form({counselor_id:old})),/error=reassign/);
  assert.equal(calls.length,n,'invalid or same-counselor requests never reach the database');
  error={message:'stale'};
  await assert.rejects(mod.exports.changeStudentCounselor(form()),/error=reassign/);
  await assert.rejects(mod.exports.disableStudent(form()),/error=disable/);
  await assert.rejects(mod.exports.resumeStudent(form()),/error=resume/);
  console.log('PASS: admin-only actions use guarded RPCs, reject invalid inputs and return appropriate stale/error feedback');
})().catch(e=>{console.error(e);process.exitCode=1});
