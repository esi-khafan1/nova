const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
(async()=>{const db=new PGlite();try{
 await db.exec(`create schema private; create table private.planner_topic_bank(id uuid primary key,edition text not null,study_field text not null,grade text not null,preparation_track text not null,subject text not null,chapter text not null,title text not null,page_start integer,page_end integer,position integer not null,revision bigint not null default 1,updated_at timestamptz not null default now(),check ((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));`);
 const files=['154_planner_shared_school_topics','155_planner_shared_school_detail','156_planner_shared_school_more_details','157_planner_verified_shared_pages'].map(sql);
 for(const f of files.slice(0,3))await db.exec(f);
 // Different admin changes are never overwritten, even if their pages are null.
 let edited=(await db.query(`select id from private.planner_topic_bank where subject='کارگاه کارآفرینی و تولید' and study_field='humanities' and title like 'بخش ۱:%' and position=1`)).rows[0].id;
 await db.query(`update private.planner_topic_bank set title='ویرایش ادمین',revision=2 where id=$1`,[edited]);
 let moved=(await db.query(`select id from private.planner_topic_bank where subject='کارگاه کارآفرینی و تولید' and study_field='humanities' and title like 'بخش ۲:%' and position=2`)).rows[0].id;
 await db.query(`update private.planner_topic_bank set chapter='فصل منتقل‌شده' where id=$1`,[moved]);
 await db.exec(files[3]);
 assert.equal((await db.query('select count(*)::int n from private.planner_topic_bank')).rows[0].n,862);
 assert.deepEqual((await db.query('select title,page_start,page_end,revision::int revision from private.planner_topic_bank where id=$1',[edited])).rows[0],{title:'ویرایش ادمین',page_start:null,page_end:null,revision:2});
 assert.equal((await db.query('select page_start from private.planner_topic_bank where id=$1',[moved])).rows[0].page_start,null);
 for(const field of ['mathematics','experimental_sciences','humanities']){
  const rows=(await db.query(`select title,page_start,page_end,revision::int revision from private.planner_topic_bank where subject='کارگاه کارآفرینی و تولید' and study_field=$1 and revision=2 and page_start is not null and position<6 order by page_start`,[field])).rows;
  assert.deepEqual(rows.map(x=>[x.page_start,x.page_end]),field==='humanities'?[[9,12],[13,16],[17,20]]:[[1,4],[5,8],[9,12],[13,16],[17,20]]);
 }
 for(const field of ['mathematics','experimental_sciences']){
  const rows=(await db.query(`select page_start,page_end,revision::int revision from private.planner_topic_bank where subject='علوم اجتماعی' and study_field=$1 and title='کل درس' order by page_start`,[field])).rows;
  assert.deepEqual(rows.map(x=>[x.page_start,x.page_end]),[[2,7],[8,16],[17,24],[25,33],[34,43],[44,52],[53,61],[62,71],[72,82],[83,91]]);
 }
 assert.equal((await db.query(`select count(*)::int n from (select edition,study_field,grade,preparation_track,subject,chapter,position from private.planner_topic_bank group by 1,2,3,4,5,6,7 having count(*)>1) duplicates`)).rows[0].n,0);
 const full=(await db.query(`select id from private.planner_topic_bank where subject='علوم اجتماعی' and title='کل درس' limit 1`)).rows[0].id;
 await db.query(`update private.planner_topic_bank set title='کل درس ویرایش‌شده',page_start=3,revision=revision+1 where id=$1`,[full]);
 for(const f of files)await db.exec(f);
 assert.equal((await db.query('select count(*)::int n from private.planner_topic_bank')).rows[0].n,862);
 assert.deepEqual((await db.query('select title,page_start,revision::int revision from private.planner_topic_bank where id=$1',[full])).rows[0],{title:'کل درس ویرایش‌شده',page_start:3,revision:2});
 assert.deepEqual((await db.query(`select page_start,page_end,revision::int revision from private.planner_topic_bank where subject='کارگاه کارآفرینی و تولید' and study_field='mathematics' and position=1 and chapter='بخش‌های ۱ تا ۴'`)).rows[0],{page_start:1,page_end:4,revision:2});
 console.log('PASS: 20 whole lessons, guarded sections, edit/move safety and reruns');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
