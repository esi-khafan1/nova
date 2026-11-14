// Synthetic catalog fixture, no production data.
const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;
 create type public.app_role as enum('student','admin','counselor');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role')::public.app_role$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved')<>'yes' then raise exception 'Approved counselor required';end if;end$$;
 grant usage on schema public,private to authenticated,anon;`);
 await db.exec(fs.readFileSync('supabase/migrations/128_planner_topic_bank.sql','utf8'));
 const actor=async(role,approved='yes')=>{await db.exec('reset role');await db.query("select set_config('test.role',$1,false),set_config('test.approved',$2,false)",[role,approved]);await db.exec('set role authenticated')};
 const save=(id,rev,title='مبحث',start=1,end=3)=>db.query('select public.planner_save_topic($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12) x',[id,rev,'1405','experimental_sciences','12','konkur','شیمی ۳','فصل ۱',title,start,end,0]);
 const list=()=>db.query("select public.planner_list_topics('1405','experimental_sciences','12','konkur','شیمی ۳','فصل ۱') x");
 await actor('admin');const result=(await save(null,null)).rows[0].x;assert.equal(result.revision,'1');await assert.rejects(()=>save(null,null,'نام',null,3));await assert.rejects(()=>save(result.id,'2'),/Topic changed/);
 const next=(await save(result.id,'1','مبحث ویرایش‌شده',2,4)).rows[0].x;assert.equal(next.revision,'2');
 await actor('counselor');const entries=(await list()).rows[0].x;assert.equal(entries[0].title,'مبحث ویرایش‌شده');assert.equal(entries[0].pageStart,2);await assert.rejects(()=>save(null,null),/Administrator required/);await assert.rejects(()=>db.query('select * from private.planner_topic_bank'),/permission denied/);
 await actor('counselor','no');await assert.rejects(list,/Approved counselor/);await actor('student');await assert.rejects(list,/required/);
 await actor('admin');await assert.rejects(()=>db.query('select public.planner_delete_topic($1,$2)',[result.id,'1']),/Topic changed/);await db.query('select public.planner_delete_topic($1,$2)',[result.id,'2']);assert.deepEqual((await list()).rows[0].x,[]);
 console.log('PASS: private shared topic bank access, validated pages and optimistic revisions');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
