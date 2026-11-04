-- Ninth grade paid enrollment: same published price band as grades 10 and 11.
-- Grade nine has no study field. Keep existing paid registrations and the
-- administrator's independently chosen final course untouched.
alter table public.student_registrations drop constraint student_registrations_grade_check;
alter table public.student_registrations add constraint student_registrations_grade_check
 check (grade in (9,10,11,12));
alter table public.student_registrations alter column study_field drop not null;
alter table public.student_registrations drop constraint student_registrations_study_field_check;
alter table public.student_registrations add constraint student_registrations_study_field_check
 check ((grade=9 and study_field is null) or
        (grade in (10,11,12) and study_field::text in
         ('mathematics','experimental_sciences','humanities','arts','foreign_languages')));

create or replace function public.submit_student_registration(payload jsonb) returns void
language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid()); current_status text; full_name_value text;
 receipt text; g smallint; f public.study_field; selected_course text; selected_months smallint;
begin
 select registration_status into current_status from public.profiles where id=me and role='student' for update;
 if current_status is null or current_status='active' then raise exception 'Registration not editable';end if;
 if not exists(select 1 from auth.users where id=me and (email_confirmed_at is not null or phone_confirmed_at is not null))
 then raise exception 'Confirmed contact required';end if;
 full_name_value:=nullif(regexp_replace(btrim(coalesce(nullif(btrim(payload->>'full_name'),''),
   nullif(btrim(concat_ws(' ',nullif(btrim(payload->>'first_name'),''),nullif(btrim(payload->>'last_name'),''))),''),'')),'\s+',' ','g'),'');
 if full_name_value is null or char_length(full_name_value) not between 3 and 121 or position(' ' in full_name_value)=0
 then raise exception 'Complete full name required';end if;
 receipt:=payload->>'receipt_path';g:=nullif(payload->>'grade','')::smallint;f:=nullif(payload->>'study_field','')::public.study_field;
 if g is null or g not in (9,10,11,12) or (g=9 and f is not null) or (g<>9 and f is null)
 then raise exception 'Valid grade and study field required';end if;
 selected_course:=nullif(payload->>'course_type','');selected_months:=nullif(payload->>'course_duration_months','')::smallint;
 -- Keep legacy submissions readable, but never accept a half-filled or invalid selection.
 if (selected_course is null)<>(selected_months is null) then raise exception 'Complete course selection required';end if;
 if g=9 and (selected_course not in ('base','progress') or selected_months is null)
 then raise exception 'Ninth-grade course selection required';end if;
 if selected_course is not null and (selected_course not in ('with_exam','with_support','simple_consultant','base','vip','progress','cip')
  or selected_months not in (1,3,6,12)) then raise exception 'Invalid course selection';end if;
 if receipt is null or split_part(receipt,'/',1)<>me::text or not exists(
   select 1 from storage.objects o where o.bucket_id='registration-receipts' and o.name=receipt)
 then raise exception 'A private receipt upload is required';end if;
 insert into public.student_registrations(student_id,full_name,first_name,last_name,phone,telegram_id,grade,study_field,province,city,receipt_path,receipt_name,course_type,course_duration_months,additional_notes)
 values(me,full_name_value,nullif(btrim(payload->>'first_name'),''),nullif(btrim(payload->>'last_name'),''),
   nullif(payload->>'phone',''),nullif(payload->>'telegram_id',''),g,f,btrim(payload->>'province'),btrim(payload->>'city'),
   receipt,left(payload->>'receipt_name',150),selected_course,selected_months,coalesce(payload->>'additional_notes',''))
 on conflict(student_id) do update set full_name=excluded.full_name,first_name=excluded.first_name,last_name=excluded.last_name,
  phone=excluded.phone,telegram_id=excluded.telegram_id,grade=excluded.grade,study_field=excluded.study_field,
  province=excluded.province,city=excluded.city,receipt_path=excluded.receipt_path,receipt_name=excluded.receipt_name,
  course_type=coalesce(excluded.course_type,student_registrations.course_type),
  course_duration_months=coalesce(excluded.course_duration_months,student_registrations.course_duration_months),
  additional_notes=excluded.additional_notes,submitted_at=now();
 perform public.save_student_account_details(payload||jsonb_build_object('full_name',full_name_value));
 update public.profiles set registration_status='pending' where id=me;
end;$$;

notify pgrst,'reload schema';
