-- EXPERIMENT ONLY: depends on student_account_blocks_foundation.sql.
-- No endpoint is deployed. These state transitions do not themselves revoke
-- tokens or guard PostgREST, Storage, Realtime, or privileged edge functions.
alter table private.student_account_blocks
 add column state text not null default 'blocked' check (state in ('blocking','blocked','unblocking','needs_review')),
 add column operation_id uuid unique;
alter table private.student_account_block_events
 add column operation_id uuid,
 add column outcome text not null default 'started' check (outcome in ('started','succeeded','uncertain'));

-- Caller identity/role comes from the verified database JWT, never parameters.
-- Keep the profile locked while beginning, so concurrent role changes cannot
-- promote the target between the student check and creation of the guard row.
create function public.experimental_begin_student_account_block(target uuid, should_block boolean, operation uuid)
returns boolean language plpgsql security definer set search_path = '' as $$
declare actor uuid := auth.uid(); target_role public.app_role; state_now text;
begin
 if actor is null or (select private.current_user_role()) is distinct from 'admin'::public.app_role
    or target is null or should_block is null or operation is null then
   raise exception 'Unauthorized or invalid request' using errcode = '42501';
 end if;
 -- Serialize against role changes of the acting administrator too.
 perform 1 from public.profiles where id=actor and role='admin' for share;
 if not found then raise exception 'Administrator required' using errcode = '42501'; end if;
 select role into target_role from public.profiles where id=target for update;
 if not found or target_role is distinct from 'student'::public.app_role then
   raise exception 'Only student accounts may be blocked' using errcode = '23514';
 end if;
 select b.state into state_now from private.student_account_blocks b where b.student_id=target for update;
 if should_block then
   if found then return false; end if;
   insert into private.student_account_blocks(student_id,blocked_by,state,operation_id)
     values(target,actor,'blocking',operation);
 else
   if not found or state_now <> 'blocked' then return false; end if;
   update private.student_account_blocks set state='unblocking',operation_id=operation where student_id=target;
 end if;
 insert into private.student_account_block_events(student_id,actor_id,event,operation_id,outcome)
   values(target,actor,case when should_block then 'block' else 'unblock' end,operation,'started');
 return true;
end; $$;
revoke all on function public.experimental_begin_student_account_block(uuid,boolean,uuid) from public,anon;
grant execute on function public.experimental_begin_student_account_block(uuid,boolean,uuid) to authenticated;

-- Only the server using the service role can finalize; unknown results remain
-- blocked and require reconciliation, not automatic retries that could race.
create function public.experimental_finish_student_account_block(operation uuid, succeeded boolean)
returns void language plpgsql security definer set search_path = '' as $$
declare b private.student_account_blocks%rowtype; e private.student_account_block_events%rowtype;
begin
 if operation is null or succeeded is null then raise exception 'Invalid result'; end if;
 select * into b from private.student_account_blocks where operation_id=operation for update;
 if not found or b.state not in ('blocking','unblocking') then raise exception 'Operation not pending'; end if;
 select * into e from private.student_account_block_events where operation_id=operation and outcome='started' order by id desc limit 1;
 if not found then raise exception 'Operation audit unavailable'; end if;
 insert into private.student_account_block_events(student_id,actor_id,event,operation_id,outcome)
   values(b.student_id,e.actor_id,e.event,operation,case when succeeded then 'succeeded' else 'uncertain' end);
 if not succeeded then
   update private.student_account_blocks set state='needs_review' where student_id=b.student_id;
 elsif b.state='blocking' then
   update private.student_account_blocks set state='blocked',operation_id=null where student_id=b.student_id;
 else
   delete from private.student_account_blocks where student_id=b.student_id;
 end if;
end; $$;
revoke all on function public.experimental_finish_student_account_block(uuid,boolean) from public,anon,authenticated;
grant execute on function public.experimental_finish_student_account_block(uuid,boolean) to service_role;
