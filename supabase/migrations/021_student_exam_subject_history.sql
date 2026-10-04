create or replace function public.student_exam_subject_history(
  target_student_id uuid,
  target_limit integer default 6
)
returns table (
  exam_id uuid,
  exam_title text,
  starts_at timestamptz,
  subject_title text,
  percentage numeric
)
language sql
stable
security definer
set search_path = ''
as $$
  with recent_attempts as (
    select attempt.exam_id, attempt.answers, exam.title as exam_title, exam.starts_at
    from public.exam_attempts attempt
    join public.exams exam on exam.id = attempt.exam_id
    where attempt.student_id = target_student_id
      and exam.counselor_id = (select auth.uid())
      and (select private.current_user_role()) = 'counselor'::public.app_role
    order by exam.starts_at desc
    limit greatest(1, least(coalesce(target_limit, 6), 12))
  ),
  subject_scores as (
    select recent.exam_id, recent.exam_title, recent.starts_at,
      booklet.title as subject_title, booklet.sort_order,
      booklet.question_count,
      count(*) filter (
        where recent.answers ? question.number::text
          and booklet.key_answers ? question.number::text
          and (recent.answers ->> question.number::text) ~ '^[1-4]$'
          and (booklet.key_answers ->> question.number::text) ~ '^[1-4]$'
          and (recent.answers ->> question.number::text)::integer =
              (booklet.key_answers ->> question.number::text)::integer
      ) as correct_count,
      count(*) filter (
        where recent.answers ? question.number::text
          and booklet.key_answers ? question.number::text
          and (recent.answers ->> question.number::text) ~ '^[1-4]$'
          and (booklet.key_answers ->> question.number::text) ~ '^[1-4]$'
          and (recent.answers ->> question.number::text)::integer <>
              (booklet.key_answers ->> question.number::text)::integer
      ) as incorrect_count
    from recent_attempts recent
    join public.exam_booklets booklet on booklet.exam_id = recent.exam_id
    cross join lateral generate_series(
      booklet.start_question_number::integer,
      booklet.end_question_number::integer
    ) as question(number)
    group by recent.exam_id, recent.exam_title, recent.starts_at,
      booklet.id, booklet.title, booklet.sort_order, booklet.question_count
  )
  select score.exam_id, score.exam_title, score.starts_at, score.subject_title,
    round(((score.correct_count * 3 - score.incorrect_count) * 100.0) /
      nullif(score.question_count * 3, 0), 2) as percentage
  from subject_scores score
  order by score.starts_at asc, score.sort_order asc;
$$;

revoke all on function public.student_exam_subject_history(uuid, integer)
  from public, anon;
grant execute on function public.student_exam_subject_history(uuid, integer)
  to authenticated;
