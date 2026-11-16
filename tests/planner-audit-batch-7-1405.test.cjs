const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('237_planner_audit_batch7_1405'),topics=JSON.parse(migration.split('$topics$')[1]);
// Printed-page ceiling per book (last printed page of the book; شیمی ۳'s
// واژه‌نامه/منابع appendix is numbered 124-126 by the TOC after the last
// numbered page 123, so its ceiling is 126).
const maxPage={'ریاضی ۱|mathematics':170,'ریاضی ۱|experimental_sciences':170,'ریاضی ۲|experimental_sciences':168,'ریاضی ۳|experimental_sciences':152,'ریاضی و آمار ۱|humanities':118,'ریاضی و آمار ۲|humanities':72,'ریاضی و آمار ۳|humanities':106,'سلامت و بهداشت|mathematics':186,'سلامت و بهداشت|experimental_sciences':186,'سلامت و بهداشت|humanities':186,'شیمی ۱|mathematics':126,'شیمی ۱|experimental_sciences':126,'شیمی ۳|mathematics':126,'شیمی ۳|experimental_sciences':126};
// The seven سلامت و بهداشت whole-lesson rows from migration 174 whose ranges
// are corrected by new Pattern A rows in this batch (old rows left untouched):
// [position, title, old start, old end]. Each is one page short at the start
// (the فصل-opening intro page) except درس ۱۰, which is one page short at the end.
const oldSalamat=[
  [1,'درس ۱: سلامت چیست؟',3,11],
  [3,'درس ۳: برنامه غذایی سالم',19,32],
  [6,'درس ۶: بیماری‌های غیر واگیر',49,66],
  [8,'درس ۸: بهداشت فردی',79,100],
  [10,'درس ۱۰: بهداشت روان',111,125],
  [11,'درس ۱۱: مصرف دخانیات و الکل',129,138],
  [13,'درس ۱۳: پیشگیری از اختلالات اسکلتی ـ عضلانی (کمردرد)',157,171]];
