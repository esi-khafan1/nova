const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
(async()=>{const db=new PGlite();try{
 await db.exec(`create schema private;create table private.planner_topic_bank(id uuid primary key,edition text not null,study_field text not null,grade text not null,preparation_track text not null,subject text not null,chapter text not null,title text not null,page_start int,page_end int,position int not null,revision bigint not null default 1,updated_at timestamptz not null default now(),check((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));create table published_snapshot(id int primary key,content jsonb);insert into published_snapshot values (1,'{"title":"existing","pageStart":78,"pageEnd":116}'::jsonb);`);
 const names=['154_planner_shared_school_topics','155_planner_shared_school_detail','156_planner_shared_school_more_details','157_planner_verified_shared_pages','158_planner_verified_shared_subtopic_pages'];
 const files=names.map(n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8'));for(const f of files.slice(0,4))await db.exec(f);
 const data=JSON.parse(files[4].split('$pages$')[1]);assert.equal(data.length,19);assert.equal(data.reduce((n,p)=>n+p.fields.length,0),52);
 // Simulate one edited/moved topic, and an admin-corrected disputed range.
 const changed=(await db.query(`select id from private.planner_topic_bank where study_field='humanities' and subject='کارگاه کارآفرینی و تولید' and title='بخش ۱: بازی تیمی برج روزنامه'`)).rows[0].id;
 await db.query(`update private.planner_topic_bank set revision=2,title='عنوان اصلاح شده',page_start=3,page_end=4 where id=$1`,[changed]);
 const disputed=(await db.query(`select id from private.planner_topic_bank where study_field='humanities' and subject='آمادگی دفاعی' and title='درس ۹: جنگ‌افزارشناسی و اصول تیراندازی'`)).rows[0].id;
 await db.query(`update private.planner_topic_bank set page_start=87,page_end=116,revision=2 where id=$1`,[disputed]);
 await db.exec(files[4]);
 for(const p of data)for(const field of p.fields){
  const row=(await db.query(`select id,page_start,page_end,revision::int revision from private.planner_topic_bank where study_field=$1 and grade=$2 and subject=$3 and chapter=$4 and position=$5`,[field,p.grade,p.subject,p.chapter,p.position])).rows[0];
  assert.ok(row);if(row.id===changed)assert.deepEqual([row.page_start,row.page_end,row.revision],[3,4,2]);else assert.deepEqual([row.page_start,row.page_end,row.revision],[p.start,p.end,2],`${field} ${p.title}`);
 }
 const cleared=(await db.query(`select study_field,page_start,page_end,revision::int revision from private.planner_topic_bank where subject='آمادگی دفاعی' and title='درس ۹: جنگ‌افزارشناسی و اصول تیراندازی' order by study_field`)).rows;
 assert.deepEqual(cleared,[{study_field:'experimental_sciences',page_start:null,page_end:null,revision:2},{study_field:'humanities',page_start:87,page_end:116,revision:2},{study_field:'mathematics',page_start:null,page_end:null,revision:2}]);
 for(const f of files)await db.exec(f);
 assert.equal((await db.query('select count(*)::int n from private.planner_topic_bank')).rows[0].n,862);
 assert.deepEqual((await db.query('select page_start,page_end,revision::int revision from private.planner_topic_bank where id=$1',[changed])).rows[0],{page_start:3,page_end:4,revision:2});
 assert.deepEqual((await db.query('select page_start,page_end,revision::int revision from private.planner_topic_bank where id=$1',[disputed])).rows[0],{page_start:87,page_end:116,revision:2});
 assert.deepEqual((await db.query('select content from published_snapshot where id=1')).rows[0].content,{title:'existing',pageStart:78,pageEnd:116});
 console.log('PASS: 52 verified ranges, conflicting defaults, editor CAS and published snapshot preservation');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
