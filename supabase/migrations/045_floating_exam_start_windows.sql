-- Optional floating start windows; all existing exams retain NULL and legacy behavior.
alter table public.exams add column start_window_ends_at timestamptz;
alter table public.exams add constraint exams_floating_window_check check (
 start_window_ends_at is null or (mode='booklet' and start_window_ends_at>starts_at
 and (start_window_ends_at at time zone 'Asia/Tehran')::date=(starts_at at time zone 'Asia/Tehran')::date));
create table public.exam_sessions (
 exam_id uuid not null references public.exams(id) on delete cascade,
 student_id uuid not null references public.profiles(id) on delete cascade,
 started_at timestamptz not null,
 expires_at timestamptz not null,
 current_booklet_index integer not null default 0 check(current_booklet_index>=0),
 booklet_started_at timestamptz not null,
 answers jsonb not null default '{}'::jsonb check(jsonb_typeof(answers)='object'),
 updated_at timestamptz not null default now(),
 primary key(exam_id,student_id),
 check(expires_at>started_at and booklet_started_at>=started_at and booklet_started_at<=expires_at)
);
alter table public.exam_sessions enable row level security;
revoke all on public.exam_sessions from public,anon,authenticated;
grant select on public.exam_sessions to authenticated;
create policy student_reads_own_exam_session on public.exam_sessions for select to authenticated
 using(student_id=(select auth.uid()) and (select private.current_user_role())='student');

create function private.assert_floating_exam_student(target_exam_id uuid)
returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role
 or not exists(select 1 from public.profiles where id=(select auth.uid()) and registration_status='active')
 or not exists(select 1 from public.exams e where e.id=target_exam_id and e.mode='booklet'
 and e.status='published' and e.start_window_ends_at is not null
 and exists(select 1 from public.counselor_students a where a.student_id=(select auth.uid())
 and (e.audience='all_assigned_students' or a.counselor_id=e.counselor_id)))
 then raise exception 'Floating exam is not available' using errcode='42501'; end if;
end $$;
revoke all on function private.assert_floating_exam_student(uuid) from public,anon,authenticated;

create function private.lock_started_floating_exam()
returns trigger language plpgsql security definer set search_path='' as $$
begin
 if exists(select 1 from public.exam_sessions where exam_id=old.id) then
 raise exception 'An exam with started sessions cannot be edited'; end if;
 return new;
end $$;
revoke all on function private.lock_started_floating_exam() from public,anon,authenticated;
create trigger exams_lock_started_floating before update on public.exams
 for each row execute function private.lock_started_floating_exam();

create function public.save_booklet_exam_with_window(
 target_exam_id uuid,target_title text,target_description text,target_audience public.exam_audience,
 target_starts_at timestamptz,target_status public.content_status,target_booklets jsonb,
 target_exam_field text default null,target_start_window_ends_at timestamptz default null
) returns uuid language plpgsql security definer set search_path='' as $$
declare saved uuid;
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role
 or not exists(select 1 from public.counselor_profiles where user_id=(select auth.uid()) and approval_status='approved')
 then raise exception 'Only approved counselors can manage exams' using errcode='42501'; end if;
 if target_start_window_ends_at is not null and
 (target_starts_at is null or target_start_window_ends_at<=target_starts_at
 or (target_start_window_ends_at at time zone 'Asia/Tehran')::date<>(target_starts_at at time zone 'Asia/Tehran')::date)
 then raise exception 'Invalid floating start window'; end if;
 if target_exam_id is not null then
 if exists(select 1 from public.exam_sessions where exam_id=target_exam_id) then
 raise exception 'An exam with started sessions cannot be edited'; end if;
 -- Clear a previous window before changing dates; any subsequent error rolls this back.
 update public.exams set start_window_ends_at=null where id=target_exam_id and counselor_id=(select auth.uid());
 end if;
 saved:=public.save_exam(target_exam_id,target_title,target_description,target_audience,
 target_starts_at,target_status,target_booklets,target_exam_field);
 update public.exams set start_window_ends_at=target_start_window_ends_at where id=saved;
 return saved;
end $$;
revoke all on function public.save_booklet_exam_with_window(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text,timestamptz) from public,anon;
grant execute on function public.save_booklet_exam_with_window(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text,timestamptz) to authenticated;

create function public.get_floating_exam_session(target_exam_id uuid)
returns table(exam_id uuid,student_id uuid,started_at timestamptz,expires_at timestamptz,current_booklet_index integer,booklet_started_at timestamptz,answers jsonb,updated_at timestamptz,server_now timestamptz) language plpgsql security definer set search_path='' as $$
begin
 perform private.assert_floating_exam_student(target_exam_id);
 return query select s.exam_id,s.student_id,s.started_at,s.expires_at,s.current_booklet_index,s.booklet_started_at,s.answers,s.updated_at,clock_timestamp() from public.exam_sessions s where s.exam_id=target_exam_id and s.student_id=(select auth.uid());
