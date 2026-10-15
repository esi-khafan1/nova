-- Staged rollout: keep the main site's counselor builder working until UI cutover.
-- Preview has its own designer-only entry point and canonical template enforcement.


create or replace function private.save_designer_exam_with_window(
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
revoke all on function private.save_designer_exam_with_window(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text,timestamptz) from public,anon,authenticated;
revoke all on function private.save_designer_exam_with_window(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text,timestamptz) from authenticated;





create or replace function public.save_designer_exam(
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
 saved:=private.save_designer_exam_with_window(target_exam_id,target_title,target_description,'own_students',target_starts_at,target_status,target_booklets,target_exam_field,target_start_window_ends_at);
 update public.exams set explicit_students=true,template_version=case when target_exam_field is null then null else 'national-1404-v1' end where id=saved;
 delete from public.exam_students where exam_id=saved;
 insert into public.exam_students(exam_id,student_id) select saved,id from (select distinct unnest(target_student_ids) id) selected;
 return saved;
end $$;
revoke all on function public.save_designer_exam(uuid,text,text,uuid[],timestamptz,public.content_status,jsonb,text,timestamptz) from public,anon;
grant execute on function public.save_designer_exam(uuid,text,text,uuid[],timestamptz,public.content_status,jsonb,text,timestamptz) to authenticated;


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
   and not ((select private.current_user_role())='counselor' and exists(select 1 from public.counselor_profiles where user_id=(select auth.uid()) and approval_status='approved'))
  then raise exception 'Only exam designers or approved legacy counselors can manage exams' using errcode='42501'; end if;
  if target_exam_field is not null and (select private.current_user_role())='exam_designer' then
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
      case when target_exam_field is not null and (select private.current_user_role())='exam_designer' then private.konkur_template(target_exam_field)->booklet_idx->'subjects'
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

  if exam_record.start_window_ends_at is null and
    (clock_timestamp()<exam_record.starts_at or clock_timestamp()>exam_record.starts_at+exam_record.duration_minutes*interval '1 minute'+interval '30 seconds')
  then raise exception 'Exam submission window is closed' using errcode='42501';end if;

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


