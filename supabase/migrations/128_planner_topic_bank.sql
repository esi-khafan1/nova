-- Edition-specific shared topic/page bank. No textbook content is copied here;
-- entries are short topic labels and independently verified page ranges.
create table private.planner_topic_bank (
 id uuid primary key default gen_random_uuid(),
 edition text not null check (edition ~ '^14[0-9]{2}$'),
 study_field text not null check (study_field in ('all','mathematics','experimental_sciences','humanities','arts','foreign_languages')),
 grade text not null check (grade in ('9','10','11','12','comprehensive')),
 preparation_track text not null check (preparation_track in ('konkur','final_exam')),
 subject text not null check (char_length(subject) between 1 and 100 and subject=btrim(subject)),
 chapter text not null check (char_length(chapter) between 1 and 160 and chapter=btrim(chapter)),
 title text not null check (char_length(title) between 1 and 160 and title=btrim(title)),
 page_start integer, page_end integer,
 position integer not null check (position between 0 and 10000),
 revision bigint not null default 1 check (revision>0),
 updated_at timestamptz not null default now(),
 check ((page_start is null and page_end is null) or (page_start is not null and page_end is not null and page_start between 1 and 9999 and page_end between page_start and 9999))
);
create index planner_topic_bank_lookup on private.planner_topic_bank(edition,study_field,grade,preparation_track,subject,chapter,position,id);
revoke all on private.planner_topic_bank from public,anon,authenticated;

create function public.planner_list_topics(target_edition text,target_field text,target_grade text,target_track text,target_subject text,target_chapter text)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare role public.app_role := (select private.current_user_role()); result jsonb;
begin
 if role='counselor'::public.app_role then perform private.require_planner_preset_access();
 elsif role is distinct from 'admin'::public.app_role then raise exception 'Counselor or administrator required' using errcode='42501'; end if;
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

create function public.planner_save_topic(target_id uuid,expected_revision text,target_edition text,target_field text,target_grade text,target_track text,
 target_subject text,target_chapter text,target_title text,target_page_start integer,target_page_end integer,target_position integer)
returns jsonb language plpgsql security definer set search_path='' as $$
declare saved private.planner_topic_bank%rowtype;
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Administrator required' using errcode='42501'; end if;
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

create function public.planner_delete_topic(target_id uuid,expected_revision text)
returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Administrator required' using errcode='42501'; end if;
 if target_id is null or expected_revision is null or expected_revision !~ '^[1-9][0-9]{0,18}$' then raise exception 'Invalid revision' using errcode='22023'; end if;
 delete from private.planner_topic_bank t where t.id=target_id and t.revision::text=expected_revision;
 if not found then raise exception 'Topic changed' using errcode='40001'; end if;
end; $$;
revoke all on function public.planner_delete_topic(uuid,text) from public,anon;
grant execute on function public.planner_delete_topic(uuid,text) to authenticated;
notify pgrst, 'reload schema';
