-- Preserve two-decimal and negative national-exam scores. Existing scores are not rewritten.
alter table public.exam_attempts drop constraint if exists exam_attempts_score_check;
alter table public.exam_attempts alter column score type numeric(6,2);
alter table public.exam_attempts add constraint exam_attempts_score_check check(score between -33.34 and 100);
drop function public.submit_booklet_exam(uuid,jsonb);
drop function public.submit_floating_booklet_exam(uuid,integer,jsonb,boolean);
drop function private.grade_booklet_exam(uuid,jsonb);
drop function public.exam_attempts_for_counselor(uuid);
-- Explicit student enrollment and immutable, subject-aware national exam templates.
alter table public.exams add column explicit_students boolean not null default false;
alter table public.exams add column template_version text;
alter table public.exam_booklets add column subject_ranges jsonb not null default '[]'::jsonb check(jsonb_typeof(subject_ranges)='array');
grant select(subject_ranges) on public.exam_booklets to authenticated;
create table public.exam_students (
 exam_id uuid not null references public.exams(id) on delete cascade,
 student_id uuid not null references public.profiles(id) on delete cascade,
 primary key(exam_id,student_id)
);
create index exam_students_student_idx on public.exam_students(student_id,exam_id);
alter table public.exam_students enable row level security;
revoke all on public.exam_students from public,anon,authenticated;
-- Enrollment is managed atomically only by the designer RPC. Directory RPCs expose minimal fields.
create or replace function private.student_can_access_exam(target_exam_id uuid,target_student_id uuid)
returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.exams e join public.profiles p on p.id=target_student_id
 where e.id=target_exam_id and e.status='published' and p.role='student' and p.registration_status='active'
 and (case when e.explicit_students then exists(select 1 from public.exam_students s where s.exam_id=e.id and s.student_id=p.id)
 else exists(select 1 from public.counselor_students a where a.student_id=p.id and (e.audience='all_assigned_students' or a.counselor_id=e.counselor_id)) end));
$$;
revoke all on function private.student_can_access_exam(uuid,uuid) from public,anon;
grant execute on function private.student_can_access_exam(uuid,uuid) to authenticated;
create or replace function private.counselor_can_review_exam(target_exam_id uuid)
returns boolean language sql stable security definer set search_path='' as $$
 select (select private.current_user_role())='counselor' and exists(select 1 from public.exams e where e.id=target_exam_id and
 (e.counselor_id=(select auth.uid()) or (e.status='published' and exists(select 1 from public.counselor_students cs where cs.counselor_id=(select auth.uid()) and
 (exists(select 1 from public.exam_students es where es.exam_id=e.id and es.student_id=cs.student_id)
 or exists(select 1 from public.exam_attempts a where a.exam_id=e.id and a.student_id=cs.student_id))))));
$$;
revoke all on function private.counselor_can_review_exam(uuid) from public,anon;
grant execute on function private.counselor_can_review_exam(uuid) to authenticated;
alter policy eligible_people_read_exams on public.exams using (
 (counselor_id=(select auth.uid()) and (select private.current_user_role()) in ('exam_designer','counselor'))
 or (select private.current_user_role())='admin' or private.counselor_can_review_exam(id)
 or (private.student_can_access_exam(id,(select auth.uid()))));
alter policy eligible_people_read_exam_booklets on public.exam_booklets using (
 exists(select 1 from public.exams e where e.id=exam_booklets.exam_id and (
 (e.counselor_id=(select auth.uid()) and (select private.current_user_role())='exam_designer')
 or (select private.current_user_role())='admin' or private.counselor_can_review_exam(e.id)
 or (private.student_can_access_exam(e.id,(select auth.uid())) and (e.start_window_ends_at is null or exists(select 1 from public.exam_sessions s where s.exam_id=e.id and s.student_id=(select auth.uid())))))));
alter policy participants_read_exam_attempts on public.exam_attempts using (
 (student_id=(select auth.uid()) and (select private.current_user_role())='student') or (select private.current_user_role())='admin'
 or ((select private.current_user_role())='counselor' and exists(select 1 from public.counselor_students a where a.student_id=exam_attempts.student_id and a.counselor_id=(select auth.uid()))));
