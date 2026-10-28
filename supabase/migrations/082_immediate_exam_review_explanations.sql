-- Applied live as immediate_exam_review_explanations (20261028210311); do not reapply.
-- Student-owned answers and explanatory PDFs become available immediately after
-- final submission (including floating exams), even if peers are still testing.
-- A previously submitted attempt remains reviewable after assignment changes.
alter table public.exam_booklets add column explanation_pdf_url text
  check (explanation_pdf_url is null or
    (length(explanation_pdf_url) between 9 and 2048 and left(explanation_pdf_url,8)='https://'));
-- 029 limits direct SELECT to safe columns; explicitly keep the new column
-- unavailable through PostgREST. It is only returned via the guarded review RPC.
revoke select (explanation_pdf_url) on public.exam_booklets from public,anon,authenticated;

create or replace function private.student_has_submitted_exam(target_exam_id uuid,target_student_id uuid)
returns boolean language sql stable security definer set search_path='' as $$
 select target_student_id=(select auth.uid()) and exists(
   select 1 from public.exams e join public.exam_attempts a on a.exam_id=e.id
   where e.id=target_exam_id and e.status='published'
    and a.student_id=target_student_id and a.submitted_at is not null);
$$;
revoke all on function private.student_has_submitted_exam(uuid,uuid) from public,anon;
-- RLS policies call this helper as authenticated; it only checks the caller's own ID.
grant execute on function private.student_has_submitted_exam(uuid,uuid) to authenticated;

-- Do not change enrollment/submission permissions; these extra policy arms only
-- allow reading an already-submitted exam after a student's assignment ends.
alter policy eligible_people_read_exams on public.exams using (
 (counselor_id=(select auth.uid()) and (select private.current_user_role()) in ('exam_designer','counselor'))
 or (select private.current_user_role())='admin' or private.counselor_can_review_exam(id)
 or (private.student_can_access_exam(id,(select auth.uid())))
 or ((select private.current_user_role())='student' and private.student_has_submitted_exam(id,(select auth.uid()))));
alter policy eligible_people_read_exam_booklets on public.exam_booklets using (
 exists(select 1 from public.exams e where e.id=exam_booklets.exam_id and (
 (e.counselor_id=(select auth.uid()) and (select private.current_user_role())='exam_designer')
 or (select private.current_user_role())='admin' or private.counselor_can_review_exam(e.id)
 or (private.student_can_access_exam(e.id,(select auth.uid())) and (e.start_window_ends_at is null or exists(select 1 from public.exam_sessions s where s.exam_id=e.id and s.student_id=(select auth.uid()))))
 or ((select private.current_user_role())='student' and private.student_has_submitted_exam(e.id,(select auth.uid()))))));

-- Replace the return signature to include the explanation link. Only the
-- submitting student sees the key/URL; a still-running peer sees neither.
drop function public.student_exam_review(uuid);
create function public.student_exam_review(target_exam_id uuid)
returns table (booklet_id uuid, booklet_title text, pdf_url text, explanation_pdf_url text, sort_order smallint,
 question_number integer, student_choice integer, correct_choice integer, answer_status text)
language plpgsql stable security definer set search_path = '' as $$
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role then
  raise exception 'Only students can review their own submitted exam' using errcode = '42501';
 end if;
 if not exists (
  select 1 from public.exams e join public.exam_attempts a on a.exam_id=e.id
  where e.id=target_exam_id and e.mode='booklet' and e.status='published'
   and a.student_id=(select auth.uid()) and a.submitted_at is not null
   and private.student_has_submitted_exam(e.id,(select auth.uid()))
 ) then raise exception 'Submitted exam is not available' using errcode='42501'; end if;
 return query
 select b.id,b.title,b.pdf_url,b.explanation_pdf_url,b.sort_order,q.number,choices.selected,choices.key,
  case when choices.selected is null then 'unanswered'
   when choices.key is null then 'ungraded'
   when choices.selected=choices.key then 'correct' else 'incorrect' end
 from public.exam_booklets b
 join public.exam_attempts a on a.exam_id=b.exam_id and a.student_id=(select auth.uid())
 cross join lateral generate_series(b.start_question_number::integer,b.end_question_number::integer) q(number)
 cross join lateral (select
  case when (a.answers->>q.number::text) ~ '^[1-4]$' then (a.answers->>q.number::text)::integer end as selected,
  case when (b.key_answers->>q.number::text) ~ '^[1-4]$' then (b.key_answers->>q.number::text)::integer end as key
 ) choices
 where b.exam_id=target_exam_id order by b.sort_order,q.number;
end; $$;
revoke all on function public.student_exam_review(uuid) from public,anon;
grant execute on function public.student_exam_review(uuid) to authenticated;

-- Report/booklet access and subject history use the same owner-only gate.
create or replace function private.student_report_available(target_exam_id uuid,target_student_id uuid)
returns boolean language sql stable security definer set search_path='' as $$
 select private.student_has_submitted_exam(target_exam_id,target_student_id)
  and exists(select 1 from public.exams e where e.id=target_exam_id and e.mode='booklet');
$$;
revoke all on function private.student_report_available(uuid,uuid) from public,anon,authenticated;

