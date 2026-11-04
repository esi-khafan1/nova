-- Ninth grade has no high-school field. Paid enrollment still supports only its
-- priced grades (10-12); account details and counselor planning support nine.
-- Existing grades, registration receipts, and historical plan rows are untouched.
alter table public.profiles drop constraint profiles_grade_check;
alter table public.profiles add constraint profiles_grade_check check (grade between 9 and 12);

alter table public.student_account_details drop constraint student_account_details_grade_check;
alter table public.student_account_details add constraint student_account_details_grade_check check (grade in (9,10,11,12));
alter table public.student_account_details alter column study_field drop not null;
alter table public.student_account_details add constraint student_account_details_grade_field_check
 check ((grade=9 and study_field is null) or (grade in (10,11,12) and study_field is not null));

alter table public.school_subjects drop constraint school_subjects_grade_check;
alter table public.school_subjects add constraint school_subjects_grade_check check (grade in (9,10,11,12));
-- The existing composite key requires a field, so repeat *identical* ninth-grade
-- school titles for the three school-catalog fields. Ninth-grade lookups ignore
-- this technical key; no ninth-grade student is assigned a study field.
insert into public.school_subjects(study_field,grade,subject)
select f.field::public.study_field,9,s.subject
from (values ('mathematics'),('experimental_sciences'),('humanities')) f(field)
cross join (values
 ('ریاضی'),
 ('علوم تجربی'),
 ('فارسی'),
 ('نگارش'),
 ('مطالعات اجتماعی'),
 ('عربی'),
 ('زبان انگلیسی'),
 ('کتاب کار زبان انگلیسی'),
 ('آموزش قرآن'),
 ('پیام‌های آسمان'),
 ('کار و فناوری'),
 ('فرهنگ و هنر'),
 ('تفکر و سبک زندگی'),
 ('آمادگی دفاعی')
) s(subject) on conflict do nothing;

alter table public.weekly_plan_items drop constraint weekly_plan_items_source_grade_check;
alter table public.weekly_plan_items add constraint weekly_plan_items_source_grade_check check(source_grade in (9,10,11,12));
alter table public.weekly_plan_items drop constraint school_metadata_check;
alter table public.weekly_plan_items add constraint school_metadata_check check (
 (preparation_track='konkur' and exam_year is null) or
 (preparation_track='final_exam' and source_grade is not null and source_grade in (9,10,11,12) and (exam_year is null or (source_grade in (10,11,12) and exam_year=1406)))
);

-- This is a distinct activity from exam_analysis; neither is an exam-design box.
alter type public.study_activity_type add value if not exists 'exam_troubleshooting';

create or replace function public.save_student_account_details(payload jsonb) returns void
language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid()); name_value text;
begin
 if not exists(select 1 from public.profiles p join auth.users u on u.id=p.id
               where p.id=me and p.role='student' and (u.email_confirmed_at is not null or u.phone_confirmed_at is not null))
 then raise exception 'Confirmed student required'; end if;
 perform 1 from public.profiles where id=me for update;
 name_value:=nullif(regexp_replace(btrim(coalesce(payload->>'full_name','')),'\s+',' ','g'),'');
 if name_value is null or char_length(name_value) not between 3 and 121 or position(' ' in name_value)=0
 then raise exception 'Complete full name required'; end if;
 if nullif(payload->>'grade','') is null or nullif(payload->>'grade','')::smallint not in (9,10,11,12)
    or (nullif(payload->>'grade','')::smallint=9 and nullif(payload->>'study_field','') is not null)
    or (nullif(payload->>'grade','')::smallint<>9 and nullif(payload->>'study_field','') is null)
 then raise exception 'Valid grade and study field required'; end if;
 insert into public.student_account_details(student_id,full_name,phone,telegram_id,grade,study_field,province,city,additional_notes)
 values(me,name_value,nullif(payload->>'phone',''),nullif(payload->>'telegram_id',''),
        nullif(payload->>'grade','')::smallint,nullif(payload->>'study_field','')::public.study_field,
        btrim(payload->>'province'),btrim(payload->>'city'),coalesce(payload->>'additional_notes',''))
 on conflict(student_id) do update set full_name=excluded.full_name,phone=excluded.phone,telegram_id=excluded.telegram_id,
  grade=excluded.grade,study_field=excluded.study_field,province=excluded.province,city=excluded.city,
  additional_notes=excluded.additional_notes,updated_at=now();
 update public.profiles set full_name=name_value,phone=nullif(payload->>'phone',''),
  grade=nullif(payload->>'grade','')::smallint,study_field=nullif(payload->>'study_field','')::public.study_field
 where id=me;
 -- Deliberately do not change registration_status, counselor assignments or payment.
