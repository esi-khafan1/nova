const {PGlite}=require('@electric-sql/pglite'),fs=require('node:fs'),assert=require('node:assert/strict');
(async()=>{const db=new PGlite();const read=n=>fs.readFileSync('supabase/migrations/'+n,'utf8');
await db.exec(`create role anon;create role authenticated;create role service_role;create schema private;create schema auth;
create table auth.users(id uuid primary key,email_confirmed_at timestamptz,phone_confirmed_at timestamptz);
create table public.profiles(id uuid primary key,role text);create function auth.uid() returns uuid language sql as $$select '11111111-1111-4111-a111-111111111111'::uuid$$;
create function public.save_student_account_details(payload jsonb) returns void language plpgsql security definer set search_path='' as $$begin if not exists(select 1 from public.profiles p join auth.users u on u.id=p.id where p.id=auth.uid() and p.role='student' and u.email_confirmed_at is not null) then raise exception 'Confirmed student required';end if;end;$$;
create function public.submit_student_registration(payload jsonb) returns void language plpgsql security definer set search_path='' as $$begin if not exists(select 1 from auth.users where id=auth.uid() and email_confirmed_at is not null) then raise exception 'Confirmed email required';end if;if payload->>'receipt' is null then raise exception 'Receipt required';end if;end;$$;
create function public.admin_activate_student_without_receipt(uuid,uuid) returns void language plpgsql security definer set search_path='' as $$begin if not exists(select 1 from auth.users where id=$1 and email_confirmed_at is not null) then raise exception 'Confirmed student required';end if;raise exception 'Admin only';end;$$;
insert into auth.users values('11111111-1111-4111-a111-111111111111',null,now());insert into public.profiles values('11111111-1111-4111-a111-111111111111','student');`);
await db.exec('create table private.sms_test_attempts(event_id text primary key,outcome text,provider_code integer,elapsed_ms integer)');await db.exec(read('074_sms_signup_limits.sql'));await db.exec(read('075_phone_verified_registration.sql'));await db.exec(read('083_sms_signup_per_phone_limits.sql'));
await db.query('select public.save_student_account_details($1)',[{}]);await db.query('select public.submit_student_registration($1)',[{receipt:'private'}]);
await assert.rejects(()=>db.query('select public.submit_student_registration($1)',[{}]),/Receipt required/);
await assert.rejects(()=>db.query("select public.admin_activate_student_without_receipt('11111111-1111-4111-a111-111111111111',null)"),/Admin only/);
await db.exec('update auth.users set phone_confirmed_at=null');await assert.rejects(()=>db.query('select public.save_student_account_details($1)',[{}]),/Confirmed student/);
await db.exec('update auth.users set email_confirmed_at=now()');await db.query('select public.save_student_account_details($1)',[{}]);
const hash='a'.repeat(64);const other='b'.repeat(64);const claim=async(id,key=hash)=>(await db.query('select public.claim_sms_signup_attempt($1,$2) as ok',[id,key])).rows[0].ok;
await db.exec('set role anon');await assert.rejects(()=>claim('bad'),/permission denied/);await db.exec('reset role;set role authenticated');await assert.rejects(()=>claim('bad'),/permission denied/);
await db.exec('reset role;set role service_role');assert.equal(await claim('one'),true);assert.equal(await claim('one'),false);assert.equal(await claim('two'),false,'one-minute cooldown');
for(let i=2;i<=10;i++){
 await db.exec(`reset role;update private.sms_signup_attempts set created_at=now()-interval '61 seconds' where phone_key=repeat('a',64);set role service_role`);
 assert.equal(await claim(`hour-${i}`),true,`hourly request ${i} should succeed`);
}
await db.exec("reset role;update private.sms_signup_attempts set created_at=now()-interval '61 seconds' where phone_key=repeat('a',64);set role service_role");
assert.equal(await claim('hour-11'),false,'eleventh request in one hour must be blocked');
assert.equal(await claim('other-1',other),true,'one phone cannot block another');
for(let i=2;i<=20;i++){
 await db.exec("reset role;update private.sms_signup_attempts set created_at=now()-interval '2 hours' where phone_key=repeat('b',64);set role service_role");
 assert.equal(await claim(`day-${i}`,other),true,`daily request ${i} should succeed`);
}
await db.exec("reset role;update private.sms_signup_attempts set created_at=now()-interval '2 hours' where phone_key=repeat('b',64);set role service_role");
assert.equal(await claim('day-21',other),false,'twenty-first request in one day must be blocked');
await db.exec("reset role;insert into private.sms_signup_attempts(event_id,phone_key,created_at) select 'bulk'||g,repeat('c',64),now() from generate_series(1,39) g;set role service_role");
assert.equal(await claim('global-50','d'.repeat(64)),true);
assert.equal(await claim('global-51','e'.repeat(64)),false,'global hourly budget remains 50');
await db.close();console.log('Phone schema: confirmed-phone/email parity with receipt/role guards retained, private RPC grants, dedup, cooldown, 10/hour and 20/day per phone, and global quotas passed.');
})().catch(e=>{console.error(e);process.exitCode=1;});
