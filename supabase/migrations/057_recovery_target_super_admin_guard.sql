-- Admins may recover admin accounts, but only super admins may recover super admins.
create or replace function public.admin_prepare_password_recovery(target_user_id uuid)
returns text language plpgsql security definer set search_path='' as $$
declare target_email text;
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only' using errcode='42501';
  end if;
  select u.email into target_email from public.profiles p join auth.users u on u.id=p.id where p.id=target_user_id;
  if target_email is null then raise exception 'User not found' using errcode='42501'; end if;
  if exists(select 1 from private.super_admins where user_id=target_user_id) and not private.is_super_admin() then
    raise exception 'Super admin required for super-administrator recovery' using errcode='42501';
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
