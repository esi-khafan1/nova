const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('238_planner_audit_batch8_1405'),topics=JSON.parse(migration.split('$topics$')[1]);
// Printed-page ceiling per book (last printed page of the book, incl. back matter).
const maxPage={'زیست‌شناسی ۱|experimental_sciences':114,'زیست‌شناسی ۲|experimental_sciences':160,'زیست‌شناسی ۳|experimental_sciences':128,'شیمی ۲|mathematics':128,'شیمی ۲|experimental_sciences':128,'تفکر و سواد رسانه‌ای|mathematics':176,'تفکر و سواد رسانه‌ای|experimental_sciences':176,'تفکر و سواد رسانه‌ای|humanities':176};
// Pre-migration row counts per (subject, field, grade, track), from the audited seed dump.
const beforeCounts={
 'شیمی ۲|mathematics|11|final_exam':70,'شیمی ۲|mathematics|11|konkur':70,
 'شیمی ۲|experimental_sciences|11|final_exam':70,'شیمی ۲|experimental_sciences|11|konkur':70,
 'تفکر و سواد رسانه‌ای|mathematics|10|final_exam':84,
 'تفکر و سواد رسانه‌ای|experimental_sciences|10|final_exam':84,
 'تفکر و سواد رسانه‌ای|humanities|10|final_exam':84,
 'تاریخ ۳|humanities|12|final_exam':149,'تاریخ ۳|humanities|12|konkur':149,
 'زبان خارجی ۱|mathematics|10|final_exam':175,
 'زبان خارجی ۱|experimental_sciences|10|final_exam':175,
 'زبان خارجی ۱|humanities|10|final_exam':175,
 'زبان خارجی ۲|mathematics|11|final_exam':139,
 'زبان خارجی ۲|experimental_sciences|11|final_exam':139,
 'زبان خارجی ۲|humanities|11|final_exam':139,
 'زبان انگلیسی|all|9|final_exam':82,
 'زیست‌شناسی ۱|experimental_sciences|10|final_exam':113,
 'زیست‌شناسی ۱|experimental_sciences|10|konkur':113,
 'زیست‌شناسی ۲|experimental_sciences|11|final_exam':136,
 'زیست‌شناسی ۲|experimental_sciences|11|konkur':136,
 'زیست‌شناسی ۳|experimental_sciences|12|final_exam':129,
 'زیست‌شناسی ۳|experimental_sciences|12|konkur':129};
