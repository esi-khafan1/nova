const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('236_planner_audit_batch6_1405'),topics=JSON.parse(migration.split('$topics$')[1]);
// Printed-page ceiling per book (last printed page of the book).
const maxPage={'نگارش ۱|mathematics':128,'نگارش ۱|experimental_sciences':128,'نگارش ۱|humanities':128,'نگارش ۲|mathematics':128,'نگارش ۲|experimental_sciences':128,'نگارش ۲|humanities':128,'نگارش ۳|mathematics':128,'نگارش ۳|experimental_sciences':128,'نگارش ۳|humanities':128,'علوم تجربی|all':176};
// Pattern-B fills for the 65 pristine NULL-page علوم تجربی ۹ rows (migration 139, v1 ids): [chapter, position, start, end].
const fills=[
  ["فصل ۱: مواد و نقش آنها در زندگی",1,2,2],
  ["فصل ۱: مواد و نقش آنها در زندگی",2,3,3],
  ["فصل ۱: مواد و نقش آنها در زندگی",3,4,6],
  ["فصل ۱: مواد و نقش آنها در زندگی",4,9,12],
  ["فصل ۱: مواد و نقش آنها در زندگی",5,11,12],
  ["فصل ۲: رفتار اتم‌ها با یکدیگر",1,14,16],
  ["فصل ۲: رفتار اتم‌ها با یکدیگر",2,17,19],
  ["فصل ۲: رفتار اتم‌ها با یکدیگر",3,20,21],
  ["فصل ۲: رفتار اتم‌ها با یکدیگر",4,22,22],
  ["فصل ۳: به دنبال محیطی بهتر برای زندگی",1,27,27],
  ["فصل ۳: به دنبال محیطی بهتر برای زندگی",2,28,29],
  ["فصل ۳: به دنبال محیطی بهتر برای زندگی",3,30,34],
  ["فصل ۳: به دنبال محیطی بهتر برای زندگی",4,35,37],
  ["فصل ۴: حرکت چیست",1,40,41],
  ["فصل ۴: حرکت چیست",2,42,47],
  ["فصل ۴: حرکت چیست",3,44,48],
  ["فصل ۴: حرکت چیست",4,49,50],
  ["فصل ۵: نیرو",1,52,53],
  ["فصل ۵: نیرو",2,52,59],
  ["فصل ۵: نیرو",3,54,56],
  ["فصل ۵: نیرو",4,57,57],
  ["فصل ۵: نیرو",5,58,59],
  ["فصل ۶: زمین‌ساخت ورقه‌ای",1,64,66],
  ["فصل ۶: زمین‌ساخت ورقه‌ای",2,69,70],
  ["فصل ۶: زمین‌ساخت ورقه‌ای",3,69,70],
  ["فصل ۶: زمین‌ساخت ورقه‌ای",4,71,72],
  ["فصل ۷: آثاری از گذشته زمین",1,74,75],
  ["فصل ۷: آثاری از گذشته زمین",2,76,78],
  ["فصل ۷: آثاری از گذشته زمین",3,79,82],
  ["فصل ۸: فشار و آثار آن",1,84,86],
  ["فصل ۸: فشار و آثار آن",2,87,88],
  ["فصل ۸: فشار و آثار آن",3,90,93],
  ["فصل ۸: فشار و آثار آن",4,89,89],
  ["فصل ۹: ماشین‌ها",1,96,97],
  ["فصل ۹: ماشین‌ها",2,100,105],
  ["فصل ۹: ماشین‌ها",3,99,99],
  ["فصل ۹: ماشین‌ها",4,102,103],
  ["فصل ۹: ماشین‌ها",5,104,105],
  ["فصل ۱۰: نگاهی به فضا",1,110,110],
  ["فصل ۱۰: نگاهی به فضا",2,110,113],
  ["فصل ۱۰: نگاهی به فضا",3,114,115],
  ["فصل ۱۰: نگاهی به فضا",4,116,117],
  ["فصل ۱۰: نگاهی به فضا",5,119,119],
  ["فصل ۱۱: گوناگونی جانداران",1,122,124],
  ["فصل ۱۱: گوناگونی جانداران",2,124,125],
  ["فصل ۱۱: گوناگونی جانداران",3,126,126],
  ["فصل ۱۱: گوناگونی جانداران",4,127,128],
  ["فصل ۱۱: گوناگونی جانداران",5,128,129],
  ["فصل ۱۲: دنیای گیاهان",1,138,138],
  ["فصل ۱۲: دنیای گیاهان",2,135,137],
  ["فصل ۱۲: دنیای گیاهان",3,135,136],
  ["فصل ۱۲: دنیای گیاهان",4,136,137],
  ["فصل ۱۳: جانوران بی‌مهره",1,142,143],
  ["فصل ۱۳: جانوران بی‌مهره",2,144,147],
  ["فصل ۱۳: جانوران بی‌مهره",3,148,149],
  ["فصل ۱۳: جانوران بی‌مهره",4,150,150],
  ["فصل ۱۴: جانوران مهره‌دار",1,152,153],
  ["فصل ۱۴: جانوران مهره‌دار",2,154,154],
  ["فصل ۱۴: جانوران مهره‌دار",3,155,157],
  ["فصل ۱۴: جانوران مهره‌دار",4,158,159],
  ["فصل ۱۴: جانوران مهره‌دار",5,160,162],
  ["فصل ۱۵: باهم‌زیستن",1,164,165],
  ["فصل ۱۵: باهم‌زیستن",2,164,165],
  ["فصل ۱۵: باهم‌زیستن",3,168,171],
  ["فصل ۱۵: باهم‌زیستن",4,167,167]];
