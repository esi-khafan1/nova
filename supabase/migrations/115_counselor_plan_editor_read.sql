-- Read the same plan-editor history under the caller's existing RLS. Identity
-- comes only from auth.uid(), so reads may start alongside fresh Auth checking.
create function public.counselor_plan_editor_page(page_offset integer default 0, previous_history boolean default false)
returns jsonb language plpgsql stable security invoker set search_path = '' as $$
declare me uuid := (select auth.uid()); result jsonb;
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then
    raise exception 'Counselor only' using errcode = '42501';
  end if;
  if page_offset is null or page_offset < 0 or previous_history is null then
    raise exception 'Invalid page';
  end if;

  if not previous_history then
    with selected as materialized (
      select p.id,p.student_id,p.week_start,p.title,p.notes,p.status,p.updated_at,p.routines
      from public.weekly_plans p where p.counselor_id=me
      order by p.week_start desc,p.id limit 201 offset page_offset
    ), page as materialized (select * from selected order by week_start desc,id limit 200)
    select jsonb_build_object('counselor_id',me,'has_more',(select count(*)>200 from selected),
      'plans',coalesce((select jsonb_agg(jsonb_build_object(
        'id',p.id,'student_id',p.student_id,'week_start',p.week_start,'title',p.title,'notes',p.notes,
        'status',p.status,'updated_at',p.updated_at,'routines',p.routines,
        'weekly_plan_items',coalesce((select jsonb_agg(jsonb_build_object(
          'id',i.id,'day_of_week',i.day_of_week,'duration_minutes',i.duration_minutes,
          'subject',i.subject,'chapter',i.chapter,'activity_type',i.activity_type,
          'target_test_count',i.target_test_count,'details',i.details,'sort_order',i.sort_order,
          'source_grade',i.source_grade,'preparation_track',i.preparation_track,
          'recommended_publisher',i.recommended_publisher,'exam_year',i.exam_year,'linked_exam_id',i.linked_exam_id
        )) from public.weekly_plan_items i where i.plan_id=p.id),'[]'::jsonb)
      ) order by p.week_start desc,p.id) from page p),'[]'::jsonb)) into result;
  else
    with selected as materialized (
      select p.id,p.student_id,p.counselor_id,p.week_start,p.title,p.status
      from public.weekly_plans p where p.status='published' and p.counselor_id<>me
      order by p.week_start desc,p.id limit 201 offset page_offset
    ), page as materialized (select * from selected order by week_start desc,id limit 200)
    select jsonb_build_object('counselor_id',me,'has_more',(select count(*)>200 from selected),
      'plans',coalesce((select jsonb_agg(jsonb_build_object(
        'id',p.id,'student_id',p.student_id,'counselor_id',p.counselor_id,'week_start',p.week_start,
        'title',p.title,'status',p.status,
        'weekly_plan_items',coalesce((select jsonb_agg(jsonb_build_object('day_of_week',i.day_of_week))
          from public.weekly_plan_items i where i.plan_id=p.id),'[]'::jsonb)
      ) order by p.week_start desc,p.id) from page p),'[]'::jsonb)) into result;
  end if;
  return result;
end; $$;
revoke all on function public.counselor_plan_editor_page(integer,boolean) from public,anon;
grant execute on function public.counselor_plan_editor_page(integer,boolean) to authenticated;
notify pgrst, 'reload schema';
