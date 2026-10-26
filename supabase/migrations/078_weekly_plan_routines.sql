-- One routine per day, stored with the plan itself. No new table is created,
-- so no Data API grants are required. The save RPC validates the exact shape.
alter table public.weekly_plans
  add column if not exists routines jsonb not null default '[]'::jsonb,
  add constraint weekly_plans_routines_shape
    check (
      jsonb_typeof(routines) = 'array'
      and jsonb_array_length(routines) <= 7
    );

create or replace function public.normalize_weekly_plan_routines(target_routines jsonb)
returns jsonb
language plpgsql
immutable
set search_path = ''
as $$
declare
  routine jsonb;
  day_value smallint;
  result jsonb := '[]'::jsonb;
  seen_days smallint[] := array[]::smallint[];
begin
  if target_routines is null or jsonb_typeof(target_routines) <> 'array' then
    raise exception 'Invalid routines';
  end if;
  if jsonb_array_length(target_routines) <> 7 then
    raise exception 'Exactly seven daily routines are required';
  end if;

  for routine in select value from jsonb_array_elements(target_routines)
  loop
    if jsonb_typeof(routine) <> 'object' then
      raise exception 'Invalid routine entry';
    end if;
    day_value := (routine ->> 'dayOfWeek')::smallint;
    if day_value is null or day_value not between 0 and 6 then
      raise exception 'Invalid routine day';
    end if;
    if day_value = any(seen_days) then
      raise exception 'Duplicate routine day';
    end if;
    seen_days := array_append(seen_days, day_value);
    result := result || jsonb_build_array(jsonb_build_object(
      'dayOfWeek', day_value,
      'subject', left(btrim(coalesce(routine ->> 'subject', '')), 100),
      'details', left(btrim(coalesce(routine ->> 'details', '')), 500)
    ));
  end loop;

  return (
    select jsonb_agg(value order by (value ->> 'dayOfWeek')::smallint)
    from jsonb_array_elements(result)
  );
end;
$$;

create or replace function public.save_weekly_plan_v5(
  target_plan_id uuid,
  target_student_id uuid,
  target_week_start date,
  target_title text,
  target_notes text,
  target_status public.content_status,
  target_items jsonb,
  target_routines jsonb
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  saved uuid;
  original_routines jsonb;
  original_status public.content_status;
  normalized jsonb;
  today date := timezone('Asia/Tehran', now())::date;
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then
    raise exception 'Only counselors can save plans';
  end if;
  if not exists (
    select 1 from public.counselor_students
    where student_id = target_student_id and counselor_id = (select auth.uid())
  ) then
    raise exception 'Student not assigned';
  end if;

  normalized := public.normalize_weekly_plan_routines(target_routines);

  if target_plan_id is not null then
    select routines, status into original_routines, original_status
    from public.weekly_plans
    where id = target_plan_id and counselor_id = (select auth.uid())
    for update;
  end if;

  saved := public.save_weekly_plan_v4(
    target_plan_id, target_student_id, target_week_start,
    target_title, target_notes, target_status, target_items
  );

  update public.weekly_plans
  set routines = normalized
  where id = saved
    and counselor_id = (select auth.uid());

  return saved;
end;
$$;

revoke all on function public.normalize_weekly_plan_routines(jsonb) from public, anon;
grant execute on function public.normalize_weekly_plan_routines(jsonb) to authenticated;
revoke all on function public.save_weekly_plan_v5(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) from public, anon;
grant execute on function public.save_weekly_plan_v5(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) to authenticated;

notify pgrst, 'reload schema';
