-- Give an exam's author a read-only view of submitted participants and the
-- same per-question answer sheet as the submitting student. Never broaden the
-- exam_attempts or exam_booklets RLS policies for ordinary table reads.
create function public.designer_exam_attempts(target_exam_id uuid)
returns table (
  attempt_id uuid, student_id uuid, student_name text, score numeric,
  correct_answers smallint, incorrect_answers smallint,
  unanswered_count smallint, total_questions smallint, submitted_at timestamptz
) language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role
   or not exists(select 1 from public.exams e where e.id=target_exam_id and e.counselor_id=(select auth.uid()) and e.mode='booklet')
 then raise exception 'Exam not found' using errcode='42501'; end if;
 return query
 select a.id,a.student_id,coalesce(nullif(btrim(p.full_name),''),'دانش‌آموز نووا'),
  a.score,a.correct_answers,a.incorrect_answers,a.unanswered_count,a.total_questions,a.submitted_at
 from public.exam_attempts a join public.profiles p on p.id=a.student_id
 where a.exam_id=target_exam_id and a.submitted_at is not null
 order by a.submitted_at desc,a.id;
end $$;
revoke all on function public.designer_exam_attempts(uuid) from public,anon;
grant execute on function public.designer_exam_attempts(uuid) to authenticated;

create function public.designer_exam_attempt_review(target_exam_id uuid,target_attempt_id uuid)
returns table (booklet_id uuid,booklet_title text,pdf_url text,explanation_pdf_url text,sort_order smallint,
 question_number integer,student_choice integer,correct_choice integer,answer_status text)
language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role
   or not exists(
     select 1 from public.exams e join public.exam_attempts a on a.exam_id=e.id
     where e.id=target_exam_id and e.counselor_id=(select auth.uid())
       and e.mode='booklet' and a.id=target_attempt_id and a.submitted_at is not null
   ) then raise exception 'Submitted attempt not found' using errcode='42501'; end if;
 return query
 select b.id,b.title,b.pdf_url,b.explanation_pdf_url,b.sort_order,q.number,choices.selected,choices.key,
  case when choices.selected is null then 'unanswered'
   when choices.key is null then 'ungraded'
   when choices.selected=choices.key then 'correct' else 'incorrect' end
 from public.exam_booklets b
 join public.exam_attempts a on a.exam_id=b.exam_id and a.id=target_attempt_id
 cross join lateral generate_series(b.start_question_number::integer,b.end_question_number::integer) q(number)
 cross join lateral (select
  case when (a.answers->>q.number::text) ~ '^[1-4]$' then (a.answers->>q.number::text)::integer end as selected,
  case when (b.key_answers->>q.number::text) ~ '^[1-4]$' then (b.key_answers->>q.number::text)::integer end as key
 ) choices
 where b.exam_id=target_exam_id order by b.sort_order,q.number;
end $$;
revoke all on function public.designer_exam_attempt_review(uuid,uuid) from public,anon;
grant execute on function public.designer_exam_attempt_review(uuid,uuid) to authenticated;
notify pgrst,'reload schema';
