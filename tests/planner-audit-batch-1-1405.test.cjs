const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('231_planner_audit_batch1_1405'),topics=JSON.parse(migration.split('$topics$')[1]);
// Printed-page ceiling per book (PDF pages minus the PDF->printed offset).
const maxPage={'آمار و احتمال|mathematics':122,'عربی|all':136,'عربی زبان قرآن ۲|mathematics':102,'عربی زبان قرآن ۲|experimental_sciences':102,'عربی زبان قرآن ۳|mathematics':68,'عربی زبان قرآن ۳|experimental_sciences':68,'عربی ۲ تخصصی|humanities':102};
const code=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':process.cwd()}}).outputFiles[0].text,mod={exports:{}};new Function('module','exports','require',code)(mod,mod.exports,require);
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 for(const n of ['128_planner_topic_bank','133_planner_topic_chapters','134_planner_more_textbook_topics','135_planner_science_humanities_topics','137_planner_humanities_school_topics','138_planner_remaining_topics','147_planner_arabic10_topics','148_planner_arabic_geography_topics','149_planner_arabic12_topics','151_planner_grade9_topics','167_planner_english9_1405_pages','188_planner_arabic12_1405_pages','189_planner_arabic11_1405_pages','191_planner_arabic10_1405_pages','192_planner_topic_super_admin','198_planner_society_statistics_1405','207_planner_defense9_1405','221_planner_quran9_1405','222_planner_arabic9_1405'])await db.exec(sql(n));
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 // No NULL-page rows for any batch-1 book before the audit migration.
 const nulls=(await db.query("select count(*) c from private.planner_topic_bank where subject in ('آمادگی دفاعی','آمار و احتمال','آموزش قرآن','عربی','عربی زبان قرآن ۱','عربی زبان قرآن ۲','عربی زبان قرآن ۳','عربی ۱ تخصصی','عربی ۲ تخصصی','عربی ۳ تخصصی') and page_start is null")).rows[0].c;
 assert.equal(Number(nulls),0);
 await db.exec(migration);
 assert.equal(topics.length,11);
 // Every new topic lands in exactly its intended tracks, with exact pages inside the book.
 let rows=0;
 for(const p of topics){
  const tracks=p.konkur?['konkur','final_exam']:['final_exam'];
  assert.ok(p.start>=1&&p.end>=p.start&&p.end<=maxPage[p.subject+'|'+p.field],`${p.subject} ${p.title} pages out of range`);
  for(const track of tracks){
   const r=(await db.query('select title,page_start,page_end,revision from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',['1405',p.field,p.grade,track,p.subject,p.chapter,p.position])).rows;
   assert.deepEqual(r,[{title:p.title,page_start:p.start,page_end:p.end,revision:1}],`${p.subject} ${p.chapter} pos ${p.position} ${track}`);
   rows++;
  }
  if(!p.konkur){
   const k=(await db.query('select count(*) c from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',['1405',p.field,p.grade,'konkur',p.subject,p.chapter,p.position])).rows[0].c;
   assert.equal(Number(k),0);
  }
  assert.ok(before.some(b=>b.study_field===p.field&&b.grade===p.grade&&b.subject===p.subject&&b.chapter===p.chapter),`chapter not previously seeded: ${p.subject} ${p.chapter}`);
 }
 assert.equal(rows,17);
 // Per book/combo row counts after the audit.
 for(const [field,grade,track,subject,count] of [
  ['mathematics','11','final_exam','آمار و احتمال',79],['mathematics','11','konkur','آمار و احتمال',79],
  ['all','9','final_exam','عربی',147],
  ['mathematics','11','final_exam','عربی زبان قرآن ۲',70],['experimental_sciences','11','final_exam','عربی زبان قرآن ۲',70],
  ['mathematics','12','final_exam','عربی زبان قرآن ۳',37],['experimental_sciences','12','final_exam','عربی زبان قرآن ۳',37],
  ['humanities','11','final_exam','عربی ۲ تخصصی',68],['humanities','11','konkur','عربی ۲ تخصصی',68]]){
  const c=(await db.query('select count(*) c from private.planner_topic_bank where study_field=$1 and grade=$2 and preparation_track=$3 and subject=$4',[field,grade,track,subject])).rows[0].c;
  assert.equal(Number(c),count,`${field} ${grade} ${track} ${subject}`);
 }
 // Catalog chapters for the study-catalog subjects (shared school books carry
 // chapters: [] in the catalog; their chapters live in the topic bank, checked above).
 for(const track of ['konkur','final_exam']){
  const stats=mod.exports.curriculumBooks('mathematics',11,track).find(x=>x.subject==='آمار و احتمال');assert.ok(stats);
  for(const p of topics.filter(t=>t.subject==='آمار و احتمال'))assert.ok(stats.chapters.includes(p.chapter));
  const ar11=mod.exports.curriculumBooks('humanities',11,track).find(x=>x.subject==='عربی ۲ تخصصی');assert.ok(ar11);
  for(const p of topics.filter(t=>t.subject==='عربی ۲ تخصصی'))assert.ok(ar11.chapters.includes(p.chapter));
 }
 const ar9=mod.exports.curriculumBooks(null,9,'final_exam').find(x=>x.subject==='عربی');assert.ok(ar9);
 for(const field of ['mathematics','experimental_sciences']){
  assert.ok(mod.exports.curriculumBooks(field,11,'final_exam').some(x=>x.subject==='عربی زبان قرآن ۲'),field);
  assert.ok(mod.exports.curriculumBooks(field,12,'final_exam').some(x=>x.subject==='عربی زبان قرآن ۳'),field);
 }
 // Spot checks on the audited values.
 for(const [subject,chapter,position,title,start,end] of [
  ['آمار و احتمال','فصل ۳: آمار توصیفی',3000,'تمرین نمایش داده‌ها',77,78],
  ['آمار و احتمال','فصل ۳: آمار توصیفی',3001,'خواندنی: تاریخچۀ علم آمار و علم احتمال',79,79],
  ['آمار و احتمال','فصل ۳: آمار توصیفی',3002,'چارک و نما',83,85],
  ['آمار و احتمال','فصل ۳: آمار توصیفی',3003,'خواندنی: کاربرد علم آمار در علوم شناختی و مغز',86,86],
  ['آمار و احتمال','فصل ۲: احتمال',3000,'تمرین احتمال غیرهم‌شانس',47,47],
  ['عربی','درس ۱۰',3000,'سخن پایانی',135,135],
  ['عربی زبان قرآن ۲','درس ۷',3000,'پژوهش علمی',100,100],
  ['عربی زبان قرآن ۳','درس ۱',3000,'تمرین‌های درس',10,15],
  ['عربی ۲ تخصصی','درس ۱',3000,'تمرین‌های درس',10,14]]){
  const t=topics.find(t=>t.subject===subject&&t.chapter===chapter&&t.position===position);
  assert.ok(t,`${subject} ${chapter} ${position}`);assert.deepEqual([t.title,t.start,t.end],[title,start,end]);
 }
 // The superseded wrong-end rows are untouched (old values, revision unchanged).
 for(const [subject,chapter,position,title,start,end,rev] of [
  ['آمار و احتمال','فصل ۳: آمار توصیفی',451,'تمرین نمایش داده‌ها',77,79,1],
  ['آمار و احتمال','فصل ۳: آمار توصیفی',454,'چارک و نما',83,86,1],
  ['عربی زبان قرآن ۳','درس ۱',3,'تمرین‌های درس',10,16,2],
  ['عربی ۲ تخصصی','درس ۱',3,'تمرین‌های درس',10,15,2]]){
  const r=(await db.query('select title,page_start,page_end,revision from private.planner_topic_bank where subject=$1 and chapter=$2 and position=$3 and study_field=$4 and preparation_track=$5',[subject,chapter,position,subject==='آمار و احتمال'?'mathematics':subject==='عربی زبان قرآن ۳'?'mathematics':'humanities','final_exam'])).rows;
  assert.deepEqual(r,[{title,page_start:start,page_end:end,revision:rev}],`${subject} ${chapter} pos ${position}`);
 }
 // No prior row changed: the pre-migration bank is intact apart from the 17 new rows.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const newIds=new Set(after.filter(a=>!before.some(b=>b.id===a.id)).map(a=>a.id));
 assert.equal(newIds.size,17);
 assert.deepEqual(after.filter(a=>!newIds.has(a.id)),before);
 // A new row is listable through the planner RPC.
 await db.query("select set_config('test.role','counselor',false),set_config('test.super','false',false),set_config('test.approved','true',false)");
 assert.ok((await db.query("select public.planner_list_topics('1405','mathematics','11','final_exam','آمار و احتمال','فصل ۳: آمار توصیفی') v")).rows[0].v.some(x=>x.title==='خواندنی: تاریخچۀ علم آمار و علم احتمال'));
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit via planner_save_topic and delete of new rows survive a re-run.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='آمار و احتمال' and chapter='فصل ۳: آمار توصیفی' and position=3001 and preparation_track='final_exam'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','11','final_exam','آمار و احتمال','فصل ۳: آمار توصیفی','ویرایش مدیر',79,79,3001)",[edit.id,edit.r]);
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='عربی' and chapter='درس ۱۰' and position=3000")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Batch 1 audit: 11 topics / 17 rows across 5 books (defence, Quran, Arabic 10/12 need none); superseded rows untouched, edits/deletions/rerun and simulated snapshot');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
