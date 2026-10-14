-- Existing accounts are grandfathered; all future students must complete registration.
alter table public.profiles add column registration_status text not null default 'active' check (registration_status in ('incomplete','pending','active'));
alter table public.profiles alter column registration_status set default 'incomplete';
create table public.student_registrations (
 student_id uuid primary key references public.profiles(id) on delete cascade,
 first_name text not null check(char_length(btrim(first_name)) between 2 and 50),
 last_name text not null check(char_length(btrim(last_name)) between 2 and 70),
 phone text not null check(phone ~ '^09[0-9]{9}$'),
 telegram_id text not null check(telegram_id ~ '^[A-Za-z][A-Za-z0-9_]{4,31}$'),
 grade smallint not null check(grade in (10,11,12)),
 study_field public.study_field not null check(study_field::text in ('mathematics','experimental_sciences','humanities')),
 province text not null check(char_length(btrim(province)) between 2 and 60),
 city text not null check(char_length(btrim(city)) between 2 and 60),
 receipt_path text not null,
 receipt_name text not null check(char_length(receipt_name) between 1 and 150),
 submitted_at timestamptz not null default now(),
 approved_at timestamptz,
 approved_by uuid references public.profiles(id) on delete set null
);
alter table public.student_registrations enable row level security;
revoke all on public.student_registrations from anon,authenticated;
grant select on public.student_registrations to authenticated;
create policy registration_participants_read on public.student_registrations for select to authenticated using (
 student_id=(select auth.uid()) or (select private.current_user_role())='admin' or ((select private.current_user_role())='counselor' and exists(select 1 from public.counselor_students a where a.student_id=student_registrations.student_id and a.counselor_id=(select auth.uid())))
);
-- Receipt objects remain private, never an ImageKit/public URL.
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('registration-receipts','registration-receipts',false,5242880,array['image/jpeg','image/png','image/webp']) on conflict(id) do nothing;
create policy receipt_upload_own_pending on storage.objects for insert to authenticated with check(bucket_id='registration-receipts' and (storage.foldername(name))[1]=(select auth.uid())::text and exists(select 1 from public.profiles p where p.id=(select auth.uid()) and p.role='student' and p.registration_status<>'active'));
create policy receipt_read_participants on storage.objects for select to authenticated using(bucket_id='registration-receipts' and ((storage.foldername(name))[1]=(select auth.uid())::text or (select private.current_user_role())='admin' or exists(select 1 from public.student_registrations r join public.counselor_students a on a.student_id=r.student_id where r.receipt_path=objects.name and a.counselor_id=(select auth.uid()) and (select private.current_user_role())='counselor')));
create policy receipt_remove_unused_own on storage.objects for delete to authenticated using(bucket_id='registration-receipts' and (storage.foldername(name))[1]=(select auth.uid())::text and not exists(select 1 from public.student_registrations r where r.receipt_path=objects.name));

create or replace function public.submit_student_registration(payload jsonb) returns void language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid()); current_status text; receipt text; g smallint; f public.study_field;
begin
 select registration_status into current_status from public.profiles where id=me and role='student' for update;
 if current_status is null or current_status='active' then raise exception 'Registration not editable'; end if;
 receipt:=payload->>'receipt_path';g:=(payload->>'grade')::smallint;f:=(payload->>'study_field')::public.study_field;
 if receipt is null or split_part(receipt,'/',1)<>me::text or not exists(select 1 from storage.objects o where o.bucket_id='registration-receipts' and o.name=receipt) then raise exception 'A private receipt upload is required'; end if;
 insert into public.student_registrations(student_id,first_name,last_name,phone,telegram_id,grade,study_field,province,city,receipt_path,receipt_name)
 values(me,btrim(payload->>'first_name'),btrim(payload->>'last_name'),payload->>'phone',payload->>'telegram_id',g,f,btrim(payload->>'province'),btrim(payload->>'city'),receipt,left(payload->>'receipt_name',150))
 on conflict(student_id) do update set first_name=excluded.first_name,last_name=excluded.last_name,phone=excluded.phone,telegram_id=excluded.telegram_id,grade=excluded.grade,study_field=excluded.study_field,province=excluded.province,city=excluded.city,receipt_path=excluded.receipt_path,receipt_name=excluded.receipt_name,submitted_at=now();
 update public.profiles set full_name=btrim(payload->>'first_name')||' '||btrim(payload->>'last_name'),phone=payload->>'phone',grade=g,study_field=f,registration_status='pending' where id=me;
end;$$;
revoke all on function public.submit_student_registration(jsonb) from public,anon;
grant execute on function public.submit_student_registration(jsonb) to authenticated;

-- Assignment and approval are one atomic admin operation.
create or replace function public.admin_activate_student(target_student_id uuid,target_counselor_id uuid,expected_receipt_path text) returns void language plpgsql security definer set search_path='' as $$
declare state text; r public.student_registrations%rowtype;
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only'; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 select registration_status into state from public.profiles where id=target_student_id and role='student' for update;
 if state is null then raise exception 'Student not found'; end if;
 if not exists(select 1 from public.profiles p join public.counselor_profiles c on c.user_id=p.id where p.id=target_counselor_id and p.role='counselor' and c.approval_status='approved') then raise exception 'Approved counselor required'; end if;
 select * into r from public.student_registrations where student_id=target_student_id for update;
 if state<>'active' then
  if state<>'pending' or r.student_id is null or expected_receipt_path is distinct from r.receipt_path or not exists(select 1 from storage.objects o where o.bucket_id='registration-receipts' and o.name=r.receipt_path) then raise exception 'Complete current registration and receipt required'; end if;
  update public.student_registrations set approved_at=now(),approved_by=(select auth.uid()) where student_id=target_student_id;
 end if;
 delete from public.counselor_students where student_id=target_student_id;
 insert into public.counselor_students(counselor_id,student_id) values(target_counselor_id,target_student_id);
 update public.profiles set registration_status='active' where id=target_student_id;
