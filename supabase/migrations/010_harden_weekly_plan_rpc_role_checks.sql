create or replace function public.counselor_student_directory()
returns table (
  student_id uuid,
  full_name text,
  grade smallint,
  study_field public.study_field,
  is_selected boolean
)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if (select private.current_user_role())
    is distinct from 'counselor'::public.app_role
  then
    raise exception 'Only counselors can browse students';
  end if;

  return query
  select
    student.id,
    student.full_name,
    student.grade,
    student.study_field,
    exists (
      select 1
      from public.counselor_students assignment
      where assignment.counselor_id = (select auth.uid())
        and assignment.student_id = student.id
    )
  from public.profiles student
  where student.role = 'student'
  order by
    exists (
      select 1
      from public.counselor_students assignment
      where assignment.counselor_id = (select auth.uid())
        and assignment.student_id = student.id
    ) desc,
    student.full_name asc;
end;
$$;

create or replace function public.counselor_select_student(
  target_student_id uuid
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select private.current_user_role())
    is distinct from 'counselor'::public.app_role
  then
    raise exception 'Only counselors can select students';
  end if;

  if not exists (
    select 1
    from public.profiles
    where id = target_student_id and role = 'student'
  ) then
    raise exception 'Student not found';
  end if;

  insert into public.counselor_students (counselor_id, student_id)
  values ((select auth.uid()), target_student_id)
  on conflict (counselor_id, student_id) do nothing;
end;
$$;

create or replace function public.save_weekly_plan(
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
  item jsonb;
  item_index integer := 0;
  item_day smallint;
  item_duration smallint;
  item_activity public.study_activity_type;
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

  if target_week_start is null then
    raise exception 'Week start is required';
  end if;

  if target_status not in (
    'draft'::public.content_status,
    'published'::public.content_status
  ) then
    raise exception 'Unsupported plan status';
  end if;

  if jsonb_typeof(target_items) <> 'array'
    or jsonb_array_length(target_items) = 0
    or jsonb_array_length(target_items) > 100
  then
    raise exception 'Plan must have between 1 and 100 items';
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
  on conflict (counselor_id, student_id, week_start)
  do update set
    title = excluded.title,
    notes = excluded.notes,
    status = excluded.status
  returning id into saved_plan_id;

  delete from public.weekly_plan_items where plan_id = saved_plan_id;

  for item in select value from jsonb_array_elements(target_items)
  loop
    item_day := (item ->> 'dayOfWeek')::smallint;
    item_duration := (item ->> 'durationMinutes')::smallint;
    item_activity := (item ->> 'activityType')::public.study_activity_type;

    if item_day not between 0 and 6
      or item_duration not between 15 and 720
      or nullif(btrim(item ->> 'subject'), '') is null
    then
      raise exception 'Invalid plan item';
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
      nullif(item ->> 'startTime', '')::time,
      item_duration,
      left(btrim(item ->> 'subject'), 100),
      nullif(left(btrim(coalesce(item ->> 'chapter', '')), 160), ''),
      item_activity,
      nullif(left(btrim(coalesce(item ->> 'details', '')), 500), ''),
      item_index
    );

    item_index := item_index + 1;
  end loop;

  return saved_plan_id;
end;
$$;