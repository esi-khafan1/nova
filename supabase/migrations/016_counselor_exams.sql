create type public.exam_mode as enum ('multiple_choice', 'pdf');
create type public.exam_audience as enum ('own_students', 'all_assigned_students');

create table public.exams (
  id uuid primary key default gen_random_uuid(),
  counselor_id uuid not null references public.profiles(id) on delete restrict,
  title text not null check (char_length(title) between 3 and 160),
  description text check (char_length(description) <= 3000),
  mode public.exam_mode not null,
  audience public.exam_audience not null default 'own_students',
  question_pdf_url text,
  status public.content_status not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint exam_pdf_matches_mode check (
    (mode = 'pdf' and question_pdf_url is not null)
    or (mode = 'multiple_choice' and question_pdf_url is null)
  )
);

create table public.exam_questions (
  id uuid primary key default gen_random_uuid(),
  exam_id uuid not null references public.exams(id) on delete cascade,
  prompt text not null check (char_length(prompt) between 1 and 1000),
  options jsonb not null check (
    jsonb_typeof(options) = 'array'
    and jsonb_array_length(options) between 2 and 6
  ),
  correct_option smallint not null check (correct_option between 0 and 5),
  sort_order smallint not null default 0 check (sort_order >= 0),
  created_at timestamptz not null default now()
);

create table public.exam_attempts (
  id uuid primary key default gen_random_uuid(),
  exam_id uuid not null references public.exams(id) on delete cascade,
  student_id uuid not null references public.profiles(id) on delete cascade,
  answers jsonb,
  answer_pdf_url text,
  score smallint check (score between 0 and 100),
  correct_answers smallint check (correct_answers >= 0),
  total_questions smallint check (total_questions >= 0),
  submitted_at timestamptz not null default now(),
  unique (exam_id, student_id),
  constraint exam_attempt_payload check (
    (answers is not null and answer_pdf_url is null)
    or (answers is null and answer_pdf_url is not null)
  )
);

create trigger exams_updated_at
before update on public.exams
for each row execute function public.set_updated_at();

create index exams_counselor_idx on public.exams(counselor_id, created_at desc);
create index exams_status_idx on public.exams(status, created_at desc);
create index exam_questions_exam_idx on public.exam_questions(exam_id, sort_order);
create index exam_attempts_exam_idx on public.exam_attempts(exam_id, submitted_at desc);
create index exam_attempts_student_idx on public.exam_attempts(student_id, submitted_at desc);

alter table public.exams enable row level security;
alter table public.exam_questions enable row level security;
alter table public.exam_attempts enable row level security;

grant select on public.exams, public.exam_questions, public.exam_attempts to authenticated;

create policy "eligible_people_read_exams"
on public.exams
for select
to authenticated
using (
  counselor_id = (select auth.uid())
  or (select private.current_user_role()) = 'admin'
  or (
    status = 'published'
    and (select private.current_user_role()) = 'student'
    and exists (
      select 1
      from public.counselor_students assignment
      where assignment.student_id = (select auth.uid())
        and (
          exams.audience = 'all_assigned_students'
          or assignment.counselor_id = exams.counselor_id
        )
    )
  )
);

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

create policy "participants_read_exam_attempts"
on public.exam_attempts
for select
to authenticated
using (
  student_id = (select auth.uid())
  or exists (
    select 1 from public.exams exam
    where exam.id = exam_attempts.exam_id
      and exam.counselor_id = (select auth.uid())
  )
  or (select private.current_user_role()) = 'admin'
);

create or replace function public.save_exam(
  target_exam_id uuid,
  target_title text,
  target_description text,
  target_mode public.exam_mode,
  target_audience public.exam_audience,
  target_question_pdf_url text,
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
  then
    raise exception 'Invalid exam metadata';
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
      counselor_id, title, description, mode, audience, question_pdf_url, status
    ) values (
      (select auth.uid()), trim(target_title), nullif(trim(target_description), ''),
      target_mode, target_audience, target_question_pdf_url, target_status
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
      and exists (
        select 1 from public.counselor_students assignment
        where assignment.student_id = (select auth.uid())
          and (
            exam.audience = 'all_assigned_students'
            or assignment.counselor_id = exam.counselor_id
          )
      )
  ) then raise exception 'Exam is not available'; end if;
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
      and exists (
        select 1 from public.counselor_students assignment
        where assignment.student_id = (select auth.uid())
          and (
            exam.audience = 'all_assigned_students'
            or assignment.counselor_id = exam.counselor_id
          )
      )
  ) then raise exception 'Exam is not available'; end if;

  insert into public.exam_attempts (exam_id, student_id, answer_pdf_url)
  values (target_exam_id, (select auth.uid()), target_answer_pdf_url);
end;
$$;

create or replace function public.exam_attempts_for_counselor(target_exam_id uuid)
returns table (
  attempt_id uuid,
  student_id uuid,
  student_name text,
  score smallint,
  correct_answers smallint,
  total_questions smallint,
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
    attempt.score, attempt.correct_answers, attempt.total_questions,
    attempt.answer_pdf_url, attempt.submitted_at
  from public.exam_attempts attempt
  join public.profiles profile on profile.id = attempt.student_id
  where attempt.exam_id = target_exam_id
  order by attempt.submitted_at desc;
end;
$$;

revoke all on function public.save_exam(uuid,text,text,public.exam_mode,public.exam_audience,text,public.content_status,jsonb) from public, anon;
revoke all on function public.submit_multiple_choice_exam(uuid,jsonb) from public, anon;
revoke all on function public.submit_pdf_exam(uuid,text) from public, anon;
revoke all on function public.exam_attempts_for_counselor(uuid) from public, anon;
grant execute on function public.save_exam(uuid,text,text,public.exam_mode,public.exam_audience,text,public.content_status,jsonb) to authenticated;
grant execute on function public.submit_multiple_choice_exam(uuid,jsonb) to authenticated;
grant execute on function public.submit_pdf_exam(uuid,text) to authenticated;
grant execute on function public.exam_attempts_for_counselor(uuid) to authenticated;
