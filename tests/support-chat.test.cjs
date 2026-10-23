// Disposable PostgreSQL (WASM) integration tests. Never connects to Supabase.
// Run: node tests/support-chat.test.cjs
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
 await denied('select public.admin_set_user_role($1,$2)',[ids.super,'student'],/protected|super administrators/);
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

 await db.exec('reset role');
 await db.exec(read('supabase/migrations/069_support_role.sql'));
 await db.exec(`create schema realtime;create table realtime.test_events(topic text,payload jsonb);create function realtime.send(payload jsonb,event text,topic text,private boolean) returns void language sql as $$insert into realtime.test_events values(topic,payload)$$;`);
 await db.exec(read('supabase/migrations/070_support_chat.sql'));
 await db.exec(read('supabase/migrations/071_support_rate_indexes.sql'));
 await actor('admin');await db.query("select public.admin_set_user_role($1,'support_agent')",[ids.student]);
 assert.equal(await scalar('select role from public.profiles where id=$1',[ids.student]),'support_agent');
 await denied("select public.admin_set_user_role($1,'support_agent')",[ids.super],/protected|super administrators/);
 const a='a'.repeat(64),b='b'.repeat(64),c='c'.repeat(64);
 const guest=async()=>{await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub','',false)");await db.exec('set role anon');};
 const visitor=(token,body=null,after=0)=>scalar('select public.support_visitor($1,$2,$3)',[token,after,body]);
 await guest();assert.deepEqual(await visitor(a),{messages:[]});
 await visitor(a,'hello guest');assert.equal((await visitor(b)).messages.length,0);
 await denied('select * from private.support_threads',[],/permission denied/);
 await denied('select public.support_inbox(true,0)',[],/permission denied/);
 await assert.rejects(()=>visitor(a,'too fast'),/wait before sending/);
 await assert.rejects(()=>visitor(c,'x'.repeat(2001)),/Invalid message/);
 await actor('author');await visitor(b,'account message');
 await actor('other');await assert.rejects(()=>visitor(b),/Session changed/);
 await guest();await assert.rejects(()=>visitor(b),/Session changed/);
 await actor('student');
 let inbox=await scalar('select public.support_inbox(true,0)');assert.equal(inbox.length,2);
 const ga=inbox.find(t=>t.visitor_name==='مهمان'),registered=inbox.find(t=>t.visitor_name==='author');assert.ok(ga);assert.ok(registered);
 const reply=await scalar("select public.support_agent_thread($1,0,'Hello from support')",[ga.id]);
 assert.equal(reply.messages.length,2);assert.deepEqual(Object.keys(reply.messages[1]).sort(),['id','sender','body','created_at'].sort());assert.equal(reply.messages[1].sender,'support');
 assert.equal((await scalar('select public.support_inbox(false,0)')).length,1);
 await guest();const messages=(await visitor(a)).messages;assert.equal(messages[1].body,'Hello from support');assert.ok(!JSON.stringify(messages).includes(ids.student));
 // Rate-limit time travel is confined to the disposable test DB.
 await db.exec('reset role');await db.exec("update private.support_messages set created_at=now()-interval '3 seconds'");
 await guest();await visitor(a,'new visitor message');
 await actor('student');assert.equal((await scalar('select public.support_inbox(true,0)')).length,2);
 for(const who of ['author','other','admin','super','manager']){await actor(who);await denied('select public.support_inbox(true,0)',[],/Support only/);await denied('select public.support_agent_thread($1,0,null)',[ga.id],/Support only/);}
 await actor('admin');await db.query("select public.admin_set_user_role($1,'student')",[ids.student]);await actor('student');await denied('select public.support_inbox(true,0)',[],/Support only/);
 await db.exec('reset role');
 await db.query("insert into private.support_messages(thread_id,sender,body) select $1,'visitor','history '||i from generate_series(1,201) i",[registered.id]);
 await actor('author');let history=await visitor(b);assert.equal(history.messages.length,200);let next=await visitor(b,null,history.messages.at(-1).id);assert.equal(next.messages.length,2);
 await db.exec('reset role');assert.equal(await scalar('select count(*)::int from private.support_threads'),2);
 assert.ok((await db.query('select * from realtime.test_events')).rows.length>0);assert.ok((await db.query('select * from realtime.test_events')).rows.every(r=>JSON.stringify(r.payload)==='{"changed":true}'));
 await db.exec(`create or replace function realtime.send(payload jsonb,event text,topic text,private boolean) returns void language plpgsql as $$begin raise exception 'tenant_events quota';end;$$;update private.support_messages set created_at=now()-interval '3 seconds';`);
 await guest();const saved=await visitor(a,'Saved despite Realtime quota');assert.equal(saved.messages.at(-1).body,'Saved despite Realtime quota');
 await db.close();console.log('Support PostgreSQL: guest isolation, account names/ownership, hidden agent identity, text limits/throttle, unanswered transitions, role revocation and ordinary/super admin role guards passed.');
})().catch(e=>{console.error(e);process.exitCode=1;});