create or replace function private.konkur_template(field text)
returns jsonb language sql immutable set search_path='' as $fn$
 select ($templates${"mathematics": [{"title": "ریاضی", "questionCount": 40, "durationMinutes": 70, "subjects": [{"id": "math", "title": "ریاضی", "start": 1, "end": 40}]}, {"title": "فیزیک و شیمی", "questionCount": 65, "durationMinutes": 75, "subjects": [{"id": "physics", "title": "فیزیک", "start": 41, "end": 75}, {"id": "chemistry", "title": "شیمی", "start": 76, "end": 105}]}], "experimental_sciences": [{"title": "زیست‌شناسی", "questionCount": 45, "durationMinutes": 45, "subjects": [{"id": "biology", "title": "زیست‌شناسی", "start": 1, "end": 45}]}, {"title": "فیزیک و شیمی", "questionCount": 65, "durationMinutes": 75, "subjects": [{"id": "physics", "title": "فیزیک", "start": 46, "end": 75}, {"id": "chemistry", "title": "شیمی", "start": 76, "end": 110}]}, {"title": "ریاضی و زمین‌شناسی", "questionCount": 45, "durationMinutes": 60, "subjects": [{"id": "math", "title": "ریاضی", "start": 111, "end": 140}, {"id": "geology", "title": "زمین‌شناسی", "start": 141, "end": 155}]}], "humanities": [{"title": "ریاضی، ادبیات، علوم اجتماعی و روان‌شناسی", "questionCount": 80, "durationMinutes": 85, "subjects": [{"id": "math", "title": "ریاضی", "start": 1, "end": 20}, {"id": "literature", "title": "زبان و ادبیات فارسی", "start": 21, "end": 50}, {"id": "social", "title": "علوم اجتماعی", "start": 51, "end": 65}, {"id": "psychology", "title": "روان‌شناسی", "start": 66, "end": 80}]}, {"title": "عربی، تاریخ، جغرافیا، فلسفه و منطق و اقتصاد", "questionCount": 80, "durationMinutes": 75, "subjects": [{"id": "arabic", "title": "زبان عربی", "start": 81, "end": 100}, {"id": "history", "title": "تاریخ", "start": 101, "end": 113}, {"id": "geography", "title": "جغرافیا", "start": 114, "end": 125}, {"id": "philosophy", "title": "فلسفه و منطق", "start": 126, "end": 145}, {"id": "economics", "title": "اقتصاد", "start": 146, "end": 160}]}], "arts": [{"title": "دروس تخصصی هنر", "questionCount": 100, "durationMinutes": 115, "subjects": [{"id": "art", "title": "درک عمومی هنر", "start": 1, "end": 50}, {"id": "art-math", "title": "درک عمومی ریاضی و فیزیک", "start": 51, "end": 80}, {"id": "visual", "title": "خلاقیت تصویری و تجسمی", "start": 81, "end": 100}]}], "foreign_languages": [{"title": "زبان تخصصی", "questionCount": 70, "durationMinutes": 105, "subjects": [{"id": "language", "title": "زبان تخصصی", "start": 1, "end": 70}]}]}$templates$::jsonb)->field;
$fn$;
revoke all on function private.konkur_template(text) from public,anon,authenticated;


create or replace function public.save_exam(
  target_exam_id uuid,
  target_title text,
  target_description text,
  target_audience public.exam_audience,
  target_starts_at timestamptz,
  target_status public.content_status,
  target_booklets jsonb,
  target_exam_field text default null
) returns uuid language plpgsql security definer set search_path = '' as $$
declare
  saved_exam_id uuid; booklet jsonb; booklet_idx integer := 0;
  total_duration integer := 0; current_start_q integer := 1;
  current_q_count integer; current_duration integer;
  booklet_title text; booklet_pdf text; booklet_keys jsonb; question_idx integer;
