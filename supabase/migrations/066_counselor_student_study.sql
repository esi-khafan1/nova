-- Only an approved assigned counselor may edit these two canonical profile fields.
-- Registration/account submissions remain historical snapshots, not counselor-editable forms.
create or replace function public.counselor_update_student_study(
 target_student_id uuid, target_grade smallint, target_study_field public.study_field
) returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role
    or not exists(select 1 from public.counselor_profiles where user_id=(select auth.uid()) and approval_status='approved') then
  raise exception 'Approved counselor required' using errcode='42501';
 end if;
 if target_grade is null or target_grade not in (10,11,12)
    or target_study_field is null then
  raise exception 'Invalid student study fields' using errcode='22023';
 end if;
 -- Serialize curriculum edits with the existing plan-saving advisory lock.
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 perform 1 from public.counselor_students
  where student_id=target_student_id and counselor_id=(select auth.uid()) for update;
 if not found then raise exception 'Student not assigned' using errcode='42501'; end if;
 update public.profiles set grade=target_grade,study_field=target_study_field
  where id=target_student_id and role='student' and registration_status='active';
 if not found then raise exception 'Active student required' using errcode='42501'; end if;
end; $$;
revoke all on function public.counselor_update_student_study(uuid,smallint,public.study_field) from public,anon;
grant execute on function public.counselor_update_student_study(uuid,smallint,public.study_field) to authenticated;
