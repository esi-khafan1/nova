-- Review is released only after the exam-wide scheduled end, using database time.
create or replace function public.student_exam_review(target_exam_id uuid)
returns table (booklet_id uuid, booklet_title text, pdf_url text, sort_order smallint,
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
   and now() >= e.starts_at + e.duration_minutes * interval '1 minute'
   and exists(select 1 from public.counselor_students cs
    where cs.student_id=(select auth.uid()) and (e.audience='all_assigned_students' or cs.counselor_id=e.counselor_id))
 ) then raise exception 'Submitted exam is not available' using errcode='42501'; end if;
 return query
 select b.id,b.title,b.pdf_url,b.sort_order,q.number,choices.selected,choices.key,
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

