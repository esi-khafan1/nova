-- Registration, payment receipts and Sheets access are admin-only (owner keeps their own receipt).
alter policy registration_participants_read on public.student_registrations using (student_id=(select auth.uid()) or (select private.current_user_role())='admin');
alter policy receipt_read_participants on storage.objects using (bucket_id='registration-receipts' and ((storage.foldername(name))[1]=(select auth.uid())::text or (select private.current_user_role())='admin'));
update public.google_sheet_export_tokens set revoked_at=now() where scope='counselor' and revoked_at is null;
create or replace function public.admin_issue_sheet_export_token(hash_value text,target_counselor_id uuid default null) returns table(id uuid,scope text,expires_at timestamptz) language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only';end if;
 if hash_value is null or hash_value !~ '^[a-f0-9]{64}$' then raise exception 'Invalid token hash';end if;
 if target_counselor_id is not null then raise exception 'Admin-only sheet';end if;
 return query insert into public.google_sheet_export_tokens(token_hash,issued_by,subject_id,scope) values(hash_value,(select auth.uid()),coalesce(target_counselor_id,(select auth.uid())),case when target_counselor_id is null then 'admin' else 'counselor' end) returning google_sheet_export_tokens.id,google_sheet_export_tokens.scope,google_sheet_export_tokens.expires_at;
end;$$;
create or replace function public.my_google_sheet_links() returns table(spreadsheet_id text) language plpgsql stable security definer set search_path='' as $$begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only';end if;
 return query select distinct t.spreadsheet_id from public.google_sheet_export_tokens t where t.subject_id=(select auth.uid()) and t.scope=(select private.current_user_role())::text and t.spreadsheet_id is not null and t.revoked_at is null and t.expires_at>now();
end;$$;
create or replace function public.sheet_export_snapshot(hash_value text) returns jsonb language plpgsql security definer set search_path='' as $$
declare credential public.google_sheet_export_tokens%rowtype;students jsonb;subject_name text;
begin
 select * into credential from public.google_sheet_export_tokens t where t.token_hash=hash_value and t.revoked_at is null and t.expires_at>now();
 if credential.id is null or credential.scope <> 'admin' then raise exception 'Invalid export credential' using errcode='28000';end if;
 if not exists(select 1 from public.profiles issuer where issuer.id=credential.issued_by and issuer.role='admin') then raise exception 'Invalid export credential' using errcode='28000';end if;
 select p.full_name into subject_name from public.profiles p where p.id=credential.subject_id and p.role::text=credential.scope;
 if not found or (credential.scope='counselor' and not exists(select 1 from public.counselor_profiles c where c.user_id=credential.subject_id and c.approval_status='approved'))then raise exception 'Invalid export credential' using errcode='28000';end if;
 select coalesce(jsonb_agg(jsonb_build_object('student_id',p.id,'full_name',p.full_name,'phone',coalesce(r.phone,p.phone),'telegram_id',r.telegram_id,'grade',p.grade,'study_field',p.study_field,'province',r.province,'city',r.city,'registration_status',p.registration_status,'receipt_name',r.receipt_name,'has_receipt',r.receipt_path is not null,'counselor_name',(select string_agg(c.full_name,'، ' order by c.full_name) from public.counselor_students a join public.profiles c on c.id=a.counselor_id where a.student_id=p.id and (credential.scope='admin' or a.counselor_id=credential.subject_id))) order by p.created_at desc,p.id),'[]'::jsonb) into students from public.profiles p left join public.student_registrations r on r.student_id=p.id where p.role='student' and (credential.scope='admin' or exists(select 1 from public.counselor_students a where a.student_id=p.id and a.counselor_id=credential.subject_id));
 return jsonb_build_object('schema_version',1,'scope',credential.scope,'subject_id',credential.subject_id,'subject_name',subject_name,'expires_at',credential.expires_at,'generated_at',now(),'students',students);
end;$$;
create or replace function public.registration_directory() returns table(student_id uuid,full_name text,phone text,telegram_id text,grade smallint,study_field public.study_field,province text,city text,registration_status text,receipt_path text,receipt_name text,counselor_name text,created_at timestamptz) language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only';end if;
 return query select p.id,p.full_name,coalesce(r.phone,p.phone),r.telegram_id,p.grade,p.study_field,r.province,r.city,p.registration_status,r.receipt_path,r.receipt_name,(select string_agg(c.full_name,'، ' order by c.full_name) from public.counselor_students a join public.profiles c on c.id=a.counselor_id where a.student_id=p.id and ((select private.current_user_role())='admin' or a.counselor_id=(select auth.uid()))),p.created_at from public.profiles p left join public.student_registrations r on r.student_id=p.id where p.role='student' and ((select private.current_user_role())='admin' or exists(select 1 from public.counselor_students a where a.student_id=p.id and a.counselor_id=(select auth.uid()))) order by p.created_at desc,p.id;
end;$$;
