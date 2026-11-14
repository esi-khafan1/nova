// Isolated database: an accidental rollout of the unfinished draft migrations
// must not expose the new unvalidated publisher or affect the legacy endpoint.
const {PGlite}=require('@electric-sql/pglite');
const {randomUUID}=require('node:crypto');
const fs=require('node:fs');
const assert=require('node:assert/strict');
(async()=>{
 const db=new PGlite();
 try{
  await db.exec(`create role anon; create role authenticated; create schema auth; create schema private;
   create type public.app_role as enum('student','counselor');
   create type public.content_status as enum('draft','published');
   create table public.profiles(id uuid primary key,role public.app_role,registration_status text);
   create table public.counselor_profiles(user_id uuid primary key,approval_status text);
   create table public.counselor_students(counselor_id uuid,student_id uuid);
   create table public.weekly_plans(id uuid primary key,counselor_id uuid,student_id uuid,week_start date,updated_at timestamptz,title text,status public.content_status);
   create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
   create function private.current_user_role() returns public.app_role language sql stable security definer as $$select role from public.profiles where id=auth.uid()$$;
   grant usage on schema public,auth,private to anon,authenticated;
   create function public.save_weekly_plan_v9(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) returns uuid language sql as $$select $1$$;
   grant execute on function public.save_weekly_plan_v9(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) to authenticated;
  `);
  for(const file of ['118_planner_private_drafts','119_planner_atomic_publish']) await db.exec(fs.readFileSync(`supabase/migrations/${file}.sql`,'utf8'));
  const allowed=async role=>(await db.query("select has_function_privilege($1,'public.planner_publish_working_draft(uuid,date,text)','EXECUTE') allowed",[role])).rows[0].allowed;
  assert.equal(await allowed('authenticated'),false,'119 must already be fail-closed');
  // Defense in depth for an older copy of 119 that granted EXECUTE.
  await db.exec('grant execute on function public.planner_publish_working_draft(uuid,date,text) to authenticated');
  assert.equal(await allowed('authenticated'),true);
  await db.exec(fs.readFileSync('supabase/migrations/124_planner_publish_safety_gate.sql','utf8'));
  const counselor=randomUUID(),student=randomUUID(),plan=randomUUID();
  await db.query("insert into public.profiles values($1,'counselor','active'),($2,'student','active')",[counselor,student]);
  await db.query("insert into public.counselor_profiles values($1,'approved')",[counselor]);
  await db.query('insert into public.counselor_students values($1,$2)',[counselor,student]);
  await db.query("insert into public.weekly_plans values($1,$2,$3,'2030-01-01',now(),'برنامه قبلی','published')",[plan,counselor,student]);
  await db.query("select set_config('request.jwt.claim.sub',$1,false)",[counselor]);
  await db.exec('set role authenticated');
  const snapshot={title:'پیش‌نویس',notes:'',items:[],routines:[]};
  await db.query('select public.planner_save_working_draft($1,$2,$3,$4::jsonb,null)',[student,'2030-01-01',plan,JSON.stringify(snapshot)]);
  assert.equal((await db.query('select public.planner_get_working_draft($1,$2) value',[student,'2030-01-01'])).rows[0].value.revision,'1');
  await assert.rejects(()=>db.query('select public.planner_publish_working_draft($1,$2,$3)',[student,'2030-01-01','1']),/permission denied/);
  assert.equal((await db.query('select public.planner_get_working_draft($1,$2) value',[student,'2030-01-01'])).rows[0].value.snapshot.title,'پیش‌نویس');
  // Existing publisher's privilege and behavior remain independent of the gate.
  assert.equal((await db.query("select public.save_weekly_plan_v9($1,$2,$3,'old','', 'published','[]','[]') value",[plan,student,'2030-01-01'])).rows[0].value,plan);
  await db.exec('reset role');
  assert.deepEqual((await db.query('select title,status from public.weekly_plans where id=$1',[plan])).rows[0],{title:'برنامه قبلی',status:'published'});
  for(const role of ['anon','authenticated','public']){
   const privilege=(await db.query("select has_function_privilege($1,'public.planner_publish_working_draft(uuid,date,text)','EXECUTE') allowed",[role])).rows[0].allowed;
   assert.equal(privilege,false,`${role} cannot execute draft publisher`);
  }
  console.log('PASS: unfinished publisher is fail-closed; drafts, old plans and legacy save privilege survive');
 }finally{await db.close()}
})().catch(error=>{console.error(error);process.exitCode=1});
