const { PGlite } = require('@electric-sql/pglite');
const { readFileSync } = require('node:fs');
const { randomUUID } = require('node:crypto');
const assert = require('node:assert/strict');

(async () => {
  const db = new PGlite();
  const id = Object.fromEntries(['admin','student','old','next','unapproved','other','plan','item','completion','exam'].map(k => [k,randomUUID()]));
  await db.exec(`
    create role authenticated; create role anon; create schema auth; create schema private; create schema storage;
    create type public.app_role as enum('admin','student','counselor');
    create type public.content_status as enum('draft','published');
    create table public.profiles(id uuid primary key,role public.app_role,registration_status text not null,
      constraint profiles_registration_status_check check(registration_status in ('incomplete','pending','active')));
    create table public.counselor_profiles(user_id uuid primary key,approval_status text);
    create table public.counselor_students(id uuid primary key default gen_random_uuid(),student_id uuid,counselor_id uuid,created_at timestamptz default now());
    create table public.weekly_plans(id uuid primary key,student_id uuid,counselor_id uuid,status public.content_status);
    create table public.weekly_plan_items(id uuid primary key,plan_id uuid);
    create table public.weekly_plan_item_completions(id uuid primary key,student_id uuid,item_id uuid);
    create table public.exams(id uuid primary key,status public.content_status);
    create table public.exam_attempts(student_id uuid,exam_id uuid,submitted_at timestamptz);
    create table public.exam_sessions(student_id uuid,exam_id uuid);
    create table auth.users(id uuid primary key,phone_confirmed_at timestamptz,email_confirmed_at timestamptz);
    create table storage.objects(bucket_id text,name text);
    create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
    create function private.current_user_role() returns public.app_role language sql stable security definer as $$select role from public.profiles where id=auth.uid()$$;
    create function storage.foldername(text) returns text[] language sql immutable as $$select string_to_array($1,'/')$$;
    grant usage on schema public,auth,private,storage to authenticated;
    grant select on all tables in schema public to authenticated;
    grant select,insert on storage.objects to authenticated;
    grant update(registration_status) on public.profiles to authenticated;
    grant update(status) on public.weekly_plans to authenticated;
  `);
  const policies={
    weekly_plans: { select:['plan_participants_read','assigned_counselor_published_history'],insert:['assigned_counselors_create_plans'],update:['counselors_update_own_plans'],delete:['counselors_delete_own_plans'] },
    weekly_plan_items: {select:['plan_participants_read_items','assigned_counselor_published_items'],insert:['counselors_create_plan_items'],update:['counselors_update_plan_items'],delete:['counselors_delete_plan_items']},
    weekly_plan_item_completions: {select:['completion_participants_read','assigned_counselor_published_completions']},
    exam_attempts: {select:['participants_read_exam_attempts']}, exam_sessions:{select:['student_reads_own_exam_session']},
  };
  for(const [table,cmds] of Object.entries(policies)){
    await db.exec(`alter table public.${table} enable row level security;`);
    for(const [cmd,names] of Object.entries(cmds))for(const name of names)
      await db.exec(`create policy ${name} on public.${table} for ${cmd} to authenticated ${cmd==='insert'?'with check(true)':cmd==='update'?'using(true) with check(true)':'using(true)'};`);
  }
  await db.exec(`
    alter table storage.objects enable row level security;
    create policy receipt_upload_own_pending on storage.objects for insert to authenticated with check(true);
    create policy receipt_upload_admin_student on storage.objects for insert to authenticated with check(true);
  `);
  for(const [name,uid] of Object.entries(id).filter(([k])=>['admin','student','old','next','unapproved','other'].includes(k)))
    await db.query('insert into public.profiles values($1,$2,$3)',[uid,name==='admin'?'admin':['old','next','unapproved'].includes(name)?'counselor':'student','active']);
  await db.query("insert into public.counselor_profiles values($1,'approved'),($2,'approved'),($3,'pending')",[id.old,id.next,id.unapproved]);
  await db.query('insert into public.counselor_students(student_id,counselor_id) values($1,$2)',[id.student,id.old]);
  await db.query('insert into auth.users values($1,now(),null)',[id.student]);
  await db.query("insert into public.weekly_plans values($1,$2,$3,'published')",[id.plan,id.student,id.old]);
  await db.query('insert into public.weekly_plan_items values($1,$2)',[id.item,id.plan]);
  await db.query('insert into public.weekly_plan_item_completions values($1,$2,$3)',[id.completion,id.student,id.item]);
  await db.query("insert into public.exams values($1,'published')",[id.exam]);
  await db.query('insert into public.exam_attempts values($1,$2,now())',[id.student,id.exam]);
  await db.exec(readFileSync('supabase/migrations/095_admin_student_service_controls.sql','utf8'));
  const actor=async name=>{await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub',$1,false)",[id[name]]);await db.exec('set role authenticated');await db.query('select private.current_user_role()');};
  const state=async()=>(await db.query('select registration_status from public.profiles where id=$1',[id.student])).rows[0].registration_status;
  const count=async table=>(await db.query(`select count(*)::int n from public.${table} where student_id=$1`,[id.student])).rows[0].n;
  const disable=expected=>db.query('select public.admin_disable_student($1,$2)',[id.student,expected]);
  const resume=target=>db.query('select public.admin_resume_student($1,$2)',[id.student,target]);
  const change=(expected,target)=>db.query('select public.admin_change_student_counselor($1,$2,$3)',[id.student,expected,target]);
  await actor('admin');
  await assert.rejects(disable(id.next),/Counselor changed/);
  assert.equal(await state(),'active');
  await disable(id.old);
  assert.equal(await state(),'disabled'); assert.equal(await count('counselor_students'),0);
  assert.equal(await count('weekly_plans'),1,'disable preserves the historical plan');
  assert.equal(await count('exam_attempts'),1,'disable preserves the historical exam result');
  await assert.rejects(disable(id.old),/Active student required/);
  await assert.rejects(resume(id.unapproved),/Approved counselor required/);
  await assert.rejects(db.query("update public.profiles set registration_status='active' where id=$1",[id.student]),/audited admin resume/);
  await actor('student');
  assert.equal((await db.query('select count(*)::int n from public.weekly_plans')).rows[0].n,0);
  assert.equal((await db.query('select count(*)::int n from public.weekly_plan_items')).rows[0].n,0);
  assert.equal((await db.query('select count(*)::int n from public.weekly_plan_item_completions')).rows[0].n,0);
  assert.equal((await db.query('select count(*)::int n from public.exam_attempts')).rows[0].n,0);
  assert.equal((await db.query('select private.student_has_submitted_exam($1,$2) as ok',[id.exam,id.student])).rows[0].ok,false);
  await assert.rejects(db.query("update public.profiles set registration_status='active' where id=$1",[id.student]),/audited admin resume/);
  await assert.rejects(resume(id.next),/Admin only/);
  await actor('admin');
  await resume(id.next);
  assert.equal(await state(),'active'); assert.equal(await count('counselor_students'),1);
  await actor('old');
  assert.equal((await db.query('select count(*)::int n from public.weekly_plans')).rows[0].n,0,'old counselor loses historical plan access');
  assert.equal((await db.query('select count(*)::int n from public.weekly_plan_items')).rows[0].n,0);
  assert.equal((await db.query('select count(*)::int n from public.weekly_plan_item_completions')).rows[0].n,0);
  assert.equal((await db.query("update public.weekly_plans set status='draft' where id=$1 returning id",[id.plan])).rows.length,0,'former counselor cannot edit a historical plan');
  await actor('next');
  assert.equal((await db.query('select count(*)::int n from public.weekly_plans')).rows[0].n,1,'new counselor sees old published history');
  assert.equal((await db.query('select count(*)::int n from public.weekly_plan_items')).rows[0].n,1);
  assert.equal((await db.query('select count(*)::int n from public.weekly_plan_item_completions')).rows[0].n,1);
  assert.equal((await db.query("update public.weekly_plans set status='draft' where id=$1 returning id",[id.plan])).rows.length,0,'new counselor views old plans read-only');
  await actor('student');
  assert.equal((await db.query('select count(*)::int n from public.weekly_plans')).rows[0].n,1);
  assert.equal((await db.query('select private.student_has_submitted_exam($1,$2) as ok',[id.exam,id.student])).rows[0].ok,true);
  await actor('admin');
  await assert.rejects(change(id.old,id.old),/Counselor changed/);
  await assert.rejects(change(id.next,id.next),/different counselor/);
  await assert.rejects(change(id.next,id.unapproved),/Approved counselor required/);
  await change(id.next,id.old);
  assert.equal(await count('weekly_plans'),1);
  await db.exec('reset role');
  const events=(await db.query('select event_type from private.student_service_events order by id')).rows.map(r=>r.event_type);
  assert.deepEqual(events,['disabled','resumed','reassigned']);
  await actor('next');
  assert.equal((await db.query('select count(*)::int n from public.weekly_plans')).rows[0].n,0);
  await db.exec('reset role; set role anon');
  await assert.rejects(disable(id.old),/permission denied/);
  await db.close();
  console.log('PASS: audited deactivate/resume/reassign, stale/role/counselor guards, preserved history and assignment-based visibility');
})().catch(e=>{console.error(e);process.exitCode=1});
