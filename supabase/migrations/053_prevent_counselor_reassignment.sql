-- Assignment is available only for students without a counselor.
-- Counselor assignment is an administrative relationship, not proof of payment
-- or activation. Keep it available for every student registration status while
-- leaving registration_status and paid-service activation unchanged.
create or replace function public.admin_assign_student_counselor(
  target_student_id uuid,
  target_counselor_id uuid
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only';
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(target_student_id::text, 73034)
  );

  perform 1
  from public.profiles
  where id = target_student_id
    and role = 'student'::public.app_role
  for update;

  if not found then
    raise exception 'Student not found';
  end if;

  if not exists (
    select 1
    from public.profiles as counselor
    join public.counselor_profiles as counselor_profile
      on counselor_profile.user_id = counselor.id
    where counselor.id = target_counselor_id
      and counselor.role = 'counselor'::public.app_role
      and counselor_profile.approval_status = 'approved'
  ) then
    raise exception 'Approved counselor required';
  end if;

  -- The student profile lock serializes assignment and activation requests.
  -- Never replace an existing relationship, including stale/double submissions.
  if exists (
    select 1 from public.counselor_students
    where student_id = target_student_id
  ) then
    raise exception 'Student already has a counselor';
  end if;

  insert into public.counselor_students (counselor_id, student_id)
  values (target_counselor_id, target_student_id);
end;
$$;

revoke all on function public.admin_assign_student_counselor(uuid, uuid)
from public, anon;

grant execute on function public.admin_assign_student_counselor(uuid, uuid)
to authenticated;



-- Activation may keep the assigned counselor, but must never replace them.
create or replace function public.admin_activate_student(target_student_id uuid,target_counselor_id uuid,expected_receipt_path text) returns void language plpgsql security definer set search_path='' as $$
declare state text; r public.student_registrations%rowtype;
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only'; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 select registration_status into state from public.profiles where id=target_student_id and role='student' for update;
 if state is null then raise exception 'Student not found'; end if;
 if not exists(select 1 from public.profiles p join public.counselor_profiles c on c.user_id=p.id where p.id=target_counselor_id and p.role='counselor' and c.approval_status='approved') then raise exception 'Approved counselor required'; end if;
 select * into r from public.student_registrations where student_id=target_student_id for update;
 if state<>'active' then
  if state<>'pending' or r.student_id is null or expected_receipt_path is distinct from r.receipt_path or not exists(select 1 from storage.objects o where o.bucket_id='registration-receipts' and o.name=r.receipt_path) then raise exception 'Complete current registration and receipt required'; end if;
  update public.student_registrations set approved_at=now(),approved_by=(select auth.uid()) where student_id=target_student_id;
 end if;
 if exists(select 1 from public.counselor_students where student_id=target_student_id and counselor_id<>target_counselor_id) then
   raise exception 'Student already has a different counselor';
 end if;
 if not exists(select 1 from public.counselor_students where student_id=target_student_id) then
   insert into public.counselor_students(counselor_id,student_id) values(target_counselor_id,target_student_id);
 end if;
 update public.profiles set registration_status='active' where id=target_student_id;
end;$$;

-- Activation may keep the assigned counselor, but must never replace them.
create or replace function public.admin_activate_student_without_receipt(target_student_id uuid,target_counselor_id uuid) returns void language plpgsql security definer set search_path='' as $$
declare state text;
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only';end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 select registration_status into state from public.profiles where id=target_student_id and role='student' for update;
 if state is null or state='active' then raise exception 'Inactive student required';end if;
 if not exists(select 1 from auth.users where id=target_student_id and email_confirmed_at is not null) then raise exception 'Confirmed student required';end if;
 if not exists(select 1 from public.student_account_details where student_id=target_student_id) and not exists(select 1 from public.student_registrations where student_id=target_student_id) then raise exception 'Complete account information required';end if;
 if not exists(select 1 from public.profiles p join public.counselor_profiles c on c.user_id=p.id where p.id=target_counselor_id and p.role='counselor' and c.approval_status='approved') then raise exception 'Approved counselor required';end if;
 if exists(select 1 from public.counselor_students where student_id=target_student_id and counselor_id<>target_counselor_id) then
   raise exception 'Student already has a different counselor';
 end if;
 if not exists(select 1 from public.counselor_students where student_id=target_student_id) then
   insert into public.counselor_students(counselor_id,student_id) values(target_counselor_id,target_student_id);
 end if;
 insert into public.student_manual_activations(student_id,activated_by,counselor_id,previous_status)values(target_student_id,(select auth.uid()),target_counselor_id,state);
 update public.profiles set registration_status='active' where id=target_student_id;
 -- Receipt and purchase fields intentionally unchanged; manual approval has its own audit.
end;$$;

notify pgrst, 'reload schema';
