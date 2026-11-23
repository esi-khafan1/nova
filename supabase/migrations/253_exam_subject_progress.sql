-- An independently limited history for each subject. This is a new RPC so
-- existing clients can keep using student_exam_subject_history unchanged.
create or replace function public.student_exam_subject_progress(
  target_student_id uuid,
  target_exam_id uuid,
  target_limit integer default 6
)
returns table(exam_id uuid, exam_title text, starts_at timestamptz, subject_title text, percentage numeric)
language sql stable security definer set search_path = '' as $$
  with eligible as (
    select a.exam_id, a.answers, e.title, e.starts_at
    from public.exam_attempts a
    join public.exams e on e.id = a.exam_id
    where a.student_id = target_student_id
      and a.submitted_at is not null
      and e.status = 'published'
      and e.starts_at <= (select cutoff.starts_at from public.exams cutoff where cutoff.id = target_exam_id)
      and (
        ((select private.current_user_role()) = 'student'
          and target_student_id = (select auth.uid())
          and private.student_report_available(e.id, target_student_id))
        or
        ((select private.current_user_role()) = 'counselor'
          and exists (select 1 from public.counselor_students cs
                      where cs.counselor_id = (select auth.uid()) and cs.student_id = target_student_id))
      )
  ), ranges as (
    select e.exam_id, e.answers, e.title, e.starts_at, b.key_answers,
           btrim(subject.value->>'title') as subject_title,
           (subject.value->>'start')::integer as first_question,
           (subject.value->>'end')::integer as last_question
    from eligible e
    join public.exam_booklets b on b.exam_id = e.exam_id
    cross join lateral jsonb_array_elements(
      case when jsonb_array_length(b.subject_ranges) > 0 then b.subject_ranges
      else jsonb_build_array(jsonb_build_object('title', b.title, 'start', b.start_question_number, 'end', b.end_question_number)) end
    ) subject(value)
    -- Generic booklet names are not evidence of a subject. Explicit ranges
    -- remain usable; a named single-subject booklet keeps its legacy fallback.
    where nullif(btrim(subject.value->>'title'), '') is not null
      and (jsonb_array_length(b.subject_ranges) > 0 or btrim(b.title) !~ '^دفترچه([[:space:]‌0-9۰-۹۱۲۳۴۵۶۷۸۹]|$)')
  ), subject_exams as (
    select distinct r.exam_id, r.title, r.starts_at, r.subject_title from ranges r
  ), ranked as (
    select se.*, row_number() over (partition by se.subject_title order by se.starts_at desc, se.exam_id desc) as rank
    from subject_exams se
  ), scores as (
    select r.exam_id, r.title, r.starts_at, r.subject_title,
           count(*) as total,
           count(*) filter (where (r.answers->>q.number::text) ~ '^[1-4]$' and (r.key_answers->>q.number::text) ~ '^[1-4]$' and (r.answers->>q.number::text) = (r.key_answers->>q.number::text)) as correct,
           count(*) filter (where (r.answers->>q.number::text) ~ '^[1-4]$' and (r.key_answers->>q.number::text) ~ '^[1-4]$' and (r.answers->>q.number::text) <> (r.key_answers->>q.number::text)) as incorrect
    from ranges r
    join ranked chosen on chosen.exam_id = r.exam_id and chosen.subject_title = r.subject_title
      and chosen.rank <= greatest(1, least(coalesce(target_limit, 6), 12))
    cross join lateral generate_series(r.first_question, r.last_question) q(number)
    group by r.exam_id, r.title, r.starts_at, r.subject_title
  )
  select s.exam_id, s.title, s.starts_at, s.subject_title,
         round((s.correct * 3 - s.incorrect) * 100.0 / nullif(s.total * 3, 0), 2)
  from scores s
  order by s.subject_title, s.starts_at, s.exam_id;
$$;

revoke all on function public.student_exam_subject_progress(uuid, uuid, integer) from public, anon;
grant execute on function public.student_exam_subject_progress(uuid, uuid, integer) to authenticated;
