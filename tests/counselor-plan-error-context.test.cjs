const assert = require('node:assert/strict');
const {readFileSync} = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const student = '11111111-1111-4111-8111-111111111111';
const plan = '22222222-2222-4222-8222-222222222222';
let rpcFailure = true;
let planCalls = 0;
const client = {
  auth: {getUser: async () => ({data:{user:{id:'33333333-3333-4333-8333-333333333333'}}})},
  rpc: async (name,args) => {
    if (name === 'counselor_student_directory') return {data:[{student_id:student,is_selected:true,grade:10,study_field:'experimental_sciences'}],error:null};
    assert.equal(name,'save_weekly_plan_v8');
    assert.equal(args.target_plan_id,plan);
    planCalls++;
    return rpcFailure ? {error:{code:'PZ001'}} : {data:plan,error:null};
  },
  from(name) {assert.equal(name,'weekly_plans');return {select:()=>({eq:()=>({eq:()=>({maybeSingle:async()=>({data:{routines:[]},error:null})})})})};},
};
const moduleStub = {exports:{}};
const script = ts.transpileModule(readFileSync('app/dashboard/actions.ts','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText;
vm.runInNewContext(script,{
  module:moduleStub,exports:moduleStub.exports,URLSearchParams,FormData,Intl,Date,Number,String,JSON,Set,RegExp,
  require(name){
    if(name==='next/cache')return {revalidatePath:()=>{}};
    if(name==='next/navigation')return {redirect:url=>{throw new Error(url)}};
    if(name==='@/lib/supabase/server')return {createClient:async()=>client};
    if(name==='@/lib/auth')return {requireProfile:()=>{throw Error('not needed')}};
    if(name==='@/lib/study-catalog')return {activityTypes:[{value:'lesson'}]};
    if(name==='@/lib/planning-curriculum')return {curriculumBooks:()=>[],routineSubjectOptions:()=>[]};
    if(name==='@/lib/recommended-publishers')return {canRecommendPublisher:()=>false,cleanRecommendedPublisher:()=>null};
    throw Error(name);
  },
});
const date = () => {
  const parts=new Intl.DateTimeFormat('en-US',{timeZone:'Asia/Tehran',year:'numeric',month:'2-digit',day:'2-digit'}).formatToParts(new Date());
  const p=k=>parts.find(x=>x.type===k).value;
  return `${p('year')}-${p('month')}-${p('day')}`;
};
const build = (overrides={}) => {
  const fd=new FormData();
  const values={student_id:student,plan_id:plan,week_start:date(),title:'برنامهٔ هفته',notes:'',status:'published',items:JSON.stringify([{id:null,dayOfWeek:0,durationMinutes:60,subject:'زیست',chapter:'',activityType:'lesson',targetTestCount:null,details:'',sourceGrade:10,preparationTrack:'konkur',recommendedPublisher:null,examYear:null}]),routines:JSON.stringify(Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'',details:''}))),...overrides};
  for(const [key,value] of Object.entries(values))fd.set(key,value);
  return fd;
};
const checkUrl=(err,kind)=>{
  const url=new URL(err.message,'https://nova.example');
  assert.equal(url.searchParams.get(kind),kind==='error'?(rpcFailure?'protected':'plan'):'published');
  assert.equal(url.searchParams.get('student'),student);
  assert.equal(url.searchParams.get('plan'),plan);
  assert.equal(url.searchParams.get('week_start'),date());
  return true;
};
(async()=>{
  await assert.rejects(moduleStub.exports.saveWeeklyPlan(build()),error=>checkUrl(error,'error'));
  assert.equal(planCalls,1);
  rpcFailure=false;
  await assert.rejects(moduleStub.exports.saveWeeklyPlan(build({status:'invalid'})),error=>checkUrl(error,'error'));
  assert.equal(planCalls,1);
  await assert.rejects(moduleStub.exports.saveWeeklyPlan(build()),error=>checkUrl(error,'saved'));
  assert.equal(planCalls,2);
  const page=readFileSync('app/dashboard/counselor/plans/page.tsx','utf8');
  assert.match(page,/initialStudentId=\{params.student\}/);
  assert.match(page,/initialPlanId=\{params.plan\}/);
  console.log('PASS: failed and successful counselor saves retain the selected student, plan and week');
})().catch(error=>{console.error(error);process.exitCode=1});
