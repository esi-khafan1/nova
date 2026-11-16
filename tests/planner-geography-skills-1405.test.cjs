const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('230_planner_geography_skills_1405'),topics=JSON.parse(migration.split('$topics$')[1]);
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 for(const n of ['128_planner_topic_bank','133_planner_topic_chapters','192_planner_topic_super_admin','148_planner_arabic_geography_topics','180_planner_geography11_12_independent_1405','229_planner_geography_activities_1405'])await db.exec(sql(n));
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;await db.exec(migration);
 const mod={exports:{}};new Function('module','exports','require',buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false}).outputFiles[0].text)(mod,mod.exports,require);
 assert.equal(topics.length,37);for(const p of topics)for(const track of ['konkur','final_exam']){
  assert.ok(mod.exports.curriculumBooks('humanities',Number(p.grade),track).some(b=>b.subject===p.subject&&b.chapters.includes(p.chapter)));
  const r=(await db.query('select title,page_start,page_end from private.planner_topic_bank where grade=$1 and subject=$2 and study_field=$3 and preparation_track=$4 and chapter=$5 and position=$6',[p.grade,p.subject,'humanities',track,p.chapter,p.position])).rows;
  assert.deepEqual(r,[{title:p.title,page_start:p.start,page_end:p.end}]);
 }
 for(const old of before)assert.deepEqual((await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1',[old.id])).rows[0].v,old);
 const cfg=(role,s,a)=>db.query("select set_config('test.role',$1,false),set_config('test.super',$2,false),set_config('test.approved',$3,false)",[role,String(s),String(a)]),list=()=>db.query("select public.planner_list_topics('1405','humanities','11','final_exam','جغرافیا ۲','درس ۱۰') v");
 await cfg('counselor',false,true);assert.ok((await list()).rows[0].v.some(x=>x.title.includes('نقشه مرزهای ایران')));await cfg('counselor',false,false);await assert.rejects(list);await cfg('admin',false,true);await assert.rejects(list);await cfg('admin',true,true);assert.ok((await list()).rows[0].v.length>0);
 for(const grade of ['11','12']){const ids=(await db.query("select id from private.planner_topic_bank where grade=$1 and study_field='humanities' and preparation_track='final_exam' and position>=2001 order by chapter,position limit 2",[grade])).rows;await db.query("update private.planner_topic_bank set title='ویرایش مدیر',revision=2 where id=$1",[ids[0].id]);await db.query('delete from private.planner_topic_bank where id=$1',[ids[1].id]);}
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;await db.exec(migration);assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});console.log('PASS: 74 geography skill and finer-section rows in 4 contexts; permissions, prior rows, edits/deletions/rerun and simulated snapshot');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
