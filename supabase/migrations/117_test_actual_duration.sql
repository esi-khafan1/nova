-- Preserve legacy proportional test-time calculations until a student edits that box.
alter table public.weekly_plan_item_completions add column test_duration_recorded boolean not null default false;
-- Keep the previous four-argument RPC compatible, but never erase a test duration
-- saved by a newer tab when an older tab updates only the test count.
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
      completed_minutes = case when target_activity = 'practice_tests'::public.study_activity_type and weekly_plan_item_completions.test_duration_recorded then weekly_plan_item_completions.completed_minutes else excluded.completed_minutes end;
      -- checked_at deliberately retains the first tick time on edits.
  else
    delete from public.weekly_plan_item_completions
    where item_id=target_item_id and student_id=target_student_id;
  end if;
end; $$;
revoke all on function public.set_weekly_plan_item_progress(uuid,boolean,integer,integer) from public,anon;
grant execute on function public.set_weekly_plan_item_progress(uuid,boolean,integer,integer) to authenticated;

-- The old RPC performs all ownership, date, activity, role and validation checks.
-- Keep its locks and first checked_at, and atomically attach the optional test time.
create function public.set_weekly_plan_item_progress_with_duration(
  target_item_id uuid, target_completed boolean, target_completed_test_count integer, target_completed_minutes integer
) returns void language plpgsql security definer set search_path = '' as $$
declare target_activity public.study_activity_type;
begin
  if target_completed_minutes is not null and target_completed_minutes not between 1 and 1440 then
    raise exception 'Study minutes must be between 1 and 1440';
  end if;
  select activity_type into target_activity from public.weekly_plan_items where id=target_item_id;
  if target_activity = 'practice_tests'::public.study_activity_type then
    if not target_completed and target_completed_minutes is not null then raise exception 'Clear values when removing progress'; end if;
    perform public.set_weekly_plan_item_progress(target_item_id,target_completed,target_completed_test_count,null);
    if target_completed then
      update public.weekly_plan_item_completions
      set completed_minutes=target_completed_minutes::smallint,test_duration_recorded=true
      where item_id=target_item_id and student_id=(select auth.uid());
    end if;
  else
    perform public.set_weekly_plan_item_progress(target_item_id,target_completed,target_completed_test_count,target_completed_minutes);
  end if;
end; $$;
revoke all on function public.set_weekly_plan_item_progress_with_duration(uuid,boolean,integer,integer) from public,anon;
grant execute on function public.set_weekly_plan_item_progress_with_duration(uuid,boolean,integer,integer) to authenticated;

-- Include the flag in the existing invoker/RLS-protected student projection.
create or replace function public.student_dashboard_page(page_offset integer default 0)
returns jsonb language plpgsql stable security invoker set search_path='' as $$
declare me uuid:=(select auth.uid()); active boolean; result jsonb;
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role then raise exception 'Student only' using errcode='42501'; end if;
 if page_offset is null or page_offset<0 then raise exception 'Invalid offset'; end if;
 select p.registration_status='active' into active from public.profiles p where p.id=me;
 if not coalesce(active,false) then
  return jsonb_build_object('student_id',me,'active',false,'plans','[]'::jsonb,'completions','[]'::jsonb,'has_more',false);
 end if;
 with selected as materialized (
  select p.id,p.title,p.week_start,p.notes from public.weekly_plans p
  where p.student_id=me and p.status='published'
  order by p.week_start desc,p.id limit 201 offset page_offset
 ), page as materialized (
  select * from selected order by week_start desc,id limit 200
 )
 select jsonb_build_object(
  'student_id',me,'active',true,
  'plans',coalesce((select jsonb_agg(jsonb_build_object(
   'id',p.id,'title',p.title,'week_start',p.week_start,'notes',p.notes,
   'weekly_plan_items',coalesce((select jsonb_agg(jsonb_build_object(
    'id',i.id,'plan_id',i.plan_id,'day_of_week',i.day_of_week,'duration_minutes',i.duration_minutes,
    'subject',i.subject,'chapter',i.chapter,'activity_type',i.activity_type,'target_test_count',i.target_test_count,
    'details',i.details,'recommended_publisher',i.recommended_publisher,'sort_order',i.sort_order,'source_grade',i.source_grade,
    'preparation_track',i.preparation_track,'exam_year',i.exam_year,
    'linked_exam_id',(select e.id from public.exams e where e.id=i.linked_exam_id and e.status='published' limit 1)
   ) order by i.sort_order,i.id) from public.weekly_plan_items i where i.plan_id=p.id),'[]'::jsonb)
  ) order by p.week_start desc,p.id) from page p),'[]'::jsonb),
  'completions',coalesce((select jsonb_agg(jsonb_build_object(
   'item_id',c.item_id,'completed_at',c.completed_at,'completed_test_count',c.completed_test_count,'completed_minutes',c.completed_minutes,'test_duration_recorded',c.test_duration_recorded
  ) order by c.item_id) from public.weekly_plan_item_completions c
  where c.student_id=me and exists(select 1 from public.weekly_plan_items i join page p on p.id=i.plan_id where i.id=c.item_id)),'[]'::jsonb),
  'has_more',(select count(*)>200 from selected)
 ) into result;
 return result;
end; $$;
revoke all on function public.student_dashboard_page(integer) from public,anon;
grant execute on function public.student_dashboard_page(integer) to authenticated;
notify pgrst, 'reload schema';
