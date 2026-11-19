-- Optional per-slot routine minutes. Old snapshots remain valid; old clients cannot erase the new fields.
create or replace function public.normalize_weekly_plan_routines(target_routines jsonb)
returns jsonb
language plpgsql
immutable
set search_path = ''
as $$
declare
  routine jsonb;
  key text;
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
    for key in select unnest(array['durationMinutes','secondDurationMinutes']) loop
      if routine ? key and jsonb_typeof(routine->key) <> 'null' and
        (jsonb_typeof(routine->key) <> 'number' or routine->>key !~ '^[0-9]+$' or (routine->>key)::numeric not between 1 and 1440) then
        raise exception 'Invalid routine duration' using errcode='22023';
      end if;
    end loop;
    result := result || jsonb_build_array(jsonb_build_object(
      'dayOfWeek', day_value,
      'subject', left(btrim(coalesce(routine ->> 'subject', '')), 100),
      'details', left(btrim(coalesce(routine ->> 'details', '')), 500)
    ) || case when routine ? 'secondSubject' then
      jsonb_build_object('secondSubject', left(btrim(coalesce(routine ->> 'secondSubject', '')), 100)) else '{}'::jsonb end
      || case when routine ? 'secondDetails' then
      jsonb_build_object('secondDetails', left(btrim(coalesce(routine ->> 'secondDetails', '')), 500)) else '{}'::jsonb end
      || case when routine ? 'durationMinutes' then jsonb_build_object('durationMinutes',routine->'durationMinutes') else '{}'::jsonb end
      || case when routine ? 'secondDurationMinutes' then jsonb_build_object('secondDurationMinutes',routine->'secondDurationMinutes') else '{}'::jsonb end);
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
  saved_links jsonb := '[]'::jsonb;
  link jsonb;
  candidate_id uuid;
  candidate_count integer;
  mapping_count integer;
  has_source_ids boolean := false;
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
    -- The legacy direct v5 caller has not acquired the student lock yet.
    -- Never wait for it while holding the plan row: older writers acquire the
    -- same locks in the reverse order. A conflict rolls back and can be retried.
    if found then
      if not pg_catalog.pg_try_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033)) then
        raise exception 'Student plan is busy; retry saving' using errcode='40001';
      end if;
      -- Hold each item before taking the link snapshot, so an exam assignment
      -- cannot slip in after the snapshot and be lost during item replacement.
      perform 1 from public.weekly_plan_items i where i.plan_id=target_plan_id
      order by i.id for update;
    end if;
    select coalesce(jsonb_agg(jsonb_build_object(
      'id',i.id,'day',i.day_of_week,'subject',i.subject,
      'chapter',coalesce(i.chapter,''),'exam',i.linked_exam_id
    )),'[]'::jsonb) into saved_links
    from public.weekly_plan_items i
    where i.plan_id=target_plan_id and i.activity_type::text='exam' and i.linked_exam_id is not null;
  end if;

  -- A source-aware client must refer only to distinct items from this exact
  -- plan. Stale IDs are conflicts, never evidence that a link was removed.
  select exists(select 1 from jsonb_array_elements(target_items) x where x ? 'sourceItemId') into has_source_ids;
  if has_source_ids and (
    exists(select 1 from jsonb_array_elements(target_items) x where x->>'sourceItemId' is not null
      and not exists(select 1 from public.weekly_plan_items i where i.plan_id=target_plan_id and i.id::text=x->>'sourceItemId'))
    or exists(select 1 from jsonb_array_elements(target_items) x where x->>'sourceItemId' is not null
      group by x->>'sourceItemId' having count(*)>1)
  ) then raise exception 'Invalid or duplicate source identity' using errcode='PZ002'; end if;

  -- A cached older planner sends only the original routine fields. Retain
  -- second-routine values already stored for that day unless explicitly sent.
  if original_routines is not null then
    select jsonb_agg(
      item.value
      || case when not (item.value ? 'secondSubject') and previous.value ? 'secondSubject'
           then jsonb_build_object('secondSubject', previous.value -> 'secondSubject') else '{}'::jsonb end
      || case when not (item.value ? 'secondDetails') and previous.value ? 'secondDetails'
           then jsonb_build_object('secondDetails', previous.value -> 'secondDetails') else '{}'::jsonb end
      || case when not (item.value ? 'durationMinutes') and previous.value ? 'durationMinutes'
           then jsonb_build_object('durationMinutes',previous.value->'durationMinutes') else '{}'::jsonb end
      || case when not (item.value ? 'secondDurationMinutes') and previous.value ? 'secondDurationMinutes'
           then jsonb_build_object('secondDurationMinutes',previous.value->'secondDurationMinutes') else '{}'::jsonb end
      order by (item.value ->> 'dayOfWeek')::smallint
    ) into normalized
    from jsonb_array_elements(normalized) as item(value)
    left join lateral (
      select value from jsonb_array_elements(original_routines)
      where (value ->> 'dayOfWeek')::smallint = (item.value ->> 'dayOfWeek')::smallint
      limit 1
    ) previous on true;
  end if;

  saved := public.save_weekly_plan_v4(
    target_plan_id, target_student_id, target_week_start,
    target_title, target_notes, target_status, target_items
  );

  update public.weekly_plans
  set routines = normalized
  where id = saved
    and counselor_id = (select auth.uid());

  if saved_links <> '[]'::jsonb then
    -- The new publisher carries sourceItemId even where v3 replaces a future
    -- ID. Legacy callers do not. Prefer exact source identity when available;
    -- never spread one link onto multiple identical exam boxes.
    for link in select value from jsonb_array_elements(saved_links) loop
      -- Today's retained row already has its link. Matching another identical
      -- unlinked row here would silently grant access to the wrong exam.
      if exists(select 1 from public.weekly_plan_items i where i.id=(link->>'id')::uuid and i.plan_id=saved) then continue; end if;
      if has_source_ids then
        select count(*)::integer into mapping_count from jsonb_array_elements(target_items) x where x->>'sourceItemId'=link->>'id';
        if mapping_count > 1 then raise exception 'Ambiguous exam source identity' using errcode='PZ002'; end if;
        select count(*)::integer,(array_agg(i.id))[1] into candidate_count,candidate_id
        from jsonb_array_elements(target_items) with ordinality x(value,position)
        join public.weekly_plan_items i on i.plan_id=saved and i.sort_order=x.position-1
        where x.value->>'sourceItemId'=link->>'id' and i.activity_type::text='exam'
          and i.day_of_week=(link->>'day')::smallint and i.subject=link->>'subject'
          and coalesce(i.chapter,'')=link->>'chapter' and i.linked_exam_id is null;
        if mapping_count > 0 and candidate_count <> 1 then raise exception 'Exam source identity changed' using errcode='PZ002'; end if;
      else
        select count(*)::integer,(array_agg(i.id))[1] into candidate_count,candidate_id
        from public.weekly_plan_items i where i.plan_id=saved and i.activity_type::text='exam' and i.linked_exam_id is null
          and i.day_of_week=(link->>'day')::smallint and i.subject=link->>'subject' and coalesce(i.chapter,'')=link->>'chapter';
        -- A legacy payload has no source IDs. If more than one old link has
        -- this identity, or more than one candidate exists, matching is unsafe.
        if candidate_count > 1 or (candidate_count > 0 and (select count(*) from jsonb_array_elements(saved_links) x
          where x->>'day'=link->>'day' and x->>'subject'=link->>'subject' and x->>'chapter'=link->>'chapter'
            and not exists(select 1 from public.weekly_plan_items i where i.id=(x->>'id')::uuid and i.plan_id=saved)) > 1)
        then raise exception 'Ambiguous exam boxes; reopen and review the plan' using errcode='PZ002'; end if;
      end if;
      if candidate_count=1 and exists(select 1 from public.exams e where e.id=(link->>'exam')::uuid) then
        update public.weekly_plan_items set linked_exam_id=(link->>'exam')::uuid where id=candidate_id;
      end if;
    end loop;
  end if;

  return saved;
