-- Optional actual amounts: a completed box with no number fulfills the full
-- planned duration / target count. NULL means inferred, never entered actual data.
-- Keep the three-argument RPC unchanged for older deployments.
create or replace function public.set_weekly_plan_item_progress(
  target_item_id uuid,
  target_completed boolean,
  target_completed_test_count integer,
  target_completed_minutes integer
) returns void language plpgsql security definer set search_path = '' as $$
declare
  target_student_id uuid;
  target_activity public.study_activity_type;
  tehran_today date := timezone('Asia/Tehran', now())::date;
begin
  if target_completed is null then raise exception 'Completion state is required'; end if;
  if (select private.current_user_role()) is distinct from 'student'::public.app_role then
    raise exception 'Only students can update plan progress';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended((select auth.uid())::text,73033));

  select plan.student_id, item.activity_type into target_student_id, target_activity
  from public.weekly_plan_items item
  join public.weekly_plans plan on plan.id = item.plan_id
  where item.id = target_item_id
    and plan.student_id = (select auth.uid())
    and plan.status = 'published'
    and exists(select 1 from public.profiles p where p.id=(select auth.uid()) and p.registration_status='active')
    and plan.week_start + item.day_of_week <= tehran_today;
  if target_student_id is null then
    raise exception 'Only own published activities through today can be updated';
  end if;

  if not target_completed and (target_completed_test_count is not null or target_completed_minutes is not null) then
    raise exception 'Clear values when removing progress';
  end if;
  if target_activity = 'practice_tests'::public.study_activity_type then
    if target_completed_minutes is not null then raise exception 'Test boxes accept only a test count'; end if;
    if target_completed_test_count is not null and target_completed_test_count not between 1 and 5000 then
      raise exception 'Test count must be between 1 and 5000';
    end if;
  else
    if target_completed_test_count is not null then raise exception 'Test count is only supported for test activities'; end if;
    if target_completed_minutes is not null and target_completed_minutes not between 1 and 1440 then
      raise exception 'Study minutes must be between 1 and 1440';
    end if;
  end if;

  if target_completed then
    insert into public.weekly_plan_item_completions
      (item_id,student_id,completed_at,checked_at,completed_test_count,completed_minutes)
    values (target_item_id,target_student_id,now(),now(),target_completed_test_count::smallint,target_completed_minutes::smallint)
    on conflict (item_id) do update set
      completed_at = excluded.completed_at,
      completed_test_count = excluded.completed_test_count,
      completed_minutes = excluded.completed_minutes;
      -- checked_at deliberately retains the first tick time on edits.
  else
    delete from public.weekly_plan_item_completions
    where item_id=target_item_id and student_id=target_student_id;
  end if;
end; $$;
revoke all on function public.set_weekly_plan_item_progress(uuid,boolean,integer,integer) from public,anon;
grant execute on function public.set_weekly_plan_item_progress(uuid,boolean,integer,integer) to authenticated;
notify pgrst, 'reload schema';
