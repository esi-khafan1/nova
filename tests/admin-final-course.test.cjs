const { PGlite } = require('@electric-sql/pglite');
const { readFileSync } = require('node:fs');
const { randomUUID } = require('node:crypto');
const assert = require('node:assert/strict');
const ts = require('typescript');
const vm = require('node:vm');

// Exercise the same pure form parser that the server actions use.
const source = readFileSync('lib/admin-final-course.ts', 'utf8');
const js = ts.transpileModule(source, { compilerOptions: { module: ts.ModuleKind.CommonJS } }).outputText;
const parsed = { exports: {} };
vm.runInNewContext(js, { module: parsed, exports: parsed.exports, require: name => {
  if (name === '@/lib/course-plans') return { availableCoursePlans: [{ value: 'base' }, { value: 'progress' }] };
  if (name === '@/lib/courses') return { courseDurations: [1,3,6,12].map(value => ({ value })) };
  throw new Error(name);
}});
const parse = (course, months) => {
  const form = new FormData();
  if (course !== undefined) form.set('service_course_type', course);
  if (months !== undefined) form.set('service_course_duration_months', months);
  return parsed.exports.parseAdminFinalCourse(form);
};
assert.deepEqual(JSON.parse(JSON.stringify(parse('', ''))), { course: null, months: null });
assert.deepEqual(JSON.parse(JSON.stringify(parse('progress', '1'))), { course: 'progress', months: 1 });
for (const [course, months] of [['progress',''],['','3'],['vip','3'],['progress','2'],[undefined,'']])
  assert.equal(parse(course, months), null);

