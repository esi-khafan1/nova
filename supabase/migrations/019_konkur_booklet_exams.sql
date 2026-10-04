alter table public.exams drop constraint if exists exam_pdf_matches_mode;
alter table public.exams alter column mode set default 'booklet'::public.exam_mode;

create table if not exists public.exam_booklets (
  id uuid primary key default gen_random_uuid(),
  exam_id uuid not null references public.exams(id) on delete cascade,
  title text not null check (char_length(trim(title)) between 1 and 160),
  pdf_url text not null,
  question_count smallint not null check (question_count between 1 and 200),
  start_question_number smallint not null check (start_question_number >= 1),
  end_question_number smallint not null check (end_question_number >= start_question_number),
  duration_minutes smallint not null check (duration_minutes between 1 and 360),
  sort_order smallint not null default 0 check (sort_order >= 0),
  key_answers jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists exam_booklets_exam_idx
  on public.exam_booklets(exam_id, sort_order);

alter table public.exam_booklets enable row level security;
grant select on public.exam_booklets to authenticated;

drop policy if exists "eligible_people_read_exam_booklets" on public.exam_booklets;
create policy "eligible_people_read_exam_booklets"
on public.exam_booklets
for select
to authenticated
using (
  exists (
    select 1
    from public.exams exam
    where exam.id = exam_booklets.exam_id
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

alter table public.exam_attempts
  add column if not exists incorrect_answers smallint default 0,
  add column if not exists unanswered_count smallint default 0;

alter table public.exam_attempts drop constraint if exists exam_attempt_payload;

drop function if exists public.save_exam(uuid,text,text,public.exam_mode,public.exam_audience,text,timestamptz,smallint,public.content_status,jsonb);
drop function if exists public.save_exam(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb);
drop function if exists public.exam_attempts_for_counselor(uuid);

create or replace function public.save_exam(
  target_exam_id uuid,
  target_title text,
  target_description text,
  target_audience public.exam_audience,
  target_starts_at timestamptz,
  target_status public.content_status,
  target_booklets jsonb
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  saved_exam_id uuid;
  booklet jsonb;
  booklet_idx integer := 0;
  total_duration integer := 0;
  current_start_q integer := 1;
  current_q_count integer;
  current_duration integer;
  booklet_title text;
  booklet_pdf text;
  booklet_keys jsonb;
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
  then
    raise exception 'Invalid exam metadata or schedule';
  end if;

  if jsonb_typeof(target_booklets) <> 'array' or jsonb_array_length(target_booklets) < 1 then
    raise exception 'Exam must have at least one booklet';
  end if;

  for booklet in select value from jsonb_array_elements(target_booklets)
  loop
    current_duration := coalesce((booklet->>'durationMinutes')::integer, 0);
    if current_duration not between 1 and 360 then
      raise exception 'Invalid booklet duration';
    end if;
    total_duration := total_duration + current_duration;
  end loop;

  if total_duration > 600 then
    raise exception 'Total exam duration exceeds maximum limit';
  end if;

  if target_exam_id is null then
    insert into public.exams (
      counselor_id, title, description, mode, audience,
      starts_at, duration_minutes, status
    ) values (
      (select auth.uid()), trim(target_title), nullif(trim(target_description), ''),
      'booklet'::public.exam_mode, target_audience,
      target_starts_at, total_duration::smallint, target_status
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
        mode = 'booklet'::public.exam_mode,
        audience = target_audience,
        starts_at = target_starts_at,
        duration_minutes = total_duration::smallint,
        status = target_status
    where id = target_exam_id and counselor_id = (select auth.uid())
    returning id into saved_exam_id;
    if saved_exam_id is null then raise exception 'Exam not found'; end if;
    delete from public.exam_booklets where exam_id = saved_exam_id;
  end if;

  for booklet in select value from jsonb_array_elements(target_booklets)
  loop
    booklet_title := trim(coalesce(booklet->>'title', ''));
    if char_length(booklet_title) not between 1 and 160 then
      booklet_title := 'دفترچه ' || (booklet_idx + 1);
    end if;

    booklet_pdf := trim(coalesce(booklet->>'pdfUrl', ''));
    if target_status = 'published' and (booklet_pdf = '' or booklet_pdf not like 'https://%') then
      raise exception 'Published booklet requires a valid PDF file';
    end if;

    current_q_count := coalesce((booklet->>'questionCount')::integer, 0);
    if current_q_count not between 1 and 200 then
      raise exception 'Invalid question count for booklet';
    end if;

    current_duration := coalesce((booklet->>'durationMinutes')::integer, 0);
    booklet_keys := coalesce(booklet->'keyAnswers', '{}'::jsonb);

    insert into public.exam_booklets (
      exam_id,
      title,
      pdf_url,
      question_count,
      start_question_number,
      end_question_number,
      duration_minutes,
      sort_order,
      key_answers
    ) values (
      saved_exam_id,
      booklet_title,
      booklet_pdf,
      current_q_count::smallint,
      current_start_q::smallint,
      (current_start_q + current_q_count - 1)::smallint,
      current_duration::smallint,
      booklet_idx::smallint,
      booklet_keys
    );

    current_start_q := current_start_q + current_q_count;
    booklet_idx := booklet_idx + 1;
  end loop;

  return saved_exam_id;
end;
$$;

create or replace function public.submit_booklet_exam(
  target_exam_id uuid,
  target_answers jsonb
)
returns table (
  score smallint,
  correct_answers smallint,
  incorrect_answers smallint,
  unanswered_count smallint,
  total_questions smallint
)
language plpgsql
security definer
set search_path = ''
as $$
declare
  exam_record record;
  booklet_record record;
  total_q integer := 0;
  correct_count integer := 0;
  incorrect_count integer := 0;
  unanswered integer := 0;
  calculated_score integer := 0;
  q_idx integer;
  student_choice integer;
  correct_choice integer;
begin
  if (select private.current_user_role()) is distinct from 'student'::public.app_role then
    raise exception 'Only students can submit exams';
  end if;

  select * into exam_record
  from public.exams exam
  where exam.id = target_exam_id
    and exam.status = 'published'
    and exists (
      select 1 from public.counselor_students assignment
      where assignment.student_id = (select auth.uid())
        and (
          exam.audience = 'all_assigned_students'
          or assignment.counselor_id = exam.counselor_id
        )
    );

  if exam_record.id is null then
    raise exception 'Exam is not available';
  end if;

  if exists (
    select 1 from public.exam_attempts
    where exam_id = target_exam_id and student_id = (select auth.uid())
  ) then
    raise exception 'You have already submitted this exam';
  end if;

  if jsonb_typeof(target_answers) <> 'object' then
    raise exception 'Invalid answers format';
  end if;

  for booklet_record in
    select * from public.exam_booklets
    where exam_id = target_exam_id
    order by sort_order asc
  loop
    for q_idx in booklet_record.start_question_number .. booklet_record.end_question_number
    loop
      total_q := total_q + 1;
      
      if (target_answers ? q_idx::text) and (target_answers->>q_idx::text) ~ '^[1-4]$' then
        student_choice := (target_answers->>q_idx::text)::integer;
      else
        student_choice := null;
      end if;

      if (booklet_record.key_answers ? q_idx::text) and (booklet_record.key_answers->>q_idx::text) ~ '^[1-4]$' then
        correct_choice := (booklet_record.key_answers->>q_idx::text)::integer;
      else
        correct_choice := null;
      end if;

      if student_choice is null then
        unanswered := unanswered + 1;
      elsif correct_choice is not null and student_choice = correct_choice then
        correct_count := correct_count + 1;
      elsif correct_choice is not null and student_choice <> correct_choice then
        incorrect_count := incorrect_count + 1;
      else
        unanswered := unanswered + 1;
      end if;
    end loop;
  end loop;

  if total_q = 0 then
    raise exception 'Exam has no questions';
  end if;

  calculated_score := round(greatest(0, (correct_count * 3 - incorrect_count)) * 100.0 / (total_q * 3))::smallint;

  insert into public.exam_attempts (
    exam_id,
    student_id,
    answers,
    score,
    correct_answers,
    incorrect_answers,
    unanswered_count,
    total_questions,
    submitted_at
  ) values (
    target_exam_id,
    (select auth.uid()),
    target_answers,
    calculated_score::smallint,
    correct_count::smallint,
    incorrect_count::smallint,
    unanswered::smallint,
    total_q::smallint,
    now()
  );

  return query select
    calculated_score::smallint,
    correct_count::smallint,
    incorrect_count::smallint,
    unanswered::smallint,
    total_q::smallint;
end;
$$;

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
  order by attempt.submitted_at desc;
end;
$$;

revoke all on function public.save_exam(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb) from public, anon;
grant execute on function public.save_exam(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb) to authenticated;

revoke all on function public.submit_booklet_exam(uuid,jsonb) from public, anon;
grant execute on function public.submit_booklet_exam(uuid,jsonb) to authenticated;

revoke all on function public.exam_attempts_for_counselor(uuid) from public, anon;
grant execute on function public.exam_attempts_for_counselor(uuid) to authenticated;
