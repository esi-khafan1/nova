-- Audit/throttle recovery requests without storing passwords or email tokens.
create table private.password_recovery_requests (
  id bigint generated always as identity primary key,
  actor_id uuid not null references public.profiles(id) on delete cascade,
  target_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now()
);
create index password_recovery_target_time on private.password_recovery_requests(target_id,created_at desc);
create index password_recovery_actor_time on private.password_recovery_requests(actor_id,created_at desc);
alter table private.password_recovery_requests enable row level security;
revoke all on private.password_recovery_requests from public,anon,authenticated;
create or replace function public.admin_prepare_password_recovery(target_user_id uuid)
returns text language plpgsql security definer set search_path='' as $$
declare target_email text; target_role public.app_role;
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only' using errcode='42501';
  end if;
  select u.email,p.role into target_email,target_role from public.profiles p join auth.users u on u.id=p.id where p.id=target_user_id;
  if target_email is null then raise exception 'User not found' using errcode='42501'; end if;
  if target_role='admin' and not private.is_super_admin() then
    raise exception 'Super admin required for administrator recovery' using errcode='42501';
  end if;
  -- Serialize reservation checks to avoid concurrent resend bypasses.
  perform pg_catalog.pg_advisory_xact_lock(56390217);
  if exists(select 1 from private.password_recovery_requests where target_id=target_user_id and created_at>now()-interval '60 seconds')
     or (select count(*) from private.password_recovery_requests where actor_id=(select auth.uid()) and created_at>now()-interval '1 hour')>=10 then
    raise exception 'Recovery send rate limit reached';
  end if;
  insert into private.password_recovery_requests(actor_id,target_id) values((select auth.uid()),target_user_id);
  return target_email;
end;
$$;
revoke all on function public.admin_prepare_password_recovery(uuid) from public,anon;
grant execute on function public.admin_prepare_password_recovery(uuid) to authenticated;
notify pgrst,'reload schema';
