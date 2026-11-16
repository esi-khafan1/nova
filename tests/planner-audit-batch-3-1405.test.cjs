const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('233_planner_audit_batch3_1405'),topics=JSON.parse(migration.split('$topics$')[1]);
// Printed-page ceiling per book (PDF pages minus the PDF->printed offset).
const maxPage={'فلسفه ۲|humanities':114,'فرهنگ و هنر|all':186,'فارسی ۱|mathematics':168,'فارسی ۱|humanities':168,'فارسی ۱|experimental_sciences':168,'فارسی ۲|mathematics':168,'فارسی ۲|humanities':168,'فارسی ۲|experimental_sciences':168,'فارسی|all':160,'فیزیک ۱|mathematics':152,'فیزیک ۱|experimental_sciences':126,'فیزیک ۳|mathematics':166,'فیزیک ۳|experimental_sciences':134};
const code=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':process.cwd()}}).outputFiles[0].text,mod={exports:{}};new Function('module','exports','require',code)(mod,mod.exports,require);
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 for(const n of ['128_planner_topic_bank','133_planner_topic_chapters','167_planner_english9_1405_pages','181_planner_philosophy11_12_1405_pages','190_planner_persian11_12_1405_pages','192_planner_topic_super_admin','194_planner_physics_1405_pages','196_planner_physics_finer_1405','210_planner_persian10_1405','216_planner_philosophy12_finer_1405','219_planner_culture_art9_1405','224_planner_persian9_1405'])await db.exec(sql(n));
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.equal(topics.length,35);
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
  // Chapter must already exist in the prior bank for that combo, or be a catalog chapter.
  assert.ok(before.some(b=>b.study_field===p.field&&b.grade===p.grade&&b.subject===p.subject&&b.chapter===p.chapter),`chapter not previously seeded: ${p.subject} ${p.chapter}`);
 }
 assert.equal(rows,52);
 // Catalog chapters for philosophy and physics.
 for(const track of ['konkur','final_exam']){
  const phil=mod.exports.curriculumBooks('humanities',12,track).find(x=>x.subject==='فلسفه ۲');assert.ok(phil);
  for(const p of topics.filter(t=>t.subject==='فلسفه ۲'))assert.ok(phil.chapters.includes(p.chapter));
  for(const [field,grade,subj] of [['mathematics','10','فیزیک ۱'],['experimental_sciences','10','فیزیک ۱'],['mathematics','12','فیزیک ۳'],['experimental_sciences','12','فیزیک ۳']]){
   const book=mod.exports.curriculumBooks(field,Number(grade),track).find(x=>x.subject===subj);assert.ok(book,`${field} ${grade} ${subj}`);
   for(const p of topics.filter(t=>t.subject===subj&&t.field===field))assert.ok(book.chapters.includes(p.chapter));
  }
 }
 // Spot checks on the audited values.
 for(const [subject,chapter,position,title,start,end] of [
  ['فلسفه ۲','درس ۹',3000,'مقدمه بخش سوم: نگاهی اجمالی به سیر فلسفه در جهان اسلام',69,69],
  ['فلسفه ۲','درس ۶',3000,'مطالعه بیشتر: منابع درس ششم',51,51],
  ['فرهنگ و هنر','خوشنویسی ـ درس ۱: تراشیدن قلم و قالب‌های اجرایی خوشنویسی',3000,'مقدمه خوشنویسی',73,73],
  ['فارسی ۱','فصل ۸: ادبیات جهان',3000,'کتابنامه',164,168],
  ['فارسی ۲','فصل ۸: ادبیات جهان',3000,'کتابنامه',167,168],
  ['فارسی','پیوست‌های کتاب',3000,'کتابنامه',158,160],
  ['فیزیک ۳','فصل ۶: آشنایی با فیزیک هسته‌ای',3000,'جدول دوره‌ای عناصر',157,157],
  ['فیزیک ۳','فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای',3003,'فهرست منابع',132,133]]){
  const t=topics.find(t=>t.subject===subject&&t.chapter===chapter&&t.position===position);
  assert.ok(t);assert.deepEqual([t.title,t.start,t.end],[title,start,end]);
 }
 // The superseded Persian 11 ketabnameh row (migration 190, 167-167) is untouched.
 const old11=(await db.query("select title,page_start,page_end,revision from private.planner_topic_bank where subject='فارسی ۲' and chapter='فصل ۸: ادبیات جهان' and position=314 and study_field='mathematics' and preparation_track='final_exam'")).rows;
 assert.deepEqual(old11,[{title:'کتابنامه',page_start:167,page_end:167,revision:1}]);
 // No prior row changed: the pre-migration bank is intact apart from the 51 new rows.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const newIds=new Set(after.filter(a=>!before.some(b=>b.id===a.id)).map(a=>a.id));
 assert.equal(newIds.size,52);
 assert.deepEqual(after.filter(a=>!newIds.has(a.id)),before);
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit via planner_save_topic and delete of new rows survive a re-run.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='فلسفه ۲' and chapter='درس ۹' and position=3000 and preparation_track='final_exam'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','humanities','12','final_exam','فلسفه ۲','درس ۹','ویرایش مدیر',69,69,3000)",[edit.id,edit.r]);
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='فرهنگ و هنر' and position=3000 and chapter like 'هنرهای آوایی%'")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Batch 3 audit: 35 topics / 52 rows across 9 books (Persian 12 needs none); prior rows, superseded ketabnameh, edits/deletions/rerun and simulated snapshot');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
