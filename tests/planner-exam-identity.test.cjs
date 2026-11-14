// Candidate migration only: disposable Postgres, no production data.
const {PGlite}=require('@electric-sql/pglite');const fs=require('node:fs');const assert=require('node:assert/strict');
(async()=>{const db=new PGlite();try{
 await db.exec(`create role authenticated;create role anon;create schema auth;create schema private;
 create type public.app_role as enum('counselor');create type public.content_status as enum('published');
 create function auth.uid() returns uuid language sql as $$select '11111111-1111-4111-8111-111111111111'::uuid$$;
 create function private.current_user_role() returns public.app_role language sql as $$select 'counselor'::public.app_role$$;
 create table public.counselor_students(counselor_id uuid,student_id uuid);
 create table public.weekly_plans(id uuid primary key,counselor_id uuid,routines jsonb,status public.content_status);
 create table public.exams(id uuid primary key);
 create table public.weekly_plan_items(id uuid primary key default gen_random_uuid(),plan_id uuid,day_of_week smallint,subject text,chapter text,activity_type text,sort_order smallint,linked_exam_id uuid);
 create function public.normalize_weekly_plan_routines(x jsonb) returns jsonb language sql as $$select x$$;
 create function public.save_weekly_plan_v4(plan uuid,student uuid,week date,title text,notes text,status public.content_status,items jsonb) returns uuid language plpgsql as $$
 declare x jsonb;n int:=0;begin
 delete from public.weekly_plan_items i where i.plan_id=plan and not exists(select 1 from jsonb_array_elements(items) a where a->>'id'=i.id::text);
 for x in select value from jsonb_array_elements(items) loop
  if x->>'id' is null then insert into public.weekly_plan_items(plan_id,day_of_week,subject,chapter,activity_type,sort_order) values(plan,(x->>'dayOfWeek')::smallint,x->>'subject',x->>'chapter','exam',n);
  else update public.weekly_plan_items set sort_order=n where id=(x->>'id')::uuid;end if;n:=n+1;
 end loop;return plan;end$$;
 insert into public.counselor_students values('11111111-1111-4111-8111-111111111111','22222222-2222-4222-8222-222222222222');
 insert into public.weekly_plans values('33333333-3333-4333-8333-333333333333','11111111-1111-4111-8111-111111111111','[]','published');
 insert into public.exams values('44444444-4444-4444-8444-444444444444');`);
 const migration=fs.readFileSync('supabase/migrations/125_plan_exam_concurrency_guard.sql','utf8');
 await db.exec('create or replace function public.save_weekly_plan_v5('+migration.split('create or replace function public.save_weekly_plan_v5(')[1].split('revoke all on function public.save_weekly_plan_v5(')[0]);
 const plan='33333333-3333-4333-8333-333333333333',student='22222222-2222-4222-8222-222222222222',exam='44444444-4444-4444-8444-444444444444',source='55555555-5555-4555-8555-555555555555',other='66666666-6666-4666-8666-666666666666';
 const box=(id,sourceItemId)=>({id,dayOfWeek:2,subject:'آزمون',chapter:'فصل',...(sourceItemId===undefined?{}:{sourceItemId})});
 const setup=async()=>{await db.query('delete from public.weekly_plan_items');await db.query("insert into public.weekly_plan_items values($1,$2,2,'آزمون','فصل','exam',0,$3),($4,$2,2,'آزمون','فصل','exam',1,null)",[source,plan,exam,other])};
 const save=items=>db.query("select public.save_weekly_plan_v5($1,$2,'2030-01-01','x','','published',$3::jsonb,'[]')",[plan,student,JSON.stringify(items)]);
 const rows=async()=>(await db.query('select id,sort_order,linked_exam_id from public.weekly_plan_items order by sort_order')).rows;
 await setup();await save([box(source),box(other)]);let result=await rows();assert.equal(result[0].linked_exam_id,exam);assert.equal(result[1].linked_exam_id,null,'retained original must not copy its exam to the duplicate');
 await setup();const before=await rows();await assert.rejects(save([box(null),box(null)]),/Ambiguous exam boxes/);assert.deepEqual(await rows(),before,'ambiguous legacy save rolls back all changes');
 await setup();await save([box(null,other),box(null,source)]);result=await rows();assert.equal(result[0].linked_exam_id,null);assert.equal(result[1].linked_exam_id,exam,'source ID, not position or same subject, picks the linked block');
 await setup();await assert.rejects(save([box(null,source),box(null,source)]),/Invalid or duplicate source identity/);assert.deepEqual(await rows(),before);
 await setup();await assert.rejects(save([{...box(null,source),chapter:'دیگر'}]),/Exam source identity changed/);assert.deepEqual(await rows(),before);
 await setup();await assert.rejects(save([box(null,'77777777-7777-4777-8777-777777777777')]),/Invalid or duplicate source identity/);assert.deepEqual(await rows(),before,'stale source cannot silently detach an exam');
 await setup();await save([box(null,other)]);result=await rows();assert.equal(result[0].linked_exam_id,null,'explicit source removal does not reattach its exam to an identical copy');
 console.log('PASS: exact exam source mapping, protected duplicate identities and atomic legacy ambiguity rejection');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