end;$$;

-- Only an approved assigned counselor may edit these two canonical profile fields.
-- Registration/account submissions remain historical snapshots, not counselor-editable forms.
create or replace function public.counselor_update_student_study(
 target_student_id uuid, target_grade smallint, target_study_field public.study_field
) returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role
    or not exists(select 1 from public.counselor_profiles where user_id=(select auth.uid()) and approval_status='approved') then
  raise exception 'Approved counselor required' using errcode='42501';
 end if;
 if target_grade is null or target_grade not in (9,10,11,12)
    or (target_grade=9 and target_study_field is not null)
    or (target_grade<>9 and target_study_field is null) then
  raise exception 'Invalid student study fields' using errcode='22023';
 end if;
 -- Serialize curriculum edits with the existing plan-saving advisory lock.
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 perform 1 from public.counselor_students
  where student_id=target_student_id and counselor_id=(select auth.uid()) for update;
 if not found then raise exception 'Student not assigned' using errcode='42501'; end if;
 update public.profiles set grade=target_grade,study_field=target_study_field
  where id=target_student_id and role='student' and registration_status='active';
 if not found then raise exception 'Active student required' using errcode='42501'; end if;
end; $$;

create or replace function public.save_weekly_plan_v4(target_plan_id uuid,target_student_id uuid,target_week_start date,target_title text,target_notes text,target_status public.content_status,target_items jsonb)
returns uuid language plpgsql security definer set search_path='' as $$
declare saved uuid; item jsonb; item_index integer:=0; g smallint; track text; y smallint; student_grade smallint; student_field text; original_status public.content_status; today date:=timezone('Asia/Tehran',now())::date;
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then raise exception 'Only counselors can save plans'; end if;
 if not exists(select 1 from public.counselor_students where student_id=target_student_id and counselor_id=(select auth.uid())) then raise exception 'Student not assigned'; end if;
 if target_items is null or jsonb_typeof(target_items)<>'array' or jsonb_array_length(target_items)>100 then raise exception 'Invalid items'; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 select grade,study_field::text into student_grade,student_field from public.profiles where id=target_student_id;
 if target_plan_id is not null then select status into original_status from public.weekly_plans where id=target_plan_id and counselor_id=(select auth.uid()) for update; end if;
 for item in select value from jsonb_array_elements(target_items) loop
  g:=nullif(item->>'sourceGrade','')::smallint;track:=coalesce(item->>'preparationTrack','konkur');y:=nullif(item->>'examYear','')::smallint;
  if track not in ('konkur','final_exam') or (g is not null and (g not in (9,10,11,12))) then raise exception 'Invalid curriculum grade or track'; end if;
  if track='konkur' and (y is not null or (g=9 and (btrim(item->>'subject')<>'هوش و استعداد تحلیلی' or nullif(btrim(item->>'recommendedPublisher'),'') is not null))) then raise exception 'Invalid grade nine aptitude subject or exam year'; end if;
  if track='final_exam' then
   if g is null or not exists(select 1 from public.school_subjects official where (g=9 or official.study_field::text=student_field) and official.grade=g and official.subject=btrim(item->>'subject')) then raise exception 'Subject not in school curriculum'; end if;
  end if;
 end loop;
 -- Delegate all existing authorization, date locks, overlap checks and atomic persistence to v3.
 saved:=public.save_weekly_plan_v3(target_plan_id,target_student_id,target_week_start,target_title,target_notes,target_status,target_items);
 for item in select value from jsonb_array_elements(target_items) loop
  update public.weekly_plan_items set source_grade=nullif(item->>'sourceGrade','')::smallint,preparation_track=coalesce(item->>'preparationTrack','konkur'),exam_year=null
  where plan_id=saved and sort_order=item_index and day_of_week=(item->>'dayOfWeek')::smallint
   and ((original_status='published'::public.content_status and (target_week_start+day_of_week>today or (current_setting('nova.edit_published_today',true)='on' and target_week_start+day_of_week=today))) or (original_status is distinct from 'published'::public.content_status and target_week_start+day_of_week>=today));
  item_index:=item_index+1;
 end loop;
 return saved;
end; $$;


notify pgrst, 'reload schema';
