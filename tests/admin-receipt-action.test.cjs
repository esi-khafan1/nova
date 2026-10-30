const assert=require('node:assert/strict');
const fs=require('node:fs');
const vm=require('node:vm');
const ts=require('typescript');
const student='11111111-1111-4111-8111-111111111111';
const old=`${student}/old.png`;
const next=`${student}/22222222-2222-4222-8222-222222222222.png`;
const calls=[];
let rpcError=null;
const bucket={
  async upload(...args){calls.push(['upload',...args]);return {error:null}},
  async remove(paths){calls.push(['remove',paths]);return {error:null}},
};
const supabase={
  storage:{from(name){assert.equal(name,'registration-receipts');return bucket}},
  async rpc(name,args){calls.push(['rpc',name,args]);return {error:rpcError}},
};
const moduleStub={exports:{}};
vm.runInNewContext(ts.transpileModule(fs.readFileSync('app/dashboard/admin/registrations/actions.ts','utf8'),{
  compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022},
}).outputText,{
  module:moduleStub,exports:moduleStub.exports,FormData,File,Uint8Array,crypto:{randomUUID:()=> '22222222-2222-4222-8222-222222222222'},
  require(name){
    if(name==='next/cache')return {revalidatePath:()=>{}};
    if(name==='next/navigation')return {redirect:url=>{throw new Error(url)}};
    if(name==='@/lib/auth')return {requireProfile:async roles=>{assert.deepEqual(Array.from(roles),['admin']);return {supabase}}};
    if(name==='@/lib/registration')return {receiptImageType:bytes=>bytes[0]===137?{mime:'image/png',extension:'png'}:null};
    throw Error(name);
  },
});
const form=(file,receipt=old)=>{const fd=new FormData();fd.set('student_id',student);fd.set('expected_receipt_path',receipt);if(file)fd.set('receipt',file);return fd};
const png=new File([Uint8Array.from([137,80,78,71])],'telegram.png',{type:'text/plain'});
(async()=>{
  await assert.rejects(moduleStub.exports.uploadStudentReceipt(form(null)),/error=upload/);
  await assert.rejects(moduleStub.exports.uploadStudentReceipt(form(new File(['fake'],'bad.png'))),/error=upload/);
  await assert.rejects(moduleStub.exports.uploadStudentReceipt(form(new File([new Uint8Array(5*1024*1024+1)],'large.png'))),/error=upload/);
  assert.equal(calls.length,0,'invalid images must not be uploaded');
  rpcError={message:'Receipt changed'};
  await assert.rejects(moduleStub.exports.uploadStudentReceipt(form(png)),/error=upload/);
  assert.equal(calls[0][0],'upload'); assert.equal(calls[0][1],next);
  assert.equal(calls[0][3].contentType,'image/png','content type comes from bytes, not the filename');
  assert.equal(calls[1][1],'admin_submit_student_receipt');
  assert.deepEqual(JSON.parse(JSON.stringify(calls[1][2])),{
    target_student_id:student,expected_receipt_path:old,new_receipt_path:next,new_receipt_name:'telegram.png',
  });
  assert.deepEqual(JSON.parse(JSON.stringify(calls[2])),['remove',[next]],'rollback only the new orphaned file');
  calls.length=0;rpcError=null;
  await assert.rejects(moduleStub.exports.uploadStudentReceipt(form(png,'')),/uploaded=1/);
  assert.equal(calls[1][2].expected_receipt_path,null);
  assert.equal(calls.length,2,'first receipt upload never removes another object');
  calls.length=0;
  await assert.rejects(moduleStub.exports.uploadStudentReceipt(form(png)),/uploaded=1/);
  assert.deepEqual(JSON.parse(JSON.stringify(calls[2])),['remove',[old]],'replaced object is removed after DB success');
  console.log('PASS: admin action validates size and magic bytes; private upload, stale-path RPC, rollback and replacement cleanup');
})().catch(e=>{console.error(e);process.exitCode=1});