end;
$$;
create or replace function private.protect_completed_routines() returns trigger language plpgsql security definer set search_path='' as $$
declare c record; r jsonb; old_r jsonb; subject text; details text; duration_key text;
begin
 if not pg_catalog.pg_try_advisory_xact_lock(pg_catalog.hashtextextended((case when tg_op='INSERT' then new.student_id else old.student_id end)::text,73033)) then
  raise exception 'Student plan is busy; retry' using errcode='40001';
 end if;
 if tg_op='UPDATE' and new.student_id is distinct from old.student_id and not pg_catalog.pg_try_advisory_xact_lock(pg_catalog.hashtextextended(new.student_id::text,73033)) then
  raise exception 'Student plan is busy; retry' using errcode='40001';
 end if;
 if tg_op<>'DELETE' and new.status='published' and exists (
  select 1 from public.weekly_plans older join public.weekly_plan_routine_completions tick on tick.plan_id=older.id
  where older.id<>new.id and older.student_id=new.student_id and older.status='published'
    and older.week_start<new.week_start and older.week_start+tick.day_of_week>=new.week_start
 ) then raise exception 'A completed routine would be hidden by the new plan' using errcode='PZ003'; end if;
 if tg_op='INSERT' then return new; end if;
 for c in select * from public.weekly_plan_routine_completions where plan_id=old.id loop
  if tg_op='DELETE' then raise exception 'Completed routine is protected' using errcode='PZ003'; end if;
  if new.student_id is distinct from old.student_id or new.week_start is distinct from old.week_start or new.status is distinct from 'published'::public.content_status then
   raise exception 'Completed routine is protected' using errcode='PZ003';
  end if;
  select value into r from jsonb_array_elements(new.routines) value where value->>'dayOfWeek'=c.day_of_week::text limit 1;
  subject:=coalesce(r->>case when c.slot=1 then 'subject' else 'secondSubject' end,'');
  details:=coalesce(r->>case when c.slot=1 then 'details' else 'secondDetails' end,'');
  if subject is distinct from c.subject or details is distinct from c.details then raise exception 'Completed routine is protected' using errcode='PZ003'; end if;
  select value into old_r from jsonb_array_elements(old.routines) value where value->>'dayOfWeek'=c.day_of_week::text limit 1;
  duration_key:=case when c.slot=1 then 'durationMinutes' else 'secondDurationMinutes' end;
  if nullif(r->duration_key,'null'::jsonb) is distinct from nullif(old_r->duration_key,'null'::jsonb) then
    raise exception 'Completed routine is protected' using errcode='PZ003';
  end if;
 end loop;
 if tg_op='DELETE' then return old; end if;
 return new;
