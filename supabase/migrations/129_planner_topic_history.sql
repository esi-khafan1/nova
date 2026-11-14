-- Topic suggestions may use earlier published weeks of this assigned student,
-- but never another student's data or unpublished working copies.
create function public.planner_topic_history(target_student_id uuid,target_before date,target_grade integer,target_track text,target_subject text,target_chapter text)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare result jsonb;
begin
 perform private.require_planner_draft_access(target_student_id);
 if target_before is null or target_grade is null or target_grade not in (9,10,11,12)
  or target_track is null or target_track not in ('konkur','final_exam') or target_subject is null or length(target_subject)>100
  or target_chapter is null or length(target_chapter)>160 then raise exception 'Invalid topic history request' using errcode='22023'; end if;
 select coalesce(jsonb_agg(jsonb_build_object('date',d.date,'order',d.sort_order,'topicIds',d.ids) order by d.date,d.sort_order,d.id),'[]'::jsonb) into result from (
  select i.id,p.week_start+i.day_of_week as date,i.sort_order,
   (select coalesce(jsonb_agg(t->>'bankId' order by ord),'[]'::jsonb) from jsonb_array_elements(case when jsonb_typeof(e.data->'topics')='array' then e.data->'topics' else '[]'::jsonb end) with ordinality as a(t,ord)
    where jsonb_typeof(t)='object' and jsonb_typeof(t->'bankId')='string' and t->>'bankId'<>'') as ids
  from public.weekly_plans p join public.weekly_plan_items i on i.plan_id=p.id
  join private.planner_item_extras e on e.item_id=i.id
  where p.student_id=target_student_id and p.status='published'::public.content_status and p.week_start+i.day_of_week<target_before
   and i.source_grade=target_grade and i.preparation_track=target_track and i.subject=target_subject and coalesce(i.chapter,'')=target_chapter
   and jsonb_typeof(e.data->'topics')='array'
   and exists (select 1 from jsonb_array_elements(case when jsonb_typeof(e.data->'topics')='array' then e.data->'topics' else '[]'::jsonb end) t
    where jsonb_typeof(t)='object' and jsonb_typeof(t->'bankId')='string' and t->>'bankId'<>'')
  order by p.week_start+i.day_of_week desc,i.sort_order desc,i.id desc limit 100
 ) d where jsonb_array_length(d.ids)>0;
 return result;
end; $$;
revoke all on function public.planner_topic_history(uuid,date,integer,text,text,text) from public,anon;
grant execute on function public.planner_topic_history(uuid,date,integer,text,text,text) to authenticated;
notify pgrst, 'reload schema';
