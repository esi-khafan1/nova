-- First save must use the exact plan version from which the editor was opened.
-- Otherwise a concurrent plan change between load and the first autosave could
-- become the draft's base version and later be overwritten without a conflict.
create function public.planner_save_working_draft_checked(
 target_student_id uuid,target_week_start date,target_plan_id uuid,target_snapshot jsonb,
 expected_revision text,expected_base_plan_updated_at timestamptz
) returns jsonb language plpgsql security definer set search_path='' as $$
declare actual timestamptz;
begin
 perform private.require_planner_draft_access(target_student_id);
 if target_week_start is null then raise exception 'Invalid date' using errcode='22023'; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended((select auth.uid())::text || ':' || target_student_id::text || ':' || target_week_start::text,73418));
 if expected_revision is null and target_plan_id is not null then
  if expected_base_plan_updated_at is null then raise exception 'Missing plan version' using errcode='40001'; end if;
  select p.updated_at into actual from public.weekly_plans p
   where p.id=target_plan_id and p.counselor_id=(select auth.uid()) and p.student_id=target_student_id and p.week_start=target_week_start for share;
  if not found or actual is distinct from expected_base_plan_updated_at then raise exception 'Published plan has changed' using errcode='40001'; end if;
 elsif target_plan_id is null and expected_base_plan_updated_at is not null then
  raise exception 'Invalid plan version' using errcode='22023';
 end if;
 -- Existing revisions retain their original base even if the live plan changes;
 -- counselors can still save work and resolve the conflict before publication.
 return public.planner_save_working_draft(target_student_id,target_week_start,target_plan_id,target_snapshot,expected_revision);
end; $$;
revoke all on function public.planner_save_working_draft(uuid,date,uuid,jsonb,text) from public,anon,authenticated;
revoke all on function public.planner_save_working_draft_checked(uuid,date,uuid,jsonb,text,timestamptz) from public,anon;
grant execute on function public.planner_save_working_draft_checked(uuid,date,uuid,jsonb,text,timestamptz) to authenticated;
notify pgrst, 'reload schema';
