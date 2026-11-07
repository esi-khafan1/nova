const assert=require('node:assert/strict');
const {readFileSync}=require('node:fs');
const vm=require('node:vm');
const ts=require('typescript');
const student='11111111-1111-4111-8111-111111111111',plan='22222222-2222-4222-8222-222222222222',counselor='33333333-3333-4333-8333-333333333333',other='44444444-4444-4444-8444-444444444444';
const duration=90;
const code=ts.transpileModule(readFileSync('app/dashboard/actions.ts','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText;
const today=()=>{const p=new Intl.DateTimeFormat('en-US',{timeZone:'Asia/Tehran',year:'numeric',month:'2-digit',day:'2-digit'}).formatToParts(new Date());const v=t=>p.find(x=>x.type===t).value;return `${v('year')}-${v('month')}-${v('day')}`};
function form(opts={}){const fd=new FormData();for(const [k,v] of Object.entries({student_id:student,plan_id:plan,week_start:today(),title:'برنامه',notes:'',status:'published',items:JSON.stringify([{id:null,dayOfWeek:0,durationMinutes:60,subject:'زیست',chapter:'',activityType:'lesson',targetTestCount:null,details:'',sourceGrade:10,preparationTrack:'konkur',recommendedPublisher:null,examYear:null}]),routines:JSON.stringify(Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:opts.subject??'',details:''}))),...opts.values}))fd.set(k,v);return fd;}
function make(opts={}){
 const events=[];let saveCalls=0;
 const timed=(name,value)=>{events.push([name,'start',performance.now()]);return new Promise(resolve=>setTimeout(()=>{events.push([name,'end',performance.now()]);resolve(value)},duration));};
 const client={auth:{getUser:()=>timed('auth',{data:{user:opts.unauth?null:{id:counselor}}})},rpc(name,args){if(name==='counselor_student_directory')return timed('directory',{data:opts.unassigned?[]:[{student_id:student,is_selected:true,grade:10,study_field:'experimental_sciences'}],error:null});assert.equal(name,'save_weekly_plan_v9');saveCalls++;assert.equal(args.target_student_id,student);return timed('save',opts.saveError?{data:null,error:{code:'PZ001'}}:{data:plan,error:null})},from(name){assert.equal(name,'weekly_plans');return {select(columns){assert.equal(columns,'counselor_id,routines');return {eq(key,value){assert.equal(key,'id');assert.equal(value,plan);return {maybeSingle:()=>timed('prior',{data:opts.priorNull?null:{counselor_id:opts.foreign?other:counselor,routines:[{subject:'روتین قبلی'}]},error:opts.priorError?{}:null})}}}}}}};
 const mod={exports:{}};
 vm.runInNewContext(code,{module:mod,exports:mod.exports,URLSearchParams,FormData,Intl,Date,Number,String,JSON,Set,RegExp,Promise,require(name){
 if(name==='next/cache')return{revalidatePath:()=>{}};if(name==='next/navigation')return{redirect:url=>{throw new Error(url)}};
 if(name==='@/lib/supabase/server')return{createClient:async()=>client};if(name==='@/lib/auth')return{requireProfile:()=>{throw Error('unexpected')}};
 if(name==='@/lib/study-catalog')return{activityTypes:[{value:'lesson'}]};if(name==='@/lib/planning-curriculum')return{curriculumBooks:()=>[],routineSubjectOptions:()=>[]};
 if(name==='@/lib/makeup-plan-box')return{makeupActivity:'makeup',makeupTitle:'باکس جبرانی'};
 if(name==='@/lib/external-simulation')return{externalSimulationActivity:'external_simulation_exam',simulationProvider:()=>null};
 if(name==='@/lib/recommended-publishers')return{canRecommendPublisher:()=>false,cleanRecommendedPublisher:()=>null};throw Error(name)}});
 return{save:mod.exports.saveWeeklyPlan,events,get calls(){return saveCalls}};
}
async function run(t,fd,expected){await assert.rejects(t.save(fd),e=>e.message.includes(expected));}
(async()=>{
 for(const isNew of [false,true]){
  const t=make(),start=performance.now();await run(t,form({values:isNew?{plan_id:''}:{}}),'saved=published');const elapsed=performance.now()-start;
  const starts=t.events.filter(e=>e[1]==='start'&&e[0]!=='save');assert.equal(starts.length,isNew?2:3);
  assert.ok(Math.max(...starts.map(e=>e[2]))-Math.min(...starts.map(e=>e[2]))<duration/2,'authorization and independent reads must start together');
  const saveStart=t.events.find(e=>e[0]==='save'&&e[1]==='start')[2];assert.ok(t.events.filter(e=>e[0]!=='save'&&e[1]==='end').every(e=>e[2]<=saveStart));
  assert.ok(elapsed<duration*3.4,`two network rounds expected, took ${elapsed.toFixed(0)}ms`);assert.equal(t.calls,1);
 }
 let t=make({unauth:true});await run(t,form(),'/auth/sign-in');assert.equal(t.calls,0);
 t=make({unassigned:true});await run(t,form(),'error=items');assert.equal(t.calls,0);
 t=make({priorError:true});await run(t,form(),'error=plan');assert.equal(t.calls,0);
 t=make({foreign:true});await run(t,form({subject:'روتین قبلی'}),'error=routines');assert.equal(t.calls,0);
 t=make();await run(t,form({subject:'روتین قبلی'}),'saved=published');assert.equal(t.calls,1);
 t=make({saveError:true});await run(t,form(),'error=protected');assert.equal(t.calls,1);
 t=make();await run(t,form({values:{status:'invalid'}}),'error=plan');assert.equal(t.calls,0);
 console.log('PASS: parallel reads for new/edit save; auth, assignment, ownership, routines, errors and protected completion preserved (mocked latency only).');
})().catch(e=>{console.error(e);process.exitCode=1});