(async () => {
  const db = new PGlite();
  const ids = Object.fromEntries(['admin','student','second'].map(name => [name, randomUUID()]));
  await db.exec(`
    create role authenticated; create role anon; create schema private; create schema auth;
    create type public.app_role as enum('admin','student','counselor');
    create table public.profiles(id uuid primary key,role public.app_role,registration_status text);
    create table public.student_registrations(student_id uuid primary key,course_type text,course_duration_months smallint,receipt_path text);
    create table private.student_service_events(id bigint generated always as identity primary key,student_id uuid not null,admin_id uuid not null,
      event_type text not null constraint student_service_events_event_type_check check(event_type in ('disabled','resumed','reassigned')));
    create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
    create function private.current_user_role() returns public.app_role language sql stable security definer set search_path='' as $$select role from public.profiles where id=(select auth.uid())$$;
    grant usage on schema public,auth,private to authenticated;
    grant select on public.profiles,public.student_registrations to authenticated;
    grant update(registration_status) on public.profiles to authenticated;
    -- Delegates simulate the established activation/resume RPC contract; the
    -- wrapper must preserve their receipt/status checks and be atomic with it.
    create function public.admin_activate_student_auto(target_student_id uuid,target_counselor_id uuid,expected_receipt_path text)
    returns void language plpgsql security definer set search_path='' as $$
    begin
      if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only'; end if;
      if (select receipt_path from public.student_registrations where student_id=target_student_id) is distinct from expected_receipt_path then raise exception 'Receipt changed'; end if;
      update public.profiles set registration_status='active' where id=target_student_id and registration_status='pending';
      if not found then raise exception 'Pending required'; end if;
    end; $$;
    create function public.admin_resume_student(target_student_id uuid,target_counselor_id uuid)
    returns void language plpgsql security definer set search_path='' as $$
    begin
      if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only'; end if;
      update public.profiles set registration_status='active' where id=target_student_id and registration_status='disabled';
      if not found then raise exception 'Disabled required'; end if;
    end; $$;
  `);
  await db.exec(readFileSync('supabase/migrations/097_admin_final_student_course.sql', 'utf8'));
  await db.exec(readFileSync('supabase/migrations/098_admin_change_active_student_course.sql', 'utf8'));
  await db.query("insert into public.profiles values ($1,'admin','active'),($2,'student','pending'),($3,'student','pending')", [ids.admin,ids.student,ids.second]);
  await db.query("insert into public.student_registrations values ($1,'base',3,'receipt.jpg')", [ids.student]);
  const actor = async name => {
    await db.exec('reset role');
    await db.query("select set_config('request.jwt.claim.sub',$1,false)",[ids[name]]);
    await db.exec('set role authenticated');
  };
  const activate = (student, receipt, course, months) => db.query('select public.admin_activate_student_with_course($1,$2,$3,$4,$5)',[student,ids.admin,receipt,course,months]);
  const resume = (course,months) => db.query('select public.admin_resume_student_with_course($1,$2,$3,$4)',[ids.student,ids.admin,course,months]);
  const change = (expectedCourse,expectedMonths,nextCourse,nextMonths) => db.query('select public.admin_change_student_course($1,$2,$3,$4,$5)',[ids.student,expectedCourse,expectedMonths,nextCourse,nextMonths]);
  const state = async () => (await db.query('select registration_status,service_course_type,service_course_duration_months from public.profiles where id=$1',[ids.student])).rows[0];
  await actor('student');
  await assert.rejects(activate(ids.student,'receipt.jpg','progress',6),/Admin only/);
  await assert.rejects(change(null,null,'base',3),/Admin only/);
  await assert.rejects(db.query("update public.profiles set service_course_type='base' where id=$1",[ids.student]),/permission denied/);
  await actor('admin');
  await assert.rejects(activate(ids.student,'old.jpg','progress',6),/Receipt changed/);
  await assert.rejects(activate(ids.student,'receipt.jpg','progress',null),/Invalid final course/);
  await assert.rejects(activate(ids.student,'receipt.jpg',null,6),/Invalid final course/);
  await assert.rejects(activate(ids.student,'receipt.jpg','vip',6),/Invalid final course/);
  assert.equal((await state()).registration_status,'pending');
  await activate(ids.student,'receipt.jpg','progress',6);
  assert.deepEqual(stateToPlain(await state()),{ registration_status:'active', service_course_type:'progress', service_course_duration_months:6 });
  const requested = (await db.query('select course_type,course_duration_months,receipt_path from public.student_registrations where student_id=$1',[ids.student])).rows[0];
  assert.deepEqual(requested,{course_type:'base',course_duration_months:3,receipt_path:'receipt.jpg'});
  await assert.rejects(activate(ids.student,'receipt.jpg','base',3),/Pending required/);
  await assert.rejects(change('base',3,'progress',1),/Course changed/);
  await assert.rejects(change('progress',6,'progress',6),/Choose a different/);
  await assert.rejects(change('progress',6,'cip',3),/Invalid final course/);
  await assert.rejects(change('progress',6,'base',2),/Invalid final course/);
  await change('progress',6,'base',12);
  assert.deepEqual(stateToPlain(await state()),{ registration_status:'active', service_course_type:'base', service_course_duration_months:12 });
  assert.deepEqual((await db.query('select course_type,course_duration_months,receipt_path from public.student_registrations where student_id=$1',[ids.student])).rows[0],requested);
  await assert.rejects(change('progress',6,null,null),/Course changed/);
  await db.exec('reset role');
  await db.query("update public.profiles set registration_status='disabled' where id=$1",[ids.student]);
  await actor('admin');
  await assert.rejects(change('base',12,null,null),/Active student required/);
  await resume(null,null);
  assert.deepEqual(stateToPlain(await state()),{ registration_status:'active', service_course_type:null, service_course_duration_months:null });
  await assert.rejects(resume('base',3),/Disabled required/);
  await change(null,null,'progress',1);
  assert.deepEqual(stateToPlain(await state()),{ registration_status:'active', service_course_type:'progress', service_course_duration_months:1 });
  await db.exec('reset role');
  const events=(await db.query('select event_type,previous_course_type,new_course_type from private.student_service_events order by id')).rows;
  assert.deepEqual(events,[
    {event_type:'course_activated',previous_course_type:null,new_course_type:'progress'},
    {event_type:'course_changed',previous_course_type:'progress',new_course_type:'base'},
    {event_type:'course_resumed',previous_course_type:'base',new_course_type:null},
    {event_type:'course_changed',previous_course_type:null,new_course_type:'progress'},
  ]);
  // Blank assignment is also valid for the first activation, not just resume.
  await actor('admin');
  await activate(ids.second,null,null,null);
  await db.close();
  console.log('PASS: admin-only final course, optional paired duration, receipt guard, original purchase preserved, audited atomic activation/resume/change');
})().catch(err=>{console.error(err);process.exitCode=1});
function stateToPlain(row){return { registration_status:row.registration_status, service_course_type:row.service_course_type, service_course_duration_months:row.service_course_duration_months };}
