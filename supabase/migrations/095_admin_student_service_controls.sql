-- Deliberately separate an administrator's service suspension from an
-- incomplete registration. Keep historical plans/exams/receipts untouched.
alter table public.profiles drop constraint profiles_registration_status_check;
alter table public.profiles add constraint profiles_registration_status_check
  check (registration_status in ('incomplete','pending','active','disabled'));

create table private.student_service_events (
 id bigint generated always as identity primary key,
 student_id uuid not null,
 admin_id uuid not null,
 event_type text not null check(event_type in ('disabled','resumed','reassigned')),
 previous_counselor_ids uuid[] not null default '{}',
 new_counselor_id uuid,
 occurred_at timestamptz not null default now()
);
revoke all on private.student_service_events from public,anon,authenticated;
revoke all on sequence private.student_service_events_id_seq from public,anon,authenticated;

-- A disabled student may edit account information, but neither a student
-- submission nor the old manual/receipt activation endpoints can silently
-- lift an administrative suspension. Only the audited resume RPC may do so.
create function private.guard_student_service_resume() returns trigger
language plpgsql security definer set search_path='' as $$
begin
 if old.registration_status='disabled' and new.registration_status is distinct from 'disabled'
    and not (new.registration_status='active'
      and (select private.current_user_role())='admin'::public.app_role
      and coalesce(current_setting('nova.resuming_student',true),'')=old.id::text) then
   raise exception 'Disabled student requires an audited admin resume';
 end if;
 return new;
end;$$;
create trigger guard_student_service_resume before update of registration_status on public.profiles
for each row execute function private.guard_student_service_resume();

create function public.admin_disable_student(target_student_id uuid, expected_counselor_id uuid)
returns void language plpgsql security definer set search_path='' as $$
declare current_counselor uuid; previous_counselors uuid[];
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only'; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 perform 1 from public.profiles where id=target_student_id and role='student'
   and registration_status='active' for update;
 if not found then raise exception 'Active student required'; end if;
 select cs.counselor_id into current_counselor from public.counselor_students cs
   where cs.student_id=target_student_id order by cs.created_at desc,cs.id desc limit 1 for update;
 if current_counselor is distinct from expected_counselor_id then raise exception 'Counselor changed; refresh'; end if;
 select coalesce(array_agg(cs.counselor_id), '{}'::uuid[]) into previous_counselors
   from public.counselor_students cs where cs.student_id=target_student_id;
 delete from public.counselor_students where student_id=target_student_id;
 update public.profiles set registration_status='disabled' where id=target_student_id;
 insert into private.student_service_events(student_id,admin_id,event_type,previous_counselor_ids)
 values(target_student_id,(select auth.uid()),'disabled',previous_counselors);
end;$$;

create function public.admin_resume_student(target_student_id uuid,target_counselor_id uuid)
returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only'; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 perform 1 from public.profiles where id=target_student_id and role='student'
   and registration_status='disabled' for update;
 if not found then raise exception 'Disabled student required'; end if;
 if not exists(select 1 from auth.users u where u.id=target_student_id
   and (u.phone_confirmed_at is not null or u.email_confirmed_at is not null)) then
   raise exception 'Confirmed contact required'; end if;
 if not exists(select 1 from public.profiles p join public.counselor_profiles c on c.user_id=p.id
   where p.id=target_counselor_id and p.role='counselor' and c.approval_status='approved') then
   raise exception 'Approved counselor required'; end if;
 if exists(select 1 from public.counselor_students where student_id=target_student_id) then
   raise exception 'Unexpected counselor; refresh'; end if;
 insert into public.counselor_students(counselor_id,student_id) values(target_counselor_id,target_student_id);
 perform set_config('nova.resuming_student',target_student_id::text,true);
 update public.profiles set registration_status='active' where id=target_student_id;
 insert into private.student_service_events(student_id,admin_id,event_type,new_counselor_id)
 values(target_student_id,(select auth.uid()),'resumed',target_counselor_id);
