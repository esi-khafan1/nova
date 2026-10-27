const {PGlite}=require('@electric-sql/pglite');
const assert=require('node:assert/strict');
const fs=require('node:fs');

const migration=fs.readFileSync('supabase/migrations/079_exam_plan_boxes.sql','utf8').replace(/^notify .*$/gim,'');
const editFix=fs.readFileSync('supabase/migrations/081_exam_box_edit_validation.sql','utf8').replace(/^notify .*$/gim,'');
const dashboard=fs.readFileSync('supabase/migrations/080_student_dashboard_exam_links.sql','utf8').replace(/^notify .*$/gim,'');
const ids={
 designer:'11111111-1111-1111-1111-111111111111',
 otherDesigner:'22222222-2222-2222-2222-222222222222',
 counselor:'33333333-3333-3333-3333-333333333333',
 studentA:'44444444-4444-4444-4444-444444444444',
 studentB:'55555555-5555-5555-5555-555555555555',
 planA:'66666666-6666-6666-6666-666666666666',
 planB:'77777777-7777-7777-7777-777777777777',
 planC:'88888888-8888-8888-8888-888888888888',
 boxA:'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
 boxB:'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
 boxSim:'cccccccc-cccc-cccc-cccc-cccccccccccc',
 boxDraft:'dddddddd-dddd-dddd-dddd-dddddddddddd',
 boxPast:'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
 examX:'99999999-9999-9999-9999-999999999999',
};
const uuid=v=>`'${v}'::uuid`;

