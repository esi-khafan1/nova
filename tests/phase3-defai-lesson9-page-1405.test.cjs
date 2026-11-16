const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}`,'utf8');
const migration=sql('246_planner_phase3_defai_lesson9_page_1405.sql');
// Original v1 ids of the three old rows (md5('nova:planner:1405:v1:<field>:10:final_exam:آمادگی دفاعی:فصل ۳: دفاع نظامی:3')).
const OLD_IDS={
 mathematics:'993769bf-84d7-6070-c368-b2aef0f44c0b',
 experimental_sciences:'e9e2cad2-5dac-d53b-da1e-74222a6c3d64',
 humanities:'a2f3856c-ec5e-c0e5-462f-664868c357d4'};
const ALL=fs.readdirSync('supabase/migrations').filter(f=>{const n=parseInt(f.split('_')[0],10);return n>=128&&n<=244}).sort((a,b)=>parseInt(a.split('_')[0],10)-parseInt(b.split('_')[0],10));
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 assert.equal(ALL.length,117,'migrations 128-244 must be exactly 117 files on disk');
 for(const f of ALL)await db.exec(sql(f));
 // Pre-migration: 86 rows per grade-10 combo (85 seeds + migration 239 منابع row),
 // grade-9 defence untouched at 85.
 for(const field of ['mathematics','experimental_sciences','humanities']){
  const c=(await db.query("select count(*) c from private.planner_topic_bank where subject='آمادگی دفاعی' and study_field=$1 and grade='10' and preparation_track='final_exam'",[field])).rows[0].c;
  assert.equal(Number(c),86,`pre-count defai grade 10 ${field}`);
 }
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject='آمادگی دفاعی' and grade='9'")).rows[0].c,85,'grade-9 defence count');
 // Pre-migration: the only NULL-page grade-10 defence rows are the three old
 // درس ۹ rows (position 3, revision 2), with the exact original v1 ids.
 const nullPre=(await db.query("select id,study_field,chapter,position,revision,title from private.planner_topic_bank where subject='آمادگی دفاعی' and grade='10' and page_start is null order by study_field")).rows;
 assert.equal(nullPre.length,3,'exactly three NULL-page grade-10 defence rows');
 for(const r of nullPre){
  assert.equal(r.id,OLD_IDS[r.study_field],`old-row id ${r.study_field}`);
  assert.equal(r.chapter,'فصل ۳: دفاع نظامی');
  assert.equal(r.position,3);
  assert.equal(r.revision,2);
  assert.equal(r.title,'درس ۹: جنگ‌افزارشناسی و اصول تیراندازی');
 }
 // The verified position-301 replacement exists, paged 87-116, revision 1, untouched by this item.
 const repPre=(await db.query("select id,study_field,page_start,page_end,revision,title from private.planner_topic_bank where subject='آمادگی دفاعی' and grade='10' and position=301 order by study_field")).rows;
 assert.equal(repPre.length,3,'three pos-301 replacement rows');
 for(const r of repPre){
  assert.equal(r.title,'درس ۹: جنگ‌افزارشناسی و اصول تیراندازی (بازه تأییدشده)');
  assert.deepEqual([r.page_start,r.page_end,r.revision],[87,116,1]);
 }
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 // The old rows keep their ids, gain the verified pages 87-116, revision 2 -> 3.
 for(const field of ['mathematics','experimental_sciences','humanities']){
  const r=(await db.query('select id,title,page_start,page_end,revision,position,chapter from private.planner_topic_bank where id=$1',[OLD_IDS[field]])).rows;
  assert.deepEqual(r,[{id:OLD_IDS[field],title:'درس ۹: جنگ‌افزارشناسی و اصول تیراندازی',page_start:87,page_end:116,revision:3,position:3,chapter:'فصل ۳: دفاع نظامی'}],`old row filled ${field}`);
 }
 // The position-301 replacement rows are byte-identical to before.
 const repAfter=(await db.query("select id,study_field,page_start,page_end,revision,title from private.planner_topic_bank where subject='آمادگی دفاعی' and grade='10' and position=301 order by study_field")).rows;
 assert.deepEqual(repAfter,repPre,'pos-301 replacement untouched');
 // Bank delta is exactly the three old rows; no row added, nothing else changed.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 assert.equal(after.length,before.length,'no rows added or removed');
 const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
 assert.equal(changed.length,3,'exactly three rows changed');
 assert.ok(changed.every(a=>Object.values(OLD_IDS).includes(a.id)),'only the old rows changed');
 // No NULL-page grade-10 defence row remains.
 assert.equal((await db.query("select count(*) c from private.planner_topic_bank where subject='آمادگی دفاعی' and grade='10' and page_start is null")).rows[0].c,0,'no NULL-page grade-10 defence row remains');
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit (mathematics old row) and delete (humanities old row) survive a re-run.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where id=$1",[OLD_IDS.mathematics])).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','10','final_exam','آمادگی دفاعی','فصل ۳: دفاع نظامی','ویرایش مدیر',87,116,3)",[edit.id,edit.r]);
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where id=$1",[OLD_IDS.humanities])).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 // The admin edit is intact and the admin delete was NOT resurrected.
 const edited=(await db.query('select title,page_start,page_end,revision from private.planner_topic_bank where id=$1',[OLD_IDS.mathematics])).rows[0];
 assert.equal(edited.title,'ویرایش مدیر');
 assert.equal((await db.query('select count(*) c from private.planner_topic_bank where id=$1',[OLD_IDS.humanities])).rows[0].c,0,'admin-deleted row not resurrected');
 // The untouched third old row still carries the verified pages.
 assert.deepEqual((await db.query('select page_start,page_end,revision from private.planner_topic_bank where id=$1',[OLD_IDS.experimental_sciences])).rows[0],{page_start:87,page_end:116,revision:3});
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Phase 3 item 3: old آمادگی دفاعی درس ۹ rows (pos 3, rev 2 -> 3) page-filled 87-116 from verified PDF text; pos-301 replacement untouched; rerun no-op; admin edit survives; admin delete not resurrected');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
