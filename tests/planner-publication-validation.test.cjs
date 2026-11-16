// Isolated PGlite fixture; no production data or grant is modified.
const {PGlite}=require('@electric-sql/pglite'),{randomUUID}=require('node:crypto'),fs=require('node:fs'),assert=require('node:assert/strict'),esbuild=require('esbuild');
(async()=>{
 const sql=fs.readFileSync('supabase/migrations/126_planner_publish_validation.sql','utf8');
 const correction=fs.readFileSync('supabase/migrations/244_planner_followup_lab_math_publish_1405.sql','utf8'); // latest re-issue of the validator; re-point when a newer re-issue lands
 const embedded=JSON.parse(correction.match(/\$catalog\$(.*?)\$catalog\$/s)[1]);
 const bundle=await esbuild.build({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false});const mod={exports:{}};new Function('module','exports',bundle.outputFiles[0].text)(mod,mod.exports);
 for(const field of [null,'mathematics','experimental_sciences','humanities','arts','foreign_languages']) for(const grade of [9,10,11,12]){
  assert.deepEqual(embedded.finals[field??'null'][grade],mod.exports.curriculumBooks(field,grade,'final_exam').map(x=>x.subject));
  assert.deepEqual(embedded.routines[field??'null'][grade],mod.exports.routineSubjectOptions(field,grade));
 }
 const db=new PGlite();try{
  await db.exec(`create role anon;create role authenticated;create schema private;create schema auth;create type public.content_status as enum('draft','published');
  create table public.profiles(id uuid primary key,study_field text,grade integer);
  create table public.counselor_students(counselor_id uuid,student_id uuid);
  create table public.weekly_plans(id uuid primary key,counselor_id uuid,student_id uuid,week_start date,status public.content_status,routines jsonb);
  create table public.weekly_plan_items(id uuid primary key,plan_id uuid,subject text);
  create table private.planner_working_drafts(counselor_id uuid,student_id uuid,week_start date,plan_id uuid,snapshot jsonb,revision bigint);
  create function auth.uid() returns uuid language sql stable as $$select current_setting('request.jwt.claim.sub')::uuid$$;
  create function private.require_planner_draft_access(uuid) returns void language sql as $$select$$;
  create function public.planner_publish_working_draft(uuid,date,text) returns uuid language plpgsql security definer as $$begin return $1;end$$;
  grant usage on schema public,private,auth to authenticated;`);
  await db.exec(sql);await db.exec(correction);
  assert.equal((await db.query("select has_function_privilege('authenticated','public.planner_publish_working_draft(uuid,date,text)','execute') allowed")).rows[0].allowed,false);
  assert.equal((await db.query("select has_function_privilege('authenticated','private.planner_publish_working_draft_unvalidated(uuid,date,text)','execute') allowed")).rows[0].allowed,false);
  // Fixture grant exercises the validation wrapper, never a release grant.
  await db.exec('grant execute on function public.planner_publish_working_draft(uuid,date,text) to authenticated');
  const c=randomUUID(),s=randomUUID(),p=randomUUID(),week='2099-01-01';
  await db.query("insert into public.profiles values($1,'experimental_sciences',10)",[s]);
  await db.query("insert into public.counselor_students values($1,$2)",[c,s]);
  await db.query("insert into public.weekly_plans values($1,$2,$3,$4,'published',$5)",[p,c,s,week,JSON.stringify([{subject:'درس قدیمی'}])]);
  const routines=Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'',details:'',secondSubject:'',secondDetails:''}));
  const item={id:null,sourceItemId:null,dayOfWeek:0,durationMinutes:60,subject:'زیست‌شناسی ۱',chapter:'',activityType:'lesson',targetTestCount:null,details:'',sourceGrade:10,preparationTrack:'final_exam',recommendedPublisher:null,examYear:null};
  const snapshot={title:'عنوان',notes:'',items:[item],routines,extras:{week:{goal:'هدف',wakeTime:'07:30'},items:[{topics:[{title:'گفتار اول',pageStart:5,pageEnd:6}]}]}};
  await db.query('insert into private.planner_working_drafts values($1,$2,$3,$4,$5,1)',[c,s,week,p,JSON.stringify(snapshot)]);
  await db.query("select set_config('request.jwt.claim.sub',$1,false)",[c]);await db.exec('set role authenticated');
  const publish=()=>db.query('select public.planner_publish_working_draft($1,$2,$3)',[s,week,'1']);
  await publish();
  const check=async(mutator)=>{const changed=structuredClone(snapshot);mutator(changed);await db.exec('reset role');await db.query('update private.planner_working_drafts set snapshot=$1',[JSON.stringify(changed)]);await db.exec('set role authenticated');await assert.rejects(publish);};
  await check(x=>x.items[0].subject='درس نامعتبر');await check(x=>x.items[0].durationMinutes=1);await check(x=>x.items[0].activityType='fake');
  await check(x=>{x.items[0].activityType='practice_tests';x.items[0].targetTestCount=null});await check(x=>x.items[0].recommendedPublisher='گاج');
  await check(x=>x.routines[0].subject='درس ساختگی');await check(x=>x.routines[0].dayOfWeek=1);await check(x=>x.items[0].examYear=1405);
  await check(x=>{x.items[0].activityType='makeup';x.items[0].subject='باکس جبرانی'});
  await check(x=>x.extras.items[0].topics[0].pageEnd=3);await check(x=>x.extras.items[0].topics={bad:true});await check(x=>x.extras.week.wakeTime='29:99');
  // Only the identical legacy item of the student's existing plan may survive.
  const oldItem=randomUUID();await db.exec('reset role');await db.query('insert into public.weekly_plan_items values($1,$2,$3)',[oldItem,p,'تفکر و سبک زندگی']);
  await db.query("update public.profiles set study_field=null,grade=9 where id=$1",[s]);
  const legacy=structuredClone(snapshot);Object.assign(legacy.items[0],{id:oldItem,sourceGrade:9,subject:'تفکر و سبک زندگی'});
  await db.query('update private.planner_working_drafts set snapshot=$1',[JSON.stringify(legacy)]);await db.exec('set role authenticated');await publish();
  legacy.items[0].id=null;await db.exec('reset role');await db.query('update private.planner_working_drafts set snapshot=$1',[JSON.stringify(legacy)]);await db.exec('set role authenticated');await assert.rejects(publish);
  legacy.items[0].sourceItemId=oldItem;await db.exec('reset role');await db.query('update private.planner_working_drafts set snapshot=$1',[JSON.stringify(legacy)]);await db.exec('set role authenticated');await publish();
  await db.exec('reset role');await db.query('update public.weekly_plan_items set plan_id=$1 where id=$2',[randomUUID(),oldItem]);await db.exec('set role authenticated');await assert.rejects(publish);
  await db.exec('reset role');await db.query('update public.weekly_plan_items set plan_id=$1 where id=$2',[p,oldItem]);legacy.routines[0].subject='تفکر و سبک زندگی';await db.query('update private.planner_working_drafts set snapshot=$1',[JSON.stringify(legacy)]);await db.exec('set role authenticated');await assert.rejects(publish);
  await db.exec('reset role');await db.query('update public.weekly_plans set routines=$1 where id=$2',[JSON.stringify([{subject:'تفکر و سبک زندگی'}]),p]);await db.exec('set role authenticated');await publish();
  console.log('PASS: authoritative publication validation, catalog parity and fail-closed grants');
 }finally{await db.close()}
})().catch(e=>{console.error(e);process.exitCode=1});
