const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
(async()=>{const db=new PGlite();try{
 await db.exec(`create schema private;create table private.planner_topic_bank(id uuid primary key,edition text not null,study_field text not null,grade text not null,preparation_track text not null,subject text not null,chapter text not null,title text not null,page_start int,page_end int,position int not null,revision bigint not null default 1,updated_at timestamptz not null default now(),check((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));create table published_snapshot(id int primary key,content jsonb);insert into published_snapshot values (1,'{"items":[{"pageStart":78,"pageEnd":116},{"pageStart":124,"pageEnd":137}]}'::jsonb);`);
 const names=['154_planner_shared_school_topics','155_planner_shared_school_detail','156_planner_shared_school_more_details','157_planner_verified_shared_pages','158_planner_verified_shared_subtopic_pages','159_planner_entrepreneurship_section_pages','160_planner_entrepreneurship_1405_pages','161_planner_three_1405_books'];
 const files=names.map(n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8'));for(const f of files.slice(0,-1))await db.exec(f);
 const sql=files.at(-1),data=JSON.parse(sql.split('$pages$')[1]),added=JSON.parse(sql.split('$new$')[1]);assert.equal(data.length,189);assert.equal(added.length,10);
 const get=async(subject,field,chapter,position)=>(await db.query(`select id,title,chapter,page_start,page_end,revision::int revision from private.planner_topic_bank where subject=$1 and study_field=$2 and chapter=$3 and position=$4`,[subject,field,chapter,position])).rows[0];
 const untouched=await get('علوم اجتماعی','humanities','درس ۲: پدیده‌های اجتماعی',1);assert.equal(untouched,undefined);
 const edited=await get('علوم اجتماعی','mathematics','درس ۲: پدیده‌های اجتماعی',1);
 await db.query(`update private.planner_topic_bank set title='ویرایش مدیر',page_start=8,page_end=8,revision=2 where id=$1`,[edited.id]);
 const moved=await get('آمادگی دفاعی','humanities','فصل ۳: دفاع نظامی',105);
 await db.query(`update private.planner_topic_bank set chapter='فصل مدیر' where id=$1`,[moved.id]);
 const otherBefore=(await db.query(`select jsonb_agg(to_jsonb(t) order by id) rows from private.planner_topic_bank t where subject not in ('آمادگی دفاعی','تعلیمات دینی ۲','علوم اجتماعی')`)).rows[0].rows;
 const oldRange=await get('تعلیمات دینی ۲','mathematics','درس ۱۰: مرجعیت و ولایت فقیه',101);
 await db.query(`update private.planner_topic_bank set page_end=135,revision=2 where id=$1`,[oldRange.id]);
 await db.exec(sql);
 assert.deepEqual((await db.query(`select jsonb_agg(to_jsonb(t) order by id) rows from private.planner_topic_bank t where subject not in ('آمادگی دفاعی','تعلیمات دینی ۲','علوم اجتماعی')`)).rows[0].rows,otherBefore);
 for(const p of data)for(const field of p.fields){
  const r=(await db.query(`select id,title,chapter,page_start,page_end,revision::int revision from private.planner_topic_bank where id=md5('nova:planner:1405:'||$1||':'||$2||':'||$3||':final_exam:'||$4||':'||$5||':'||$6)::uuid`,[p.generation,field,p.grade,p.subject,p.chapter,p.position])).rows[0];assert.ok(r,p.title);
  if(r.id===edited.id)assert.deepEqual([r.title,r.page_start,r.page_end,r.revision],['ویرایش مدیر',8,8,2]);
  else if(r.id===moved.id)assert.deepEqual([r.chapter,r.page_start,r.page_end,r.revision],['فصل مدیر',null,null,1]);
  else assert.deepEqual([r.title,r.page_start,r.page_end,r.revision],[p.new_title,p.start,p.end,2],p.title);
 }
 for(const field of ['mathematics','experimental_sciences','humanities']){
  const old=await get('آمادگی دفاعی',field,'فصل ۳: دفاع نظامی',3),verified=await get('آمادگی دفاعی',field,'فصل ۳: دفاع نظامی',301),lesson8=await get('آمادگی دفاعی',field,'فصل ۳: دفاع نظامی',2);
  assert.deepEqual([old.page_start,old.page_end,old.revision],[null,null,2]);assert.deepEqual([verified.page_start,verified.page_end],[87,116]);assert.deepEqual([lesson8.page_start,lesson8.page_end],[64,86]);
  for(const p of added){const r=await get('آمادگی دفاعی',field,'فصل ۳: دفاع نظامی',p.position);assert.deepEqual([r.title,r.page_start,r.page_end],[p.title,p.start,p.end]);}
 }
 const religion=await get('تعلیمات دینی ۲','experimental_sciences','درس ۱۰: مرجعیت و ولایت فقیه',101);assert.deepEqual([religion.page_start,religion.page_end,religion.revision],[124,133,2]);
 assert.equal((await db.query('select page_end from private.planner_topic_bank where id=$1',[oldRange.id])).rows[0].page_end,135);
 const last=await get('تعلیمات دینی ۲','experimental_sciences','درس ۱۲: پیوند مقدس',101);assert.deepEqual([last.page_start,last.page_end],[148,158]);
 const counts=(await db.query(`select subject,study_field,count(*)::int total,count(*) filter(where page_start is null)::int missing from private.planner_topic_bank where (subject='آمادگی دفاعی' and grade='10') or (subject='علوم اجتماعی' and grade='12') or (subject='تعلیمات دینی ۲' and grade='11') group by subject,study_field order by subject,study_field`)).rows;
 assert.equal(counts.length,7);for(const c of counts)assert.equal(c.missing,c.subject==='آمادگی دفاعی'?(c.study_field==='humanities'?2:1):0,JSON.stringify(c));
 const before=(await db.query(`select jsonb_agg(to_jsonb(t) order by id) rows from private.planner_topic_bank t`)).rows[0].rows;
 for(const f of files)await db.exec(f);
 assert.deepEqual((await db.query(`select jsonb_agg(to_jsonb(t) order by id) rows from private.planner_topic_bank t`)).rows[0].rows,before);
 assert.deepEqual((await db.query('select content from published_snapshot where id=1')).rows[0].content,{items:[{pageStart:78,pageEnd:116},{pageStart:124,pageEnd:137}]});
 console.log('PASS: 444 seed updates, 30 new defence topics, corrected religion range, seven contexts, CAS, moves, snapshots, rerun'); console.log(counts);
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
