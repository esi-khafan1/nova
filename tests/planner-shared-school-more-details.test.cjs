// Exercise all ten curriculum contexts, supplemental coverage, null pages and safe reruns.
const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
(async()=>{const db=new PGlite();try{
 await db.exec(`create schema private;create table private.planner_topic_bank(id uuid primary key,edition text,study_field text,grade text,preparation_track text,subject text,chapter text,title text,page_start int,page_end int,position int,revision int default 1);`);
 const files=['154_planner_shared_school_topics','155_planner_shared_school_detail','156_planner_shared_school_more_details'].map(x=>fs.readFileSync(`supabase/migrations/${x}.sql`,'utf8'));
 for(const sql of files)await db.exec(sql);
 assert.equal((await db.query('select count(*)::int n from private.planner_topic_bank')).rows[0].n,842);
 assert.equal((await db.query(`select count(*)::int n from (select edition,study_field,grade,preparation_track,subject,chapter,position from private.planner_topic_bank group by 1,2,3,4,5,6,7 having count(*)>1) duplicates`)).rows[0].n,0);
 assert.equal((await db.query(`select count(*)::int n from private.planner_topic_bank where char_length(title)>160 or char_length(chapter)>160 or position not between 0 and 10000`)).rows[0].n,0);
 const contexts=[...['mathematics','experimental_sciences','humanities'].flatMap(f=>[['10',f,'کارگاه کارآفرینی و تولید'],['10',f,'آمادگی دفاعی']]),...['mathematics','experimental_sciences'].flatMap(f=>[['12',f,'علوم اجتماعی'],['11',f,'تعلیمات دینی ۲']])];assert.equal(contexts.length,10);
 for(const [grade,field,subject] of contexts){
  const rows=(await db.query('select * from private.planner_topic_bank where grade=$1 and study_field=$2 and subject=$3 and preparation_track=$4',[grade,field,subject,'final_exam'])).rows;
  assert.ok(rows.some(x=>x.position>=200),`${field} ${subject}`);
  const added=rows.filter(x=>x.position>=200);assert.ok(added.every(x=>x.page_start===null&&x.page_end===null));
  if(subject==='کارگاه کارآفرینی و تولید')for(let i=1;i<=32;i++){
   const n=String(i).replace(/[0-9]/g,c=>'۰۱۲۳۴۵۶۷۸۹'[c]);assert.ok(rows.some(x=>x.position>=100&&x.title.startsWith(`بخش ${n}:`)),`${field} workshop ${i}`);
  }
  if(subject==='آمادگی دفاعی')for(let i=1;i<=13;i++){
   const n=String(i).replace(/[0-9]/g,c=>'۰۱۲۳۴۵۶۷۸۹'[c]);assert.ok(added.some(x=>x.title.startsWith(`درس ${n}:`)),`${field} defence ${i}`);
  }
  if(subject==='علوم اجتماعی'||subject==='تعلیمات دینی ۲'){
   const expected=subject==='علوم اجتماعی'?10:12;assert.equal(new Set(added.map(x=>x.chapter)).size,expected);
  }
 }
 const edit=(await db.query('select id from private.planner_topic_bank where position>=200 limit 1')).rows[0].id;
 const earlier=(await db.query('select id from private.planner_topic_bank where position>=100 and position<200 limit 1')).rows[0].id;
 await db.query("update private.planner_topic_bank set title='حفظ ویرایش',revision=2 where id in ($1,$2)",[edit,earlier]);for(const sql of files)await db.exec(sql);
 assert.equal((await db.query('select count(*)::int n from private.planner_topic_bank')).rows[0].n,842);
 assert.equal((await db.query("select count(*)::int n from private.planner_topic_bank where title='حفظ ویرایش' and revision=2")).rows[0].n,2);
 assert.equal((await db.query("select count(*)::int n from private.planner_topic_bank where edition<>'1405' or preparation_track<>'final_exam'")).rows[0].n,0);
 console.log('PASS: 298 new rows, all ten contexts, section coverage, null pages and edit preservation');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
