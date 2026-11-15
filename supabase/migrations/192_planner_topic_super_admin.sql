-- Restrict shared topic bank management to super administrators.
-- Approved counselors retain read-only access for planning; ordinary admins cannot use the bank RPCs.
-- The private table remains inaccessible directly to API roles.
create or replace function public.planner_list_topics(target_edition text,target_field text,target_grade text,target_track text,target_subject text,target_chapter text)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare role public.app_role := (select private.current_user_role()); result jsonb;
begin
 if role='counselor'::public.app_role then perform private.require_planner_preset_access();
 elsif role is distinct from 'admin'::public.app_role or (select private.is_super_admin()) is not true then raise exception 'Approved counselor or super administrator required' using errcode='42501'; end if;
 if target_edition is null or target_edition !~ '^14[0-9]{2}$' or target_field is null or target_field not in ('all','mathematics','experimental_sciences','humanities','arts','foreign_languages')
  or target_grade is null or target_grade not in ('9','10','11','12','comprehensive') or target_track is null or target_track not in ('konkur','final_exam')
  or target_subject is null or length(target_subject)>100 or target_chapter is null or length(target_chapter)>160 then raise exception 'Invalid topic selection' using errcode='22023'; end if;
 select coalesce(jsonb_agg(jsonb_build_object('id',t.id,'edition',t.edition,'studyField',t.study_field,'grade',t.grade,'track',t.preparation_track,
  'subject',t.subject,'chapter',t.chapter,'title',t.title,'pageStart',t.page_start,'pageEnd',t.page_end,'order',t.position,'revision',t.revision::text) order by t.position,t.id),'[]'::jsonb)
 into result from private.planner_topic_bank t where t.edition=target_edition and t.study_field=target_field and t.grade=target_grade
  and t.preparation_track=target_track and t.subject=target_subject and t.chapter=target_chapter;
 return result;
end; $$;
revoke all on function public.planner_list_topics(text,text,text,text,text,text) from public,anon;
grant execute on function public.planner_list_topics(text,text,text,text,text,text) to authenticated;

create or replace function public.planner_save_topic(target_id uuid,expected_revision text,target_edition text,target_field text,target_grade text,target_track text,
 target_subject text,target_chapter text,target_title text,target_page_start integer,target_page_end integer,target_position integer)
returns jsonb language plpgsql security definer set search_path='' as $$
declare saved private.planner_topic_bank%rowtype;
begin
 if (select private.is_super_admin()) is not true then raise exception 'Super administrator required' using errcode='42501'; end if;
 if target_id is null then
  if expected_revision is not null then raise exception 'Invalid revision' using errcode='22023'; end if;
  insert into private.planner_topic_bank(edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
  values(target_edition,target_field,target_grade,target_track,btrim(target_subject),btrim(target_chapter),btrim(target_title),target_page_start,target_page_end,target_position) returning * into saved;
 else
  if expected_revision is null or expected_revision !~ '^[1-9][0-9]{0,18}$' then raise exception 'Invalid revision' using errcode='22023'; end if;
  update private.planner_topic_bank t set edition=target_edition,study_field=target_field,grade=target_grade,preparation_track=target_track,
   subject=btrim(target_subject),chapter=btrim(target_chapter),title=btrim(target_title),page_start=target_page_start,page_end=target_page_end,
   position=target_position,revision=t.revision+1,updated_at=now() where t.id=target_id and t.revision::text=expected_revision returning * into saved;
  if not found then raise exception 'Topic changed' using errcode='40001'; end if;
 end if;
 return jsonb_build_object('id',saved.id,'revision',saved.revision::text);
end; $$;
revoke all on function public.planner_save_topic(uuid,text,text,text,text,text,text,text,text,integer,integer,integer) from public,anon;
grant execute on function public.planner_save_topic(uuid,text,text,text,text,text,text,text,text,integer,integer,integer) to authenticated;

create or replace function public.planner_delete_topic(target_id uuid,expected_revision text)
returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.is_super_admin()) is not true then raise exception 'Super administrator required' using errcode='42501'; end if;
 if target_id is null or expected_revision is null or expected_revision !~ '^[1-9][0-9]{0,18}$' then raise exception 'Invalid revision' using errcode='22023'; end if;
 delete from private.planner_topic_bank t where t.id=target_id and t.revision::text=expected_revision;
 if not found then raise exception 'Topic changed' using errcode='40001'; end if;
end; $$;
revoke all on function public.planner_delete_topic(uuid,text) from public,anon;
grant execute on function public.planner_delete_topic(uuid,text) to authenticated;


create or replace function public.planner_list_topic_chapters(target_edition text,target_field text,target_grade text,target_track text,target_subject text)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare role public.app_role := (select private.current_user_role()); result jsonb;
begin
 if role='counselor'::public.app_role then perform private.require_planner_preset_access();
 elsif role is distinct from 'admin'::public.app_role or (select private.is_super_admin()) is not true then raise exception 'Approved counselor or super administrator required' using errcode='42501'; end if;
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