(async()=>{
 const db=new PGlite();
 await db.exec(`create role authenticated;create role anon;create schema auth;create schema private;
 create type public.app_role as enum ('student','counselor','exam_designer','admin','support_agent','content_manager');
 create type public.content_status as enum ('draft','published','archived');
 create type public.exam_audience as enum ('own_students','all_assigned_students');
 create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
 create table public.profiles(id uuid primary key,role public.app_role,registration_status text default 'active',full_name text,grade smallint,study_field text);
 create function private.current_user_role() returns public.app_role language sql stable security definer as $$select role from public.profiles where id=auth.uid()$$;
 create table public.counselor_students(counselor_id uuid,student_id uuid);
 create table public.weekly_plans(id uuid primary key,counselor_id uuid,student_id uuid,week_start date,title text default 'برنامه',notes text,status public.content_status default 'published',routines jsonb default '[]'::jsonb);
 create table public.weekly_plan_items(id uuid primary key,plan_id uuid references public.weekly_plans(id) on delete cascade,day_of_week smallint,subject text,chapter text,activity_type text,duration_minutes smallint default 90,sort_order smallint default 0,details text,target_test_count smallint,source_grade smallint,preparation_track text default 'konkur',exam_year smallint);
 create table public.exams(id uuid primary key,counselor_id uuid,title text,status public.content_status default 'draft',audience public.exam_audience default 'own_students',starts_at timestamptz,explicit_students boolean default false,template_version text,description text,duration_minutes smallint default 60,exam_field text,start_window_ends_at timestamptz);
 create table public.exam_students(exam_id uuid,student_id uuid,primary key(exam_id,student_id));
 create table public.exam_sessions(exam_id uuid,student_id uuid);
 create table public.exam_attempts(exam_id uuid,student_id uuid);
 create table public.exam_booklets(id uuid,exam_id uuid,sort_order int,pdf_url text,question_count int,start_question_number int,end_question_number int,duration_minutes int,key_answers jsonb,subject_ranges jsonb,title text);
 create table public.weekly_plan_item_completions(item_id uuid,student_id uuid,completed_at timestamptz default now(),checked_at timestamptz,completed_test_count int);
 grant usage on schema public,private,auth to authenticated;
 grant select on all tables in schema public to authenticated;

 create or replace function public.normalize_weekly_plan_routines(target_routines jsonb) returns jsonb language sql immutable as $$select coalesce(target_routines,'[]'::jsonb)$$;
 create or replace function private.save_designer_exam_with_window(
  target_exam_id uuid,target_title text,target_description text,target_audience public.exam_audience,
  target_starts_at timestamptz,target_status public.content_status,target_booklets jsonb,
  target_exam_field text default null,target_start_window_ends_at timestamptz default null
 ) returns uuid language plpgsql as $$
 declare saved uuid;
 begin
  if jsonb_typeof(coalesce(target_booklets,'[]'::jsonb)) <> 'array' or jsonb_array_length(target_booklets)<1 then raise exception 'Exam must have at least one booklet';end if;
  if target_title='BAD TEMPLATE' then raise exception 'Invalid exam template';end if;
  if target_exam_id is null then
   insert into public.exams(id,counselor_id,title,status,audience,starts_at,explicit_students)
   values(md5(random()::text||clock_timestamp()::text)::uuid,auth.uid(),target_title,target_status,target_audience,target_starts_at,true)
   returning id into saved;
  else
   saved:=target_exam_id;
   update public.exams set title=target_title,status=target_status,starts_at=target_starts_at,audience=target_audience where id=saved;
  end if;
  return saved;
 end $$;
 create or replace function public.save_weekly_plan_v4(
  target_plan_id uuid,target_student_id uuid,target_week_start date,target_title text,
  target_notes text,target_status public.content_status,target_items jsonb
 ) returns uuid language plpgsql as $$
 declare saved uuid; it jsonb; idx int:=0;
 begin
  saved:=coalesce(target_plan_id,md5(random()::text)::uuid);
  -- The real RPC re-creates items, so ids change on every counselor save.
  delete from public.weekly_plan_items where plan_id=saved;
  for it in select value from jsonb_array_elements(target_items) loop
   insert into public.weekly_plan_items(id,plan_id,day_of_week,subject,chapter,activity_type,duration_minutes,sort_order,details)
   values(md5(saved::text||idx::text||clock_timestamp()::text)::uuid,saved,(it->>'dayOfWeek')::smallint,
    it->>'subject',nullif(it->>'chapter',''),it->>'activityType',coalesce((it->>'durationMinutes')::int,90),idx,nullif(it->>'details',''));
   idx:=idx+1;
  end loop;
  return saved;
 end $$;
 `);

 await db.query(`insert into public.profiles(id,role,full_name) values
  (${uuid(ids.designer)},'exam_designer','طراح اصلی'),(${uuid(ids.otherDesigner)},'exam_designer','طراح دوم'),
  (${uuid(ids.counselor)},'counselor','مشاور'),(${uuid(ids.studentA)},'student','شیما'),(${uuid(ids.studentB)},'student','علی')`);
 await db.query(`insert into public.counselor_students values(${uuid(ids.counselor)},${uuid(ids.studentA)}),(${uuid(ids.counselor)},${uuid(ids.studentB)})`);
 const start=`(current_date - 1)`;
 await db.query(`insert into public.weekly_plans(id,counselor_id,student_id,week_start,status) values
  (${uuid(ids.planA)},${uuid(ids.counselor)},${uuid(ids.studentA)},${start},'published'),
  (${uuid(ids.planB)},${uuid(ids.counselor)},${uuid(ids.studentB)},${start},'draft'),
  (${uuid(ids.planC)},${uuid(ids.counselor)},${uuid(ids.studentB)},current_date + 1,'published')`);
 await db.query(`insert into public.weekly_plan_items(id,plan_id,day_of_week,subject,chapter,activity_type,sort_order) values
  (${uuid(ids.boxA)},${uuid(ids.planA)},1,'زیستشناسی','فصل ۲','exam',0),
  (${uuid(ids.boxSim)},${uuid(ids.planA)},2,'فیزیک','فصل ۱','simulation_exam',1),
  (${uuid(ids.boxDraft)},${uuid(ids.planB)},3,'شیمی','فصل ۳','exam',0),
  (${uuid(ids.boxB)},${uuid(ids.planC)},1,'عربی','درس ۴','exam',0),
  (${uuid(ids.boxPast)},${uuid(ids.planA)},0,'ریاضی','فصل ۱','exam',2)`);
 await db.exec(migration);
 await db.exec(editFix);

 const actor=async id=>{await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub',$1,false)",[id]);await db.exec('set role authenticated');};
 const boxes=async()=>(await db.query('select * from public.designer_exam_boxes()')).rows;
 const link=async(box,exam)=>{await db.exec('reset role');return db.query('update public.weekly_plan_items set linked_exam_id=$2 where id=$1',[box,exam]);};
 const booklets=JSON.stringify([{title:'ریاضی',questionCount:10,durationMinutes:20,pdfUrl:'https://x/y.pdf',keyAnswers:{}}]);
 const save=async(overrides={})=>{
  const args=[null,'آزمون هفتگی',null,[],new Date(Date.now()+7200000).toISOString(),'published',booklets,null,null,[]];
  Object.assign(args,overrides);
  return (await db.query(`select public.save_designer_exam($1,$2,$3,$4::uuid[],$5::timestamptz,$6::public.content_status,$7::jsonb,$8,$9::timestamptz,$10::uuid[]) as id`,args)).rows[0].id;
 };
 const fail=async(overrides,message)=>{
  try{await save(overrides);}catch(e){assert.match(e.message,message);return;}
  assert.fail('expected rejection: '+message);
 };

 await actor(ids.designer);
 let rows=await boxes();
 assert.equal(rows.length,2,'only published, current exam boxes are shared');
 assert.deepEqual(new Set(rows.map(r=>r.item_id)),new Set([ids.boxA,ids.boxB]));
 assert.equal(rows.find(r=>r.item_id===ids.boxA).subject,'زیستشناسی');
 assert.equal(rows.find(r=>r.item_id===ids.boxA).student_id,ids.studentA);
 assert.equal(rows.find(r=>r.item_id===ids.boxA).day_of_week,1);
 assert.ok(rows.find(r=>r.item_id===ids.boxA).box_date,'box day is sent as a date');
 assert.ok(!rows.some(r=>r.activity_type==='simulation_exam'));

 // Only a designer may read the queue.
 await actor(ids.counselor);
 await assert.rejects(()=>boxes(),/Only exam designers/);
 await actor(ids.studentA);
 await assert.rejects(()=>boxes(),/Only exam designers/);

 // Attaching an exam to a box keeps the box's own student accessible, while
 // other students are still enrolled through the normal picker.
 await actor(ids.designer);
 const exam=await save({9:[ids.boxA]});
 const linked=(await db.query('select linked_exam_id from public.weekly_plan_items where id=$1',[ids.boxA])).rows[0].linked_exam_id;
 assert.equal(linked,exam);
 assert.equal((await db.query('select count(*)::int n from public.exam_students where exam_id=$1',[exam])).rows[0].n,0,'box link is not a duplicate manual enrollment');
 const access=(await db.query('select private.student_can_access_exam($1,$2) ok',[exam,ids.studentA])).rows[0].ok;
 assert.equal(access,true,'a linked box grants exam access');
 assert.equal((await db.query('select private.student_can_access_exam($1,$2) ok',[exam,ids.studentB])).rows[0].ok,false,'unrelated student stays out');
 const asObj=v=>typeof v==='string'?JSON.parse(v):v;
 const details=asObj((await db.query('select public.designer_exam_details($1) d',[exam])).rows[0].d);
 assert.deepEqual(details.box_ids,[ids.boxA]);

 // Other students can be added to the same exam; unchecking a box detaches it.
 await save({0:exam,3:[ids.studentB],9:[]});
 assert.equal((await db.query('select linked_exam_id from public.weekly_plan_items where id=$1',[ids.boxA])).rows[0].linked_exam_id,null);
 assert.equal((await db.query('select count(*)::int n from public.exam_students where exam_id=$1 and student_id=$2',[exam,ids.studentB])).rows[0].n,1);
 assert.equal((await db.query('select private.student_can_access_exam($1,$2) ok',[exam,ids.studentA])).rows[0].ok,false);
 assert.equal((await db.query('select private.student_can_access_exam($1,$2) ok',[exam,ids.studentB])).rows[0].ok,true);

 // Rejection paths: foreign box, simulation box, draft box, expired box.
 await save({0:exam,9:[ids.boxA]});
 await actor(ids.otherDesigner);
 await fail({9:[ids.boxA]},/Invalid exam boxes/);
 await actor(ids.designer);
 await fail({9:[ids.boxSim]},/Invalid exam boxes/);
 await fail({9:[ids.boxDraft]},/Invalid exam boxes/);
 await fail({9:[ids.boxPast]},/Invalid exam boxes/);
 await fail({9:['00000000-0000-0000-0000-000000000000']},/Invalid exam boxes/);
 await fail({3:[],9:[]},/Invalid selected students/);
 await fail({1:'BAD TEMPLATE',9:[ids.boxA]},/Invalid exam template/);
 assert.equal((await db.query('select linked_exam_id from public.weekly_plan_items where id=$1',[ids.boxA])).rows[0].linked_exam_id,exam,'failed saves leave links untouched');

 // Roles: a counselor or student cannot save designer exams or attach boxes.
 await actor(ids.counselor);
 await fail({9:[ids.boxA]},/Only exam designers/);

 // A past box that is already linked stays visible so it can be detached.
 await link(ids.boxPast,exam);
 await actor(ids.designer);
 rows=await boxes();
 assert.ok(rows.some(r=>r.item_id===ids.boxPast),'linked past box remains manageable');
 assert.equal(rows.find(r=>r.item_id===ids.boxPast).linked_exam_owned,true);
 await actor(ids.otherDesigner);
 rows=await boxes();
 assert.equal(rows.find(r=>r.item_id===ids.boxPast).linked_exam_owned,false,'other designer sees it as owned elsewhere');

 // Editing the exam keeps its own past box attached instead of rejecting it.
 await actor(ids.designer);
 await save({0:exam,9:[ids.boxA,ids.boxPast]});
 assert.equal((await db.query('select linked_exam_id from public.weekly_plan_items where id=$1',[ids.boxPast])).rows[0].linked_exam_id,exam,'editing keeps its own past box');

 // Re-saving a plan re-creates its item ids; the exam link must survive.
 await link(ids.boxA,exam);
 await actor(ids.counselor);
 const items=JSON.stringify([{dayOfWeek:1,subject:'زیستشناسی',chapter:'فصل ۲',activityType:'exam',durationMinutes:90}]);
 await db.query(`select public.save_weekly_plan_v5($1,$2,$3,'برنامه',null,'published',$4,'[]'::jsonb)`,[ids.planA,ids.studentA,new Date().toISOString().slice(0,10),items]);
 const after=(await db.query("select id,linked_exam_id,subject,activity_type from public.weekly_plan_items where plan_id=$1",[ids.planA])).rows;
 assert.equal(after.length,1);
 assert.notEqual(after[0].id,ids.boxA,'plan save really re-created the item');
 assert.equal(after[0].linked_exam_id,exam,'exam link survives plan re-save');

 // Changing the box identity (subject) drops the stale link.
 await db.query(`select public.save_weekly_plan_v5($1,$2,$3,'برنامه',null,'published',$4,'[]'::jsonb)`,[ids.planA,ids.studentA,new Date().toISOString().slice(0,10),items.replace('زیستشناسی','شیمی')]);
 const changed=(await db.query("select id,linked_exam_id from public.weekly_plan_items where plan_id=$1",[ids.planA])).rows[0];
 assert.equal(changed.linked_exam_id,null,'a changed box must be re-assigned');

 // The student dashboard only exposes a published, accessible exam id.
 await db.exec('reset role');
 await db.exec(`alter table public.exams enable row level security;
 create policy exams_readable on public.exams for select to authenticated using(
  status='published' and (counselor_id=auth.uid()
   or exists(select 1 from public.exam_students s where s.exam_id=exams.id and s.student_id=auth.uid())
   or exists(select 1 from public.weekly_plan_items i join public.weekly_plans wp on wp.id=i.plan_id
      where i.linked_exam_id=exams.id and wp.student_id=auth.uid() and wp.status='published' and i.activity_type='exam'))
 );`);
 await db.exec(dashboard);
 await link(changed.id,exam); // exam is published
 await actor(ids.studentA);
 const page=async()=>asObj((await db.query('select public.student_dashboard_page(0) d')).rows[0].d);
 let p=await page();
 const boxItem=p.plans.flatMap(pl=>pl.weekly_plan_items).find(i=>i.id===changed.id);
 assert.equal(boxItem.linked_exam_id,exam);
 await db.exec('reset role');
 await db.query("update public.exams set status='draft' where id=$1",[exam]);
 await actor(ids.studentA);
 p=await page();
 assert.equal(p.plans.flatMap(pl=>pl.weekly_plan_items).find(i=>i.id===changed.id).linked_exam_id,null,'draft exam is not linked in the plan');

 await db.close();
 console.log('Exam plan boxes: exam-only designer queue, day/subject payload, box linking, other-student enrollment, RLS/owner guards, plan re-save durability and student dashboard link passed.');
})().catch(e=>{console.error(e);process.exitCode=1;});
