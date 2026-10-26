-- Preserve the first real tick time even when a student later edits a test count.
-- No new table is created, so no Data API grants are required.
alter table public.weekly_plan_item_completions
  add column if not exists checked_at timestamptz;

update public.weekly_plan_item_completions
set checked_at = completed_at
where checked_at is null;

alter table public.weekly_plan_item_completions
  alter column checked_at set default now(),
  alter column checked_at set not null;

create index if not exists weekly_plan_completions_checked_idx
  on public.weekly_plan_item_completions(student_id, checked_at desc);

create or replace function public.set_weekly_plan_item_progress(
  target_item_id uuid,
  target_completed boolean,
  target_completed_test_count integer
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_student_id uuid;
  target_activity public.study_activity_type;
  target_test_goal smallint;
  tehran_today date := timezone('Asia/Tehran', now())::date;
begin
  if (select private.current_user_role())
    is distinct from 'student'::public.app_role
  then
    raise exception 'Only students can update plan progress';
  end if;

  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended((select auth.uid())::text,73033));

  select plan.student_id, item.activity_type, item.target_test_count
  into target_student_id, target_activity, target_test_goal
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

  if target_activity = 'practice_tests'::public.study_activity_type
    and target_completed
    and (
      target_test_goal is null
      or target_completed_test_count is null
      or target_completed_test_count not between 1 and 5000
    )
  then
    raise exception 'Completed test count is required';
  end if;

  if target_activity <> 'practice_tests'::public.study_activity_type
    and target_completed_test_count is not null
  then
    raise exception 'Test count is only supported for test activities';
  end if;

  if target_completed then
    insert into public.weekly_plan_item_completions (
      item_id,
      student_id,
      completed_at,
      checked_at,
      completed_test_count
    )
    values (
      target_item_id,
      target_student_id,
      now(),
      now(),
      case
        when target_activity = 'practice_tests'::public.study_activity_type
          then target_completed_test_count::smallint
        else null
      end
    )
    on conflict (item_id) do update set
      completed_at = excluded.completed_at,
      completed_test_count = excluded.completed_test_count;
      -- checked_at is deliberately not updated: the first tick stays auditable.
  else
    delete from public.weekly_plan_item_completions
    where item_id = target_item_id
      and student_id = target_student_id;
  end if;
end;
$$;

-- Keep the older boolean-only RPC consistent for any legacy caller.
create or replace function public.set_weekly_plan_item_completed(
  target_item_id uuid,
  target_completed boolean
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_student_id uuid;
begin
  if (select private.current_user_role())
    is distinct from 'student'::public.app_role
  then
    raise exception 'Only students can update plan progress';
  end if;

  select plan.student_id
  into target_student_id
  from public.weekly_plan_items item
  join public.weekly_plans plan on plan.id = item.plan_id
  where item.id = target_item_id
    and plan.student_id = (select auth.uid())
    and plan.status = 'published';

  if target_student_id is null then
    raise exception 'Published plan item not found';
  end if;

  if target_completed then
    insert into public.weekly_plan_item_completions (
      item_id,
      student_id,
      completed_at,
      checked_at
    )
    values (
      target_item_id,
      target_student_id,
      now(),
      now()
    )
    on conflict (item_id) do update set
      completed_at = excluded.completed_at;
  else
    delete from public.weekly_plan_item_completions
    where item_id = target_item_id
      and student_id = target_student_id;
  end if;
end;
$$;

notify pgrst, 'reload schema';
