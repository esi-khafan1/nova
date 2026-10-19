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

  -- The registration flows treat counselor_students as the student's single
  -- current assignment, so replace any previous assignment atomically.
  delete from public.counselor_students
  where student_id = target_student_id;

  insert into public.counselor_students (counselor_id, student_id)
  values (target_counselor_id, target_student_id);
end;
$$;

revoke all on function public.admin_assign_student_counselor(uuid, uuid)
from public, anon;

grant execute on function public.admin_assign_student_counselor(uuid, uuid)
to authenticated;

notify pgrst, 'reload schema';
