-- Routine ticks have their own identity. They do not alter plan items, their
-- completions, or the printed routine layout. A tick protects its exact text.
create table public.weekly_plan_routine_completions (
 plan_id uuid not null references public.weekly_plans(id) on delete restrict,
 student_id uuid not null references public.profiles(id) on delete restrict,
 day_of_week smallint not null check (day_of_week between 0 and 6),
 slot smallint not null check (slot in (1,2)),
 subject text not null,
 details text not null,
 checked_at timestamptz not null default now(),
 primary key(plan_id,day_of_week,slot)
);
create index weekly_plan_routine_completions_student_idx on public.weekly_plan_routine_completions(student_id,plan_id,day_of_week,slot);
alter table public.weekly_plan_routine_completions enable row level security;
revoke all on public.weekly_plan_routine_completions from public, anon, authenticated;
grant select on public.weekly_plan_routine_completions to authenticated;
create policy routine_completions_read on public.weekly_plan_routine_completions for select to authenticated using (
 exists (select 1 from public.weekly_plans p where p.id=weekly_plan_routine_completions.plan_id and p.student_id=weekly_plan_routine_completions.student_id and p.status='published'
   and ((weekly_plan_routine_completions.student_id=(select auth.uid()) and (select private.current_user_role())='student')
    or ((select private.current_user_role())='counselor' and exists (select 1 from public.counselor_students a where a.student_id=p.student_id and a.counselor_id=(select auth.uid())))))
);

create function public.set_weekly_routine_progress(target_plan_id uuid, target_day integer, target_slot integer, target_subject text, target_details text, target_completed boolean)
returns void language plpgsql security definer set search_path='' as $$
declare me uuid := (select auth.uid()); p public.weekly_plans%rowtype; r jsonb; v_subject text; v_details text;
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role
   or not exists(select 1 from public.profiles where id=me and registration_status='active') then
   raise exception 'Active student required' using errcode='42501';
 end if;
 if target_plan_id is null or target_day is null or target_day not between 0 and 6 or target_slot is null or target_slot not in (1,2)
    or target_subject is null or target_details is null or target_completed is null then raise exception 'Invalid routine' using errcode='22023'; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(me::text,73033));
 select * into p from public.weekly_plans where id=target_plan_id and student_id=me and status='published' for update;
 if not found or p.week_start + target_day > timezone('Asia/Tehran',now())::date then raise exception 'Routine unavailable' using errcode='42501'; end if;
 -- A newer published plan takes over shared dates, but a draft does not.
 if exists(select 1 from public.weekly_plans newer where newer.student_id=me and newer.status='published' and newer.id<>p.id and newer.week_start>p.week_start and newer.week_start<=p.week_start+target_day) then
   raise exception 'Routine superseded' using errcode='40001';
 end if;
 select value into r from jsonb_array_elements(p.routines) value where value->>'dayOfWeek'=target_day::text limit 1;
 v_subject := coalesce(r->>case when target_slot=1 then 'subject' else 'secondSubject' end,'');
 v_details := coalesce(r->>case when target_slot=1 then 'details' else 'secondDetails' end,'');
 if (btrim(v_subject)='' and btrim(v_details)='') or v_subject is distinct from target_subject or v_details is distinct from target_details then
   raise exception 'Routine changed; reload' using errcode='40001';
 end if;
 if exists(select 1 from public.weekly_plan_routine_completions c where c.plan_id=p.id and c.day_of_week=target_day and c.slot=target_slot and (c.subject is distinct from v_subject or c.details is distinct from v_details)) then
  raise exception 'Routine completion conflicts with plan' using errcode='40001';
 end if;
 if target_completed then
  insert into public.weekly_plan_routine_completions(plan_id,student_id,day_of_week,slot,subject,details)
  values(p.id,me,target_day,target_slot,v_subject,v_details) on conflict(plan_id,day_of_week,slot) do nothing;
 else
  delete from public.weekly_plan_routine_completions where plan_id=p.id and student_id=me and day_of_week=target_day and slot=target_slot;
 end if;
end; $$;
revoke all on function public.set_weekly_routine_progress(uuid,integer,integer,text,text,boolean) from public, anon;
grant execute on function public.set_weekly_routine_progress(uuid,integer,integer,text,text,boolean) to authenticated;

