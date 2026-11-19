-- Production rollout of supabase/migrations/251_routine_duration.sql.
-- Supabase migration planner_251_routine_duration_checked, version 20261119023546.
-- tests/routine-duration-rollout.test.cjs checks all resulting function bodies
-- against the canonical migration and exercises legacy and protected routines.
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


-- Identical function bodies to migration 251, with strict precondition checks.
-- The unchanged portions are read from the already installed 125/250 definitions.
do $patch$
declare v text; original text;
begin
 if to_regprocedure('public.set_weekly_routine_progress_v2(uuid,integer,integer,text,text,boolean,integer)') is not null then raise exception 'Migration already installed'; end if;
 if (select md5(prosrc) from pg_proc where oid='public.save_weekly_plan_v5(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb)'::regprocedure)<>'09a83c90c17554f858e0298075c6d39a'
 or (select md5(prosrc) from pg_proc where oid='private.protect_completed_routines()'::regprocedure)<>'8a61783ded308de9908b1129258e6cb5'
 or (select md5(prosrc) from pg_proc where oid='public.set_weekly_routine_progress(uuid,integer,integer,text,text,boolean)'::regprocedure)<>'b722b3309cdda9f1d2cd84bc664408be' then raise exception 'Unexpected routine schema'; end if;
 select pg_get_functiondef('public.save_weekly_plan_v5(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb)'::regprocedure) into original;
 v:=replace(original,$old$      || case when not (item.value ? 'secondDetails') and previous.value ? 'secondDetails'
           then jsonb_build_object('secondDetails', previous.value -> 'secondDetails') else '{}'::jsonb end$old$,$new$      || case when not (item.value ? 'secondDetails') and previous.value ? 'secondDetails'
           then jsonb_build_object('secondDetails', previous.value -> 'secondDetails') else '{}'::jsonb end
      || case when not (item.value ? 'durationMinutes') and previous.value ? 'durationMinutes'
           then jsonb_build_object('durationMinutes',previous.value->'durationMinutes') else '{}'::jsonb end
      || case when not (item.value ? 'secondDurationMinutes') and previous.value ? 'secondDurationMinutes'
           then jsonb_build_object('secondDurationMinutes',previous.value->'secondDurationMinutes') else '{}'::jsonb end$new$);
 if v=original then raise exception 'Plan saver patch did not match'; end if;
 execute v;
 select pg_get_functiondef('private.protect_completed_routines()'::regprocedure) into original;
 v:=replace(replace(original,$old$declare c record; r jsonb; subject text; details text;$old$,$new$declare c record; r jsonb; old_r jsonb; subject text; details text; duration_key text;$new$),$old$  if subject is distinct from c.subject or details is distinct from c.details then raise exception 'Completed routine is protected' using errcode='PZ003'; end if;$old$,$new$  if subject is distinct from c.subject or details is distinct from c.details then raise exception 'Completed routine is protected' using errcode='PZ003'; end if;
  select value into old_r from jsonb_array_elements(old.routines) value where value->>'dayOfWeek'=c.day_of_week::text limit 1;
  duration_key:=case when c.slot=1 then 'durationMinutes' else 'secondDurationMinutes' end;
  if nullif(r->duration_key,'null'::jsonb) is distinct from nullif(old_r->duration_key,'null'::jsonb) then
    raise exception 'Completed routine is protected' using errcode='PZ003';
  end if;$new$);
 if v=original or position($new$declare c record; r jsonb; old_r jsonb; subject text; details text; duration_key text;$new$ in v)=0 or position($new$  if subject is distinct from c.subject or details is distinct from c.details then raise exception 'Completed routine is protected' using errcode='PZ003'; end if;
  select value into old_r from jsonb_array_elements(old.routines) value where value->>'dayOfWeek'=c.day_of_week::text limit 1;
  duration_key:=case when c.slot=1 then 'durationMinutes' else 'secondDurationMinutes' end;
  if nullif(r->duration_key,'null'::jsonb) is distinct from nullif(old_r->duration_key,'null'::jsonb) then
    raise exception 'Completed routine is protected' using errcode='PZ003';
  end if;$new$ in v)=0 then raise exception 'Routine guard patch did not match'; end if;
 execute v;
 select pg_get_functiondef('public.set_weekly_routine_progress(uuid,integer,integer,text,text,boolean)'::regprocedure) into original;
 v:=replace(original,'public.set_weekly_routine_progress(', 'private.set_weekly_routine_progress_internal(');
 if v=original then raise exception 'Routine tick function patch did not match'; end if;
 execute v;
end $patch$;

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
