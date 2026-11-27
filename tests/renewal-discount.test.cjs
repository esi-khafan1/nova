// Synthetic database: never uses or prints the real discount secret.
const {PGlite}=require('@electric-sql/pglite'),{randomUUID}=require('node:crypto'),fs=require('node:fs'),assert=require('node:assert/strict');
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon;create role authenticated;create schema auth;create schema private;create schema storage;
 create type public.app_role as enum('student','counselor','admin');
 create table public.profiles(id uuid primary key,full_name text,phone text,role public.app_role,registration_status text);
 create table auth.users(id uuid primary key,email_confirmed_at timestamptz,phone_confirmed_at timestamptz);
 create table private.student_account_blocks(student_id uuid primary key);
 create table private.course_offer_settings(grade smallint,plan text,monthly_price integer,primary key(grade,plan));
 create table private.course_sale_status(singleton boolean primary key,sold_out boolean);
 insert into private.course_sale_status values(true,false);insert into private.course_offer_settings values(10,'base',2490000);
 create table public.student_registrations(student_id uuid primary key,receipt_path text);
 create table storage.objects(id uuid primary key default gen_random_uuid(),bucket_id text,name text unique);
 create function storage.foldername(text) returns text[] language sql immutable as $$select string_to_array($1,'/')$$;
 create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid$$;
 create function private.current_user_role() returns public.app_role language sql stable security definer as $$select role from public.profiles where id=auth.uid()$$;
 create function public.course_enrollment_open() returns boolean language sql stable security definer as $$select not sold_out from private.course_sale_status where singleton$$;
 grant usage on schema auth,private,storage,public to anon,authenticated;grant select on public.profiles,storage.objects to authenticated;grant insert,delete on storage.objects to authenticated;
 alter table storage.objects enable row level security;
 create policy own_read on storage.objects for select to authenticated using(split_part(name,'/',1)=auth.uid()::text or private.current_user_role()='admin');
 create policy own_remove on storage.objects for delete to authenticated using(split_part(name,'/',1)=auth.uid()::text);
 `);
 await db.exec(fs.readFileSync('supabase/migrations/257_renewal_discount.sql','utf8'));
 const a=randomUUID(),b=randomUUID(),admin=randomUUID(),inactive=randomUUID();
 for(const [id,role,status] of [[a,'student','active'],[b,'student','active'],[admin,'admin','active'],[inactive,'student','pending']]){
  await db.query('insert into auth.users values($1,now(),null)',[id]);await db.query('insert into public.profiles values($1,$2,null,$3,$4)',[id,'Test user',role,status]);
 }
 await db.query("insert into public.student_registrations values($1,$2)",[a,`${a}/old.jpg`]);
 // A deliberately unrelated fixture password; production material never appears in this test or repository.
 await db.query("insert into private.renewal_discount_secret(salt,digest) values(decode(repeat('ab',32),'hex'),sha256(decode(repeat('ab',32),'hex')||convert_to($1,'UTF8')))",['SAMPLE']);
 const actor=async id=>{await db.exec('reset role');await db.query("select set_config('request.jwt.claim.sub',$1,false)",[id??'']);await db.exec('set role authenticated')};
 const quote=async code=>(await db.query("select public.quote_student_renewal(10::smallint,'humanities','base',3::smallint,$1) v",[code])).rows[0].v;
 await actor(inactive);await assert.rejects(()=>quote('SAMPLE'),/Renewal unavailable/);
 await actor(a);await assert.rejects(()=>db.query('select * from private.renewal_discount_secret'),/permission denied/);
 for(let n=0;n<8;n++)assert.equal((await quote('wrong')).status,'invalid');assert.equal((await quote('SAMPLE')).status,'limited');
 await db.exec('reset role');await db.query("update private.renewal_discount_attempts set window_start=now()-interval '16 minutes' where student_id=$1",[a]);await actor(a);
 const q=await quote(' sample ');assert.equal(q.status,'ok');assert.equal(q.base_price,7470000);assert.equal(q.discount_percent,15);assert.equal(q.payable_price,6349500);
 const full=await quote('');assert.equal(full.payable_price,7470000);assert.equal(full.discount_percent,0);
 const receipt=`${a}/renewal/${randomUUID()}.jpg`;await db.query('insert into storage.objects(bucket_id,name) values($1,$2)',['registration-receipts',receipt]);
 await actor(b);await assert.rejects(()=>db.query('select public.submit_student_renewal($1,$2,$3)',[q.quote_id,receipt,'r.jpg']),/Quote unavailable/);
 await actor(a);const rid=(await db.query('select public.submit_student_renewal($1,$2,$3) v',[q.quote_id,receipt,'r.jpg'])).rows[0].v;
 assert.equal((await db.query('select public.student_renewal_receipt($1) v',[rid])).rows[0].v,receipt);
 await assert.rejects(()=>db.query('select public.submit_student_renewal($1,$2,$3)',[q.quote_id,receipt,'r.jpg']),/Quote unavailable/);
 const removed=await db.query('delete from storage.objects where name=$1 returning name',[receipt]);assert.equal(removed.rows.length,0,'submitted receipts cannot be deleted by owner');
 const receipt2=`${a}/renewal/${randomUUID()}.jpg`;await db.query('insert into storage.objects(bucket_id,name) values($1,$2)',['registration-receipts',receipt2]);
 await assert.rejects(()=>db.query('select public.submit_student_renewal($1,$2,$3)',[full.quote_id,receipt2,'r.jpg']),/student_renewal_one_pending/);
 await assert.rejects(()=>db.query('select public.admin_list_student_renewals()'),/Admin only/);
 await actor(b);await assert.rejects(()=>db.query('select public.student_renewal_receipt($1)',[rid]),/Receipt unavailable/);
 await actor(admin);let rows=(await db.query('select public.admin_list_student_renewals() v')).rows[0].v;assert.equal(rows.length,1);assert.equal(rows[0].payable_price,6349500);assert.equal(rows[0].discount_percent,15);
 await db.query('select public.admin_review_student_renewal($1)',[rid]);await assert.rejects(()=>db.query('select public.admin_review_student_renewal($1)',[rid]),/Request unavailable/);
 assert.deepEqual((await db.query('select public.admin_list_student_renewals() v')).rows[0].v,[]);
 await db.exec('reset role');await db.query("update private.renewal_quotes set expires_at=now()-interval '1 minute' where id=$1",[full.quote_id]);await actor(a);await assert.rejects(()=>db.query('select public.submit_student_renewal($1,$2,$3)',[full.quote_id,receipt,'r.jpg']),/Quote unavailable/);await db.exec('reset role');assert.equal((await db.query('select receipt_path from public.student_registrations where student_id=$1',[a])).rows[0].receipt_path,`${a}/old.jpg`);assert.equal((await db.query('select registration_status from public.profiles where id=$1',[a])).rows[0].registration_status,'active');
 await db.query('insert into private.student_account_blocks values($1)',[a]);await actor(a);await assert.rejects(()=>quote('SAMPLE'),/Renewal unavailable/);
 console.log('PASS: eligibility, private secret, rate limit, server pricing, isolated receipts, roles and preserved service');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
