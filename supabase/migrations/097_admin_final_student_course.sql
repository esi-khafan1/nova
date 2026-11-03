-- The student's purchase/request remains in student_registrations. These columns
-- record ONLY the service explicitly assigned by an administrator. Existing
-- accounts are not backfilled from receipts or historical requests.
alter table public.profiles
  add column service_course_type text,
  add column service_course_duration_months smallint,
  add constraint profiles_service_course_pair_check check (
    (service_course_type is null and service_course_duration_months is null) or
    (service_course_type in ('base','progress') and service_course_duration_months in (1,3,6,12))
  );
-- Authenticated users have column-level UPDATE privileges on profiles; never
-- grant these new service columns to the student or other client roles.

alter table private.student_service_events
  add column previous_course_type text,
  add column previous_course_duration_months smallint,
  add column new_course_type text,
  add column new_course_duration_months smallint;
alter table private.student_service_events
  drop constraint student_service_events_event_type_check,
  add constraint student_service_events_event_type_check
    check (event_type in ('disabled','resumed','reassigned','course_activated','course_resumed'));

-- Both operations run in one database transaction with the existing receipt,
-- manual-activation, counselor and suspension checks; any failure rolls back
-- the activation and the course assignment together.
create function public.admin_activate_student_with_course(
  target_student_id uuid, target_counselor_id uuid, expected_receipt_path text,
  target_course_type text, target_course_duration_months smallint
) returns void language plpgsql security definer set search_path='' as $$
declare old_course text; old_months smallint;
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only';
  end if;
  if not coalesce(
    (target_course_type is null and target_course_duration_months is null) or
    (target_course_type in ('base','progress') and target_course_duration_months in (1,3,6,12)), false
  ) then raise exception 'Invalid final course selection'; end if;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
  select p.service_course_type,p.service_course_duration_months into old_course,old_months
    from public.profiles p where p.id=target_student_id and p.role='student' for update;
  perform public.admin_activate_student_auto(target_student_id,target_counselor_id,expected_receipt_path);
  update public.profiles set service_course_type=target_course_type,
    service_course_duration_months=target_course_duration_months where id=target_student_id;
  insert into private.student_service_events(student_id,admin_id,event_type,
    previous_course_type,previous_course_duration_months,new_course_type,new_course_duration_months)
  values(target_student_id,(select auth.uid()),'course_activated',old_course,old_months,
    target_course_type,target_course_duration_months);
end; $$;

create function public.admin_resume_student_with_course(
  target_student_id uuid, target_counselor_id uuid,
  target_course_type text, target_course_duration_months smallint
) returns void language plpgsql security definer set search_path='' as $$
declare old_course text; old_months smallint;
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only';
  end if;
  if not coalesce(
    (target_course_type is null and target_course_duration_months is null) or
    (target_course_type in ('base','progress') and target_course_duration_months in (1,3,6,12)), false
  ) then raise exception 'Invalid final course selection'; end if;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
  select p.service_course_type,p.service_course_duration_months into old_course,old_months
    from public.profiles p where p.id=target_student_id and p.role='student' for update;
  perform public.admin_resume_student(target_student_id,target_counselor_id);
  update public.profiles set service_course_type=target_course_type,
    service_course_duration_months=target_course_duration_months where id=target_student_id;
  insert into private.student_service_events(student_id,admin_id,event_type,
    previous_course_type,previous_course_duration_months,new_course_type,new_course_duration_months)
  values(target_student_id,(select auth.uid()),'course_resumed',old_course,old_months,
    target_course_type,target_course_duration_months);
end; $$;
revoke all on function public.admin_activate_student_with_course(uuid,uuid,text,text,smallint),
  public.admin_resume_student_with_course(uuid,uuid,text,smallint) from public,anon;
grant execute on function public.admin_activate_student_with_course(uuid,uuid,text,text,smallint),
  public.admin_resume_student_with_course(uuid,uuid,text,smallint) to authenticated;
notify pgrst,'reload schema';
