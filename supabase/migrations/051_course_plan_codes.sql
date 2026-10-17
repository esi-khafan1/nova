-- Keep historical course types readable while accepting the four new plans.
alter table public.student_registrations
 drop constraint registration_course_selection_check,
 add constraint registration_course_selection_check check (
  (course_type is null and course_duration_months is null) or
  (course_type is not null and course_duration_months is not null and course_type in ('with_exam','with_support','simple_consultant','base','vip','progress','cip') and course_duration_months in (3,6,12))
 );

-- Preserve the existing secure registration flow and allow the new plan codes.
create or replace function public.submit_student_registration(payload jsonb) returns void language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid()); current_status text; full_name_value text; receipt text; g smallint; f public.study_field; selected_course text; selected_months smallint;
begin
 select registration_status into current_status from public.profiles where id=me and role='student' for update;
 if current_status is null or current_status='active' then raise exception 'Registration not editable';end if;
 if not exists(select 1 from auth.users where id=me and email_confirmed_at is not null) then raise exception 'Confirmed email required';end if;
 if nullif(btrim(payload->>'full_name'),'') is null and (nullif(btrim(payload->>'first_name'),'') is null or nullif(btrim(payload->>'last_name'),'') is null) then raise exception 'Complete full name required';end if;
 full_name_value:=regexp_replace(btrim(coalesce(nullif(btrim(payload->>'full_name'),''),btrim(payload->>'first_name')||' '||btrim(payload->>'last_name'))),'\s+',' ','g');
 if full_name_value is null or char_length(full_name_value) not between 3 and 121 or position(' ' in full_name_value)=0 then raise exception 'Complete full name required';end if;
 receipt:=payload->>'receipt_path';g:=(payload->>'grade')::smallint;f:=(payload->>'study_field')::public.study_field;
 selected_course:=nullif(payload->>'course_type','');selected_months:=nullif(payload->>'course_duration_months','')::smallint;
 -- Allow legacy submissions as well as the current four plans, but never a half-filled selection.
 if (selected_course is null)<>(selected_months is null) then raise exception 'Complete course selection required';end if;
 if selected_course is not null and (selected_course not in ('with_exam','with_support','simple_consultant','base','vip','progress','cip') or selected_months not in (3,6,12)) then raise exception 'Invalid course selection';end if;
 if receipt is null or split_part(receipt,'/',1)<>me::text or not exists(select 1 from storage.objects o where o.bucket_id='registration-receipts' and o.name=receipt) then raise exception 'A private receipt upload is required';end if;
 insert into public.student_registrations(student_id,full_name,first_name,last_name,phone,telegram_id,grade,study_field,province,city,receipt_path,receipt_name,course_type,course_duration_months,additional_notes)
 values(me,full_name_value,btrim(payload->>'first_name'),btrim(payload->>'last_name'),payload->>'phone',payload->>'telegram_id',g,f,btrim(payload->>'province'),btrim(payload->>'city'),receipt,left(payload->>'receipt_name',150),selected_course,selected_months,coalesce(payload->>'additional_notes',''))
 on conflict(student_id) do update set full_name=excluded.full_name,first_name=excluded.first_name,last_name=excluded.last_name,phone=excluded.phone,telegram_id=excluded.telegram_id,grade=excluded.grade,study_field=excluded.study_field,province=excluded.province,city=excluded.city,receipt_path=excluded.receipt_path,receipt_name=excluded.receipt_name,course_type=coalesce(excluded.course_type,student_registrations.course_type),course_duration_months=coalesce(excluded.course_duration_months,student_registrations.course_duration_months),additional_notes=excluded.additional_notes,submitted_at=now();
 perform public.save_student_account_details(payload||jsonb_build_object('full_name',full_name_value));
 update public.profiles set registration_status='pending' where id=me;
end;$$;
