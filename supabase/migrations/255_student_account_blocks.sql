-- Student account suspension is separate from registration/service status.
create table private.student_account_blocks (
  student_id uuid primary key references public.profiles(id) on delete cascade,
  blocked_at timestamptz not null default now(),
  blocked_by uuid not null
);
alter table private.student_account_blocks enable row level security;
revoke all on private.student_account_blocks from public, anon, authenticated;

-- This is separate from the current state so unblock does not erase history.
-- No authenticated client gets direct read or write access.
create table private.student_account_block_events (
  id bigint generated always as identity primary key,
  student_id uuid not null,
  actor_id uuid not null,
  event text not null check (event in ('block', 'unblock')),
  occurred_at timestamptz not null default now()
);
alter table private.student_account_block_events enable row level security;
revoke all on private.student_account_block_events from public, anon, authenticated;

-- Serialize creation of a block against role changes on the same profile.
-- Never allow the state to be attached to a non-student account.
create function private.guard_student_account_block_insert() returns trigger
language plpgsql security definer set search_path = '' as $$
declare target_role public.app_role;
begin
  select role into target_role from public.profiles where id = new.student_id for update;
  if not found or target_role is distinct from 'student'::public.app_role then
    raise exception 'Only student accounts may be blocked' using errcode = '23514';
  end if;
  return new;
end; $$;
revoke all on function private.guard_student_account_block_insert() from public, anon, authenticated;
create trigger guard_student_account_block_insert before insert or update of student_id
on private.student_account_blocks for each row execute function private.guard_student_account_block_insert();

-- A blocked student must be unblocked before a role change. The profile row
-- lock held by UPDATE serializes this test against the insert trigger above.
create function private.guard_blocked_student_role_change() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  if new.role is distinct from old.role and exists (
    select 1 from private.student_account_blocks where student_id = old.id
  ) then
    raise exception 'Unblock this student before changing their role' using errcode = '23514';
  end if;
  return new;
end; $$;
revoke all on function private.guard_blocked_student_role_change() from public, anon, authenticated;
create trigger guard_blocked_student_role_change before update of role on public.profiles
for each row execute function private.guard_blocked_student_role_change();

alter table private.student_account_blocks
 add column state text not null default 'blocked' check (state in ('blocking','blocked','unblocking','needs_review')),
 add column operation_id uuid unique,
 add column auth_banned_until timestamptz;
alter table private.student_account_block_events
 add column operation_id uuid,
 add column outcome text not null default 'started' check (outcome in ('started','succeeded','uncertain'));

-- Caller identity/role comes from the verified database JWT, never parameters.
-- Keep the profile locked while beginning, so concurrent role changes cannot
-- promote the target between the student check and creation of the guard row.
create function public.begin_student_account_block(target uuid, should_block boolean, operation uuid)
returns jsonb language plpgsql security definer set search_path = '' as $$
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
   if found then return null; end if;
   insert into private.student_account_blocks(student_id,blocked_by,state,operation_id)
     values(target,actor,'blocking',operation);
 else
   if not found or state_now <> 'blocked' then return null; end if;
   update private.student_account_blocks set state='unblocking',operation_id=operation where student_id=target;
 end if;
 insert into private.student_account_block_events(student_id,actor_id,event,operation_id,outcome)
   values(target,actor,case when should_block then 'block' else 'unblock' end,operation,'started');
 return (select pg_catalog.jsonb_build_object('auth_banned_until', auth_banned_until) from private.student_account_blocks where student_id=target);
end; $$;
revoke all on function public.begin_student_account_block(uuid,boolean,uuid) from public,anon;
grant execute on function public.begin_student_account_block(uuid,boolean,uuid) to authenticated;

-- Only the server using the service role can finalize; unknown results remain
-- blocked and require reconciliation, not automatic retries that could race.
create function public.finish_student_account_block(operation uuid, succeeded boolean, auth_until timestamptz)
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
 if succeeded and b.state='blocking' and (auth_until is null or auth_until <= now()) then raise exception 'Auth ban was not verified'; end if;
 if not succeeded then
   update private.student_account_blocks set state='needs_review' where student_id=b.student_id;
 elsif b.state='blocking' then
   update private.student_account_blocks set state='blocked',operation_id=null,auth_banned_until=auth_until where student_id=b.student_id;
 else
   delete from private.student_account_blocks where student_id=b.student_id;
 end if;
