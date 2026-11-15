const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
(async()=>{const db=new PGlite();try{
 await db.exec(`create schema private;create table private.planner_topic_bank(id uuid primary key,edition text not null,study_field text not null,grade text not null,preparation_track text not null,subject text not null,chapter text not null,title text not null,page_start int,page_end int,position int not null,revision bigint not null default 1,updated_at timestamptz not null default now(),check((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));create table published_snapshot(id int primary key,content jsonb);insert into published_snapshot values (1,'{"pageStart":null,"pageEnd":null}'::jsonb);`);
 const names=['154_planner_shared_school_topics','155_planner_shared_school_detail','156_planner_shared_school_more_details','157_planner_verified_shared_pages','158_planner_verified_shared_subtopic_pages','159_planner_entrepreneurship_section_pages','160_planner_entrepreneurship_1405_pages'];
 const files=names.map(n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8'));for(const f of files.slice(0,-1))await db.exec(f);
 const data=JSON.parse(files.at(-1).split('$pages$')[1]);const added=JSON.parse(files.at(-1).split('$new$')[1]);assert.equal(data.length,70);assert.equal(added.length,5);
 const subject='کارگاه کارآفرینی و تولید';
 const before=(await db.query(`select id from private.planner_topic_bank where study_field='humanities' and subject=$1 and title='بخش ۶: تیپ‌های شخصیتی'`,[subject])).rows[0];
 await db.query(`update private.planner_topic_bank set revision=2,page_start=22,page_end=23 where id=$1`,[before.id]);
 const moved=(await db.query(`select id from private.planner_topic_bank where study_field='mathematics' and subject=$1 and title='بخش ۱۳: روش طوفان فکری'`,[subject])).rows[0];
 await db.query(`update private.planner_topic_bank set chapter='انتقال مدیر' where id=$1`,[moved.id]);
 await db.exec(files.at(-1));
 for(const field of ['humanities','mathematics','experimental_sciences']){
  for(const p of data){
   const r=(await db.query(`select id,page_start,page_end,revision::int revision from private.planner_topic_bank where study_field=$1 and grade='10' and subject=$2 and title=$3`,[field,subject,p.title])).rows[0];assert.ok(r,p.title);
   if(r.id===before.id)assert.deepEqual([r.page_start,r.page_end,r.revision],[22,23,2]);
   else if(r.id===moved.id)assert.deepEqual([r.page_start,r.page_end,r.revision],[null,null,1]);
   else assert.deepEqual([r.page_start,r.page_end,r.revision],[p.start,p.end,2],p.title);
  }
  for(const p of added){let r=(await db.query(`select page_start,page_end from private.planner_topic_bank where study_field=$1 and subject=$2 and title=$3`,[field,subject,p.title])).rows[0];assert.deepEqual([r.page_start,r.page_end],[p.start,p.end]);}
  const all=(await db.query(`select count(*)::int n,count(*) filter(where page_start is null)::int missing from private.planner_topic_bank where study_field=$1 and grade='10' and subject=$2 and preparation_track='final_exam'`,[field,subject])).rows[0];assert.equal(all.n,118);assert.equal(all.missing,field==='mathematics'?1:0);
  const sections=(await db.query(`select title,page_start,page_end from private.planner_topic_bank where study_field=$1 and grade='10' and subject=$2 and position<100`,[field,subject])).rows;
  const boundaries=[1,5,9,13,17,21,27,31,35,41,47,51,55,59,65,69,75,79,81,85,89,91,93,97,99,101,103,105,109,115,119,123,128];
  assert.equal(sections.length,32);
  for(let i=1;i<=32;i++){const num=String(i).replace(/[0-9]/g,c=>'۰۱۲۳۴۵۶۷۸۹'[Number(c)]);const r=sections.find(x=>x.title.startsWith(`بخش ${num}:`));assert.ok(r,`section ${i}`);assert.deepEqual([r.page_start,r.page_end],[boundaries[i-1],boundaries[i]-1],r.title);}

 }
 const unchanged=(await db.query(`select jsonb_agg(to_jsonb(t) order by id) rows from private.planner_topic_bank t`)).rows[0].rows;
 for(const f of files)await db.exec(f);
 assert.deepEqual((await db.query(`select jsonb_agg(to_jsonb(t) order by id) rows from private.planner_topic_bank t`)).rows[0].rows,unchanged);
 assert.deepEqual((await db.query('select content from published_snapshot where id=1')).rows[0].content,{pageStart:null,pageEnd:null});
 console.log('PASS: 210 page updates and 15 new topics; three 118-topic contexts, CAS, moves, snapshot, rerun');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