end;$$;

create function public.admin_change_student_counselor(
 target_student_id uuid, expected_counselor_id uuid, target_counselor_id uuid
) returns void language plpgsql security definer set search_path='' as $$
declare old_counselor uuid; assignment_count integer;
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only'; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 perform 1 from public.profiles where id=target_student_id and role='student'
   and registration_status='active' for update;
 if not found then raise exception 'Active student required'; end if;
 select count(*),min(counselor_id::text)::uuid into assignment_count,old_counselor
 from public.counselor_students where student_id=target_student_id;
 if assignment_count<>1 or old_counselor is distinct from expected_counselor_id then
   raise exception 'Counselor changed; refresh'; end if;
 if target_counselor_id=old_counselor then raise exception 'Choose a different counselor'; end if;
 if not exists(select 1 from public.profiles p join public.counselor_profiles c on c.user_id=p.id
   where p.id=target_counselor_id and p.role='counselor' and c.approval_status='approved') then
   raise exception 'Approved counselor required'; end if;
 update public.counselor_students set counselor_id=target_counselor_id,created_at=now()
 where student_id=target_student_id and counselor_id=old_counselor;
 insert into private.student_service_events(student_id,admin_id,event_type,previous_counselor_ids,new_counselor_id)
 values(target_student_id,(select auth.uid()),'reassigned',array[old_counselor],target_counselor_id);
end;$$;
revoke all on function public.admin_disable_student(uuid,uuid),public.admin_resume_student(uuid,uuid),
 public.admin_change_student_counselor(uuid,uuid,uuid) from public,anon;
grant execute on function public.admin_disable_student(uuid,uuid),public.admin_resume_student(uuid,uuid),
 public.admin_change_student_counselor(uuid,uuid,uuid) to authenticated;

-- Prevent orphaned private objects while a student is administratively disabled.
alter policy receipt_upload_own_pending on storage.objects with check (
 bucket_id='registration-receipts' and (storage.foldername(name))[1]=(select auth.uid())::text
 and exists(select 1 from public.profiles p where p.id=(select auth.uid()) and p.role='student'
   and p.registration_status in ('incomplete','pending'))
);
alter policy receipt_upload_admin_student on storage.objects with check (
 bucket_id='registration-receipts' and (select private.current_user_role())='admin'
 and name ~ '^[0-9a-f-]{36}/[0-9a-f-]{36}\.(jpg|png|webp)$'
 and exists(select 1 from public.profiles p where p.id::text=(storage.foldername(name))[1]
   and p.role='student' and p.registration_status in ('incomplete','pending'))
);

-- SECURITY DEFINER helpers used by RLS: assignments are evaluated against
-- the CURRENT relationship, not the author of an old plan.
create function private.student_services_active(target_student_id uuid) returns boolean
language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.profiles p where p.id=target_student_id
  and p.role='student' and p.registration_status='active'); $$;
create function private.counselor_currently_assigned(target_student_id uuid) returns boolean
language sql stable security definer set search_path='' as $$
 select (select private.current_user_role())='counselor'::public.app_role
  and private.student_services_active(target_student_id)
  and exists(select 1 from public.counselor_students cs
   where cs.student_id=target_student_id and cs.counselor_id=(select auth.uid())); $$;

alter policy plan_participants_read on public.weekly_plans using (
 (select private.current_user_role())='admin'
 or (student_id=(select auth.uid()) and status='published' and private.student_services_active(student_id))
 or (counselor_id=(select auth.uid()) and private.counselor_currently_assigned(student_id))
);
alter policy assigned_counselor_published_history on public.weekly_plans using (
 status='published' and private.counselor_currently_assigned(student_id)
);
alter policy assigned_counselors_create_plans on public.weekly_plans with check (
 counselor_id=(select auth.uid()) and private.counselor_currently_assigned(student_id)
);
alter policy counselors_update_own_plans on public.weekly_plans using (
 (select private.current_user_role())='admin' or
 (counselor_id=(select auth.uid()) and private.counselor_currently_assigned(student_id))
) with check (
 (select private.current_user_role())='admin' or
 (counselor_id=(select auth.uid()) and private.counselor_currently_assigned(student_id))
);
alter policy counselors_delete_own_plans on public.weekly_plans using (
 (select private.current_user_role())='admin' or
 (counselor_id=(select auth.uid()) and private.counselor_currently_assigned(student_id))
);

