-- Secret material is provisioned separately, never placed in the repository.
create table private.renewal_discount_secret (
 singleton boolean primary key default true check(singleton),
 salt bytea not null check(octet_length(salt)=32),
 digest bytea not null check(octet_length(digest)=32)
);
create table private.renewal_discount_attempts (
 student_id uuid primary key references public.profiles(id) on delete cascade,
 window_start timestamptz not null default now(), attempts integer not null default 0 check(attempts>=0)
);
create table private.renewal_quotes (
 id uuid primary key default gen_random_uuid(),
 student_id uuid not null references public.profiles(id) on delete cascade,
 grade smallint not null check(grade between 9 and 12),
 study_field text,
 course_type text not null check(course_type in ('base','progress')),
 months smallint not null check(months in (1,3,6,12)),
 base_price bigint not null check(base_price>=0),
 discount_percent smallint not null check(discount_percent in (0,15)),
 payable_price bigint not null check(payable_price>=0),
 created_at timestamptz not null default now(), expires_at timestamptz not null default now()+interval '24 hours',
 check ((grade=9 and study_field is null) or (grade<>9 and study_field in ('mathematics','experimental_sciences','humanities')))
);
create table private.student_renewal_requests (
 id uuid primary key default gen_random_uuid(),
 student_id uuid not null references public.profiles(id) on delete cascade,
 quote_id uuid not null unique references private.renewal_quotes(id),
 receipt_path text not null unique, receipt_name text not null,
 status text not null default 'pending' check(status in ('pending','reviewed')),
 created_at timestamptz not null default now(), reviewed_at timestamptz, reviewed_by uuid references public.profiles(id)
);
create unique index student_renewal_one_pending on private.student_renewal_requests(student_id) where status='pending';
create index student_renewal_pending on private.student_renewal_requests(created_at) where status='pending';
alter table private.renewal_discount_secret enable row level security;
alter table private.renewal_discount_attempts enable row level security;
alter table private.renewal_quotes enable row level security;
alter table private.student_renewal_requests enable row level security;
revoke all on private.renewal_discount_secret,private.renewal_discount_attempts,private.renewal_quotes,private.student_renewal_requests from public,anon,authenticated;

create function private.require_renewal_access() returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role
   or not exists(select 1 from public.profiles p where p.id=(select auth.uid()) and p.role='student' and p.registration_status='active')
   or exists(select 1 from private.student_account_blocks where student_id=(select auth.uid()))
   or not exists(select 1 from auth.users where id=(select auth.uid()) and (email_confirmed_at is not null or phone_confirmed_at is not null))
 then raise exception 'Renewal unavailable' using errcode='42501';end if;
end;$$;
revoke all on function private.require_renewal_access() from public,anon,authenticated;

-- Returns a short-lived quote bound to the caller, amount and selected course.
-- Invalid attempts return normally so the per-account rate limit persists.
create function public.quote_student_renewal(target_grade smallint,target_field text,target_course text,target_months smallint,target_code text)
returns jsonb language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid()); monthly bigint; original bigint; final bigint; discount smallint:=0; attempt private.renewal_discount_attempts%rowtype; qid uuid; secret private.renewal_discount_secret%rowtype;
begin
 perform private.require_renewal_access();
 if target_grade is null or target_grade not between 9 and 12 or target_course is null or target_course not in ('base','progress') or target_months is null or target_months not in (1,3,6,12)
 or (target_grade=9 and target_field is not null) or (target_grade<>9 and (target_field is null or target_field not in ('mathematics','experimental_sciences','humanities')))
 or length(coalesce(target_code,''))>64 then raise exception 'Invalid selection' using errcode='22023'; end if;
 if not (select public.course_enrollment_open()) then raise exception 'Course capacity full' using errcode='P0001';end if;
 select monthly_price into monthly from private.course_offer_settings where grade=target_grade and plan=target_course;
 if monthly is null then raise exception 'Offer unavailable' using errcode='22023';end if;
 if btrim(coalesce(target_code,''))<>'' then
   insert into private.renewal_discount_attempts(student_id) values(me) on conflict(student_id) do nothing;
   select * into attempt from private.renewal_discount_attempts where student_id=me for update;
   if attempt.window_start < now()-interval '15 minutes' then update private.renewal_discount_attempts set attempts=0,window_start=now() where student_id=me returning * into attempt;end if;
   if attempt.attempts>=8 then return jsonb_build_object('status','limited');end if;
   update private.renewal_discount_attempts set attempts=attempts+1 where student_id=me;
   select * into secret from private.renewal_discount_secret where singleton;
   if not found or pg_catalog.sha256(secret.salt||pg_catalog.convert_to(pg_catalog.upper(pg_catalog.btrim(target_code)),'UTF8')) is distinct from secret.digest then
    return jsonb_build_object('status','invalid');
   end if;
   discount:=15;
 end if;
 original:=monthly*target_months; final:=(original*(100-discount)+50)/100;
 insert into private.renewal_quotes(student_id,grade,study_field,course_type,months,base_price,discount_percent,payable_price)
 values(me,target_grade,target_field,target_course,target_months,original,discount,final) returning id into qid;
 return jsonb_build_object('status','ok','quote_id',qid,'base_price',original,'discount_percent',discount,'payable_price',final);
