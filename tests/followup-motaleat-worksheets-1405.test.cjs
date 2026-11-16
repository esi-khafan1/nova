const fs=require('node:fs'),assert=require('node:assert/strict'),crypto=require('node:crypto'),{PGlite}=require('@electric-sql/pglite');
const sql=n=>fs.readFileSync(`supabase/migrations/${n}.sql`,'utf8');
const migration=sql('242_planner_followup_motaleat_worksheets_1405'),topics=JSON.parse(migration.split('$topics$')[1]);
// The 18 worksheets, in position order: [position, title, lesson, PDF page(s)].
const expected=[
 [3000,'کاربرگه ۱: طول و عرض جغرافیایی','درس ۱','PDF p.178'],
 [3001,'کاربرگه ۲: طول و عرض جغرافیایی بر روی نقشه','درس ۱','PDF p.179'],
 [3002,'کاربرگه ۳: انواع ناهمواری‌ها','درس ۳','PDF p.180'],
 [3003,'کاربرگه ۴: رابطه پراکندگی زیست‌بوم‌های جهان با عرض جغرافیایی و بارش','درس ۵','PDF p.181'],
 [3004,'کاربرگه ۵: زیست‌بوم‌های جهان','درس ۵','PDF p.182'],
 [3005,'کاربرگه ۶: شگفتی‌های آفریقا','درس ۵','PDF p.183'],
 [3006,'کاربرگه ۷: نقشه سیاسی ایران در آستانه تأسیس حکومت صفویه','درس ۹','PDF pp.184–185'],
 [3007,'کاربرگه ۸: اداره شهرها و روستاها در عصر صفوی','درس ۱۰','PDF p.186'],
 [3008,'کاربرگه ۹: جدایی سرزمین‌های ایرانی در دوره قاجار','درس ۱۱','PDF p.187'],
 [3009,'کاربرگه ۱۰: زمینه‌ها و عوامل نهضت مشروطه','درس ۱۳','PDF p.188'],
 [3010,'کاربرگه ۱۱: سخن امام درباره قرآن و روحانیت','درس ۱۵','PDF p.189'],
 [3011,'کاربرگه ۱۲: رویدادهای مهم انقلاب اسلامی در سال ۱۳۵۷','درس ۱۵','PDF p.190'],
 [3012,'کاربرگه ۱۳: لایه‌های فرهنگ','درس ۱۷','PDF pp.191–193'],
 [3013,'کاربرگه ۱۴: سازگاری والدین و فرزندان','درس ۲۰','PDF p.194'],
 [3014,'کاربرگه ۱۵: سازگاری والدین و فرزندان','درس ۲۰','PDF p.195'],
 [3015,'کاربرگه ۱۶: حقوق و تکالیف شهروندی','درس ۲۲','PDF p.196'],
 [3016,'کاربرگه ۱۷: بهره‌وری','درس ۲۳','PDF p.197'],
 [3017,'کاربرگه ۱۸: حل مسئله','درس ۲۴','PDF p.198']];
