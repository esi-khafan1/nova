// Disposable PostgreSQL (WASM) integration tests. Never connects to Supabase.
// Run: node tests/editorial-workflow.test.cjs
const {PGlite}=require('@electric-sql/pglite');
const {readFileSync}=require('node:fs');
const {randomUUID}=require('node:crypto');
const assert=require('node:assert/strict');
const read=p=>readFileSync(p,'utf8');
(async()=>{
 const db=new PGlite();
 const ids=Object.fromEntries(['author','other','manager','admin','super','student'].map(k=>[k,randomUUID()]));
 await db.exec(`create role anon;create role authenticated;create schema auth;create schema private;
 create table auth.users(id uuid primary key);
 create function auth.uid() returns uuid language sql stable as $$ select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid $$;
 create type public.app_role as enum ('student','counselor','admin','exam_designer');
 create type public.approval_status as enum ('pending','approved','rejected');
 create type public.content_status as enum ('draft','published','archived');
 create type public.resource_type as enum ('konkur','final_exam');`);
 for(const file of ['001_initial_schema.sql','022_konkur_news.sql','026_podcasts.sql']){
  const source=read('supabase/migrations/'+file);
  for(const name of ['profiles','counselor_profiles','resources','konkur_news','podcasts']){
   const ddl=source.match(new RegExp('create table public\\.'+name+' \\([\\s\\S]*?\\n\\);'));
   if(ddl)await db.exec(ddl[0]);
  }
 }
 await db.exec(`create table private.super_admins(user_id uuid primary key references public.profiles(id));
 create function private.current_user_role() returns public.app_role language sql stable security definer as $$ select role from public.profiles where id=auth.uid() $$;
 create function private.is_approved_counselor() returns boolean language sql stable security definer as $$ select exists(select 1 from public.counselor_profiles where user_id=auth.uid() and approval_status='approved') $$;
 create function public.admin_list_super_admins() returns table(user_id uuid) language sql stable security definer as $$ select user_id from private.super_admins where private.current_user_role()='admin' $$;
 create function private.is_super_admin() returns boolean language sql stable security definer as $$ select exists(select 1 from private.super_admins where user_id=auth.uid()) $$;
 grant usage on schema public,auth,private to authenticated,anon;
 grant select,insert,update,delete on public.profiles,public.counselor_profiles,public.resources,public.konkur_news,public.podcasts to authenticated;
 alter table public.profiles enable row level security;
 create policy profile_read on public.profiles for select using(id=auth.uid() or private.current_user_role()='admin');
 create policy profile_write on public.profiles for update using(private.current_user_role()='admin');`);
 await db.exec(read('supabase/migrations/058_content_manager_role.sql'));
 await db.exec(read('supabase/migrations/059_editorial_workflow.sql'));
 await db.exec(read('supabase/migrations/060_content_manager_archive.sql'));
 await db.exec('create trigger protect_profile_role before update on public.profiles for each row execute function private.protect_profile_role()');
 for(const [actor,id]of Object.entries(ids)){
  await db.query('insert into auth.users values($1)',[id]);
  await db.query('insert into public.profiles(id,full_name,role) values($1,$2,$3)',[id,actor,['author','other'].includes(actor)?'counselor':actor==='super'?'admin':actor==='manager'?'content_manager':actor]);
 }
 await db.query("insert into public.counselor_profiles(user_id,approval_status) values($1,'approved'),($2,'approved')",[ids.author,ids.other]);
 await db.query('insert into private.super_admins values($1)',[ids.super]);
 const actor=async key=>{await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub',$1,false)",[ids[key]]);await db.exec('set role authenticated');};
 const scalar=async(sql,args=[])=>Object.values((await db.query(sql,args)).rows[0])[0];
 const denied=async(sql,args,pattern)=>assert.rejects(()=>db.query(sql,args),pattern);
 await actor('admin');
 await denied('select public.admin_set_user_role($1,$2)',[ids.student,'content_manager'],/super administrators/);
 await denied('select public.admin_set_user_role($1,$2)',[ids.super,'student'],/super administrators|protected/);
 await actor('super');
 await db.query('select public.admin_set_user_role($1,$2)',[ids.admin,'student']);
 assert.equal(await scalar('select role from public.profiles where id=$1',[ids.admin]),'student');
 await db.query('select public.admin_set_user_role($1,$2)',[ids.admin,'admin']);
 await db.query('select public.admin_set_user_role($1,$2)',[ids.student,'content_manager']);
 await db.query('select public.admin_set_user_role($1,$2)',[ids.student,'student']);
 await denied('select public.admin_set_user_role($1,$2)',[ids.super,'student'],/protected/);
 await actor('admin');
 await denied('select public.admin_set_user_role($1,$2)',[ids.manager,'student'],/super administrators/);
 await denied("update public.profiles set role='student' where id=$1",[ids.manager],/Super administrator required/);
 const payloads={
  resources:{title:'Original article',summary:'Summary',resource_type:'konkur',grade:12,subject:'Math'},
  news:{title:'Original news',summary:'Summary',source_name:'Official',source_url:'https://example.com/source',source_published_at:'2020-01-01'},
  podcasts:{title:'Original podcast',summary:'Summary',resource_type:'konkur',audio_url:'https://example.com/audio.mp3',audio_seconds:60},
 };
 for(const [kind,base]of Object.entries(payloads)){
  const table=kind==='news'?'konkur_news':kind;
  const p={...base,body:JSON.stringify({type:'doc',content:[{type:'paragraph',content:[{type:'text',text:'A long enough article body for testing.'}]}]})};
  const save=(cid,pending,version,payload=p)=>db.query('select public.save_content_submission($1,$2,$3,$4,$5) as id',[kind,cid,payload,pending,version]);
  const review=(id,decision,reason,version)=>db.query('select public.review_content_submission($1,$2,$3,$4)',[id,decision,reason,version]);
  await actor('author');
  const cid=(await save(null,false,0)).rows[0].id;
  const s=(await db.query('select * from public.content_submissions where content_id=$1',[cid])).rows[0];
  assert.equal(s.state,'draft');assert.equal(await scalar(`select count(*)::int from public.${table} where id=$1`,[cid]),0);
  await actor('other');assert.equal(await scalar('select count(*)::int from public.content_submissions where id=$1',[s.id]),0);
  await denied('select public.save_content_submission($1,$2,$3,true,1)',[kind,cid,p],/Not your submission/);
  await actor('manager');assert.equal(await scalar('select count(*)::int from public.content_submissions where id=$1',[s.id]),0);
  await actor('author');await save(cid,true,1);
  await denied('select public.save_content_submission($1,$2,$3,true,2)',[kind,cid,p],/under review/);
  await denied(`insert into public.${table} select (jsonb_populate_record(null::public.${table},$1)).*`,[{...p,id:randomUUID(),author_id:ids.author,status:'published',published_at:new Date().toISOString(),created_at:new Date().toISOString(),updated_at:new Date().toISOString(),...(kind==='podcasts'?{is_sample:false}:{})}],/editorial submission workflow/);
  for(const who of ['author','admin','super','student']){
   await actor(who);await denied('select public.review_content_submission($1,$2,$3,$4)',[s.id,'approve','',2],/Content manager only/);
   await denied('select public.edit_content_submission($1,$2,$3)',[s.id,p,2],/Content manager only/);
  }
  await actor('manager');
  await denied('select public.review_content_submission($1,$2,$3,$4)',[s.id,'reject','',2],/reason required/);
  await denied('select public.review_content_submission($1,$2,$3,$4)',[s.id,null,null,2],/Invalid decision/);
  await denied('select public.review_content_submission($1,$2,$3,$4)',[s.id,'approve',null,null],/changed/);
  const revised={...p,title:'Manager revised title'};
  await db.query('select public.edit_content_submission($1,$2,$3)',[s.id,revised,2]);
  await denied('select public.review_content_submission($1,$2,$3,$4)',[s.id,'approve','',2],/changed/);
  await review(s.id,'approve','',3);
  assert.equal(await scalar(`select title from public.${table} where id=$1`,[cid]),revised.title);
  const publishedAt=await scalar(`select published_at::text from public.${table} where id=$1`,[cid]);
  await denied(`update public.${table} set title='Direct manager update' where id=$1`,[cid],/editorial submission workflow/);
  await actor('author');
  const newPayload={...p,title:'Second revision'};
  await save(cid,true,4,newPayload);
  assert.equal(await scalar(`select title from public.${table} where id=$1`,[cid]),revised.title);
  await actor('manager');await review(s.id,'reject','Please improve the sources',5);
  assert.equal(await scalar(`select title from public.${table} where id=$1`,[cid]),revised.title);
  await actor('author');
  assert.equal(await scalar('select rejection_reason from public.content_submissions where id=$1',[s.id]),'Please improve the sources');
  await save(cid,true,6,newPayload);
  await denied('select public.save_content_submission($1,$2,$3,true,6)',[kind,cid,newPayload],/under review/);
  await actor('manager');await review(s.id,'approve','',7);
  assert.equal(await scalar(`select title from public.${table} where id=$1`,[cid]),newPayload.title);
  assert.equal(await scalar(`select published_at::text from public.${table} where id=$1`,[cid]),publishedAt);
  await denied('select public.review_content_submission($1,$2,$3,$4)',[s.id,'approve','',7],/changed/);
  const liveUpdated=await scalar(`select updated_at::text from public.${table} where id=$1`,[cid]);
  // Archive permissions are independent of review rights and direct table grants.
  for(const who of ['author','other','admin','super','student']){
   await actor(who);
   await denied('select public.archive_editorial_content($1,$2,$3)',[kind,cid,liveUpdated],/Content manager only/);
   await denied('select * from public.list_editorial_live($1,0)',['published'],/Content manager only/);
  }
  await actor('manager');
  assert.ok((await db.query('select * from public.list_editorial_live($1,0)',['published'])).rows.some(r=>r.content_id===cid));
  await denied('select public.archive_editorial_content($1,$2,$3)',[kind,cid,null],/Invalid content/);
  await denied('select public.archive_editorial_content($1,$2,$3)',[kind,cid,'2000-01-01'],/changed/);
  // Keep a pending revision while archiving its older public version.
  await actor('author');await save(cid,true,8,newPayload);
  await actor('manager');
  await db.query('select public.archive_editorial_content($1,$2,$3)',[kind,cid,liveUpdated]);
  assert.equal(await scalar(`select status from public.${table} where id=$1`,[cid]),'archived');
  assert.equal(await scalar(`select published_at from public.${table} where id=$1`,[cid]),null);
  assert.equal(await scalar(`select title from public.${table} where id=$1`,[cid]),newPayload.title);
  assert.equal(await scalar('select state from public.content_submissions where id=$1',[s.id]),'pending');
  assert.equal(await scalar('select version from public.content_submissions where id=$1',[s.id]),9);
  assert.ok((await db.query('select * from public.list_editorial_live($1,0)',['archived'])).rows.some(r=>r.content_id===cid));
  assert.ok(!(await db.query('select * from public.list_editorial_live($1,0)',['published'])).rows.some(r=>r.content_id===cid));
  await denied('select public.archive_editorial_content($1,$2,$3)',[kind,cid,liveUpdated],/changed/);
 }
 // A seed with no author must never be claimable; ownership changes at approval
 // time must fail atomically without moving a pending submission out of the queue.
 await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub','',false)");
 const sample=randomUUID();
 await db.query("insert into public.konkur_news(id,title,body,source_name,source_url,source_published_at,status,published_at) values($1,'Seed news','Seed body','Source','https://example.com','2020-01-01','published',now())",[sample]);
 await actor('author');
 await denied('select public.save_content_submission($1,$2,$3,true,0)',['news',sample,{...payloads.news,body:JSON.stringify({type:'doc',content:[]})}],/Not your content/);
 const existing=(await db.query("select * from public.content_submissions where kind='resources'")).rows[0];
 // This revision was already pending when its public version was archived.

 await denied("insert into public.content_submissions(kind,content_id,author_id,payload) values('resources',$1,$2,$3)",[randomUUID(),ids.author,existing.payload],/permission denied/);
 await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub','',false)");
 await db.query('update public.resources set author_id=$1 where id=$2',[ids.other,existing.content_id]);
 await actor('manager');
 await denied('select public.review_content_submission($1,$2,$3,$4)',[existing.id,'approve','',existing.version],/ownership changed/);
 assert.equal(await scalar('select state from public.content_submissions where id=$1',[existing.id]),'pending');
 await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub','',false)");await db.exec('set role anon');
 await denied('select public.review_content_submission($1,$2,$3,$4)',[existing.id,'approve','',existing.version],/permission denied/);
 await actor('admin');assert.equal(await scalar('select count(*)::int from public.content_submissions'),0);
 await actor('manager');assert.equal((await db.query('select * from public.editorial_authors()')).rows.length,1);
 await db.exec('reset role');
 assert.equal(await scalar('select count(*)::int from private.content_review_events'),12);
 assert.equal(await scalar('select count(*)::int from private.content_archive_events'),3);
 await db.close();console.log('Editorial PostgreSQL integration passed: all 3 kinds, role guards, RLS, drafts, pending lock, editing, rejection/resubmission, stale versions, preserved live content and timestamps, manager-only archiving with unchanged pending revisions.');
})().catch(e=>{console.error(e);process.exit(1);});
