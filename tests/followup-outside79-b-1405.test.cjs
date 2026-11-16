const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}`,'utf8');
const migration=sql('240_planner_followup_outside79_b_1405.sql'),topics=JSON.parse(migration.split('$topics$')[1]);
// Printed-page ceiling per book (last printed page).
const maxPage={'تاریخ ۲':206,'تاریخ معاصر ایران':263,'تعلیمات دینی ۲':158,'تعلیمات دینی ۳':136};
// Pre-migration row counts per (subject, field, grade, track), from the audited seed dump (migrations 128-239).
const beforeCounts={
 'تاریخ ۲|humanities|11|final_exam':251,
 'تاریخ ۲|humanities|11|konkur':251,
 'تاریخ معاصر ایران|mathematics|11|final_exam':250,
 'تاریخ معاصر ایران|experimental_sciences|11|final_exam':250,
 'تعلیمات دینی ۲|mathematics|11|final_exam':82,
 'تعلیمات دینی ۲|experimental_sciences|11|final_exam':82,
 'تعلیمات دینی ۳|mathematics|12|final_exam':52,
 'تعلیمات دینی ۳|experimental_sciences|12|final_exam':52};
// The humanities دین و زندگی books (111205/112205) are separate books and must be untouched.
const humanitiesDiniCounts={
 'تعلیمات دینی ۲|humanities|11|final_exam':295,
 'تعلیمات دینی ۳|humanities|12|final_exam':225};
const ALL=fs.readdirSync('supabase/migrations').filter(f=>{const n=parseInt(f.split('_')[0],10);return n>=128&&n<=239}).sort((a,b)=>parseInt(a.split('_')[0],10)-parseInt(b.split('_')[0],10));
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 assert.equal(ALL.length,112,'migrations 128-239 must be exactly 112 files on disk');
 for(const f of ALL)await db.exec(sql(f));
 // Pre-migration state: exact per-combo row counts, and zero NULL-page rows
 // for these four books' combos (so no pattern-B page-fill applies).
 for(const [key,count] of Object.entries({...beforeCounts,...humanitiesDiniCounts})){
  const [subject,field,grade,track]=key.split('|');
  const c=(await db.query('select count(*) c from private.planner_topic_bank where subject=$1 and study_field=$2 and grade=$3 and preparation_track=$4',[subject,field,grade,track])).rows[0].c;
  assert.equal(Number(c),count,`pre-count ${key}`);
 }
 const nullPre=(await db.query("select subject,study_field,chapter,position,revision from private.planner_topic_bank where subject in ('تاریخ ۲','تاریخ معاصر ایران','تعلیمات دینی ۲','تعلیمات دینی ۳') and page_start is null order by subject,study_field")).rows;
 assert.deepEqual(nullPre,[],'pre-migration NULL-page rows for the four books must be none');
 // No positions >=3000 anywhere for these subjects yet, so the new positions cannot collide.
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject in ('تاریخ ۲','تاریخ معاصر ایران','تعلیمات دینی ۲','تعلیمات دینی ۳') and position>=3000")).rows[0].c,0,'no prior positions >=3000');
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.equal(topics.length,85);
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
  // Chapter must already exist in the prior bank for that combo, except the
  // new «مرور» chapter for تاریخ معاصر ایران, which is a deliberate new chapter.
  if(p.chapter!=='مرور'){
   assert.ok(before.some(b=>b.study_field===p.field&&b.grade===p.grade&&b.subject===p.subject&&b.chapter===p.chapter),`chapter not previously seeded: ${p.subject} ${p.chapter}`);
  }
 }
 assert.equal(rows,90);
 // Spot checks on the audited values.
 for(const [subject,chapter,position,title,start,end] of [
  ['تاریخ ۲','درس ۱',3000,'آغاز فصل اول: تاریخ‌شناسی',1,1],
  ['تاریخ ۲','درس ۳',3000,'آغاز فصل دوم: ظهور اسلام، حرکتی تازه در تاریخ بشر',19,19],
  ['تاریخ ۲','درس ۸',3000,'آغاز فصل سوم: ایران؛ از ورود اسلام تا پایان صفویه',83,83],
  ['تاریخ ۲','درس ۱۵',3000,'آغاز فصل چهارم: اروپا در قرون وسطا و عصر جدید',173,173],
  ['تاریخ ۲','درس ۱۶',3000,'منابع و مآخذ',202,205],
  ['تاریخ معاصر ایران','مرور',3000,'ایران پیش از اسلام',1,7],
  ['تاریخ معاصر ایران','مرور',3001,'ایران بعد از اسلام',8,9],
  ['تاریخ معاصر ایران','مرور',3002,'ایران از دوران غزنویان تا خوارزمشاهیان و هجوم مغول',10,12],
  ['تاریخ معاصر ایران','مرور',3003,'ایران در عصر صفویه',13,16],
  ['تعلیمات دینی ۲','درس ۱: هدایت الهی',3000,'آیات و ترجمه آغاز درس',10,11],
  ['تعلیمات دینی ۲','درس ۱: هدایت الهی',3001,'اندیشه و تحقیق',18,18],
  ['تعلیمات دینی ۲','درس ۱۲: پیوند مقدس',3000,'آیات و ترجمه آغاز درس',146,147],
  ['تعلیمات دینی ۳','درس ۱',3000,'آیات و ترجمه آغاز درس',4,5],
  ['تعلیمات دینی ۳','درس ۳',3002,'تحلیل و بررسی',37,37],
  ['تعلیمات دینی ۳','درس ۹',3001,'برداشت (۱)',117,120],
  ['تعلیمات دینی ۳','درس ۹',3002,'برداشت (۲)',121,121],
  ['تعلیمات دینی ۳','درس ۹',3003,'هم‌اندیشی',122,122]]){
  const t=topics.find(t=>t.subject===subject&&t.chapter===chapter&&t.position===position);
  assert.ok(t,`${subject} ${chapter} pos ${position} missing from migration`);
  assert.deepEqual([t.title,t.start,t.end],[title,start,end]);
 }
 // Post-migration counts: every combo grows by exactly the new topics for that combo.
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
 // The humanities دین و زندگی books gain no row at all (different books).
 for(const [key,count] of Object.entries(humanitiesDiniCounts)){
  const [subject,field,grade,track]=key.split('|');
  const c=(await db.query('select count(*) c from private.planner_topic_bank where subject=$1 and study_field=$2 and grade=$3 and preparation_track=$4',[subject,field,grade,track])).rows[0].c;
  assert.equal(Number(c),count,`humanities dini unchanged ${key}`);
 }
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject in ('تعلیمات دینی ۲','تعلیمات دینی ۳') and study_field='humanities' and position>=3000")).rows[0].c,0,'no new rows in the humanities dini books');
 // No rows for unsupported combos: تاریخ ۲ only humanities; تاریخ معاصر and
 // تعلیمات دینی ۲/۳ have no konkur rows at all.
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject='تاریخ ۲' and study_field<>'humanities'")).rows[0].c,0,'تاریخ ۲ outside humanities');
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject='تاریخ معاصر ایران' and preparation_track='konkur'")).rows[0].c,0,'تاریخ معاصر in konkur');
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject in ('تعلیمات دینی ۲','تعلیمات دینی ۳') and preparation_track='konkur'")).rows[0].c,0,'تعلیمات دینی in konkur');
 // The مرور chapter exists only for تاریخ معاصر ایران, math/exp, final_exam.
 assert.deepEqual((await db.query("select study_field,grade,preparation_track,count(*) c from private.planner_topic_bank where subject='تاریخ معاصر ایران' and chapter='مرور' group by 1,2,3 order by 1")).rows,
  [{study_field:'experimental_sciences',grade:'11',preparation_track:'final_exam',c:4},{study_field:'mathematics',grade:'11',preparation_track:'final_exam',c:4}],'مرور chapter combos');
 // Bank delta is exactly the 90 new rows; nothing else changed.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const newIds=new Set(after.filter(a=>!before.some(b=>b.id===a.id)).map(a=>a.id));
 assert.equal(newIds.size,90);
 const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
 assert.equal(changed.length,0);
 assert.deepEqual(after.filter(a=>!newIds.has(a.id)),before);
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit via planner_save_topic and delete of new rows survive a re-run.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='تعلیمات دینی ۲' and chapter='درس ۱: هدایت الهی' and position=3000 and study_field='mathematics' and preparation_track='final_exam'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','11','final_exam','تعلیمات دینی ۲','درس ۱: هدایت الهی','ویرایش مدیر',10,11,3000)",[edit.id,edit.r]);
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='تاریخ معاصر ایران' and chapter='مرور' and position=3000 and study_field='mathematics'")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Follow-up 5B audit: 45 topics / 90 rows (تاریخ ۲ چهار آغاز فصل + منابع و مآخذ؛ تاریخ معاصر مرور ۴ بخش؛ دین و زندگی ۲/۳ آیات و ترجمه آغاز درس + اندیشه و تحقیق + تحلیل و بررسی/برداشت/هم‌اندیشی) across 4 books; prior counts, zero NULL-page rows, humanities-dini guard, edits/deletions/rerun and simulated snapshot');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