-- A counselor cannot replace or delete a completed routine underneath a tick.
-- Plan writers may already hold the plan row, so never wait on the student
-- advisory lock here: fail and retry instead of deadlocking a student tick.
create function private.protect_completed_routines() returns trigger language plpgsql security definer set search_path='' as $$
declare c record; r jsonb; subject text; details text;
begin
 if not pg_catalog.pg_try_advisory_xact_lock(pg_catalog.hashtextextended((case when tg_op='INSERT' then new.student_id else old.student_id end)::text,73033)) then
  raise exception 'Student plan is busy; retry' using errcode='40001';
 end if;
 if tg_op='UPDATE' and new.student_id is distinct from old.student_id and not pg_catalog.pg_try_advisory_xact_lock(pg_catalog.hashtextextended(new.student_id::text,73033)) then
  raise exception 'Student plan is busy; retry' using errcode='40001';
 end if;
 if tg_op<>'DELETE' and new.status='published' and exists (
  select 1 from public.weekly_plans older join public.weekly_plan_routine_completions tick on tick.plan_id=older.id
  where older.id<>new.id and older.student_id=new.student_id and older.status='published'
    and older.week_start<new.week_start and older.week_start+tick.day_of_week>=new.week_start
 ) then raise exception 'A completed routine would be hidden by the new plan' using errcode='PZ003'; end if;
 if tg_op='INSERT' then return new; end if;
 for c in select * from public.weekly_plan_routine_completions where plan_id=old.id loop
  if tg_op='DELETE' then raise exception 'Completed routine is protected' using errcode='PZ003'; end if;
  if new.student_id is distinct from old.student_id or new.week_start is distinct from old.week_start or new.status is distinct from 'published'::public.content_status then
   raise exception 'Completed routine is protected' using errcode='PZ003';
  end if;
  select value into r from jsonb_array_elements(new.routines) value where value->>'dayOfWeek'=c.day_of_week::text limit 1;
  subject:=coalesce(r->>case when c.slot=1 then 'subject' else 'secondSubject' end,'');
  details:=coalesce(r->>case when c.slot=1 then 'details' else 'secondDetails' end,'');
  if subject is distinct from c.subject or details is distinct from c.details then raise exception 'Completed routine is protected' using errcode='PZ003'; end if;
 end loop;
 if tg_op='DELETE' then return old; end if;
 return new;
end; $$;
revoke all on function private.protect_completed_routines() from public,anon,authenticated;
create trigger protect_completed_routines before insert or update or delete on public.weekly_plans for each row execute function private.protect_completed_routines();
notify pgrst, 'reload schema';

-- Include routines in the existing authorized paged student projection.
create or replace function public.student_dashboard_page(page_offset integer default 0)
returns jsonb language plpgsql stable security invoker set search_path='' as $$
declare me uuid:=(select auth.uid()); active boolean; result jsonb;
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role then raise exception 'Student only' using errcode='42501'; end if;
 if page_offset is null or page_offset<0 then raise exception 'Invalid offset'; end if;
 select p.registration_status='active' into active from public.profiles p where p.id=me;
 if not coalesce(active,false) then
  return jsonb_build_object('student_id',me,'active',false,'plans','[]'::jsonb,'completions','[]'::jsonb,'has_more',false);
 end if;
 with selected as materialized (
  select p.id,p.title,p.week_start,p.notes,p.routines from public.weekly_plans p
  where p.student_id=me and p.status='published'
  order by p.week_start desc,p.id limit 201 offset page_offset
 ), page as materialized (
  select * from selected order by week_start desc,id limit 200
 )
 select jsonb_build_object(
  'student_id',me,'active',true,
  'plans',coalesce((select jsonb_agg(jsonb_build_object(
   'id',p.id,'title',p.title,'week_start',p.week_start,'notes',p.notes,'routines',p.routines,
   'weekly_plan_items',coalesce((select jsonb_agg(jsonb_build_object(
    'id',i.id,'plan_id',i.plan_id,'day_of_week',i.day_of_week,'duration_minutes',i.duration_minutes,
    'subject',i.subject,'chapter',i.chapter,'activity_type',i.activity_type,'target_test_count',i.target_test_count,
    'details',i.details,'recommended_publisher',i.recommended_publisher,'sort_order',i.sort_order,'source_grade',i.source_grade,
    'preparation_track',i.preparation_track,'exam_year',i.exam_year,
    'linked_exam_id',(select e.id from public.exams e where e.id=i.linked_exam_id and e.status='published' limit 1)
   ) order by i.sort_order,i.id) from public.weekly_plan_items i where i.plan_id=p.id),'[]'::jsonb)
  ) order by p.week_start desc,p.id) from page p),'[]'::jsonb),
  'completions',coalesce((select jsonb_agg(jsonb_build_object(
   'item_id',c.item_id,'completed_at',c.completed_at,'completed_test_count',c.completed_test_count,'completed_minutes',c.completed_minutes,'test_duration_recorded',c.test_duration_recorded
  ) order by c.item_id) from public.weekly_plan_item_completions c
  where c.student_id=me and exists(select 1 from public.weekly_plan_items i join page p on p.id=i.plan_id where i.id=c.item_id)),'[]'::jsonb),
  'has_more',(select count(*)>200 from selected)
 ) into result;
 return result;
end; $$;
revoke all on function public.student_dashboard_page(integer) from public,anon;
grant execute on function public.student_dashboard_page(integer) to authenticated;
notify pgrst, 'reload schema';