begin
  if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role
  then raise exception 'Only exam designers can manage exams' using errcode='42501'; end if;
  if target_exam_field is not null then
    if private.konkur_template(target_exam_field) is null or jsonb_array_length(target_booklets)<>jsonb_array_length(private.konkur_template(target_exam_field)) then raise exception 'Invalid exam template'; end if;
    for booklet_idx in 0..jsonb_array_length(target_booklets)-1 loop
      booklet:=target_booklets->booklet_idx;
      if booklet->>'title' is distinct from (private.konkur_template(target_exam_field)->booklet_idx)->>'title'
       or (booklet->>'questionCount')::integer is distinct from ((private.konkur_template(target_exam_field)->booklet_idx)->>'questionCount')::integer
       or (booklet->>'durationMinutes')::integer is distinct from ((private.konkur_template(target_exam_field)->booklet_idx)->>'durationMinutes')::integer
      then raise exception 'Invalid exam template';end if;
    end loop;
    booklet_idx:=0;
  end if;
  if char_length(trim(target_title)) not between 3 and 160
    or char_length(coalesce(target_description,'')) > 3000
    or target_status not in ('draft','published')
    or target_starts_at is null or target_starts_at <= now() + interval '1 minute'
    or (target_exam_field is not null and target_exam_field not in ('mathematics','experimental_sciences','humanities','arts','foreign_languages'))
  then raise exception 'Invalid exam metadata or schedule'; end if;
  if jsonb_typeof(target_booklets) <> 'array' or jsonb_array_length(target_booklets) < 1 then raise exception 'Exam must have at least one booklet'; end if;
  for booklet in select value from jsonb_array_elements(target_booklets) loop
    current_duration := coalesce((booklet->>'durationMinutes')::integer,0);
    if current_duration not between 1 and 360 then raise exception 'Invalid booklet duration'; end if;
    total_duration := total_duration + current_duration;
  end loop;
  if total_duration > 600 then raise exception 'Total exam duration exceeds maximum limit'; end if;
  if target_exam_id is null then
    insert into public.exams(counselor_id,title,description,mode,audience,starts_at,duration_minutes,status,exam_field)
    values((select auth.uid()),trim(target_title),nullif(trim(target_description),''),'booklet'::public.exam_mode,target_audience,target_starts_at,total_duration::smallint,target_status,target_exam_field)
    returning id into saved_exam_id;
  else
    if exists(select 1 from public.exam_attempts where exam_id=target_exam_id) then raise exception 'An exam with submissions cannot be edited'; end if;
    update public.exams set title=trim(target_title),description=nullif(trim(target_description),''),mode='booklet'::public.exam_mode,audience=target_audience,starts_at=target_starts_at,duration_minutes=total_duration::smallint,status=target_status,exam_field=target_exam_field
    where id=target_exam_id and counselor_id=(select auth.uid()) returning id into saved_exam_id;
    if saved_exam_id is null then raise exception 'Exam not found'; end if;
    delete from public.exam_booklets where exam_id=saved_exam_id;
  end if;
  for booklet in select value from jsonb_array_elements(target_booklets) loop
    booklet_title := trim(coalesce(booklet->>'title',''));
    if char_length(booklet_title) not between 1 and 160 then booklet_title := 'دفترچه ' || (booklet_idx+1); end if;
    booklet_pdf := trim(coalesce(booklet->>'pdfUrl',''));
    if target_status='published' and (booklet_pdf='' or booklet_pdf not like 'https://%') then raise exception 'Published booklet requires a valid PDF file'; end if;
    current_q_count := coalesce((booklet->>'questionCount')::integer,0);
    if current_q_count not between 1 and 200 then raise exception 'Invalid question count for booklet'; end if;
    current_duration := coalesce((booklet->>'durationMinutes')::integer,0);
    booklet_keys := coalesce(booklet->'keyAnswers','{}'::jsonb);
    if target_status='published' then
      if jsonb_typeof(booklet_keys) is distinct from 'object' then
        raise exception 'Published exam requires a complete answer key';
      end if;
      for question_idx in current_start_q..(current_start_q+current_q_count-1) loop
        if jsonb_typeof(booklet_keys->question_idx::text) is distinct from 'number'
           or (booklet_keys->>question_idx::text) !~ '^[1-4]$' then
          raise exception 'Published exam requires a valid key for every question';
        end if;
      end loop;
    end if;
    insert into public.exam_booklets(exam_id,title,pdf_url,question_count,start_question_number,end_question_number,duration_minutes,sort_order,key_answers,subject_ranges)
    values(saved_exam_id,booklet_title,booklet_pdf,current_q_count::smallint,current_start_q::smallint,(current_start_q+current_q_count-1)::smallint,current_duration::smallint,booklet_idx::smallint,booklet_keys,
      case when target_exam_field is not null then private.konkur_template(target_exam_field)->booklet_idx->'subjects'
      else jsonb_build_array(jsonb_build_object('id',booklet_title,'title',booklet_title,'start',current_start_q,'end',current_start_q+current_q_count-1)) end);
    current_start_q := current_start_q + current_q_count; booklet_idx := booklet_idx + 1;
  end loop;
  return saved_exam_id;
end; $$;

revoke all on function public.save_exam(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text) from public, anon;
revoke all on function public.save_exam(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text) from authenticated;


