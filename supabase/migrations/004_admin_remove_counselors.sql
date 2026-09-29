create policy "admins_delete_counselor_profiles"
on public.counselor_profiles
for delete
to authenticated
using ((select private.current_user_role()) = 'admin');

create or replace function private.reset_role_after_counselor_delete()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.profiles
  set role = 'student', updated_at = now()
  where id = old.user_id and role <> 'admin';
  return old;
end;
$$;

revoke all on function private.reset_role_after_counselor_delete()
from public, anon, authenticated;

drop trigger if exists reset_role_after_counselor_delete
on public.counselor_profiles;

create trigger reset_role_after_counselor_delete
after delete on public.counselor_profiles
for each row
execute function private.reset_role_after_counselor_delete();