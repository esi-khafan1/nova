const fs=require('node:fs'),assert=require('node:assert/strict'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('227_planner_vision_exercises_1405'),books=JSON.parse(migration.split('$books$')[1]);
// Independently transcribed printed-page/label inventory for every lesson of Vision 3.
// The unlabelled paragraph-identification exercise spans 66–67.
const vision3=[
['1','Get Ready','A17 B18 C18'],['1','Vocabulary','A21-23 B23 C23'],['1','Reading','A26 B26 C26'],['1','Vocabulary Development','A28 B28'],['1','Grammar','A29 B29 C30 D30 E30 F30 G30'],['1','See Also','A31 B31'],['1','Listening','A32 B33'],['1','Writing','A35 B37 C38 D38 E39 F39'],['1','What You Learned','A41 B41 C41'],
['2','Get Ready','A45 B46 C46'],['2','Vocabulary','A49-51 B51 C51'],['2','Reading','A54 B54 C54'],['2','Vocabulary Development','A56 B56'],['2','Grammar','A57 B57 C58 D59 E59 F59'],['2','See Also','A60 B60'],['2','Listening','A61 B62'],['2','Writing','A64 B65 C67'],['2','What You Learned','A69 B69 C69'],
['3','Get Ready','A73 B74 C74'],['3','Vocabulary','A77-79 B79 C79'],['3','Reading','A82 B82 C82'],['3','Vocabulary Development','A84 B85'],['3','Grammar','A86 B86 C87 D87 E87 F87 G87'],['3','See Also','A88 B88'],['3','Listening','A89 B90'],['3','Writing','A91 B92 C93 D94 E95 F96 G97'],['3','What You Learned','A99 B99 C99']];
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"old","completed":[true,false],"exam":"e1","topics":[{"pageStart":26}]}');`);
 for(const n of ['128_planner_topic_bank','133_planner_topic_chapters','192_planner_topic_super_admin','136_planner_physics_writing_topics','137_planner_humanities_school_topics','169_planner_english_1405_details'])await db.exec(sql(n));
 const original=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual(books.map(x=>[x.grade,x.topics.length]),[['10',122],['11',99],['12',91]]);
 const mod={exports:{}};new Function('module','exports','require',buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false}).outputFiles[0].text)(mod,mod.exports,require);
 for(const b of books)for(const field of ['mathematics','experimental_sciences','humanities']){
  assert.ok(mod.exports.curriculumBooks(field,Number(b.grade),'final_exam').some(x=>x.subject===b.subject));
  const rows=(await db.query("select title,page_start,page_end,position from private.planner_topic_bank where grade=$1 and study_field=$2 and preparation_track='final_exam' and subject=$3 and chapter='درس‌ها' and position>=1001 order by position",[b.grade,field,b.subject])).rows;
  assert.equal(rows.length,b.topics.length);for(let i=0;i<rows.length;i++)assert.deepEqual(rows[i],{title:b.topics[i].title,page_start:b.topics[i].start,page_end:b.topics[i].end,position:b.topics[i].position});
 }
 const new12=books.find(b=>b.grade==='12').topics;
 for(const [lesson,section,items] of vision3)for(const token of items.split(' ')){
  const m=token.match(/^([A-G])(\d+)(?:-(\d+))?$/),start=+m[2],end=+(m[3]||m[2]);
  const matches=new12.filter(p=>p.title.startsWith(`درس ${lesson} — ${section} — ${m[1]}:`));assert.equal(matches.length,1,token);assert.deepEqual([matches[0].start,matches[0].end],[start,end]);
 }
 assert.ok(new12.some(x=>x.title.startsWith('درس 2 — Writing — متن تمرین:')&&x.start===66&&x.end===67));
 for(const p of original){const now=(await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1',[p.id])).rows[0].v;assert.deepEqual(now,p);}
 const cfg=(role,superuser,approved)=>db.query("select set_config('test.role',$1,false),set_config('test.super',$2,false),set_config('test.approved',$3,false)",[role,String(superuser),String(approved)]);
 const list=()=>db.query("select public.planner_list_topics('1405','humanities','12','final_exam','زبان خارجی ۳','درس‌ها') v");
 await cfg('counselor',false,true);assert.ok((await list()).rows[0].v.some(x=>x.title.includes('نوشتن پاراگراف درباره تصویر ایران')));
 await cfg('counselor',false,false);await assert.rejects(list);await cfg('admin',false,true);await assert.rejects(list);await cfg('admin',true,true);assert.ok((await list()).rows[0].v.length>91);
 for(const b of books){const ids=(await db.query("select id from private.planner_topic_bank where grade=$1 and subject=$2 and study_field='humanities' and position>=1001 order by position limit 2",[b.grade,b.subject])).rows;
  await db.query("update private.planner_topic_bank set title='ویرایش مدیر',revision=2 where id=$1",[ids[0].id]);await db.query('delete from private.planner_topic_bank where id=$1',[ids[1].id]);}
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;await db.exec(migration);assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,before);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'old',completed:[true,false],exam:'e1',topics:[{pageStart:26}]});
 console.log('PASS: 936 Vision exercise rows in nine contexts, independent Vision 3 inventory, role access, edit/delete/rerun and simulated snapshot');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
