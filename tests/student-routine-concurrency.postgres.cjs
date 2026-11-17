// Disposable real PostgreSQL only; install embedded-postgres separately.
const assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path'),{randomUUID}=require('node:crypto');
(async()=>{
 const EmbeddedPostgres=(await import('embedded-postgres')).default;
 const db=new EmbeddedPostgres({databaseDir:fs.mkdtempSync(path.join(os.tmpdir(),'nova-routine-pg-')),user:'postgres',password:'fixture-only',port:24000+Math.floor(Math.random()*10000),persistent:false,onLog:()=>{},onError:()=>{}});let started=false;const connections=[];
 try{
  await db.initialise();await db.start();started=true;
  const client=async()=>{const c=db.getPgClient();await c.connect();connections.push(c);await c.query("set statement_timeout='5s'");return c;};
  const setup=await client();
  await setup.query(`create role authenticated;create role anon;create schema auth;create schema private;create type public.app_role as enum('student','counselor');create type public.content_status as enum('published','draft');
   create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
   create table public.profiles(id uuid primary key,role public.app_role,registration_status text);
   create function private.current_user_role() returns public.app_role language sql stable security definer as $$select role from public.profiles where id=auth.uid()$$;
   create table public.counselor_students(student_id uuid,counselor_id uuid);
   create table public.weekly_plans(id uuid primary key,student_id uuid,title text,week_start date,notes text,status public.content_status,routines jsonb not null default '[]');
   create table public.weekly_plan_items(id uuid,plan_id uuid,day_of_week integer,duration_minutes integer,subject text,chapter text,activity_type text,target_test_count integer,details text,recommended_publisher text,sort_order integer,source_grade integer,preparation_track text,exam_year integer,linked_exam_id uuid);
   create table public.weekly_plan_item_completions(item_id uuid,student_id uuid,completed_at timestamptz,completed_test_count integer,completed_minutes integer,test_duration_recorded boolean);
   create table public.exams(id uuid,status text);grant usage on schema public,auth,private to authenticated;`);
  await setup.query(fs.readFileSync('supabase/migrations/250_student_routine_progress.sql','utf8'));
  const student=randomUUID(),plan=randomUUID();const old=[{dayOfWeek:0,subject:'ریاضی',details:'تمرین'}],modified=[{dayOfWeek:0,subject:'شیمی',details:'تمرین'}];
  await setup.query("insert into public.profiles values($1,'student','active')",[student]);
  await setup.query("insert into public.weekly_plans values($1,$2,'برنامه',timezone('Asia/Tehran',now())::date,null,'published',$3)",[plan,student,JSON.stringify(old)]);
  const a=await client(),b=await client();await a.query("select set_config('request.jwt.claim.sub',$1,false)",[student]);await a.query('set role authenticated');
  const tick=(conn,subject,done)=>conn.query('select public.set_weekly_routine_progress($1,0,1,$2,$3,$4)',[plan,subject,'تمرین',done]);
  await a.query('begin');await a.query('select pg_advisory_xact_lock(hashtextextended($1,73033))',[student]);
  await assert.rejects(()=>b.query('update public.weekly_plans set routines=$1 where id=$2',[JSON.stringify(modified),plan]),e=>e.code==='40001');
  await tick(a,'ریاضی',true);
  let updateSettled=false;const pendingUpdate=b.query('update public.weekly_plans set routines=$1 where id=$2',[JSON.stringify(modified),plan]).then(()=>({ok:true}),error=>({ok:false,error})).finally(()=>{updateSettled=true});
  await new Promise(resolve=>setTimeout(resolve,100));assert.equal(updateSettled,false);await a.query('commit');
  const blocked=await pendingUpdate;assert.equal(blocked.ok,false);assert.equal(blocked.error.code,'PZ003');
  assert.equal((await setup.query('select count(*)::int as n from public.weekly_plan_routine_completions')).rows[0].n,1);
  await tick(a,'ریاضی',false);
  await b.query('begin');await b.query('update public.weekly_plans set routines=$1 where id=$2',[JSON.stringify(modified),plan]);
  let settled=false;const waiting=tick(a,'ریاضی',true).then(()=>({ok:true}),error=>({ok:false,error})).finally(()=>{settled=true});
  await new Promise(resolve=>setTimeout(resolve,100));assert.equal(settled,false);await b.query('commit');
  const result=await waiting;assert.equal(result.ok,false);assert.equal(result.error.code,'40001');
  assert.equal((await setup.query('select count(*)::int as n from public.weekly_plan_routine_completions')).rows[0].n,0);
  console.log('PASS: routine check and publication races preserve the checked content');
 }finally{for(const c of connections)await c.end().catch(()=>{});if(started)await db.stop();}
})().catch(e=>{console.error(e);process.exitCode=1});
