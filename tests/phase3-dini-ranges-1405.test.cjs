const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}`,'utf8');
const migration=sql('247_planner_phase3_dini_ranges_1405.sql');
const fixes=JSON.parse(migration.split('$fixes$')[1]);
const topics=JSON.parse(migration.split('$topics$')[1]);
// Old -> new printed pages for the 12 v155 دین و زندگی ۲ «کل درس» rows (position 101),
// verified against the چاپ ۱۴۰۵ PDF (111204, printed = PDF page).
const expectedOld={};
for(const f of fixes)expectedOld[f.chapter]=[f.old_start,f.old_end,f.old_revision];
const expectedNew={};
for(const f of fixes)expectedNew[f.chapter]=[f.start,f.end];
// Printed-page ceilings per book.
const maxPage={'تعلیمات دینی ۲':158,'تعلیمات دینی ۳':136};
// Pre-migration row counts per (subject, field, grade, track) after migrations 128-246
// (82 v155/v1/v156 rows + 19 v240 rows for دین و زندگی ۲; 52 + 17 for دین و زندگی ۳).
const beforeCounts={
 'تعلیمات دینی ۲|mathematics|11|final_exam':101,
 'تعلیمات دینی ۲|experimental_sciences|11|final_exam':101,
 'تعلیمات دینی ۳|mathematics|12|final_exam':69,
 'تعلیمات دینی ۳|experimental_sciences|12|final_exam':69};
// The humanities دین و زندگی books (111205/112205) are separate books and must be untouched.
const humanitiesDiniCounts={
 'تعلیمات دینی ۲|humanities|11|final_exam':295,
 'تعلیمات دینی ۳|humanities|12|final_exam':225};
const ALL=fs.readdirSync('supabase/migrations').filter(f=>{const n=parseInt(f.split('_')[0],10);return n>=128&&n<=246}).sort((a,b)=>parseInt(a.split('_')[0],10)-parseInt(b.split('_')[0],10));
const SETUP=`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`;
const strip=r=>{const c={...r};delete c.page_start;delete c.page_end;delete c.revision;delete c.updated_at;return c};
async function applyChain(db){for(const f of ALL)await db.exec(sql(f))}
async function counts(db,map){for(const [key,count] of Object.entries(map)){const [subject,field,grade,track]=key.split('|');
 const c=(await db.query('select count(*) c from private.planner_topic_bank where subject=$1 and study_field=$2 and grade=$3 and preparation_track=$4',[subject,field,grade,track])).rows[0].c;
 assert.equal(Number(c),count,`count ${key}`)}}
(async()=>{const db=new PGlite();try{
 await db.exec(SETUP);
 assert.equal(ALL.length,119,'migrations 128-246 must be exactly 119 files on disk');
 await applyChain(db);
 await counts(db,{...beforeCounts,...humanitiesDiniCounts});
 // Pre-state: the 12 v155 «کل درس» rows per field carry exactly the old pages/revisions.
 assert.equal(fixes.length,12);
 for(const field of ['mathematics','experimental_sciences']){
  for(const f of fixes){
   const r=(await db.query("select page_start,page_end,revision from private.planner_topic_bank where subject='تعلیمات دینی ۲' and study_field=$1 and grade='11' and preparation_track='final_exam' and chapter=$2 and title='کل درس' and position=101",[field,f.chapter])).rows;
   assert.deepEqual(r,[{page_start:f.old_start,page_end:f.old_end,revision:f.old_revision}],`pre کل درس ${field} ${f.chapter}`);
  }
 }
 // No prior row for these subjects uses a position >= 3100, so the new positions cannot collide.
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject in ('تعلیمات دینی ۲','تعلیمات دینی ۳') and position>=3100")).rows[0].c,0,'no prior positions >=3100');
 // No NULL-page rows for these combos (the 155/161/163 fills already applied).
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject in ('تعلیمات دینی ۲','تعلیمات دینی ۳') and study_field in ('mathematics','experimental_sciences') and page_start is null")).rows[0].c,0,'no NULL-page rows pre-migration');
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.equal(topics.length,430,'430 مطالعه topics in the migration');
 // Every corrected کل درس row: same id, new pages, revision bumped by exactly 1.
 for(const field of ['mathematics','experimental_sciences']){
  for(const f of fixes){
   const r=(await db.query("select page_start,page_end,revision from private.planner_topic_bank where subject='تعلیمات دینی ۲' and study_field=$1 and grade='11' and preparation_track='final_exam' and chapter=$2 and title='کل درس' and position=101",[field,f.chapter])).rows;
   assert.deepEqual(r,[{page_start:f.start,page_end:f.end,revision:f.old_revision+1}],`corrected کل درس ${field} ${f.chapter}`);
  }
 }
 // Every مطالعه row lands with exact single pages inside the book, revision 1.
 let rows=0;
 for(const p of topics){
  assert.ok(p.start>=1&&p.end===p.start&&p.end<=maxPage[p.subject],`${p.subject} ${p.chapter} ${p.title} pages out of range`);
  assert.equal(p.position,3100+p.start,`position must be 3100+page for ${p.subject} ${p.chapter} ${p.title}`);
  const r=(await db.query('select title,page_start,page_end,revision from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',['1405',p.field,p.grade,'final_exam',p.subject,p.chapter,p.position])).rows;
  assert.deepEqual(r,[{title:p.title,page_start:p.start,page_end:p.end,revision:1}],`${p.subject} ${p.chapter} pos ${p.position}`);
  rows++;
  const k=(await db.query('select count(*) c from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',['1405',p.field,p.grade,'konkur',p.subject,p.chapter,p.position])).rows[0].c;
  assert.equal(Number(k),0,`${p.subject} ${p.title} must not exist in konkur`);
 }
 assert.equal(rows,430);
 // Spot checks on the audited values.
 for(const [subject,chapter,position,title,start,end] of [
  ['تعلیمات دینی ۲','درس ۱: هدایت الهی',3112,'مطالعه صفحه ۱۲',12,12],
  ['تعلیمات دینی ۲','درس ۳: معجزه جاویدان',3144,'مطالعه صفحه ۴۴',44,44],
  ['تعلیمات دینی ۲','درس ۱۲: پیوند مقدس',3258,'مطالعه صفحه ۱۵۸',158,158],
  ['تعلیمات دینی ۳','درس ۱',3106,'مطالعه صفحه ۶',6,6],
  ['تعلیمات دینی ۳','درس ۹',3222,'مطالعه صفحه ۱۲۲',122,122],
  ['تعلیمات دینی ۳','درس ۱۰',3236,'مطالعه صفحه ۱۳۶',136,136]]){
  const t=topics.find(t=>t.subject===subject&&t.chapter===chapter&&t.position===position);
  assert.ok(t,`${subject} ${chapter} pos ${position} missing from migration`);
  assert.deepEqual([t.title,t.start,t.end],[title,start,end]);
 }
 // Post-migration counts: دین و زندگی ۲ grows by 113 per field, دین و زندگی ۳ by 102.
 await counts(db,{
  'تعلیمات دینی ۲|mathematics|11|final_exam':214,
  'تعلیمات دینی ۲|experimental_sciences|11|final_exam':214,
  'تعلیمات دینی ۳|mathematics|12|final_exam':171,
  'تعلیمات دینی ۳|experimental_sciences|12|final_exam':171,
  ...humanitiesDiniCounts});
 // The humanities دین و زندگی books gain no row at all (different books).
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject in ('تعلیمات دینی ۲','تعلیمات دینی ۳') and study_field='humanities' and position>=3100")).rows[0].c,0,'no new rows in the humanities dini books');
 // The دین و زندگی ۳ (ریاضی/تجربی) «کل درس» starts are deliberately NOT changed (title page).
 for(const [chapter,start,end] of [['درس ۱',6,14],['درس ۲',18,26],['درس ۳',30,38],['درس ۴',42,48],['درس ۵',52,60],['درس ۶',64,74],['درس ۷',80,90],['درس ۸',94,104],['درس ۹',108,122],['درس ۱۰',126,136]]){
  const r=(await db.query("select page_start,page_end from private.planner_topic_bank where subject='تعلیمات دینی ۳' and study_field='mathematics' and grade='12' and preparation_track='final_exam' and chapter=$1 and title like 'کل درس%' and position=1",[chapter])).rows;
  assert.deepEqual(r,[{page_start:start,page_end:end}],`dini3 کل درس unchanged ${chapter}`);
 }
 // Bank delta is exactly the 430 new rows plus the 24 corrected کل درس rows; nothing else changed.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const newIds=new Set(after.filter(a=>!before.some(b=>b.id===a.id)).map(a=>a.id));
 assert.equal(newIds.size,430);
 const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
 assert.equal(changed.length,24,`exactly the 24 کل درس rows change, got ${changed.length}`);
 for(const c of changed){
  assert.equal(c.title,'کل درس');assert.equal(c.position,101);assert.equal(c.subject,'تعلیمات دینی ۲');
  assert.deepEqual([c.page_start,c.page_end],expectedNew[c.chapter]);
  const b=before.find(x=>x.id===c.id);
  assert.equal(c.revision,b.revision+1);
  assert.deepEqual(strip(c),strip(b),'only pages/revision/updated_at may differ on a corrected row');
 }
 assert.deepEqual(after.filter(a=>!newIds.has(a.id)&&!changed.some(c=>c.id===a.id)),before.filter(b=>!changed.some(c=>c.id===b.id)));
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit (one corrected کل درس row + one new مطالعه row)
 // and delete (one new مطالعه row + one corrected کل درس row) survive a re-run.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const editKl=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='تعلیمات دینی ۲' and chapter='درس ۱: هدایت الهی' and position=101 and study_field='mathematics' and preparation_track='final_exam'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','11','final_exam','تعلیمات دینی ۲','درس ۱: هدایت الهی','ویرایش مدیر',10,18,101)",[editKl.id,editKl.r]);
 const editMt=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='تعلیمات دینی ۳' and chapter='درس ۱' and position=3106 and study_field='mathematics'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','12','final_exam','تعلیمات دینی ۳','درس ۱','ویرایش مدیر',6,6,3106)",[editMt.id,editMt.r]);
 const delMt=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='تعلیمات دینی ۲' and chapter='درس ۱۲: پیوند مقدس' and position=3258 and study_field='experimental_sciences'")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[delMt.id,delMt.r]);
 const delKl=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='تعلیمات دینی ۲' and chapter='درس ۵: امامت، تداوم رسالت' and position=101 and study_field='experimental_sciences'")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[delKl.id,delKl.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Phase 3 item 4: 24 دین و زندگی ۲ کل درس rows corrected (قرائت-to-last-content) + 430 مطالعهٔ صفحه rows (226 دین و زندگی ۲ + 204 دین و زندگی ۳); humanities books untouched; دین و زندگی ۳ کل درس starts unchanged; edits/deletions/rerun and simulated snapshot');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});

// Second database: a pre-migration admin edit / delete must block the guarded fix.
(async()=>{const db=new PGlite();try{
 await db.exec(SETUP);
 await applyChain(db);
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 // Admin edits درس ۵'s کل درس (mathematics) before 247 runs: guard must skip it.
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='تعلیمات دینی ۲' and chapter='درس ۵: امامت، تداوم رسالت' and position=101 and study_field='mathematics'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','11','final_exam','تعلیمات دینی ۲','درس ۵: امامت، تداوم رسالت','ویرایش مدیر پیشین',62,73,101)",[edit.id,edit.r]);
 // Admin deletes درس ۶'s کل درس (experimental_sciences) before 247 runs: never resurrected.
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='تعلیمات دینی ۲' and chapter='درس ۶: پیشوایان اسوه' and position=101 and study_field='experimental_sciences'")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 await db.exec(migration);
 const kept=(await db.query("select title,page_start,page_end,revision from private.planner_topic_bank where subject='تعلیمات دینی ۲' and chapter='درس ۵: امامت، تداوم رسالت' and position=101 and study_field='mathematics'")).rows;
 assert.deepEqual(kept,[{title:'ویرایش مدیر پیشین',page_start:62,page_end:73,revision:2}],'pre-migration admin edit must survive 247 untouched');
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject='تعلیمات دینی ۲' and chapter='درس ۶: پیشوایان اسوه' and position=101 and study_field='experimental_sciences'")).rows[0].c,0,'pre-migration admin delete must not be resurrected');
 // The other 22 کل درس rows are still corrected.
 let corrected=0;
 for(const field of ['mathematics','experimental_sciences']){
  for(const f of fixes){
   if(field==='mathematics'&&f.chapter==='درس ۵: امامت، تداوم رسالت')continue;
   if(field==='experimental_sciences'&&f.chapter==='درس ۶: پیشوایان اسوه')continue;
   const r=(await db.query("select page_start,page_end,revision from private.planner_topic_bank where subject='تعلیمات دینی ۲' and study_field=$1 and grade='11' and preparation_track='final_exam' and chapter=$2 and title='کل درس' and position=101",[field,f.chapter])).rows;
   assert.deepEqual(r,[{page_start:f.start,page_end:f.end,revision:f.old_revision+1}],`guard-db corrected ${field} ${f.chapter}`);
   corrected++;
  }
 }
 assert.equal(corrected,22);
 // All 430 مطالعه rows still land.
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject in ('تعلیمات دینی ۲','تعلیمات دینی ۳') and position>=3100")).rows[0].c,430,'guard-db مطالعه rows');
 console.log('PASS: guard check: pre-migration admin edit survives, pre-migration admin delete is not resurrected, other 22 کل درس rows corrected');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
