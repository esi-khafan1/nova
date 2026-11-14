// Real concurrent PostgreSQL backends; local disposable fixture only.
// Install embedded-postgres separately (npm install --no-save embedded-postgres).
const assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path'),{randomUUID}=require('node:crypto');
(async()=>{
 const EmbeddedPostgres=(await import('embedded-postgres')).default;
 const dir=fs.mkdtempSync(path.join(os.tmpdir(),'nova-planner-pg-'));
 const db=new EmbeddedPostgres({databaseDir:dir,user:'postgres',password:'fixture-only',port:24000+Math.floor(Math.random()*10000),persistent:false,onLog:()=>{},onError:()=>{}});
 const clients=[];let started=false;
 try {
  await db.initialise();await db.start();started=true;
  const client=async()=>{const c=db.getPgClient();await c.connect();clients.push(c);await c.query("set statement_timeout='5s'");return c};
  const setup=await client();
  await setup.query(`create role anon;create role authenticated;create schema auth;create schema private;
   create type public.app_role as enum('student','counselor','exam_designer');create type public.content_status as enum('draft','published');
   create type public.study_activity_type as enum('lesson','exam','practice_tests');
   create table public.profiles(id uuid primary key,role public.app_role,registration_status text,grade smallint,study_field text);
   create table public.counselor_profiles(user_id uuid primary key,approval_status text);
   create table public.counselor_students(counselor_id uuid,student_id uuid,primary key(counselor_id,student_id));
   create table public.school_subjects(study_field text,grade smallint,subject text);
   create table public.weekly_plans(id uuid primary key default gen_random_uuid(),counselor_id uuid,student_id uuid,week_start date,updated_at timestamptz default clock_timestamp(),title text,notes text,status public.content_status,routines jsonb default '[]'::jsonb);
   create table public.exams(id uuid primary key,counselor_id uuid,explicit_students boolean,template_version text);
   create table public.exam_students(exam_id uuid,student_id uuid);
   create table public.exam_booklets(exam_id uuid,sort_order integer,explanation_pdf_url text);
   create function private.save_designer_exam_with_window(uuid,text,text,text,timestamptz,public.content_status,jsonb,text,timestamptz) returns uuid language sql as $$select $1$$;
   create table public.weekly_plan_items(id uuid primary key default gen_random_uuid(),plan_id uuid references public.weekly_plans(id) on delete cascade,day_of_week smallint,start_time time,duration_minutes smallint,subject text,chapter text,activity_type public.study_activity_type,target_test_count smallint,details text,sort_order smallint,source_grade smallint,preparation_track text default 'konkur',exam_year smallint,linked_exam_id uuid references public.exams(id));
   create table public.weekly_plan_item_completions(item_id uuid primary key references public.weekly_plan_items(id) on delete cascade,student_id uuid,completed_at timestamptz,checked_at timestamptz,completed_test_count smallint);
   create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
   create function private.current_user_role() returns public.app_role language sql stable security definer as $$select role from public.profiles where id=auth.uid()$$;
   create function public.normalize_weekly_plan_routines(target_routines jsonb) returns jsonb language sql immutable as $$select target_routines$$;
   create function public.touch_fixture_plan() returns trigger language plpgsql as $$begin new.updated_at=clock_timestamp();return new;end$$;
   create trigger touch_fixture_plan before update on public.weekly_plans for each row execute function public.touch_fixture_plan();
   grant usage on schema public,auth,private to authenticated;`);
  const migration=name=>fs.readFileSync(`supabase/migrations/${name}.sql`,'utf8');
  await setup.query(migration('090_edit_published_plan_today'));
  const v5=migration('079_exam_plan_boxes').split('create or replace function public.save_weekly_plan_v5(')[1].split('revoke all on function public.save_weekly_plan_v5(')[0];
  await setup.query('create or replace function public.save_weekly_plan_v5('+v5);
  await setup.query(migration('085_konkur_recommended_publisher').split('-- Re-issue the student RPC')[0]);
  await setup.query(migration('091_completed_boxes_and_linked_exam_removal'));
  // Use the latest designer save function (084), including explanation PDFs.
  const designerSave=migration('084_designer_assigned_student_picker').split('create or replace function public.save_designer_exam(')[1].split('revoke all on function public.save_designer_exam(')[0];
  await setup.query('create or replace function public.save_designer_exam('+designerSave);
  await setup.query(migration('103_external_simulation_provider_plan_boxes'));
  await setup.query(migration('109_makeup_plan_boxes'));
  await setup.query('create or replace function public.save_weekly_plan_v4'+migration('100_grade_nine_planning_and_exam_troubleshooting').split('create or replace function public.save_weekly_plan_v4')[1]);
  await setup.query(migration('111_two_daily_routines'));
  await setup.query(migration('118_planner_private_drafts'));
  await setup.query(migration('119_planner_atomic_publish'));
  // Isolated fixture only: inspect the still-disabled publication internals.
  await setup.query('grant execute on function public.planner_publish_working_draft(uuid,date,text) to authenticated');
  await setup.query(migration('121_planner_reviews'));
  await setup.query(migration('122_planner_published_extras'));
  await setup.query(migration('123_planner_review_history'));
  const counselor=randomUUID(),student=randomUUID(),plan=randomUUID();
  const week=(await setup.query("select timezone('Asia/Tehran',now())::date::text as today")).rows[0].today;
  await setup.query("insert into public.profiles values($1,'counselor','active',null,null),($2,'student','active',10,'experimental_sciences')",[counselor,student]);
  await setup.query("insert into public.counselor_profiles values($1,'approved')",[counselor]);
  await setup.query('insert into public.counselor_students values($1,$2)',[counselor,student]);
  await setup.query("insert into public.weekly_plans(id,counselor_id,student_id,week_start,title,status) values($1,$2,$3,$4,'old','published')",[plan,counselor,student,week]);
  const a=await client(),b=await client(),c=await client();
  for(const conn of [a,b,c]){await conn.query("select set_config('request.jwt.claim.sub',$1,false)",[counselor]);await conn.query('set role authenticated')}
  const snapshot={title:'new',notes:'',items:[{id:null,dayOfWeek:1,durationMinutes:60,subject:'زیست',chapter:'فصل یک',activityType:'lesson',targetTestCount:null,details:'',sourceGrade:10,preparationTrack:'konkur',recommendedPublisher:null}],routines:Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'',details:'',secondSubject:'',secondDetails:''})),extras:{week:{goal:'هدف'},items:[{topics:[{title:'گفتار یک'}]}]}};
  const save=(conn,revision,snap=snapshot)=>conn.query('select public.planner_save_working_draft($1,$2,$3,$4::jsonb,$5) x',[student,week,plan,JSON.stringify(snap),revision]);
  const publish=conn=>conn.query('select public.planner_publish_working_draft($1,$2,$3) x',[student,week,'1']);
  const readDraft=conn=>conn.query('select public.planner_get_working_draft($1,$2) x',[student,week]);
  await save(b,null);
  // The old v3/v4 route and completion writes lock the student first. A
  // publisher holding the plan row must not wait for that lock and deadlock.
  await a.query('begin');await a.query('select pg_advisory_xact_lock(hashtextextended($1,73033))',[student]);
  await assert.rejects(publish(b),err=>err.code==='40001'&&/busy/.test(err.message));
  await a.query('reset role');await a.query('select id from public.weekly_plans where id=$1 for update',[plan]);await a.query('commit');
  assert.equal((await readDraft(b)).rows[0].x.revision,'1','busy publication retains draft');
  // Hold a successful publication open; a second publisher waits for the
  // draft-context lock, and cannot replay after the first commits.
  await b.query('begin');assert.equal((await publish(b)).rows[0].x,plan);
  let secondSettled=false;const second=publish(c).then(()=>({ok:true}),error=>({ok:false,error})).finally(()=>{secondSettled=true});
  await new Promise(resolve=>setTimeout(resolve,120));assert.equal(secondSettled,false,'second publisher waits for first transaction');
  await b.query('commit');const result=await second;assert.equal(result.ok,false);assert.equal(result.error.code,'40001');assert.match(result.error.message,/Draft has changed/);
  assert.equal((await readDraft(c)).rows[0].x,null);
  const publishedExtra=(await setup.query('select e.data from private.planner_item_extras e join public.weekly_plan_items i on i.id=e.item_id where i.plan_id=$1',[plan])).rows;
  assert.equal(publishedExtra.length,1);assert.equal(publishedExtra[0].data.topics[0].title,'گفتار یک');
  // An independently edited published version makes the private draft stale.
  await save(b,null);await setup.query("update public.weekly_plans set title='external',updated_at=clock_timestamp() where id=$1",[plan]);
  await assert.rejects(publish(b),err=>err.code==='40001'&&/Published plan has changed/.test(err.message));
  assert.equal((await readDraft(b)).rows[0].x.revision,'1');
  // Two tabs cannot both write revision 1. One succeeds and one conflicts.
  const writers=await Promise.allSettled([save(b,'1',{...snapshot,title:'tab one'}),save(c,'1',{...snapshot,title:'tab two'})]);
  assert.equal(writers.filter(x=>x.status==='fulfilled').length,1);assert.equal(writers.filter(x=>x.status==='rejected').length,1);
  assert.equal(writers.find(x=>x.status==='rejected').reason.code,'40001');assert.equal((await readDraft(c)).rows[0].x.revision,'2');
  // The student checks an activity while the counselor has an older draft.
  // Publication must not race the check or rewrite the newly protected item.
  await b.query('select public.planner_discard_working_draft($1,$2,$3)',[student,week,'2']);
  const todayItem=randomUUID();
  await setup.query("insert into public.weekly_plan_items(id,plan_id,day_of_week,duration_minutes,subject,chapter,activity_type,details,sort_order,source_grade,preparation_track) values($1,$2,0,60,'زیست','فصل یک','lesson',null,0,10,'konkur')",[todayItem,plan]);
  const stale={...snapshot,items:[{...snapshot.items[0],id:todayItem,dayOfWeek:0,details:'changed'}],extras:{week:{},items:[null]}};
  await save(b,null,stale);
  await a.query("select set_config('request.jwt.claim.sub',$1,false)",[student]);await a.query('begin');
  await a.query('select pg_advisory_xact_lock(hashtextextended($1,73033))',[student]);
  await a.query('insert into public.weekly_plan_item_completions values($1,$2,now(),now(),null)',[todayItem,student]);
  await assert.rejects(publish(b),err=>err.code==='40001'&&/busy/.test(err.message));
  await a.query('commit');
  await assert.rejects(publish(b),err=>err.code==='PZ001'&&/Completed plan activity/.test(err.message));
  assert.equal((await readDraft(b)).rows[0].x.revision,'1');
  assert.equal((await setup.query('select details from public.weekly_plan_items where id=$1',[todayItem])).rows[0].details,null);
  assert.equal((await setup.query('select count(*)::int n from public.weekly_plan_item_completions where item_id=$1',[todayItem])).rows[0].n,1);
  await b.query('select public.planner_discard_working_draft($1,$2,$3)',[student,week,'1']);
  const futureId=(await setup.query('select id from public.weekly_plan_items where plan_id=$1 and day_of_week=1',[plan])).rows[0].id;
  const reviewDraft={...snapshot,items:[{...snapshot.items[0],sourceItemId:futureId},{...snapshot.items[0],id:todayItem,dayOfWeek:0,details:''}],extras:{week:{},items:[snapshot.extras.items[0],null]}};
  await save(b,null,reviewDraft);await a.query('set role authenticated');await a.query('begin');
  await a.query('select public.planner_set_review_completed($1,1,true)',[futureId]);
  await assert.rejects(publish(b),err=>err.code==='40001'&&/busy/.test(err.message));await a.query('commit');
  await publish(b);const replacement=(await setup.query('select id from public.weekly_plan_items where plan_id=$1 and day_of_week=1',[plan])).rows[0].id;
  assert.notEqual(replacement,futureId);
  assert.equal((await setup.query('select count(*)::int n from private.planner_review_completions where item_id=$1 and review_offset=1',[replacement])).rows[0].n,1,'concurrent review follows the unchanged replaced activity');
  assert.equal((await setup.query('select count(*)::int n from private.planner_review_history')).rows[0].n,0);
  // Reproduce an existing designer race before enabling the new publisher.
  // The real designer RPC validates box IDs BEFORE locking the exam. Hold that
  // lock so it has validated an unlinked future box while v9 replaces the box.
  // The designer then resumes and reports success although its update matched
  // zero rows. This is intentionally documented as a release-blocking finding.
  const designer=randomUUID(),exam=randomUUID(),examBox=randomUUID();
  await setup.query("insert into public.profiles values($1,'exam_designer','active',null,null)",[designer]);
  await setup.query('insert into public.exams(id,counselor_id) values($1,$2)',[exam,designer]);
  await setup.query("insert into public.weekly_plan_items(id,plan_id,day_of_week,duration_minutes,subject,chapter,activity_type,sort_order,source_grade,preparation_track) values($1,$2,2,60,'آزمون فیزیک','فصل یک','exam',2,10,'konkur')",[examBox,plan]);
  const examItem={id:null,sourceItemId:examBox,dayOfWeek:2,durationMinutes:60,subject:'آزمون فیزیک',chapter:'فصل یک',activityType:'exam',targetTestCount:null,details:'',sourceGrade:10,preparationTrack:'konkur',recommendedPublisher:null};
  const examDraft={...reviewDraft,items:[{...reviewDraft.items[0],sourceItemId:replacement},reviewDraft.items[1],examItem],extras:{week:{},items:[snapshot.extras.items[0],null,null]}};
  await save(b,null,examDraft);
  const designerClient=await client();await designerClient.query("select set_config('request.jwt.claim.sub',$1,false)",[designer]);await designerClient.query('set role authenticated');
  const designerPid=(await designerClient.query('select pg_backend_pid() pid')).rows[0].pid;
  await a.query('reset role');await a.query('begin');await a.query('select id from public.exams where id=$1 for update',[exam]);
  let finished=false;
  const design=designerClient.query("select public.save_designer_exam($1,'exam','',$2::uuid[],now(),'published','[]'::jsonb,null,null,$3::uuid[]) x",[exam,[],[examBox]]).finally(()=>{finished=true});
  await new Promise(resolve=>setTimeout(resolve,150));
  assert.equal(finished,false,'designer is waiting after validating the box');
  assert.ok((await setup.query('select cardinality(pg_blocking_pids($1)) n',[designerPid])).rows[0].n>0,'designer really holds at the exam lock');
  await publish(b);
  await a.query('commit');assert.equal((await design).rows[0].x,exam);
  assert.equal((await setup.query('select count(*)::int n from public.weekly_plan_items where linked_exam_id=$1',[exam])).rows[0].n,0,'known race: designer success without its selected box');
  assert.equal((await setup.query("select count(*)::int n from public.weekly_plan_items where plan_id=$1 and subject='آزمون فیزیک'",[plan])).rows[0].n,1,'plan still has a replacement box');
  // Apply the candidate guard only inside the disposable DB. Repeat the same
  // ordering: after the plan commits the designer must get an error, not a
  // false success. Its original exam state must roll back atomically.
  await setup.query(migration('125_plan_exam_concurrency_guard'));
  // A direct legacy v5 save must not wait with a plan row while another
  // transaction holds the student lock (older clients lock student first).
  await a.query('begin');await a.query('select pg_advisory_xact_lock(hashtextextended($1,73033))',[student]);
  await assert.rejects(b.query("select public.save_weekly_plan_v5($1,$2,$3,'old','', 'published',$4::jsonb,$5::jsonb)",[plan,student,week,JSON.stringify(snapshot.items),JSON.stringify(snapshot.routines)]),err=>err.code==='40001'&&/busy/.test(err.message));
  await a.query('commit');
  const getExamBox=async()=>(await setup.query("select id from public.weekly_plan_items where plan_id=$1 and subject='آزمون فیزیک'",[plan])).rows[0].id;
  const latestLesson=async()=>(await setup.query("select id from public.weekly_plan_items where plan_id=$1 and day_of_week=1",[plan])).rows[0].id;
  const currentDraft=async()=>({...examDraft,items:[{...reviewDraft.items[0],sourceItemId:await latestLesson()},reviewDraft.items[1],{...examItem,sourceItemId:await getExamBox()}]});
  let box=await getExamBox();await save(b,null,await currentDraft());
  await a.query('begin');await a.query('select id from public.exams where id=$1 for update',[exam]);
  let guardSettled=false;
  const guarded=designerClient.query("select public.save_designer_exam($1,'exam','',$2::uuid[],now(),'published','[]'::jsonb,null,null,$3::uuid[]) x",[exam,[],[box]]).then(value=>({value}),error=>({error})).finally(()=>{guardSettled=true});
  await new Promise(resolve=>setTimeout(resolve,150));assert.equal(guardSettled,false);
  assert.ok((await setup.query('select cardinality(pg_blocking_pids($1)) n',[designerPid])).rows[0].n>0);
  await publish(b);await a.query('commit');
  const rejected=await guarded;assert.match(rejected.error?.message||'',/Invalid exam boxes/,'stale box must fail, not silently lose the link');
  assert.equal((await setup.query('select count(*)::int n from public.weekly_plan_items where linked_exam_id=$1',[exam])).rows[0].n,0);
  // Opposite ordering: the designer attaches the box first and keeps the
  // transaction open. The plan must wait and carry that link to its new ID.
  box=await getExamBox();await save(b,null,await currentDraft());
  await designerClient.query('begin');
  assert.equal((await designerClient.query("select public.save_designer_exam($1,'exam','',$2::uuid[],now(),'published','[]'::jsonb,null,null,$3::uuid[]) x",[exam,[],[box]])).rows[0].x,exam);
  let planSettled=false;const planned=publish(b).then(value=>({value}),error=>({error})).finally(()=>{planSettled=true});
  await new Promise(resolve=>setTimeout(resolve,150));assert.equal(planSettled,false,'plan waits for the designer box transaction');
  await designerClient.query('commit');const planResult=await planned;assert.equal(planResult.error,undefined);assert.equal(planResult.value.rows[0].x,plan);
  let linked=(await setup.query('select id,linked_exam_id from public.weekly_plan_items where plan_id=$1 and linked_exam_id=$2',[plan,exam])).rows;
  assert.equal(linked.length,1);assert.notEqual(linked[0].id,box,'link survives replacement of the original box');
  // Cached legacy clients still call v5 directly and submit future items only.
  // Their snapshot must also wait for the designer's transaction.
  await designerClient.query('begin');
  assert.equal((await designerClient.query("select public.save_designer_exam($1,'exam','',$2::uuid[],now(),'published','[]'::jsonb,null,null,$3::uuid[]) x",[exam,[],[linked[0].id]])).rows[0].x,exam);
  let legacySettled=false;
  const legacyExamItem={...examItem};delete legacyExamItem.sourceItemId;
  const legacy=b.query("select public.save_weekly_plan_v5($1,$2,$3,'legacy','', 'published',$4::jsonb,$5::jsonb) x",[plan,student,week,JSON.stringify([snapshot.items[0],legacyExamItem]),JSON.stringify(snapshot.routines)]).then(value=>({value}),error=>({error})).finally(()=>{legacySettled=true});
  await new Promise(resolve=>setTimeout(resolve,150));assert.equal(legacySettled,false,'legacy save waits for exam box');
  await designerClient.query('commit');const legacyResult=await legacy;assert.equal(legacyResult.error,undefined);assert.equal(legacyResult.value.rows[0].x,plan);
  linked=(await setup.query('select id,linked_exam_id from public.weekly_plan_items where plan_id=$1 and linked_exam_id=$2',[plan,exam])).rows;assert.equal(linked.length,1,'legacy save keeps the exam link');
  // The designer must fail immediately if the plan already holds a box row;
  // otherwise exam-lock / box-lock ordering could deadlock both operations.
  await a.query('begin');await a.query('select id from public.weekly_plan_items where id=$1 for update',[linked[0].id]);
  await assert.rejects(designerClient.query("select public.save_designer_exam($1,'exam','',$2::uuid[],now(),'published','[]'::jsonb,null,null,$3::uuid[])",[exam,[],[linked[0].id]]),err=>err.code==='40001'&&/being updated/.test(err.message));
  await a.query('commit');
  assert.equal((await setup.query('select linked_exam_id from public.weekly_plan_items where id=$1',[linked[0].id])).rows[0].linked_exam_id,exam,'busy rejection leaves prior link intact');
  assert.equal((await setup.query('select count(*)::int n from public.weekly_plan_item_completions where item_id=$1',[todayItem])).rows[0].n,1,'today progress survives both race orders');
  // A plan edit racing the first autosave must not be adopted as the base of a
  // stale editor. 127 locks the row before comparing the loaded microseconds.
  await setup.query(migration('127_planner_draft_base_version'));
  const base=(await setup.query("select to_jsonb(updated_at)#>>'{}' version from public.weekly_plans where id=$1",[plan])).rows[0].version;
  await a.query('begin');await a.query("update public.weekly_plans set title='concurrent change' where id=$1",[plan]);
  let savedSettled=false;
  const firstSave=b.query('select public.planner_save_working_draft_checked($1,$2,$3,$4::jsonb,null,$5)',[student,week,plan,JSON.stringify({title:'stale'}),base]).then(value=>({value}),error=>({error})).finally(()=>{savedSettled=true});
  await new Promise(resolve=>setTimeout(resolve,150));assert.equal(savedSettled,false,'first save waits for the plan version lock');
  await a.query('commit');const staleFirstSave=await firstSave;assert.equal(staleFirstSave.error?.code,'40001','concurrent plan update rejects the stale first save');
  assert.equal((await setup.query('select count(*)::int n from private.planner_working_drafts')).rows[0].n,0);
  const freshBase=(await setup.query("select to_jsonb(updated_at)#>>'{}' version from public.weekly_plans where id=$1",[plan])).rows[0].version;
  await b.query('select public.planner_save_working_draft_checked($1,$2,$3,$4::jsonb,null,$5)',[student,week,plan,JSON.stringify({title:'fresh draft'}),freshBase]);
  assert.equal((await setup.query('select snapshot->>\'title\' title from private.planner_working_drafts')).rows[0].title,'fresh draft');
  console.log('PASS: designer/plan races, checked first autosave race and preserved progress/link');
 } finally {for(const c of clients)await c.end().catch(()=>{});if(started)await db.stop().catch(()=>{});fs.rmSync(dir,{recursive:true,force:true})}
})().catch(error=>{console.error(error);process.exitCode=1});