end; $$;
revoke all on function public.finish_student_account_block(uuid,boolean,timestamptz) from public,anon,authenticated;
grant execute on function public.finish_student_account_block(uuid,boolean,timestamptz) to service_role;

create function private.is_own_student_account_blocked() returns boolean
language sql stable security definer set search_path = '' as $$
 select exists(select 1 from private.student_account_blocks where student_id=(select auth.uid()));
$$;
revoke all on function private.is_own_student_account_blocked() from public,anon;
grant execute on function private.is_own_student_account_blocked() to authenticated;

create function public.reject_blocked_request() returns void
language plpgsql stable security definer set search_path = '' as $$
begin
 if (select private.is_own_student_account_blocked()) then
   raise exception 'Account access is suspended' using errcode='42501';
 end if;
end; $$;
revoke all on function public.reject_blocked_request() from public;
grant execute on function public.reject_blocked_request() to anon,authenticated,service_role;

-- Used by privileged edge functions to fail closed before acting as service_role.
create function public.own_account_blocked() returns boolean language sql stable security invoker set search_path = '' as $$
 select private.is_own_student_account_blocked();
$$;
revoke all on function public.own_account_blocked() from public,anon;
grant execute on function public.own_account_blocked() to authenticated;

-- Example Storage defense in depth. Existing signed URLs can remain usable
-- until their expiry. Verify all buckets/policies and other Supabase products.
create policy blocked_student_storage on storage.objects
 as restrictive for all to authenticated
 using (not (select private.is_own_student_account_blocked()))
 with check (not (select private.is_own_student_account_blocked()));


-- Page and search in PostgreSQL, before returning accounts to the browser.
-- This does not change roles, student services, or authentication.
create function public.admin_user_directory_page_with_status(
  search_query text default '', requested_page integer default 1, account_filter text default 'all'
) returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare result jsonb; q text; phone_query text;
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Only administrators can list users' using errcode = '42501';
  end if;
  if account_filter is null or account_filter not in ('all', 'active', 'blocked') then raise exception 'Invalid account filter'; end if;
  q := pg_catalog.lower(pg_catalog.translate(pg_catalog.left(pg_catalog.btrim(coalesce(search_query, '')), 120), 'يكى', 'یکی'));
  phone_query := private.registration_search_phone(q);

  with candidates as materialized (
    select p.id, p.full_name, p.role, p.grade, p.created_at, a.email::text as email, exists(select 1 from private.student_account_blocks b where b.student_id=p.id) as blocked,
      (select b.state from private.student_account_blocks b where b.student_id=p.id) as block_state
    from public.profiles p left join auth.users a on a.id = p.id
    where (account_filter = 'all' or (account_filter = 'blocked') = exists(select 1 from private.student_account_blocks b where b.student_id=p.id))
      and (q = ''
      or pg_catalog.strpos(pg_catalog.lower(pg_catalog.translate(coalesce(p.full_name, ''), 'يكى', 'یکی')), q) > 0
      or pg_catalog.strpos(pg_catalog.lower(coalesce(a.email::text, '')), q) > 0
      or (phone_query <> '' and q ~ '^[0-9۰-۹٠-٩+()[:space:]-]+$' and (
        pg_catalog.strpos(private.registration_search_phone(coalesce(p.phone, '')), phone_query) > 0
        or pg_catalog.strpos(private.registration_search_phone(coalesce(a.phone::text, '')), phone_query) > 0
      )))
  ), stats as (
    select count(*)::integer as total from candidates
  ), pagination as (
    select total, greatest(1, (total + 9) / 10) as pages,
      least(greatest(coalesce(requested_page, 1), 1), greatest(1, (total + 9) / 10)) as page
    from stats
  ), page_rows as (
    select c.* from candidates c order by c.created_at desc, c.id
    limit 10 offset ((select page from pagination) - 1) * 10
  )
  select pg_catalog.jsonb_build_object(
    'total', pagination.total, 'page', pagination.page, 'pages', pagination.pages,
    'rows', coalesce((select pg_catalog.jsonb_agg(pg_catalog.to_jsonb(r) order by r.created_at desc, r.id) from page_rows r), '[]'::jsonb)
  ) into result from pagination;
  return result;
