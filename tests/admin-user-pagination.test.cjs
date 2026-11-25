const assert=require('node:assert/strict'),fs=require('node:fs'),{PGlite}=require('@electric-sql/pglite');
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon; create role authenticated; create schema private; create schema auth;
 create type public.app_role as enum ('admin','student','counselor');
 create function private.current_user_role() returns public.app_role language sql stable as $$select coalesce(current_setting('test.role',true),'student')::public.app_role$$;
 create table public.profiles(id uuid primary key,full_name text,role public.app_role,grade smallint,phone text,created_at timestamptz);
 create table auth.users(id uuid primary key,email text,phone text);
 insert into public.profiles select ('00000000-0000-4000-8000-'||lpad(i::text,12,'0'))::uuid,case when i=17 then 'مریم يكتا' else 'student '||i end,case when i=24 then 'counselor'::public.app_role else 'student'::public.app_role end,10,case when i=17 then '989123456017' else null end, '2026-01-01'::timestamptz+i*interval '1 day' from generate_series(1,26)i;
 insert into auth.users select id, 'sample'||substring(id::text from 25)||'@example.test',case when id='00000000-0000-4000-8000-000000000012' then '989123456012' else null end from public.profiles;`);
 await db.exec(fs.readFileSync('supabase/migrations/113_registration_phone_search.sql','utf8').split('create or replace function public.admin_registration_directory_page')[0]);
 await db.exec(fs.readFileSync('supabase/migrations/254_admin_user_directory_pagination.sql','utf8'));
 await assert.rejects(db.query('select public.admin_user_directory_page()'),/Only administrators/);
 await db.exec("set test.role='admin'");
 const get=async(q='',page=1)=>(await db.query('select public.admin_user_directory_page($1,$2) result',[q,page])).rows[0].result;
 const first=await get(),second=await get('',2),last=await get('',9999);
 assert.equal(first.total,26);assert.equal(first.pages,3);assert.equal(last.page,3);
 assert.deepEqual([first.rows.length,second.rows.length,last.rows.length],[10,10,6]);
 assert.equal(new Set([...first.rows,...second.rows,...last.rows].map(x=>x.id)).size,26);
 assert.deepEqual([first.rows[0].full_name,second.rows[0].full_name,last.rows[5].full_name],['student 26','student 16','student 1']);
 assert.equal((await get('مريم يكتا')).rows[0].id,'00000000-0000-4000-8000-000000000017');
 assert.equal((await get('SAMPLE000000000012@EXAMPLE.TEST')).total,1);
 for(const [query,id] of [['۰۹۱۲۳۴۵۶۰۱۷','00000000-0000-4000-8000-000000000017'],['+98 912 345 6012','00000000-0000-4000-8000-000000000012']]){const r=await get(query);assert.equal(r.total,1,query);assert.equal(r.rows[0].id,id)}
 assert.equal((await get('%')).total,0);const empty=await get('not-found',99);assert.deepEqual(empty,{total:0,page:1,pages:1,rows:[]});
 assert.equal((await db.query("select has_function_privilege('anon','public.admin_user_directory_page(text,integer)','execute') ok")).rows[0].ok,false);
 // Results beyond the typical PostgREST row cap remain searchable and page-able;
 // only the selected ten records leave the database per request.
 await db.exec(`insert into public.profiles select ('00000000-0000-4000-8001-'||lpad(i::text,12,'0'))::uuid,'bulk '||i,'student',10,null,'2026-02-01'::timestamptz+i*interval '1 second' from generate_series(1,1100)i;`);
 const large=await get('',113), found=await get('bulk 1');
 assert.equal(large.total,1126);assert.equal(large.pages,113);assert.equal(large.rows.length,6);
 assert.ok(found.total>10 && found.rows.length===10);assert.equal((await get('bulk 1100')).total,1);
 assert.ok(JSON.stringify(large.rows).length < JSON.stringify((await db.query('select id,full_name,role,grade,created_at from public.profiles')).rows).length / 20);
 console.log('PASS: admin-only SQL pagination, global search, normalized phones and bounded results');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
