// Disposable PostgreSQL; never connects to production or sends emails.
const {PGlite}=require('@electric-sql/pglite');const fs=require('node:fs');const assert=require('node:assert/strict');const {randomUUID}=require('node:crypto');
(async()=>{
 const db=new PGlite();const ids=Object.fromEntries(['admin','counselor','otherCounselor','unapproved','student','pending','active','legacy','legacyPending','badLegacy','unassigned','rollback','manager','designer'].map(k=>[k,randomUUID()]));
 await db.exec(`create role anon;create role authenticated;create schema auth;create schema private;
 create type public.app_role as enum ('student','counselor','admin','content_manager','exam_designer');
 create table public.profiles(id uuid primary key,role public.app_role,registration_status text default 'incomplete');
 create table public.counselor_profiles(user_id uuid primary key references public.profiles(id),approval_status text);
 create table public.counselor_students(counselor_id uuid references public.profiles(id),student_id uuid references public.profiles(id),primary key(counselor_id,student_id));
 create table public.student_registrations(student_id uuid primary key,receipt_path text,approved_by uuid);
 create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
 create function private.current_user_role() returns public.app_role language sql stable security definer as $$select role from public.profiles where id=auth.uid()$$;
 grant usage on schema public,auth,private to authenticated;
 grant select on public.profiles,public.counselor_students to authenticated;
 `);
 for(const [k,id]of Object.entries(ids))await db.query('insert into public.profiles(id,role,registration_status) values($1,$2,$3)',[id,k==='admin'?'admin':['counselor','otherCounselor','unapproved'].includes(k)?'counselor':k==='manager'?'content_manager':k==='designer'?'exam_designer':'student',['pending','legacyPending'].includes(k)?'pending':k==='active'?'active':'incomplete']);
 await db.query("insert into public.counselor_profiles values($1,'approved'),($2,'approved'),($3,'pending')",[ids.counselor,ids.otherCounselor,ids.unapproved]);
 await db.query('insert into public.counselor_students values($1,$2),($1,$3),($4,$5)',[ids.counselor,ids.legacy,ids.legacyPending,ids.unapproved,ids.badLegacy]);
 await db.query("insert into public.student_registrations values($1,'private/receipt.png',null)",[ids.pending]);
 const receiptBefore=(await db.query('select * from public.student_registrations')).rows;
 const migration=fs.readFileSync('supabase/migrations/064_assignment_activates_student.sql','utf8');
 await db.exec(migration);
 const status=async key=>(await db.query('select registration_status from public.profiles where id=$1',[ids[key]])).rows[0].registration_status;
 assert.equal(await status('legacy'),'active');assert.equal(await status('legacyPending'),'active');assert.equal(await status('badLegacy'),'incomplete');assert.equal(await status('unassigned'),'incomplete');
 const actor=async key=>{await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub',$1,false)",[ids[key]]);await db.exec('set role authenticated');};
 const assign=(student,counselor='counselor')=>db.query('select public.admin_assign_student_counselor($1,$2)',[ids[student],ids[counselor]]);
 for(const who of ['student','counselor','manager','designer']){await actor(who);await assert.rejects(()=>assign('unassigned'),/Admin only/);}
 await actor('admin');
 await assert.rejects(()=>assign('unassigned','unapproved'),/Approved counselor required/);assert.equal(await status('unassigned'),'incomplete');
 await assign('student');await assign('pending');await assign('active');
 for(const k of ['student','pending','active'])assert.equal(await status(k),'active');
 await assert.rejects(()=>assign('student'),/already has a counselor/);
 await assert.rejects(()=>assign('student','otherCounselor'),/already has a counselor/);
 assert.equal((await db.query('select counselor_id from public.counselor_students where student_id=$1',[ids.student])).rows[0].counselor_id,ids.counselor);
 await db.exec('reset role');
 await db.exec(`alter table public.profiles add constraint simulate_activation_failure check (id<>'${ids.rollback}' or registration_status<>'active')`);
 await actor('admin');await assert.rejects(()=>assign('rollback'),/simulate_activation_failure/);
 assert.equal((await db.query('select count(*)::int as n from public.counselor_students where student_id=$1',[ids.rollback])).rows[0].n,0);assert.equal(await status('rollback'),'incomplete');
 await db.exec('reset role');assert.deepEqual((await db.query('select * from public.student_registrations')).rows,receiptBefore);
 await db.exec(migration);assert.equal(await status('legacy'),'active'); // Backfill is repeat-safe.
 await db.exec('set role anon');await assert.rejects(()=>assign('unassigned'),/permission denied/);
 await db.close();console.log('Assignment activates atomically; legacy repair, unassigned/approved-only/admin-only guards, no reassignment, rollback, unchanged receipts and anonymous denial passed.');
})().catch(e=>{console.error(e);process.exitCode=1;});