end $$;
create function public.begin_floating_exam(target_exam_id uuid)
returns table(exam_id uuid,student_id uuid,started_at timestamptz,expires_at timestamptz,current_booklet_index integer,booklet_started_at timestamptz,answers jsonb,updated_at timestamptz,server_now timestamptz) language plpgsql security definer set search_path='' as $$
declare e public.exams; prior public.exam_sessions; stamp timestamptz;
begin
 perform private.assert_floating_exam_student(target_exam_id);
 select * into e from public.exams where id=target_exam_id for update;
 perform private.assert_floating_exam_student(target_exam_id);
 if exists(select 1 from public.exam_attempts a where a.exam_id=target_exam_id and a.student_id=(select auth.uid()))
 then raise exception 'Exam has already been submitted'; end if;
 select * into prior from public.exam_sessions s where s.exam_id=target_exam_id and s.student_id=(select auth.uid()) for update;
 stamp:=clock_timestamp();
 if prior.exam_id is not null then
 if stamp>=prior.expires_at then raise exception 'Exam session has expired'; end if;
 -- Resuming after the window closes is allowed; no timestamp or duration is reset.
 else
 if stamp<e.starts_at then raise exception 'Start window has not opened'; end if;
 if stamp>=e.start_window_ends_at then raise exception 'Start window is closed'; end if;
 if not exists(select 1 from public.exam_booklets b where b.exam_id=e.id) then raise exception 'Exam has no booklets'; end if;
 insert into public.exam_sessions(exam_id,student_id,started_at,expires_at,booklet_started_at,updated_at)
 values(e.id,(select auth.uid()),stamp,stamp+e.duration_minutes*interval '1 minute',stamp,stamp);
 end if;
 return query select s.exam_id,s.student_id,s.started_at,s.expires_at,s.current_booklet_index,s.booklet_started_at,s.answers,s.updated_at,clock_timestamp() from public.exam_sessions s where s.exam_id=target_exam_id and s.student_id=(select auth.uid());
end $$;

create function public.update_floating_exam_progress(target_exam_id uuid,expected_booklet_index integer,target_answers jsonb,advance_booklet boolean default false)
returns table(exam_id uuid,student_id uuid,started_at timestamptz,expires_at timestamptz,current_booklet_index integer,booklet_started_at timestamptz,answers jsonb,updated_at timestamptz,server_now timestamptz) language plpgsql security definer set search_path='' as $$
declare session public.exam_sessions; booklet public.exam_booklets; stamp timestamptz; deadline timestamptz;
 merged jsonb; q integer; choice text; count_booklets integer;
begin
 perform private.assert_floating_exam_student(target_exam_id);
 if jsonb_typeof(target_answers) is distinct from 'object' then raise exception 'Invalid answers format'; end if;
 select * into session from public.exam_sessions s where s.exam_id=target_exam_id and s.student_id=(select auth.uid()) for update;
 stamp:=clock_timestamp();
 if session.exam_id is null or stamp>=session.expires_at then raise exception 'Exam session has expired'; end if;
 if exists(select 1 from public.exam_attempts a where a.exam_id=target_exam_id and a.student_id=(select auth.uid())) then raise exception 'Exam has already been submitted'; end if;
 if expected_booklet_index is distinct from session.current_booklet_index then raise exception 'Booklet state changed'; end if;
 select * into booklet from public.exam_booklets b where b.exam_id=target_exam_id order by b.sort_order offset session.current_booklet_index limit 1;
 if booklet.id is null then raise exception 'Invalid booklet index'; end if;
 deadline:=least(session.expires_at,session.booklet_started_at+booklet.duration_minutes*interval '1 minute');
 merged:=session.answers;
 if stamp<deadline then
 for q in booklet.start_question_number..booklet.end_question_number loop
 merged:=merged-q::text; choice:=target_answers->>q::text;
 if jsonb_typeof(target_answers->q::text)='number' and choice ~ '^[1-4]$' then merged:=merged||jsonb_build_object(q::text,choice::integer); end if;
 end loop;
 elsif not advance_booklet then raise exception 'Booklet time has expired';
 end if;
 if advance_booklet then
 select count(*) into count_booklets from public.exam_booklets b where b.exam_id=target_exam_id;
 if session.current_booklet_index+1>=count_booklets then raise exception 'Use final submission for the last booklet'; end if;
 update public.exam_sessions s set answers=merged,current_booklet_index=s.current_booklet_index+1,
 booklet_started_at=least(stamp,deadline),updated_at=stamp
 where s.exam_id=target_exam_id and s.student_id=(select auth.uid());
 else
 update public.exam_sessions s set answers=merged,updated_at=stamp where s.exam_id=target_exam_id and s.student_id=(select auth.uid());
 end if;
 return query select s.exam_id,s.student_id,s.started_at,s.expires_at,s.current_booklet_index,s.booklet_started_at,s.answers,s.updated_at,clock_timestamp() from public.exam_sessions s where s.exam_id=target_exam_id and s.student_id=(select auth.uid());