end;$$;
revoke all on function public.admin_activate_student(uuid,uuid,text) from public,anon;
grant execute on function public.admin_activate_student(uuid,uuid,text) to authenticated;

-- Hiding the picker alone is insufficient: remove the RPC and direct-table write paths.
create or replace function public.counselor_select_student(target_student_id uuid) returns void language plpgsql security definer set search_path='' as $$begin raise exception 'Assignments are managed by the admin';end;$$;
revoke all on function public.counselor_select_student(uuid) from public,anon,authenticated;
drop policy counselors_create_assignments on public.counselor_students;
drop policy counselors_remove_assignments on public.counselor_students;
revoke insert,update,delete on public.counselor_students from authenticated;
create or replace function public.counselor_student_directory() returns table(student_id uuid,full_name text,grade smallint,study_field public.study_field,is_selected boolean) language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then raise exception 'Counselor only';end if;
 return query select p.id,p.full_name,p.grade,p.study_field,true from public.profiles p join public.counselor_students a on a.student_id=p.id where a.counselor_id=(select auth.uid()) and p.role='student' and p.registration_status='active' order by p.full_name;
end;$$;

create or replace function public.registration_directory() returns table(student_id uuid,full_name text,phone text,telegram_id text,grade smallint,study_field public.study_field,province text,city text,registration_status text,receipt_path text,receipt_name text,counselor_name text,created_at timestamptz) language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) not in ('admin'::public.app_role,'counselor'::public.app_role) or (select private.current_user_role()) is null then raise exception 'Staff only';end if;
 return query select p.id,p.full_name,coalesce(r.phone,p.phone),r.telegram_id,p.grade,p.study_field,r.province,r.city,p.registration_status,r.receipt_path,r.receipt_name,(select string_agg(c.full_name,'، ' order by c.full_name) from public.counselor_students a join public.profiles c on c.id=a.counselor_id where a.student_id=p.id and ((select private.current_user_role())='admin' or a.counselor_id=(select auth.uid()))),p.created_at from public.profiles p left join public.student_registrations r on r.student_id=p.id where p.role='student' and ((select private.current_user_role())='admin' or exists(select 1 from public.counselor_students a where a.student_id=p.id and a.counselor_id=(select auth.uid()))) order by p.created_at desc,p.id;
end;$$;
revoke all on function public.registration_directory() from public,anon;
grant execute on function public.registration_directory() to authenticated;

-- Today's and past published activities are editable; future activities remain locked.
create or replace function public.set_weekly_plan_item_progress(
  target_item_id uuid,
  target_completed boolean,
  target_completed_test_count integer
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_student_id uuid;
  target_activity public.study_activity_type;
  target_test_goal smallint;
  tehran_today date := timezone('Asia/Tehran', now())::date;
begin
  if (select private.current_user_role())
    is distinct from 'student'::public.app_role
  then
    raise exception 'Only students can update plan progress';
  end if;

  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended((select auth.uid())::text,73033));

  select plan.student_id, item.activity_type, item.target_test_count
  into target_student_id, target_activity, target_test_goal
  from public.weekly_plan_items item
  join public.weekly_plans plan on plan.id = item.plan_id
  where item.id = target_item_id
    and plan.student_id = (select auth.uid())
    and plan.status = 'published'
    and exists(select 1 from public.profiles p where p.id=(select auth.uid()) and p.registration_status='active')
    and plan.week_start + item.day_of_week <= tehran_today;

  if target_student_id is null then
    raise exception 'Only own published activities through today can be updated';
  end if;

  if target_activity = 'practice_tests'::public.study_activity_type
    and target_completed
    and (
      target_test_goal is null
      or target_completed_test_count is null
      or target_completed_test_count not between 1 and 5000
    )
  then
    raise exception 'Completed test count is required';
  end if;

  if target_activity <> 'practice_tests'::public.study_activity_type
    and target_completed_test_count is not null
  then
    raise exception 'Test count is only supported for test activities';
  end if;

  if target_completed then
    insert into public.weekly_plan_item_completions (
      item_id,
      student_id,
      completed_at,
      completed_test_count
    )
    values (
      target_item_id,
      target_student_id,
      now(),
      case
        when target_activity = 'practice_tests'::public.study_activity_type
          then target_completed_test_count::smallint
        else null
      end
    )
    on conflict (item_id) do update set
      completed_at = excluded.completed_at,
      completed_test_count = excluded.completed_test_count;
  else
    delete from public.weekly_plan_item_completions
    where item_id = target_item_id
      and student_id = target_student_id;
  end if;
end;
$$;

revoke all on function public.set_weekly_plan_item_progress(uuid, boolean, integer)
from public, anon;

grant execute on function public.set_weekly_plan_item_progress(uuid, boolean, integer)
to authenticated;
