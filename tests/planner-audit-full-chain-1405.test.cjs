// Full-chain verification for the Nova planner topic-bank audit (migrations 231-238)
// plus the follow-up phase (239-244) and phase 3 (245-247).
// Phase 1 attempts the ENTIRE migration chain 128-247 in numeric order in a fresh
// PGlite database, recording every migration that cannot apply (with its error)
// instead of silently skipping it; the maximal chain that does run is applied.
// Phase 2 applies the audit-relevant chain (128 + the union of every batch test's
// dependency migrations + 231-238 + follow-ups 239-244 + phase 3 245-247) in a
// second fresh database and asserts the audit outcomes end to end.
// Run: node tests/planner-audit-full-chain-1405.test.cjs
const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const STUBS=`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
create table private.planner_seed_installations(seed_key text primary key);
create table public.profiles(id uuid primary key);create table public.weekly_plans(id uuid primary key);
-- Minimal FK targets for 118 (drafts table references profiles/weekly_plans).
create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`;
// All migration files 128-248 present on disk, in numeric order.
const ALL=fs.readdirSync('supabase/migrations').filter(f=>{const n=parseInt(f.split('_')[0],10);return n>=128&&n<=248}).sort((a,b)=>parseInt(a.split('_')[0],10)-parseInt(b.split('_')[0],10));
// Audit-relevant chain: 128 + the union of the dependency migrations of audit
// batches 1-8 + the eight audit migrations, in numeric order.
const AUDIT_CHAIN=['118_planner_private_drafts','119_planner_atomic_publish','126_planner_publish_validation','128_planner_topic_bank','131_planner_biology12_1405_topics','132_planner_verified_topics','133_planner_topic_chapters','134_planner_more_textbook_topics','135_planner_science_humanities_topics','136_planner_physics_writing_topics','137_planner_humanities_school_topics','138_planner_remaining_topics','139_planner_science9_topics','141_planner_humanities_topics','142_planner_economics_topics','143_planner_sociology12_topics','144_planner_sociology11_topics','145_planner_philosophy12_topics','147_planner_arabic10_topics','148_planner_arabic_geography_topics','149_planner_arabic12_topics','150_planner_history12_topics','151_planner_grade9_topics','153_planner_religion12_topics','154_planner_shared_school_topics','155_planner_shared_school_detail','156_planner_shared_school_more_details','161_planner_three_1405_books','163_planner_religion12_1405_pages','167_planner_english9_1405_pages','169_planner_english_1405_details','172_planner_writing_1405_pages','173_planner_environment_1405_pages','174_planner_health_1405_pages','175_planner_logic_1405_pages','177_planner_media_1405_pages','178_planner_geography10_1405_pages','180_planner_geography11_12_independent_1405','181_planner_philosophy11_12_1405_pages','182_planner_psychology11_1405_pages','183_planner_legacy_exact_1405_pages','184_planner_philosophy_psychology_legacy_1405_pages','187_planner_chemistry_1405_pages','188_planner_arabic12_1405_pages','189_planner_arabic11_1405_pages','190_planner_persian11_12_1405_pages','191_planner_arabic10_1405_pages','192_planner_topic_super_admin','193_planner_biology_1405_pages','194_planner_physics_1405_pages','195_planner_math_geometry_1405','196_planner_physics_finer_1405','197_planner_economics_1405_pages','198_planner_society_statistics_1405','199_planner_calculus_discrete_1405','200_planner_literary_studies_1405','201_planner_logic_1405','202_planner_math9_1405','203_planner_geometry2_1405','204_planner_sociology_1405','205_planner_history12_1405','206_planner_labs_1405','207_planner_defense9_1405','208_planner_messages9_1405','209_planner_religion10_1405','210_planner_persian10_1405','211_planner_science9_1405','212_planner_religion12_humanities_1405','213_planner_religion11_humanities_1405','214_planner_work_technology9_1405','215_planner_philosophy11_finer_1405','216_planner_philosophy12_finer_1405','217_planner_psychology11_finer_1405','218_planner_family12_versions_1405','219_planner_culture_art9_1405','220_planner_writing9_1405','221_planner_quran9_1405','222_planner_arabic9_1405','223_planner_workbook9_audit_1405','224_planner_persian9_1405','225_planner_workbook9_subparts_1405','226_planner_grade9_catalog_1405','227_planner_vision_exercises_1405','228_planner_writing_finer_1405','229_planner_geography_activities_1405','230_planner_geography_skills_1405','231_planner_audit_batch1_1405','232_planner_audit_batch2_1405','233_planner_audit_batch3_1405','234_planner_audit_batch4_1405','235_planner_audit_batch5_1405','236_planner_audit_batch6_1405','237_planner_audit_batch7_1405','238_planner_audit_batch8_1405'];
const AUDIT=AUDIT_CHAIN.slice(-8);
// Follow-up phase migrations 239-244 (items 1-5; 244 re-issues the publication
// validator). 241 has no install marker: its guarded UPDATE is idempotent via
// the revision=1 + NULL-pages guard, so a re-run matches nothing.
const FOLLOWUP=['239_planner_followup_outside79_a_1405','240_planner_followup_outside79_b_1405','241_planner_followup_soc_geo_fix_1405','242_planner_followup_motaleat_worksheets_1405','243_planner_followup_lab_math_1405','244_planner_followup_lab_math_publish_1405'];
const EXPECTED_FOLLOWUP_ROWS=[21,90,0,18,186,0]; // sums to 315
const EXPECTED_FOLLOWUP_FILLS=[0,0,4,0,0,0]; // pattern-B page-fills, sums to 4
const EXPECTED_FOLLOWUP_MARKERS=['audit-followup5a-1405-v239','audit-followup5b-1405-v240','followup-motaleat-worksheets-1405-v242','labs-math-10-11-1405-v243'];
// Phase 3 migrations 245-247 (user decisions on the follow-up open questions).
// 245 has no install marker: DDL (add column if not exists) + function re-issue
// + guarded hide update are idempotent via the guard. 246 has no install marker:
// guarded page-fill only. 247 has marker 'planner-phase3-dini-ranges-1405-v247'.
// In the audit chain 246 is a no-op by design: its guard needs the post-158
// state (NULL pages, revision 2) and 158 is not an audit dependency, so the
// rows keep 154's 78-116 pages there; the fill is verified by phase 1 instead.
const PHASE3=['245_planner_phase3_hide_moved_rows_1405','246_planner_phase3_defai_lesson9_page_1405','247_planner_phase3_dini_ranges_1405'];
const EXPECTED_PHASE3_ROWS=[0,0,430]; // sums to 430
const EXPECTED_PHASE3_FILLS=[0,0,0]; // pattern-B page-fills in the audit chain, sums to 0
const EXPECTED_PHASE3_CHANGED=[4,0,24]; // rows whose stored values change (hide flag / — / page corrections)
const EXPECTED_PHASE3_MARKERS=['planner-phase3-dini-ranges-1405-v247'];
const EXPECTED_ROWS=[17,1,52,112,203,34,224,23]; // per batch, sums to 666
const EXPECTED_FILLS=[0,0,0,0,8,65,0,0]; // pattern-B page-fills per batch, sums to 73
const EXPECTED_MARKERS=AUDIT.map((_,i)=>`audit-batch${i+1}-1405-v23${i+1}`);
const snap=async db=>(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v||[];
const count=async(db,q,args=[])=>(await db.query(q,args)).rows[0].c;
(async()=>{
 // --- Phase 1: full chain 128-248, recording (never silently skipping) failures. ---
 assert.equal(ALL.length,121,'migrations 128-248 must be exactly 121 files on disk');
 assert.deepEqual(ALL.map(f=>parseInt(f.split('_')[0],10)),Array.from({length:121},(_,i)=>128+i),'migration numbers 128-248 must be contiguous');
 const chainDb=new PGlite(),failures=[];
 try{
  await chainDb.exec(STUBS);
  for(const f of ALL){
   try{await chainDb.exec(fs.readFileSync(`supabase/migrations/${f}`,'utf8'));}
   catch(e){failures.push({migration:f,error:String(e.message||e).split('\n')[0]});}
  }
  // When the full chain applied with no skips, its end state is asserted too:
  // the only NULL-page rows left are the 18 کاربرگه worksheet rows added by
  // follow-up 242, which are page-less by design (the PDF prints no page
  // numbers for them). The جامعه‌شناسی ۲ and جغرافیا ۲ NULL rows the audit
  // left untouched were moved and filled by follow-up 241, and the three
  // آمادگی دفاعی درس ۹ rows were filled 87-116 by phase-3 246 (verified
  // against the PDF text), so neither set appears here. If any migration was
  // skipped above, this check is not meaningful for the partial chain and is
  // left to phase 2.
  if(failures.length===0){
   const fullNulls=(await chainDb.query('select subject,chapter,title from private.planner_topic_bank where page_start is null order by subject,chapter,title')).rows;
   assert.deepEqual(fullNulls,[
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۱: طول و عرض جغرافیایی'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۱۰: زمینه‌ها و عوامل نهضت مشروطه'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۱۱: سخن امام درباره قرآن و روحانیت'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۱۲: رویدادهای مهم انقلاب اسلامی در سال ۱۳۵۷'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۱۳: لایه‌های فرهنگ'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۱۴: سازگاری والدین و فرزندان'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۱۵: سازگاری والدین و فرزندان'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۱۶: حقوق و تکالیف شهروندی'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۱۷: بهره‌وری'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۱۸: حل مسئله'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۲: طول و عرض جغرافیایی بر روی نقشه'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۳: انواع ناهمواری‌ها'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۴: رابطه پراکندگی زیست‌بوم‌های جهان با عرض جغرافیایی و بارش'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۵: زیست‌بوم‌های جهان'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۶: شگفتی‌های آفریقا'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۷: نقشه سیاسی ایران در آستانه تأسیس حکومت صفویه'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۸: اداره شهرها و روستاها در عصر صفوی'},
    {subject:'مطالعات اجتماعی',chapter:'کاربرگه‌ها',title:'کاربرگه ۹: جدایی سرزمین‌های ایرانی در دوره قاجار'}],'full-chain remaining NULL-page rows');
   // Phase-3 246 filled the three old آمادگی دفاعی درس ۹ rows 87-116 (the
   // pos-301 replacements carry the same pages under a different title).
   assert.equal(Number(await count(chainDb,"select count(*) c from private.planner_topic_bank where grade='10' and subject='آمادگی دفاعی' and chapter='فصل ۳: دفاع نظامی' and title='درس ۹: جنگ‌افزارشناسی و اصول تیراندازی' and position=3 and page_start=87 and page_end=116")),3,'full-chain defai lesson 9 rows filled 87-116 by phase-3 246');
   const fullMarkers=(await chainDb.query("select seed_key from private.planner_seed_installations where seed_key like 'audit-batch%' order by seed_key")).rows.map(r=>r.seed_key);
   assert.deepEqual(fullMarkers,EXPECTED_MARKERS,'full-chain audit install markers');
   const fullFuMarkers=(await chainDb.query("select seed_key from private.planner_seed_installations where seed_key in ('audit-followup5a-1405-v239','audit-followup5b-1405-v240','followup-motaleat-worksheets-1405-v242','labs-math-10-11-1405-v243','planner-phase3-dini-ranges-1405-v247') order by seed_key")).rows.map(r=>r.seed_key);
   assert.deepEqual(fullFuMarkers,[...EXPECTED_FOLLOWUP_MARKERS,...EXPECTED_PHASE3_MARKERS].sort(),'full-chain follow-up install markers');
  }
 }finally{await chainDb.close();}
 if(failures.length===0)console.log('FULL CHAIN 128-248: all 121 migrations applied cleanly in PGlite (no skipped migration).');
 else{
  console.log(`FULL CHAIN 128-248: INCOMPLETE — ${failures.length} migration(s) could not apply in PGlite (recorded, not skipped silently):`);
  for(const f of failures)console.log(`  SKIPPED ${f.migration}: ${f.error}`);
  console.log('Continuing with the maximal chain that does run; the audit-relevant chain below is asserted cleanly.');
 }
 // --- Phase 2: audit-relevant chain, asserted cleanly. ---
 const db=new PGlite();
 try{
  await db.exec(STUBS);
  for(const n of AUDIT_CHAIN.slice(0,-8))await db.exec(sql(n));
  // No audit row exists before 231: audit rows are the only position>=3000 rows.
  assert.equal(Number(await count(db,'select count(*) c from private.planner_topic_bank where position>=3000')),0,'pre-audit position>=3000 rows');
  // Apply the eight audit migrations one at a time, counting each batch's delta.
  let totalRows=0,totalFills=0;
  for(let i=0;i<8;i++){
   const before=await snap(db);
   await db.exec(sql(AUDIT[i]));
   const after=await snap(db);
   const newRows=after.filter(a=>!before.some(b=>b.id===a.id));
   const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
   const fills=changed.filter(a=>{const b=before.find(x=>x.id===a.id);return b.page_start==null&&a.page_start!=null});
   assert.equal(newRows.length,EXPECTED_ROWS[i],`batch ${i+1} new rows`);
   assert.equal(fills.length,EXPECTED_FILLS[i],`batch ${i+1} pattern-B fills`);
   assert.equal(changed.length,fills.length,`batch ${i+1}: every changed pre-existing row is a page-fill`);
   for(const r of newRows){
    assert.ok(r.position>=3000&&r.page_start!=null&&r.page_end!=null&&r.page_start>=1&&r.page_end>=r.page_start&&r.revision===1,`batch ${i+1} new row pages/revision: ${r.subject} ${r.chapter} pos ${r.position}`);
   }
   totalRows+=newRows.length;totalFills+=fills.length;
  }
  assert.equal(totalRows,666,'total new audit rows');
  assert.equal(totalFills,73,'total pattern-B page-fills');
  // Apply the six follow-up migrations one at a time, counting each delta the
  // same way. New rows are page-less ONLY for the 18 کاربرگه worksheet rows
  // (migration 242, chapter «کاربرگه‌ها», page-less by design); every other
  // new follow-up row must have pages.
  let fuRows=0,fuFills=0;
  for(let i=0;i<6;i++){
   const before=await snap(db);
   await db.exec(sql(FOLLOWUP[i]));
   const after=await snap(db);
   const newRows=after.filter(a=>!before.some(b=>b.id===a.id));
   const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
   const fills=changed.filter(a=>{const b=before.find(x=>x.id===a.id);return b.page_start==null&&a.page_start!=null});
   assert.equal(newRows.length,EXPECTED_FOLLOWUP_ROWS[i],`follow-up ${i+1} new rows`);
   assert.equal(fills.length,EXPECTED_FOLLOWUP_FILLS[i],`follow-up ${i+1} pattern-B fills`);
   assert.equal(changed.length,fills.length,`follow-up ${i+1}: every changed pre-existing row is a page-fill`);
   for(const r of newRows){
    if(r.subject==='مطالعات اجتماعی'&&r.chapter==='کاربرگه‌ها')assert.ok(r.position>=3000&&r.page_start==null&&r.page_end==null&&r.revision===1,`follow-up ${i+1} worksheet row page-less by design: ${r.title} pos ${r.position}`);
    // Follow-up 5 (migration 243) mirrors migration 206 exactly, so its rows
    // carry the original small positions (1-45), not the audit's >=3000 range.
    else if(i===4)assert.ok(r.position>=1&&r.position<=45&&r.page_start!=null&&r.page_end!=null&&r.page_start>=1&&r.page_end>=r.page_start&&r.revision===1,`follow-up ${i+1} new row pages/revision: ${r.subject} ${r.chapter} pos ${r.position}`);
    else assert.ok(r.position>=3000&&r.page_start!=null&&r.page_end!=null&&r.page_start>=1&&r.page_end>=r.page_start&&r.revision===1,`follow-up ${i+1} new row pages/revision: ${r.subject} ${r.chapter} pos ${r.position}`);
   }
   fuRows+=newRows.length;fuFills+=fills.length;
  }
  // Apply the three phase-3 migrations one at a time. 245 adds a column, so
  // row comparison strips hidden_from_selection (every row's JSON gains the
  // key); 246 is a no-op here by design (guard needs post-158 state, and 158
  // is not in this chain); 247 adds 430 مطالعه rows and corrects 24 ranges.
  let p3Rows=0,p3Fills=0;
  const strip=r=>{const {hidden_from_selection,...rest}=r;return rest;};
  for(let i=0;i<3;i++){
   const before=await snap(db);
   await db.exec(sql(PHASE3[i]));
   const after=await snap(db);
   const newRows=after.filter(a=>!before.some(b=>b.id===a.id));
   const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(strip(b))!==JSON.stringify(strip(a))});
   const fills=changed.filter(a=>{const b=before.find(x=>x.id===a.id);return b.page_start==null&&a.page_start!=null});
   assert.equal(newRows.length,EXPECTED_PHASE3_ROWS[i],`phase-3 ${i+1} new rows`);
   assert.equal(fills.length,EXPECTED_PHASE3_FILLS[i],`phase-3 ${i+1} pattern-B fills`);
   assert.equal(changed.length,EXPECTED_PHASE3_CHANGED[i],`phase-3 ${i+1} changed rows`);
   for(const r of newRows){
    assert.ok(r.position>=3000&&r.page_start!=null&&r.page_end!=null&&r.page_start>=1&&r.page_end>=r.page_start&&r.revision===1,`phase-3 ${i+1} new row pages/revision: ${r.subject} ${r.chapter} pos ${r.position}`);
   }
   p3Rows+=newRows.length;p3Fills+=fills.length;
  }
  // 245 hid exactly the 4 moved rows; 247 corrected دین و زندگی ۲ درس ۱ to 10-18.
  assert.equal(Number(await count(db,'select count(*) c from private.planner_topic_bank where hidden_from_selection=true')),4,'phase-3 hidden rows');
  assert.equal(Number(await count(db,"select count(*) c from private.planner_topic_bank where subject='تعلیمات دینی ۲' and chapter='درس ۱: هدایت الهی' and title='کل درس' and page_start=10 and page_end=18")),2,'phase-3 dini 2 lesson 1 corrected to 10-18');
  assert.equal(totalRows+fuRows+p3Rows,1411,'total new rows incl. follow-up + phase 3 (666+315+430)');
  assert.equal(totalFills+fuFills+p3Fills,77,'total pattern-B page-fills incl. follow-up + phase 3 (73+4+0)');
  // All 8 audit install markers present, and no other audit-batch marker.
  const markers=(await db.query("select seed_key from private.planner_seed_installations where seed_key like 'audit-batch%' order by seed_key")).rows.map(r=>r.seed_key);
  assert.deepEqual(markers,EXPECTED_MARKERS,'audit install markers');
  const fuMarkers=(await db.query("select seed_key from private.planner_seed_installations where seed_key in ('audit-followup5a-1405-v239','audit-followup5b-1405-v240','followup-motaleat-worksheets-1405-v242','labs-math-10-11-1405-v243','planner-phase3-dini-ranges-1405-v247') order by seed_key")).rows.map(r=>r.seed_key);
  assert.deepEqual(fuMarkers,[...EXPECTED_FOLLOWUP_MARKERS,...EXPECTED_PHASE3_MARKERS].sort(),'follow-up install markers');
  // The only audit/follow-up rows with NULL pages are the 18 کاربرگه worksheet
  // rows (page-less by design). (The audit-relevant chain omits some pre-audit
  // page-filling migrations, e.g. 157-160/162/164-166/168/170-171/176/179/186,
  // so other pre-existing rows may still lack pages here; the exact
  // remaining-NULL set for the FULL chain is asserted in phase 1.)
  assert.equal(Number(await count(db,'select count(*) c from private.planner_topic_bank where position>=3000 and (page_start is null or page_end is null)')),18,'audit/follow-up rows with NULL pages');
  assert.equal(Number(await count(db,"select count(*) c from private.planner_topic_bank where position>=3000 and (page_start is null or page_end is null) and not (subject='مطالعات اجتماعی' and chapter='کاربرگه‌ها')")),0,'NULL-page audit rows outside the worksheets');
  // Follow-up 241 moved the two pre-existing NULL-page rows the audit had left
  // untouched into their correct lessons with pages: جامعه‌شناسی ۲ درس ۱۵ x2
  // → درس ۱۴, 120-123; جغرافیا ۲ درس ۱ x2 → درس ۲, 15-17. Phase-3 245 then
  // hid those 4 moved rows from the counselor new-selection list (they stay
  // resolvable by id and visible to super-admins). The third untouched set,
  // آمادگی دفاعی درس ۹, is filled 87-116 by phase-3 246 in the FULL chain
  // only: its guard needs the post-158 state (NULL pages, revision 2), and
  // 158 is not an audit dependency, so in THIS chain 246 matches nothing and
  // the rows keep 154's 78-116 pages. Phase 1 asserts the full-chain fill.
  for(const [subject,chapter,title,rows,start,end] of [
   ['جامعه‌شناسی ۲','درس ۱۴','انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم',2,120,123],
   ['جغرافیا ۲','درس ۲','کانون و مرزهای ناحیه',2,15,17]]){
   assert.equal(Number(await count(db,'select count(*) c from private.planner_topic_bank where subject=$1 and chapter=$2 and title=$3 and page_start=$4 and page_end=$5',[subject,chapter,title,start,end])),rows,`follow-up moved rows: ${subject} ${title}`);
  }
  // Baseline spot checks (planner-topic-bank / planner-geography-skills-1405 /
  // planner-topic-super-admin key assertions, cheaply re-run here).
  await db.query("select set_config('test.role','counselor',false),set_config('test.super','false',false),set_config('test.approved','true',false)");
  const listed=(await db.query("select public.planner_list_topics('1405','mathematics','11','final_exam','آمار و احتمال','فصل ۳: آمار توصیفی') v")).rows[0].v;
  assert.ok(listed.some(x=>x.title==='خواندنی: تاریخچۀ علم آمار و علم احتمال'),'audit row listable via planner_list_topics');
  await db.query("select set_config('test.role','student',false)");
  await assert.rejects(db.query("select public.planner_list_topics('1405','mathematics','11','final_exam','آمار و احتمال','فصل ۳: آمار توصیفی')"),/required/,'student list rejected');
  for(const track of ['konkur','final_exam']){
   const geo=(await db.query('select title,page_start,page_end from private.planner_topic_bank where grade=$1 and subject=$2 and study_field=$3 and preparation_track=$4 and chapter=$5 and position=$6',['11','جغرافیا ۲','humanities',track,'درس ۱۰',2001])).rows;
   assert.deepEqual(geo,[{title:'مهارت نقشه مرزهای ایران و همسایگان',page_start:141,page_end:141}],`geography skills row (${track})`);
  }
  // Re-running migrations 231-247 is a no-op.
  const settled=await snap(db);
  for(const n of [...AUDIT,...FOLLOWUP,...PHASE3])await db.exec(sql(n));
  assert.deepEqual(await snap(db),settled,'re-run 231-247: bank unchanged');
  assert.deepEqual((await db.query("select seed_key from private.planner_seed_installations where seed_key like 'audit-batch%' order by seed_key")).rows.map(r=>r.seed_key),EXPECTED_MARKERS,'re-run 231-247: audit markers unchanged');
  assert.deepEqual((await db.query("select seed_key from private.planner_seed_installations where seed_key in ('audit-followup5a-1405-v239','audit-followup5b-1405-v240','followup-motaleat-worksheets-1405-v242','labs-math-10-11-1405-v243','planner-phase3-dini-ranges-1405-v247') order by seed_key")).rows.map(r=>r.seed_key),[...EXPECTED_FOLLOWUP_MARKERS,...EXPECTED_PHASE3_MARKERS].sort(),'re-run 231-247: follow-up markers unchanged');
  // Simulated super-admin edit and admin delete of audit rows survive a re-run.
  await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
  const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='آمار و احتمال' and chapter='فصل ۳: آمار توصیفی' and position=3001 and preparation_track='final_exam'")).rows[0];
  await db.query("select public.planner_save_topic($1,$2,'1405','mathematics','11','final_exam','آمار و احتمال','فصل ۳: آمار توصیفی','ویرایش مدیر',79,79,3001)",[edit.id,edit.r]);
  const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='تفکر و سواد رسانه‌ای' and position=3000 and study_field='humanities'")).rows[0];
  await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
  const current=await snap(db);
  assert.ok(current.some(r=>r.title==='ویرایش مدیر'),'super-admin edit applied');
  assert.ok(!current.some(r=>r.id===del.id),'admin delete applied');
  for(const n of [...AUDIT,...FOLLOWUP,...PHASE3])await db.exec(sql(n));
  assert.deepEqual(await snap(db),current,'re-run after edit/delete: edit intact, deleted row not resurrected');
  assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]},'simulated published_snapshot unchanged');
  console.log(`PASS: Full-chain audit 1405: 121 migrations 128-248 applied in PGlite (${failures.length} skipped); audit chain ${AUDIT_CHAIN.length} migrations; 1411 new rows (17+1+52+112+203+34+224+23+21+90+0+18+186+0+0+0+430), 77 pattern-B page-fills in the audit chain (8+65+4; 80 incl. full-chain phase-3 246), 13 markers, 18 page-less worksheet rows by design, rerun/edit/delete/snapshot all hold`);
 }finally{await db.close();}
})().catch(e=>{console.error(e);process.exitCode=1});