end; $$;

create function private.set_weekly_routine_progress_internal(target_plan_id uuid, target_day integer, target_slot integer, target_subject text, target_details text, target_completed boolean)
returns void language plpgsql security definer set search_path='' as $$
declare me uuid := (select auth.uid()); p public.weekly_plans%rowtype; r jsonb; v_subject text; v_details text;
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role
   or not exists(select 1 from public.profiles where id=me and registration_status='active') then
   raise exception 'Active student required' using errcode='42501';
 end if;
 if target_plan_id is null or target_day is null or target_day not between 0 and 6 or target_slot is null or target_slot not in (1,2)
    or target_subject is null or target_details is null or target_completed is null then raise exception 'Invalid routine' using errcode='22023'; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(me::text,73033));
 select * into p from public.weekly_plans where id=target_plan_id and student_id=me and status='published' for update;
 if not found or p.week_start + target_day > timezone('Asia/Tehran',now())::date then raise exception 'Routine unavailable' using errcode='42501'; end if;
 -- A newer published plan takes over shared dates, but a draft does not.
 if exists(select 1 from public.weekly_plans newer where newer.student_id=me and newer.status='published' and newer.id<>p.id and newer.week_start>p.week_start and newer.week_start<=p.week_start+target_day) then
   raise exception 'Routine superseded' using errcode='40001';
 end if;
 select value into r from jsonb_array_elements(p.routines) value where value->>'dayOfWeek'=target_day::text limit 1;
 v_subject := coalesce(r->>case when target_slot=1 then 'subject' else 'secondSubject' end,'');
 v_details := coalesce(r->>case when target_slot=1 then 'details' else 'secondDetails' end,'');
 if (btrim(v_subject)='' and btrim(v_details)='') or v_subject is distinct from target_subject or v_details is distinct from target_details then
   raise exception 'Routine changed; reload' using errcode='40001';
 end if;
 if exists(select 1 from public.weekly_plan_routine_completions c where c.plan_id=p.id and c.day_of_week=target_day and c.slot=target_slot and (c.subject is distinct from v_subject or c.details is distinct from v_details)) then
  raise exception 'Routine completion conflicts with plan' using errcode='40001';
 end if;
 if target_completed then
  insert into public.weekly_plan_routine_completions(plan_id,student_id,day_of_week,slot,subject,details)
  values(p.id,me,target_day,target_slot,v_subject,v_details) on conflict(plan_id,day_of_week,slot) do nothing;
 else
  delete from public.weekly_plan_routine_completions where plan_id=p.id and student_id=me and day_of_week=target_day and slot=target_slot;
 end if;
