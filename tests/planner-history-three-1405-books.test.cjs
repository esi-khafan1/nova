const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
(async()=>{const db=new PGlite();try{
 await db.exec(`create schema private;create table private.planner_topic_bank(id uuid primary key,edition text not null,study_field text not null,grade text not null,preparation_track text not null,subject text not null,chapter text not null,title text not null,page_start int,page_end int,position int not null,revision bigint not null default 1,updated_at timestamptz not null default now(),check((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));create table published_snapshot(content jsonb);insert into published_snapshot values ('{"item":{"pageStart":62,"pageEnd":69,"done":true,"examId":"exam-1"}}');`);
 const seed=fs.readFileSync('supabase/migrations/152_planner_geology_history_topics.sql','utf8'),files=['164_planner_history10_1405_topics','165_planner_history11_1405_topics','166_planner_contemporary_history_1405_topics'].map(s=>fs.readFileSync(`supabase/migrations/${s}.sql`,'utf8'));await db.exec(seed);
 const get=async(subject,field,track,chapter,pos)=>(await db.query('select * from private.planner_topic_bank where subject=$1 and study_field=$2 and preparation_track=$3 and chapter=$4 and position=$5',[subject,field,track,chapter,pos])).rows[0];
 const e=await get('تاریخ ۱','humanities','konkur','درس ۷',1);await db.query('update private.planner_topic_bank set page_end=67,revision=2 where id=$1',[e.id]);
 const moved=await get('تاریخ معاصر ایران','mathematics','final_exam','درس ۱',1);await db.query("update private.planner_topic_bank set chapter='فصل مدیر' where id=$1",[moved.id]);
 const deleted=await get('تاریخ معاصر ایران','experimental_sciences','final_exam','درس ۲',1);await db.query('delete from private.planner_topic_bank where id=$1',[deleted.id]);
 const other=(await db.query("select jsonb_agg(to_jsonb(t) order by id) x from private.planner_topic_bank t where subject='زمین‌شناسی'")).rows[0].x;
 for(const sql of files)await db.exec(sql);
 for(const [i,subject,field,tracks] of [[0,'تاریخ ۱','humanities',['konkur','final_exam']],[1,'تاریخ ۲','humanities',['konkur','final_exam']],[2,'تاریخ معاصر ایران','mathematics',['final_exam']],[2,'تاریخ معاصر ایران','experimental_sciences',['final_exam']]]){
  const topics=JSON.parse(files[i].split('$topics$')[1]);assert.equal(topics.length,[46,49,76][i]);for(const track of tracks)for(const p of topics){const r=await get(subject,field,track,p.chapter,p.position);assert.ok(r,`${subject} ${p.chapter} ${p.title}`);assert.deepEqual([r.title,r.page_start,r.page_end],[p.title,p.start,p.end]);}
 }
 const seeds=JSON.parse(seed.split('$books$')[1]);
 for(const [idx,bookIndex] of [[0,2],[1,3],[2,4]]){
  const groups=JSON.parse(files[idx].split('$topics$')[1]);
  const lessons=idx===2?JSON.parse(files[idx].split('$lessons$')[1]):null;
  for(const [j,c] of seeds[bookIndex].chapters.entries()){
   let start=lessons?lessons[j].start:c.topics[0].start,end=lessons?lessons[j].end:c.topics[0].end;
   if(idx===0&&j===6)end=68;if(idx===0&&j===7)start=69;
   if(idx===0&&j===12){start=118;end=127}if(idx===0&&j===13){start=128;end=135}
   for(let page=start;page<=end;page++)assert.ok(groups.some(p=>p.chapter===c.chapter&&p.start<=page&&p.end>=page),`${c.chapter} page ${page} missing from study groupings`);
  }
 }
 for(const tr of ['konkur','final_exam']){const seven=await get('تاریخ ۱','humanities',tr,'درس ۷',1),eight=await get('تاریخ ۱','humanities',tr,'درس ۸',1),thirteen=await get('تاریخ ۱','humanities',tr,'درس ۱۳',1),fourteen=await get('تاریخ ۱','humanities',tr,'درس ۱۴',1);assert.equal(seven.page_end,tr==='konkur'?67:68);assert.deepEqual([eight.page_start,eight.page_end],[69,79]);assert.deepEqual([thirteen.page_start,thirteen.page_end],[118,127]);assert.deepEqual([fourteen.page_start,fourteen.page_end],[128,135]);}
 assert.equal((await db.query('select chapter from private.planner_topic_bank where id=$1',[moved.id])).rows[0].chapter,'فصل مدیر');assert.equal(await get('تاریخ معاصر ایران','experimental_sciences','final_exam','درس ۲',1),undefined);
 for(const field of ['mathematics','experimental_sciences'])for(const p of JSON.parse(files[2].split('$lessons$')[1])){const r=await get('تاریخ معاصر ایران',field,'final_exam',p.chapter,1);if((field==='mathematics'&&p.chapter==='درس ۱')||(field==='experimental_sciences'&&p.chapter==='درس ۲'))continue;assert.deepEqual([r.page_start,r.page_end],[p.start,p.end]);}
 const custom=await get('تاریخ ۲','humanities','konkur','درس ۱',101);await db.query("update private.planner_topic_bank set page_start=8,page_end=9,revision=revision+1 where id=$1",[custom.id]);
 assert.deepEqual((await db.query("select jsonb_agg(to_jsonb(t) order by id) x from private.planner_topic_bank t where subject='زمین‌شناسی'")).rows[0].x,other);
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) x from private.planner_topic_bank t')).rows[0].x;for(const sql of files)await db.exec(sql);assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) x from private.planner_topic_bank t')).rows[0].x,before);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{item:{pageStart:62,pageEnd:69,done:true,examId:'exam-1'}});console.log('PASS: 171 topic groups in 6 contexts, lesson fixes, CAS, moved/deleted rows, snapshots and rerun');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
