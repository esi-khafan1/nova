// Supplemental seeds must be additive, context-limited and safe to repeat after edits.
const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
(async()=>{const db=new PGlite();try{
 await db.exec(`create schema private; create table private.planner_topic_bank(id uuid primary key,edition text,study_field text,grade text,preparation_track text,subject text,chapter text,title text,page_start int,page_end int,position int,revision int default 1)`);
 const old=fs.readFileSync('supabase/migrations/154_planner_shared_school_topics.sql','utf8'),extra=fs.readFileSync('supabase/migrations/155_planner_shared_school_detail.sql','utf8');
 await db.exec(old);await db.exec(extra);
 assert.equal((await db.query('select count(*)::int n from private.planner_topic_bank')).rows[0].n,544);
 for(const field of ['mathematics','experimental_sciences','humanities']){
  const rows=(await db.query("select title from private.planner_topic_bank where subject='آمادگی دفاعی' and study_field=$1 and position>=100",[field])).rows;
  for(let i=1;i<=13;i++)assert.ok(rows.some(x=>x.title.startsWith(`درس ${String(i).replace(/[0-9]/g,x=>'۰۱۲۳۴۵۶۷۸۹'[x])}:`)),`${field} lesson ${i}`);
 }
 for(const field of ['mathematics','experimental_sciences']){
  const rows=(await db.query("select chapter,page_start,page_end from private.planner_topic_bank where subject='تعلیمات دینی ۲' and study_field=$1 and title='کل درس' order by page_start nulls last",[field])).rows;
  assert.equal(rows.length,12);assert.deepEqual([rows[0].page_start,rows[0].page_end],[12,21]);assert.deepEqual([rows.at(-1).page_start,rows.at(-1).page_end],[null,null]);
 }
 const newrow=(await db.query("select id from private.planner_topic_bank where subject='آمادگی دفاعی' and position>=100 limit 1")).rows[0];
 const oldrow=(await db.query("select id from private.planner_topic_bank where subject='کارگاه کارآفرینی و تولید' and position<100 limit 1")).rows[0];
 await db.query("update private.planner_topic_bank set title='ویرایش مدیر',revision=2 where id in ($1,$2)",[newrow.id,oldrow.id]);
 await db.exec(old);await db.exec(extra);
 assert.equal((await db.query('select count(*)::int n from private.planner_topic_bank')).rows[0].n,544);
 assert.equal((await db.query("select count(*)::int n from private.planner_topic_bank where title='ویرایش مدیر' and revision=2")).rows[0].n,2);
 assert.equal((await db.query("select count(*)::int n from private.planner_topic_bank where position>=100 and preparation_track<>'final_exam'")).rows[0].n,0);
 console.log('PASS: 273 additive rows, coverage, 1405 lesson pages, rerun and edits');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