end;$$;
revoke all on function public.quote_student_renewal(smallint,text,text,smallint,text) from public,anon;
grant execute on function public.quote_student_renewal(smallint,text,text,smallint,text) to authenticated;

-- An unexpired quote remains uploadable if sales close after the student pays.
create function private.renewal_may_upload() returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.profiles p where p.id=(select auth.uid()) and p.role='student' and p.registration_status='active')
   and exists(select 1 from private.renewal_quotes q where q.student_id=(select auth.uid()) and q.expires_at>now());
$$;
revoke all on function private.renewal_may_upload() from public,anon;
grant execute on function private.renewal_may_upload() to authenticated;
-- Active students upload separately from their original registration receipt.
create policy receipt_upload_own_renewal on storage.objects for insert to authenticated with check (
 bucket_id='registration-receipts' and (storage.foldername(name))[1]=(select auth.uid())::text
 and (storage.foldername(name))[2]='renewal'
 and (select private.renewal_may_upload())
);
create function private.renewal_receipt_unused(target_path text) returns boolean language sql stable security definer set search_path='' as $$
 select not exists(select 1 from private.student_renewal_requests where receipt_path=target_path);
$$;
revoke all on function private.renewal_receipt_unused(text) from public,anon;
grant execute on function private.renewal_receipt_unused(text) to authenticated;
create policy receipt_protect_used_renewal on storage.objects as restrictive for delete to authenticated
 using (bucket_id<>'registration-receipts' or (select private.renewal_receipt_unused(name)));

create function public.submit_student_renewal(target_quote_id uuid,target_receipt text,target_name text)
returns uuid language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid()); q private.renewal_quotes%rowtype; rid uuid;
begin
 perform private.require_renewal_access();
 perform 1 from public.profiles where id=me for update;
 perform private.require_renewal_access();
 select * into q from private.renewal_quotes where id=target_quote_id and student_id=me for update;
 if not found or q.expires_at<=now() or exists(select 1 from private.student_renewal_requests where quote_id=target_quote_id) then raise exception 'Quote unavailable' using errcode='22023';end if;
 if target_receipt is null or split_part(target_receipt,'/',1)<>me::text or split_part(target_receipt,'/',2)<>'renewal'
  or target_name is null or length(target_name)>150 then raise exception 'Receipt unavailable' using errcode='22023';end if;
 perform 1 from storage.objects where bucket_id='registration-receipts' and name=target_receipt for key share;
 if not found then raise exception 'Receipt unavailable' using errcode='22023';end if;
 insert into private.student_renewal_requests(student_id,quote_id,receipt_path,receipt_name) values(me,q.id,target_receipt,target_name) returning id into rid;
 return rid;
end;$$;
revoke all on function public.submit_student_renewal(uuid,text,text) from public,anon;
grant execute on function public.submit_student_renewal(uuid,text,text) to authenticated;

create function public.admin_list_student_renewals() returns jsonb language plpgsql stable security definer set search_path='' as $$
declare result jsonb;
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only' using errcode='42501';end if;
 select coalesce(jsonb_agg(jsonb_build_object('id',r.id,'student_id',r.student_id,'full_name',p.full_name,'phone',p.phone,'grade',q.grade,'field',q.study_field,'course',q.course_type,'months',q.months,'base_price',q.base_price,'discount_percent',q.discount_percent,'payable_price',q.payable_price,'created_at',r.created_at) order by r.created_at),'[]'::jsonb) into result
 from private.student_renewal_requests r join private.renewal_quotes q on q.id=r.quote_id join public.profiles p on p.id=r.student_id
 where r.status='pending' and p.role='student' and not exists(select 1 from private.student_account_blocks b where b.student_id=p.id);
 return result;
end;$$;
revoke all on function public.admin_list_student_renewals() from public,anon;
grant execute on function public.admin_list_student_renewals() to authenticated;

create function public.student_renewal_receipt(target_request_id uuid) returns text language plpgsql stable security definer set search_path='' as $$
declare p text;
begin
 select receipt_path into p from private.student_renewal_requests where id=target_request_id and (student_id=(select auth.uid()) or (select private.current_user_role())='admin'::public.app_role);
 if p is null then raise exception 'Receipt unavailable' using errcode='42501';end if;return p;
end;$$;
revoke all on function public.student_renewal_receipt(uuid) from public,anon;
grant execute on function public.student_renewal_receipt(uuid) to authenticated;

create function public.admin_review_student_renewal(target_request_id uuid) returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only' using errcode='42501';end if;
 update private.student_renewal_requests set status='reviewed',reviewed_at=now(),reviewed_by=(select auth.uid()) where id=target_request_id and status='pending';
 if not found then raise exception 'Request unavailable' using errcode='40001';end if;
end;$$;
revoke all on function public.admin_review_student_renewal(uuid) from public,anon;
grant execute on function public.admin_review_student_renewal(uuid) to authenticated;
notify pgrst,'reload schema';
