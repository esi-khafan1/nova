-- Resolve the caller from the validated database session, never from a client ID.
-- SECURITY INVOKER retains profiles RLS even for this own-row-only projection.
create or replace function public.own_dashboard_profile()
returns table(id uuid,full_name text,role public.app_role,grade smallint,phone text,study_field public.study_field,registration_status text)
language sql stable security invoker set search_path='' as $$
 select p.id,p.full_name,p.role,p.grade,p.phone,p.study_field,p.registration_status
 from public.profiles p where p.id=(select auth.uid());
$$;
revoke all on function public.own_dashboard_profile() from public,anon;
grant execute on function public.own_dashboard_profile() to authenticated;

-- One authorized call and one scan instead of three exact-count HTTP requests.
create or replace function public.admin_dashboard_counts()
returns table(users bigint,students bigint,counselors bigint)
language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
  raise exception 'Admin only' using errcode='42501';
 end if;
 return query select count(*),count(*) filter(where p.role='student'),count(*) filter(where p.role='counselor') from public.profiles p;
end; $$;
revoke all on function public.admin_dashboard_counts() from public,anon;
grant execute on function public.admin_dashboard_counts() to authenticated;
notify pgrst,'reload schema';
