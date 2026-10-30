const test = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const { randomUUID } = require('node:crypto');
const { PGlite } = require('@electric-sql/pglite');

test('optional personal details preserve required study/location fields and receipt/activation guards', async () => {
  const db = new PGlite();
  try {
    const active = randomUUID(), enrolling = randomUUID();
    await db.exec(`
      create role authenticated; create role anon; create schema auth; create schema storage;
      create type public.study_field as enum('mathematics','experimental_sciences','humanities','arts','foreign_languages');
      create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
      create table auth.users(id uuid primary key,email_confirmed_at timestamptz,phone_confirmed_at timestamptz);
      create table public.profiles(id uuid primary key,role text,registration_status text,full_name text not null,phone text,grade smallint,study_field public.study_field);
      create table storage.objects(bucket_id text,name text);
      create table public.student_account_details (
        student_id uuid primary key,full_name text not null check(char_length(btrim(full_name)) between 3 and 121 and position(' ' in btrim(full_name))>0),
        phone text not null check(phone ~ '^09[0-9]{9}$'),telegram_id text not null check(telegram_id ~ '^[A-Za-z][A-Za-z0-9_]{4,31}$'),
        grade smallint not null check(grade in (10,11,12)),study_field public.study_field not null,
        province text not null check(char_length(btrim(province)) between 2 and 60),city text not null check(char_length(btrim(city)) between 2 and 60),
        additional_notes text not null default '' check(char_length(additional_notes)<=2000),updated_at timestamptz not null default now()
      );
      create table public.student_registrations (
        student_id uuid primary key,full_name text not null check(char_length(btrim(full_name)) between 3 and 121),
        first_name text check(char_length(btrim(first_name)) between 2 and 50),last_name text check(char_length(btrim(last_name)) between 2 and 70),
        phone text not null check(phone ~ '^09[0-9]{9}$'),telegram_id text not null check(telegram_id ~ '^[A-Za-z][A-Za-z0-9_]{4,31}$'),
        grade smallint not null check(grade in (10,11,12)),study_field public.study_field not null,
        province text not null check(char_length(btrim(province)) between 2 and 60),city text not null check(char_length(btrim(city)) between 2 and 60),
        receipt_path text not null,receipt_name text not null check(char_length(receipt_name) between 1 and 150),
        course_type text,course_duration_months smallint,additional_notes text not null default '',submitted_at timestamptz not null default now()
      );
      create function public.save_student_account_details(jsonb) returns void language sql as $$select$$;
      create function public.submit_student_registration(jsonb) returns void language sql as $$select$$;
      revoke all on function public.save_student_account_details(jsonb),public.submit_student_registration(jsonb) from public,anon;
      grant usage on schema auth,public to authenticated;
    `);
    await db.exec(readFileSync('supabase/migrations/088_optional_student_personal_details.sql', 'utf8'));
    await db.query('insert into auth.users values($1,null,now()),($2,null,now())', [active, enrolling]);
    await db.query("insert into public.profiles values($1,'student','active','Initial Name',null,null,null),($2,'student','incomplete','Signup Name',null,null,null)", [active, enrolling]);
    await db.query('insert into storage.objects values($1,$2)', ['registration-receipts', `${enrolling}/receipt.png`]);
    await db.query("select set_config('request.jwt.claim.sub',$1,false)", [active]);
    await db.exec('set role authenticated');
    const save = payload => db.query('select public.save_student_account_details($1)', [payload]);
    const profile = { grade: 11, study_field: 'humanities', province: 'تهران', city: 'تهران' };
    await save(profile);
    await assert.rejects(() => save({ ...profile, grade: null }), /Grade and study field required/);
    await assert.rejects(() => save({ ...profile, study_field: null }), /Grade and study field required/);
    await assert.rejects(() => save({ ...profile, province: '' }), /violates check constraint/);
    await assert.rejects(() => save({ ...profile, city: '' }), /violates check constraint/);
    await assert.rejects(() => save({ ...profile, telegram_id: 'bad' }), /violates check constraint/);
    await db.exec('reset role');
    let row = await db.query('select full_name,phone,telegram_id,grade,study_field,province,city from public.student_account_details where student_id=$1', [active]);
    assert.equal(row.rows[0].full_name, null);
    assert.equal(row.rows[0].phone, null);
    assert.equal(row.rows[0].telegram_id, null);
    assert.equal(row.rows[0].province, 'تهران');
    assert.equal((await db.query('select full_name,registration_status from public.profiles where id=$1', [active])).rows[0].full_name, 'Initial Name');
    assert.equal((await db.query('select registration_status from public.profiles where id=$1', [active])).rows[0].registration_status, 'active');
    await db.query("select set_config('request.jwt.claim.sub',$1,false)", [enrolling]);
    await db.exec('set role authenticated');
    const enroll = payload => db.query('select public.submit_student_registration($1)', [payload]);
    const request = { ...profile, receipt_path: `${enrolling}/receipt.png`, receipt_name: 'receipt.png', course_type: 'base', course_duration_months: 3 };
    await assert.rejects(() => enroll({ ...request, receipt_path: `${active}/receipt.png` }), /private receipt/);
    await assert.rejects(() => enroll({ ...request, grade: null }), /Grade and study field required/);
    await assert.rejects(() => enroll({ ...request, study_field: null }), /Grade and study field required/);
    await enroll(request);
    await db.exec('reset role');
    row = await db.query('select full_name,phone,telegram_id,grade,study_field,province,city,receipt_path from public.student_registrations where student_id=$1', [enrolling]);
    assert.equal(row.rows[0].full_name, null);
    assert.equal(row.rows[0].phone, null);
    assert.equal(row.rows[0].telegram_id, null);
    assert.equal(row.rows[0].grade, 11);
    assert.equal(row.rows[0].study_field, 'humanities');
    assert.equal(row.rows[0].receipt_path, request.receipt_path);
    assert.equal((await db.query('select registration_status from public.profiles where id=$1', [enrolling])).rows[0].registration_status, 'pending');
    await db.exec('set role anon');
    await assert.rejects(() => enroll(request), /permission denied/);
  } finally { await db.close(); }
});