create or replace function public.save_booklet_exam_with_window(
 target_exam_id uuid,target_title text,target_description text,target_audience public.exam_audience,
 target_starts_at timestamptz,target_status public.content_status,target_booklets jsonb,
 target_exam_field text default null,target_start_window_ends_at timestamptz default null
) returns uuid language plpgsql security definer set search_path='' as $$
declare saved uuid;
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role
 then raise exception 'Only exam designers can manage exams' using errcode='42501'; end if;
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
revoke all on function public.save_booklet_exam_with_window(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text,timestamptz) from authenticated;



create or replace function private.grade_booklet_exam(
  target_exam_id uuid,
  target_answers jsonb
)
returns table (
  score numeric,
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
  calculated_score numeric := 0;
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
    and private.student_can_access_exam(exam.id,(select auth.uid()));

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

  calculated_score := round((correct_count * 3 - incorrect_count) * 100.0 / (total_q * 3),2);

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
    calculated_score,
    correct_count::smallint,
    incorrect_count::smallint,
    unanswered::smallint,
    total_q::smallint,
    now()
  );

  return query select
    calculated_score,
    correct_count::smallint,
    incorrect_count::smallint,
    unanswered::smallint,
    total_q::smallint;
end;
$$;

revoke all on function private.grade_booklet_exam(uuid,jsonb) from public,anon,authenticated;
-- Preserve the legacy RPC and grading behavior for every existing fixed-schedule exam.


create or replace function private.assert_floating_exam_student(target_exam_id uuid)
returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role
 or not exists(select 1 from public.profiles where id=(select auth.uid()) and registration_status='active')
 or not exists(select 1 from public.exams e where e.id=target_exam_id and e.mode='booklet'
 and e.status='published' and e.start_window_ends_at is not null
 and private.student_can_access_exam(e.id,(select auth.uid())))
 then raise exception 'Floating exam is not available' using errcode='42501'; end if;
end $$;
revoke all on function private.assert_floating_exam_student(uuid) from public,anon,authenticated;



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
   and private.student_can_access_exam(e.id,(select auth.uid()))
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




create function public.save_designer_exam(
 target_exam_id uuid,target_title text,target_description text,target_student_ids uuid[],target_starts_at timestamptz,
 target_status public.content_status,target_booklets jsonb,target_exam_field text default null,target_start_window_ends_at timestamptz default null
) returns uuid language plpgsql security definer set search_path='' as $$
declare saved uuid;
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role then raise exception 'Only exam designers can manage exams' using errcode='42501';end if;
 if target_student_ids is null or cardinality(target_student_ids)>10000 or
 (target_status='published' and cardinality(target_student_ids)=0) or
 exists(select 1 from unnest(target_student_ids) x(id) where not exists(select 1 from public.profiles p where p.id=x.id and p.role='student'))
 then raise exception 'Invalid selected students';end if;
 if target_exam_id is not null then
 perform 1 from public.exams where id=target_exam_id and counselor_id=(select auth.uid()) for update;
 if not found then raise exception 'Exam not found';end if;
 end if;
 saved:=public.save_booklet_exam_with_window(target_exam_id,target_title,target_description,'own_students',target_starts_at,target_status,target_booklets,target_exam_field,target_start_window_ends_at);
 update public.exams set explicit_students=true,template_version=case when target_exam_field is null then null else 'national-1404-v1' end where id=saved;
 delete from public.exam_students where exam_id=saved;
 insert into public.exam_students(exam_id,student_id) select saved,id from (select distinct unnest(target_student_ids) id) selected;
 return saved;
end $$;
revoke all on function public.save_designer_exam(uuid,text,text,uuid[],timestamptz,public.content_status,jsonb,text,timestamptz) from public,anon;
grant execute on function public.save_designer_exam(uuid,text,text,uuid[],timestamptz,public.content_status,jsonb,text,timestamptz) to authenticated;
-- Disable all obsolete save overloads as entry points. The security-definer wrapper calls the canonical one internally.
do $$ declare f record;begin
 for f in select p.oid::regprocedure signature from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public' and p.proname='save_exam' loop
 execute format('revoke all on function %s from public,anon,authenticated',f.signature);
 end loop;
end $$;
create function private.normalize_student_name(value text) returns text language sql immutable set search_path='' as $$
 select regexp_replace(translate(lower(coalesce(value,'')),'يىك‌','ییک '),'[[:space:]]+',' ','g');