-- Keep a box that is already attached to this exam valid even after its week
-- passes (or its student becomes inactive); editing the exam must not detach it.
create or replace function public.save_designer_exam(
 target_exam_id uuid,target_title text,target_description text,target_student_ids uuid[],target_starts_at timestamptz,
 target_status public.content_status,target_booklets jsonb,target_exam_field text default null,
 target_start_window_ends_at timestamptz default null,target_box_ids uuid[] default '{}'::uuid[]
) returns uuid language plpgsql security definer set search_path='' as $$
declare saved uuid; invalid_pdf boolean;
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role then
   raise exception 'Only exam designers can manage exams' using errcode='42501';end if;
 if target_student_ids is null or cardinality(target_student_ids)>10000 then
   raise exception 'Invalid selected students';end if;
 if target_box_ids is null or cardinality(target_box_ids)>200 then
   raise exception 'Invalid exam boxes';end if;
 if (target_status='published' and cardinality(target_student_ids)=0 and cardinality(target_box_ids)=0)
    or exists(select 1 from unnest(target_student_ids) x(id) where not exists(select 1 from public.profiles p where p.id=x.id and p.role='student'))
 then raise exception 'Invalid selected students';end if;
 -- A new box must be a published, current/future 'exam' plan item of an active
 -- student, and must not already belong to another designer's exam. Boxes that
 -- are already attached to this exam stay valid even after their week passes.
 if exists(select 1 from unnest(target_box_ids) b(id) where not exists(
   select 1 from public.weekly_plan_items i
   join public.weekly_plans p on p.id=i.plan_id
   join public.profiles pr on pr.id=p.student_id
   where i.id=b.id and i.activity_type::text='exam' and p.status='published'
     and (
       (target_exam_id is not null and i.linked_exam_id=target_exam_id)
       or (
         (p.week_start + i.day_of_week) >= timezone('Asia/Tehran',now())::date
         and pr.role='student' and pr.registration_status='active'
         and (i.linked_exam_id is null
           or exists(select 1 from public.exams e where e.id=i.linked_exam_id and e.counselor_id=(select auth.uid())))
       )
     )
 )) then raise exception 'Invalid exam boxes';end if;
 if target_exam_id is not null then
   perform 1 from public.exams where id=target_exam_id and counselor_id=(select auth.uid()) for update;
   if not found then raise exception 'Exam not found';end if;
 end if;
 -- The optional explanation belongs to the corresponding booklet, never to a student upload.
 if jsonb_typeof(target_booklets) is distinct from 'array' then raise exception 'Invalid booklets'; end if;
 select exists(select 1 from jsonb_array_elements(target_booklets) b
   where b ? 'explanationPdfUrl' and b->>'explanationPdfUrl' is not null
     and trim(b->>'explanationPdfUrl') <> ''
     and (length(trim(b->>'explanationPdfUrl')) > 2048 or left(trim(b->>'explanationPdfUrl'),8) <> 'https://'))
 into invalid_pdf;
 if invalid_pdf then raise exception 'Invalid explanation PDF'; end if;
 saved:=private.save_designer_exam_with_window(target_exam_id,target_title,target_description,'own_students',target_starts_at,target_status,target_booklets,target_exam_field,target_start_window_ends_at);
 -- The canonical save rebuilds booklets. Attach each optional PDF in the same
 -- transaction so a failed save never leaves the answer sheet mismatched.
 update public.exam_booklets b set explanation_pdf_url=nullif(trim(x.value->>'explanationPdfUrl'),'')
 from jsonb_array_elements(target_booklets) with ordinality as x(value,position)
 where b.exam_id=saved and b.sort_order=x.position-1;
 update public.exams set explicit_students=true,template_version=case when target_exam_field is null then null else 'national-1404-v1' end where id=saved;
 update public.weekly_plan_items set linked_exam_id=null
   where linked_exam_id=saved and not (id=any(target_box_ids));
 update public.weekly_plan_items set linked_exam_id=saved
   where id=any(target_box_ids) and activity_type::text='exam';
 delete from public.exam_students where exam_id=saved;
 insert into public.exam_students(exam_id,student_id) select saved,id from (select distinct unnest(target_student_ids) id) selected;
 return saved;
end $$;
revoke all on function public.save_designer_exam(uuid,text,text,uuid[],timestamptz,public.content_status,jsonb,text,timestamptz,uuid[]) from public,anon;
grant execute on function public.save_designer_exam(uuid,text,text,uuid[],timestamptz,public.content_status,jsonb,text,timestamptz,uuid[]) to authenticated;


-- A designer may add/correct an explanation after a scheduled exam is locked.
-- This cannot alter questions, keys, attempts, recipients, or schedule.
create function public.set_designer_exam_explanation(target_exam_id uuid,target_booklet_id uuid,target_url text)
returns void language plpgsql security definer set search_path='' as $$
declare cleaned text:=nullif(trim(coalesce(target_url,'')),'');
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role
    or not exists(select 1 from public.exams e where e.id=target_exam_id and e.counselor_id=(select auth.uid()))
 then raise exception 'Exam not found' using errcode='42501'; end if;
 if cleaned is not null and (length(cleaned)>2048 or left(cleaned,8)<>'https://')
 then raise exception 'Invalid explanation PDF'; end if;
 update public.exam_booklets set explanation_pdf_url=cleaned
 where id=target_booklet_id and exam_id=target_exam_id;
 if not found then raise exception 'Booklet not found' using errcode='42501'; end if;
end $$;
revoke all on function public.set_designer_exam_explanation(uuid,uuid,text) from public,anon;
grant execute on function public.set_designer_exam_explanation(uuid,uuid,text) to authenticated;
notify pgrst, 'reload schema';
