const { PGlite } = require('@electric-sql/pglite');
const assert = require('node:assert/strict');
const fs = require('node:fs');

const todayMigration = fs.readFileSync('supabase/migrations/090_edit_published_plan_today.sql', 'utf8');
const completedMigration = fs.readFileSync('supabase/migrations/091_completed_boxes_and_linked_exam_removal.sql', 'utf8');
const examMigration = fs.readFileSync('supabase/migrations/079_exam_plan_boxes.sql', 'utf8');
const v5 = 'create or replace function public.save_weekly_plan_v5(' + examMigration.split('create or replace function public.save_weekly_plan_v5(')[1].split('revoke all on function public.save_weekly_plan_v5(')[0];
const v6 = fs.readFileSync('supabase/migrations/085_konkur_recommended_publisher.sql', 'utf8').split('-- Re-issue the student RPC')[0];
const ids = {
  counselor: '33333333-3333-4333-8333-333333333333',
  other: '22222222-2222-4222-8222-222222222222',
  student: '44444444-4444-4444-8444-444444444444',
  plan: '66666666-6666-4666-8666-666666666666',
  past: 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  completed: 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
  linked: 'cccccccc-cccc-4ccc-8ccc-cccccccccccc',
  unused: 'dddddddd-dddd-4ddd-8ddd-dddddddddddd',
  future: 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee',
  exam: '99999999-9999-4999-8999-999999999999',
};
const item = (day, subject, options = {}) => ({
  id: null, dayOfWeek: day, durationMinutes: 60, subject, chapter: '',
  activityType: 'lesson', targetTestCount: null, details: '', sourceGrade: 10,
  preparationTrack: 'konkur', recommendedPublisher: null, ...options,
});