$$;
revoke all on function private.normalize_student_name(text) from public,anon,authenticated;
create function public.search_exam_students(search_text text default '',page_offset integer default 0,page_size integer default 51)
returns table(id uuid,full_name text,grade smallint,study_field text) language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role then raise exception 'Only exam designers can search students' using errcode='42501';end if;
 return query select p.id,p.full_name,p.grade,p.study_field::text from public.profiles p where p.role='student'
 and strpos(private.normalize_student_name(p.full_name),trim(private.normalize_student_name(left(coalesce(search_text,''),100))))>0
 order by p.full_name,p.id limit greatest(1,least(coalesce(page_size,51),51)) offset greatest(0,coalesce(page_offset,0));
end $$;
revoke all on function public.search_exam_students(text,integer,integer) from public,anon;
grant execute on function public.search_exam_students(text,integer,integer) to authenticated;
create function public.designer_exam_details(target_exam_id uuid) returns jsonb language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role or not exists(select 1 from public.exams where id=target_exam_id and counselor_id=(select auth.uid())) then raise exception 'Exam not found' using errcode='42501';end if;
 return jsonb_build_object('locked',exists(select 1 from public.exam_sessions where exam_id=target_exam_id) or exists(select 1 from public.exam_attempts where exam_id=target_exam_id) or exists(select 1 from public.exams where id=target_exam_id and starts_at<=now()),
 'booklets',coalesce((select jsonb_agg(to_jsonb(b) order by b.sort_order) from public.exam_booklets b where b.exam_id=target_exam_id),'[]'::jsonb),
 'students',coalesce((select jsonb_agg(jsonb_build_object('id',p.id,'full_name',p.full_name,'grade',p.grade,'study_field',p.study_field) order by p.full_name,p.id) from public.exam_students s join public.profiles p on p.id=s.student_id where s.exam_id=target_exam_id),'[]'::jsonb));
end $$;
revoke all on function public.designer_exam_details(uuid) from public,anon;
grant execute on function public.designer_exam_details(uuid) to authenticated;


create or replace function public.exam_attempts_for_counselor(target_exam_id uuid)
returns table (
  attempt_id uuid,
  student_id uuid,
  student_name text,
  score numeric,
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
  if not (private.counselor_can_review_exam(target_exam_id) or (select private.current_user_role())='admin') then raise exception 'Exam not found' using errcode='42501'; end if;

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


create or replace function public.exam_booklets_for_counselor(target_exam_id uuid)
returns setof public.exam_booklets language plpgsql stable security definer set search_path='' as $$
begin
 if not (private.counselor_can_review_exam(target_exam_id) or (select private.current_user_role())='admin') then raise exception 'Exam is not available' using errcode='42501';end if;
 return query select b.* from public.exam_booklets b where b.exam_id=target_exam_id order by b.sort_order;
end $$;
create function private.student_report_available(target_exam_id uuid,target_student_id uuid)
returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.exams e join public.exam_attempts a on a.exam_id=e.id where e.id=target_exam_id and a.student_id=target_student_id and e.status='published' and e.mode='booklet'
 and now()>=coalesce(e.start_window_ends_at,e.starts_at)+e.duration_minutes*interval '1 minute'+case when e.start_window_ends_at is null then interval '0 seconds' else interval '30 seconds' end
 and private.student_can_access_exam(e.id,target_student_id));
$$;
revoke all on function private.student_report_available(uuid,uuid) from public,anon,authenticated;
create function public.exam_booklets_for_student_report(target_exam_id uuid)
returns setof public.exam_booklets language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role or not private.student_report_available(target_exam_id,(select auth.uid())) then raise exception 'Report is not available' using errcode='42501';end if;
 return query select b.* from public.exam_booklets b where b.exam_id=target_exam_id order by b.sort_order;
