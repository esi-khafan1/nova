const { PGlite } = require('@electric-sql/pglite');
const assert = require('node:assert/strict');
const fs = require('node:fs');

const todayMigration = fs.readFileSync('supabase/migrations/090_edit_published_plan_today.sql', 'utf8');
const completedMigration = fs.readFileSync('supabase/migrations/091_completed_boxes_and_linked_exam_removal.sql', 'utf8');
const counselorFlags = fs.readFileSync('supabase/migrations/092_counselor_completed_plan_boxes.sql', 'utf8');
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
  await db.exec(fs.readFileSync('supabase/migrations/103_external_simulation_provider_plan_boxes.sql','utf8'));
  await db.exec(fs.readFileSync('supabase/migrations/109_makeup_plan_boxes.sql','utf8'));
  await db.exec(counselorFlags);
  const date = (await db.query(`select (timezone('Asia/Tehran',now())::date-1)::text as day`)).rows[0].day;
  const actor = id => db.query("select set_config('request.jwt.claim.sub',$1,false)", [id]);
  await actor(ids.counselor);
  assert.deepEqual((await db.query('select item_id from public.counselor_completed_plan_item_ids()')).rows.map(row=>row.item_id),[ids.completed], 'authoritative counselor flags identify exactly completed boxes');
  await actor(ids.other);
  assert.deepEqual((await db.query('select item_id from public.counselor_completed_plan_item_ids()')).rows,[], 'unassigned counselor cannot see progress');
  await actor(ids.student);
  await assert.rejects(db.query('select * from public.counselor_completed_plan_item_ids()'), /Only counselors/);
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
  const providerBox = item(2,'آزمون شبیه‌ساز · ماز',{
    activityType:'external_simulation_exam',sourceGrade:null,chapter:'',preparationTrack:'konkur',examYear:null,
  });
  const saveV9 = list => db.query(`select public.save_weekly_plan_v9($1,$2,$3,'هفتهٔ تازه',null,'published',$4::jsonb,'[]'::jsonb)`,
    [ids.plan,ids.student,date,JSON.stringify(list)]);
  await saveV9([...initial.filter(i=>i.id!==ids.linked),providerBox]);
  assert.equal((await db.query("select count(*)::int as n from public.weekly_plan_items where subject='آزمون شبیه‌ساز · ماز' and activity_type::text='external_simulation_exam' and source_grade is null")).rows[0].n,1,
    'new provider box persists through v9 → v8 → v7 → v6 → v5 → v4 → v3');
  assert.equal((await db.query('select completed_test_count from public.weekly_plan_item_completions where item_id=$1',[ids.completed])).rows[0].completed_test_count,12,
    'new box saves preserve already-completed activities');
  await assert.rejects(saveV9([...initial.filter(i=>i.id!==ids.linked),{...providerBox,chapter:'فصل ۱'}]),/Invalid external simulation provider/);
  const makeupBox=item(2,'باکس جبرانی',{activityType:'makeup',sourceGrade:null,chapter:'',preparationTrack:'konkur'});
  await saveV9([...initial.filter(i=>i.id!==ids.linked),makeupBox]);
  assert.equal((await db.query("select count(*)::int as n from public.weekly_plan_items where activity_type::text='makeup' and subject='باکس جبرانی' and chapter is null and source_grade is null")).rows[0].n,1,'makeup box persists through the complete save chain');
  const makeupBefore=await signature();
  await assert.rejects(saveV9([...initial.filter(i=>i.id!==ids.linked),{...makeupBox,chapter:'فصل ۱'}]),/makeup_plan_box_shape/);
  assert.deepEqual(await signature(),makeupBefore,'invalid makeup save rolls back without replacing any items');
  assert.equal((await db.query('select completed_test_count from public.weekly_plan_item_completions where item_id=$1',[ids.completed])).rows[0].completed_test_count,12,'existing completion survives makeup saves');
  const makeupToday={...makeupBox,dayOfWeek:1};
  await saveV9([...initial.filter(i=>i.id!==ids.linked),makeupToday]);
  const makeupId=(await db.query("select id from public.weekly_plan_items where activity_type::text='makeup'")).rows[0].id;
  await db.query('insert into public.weekly_plan_item_completions values ($1,$2,now(),now(),null)',[makeupId,ids.student]);
  await saveV9([...initial.filter(i=>i.id!==ids.linked),{...makeupToday,id:makeupId}]);
  assert.equal((await db.query('select count(*)::int as n from public.weekly_plan_item_completions where item_id=$1',[makeupId])).rows[0].n,1,'a completed makeup box retains its progress during resave');
  await assert.rejects(saveV9([...initial.filter(i=>i.id!==ids.linked),{...makeupToday,id:makeupId,durationMinutes:90}]),/Completed plan activity cannot be changed/);
  await actor(ids.other);
  await assert.rejects(save(initial),/Only counselors can save plans|Student not assigned/);
  // Exercise draft publication through the real v9→v3 chain, rather than a stub.
  await db.exec(`alter table public.profiles add column registration_status text default 'active';
    create table public.counselor_profiles(user_id uuid primary key,approval_status text);
    insert into public.counselor_profiles values ('${ids.counselor}','approved');
    alter table public.weekly_plans add column updated_at timestamptz not null default now();
    create function public.touch_fixture_plan() returns trigger language plpgsql as $$begin new.updated_at=clock_timestamp();return new;end$$;
    create trigger touch_fixture_plan before update on public.weekly_plans for each row execute function public.touch_fixture_plan();`);
  // Exercise the latest grade-nine v4 and two-routine v5 implementations too.
  const gradeNine = fs.readFileSync('supabase/migrations/100_grade_nine_planning_and_exam_troubleshooting.sql','utf8');
  await db.exec('create or replace function public.save_weekly_plan_v4' + gradeNine.split('create or replace function public.save_weekly_plan_v4')[1]);
  await db.exec(fs.readFileSync('supabase/migrations/111_two_daily_routines.sql','utf8'));
  await db.exec(fs.readFileSync('supabase/migrations/118_planner_private_drafts.sql','utf8'));
  await db.exec(fs.readFileSync('supabase/migrations/119_planner_atomic_publish.sql','utf8'));
  await db.exec(fs.readFileSync('supabase/migrations/121_planner_reviews.sql','utf8'));
  await db.exec(fs.readFileSync('supabase/migrations/122_planner_published_extras.sql','utf8'));
  await db.exec(fs.readFileSync('supabase/migrations/123_planner_review_history.sql','utf8'));
  await actor(ids.counselor);
  const intact=[...initial.filter(i=>i.id!==ids.linked),{...makeupToday,id:makeupId}];
  const routines=Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'',details:'',secondSubject:'',secondDetails:''}));
  const payload=(list,extras)=>({title:'برنامهٔ تازه',notes:'',items:list,routines,...(extras === undefined ? {} : {extras})});
  const saveDraft=(list,rev,extras)=>db.query('select public.planner_save_working_draft($1,$2,$3,$4::jsonb,$5)',[ids.student,date,ids.plan,JSON.stringify(payload(list,extras)),rev]);
  const publishDraft=rev=>db.query('select public.planner_publish_working_draft($1,$2,$3)',[ids.student,date,rev]);
  await saveDraft(intact.map(i=>i.id===ids.completed?{...i,details:'نباید تغییر کند'}:i),null);
  const draftBefore=await signature();
  await assert.rejects(publishDraft('1'),/Completed plan activity cannot be changed/);
  assert.deepEqual(await signature(),draftBefore,'failed atomic publish leaves live items untouched');
  assert.ok((await db.query('select public.planner_get_working_draft($1,$2) d',[ids.student,date])).rows[0].d,'draft is retained after rejection');
  await saveDraft(intact,'1');await publishDraft('2');
  assert.equal((await db.query('select count(*)::int n from public.weekly_plan_item_completions where item_id=any($1::uuid[])',[[ids.completed,makeupId]])).rows[0].n,2,'real publish keeps completed test and makeup progress');
  assert.equal((await db.query('select public.planner_get_working_draft($1,$2) d',[ids.student,date])).rows[0].d,null);
  const extras={week:{goal:'هدف تازه',wakeTime:'07:00'},items:[null,{topics:[{title:'گفتار یک',pageStart:1,pageEnd:4}]},{action:'مطالعه'},null]};
  const publicExtras=async()=>(await db.query('select public.planner_get_published_extras($1) d',[ids.plan])).rows[0].d;
  await saveDraft(intact,null,{week:{goal:'نباید منتشر شود'},items:[]});
  const beforeBadExtras=await signature();
  await assert.rejects(publishDraft('1'),/Invalid plan extras/);
  assert.deepEqual(await signature(),beforeBadExtras,'bad metadata rolls back the legacy saver too');
  assert.deepEqual(await publicExtras(),{week:{},items:{}},'student-visible data was not changed');
  await saveDraft(intact,'1',{...extras,items:[{action:'تغییر فعالیت انجام‌شده'},...extras.items.slice(1)]});
  await assert.rejects(publishDraft('2'),/Completed plan activity cannot be changed/);
  assert.deepEqual(await signature(),beforeBadExtras);
  await saveDraft(intact,'2',extras);await publishDraft('3');
  const persisted=await publicExtras();assert.equal(persisted.week.goal,'هدف تازه');
  const mapped=(await db.query('select id,subject from public.weekly_plan_items where plan_id=$1',[ids.plan])).rows;
  const added=mapped.find(row=>row.subject==='فعالیت جدید');const future=mapped.find(row=>row.subject==='درس فردا');
  assert.equal(persisted.items[added.id].topics[0].pageEnd,4);assert.equal(persisted.items[future.id].action,'مطالعه');
  assert.equal(Object.hasOwn(persisted.items,ids.completed),false);
  await actor(ids.student);assert.deepEqual(await publicExtras(),persisted,'student sees only published extras');
  await actor(ids.other);await assert.rejects(publicExtras(),/Student not available/);
  await actor(ids.counselor);
  // A legacy edit of the identity must not leave stale topic metadata behind.
  await db.query('update public.weekly_plan_items set chapter=$1 where id=$2',['فصل دیگر',added.id]);
  assert.equal(Object.hasOwn((await publicExtras()).items,added.id),false);
  // A future item is replaced by v9, but checked reviews must follow an
  // unchanged source. A failure in later metadata persistence rolls back too.
  await actor(ids.student);await db.query('select public.planner_set_review_completed($1,1,true)',[future.id]);await db.query('select public.planner_set_review_completed($1,3,true)',[future.id]);
  const originalChecks=(await db.query('select review_offset,completed_at from private.planner_review_completions where item_id=$1 order by review_offset',[future.id])).rows;
  await actor(ids.counselor);
  const withSources=intact.map(i=>i.subject==='درس فردا'?{...i,sourceItemId:future.id}:i);
  await saveDraft(withSources,null,{week:{},items:[]});await assert.rejects(publishDraft('1'),/Invalid plan extras/);
  assert.deepEqual((await db.query('select review_offset,completed_at from private.planner_review_completions where item_id=$1 order by review_offset',[future.id])).rows,originalChecks,'rollback retains checks and timestamps');
  assert.equal((await db.query('select count(*)::int n from private.planner_review_history')).rows[0].n,0);
  await saveDraft(withSources,'1',extras);await publishDraft('2');
  const newFuture=(await db.query("select id from public.weekly_plan_items where plan_id=$1 and subject='درس فردا'",[ids.plan])).rows[0].id;
  assert.notEqual(newFuture,future.id,'legacy future ID changed');
  assert.deepEqual((await db.query('select review_offset,completed_at from private.planner_review_completions where item_id=$1 order by review_offset',[newFuture])).rows,originalChecks,'checks follow the unchanged source, retaining their original timestamps');
  assert.equal((await db.query('select count(*)::int n from private.planner_review_history')).rows[0].n,0);
  // A changed subject/topic represents new study. Preserve checked history as
  // a separate record instead of attributing it to a different topic.
  const changed=withSources.map(i=>i.subject==='درس فردا'?{...i,sourceItemId:newFuture,chapter:'فصل جدید'}:i);
  await saveDraft(changed,null,extras);await publishDraft('1');
  const archive=(await db.query('select * from private.planner_review_history order by review_offset')).rows;
  assert.deepEqual(archive.map(r=>r.review_offset),[1,3]);assert.equal(archive[0].chapter,null);
  const changedId=(await db.query("select id from public.weekly_plan_items where plan_id=$1 and subject='درس فردا'",[ids.plan])).rows[0].id;
  assert.equal((await db.query('select count(*)::int n from private.planner_review_completions where item_id=$1',[changedId])).rows[0].n,0);
  await actor(ids.student);
  const weekReviews=(await db.query('select public.planner_review_week($1,$2) data',[ids.student,date])).rows[0].data;
  assert.equal(weekReviews.filter(r=>r.historical&&r.completed).length,2);
  await db.query('select public.planner_set_historical_review_completed($1,false)',[archive[0].id]);
  assert.equal((await db.query('select completed from private.planner_review_history where id=$1',[archive[0].id])).rows[0].completed,false);
  await db.query('select public.planner_set_review_completed($1,7,true)',[changedId]);
  await actor(ids.other);await assert.rejects(db.query('select public.planner_set_historical_review_completed($1,true)',[archive[0].id]),/Only students/);
  await actor(ids.counselor);
  const legacy=[...intact.filter(i=>i.subject!=='درس فردا'),item(2,'درس دیگر')];
  await db.query(`select public.save_weekly_plan_v9($1,$2,$3,'ذخیرهٔ قدیمی',null,'published',$4::jsonb,$5::jsonb)`,[ids.plan,ids.student,date,JSON.stringify(legacy),JSON.stringify(routines)]);
  assert.equal((await db.query('select count(*)::int n from private.planner_review_history')).rows[0].n,3,'old save endpoints archive a checked review instead of deleting it');
  assert.equal((await db.query('select chapter from private.planner_review_history where review_offset=7')).rows[0].chapter,'فصل جدید');
  console.log('PASS: real save chain, atomic metadata, review transfer and preserved review history');
})().catch(error => { console.error(error); process.exitCode = 1; });
