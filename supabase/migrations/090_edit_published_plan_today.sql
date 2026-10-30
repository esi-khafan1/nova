-- Allow counselors to edit the ongoing day of a published plan without losing
-- checked progress or exam-box links. Past days remain locked in Tehran time.
-- No tables are added; existing function execution grants remain in place.
create or replace function public.save_weekly_plan_v3(
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
  item_target_test_count smallint;
  item_date date;
  item_id uuid;
  seen_ids uuid[] := array[]::uuid[];
  tehran_today date := timezone('Asia/Tehran', now())::date;
  is_published_edit boolean := false;
  edit_today boolean := current_setting('nova.edit_published_today', true) = 'on';
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

  if target_week_start is null
    or (target_plan_id is null and target_week_start < tehran_today)
    or target_week_start + 6 < tehran_today
  then raise exception 'Choose today or a future date for a new seven-day plan'; end if;
  -- Serialize all overlapping-plan checks for one student, across counselors.
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text, 73033));

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

    if is_published_edit and edit_today then
      -- Student progress and plan saving share the per-student advisory lock.
      -- Lock today's rows too, so a designer cannot move a linked box mid-save.
      perform 1 from public.weekly_plan_items
      where plan_id = saved_plan_id and target_week_start + day_of_week = tehran_today
      for update;
      delete from public.weekly_plan_items
      where plan_id = saved_plan_id
        and target_week_start + day_of_week > tehran_today;
      -- A checked item or linked exam box must never disappear (the former has
      -- an ON DELETE CASCADE completion, and the latter grants exam access).
      if exists (
        select 1 from public.weekly_plan_items i
        where i.plan_id = saved_plan_id
          and target_week_start + i.day_of_week = tehran_today
          and not exists (
            select 1 from jsonb_array_elements(target_items) submitted
            where submitted.value->>'id' = i.id::text
              and (submitted.value->>'dayOfWeek')::smallint = i.day_of_week
          )
          and (i.linked_exam_id is not null or exists (
            select 1 from public.weekly_plan_item_completions c where c.item_id = i.id
          ))
      ) then
        raise exception 'Cannot remove a completed activity or linked exam box from today' using errcode = 'PZ001';
      end if;
      delete from public.weekly_plan_items i
      where i.plan_id = saved_plan_id
        and target_week_start + i.day_of_week = tehran_today
        and not exists (
          select 1 from jsonb_array_elements(target_items) submitted
          where submitted.value->>'id' = i.id::text
            and (submitted.value->>'dayOfWeek')::smallint = i.day_of_week
        );
    elsif is_published_edit then
      -- Old v3/v4/v5/v6 clients still save only future items.
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
    item_target_test_count := nullif(item ->> 'targetTestCount', '')::smallint;
    item_date := target_week_start + item_day;

    if item_day not between 0 and 6
      or item_duration not between 15 and 720
      or nullif(btrim(item ->> 'subject'), '') is null
      or (
        item_activity = 'practice_tests'::public.study_activity_type
        and (item_target_test_count is null or item_target_test_count not between 1 and 5000)
      )
      or (
        item_activity <> 'practice_tests'::public.study_activity_type
        and item_target_test_count is not null
      )
      or (
        is_published_edit
        and (item_date < tehran_today or (not edit_today and item_date = tehran_today))
      )
      or (
        not is_published_edit
        and item_date < tehran_today
      )
    then
      raise exception 'Invalid or locked plan item';
    end if;

    item_id := nullif(item ->> 'id', '')::uuid;
    if item_id is not null then
      if not is_published_edit or not edit_today or item_date <> tehran_today or item_id = any(seen_ids) then
        raise exception 'Invalid or duplicate plan item id';
      end if;
      seen_ids := array_append(seen_ids, item_id);
      -- Keep the same id, completion and linked exam. A checked item keeps its
      -- activity type; a linked box keeps its exam identity (day/subject/chapter).
      update public.weekly_plan_items i set
        duration_minutes = item_duration,
        subject = left(btrim(item ->> 'subject'), 100),
        chapter = nullif(left(btrim(coalesce(item ->> 'chapter', '')), 160), ''),
        activity_type = item_activity,
        target_test_count = item_target_test_count,
        details = nullif(left(btrim(coalesce(item ->> 'details', '')), 500), ''),
        sort_order = item_index
      where i.id = item_id and i.plan_id = saved_plan_id
        and i.day_of_week = item_day
        and (i.linked_exam_id is null or (
          item_activity = 'exam'::public.study_activity_type
          and i.subject = left(btrim(item ->> 'subject'), 100)
          and coalesce(i.chapter, '') = left(btrim(coalesce(item ->> 'chapter', '')), 160)
        ))
        and (i.activity_type = item_activity or not exists (
          select 1 from public.weekly_plan_item_completions c where c.item_id = i.id
        ));
      if not found then
        raise exception 'Today activity has changed or is protected' using errcode = 'PZ001';
      end if;
    else
    insert into public.weekly_plan_items (
      plan_id,
      day_of_week,
      start_time,
      duration_minutes,
      subject,
      chapter,
      activity_type,
      target_test_count,
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
      item_target_test_count,
      nullif(left(btrim(coalesce(item ->> 'details', '')), 500), ''),
      item_index
    );
    end if;

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

