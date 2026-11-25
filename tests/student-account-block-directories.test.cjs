const assert=require('node:assert/strict'),fs=require('node:fs'),{PGlite}=require('@electric-sql/pglite');
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create schema auth;
 create type public.app_role as enum('student','admin','counselor');create type public.study_field as enum('mathematics');
 create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('test.uid',true),'')::uuid$$;
 create table public.profiles(id uuid primary key,role public.app_role,full_name text,phone text,grade smallint,study_field public.study_field,registration_status text,created_at timestamptz,service_course_type text,service_course_duration_months integer);
 create function private.current_user_role() returns public.app_role language sql stable as $$select role from public.profiles where id=auth.uid()$$;
 create table auth.users(id uuid primary key,email text,phone text);
 create table public.student_registrations(student_id uuid primary key,phone text,telegram_id text,province text,city text,receipt_path text,receipt_name text,course_type text,course_duration_months integer,additional_notes text);
 create table public.student_account_details(student_id uuid primary key,telegram_id text,province text,city text,additional_notes text);
 create table public.counselor_students(student_id uuid,counselor_id uuid,created_at timestamptz);
 create function public.admin_student_plan_service_reviews() returns table(student_id uuid,review_plan_count integer) language sql stable as $$select id,4 from public.profiles where registration_status='active'$$;
 insert into public.profiles(id,role,full_name,grade,registration_status,created_at)
 select ('00000000-0000-4000-8000-'||lpad(i::text,12,'0'))::uuid,'student','student '||i,10,'active','2026-01-01'::timestamptz+i*interval '1 second' from generate_series(1,25)i;
 insert into public.profiles(id,role,full_name,registration_status,created_at) values
 ('00000000-0000-4000-8001-000000000001','admin','admin','active',now()),
 ('00000000-0000-4000-8001-000000000002','counselor','counselor','active',now());
 insert into public.counselor_students select id,'00000000-0000-4000-8001-000000000002',now() from public.profiles where role='student';`);
 await db.exec(fs.readFileSync('supabase/migrations/113_registration_phone_search.sql','utf8').split('create or replace function public.admin_registration_directory_page')[0]);
 await db.exec(fs.readFileSync('supabase/experimental/student_account_blocks_foundation.sql','utf8'));
 await db.exec(fs.readFileSync('supabase/experimental/student_account_block_directories.sql','utf8'));
 const id='00000000-0000-4000-8000-000000000025',admin='00000000-0000-4000-8001-000000000001',counselor='00000000-0000-4000-8001-000000000002';
 await db.query('insert into private.student_account_blocks(student_id,blocked_by) values($1,$2)',[id,admin]);
 await db.exec(`set test.uid='${admin}'`);
 const users=async(filter,page=1)=>(await db.query('select public.experimental_admin_user_directory_page($1,$2,$3) data',['',page,filter])).rows[0].data;
 assert.equal((await users('all')).total,27);
 assert.equal((await users('active')).total,26);
 const blocked=await users('blocked');assert.equal(blocked.total,1);assert.equal(blocked.rows[0].id,id);assert.equal(blocked.rows[0].blocked,true);
 await assert.rejects(users('anything'),/Invalid account filter/);
 const registration=async(page)=>(await db.query('select public.experimental_admin_registration_directory_page($1,$2,$3,$4) data',['',null,false,page])).rows[0].data;
 const pages=await Promise.all([1,2,3].map(registration));
 assert.equal(pages[0].total,24);assert.equal(pages[0].assigned,24);assert.equal(pages[0].review_count,24);
 assert.deepEqual(pages.map(p=>p.rows.length),[10,10,4]);assert.ok(pages.flatMap(p=>p.rows).every(r=>r.student_id!==id));
 await db.exec(`set test.uid='${counselor}'`);
 const directory=await db.query('select * from public.experimental_counselor_student_directory()');assert.equal(directory.rows.length,24);assert.ok(directory.rows.every(row=>row.student_id!==id));
 await assert.rejects(users('all'),/Only administrators/);
 await db.query('delete from private.student_account_blocks where student_id=$1',[id]);
 assert.equal((await db.query('select * from public.experimental_counselor_student_directory()')).rows.length,25);
 console.log('PASS: experimental directory filtering before pagination and student restoration');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
