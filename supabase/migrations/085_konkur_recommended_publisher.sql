-- A publisher recommendation belongs to a specific eligible Konkur activity.
-- No new table/roles; existing plan/item RLS and print projection stay unchanged.
alter table public.weekly_plan_items
  add column recommended_publisher text,
  add constraint weekly_plan_item_publisher_check check (
    recommended_publisher is null or (
      char_length(recommended_publisher) between 1 and 80
      and recommended_publisher = btrim(recommended_publisher)
      and recommended_publisher !~ '[[:cntrl:]]'
      and preparation_track = 'konkur'
      and activity_type::text in ('lesson', 'practice_tests', 'review', 'homework')
    )
  );

-- v5 still enforces assignment, ownership, overlaps, day locks, curricula and
-- exam-link restoration. Save recommendations in the SAME transaction by the
-- stable sort_order assigned by v5; never alter locked historical items.
create function public.save_weekly_plan_v6(
  target_plan_id uuid, target_student_id uuid, target_week_start date,
  target_title text, target_notes text, target_status public.content_status,
  target_items jsonb, target_routines jsonb
) returns uuid language plpgsql security definer set search_path = '' as $$
declare saved uuid; item jsonb; item_index integer := 0; publisher text; changed integer;
begin
  if target_items is null or jsonb_typeof(target_items) <> 'array' then
    raise exception 'Invalid items';
  end if;
  for item in select value from jsonb_array_elements(target_items) loop
    publisher := nullif(btrim(item->>'recommendedPublisher'), '');
    if publisher is not null and (
      char_length(publisher) > 80 or publisher ~ '[[:cntrl:]]'
      or item->>'preparationTrack' is distinct from 'konkur'
      or item->>'activityType' not in ('lesson', 'practice_tests', 'review', 'homework')
    ) then raise exception 'Invalid Konkur publisher'; end if;
  end loop;

  saved := public.save_weekly_plan_v5(
    target_plan_id, target_student_id, target_week_start,
    target_title, target_notes, target_status, target_items, target_routines
  );
  for item in select value from jsonb_array_elements(target_items) loop
    publisher := nullif(btrim(item->>'recommendedPublisher'), '');
    update public.weekly_plan_items i
    set recommended_publisher = publisher
    where i.plan_id = saved
      and i.sort_order = item_index
      and i.day_of_week = (item->>'dayOfWeek')::smallint
      and exists (select 1 from public.weekly_plans p
                  where p.id = saved and p.counselor_id = (select auth.uid()));
    get diagnostics changed = row_count;
    if changed <> 1 then raise exception 'Publisher item mapping failed'; end if;
    item_index := item_index + 1;
  end loop;
  return saved;
end; $$;
revoke all on function public.save_weekly_plan_v6(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) from public,anon;
grant execute on function public.save_weekly_plan_v6(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) to authenticated;

-- Re-issue the student RPC with the single new field; keep identity, activation,
-- publication, pagination, completion and linked-exam guards unchanged.
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
   'item_id',c.item_id,'completed_at',c.completed_at,'completed_test_count',c.completed_test_count
  ) order by c.item_id) from public.weekly_plan_item_completions c
  where c.student_id=me and exists(select 1 from public.weekly_plan_items i join page p on p.id=i.plan_id where i.id=c.item_id)),'[]'::jsonb),
  'has_more',(select count(*)>200 from selected)
 ) into result;
 return result;
end; $$;
revoke all on function public.student_dashboard_page(integer) from public,anon;
grant execute on function public.student_dashboard_page(integer) to authenticated;
notify pgrst, 'reload schema';
