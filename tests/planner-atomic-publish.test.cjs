// Disposable PostgreSQL fixture. The legacy save RPC is a stub so transaction
// and revision behavior are tested without changing any real project.
const {PGlite}=require('@electric-sql/pglite');
const {randomUUID}=require('node:crypto');
const fs=require('node:fs');const assert=require('node:assert/strict');
(async()=>{
 const db=new PGlite();
 try {
  await db.exec(`create role anon;create role authenticated;create schema auth;create schema private;
   create type public.app_role as enum('student','counselor','admin');
   create type public.content_status as enum('draft','published');
   create table public.profiles(id uuid primary key,role public.app_role,registration_status text);
   create table public.counselor_profiles(user_id uuid primary key,approval_status text);
   create table public.counselor_students(counselor_id uuid,student_id uuid,primary key(counselor_id,student_id));
   create table public.weekly_plans(id uuid primary key,counselor_id uuid,student_id uuid,week_start date,updated_at timestamptz not null default now(),title text,status public.content_status);
   create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
   create function private.current_user_role() returns public.app_role language sql security definer stable as $$select role from public.profiles where id=auth.uid()$$;
   grant usage on schema public,auth,private to anon,authenticated;
   create function public.save_weekly_plan_v9(pid uuid,sid uuid,start date,title text,notes text,status public.content_status,items jsonb,routines jsonb)
   returns uuid language plpgsql security definer as $$declare saved uuid:=coalesce(pid,gen_random_uuid());begin
     if title='reject' then raise exception 'protected item';end if;
     if jsonb_array_length(items)=0 then raise exception 'missing items';end if;
     insert into public.weekly_plans(id,counselor_id,student_id,week_start,title,status) values(saved,auth.uid(),sid,start,title,status)
     on conflict(id) do update set title=excluded.title,status=excluded.status,updated_at=now();return saved;end$$;
  `);
  await db.exec(fs.readFileSync('supabase/migrations/118_planner_private_drafts.sql','utf8'));
  await db.exec(fs.readFileSync('supabase/migrations/119_planner_atomic_publish.sql','utf8'));
  const counselor=randomUUID(),student=randomUUID(),other=randomUUID(),id=randomUUID();
  await db.query("insert into public.profiles values($1,'counselor','active'),($2,'student','active'),($3,'counselor','active')",[counselor,student,other]);
  await db.query("insert into public.counselor_profiles values($1,'approved'),($2,'approved')",[counselor,other]);
  await db.query('insert into public.counselor_students values($1,$2)',[counselor,student]);
  await db.query("insert into public.weekly_plans values($1,$2,$3,'2030-01-05',now(),'قبلی','published')",[id,counselor,student]);
  const actor=async user=>{await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub',$1,false)",[user]);await db.exec('set role authenticated')};
  const snapshot=title=>({title,notes:'',items:[{subject:'زیست'}],routines:[]});
  const save=async(week,plan,snap,revision)=> (await db.query('select public.planner_save_working_draft($1,$2,$3,$4::jsonb,$5) x',[student,week,plan,JSON.stringify(snap),revision])).rows[0].x;
  const publish=(week,revision)=>db.query('select public.planner_publish_working_draft($1,$2,$3)',[student,week,revision]);
  const get=async week=>(await db.query('select public.planner_get_working_draft($1,$2) x',[student,week])).rows[0].x;
  const plan=async()=>{await db.exec('reset role');return (await db.query('select title,status from public.weekly_plans where id=$1',[id])).rows[0]};
  await actor(counselor);await save('2030-01-05',id,snapshot('reject'),null);
  await assert.rejects(()=>publish('2030-01-05','0'),/Invalid draft/);await assert.rejects(()=>publish('2030-01-05','2'),/Draft has changed/);
  await assert.rejects(()=>publish('2030-01-05','1'),/protected item/);
  assert.equal((await get('2030-01-05')).snapshot.title,'reject');assert.deepEqual(await plan(),{title:'قبلی',status:'published'});
  await actor(counselor);await save('2030-01-05',id,snapshot('جدید'),'1');
  await actor(other);await assert.rejects(()=>publish('2030-01-05','2'),/Student not available/);
  await actor(counselor);await publish('2030-01-05','2');assert.equal(await get('2030-01-05'),null);assert.deepEqual(await plan(),{title:'جدید',status:'published'});
  await actor(counselor);await save('2030-01-05',id,snapshot('stale'),null);
  await db.exec('reset role');await db.query("update public.weekly_plans set updated_at=updated_at + interval '1 second' where id=$1",[id]);
  await actor(counselor);await assert.rejects(()=>publish('2030-01-05','1'),/Published plan has changed/);assert.equal((await get('2030-01-05')).snapshot.title,'stale');
  await save('2030-02-01',null,{title:'incomplete'},null);await assert.rejects(()=>publish('2030-02-01','1'),/Draft is incomplete/);
  assert.ok(await get('2030-02-01'));await save('2030-02-01',null,snapshot('برنامه جدید'),'1');
  await publish('2030-02-01','2');assert.equal(await get('2030-02-01'),null);
  await db.exec('reset role');assert.equal((await db.query("select count(*)::int n from public.weekly_plans where week_start='2030-02-01' and status='published'")).rows[0].n,1);
  console.log('PASS: atomic publication, revision and live-plan conflict checks, retained drafts on failure, and access guards');
 }finally{await db.close()}
})().catch(e=>{console.error(e);process.exitCode=1});
