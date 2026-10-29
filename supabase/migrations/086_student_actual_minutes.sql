-- Record actual minutes for non-test boxes; keep the test-count flow unchanged.
-- Legacy completed rows remain null and are displayed/calculated as their
-- planned duration, without pretending that the student entered actual time.
alter table public.weekly_plan_item_completions
  add column completed_minutes smallint
  constraint weekly_plan_completion_minutes_check check (completed_minutes between 1 and 1440);

-- Keep the three-argument RPC available for old app builds during rollout.
-- Its existing ownership/role/activation/date checks and checked_at audit
-- are reused atomically; a failed four-argument call rolls back the tick.
create function public.set_weekly_plan_item_progress(
  target_item_id uuid,
  target_completed boolean,
  target_completed_test_count integer,
  target_completed_minutes integer
) returns void language plpgsql security definer set search_path = '' as $$
declare target_activity public.study_activity_type;
begin
  if target_completed is null then raise exception 'Completion state is required'; end if;
  if not target_completed and (target_completed_test_count is not null or target_completed_minutes is not null) then
    raise exception 'Clear values when removing progress';
  end if;
  perform public.set_weekly_plan_item_progress(target_item_id,target_completed,target_completed_test_count);
  if not target_completed then return; end if;
  select activity_type into target_activity from public.weekly_plan_items where id=target_item_id;
  if target_activity = 'practice_tests'::public.study_activity_type then
    if target_completed_minutes is not null then raise exception 'Test boxes accept only a test count'; end if;
  elsif target_completed_minutes is null or target_completed_minutes not between 1 and 1440 then
    raise exception 'Study minutes must be between 1 and 1440';
  end if;
  update public.weekly_plan_item_completions
  set completed_minutes = target_completed_minutes::smallint
  where item_id=target_item_id and student_id=(select auth.uid());
end; $$;
revoke all on function public.set_weekly_plan_item_progress(uuid,boolean,integer,integer) from public,anon;
grant execute on function public.set_weekly_plan_item_progress(uuid,boolean,integer,integer) to authenticated;

-- Add the optional value to the student's existing RLS-scoped paged projection.
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
   'item_id',c.item_id,'completed_at',c.completed_at,'completed_test_count',c.completed_test_count,'completed_minutes',c.completed_minutes
  ) order by c.item_id) from public.weekly_plan_item_completions c
  where c.student_id=me and exists(select 1 from public.weekly_plan_items i join page p on p.id=i.plan_id where i.id=c.item_id)),'[]'::jsonb),
  'has_more',(select count(*)>200 from selected)
 ) into result;
 return result;
end; $$;
revoke all on function public.student_dashboard_page(integer) from public,anon;
grant execute on function public.student_dashboard_page(integer) to authenticated;
notify pgrst, 'reload schema';
