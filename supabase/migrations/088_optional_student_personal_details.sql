-- In student information forms grade, field, province and city are required.
-- Course choice and the private receipt remain required for normal enrollment.
-- Existing rows, activation, assignments and receipts are unchanged.
alter table public.student_account_details
 alter column full_name drop not null,
 alter column phone drop not null,
 alter column telegram_id drop not null;

alter table public.student_registrations
 alter column full_name drop not null,
 alter column phone drop not null,
 alter column telegram_id drop not null;

create or replace function public.save_student_account_details(payload jsonb) returns void
language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid()); name_value text;
begin
 if not exists(select 1 from public.profiles p join auth.users u on u.id=p.id
               where p.id=me and p.role='student' and (u.email_confirmed_at is not null or u.phone_confirmed_at is not null))
 then raise exception 'Confirmed student required'; end if;
 perform 1 from public.profiles where id=me for update;
 name_value:=nullif(regexp_replace(btrim(coalesce(payload->>'full_name','')),'\s+',' ','g'),'');
 if name_value is not null and (char_length(name_value) not between 3 and 121 or position(' ' in name_value)=0)
 then raise exception 'Invalid full name'; end if;
 if nullif(payload->>'grade','') is null or nullif(payload->>'study_field','') is null
 then raise exception 'Grade and study field required'; end if;
 insert into public.student_account_details(student_id,full_name,phone,telegram_id,grade,study_field,province,city,additional_notes)
 values(me,name_value,nullif(payload->>'phone',''),nullif(payload->>'telegram_id',''),
        nullif(payload->>'grade','')::smallint,nullif(payload->>'study_field','')::public.study_field,
        btrim(payload->>'province'),btrim(payload->>'city'),coalesce(payload->>'additional_notes',''))
 on conflict(student_id) do update set full_name=excluded.full_name,phone=excluded.phone,telegram_id=excluded.telegram_id,
  grade=excluded.grade,study_field=excluded.study_field,province=excluded.province,city=excluded.city,
  additional_notes=excluded.additional_notes,updated_at=now();
 update public.profiles set full_name=coalesce(name_value,full_name),phone=nullif(payload->>'phone',''),
  grade=nullif(payload->>'grade','')::smallint,study_field=nullif(payload->>'study_field','')::public.study_field
 where id=me;
 -- Deliberately do not change registration_status, counselor assignments or payment.
end;$$;
revoke all on function public.save_student_account_details(jsonb) from public,anon;
grant execute on function public.save_student_account_details(jsonb) to authenticated;

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
 if full_name_value is not null and (char_length(full_name_value) not between 3 and 121 or position(' ' in full_name_value)=0)
 then raise exception 'Invalid full name';end if;
 receipt:=payload->>'receipt_path';g:=nullif(payload->>'grade','')::smallint;f:=nullif(payload->>'study_field','')::public.study_field;
 if g is null or f is null then raise exception 'Grade and study field required';end if;
 selected_course:=nullif(payload->>'course_type','');selected_months:=nullif(payload->>'course_duration_months','')::smallint;
 -- Keep legacy submissions readable, but never accept a half-filled or invalid selection.
 if (selected_course is null)<>(selected_months is null) then raise exception 'Complete course selection required';end if;
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
revoke all on function public.submit_student_registration(jsonb) from public,anon;
grant execute on function public.submit_student_registration(jsonb) to authenticated;
notify pgrst,'reload schema';
