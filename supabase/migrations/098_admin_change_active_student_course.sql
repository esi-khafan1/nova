-- Correct an administrator-assigned course without suspending services,
-- changing counselors, or altering the student's original request/receipt.
alter table private.student_service_events
  drop constraint student_service_events_event_type_check,
  add constraint student_service_events_event_type_check
    check (event_type in ('disabled','resumed','reassigned','course_activated','course_resumed','course_changed'));

create function public.admin_change_student_course(
  target_student_id uuid,
  expected_course_type text, expected_course_duration_months smallint,
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
  from public.profiles p where p.id=target_student_id and p.role='student'
    and p.registration_status='active' for update;
  if not found then raise exception 'Active student required'; end if;
  if old_course is distinct from expected_course_type
    or old_months is distinct from expected_course_duration_months then
    raise exception 'Course changed; refresh and review again';
  end if;
  if old_course is not distinct from target_course_type
    and old_months is not distinct from target_course_duration_months then
    raise exception 'Choose a different course or duration';
  end if;
  update public.profiles set service_course_type=target_course_type,
    service_course_duration_months=target_course_duration_months where id=target_student_id;
  insert into private.student_service_events(student_id,admin_id,event_type,
    previous_course_type,previous_course_duration_months,new_course_type,new_course_duration_months)
  values(target_student_id,(select auth.uid()),'course_changed',old_course,old_months,
    target_course_type,target_course_duration_months);
end; $$;
revoke all on function public.admin_change_student_course(uuid,text,smallint,text,smallint) from public,anon;
grant execute on function public.admin_change_student_course(uuid,text,smallint,text,smallint) to authenticated;
notify pgrst,'reload schema';
