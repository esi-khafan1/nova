const { PGlite } = require('@electric-sql/pglite');
const { readFileSync } = require('node:fs');
const { randomUUID } = require('node:crypto');
const assert = require('node:assert/strict');

(async () => {
  const db = new PGlite();
  const ids = Object.fromEntries(['admin','student','accountOnly','missingDetails','unverified','active','other'].map(key=>[key,randomUUID()]));
  const receiptFile = '44444444-4444-4444-8444-444444444444.png';
  const path = (name,file=receiptFile) => `${ids[name]}/${file}`;
  await db.exec(`
    create role authenticated; create role anon; create schema auth; create schema private; create schema storage;
    create type public.app_role as enum ('admin','counselor','student');
    create type public.study_field as enum ('mathematics','experimental_sciences','humanities','arts','foreign_languages');
    create table public.profiles(id uuid primary key,role public.app_role,registration_status text);
    create table public.student_registrations(student_id uuid primary key,full_name text not null,
      phone text,telegram_id text,grade smallint not null,study_field public.study_field not null,
      province text not null,city text not null,additional_notes text not null default '',
      receipt_path text not null,receipt_name text not null,submitted_at timestamptz not null default now(),
      approved_at timestamptz,approved_by uuid,
      constraint student_registrations_study_field_check check (study_field::text in ('mathematics','experimental_sciences','humanities')));
    create table public.student_account_details(student_id uuid primary key,full_name text,phone text,
      telegram_id text,grade smallint,study_field public.study_field,province text,city text,additional_notes text);
    create table auth.users(id uuid primary key,email_confirmed_at timestamptz,phone_confirmed_at timestamptz);
    create table storage.objects(bucket_id text,name text);
    alter table storage.objects enable row level security;
    create function storage.foldername(text) returns text[] language sql immutable as $$select string_to_array($1,'/')$$;
    create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
    create function private.current_user_role() returns public.app_role language sql stable security definer
      as $$select role from public.profiles where id=auth.uid()$$;
    grant usage on schema public,auth,private,storage to authenticated;
    grant select on public.profiles,public.student_registrations,public.student_account_details to authenticated;
    grant insert,select,delete on storage.objects to authenticated;
    create policy admin_receipt_read on storage.objects for select to authenticated
      using ((select private.current_user_role())='admin');
  `);
  for(const [name,id] of Object.entries(ids)) {
    await db.query('insert into public.profiles values($1,$2,$3)',[id,name==='admin'?'admin':'student',name==='active'?'active':name==='student'?'pending':'incomplete']);
    if(name!=='admin')await db.query('insert into auth.users values($1,null,$2)',[id,name==='unverified'?null:new Date()]);
  }
  for(const name of ['accountOnly','active'])await db.query(
    "insert into public.student_account_details values($1,'نام دانش آموز',null,null,11,'arts','تهران','تهران','یادداشت')",[ids[name]]);
  await db.query("insert into public.student_registrations values($1,'نام دانش آموز',null,null,10,'humanities','تهران','تهران','', $2,'old.png',now(),now(),$3)",[ids.student,path('student','old.png'),ids.admin]);
  await db.exec(readFileSync('supabase/migrations/094_admin_student_receipt_upload.sql','utf8'));
  const actor=async name=>{await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub',$1,false)",[ids[name]]);await db.exec('set role authenticated');};
  const save=(name,expected,file=receiptFile)=>db.query('select public.admin_submit_student_receipt($1,$2,$3,$4)',[ids[name],expected,path(name,file),file]);
  const object=async(name,file=receiptFile)=>{await db.exec('reset role');await db.query("insert into storage.objects values('registration-receipts',$1)",[path(name,file)]);await db.exec('set role authenticated');};
  const status=async name=>(await db.query('select registration_status from public.profiles where id=$1',[ids[name]])).rows[0].registration_status;

  await actor('admin');
  // Like requireProfile on the server, resolve the actor before calling Storage.
  await db.query('select private.current_user_role()');
  await db.query("insert into storage.objects values('registration-receipts',$1)",[path('student')]);
  await assert.rejects(db.query("insert into storage.objects values('registration-receipts',$1)",[path('active')]),/row-level security/);
  await object('accountOnly'); await object('missingDetails'); await object('unverified'); await object('active');
  await assert.rejects(save('student',null),/Receipt changed/);
  await assert.rejects(save('student',path('student','old.png'),'other.png'),/Valid private student receipt required/);
  await save('student',path('student','old.png'));
  assert.equal(await status('student'),'pending');
  const edited=(await db.query('select receipt_path,approved_at,approved_by from public.student_registrations where student_id=$1',[ids.student])).rows[0];
  assert.equal(edited.receipt_path,path('student')); assert.equal(edited.approved_at,null); assert.equal(edited.approved_by,null);
  await assert.rejects(save('student',path('student','old.png')),/Receipt changed/);
  await save('accountOnly',null);
  assert.equal(await status('accountOnly'),'pending');
  const created=(await db.query('select full_name,study_field from public.student_registrations where student_id=$1',[ids.accountOnly])).rows[0];
  assert.equal(created.full_name,'نام دانش آموز'); assert.equal(created.study_field,'arts');
  await assert.rejects(save('missingDetails',null),/Complete account information required/);
  await assert.rejects(save('unverified',null),/Confirmed student required/);
  await assert.rejects(save('active',null),/Inactive student required/);
  await db.exec('reset role');
  const log=(await db.query('select student_id,admin_id,previous_receipt_path from private.admin_receipt_uploads order by id')).rows;
  await db.exec('set role authenticated');
  assert.equal(log.length,2); assert.equal(log[0].admin_id,ids.admin); assert.equal(log[0].previous_receipt_path,path('student','old.png'));
  assert.equal(log[1].student_id,ids.accountOnly);
  const policies=(await db.query("select polname from pg_policy where polrelid='storage.objects'::regclass")).rows.map(r=>r.polname);
  assert.ok(policies.includes('receipt_upload_admin_student')); assert.ok(policies.includes('receipt_remove_unused_admin'));
  await actor('other');
  await db.query('select private.current_user_role()');
  await assert.rejects(db.query("insert into storage.objects values('registration-receipts',$1)",[path('other')]),/row-level security/);
  await assert.rejects(save('accountOnly',path('accountOnly')),/Admin only/);
  await assert.rejects(db.query('select * from private.admin_receipt_uploads'),/permission denied/);
  await db.exec('reset role; set role anon');
  await assert.rejects(save('accountOnly',path('accountOnly')),/permission denied/);
  await db.close();
  console.log('PASS: admin private receipt attach requires fresh target, inactive verified student and account details; pending review and private audit without auto-approval');
})().catch(error=>{console.error(error);process.exitCode=1});
