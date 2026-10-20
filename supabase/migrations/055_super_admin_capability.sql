-- Super admin is a protected capability on an existing admin account, not a
-- new enum role: all existing admin RLS policies and dashboards keep working.
create table private.super_admins (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now()
);
alter table private.super_admins enable row level security;
revoke all on private.super_admins from public, anon, authenticated;

create or replace function private.is_super_admin()
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from private.super_admins s join public.profiles p on p.id = s.user_id
    where s.user_id = (select auth.uid()) and p.role = 'admin'
  );
$$;
revoke all on function private.is_super_admin() from public, anon;
grant execute on function private.is_super_admin() to authenticated;

create or replace function public.admin_list_super_admins()
returns table(user_id uuid) language plpgsql stable security definer set search_path = '' as $$
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only' using errcode = '42501';
  end if;
  return query select s.user_id from private.super_admins s;
end;
$$;
revoke all on function public.admin_list_super_admins() from public, anon;
grant execute on function public.admin_list_super_admins() to authenticated;

-- Enforce this even for direct REST updates, not just the role-change RPC/UI.
create or replace function private.protect_profile_role()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if new.role is distinct from old.role then
    if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
      raise exception 'Only administrators can change user roles' using errcode = '42501';
    end if;
    if old.role = 'admin'::public.app_role then
      raise exception 'Administrator roles cannot be changed here' using errcode = '42501';
    end if;
    if new.role = 'admin'::public.app_role and not private.is_super_admin() then
      raise exception 'Only super administrators can grant admin access' using errcode = '42501';
    end if;
  end if;
  return new;
end;
$$;
revoke all on function private.protect_profile_role() from public, anon, authenticated;

create or replace function public.admin_set_user_role(
  target_user_id uuid,
  target_role public.app_role
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  actor_role public.app_role;
  current_target_role public.app_role;
begin
  select role into actor_role
  from public.profiles
  where id = (select auth.uid());

  if actor_role is distinct from 'admin'::public.app_role then
    raise exception 'Only administrators can change user roles';
  end if;

  if target_role not in (
    'student'::public.app_role,
    'counselor'::public.app_role,
    'exam_designer'::public.app_role,
    'admin'::public.app_role
  ) then
    raise exception 'Unsupported target role';
  end if;

  if target_role = 'admin'::public.app_role and not private.is_super_admin() then
    raise exception 'Only super administrators can grant admin access' using errcode = '42501';
  end if;

  select role into current_target_role
  from public.profiles
  where id = target_user_id
  for update;

  if not found then
    raise exception 'User not found';
  end if;

  if current_target_role = 'admin'::public.app_role then
    raise exception 'Administrator roles cannot be changed here';
  end if;

  if target_role = 'counselor'::public.app_role then
    if exists (
      select 1
      from public.counselor_profiles
      where user_id = target_user_id
    ) then
      update public.counselor_profiles
      set approval_status = 'approved'
      where user_id = target_user_id;
    else
      insert into public.counselor_profiles (
        user_id,
        headline,
        approval_status,
        is_accepting
      )
      values (
        target_user_id,
        'مشاور نووا',
        'approved',
        false
      );
    end if;

    update public.profiles
    set role = 'counselor'
    where id = target_user_id;
  else
    delete from public.counselor_profiles
    where user_id = target_user_id;

    update public.profiles
    set role = target_role
    where id = target_user_id;
  end if;
end;
$$;

revoke all on function public.admin_set_user_role(uuid, public.app_role)
from public, anon;

grant execute on function public.admin_set_user_role(uuid, public.app_role)
to authenticated;

notify pgrst, 'reload schema';
