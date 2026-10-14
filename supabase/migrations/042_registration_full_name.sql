-- Canonical full name; preserve legacy names and old form compatibility.
alter table public.student_registrations add column full_name text;
update public.student_registrations set full_name=btrim(first_name)||' '||btrim(last_name);
alter table public.student_registrations alter column full_name set not null;
alter table public.student_registrations add constraint registration_full_name_check check(char_length(btrim(full_name)) between 3 and 121);
alter table public.student_registrations alter column first_name drop not null,alter column last_name drop not null;
create or replace function public.submit_student_registration(payload jsonb) returns void language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid()); current_status text; full_name_value text; receipt text; g smallint; f public.study_field;
begin
 select registration_status into current_status from public.profiles where id=me and role='student' for update;
 if current_status is null or current_status='active' then raise exception 'Registration not editable'; end if;
 if nullif(btrim(payload->>'full_name'),'') is null and (nullif(btrim(payload->>'first_name'),'') is null or nullif(btrim(payload->>'last_name'),'') is null) then raise exception 'Complete full name required';end if;
 full_name_value:=regexp_replace(btrim(coalesce(nullif(btrim(payload->>'full_name'),''),btrim(payload->>'first_name')||' '||btrim(payload->>'last_name'))),'\s+',' ','g');
 if full_name_value is null or char_length(full_name_value) not between 3 and 121 or position(' ' in full_name_value)=0 then raise exception 'Complete full name required';end if;
 receipt:=payload->>'receipt_path';g:=(payload->>'grade')::smallint;f:=(payload->>'study_field')::public.study_field;
 if receipt is null or split_part(receipt,'/',1)<>me::text or not exists(select 1 from storage.objects o where o.bucket_id='registration-receipts' and o.name=receipt) then raise exception 'A private receipt upload is required'; end if;
 insert into public.student_registrations(student_id,full_name,first_name,last_name,phone,telegram_id,grade,study_field,province,city,receipt_path,receipt_name)
 values(me,full_name_value,btrim(payload->>'first_name'),btrim(payload->>'last_name'),payload->>'phone',payload->>'telegram_id',g,f,btrim(payload->>'province'),btrim(payload->>'city'),receipt,left(payload->>'receipt_name',150))
 on conflict(student_id) do update set full_name=excluded.full_name,first_name=excluded.first_name,last_name=excluded.last_name,phone=excluded.phone,telegram_id=excluded.telegram_id,grade=excluded.grade,study_field=excluded.study_field,province=excluded.province,city=excluded.city,receipt_path=excluded.receipt_path,receipt_name=excluded.receipt_name,submitted_at=now();
 update public.profiles set full_name=full_name_value,phone=payload->>'phone',grade=g,study_field=f,registration_status='pending' where id=me;
end;$$;
