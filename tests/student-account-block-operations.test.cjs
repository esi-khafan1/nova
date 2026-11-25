const assert=require('node:assert/strict'),fs=require('node:fs'),{PGlite}=require('@electric-sql/pglite');
(async()=>{const db=new PGlite();try{
 await db.exec(`create role anon; create role authenticated; create role service_role;
 create schema private; create schema auth;
 create type public.app_role as enum ('student','counselor','admin');
 create table public.profiles(id uuid primary key,role public.app_role not null);
 create function auth.uid() returns uuid language sql stable as $$select nullif(current_setting('test.uid',true),'')::uuid$$;
 create function private.current_user_role() returns public.app_role language sql stable security definer as $$select role from public.profiles where id=auth.uid()$$;
 insert into public.profiles values
 ('00000000-0000-4000-8000-000000000001','admin'),
 ('00000000-0000-4000-8000-000000000002','student'),
 ('00000000-0000-4000-8000-000000000003','counselor');`);
 await db.exec(fs.readFileSync('supabase/experimental/student_account_blocks_foundation.sql','utf8'));
 await db.exec(fs.readFileSync('supabase/experimental/student_account_block_operations.sql','utf8'));
 const admin='00000000-0000-4000-8000-000000000001',student='00000000-0000-4000-8000-000000000002',counselor='00000000-0000-4000-8000-000000000003';
 const op=n=>`00000000-0000-4000-8001-${String(n).padStart(12,'0')}`;
 const uid=async id=>db.exec(`set test.uid='${id}'`);
 const begin=async(target,blocked,id)=>(await db.query('select public.experimental_begin_student_account_block($1,$2,$3) result',[target,blocked,id])).rows[0].result;
 const finish=async(id,ok)=>db.query('select public.experimental_finish_student_account_block($1,$2)',[id,ok]);
 const state=async()=>(await db.query('select state from private.student_account_blocks where student_id=$1',[student])).rows[0]?.state;
 await uid(counselor);await assert.rejects(begin(student,true,op(1)),/Unauthorized/);
 await uid(admin);await assert.rejects(begin(counselor,true,op(2)),/Only student/);
 assert.equal(await begin(student,true,op(3)),true);assert.equal(await state(),'blocking');
 assert.equal(await begin(student,false,op(4)),false);
 await assert.rejects(db.query("update public.profiles set role='admin' where id=$1",[student]),/Unblock/);
 await finish(op(3),true);assert.equal(await state(),'blocked');
 assert.equal(await begin(student,false,op(5)),true);assert.equal(await state(),'unblocking');
 assert.equal(await begin(student,true,op(6)),false);
 await finish(op(5),false);assert.equal(await state(),'needs_review');
 assert.equal(await begin(student,false,op(7)),false);
 await assert.rejects(finish(op(5),true),/not pending/);
 let events=(await db.query('select event,outcome from private.student_account_block_events order by id')).rows;
 assert.deepEqual(events,[{event:'block',outcome:'started'},{event:'block',outcome:'succeeded'},{event:'unblock',outcome:'started'},{event:'unblock',outcome:'uncertain'}]);
 assert.equal((await db.query("select has_function_privilege('authenticated','public.experimental_finish_student_account_block(uuid,boolean)','execute') allowed")).rows[0].allowed,false);
 // A clean successful reversal removes only the block state, not the account.
 // Reset the experimental test state directly; production reconciliation is
 // intentionally not implemented or exposed here.
 await db.query('delete from private.student_account_blocks where student_id=$1',[student]);
 assert.equal(await begin(student,true,op(8)),true); await finish(op(8),true);
 assert.equal(await begin(student,false,op(9)),true); await finish(op(9),true);
 assert.equal(await state(),undefined);
 assert.equal((await db.query('select role from public.profiles where id=$1',[student])).rows[0].role,'student');
 await assert.rejects(finish(op(9),true),/not pending/);
 console.log('PASS: experimental operations reject non-admins, guard role changes and retain failed blocks');
 }finally{await db.close()}})().catch(e=>{console.error(e);process.exitCode=1});
