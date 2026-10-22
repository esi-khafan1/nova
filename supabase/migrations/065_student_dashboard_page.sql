-- One request per page of published plans, including their items and progress.
-- Derive identity from the database session and retain all underlying RLS.
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
    'details',i.details,'sort_order',i.sort_order,'source_grade',i.source_grade,
    'preparation_track',i.preparation_track,'exam_year',i.exam_year
   ) order by i.sort_order,i.id) from public.weekly_plan_items i where i.plan_id=p.id),'[]'::jsonb)
  ) order by p.week_start desc,p.id) from page p),'[]'::jsonb),
  'completions',coalesce((select jsonb_agg(jsonb_build_object(
   'item_id',c.item_id,'completed_at',c.completed_at,'completed_test_count',c.completed_test_count
  ) order by c.item_id) from public.weekly_plan_item_completions c
  where c.student_id=me and exists(select 1 from public.weekly_plan_items i join page p on p.id=i.plan_id where i.id=c.item_id)),'[]'::jsonb),
  'has_more',(select count(*)>200 from selected)
 ) into result;
 return result;
end; $$;
revoke all on function public.student_dashboard_page(integer) from public,anon;
grant execute on function public.student_dashboard_page(integer) to authenticated;
notify pgrst,'reload schema';