// The six نگارش ۳ whole-lesson rows from migration 172 that each end one page short: [title, position, start, end]. Left untouched.
const oldWriting12=[
  ["خاطره‌نگاری",1,12,26],
  ["نگارش ادبی ۱: نثر ادبی",2,30,40],
  ["نگارش ادبی ۲: قطعه ادبی",3,44,56],
  ["نامه‌نگاری",4,60,75],
  ["نگارش علمی: مقاله‌نویسی ۱",5,80,92],
  ["نگارش علمی: مقاله‌نویسی ۲",6,96,103]];
const DEPS=['128_planner_topic_bank','133_planner_topic_chapters','135_planner_science_humanities_topics','136_planner_physics_writing_topics','138_planner_remaining_topics','139_planner_science9_topics','167_planner_english9_1405_pages','172_planner_writing_1405_pages','182_planner_psychology11_1405_pages','183_planner_legacy_exact_1405_pages','184_planner_philosophy_psychology_legacy_1405_pages','192_planner_topic_super_admin','200_planner_literary_studies_1405','208_planner_messages9_1405','211_planner_science9_1405','217_planner_psychology11_finer_1405','220_planner_writing9_1405','228_planner_writing_finer_1405'];
const code=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':process.cwd()}}).outputFiles[0].text,mod={exports:{}};new Function('module','exports','require',code)(mod,mod.exports,require);
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 for(const n of DEPS)await db.exec(sql(n));
 // Pre-migration state: exactly the 65 علوم تجربی ۹ rows are NULL-page, pristine, revision 1.
 const nulls=(await db.query("select chapter,position,title from private.planner_topic_bank where subject='علوم تجربی' and page_start is null")).rows;
 assert.equal(nulls.length,65);
 for(const [chapter,position] of fills.map(f=>[f[0],f[1]])){
  const r=(await db.query("select title,page_start,page_end,revision from private.planner_topic_bank where subject='علوم تجربی' and chapter=$1 and position=$2",[chapter,position])).rows;
  assert.deepEqual(r.map(x=>[x.page_start,x.page_end,x.revision]),[[null,null,1]],`pre-fill ${chapter} pos ${position}`);
 }
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.equal(topics.length,34);
 // Every new topic lands in final_exam only (these books have no konkur track), with exact pages inside the book.
 let rows=0;
 for(const p of topics){
  assert.ok(p.start>=1&&p.end>=p.start&&p.end<=maxPage[p.subject+'|'+p.field],`${p.subject} ${p.title} pages out of range`);
  assert.equal(p.konkur,false);
  const r=(await db.query('select title,page_start,page_end,revision from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',['1405',p.field,p.grade,'final_exam',p.subject,p.chapter,p.position])).rows;
  assert.deepEqual(r,[{title:p.title,page_start:p.start,page_end:p.end,revision:1}],`${p.subject} ${p.chapter} pos ${p.position} final_exam`);
  rows++;
  const k=(await db.query('select count(*) c from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',['1405',p.field,p.grade,'konkur',p.subject,p.chapter,p.position])).rows[0].c;
  assert.equal(k,0);
  // Chapter must already exist in the prior bank for that combo.
  assert.ok(before.some(b=>b.study_field===p.field&&b.grade===p.grade&&b.subject===p.subject&&b.chapter===p.chapter),`chapter not previously seeded: ${p.subject} ${p.chapter}`);
 }
 assert.equal(rows,34);
 // Spot checks on the audited values.
 for(const [subject,chapter,position,title,start,end] of [
  ['نگارش ۱','درس‌ها',3000,'ستایش',11,11],
  ['نگارش ۱','درس‌ها',3001,'نیایش',123,123],
  ['نگارش ۳','درس‌ها',3000,'ستایش',9,9],
  ['نگارش ۳','درس‌ها',3001,'خاطره‌نگاری',12,27],
  ['نگارش ۳','درس‌ها',3002,'نگارش ادبی ۱: نثر ادبی',30,41],
  ['نگارش ۳','درس‌ها',3003,'نگارش ادبی ۲: قطعه ادبی',44,57],
  ['نگارش ۳','درس‌ها',3004,'نامه‌نگاری',60,76],
  ['نگارش ۳','درس‌ها',3005,'نگارش علمی: مقاله‌نویسی ۱',80,93],
  ['نگارش ۳','درس‌ها',3006,'نگارش علمی: مقاله‌نویسی ۲',96,104],
  ['نگارش ۲','درس‌ها',3000,'ستایش',11,11],
  ['نگارش ۲','درس‌ها',3001,'نیایش',124,124],
  ['علوم تجربی','فصل ۱۵: باهم‌زیستن',3000,'جدول تناوبی عنصرها',174,175]]){
  const t=topics.find(t=>t.subject===subject&&t.chapter===chapter&&t.position===position);
  assert.ok(t);assert.deepEqual([t.title,t.start,t.end],[title,start,end]);
 }
 // The six short نگارش ۳ whole-lesson rows (migration 172) are untouched.
 for(const [title,position,start,end] of oldWriting12){
  const r=(await db.query("select page_start,page_end,revision from private.planner_topic_bank where subject='نگارش ۳' and chapter='درس‌ها' and position=$1 and study_field='mathematics' and preparation_track='final_exam'",[position])).rows;
  assert.deepEqual(r,[{page_start:start,page_end:end,revision:1}],`old writing12 pos ${position}`);
 }
 // All 65 pattern-B fills landed, revision bumped to 2, and no other NULL-page علوم تجربی ۹ row remains.
 for(const [chapter,position,start,end] of fills){
  const r=(await db.query("select title,page_start,page_end,revision from private.planner_topic_bank where subject='علوم تجربی' and chapter=$1 and position=$2",[chapter,position])).rows;
  assert.deepEqual(r.map(x=>[x.page_start,x.page_end,x.revision]),[[start,end,2]],`fill ${chapter} pos ${position}`);
 }
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject='علوم تجربی' and page_start is null")).rows[0].c,0);
 // Catalog: the audited subjects exist for their combos; specialist chapters match the catalog.
 for(const track of ['final_exam']){
  for(const field of ['mathematics','experimental_sciences','humanities']){
   assert.ok(mod.exports.curriculumBooks(field,10,track).some(x=>x.subject==='نگارش ۱'),`catalog نگارش ۱ ${field}`);
   assert.ok(mod.exports.curriculumBooks(field,11,track).some(x=>x.subject==='نگارش ۲'),`catalog نگارش ۲ ${field}`);
   assert.ok(mod.exports.curriculumBooks(field,12,track).some(x=>x.subject==='نگارش ۳'),`catalog نگارش ۳ ${field}`);
  }
  assert.ok(mod.exports.curriculumBooks(null,9,track).some(x=>x.subject==='علوم تجربی'),'catalog علوم تجربی ۹');
  assert.ok(mod.exports.curriculumBooks(null,9,track).some(x=>x.subject==='نگارش'),'catalog نگارش ۹');
  assert.ok(mod.exports.curriculumBooks(null,9,track).some(x=>x.subject==='پیام‌های آسمان'),'catalog پیام‌های آسمان ۹');
  const lit=mod.exports.curriculumBooks('humanities',10,track).find(x=>x.subject==='علوم و فنون ادبی ۱');assert.ok(lit);
  for(const c of ['فصل ۱','فصل ۲','فصل ۳','فصل ۴'])assert.ok(lit.chapters.includes(c));
  const psy=mod.exports.curriculumBooks('humanities',11,track).find(x=>x.subject==='روان‌شناسی');assert.ok(psy);
  for(let i=1;i<=8;i++)assert.ok(psy.chapters.includes('درس '+i.toLocaleString('fa-IR')));
 }
 // Bank delta is exactly 34 new rows plus the 65 page-fills; nothing else changed.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const newIds=new Set(after.filter(a=>!before.some(b=>b.id===a.id)).map(a=>a.id));
 assert.equal(newIds.size,34);
 const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
 assert.equal(changed.length,65);
 assert.ok(changed.every(a=>a.subject==='علوم تجربی'&&a.revision===2));
 assert.deepEqual(after.filter(a=>!newIds.has(a.id)&&!changed.some(c=>c.id===a.id)),before.filter(b=>!changed.some(c=>c.id===b.id)));
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit via planner_save_topic and delete of new rows survive a re-run.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='نگارش ۳' and chapter='درس‌ها' and position=3001 and study_field='mathematics' and preparation_track='final_exam'")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','12','final_exam','نگارش ۳','درس‌ها','ویرایش مدیر',12,27,3001)",[edit.id,edit.r]);
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='علوم تجربی' and position=3000")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Batch 6 audit: 34 topics / 34 rows (نگارش ۱/۲/۳ ستایش+نیایش, نگارش ۳ corrected lessons, علوم ۹ periodic table) + 65 علوم ۹ page-fills across 10 books; prior rows, superseded writing-12 lessons, edits/deletions/rerun and simulated snapshot');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
