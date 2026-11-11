const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const {PGlite} = require('@electric-sql/pglite');

(async () => {
 const db = new PGlite();
 const actor='11111111-1111-4111-8111-111111111111', other='22222222-2222-4222-8222-222222222222', admin='33333333-3333-4333-8333-333333333333', student='44444444-4444-4444-8444-444444444444', hiddenStudent='55555555-5555-4555-8555-555555555555';
 await db.exec(`
  create role authenticated; create role anon; create schema auth; create schema private;
  create type public.app_role as enum ('counselor','student','admin');
  create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
  create table public.profiles(id uuid primary key,role public.app_role);
  create function private.current_user_role() returns public.app_role language sql stable security definer as $$select role from public.profiles where id=auth.uid()$$;
  create table public.weekly_plans(id uuid primary key,student_id uuid,counselor_id uuid,week_start date,title text,notes text,status text,updated_at timestamptz,routines jsonb);
  create table public.weekly_plan_items(id uuid primary key,plan_id uuid,day_of_week integer,duration_minutes integer,subject text,chapter text,activity_type text,target_test_count integer,details text,sort_order integer,source_grade integer,preparation_track text,recommended_publisher text,exam_year integer,linked_exam_id uuid,visible boolean default true);
  grant usage on schema public,auth,private to authenticated,anon;
  grant select on public.weekly_plans,public.weekly_plan_items to authenticated;
  alter table public.weekly_plans enable row level security;
  create policy plan_access on public.weekly_plans for select to authenticated using (counselor_id=auth.uid() or (student_id='${student}' and auth.uid()='${actor}' and status='published'));
  alter table public.weekly_plan_items enable row level security;
  create policy item_access on public.weekly_plan_items for select to authenticated using (visible and exists(select 1 from public.weekly_plans p where p.id=plan_id));
 `);
 await db.query("insert into public.profiles values ($1,'counselor'),($2,'counselor'),($3,'admin'),($4,'student')",[actor,other,admin,student]);
 await db.query(`insert into public.weekly_plans select md5('own'||g)::uuid,$1,$2,date '2020-01-01'+g,'own '||g,'note',case when g=1 then 'draft' else 'published' end,now(),'[{"dayOfWeek":0,"subject":"ریاضی","secondSubject":"فیزیک"}]'::jsonb from generate_series(1,201) g`,[student,actor]);
 await db.query(`insert into public.weekly_plans select md5('previous'||g)::uuid,$1,$2,date '2020-01-01'+g,'previous '||g,null,'published',now(),null from generate_series(1,201) g`,[student,other]);
 await db.query("insert into public.weekly_plans values (md5('other-draft')::uuid,$1,$2,'2050-01-01','draft',null,'draft',now(),null),(md5('not-assigned')::uuid,$3,$2,'2050-01-01','not assigned',null,'published',now(),null)",[student,other,hiddenStudent]);
 await db.exec(`insert into public.weekly_plan_items(id,plan_id,day_of_week,duration_minutes,subject,activity_type,sort_order,source_grade,preparation_track,recommended_publisher,visible) values
  (md5('visible')::uuid,md5('own201')::uuid,0,60,'ریاضی','lesson',0,10,'konkur','گاج',true),
  (md5('hidden')::uuid,md5('own201')::uuid,1,60,'hidden','lesson',1,10,'konkur',null,false),
  (md5('previtem')::uuid,md5('previous201')::uuid,2,60,'علوم','lesson',0,10,'konkur',null,true)`);
 await db.exec(fs.readFileSync('supabase/migrations/115_counselor_plan_editor_read.sql','utf8'));
 const impersonate=async id=>{await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub',$1,false)",[id]);await db.exec('set role authenticated');};
 const page=async(offset,previous)=>(await db.query('select public.counselor_plan_editor_page($1,$2) result',[offset,previous])).rows[0].result;
 await impersonate(actor);
 const first=await page(0,false),last=await page(200,false),history=await page(0,true),historyLast=await page(200,true);
 assert.equal(first.counselor_id,actor);assert.equal(first.plans.length,200);assert.equal(first.has_more,true);assert.equal(last.plans.length,1);assert.equal(last.has_more,false);
 assert.equal(new Set([...first.plans,...last.plans].map(p=>p.id)).size,201);
 assert.equal(first.plans[0].title,'own 201');assert.equal(first.plans[0].weekly_plan_items.length,1);assert.equal(first.plans[0].weekly_plan_items[0].recommended_publisher,'گاج');assert.equal(first.plans[0].routines[0].secondSubject,'فیزیک');
 assert.equal(history.plans.length,200);assert.equal(historyLast.plans.length,1);assert.equal(history.has_more,true);assert.equal(historyLast.has_more,false);
 assert.ok([...history.plans,...historyLast.plans].every(p=>p.counselor_id===other&&p.student_id===student&&p.status==='published'));
 assert.deepEqual(history.plans[0].weekly_plan_items,[{day_of_week:2}]);assert.equal((await page(400,true)).plans.length,0);
 await assert.rejects(()=>page(-1,false),/Invalid page/);await assert.rejects(()=>page(0,null),/Invalid page/);
 await impersonate(other);assert.equal((await page(0,true)).plans.length,0,'RLS blocks unassigned history');
 await impersonate(admin);await assert.rejects(()=>page(0,false),/Counselor only/);
 await db.exec('reset role; set role anon');await assert.rejects(()=>page(0,false),/permission denied/);
 await db.close();

 // Loader discards partial pages and detects identity changes.
 const mod={exports:{}};const js=ts.transpileModule(fs.readFileSync('lib/load-counselor-plans.ts','utf8'),{compilerOptions:{module:ts.ModuleKind.CommonJS,target:ts.ScriptTarget.ES2022}}).outputText;
 vm.runInNewContext(js,{module:mod,exports:mod.exports,require:name=>name==='@/lib/collect-query-pages'?{collectQueryPages:()=>{}}:require(name)});
 const responses=[];const calls=[];const fake={rpc:async(name,args)=>{assert.equal(name,'counselor_plan_editor_page');calls.push(args);return responses.shift()}};
 responses.push({data:first,error:null},{data:last,error:null});let loaded=await mod.exports.loadCounselorEditorPage(fake,false);assert.equal(loaded.counselorId,actor);assert.equal(loaded.plans.length,201);assert.deepEqual(calls.map(c=>c.page_offset),[0,200]);
 responses.push({data:first,error:null},{data:null,error:{message:'failed'}});await assert.rejects(()=>mod.exports.loadCounselorEditorPage(fake,false));
 responses.push({data:first,error:null},{data:{...last,counselor_id:other},error:null});await assert.rejects(()=>mod.exports.loadCounselorEditorPage(fake,false),/identity changed/);
 responses.push({data:{...first,plans:[]},error:null});await assert.rejects(()=>mod.exports.loadCounselorEditorPage(fake,false));
 console.log('PASS: plan editor RPC isolation, 201-plan paging, hidden rows, complete items, errors and identity checks');
})().catch(e=>{console.error(e);process.exitCode=1});
