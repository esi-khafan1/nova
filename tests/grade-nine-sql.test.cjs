const {PGlite} = require('@electric-sql/pglite');
const assert = require('node:assert/strict');
const fs = require('node:fs');
(async()=>{
 const db = new PGlite();
 try {
  await db.exec(`
  create role authenticated; create role anon;
  create schema auth; create schema private;
  create table auth.users(id uuid primary key,email_confirmed_at timestamptz,phone_confirmed_at timestamptz);
  create type public.study_field as enum ('mathematics','experimental_sciences','humanities','arts','foreign_languages');
  create type public.app_role as enum ('student','counselor');
  create type public.content_status as enum ('draft','published');
  create type public.study_activity_type as enum ('lesson','exam','exam_analysis');
  create table public.profiles(id uuid primary key, role public.app_role, grade smallint check(grade between 10 and 12), study_field public.study_field,full_name text,phone text,registration_status text);
  create table public.student_account_details(student_id uuid primary key,grade smallint not null check(grade in (10,11,12)),study_field public.study_field not null,full_name text,phone text,telegram_id text,province text,city text,additional_notes text,updated_at timestamptz);
  create table public.school_subjects(study_field public.study_field not null,grade smallint not null check(grade in (10,11,12)),subject text not null,primary key(study_field,grade,subject));
  create function auth.uid() returns uuid language sql stable as $$select '33333333-3333-4333-8333-333333333333'::uuid$$;
  create function private.current_user_role() returns public.app_role language sql stable as $$select 'counselor'::public.app_role$$;
  create table public.counselor_students(counselor_id uuid, student_id uuid);
  create table public.weekly_plans(id uuid, counselor_id uuid, status public.content_status);
  create function public.save_weekly_plan_v3(uuid,uuid,date,text,text,public.content_status,jsonb) returns uuid language sql as $$select '44444444-4444-4444-8444-444444444444'::uuid$$;
  create table public.weekly_plan_items(plan_id uuid,day_of_week smallint,sort_order int,source_grade smallint check(source_grade in (10,11,12)),preparation_track text not null default 'konkur',exam_year smallint,
   constraint school_metadata_check check ((preparation_track='konkur' and exam_year is null) or (preparation_track='final_exam' and source_grade is not null and source_grade in (10,11,12) and (exam_year is null or exam_year=1406))));
  `);
  await db.exec(fs.readFileSync('supabase/migrations/100_grade_nine_planning_and_exam_troubleshooting.sql','utf8'));
  const g9='11111111-1111-4111-8111-111111111111';
  await db.query('insert into public.profiles(id,grade,study_field) values($1,9,null)',[g9]);
  await db.query('insert into public.student_account_details(student_id,grade,study_field) values($1,9,null)',[g9]);
  await db.query('insert into public.counselor_students(counselor_id,student_id) values($1,$2)',['33333333-3333-4333-8333-333333333333',g9]);
  assert.equal((await db.query('select count(distinct subject)::int as n from public.school_subjects where grade=9')).rows[0].n,14);
  assert.equal((await db.query("select 'exam_troubleshooting'::public.study_activity_type::text as type")).rows[0].type,'exam_troubleshooting');
  await assert.rejects(db.query('insert into public.student_account_details(student_id,grade,study_field) values($1,10,null)',['22222222-2222-4222-8222-222222222222']));
  await db.query('insert into public.weekly_plan_items(source_grade,preparation_track) values(9,$1)',['final_exam']);
  await assert.rejects(db.query('insert into public.weekly_plan_items(source_grade,preparation_track,exam_year) values(9,$1,1406)',['final_exam']));
  const plan = (grade,track,subject,publisher=null)=>[{dayOfWeek:0,durationMinutes:60,activityType:'lesson',subject,sourceGrade:grade,preparationTrack:track,recommendedPublisher:publisher}];
  const save = items => db.query('select public.save_weekly_plan_v4(null,$1,$2,$3,null,$4,$5::jsonb) as id',[g9,'2026-11-07','برنامه','draft',JSON.stringify(items)]);
  assert.equal((await save(plan(9,'final_exam','ریاضی'))).rows[0].id,'44444444-4444-4444-8444-444444444444');
  await save(plan(9,'konkur','هوش و استعداد تحلیلی'));
  const accountId='33333333-3333-4333-8333-333333333333';
  await db.query('insert into auth.users(id,email_confirmed_at) values($1,now())',[accountId]);
  await db.query('insert into public.profiles(id,role,grade) values($1,$2,10)',[accountId,'student']);
  const account = payload=>db.query('select public.save_student_account_details($1::jsonb)',[JSON.stringify(payload)]);
  const basics={full_name:'سارا رضایی',province:'تهران',city:'تهران'};
  await account({...basics,grade:9,study_field:null});
  assert.deepEqual((await db.query('select grade,study_field from public.student_account_details where student_id=$1',[accountId])).rows[0],{grade:9,study_field:null});
  await assert.rejects(account({...basics,grade:9,study_field:'humanities'}));
  await assert.rejects(account({...basics,grade:10,study_field:null}));
  await assert.rejects(account({...basics,grade:null,study_field:null}));
  await assert.rejects(save(plan(9,'final_exam','هوش و استعداد تحلیلی')));
  await assert.rejects(save(plan(9,'konkur','ریاضی')));
  await assert.rejects(save(plan(9,'konkur','هوش و استعداد تحلیلی','گاج')));
  console.log('PASS: grade-nine migration checks and plan RPC school/aptitude validation work in PostgreSQL');
 } finally {await db.close();}
})().catch(e=>{console.error(e);process.exitCode=1});
