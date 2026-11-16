// Phase 3 item 1: hide the four moved near-duplicate rows (migration 241)
// from the counselor's new-selection list, without deleting them and
// without touching admin management.
//
// Mechanism under test (migration 245):
//  * new column private.planner_topic_bank.hidden_from_selection (default false);
//  * planner_list_topics (192 version, otherwise verbatim) skips hidden rows
//    ONLY for counselors; super-admins still see every row, so the admin bank
//    manager keeps full edit/delete access to the hidden rows;
//  * a guarded update sets hidden=true only on rows still in their exact
//    post-241 state (original v1 id, new chapter, original title/position,
//    post-241 pages, revision=2); anything else is left visible.
//
// Run: node tests/phase3-near-duplicates-1405.test.cjs
const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration241=sql('241_planner_followup_soc_geo_fix_1405');
const migration245=sql('245_planner_phase3_hide_moved_rows_1405');
// Old v1 rows (ids pinned: md5('nova:planner:1405:v1:humanities:11:<track>:<subject>:<old chapter>:<position>')).
const oldIds={
 'جامعه‌شناسی ۲|konkur':'e1f041b8-3698-b415-9346-605aee28bdc0',
 'جامعه‌شناسی ۲|final_exam':'0259b466-5818-af75-41de-dae34dd9d24a',
 'جغرافیا ۲|konkur':'15268375-d484-b1fa-0dcf-6f2db3fa14db',
 'جغرافیا ۲|final_exam':'58396032-946b-72d8-44c8-46d6c8d182aa'};
const correctIds={
 'جامعه‌شناسی ۲|konkur':'3f8e8ce1-7250-5670-eabb-02b7b93e8a4c',
 'جامعه‌شناسی ۲|final_exam':'1c627f07-0d65-f180-0f43-f9c6e1bb2591',
 'جغرافیا ۲|konkur':'3eb9f3c1-f2cb-e727-0433-46f8eafdd516',
 'جغرافیا ۲|final_exam':'2b7d8343-c945-c735-85d2-8a20610ab495'};