end; $$;
revoke all on function public.admin_user_directory_page_with_status(text, integer, text) from public, anon;
grant execute on function public.admin_user_directory_page_with_status(text, integer, text) to authenticated;


create or replace function public.admin_registration_directory_page(
  search_query text default '', province_filter text default null,
  review_only boolean default false, requested_page integer default 1
) returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare result jsonb; q text; phone_query text;
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only';
  end if;
  q := pg_catalog.lower(pg_catalog.translate(pg_catalog.btrim(coalesce(search_query, '')), 'يكى', 'یکی'));
  phone_query := private.registration_search_phone(q);

  with reviews as materialized (
    select r.student_id, r.review_plan_count from public.admin_student_plan_service_reviews() r
  ), candidates as materialized (
    select p.id, p.full_name, coalesce(r.phone,p.phone) as phone,
      case when r.student_id is not null then r.province else a.province end as province,
      p.registration_status, r.receipt_path, p.created_at,
      assignment.counselor_id, reviews.review_plan_count
    from public.profiles p
    left join public.student_registrations r on r.student_id=p.id
    left join public.student_account_details a on a.student_id=p.id
    left join lateral (
      select cs.counselor_id from public.counselor_students cs
      where cs.student_id=p.id order by cs.created_at desc, cs.counselor_id limit 1
    ) assignment on true
    left join reviews on reviews.student_id=p.id
    where p.role='student'
      and not exists(select 1 from private.student_account_blocks b where b.student_id=p.id)
      and (province_filter is null or province_filter = '' or
        (case when r.student_id is not null then r.province else a.province end) = province_filter)
      and (q = '' or
        pg_catalog.strpos(pg_catalog.lower(pg_catalog.translate(coalesce(p.full_name,''), 'يكى', 'یکی')), q) > 0 or
        (phone_query <> '' and q ~ '^[0-9۰-۹٠-٩+()[:space:]-]+$' and
          pg_catalog.strpos(private.registration_search_phone(coalesce(r.phone,p.phone,'')), phone_query) > 0) or
        exists (select 1 from public.counselor_students cs join public.profiles counselor on counselor.id=cs.counselor_id
          where cs.student_id=p.id and pg_catalog.strpos(pg_catalog.lower(pg_catalog.translate(coalesce(counselor.full_name,''), 'يكى', 'یکی')), q) > 0))
  ), selected as materialized (
    select *, (registration_status='pending' and coalesce(receipt_path,'') <> '' and counselor_id is null) as priority
    from candidates where not coalesce(review_only,false) or review_plan_count is not null
  ), stats as (
    select count(*)::integer as total,
      count(*) filter (where priority)::integer as waiting,
      count(*) filter (where counselor_id is null)::integer as unassigned,
      count(*) filter (where counselor_id is not null)::integer as assigned
    from selected
  ), pagination as (
    select *, greatest(1, (total + 9) / 10) as pages,
      least(greatest(coalesce(requested_page,1),1), greatest(1,(total + 9) / 10)) as page from stats
  ), page_rows as materialized (
    select s.* from selected s order by s.priority desc, s.created_at desc, s.id
    limit 10 offset ((select page from pagination) - 1) * 10
  ), detail as (
    select s.*, p.grade, p.study_field, p.service_course_type, p.service_course_duration_months,
      r.receipt_name, r.course_type, r.course_duration_months,
      case when r.student_id is not null then r.telegram_id else a.telegram_id end as telegram_id,
      case when r.student_id is not null then r.city else a.city end as city,
      case when r.student_id is not null then r.additional_notes else a.additional_notes end as additional_notes,
      (r.student_id is not null or a.student_id is not null) as has_account_details,
      (select pg_catalog.string_agg(c.full_name, '، ' order by c.full_name)
       from public.counselor_students cs join public.profiles c on c.id=cs.counselor_id where cs.student_id=s.id) as counselor_name
    from page_rows s join public.profiles p on p.id=s.id
    left join public.student_registrations r on r.student_id=s.id
    left join public.student_account_details a on a.student_id=s.id
  )
  select pg_catalog.jsonb_build_object(
    'total', pagination.total, 'waiting', pagination.waiting, 'unassigned', pagination.unassigned,
    'assigned', pagination.assigned, 'page', pagination.page, 'pages', pagination.pages,
    'review_count', (select count(*) from candidates where review_plan_count is not null),
    'rows', coalesce((select pg_catalog.jsonb_agg(pg_catalog.jsonb_build_object(
      'student_id',d.id,'full_name',d.full_name,'phone',d.phone,'telegram_id',d.telegram_id,
      'grade',d.grade,'study_field',d.study_field,'province',d.province,'city',d.city,
      'registration_status',d.registration_status,'receipt_path',d.receipt_path,'receipt_name',d.receipt_name,
      'counselor_name',d.counselor_name,'counselor_id',d.counselor_id,'created_at',d.created_at,
      'course_type',d.course_type,'course_duration_months',d.course_duration_months,
      'service_course_type',d.service_course_type,'service_course_duration_months',d.service_course_duration_months,
      'additional_notes',d.additional_notes,'has_account_details',d.has_account_details,'review_plan_count',d.review_plan_count
    ) order by d.priority desc, d.created_at desc, d.id) from detail d), '[]'::jsonb)
  ) into result from pagination;
  return result;