alter policy plan_participants_read_items on public.weekly_plan_items using (
 exists(select 1 from public.weekly_plans p where p.id=plan_id and (
 (select private.current_user_role())='admin'
 or (p.student_id=(select auth.uid()) and p.status='published' and private.student_services_active(p.student_id))
 or (p.counselor_id=(select auth.uid()) and private.counselor_currently_assigned(p.student_id))
 ))
);
alter policy assigned_counselor_published_items on public.weekly_plan_items using (
 exists(select 1 from public.weekly_plans p where p.id=plan_id and p.status='published'
 and private.counselor_currently_assigned(p.student_id))
);
alter policy counselors_create_plan_items on public.weekly_plan_items with check (
 exists(select 1 from public.weekly_plans p where p.id=plan_id and p.counselor_id=(select auth.uid())
 and private.counselor_currently_assigned(p.student_id))
);
alter policy counselors_update_plan_items on public.weekly_plan_items using (
 exists(select 1 from public.weekly_plans p where p.id=plan_id and ((select private.current_user_role())='admin'
 or (p.counselor_id=(select auth.uid()) and private.counselor_currently_assigned(p.student_id))))
) with check (
 exists(select 1 from public.weekly_plans p where p.id=plan_id and ((select private.current_user_role())='admin'
 or (p.counselor_id=(select auth.uid()) and private.counselor_currently_assigned(p.student_id))))
);
alter policy counselors_delete_plan_items on public.weekly_plan_items using (
 exists(select 1 from public.weekly_plans p where p.id=plan_id and ((select private.current_user_role())='admin'
 or (p.counselor_id=(select auth.uid()) and private.counselor_currently_assigned(p.student_id))))
);

alter policy completion_participants_read on public.weekly_plan_item_completions using (
 (select private.current_user_role())='admin'
 or (student_id=(select auth.uid()) and private.student_services_active(student_id))
 or exists(select 1 from public.weekly_plan_items i join public.weekly_plans p on p.id=i.plan_id
   where i.id=item_id and p.counselor_id=(select auth.uid())
   and private.counselor_currently_assigned(p.student_id))
);
alter policy assigned_counselor_published_completions on public.weekly_plan_item_completions using (
 exists(select 1 from public.weekly_plan_items i join public.weekly_plans p on p.id=i.plan_id
   where i.id=item_id and p.status='published'
   and private.counselor_currently_assigned(p.student_id))
);

alter policy participants_read_exam_attempts on public.exam_attempts using (
 (select private.current_user_role())='admin'
 or (student_id=(select auth.uid()) and (select private.current_user_role())='student'
    and private.student_services_active(student_id))
 or private.counselor_currently_assigned(student_id)
);
alter policy student_reads_own_exam_session on public.exam_sessions using (
 student_id=(select auth.uid()) and (select private.current_user_role())='student'
 and private.student_services_active(student_id)
);
-- The submitted-at fallback in exam/booklet/report RLS must also close when
-- services are disabled; old attempts remain stored and reappear on resume.
create or replace function private.student_has_submitted_exam(target_exam_id uuid,target_student_id uuid)
returns boolean language sql stable security definer set search_path='' as $$
 select target_student_id=(select auth.uid()) and private.student_services_active(target_student_id)
 and exists(select 1 from public.exams e join public.exam_attempts a on a.exam_id=e.id
  where e.id=target_exam_id and e.status='published' and a.student_id=target_student_id
    and a.submitted_at is not null);
$$;
notify pgrst,'reload schema';