end $$;
revoke all on function public.exam_booklets_for_student_report(uuid) from public,anon;
grant execute on function public.exam_booklets_for_student_report(uuid) to authenticated;
create or replace function public.student_exam_subject_history(target_student_id uuid,target_limit integer default 6)
returns table(exam_id uuid,exam_title text,starts_at timestamptz,subject_title text,percentage numeric)
language sql stable security definer set search_path='' as $$
 with recent as (
 select a.exam_id,a.answers,e.title,e.starts_at from public.exam_attempts a join public.exams e on e.id=a.exam_id
 where a.student_id=target_student_id and (
 ((select private.current_user_role())='student' and target_student_id=(select auth.uid()) and private.student_report_available(e.id,target_student_id)) or
 ((select private.current_user_role())='counselor' and exists(select 1 from public.counselor_students cs where cs.counselor_id=(select auth.uid()) and cs.student_id=target_student_id)))
 order by e.starts_at desc limit greatest(1,least(coalesce(target_limit,6),12))
 ), scores as (
 select r.exam_id,r.title,r.starts_at,subject->>'title' as subject_title,min(b.sort_order) as subject_order,
 count(*) as total,
 count(*) filter(where (r.answers->>q.number::text)~'^[1-4]$' and (b.key_answers->>q.number::text)~'^[1-4]$' and (r.answers->>q.number::text)=(b.key_answers->>q.number::text)) as correct,
 count(*) filter(where (r.answers->>q.number::text)~'^[1-4]$' and (b.key_answers->>q.number::text)~'^[1-4]$' and (r.answers->>q.number::text)<>(b.key_answers->>q.number::text)) as incorrect
 from recent r join public.exam_booklets b on b.exam_id=r.exam_id
 cross join lateral jsonb_array_elements(case when jsonb_array_length(b.subject_ranges)>0 then b.subject_ranges else jsonb_build_array(jsonb_build_object('title',b.title,'start',b.start_question_number,'end',b.end_question_number)) end) subject
 cross join lateral generate_series((subject->>'start')::integer,(subject->>'end')::integer) q(number)
 group by r.exam_id,r.title,r.starts_at,subject->>'title'
 ) select s.exam_id,s.title,s.starts_at,s.subject_title,round(((s.correct*3-s.incorrect)*100.0)/nullif(s.total*3,0),2)
 from scores s order by s.starts_at,s.subject_order,s.subject_title;
$$;


create or replace function public.admin_set_user_role(
  target_user_id uuid,
  target_role public.app_role
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  actor_role public.app_role;
  current_target_role public.app_role;
begin
  select role into actor_role
  from public.profiles
  where id = (select auth.uid());

  if actor_role is distinct from 'admin'::public.app_role then
    raise exception 'Only administrators can change user roles';
  end if;

  if target_role not in (
    'student'::public.app_role,
    'counselor'::public.app_role,
    'exam_designer'::public.app_role
  ) then
    raise exception 'Unsupported target role';
  end if;

  select role into current_target_role
  from public.profiles
  where id = target_user_id
  for update;

  if not found then
    raise exception 'User not found';
  end if;

  if current_target_role = 'admin'::public.app_role then
    raise exception 'Administrator roles cannot be changed here';
  end if;

  if target_role = 'counselor'::public.app_role then
    if exists (
      select 1
      from public.counselor_profiles
      where user_id = target_user_id
    ) then
      update public.counselor_profiles
      set approval_status = 'approved'
      where user_id = target_user_id;
    else
      insert into public.counselor_profiles (
        user_id,
        headline,
        approval_status,
        is_accepting
      )
      values (
        target_user_id,
        'مشاور نووا',
        'approved',
        false
      );
    end if;

    update public.profiles
    set role = 'counselor'
    where id = target_user_id;
  else
    delete from public.counselor_profiles
    where user_id = target_user_id;

    update public.profiles
    set role = target_role
    where id = target_user_id;
  end if;
end;
$$;

revoke all on function public.admin_set_user_role(uuid, public.app_role)
from public, anon;

grant execute on function public.admin_set_user_role(uuid, public.app_role)
to authenticated;
create or replace function public.submit_booklet_exam(target_exam_id uuid,target_answers jsonb)
returns table(score numeric,correct_answers smallint,incorrect_answers smallint,unanswered_count smallint,total_questions smallint)
language plpgsql security definer set search_path='' as $$
begin
 if exists(select 1 from public.exams where id=target_exam_id and start_window_ends_at is not null)
 then raise exception 'Use floating exam submission' using errcode='42501'; end if;
 return query select * from private.grade_booklet_exam(target_exam_id,target_answers);
end $$;

create function public.submit_floating_booklet_exam(target_exam_id uuid,expected_booklet_index integer,target_answers jsonb,use_saved_answers boolean default false)
returns table(score numeric,correct_answers smallint,incorrect_answers smallint,unanswered_count smallint,total_questions smallint)
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

revoke all on function public.submit_booklet_exam(uuid,jsonb),public.submit_floating_booklet_exam(uuid,integer,jsonb,boolean),public.exam_attempts_for_counselor(uuid) from public,anon;
grant execute on function public.submit_booklet_exam(uuid,jsonb),public.submit_floating_booklet_exam(uuid,integer,jsonb,boolean),public.exam_attempts_for_counselor(uuid) to authenticated;
