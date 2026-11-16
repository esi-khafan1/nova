const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('234_planner_audit_batch4_1405'),topics=JSON.parse(migration.split('$topics$')[1]);
// Printed-page ceiling per book (PDF pages minus the PDF->printed offset).
const maxPage={'فیزیک ۲|mathematics':136,'فیزیک ۲|experimental_sciences':111,'ریاضیات گسسته|mathematics':86,'هندسه ۱|mathematics':96,'هندسه ۳|mathematics':88,'هندسه ۲|mathematics':80,'حسابان ۱|mathematics':154,'حسابان ۲|mathematics':146,'جامعه‌شناسی ۳|humanities':121,'جامعه‌شناسی ۲|humanities':140};
const code=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':process.cwd()}}).outputFiles[0].text,mod={exports:{}};new Function('module','exports','require',code)(mod,mod.exports,require);
const count=async(db,where,params=[])=>Number((await db.query(`select count(*) n from private.planner_topic_bank where ${where}`,params)).rows[0].n);
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 for(const n of ['128_planner_topic_bank','132_planner_verified_topics','133_planner_topic_chapters','135_planner_science_humanities_topics','136_planner_physics_writing_topics','141_planner_humanities_topics','143_planner_sociology12_topics','144_planner_sociology11_topics','167_planner_english9_1405_pages','192_planner_topic_super_admin','194_planner_physics_1405_pages','195_planner_math_geometry_1405','196_planner_physics_finer_1405','199_planner_calculus_discrete_1405','203_planner_geometry2_1405','204_planner_sociology_1405'])await db.exec(sql(n));
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 // Pre-audit per-combo counts, and the two deliberately unpaged sociology rows.
 assert.equal(await count(db,`subject='فیزیک ۲' and study_field='mathematics' and preparation_track='konkur'`),102);
 assert.equal(await count(db,`subject='فیزیک ۲' and study_field='experimental_sciences' and preparation_track='konkur'`),91);
 assert.equal(await count(db,`subject='ریاضیات گسسته' and preparation_track='konkur'`),38);
 assert.equal(await count(db,`subject='هندسه ۱' and preparation_track='konkur'`),47);
 assert.equal(await count(db,`subject='هندسه ۳' and preparation_track='konkur'`),44);
 assert.equal(await count(db,`subject='هندسه ۲' and preparation_track='konkur'`),55);
 assert.equal(await count(db,`subject='حسابان ۱' and preparation_track='konkur'`),100);
 assert.equal(await count(db,`subject='حسابان ۲' and preparation_track='konkur'`),70);
 assert.equal(await count(db,`subject='جامعه‌شناسی ۳' and preparation_track='konkur'`),79);
 assert.equal(await count(db,`subject='جامعه‌شناسی ۲' and preparation_track='konkur'`),107);
 assert.equal(await count(db,`subject in ('فیزیک ۲','ریاضیات گسسته','هندسه ۱','هندسه ۳','هندسه ۲','حسابان ۱','حسابان ۲','جامعه‌شناسی ۳','جامعه‌شناسی ۲') and page_start is null`),2);
 await db.exec(migration);
 assert.equal(topics.length,56);
 assert.ok((await db.query(`select 1 from private.planner_seed_installations where seed_key='audit-batch4-1405-v234'`)).rows.length===1);
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
  // Chapter must already exist in the prior bank for that combo.
  assert.ok(before.some(b=>b.study_field===p.field&&b.grade===p.grade&&b.subject===p.subject&&b.chapter===p.chapter),`chapter not previously seeded: ${p.subject} ${p.chapter}`);
 }
 assert.equal(rows,112);
 // Post-audit per-combo counts (هندسه ۱ needs no new row).
 assert.equal(await count(db,`subject='فیزیک ۲' and study_field='mathematics' and preparation_track='konkur'`),105);
 assert.equal(await count(db,`subject='فیزیک ۲' and study_field='experimental_sciences' and preparation_track='konkur'`),95);
 assert.equal(await count(db,`subject='ریاضیات گسسته' and preparation_track='konkur'`),46);
 assert.equal(await count(db,`subject='هندسه ۱' and preparation_track='konkur'`),47);
 assert.equal(await count(db,`subject='هندسه ۳' and preparation_track='konkur'`),45);
 assert.equal(await count(db,`subject='هندسه ۲' and preparation_track='konkur'`),64);
 assert.equal(await count(db,`subject='حسابان ۱' and preparation_track='konkur'`),113);
 assert.equal(await count(db,`subject='حسابان ۲' and preparation_track='konkur'`),77);
 assert.equal(await count(db,`subject='جامعه‌شناسی ۳' and preparation_track='konkur'`),81);
 assert.equal(await count(db,`subject='جامعه‌شناسی ۲' and preparation_track='konkur'`),116);
 // Catalog chapters for every audited book; the هندسه ۲ catalog chapter 4 is
 // not in the PDF, so it must have no rows (unresolved catalog discrepancy).
 for(const track of ['konkur','final_exam']){
  for(const [field,grade,subj] of [['mathematics','11','فیزیک ۲'],['experimental_sciences','11','فیزیک ۲'],['mathematics','12','ریاضیات گسسته'],['mathematics','10','هندسه ۱'],['mathematics','12','هندسه ۳'],['mathematics','11','هندسه ۲'],['mathematics','11','حسابان ۱'],['mathematics','12','حسابان ۲'],['humanities','12','جامعه‌شناسی ۳'],['humanities','11','جامعه‌شناسی ۲']]){
   const book=mod.exports.curriculumBooks(field,Number(grade),track).find(x=>x.subject===subj);assert.ok(book,`${field} ${grade} ${subj}`);
   for(const p of topics.filter(t=>t.subject===subj&&t.field===field))assert.ok(book.chapters.includes(p.chapter),`${subj} chapter ${p.chapter} not in catalog`);
  }
  const g2=mod.exports.curriculumBooks('mathematics',11,track).find(x=>x.subject==='هندسه ۲');
  assert.deepEqual(g2.chapters,['فصل ۱: دایره','فصل ۲: تبدیل‌های هندسی و کاربردها','فصل ۳: روابط طولی در مثلث','فصل ۴: تجسم فضایی']);
  assert.equal(await count(db,`subject='هندسه ۲' and chapter='فصل ۴: تجسم فضایی'`),0);
 }
 // Spot checks on the audited values.
 for(const [subject,chapter,position,title,start,end] of [
  ['فیزیک ۲','فصل ۱: الکتریسیته ساکن',3000,'توزیع بار در رسانا و آزمایش فاراده',27,28],
  ['فیزیک ۲','فصل ۳: مغناطیس و القای الکترومغناطیسی',3001,'فهرست منابع',108,109],
  ['ریاضیات گسسته','فصل ۱: آشنایی با نظریه اعداد',3000,'تمرین استدلال ریاضی',8,8],
  ['ریاضیات گسسته','فصل ۳: ترکیبیات',3002,'منابع',85,85],
  ['هندسه ۲','فصل ۱: دایره',3000,'وضعیت خط و دایره',10,11],
  ['هندسه ۲','فصل ۲: تبدیل‌های هندسی و کاربردها',3003,'تبدیل همانی',47,49],
  ['هندسه ۳','فصل ۳: بردارها',3000,'منابع',87,87],
  ['حسابان ۱','فصل ۳: توابع نمایی و لگاریتمی',3000,'شرح: تابع نمایی',72,76],
  ['حسابان ۱','فصل ۳: توابع نمایی و لگاریتمی',3004,'تمرین ویژگی‌های لگاریتم و حل معادله‌های لگاریتمی',90,90],
  ['حسابان ۲','فصل ۴: مشتق',3001,'تمرین مشتق‌پذیری و پیوستگی',99,101],
  ['حسابان ۲','فصل ۵: کاربردهای مشتق',3003,'منابع',145,145],
  ['جامعه‌شناسی ۳','درس ۱',3000,'اهداف کتاب',1,1],
  ['جامعه‌شناسی ۲','درس ۱۳',3000,'آغاز فصل چهارم: بیداری اسلامی',105,105],
  ['جامعه‌شناسی ۲','درس ۱۵',3000,'منابع',137,138]]){
  const t=topics.find(t=>t.subject===subject&&t.chapter===chapter&&t.position===position);
  assert.ok(t);assert.deepEqual([t.title,t.start,t.end],[title,start,end]);
 }
 // The superseded old rows are untouched (original pages, revision 1).
 for(const [field,subject,chapter,position,title,start,end] of [
  ['mathematics','فیزیک ۲','فصل ۱: الکتریسیته ساکن',505,'توزیع بار در رسانا و آزمایش فاراده',27,27],
  ['experimental_sciences','فیزیک ۲','فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم',502,'ترمیستور و مقاومت نوری',48,48],
  ['experimental_sciences','فیزیک ۲','فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم',505,'بستن متوالی مقاومت‌ها',56,56],
  ['mathematics','هندسه ۲','فصل ۱: دایره',451,'وضعیت خط و دایره',11,11],
  ['mathematics','هندسه ۲','فصل ۱: دایره',452,'وتر، قطر، زاویه مرکزی و محاطی و کمان',12,12],
  ['mathematics','هندسه ۲','فصل ۱: دایره',455,'اندازه زاویه ظلی',15,15],
  ['mathematics','هندسه ۲','فصل ۱: دایره',464,'چهارضلعی محیطی',28,28],
  ['mathematics','هندسه ۲','فصل ۲: تبدیل‌های هندسی و کاربردها',453,'بازتاب و نقطه ثابت',36,38],
  ['mathematics','هندسه ۲','فصل ۲: تبدیل‌های هندسی و کاربردها',454,'انتقال با بردار',39,39],
  ['mathematics','هندسه ۲','فصل ۲: تبدیل‌های هندسی و کاربردها',456,'تجانس و نسبت تجانس',44,45],
  ['mathematics','هندسه ۲','فصل ۲: تبدیل‌های هندسی و کاربردها',459,'تبدیل همانی',48,49]]){
  const r=(await db.query('select title,page_start,page_end,revision from private.planner_topic_bank where subject=$1 and chapter=$2 and position=$3 and study_field=$4 and preparation_track=$5',[subject,chapter,position,field,'final_exam'])).rows;
  assert.deepEqual(r,[{title,page_start:start,page_end:end,revision:1}],`superseded old row changed: ${subject} ${chapter} pos ${position}`);
 }
 // The two deliberately unpaged جامعه‌شناسی ۲ درس ۱۵ rows stay NULL, revision 1.
 const soc=(await db.query(`select preparation_track,page_start,page_end,revision from private.planner_topic_bank where subject='جامعه‌شناسی ۲' and chapter='درس ۱۵' and position=1 order by preparation_track`)).rows;
 assert.deepEqual(soc,[{preparation_track:'final_exam',page_start:null,page_end:null,revision:1},{preparation_track:'konkur',page_start:null,page_end:null,revision:1}]);
 // No prior row changed: the pre-migration bank is intact apart from the 112 new rows.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const newIds=new Set(after.filter(a=>!before.some(b=>b.id===a.id)).map(a=>a.id));
 assert.equal(newIds.size,112);
 assert.deepEqual(after.filter(a=>!newIds.has(a.id)),before);
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit via planner_save_topic and delete of new rows survive a re-run.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='ریاضیات گسسته' and chapter='فصل ۲: گراف و مدل‌سازی' and position=3000 and preparation_track='final_exam'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','12','final_exam','ریاضیات گسسته','فصل ۲: گراف و مدل‌سازی','ویرایش مدیر',41,42,3000)",[edit.id,edit.r]);
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='جامعه‌شناسی ۲' and chapter='درس ۱۵' and position=3000 and preparation_track='final_exam'")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Batch 4 audit: 56 topics / 112 rows across 10 books (هندسه ۱ needs none); superseded old rows untouched, sociology درس ۱۵ rows stay NULL, هندسه ۲ catalog فصل ۴ has no rows, rerun/edit/delete protection holds');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
