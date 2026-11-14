-- Sort numbered chapters naturally when page spans are missing, while preserving page-first order.
-- Same authorization as planner_list_topics; no direct table access.
create or replace function public.planner_list_topic_chapters(target_edition text,target_field text,target_grade text,target_track text,target_subject text)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare role public.app_role := (select private.current_user_role()); result jsonb;
begin
 if role='counselor'::public.app_role then perform private.require_planner_preset_access();
 elsif role is distinct from 'admin'::public.app_role then raise exception 'Counselor or administrator required' using errcode='42501'; end if;
 if target_edition is null or target_edition !~ '^14[0-9]{2}$' or target_field is null or target_field not in ('all','mathematics','experimental_sciences','humanities','arts','foreign_languages')
  or target_grade is null or target_grade not in ('9','10','11','12','comprehensive') or target_track is null or target_track not in ('konkur','final_exam')
  or target_subject is null or length(target_subject)>100 then raise exception 'Invalid topic selection' using errcode='22023'; end if;
 select coalesce(jsonb_agg(c.chapter order by c.first_page nulls last,
   case when translate(c.chapter,'۰۱۲۳۴۵۶۷۸۹','0123456789') ~ '^(فصل|درس|بخش|مبحث) *[0-9]+'
    then substring(translate(c.chapter,'۰۱۲۳۴۵۶۷۸۹','0123456789') from '[0-9]+')::numeric end nulls last,c.chapter),'[]'::jsonb) into result
 from (select t.chapter,min(t.page_start) first_page from private.planner_topic_bank t
 where t.edition=target_edition and t.study_field=target_field and t.grade=target_grade and t.preparation_track=target_track and t.subject=target_subject group by t.chapter) c;
 return result;
end; $$;
revoke all on function public.planner_list_topic_chapters(text,text,text,text,text) from public,anon;
grant execute on function public.planner_list_topic_chapters(text,text,text,text,text) to authenticated;
notify pgrst, 'reload schema';