(async () => {
  const db = new PGlite();
  await db.exec(`
    create role authenticated; create role anon; create schema auth; create schema private;
    create type public.app_role as enum ('student', 'counselor');
    create type public.content_status as enum ('draft', 'published');
    create type public.study_activity_type as enum ('lesson', 'exam', 'practice_tests');
    create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
    create table public.profiles(id uuid primary key, role public.app_role, grade smallint, study_field text);
    create function private.current_user_role() returns public.app_role language sql stable security definer set search_path='' as $$
      select role from public.profiles where id=(select auth.uid())$$;
    create table public.counselor_students(counselor_id uuid, student_id uuid);
    create table public.school_subjects(study_field text, grade smallint, subject text);
    create table public.weekly_plans(id uuid primary key default gen_random_uuid(), counselor_id uuid,
      student_id uuid, week_start date, title text, notes text, status public.content_status, routines jsonb default '[]'::jsonb);
    create table public.exams(id uuid primary key);
    create table public.weekly_plan_items(id uuid primary key default gen_random_uuid(), plan_id uuid references public.weekly_plans(id) on delete cascade,
      day_of_week smallint, start_time time, duration_minutes smallint, subject text, chapter text,
      activity_type public.study_activity_type, target_test_count smallint, details text, sort_order smallint,
      source_grade smallint, preparation_track text default 'konkur', exam_year smallint,
      linked_exam_id uuid references public.exams(id));
    create table public.weekly_plan_item_completions(item_id uuid primary key references public.weekly_plan_items(id) on delete cascade,
      student_id uuid, completed_at timestamptz, checked_at timestamptz, completed_test_count smallint);
    create function public.normalize_weekly_plan_routines(target_routines jsonb) returns jsonb language sql immutable as $$select target_routines$$;
    insert into public.profiles(id,role,grade,study_field) values
      ('${ids.counselor}','counselor',null,null),('${ids.other}','counselor',null,null),('${ids.student}','student',10,'experimental_sciences');
    insert into public.counselor_students values ('${ids.counselor}','${ids.student}');
    insert into public.exams values ('${ids.exam}');
    insert into public.weekly_plans(id,counselor_id,student_id,week_start,title,status)
      values ('${ids.plan}','${ids.counselor}','${ids.student}',timezone('Asia/Tehran',now())::date-1,'هفته','published');
    insert into public.weekly_plan_items(id,plan_id,day_of_week,duration_minutes,subject,chapter,activity_type,target_test_count,sort_order,linked_exam_id)
      values ('${ids.past}','${ids.plan}',0,50,'گذشته',null,'lesson',null,0,null),
             ('${ids.completed}','${ids.plan}',1,60,'تکمیل‌شده',null,'practice_tests',20,1,null),
             ('${ids.linked}','${ids.plan}',1,60,'آزمون','فصل ۱','exam',null,2,'${ids.exam}'),
             ('${ids.unused}','${ids.plan}',1,60,'حذف‌شدنی',null,'lesson',null,3,null),
             ('${ids.future}','${ids.plan}',2,60,'فردا',null,'lesson',null,4,null);
    insert into public.weekly_plan_item_completions values
      ('${ids.completed}','${ids.student}','2026-01-01T08:00:00Z','2026-01-01T08:00:00Z',12);
  `);
  await db.exec(todayMigration);
  await db.exec(v5);
  await db.exec(v6);
  await db.exec(completedMigration);
  const date = (await db.query(`select (timezone('Asia/Tehran',now())::date-1)::text as day`)).rows[0].day;
  const actor = id => db.query("select set_config('request.jwt.claim.sub',$1,false)", [id]);
  await actor(ids.counselor);
  const initial = [
    item(1,'تکمیل‌شده',{id:ids.completed,activityType:'practice_tests',targetTestCount:20,sourceGrade:null}),
    item(1,'آزمون',{id:ids.linked,activityType:'exam',chapter:'فصل ۱',durationMinutes:90}),
    item(1,'فعالیت جدید'), item(2,'درس فردا'),
  ];
  const save = list => db.query(`select public.save_weekly_plan_v8($1,$2,$3,'هفتهٔ تازه',null,'published',$4::jsonb,'[]'::jsonb)`,
    [ids.plan,ids.student,date,JSON.stringify(list)]);
  const oldClient = () => db.query(`select public.save_weekly_plan_v6($1,$2,$3,'قدیمی',null,'published',$4::jsonb,'[]'::jsonb)`,
    [ids.plan,ids.student,date,JSON.stringify([item(2,'فردای قدیمی')])]);
  await oldClient();
  assert.equal((await db.query('select count(*)::int as n from public.weekly_plan_items where id=any($1::uuid[])',[[ids.completed,ids.linked,ids.unused]] )).rows[0].n,3,'deployed v6 client must not rewrite today');
  await save(initial);
  let rows = (await db.query('select id,subject,details,duration_minutes,linked_exam_id,recommended_publisher from public.weekly_plan_items where plan_id=$1 order by day_of_week,sort_order',[ids.plan])).rows;
  assert.equal(rows.find(r=>r.id===ids.past)?.subject,'گذشته','past is unchanged');
  assert.equal(rows.find(r=>r.id===ids.completed)?.details,null,'completed activity is unchanged');
  assert.equal(rows.find(r=>r.id===ids.completed)?.recommended_publisher,null,'completed publisher is unchanged');
  assert.equal(rows.find(r=>r.id===ids.linked)?.duration_minutes,90);
  assert.equal(rows.find(r=>r.id===ids.linked)?.linked_exam_id,ids.exam,'today exam link and box id survive');
  assert.ok(!rows.some(r=>r.id===ids.unused),'unused today item can be removed');
  assert.ok(!rows.some(r=>r.id===ids.future),'future items retain old replacement behavior');
  assert.equal((await db.query('select completed_test_count,checked_at from public.weekly_plan_item_completions where item_id=$1',[ids.completed])).rows[0].completed_test_count,12);
  await oldClient();
  assert.equal((await db.query('select count(*)::int as n from public.weekly_plan_items where day_of_week=1 and plan_id=$1',[ids.plan])).rows[0].n,3,'v7 opt-in must not leak into the next legacy request');
  const signature = async () => (await db.query('select id,subject,linked_exam_id from public.weekly_plan_items where plan_id=$1 order by id',[ids.plan])).rows;
  const before = await signature();
  const rejects = async (list, message) => {
    await assert.rejects(save(list), err => { assert.match(err.message,message); return true; });
    assert.deepEqual(await signature(),before,'rejected save is atomic');
  };
  await rejects(initial.filter(i=>i.id!==ids.completed),/Cannot remove a completed activity/);
  await rejects(initial.map(i=>i.id===ids.completed?{...i,activityType:'lesson',targetTestCount:null}:i),/Today activity has changed|Completed plan activity cannot be changed/);
  await rejects(initial.map(i=>i.id===ids.completed?{...i,details:'ویرایش نشده'}:i),/Completed plan activity cannot be changed/);
  await rejects(initial.map(i=>i.id===ids.completed?{...i,recommendedPublisher:'گاج'}:i),/Completed plan activity cannot be changed/);
  await rejects(initial.map(i=>i.id===ids.completed?{...i,sourceGrade:10}:i),/Completed plan activity cannot be changed/);
  await rejects(initial.map(i=>i.id===ids.linked?{...i,subject:'آزمون دیگر'}:i),/Today activity has changed/);
  await rejects([...initial,{...initial[0]}],/duplicate plan item id/);
  await rejects([...initial,item(0,'گذشتهٔ غیرمجاز')],/Invalid or locked plan item/);
  await save([...initial.filter(i=>i.id!==ids.linked),item(1,'آزمون',{activityType:'exam',chapter:'فصل ۱'})]);
  assert.equal((await db.query('select count(*)::int as n from public.weekly_plan_items where id=$1',[ids.linked])).rows[0].n,0,'confirmed linked box can be removed');
  assert.equal((await db.query('select count(*)::int as n from public.weekly_plan_items where linked_exam_id=$1',[ids.exam])).rows[0].n,0,'removed exam link is not reattached to a same-subject box');
  assert.equal((await db.query('select count(*)::int as n from public.exams where id=$1',[ids.exam])).rows[0].n,1,'deleting a box does not delete its exam');
  assert.equal((await db.query('select count(*)::int as n from public.weekly_plan_item_completions where item_id=$1',[ids.completed])).rows[0].n,1,'completed box remains intact');
  await actor(ids.other);
  await assert.rejects(save(initial),/Only counselors can save plans|Student not assigned/);
  console.log('PASS: completed boxes immutable; linked boxes removable without deleting exams; past and progress stay protected');
})().catch(error => { console.error(error); process.exitCode = 1; });
