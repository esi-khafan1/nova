// Isolated catalog and database fixture; never touches user plans or production.
const {PGlite}=require('@electric-sql/pglite');
const {buildSync}=require('esbuild');
const Module=require('node:module');
const fs=require('node:fs');
const assert=require('node:assert/strict');
const bundle=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':'./'}}).outputFiles[0].text;
const mod=new Module('test-planning-curriculum',module);mod.filename=require('node:path').resolve('test-planning-curriculum.cjs');mod.paths=module.paths;mod._compile(bundle,mod.filename);
const {curriculumBooks}=mod.exports;
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;
 create type public.app_role as enum('student','admin','counselor');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role')::public.app_role$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved')<>'yes' then raise exception 'Approved counselor required';end if;end$$;
 grant usage on schema public,private to authenticated,anon;`);
 await db.exec(fs.readFileSync('supabase/migrations/128_planner_topic_bank.sql','utf8'));
 const seed=fs.readFileSync('supabase/migrations/131_planner_biology12_1405_topics.sql','utf8');await db.exec(seed);
 const all=(await db.query('select * from private.planner_topic_bank')).rows;assert.equal(all.length,46);
 for(const track of ['konkur','final_exam']){
  const book=curriculumBooks('experimental_sciences',12,track).find(x=>x.subject==='زیست‌شناسی ۳');assert.ok(book);assert.equal(book.chapters.length,8);
  for(const chapter of book.chapters){const found=all.filter(x=>x.preparation_track===track&&x.chapter===chapter);assert.ok(found.length>=2,chapter);}
 }
 assert.equal(all.filter(x=>x.page_start!==null).length,6);
 await db.query("update private.planner_topic_bank set title='ویرایش مدیر', revision=revision+1 where id=$1",[all[0].id]);await db.exec(seed);
 assert.equal((await db.query('select count(*)::int n from private.planner_topic_bank')).rows[0].n,46);
 assert.equal((await db.query('select title from private.planner_topic_bank where id=$1',[all[0].id])).rows[0].title,'ویرایش مدیر');
 await db.exec("select set_config('test.role','counselor',false),set_config('test.approved','yes',false);set role authenticated");
 for(const track of ['konkur','final_exam']){
  const entries=(await db.query('select public.planner_list_topics($1,$2,$3,$4,$5,$6) entries',['1405','experimental_sciences','12',track,'زیست‌شناسی ۳','فصل ۱: مولکول‌های اطلاعاتی'])).rows[0].entries;
  assert.equal(entries.length,3);assert.deepEqual(entries.map(e=>[e.pageStart,e.pageEnd]),[[2,8],[9,14],[15,20]]);
 }
 console.log('PASS: 23 biology topics, both actual planner tracks, verified pages, safe rerun and counselor RPC');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
