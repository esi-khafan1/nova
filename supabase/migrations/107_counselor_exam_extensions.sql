-- Counselor-managed, per-student exam extensions. An extension gives one
-- student who has not submitted a fresh start window on another day. Starting
-- inside that window creates the same kind of timed session as a floating
-- exam; the student then receives the exam's full duration.
create table public.exam_extensions (
  id uuid primary key default gen_random_uuid(),
  exam_id uuid not null references public.exams(id) on delete cascade,
  student_id uuid not null references public.profiles(id) on delete cascade,
  counselor_id uuid not null references public.profiles(id) on delete restrict,
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  generation integer not null default 1 check (generation > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (exam_id, student_id),
  check (ends_at > starts_at),
  check ((ends_at at time zone 'Asia/Tehran')::date = (starts_at at time zone 'Asia/Tehran')::date)
);
create index exam_extensions_student_idx on public.exam_extensions(student_id, starts_at);
create index exam_extensions_exam_idx on public.exam_extensions(exam_id, starts_at);
alter table public.exam_extensions enable row level security;
grant select on public.exam_extensions to authenticated;
create policy counselor_reads_student_exam_extensions on public.exam_extensions
for select to authenticated using (
  (select private.current_user_role()) = 'counselor'::public.app_role
  and exists (
    select 1 from public.counselor_students cs
    where cs.student_id = exam_extensions.student_id
      and cs.counselor_id = (select auth.uid())
  )
);
create policy student_reads_own_exam_extensions on public.exam_extensions
for select to authenticated using (
  student_id = (select auth.uid())
  and (select private.current_user_role()) = 'student'::public.app_role
);

alter table public.exam_sessions
  add column extension_id uuid references public.exam_extensions(id) on delete set null,
  add column extension_generation integer;

create function private.current_exam_extension(target_exam_id uuid, target_student_id uuid)
returns public.exam_extensions
language sql stable security definer set search_path = '' as $$
  select extension.*
  from public.exam_extensions extension
  where extension.exam_id = target_exam_id
    and extension.student_id = target_student_id;
$$;
revoke all on function private.current_exam_extension(uuid, uuid) from public, anon, authenticated;

create function private.exam_extension_is_missed(target_exam_id uuid, target_student_id uuid)
returns boolean
language plpgsql stable security definer set search_path = '' as $$
declare exam public.exams;
begin
  select * into exam from public.exams where id = target_exam_id;
  if exam.id is null or exists (
    select 1 from public.exam_attempts attempt
    where attempt.exam_id = target_exam_id
      and attempt.student_id = target_student_id
      and attempt.submitted_at is not null
  ) then
    return false;
  end if;
  if exists (
    select 1 from public.exam_sessions session
    where session.exam_id = target_exam_id
      and session.student_id = target_student_id
      and session.expires_at > now()
  ) then
    return false;
  end if;
  if exam.start_window_ends_at is null then
    return now() >= exam.starts_at + exam.duration_minutes * interval '1 minute';
  end if;
  return now() >= exam.start_window_ends_at;
end;
$$;
revoke all on function private.exam_extension_is_missed(uuid, uuid) from public, anon, authenticated;

create function public.counselor_set_exam_extension(
  target_exam_id uuid,
  target_student_id uuid,
  target_starts_at timestamptz,
  target_ends_at timestamptz
) returns uuid language plpgsql security definer set search_path = '' as $$
declare saved_id uuid; existing public.exam_extensions;
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role
     or not exists (
       select 1 from public.counselor_students cs
       where cs.student_id = target_student_id and cs.counselor_id = (select auth.uid())
     )
     or not private.student_services_active(target_student_id)
     or not exists (
       select 1 from public.exams exam
       where exam.id = target_exam_id and exam.status = 'published' and exam.mode = 'booklet'
         and private.student_can_access_exam(exam.id, target_student_id)
     )
     or not private.exam_extension_is_missed(target_exam_id, target_student_id)
  then raise exception 'Exam extension is not available' using errcode = '42501'; end if;

  if target_starts_at is null or target_ends_at is null
     or target_starts_at <= now() + interval '30 seconds'
     or target_ends_at <= target_starts_at
     or (target_ends_at at time zone 'Asia/Tehran')::date
        <> (target_starts_at at time zone 'Asia/Tehran')::date
  then raise exception 'Invalid exam extension window'; end if;

  select * into existing from public.exam_extensions
  where exam_id = target_exam_id and student_id = target_student_id for update;
  if existing.id is not null and exists (
    select 1 from public.exam_sessions session
    where session.exam_id = target_exam_id and session.student_id = target_student_id
      and session.extension_id = existing.id
      and session.extension_generation = existing.generation
      and session.expires_at > now()
  ) then raise exception 'Exam extension is already in use'; end if;

  insert into public.exam_extensions(
    exam_id, student_id, counselor_id, starts_at, ends_at
  ) values (
    target_exam_id, target_student_id, (select auth.uid()), target_starts_at, target_ends_at
  )
  on conflict (exam_id, student_id) do update set
    counselor_id = excluded.counselor_id,
    starts_at = excluded.starts_at,
    ends_at = excluded.ends_at,
    generation = public.exam_extensions.generation + 1,
    updated_at = now()
  returning id into saved_id;
  return saved_id;
end;
$$;
revoke all on function public.counselor_set_exam_extension(uuid, uuid, timestamptz, timestamptz) from public, anon;
grant execute on function public.counselor_set_exam_extension(uuid, uuid, timestamptz, timestamptz) to authenticated;

create function public.counselor_cancel_exam_extension(
  target_exam_id uuid,
  target_student_id uuid
) returns void language plpgsql security definer set search_path = '' as $$
declare existing public.exam_extensions;
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role
     or not exists (
       select 1 from public.counselor_students cs
       where cs.student_id = target_student_id and cs.counselor_id = (select auth.uid())
     )
  then raise exception 'Exam extension is not available' using errcode = '42501'; end if;
  select * into existing from public.exam_extensions
  where exam_id = target_exam_id and student_id = target_student_id for update;
  if existing.id is null then raise exception 'Exam extension not found'; end if;
  if exists (
    select 1 from public.exam_sessions session
    where session.exam_id = target_exam_id and session.student_id = target_student_id
      and session.extension_id = existing.id
      and session.extension_generation = existing.generation
      and session.expires_at > now()
  ) then raise exception 'Exam extension is already in use'; end if;
  delete from public.exam_extensions where id = existing.id;
end;
$$;
revoke all on function public.counselor_cancel_exam_extension(uuid, uuid) from public, anon;
grant execute on function public.counselor_cancel_exam_extension(uuid, uuid) to authenticated;

create function public.student_exam_extensions()
returns table (
  exam_id uuid,
  extension_id uuid,
  starts_at timestamptz,
  ends_at timestamptz,
  generation integer
)
language plpgsql stable security definer set search_path = '' as $$
begin
  if (select private.current_user_role()) is distinct from 'student'::public.app_role
     or not private.student_services_active((select auth.uid()))
  then raise exception 'Student only' using errcode = '42501'; end if;
  return query
  select extension.exam_id, extension.id, extension.starts_at, extension.ends_at, extension.generation
  from public.exam_extensions extension
  join public.exams exam on exam.id = extension.exam_id
  where extension.student_id = (select auth.uid())
    and exam.status = 'published' and exam.mode = 'booklet'
    and private.student_can_access_exam(exam.id, (select auth.uid()))
    and not exists (
      select 1 from public.exam_attempts attempt
      where attempt.exam_id = exam.id and attempt.student_id = (select auth.uid())
        and attempt.submitted_at is not null
    )
  order by extension.starts_at, extension.exam_id;
end;
$$;
revoke all on function public.student_exam_extensions() from public, anon;
grant execute on function public.student_exam_extensions() to authenticated;

-- A current extension makes the session-based flow available even when the
-- original exam used a fixed schedule. The original floating path is unchanged
-- for students without an extension.
create or replace function private.assert_floating_exam_student(target_exam_id uuid)
returns void language plpgsql security definer set search_path = '' as $$
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role
 or not exists(select 1 from public.profiles where id = (select auth.uid()) and registration_status = 'active')
 or not exists(
   select 1 from public.exams exam
   where exam.id = target_exam_id and exam.mode = 'booklet' and exam.status = 'published'
     and private.student_can_access_exam(exam.id, (select auth.uid()))
     and (
       exam.start_window_ends_at is not null
       or (select private.current_exam_extension(exam.id, (select auth.uid()))).id is not null
     )
 )
 then raise exception 'Floating exam is not available' using errcode = '42501'; end if;
end;
$$;
revoke all on function private.assert_floating_exam_student(uuid) from public, anon, authenticated;

drop function public.begin_floating_exam(uuid);
create function public.begin_floating_exam(target_exam_id uuid)
returns table(exam_id uuid,student_id uuid,started_at timestamptz,expires_at timestamptz,current_booklet_index integer,booklet_started_at timestamptz,answers jsonb,updated_at timestamptz,server_now timestamptz)
language plpgsql security definer set search_path = '' as $$
declare
  exam public.exams;
  extension public.exam_extensions;
  prior public.exam_sessions;
  stamp timestamptz;
  tied_to_extension boolean := false;
  tied_to_global boolean := false;
begin
  perform private.assert_floating_exam_student(target_exam_id);
  select * into exam from public.exams where id = target_exam_id for update;
  perform private.assert_floating_exam_student(target_exam_id);
  if exists (
    select 1 from public.exam_attempts attempt
    where attempt.exam_id = target_exam_id and attempt.student_id = (select auth.uid())
  ) then raise exception 'Exam has already been submitted'; end if;

  extension := private.current_exam_extension(target_exam_id, (select auth.uid()));
  select * into prior from public.exam_sessions session
  where session.exam_id = target_exam_id and session.student_id = (select auth.uid()) for update;
  stamp := clock_timestamp();

  if prior.exam_id is not null then
    tied_to_extension := extension.id is not null
      and prior.extension_id = extension.id
      and prior.extension_generation = extension.generation;
    tied_to_global := extension.id is null and prior.extension_id is null;
    if tied_to_extension or tied_to_global then
      if stamp >= prior.expires_at then raise exception 'Exam session has expired'; end if;
      return query
      select session.exam_id, session.student_id, session.started_at, session.expires_at,
        session.current_booklet_index, session.booklet_started_at, session.answers,
        session.updated_at, clock_timestamp()
      from public.exam_sessions session
      where session.exam_id = target_exam_id and session.student_id = (select auth.uid());
      return;
    end if;
    if extension.id is not null and stamp < extension.starts_at then
      raise exception 'Start window has not opened';
    end if;
    if extension.id is not null and stamp >= extension.ends_at then
      raise exception 'Start window is closed';
    end if;
    if extension.id is null then raise exception 'Exam session has expired'; end if;
    -- A counselor-issued replacement window creates a genuinely fresh session;
    -- an unfinished earlier session and its saved answers are not reused.
    delete from public.exam_sessions
    where exam_id = target_exam_id and student_id = (select auth.uid());
  end if;

  if not exists(select 1 from public.exam_booklets booklet where booklet.exam_id = exam.id) then
    raise exception 'Exam has no booklets';
  end if;

  if extension.id is not null and stamp >= extension.starts_at and stamp < extension.ends_at then
    insert into public.exam_sessions(
      exam_id, student_id, started_at, expires_at, booklet_started_at, updated_at,
      extension_id, extension_generation
    ) values (
      exam.id, (select auth.uid()), stamp, stamp + exam.duration_minutes * interval '1 minute',
      stamp, stamp, extension.id, extension.generation
    );
  elsif exam.start_window_ends_at is not null
        and stamp >= exam.starts_at and stamp < exam.start_window_ends_at then
    insert into public.exam_sessions(
      exam_id, student_id, started_at, expires_at, booklet_started_at, updated_at
    ) values (
      exam.id, (select auth.uid()), stamp, stamp + exam.duration_minutes * interval '1 minute', stamp, stamp
    );
  elsif extension.id is not null and stamp < extension.starts_at then
    raise exception 'Start window has not opened';
  elsif exam.start_window_ends_at is not null and stamp < exam.starts_at then
    raise exception 'Start window has not opened';
  else
    raise exception 'Start window is closed';
  end if;

  return query
  select session.exam_id, session.student_id, session.started_at, session.expires_at,
    session.current_booklet_index, session.booklet_started_at, session.answers,
    session.updated_at, clock_timestamp()
  from public.exam_sessions session
  where session.exam_id = target_exam_id and session.student_id = (select auth.uid());
end;
$$;
revoke all on function public.begin_floating_exam(uuid) from public, anon;
grant execute on function public.begin_floating_exam(uuid) to authenticated;

-- Counselor history now also supplies the metadata needed to manage an
-- extension without exposing another counselor's student.
drop function public.counselor_student_exam_history(uuid, integer, integer);
create function public.counselor_student_exam_history(
  target_student_id uuid,
  page_offset integer default 0,
  page_size integer default 6
) returns table(
  exam_id uuid,
  title text,
  starts_at timestamptz,
  duration_minutes integer,
  start_window_ends_at timestamptz,
  attempt_id uuid,
  submitted_at timestamptz,
  score numeric,
  extension_id uuid,
  extension_starts_at timestamptz,
  extension_ends_at timestamptz,
  can_extend boolean
) language plpgsql stable security definer set search_path = '' as $$
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role
     or not exists (
       select 1 from public.counselor_students cs
       where cs.student_id = target_student_id and cs.counselor_id = (select auth.uid())
     )
  then raise exception 'Student not assigned' using errcode = '42501'; end if;
  if page_offset is null or page_offset < 0 or page_offset > 10000
     or page_size is null or page_size < 1 or page_size > 6
  then raise exception 'Invalid page'; end if;

  return query
  select
    exam.id,
    exam.title,
    exam.starts_at,
    exam.duration_minutes::integer,
    exam.start_window_ends_at,
    attempt.id,
    attempt.submitted_at,
    attempt.score,
    extension.id,
    extension.starts_at,
    extension.ends_at,
    private.exam_extension_is_missed(exam.id, target_student_id)
  from public.exams exam
  left join lateral (
    select submitted.id, submitted.submitted_at, submitted.score
    from public.exam_attempts submitted
    where submitted.exam_id = exam.id and submitted.student_id = target_student_id
      and submitted.submitted_at is not null
    order by submitted.submitted_at desc, submitted.id desc
    limit 1
  ) attempt on true
  left join public.exam_extensions extension
    on extension.exam_id = exam.id and extension.student_id = target_student_id
  where exam.status = 'published' and exam.mode = 'booklet' and exam.starts_at <= now()
    and (
      private.student_can_access_exam(exam.id, target_student_id)
      or exists (
        select 1 from public.exam_attempts old_attempt
        where old_attempt.exam_id = exam.id
          and old_attempt.student_id = target_student_id
          and old_attempt.submitted_at is not null
      )
    )
  order by exam.starts_at desc, exam.id desc
  limit page_size offset page_offset;
end;
$$;
revoke all on function public.counselor_student_exam_history(uuid, integer, integer) from public, anon;
grant execute on function public.counselor_student_exam_history(uuid, integer, integer) to authenticated;

notify pgrst, 'reload schema';