end; $$;


-- Both clients acquire the same student lock as the plan writer before comparing
-- duration. A legacy client cannot tick a routine with a duration it cannot see.
create function private.check_routine_duration(target_plan_id uuid,target_day integer,target_slot integer,target_duration integer)
returns void language plpgsql security definer set search_path='' as $$
declare r jsonb; stored integer;
begin
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended((select auth.uid())::text,73033));
 select x.value into r from public.weekly_plans p cross join lateral jsonb_array_elements(p.routines) x(value)
 where p.id=target_plan_id and p.student_id=(select auth.uid()) and x.value->>'dayOfWeek'=target_day::text limit 1;
 stored := (r->>case when target_slot=1 then 'durationMinutes' else 'secondDurationMinutes' end)::integer;
 if stored is distinct from target_duration then raise exception 'Routine changed; reload' using errcode='40001'; end if;
end; $$;
revoke all on function private.check_routine_duration(uuid,integer,integer,integer) from public,anon,authenticated;
revoke all on function private.set_weekly_routine_progress_internal(uuid,integer,integer,text,text,boolean) from public,anon,authenticated;
create or replace function public.set_weekly_routine_progress(target_plan_id uuid,target_day integer,target_slot integer,target_subject text,target_details text,target_completed boolean)
returns void language plpgsql security definer set search_path='' as $$
begin
 perform private.check_routine_duration(target_plan_id,target_day,target_slot,null);
 perform private.set_weekly_routine_progress_internal(target_plan_id,target_day,target_slot,target_subject,target_details,target_completed);
end; $$;
create function public.set_weekly_routine_progress_v2(target_plan_id uuid,target_day integer,target_slot integer,target_subject text,target_details text,target_completed boolean,target_duration integer)
returns void language plpgsql security definer set search_path='' as $$
begin
 if target_duration is not null and target_duration not between 1 and 1440 then raise exception 'Invalid routine duration' using errcode='22023'; end if;
 perform private.check_routine_duration(target_plan_id,target_day,target_slot,target_duration);
 perform private.set_weekly_routine_progress_internal(target_plan_id,target_day,target_slot,target_subject,target_details,target_completed);
end; $$;
revoke all on function public.set_weekly_routine_progress_v2(uuid,integer,integer,text,text,boolean,integer) from public,anon;
grant execute on function public.set_weekly_routine_progress_v2(uuid,integer,integer,text,text,boolean,integer) to authenticated;
notify pgrst, 'reload schema';
