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
 for(const table of ['resources','konkur_news','podcasts'])await db.exec(`alter table public.${table} enable row level security;grant select on public.${table} to anon;create policy baseline_read on public.${table} for select using(status='published' or author_id=auth.uid() or private.current_user_role()='admin');`);
 await db.exec(read('supabase/migrations/067_manage_archived_content.sql'));
 await db.exec(`create type public.study_field as enum ('mathematics','experimental_sciences','humanities','arts','foreign_languages');alter table public.profiles add column study_field public.study_field;alter table public.profiles add column registration_status text not null default 'active';`);
 await db.exec(read('supabase/migrations/062_dashboard_latency.sql'));
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
 // The own-profile RPC cannot return another account, even for an admin.
 await actor('super');
 let own=(await db.query('select * from public.own_dashboard_profile()')).rows;
 assert.equal(own.length,1);assert.equal(own[0].id,ids.super);
 let counts=(await db.query('select * from public.admin_dashboard_counts()')).rows[0];
 assert.equal(Number(counts.users),6);assert.equal(Number(counts.students),1);assert.equal(Number(counts.counselors),2);
 for(const who of ['student','author','manager']){
  await actor(who);own=(await db.query('select * from public.own_dashboard_profile()')).rows;
  assert.equal(own.length,1);assert.equal(own[0].id,ids[who]);
  await denied('select * from public.admin_dashboard_counts()',[],/Admin only/);
 }
 await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub','',false)");await db.exec('set role anon');
 await denied('select * from public.own_dashboard_profile()',[],/permission denied/);
 await denied('select * from public.admin_dashboard_counts()',[],/permission denied/);
 const payloads={
  resources:{title:'Original article',summary:'Summary',resource_type:'konkur',grade:12,subject:'Math'},
  news:{title:'Original news',summary:'Summary',source_name:'Official',source_url:'https://example.com/source',source_published_at:'2020-01-01'},
  podcasts:{title:'Original podcast',summary:'Summary',resource_type:'konkur',audio_url:'https://example.com/audio.mp3',audio_seconds:60},
 };

 for(const [kind,base]of Object.entries(payloads)){
  const table=kind==='news'?'konkur_news':kind;
  const p={...base,body:JSON.stringify({type:'doc',content:[{type:'paragraph',content:[{type:'text',text:'A long enough article body for testing.'}]}]})};
  await actor('author');
  const cid=await scalar('select public.save_content_submission($1,null,$2,true,0)',[kind,p]);
  let submission=(await db.query('select * from public.content_submissions where content_id=$1',[cid])).rows[0];
  await actor('manager');await db.query("select public.review_content_submission($1,'approve','',1)",[submission.id]);
  const stamp=()=>scalar(`select updated_at::text from public.${table} where id=$1`,[cid]);
  const manage=(operation,updated,payload=null,reason=null)=>db.query('select public.manage_archived_content($1,$2,$3,$4,$5,$6)',[kind,cid,updated,operation,payload,reason]);
  await assert.rejects(()=>manage('publish','2000-01-01'),/changed/);
  await db.query('select public.archive_editorial_content($1,$2,$3)',[kind,cid,await stamp()]);
  assert.equal(await scalar(`select count(*)::int from public.${table} where id=$1`,[cid]),1,'manager must read archived rows under RLS');
  await db.exec('reset role;set role anon');assert.equal(await scalar(`select count(*)::int from public.${table} where id=$1`,[cid]),0);
  await actor('other');assert.equal(await scalar(`select count(*)::int from public.${table} where id=$1`,[cid]),0);
  await actor('manager');let updated=await stamp();
  for(const who of ['author','other','admin','super','student']){await actor(who);await assert.rejects(()=>manage('publish',updated),/Content manager only/);}
  await actor('manager');
  await assert.rejects(()=>manage('return',updated,null,'bad'),/Rejection reason/);
  await manage('edit',updated,{...p,title:'Edited archive',author_id:ids.other,status:'published'});
  assert.equal(await scalar(`select status from public.${table} where id=$1`,[cid]),'archived');
  assert.equal(await scalar(`select author_id from public.${table} where id=$1`,[cid]),ids.author);
  assert.equal(await scalar(`select title from public.${table} where id=$1`,[cid]),'Edited archive');
  await assert.rejects(()=>manage('publish',updated),/changed/);
  await manage('publish',await stamp());
  assert.equal(await scalar(`select status from public.${table} where id=$1`,[cid]),'published');
  await db.query('select public.archive_editorial_content($1,$2,$3)',[kind,cid,await stamp()]);
  await manage('return',await stamp(),null,'Please correct the references');
  await actor('author');
  submission=(await db.query('select * from public.content_submissions where content_id=$1',[cid])).rows[0];
  assert.equal(submission.state,'rejected');assert.equal(submission.rejection_reason,'Please correct the references');assert.equal(submission.payload.title,'Edited archive');
  assert.equal(await scalar(`select status from public.${table} where id=$1`,[cid]),'archived');
  await db.query('select public.save_content_submission($1,$2,$3,true,$4)',[kind,cid,p,submission.version]);
  await actor('manager');
  updated=await stamp();
  const before=(await db.query('select * from public.content_submissions where content_id=$1',[cid])).rows[0];
  await assert.rejects(()=>manage('return',updated,null,'Return pending again'),/Author revision exists/);
  await manage('edit',updated,{...p,title:'Manager archived edit'});
  await manage('publish',await stamp());
  assert.deepEqual((await db.query('select * from public.content_submissions where content_id=$1',[cid])).rows[0],before);
  await db.query("select public.review_content_submission($1,'approve','',$2)",[before.id,before.version]);
  assert.equal(await scalar(`select title from public.${table} where id=$1`,[cid]),p.title);
 }
 // Legacy NULL-author content can be edited/published but cannot be assigned to a new author.
 await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub','',false)");
 const legacy=randomUUID();await db.query("insert into public.konkur_news(id,title,body,source_name,source_url,source_published_at,status) values($1,'Legacy article','Long enough legacy content body for testing','Source','https://example.com','2020-01-01','archived')",[legacy]);
 await actor('manager');
 const legacyStamp=await scalar('select updated_at::text from public.konkur_news where id=$1',[legacy]);
 await denied("select public.manage_archived_content('news',$1,$2,'return',null,'Please fix this content')",[legacy,legacyStamp],/No eligible author/);
 await db.query("select public.manage_archived_content('news',$1,$2,'publish')",[legacy,legacyStamp]);
 assert.equal(await scalar('select author_id from public.konkur_news where id=$1',[legacy]),null);
 await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub','',false)");
 const authoredLegacy=randomUUID();await db.query("insert into public.konkur_news(id,author_id,title,body,source_name,source_url,source_published_at,status) values($1,$2,'Legacy author article','Long enough legacy content body for testing','Source','https://example.com','2020-01-01','archived')",[authoredLegacy,ids.author]);
 await actor('manager');
 const authoredStamp=await scalar('select updated_at::text from public.konkur_news where id=$1',[authoredLegacy]);
 await db.query("select public.manage_archived_content('news',$1,$2,'return',null,'Please correct this legacy article')",[authoredLegacy,authoredStamp]);
 await actor('author');
 const returned=(await db.query('select * from public.content_submissions where content_id=$1',[authoredLegacy])).rows[0];
 assert.equal(returned.state,'rejected');assert.equal(JSON.parse(returned.payload.body).type,'doc');
 assert.equal(returned.author_id,ids.author);

 await db.exec('reset role;set role anon');
 await denied("select public.manage_archived_content('news',$1,$2,'publish')",[legacy,legacyStamp],/permission denied/);
 await db.exec('reset role');assert.equal(await scalar('select count(*)::int from private.archived_content_events'),17);
 await db.close();console.log('Archived content: all three kinds edit/restore/return-resubmit-approve, ownership and reason guards, stale edits, role denial, pending preservation, legacy NULL authors and audit passed.');
})().catch(e=>{console.error(e);process.exit(1);});
