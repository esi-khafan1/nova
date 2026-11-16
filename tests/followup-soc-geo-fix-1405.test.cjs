const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('241_planner_followup_soc_geo_fix_1405');
// Old v1 rows (ids pinned: md5('nova:planner:1405:v1:humanities:11:<track>:<subject>:<chapter>:<position>')).
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
const bank=async db=>(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
const byId=async (db,id)=>(await db.query('select edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position,revision from private.planner_topic_bank where id=$1',[id])).rows;
async function fresh(){
 const db=new PGlite();
 await db.exec(preamble);
 for(const n of deps)await db.exec(sql(n));
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 return db;
}
(async()=>{
 // --- Main instance: clean dependency state, then migration 241. ---
 const db=await fresh();
 try{
  // Pre-state: the four old rows exist, NULL pages, revision 1, in the wrong lessons.
  for(const [key,id] of Object.entries(oldIds)){
   const [subject,track]=key.split('|');
   const oldChapter=subject==='جامعه‌شناسی ۲'?'درس ۱۵':'درس ۱',oldPos=subject==='جامعه‌شناسی ۲'?1:3;
   const oldTitle=subject==='جامعه‌شناسی ۲'?'انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم':'کانون و مرزهای ناحیه';
   assert.deepEqual(await byId(db,id),[{edition:'1405',study_field:'humanities',grade:'11',preparation_track:track,subject,chapter:oldChapter,title:oldTitle,page_start:null,page_end:null,position:oldPos,revision:1}],`pre-state ${key}`);
  }
  // Pre-state: the correct rows already exist, paged, revision 1.
  for(const [key,id] of Object.entries(correctIds)){
   const [subject,track]=key.split('|');
   const r=(await byId(db,id))[0];
   assert.ok(r,`correct row missing ${key}`);
   assert.equal(r.revision,1);
   if(subject==='جامعه‌شناسی ۲'){assert.deepEqual([r.chapter,r.title,r.page_start,r.page_end,r.position],['درس ۱۴','مقایسه انقلاب اسلامی و انقلاب‌های آزادی‌بخش',120,123,453]);}
   else{assert.deepEqual([r.chapter,r.title,r.page_start,r.page_end,r.position],['درس ۲','کانون و مرز ناحیه',15,18,303]);}
  }
  const before=await bank(db),beforeCount=before.length;
  await db.exec(migration);
  // Moved rows keep their ids, with the new chapter/pages and revision 2.
  for(const [key,id] of Object.entries(oldIds)){
   const [subject,track]=key.split('|');
   const newChapter=subject==='جامعه‌شناسی ۲'?'درس ۱۴':'درس ۲',start=subject==='جامعه‌شناسی ۲'?120:15,end=subject==='جامعه‌شناسی ۲'?123:17;
   assert.deepEqual(await byId(db,id),[{edition:'1405',study_field:'humanities',grade:'11',preparation_track:track,subject,chapter:newChapter,title:subject==='جامعه‌شناسی ۲'?'انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم':'کانون و مرزهای ناحیه',page_start:start,page_end:end,position:subject==='جامعه‌شناسی ۲'?1:3,revision:2}],`moved ${key}`);
  }
  // No row added or removed; exactly the four old rows changed; correct rows untouched.
  const after=await bank(db);
  assert.equal(after.length,beforeCount);
  assert.deepEqual(after.map(a=>a.id).sort(),before.map(b=>b.id).sort());
  const changed=after.filter(a=>{const b=before.find(x=>x.id===a.id);return b&&JSON.stringify(b)!==JSON.stringify(a)});
  assert.equal(changed.length,4);
  assert.ok(changed.every(a=>Object.values(oldIds).includes(a.id)&&a.revision===2&&a.page_start!==null));
  for(const [key,id] of Object.entries(correctIds)){
   const [subject,track]=key.split('|');
   const exp=subject==='جامعه‌شناسی ۲'
    ?{edition:'1405',study_field:'humanities',grade:'11',preparation_track:track,subject,chapter:'درس ۱۴',title:'مقایسه انقلاب اسلامی و انقلاب‌های آزادی‌بخش',page_start:120,page_end:123,position:453,revision:1}
    :{edition:'1405',study_field:'humanities',grade:'11',preparation_track:track,subject,chapter:'درس ۲',title:'کانون و مرز ناحیه',page_start:15,page_end:18,position:303,revision:1};
   assert.deepEqual(await byId(db,id),[exp],`correct row changed ${key}`);
  }
  // A simulated plan reference to an old id still resolves: planner_list_topics
  // returns the same id under the NEW chapter, and no longer under the old one.
  for(const [subject,newChapter,oldChapter] of [['جامعه‌شناسی ۲','درس ۱۴','درس ۱۵'],['جغرافیا ۲','درس ۲','درس ۱']]){
   for(const track of ['konkur','final_exam']){
    const listed=await db.query('select public.planner_list_topics($1,$2,$3,$4,$5,$6) v',['1405','humanities','11',track,subject,newChapter]);
    const ids=listed.rows[0].v.map(t=>t.id);
    assert.ok(ids.includes(oldIds[subject+'|'+track]),`plan ref ${subject} ${track} missing under ${newChapter}`);
    const moved=listed.rows[0].v.find(t=>t.id===oldIds[subject+'|'+track]);
    assert.equal(moved.pageStart,subject==='جامعه‌شناسی ۲'?120:15);
    assert.equal(moved.pageEnd,subject==='جامعه‌شناسی ۲'?123:17);
    assert.equal(moved.revision,'2');
    const oldListed=await db.query('select public.planner_list_topics($1,$2,$3,$4,$5,$6) v',['1405','humanities','11',track,subject,oldChapter]);
    assert.ok(!oldListed.rows[0].v.some(t=>t.id===oldIds[subject+'|'+track]),`plan ref ${subject} ${track} still under ${oldChapter}`);
   }
  }
  // Re-running is a no-op.
  await db.exec(migration);
  assert.deepEqual(await bank(db),after);
  // Simulated super-admin edit of a moved row survives a re-run.
  const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where id=$1",[oldIds['جغرافیا ۲|final_exam']])).rows[0];
  await db.query("select public.planner_save_topic($1,$2,'1405','humanities','11','final_exam','جغرافیا ۲','درس ۲','ویرایش مدیر: کانون و مرز ناحیه',15,17,3)",[edit.id,edit.r]);
  // Simulated super-admin delete of a moved row is NOT resurrected by a re-run.
  const del=(await db.query("select id,revision::text r from private.planner_topic_bank where id=$1",[oldIds['جامعه‌شناسی ۲|konkur']])).rows[0];
  await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
  const current=await bank(db);
  await db.exec(migration);
  assert.deepEqual(await bank(db),current);
  assert.deepEqual(await byId(db,oldIds['جغرافیا ۲|final_exam']),[{edition:'1405',study_field:'humanities',grade:'11',preparation_track:'final_exam',subject:'جغرافیا ۲',chapter:'درس ۲',title:'ویرایش مدیر: کانون و مرز ناحیه',page_start:15,page_end:17,position:3,revision:3}]);
  assert.deepEqual(await byId(db,oldIds['جامعه‌شناسی ۲|konkur']),[]);
  assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 }finally{await db.close();}
 // --- Guard instance: a row that no longer matches the guard is left alone. ---
 const g=await fresh();
 try{
  // Admin edits one old row and deletes another BEFORE migration 241 runs.
  const edit=(await g.query("select id,revision::text r from private.planner_topic_bank where id=$1",[oldIds['جامعه‌شناسی ۲|konkur']])).rows[0];
  await g.query("select public.planner_save_topic($1,$2,'1405','humanities','11','konkur','جامعه‌شناسی ۲','درس ۱۵','ویرایش مدیر پیش از اصلاح',null,null,1)",[edit.id,edit.r]);
  const del=(await g.query("select id,revision::text r from private.planner_topic_bank where id=$1",[oldIds['جغرافیا ۲|final_exam']])).rows[0];
  await g.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
  await g.exec(migration);
  // Edited row untouched (still درس ۱۵, NULL pages, revision 2, admin title).
  assert.deepEqual(await byId(g,oldIds['جامعه‌شناسی ۲|konkur']),[{edition:'1405',study_field:'humanities',grade:'11',preparation_track:'konkur',subject:'جامعه‌شناسی ۲',chapter:'درس ۱۵',title:'ویرایش مدیر پیش از اصلاح',page_start:null,page_end:null,position:1,revision:2}]);
  // Deleted row NOT resurrected.
  assert.deepEqual(await byId(g,oldIds['جغرافیا ۲|final_exam']),[]);
  // The two pristine rows still moved.
  assert.deepEqual((await byId(g,oldIds['جامعه‌شناسی ۲|final_exam']))[0].chapter,'درس ۱۴');
  assert.deepEqual((await byId(g,oldIds['جغرافیا ۲|konkur']))[0].chapter,'درس ۲');
  assert.equal((await byId(g,oldIds['جامعه‌شناسی ۲|final_exam']))[0].revision,2);
  assert.equal((await byId(g,oldIds['جغرافیا ۲|konkur']))[0].revision,2);
 }finally{await g.close();}
 console.log('PASS: Follow-up 2: 4 old rows moved in place (same ids, revision 2); plan refs resolve under new chapters; correct rows untouched; re-run no-op; admin edit survives; admin delete not resurrected; non-matching rows left alone');
})().catch(e=>{console.error(e);process.exitCode=1});