const DEPS=['128_planner_topic_bank','131_planner_biology12_1405_topics','132_planner_verified_topics','134_planner_more_textbook_topics','136_planner_physics_writing_topics','137_planner_humanities_school_topics','150_planner_history12_topics','167_planner_english9_1405_pages','169_planner_english_1405_details','177_planner_media_1405_pages','187_planner_chemistry_1405_pages','193_planner_biology_1405_pages','205_planner_history12_1405','227_planner_vision_exercises_1405'];
const code=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':process.cwd()}}).outputFiles[0].text,mod={exports:{}};new Function('module','exports','require',code)(mod,mod.exports,require);
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 for(const n of DEPS)await db.exec(sql(n));
 // Pre-migration state: exact per-combo row counts for all nine books, and zero NULL-page rows.
 for(const [key,count] of Object.entries(beforeCounts)){
  const [subject,field,grade,track]=key.split('|');
  const c=(await db.query('select count(*) c from private.planner_topic_bank where subject=$1 and study_field=$2 and grade=$3 and preparation_track=$4',[subject,field,grade,track])).rows[0].c;
  assert.equal(Number(c),count,`pre-count ${key}`);
 }
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject in ('شیمی ۲','تفکر و سواد رسانه‌ای','تاریخ ۳','زبان خارجی ۱','زبان خارجی ۲','زبان انگلیسی','زیست‌شناسی ۱','زیست‌شناسی ۲','زیست‌شناسی ۳') and page_start is null")).rows[0].c,0,'pre-migration NULL-page rows');
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.equal(topics.length,13);
 // Every new topic lands with exact pages inside the book, in the right tracks, revision 1.
 let rows=0;
 for(const p of topics){
  assert.ok(p.start>=1&&p.end>=p.start&&p.end<=maxPage[p.subject+'|'+p.field],`${p.subject} ${p.title} pages out of range`);
  const tracks=p.konkur?['konkur','final_exam']:['final_exam'];
  for(const track of tracks){
   const r=(await db.query('select title,page_start,page_end,revision from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',['1405',p.field,p.grade,track,p.subject,p.chapter,p.position])).rows;
   assert.deepEqual(r,[{title:p.title,page_start:p.start,page_end:p.end,revision:1}],`${p.subject} ${p.chapter} pos ${p.position} ${track}`);
   rows++;
  }
  if(!p.konkur){
   const k=(await db.query('select count(*) c from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',['1405',p.field,p.grade,'konkur',p.subject,p.chapter,p.position])).rows[0].c;
   assert.equal(Number(k),0,`${p.subject} ${p.title} must not exist in konkur`);
  }
  // Chapter must already exist in the prior bank for that combo.
  assert.ok(before.some(b=>b.study_field===p.field&&b.grade===p.grade&&b.subject===p.subject&&b.chapter===p.chapter),`chapter not previously seeded: ${p.subject} ${p.chapter}`);
 }
 assert.equal(rows,23);
 // Spot checks on the audited values.
 for(const [subject,chapter,position,title,start,end] of [
  ['زیست‌شناسی ۱','فصل ۱: دنیای زنده',3000,'هسته',12,12],
  ['زیست‌شناسی ۱','فصل ۱: دنیای زنده',3001,'ورود مواد به یاخته و خروج از آن',12,14],
  ['زیست‌شناسی ۱','فصل ۱: دنیای زنده',3002,'بافت‌های بدن انسان',15,16],
  ['زیست‌شناسی ۲','فصل ۱: تنظیم عصبی',3000,'مغز',10,10],
  ['زیست‌شناسی ۲','فصل ۷: تولید مثل',3000,'لقاح',108,108],
  ['زیست‌شناسی ۲','فصل ۸: تولید مثل نهاندانگان',3000,'میوه',132,133],
  ['زیست‌شناسی ۳','فصل ۶: از انرژی به ماده',3000,'فتوسنتز در گیاهان C4',87,87],
  ['زیست‌شناسی ۳','فصل ۶: از انرژی به ماده',3001,'فتوسنتز در گیاهان CAM',87,88],
  ['شیمی ۲','فصل ۳: پوشاک، نیازی پایان‌ناپذیر',3000,'جدول دوره‌ای عنصرها',127,127],
  ['تفکر و سواد رسانه‌ای','فصل ۶: رژیم مصرف رسانه‌ای',3000,'بازبینه‌های ارزیابی',169,173]]){
  const t=topics.find(t=>t.subject===subject&&t.chapter===chapter&&t.position===position);
  assert.ok(t);assert.deepEqual([t.title,t.start,t.end],[title,start,end]);
 }
 // Post-migration counts: only the four books with new rows grow, by the exact deltas.
 const afterCounts={...beforeCounts};
 afterCounts['شیمی ۲|mathematics|11|final_exam']=71;
 afterCounts['شیمی ۲|mathematics|11|konkur']=71;
 afterCounts['شیمی ۲|experimental_sciences|11|final_exam']=71;
 afterCounts['شیمی ۲|experimental_sciences|11|konkur']=71;
 afterCounts['زیست‌شناسی ۱|experimental_sciences|10|final_exam']=116;
 afterCounts['زیست‌شناسی ۱|experimental_sciences|10|konkur']=116;
 afterCounts['زیست‌شناسی ۲|experimental_sciences|11|final_exam']=139;
 afterCounts['زیست‌شناسی ۲|experimental_sciences|11|konkur']=139;
 afterCounts['زیست‌شناسی ۳|experimental_sciences|12|final_exam']=131;
 afterCounts['زیست‌شناسی ۳|experimental_sciences|12|konkur']=131;
 afterCounts['تفکر و سواد رسانه‌ای|mathematics|10|final_exam']=85;
 afterCounts['تفکر و سواد رسانه‌ای|experimental_sciences|10|final_exam']=85;
 afterCounts['تفکر و سواد رسانه‌ای|humanities|10|final_exam']=85;
 for(const [key,count] of Object.entries(afterCounts)){
  const [subject,field,grade,track]=key.split('|');
  const c=(await db.query('select count(*) c from private.planner_topic_bank where subject=$1 and study_field=$2 and grade=$3 and preparation_track=$4',[subject,field,grade,track])).rows[0].c;
  assert.equal(Number(c),count,`post-count ${key}`);
 }
 // No NULL-page rows remain for any of the nine books.
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject in ('شیمی ۲','تفکر و سواد رسانه‌ای','تاریخ ۳','زبان خارجی ۱','زبان خارجی ۲','زبان انگلیسی','زیست‌شناسی ۱','زیست‌شناسی ۲','زیست‌شناسی ۳') and page_start is null")).rows[0].c,0,'post-migration NULL-page rows');
 // Catalog: the audited subjects exist for their combos; the new rows' chapters match the catalog.
 for(const track of ['final_exam']){
  const b10=mod.exports.curriculumBooks('experimental_sciences',10,track).find(x=>x.subject==='زیست‌شناسی ۱');assert.ok(b10);
  assert.ok(b10.chapters.includes('فصل ۱: دنیای زنده'));
  const b11=mod.exports.curriculumBooks('experimental_sciences',11,track).find(x=>x.subject==='زیست‌شناسی ۲');assert.ok(b11);
  for(const c of ['فصل ۱: تنظیم عصبی','فصل ۷: تولید مثل','فصل ۸: تولید مثل نهاندانگان'])assert.ok(b11.chapters.includes(c));
  const b12=mod.exports.curriculumBooks('experimental_sciences',12,track).find(x=>x.subject==='زیست‌شناسی ۳');assert.ok(b12);
  assert.ok(b12.chapters.includes('فصل ۶: از انرژی به ماده'));
  for(const field of ['mathematics','experimental_sciences','humanities']){
   assert.ok(mod.exports.curriculumBooks(field,10,track).some(x=>x.subject==='تفکر و سواد رسانه‌ای'),`catalog تفکر ${field}`);
   assert.ok(mod.exports.curriculumBooks(field,10,track).some(x=>x.subject==='زبان خارجی ۱'),`catalog زبان خارجی ۱ ${field}`);
   assert.ok(mod.exports.curriculumBooks(field,11,track).some(x=>x.subject==='زبان خارجی ۲'),`catalog زبان خارجی ۲ ${field}`);
  }
  assert.ok(mod.exports.curriculumBooks('mathematics',11,track).some(x=>x.subject==='شیمی ۲'),'catalog شیمی ۲ ریاضی');
  assert.ok(mod.exports.curriculumBooks('experimental_sciences',11,track).some(x=>x.subject==='شیمی ۲'),'catalog شیمی ۲ تجربی');
  const tar=mod.exports.curriculumBooks('humanities',12,track).find(x=>x.subject==='تاریخ ۳');assert.ok(tar);
  for(let i=1;i<=12;i++)assert.ok(tar.chapters.includes('درس '+i.toLocaleString('fa-IR')));
  assert.ok(mod.exports.curriculumBooks(null,9,track).some(x=>x.subject==='زبان انگلیسی'),'catalog زبان انگلیسی ۹');
 }
 // Bank delta is exactly the 19 new rows; nothing else changed.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const newIds=new Set(after.filter(a=>!before.some(b=>b.id===a.id)).map(a=>a.id));
 assert.equal(newIds.size,23);
 const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
 assert.equal(changed.length,0);
 assert.deepEqual(after.filter(a=>!newIds.has(a.id)),before);
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit via planner_save_topic and delete of new rows survive a re-run.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='زیست‌شناسی ۲' and chapter='فصل ۷: تولید مثل' and position=3000 and study_field='experimental_sciences' and preparation_track='final_exam'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','experimental_sciences','11','final_exam','زیست‌شناسی ۲','فصل ۷: تولید مثل','ویرایش مدیر',108,108,3000)",[edit.id,edit.r]);
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='تفکر و سواد رسانه‌ای' and position=3000 and study_field='humanities'")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Batch 8 audit: 13 topics / 23 rows (زیست ۱ هسته/ورود مواد/بافت‌ها, زیست ۲ مغز/لقاح/میوه, زیست ۳ C4/CAM, شیمی ۲ جدول دوره‌ای عنصرها, تفکر بازبینه‌های ارزیابی) across 9 books; prior counts, no NULL pages, edits/deletions/rerun and simulated snapshot');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
