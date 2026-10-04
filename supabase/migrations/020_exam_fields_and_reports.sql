alter table public.exams add column if not exists exam_field text check (exam_field is null or exam_field in ('mathematics','experimental_sciences','humanities','arts','foreign_languages'));

drop function if exists public.save_exam(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb);

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
  booklet_title text; booklet_pdf text; booklet_keys jsonb;
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role
    or not exists (select 1 from public.counselor_profiles cp where cp.user_id = (select auth.uid()) and cp.approval_status = 'approved')
  then raise exception 'Only approved counselors can manage exams'; end if;
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
    insert into public.exam_booklets(exam_id,title,pdf_url,question_count,start_question_number,end_question_number,duration_minutes,sort_order,key_answers)
    values(saved_exam_id,booklet_title,booklet_pdf,current_q_count::smallint,current_start_q::smallint,(current_start_q+current_q_count-1)::smallint,current_duration::smallint,booklet_idx::smallint,booklet_keys);
    current_start_q := current_start_q + current_q_count; booklet_idx := booklet_idx + 1;
  end loop;
  return saved_exam_id;
end; $$;

revoke all on function public.save_exam(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text) from public, anon;
grant execute on function public.save_exam(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text) to authenticated;