create or replace function public.save_weekly_plan_v4(target_plan_id uuid,target_student_id uuid,target_week_start date,target_title text,target_notes text,target_status public.content_status,target_items jsonb)
returns uuid language plpgsql security definer set search_path='' as $$
declare saved uuid; item jsonb; item_index integer:=0; g smallint; track text; y smallint; student_grade smallint; student_field text; original_status public.content_status; today date:=timezone('Asia/Tehran',now())::date;
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then raise exception 'Only counselors can save plans'; end if;
 if not exists(select 1 from public.counselor_students where student_id=target_student_id and counselor_id=(select auth.uid())) then raise exception 'Student not assigned'; end if;
 if target_items is null or jsonb_typeof(target_items)<>'array' or jsonb_array_length(target_items)>100 then raise exception 'Invalid items'; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 select grade,study_field::text into student_grade,student_field from public.profiles where id=target_student_id;
 if target_plan_id is not null then select status into original_status from public.weekly_plans where id=target_plan_id and counselor_id=(select auth.uid()) for update; end if;
 for item in select value from jsonb_array_elements(target_items) loop
  g:=nullif(item->>'sourceGrade','')::smallint;track:=coalesce(item->>'preparationTrack','konkur');y:=nullif(item->>'examYear','')::smallint;
  if track not in ('konkur','final_exam') or (g is not null and (g not in (10,11,12))) then raise exception 'Invalid curriculum grade or track'; end if;
  if track='konkur' and y is not null then raise exception 'Invalid exam year'; end if;
  if track='final_exam' then
   if g is null or not exists(select 1 from public.school_subjects official where official.study_field::text=student_field and official.grade=g and official.subject=btrim(item->>'subject')) then raise exception 'Subject not in school curriculum'; end if;
  end if;
 end loop;
 -- Delegate all existing authorization, date locks, overlap checks and atomic persistence to v3.
 saved:=public.save_weekly_plan_v3(target_plan_id,target_student_id,target_week_start,target_title,target_notes,target_status,target_items);
 for item in select value from jsonb_array_elements(target_items) loop
  update public.weekly_plan_items set source_grade=nullif(item->>'sourceGrade','')::smallint,preparation_track=coalesce(item->>'preparationTrack','konkur'),exam_year=null
  where plan_id=saved and sort_order=item_index and day_of_week=(item->>'dayOfWeek')::smallint
   and ((original_status='published'::public.content_status and (target_week_start+day_of_week>today or (current_setting('nova.edit_published_today',true)='on' and target_week_start+day_of_week=today))) or (original_status is distinct from 'published'::public.content_status and target_week_start+day_of_week>=today));
  item_index:=item_index+1;
 end loop;
 return saved;
end; $$;

-- Only the new endpoint opts into today edits; existing deployed clients keep
-- their previous future-only behavior until their frontend is updated.
create function public.save_weekly_plan_v7(
  target_plan_id uuid, target_student_id uuid, target_week_start date,
  target_title text, target_notes text, target_status public.content_status,
  target_items jsonb, target_routines jsonb
) returns uuid language plpgsql security definer set search_path = '' as $$
begin
  perform pg_catalog.set_config('nova.edit_published_today', 'on', true);
  return public.save_weekly_plan_v6(
    target_plan_id, target_student_id, target_week_start,
    target_title, target_notes, target_status, target_items, target_routines
  );
end; $$;
revoke all on function public.save_weekly_plan_v7(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) from public,anon;
grant execute on function public.save_weekly_plan_v7(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) to authenticated;

notify pgrst, 'reload schema';
