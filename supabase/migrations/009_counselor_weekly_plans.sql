create type public.study_field as enum (
  'mathematics',
  'experimental_sciences',
  'humanities',
  'arts',
  'foreign_languages'
);

create type public.study_activity_type as enum (
  'lesson',
  'notes',
  'practice_tests',
  'class',
  'exam',
  'review',
  'homework',
  'summary',
  'other'
);

alter table public.profiles
add column study_field public.study_field;

grant update (study_field) on public.profiles to authenticated;

create table public.counselor_students (
  id uuid primary key default gen_random_uuid(),
  counselor_id uuid not null references public.profiles(id) on delete cascade,
  student_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (counselor_id, student_id),
  constraint counselor_student_are_different check (counselor_id <> student_id)
);

create table public.weekly_plans (
  id uuid primary key default gen_random_uuid(),
  counselor_id uuid not null references public.profiles(id) on delete restrict,
  student_id uuid not null references public.profiles(id) on delete cascade,
  week_start date not null,
  title text not null default 'برنامه هفتگی'
    check (char_length(title) between 2 and 120),
  notes text check (char_length(notes) <= 2000),
  status public.content_status not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (counselor_id, student_id, week_start)
);

create table public.weekly_plan_items (
  id uuid primary key default gen_random_uuid(),
  plan_id uuid not null references public.weekly_plans(id) on delete cascade,
  day_of_week smallint not null check (day_of_week between 0 and 6),
  start_time time,
  duration_minutes smallint not null
    check (duration_minutes between 15 and 720),
  subject text not null check (char_length(subject) between 1 and 100),
  chapter text check (char_length(chapter) <= 160),
  activity_type public.study_activity_type not null,
  details text check (char_length(details) <= 500),
  sort_order smallint not null default 0 check (sort_order >= 0),
  created_at timestamptz not null default now()
);

create trigger weekly_plans_updated_at
before update on public.weekly_plans
for each row execute function public.set_updated_at();

create index counselor_students_counselor_idx
on public.counselor_students(counselor_id, created_at desc);

create index counselor_students_student_idx
on public.counselor_students(student_id, created_at desc);

create index weekly_plans_counselor_idx
on public.weekly_plans(counselor_id, week_start desc);

create index weekly_plans_student_idx
on public.weekly_plans(student_id, week_start desc);

create index weekly_plan_items_plan_idx
on public.weekly_plan_items(plan_id, day_of_week, sort_order);

alter table public.counselor_students enable row level security;
alter table public.weekly_plans enable row level security;
alter table public.weekly_plan_items enable row level security;

create policy "assignment_participants_read"
on public.counselor_students
for select
to authenticated
using (
  counselor_id = (select auth.uid())
  or student_id = (select auth.uid())
  or (select private.current_user_role()) = 'admin'
);

create policy "counselors_create_assignments"
on public.counselor_students
for insert
to authenticated
with check (
  counselor_id = (select auth.uid())
  and (select private.current_user_role()) = 'counselor'
  and exists (
    select 1
    from public.profiles student
    where student.id = student_id and student.role = 'student'
  )
);

create policy "counselors_remove_assignments"
on public.counselor_students
for delete
to authenticated
using (
  counselor_id = (select auth.uid())
  or (select private.current_user_role()) = 'admin'
);

create policy "plan_participants_read"
on public.weekly_plans
for select
to authenticated
using (
  counselor_id = (select auth.uid())
  or student_id = (select auth.uid())
  or (select private.current_user_role()) = 'admin'
);

create policy "assigned_counselors_create_plans"
on public.weekly_plans
for insert
to authenticated
with check (
  counselor_id = (select auth.uid())
  and (select private.current_user_role()) = 'counselor'
  and exists (
    select 1
    from public.counselor_students assignment
    where assignment.counselor_id = (select auth.uid())
      and assignment.student_id = weekly_plans.student_id
  )
);

create policy "counselors_update_own_plans"
on public.weekly_plans
for update
to authenticated
using (
  counselor_id = (select auth.uid())
  or (select private.current_user_role()) = 'admin'
)
with check (
  counselor_id = (select auth.uid())
  or (select private.current_user_role()) = 'admin'
);

create policy "counselors_delete_own_plans"
on public.weekly_plans
for delete
to authenticated
using (
  counselor_id = (select auth.uid())
  or (select private.current_user_role()) = 'admin'
);

create policy "plan_participants_read_items"
on public.weekly_plan_items
for select
to authenticated
using (
  exists (
    select 1
    from public.weekly_plans plan
    where plan.id = weekly_plan_items.plan_id
      and (
        plan.counselor_id = (select auth.uid())
        or plan.student_id = (select auth.uid())
        or (select private.current_user_role()) = 'admin'
      )
  )
);

create policy "counselors_create_plan_items"
on public.weekly_plan_items
for insert
to authenticated
with check (
  exists (
    select 1
    from public.weekly_plans plan
    where plan.id = weekly_plan_items.plan_id
      and plan.counselor_id = (select auth.uid())
  )
);

create policy "counselors_update_plan_items"
on public.weekly_plan_items
for update
to authenticated
using (
  exists (
    select 1
    from public.weekly_plans plan
    where plan.id = weekly_plan_items.plan_id
      and (
        plan.counselor_id = (select auth.uid())
        or (select private.current_user_role()) = 'admin'
      )
  )
)
with check (
  exists (
    select 1
    from public.weekly_plans plan
    where plan.id = weekly_plan_items.plan_id
      and (
        plan.counselor_id = (select auth.uid())
        or (select private.current_user_role()) = 'admin'
      )
  )
);

create policy "counselors_delete_plan_items"
on public.weekly_plan_items
for delete
to authenticated
using (
  exists (
    select 1
    from public.weekly_plans plan
    where plan.id = weekly_plan_items.plan_id
      and (
        plan.counselor_id = (select auth.uid())
        or (select private.current_user_role()) = 'admin'
      )
  )
);

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
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then
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

revoke all on function public.counselor_student_directory()
from public, anon;
grant execute on function public.counselor_student_directory()
to authenticated;

create or replace function public.counselor_select_student(
  target_student_id uuid
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then
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

revoke all on function public.counselor_select_student(uuid)
from public, anon;
grant execute on function public.counselor_select_student(uuid)
to authenticated;

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
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then
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

revoke all on function public.save_weekly_plan(
  uuid,
  date,
  text,
  text,
  public.content_status,
  jsonb
) from public, anon;

grant execute on function public.save_weekly_plan(
  uuid,
  date,
  text,
  text,
  public.content_status,
  jsonb
) to authenticated;