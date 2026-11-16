const fs = require('node:fs');
const assert = require('node:assert/strict');
const { PGlite } = require('@electric-sql/pglite');
const { buildSync } = require('esbuild');
const names = ['206_planner_labs_1405','207_planner_defense9_1405','208_planner_messages9_1405','209_planner_religion10_1405'];
const migrations = names.map(name => {
 const sql = fs.readFileSync(`supabase/migrations/${name}.sql`, 'utf8');
 return {name,sql,topics:JSON.parse(sql.split('$topics$')[1])};
});
const code=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':process.cwd()}}).outputFiles[0].text;
const mod={exports:{}};new Function('module','exports','require',code)(mod,mod.exports,require);
(async()=>{const db=new PGlite();try {
 await db.exec(`create role anon;create role authenticated;create schema private;
 create table private.planner_seed_installations(seed_key text primary key);
 create table private.planner_topic_bank(id uuid primary key,edition text not null,study_field text not null,grade text not null,preparation_track text not null,subject text not null,chapter text not null,title text not null,page_start integer,page_end integer,position integer not null,revision bigint not null default 1,updated_at timestamptz not null default now(),check((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));
 insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,position,revision) values ('d0f2c439-a97c-403b-9088-c39fe5d922e5','1405','all','9','final_exam','آمادگی دفاعی','فصل سفارشی','ویرایش مدیر',7,2);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","exam":"e1","ticks":[true,false],"page":55}');`);
 const edited=(await db.query('select to_jsonb(t) v from private.planner_topic_bank t')).rows[0].v;
 for(const {sql} of migrations)await db.exec(sql);
 assert.deepEqual((await db.query("select to_jsonb(t) v from private.planner_topic_bank t where id='d0f2c439-a97c-403b-9088-c39fe5d922e5'")).rows[0].v,edited);
 const contexts=[['experimental_sciences','10','آزمایشگاه علوم تجربی ۱',0,4,101],['experimental_sciences','11','آزمایشگاه علوم تجربی ۲',0,5,85],['all','9','آمادگی دفاعی',1,9,85],['all','9','پیام‌های آسمان',2,12,86],['mathematics','10','تعلیمات دینی ۱',3,12,173],['experimental_sciences','10','تعلیمات دینی ۱',3,12,173],['humanities','10','تعلیمات دینی ۱',3,13,202]];
 for(const [field,grade,subject,index,chapters,count] of contexts){
  const catalog=mod.exports.curriculumBooks(field==='all'?null:field,Number(grade),'final_exam');assert.ok(catalog.some(b=>b.subject===subject));
  const list=migrations[index].topics.filter(p=>(p.grade??grade)===grade&&(p.subject??subject)===subject&&(!p.fields||p.fields.includes(field)));assert.equal(list.length,count);
  assert.equal(new Set(list.map(p=>p.chapter)).size,chapters);
  assert.equal(list.filter(p=>p.title==='کل درس'||p.title==='کل فصل'||p.title==='کل پروژه').length,chapters);
  for(const p of list){assert.ok(p.start>0&&p.end>=p.start&&p.title.length<=160);const rows=(await db.query('select title,page_start,page_end from private.planner_topic_bank where edition=$1 and study_field=$2 and grade=$3 and preparation_track=$4 and subject=$5 and chapter=$6 and position=$7',['1405',field,grade,'final_exam',subject,p.chapter,p.position])).rows;assert.deepEqual(rows,[{title:p.title,page_start:p.start,page_end:p.end}]);}
 }
 const anchor=async(subject,title,start,end)=>{const rows=(await db.query('select page_start,page_end from private.planner_topic_bank where subject=$1 and title=$2',[subject,title])).rows;assert.deepEqual(rows,[{page_start:start,page_end:end}]);};
 await anchor('آزمایشگاه علوم تجربی ۱','انبساط طولی جامدها؛ ارجاع به کتاب فیزیک',115,115);
 await anchor('آزمایشگاه علوم تجربی ۲','مولد جریان برق',36,37);
 await anchor('آزمایشگاه علوم تجربی ۲','بررسی نقش نیتروژن در سلامت و رشد گیاه',124,125);
 await anchor('آمادگی دفاعی','تهدید نظامی و اقتصادی',17,17);
 await anchor('پیام‌های آسمان','انفاق مستحب و قرض',126,126);
 const faith=(await db.query("select study_field,page_start,page_end from private.planner_topic_bank where subject='تعلیمات دینی ۱' and title='منزلگاه بعد'")).rows;assert.deepEqual(faith,[]);
 const distinct=(await db.query("select study_field,chapter,page_start,page_end from private.planner_topic_bank where subject='تعلیمات دینی ۱' and title='کل درس' and chapter like '%منزلگاه بعد' order by study_field")).rows;assert.deepEqual(distinct.map(r=>[r.study_field,r.page_start,r.page_end]),[['experimental_sciences',42,49],['humanities',55,66],['mathematics',42,49]]);
 for(const [field,grade,subject] of contexts){const sample=(await db.query('select id from private.planner_topic_bank where study_field=$1 and grade=$2 and subject=$3 and position>=10 order by id limit 2',[field,grade,subject])).rows;assert.equal(sample.length,2);await db.query('delete from private.planner_topic_bank where id=$1',[sample[0].id]);await db.query("update private.planner_topic_bank set title='ویرایش مدیر',revision=2 where id=$1",[sample[1].id]);}
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 for(const {sql} of migrations)await db.exec(sql);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,before);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',exam:'e1',ticks:[true,false],page:55});
 console.log('PASS: 7 catalog contexts, 905 rows, all lessons/experiments, edits/deletions, rerun and simulated snapshot');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
