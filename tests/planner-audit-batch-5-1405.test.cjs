const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('235_planner_audit_batch5_1405'),topics=JSON.parse(migration.split('$topics$')[1]);
// Printed-page ceiling per book (PDF pages minus the PDF->printed offset).
const maxPage={'جامعه‌شناسی ۱|humanities':144,'جغرافیای ایران|humanities':114,'جغرافیای ایران|mathematics':114,'جغرافیای ایران|experimental_sciences':114,'جغرافیا ۳|humanities':120,'جغرافیا ۲|humanities':168,'کار و فناوری|all':152,'کتاب کار زبان انگلیسی|all':96,'منطق|humanities':125,'مدیریت خانواده و سبک زندگی|mathematics':193,'مدیریت خانواده و سبک زندگی|experimental_sciences':193,'مدیریت خانواده و سبک زندگی|humanities':193,'مطالعات اجتماعی|all':170};
const code=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':process.cwd()}}).outputFiles[0].text,mod={exports:{}};new Function('module','exports','require',code)(mod,mod.exports,require);
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 for(const n of ['128_planner_topic_bank','133_planner_topic_chapters','148_planner_arabic_geography_topics','151_planner_grade9_topics','167_planner_english9_1405_pages','169_planner_english_1405_details','175_planner_logic_1405_pages','178_planner_geography10_1405_pages','180_planner_geography11_12_independent_1405','192_planner_topic_super_admin','198_planner_society_statistics_1405','201_planner_logic_1405','214_planner_work_technology9_1405','218_planner_family12_versions_1405','223_planner_workbook9_audit_1405','225_planner_workbook9_subparts_1405','229_planner_geography_activities_1405','230_planner_geography_skills_1405'])await db.exec(sql(n));
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.equal(topics.length,188);
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
   assert.equal(k,0);
  }
  // Chapter must already exist in the prior bank for that combo.
  assert.ok(before.some(b=>b.study_field===p.field&&b.grade===p.grade&&b.subject===p.subject&&b.chapter===p.chapter),`chapter not previously seeded: ${p.subject} ${p.chapter}`);
 }
 assert.equal(rows,203);
 // Catalog chapters for the humanities books.
 for(const track of ['konkur','final_exam']){
  for(const [field,grade,subj] of [['humanities','10','جامعه‌شناسی ۱'],['humanities','10','جغرافیای ایران'],['humanities','10','منطق'],['humanities','11','جغرافیا ۲'],['humanities','12','جغرافیا ۳']]){
   const book=mod.exports.curriculumBooks(field,Number(grade),track).find(x=>x.subject===subj);assert.ok(book,`${field} ${grade} ${subj}`);
   for(const p of topics.filter(t=>t.subject===subj&&t.field===field))assert.ok(book.chapters.includes(p.chapter),`${subj} ${p.chapter} not in catalog`);
  }
 }
 // Spot checks on the audited values.
 for(const [subject,chapter,position,title,start,end] of [
  ['جامعه‌شناسی ۱','درس ۱۶',3000,'منابع',142,144],
  ['جغرافیای ایران','درس ۱۰',3000,'واژه‌ها و اصطلاحات',109,114],
  ['جغرافیا ۳','درس ۶',3000,'بیشتر بدانیم: معرفی برخی از کلیدهای نوار ابزار گوگل ارث',115,115],
  ['جغرافیا ۳','درس ۶',3001,'واژه‌نامه',116,118],
  ['جغرافیا ۲','درس ۱۱',3000,'واژه‌ها و اصطلاحات',161,163],
  ['کار و فناوری','پودمان ۶: برق',3000,'آغاز بخش دوم: پودمان‌های نیمه‌تجویزی (انتخاب دو پروژه از شش پودمان)',71,71],
  ['کتاب کار زبان انگلیسی','درس‌ها',3000,'درس 5: Media — کل درس',67,80],
  ['منطق','درس ۱۰',3001,'منابع',124,125],
  ['مدیریت خانواده و سبک زندگی','دختران — صحنه ۱۰: زندگی با طعم مسئولیت',3000,'دختران — منابع پیشنهادی برای مطالعه',193,193],
  ['مدیریت خانواده و سبک زندگی','پسران — درس ۱: هویت و آرمان',3000,'پسران — آغاز فصل اول: هویت و سبک زندگی',1,1],
  ['مطالعات اجتماعی','فصل ۸: سقوط حکومت شاهنشاهی و شکل‌گیری نظام جمهوری اسلامی',3012,'درس ۱۶: جنگ تحمیلی در سال ۱۴۰۴ و هدف قرار دادن ارکان قدرت ملی',114,114],
  ['مطالعات اجتماعی','فصل ۱۲: بهره‌وری',3001,'درس ۲۳: بهره‌وری چیست؟',160,161]]){
  const t=topics.find(t=>t.subject===subject&&t.chapter===chapter&&t.position===position);
  assert.ok(t);assert.deepEqual([t.title,t.start,t.end],[title,start,end]);
 }
 // Pattern B: the eight مطالعات اجتماعی ۹ whole-lesson rows are page-filled, revision bumped.
 for(const [chapter,position,start,end] of [
  ['فصل ۴: ساکنان سیاره زمین',1,42,46],['فصل ۴: ساکنان سیاره زمین',2,47,52],
  ['فصل ۷: ایران در عصر مشروطه',1,82,87],['فصل ۷: ایران در عصر مشروطه',2,88,94],
  ['فصل ۸: سقوط حکومت شاهنشاهی و شکل‌گیری نظام جمهوری اسلامی',1,96,104],['فصل ۸: سقوط حکومت شاهنشاهی و شکل‌گیری نظام جمهوری اسلامی',2,105,116],
  ['فصل ۱۲: بهره‌وری',1,158,163],['فصل ۱۲: بهره‌وری',2,164,170]]){
  const r=(await db.query("select title,page_start,page_end,revision from private.planner_topic_bank where subject='مطالعات اجتماعی' and chapter=$1 and position=$2",[chapter,position])).rows;
  assert.equal(r.length,1);assert.equal(r[0].page_start,start);assert.equal(r[0].page_end,end);assert.equal(r[0].revision,2);
 }
 // The superseded workbook کل درس ۵ row (67–81) and the جغرافیا ۲ old row are untouched.
 const oldWb=(await db.query("select title,page_start,page_end,revision from private.planner_topic_bank where subject='کتاب کار زبان انگلیسی' and position=501")).rows;
 assert.deepEqual(oldWb,[{title:'درس 5: Media — کل درس',page_start:67,page_end:81,revision:1}]);
 const oldGeo=(await db.query("select title,page_start,page_end,revision from private.planner_topic_bank where subject='جغرافیا ۲' and chapter='درس ۱' and position=3")).rows;
 assert.deepEqual(oldGeo,[{title:'کانون و مرزهای ناحیه',page_start:null,page_end:null,revision:1},{title:'کانون و مرزهای ناحیه',page_start:null,page_end:null,revision:1}]);
 const correctGeo=(await db.query("select title,page_start,page_end,revision from private.planner_topic_bank where subject='جغرافیا ۲' and chapter='درس ۲' and position=303 and preparation_track='final_exam'")).rows;
 assert.deepEqual(correctGeo,[{title:'کانون و مرز ناحیه',page_start:15,page_end:18,revision:1}]);
 // No prior row changed apart from the 8 pattern-B fills: 203 new ids, 8 modified rows.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const newIds=new Set(after.filter(a=>!before.some(b=>b.id===a.id)).map(a=>a.id));
 assert.equal(newIds.size,203);
 const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
 assert.equal(changed.length,8);
 assert.ok(changed.every(a=>a.subject==='مطالعات اجتماعی'&&a.revision===2&&a.page_start!==null));
 assert.deepEqual(after.filter(a=>!newIds.has(a.id)&&!changed.some(c=>c.id===a.id)),before.filter(b=>!changed.some(c=>c.id===b.id)));
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit via planner_save_topic and delete of new rows survive a re-run.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='مطالعات اجتماعی' and chapter='فصل ۱: سیاره ما، زمین' and position=3000 and preparation_track='final_exam'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','all','9','final_exam','مطالعات اجتماعی','فصل ۱: سیاره ما، زمین','ویرایش مدیر',1,1,3000)",[edit.id,edit.r]);
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='جامعه‌شناسی ۱' and chapter='درس ۱' and position=3000 and preparation_track='final_exam'")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Batch 5 audit: 188 topics / 203 rows across 10 books; 8 pattern-B fills; old geography/workbook rows untouched; edits/deletions/rerun and simulated snapshot');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
