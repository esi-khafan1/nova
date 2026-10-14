-- Shared exams must not expose other counselors' students or participant counts.
alter policy participants_read_exam_attempts on public.exam_attempts using (
 student_id=(select auth.uid()) or (select private.current_user_role())='admin' or (
 exists(select 1 from public.exams e where e.id=exam_attempts.exam_id and e.counselor_id=(select auth.uid()))
 and exists(select 1 from public.counselor_students a where a.student_id=exam_attempts.student_id and a.counselor_id=(select auth.uid()))
 ));
create or replace function public.exam_attempts_for_counselor(target_exam_id uuid)
returns table (
  attempt_id uuid,
  student_id uuid,
  student_name text,
  score smallint,
  correct_answers smallint,
  incorrect_answers smallint,
  unanswered_count smallint,
  total_questions smallint,
  answers jsonb,
  answer_pdf_url text,
  submitted_at timestamptz
)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not exists (
    select 1 from public.exams exam
    where exam.id = target_exam_id
      and (
        exam.counselor_id = (select auth.uid())
        or (select private.current_user_role()) = 'admin'
      )
  ) then raise exception 'Exam not found'; end if;

  return query
  select attempt.id, attempt.student_id, profile.full_name,
    attempt.score, attempt.correct_answers,
    coalesce(attempt.incorrect_answers, 0::smallint),
    coalesce(attempt.unanswered_count, 0::smallint),
    attempt.total_questions,
    attempt.answers,
    attempt.answer_pdf_url, attempt.submitted_at
  from public.exam_attempts attempt
  join public.profiles profile on profile.id = attempt.student_id
  where attempt.exam_id = target_exam_id
    and ((select private.current_user_role())='admin' or exists(select 1 from public.counselor_students a where a.student_id=attempt.student_id and a.counselor_id=(select auth.uid())))
  order by attempt.submitted_at desc;
end;
$$;
