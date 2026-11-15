// The real capability definition and RPCs run against synthetic accounts, not production.
const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const ids={super:'11111111-1111-4111-8111-111111111111',admin:'22222222-2222-4222-8222-222222222222',counselor:'33333333-3333-4333-8333-333333333333',student:'44444444-4444-4444-8444-444444444444'};
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create schema auth;
 create type public.app_role as enum('student','admin','counselor');
 create table public.profiles(id uuid primary key,role public.app_role);
 create table private.super_admins(user_id uuid primary key references public.profiles(id));
 create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('test.uid',true),'')::uuid$$;
 create function private.current_user_role() returns public.app_role language sql stable security definer set search_path='' as $$select role from public.profiles where id=(select auth.uid())$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved',true) is distinct from 'yes' then raise exception 'Approved counselor required' using errcode='42501';end if;end$$;
 grant usage on schema public,private,auth to authenticated,anon;
 create table public.fixture_snapshot(content jsonb);insert into public.fixture_snapshot values ('{"completed":true,"examId":"exam-1","topics":[{"pageStart":6}]}');`);
 for(const [name,id] of Object.entries(ids))await db.query('insert into public.profiles values ($1,$2)',[id,name==='super'?'admin':name==='counselor'?'counselor':name==='student'?'student':'admin']);
 await db.query('insert into private.super_admins values ($1)',[ids.super]);
 const original=sql('055_super_admin_capability');const fn=original.slice(original.indexOf('create or replace function private.is_super_admin()'),original.indexOf('revoke all on function private.is_super_admin()'));await db.exec(fn);
 await db.exec(sql('128_planner_topic_bank'));await db.exec(sql('140_planner_chapter_natural_order'));await db.exec(sql('192_planner_topic_super_admin'));
 const actor=async(id,approved='yes',role='authenticated')=>{await db.exec('reset role');await db.query("select set_config('test.uid',$1,false),set_config('test.approved',$2,false)",[id||'',approved]);await db.exec(`set role ${role}`)};
 const save=(id,rev,title='مبحث')=>db.query('select public.planner_save_topic($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12) x',[id,rev,'1405','experimental_sciences','12','konkur','شیمی ۳','فصل ۱',title,1,3,0]);
 const list=()=>db.query("select public.planner_list_topics('1405','experimental_sciences','12','konkur','شیمی ۳','فصل ۱') x");
 const chapters=()=>db.query("select public.planner_list_topic_chapters('1405','experimental_sciences','12','konkur','شیمی ۳') x");
 const del=(id,rev)=>db.query('select public.planner_delete_topic($1,$2)',[id,rev]);
 await actor(ids.super);const row=(await save(null,null)).rows[0].x;assert.equal(row.revision,'1');const revised=(await save(row.id,'1','ویرایش سوپرادمین')).rows[0].x;assert.equal(revised.revision,'2');await assert.rejects(()=>save(row.id,'1'),/Topic changed/);assert.equal((await list()).rows[0].x[0].title,'ویرایش سوپرادمین');assert.deepEqual((await chapters()).rows[0].x,['فصل ۱']);
 for(const id of [ids.admin,ids.student,ids.counselor]){await actor(id);await assert.rejects(()=>save(null,null),/Super administrator required/);await assert.rejects(()=>save(row.id,'2','تغییر غیرمجاز'),/Super administrator required/);await assert.rejects(()=>del(row.id,'2'),/Super administrator required/);await assert.rejects(()=>db.query('select * from private.planner_topic_bank'),/permission denied/);if(id!==ids.counselor){await assert.rejects(list,/required/);await assert.rejects(chapters,/required/)}else{assert.equal((await list()).rows[0].x[0].title,'ویرایش سوپرادمین');assert.deepEqual((await chapters()).rows[0].x,['فصل ۱']);}}
 // A stale capability row cannot elevate a non-admin profile.
 await db.exec('reset role');await db.query('insert into private.super_admins values ($1)',[ids.counselor]);await actor(ids.counselor);await assert.rejects(()=>save(row.id,'2'),/Super administrator required/);assert.equal((await list()).rows[0].x.length,1);
 await actor(ids.counselor,'no');await assert.rejects(list,/Approved counselor/);await assert.rejects(chapters,/Approved counselor/);
 await actor(null,'yes','anon');await assert.rejects(list,/permission denied/);await assert.rejects(chapters,/permission denied/);await assert.rejects(()=>save(null,null),/permission denied/);await assert.rejects(()=>del(row.id,'2'),/permission denied/);
 // A revoked super-admin capability is enforced immediately on the next request.
 await db.exec('reset role');await db.query('delete from private.super_admins where user_id=$1',[ids.super]);await actor(ids.super);await assert.rejects(()=>save(row.id,'2'),/Super administrator required/);await assert.rejects(()=>del(row.id,'2'),/Super administrator required/);await assert.rejects(list,/required/);
 await db.exec('reset role');await db.query('insert into private.super_admins values ($1)',[ids.super]);await actor(ids.super);await assert.rejects(()=>del(row.id,'1'),/Topic changed/);await del(row.id,'2');assert.deepEqual((await list()).rows[0].x,[]);
 await db.exec('reset role');assert.deepEqual((await db.query('select content from public.fixture_snapshot')).rows[0].content,{completed:true,examId:'exam-1',topics:[{pageStart:6}]});
 console.log('PASS: super-admin-only bank CRUD, direct RPC/table denials, counselor read-only, revocation, snapshot');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
