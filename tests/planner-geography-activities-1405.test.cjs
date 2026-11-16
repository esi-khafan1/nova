const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('229_planner_geography_activities_1405'),topics=JSON.parse(migration.split('$topics$')[1]);
// Separately transcribed printed-page inventory of activity blocks in geography 3.
const pages12={1:[3,5,6,9,16,18,20],2:[23,24,27,29,34,35,37,40],3:[45,47,51,55,58],4:[61,66,70,72,73,74,76,80],5:[88,92,96,99],6:[103,106,110,114]};
const pages11={1:[10],2:[17],3:[20,22,25,28,31,34],4:[37,40,43,46,50],5:[53,56,57,63,66],6:[68,71,75,76,82],7:[90,93,94,98],8:[101,105,108,108,112],9:[117,120,126],10:[127,129,133,136,140],11:[146,149,152,156,159]};
const fields10=[['humanities','konkur'],['humanities','final_exam'],['mathematics','final_exam'],['experimental_sciences','final_exam']],fields12=[['humanities','konkur'],['humanities','final_exam']];
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 for(const n of ['128_planner_topic_bank','133_planner_topic_chapters','192_planner_topic_super_admin','146_planner_geography10_topics','148_planner_arabic_geography_topics','178_planner_geography10_1405_pages','180_planner_geography11_12_independent_1405'])await db.exec(sql(n));
 const original=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.equal(topics.filter(p=>p.grade==='10').length,55);assert.equal(topics.filter(p=>p.grade==='11').length,45);assert.equal(topics.filter(p=>p.grade==='12').length,36);
 const mod={exports:{}};new Function('module','exports','require',buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false}).outputFiles[0].text)(mod,mod.exports,require);
 for(const [grade,contexts] of [['10',fields10],['11',fields12],['12',fields12]])for(const [field,track] of contexts){
  const expected=topics.filter(p=>p.grade===grade),subject=expected[0].subject;assert.ok(mod.exports.curriculumBooks(field,Number(grade),track).some(x=>x.subject===subject));
  const rows=(await db.query("select chapter,position,title,page_start,page_end from private.planner_topic_bank where grade=$1 and study_field=$2 and preparation_track=$3 and subject=$4 and position>=1001 order by chapter,position",[grade,field,track,subject])).rows;
  assert.equal(rows.length,expected.length);for(const p of expected){const row=rows.find(x=>x.chapter===p.chapter&&x.position===p.position);assert.deepEqual(row,{chapter:p.chapter,position:p.position,title:p.title,page_start:p.start,page_end:p.end});}
 }
 for(const [grade,inventory] of [['11',pages11],['12',pages12]])for(const [lesson,expected] of Object.entries(inventory)){const chapter=`درس ${lesson.replace(/[0-9]/g,n=>'۰۱۲۳۴۵۶۷۸۹'[+n])}`;assert.deepEqual(topics.filter(p=>p.grade===grade&&p.chapter===chapter).map(p=>p.start),expected);}
 for(const [chapter,start,end] of [['درس ۱',2,20],['درس ۲',21,40],['درس ۳',42,58],['درس ۴',59,80],['درس ۵',82,99],['درس ۶',100,114]])for(let page=start;page<=end;page++){
  const a=JSON.parse(sql('180_planner_geography11_12_independent_1405').split('$topics$')[1]);assert.ok(a.some(p=>p.grade==='12'&&p.chapter===chapter&&p.position>300&&p.start<=page&&p.end>=page),`${chapter} ${page}`);
 }
 for(const old of original)assert.deepEqual((await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1',[old.id])).rows[0].v,old);
 const cfg=(role,s,a)=>db.query("select set_config('test.role',$1,false),set_config('test.super',$2,false),set_config('test.approved',$3,false)",[role,String(s),String(a)]),list=()=>db.query("select public.planner_list_topics('1405','humanities','12','final_exam','جغرافیا ۳','درس ۶') v");
 await cfg('counselor',false,true);assert.ok((await list()).rows[0].v.some(x=>x.title.includes('مدیریت زلزله، آموزش و مانور')));
 await cfg('counselor',false,false);await assert.rejects(list);await cfg('admin',false,true);await assert.rejects(list);await cfg('admin',true,true);assert.ok((await list()).rows[0].v.length>4);
 for(const grade of ['10','11','12']){const ids=(await db.query("select id from private.planner_topic_bank where grade=$1 and study_field='humanities' and preparation_track='final_exam' and position>=1001 order by chapter,position limit 2",[grade])).rows;await db.query("update private.planner_topic_bank set title='ویرایش مدیر',revision=2 where id=$1",[ids[0].id]);await db.query('delete from private.planner_topic_bank where id=$1',[ids[1].id]);}
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;await db.exec(migration);assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,before);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: 382 geography activity rows in eight contexts; independent geography 12 inventory and lesson coverage; legacy data, roles, edits/deletions/rerun, simulated snapshot');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
