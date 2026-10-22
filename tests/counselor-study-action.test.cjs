const assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm'),ts=require('typescript');
const m={exports:{}};let authCalls=0,rpcCalls=0,fail=false,denied=false,invalidations=[];
vm.runInNewContext(ts.transpileModule(fs.readFileSync('app/dashboard/counselor/study-actions.ts','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText,{module:m,exports:m.exports,require(name){
 if(name==='@/lib/study-catalog')return {studyFieldLabels:{mathematics:'Math',experimental_sciences:'Science',humanities:'Humanities',arts:'Arts',foreign_languages:'Languages'}};
 if(name==='next/cache')return {revalidatePath:(...args)=>invalidations.push(args)};
 if(name==='@/lib/auth')return {requireProfile:async roles=>{authCalls++;assert.equal(roles.join(','),'counselor');if(denied)throw Error('denied');return {supabase:{rpc:async(name,args)=>{rpcCalls++;assert.equal(name,'counselor_update_student_study');assert.equal(args.target_student_id,'11111111-1111-1111-1111-111111111111');assert.equal(args.target_grade,11);assert.equal(args.target_study_field,'humanities');return {error:fail?{message:'denied'}:null};}}};}};
 throw Error(name);
}});
const data=(overrides={})=>{const fd=new FormData();for(const [key,value]of Object.entries({student_id:'11111111-1111-1111-1111-111111111111',grade:'11',study_field:'humanities',...overrides}))fd.set(key,value);return fd;};
(async()=>{
 const save=m.exports.updateCounselorStudentStudy;
 for(const overrides of [{student_id:'invalid'},{grade:'9'},{grade:''},{study_field:'invalid'},{study_field:'constructor'}])assert.ok((await save(data(overrides))).error);
 assert.equal(rpcCalls,0);assert.equal(invalidations.length,0);
 fail=true;assert.ok((await save(data())).error);assert.equal(invalidations.length,0);
 fail=false;assert.equal((await save(data())).success,true);assert.equal(invalidations[0].join(','),'/dashboard,layout');
 denied=true;await assert.rejects(()=>save(data()),/denied/);assert.equal(rpcCalls,2);assert.equal(authCalls,8);
 const builder=fs.readFileSync('components/dashboard/weekly-plan-builder.tsx','utf8'),editor=fs.readFileSync('components/dashboard/counselor-student-study-editor.tsx','utf8');
 assert.ok(builder.indexOf('<CounselorStudentStudyEditor')<builder.indexOf('<form action={saveWeeklyPlan}'));
 assert.match(builder,/key=\{student.student_id\} student=\{student\}/);assert.match(builder,/curriculumBooks\(student\?\.study_field/);
 assert.match(editor,/type="button"/);assert.match(editor,/disabled=\{pending \|\| !grade \|\| !field\}/);assert.match(editor,/aria-live="polite"/);
 console.log('Study server action: fresh counselor guard, invalid/tampered input rejection, RPC error handling, successful dashboard invalidation; selected-student editor and preserved plan form wiring passed.');
})().catch(e=>{console.error(e);process.exitCode=1;});
