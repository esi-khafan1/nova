revoke execute on function public.save_weekly_plan(
  uuid,
  date,
  text,
  text,
  public.content_status,
  jsonb
) from authenticated;

create or replace function public.save_weekly_plan_v2(
  target_plan_id uuid,
  target_student_id uuid,
  target_week_start date,
  target_title text,
  target_notes text,
  target_status public.content_status,
  target_items jsonb
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  saved_plan_id uuid;
  existing_status public.content_status;
  item jsonb;
  item_index integer := 0;
  item_day smallint;
  item_duration smallint;
  item_activity public.study_activity_type;
  item_date date;
  tehran_today date := timezone('Asia/Tehran', now())::date;
  current_week_start date;
  is_published_edit boolean := false;
begin
  if (select private.current_user_role())
    is distinct from 'counselor'::public.app_role
  then
    raise exception 'Only counselors can save weekly plans';
  end if;

  if not exists (
    select 1
    from public.counselor_students
    where counselor_id = (select auth.uid())
      and student_id = target_student_id
  ) then
    raise exception 'Select the student before creating a plan';
  end if;

  current_week_start :=
    tehran_today - ((extract(dow from tehran_today)::integer + 1) % 7);

  if target_week_start is null
    or extract(dow from target_week_start)::integer <> 6
    or target_week_start < current_week_start
  then
    raise exception 'Week must start on an available Saturday';
  end if;

  if target_status not in (
    'draft'::public.content_status,
    'published'::public.content_status
  ) then
    raise exception 'Unsupported plan status';
  end if;

  if jsonb_typeof(target_items) <> 'array'
    or jsonb_array_length(target_items) > 100
  then
    raise exception 'Plan must contain a valid item list';
  end if;

  select id, status
  into saved_plan_id, existing_status
  from public.weekly_plans
  where counselor_id = (select auth.uid())
    and student_id = target_student_id
    and week_start = target_week_start
  for update;

  if saved_plan_id is null then
    if target_plan_id is not null then
      raise exception 'The selected plan no longer exists';
    end if;

    if jsonb_array_length(target_items) = 0 then
      raise exception 'A new plan must contain at least one item';
    end if;

    insert into public.weekly_plans (
      counselor_id,
      student_id,
      week_start,
      title,
      notes,
      status
    )
    values (
      (select auth.uid()),
      target_student_id,
      target_week_start,
      left(coalesce(nullif(btrim(target_title), ''), 'برنامه هفتگی'), 120),
      nullif(left(btrim(coalesce(target_notes, '')), 2000), ''),
      target_status
    )
    returning id into saved_plan_id;
  else
    if target_plan_id is null or target_plan_id <> saved_plan_id then
      raise exception 'This week already has a plan; open it in edit mode';
    end if;

    is_published_edit :=
      existing_status = 'published'::public.content_status;

    if is_published_edit
      and target_status <> 'published'::public.content_status
    then
      raise exception 'A published plan cannot return to draft';
    end if;

    update public.weekly_plans
    set
      title = left(
        coalesce(nullif(btrim(target_title), ''), 'برنامه هفتگی'),
        120
      ),
      notes = nullif(
        left(btrim(coalesce(target_notes, '')), 2000),
        ''
      ),
      status = target_status
    where id = saved_plan_id;

    if is_published_edit then
      delete from public.weekly_plan_items
      where plan_id = saved_plan_id
        and target_week_start + day_of_week > tehran_today;
    else
      delete from public.weekly_plan_items
      where plan_id = saved_plan_id
        and target_week_start + day_of_week >= tehran_today;
    end if;
  end if;

  for item in select value from jsonb_array_elements(target_items)
  loop
    item_day := (item ->> 'dayOfWeek')::smallint;
    item_duration := (item ->> 'durationMinutes')::smallint;
    item_activity := (item ->> 'activityType')::public.study_activity_type;
    item_date := target_week_start + item_day;

    if item_day not between 0 and 6
      or item_duration not between 15 and 720
      or nullif(btrim(item ->> 'subject'), '') is null
      or (
        is_published_edit
        and item_date <= tehran_today
      )
      or (
        not is_published_edit
        and item_date < tehran_today
      )
    then
      raise exception 'Invalid or locked plan item';
    end if;

    insert into public.weekly_plan_items (
      plan_id,
      day_of_week,
      start_time,
      duration_minutes,
      subject,
      chapter,
      activity_type,
      details,
      sort_order
    )
    values (
      saved_plan_id,
      item_day,
      null,
      item_duration,
      left(btrim(item ->> 'subject'), 100),
      nullif(left(btrim(coalesce(item ->> 'chapter', '')), 160), ''),
      item_activity,
      nullif(left(btrim(coalesce(item ->> 'details', '')), 500), ''),
      item_index
    );

    item_index := item_index + 1;
  end loop;

  if not exists (
    select 1
    from public.weekly_plan_items
    where plan_id = saved_plan_id
  ) then
    raise exception 'Plan must contain at least one item';
  end if;

  return saved_plan_id;
end;
$$;

revoke all on function public.save_weekly_plan_v2(
  uuid,
  uuid,
  date,
  text,
  text,
  public.content_status,
  jsonb
) from public, anon;

grant execute on function public.save_weekly_plan_v2(
  uuid,
  uuid,
  date,
  text,
  text,
  public.content_status,
  jsonb
) to authenticated;