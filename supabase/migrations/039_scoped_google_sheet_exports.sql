-- Dedicated read-only export credentials. Never store plaintext credentials.
create table public.google_sheet_export_tokens(
 id uuid primary key default gen_random_uuid(),
 token_hash text not null unique check(token_hash ~ '^[a-f0-9]{64}$'),
 issued_by uuid not null references public.profiles(id) on delete cascade,
 subject_id uuid not null references public.profiles(id) on delete cascade,
 scope text not null check(scope in ('admin','counselor')),
 created_at timestamptz not null default now(),
 expires_at timestamptz not null default now()+interval '90 days',
 revoked_at timestamptz,
 spreadsheet_id text check(spreadsheet_id is null or spreadsheet_id ~ '^[A-Za-z0-9_-]{20,200}$')
);
alter table public.google_sheet_export_tokens enable row level security;
revoke all on public.google_sheet_export_tokens from anon,authenticated;

create function public.admin_issue_sheet_export_token(hash_value text,target_counselor_id uuid default null) returns table(id uuid,scope text,expires_at timestamptz) language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only';end if;
 if hash_value is null or hash_value !~ '^[a-f0-9]{64}$' then raise exception 'Invalid token hash';end if;
 if target_counselor_id is not null and not exists(select 1 from public.profiles p join public.counselor_profiles c on c.user_id=p.id where p.id=target_counselor_id and p.role='counselor' and c.approval_status='approved') then raise exception 'Approved counselor required';end if;
 return query insert into public.google_sheet_export_tokens(token_hash,issued_by,subject_id,scope) values(hash_value,(select auth.uid()),coalesce(target_counselor_id,(select auth.uid())),case when target_counselor_id is null then 'admin' else 'counselor' end) returning google_sheet_export_tokens.id,google_sheet_export_tokens.scope,google_sheet_export_tokens.expires_at;
end;$$;
create function public.admin_list_sheet_export_tokens() returns table(id uuid,scope text,subject_name text,expires_at timestamptz,revoked_at timestamptz,spreadsheet_id text) language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only';end if;
 return query select t.id,t.scope,p.full_name,t.expires_at,t.revoked_at,t.spreadsheet_id from public.google_sheet_export_tokens t join public.profiles p on p.id=t.subject_id order by t.created_at desc;
end;$$;
create function public.admin_revoke_sheet_export_token(target_token_id uuid) returns void language plpgsql security definer set search_path='' as $$begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only';end if;
 update public.google_sheet_export_tokens set revoked_at=now() where id=target_token_id;
end;$$;
create function public.admin_attach_google_sheet(target_token_id uuid,target_spreadsheet_id text) returns void language plpgsql security definer set search_path='' as $$begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only';end if;
 if target_spreadsheet_id is null or target_spreadsheet_id !~ '^[A-Za-z0-9_-]{20,200}$' then raise exception 'Invalid sheet ID';end if;
 update public.google_sheet_export_tokens set spreadsheet_id=target_spreadsheet_id where id=target_token_id and revoked_at is null and expires_at>now();
end;$$;
create function public.my_google_sheet_links() returns table(spreadsheet_id text) language plpgsql stable security definer set search_path='' as $$begin
 if (select private.current_user_role()) not in ('admin'::public.app_role,'counselor'::public.app_role) or (select private.current_user_role()) is null then raise exception 'Staff only';end if;
 return query select distinct t.spreadsheet_id from public.google_sheet_export_tokens t where t.subject_id=(select auth.uid()) and t.scope=(select private.current_user_role())::text and t.spreadsheet_id is not null and t.revoked_at is null and t.expires_at>now();
end;$$;
-- Anonymous callers get no data without a 256-bit export credential. Scope is server-bound, not a request parameter.
create function public.sheet_export_snapshot(hash_value text) returns jsonb language plpgsql security definer set search_path='' as $$
declare credential public.google_sheet_export_tokens%rowtype;students jsonb;subject_name text;
begin
 select * into credential from public.google_sheet_export_tokens t where t.token_hash=hash_value and t.revoked_at is null and t.expires_at>now();
 if credential.id is null then raise exception 'Invalid export credential' using errcode='28000';end if;
 if not exists(select 1 from public.profiles issuer where issuer.id=credential.issued_by and issuer.role='admin') then raise exception 'Invalid export credential' using errcode='28000';end if;
 select p.full_name into subject_name from public.profiles p where p.id=credential.subject_id and p.role::text=credential.scope;
 if not found or (credential.scope='counselor' and not exists(select 1 from public.counselor_profiles c where c.user_id=credential.subject_id and c.approval_status='approved'))then raise exception 'Invalid export credential' using errcode='28000';end if;
 select coalesce(jsonb_agg(jsonb_build_object('student_id',p.id,'full_name',p.full_name,'phone',coalesce(r.phone,p.phone),'telegram_id',r.telegram_id,'grade',p.grade,'study_field',p.study_field,'province',r.province,'city',r.city,'registration_status',p.registration_status,'receipt_name',r.receipt_name,'has_receipt',r.receipt_path is not null,'counselor_name',(select string_agg(c.full_name,'، ' order by c.full_name) from public.counselor_students a join public.profiles c on c.id=a.counselor_id where a.student_id=p.id and (credential.scope='admin' or a.counselor_id=credential.subject_id))) order by p.created_at desc,p.id),'[]'::jsonb) into students from public.profiles p left join public.student_registrations r on r.student_id=p.id where p.role='student' and (credential.scope='admin' or exists(select 1 from public.counselor_students a where a.student_id=p.id and a.counselor_id=credential.subject_id));
 return jsonb_build_object('schema_version',1,'scope',credential.scope,'subject_id',credential.subject_id,'subject_name',subject_name,'expires_at',credential.expires_at,'generated_at',now(),'students',students);
end;$$;
revoke all on function public.admin_issue_sheet_export_token(text,uuid),public.admin_list_sheet_export_tokens(),public.admin_revoke_sheet_export_token(uuid),public.admin_attach_google_sheet(uuid,text),public.my_google_sheet_links() from public,anon;
grant execute on function public.admin_issue_sheet_export_token(text,uuid),public.admin_list_sheet_export_tokens(),public.admin_revoke_sheet_export_token(uuid),public.admin_attach_google_sheet(uuid,text),public.my_google_sheet_links() to authenticated;
revoke all on function public.sheet_export_snapshot(text) from public;
grant execute on function public.sheet_export_snapshot(text) to anon,authenticated;
