const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('228_planner_writing_finer_1405'),books=JSON.parse(migration.split('$books$')[1]);
// Independent transcription of the three numbered workshops in every lesson of the complete 12th grade book.
const workshop12={1:[[23,23],[24,25],[26,26]],2:[[37,37],[38,39],[40,40]],3:[[51,53],[54,55],[56,56]],4:[[72,72],[73,74],[75,75]],5:[[89,89],[90,91],[92,92]],6:[[101,101],[102,102],[103,103]]};
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 for(const n of ['128_planner_topic_bank','133_planner_topic_chapters','192_planner_topic_super_admin','136_planner_physics_writing_topics','172_planner_writing_1405_pages'])await db.exec(sql(n));
 const original=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;await db.exec(migration);
 assert.deepEqual(books.map(x=>[x.grade,x.topics.length]),[['10',63],['11',57],['12',59]]);
 const mod={exports:{}};new Function('module','exports','require',buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false}).outputFiles[0].text)(mod,mod.exports,require);
 for(const b of books)for(const field of ['mathematics','experimental_sciences','humanities']){
  assert.ok(mod.exports.curriculumBooks(field,Number(b.grade),'final_exam').some(x=>x.subject===b.subject));
  const rows=(await db.query("select title,page_start,page_end,position from private.planner_topic_bank where grade=$1 and study_field=$2 and preparation_track='final_exam' and subject=$3 and chapter='درس‌ها' and position>=1101 order by position",[b.grade,field,b.subject])).rows;
  assert.equal(rows.length,b.topics.length);for(let i=0;i<rows.length;i++)assert.deepEqual(rows[i],{title:b.topics[i].title,page_start:b.topics[i].start,page_end:b.topics[i].end,position:b.topics[i].position});
 }
 const b=books.find(x=>x.grade==='12');for(const [lesson,parts] of Object.entries(workshop12))for(let n=1;n<=3;n++){
  const matches=b.topics.filter(p=>p.title.startsWith(`درس ${lesson} — کارگاه ${"۰۱۲۳۴۵۶۷۸۹"[n]}:`));assert.equal(matches.length,1);assert.deepEqual([matches[0].start,matches[0].end],parts[n-1]);}
 for(const [lesson,a,z] of [[1,12,27],[2,30,41],[3,44,57],[4,60,76],[5,80,93],[6,96,104]])for(let page=a;page<=z;page++)assert.ok(b.topics.some(p=>p.title.startsWith(`درس ${lesson} —`)&&p.start<=page&&p.end>=page),`lesson ${lesson} page ${page}`);
 for(const old of original)assert.deepEqual((await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1',[old.id])).rows[0].v,old);
 const cfg=(role,s,a)=>db.query("select set_config('test.role',$1,false),set_config('test.super',$2,false),set_config('test.approved',$3,false)",[role,String(s),String(a)]),list=()=>db.query("select public.planner_list_topics('1405','humanities','12','final_exam','نگارش ۳','درس‌ها') v");
 await cfg('counselor',false,true);assert.ok((await list()).rows[0].v.some(x=>x.title.includes('تحلیل قطعۀ ادبی نماز')));
 await cfg('counselor',false,false);await assert.rejects(list);await cfg('admin',false,true);await assert.rejects(list);await cfg('admin',true,true);assert.ok((await list()).rows[0].v.length>59);
 for(const book of books){const ids=(await db.query("select id from private.planner_topic_bank where grade=$1 and subject=$2 and study_field='humanities' and position>=1101 order by position limit 2",[book.grade,book.subject])).rows;await db.query("update private.planner_topic_bank set title='ویرایش مدیر',revision=2 where id=$1",[ids[0].id]);await db.query('delete from private.planner_topic_bank where id=$1',[ids[1].id]);}
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;await db.exec(migration);assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,before);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: 537 writing topics in nine contexts; independent grade 12 workshop and page coverage; legacy rows, permissions, edits/deletions/rerun and simulated snapshot');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