const uuid=hex=>`${hex.slice(0,8)}-${hex.slice(8,12)}-${hex.slice(12,16)}-${hex.slice(16,20)}-${hex.slice(20)}`;
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema private;create type public.app_role as enum ('admin','counselor','student');
 create function private.current_user_role() returns public.app_role language sql stable as $$select current_setting('test.role','true')::public.app_role$$;
 create function private.is_super_admin() returns boolean language sql stable as $$select current_setting('test.super','true')::boolean$$;
 create function private.require_planner_preset_access() returns void language plpgsql as $$begin if current_setting('test.approved','true')<>'true' then raise exception 'not approved' using errcode='42501';end if;end$$;
 create table private.planner_seed_installations(seed_key text primary key);
 create table published_snapshot(content jsonb);insert into published_snapshot values ('{"plan":"p1","ticks":[true,false],"exam":"e1","topics":[{"title":"old","pageStart":12}]}');`);
 // Dependency migrations in numeric order: 128 schema + save/delete, 133 chapter
 // listing, 151 grade-9 seeds (incl. the 24 مطالعات اجتماعی rows, 8 NULL-page),
 // 167 install-marker table, 192 super-admin save/delete.
 for(const n of ['128_planner_topic_bank','133_planner_topic_chapters','151_planner_grade9_topics','167_planner_english9_1405_pages','192_planner_topic_super_admin'])await db.exec(sql(n));
 assert.equal(topics.length,18);
 // The migration's JSON must be exactly the expected 18, positions 3000-3017.
 assert.deepEqual(topics.map(t=>[t.position,t.title]),expected.map(([p,t])=>[p,t]));
 assert.ok(topics.every(t=>t.grade==='9'&&t.subject==='مطالعات اجتماعی'&&t.chapter==='کاربرگه‌ها'&&t.start===null&&t.end===null),'all topics grade 9 / کاربرگه‌ها / NULL pages');
 // Chapter کاربرگه‌ها does not exist yet; record the pre-existing NULL-page count.
 const before=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const beforeWs=(await db.query("select count(*) c from private.planner_topic_bank where subject='مطالعات اجتماعی' and chapter='کاربرگه‌ها'")).rows[0].c;
 assert.equal(Number(beforeWs),0);
 const beforeNull=Number((await db.query("select count(*) c from private.planner_topic_bank where subject='مطالعات اجتماعی' and page_start is null")).rows[0].c);
 assert.equal(beforeNull,8,'migration 151 seeds 8 NULL-page مطالعات اجتماعی rows');
 await db.exec(migration);
 // Exactly 18 rows for chapter کاربرگه‌ها, all NULL-page, one combo only.
 const ws=(await db.query("select id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position,revision from private.planner_topic_bank where subject='مطالعات اجتماعی' and chapter='کاربرگه‌ها' order by position")).rows;
 assert.equal(ws.length,18);
 for(let i=0;i<18;i++){
  const [pos,title]=[expected[i][0],expected[i][1]];
  assert.deepEqual([ws[i].edition,ws[i].study_field,ws[i].grade,ws[i].preparation_track,ws[i].subject,ws[i].chapter,ws[i].title,ws[i].page_start,ws[i].page_end,ws[i].position,ws[i].revision],['1405','all','9','final_exam','مطالعات اجتماعی','کاربرگه‌ها',title,null,null,pos,1]);
  const want=uuid(crypto.createHash('md5').update(`nova:planner:1405:v242:all:9:final_exam:مطالعات اجتماعی:کاربرگه‌ها:${pos}`,'utf8').digest('hex'));
  assert.equal(ws[i].id,want,`id formula mismatch at position ${pos}`);
 }
 // No konkur rows for this chapter, and no other NULL-page rows from this migration:
 // the subject's NULL-page count grew by exactly 18.
 const afterNull=Number((await db.query("select count(*) c from private.planner_topic_bank where subject='مطالعات اجتماعی' and page_start is null")).rows[0].c);
 assert.equal(afterNull,beforeNull+18);
 assert.equal(Number((await db.query("select count(*) c from private.planner_topic_bank where subject='مطالعات اجتماعی' and chapter='کاربرگه‌ها' and preparation_track='konkur'")).rows[0].c),0);
 // Only 18 new ids in the whole bank; nothing else changed.
 const after=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 const newIds=new Set(after.filter(a=>!before.some(b=>b.id===a.id)).map(a=>a.id));
 assert.equal(newIds.size,18);
 assert.deepEqual(after.filter(a=>!newIds.has(a.id)),before);
 // planner_list_topics serves the 18 worksheets (NULL pages) to an admin.
 await db.query("select set_config('test.role','admin',false),set_config('test.super','true',false),set_config('test.approved','true',false)");
 const listed=(await db.query("select public.planner_list_topics('1405','all','9','final_exam','مطالعات اجتماعی','کاربرگه‌ها') v")).rows[0].v;
 assert.equal(listed.length,18);
 assert.ok(listed.every(t=>t.pageStart===null&&t.pageEnd===null&&t.chapter==='کاربرگه‌ها'));
 assert.deepEqual(listed.map(t=>t.title),expected.map(([,t])=>t));
 // Chapter discovery also lists کاربرگه‌ها (NULL first page sorts last).
 const chapters=(await db.query("select public.planner_list_topic_chapters('1405','all','9','final_exam','مطالعات اجتماعی') v")).rows[0].v;
 assert.ok(chapters.includes('کاربرگه‌ها'));
 // Re-running is a no-op.
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,after);
 // Simulated super-admin edit via planner_save_topic and delete of a new row survive a re-run.
 const edit=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='مطالعات اجتماعی' and chapter='کاربرگه‌ها' and position=3000")).rows[0];
 await db.query("select public.planner_save_topic($1,$2,'1405','all','9','final_exam','مطالعات اجتماعی','کاربرگه‌ها','ویرایش مدیر',null,null,3000)",[edit.id,edit.r]);
 const del=(await db.query("select id,revision::text r from private.planner_topic_bank where subject='مطالعات اجتماعی' and chapter='کاربرگه‌ها' and position=3017")).rows[0];
 await db.query('select public.planner_delete_topic($1,$2)',[del.id,del.r]);
 const current=(await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v;
 await db.exec(migration);
 assert.deepEqual((await db.query('select jsonb_agg(to_jsonb(t) order by id) v from private.planner_topic_bank t')).rows[0].v,current);
 // The edit survived (title changed, revision bumped) and the delete was NOT resurrected.
 const edited=(await db.query("select title,revision,page_start from private.planner_topic_bank where id=$1",[edit.id])).rows[0];
 assert.deepEqual([edited.title,edited.revision,edited.page_start],['ویرایش مدیر',2,null]);
 assert.equal(Number((await db.query("select count(*) c from private.planner_topic_bank where id=$1",[del.id])).rows[0].c),0);
 assert.equal(Number((await db.query("select count(*) c from private.planner_topic_bank where subject='مطالعات اجتماعی' and chapter='کاربرگه‌ها'")).rows[0].c),17);
 assert.deepEqual((await db.query('select content from published_snapshot')).rows[0].content,{plan:'p1',ticks:[true,false],exam:'e1',topics:[{title:'old',pageStart:12}]});
 console.log('PASS: Follow-up 3: 18 کاربرگه worksheets (positions 3000-3017, all NULL-page, final_exam only); ids v242; rerun no-op; admin edit survives; admin delete NOT resurrected; snapshot untouched');
}finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
