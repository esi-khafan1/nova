// Synthetic database: verify permissions, optimistic concurrency and history preservation.
const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;
 create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select nullif(current_setting('test.role',true),'')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select coalesce(current_setting('test.super',true),'false')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved',true) is distinct from 'yes' then raise exception 'Approved counselor required' using errcode='42501';end if;end$$;
 grant usage on schema public,private to authenticated,anon;
 create table public.fixture_snapshot(content jsonb);insert into public.fixture_snapshot values ('{"plan":"p","exam":"e","ticks":[true,false],"topics":[{"bankId":"11111111-1111-4111-8111-111111111111","title":"نسخه قدیمی","pageStart":15}]}');`);
 for(const n of ['128_planner_topic_bank','192_planner_topic_super_admin','245_planner_phase3_hide_moved_rows_1405','248_planner_restore_hidden_topics'])await db.exec(sql(n));
 const id='11111111-1111-4111-8111-111111111111';await db.query(`insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position,hidden_from_selection) values($1,'1405','humanities','11','final_exam','جغرافیا ۲','درس ۲','ویرایش مدیر',15,17,3,true)`,[id]);
 const actor=async(role,superuser,approved='yes',dbrole='authenticated')=>{await db.exec('reset role');await db.query("select set_config('test.role',$1,false),set_config('test.super',$2,false),set_config('test.approved',$3,false)",[role,String(superuser),approved]);await db.exec(`set role ${dbrole}`)};
 const list=()=>db.query("select public.planner_list_topics('1405','humanities','11','final_exam','جغرافیا ۲','درس ۲') x");
 const restore=(rev='1')=>db.query('select public.planner_restore_hidden_topic($1,$2) x',[id,rev]);
 await actor('counselor',false);assert.deepEqual((await list()).rows[0].x,[]);await assert.rejects(restore(),/Super administrator required/);
 await actor('admin',false);await assert.rejects(restore(),/Super administrator required/);await assert.rejects(list(),/required/);
 await actor('student',false);await assert.rejects(restore(),/Super administrator required/);
 await actor('counselor',true);await assert.rejects(restore(),/Super administrator required/,'stale capability cannot elevate a counselor');
 await actor('',false,'yes','anon');await assert.rejects(restore(),/permission denied/);
 await actor('admin',true);const hidden=(await list()).rows[0].x[0];assert.equal(hidden.hiddenFromSelection,true);assert.equal(hidden.title,'ویرایش مدیر');await assert.rejects(restore('0'),/Invalid revision/);await assert.rejects(restore('2'),/Topic changed/);
 // A real concurrent edit bumps the revision; the old button must not overwrite it.
 await db.query("select public.planner_save_topic($1,'1','1405','humanities','11','final_exam','جغرافیا ۲','درس ۲','تغییر همزمان مدیر',15,18,3)",[id]);await assert.rejects(restore('1'),/Topic changed/);
 const before=(await list()).rows[0].x[0];assert.equal(before.hiddenFromSelection,true);const r=(await restore('2')).rows[0].x;assert.deepEqual(r,{id,revision:'3'});const after=(await list()).rows[0].x[0];assert.deepEqual({...after,revision:before.revision,hiddenFromSelection:before.hiddenFromSelection},before);assert.equal(after.hiddenFromSelection,false);await assert.rejects(restore('3'),/Topic changed/);
 await actor('counselor',false);assert.equal((await list()).rows[0].x[0].title,'تغییر همزمان مدیر');assert.equal((await list()).rows[0].x[0].hiddenFromSelection,false);
 await actor('counselor',false,'no');await assert.rejects(list(),/Approved counselor/);
 await actor('admin',true);await db.query("select public.planner_delete_topic($1,'3')",[id]);await assert.rejects(restore('3'),/Topic changed/,'a deleted topic is never recreated');
 await db.exec('reset role');const snapshot=(await db.query('select content from public.fixture_snapshot')).rows[0].content;assert.deepEqual(snapshot,{plan:'p',exam:'e',ticks:[true,false],topics:[{bankId:id,title:'نسخه قدیمی',pageStart:15}]});
 // The actual v1 seed ID and exact post-241 state match migration 245's guard.
 // Once restored, its bumped revision prevents 245 from hiding it again.
 const crypto=require('node:crypto');const h=crypto.createHash('md5').update('nova:planner:1405:v1:humanities:11:final_exam:جغرافیا ۲:درس ۱:3').digest('hex');const seedId=`${h.slice(0,8)}-${h.slice(8,12)}-${h.slice(12,16)}-${h.slice(16,20)}-${h.slice(20)}`;
 await db.query(`insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position,revision) values($1,'1405','humanities','11','final_exam','جغرافیا ۲','درس ۲','کانون و مرزهای ناحیه',15,17,3,2)`,[seedId]);
 await db.exec(sql('245_planner_phase3_hide_moved_rows_1405'));assert.deepEqual((await db.query('select revision::text,hidden_from_selection from private.planner_topic_bank where id=$1',[seedId])).rows,[{revision:'3',hidden_from_selection:true}]);
 await actor('admin',true);await db.query("select public.planner_restore_hidden_topic($1,'3')",[seedId]);await db.exec('reset role');await db.exec(sql('245_planner_phase3_hide_moved_rows_1405'));assert.deepEqual((await db.query('select revision::text,hidden_from_selection from private.planner_topic_bank where id=$1',[seedId])).rows,[{revision:'4',hidden_from_selection:false}]);
 console.log('PASS: hidden-topic restore role checks, revision conflicts, retained edits, counselor listing and simulated snapshot');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