end $$;
create or replace function private.grade_booklet_exam(
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

revoke all on function private.grade_booklet_exam(uuid,jsonb) from public,anon,authenticated;
-- Preserve the legacy RPC and grading behavior for every existing fixed-schedule exam.
create or replace function public.submit_booklet_exam(target_exam_id uuid,target_answers jsonb)
returns table(score smallint,correct_answers smallint,incorrect_answers smallint,unanswered_count smallint,total_questions smallint)
language plpgsql security definer set search_path='' as $$
begin
 if exists(select 1 from public.exams where id=target_exam_id and start_window_ends_at is not null)
 then raise exception 'Use floating exam submission' using errcode='42501'; end if;
 return query select * from private.grade_booklet_exam(target_exam_id,target_answers);
end $$;

create function public.submit_floating_booklet_exam(target_exam_id uuid,expected_booklet_index integer,target_answers jsonb,use_saved_answers boolean default false)
returns table(score smallint,correct_answers smallint,incorrect_answers smallint,unanswered_count smallint,total_questions smallint)
language plpgsql security definer set search_path='' as $$
declare session public.exam_sessions; booklet public.exam_booklets; stamp timestamptz; deadline timestamptz;
 merged jsonb; q integer; choice text; count_booklets integer;
begin
 perform private.assert_floating_exam_student(target_exam_id);
 if jsonb_typeof(target_answers) is distinct from 'object' then raise exception 'Invalid answers format'; end if;
 select * into session from public.exam_sessions s where s.exam_id=target_exam_id and s.student_id=(select auth.uid()) for update;
 if session.exam_id is null then raise exception 'Exam has not been started'; end if;
 stamp:=clock_timestamp();
 select * into booklet from public.exam_booklets b where b.exam_id=target_exam_id order by b.sort_order offset session.current_booklet_index limit 1;
 select count(*) into count_booklets from public.exam_booklets b where b.exam_id=target_exam_id;
 if booklet.id is null or count_booklets=0 then raise exception 'Invalid booklet index'; end if;
 deadline:=least(session.expires_at,session.booklet_started_at+booklet.duration_minutes*interval '1 minute');
 if not use_saved_answers and expected_booklet_index is distinct from session.current_booklet_index then raise exception 'Booklet state changed'; end if;
 if stamp<session.expires_at and session.current_booklet_index<>count_booklets-1
 then raise exception 'Complete the current booklet first'; end if;
 if use_saved_answers and stamp<least(session.expires_at,case when session.current_booklet_index=count_booklets-1 then deadline else session.expires_at end)
 then raise exception 'Saved-only submission is available after the time expires'; end if;
 merged:=session.answers;
 -- A bounded 30-second network grace accepts the final already-entered payload;
 -- after that, only the checkpointed server answers can be finalized.
 if not use_saved_answers and stamp<=deadline+interval '30 seconds' then
 for q in booklet.start_question_number..booklet.end_question_number loop
 merged:=merged-q::text; choice:=target_answers->>q::text;
 if jsonb_typeof(target_answers->q::text)='number' and choice ~ '^[1-4]$' then merged:=merged||jsonb_build_object(q::text,choice::integer); end if;
 end loop;
 end if;
 update public.exam_sessions s set answers=merged,updated_at=stamp where s.exam_id=target_exam_id and s.student_id=(select auth.uid());
 return query select * from private.grade_booklet_exam(target_exam_id,merged);
end $$;
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
   and now() >= coalesce(e.start_window_ends_at,e.starts_at) + e.duration_minutes * interval '1 minute' + case when e.start_window_ends_at is not null then interval '30 seconds' else interval '0 seconds' end
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


alter policy eligible_people_read_exam_booklets on public.exam_booklets using (
 exists(select 1 from public.exams e where e.id=exam_booklets.exam_id and (
 e.counselor_id=(select auth.uid()) or (select private.current_user_role())='admin' or (
 e.status='published' and (select private.current_user_role())='student'
 and exists(select 1 from public.counselor_students a where a.student_id=(select auth.uid()) and (e.audience='all_assigned_students' or a.counselor_id=e.counselor_id))
 and (e.start_window_ends_at is null or exists(select 1 from public.exam_sessions s where s.exam_id=e.id and s.student_id=(select auth.uid())))
 ))));
revoke all on function public.get_floating_exam_session(uuid) from public,anon;
grant execute on function public.get_floating_exam_session(uuid) to authenticated;
revoke all on function public.begin_floating_exam(uuid) from public,anon;
grant execute on function public.begin_floating_exam(uuid) to authenticated;
revoke all on function public.update_floating_exam_progress(uuid,integer,jsonb,boolean) from public,anon;
grant execute on function public.update_floating_exam_progress(uuid,integer,jsonb,boolean) to authenticated;
revoke all on function public.submit_floating_booklet_exam(uuid,integer,jsonb,boolean) from public,anon;
grant execute on function public.submit_floating_booklet_exam(uuid,integer,jsonb,boolean) to authenticated;