const preamble=`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`;
const deps=['128_planner_topic_bank','144_planner_sociology11_topics','148_planner_arabic_geography_topics','167_planner_english9_1405_pages','180_planner_geography11_12_independent_1405','204_planner_sociology_1405','229_planner_geography_activities_1405','230_planner_geography_skills_1405'];
// Full row incl. the new flag (updated_at excluded: the hide bumps it).
// The bank() snapshot projection excludes updated_at AND the new flag:
// before-245 snapshots predate the column, so the diff below counts only
// content changes; the flag itself is asserted per row via byId().
const bank=async db=>(await db.query('select jsonb_agg(to_jsonb(t)-\'updated_at\'-\'hidden_from_selection\' order by id) v from private.planner_topic_bank t')).rows[0].v;
const byId=async (db,id)=>(await db.query('select edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position,revision,hidden_from_selection from private.planner_topic_bank where id=$1',[id])).rows;
// Pre-245 rows have no hidden_from_selection column yet.
const byIdBase=async (db,id)=>(await db.query('select edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position,revision from private.planner_topic_bank where id=$1',[id])).rows;
const asRole=async (db,role,superAdmin,approved)=>{await db.query('select set_config($1,$2,false),set_config($3,$4,false),set_config($5,$6,false)',['test.role',role,'test.super',superAdmin,'test.approved',approved])};
const list=async (db,subject,chapter,track)=> (await db.query('select public.planner_list_topics($1,$2,$3,$4,$5,$6) v',['1405','humanities','11',track,subject,chapter])).rows[0].v;
async function fresh(){
 const db=new PGlite();
 await db.exec(preamble);
 for(const n of deps)await db.exec(sql(n));
 await asRole(db,'admin','true','true');
 return db;
}
(async()=>{
 // --- Main instance: deps, then 241, then 245. ---
 const db=await fresh();
 try{
  // Pre-state: the four old rows exist, NULL pages, revision 1, in the wrong lessons.
  for(const [key,id] of Object.entries(oldIds)){
   const [subject,track]=key.split('|');
   const oldChapter=subject==='جامعه‌شناسی ۲'?'درس ۱۵':'درس ۱',oldPos=subject==='جامعه‌شناسی ۲'?1:3;
   const oldTitle=subject==='جامعه‌شناسی ۲'?'انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم':'کانون و مرزهای ناحیه';
   assert.deepEqual(await byIdBase(db,id),[{edition:'1405',study_field:'humanities',grade:'11',preparation_track:track,subject,chapter:oldChapter,title:oldTitle,page_start:null,page_end:null,position:oldPos,revision:1}],`pre-state ${key}`);
  }
  await db.exec(migration241);
  // Post-241: moved rows keep their ids, new chapter/pages, revision 2.
  for(const [key,id] of Object.entries(oldIds)){
   const [subject,track]=key.split('|');
   const r=(await byIdBase(db,id))[0];
   assert.equal(r.chapter,subject==='جامعه‌شناسی ۲'?'درس ۱۴':'درس ۲');
   assert.deepEqual([r.page_start,r.page_end],subject==='جامعه‌شناسی ۲'?[120,123]:[15,17]);
   assert.equal(r.revision,2);
  }
  const before245=await bank(db),beforeCount=before245.length;
  await db.exec(migration245);
  // The four moved rows are hidden, revision 3; nothing else changed.
  const after=await bank(db);
  assert.equal(after.length,beforeCount);
  assert.deepEqual(after.map(a=>a.id).sort(),before245.map(b=>b.id).sort());
  const changed=after.filter(a=>{const b=before245.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
  assert.equal(changed.length,4);
  // The projection excludes the flag (asserted per row via byId() below);
  // the four changed rows are exactly the moved rows, now at revision 3.
  assert.ok(changed.every(a=>Object.values(oldIds).includes(a.id)&&a.revision===3));
  for(const [key,id] of Object.entries(oldIds)){
   const [subject,track]=key.split('|');
   const newChapter=subject==='جامعه‌شناسی ۲'?'درس ۱۴':'درس ۲',start=subject==='جامعه‌شناسی ۲'?120:15,end=subject==='جامعه‌شناسی ۲'?123:17;
   assert.deepEqual(await byId(db,id),[{edition:'1405',study_field:'humanities',grade:'11',preparation_track:track,subject,chapter:newChapter,title:subject==='جامعه‌شناسی ۲'?'انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم':'کانون و مرزهای ناحیه',page_start:start,page_end:end,position:subject==='جامعه‌شناسی ۲'?1:3,revision:3,hidden_from_selection:true}],`hidden ${key}`);
  }
  // The correct rows are untouched and stay visible.
  for(const [key,id] of Object.entries(correctIds)){
   const [subject,track]=key.split('|');
   const r=(await byId(db,id))[0];
   assert.equal(r.revision,1);
   assert.equal(r.hidden_from_selection,false);
   if(subject==='جامعه‌شناسی ۲')assert.deepEqual([r.chapter,r.title,r.page_start,r.page_end,r.position],['درس ۱۴','مقایسه انقلاب اسلامی و انقلاب‌های آزادی‌بخش',120,123,453]);
   else assert.deepEqual([r.chapter,r.title,r.page_start,r.page_end,r.position],['درس ۲','کانون و مرز ناحیه',15,18,303]);
  }
  // Counselor (new selection): the old rows are gone from the list, the
  // correct rows remain, and an unrelated non-hidden row is still listed.
  await asRole(db,'counselor','false','true');
  for(const [subject,chapter] of [['جامعه‌شناسی ۲','درس ۱۴'],['جغرافیا ۲','درس ۲']]){
   for(const track of ['konkur','final_exam']){
    const listed=await list(db,subject,chapter,track);
    assert.ok(!listed.some(t=>t.id===oldIds[subject+'|'+track]),`counselor still sees old ${subject} ${track}`);
    assert.ok(listed.some(t=>t.id===correctIds[subject+'|'+track]),`counselor lost correct ${subject} ${track}`);
   }
  }
  const geoSkills=await db.query("select public.planner_list_topics('1405','humanities','11','final_exam','جغرافیا ۲','درس ۱۰') v");
  assert.ok(geoSkills.rows[0].v.some(t=>t.title==='مهارت نقشه مرزهای ایران و همسایگان'),'counselor lost an unrelated row');
  // Super-admin (bank manager): the old rows are STILL listed, with revision 3,
  // so they can still be edited and deleted through the manager UI.
  await asRole(db,'admin','true','true');
  for(const [subject,chapter] of [['جامعه‌شناسی ۲','درس ۱۴'],['جغرافیا ۲','درس ۲']]){
   for(const track of ['konkur','final_exam']){
    const listed=await list(db,subject,chapter,track);
    const row=listed.find(t=>t.id===oldIds[subject+'|'+track]);
    assert.ok(row,`admin lost old ${subject} ${track}`);
    assert.equal(row.revision,'3');
    assert.ok(listed.some(t=>t.id===correctIds[subject+'|'+track]),`admin lost correct ${subject} ${track}`);
   }
  }
  // Student role is still rejected (role checks preserved).
  await asRole(db,'student','false','false');
  await assert.rejects(db.query("select public.planner_list_topics('1405','humanities','11','konkur','جغرافیا ۲','درس ۲')"),/required/,'student list not rejected');
  // Old plans referencing the old ids still read back: the rows still exist,
  // resolve by id with the same title/pages the plan snapshot stores, and
  // the admin list returns them. (Plans render their stored snapshot; no
  // bank lookup happens at plan read time.)
  await asRole(db,'admin','true','true');
  const storedPlans=[
   {bankId:oldIds['جامعه‌شناسی ۲|konkur'],title:'انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم',pageStart:120,pageEnd:123},
   {bankId:oldIds['جغرافیا ۲|final_exam'],title:'کانون و مرزهای ناحیه',pageStart:15,pageEnd:17}];
  for(const plan of storedPlans){
   const row=(await byId(db,plan.bankId))[0];
   assert.ok(row,`plan ref ${plan.bankId} no longer resolvable`);
   assert.equal(row.title,plan.title);
   assert.deepEqual([row.page_start,row.page_end],[plan.pageStart,plan.pageEnd]);
   const listed=await list(db,row.subject,row.chapter,row.preparation_track);
   assert.ok(listed.some(t=>t.id===plan.bankId),`plan ref ${plan.bankId} missing from admin list`);
  }
  // Re-running migration 245 is a no-op.
  await db.exec(migration245);
  assert.deepEqual(await bank(db),after);
  // Simulated super-admin edit of a HIDDEN row survives a re-run, keeps the
  // row hidden, and stays editable afterwards.
  const edit=(await db.query('select id,revision::text r from private.planner_topic_bank where id=$1',[oldIds['جغرافیا ۲|final_exam']])).rows[0];
  await db.query("select public.planner_save_topic($1,$2,'1405','humanities','11','final_exam','جغرافیا ۲','درس ۲','ویرایش مدیر: کانون و مرز ناحیه',15,17,3)",[edit.id,edit.r]);
  assert.deepEqual(await byId(db,oldIds['جغرافیا ۲|final_exam']),[{edition:'1405',study_field:'humanities',grade:'11',preparation_track:'final_exam',subject:'جغرافیا ۲',chapter:'درس ۲',title:'ویرایش مدیر: کانون و مرز ناحیه',page_start:15,page_end:17,position:3,revision:4,hidden_from_selection:true}]);
  await asRole(db,'counselor','false','true');
  assert.ok(!(await list(db,'جغرافیا ۲','درس ۲','final_exam')).some(t=>t.id===oldIds['جغرافیا ۲|final_exam']),'edited hidden row leaked to counselor list');
  await asRole(db,'admin','true','true');
  assert.ok((await list(db,'جغرافیا ۲','درس ۲','final_exam')).some(t=>t.id===oldIds['جغرافیا ۲|final_exam']&&t.title==='ویرایش مدیر: کانون و مرز ناحیه'),'edited hidden row missing from admin list');
  const current=await bank(db);
  await db.exec(migration245);
  assert.deepEqual(await bank(db),current);
  // Simulated super-admin delete of a HIDDEN row is NOT resurrected by a re-run.
  const del=(await db.query('select id,revision::text r from private.planner_topic_bank where id=$1',[oldIds['جامعه‌شناسی ۲|konkur']])).rows[0];
  await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
  const afterDelete=await bank(db);
  await db.exec(migration245);
  assert.deepEqual(await bank(db),afterDelete);
  assert.deepEqual(await byId(db,oldIds['جامعه‌شناسی ۲|konkur']),[]);
  // A brand-new admin-created row defaults to visible and is listed to counselors.
  const created=(await db.query("select public.planner_save_topic(null,null,'1405','humanities','11','konkur','جغرافیا ۲','درس ۲','مبحث تازهٔ مدیر',20,21,999)")).rows[0];
  assert.equal((await byId(db,created.planner_save_topic.id))[0].hidden_from_selection,false);
  await asRole(db,'counselor','false','true');
  assert.ok((await list(db,'جغرافیا ۲','درس ۲','konkur')).some(t=>t.id===created.planner_save_topic.id),'new admin row not listed to counselor');
  assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 }finally{await db.close();}
 // --- Guard instance A: admin edit/delete BEFORE 241 block both the move and the hide. ---
 const g=await fresh();
 try{
  const edit=(await g.query('select id,revision::text r from private.planner_topic_bank where id=$1',[oldIds['جامعه‌شناسی ۲|konkur']])).rows[0];
  await g.query("select public.planner_save_topic($1,$2,'1405','humanities','11','konkur','جامعه‌شناسی ۲','درس ۱۵','ویرایش مدیر پیش از اصلاح',null,null,1)",[edit.id,edit.r]);
  const del=(await g.query('select id,revision::text r from private.planner_topic_bank where id=$1',[oldIds['جغرافیا ۲|final_exam']])).rows[0];
  await g.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
  await g.exec(migration241);
  await g.exec(migration245);
  // Edited row untouched by either migration: still درس ۱۵, NULL pages, revision 2, VISIBLE.
  assert.deepEqual(await byId(g,oldIds['جامعه‌شناسی ۲|konkur']),[{edition:'1405',study_field:'humanities',grade:'11',preparation_track:'konkur',subject:'جامعه‌شناسی ۲',chapter:'درس ۱۵',title:'ویرایش مدیر پیش از اصلاح',page_start:null,page_end:null,position:1,revision:2,hidden_from_selection:false}]);
  await asRole(g,'counselor','false','true');
  assert.ok((await list(g,'جامعه‌شناسی ۲','درس ۱۵','konkur')).some(t=>t.id===oldIds['جامعه‌شناسی ۲|konkur']),'admin-edited row wrongly hidden from counselor list');
  // Deleted row NOT resurrected.
  assert.deepEqual(await byId(g,oldIds['جغرافیا ۲|final_exam']),[]);
  // The two pristine rows still moved and hidden.
  await asRole(g,'admin','true','true');
  assert.deepEqual((await byId(g,oldIds['جامعه‌شناسی ۲|final_exam']))[0].chapter,'درس ۱۴');
  assert.equal((await byId(g,oldIds['جامعه‌شناسی ۲|final_exam']))[0].revision,3);
  assert.equal((await byId(g,oldIds['جامعه‌شناسی ۲|final_exam']))[0].hidden_from_selection,true);
  assert.deepEqual((await byId(g,oldIds['جغرافیا ۲|konkur']))[0].chapter,'درس ۲');
  assert.equal((await byId(g,oldIds['جغرافیا ۲|konkur']))[0].revision,3);
  assert.equal((await byId(g,oldIds['جغرافیا ۲|konkur']))[0].hidden_from_selection,true);
 }finally{await g.close();}
 // --- Guard instance B: admin edit BETWEEN 241 and 245 blocks the hide for that row only. ---
 const h=await fresh();
 try{
  await h.exec(migration241);
  const edit=(await h.query('select id,revision::text r from private.planner_topic_bank where id=$1',[oldIds['جغرافیا ۲|konkur']])).rows[0];
  await h.query("select public.planner_save_topic($1,$2,'1405','humanities','11','konkur','جغرافیا ۲','درس ۲','ویرایش مدیر پس از جابه‌جایی',15,17,3)",[edit.id,edit.r]);
  await h.exec(migration245);
  // Edited row: moved, but NOT hidden (revision 3, admin title preserved).
  assert.deepEqual(await byId(h,oldIds['جغرافیا ۲|konkur']),[{edition:'1405',study_field:'humanities',grade:'11',preparation_track:'konkur',subject:'جغرافیا ۲',chapter:'درس ۲',title:'ویرایش مدیر پس از جابه‌جایی',page_start:15,page_end:17,position:3,revision:3,hidden_from_selection:false}]);
  await asRole(h,'counselor','false','true');
  assert.ok((await list(h,'جغرافیا ۲','درس ۲','konkur')).some(t=>t.id===oldIds['جغرافیا ۲|konkur']),'admin-edited moved row wrongly hidden from counselor list');
  // The other three moved rows are hidden.
  for(const id of [oldIds['جامعه‌شناسی ۲|konkur'],oldIds['جامعه‌شناسی ۲|final_exam'],oldIds['جغرافیا ۲|final_exam']]){
   const r=(await byId(h,id))[0];
   assert.equal(r.hidden_from_selection,true,`row ${id} not hidden`);
   assert.equal(r.revision,3);
  }
  // Re-running 245 here is also a no-op.
  const settled=await bank(h);
  await h.exec(migration245);
  assert.deepEqual(await bank(h),settled);
 }finally{await h.close();}
 console.log('PASS: Phase 3 item 1: 4 moved rows kept (same ids) and hidden from the counselor new-selection list only; super-admin list still shows them (editable/deletable); old plan refs resolve by id; re-run no-op; admin edit survives and keeps the flag; admin delete not resurrected; admin-edited rows (before 241 or between 241 and 245) stay visible');
})().catch(e=>{console.error(e);process.exitCode=1});
