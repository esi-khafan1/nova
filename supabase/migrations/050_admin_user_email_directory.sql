create or replace function public.admin_list_users()
returns table (
  id uuid,
  full_name text,
  role public.app_role,
  grade smallint,
  created_at timestamptz,
  email text
)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Only administrators can list users' using errcode = '42501';
  end if;

  return query
  select
    profiles.id,
    profiles.full_name,
    profiles.role,
    profiles.grade,
    profiles.created_at,
    auth_users.email::text
  from public.profiles as profiles
  left join auth.users as auth_users on auth_users.id = profiles.id
  order by profiles.created_at desc;
end;
$$;

revoke all on function public.admin_list_users() from public, anon;
grant execute on function public.admin_list_users() to authenticated;

notify pgrst, 'reload schema';