end; $$;
revoke all on function public.admin_registration_directory_page(text,text,boolean,integer) from public, anon;
grant execute on function public.admin_registration_directory_page(text,text,boolean,integer) to authenticated;


create or replace function public.counselor_student_directory() returns table(student_id uuid,full_name text,grade smallint,study_field public.study_field,is_selected boolean) language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then raise exception 'Counselor only';end if;
 return query select p.id,p.full_name,p.grade,p.study_field,true from public.profiles p join public.counselor_students a on a.student_id=p.id where a.counselor_id=(select auth.uid()) and p.role='student' and p.registration_status='active' and not exists(select 1 from private.student_account_blocks b where b.student_id=p.id) order by p.full_name;
end;$$;
revoke all on function public.counselor_student_directory() from public,anon;
grant execute on function public.counselor_student_directory() to authenticated;


-- Keep planner history for all other students untouched; return only blocked
-- students who are currently assigned to, or have plans by, this counselor.
create function public.counselor_blocked_student_ids() returns table(student_id uuid)
language plpgsql stable security definer set search_path = '' as $$
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then
   raise exception 'Counselor only' using errcode = '42501';
 end if;
 return query select b.student_id from private.student_account_blocks b
 where exists(select 1 from public.counselor_students cs where cs.student_id=b.student_id and cs.counselor_id=(select auth.uid()))
    or exists(select 1 from public.weekly_plans wp where wp.student_id=b.student_id and wp.counselor_id=(select auth.uid()));
end; $$;
revoke all on function public.counselor_blocked_student_ids() from public,anon;
grant execute on function public.counselor_blocked_student_ids() to authenticated;

-- Never replace an existing pre-request hook: it may enforce other controls.
do $$ begin
 if exists (select 1 from pg_catalog.pg_db_role_setting s
     join pg_catalog.pg_roles r on r.oid=s.setrole
     cross join lateral pg_catalog.unnest(s.setconfig) cfg
     where r.rolname='authenticator' and cfg like 'pgrst.db_pre_request=%'
       and cfg <> 'pgrst.db_pre_request=public.reject_blocked_request') then
   raise exception 'Existing PostgREST pre-request hook requires manual integration';
 end if;
end $$;
alter role authenticator set pgrst.db_pre_request = 'public.reject_blocked_request';
notify pgrst, 'reload config';
notify pgrst, 'reload schema';
