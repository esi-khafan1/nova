const assert=require('node:assert/strict');
const fs=require('node:fs');
const {PGlite}=require('@electric-sql/pglite');
(async()=>{
 const db=new PGlite();
 await db.exec(`create role authenticated;create role anon;create schema private;create schema auth;
 create type public.app_role as enum ('counselor','student');create type public.content_status as enum ('draft','published');
 create table public.counselor_students(student_id uuid,counselor_id uuid);
 create table public.weekly_plans(id uuid primary key,counselor_id uuid,routines jsonb not null default '[]',status public.content_status);
 create table public.weekly_plan_items(id uuid,plan_id uuid,day_of_week smallint,subject text,chapter text,activity_type text,linked_exam_id uuid);
 create table public.exams(id uuid);
 create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
 create function private.current_user_role() returns public.app_role language sql stable as $$select nullif(current_setting('test.role',true),'')::public.app_role$$;
 create function public.save_weekly_plan_v4(uuid,uuid,date,text,text,public.content_status,jsonb) returns uuid language sql as $$select $1$$;`);
 await db.exec(fs.readFileSync('supabase/migrations/111_two_daily_routines.sql','utf8'));
 const counselor='11111111-1111-4111-8111-111111111111', student='22222222-2222-4222-8222-222222222222', plan='33333333-3333-4333-8333-333333333333';
 await db.query('insert into public.counselor_students values($1,$2)',[student,counselor]);
 const old=Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'ریاضی',details:'قبلی'}));
 await db.query("insert into public.weekly_plans values($1,$2,$3::jsonb,'published')",[plan,counselor,JSON.stringify(old)]);
 await db.query("select set_config('request.jwt.claim.sub',$1,false),set_config('test.role','counselor',false)",[counselor]);
 const save=async rows=>db.query("select public.save_weekly_plan_v5($1,$2,current_date,'title','','published','[]'::jsonb,$3::jsonb)",[plan,student,JSON.stringify(rows)]);
 const get=async()=>(await db.query('select routines from public.weekly_plans where id=$1',[plan])).rows[0].routines;
 const both=old.map((r,i)=>({...r,secondSubject:i===0?' فارسی ':'',secondDetails:i===0?' مرور ':''}));
 await save(both);let saved=await get();assert.equal(saved[0].subject,'ریاضی');assert.equal(saved[0].secondSubject,'فارسی');assert.equal(saved[0].secondDetails,'مرور');
 // A stale client may update the first routine, but cannot erase the second.
 await save(old.map((r,i)=>({...r,details:i===0?'ویرایش قدیمی':r.details})));saved=await get();assert.equal(saved[0].details,'ویرایش قدیمی');assert.equal(saved[0].secondSubject,'فارسی');assert.equal(saved[0].secondDetails,'مرور');
 // Explicit deletion from a new client is respected.
 await save(both.map(r=>({...r,secondSubject:'',secondDetails:''})));saved=await get();assert.equal(saved[0].secondSubject,'');assert.equal(saved[0].secondDetails,'');
 await assert.rejects(save([...old.slice(0,6),old[0]]),/Duplicate routine day/);
 await assert.rejects(save(old.slice(0,6)),/Exactly seven daily routines/);
 await db.query("select set_config('test.role','student',false)");await assert.rejects(save(both),/Only counselors/);
 await db.close();console.log('PASS: two routines save, legacy plans and stale clients retain values, explicit clears work, and authorization remains.');
})().catch(e=>{console.error(e);process.exitCode=1});
