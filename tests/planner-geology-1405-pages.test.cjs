const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
(async()=>{const db=new PGlite();try{
 await db.exec(`create schema private;create table private.planner_topic_bank(id uuid primary key,edition text not null,study_field text not null,grade text not null,preparation_track text not null,subject text not null,chapter text not null,title text not null,page_start integer,page_end integer,position integer not null,revision bigint not null default 1,updated_at timestamptz not null default now(),check((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));create table published_snapshot(id integer,content jsonb);insert into published_snapshot values(1,'{"pageStart":3,"pageEnd":6,"checked":true,"examId":"exam-1"}');`);
 const seed=fs.readFileSync('supabase/migrations/152_planner_geology_history_topics.sql','utf8'), sql=fs.readFileSync('supabase/migrations/162_planner_geology_1405_pages.sql','utf8');await db.exec(seed);
 const rows=JSON.parse(sql.split('$pages$')[1]),chapters=JSON.parse(sql.split('$chapters$')[1]);assert.equal(rows.length,35);assert.equal(chapters.length,7);
 const get=async(field,track,chapter,position)=>(await db.query(`select * from private.planner_topic_bank where subject='زمین‌شناسی' and study_field=$1 and preparation_track=$2 and chapter=$3 and position=$4`,[field,track,chapter,position])).rows[0];
 const edit=await get('experimental_sciences','konkur',rows[0].chapter,1);await db.query(`update private.planner_topic_bank set title='ویرایش مدیر',page_start=5,page_end=8,revision=2 where id=$1`,[edit.id]);
 const moved=await get('mathematics','final_exam',rows[5].chapter,1);await db.query(`update private.planner_topic_bank set chapter='فصل مدیر' where id=$1`,[moved.id]);
 const removed=await get('experimental_sciences','final_exam',rows[6].chapter,2);await db.query(`delete from private.planner_topic_bank where id=$1`,[removed.id]);
 const other=(await db.query(`select jsonb_agg(to_jsonb(t) order by id) x from private.planner_topic_bank t where subject<>'زمین‌شناسی'`)).rows[0].x;
 await db.exec(sql);
 for(const [field,track] of [['experimental_sciences','konkur'],['experimental_sciences','final_exam'],['mathematics','final_exam']]){
  for(const p of rows){const r=await get(field,track,p.chapter,p.position);if(r?.id===edit.id){assert.deepEqual([r.title,r.page_start,r.page_end,Number(r.revision)],['ویرایش مدیر',5,8,2]);continue} if(field==='mathematics'&&p.chapter===rows[5].chapter&&p.position===1||field==='experimental_sciences'&&track==='final_exam'&&p.chapter===rows[6].chapter&&p.position===2){assert.equal(r,undefined);continue} assert.ok(r,p.title);assert.deepEqual([r.title,r.page_start,r.page_end,Number(r.revision)],[p.title,p.start,p.end,2]);}
  for(const p of chapters){const r=await get(field,track,p.chapter,p.position);assert.deepEqual([r.title,r.page_start,r.page_end],[p.title,p.start,p.end]);}
 }
 assert.deepEqual((await db.query(`select chapter,page_start,page_end from private.planner_topic_bank where study_field='experimental_sciences' and preparation_track='final_exam' and subject='زمین‌شناسی' and position=101 order by page_start`)).rows.map(x=>[x.page_start,x.page_end]),[[9,21],[23,39],[41,57],[59,75],[77,91],[93,107],[109,125]]);
 assert.equal((await db.query('select chapter from private.planner_topic_bank where id=$1',[moved.id])).rows[0].chapter,'فصل مدیر');
 assert.deepEqual((await db.query(`select jsonb_agg(to_jsonb(t) order by id) x from private.planner_topic_bank t where subject<>'زمین‌شناسی'`)).rows[0].x,other);
 const before=(await db.query(`select jsonb_agg(to_jsonb(t) order by id) x from private.planner_topic_bank t`)).rows[0].x;await db.exec(sql);assert.deepEqual((await db.query(`select jsonb_agg(to_jsonb(t) order by id) x from private.planner_topic_bank t`)).rows[0].x,before);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{pageStart:3,pageEnd:6,checked:true,examId:'exam-1'});
 console.log('PASS: 35 subtopics and 7 whole chapters in 3 contexts; CAS, moves, deletions, snapshots, rerun');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
