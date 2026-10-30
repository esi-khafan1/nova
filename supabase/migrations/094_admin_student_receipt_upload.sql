-- Admins can attach a Telegram-sent receipt to an inactive student without
-- bypassing the existing receipt-review and counselor-assignment flow.
-- Account-only students have no registration row: use their verified, complete
-- account details instead of fabricating a course or payment approval.
alter table public.student_registrations drop constraint student_registrations_study_field_check;
alter table public.student_registrations add constraint student_registrations_study_field_check
 check (study_field::text in ('mathematics','experimental_sciences','humanities','arts','foreign_languages'));

create table private.admin_receipt_uploads (
 id bigint generated always as identity primary key,
 student_id uuid not null,
 admin_id uuid not null,
 receipt_path text not null,
 previous_receipt_path text,
 uploaded_at timestamptz not null default now()
);
-- No client grants: the security-definer function alone writes the audit log.
revoke all on private.admin_receipt_uploads from public,anon,authenticated;
revoke all on sequence private.admin_receipt_uploads_id_seq from public,anon,authenticated;

create policy receipt_upload_admin_student on storage.objects for insert to authenticated
 with check (
  bucket_id='registration-receipts'
  and (select private.current_user_role())='admin'
  and name ~ '^[0-9a-f-]{36}/[0-9a-f-]{36}\.(jpg|png|webp)$'
  and exists(select 1 from public.profiles p
    where p.id::text=(storage.foldername(name))[1] and p.role='student'
      and p.registration_status<>'active')
 );
create policy receipt_remove_unused_admin on storage.objects for delete to authenticated
 using (
  bucket_id='registration-receipts'
  and (select private.current_user_role())='admin'
  and not exists(select 1 from public.student_registrations r where r.receipt_path=objects.name)
 );

create function public.admin_submit_student_receipt(
 target_student_id uuid, expected_receipt_path text, new_receipt_path text, new_receipt_name text
) returns void language plpgsql security definer set search_path='' as $$
declare current_status text; old_receipt text; details public.student_account_details%rowtype;
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
  raise exception 'Admin only';
 end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 select registration_status into current_status from public.profiles
  where id=target_student_id and role='student' for update;
 if current_status is null or current_status='active' then raise exception 'Inactive student required'; end if;
 if not exists(select 1 from auth.users where id=target_student_id
    and (email_confirmed_at is not null or phone_confirmed_at is not null)) then
  raise exception 'Confirmed student required';
 end if;
 select receipt_path into old_receipt from public.student_registrations
  where student_id=target_student_id for update;
 if old_receipt is distinct from nullif(expected_receipt_path,'') then
  raise exception 'Receipt changed; refresh and review again';
 end if;
 if new_receipt_path is null or new_receipt_path !~
    ('^'||target_student_id::text||'/[0-9a-f-]{36}\.(jpg|png|webp)$')
    or new_receipt_path=old_receipt
    or not exists(select 1 from storage.objects o
      where o.bucket_id='registration-receipts' and o.name=new_receipt_path)
    or new_receipt_name is null or char_length(new_receipt_name) not between 1 and 150 then
  raise exception 'Valid private student receipt required';
 end if;
 if old_receipt is null then
  select * into details from public.student_account_details where student_id=target_student_id;
  if not found then raise exception 'Complete account information required'; end if;
 end if;
 if exists(select 1 from public.student_registrations where student_id=target_student_id) then
  update public.student_registrations set receipt_path=new_receipt_path,
   receipt_name=new_receipt_name,submitted_at=now(),approved_at=null,approved_by=null
   where student_id=target_student_id;
 else
  -- Existing NOT NULL and CHECK constraints ensure missing details cannot be invented.
  insert into public.student_registrations
   (student_id,full_name,phone,telegram_id,grade,study_field,province,city,
    additional_notes,receipt_path,receipt_name)
  values (target_student_id,details.full_name,details.phone,details.telegram_id,
    details.grade,details.study_field,details.province,details.city,
    details.additional_notes,new_receipt_path,new_receipt_name);
 end if;
 update public.profiles set registration_status='pending' where id=target_student_id;
 insert into private.admin_receipt_uploads(student_id,admin_id,receipt_path,previous_receipt_path)
 values(target_student_id,(select auth.uid()),new_receipt_path,old_receipt);
 -- No activation, approval or counselor assignment here; review uses the
 -- existing admin_activate_student_auto RPC with this exact stored path.
end;$$;
revoke all on function public.admin_submit_student_receipt(uuid,text,text,text) from public,anon;
grant execute on function public.admin_submit_student_receipt(uuid,text,text,text) to authenticated;
notify pgrst,'reload schema';
