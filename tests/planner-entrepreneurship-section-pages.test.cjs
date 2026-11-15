const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
(async()=>{const db=new PGlite();try{
 await db.exec(`create schema private;create table private.planner_topic_bank(id uuid primary key,edition text not null,study_field text not null,grade text not null,preparation_track text not null,subject text not null,chapter text not null,title text not null,page_start int,page_end int,position int not null,revision bigint not null default 1,updated_at timestamptz not null default now(),check((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));create table published_snapshot(id int primary key,content jsonb);insert into published_snapshot values (1,'{"pageStart":null,"pageEnd":null}'::jsonb);`);
 const files=['154_planner_shared_school_topics','155_planner_shared_school_detail','156_planner_shared_school_more_details','157_planner_verified_shared_pages','158_planner_verified_shared_subtopic_pages','159_planner_entrepreneurship_section_pages'].map(n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8'));
 for(const f of files.slice(0,-1))await db.exec(f);
 const data=JSON.parse(files.at(-1).split('$pages$')[1]);assert.equal(data.length,12);
 const row=(await db.query(`select id from private.planner_topic_bank where study_field='humanities' and subject='کارگاه کارآفرینی و تولید' and title='بخش ۶: خودشناسی'`)).rows[0];
 await db.query(`update private.planner_topic_bank set revision=2,page_start=22,page_end=25 where id=$1`,[row.id]);
 await db.exec(files.at(-1));
 for(const p of data)for(const field of ['humanities','mathematics','experimental_sciences']){
  const r=(await db.query(`select id,page_start,page_end,revision::int revision from private.planner_topic_bank where study_field=$1 and grade='10' and subject='کارگاه کارآفرینی و تولید' and chapter=$2 and title=$3 and position=$4`,[field,p.chapter,p.title,p.position])).rows[0];assert.ok(r);
  assert.deepEqual([r.page_start,r.page_end,r.revision],r.id===row.id?[22,25,2]:[p.page_start,p.page_end,2]);
 }
 for(const f of files)await db.exec(f);
 assert.deepEqual((await db.query('select page_start,page_end,revision::int revision from private.planner_topic_bank where id=$1',[row.id])).rows[0],{page_start:22,page_end:25,revision:2});
 assert.deepEqual((await db.query('select content from published_snapshot where id=1')).rows[0].content,{pageStart:null,pageEnd:null});
 assert.equal((await db.query(`select count(*)::int n from private.planner_topic_bank`)).rows[0].n,862);
 console.log('PASS: 36 whole-section ranges, preserve administrator edits, published snapshots and rerun');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
