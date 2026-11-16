-- Phase 3 item 1: hide the four moved near-duplicate rows from the
-- counselor's NEW-selection list, without deleting them and without
-- touching admin management of the bank.
--
-- Background (follow-up item 2, migration 241): two old v1 rows were moved
-- in place (same ids) into lessons where a correct row already existed:
--   جامعه‌شناسی ۲ درس ۱۴ «انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم»
--     pos 1, 120–123 — near-duplicates the correct row «مقایسه انقلاب اسلامی
--     و انقلاب‌های آزادی‌بخش» درس ۱۴ pos 453, 120–123 (v204);
--   جغرافیا ۲ درس ۲ «کانون و مرزهای ناحیه» pos 3, 15–17 — near-duplicates
--     the correct row «کانون و مرز ناحیه» درس ۲ pos 303, 15–18 (v180).
-- Both rows of each pair must be KEPT (no deletion, no merge). Only the
-- old (moved) rows are hidden from new selection.
--
-- Mechanism (chosen after investigating the schema, the list function and
-- both UI paths — see docs/planner-1405-audit/phase3-1-evidence.md):
--  1. A new boolean column hidden_from_selection (default false). No
--     hidden/is_active/deprecated column existed before.
--  2. planner_list_topics is re-issued byte-identical to migration 192
--     except for ONE added filter: counselors — the only role that uses
--     the new-selection UI (PlannerTopicEditor, rendered by
--     WeeklyPlanBuilder on the counselor plans page) — no longer see
--     hidden rows; super-admins still see EVERY row, so the admin bank
--     manager (PlannerTopicBankManager, which lists through this same
--     RPC) keeps full edit/delete access to the hidden rows. A filter
--     for all roles was rejected: it would have made the four rows
--     invisible — and therefore uneditable and undeletable — in the only
--     shipped admin UI.
--  3. A guarded update sets the flag ONLY on rows still in their exact
--     post-241 state: original v1 id formula (computed from the ORIGINAL
--     chapter), new chapter, original title, original position, the
--     post-241 pages, revision=2, not already hidden. Any row an admin
--     edited after 241 (revision bumped by planner_save_topic, or any
--     field changed) does not match and stays visible; a row 241 never
--     moved does not match either. The update bumps revision to 3, so a
--     re-run matches nothing and is a no-op.
--
-- What is NOT changed: planner_save_topic / planner_delete_topic are
-- untouched and never read or write the flag — an admin edit of a hidden
-- row preserves hidden=true (and bumps revision as usual), an admin
-- delete still works, and a deleted row is never resurrected (this
-- migration contains NO insert). planner_list_topic_chapters is
-- untouched: both chapters still contain visible rows, so the chapter
-- lists are unchanged. Saved plans store a snapshot (title + pages) plus
-- the bank id; hiding changes neither, so old plans referencing the old
-- ids still read back. (One narrow suggestion caveat is recorded in the
-- evidence file: if a plan's most recent topic is a hidden row,
-- suggestNextTopic skips that id and falls back to an earlier topic id
-- or the first topic of the chapter.)
--
-- No row is inserted or deleted by this migration.

alter table private.planner_topic_bank
 add column if not exists hidden_from_selection boolean not null default false;

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
  and t.preparation_track=target_track and t.subject=target_subject and t.chapter=target_chapter
  and (role='admin'::public.app_role or not t.hidden_from_selection);
 return result;
end; $$;
revoke all on function public.planner_list_topics(text,text,text,text,text,text) from public,anon;
grant execute on function public.planner_list_topics(text,text,text,text,text,text) to authenticated;
notify pgrst, 'reload schema';

-- Guarded hide of the four moved rows only. Guard (pattern B, adapted):
-- the row must still be exactly as migration 241 left it — same v1 id
-- (from the ORIGINAL chapter), new chapter, original title/position,
-- post-241 pages, revision=2, not already hidden. Anything else (admin
-- edit, admin delete, 241 never applied) is left untouched.
with hides as (select * from jsonb_to_recordset($hides$[
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "old_chapter": "درس ۱۵",
  "new_chapter": "درس ۱۴",
  "position": 1,
  "title": "انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم",
  "start": 120,
  "end": 123
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "old_chapter": "درس ۱",
  "new_chapter": "درس ۲",
  "position": 3,
  "title": "کانون و مرزهای ناحیه",
  "start": 15,
  "end": 17
 }
]$hides$::jsonb) as p(grade text,subject text,old_chapter text,new_chapter text,position integer,title text,start integer,"end" integer)),
tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set hidden_from_selection=true,revision=t.revision+1,updated_at=now()
from hides p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.old_chapter||':'||p.position)::uuid
 and t.edition='1405' and t.study_field='humanities' and t.grade=p.grade
 and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.new_chapter
 and t.title=p.title and t.position=p.position
 and t.page_start=p.start and t.page_end=p."end" and t.revision=2
 and not t.hidden_from_selection;
