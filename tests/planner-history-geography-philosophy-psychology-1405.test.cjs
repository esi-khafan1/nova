const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict'),crypto=require('node:crypto');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const base=['137_planner_humanities_school_topics','138_planner_remaining_topics','141_planner_humanities_topics','145_planner_philosophy12_topics','148_planner_arabic_geography_topics','152_planner_geology_history_topics','166_planner_contemporary_history_1405_topics','167_planner_english9_1405_pages'];
const fresh=['179_planner_contemporary_history_independent_1405','180_planner_geography11_12_independent_1405','181_planner_philosophy11_12_1405_pages','182_planner_psychology11_1405_pages','183_planner_legacy_exact_1405_pages','184_planner_philosophy_psychology_legacy_1405_pages','185_planner_philosophy12_legacy_1405_pages','186_planner_geography_legacy_1405_pages'];
const uuid=s=>{let x=crypto.createHash('md5').update(s).digest('hex');return `${x.slice(0,8)}-${x.slice(8,12)}-${x.slice(12,16)}-${x.slice(16,20)}-${x.slice(20)}`};
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create table private.planner_topic_bank(id uuid primary key,edition text not null,study_field text not null,grade text not null,preparation_track text not null,subject text not null,chapter text not null,title text not null,page_start integer,page_end integer,position integer not null,revision bigint not null default 1,updated_at timestamptz not null default now(),check((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));create table published_snapshot(content jsonb);insert into published_snapshot values ('{"done":true,"examId":"exam-1","topics":[{"pageStart":6}]}');`);
 for(const f of base)await db.exec(sql(f));
 const fixes=[...JSON.parse(sql(fresh[4]).split('$fixes$')[1]),...JSON.parse(sql(fresh[5]).split('$fixes$')[1]),...JSON.parse(sql(fresh[6]).split('$fixes$')[1]),...JSON.parse(sql(fresh[7]).split('$fixes$')[1])];assert.equal(fixes.length,163);
 // Exercise edit/move and delete independently for each of the four CAS migrations.
 const ids=[],modified=[];
 for(const f of fresh.slice(4)){
  const sample=JSON.parse(sql(f).split('$fixes$')[1]).slice(0,2).map(p=>uuid(`nova:planner:1405:v1:humanities:${p.grade}:konkur:${p.subject}:${p.chapter}:${p.position}`));ids.push(...sample);
  await db.query("update private.planner_topic_bank set title='ویرایش مدیر',chapter='فصل مدیر',revision=2 where id=$1",[sample[0]]);
  modified.push([sample[0],(await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1',[sample[0]])).rows[0].v]);await db.query('delete from private.planner_topic_bank where id=$1',[sample[1]]);
 }
 for(const f of fresh)await db.exec(sql(f));for(const [id,old] of modified)assert.deepEqual((await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1',[id])).rows[0].v,old);for(const id of ids.filter((_,i)=>i%2===1))assert.equal((await db.query('select 1 from private.planner_topic_bank where id=$1',[id])).rows.length,0);
 let inserted=0;
 for(let i=0;i<4;i++){
  const items=JSON.parse(sql(fresh[i]).split('$topics$')[1]);assert.equal(items.length,[148,123,118,81][i]);let unique=new Set();
  for(const p of items){const grade=p.grade||'11',subject=p.subject||(i===0?'تاریخ معاصر ایران':'روان‌شناسی');const key=`${grade}|${subject}|${p.chapter}|${p.position}`;assert.ok(!unique.has(key),key);unique.add(key);
   const contexts=i===0?[['mathematics','final_exam'],['experimental_sciences','final_exam']]:[['humanities','konkur'],['humanities','final_exam']];
   for(const [field,track] of contexts){const rows=(await db.query('select title,page_start,page_end from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',['1405',field,grade,track,subject,p.chapter,p.position])).rows;assert.equal(rows.length,1,`${fresh[i]} ${key}`);assert.deepEqual([rows[0].title,rows[0].page_start,rows[0].page_end],[p.title,p.start,p.end]);assert.ok(p.start>0&&p.start<=p.end);inserted++;}
  }
 }
 assert.equal(inserted,940);
 for(const p of fixes)for(const track of ['konkur','final_exam']){const id=uuid(`nova:planner:1405:v1:humanities:${p.grade}:${track}:${p.subject}:${p.chapter}:${p.position}`);if(ids.includes(id))continue;const rows=(await db.query('select title,page_start,page_end,revision from private.planner_topic_bank where id=$1',[id])).rows;assert.equal(rows.length,1);assert.deepEqual([rows[0].title,rows[0].page_start,rows[0].page_end,Number(rows[0].revision)],[p.title,p.start,p.end,2]);}
 // In an unedited track, all original rows for five books have pages. The one
 // geography-11 legacy title filed under lesson 1 is not actually in that lesson.
 for(const subject of ['تاریخ معاصر ایران','جغرافیا ۳','فلسفه ۱','فلسفه ۲','روان‌شناسی']){
  const row=(await db.query(`select count(*)::int n from private.planner_topic_bank where subject=$1 and preparation_track='final_exam' and page_start is null`,[subject])).rows[0];assert.equal(row.n,0,subject);
 }
 const geoMissing=(await db.query(`select title,chapter from private.planner_topic_bank where subject='جغرافیا ۲' and preparation_track='final_exam' and page_start is null`)).rows;assert.deepEqual(geoMissing,[{title:'کانون و مرزهای ناحیه',chapter:'درس ۱'}]);
 // Every lesson receives multiple independent sections (not just a whole-lesson row).
 for(const [subject,grade,count,field] of [['تاریخ معاصر ایران','11',26,'mathematics'],['جغرافیا ۲','11',11,'humanities'],['جغرافیا ۳','12',6,'humanities'],['فلسفه ۱','11',11,'humanities'],['فلسفه ۲','12',12,'humanities'],['روان‌شناسی','11',8,'humanities']]){
  const rows=(await db.query(`select chapter,count(*)::int n from private.planner_topic_bank where edition='1405' and study_field=$1 and grade=$2 and subject=$3 and position>=300 group by chapter`,[field,grade,subject])).rows;assert.equal(rows.length,count,subject);for(const r of rows)assert.ok(r.n>=3,`${subject} ${r.chapter}`);
 }
 for(let i=0;i<4;i++){const p=JSON.parse(sql(fresh[i]).split('$topics$')[1])[0],grade=p.grade||'11',subject=p.subject||(i===0?'تاریخ معاصر ایران':'روان‌شناسی'),field=i===0?'mathematics':'humanities';const row=(await db.query('select id from private.planner_topic_bank where grade=$1 and study_field=$2 and subject=$3 and chapter=$4 and position=$5 and title=$6',[grade,field,subject,p.chapter,p.position,p.title])).rows[0];assert.ok(row);await db.query('delete from private.planner_topic_bank where id=$1',[row.id]);}
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;for(const f of fresh)await db.exec(sql(f));assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{done:true,examId:'exam-1',topics:[{pageStart:6}]});
 console.log(`PASS: ${inserted} new page-bearing entries across 12 contexts; 326 guarded legacy updates; edits, deletes, snapshot, reruns`);
 }finally{await db.close();}})().catch(e=>{console.error(e);process.exitCode=1});
