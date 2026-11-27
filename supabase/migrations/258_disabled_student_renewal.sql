-- Service suspension is not an account block: allow former students to renew
-- without changing their service status, counselor assignment or old records.
create or replace function private.require_renewal_access() returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role
   or not exists(select 1 from public.profiles p where p.id=(select auth.uid()) and p.role='student' and p.registration_status in ('active','disabled'))
   or exists(select 1 from private.student_account_blocks where student_id=(select auth.uid()))
   or not exists(select 1 from auth.users where id=(select auth.uid()) and (email_confirmed_at is not null or phone_confirmed_at is not null))
 then raise exception 'Renewal unavailable' using errcode='42501';end if;
end;$$;

create or replace function private.renewal_may_upload() returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.profiles p where p.id=(select auth.uid()) and p.role='student' and p.registration_status in ('active','disabled'))
   and not exists(select 1 from private.student_account_blocks where student_id=(select auth.uid()))
   and exists(select 1 from auth.users where id=(select auth.uid()) and (email_confirmed_at is not null or phone_confirmed_at is not null))
   and exists(select 1 from private.renewal_quotes q where q.student_id=(select auth.uid()) and q.expires_at>now());
$$;
notify pgrst,'reload schema';
