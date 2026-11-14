// Isolated PostgreSQL fixture: never touches a real account or project.
const {PGlite} = require('@electric-sql/pglite');
const {randomUUID} = require('node:crypto');
const fs = require('node:fs');
const assert = require('node:assert/strict');
(async()=>{
 const db=new PGlite();
 try {
  await db.exec(`create role anon; create role authenticated; create schema auth; create schema private;
    create type public.app_role as enum('student','counselor','admin');
    create table public.profiles(id uuid primary key, role public.app_role not null, registration_status text);
    create table public.counselor_profiles(user_id uuid primary key, approval_status text);
    create table public.counselor_students(counselor_id uuid, student_id uuid, primary key(counselor_id,student_id));
    create table public.weekly_plans(id uuid primary key,counselor_id uuid,student_id uuid,week_start date,updated_at timestamptz not null default now(),status text,notes text);
    create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
    create function private.current_user_role() returns public.app_role language sql security definer stable as $$select role from public.profiles where id=auth.uid()$$;
    grant usage on schema public,auth,private to authenticated,anon;
  `);
  await db.exec(fs.readFileSync('supabase/migrations/118_planner_private_drafts.sql','utf8'));
  const counselor=randomUUID(),other=randomUUID(),pending=randomUUID(),student=randomUUID(),inactive=randomUUID(),outsider=randomUUID(),plan=randomUUID();
  for(const id of [counselor,other,pending]) await db.query("insert into public.profiles values($1,'counselor','active')",[id]);
  for(const [id,state] of [[student,'active'],[outsider,'active'],[inactive,'incomplete']]) await db.query("insert into public.profiles values($1,'student',$2)",[id,state]);
  await db.query("insert into public.counselor_profiles values($1,'approved'),($2,'approved'),($3,'pending')",[counselor,other,pending]);
  await db.query('insert into public.counselor_students values($1,$2),($1,$3),($4,$2)',[counselor,student,inactive,pending]);
  await db.query("insert into public.weekly_plans(id,counselor_id,student_id,week_start,status,notes) values($1,$2,$3,'2030-01-05','published','original')",[plan,counselor,student]);
  async function actor(id,role='authenticated'){await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub',$1,false)",[id||'']);await db.exec(`set role ${role}`);}
  async function save(who,week,planId,snapshot,rev){return (await db.query('select public.planner_save_working_draft($1,$2,$3,$4::jsonb,$5) result',[who,week,planId,JSON.stringify(snapshot),rev])).rows[0].result;}
  async function get(who,week){return (await db.query('select public.planner_get_working_draft($1,$2) result',[who,week])).rows[0].result;}
  async function discard(who,week,rev){return db.query('select public.planner_discard_working_draft($1,$2,$3)',[who,week,rev]);}
  await actor(counselor);
  await assert.rejects(()=>db.query('select * from private.planner_working_drafts'),/permission denied/);
  const created=await save(student,'2030-01-05',plan,{title:'نیمه‌کاره',items:[]},null);
  assert.equal(created.revision,'1');assert.ok(created.base_plan_updated_at);
  let loaded=await get(student,'2030-01-05');assert.equal(loaded.snapshot.title,'نیمه‌کاره');assert.equal(loaded.plan_id,plan);
  await assert.rejects(()=>save(student,'2030-01-05',plan,{title:'stale'},null),/Draft has changed/);
  const updated=await save(student,'2030-01-05',plan,{title:'جدید'},'1');assert.equal(updated.revision,'2');
  await assert.rejects(()=>save(student,'2030-01-05',plan,{title:'old'},'1'),/Draft has changed/);
  await assert.rejects(()=>discard(student,'2030-01-05','1'),/Draft has changed/);
  assert.equal((await get(student,'2030-01-05')).snapshot.title,'جدید');
  await assert.rejects(()=>save(student,'2030-01-05',null,{},'2'),/Draft has changed/);
  await assert.rejects(()=>save(student,'2030-02-01',plan,{},null),/Plan not available/);
  await assert.rejects(()=>save(outsider,'2030-02-01',null,{},null),/Student not available/);
  await assert.rejects(()=>save(inactive,'2030-02-01',null,{},null),/Student not available/);
  await assert.rejects(()=>save(student,'2030-02-01',null,[],null),/Invalid draft/);
  await assert.rejects(()=>save(student,'2030-02-01',null,{text:'x'.repeat(200001)},null),/Invalid draft/);
  await actor(other);await assert.rejects(()=>get(student,'2030-01-05'),/Student not available/);
  await actor(pending);await assert.rejects(()=>get(student,'2030-01-05'),/Student not available/);
  await actor(student);await assert.rejects(()=>get(student,'2030-01-05'),/Student not available/);
  await actor(null,'anon');await assert.rejects(()=>get(student,'2030-01-05'),/permission denied/);
  await actor(counselor);await discard(student,'2030-01-05','2');assert.equal(await get(student,'2030-01-05'),null);
  await assert.rejects(()=>save(student,'2030-01-05',null,{},null),/Open the existing plan/);
  await db.exec('reset role');const unchanged=(await db.query('select status,notes from public.weekly_plans where id=$1',[plan])).rows[0];assert.deepEqual(unchanged,{status:'published',notes:'original'});
  await db.query('delete from public.counselor_students where counselor_id=$1 and student_id=$2',[counselor,student]);await actor(counselor);await assert.rejects(()=>get(student,'2030-01-05'),/Student not available/);
  console.log('PASS: isolated private drafts, assigned approved access, revision conflicts and untouched published plans');
 } finally {await db.close();}
})().catch(e=>{console.error(e);process.exitCode=1});
