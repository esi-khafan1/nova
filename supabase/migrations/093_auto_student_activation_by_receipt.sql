-- One admin activation decision, routed by the RECEIPT STORED IN THE DATABASE.
-- A receipt must never be silently treated as a no-receipt activation.
-- Keep the existing admin/approved-counselor/no-reassignment checks and audits.

-- Direct assignment is now for accounts that were already active. Previously it
-- activated inactive students without reviewing a receipt or recording an
-- exception, which bypassed both accountable activation paths.
create or replace function public.admin_assign_student_counselor(
  target_student_id uuid, target_counselor_id uuid
) returns void language plpgsql security definer set search_path = '' as $$
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text, 73034));
  perform 1 from public.profiles
  where id=target_student_id and role='student'::public.app_role and registration_status='active'
  for update;
  if not found then raise exception 'Only an already active student can be assigned directly'; end if;
  if not exists (
    select 1 from public.profiles p join public.counselor_profiles c on c.user_id=p.id
    where p.id=target_counselor_id and p.role='counselor'::public.app_role
      and c.approval_status='approved'
  ) then raise exception 'Approved counselor required'; end if;
  if exists (select 1 from public.counselor_students where student_id=target_student_id) then
    raise exception 'Student already has a counselor';
  end if;
  insert into public.counselor_students(counselor_id,student_id)
  values(target_counselor_id,target_student_id);
end; $$;

-- Retain confirmed email OR confirmed phone for the manual route (migration 075).
-- Block the manual endpoint as well when a receipt has already been submitted.
create or replace function public.admin_activate_student_without_receipt(
  target_student_id uuid, target_counselor_id uuid
) returns void language plpgsql security definer set search_path = '' as $$
declare state text;
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
  select registration_status into state from public.profiles
  where id=target_student_id and role='student' for update;
  if state is null or state='active' then raise exception 'Inactive student required'; end if;
  if exists (select 1 from public.student_registrations
             where student_id=target_student_id and receipt_path is not null) then
    raise exception 'Submitted receipt must be reviewed before activation';
  end if;
  if not exists (select 1 from auth.users where id=target_student_id
                 and (email_confirmed_at is not null or phone_confirmed_at is not null)) then
    raise exception 'Confirmed student required';
  end if;
  if not exists(select 1 from public.student_account_details where student_id=target_student_id)
     and not exists(select 1 from public.student_registrations where student_id=target_student_id) then
    raise exception 'Complete account information required';
  end if;
  if not exists(select 1 from public.profiles p join public.counselor_profiles c on c.user_id=p.id
                where p.id=target_counselor_id and p.role='counselor' and c.approval_status='approved') then
    raise exception 'Approved counselor required';
  end if;
  if exists(select 1 from public.counselor_students
            where student_id=target_student_id and counselor_id<>target_counselor_id) then
    raise exception 'Student already has a different counselor';
  end if;
  if not exists(select 1 from public.counselor_students where student_id=target_student_id) then
    insert into public.counselor_students(counselor_id,student_id) values(target_counselor_id,target_student_id);
  end if;
  insert into public.student_manual_activations(student_id,activated_by,counselor_id,previous_status)
  values(target_student_id,(select auth.uid()),target_counselor_id,state);
  update public.profiles set registration_status='active' where id=target_student_id;
  -- No receipt or purchase approval is fabricated by the manual route.
end; $$;

create function public.admin_activate_student_auto(
  target_student_id uuid, target_counselor_id uuid, expected_receipt_path text
) returns void language plpgsql security definer set search_path = '' as $$
declare state text; receipt text;
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
  select registration_status into state from public.profiles
  where id=target_student_id and role='student' for update;
  if state is null or state='active' then raise exception 'Inactive student required'; end if;
  select r.receipt_path into receipt from public.student_registrations r
  where r.student_id=target_student_id for update;
  -- Never approve a receipt uploaded/replaced after the admin opened this form.
  if receipt is distinct from nullif(expected_receipt_path, '') then
    raise exception 'Receipt changed; refresh and review again';
  end if;
  if receipt is not null then
    -- The existing receipt RPC checks pending status, the exact stored path,
    -- storage existence, approved counselor and same-counselor assignment.
    perform public.admin_activate_student(target_student_id,target_counselor_id,receipt);
  else
    -- The existing manual audit/verified-contact requirements remain enforced.
    perform public.admin_activate_student_without_receipt(target_student_id,target_counselor_id);
  end if;
end; $$;
revoke all on function public.admin_activate_student_auto(uuid,uuid,text) from public,anon;
grant execute on function public.admin_activate_student_auto(uuid,uuid,text) to authenticated;
notify pgrst,'reload schema';
