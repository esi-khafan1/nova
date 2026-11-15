const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const seeds=['132_planner_verified_topics','136_planner_physics_writing_topics','137_planner_humanities_school_topics','138_planner_remaining_topics','146_planner_geography10_topics','152_planner_geology_history_topics','165_planner_history11_1405_topics','167_planner_english9_1405_pages','171_planner_history11_independent_1405'];
const names=['172_planner_writing_1405_pages','173_planner_environment_1405_pages','174_planner_health_1405_pages','175_planner_logic_1405_pages','176_planner_history11_independent_1405','177_planner_media_1405_pages','178_planner_geography10_1405_pages'];
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create table private.planner_topic_bank(id uuid primary key,edition text not null,study_field text not null,grade text not null,preparation_track text not null,subject text not null,chapter text not null,title text not null,page_start integer,page_end integer,position integer not null,revision bigint not null default 1,updated_at timestamptz not null default now(),check((page_start is null and page_end is null) or (page_start is not null and page_end>=page_start)));create table published_snapshot(content jsonb);insert into published_snapshot values ('{"done":true,"examId":"exam-1","pageStart":6}');`);
 for(const f of seeds)await db.exec(sql(f));
 // Original edits/moves and deletions must not be overwritten or restored.
 const edited=(await db.query(`select id from private.planner_topic_bank where subject='منطق' and chapter='درس ۱' and preparation_track='konkur' and position=1`)).rows[0];assert.ok(edited);await db.query(`update private.planner_topic_bank set title='ویرایش مدیر',chapter='جابجا شده',revision=2 where id=$1`,[edited.id]);
 const deleted=(await db.query(`select id from private.planner_topic_bank where subject='جغرافیای ایران' and chapter='درس ۱' and preparation_track='final_exam' and study_field='humanities' and position=1`)).rows[0];assert.ok(deleted);await db.query('delete from private.planner_topic_bank where id=$1',[deleted.id]);
 const before=(await db.query('select to_jsonb(t) x from private.planner_topic_bank t where id=$1',[edited.id])).rows[0].x;
 for(const f of names)await db.exec(sql(f));
 assert.deepEqual((await db.query('select to_jsonb(t) x from private.planner_topic_bank t where id=$1',[edited.id])).rows[0].x,before);assert.equal((await db.query('select 1 from private.planner_topic_bank where id=$1',[deleted.id])).rows.length,0);
 // Every generated record exists in every intended context and has its exact range.
 let total=0;
 for(const n of names){const s=sql(n),parts=s.split('$topics$');let items=[];if(parts.length>1){let topics=JSON.parse(parts[1]);let contexts=n.startsWith('175')?[['humanities','10','konkur','منطق'],['humanities','10','final_exam','منطق']]:n.startsWith('176')?[['humanities','11','konkur','تاریخ ۲'],['humanities','11','final_exam','تاریخ ۲']]:n.startsWith('177')?['humanities','mathematics','experimental_sciences'].map(f=>[f,'10','final_exam','تفکر و سواد رسانه‌ای']):n.startsWith('178')?[['humanities','10','konkur','جغرافیای ایران'],...['humanities','mathematics','experimental_sciences'].map(f=>[f,'10','final_exam','جغرافیای ایران'])]:['humanities','mathematics','experimental_sciences'].map(f=>[f,n.startsWith('173')?'11':'12','final_exam',n.startsWith('173')?'انسان و محیط زیست':'سلامت و بهداشت']);for(const p of topics)for(const c of contexts)items.push([p,c,p.chapter||'درس‌ها']);}
 else {const books=JSON.parse(s.split('$books$')[1]);for(const b of books)for(const p of b.topics)for(const f of b.fields)items.push([p,[f,b.grade,'final_exam',b.subject],'درس‌ها']);}
 for(const [p,[f,g,tr,subject],chapter] of items){const result=await db.query(`select page_start,page_end from private.planner_topic_bank where study_field=$1 and grade=$2 and preparation_track=$3 and subject=$4 and chapter=$5 and position=$6 and title=$7`,[f,g,tr,subject,chapter,p.position,p.title]);assert.equal(result.rows.length,1,`${n} ${f} ${p.title}`);assert.deepEqual([result.rows[0].page_start,result.rows[0].page_end],[p.start,p.end]);total++;} }
 assert.equal(total,651+106+184+192+268);
 // Check every untouched original row targeted by a compare-and-swap correction.
 const crypto=require('node:crypto');let corrected=0;
 for(const n of [names[0],names[1],names[2],names[3],names[6]]){
  const fixes=JSON.parse(sql(n).split('$fixes$')[1]);
  for(const p of fixes){const isLogic=n.startsWith('175'),isGeo=n.startsWith('178');const fields=isLogic?['humanities']:['humanities','mathematics','experimental_sciences'];
   for(const field of fields){const tracks=(isLogic||isGeo&&field==='humanities')?['konkur','final_exam']:['final_exam'];for(const track of tracks){const grade=isLogic||isGeo?'10':n.startsWith('173')?'11':n.startsWith('174')?'12':p.grade;const subject=isLogic?'منطق':isGeo?'جغرافیای ایران':n.startsWith('173')?'انسان و محیط زیست':n.startsWith('174')?'سلامت و بهداشت':p.subject;const chapter=p.chapter||'درس‌ها';const digest=crypto.createHash('md5').update(`nova:planner:1405:v1:${field}:${grade}:${track}:${subject}:${chapter}:${p.position}`).digest('hex');const id=`${digest.slice(0,8)}-${digest.slice(8,12)}-${digest.slice(12,16)}-${digest.slice(16,20)}-${digest.slice(20)}`;
    if(id===edited.id||id===deleted.id)continue;
    const rows=(await db.query('select page_start,page_end,revision from private.planner_topic_bank where id=$1',[id])).rows;assert.equal(rows.length,1,`${n} missing original ${subject} ${chapter} ${p.title}`);assert.deepEqual([rows[0].page_start,rows[0].page_end,Number(rows[0].revision)],[p.start,p.end,2],`${n} ${subject} ${chapter} ${p.title}`);corrected++;
   }}
  }
 }
 assert.equal(corrected,14*3+7*3+14*3+26*2+33*4-2);
 // Corrected untouched v1 row has the book page, and once edited is not reset.
 const geo=(await db.query(`select id,page_start,page_end from private.planner_topic_bank where subject='جغرافیای ایران' and study_field='humanities' and preparation_track='konkur' and chapter='درس ۵' and position=1`)).rows[0];assert.deepEqual([geo.page_start,geo.page_end],[34,40]);
 for(const n of names){const version=n.slice(0,3);const row=(await db.query(`select id from private.planner_topic_bank where id::text like '%' and id in (select id from private.planner_topic_bank) and subject=$1 and position=$2 limit 1`,n.startsWith('172')?['نگارش ۱',101]:n.startsWith('173')?['انسان و محیط زیست',101]:n.startsWith('174')?['سلامت و بهداشت',101]:n.startsWith('175')?['منطق',101]:n.startsWith('176')?['تاریخ ۲',301]:n.startsWith('177')?['تفکر و سواد رسانه‌ای',101]:['جغرافیای ایران',101])).rows[0];assert.ok(row,version);await db.query('delete from private.planner_topic_bank where id=$1',[row.id]);}
 await db.query(`update private.planner_topic_bank set title='درس مدیر',revision=revision+1 where id=$1`,[geo.id]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) x from private.planner_topic_bank t')).rows[0].x;
 for(const f of names)await db.exec(sql(f));assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) x from private.planner_topic_bank t')).rows[0].x,current);assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{done:true,examId:'exam-1',pageStart:6});
 console.log(`PASS: ${total} added rows, exact context and pages, untouched CAS, edits, deletions, snapshots, reruns`);
 }finally{await db.close();}})().catch(e=>{console.error(e);process.exitCode=1});
