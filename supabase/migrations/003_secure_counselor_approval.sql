create or replace function private.protect_counselor_approval() returns trigger language plpgsql security definer set search_path='' as $$
begin
 if tg_op='INSERT' and coalesce((select private.current_user_role()),'student'::public.app_role)<>'admin'::public.app_role then new.approval_status:='pending';
 elsif tg_op='UPDATE' and new.approval_status is distinct from old.approval_status and coalesce((select private.current_user_role()),'student'::public.app_role)<>'admin'::public.app_role then raise exception 'Only administrators can review counselor applications'; end if;
 return new;
end;$$;
create or replace function private.sync_counselor_role() returns trigger language plpgsql security definer set search_path='' as $$
begin
 if new.approval_status='approved' then update public.profiles set role='counselor',updated_at=now() where id=new.user_id;
 elsif new.approval_status='rejected' then update public.profiles set role='student',updated_at=now() where id=new.user_id and role<>'admin'; end if;
 return new;
end;$$;
revoke all on function private.protect_counselor_approval() from public,anon,authenticated;
revoke all on function private.sync_counselor_role() from public,anon,authenticated;
drop trigger if exists protect_counselor_approval on public.counselor_profiles;
create trigger protect_counselor_approval before insert or update on public.counselor_profiles for each row execute function private.protect_counselor_approval();
drop trigger if exists sync_counselor_role on public.counselor_profiles;
create trigger sync_counselor_role after update of approval_status on public.counselor_profiles for each row when(old.approval_status is distinct from new.approval_status) execute function private.sync_counselor_role();
grant update(approval_status) on public.counselor_profiles to authenticated;
