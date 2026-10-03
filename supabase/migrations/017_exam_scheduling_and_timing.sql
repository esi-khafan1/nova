alter table public.exams
  add column starts_at timestamptz not null default (now() + interval '1 day'),
  add column duration_minutes smallint not null default 60;

alter table public.exams
  add constraint exams_duration_minutes_check
  check (duration_minutes between 5 and 360);

create index exams_starts_at_idx
on public.exams(status, starts_at);

drop policy "eligible_people_read_exam_questions" on public.exam_questions;
create policy "eligible_people_read_exam_questions"
on public.exam_questions
for select
to authenticated
using (
  exists (
    select 1
    from public.exams exam
    where exam.id = exam_questions.exam_id
      and (
        exam.counselor_id = (select auth.uid())
        or (select private.current_user_role()) = 'admin'
        or (
          exam.status = 'published'
          and (select private.current_user_role()) = 'student'
          and now() >= exam.starts_at
          and now() < exam.starts_at + make_interval(mins => exam.duration_minutes)
          and exists (
            select 1
            from public.counselor_students assignment
            where assignment.student_id = (select auth.uid())
              and (
                exam.audience = 'all_assigned_students'
                or assignment.counselor_id = exam.counselor_id
              )
          )
        )
      )
  )
);

create or replace function public.save_exam(
  target_exam_id uuid,
  target_title text,
  target_description text,
  target_mode public.exam_mode,
  target_audience public.exam_audience,
  target_question_pdf_url text,
  target_starts_at timestamptz,
  target_duration_minutes smallint,
  target_status public.content_status,
  target_questions jsonb
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  saved_exam_id uuid;
  question jsonb;
  question_index integer := 0;
  option_value jsonb;
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role
    or not exists (
      select 1 from public.counselor_profiles cp
      where cp.user_id = (select auth.uid()) and cp.approval_status = 'approved'
    )
  then
    raise exception 'Only approved counselors can manage exams';
  end if;

  if char_length(trim(target_title)) not between 3 and 160
    or char_length(coalesce(target_description, '')) > 3000
    or target_status not in ('draft', 'published')
    or target_starts_at is null
    or target_starts_at <= now() + interval '1 minute'
    or target_duration_minutes not between 5 and 360
  then
    raise exception 'Invalid exam metadata or schedule';
  end if;

  if target_mode = 'pdf' then
    if target_question_pdf_url is null
      or target_question_pdf_url not like 'https://ik.imagekit.io/%'
      or coalesce(jsonb_array_length(target_questions), 0) <> 0
    then
      raise exception 'PDF exam requires a valid question file';
    end if;
  elsif target_mode = 'multiple_choice' then
    if target_question_pdf_url is not null
      or jsonb_typeof(target_questions) <> 'array'
      or jsonb_array_length(target_questions) not between 1 and 100
    then
      raise exception 'Multiple choice exam requires questions';
    end if;
  end if;

  if target_exam_id is null then
    insert into public.exams (
      counselor_id, title, description, mode, audience, question_pdf_url,
      starts_at, duration_minutes, status
    ) values (
      (select auth.uid()), trim(target_title), nullif(trim(target_description), ''),
      target_mode, target_audience, target_question_pdf_url,
      target_starts_at, target_duration_minutes, target_status
    ) returning id into saved_exam_id;
  else
    if exists (
      select 1 from public.exam_attempts attempt where attempt.exam_id = target_exam_id
    ) then
      raise exception 'An exam with submissions cannot be edited';
    end if;
    update public.exams
    set title = trim(target_title),
        description = nullif(trim(target_description), ''),
        mode = target_mode,
        audience = target_audience,
        question_pdf_url = target_question_pdf_url,
        starts_at = target_starts_at,
        duration_minutes = target_duration_minutes,
        status = target_status
    where id = target_exam_id and counselor_id = (select auth.uid())
    returning id into saved_exam_id;
    if saved_exam_id is null then raise exception 'Exam not found'; end if;
    delete from public.exam_questions where exam_id = saved_exam_id;
  end if;

  if target_mode = 'multiple_choice' then
    for question in select value from jsonb_array_elements(target_questions)
    loop
      if char_length(trim(question->>'prompt')) not between 1 and 1000
        or jsonb_typeof(question->'options') <> 'array'
        or jsonb_array_length(question->'options') not between 2 and 6
        or (question->>'correctOption')::integer < 0
        or (question->>'correctOption')::integer >= jsonb_array_length(question->'options')
      then
        raise exception 'Invalid exam question';
      end if;
      for option_value in select value from jsonb_array_elements(question->'options')
      loop
        if char_length(trim(option_value #>> '{}')) not between 1 and 500 then
          raise exception 'Invalid exam option';
        end if;
      end loop;
      insert into public.exam_questions (
        exam_id, prompt, options, correct_option, sort_order
      ) values (
        saved_exam_id,
        trim(question->>'prompt'),
        question->'options',
        (question->>'correctOption')::smallint,
        question_index
      );
      question_index := question_index + 1;
    end loop;
  end if;

  return saved_exam_id;
end;
$$;

create or replace function public.submit_multiple_choice_exam(
  target_exam_id uuid,
  target_answers jsonb
)
returns table (score smallint, correct_answers smallint, total_questions smallint)
language plpgsql
security definer
set search_path = ''
as $$
declare
  correct_count integer;
  question_count integer;
begin
  if (select private.current_user_role()) is distinct from 'student'::public.app_role then
    raise exception 'Only students can submit exams';
  end if;
  if not exists (
    select 1 from public.exams exam
    where exam.id = target_exam_id
      and exam.status = 'published'
      and exam.mode = 'multiple_choice'
      and now() >= exam.starts_at
      and now() <= exam.starts_at + make_interval(mins => exam.duration_minutes) + interval '30 seconds'
      and exists (
        select 1 from public.counselor_students assignment
        where assignment.student_id = (select auth.uid())
          and (
            exam.audience = 'all_assigned_students'
            or assignment.counselor_id = exam.counselor_id
          )
      )
  ) then raise exception 'Exam is not available at this time'; end if;
  if jsonb_typeof(target_answers) <> 'object' then raise exception 'Invalid answers'; end if;

  select count(*), count(*) filter (
    where (target_answers->>question.id::text) ~ '^[0-9]+$'
      and (target_answers->>question.id::text)::integer = question.correct_option
  )
  into question_count, correct_count
  from public.exam_questions question
  where question.exam_id = target_exam_id;

  if question_count = 0 then raise exception 'Exam has no questions'; end if;

  insert into public.exam_attempts (
    exam_id, student_id, answers, score, correct_answers, total_questions
  ) values (
    target_exam_id, (select auth.uid()), target_answers,
    round(correct_count * 100.0 / question_count)::smallint,
    correct_count::smallint, question_count::smallint
  );

  return query select
    round(correct_count * 100.0 / question_count)::smallint,
    correct_count::smallint,
    question_count::smallint;
end;
$$;

create or replace function public.submit_pdf_exam(
  target_exam_id uuid,
  target_answer_pdf_url text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if (select private.current_user_role()) is distinct from 'student'::public.app_role then
    raise exception 'Only students can submit exams';
  end if;
  if target_answer_pdf_url not like 'https://ik.imagekit.io/%' then
    raise exception 'Invalid answer file';
  end if;
  if not exists (
    select 1 from public.exams exam
    where exam.id = target_exam_id
      and exam.status = 'published'
      and exam.mode = 'pdf'
      and now() >= exam.starts_at
      and now() <= exam.starts_at + make_interval(mins => exam.duration_minutes) + interval '30 seconds'
      and exists (
        select 1 from public.counselor_students assignment
        where assignment.student_id = (select auth.uid())
          and (
            exam.audience = 'all_assigned_students'
            or assignment.counselor_id = exam.counselor_id
          )
      )
  ) then raise exception 'Exam is not available at this time'; end if;

  insert into public.exam_attempts (exam_id, student_id, answer_pdf_url)
  values (target_exam_id, (select auth.uid()), target_answer_pdf_url);
end;
$$;

revoke all on function public.save_exam(uuid,text,text,public.exam_mode,public.exam_audience,text,timestamptz,smallint,public.content_status,jsonb) from public, anon;
grant execute on function public.save_exam(uuid,text,text,public.exam_mode,public.exam_audience,text,timestamptz,smallint,public.content_status,jsonb) to authenticated;
