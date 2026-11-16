// Isolated PGlite, real bank schema and authorization RPCs; no production data.
const fs=require('node:fs'),assert=require('node:assert/strict'),crypto=require('node:crypto'),{PGlite}=require('@electric-sql/pglite'),{buildSync}=require('esbuild');
const read=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const names=['218_planner_family12_versions_1405','219_planner_culture_art9_1405','220_planner_writing9_1405'];
const sql=names.map(read),[family,art,writing]=sql.map(s=>JSON.parse(s.split('$topics$')[1])),fixes=JSON.parse(sql[2].split('$fixes$')[1]);
const code=buildSync({entryPoints:['lib/planning-curriculum.ts'],bundle:true,platform:'node',format:'cjs',write:false,alias:{'@':process.cwd()}}).outputFiles[0].text,mod={exports:{}};new Function('module','exports','require',code)(mod,mod.exports,require);
const uuid=s=>{const x=crypto.createHash('md5').update(s).digest('hex');return `${x.slice(0,8)}-${x.slice(8,12)}-${x.slice(12,16)}-${x.slice(16,20)}-${x.slice(20)}`};
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$ select current_setting('test.role')::public.app_role $$;
 create function private.is_super_admin() returns boolean language sql stable as $$ select current_setting('test.super')::boolean $$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$ begin if current_setting('test.approved') <> 'true' then raise exception 'not approved' using errcode='42501'; end if; end $$;
 create table private.planner_seed_installations(seed_key text primary key);create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"original","ticks":[true,false],"exam":"id","topics":[{"title":"اصل","pageStart":3}]}');`);
 await db.exec(read('128_planner_topic_bank'));await db.exec(read('133_planner_topic_chapters'));await db.exec(read('192_planner_topic_super_admin'));await db.exec(read('136_planner_physics_writing_topics'));
 const oldId=p=>uuid(`nova:planner:1405:v1:all:9:final_exam:نگارش:${p.chapter}:${p.position}`);
 await db.query("update private.planner_topic_bank set title='ویرایش مدیر',page_start=7,page_end=8,revision=2 where id=$1",[oldId(fixes[0])]);await db.query('delete from private.planner_topic_bank where id=$1',[oldId(fixes[1])]);
 const edited=(await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1',[oldId(fixes[0])])).rows[0].v;
 const other=(await db.query("select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t where subject<>'نگارش'")).rows[0].v;
 for(const s of sql)await db.exec(s);
 assert.equal(family.length,440);assert.equal(art.length,286);assert.equal(writing.length,137);assert.equal(fixes.length,8);
 for(const field of ['mathematics','experimental_sciences','humanities']){
  assert.ok(mod.exports.curriculumBooks(field,12,'final_exam').some(b=>b.subject==='مدیریت خانواده و سبک زندگی'));
  const x=(await db.query("select chapter,title,page_start,page_end,position from private.planner_topic_bank where study_field=$1 and subject='مدیریت خانواده و سبک زندگی'",[field])).rows;
  assert.equal(x.length,440);assert.equal(new Set(x.map(r=>r.chapter)).size,32);
  for(const row of x){const v=row.chapter.startsWith('دختران —')?'دختران':'پسران';assert.ok(row.chapter.startsWith(v+' —')&&row.title.startsWith(v+' —'));assert.ok(row.page_start>=1&&row.page_end>=row.page_start&&row.page_end<=(v==='دختران'?192:142));}
  assert.equal(new Set(x.filter(r=>r.chapter.startsWith('دختران')).map(r=>r.chapter)).size,10);assert.equal(new Set(x.filter(r=>r.chapter.startsWith('پسران')).map(r=>r.chapter)).size,22);
 }
 for(const subject of ['فرهنگ و هنر','نگارش'])assert.ok(mod.exports.curriculumBooks(null,9,'final_exam').some(x=>x.subject===subject));
 for(const p of art){assert.ok(p.start>0&&p.end>=p.start&&p.end<=184);const r=(await db.query("select title,page_start,page_end from private.planner_topic_bank where subject='فرهنگ و هنر' and chapter=$1 and position=$2",[p.chapter,p.position])).rows;assert.deepEqual(r,[{title:p.title,page_start:p.start,page_end:p.end}]);}
 assert.equal(new Set(art.map(p=>p.chapter)).size,31);
 // Each lesson/scene has its complete page range covered by explicit page choices.
 for(const [entries,prefix] of [[family,'دختران —'],[family,'پسران —'],[art,'']]){
  const chapters=[...new Set(entries.filter(p=>p.chapter.startsWith(prefix)).map(p=>p.chapter))];
  for(const chapter of chapters){const rows=entries.filter(p=>p.chapter===chapter);const whole=rows.find(p=>p.position===1);assert.ok(whole,chapter);for(let page=whole.start;page<=whole.end;page++)assert.ok(rows.some(p=>p.position>=500&&p.start===page&&p.end===page),`${chapter}: ${page}`);}
 }
 for(let page=12;page<=108;page++)assert.ok(writing.some(p=>p.start===page&&p.end===page&&p.title.includes(page===12?'ستایش':page===108?'نیایش':'مطالعه صفحه')),String(page));
 for(const p of writing){assert.ok(p.start>=12&&p.end>=p.start&&p.end<=108);const r=(await db.query("select title,page_start,page_end from private.planner_topic_bank where subject='نگارش' and chapter=$1 and position=$2",[p.chapter,p.position])).rows;assert.deepEqual(r,[{title:p.title,page_start:p.start,page_end:p.end}]);}
 assert.deepEqual((await db.query('select to_jsonb(t) v from private.planner_topic_bank t where id=$1',[oldId(fixes[0])])).rows[0].v,edited);assert.equal((await db.query('select id from private.planner_topic_bank where id=$1',[oldId(fixes[1])])).rows.length,0);
 for(const p of fixes.slice(2))assert.deepEqual((await db.query('select page_start,page_end,revision from private.planner_topic_bank where id=$1',[oldId(p)])).rows,[{page_start:p.start,page_end:p.end,revision:2}]);
 assert.deepEqual((await db.query("select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t where subject not in ('نگارش','فرهنگ و هنر','مدیریت خانواده و سبک زندگی')")).rows[0].v,other);
 for(const [entries,chapter,title,a,b] of [[family,'دختران — صحنه ۱۰: زندگی با طعم مسئولیت','دختران — کل صحنه',182,192],[family,'پسران — درس ۲۲: شیوه‌های آشنایی برای ازدواج','پسران — کل درس',136,142],[art,'خوشنویسی ـ درس ۴: گرایش‌های هنری با بنیان خوشنویسی و مشق دفتری','کل درس',97,104],[writing,'درس‌ها','درس ۸ — حکایت‌نگاری',107,107]]){const p=entries.find(x=>x.chapter===chapter&&x.title===title);assert.ok(p,title);assert.deepEqual([p.start,p.end],[a,b]);}
 const cfg=async(role,superuser,approved)=>{await db.query("select set_config('test.role',$1,false),set_config('test.super',$2,false),set_config('test.approved',$3,false)",[role,String(superuser),String(approved)])};
 const chapters=()=>db.query("select public.planner_list_topic_chapters('1405','mathematics','12','final_exam','مدیریت خانواده و سبک زندگی') c");
 await cfg('counselor',false,true);let ch=(await chapters()).rows[0].c;assert.equal(ch.length,32);assert.ok(ch.some(x=>x.startsWith('دختران'))&&ch.some(x=>x.startsWith('پسران')));
 let found=(await db.query("select public.planner_list_topics('1405','mathematics','12','final_exam','مدیریت خانواده و سبک زندگی',$1) t",[ch.find(x=>x.startsWith('دختران'))])).rows[0].t;assert.ok(found.length&&found.every(x=>x.title.startsWith('دختران —')));
 await cfg('counselor',false,false);await assert.rejects(chapters);await cfg('admin',false,true);await assert.rejects(chapters);await cfg('admin',true,true);assert.equal((await chapters()).rows[0].c.length,32);
 for(const subject of ['مدیریت خانواده و سبک زندگی','فرهنگ و هنر','نگارش']){const ids=(await db.query('select id from private.planner_topic_bank where subject=$1 and position>=300 order by id limit 2',[subject])).rows;await db.query('delete from private.planner_topic_bank where id=$1',[ids[0].id]);await db.query("update private.planner_topic_bank set title='ویرایش مدیر',revision=2 where id=$1",[ids[1].id]);}
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;for(const s of sql)await db.exec(s);assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,before);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'original',ticks:[true,false],exam:'id',topics:[{title:'اصل',pageStart:3}]});
 console.log('PASS: 1743 added rows, 8 guarded legacy ranges; field/version isolation, real RPC authorization, edits/deletes/rerun and simulated snapshot');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
