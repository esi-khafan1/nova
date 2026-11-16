const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('232_planner_audit_batch2_1405');
// Dependency migrations that create the Batch 2 books' rows, in numeric order
// (validated to apply cleanly in PGlite together with 128 and 167).
const DEPS=['128_planner_topic_bank','133_planner_topic_chapters','134_planner_more_textbook_topics','136_planner_physics_writing_topics','137_planner_humanities_school_topics','138_planner_remaining_topics','141_planner_humanities_topics','142_planner_economics_topics','145_planner_philosophy12_topics','153_planner_religion12_topics','154_planner_shared_school_topics','155_planner_shared_school_detail','156_planner_shared_school_more_details','161_planner_three_1405_books','163_planner_religion12_1405_pages','167_planner_english9_1405_pages','169_planner_english_1405_details','173_planner_environment_1405_pages','181_planner_philosophy11_12_1405_pages','183_planner_legacy_exact_1405_pages','184_planner_philosophy_psychology_legacy_1405_pages','197_planner_economics_1405_pages','206_planner_labs_1405','209_planner_religion10_1405','212_planner_religion12_humanities_1405','213_planner_religion11_humanities_1405','215_planner_philosophy11_finer_1405','227_planner_vision_exercises_1405'];
const count=async(db,where,params=[])=>Number((await db.query(`select count(*) n from private.planner_topic_bank where ${where}`,params)).rows[0].n);
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 for(const n of DEPS)await db.exec(sql(n));
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 // Pre-audit counts (migration 206 has no پروژه chapter for آزمایشگاه ۱).
 assert.equal(await count(db,`subject='آزمایشگاه علوم تجربی ۱'`),101);
 assert.equal(await count(db,`subject='آزمایشگاه علوم تجربی ۱' and chapter='پروژه'`),0);
 await db.exec(migration);
 // The one new row: آزمایشگاه ۱ پروژه, printed pp.146–148 (book's printed range 1–152).
 const proj=(await db.query(`select id,title,page_start,page_end,position,revision from private.planner_topic_bank where study_field='experimental_sciences' and grade='10' and preparation_track='final_exam' and subject='آزمایشگاه علوم تجربی ۱' and chapter='پروژه' and position=3001`)).rows;
 assert.deepEqual(proj,[{id:proj[0].id,title:'کل پروژه',page_start:146,page_end:148,position:3001,revision:1}]);
 assert.ok((await db.query(`select 1 from private.planner_seed_installations where seed_key='audit-batch2-1405-v232'`)).rows.length===1);
 // Per book/combo row counts after the audit (no other book changes).
 assert.equal(await count(db,`subject='آزمایشگاه علوم تجربی ۱'`),102);
 assert.equal(await count(db,`subject='آزمایشگاه علوم تجربی ۲'`),85);
 for(const f of ['mathematics','experimental_sciences'])assert.equal(await count(db,`subject='تعلیمات دینی ۱' and study_field=$1`,[f]),173);
 assert.equal(await count(db,`subject='تعلیمات دینی ۱' and study_field='humanities'`),202);
 assert.equal(await count(db,`subject='تعلیمات دینی ۲' and study_field='humanities'`),295);
 for(const f of ['mathematics','experimental_sciences'])assert.equal(await count(db,`subject='تعلیمات دینی ۲' and study_field=$1`,[f]),82);
 assert.equal(await count(db,`subject='تعلیمات دینی ۳' and study_field='humanities'`),225);
 for(const f of ['mathematics','experimental_sciences'])assert.equal(await count(db,`subject='تعلیمات دینی ۳' and study_field=$1`,[f]),52);
 for(const tr of ['konkur','final_exam'])assert.equal(await count(db,`subject='اقتصاد' and preparation_track=$1`,[tr]),163);
 for(const f of ['mathematics','experimental_sciences','humanities'])assert.equal(await count(db,`subject='زبان خارجی ۳' and study_field=$1`,[f]),130);
 for(const f of ['mathematics','experimental_sciences','humanities'])assert.equal(await count(db,`subject='انسان و محیط زیست' and study_field=$1`,[f]),74);
 for(const tr of ['konkur','final_exam'])assert.equal(await count(db,`subject='فلسفه ۱' and preparation_track=$1`,[tr]),167);
 // No NULL pages anywhere in the Batch 2 books' combos, and the new row's
 // pages sit inside the book's printed range.
 assert.equal(await count(db,`subject in ('آزمایشگاه علوم تجربی ۱','آزمایشگاه علوم تجربی ۲','تعلیمات دینی ۱','تعلیمات دینی ۲','تعلیمات دینی ۳','اقتصاد','زبان خارجی ۳','انسان و محیط زیست','فلسفه ۱') and page_start is null`),0);
 assert.ok(proj[0].page_start>=1&&proj[0].page_end<=152&&proj[0].page_start<=proj[0].page_end);
 // Re-running the migration is a no-op (apart from the one new row).
 const afterFirst=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 assert.equal(afterFirst.length,before.length+1);
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,afterFirst);
 // A simulated admin edit of the new row survives a re-run.
 const id=proj[0].id;
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 await db.query(`select public.planner_save_topic($1,'1','1405','experimental_sciences','10','final_exam','آزمایشگاه علوم تجربی ۱','پروژه','ویرایش مدیر',146,148,3001)`,[id]);
 await db.exec(migration);
 let r=(await db.query('select title,revision from private.planner_topic_bank where id=$1',[id])).rows[0];
 assert.deepEqual(r,{title:'ویرایش مدیر',revision:2});
 // A simulated admin delete of the new row is NOT resurrected by a re-run.
 await db.query(`select public.planner_delete_topic($1,'2')`,[id]);
 await db.exec(migration);
 assert.equal((await db.query('select count(*) n from private.planner_topic_bank where id=$1',[id])).rows[0].n,0);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: batch 2 audit migration 232 — 1 new labs project row, 10 books verified, rerun/edit/delete protection holds');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
