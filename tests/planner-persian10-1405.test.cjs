// No real database or users: exact legacy CAS, local seed, catalog and snapshots.
const fs=require('node:fs'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const {PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const text=fs.readFileSync('supabase/migrations/210_planner_persian10_1405.sql','utf8');
const topics=JSON.parse(text.split('$topics$')[1]),fixes=JSON.parse(text.split('$fixes$')[1]);
const code=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':process.cwd()}}).outputFiles[0].text;
const mod={exports:{}};new Function('module','exports','require',code)(mod,mod.exports,require);
const uuid=s=>{const v=crypto.createHash('md5').update(s).digest('hex');return `${v.slice(0,8)}-${v.slice(8,12)}-${v.slice(12,16)}-${v.slice(16,20)}-${v.slice(20)}`};
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;
 create table private.planner_seed_installations(seed_key text primary key);
 create table private.planner_topic_bank(id uuid primary key,edition text not null,study_field text not null,grade text not null,preparation_track text not null,subject text not null,chapter text not null,title text not null,page_start integer,page_end integer,position integer not null,revision bigint not null default 1,updated_at timestamptz not null default now(),check((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","exam":"e1","done":[true,false],"topics":[{"pageStart":15}]}');`);
 await db.exec(fs.readFileSync('supabase/migrations/134_planner_more_textbook_topics.sql','utf8'));
 const fields=['mathematics','experimental_sciences','humanities'];
 const id=(field,f)=>uuid(`nova:planner:1405:v1:${field}:10:final_exam:فارسی ۱:${f.chapter}:${f.position}`);
 const edited=id(fields[0],fixes[0]),deleted=id(fields[0],fixes[1]);
 await db.query("update private.planner_topic_bank set title='ویرایش مدیر',page_start=7,page_end=8,revision=2 where id=$1",[edited]);
 const beforeEdit=(await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1',[edited])).rows[0].v;
 await db.query('delete from private.planner_topic_bank where id=$1',[deleted]);
 await db.exec(text);
 assert.equal(topics.length,126);assert.equal(fixes.length,18);
 for(const field of fields){
  const book=mod.exports.curriculumBooks(field,10,'final_exam').find(x=>x.subject==='فارسی ۱');assert.ok(book);
  const chapters=(await db.query("select distinct chapter from private.planner_topic_bank where study_field=$1 and subject='فارسی ۱' and grade='10' and preparation_track='final_exam'",[field])).rows.map(x=>x.chapter);assert.deepEqual(new Set(topics.map(p=>p.chapter)),new Set(chapters));
  for(const p of topics){assert.ok(p.start>0&&p.end>=p.start&&p.title.length<=160);const got=(await db.query(`select title,page_start,page_end from private.planner_topic_bank where edition='1405' and study_field=$1 and grade='10' and preparation_track='final_exam' and subject='فارسی ۱' and chapter=$2 and position=$3`,[field,p.chapter,p.position])).rows;assert.deepEqual(got,[{title:p.title,page_start:p.start,page_end:p.end}]);}
  for(const f of fixes){const found=(await db.query('select page_start,page_end,revision from private.planner_topic_bank where id=$1',[id(field,f)])).rows;if(id(field,f)===edited){assert.deepEqual((await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1',[edited])).rows[0].v,beforeEdit);continue;}if(id(field,f)===deleted){assert.equal(found.length,0);continue;}assert.deepEqual(found,[{page_start:f.start,page_end:f.end,revision:2}]);}
 }
 for(const [title,start,end] of [['درس ۱: چشمه — قلمرو ادبی',15,16],['درس ۴: آزاد — کارگاه متن‌پژوهی',38,38],['روان‌خوانی: دیوار',21,27],['درس ۱۷: سپیده‌دم — قلمرو فکری',139,140],['روان‌خوانی: سه پرسش',146,150],['واژه‌نامه',153,163]]){const p=topics.find(t=>t.title===title);assert.ok(p,title);assert.deepEqual([p.start,p.end],[start,end]);}
 const newId=(await db.query("select id from private.planner_topic_bank where subject='فارسی ۱' and position>=300 order by id limit 2")).rows;
 await db.query('delete from private.planner_topic_bank where id=$1',[newId[0].id]);await db.query("update private.planner_topic_bank set title='ویرایش تازه',revision=2 where id=$1",[newId[1].id]);
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(text);assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,before);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',exam:'e1',done:[true,false],topics:[{pageStart:15}]});
 console.log('PASS: Persian 10: 3 real catalog contexts, 378 new rows, 54 guarded legacy ranges, edits/deletions, rerun and simulated snapshot');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
