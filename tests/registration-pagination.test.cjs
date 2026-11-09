const assert = require('node:assert/strict');
const fs = require('node:fs');
const {PGlite} = require('@electric-sql/pglite');
(async()=>{
 const db = new PGlite();
 await db.exec(`
 create role anon; create role authenticated;
 create schema private;
 create type public.app_role as enum ('admin','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select coalesce(current_setting('test.role',true),'student')::public.app_role$$;
 create table public.profiles(id uuid primary key, role public.app_role, full_name text, phone text, grade smallint, study_field text, registration_status text, created_at timestamptz, service_course_type text, service_course_duration_months integer);
 create table public.student_registrations(student_id uuid primary key, phone text, telegram_id text, province text, city text, receipt_path text, receipt_name text, course_type text, course_duration_months integer, additional_notes text);
 create table public.student_account_details(student_id uuid primary key, telegram_id text, province text, city text, additional_notes text);
 create table public.counselor_students(student_id uuid, counselor_id uuid, created_at timestamptz);
 create function public.admin_student_plan_service_reviews() returns table(student_id uuid, review_plan_count integer) language sql stable as $$select id,4 from public.profiles where registration_status='active' and full_name like '%review%'$$;
 insert into public.profiles(id,role,full_name,phone,grade,registration_status,created_at)
 select ('00000000-0000-4000-8000-'||lpad(i::text,12,'0'))::uuid, 'student', 'student '||i||case when i=12 then ' review' else '' end, '09123456'||lpad(i::text,3,'0'), 10, case when i=12 then 'active' else 'incomplete' end, '2026-01-01'::timestamptz + i*interval '1 day' from generate_series(1,26) i;
 insert into public.profiles(id,role,full_name) values ('00000000-0000-4000-8000-999999999999','admin','مشاور یکتا');
 insert into public.student_registrations(student_id,province,receipt_path,additional_notes) values ('00000000-0000-4000-8000-000000000001','تهران','receipt','ثبت نام');
 update public.profiles set registration_status='pending' where id='00000000-0000-4000-8000-000000000001';
 insert into public.student_account_details values ('00000000-0000-4000-8000-000000000012','user','تهران','تهران','حساب');
 insert into public.counselor_students values ('00000000-0000-4000-8000-000000000012','00000000-0000-4000-8000-999999999999',now());
 `);
 await db.exec(fs.readFileSync('supabase/migrations/112_admin_registration_pagination.sql','utf8'));
 await assert.rejects(db.query('select public.admin_registration_directory_page()'), /Admin only/);
 await db.exec("set test.role = 'admin'");
 const get=async (...args)=>(await db.query('select public.admin_registration_directory_page($1,$2,$3,$4) as data',args)).rows[0].data;
 const first=await get('',null,false,1), second=await get('',null,false,2), last=await get('',null,false,9999);
 assert.equal(first.total,26); assert.equal(first.pages,3); assert.equal(first.rows.length,10);
 assert.equal(first.rows[0].student_id,'00000000-0000-4000-8000-000000000001'); assert.equal(first.waiting,1);
 assert.equal(last.page,3); assert.equal(last.rows.length,6);
 assert.equal(new Set([...first.rows,...second.rows,...last.rows].map(r=>r.student_id)).size,26);
 assert.equal(first.review_count,1);assert.equal(first.assigned,1);assert.equal(first.unassigned,25);
 const counselor=await get('مشاور يكتا',null,false,1);assert.equal(counselor.total,1);assert.equal(counselor.rows[0].review_plan_count,4);assert.equal(counselor.rows[0].additional_notes,'حساب');
 const phone=await get('۰۹۱۲۳۴۵۶۰۱۲',null,false,1);assert.equal(phone.total,1);
 assert.equal((await get('student 12',null,false,1)).total,1);
 assert.equal((await get('', 'تهران',false,1)).total,2);
 const review=await get('', 'تهران',true,1); assert.equal(review.total,1);assert.equal(review.review_count,1);
 const empty=await get('no match',null,false,23); assert.equal(empty.page,1); assert.equal(empty.pages,1);assert.equal(empty.total,0);assert.deepEqual(empty.rows,[]);
 assert.equal((await get('%',null,false,1)).total,0);

 // Exercise a filtered result that spans three pages, rather than just testing
 // small filters. All data here is synthetic and stays in the local PGlite DB.
 await db.exec(`
   update public.profiles set full_name='student ' || substring(id::text from 25) || ' review',
     registration_status='active'
   where role='student' and id <> '00000000-0000-4000-8000-000000000001';
   insert into public.student_account_details(student_id,province)
     select id,'تهران' from public.profiles where role='student'
       and id <> '00000000-0000-4000-8000-000000000001'
       and id <> '00000000-0000-4000-8000-000000000012';
   insert into public.counselor_students(student_id,counselor_id,created_at)
     select id,'00000000-0000-4000-8000-999999999999',now()
     from public.profiles where role='student'
       and id <> '00000000-0000-4000-8000-000000000001'
       and id <> '00000000-0000-4000-8000-000000000012';
 `);
 for (const [query, province, reviewOnly] of [
   ['student',null,false], ['', 'تهران',false],
   ['مشاور يكتا', 'تهران',false], ['student', 'تهران',true],
 ]) {
   const resultPages = await Promise.all([1,2,3].map(n=>get(query,province,reviewOnly,n)));
   const expected = reviewOnly || query.includes('مشاور') ? 25 : 26;
   assert.equal(resultPages[0].total,expected);
   assert.deepEqual(resultPages.map(p=>p.rows.length),[10,10,expected-20]);
   assert.ok(resultPages.every(p=>p.rows.length<=10 && p.pages===3 && p.total===expected));
   assert.deepEqual(resultPages.map(p=>p.page),[1,2,3]);
   assert.equal(new Set(resultPages.flatMap(p=>p.rows.map(r=>r.student_id))).size,expected);
 }
 await db.close(); console.log('PASS: admin-only database pagination, global priority, search, review, counts, page boundaries and details');
})().catch(e=>{console.error(e);process.exitCode=1});
