-- Expose visibility state to the existing management list and provide a
-- revision-checked super-admin-only way to restore a hidden row. No seed,
-- plan, snapshot, title, page range, or position is rewritten.
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
  'subject',t.subject,'chapter',t.chapter,'title',t.title,'pageStart',t.page_start,'pageEnd',t.page_end,'order',t.position,'revision',t.revision::text,'hiddenFromSelection',t.hidden_from_selection) order by t.position,t.id),'[]'::jsonb)
 into result from private.planner_topic_bank t where t.edition=target_edition and t.study_field=target_field and t.grade=target_grade
  and t.preparation_track=target_track and t.subject=target_subject and t.chapter=target_chapter
  and (role='admin'::public.app_role or not t.hidden_from_selection);
 return result;
end; $$;
revoke all on function public.planner_list_topics(text,text,text,text,text,text) from public,anon;
grant execute on function public.planner_list_topics(text,text,text,text,text,text) to authenticated;
notify pgrst, 'reload schema';


create or replace function public.planner_restore_hidden_topic(target_id uuid, expected_revision text)
returns jsonb language plpgsql security definer set search_path='' as $$
declare saved private.planner_topic_bank%rowtype;
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role or (select private.is_super_admin()) is not true then
  raise exception 'Super administrator required' using errcode='42501';
 end if;
 if target_id is null or expected_revision is null or expected_revision !~ '^[1-9][0-9]{0,18}$' then
  raise exception 'Invalid revision' using errcode='22023';
 end if;
 update private.planner_topic_bank t set hidden_from_selection=false,revision=t.revision+1,updated_at=now()
 where t.id=target_id and t.revision::text=expected_revision and t.hidden_from_selection returning * into saved;
 if not found then raise exception 'Topic changed' using errcode='40001'; end if;
 return jsonb_build_object('id',saved.id,'revision',saved.revision::text);
end; $$;
revoke all on function public.planner_restore_hidden_topic(uuid,text) from public,anon;
grant execute on function public.planner_restore_hidden_topic(uuid,text) to authenticated;
notify pgrst, 'reload schema';
