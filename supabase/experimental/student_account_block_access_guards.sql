-- EXPERIMENT ONLY. This is not an installed migration. These guards must not
-- be enabled independently of Auth/Edge, directory, recovery, and live tests.
-- The Data API pre-request guard does NOT cover Storage, Realtime, or Edge.
create function private.is_own_student_account_blocked() returns boolean
language sql stable security definer set search_path = '' as $$
 select exists(select 1 from private.student_account_blocks where student_id=(select auth.uid()));
$$;
revoke all on function private.is_own_student_account_blocked() from public,anon;
grant execute on function private.is_own_student_account_blocked() to authenticated;

create function public.experimental_reject_blocked_request() returns void
language plpgsql stable security definer set search_path = '' as $$
begin
 if (select private.is_own_student_account_blocked()) then
   raise exception 'Account access is suspended' using errcode='42501';
 end if;
end; $$;
revoke all on function public.experimental_reject_blocked_request() from public;
grant execute on function public.experimental_reject_blocked_request() to anon,authenticated,service_role;

-- Example Storage defense in depth. Existing signed URLs can remain usable
-- until their expiry. Verify all buckets/policies and other Supabase products.
create policy experimental_blocked_student_storage on storage.objects
 as restrictive for all to authenticated
 using (not (select private.is_own_student_account_blocked()))
 with check (not (select private.is_own_student_account_blocked()));

-- No ALTER ROLE or NOTIFY here: avoid changing the live Data API globally.
-- Installation and rollback must be coordinated and tested separately.
