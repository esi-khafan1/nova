-- Supersedes 052/053: admin assignment activates the account as well.
-- Existing assignment/reassignment and approved-counselor guards stay intact.
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

  -- Assignment by an admin is the activation decision, in the same transaction.
  update public.profiles set registration_status='active'
  where id=target_student_id and role='student' and registration_status<>'active';
end;
$$;

revoke all on function public.admin_assign_student_counselor(uuid, uuid)
from public, anon;

grant execute on function public.admin_assign_student_counselor(uuid, uuid)
to authenticated;



-- Repair existing assigned-but-inactive students without changing counselors,
-- receipts, purchases, approval metadata, roles or email verification state.
update public.profiles as student set registration_status='active'
where student.role='student' and student.registration_status<>'active'
 and exists (
  select 1 from public.counselor_students assignment
  join public.profiles counselor on counselor.id=assignment.counselor_id and counselor.role='counselor'
  join public.counselor_profiles cp on cp.user_id=counselor.id and cp.approval_status='approved'
  where assignment.student_id=student.id
 );
notify pgrst,'reload schema';
