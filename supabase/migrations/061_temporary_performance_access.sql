-- No request traces or timing reports are stored here; only account-scoped temporary grants.
create table private.performance_debug_access (
 user_id uuid primary key references public.profiles(id) on delete cascade,
 expires_at timestamptz not null
);
alter table private.performance_debug_access enable row level security;
revoke all on private.performance_debug_access from public,anon,authenticated;

create or replace function public.performance_debug_enabled()
returns boolean language sql stable security definer set search_path='' as $$
 select private.is_super_admin() or (
  (select private.current_user_role()) in ('admin','content_manager')
  and exists(select 1 from private.performance_debug_access a where a.user_id=(select auth.uid()) and a.expires_at>now())
 );
$$;
revoke all on function public.performance_debug_enabled() from public,anon;
grant execute on function public.performance_debug_enabled() to authenticated;

create or replace function public.set_performance_debug_access(target_user_id uuid,enabled boolean)
returns void language plpgsql security definer set search_path='' as $$
begin
 if not private.is_super_admin() then raise exception 'Super administrator required' using errcode='42501'; end if;
 if target_user_id is null or enabled is null then raise exception 'Invalid input'; end if;
 if enabled then
  if not exists(select 1 from public.profiles where id=target_user_id and role in ('admin','content_manager')) then raise exception 'Admin or content manager account required'; end if;
  insert into private.performance_debug_access(user_id,expires_at) values(target_user_id,now()+interval '1 hour') on conflict(user_id) do update set expires_at=excluded.expires_at;
 else
  delete from private.performance_debug_access where user_id=target_user_id;
 end if;
end; $$;
revoke all on function public.set_performance_debug_access(uuid,boolean) from public,anon;
grant execute on function public.set_performance_debug_access(uuid,boolean) to authenticated;
notify pgrst,'reload schema';