const DEPS=['128_planner_topic_bank','132_planner_verified_topics','133_planner_topic_chapters','134_planner_more_textbook_topics','135_planner_science_humanities_topics','137_planner_humanities_school_topics','167_planner_english9_1405_pages','174_planner_health_1405_pages','187_planner_chemistry_1405_pages','192_planner_topic_super_admin','195_planner_math_geometry_1405','202_planner_math9_1405'];
const code=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':process.cwd()}}).outputFiles[0].text,mod={exports:{}};new Function('module','exports','require',code)(mod,mod.exports,require);
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 for(const n of DEPS)await db.exec(sql(n));
 // Pre-migration state: no NULL-page row remains for any of the ten subjects
 // (the 195/202/174/187 seeds already page-filled the v1 rows), which is why
 // this batch has no Pattern B fills; and no prior row uses position >= 3000
 // for these subjects, so the new positions cannot collide.
 const subjects=['ریاضی ۱','ریاضی ۲','ریاضی ۳','ریاضی','ریاضی و آمار ۱','ریاضی و آمار ۲','ریاضی و آمار ۳','سلامت و بهداشت','شیمی ۱','شیمی ۳'];
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject=any($1) and page_start is null",[subjects])).rows[0].c,0);
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject=any($1) and position>=3000",[subjects])).rows[0].c,0);
 // The seven short سلامت lesson rows are page-filled already (revision 2).
 for(const [position,title,start,end] of oldSalamat){
  for(const field of ['mathematics','experimental_sciences','humanities']){
   const r=(await db.query("select page_start,page_end,revision from private.planner_topic_bank where subject='سلامت و بهداشت' and chapter='درس‌ها' and position=$1 and study_field=$2 and preparation_track='final_exam'",[position,field])).rows;
   assert.deepEqual(r,[{page_start:start,page_end:end,revision:2}],`pre-migration salamat pos ${position} ${field}`);
  }
 }
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.equal(topics.length,124);
 // Every new topic lands with exact pages inside the book, on the tracks its
 // konkur flag allows (سلامت و بهداشت is final_exam only; the rest have both).
 let rows=0;
 for(const p of topics){
  assert.ok(p.start>=1&&p.end>=p.start&&p.end<=maxPage[p.subject+'|'+p.field],`${p.subject} ${p.title} pages out of range`);
  for(const track of ['konkur','final_exam']){
   const r=(await db.query('select title,page_start,page_end,revision from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',['1405',p.field,p.grade,track,p.subject,p.chapter,p.position])).rows;
   if(p.konkur||track==='final_exam'){
    assert.deepEqual(r,[{title:p.title,page_start:p.start,page_end:p.end,revision:1}],`${p.subject} ${p.chapter} pos ${p.position} ${track}`);
    rows++;
   }else assert.equal(r.length,0);
  }
  // Chapter must already exist in the prior bank for that combo.
  assert.ok(before.some(b=>b.study_field===p.field&&b.grade===p.grade&&b.subject===p.subject&&b.chapter===p.chapter),`chapter not previously seeded: ${p.subject} ${p.chapter}`);
 }
 assert.equal(rows,224);
 // Spot checks on the audited values.
 for(const [subject,chapter,position,title,start,end] of [
  ['ریاضی ۱','فصل ۱: مجموعه، الگو و دنباله',3000,'تمرین مجموعه‌های متناهی و نامتناهی',7,7],
  ['ریاضی ۱','فصل ۳: توان‌های گویا و عبارت‌های جبری',3001,'تمرین ریشه nام',56,56],
  ['ریاضی ۱','فصل ۳: توان‌های گویا و عبارت‌های جبری',3002,'تمرین ریشه nام (پایان درس)',57,58],
  ['ریاضی ۱','فصل ۶: شمارش، بدون شمردن',3003,'تمرین ترکیب (پایان درس)',139,140],
  ['ریاضی ۱','فصل ۷: آمار و احتمال',3002,'تمرین متغیر و انواع آن',168,170],
  ['ریاضی ۲','فصل ۷: آمار و احتمال',3000,'منابع',167,167],
  ['ریاضی ۳','فصل ۷: احتمال',3000,'منابع',149,151],
  ['ریاضی و آمار ۱','فصل ۱',3002,'تمرین روش مربع کامل',27,27],
  ['ریاضی و آمار ۱','فصل ۴',3001,'تمرین نمایش داده (پایان درس)',109,109],
  ['ریاضی و آمار ۱','فصل ۴',3004,'منابع',118,118],
  ['ریاضی و آمار ۲','فصل ۲',3001,'تمرین توابع ثابت، چندضابطه‌ای و همانی',31,33],
  ['ریاضی و آمار ۲','فصل ۳',3002,'منابع',71,71],
  ['ریاضی و آمار ۳','فصل ۳',3003,'تمرین تابع نمایی (پایان درس)',104,104],
  ['ریاضی و آمار ۳','فصل ۳',3004,'منابع',105,105],
  ['سلامت و بهداشت','درس‌ها',3000,'درس ۱: سلامت چیست؟',2,11],
  ['سلامت و بهداشت','درس‌ها',3004,'درس ۱۰: بهداشت روان',111,126],
  ['سلامت و بهداشت','درس‌ها',3006,'درس ۱۳: پیشگیری از اختلالات اسکلتی ـ عضلانی (کمردرد)',156,171],
  ['سلامت و بهداشت','درس‌ها',3007,'منابع',185,185],
  ['شیمی ۱','فصل ۳: آب، آهنگ زندگی',3000,'واژه‌نامه',123,126],
  ['شیمی ۱','فصل ۳: آب، آهنگ زندگی',3001,'منابع',126,126],
  ['شیمی ۳','فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر',3000,'واژه‌نامه',124,125],
  ['شیمی ۳','فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر',3001,'منابع',126,126]]){
  const t=topics.find(t=>t.subject===subject&&t.chapter===chapter&&t.position===position);
  assert.ok(t);assert.deepEqual([t.title,t.start,t.end],[title,start,end]);
 }
 // The seven short سلامت lesson rows are untouched by this migration.
 for(const [position,title,start,end] of oldSalamat){
  for(const field of ['mathematics','experimental_sciences','humanities']){
   const r=(await db.query("select page_start,page_end,revision from private.planner_topic_bank where subject='سلامت و بهداشت' and chapter='درس‌ها' and position=$1 and study_field=$2 and preparation_track='final_exam'",[position,field])).rows;
   assert.deepEqual(r,[{page_start:start,page_end:end,revision:2}],`old salamat pos ${position} ${field}`);
  }
 }
 // No NULL-page row remains for any of the ten subjects.
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject=any($1) and page_start is null",[subjects])).rows[0].c,0);
 // Catalog: the audited subjects exist for their combos; specialist chapters match the catalog.
 for(const track of ['konkur','final_exam']){
  for(const field of ['mathematics','experimental_sciences']){
   assert.ok(mod.exports.curriculumBooks(field,10,track).some(x=>x.subject==='ریاضی ۱'),`catalog ریاضی ۱ ${field} ${track}`);
   assert.ok(mod.exports.curriculumBooks(field,10,track).some(x=>x.subject==='شیمی ۱'),`catalog شیمی ۱ ${field} ${track}`);
   assert.ok(mod.exports.curriculumBooks(field,12,track).some(x=>x.subject==='شیمی ۳'),`catalog شیمی ۳ ${field} ${track}`);
  }
  assert.ok(mod.exports.curriculumBooks('experimental_sciences',11,track).some(x=>x.subject==='ریاضی ۲'),`catalog ریاضی ۲ ${track}`);
  assert.ok(mod.exports.curriculumBooks('experimental_sciences',12,track).some(x=>x.subject==='ریاضی ۳'),`catalog ریاضی ۳ ${track}`);
  assert.ok(mod.exports.curriculumBooks('humanities',10,track).some(x=>x.subject==='ریاضی و آمار ۱'),`catalog ریاضی و آمار ۱ ${track}`);
  assert.ok(mod.exports.curriculumBooks('humanities',11,track).some(x=>x.subject==='ریاضی و آمار ۲'),`catalog ریاضی و آمار ۲ ${track}`);
  assert.ok(mod.exports.curriculumBooks('humanities',12,track).some(x=>x.subject==='ریاضی و آمار ۳'),`catalog ریاضی و آمار ۳ ${track}`);
 }
 // سلامت و بهداشت is a shared school subject: final_exam only, all three fields.
 for(const field of ['mathematics','experimental_sciences','humanities'])
  assert.ok(mod.exports.curriculumBooks(field,12,'final_exam').some(x=>x.subject==='سلامت و بهداشت'),`catalog سلامت و بهداشت ${field}`);
 assert.ok(mod.exports.curriculumBooks(null,9,'final_exam').some(x=>x.subject==='ریاضی'),'catalog ریاضی ۹');
 const m1=mod.exports.curriculumBooks('mathematics',10,'konkur').find(x=>x.subject==='ریاضی ۱');assert.ok(m1);
 for(const c of ['فصل ۱: مجموعه، الگو و دنباله','فصل ۲: مثلثات','فصل ۳: توان‌های گویا و عبارت‌های جبری','فصل ۴: معادله‌ها و نامعادله‌ها','فصل ۵: تابع','فصل ۶: شمارش، بدون شمردن','فصل ۷: آمار و احتمال'])assert.ok(m1.chapters.includes(c));
 const am1=mod.exports.curriculumBooks('humanities',10,'konkur').find(x=>x.subject==='ریاضی و آمار ۱');assert.ok(am1);
 for(const c of ['فصل ۱','فصل ۲','فصل ۳','فصل ۴'])assert.ok(am1.chapters.includes(c));
 const ch3=mod.exports.curriculumBooks('mathematics',12,'konkur').find(x=>x.subject==='شیمی ۳');assert.ok(ch3);
 for(const c of ['فصل ۱: مولکول‌ها در خدمت تندرستی','فصل ۲: آسایش و رفاه در سایه شیمی','فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری','فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر'])assert.ok(ch3.chapters.includes(c));
 // Bank delta is exactly 224 new rows; nothing else changed.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const newIds=new Set(after.filter(a=>!before.some(b=>b.id===a.id)).map(a=>a.id));
 assert.equal(newIds.size,224);
 const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
 assert.equal(changed.length,0);
 assert.deepEqual(after.filter(a=>!newIds.has(a.id)),before);
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit via planner_save_topic and delete of new rows survive a re-run.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='ریاضی ۱' and chapter='فصل ۳: توان‌های گویا و عبارت‌های جبری' and position=3002 and study_field='mathematics' and preparation_track='konkur'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','10','konkur','ریاضی ۱','فصل ۳: توان‌های گویا و عبارت‌های جبری','ویرایش مدیر',57,58,3002)",[edit.id,edit.r]);
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='شیمی ۳' and position=3001 and study_field='experimental_sciences' and preparation_track='final_exam'")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Batch 7 audit: 124 topics / 224 rows (ریاضی ۱ 26 تمرین, ریاضی ۲/۳ منابع, ریاضی و آمار ۱/۲/۳ 35 تمرین + 3 منابع, سلامت 7 corrected lessons + منابع, شیمی ۱/۳ واژه‌نامه + منابع) + 0 page-fills across 10 books; prior rows, superseded سلامت lessons, edits/deletions/rerun and simulated snapshot');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
