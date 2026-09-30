create or replace function private.protect_profile_role()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.role is distinct from old.role
    and coalesce(
      (select private.current_user_role()),
      'student'::public.app_role
    ) <> 'admin'::public.app_role
  then
    raise exception 'Only administrators can change user roles';
  end if;

  return new;
end;
$$;

revoke all on function private.protect_profile_role()
from public, anon, authenticated;

drop trigger if exists protect_profile_role on public.profiles;

create trigger protect_profile_role
before update of role on public.profiles
for each row
execute function private.protect_profile_role();

grant update (role) on public.profiles to authenticated;

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
    'counselor'::public.app_role
  ) then
    raise exception 'Unsupported target role';
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
    set role = 'counselor', updated_at = now()
    where id = target_user_id;
  else
    delete from public.counselor_profiles
    where user_id = target_user_id;

    update public.profiles
    set role = 'student', updated_at = now()
    where id = target_user_id;
  end if;
end;
$$;

revoke all on function public.admin_set_user_role(uuid, public.app_role)
from public, anon;

grant execute on function public.admin_set_user_role(uuid, public.app_role)
to authenticated;