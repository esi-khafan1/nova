// Disposable DB only: no production plans, accounts or progress are changed.
const {PGlite}=require('@electric-sql/pglite');
const assert=require('node:assert/strict');
const fs=require('node:fs');
(async()=>{
 const db=new PGlite();
 const own='11111111-1111-1111-1111-111111111111',other='22222222-2222-2222-2222-222222222222',inactive='33333333-3333-3333-3333-333333333333';
 await db.exec(`create role authenticated;create role anon;create schema auth;create schema private;
 create type public.app_role as enum ('student','counselor');
 create type public.study_activity_type as enum ('lesson','practice_tests');
 create type public.content_status as enum ('draft','published');
 create table public.profiles(id uuid primary key,role public.app_role,registration_status text);
 create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
 create function private.current_user_role() returns public.app_role language sql stable security definer as $$select role from public.profiles where id=auth.uid()$$;
 create table public.weekly_plans(id uuid primary key,student_id uuid,status public.content_status,week_start date);
 create table public.weekly_plan_items(id uuid primary key,plan_id uuid references public.weekly_plans(id),activity_type public.study_activity_type,target_test_count smallint,day_of_week integer);
 create table public.weekly_plan_item_completions(item_id uuid primary key,student_id uuid,completed_at timestamptz default now(),checked_at timestamptz default now(),completed_test_count smallint);
 grant usage on schema public,private,auth to authenticated;
 grant select on all tables in schema public to authenticated;
 grant execute on function auth.uid() to authenticated;
 grant execute on function private.current_user_role() to authenticated;
 `);
 await db.query("insert into public.profiles values ($1,'student','active'),($2,'student','active'),($3,'student','incomplete')",[own,other,inactive]);
 const lesson='aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',tests='bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
 await db.query("insert into public.weekly_plans values ('cccccccc-cccc-4ccc-8ccc-cccccccccccc',$1,'published',current_date-1),('dddddddd-dddd-4ddd-8ddd-dddddddddddd',$2,'published',current_date-1),('eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee',$3,'published',current_date-1),('ffffffff-ffff-4fff-8fff-ffffffffffff',$1,'draft',current_date-1),('99999999-9999-4999-8999-999999999999',$1,'published',current_date+7)",[own,other,inactive]);
 await db.query("insert into public.weekly_plan_items values($1,'cccccccc-cccc-4ccc-8ccc-cccccccccccc','lesson',null,0),($2,'cccccccc-cccc-4ccc-8ccc-cccccccccccc','practice_tests',20,0),('12345678-1234-4123-8123-123456789012','dddddddd-dddd-4ddd-8ddd-dddddddddddd','lesson',null,0),('12345678-1234-4123-8123-123456789013','eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee','lesson',null,0),('12345678-1234-4123-8123-123456789014','ffffffff-ffff-4fff-8fff-ffffffffffff','lesson',null,0),('12345678-1234-4123-8123-123456789015','99999999-9999-4999-8999-999999999999','lesson',null,0)",[lesson,tests]);
 // Install the previous production RPC, then the new migration (except the paged view;
 // its full projection is exercised in student-dashboard-load.test.cjs).
 const old=fs.readFileSync('supabase/migrations/077_plan_check_timestamps.sql','utf8');
 await db.exec(old.slice(old.indexOf('create or replace function public.set_weekly_plan_item_progress('),old.indexOf('-- Keep the older boolean-only RPC')));
 const migration=fs.readFileSync('supabase/migrations/086_student_actual_minutes.sql','utf8');
 await db.exec(migration.split('-- Add the optional value')[0]);
 const actor=async id=>{await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub',$1,false)",[id]);await db.exec('set role authenticated');};
 const save=(id,completed,count,minutes)=>db.query('select public.set_weekly_plan_item_progress($1,$2,$3,$4)',[id,completed,count,minutes]);
 await actor(own);
 await save(lesson,true,null,45);
 let row=(await db.query('select completed_minutes,completed_test_count,checked_at from public.weekly_plan_item_completions where item_id=$1',[lesson])).rows[0];
 assert.equal(row.completed_minutes,45);assert.equal(row.completed_test_count,null);
 const checkedAt=row.checked_at;
 await save(lesson,true,null,125);
 row=(await db.query('select completed_minutes,checked_at from public.weekly_plan_item_completions where item_id=$1',[lesson])).rows[0];
 assert.equal(row.completed_minutes,125);assert.equal(row.checked_at.getTime(),checkedAt.getTime(),'editing actual minutes must preserve first tick');
 await save(tests,true,9,null);
 assert.equal((await db.query('select completed_test_count,completed_minutes from public.weekly_plan_item_completions where item_id=$1',[tests])).rows[0].completed_test_count,9);
 for(const [id,completed,count,minutes] of [[lesson,true,null,0],[lesson,true,null,1441],[lesson,true,3,40],[lesson,true,null,null],[tests,true,9,30],[tests,true,null,null],[tests,false,null,1],['12345678-1234-4123-8123-123456789014',true,null,40],['12345678-1234-4123-8123-123456789015',true,null,40]]){
  await assert.rejects(()=>save(id,completed,count,minutes),undefined,`Must reject ${id} / ${completed} / ${count} / ${minutes}`);
 }
 assert.equal((await db.query('select completed_minutes from public.weekly_plan_item_completions where item_id=$1',[lesson])).rows[0].completed_minutes,125,'failed saves roll back previous tick');
 await actor(other);await assert.rejects(()=>save(lesson,true,null,30));
 await actor(inactive);await assert.rejects(()=>save('12345678-1234-4123-8123-123456789013',true,null,30));
 await db.exec('reset role');await db.exec('set role anon');await assert.rejects(()=>save(lesson,true,null,30),/permission denied/);
 await actor(own);await save(lesson,false,null,null);
 assert.equal((await db.query('select count(*)::int as n from public.weekly_plan_item_completions where item_id=$1',[lesson])).rows[0].n,0);
 await db.close();
 console.log('Actual minutes RPC: own published past activities, test-only count, validation, rollback, first tick and role isolation passed.');
})().catch(e=>{console.error(e);process.exitCode=1;});
