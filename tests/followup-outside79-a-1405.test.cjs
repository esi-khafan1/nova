const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}`,'utf8');
const migration=sql('239_planner_followup_outside79_a_1405.sql'),topics=JSON.parse(migration.split('$topics$')[1]);
// Printed-page ceiling per book (last printed page).
const maxPage={'کارگاه کارآفرینی و تولید':128,'آمادگی دفاعی':160,'علوم اجتماعی':93,'زمین‌شناسی':127,'تاریخ ۱':157};
// Pre-migration row counts per (subject, field, grade, track), from the audited seed dump (migrations 128-238).
const beforeCounts={
 'کارگاه کارآفرینی و تولید|mathematics|10|final_exam':118,
 'کارگاه کارآفرینی و تولید|experimental_sciences|10|final_exam':118,
 'کارگاه کارآفرینی و تولید|humanities|10|final_exam':118,
 'آمادگی دفاعی|mathematics|10|final_exam':85,
 'آمادگی دفاعی|experimental_sciences|10|final_exam':85,
 'آمادگی دفاعی|humanities|10|final_exam':85,
 'آمادگی دفاعی|all|9|final_exam':85,
 'علوم اجتماعی|mathematics|12|final_exam':67,
 'علوم اجتماعی|experimental_sciences|12|final_exam':67,
 'زمین‌شناسی|experimental_sciences|11|final_exam':42,
 'زمین‌شناسی|experimental_sciences|11|konkur':42,
 'زمین‌شناسی|mathematics|11|final_exam':42,
 'تاریخ ۱|humanities|10|final_exam':198,
 'تاریخ ۱|humanities|10|konkur':198};
const ALL=fs.readdirSync('supabase/migrations').filter(f=>{const n=parseInt(f.split('_')[0],10);return n>=128&&n<=238}).sort((a,b)=>parseInt(a.split('_')[0],10)-parseInt(b.split('_')[0],10));
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 assert.equal(ALL.length,111,'migrations 128-238 must be exactly 111 files on disk');
 for(const f of ALL)await db.exec(sql(f));
 // Pre-migration state: exact per-combo row counts, and the only NULL-page rows
 // are the three deliberately unpaged آمادگی دفاعی درس ۹ rows (one per field,
 // grade 10, position 3, revision 2 — superseded by position 301, 87-116).
 for(const [key,count] of Object.entries(beforeCounts)){
  const [subject,field,grade,track]=key.split('|');
  const c=(await db.query('select count(*) c from private.planner_topic_bank where subject=$1 and study_field=$2 and grade=$3 and preparation_track=$4',[subject,field,grade,track])).rows[0].c;
  assert.equal(Number(c),count,`pre-count ${key}`);
 }
 const nullPre=(await db.query("select subject,study_field,chapter,position,revision from private.planner_topic_bank where subject in ('کارگاه کارآفرینی و تولید','آمادگی دفاعی','علوم اجتماعی','زمین‌شناسی','تاریخ ۱') and grade<>'9' and page_start is null order by subject,study_field")).rows;
 assert.deepEqual(nullPre,[
  {subject:'آمادگی دفاعی',study_field:'experimental_sciences',chapter:'فصل ۳: دفاع نظامی',position:3,revision:2},
  {subject:'آمادگی دفاعی',study_field:'humanities',chapter:'فصل ۳: دفاع نظامی',position:3,revision:2},
  {subject:'آمادگی دفاعی',study_field:'mathematics',chapter:'فصل ۳: دفاع نظامی',position:3,revision:2}],'pre-migration NULL-page rows');
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.equal(topics.length,16);
 // Every new topic lands with exact pages inside the book, in the right tracks, revision 1.
 let rows=0;
 for(const p of topics){
  assert.ok(p.start>=1&&p.end>=p.start&&p.end<=maxPage[p.subject],`${p.subject} ${p.title} pages out of range`);
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
 assert.equal(rows,21);
 // Spot checks on the audited values.
 for(const [subject,chapter,position,title,start,end] of [
  ['کارگاه کارآفرینی و تولید','بخش‌های ۲۸ تا ۳۲',3000,'منابع و مآخذ',128,128],
  ['آمادگی دفاعی','فصل ۴: دفاع غیرنظامی',3000,'منابع برای مطالعه بیشتر',159,160],
  ['علوم اجتماعی','درس ۱: کنش‌های ما',3000,'اهداف کتاب',1,1],
  ['علوم اجتماعی','درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران',3000,'منابع',92,93],
  ['زمین‌شناسی','فصل ۷: زمین‌شناسی ایران',3000,'منابع',127,127],
  ['تاریخ ۱','درس ۱',3000,'آغاز فصل اول: تاریخ‌شناسی؛ کاوش گذشته',1,1],
  ['تاریخ ۱','درس ۴',3000,'آغاز فصل دوم: جهان در عصر باستان؛ میراث بشری',29,29],
  ['تاریخ ۱','درس ۷',3000,'آغاز فصل سوم: ایران در عصر باستان؛ سرآغاز هویت ایرانی',61,61],
  ['تاریخ ۱','درس ۱۶',3000,'منابع و مآخذ',153,157]]){
  const t=topics.find(t=>t.subject===subject&&t.chapter===chapter&&t.position===position);
  assert.ok(t);assert.deepEqual([t.title,t.start,t.end],[title,start,end]);
 }
 // Post-migration counts: every combo grows by exactly one row per new topic.
 const afterCounts={...beforeCounts};
 for(const p of topics){
  const tracks=p.konkur?['konkur','final_exam']:['final_exam'];
  for(const track of tracks)afterCounts[`${p.subject}|${p.field}|${p.grade}|${track}`]+=1;
 }
 for(const [key,count] of Object.entries(afterCounts)){
  const [subject,field,grade,track]=key.split('|');
  const c=(await db.query('select count(*) c from private.planner_topic_bank where subject=$1 and study_field=$2 and grade=$3 and preparation_track=$4',[subject,field,grade,track])).rows[0].c;
  assert.equal(Number(c),count,`post-count ${key}`);
 }
 // The grade-9 آمادگی دفاعی book is untouched: still 85 rows, no position-3000 row.
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject='آمادگی دفاعی' and grade='9' and position=3000")).rows[0].c,0,'grade-9 defence must gain no row');
 // Bank delta is exactly the 21 new rows; nothing else changed — in particular the
 // three NULL-page درس ۹ rows stay NULL and unrevised.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const newIds=new Set(after.filter(a=>!before.some(b=>b.id===a.id)).map(a=>a.id));
 assert.equal(newIds.size,21);
 const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
 assert.equal(changed.length,0);
 assert.deepEqual(after.filter(a=>!newIds.has(a.id)),before);
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit via planner_save_topic and delete of new rows survive a re-run.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='تاریخ ۱' and chapter='درس ۴' and position=3000 and study_field='humanities' and preparation_track='final_exam'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','humanities','10','final_exam','تاریخ ۱','درس ۴','ویرایش مدیر',29,29,3000)",[edit.id,edit.r]);
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='علوم اجتماعی' and position=3000 and study_field='mathematics' and chapter='درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران'")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Follow-up 5A audit: 9 topics / 21 rows (کارآفرینی منابع و مآخذ, دفاعی منابع, هویت اهداف کتاب + منابع, زمین‌شناسی منابع, تاریخ ۱ سه آغاز فصل + منابع و مآخذ) across 5 books; prior counts, NULL-page guard, edits/deletions/rerun and simulated snapshot');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
