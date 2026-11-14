-- Isolated working copies for the new planner. Saving here never changes a
-- weekly plan, its published items, progress or exam links. Publication must
-- separately validate the base plan and use the existing protected save path.
create table private.planner_working_drafts (
  counselor_id uuid not null references public.profiles(id) on delete cascade,
  student_id uuid not null references public.profiles(id) on delete cascade,
  week_start date not null,
  plan_id uuid references public.weekly_plans(id) on delete cascade,
  base_plan_updated_at timestamptz,
  snapshot jsonb not null,
  revision bigint not null default 1 check (revision > 0),
  updated_at timestamptz not null default now(),
  primary key (counselor_id, student_id, week_start),
  check (jsonb_typeof(snapshot) = 'object'),
  check (octet_length(snapshot::text) <= 200000),
  check ((plan_id is null) = (base_plan_updated_at is null))
);
revoke all on private.planner_working_drafts from public, anon, authenticated;

create function private.require_planner_draft_access(target_student_id uuid)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role
    or not exists (select 1 from public.counselor_profiles cp where cp.user_id = (select auth.uid()) and cp.approval_status = 'approved')
    or not exists (select 1 from public.counselor_students cs where cs.counselor_id = (select auth.uid()) and cs.student_id = target_student_id)
    or not exists (select 1 from public.profiles p where p.id = target_student_id and p.role = 'student' and p.registration_status = 'active')
  then raise exception 'Student not available' using errcode = '42501'; end if;
end; $$;
revoke all on function private.require_planner_draft_access(uuid) from public, anon, authenticated;

create function public.planner_get_working_draft(target_student_id uuid, target_week_start date)
returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare result jsonb;
begin
  perform private.require_planner_draft_access(target_student_id);
  if target_week_start is null then raise exception 'Invalid date' using errcode='22023'; end if;
  select jsonb_build_object('plan_id', d.plan_id, 'base_plan_updated_at', d.base_plan_updated_at,
    'snapshot', d.snapshot, 'revision', d.revision::text, 'updated_at', d.updated_at)
  into result from private.planner_working_drafts d
  where d.counselor_id = (select auth.uid()) and d.student_id = target_student_id and d.week_start = target_week_start;
  return result;
end; $$;
revoke all on function public.planner_get_working_draft(uuid,date) from public, anon;
grant execute on function public.planner_get_working_draft(uuid,date) to authenticated;

create function public.planner_save_working_draft(target_student_id uuid, target_week_start date,
  target_plan_id uuid, target_snapshot jsonb, expected_revision text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare me uuid := (select auth.uid()); current_draft private.planner_working_drafts%rowtype; base_time timestamptz;
begin
  perform private.require_planner_draft_access(target_student_id);
  if target_week_start is null or target_snapshot is null or jsonb_typeof(target_snapshot) <> 'object'
    or octet_length(target_snapshot::text) > 200000
    or (expected_revision is not null and expected_revision !~ '^[1-9][0-9]{0,18}$')
  then raise exception 'Invalid draft' using errcode='22023'; end if;
  -- Serialize draft creation, updates and deletion for this exact context.
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(me::text || ':' || target_student_id::text || ':' || target_week_start::text, 73418));
  -- Recheck assignment after acquiring a lock on the assignment row.
  perform 1 from public.counselor_students where counselor_id = me and student_id = target_student_id for update;
  if not found then raise exception 'Student not available' using errcode='42501'; end if;
  perform private.require_planner_draft_access(target_student_id);
  select * into current_draft from private.planner_working_drafts d
  where d.counselor_id = me and d.student_id = target_student_id and d.week_start = target_week_start for update;
  if found then
    if expected_revision is distinct from current_draft.revision::text or target_plan_id is distinct from current_draft.plan_id
    then raise exception 'Draft has changed' using errcode='40001'; end if;
    update private.planner_working_drafts d set snapshot = target_snapshot, revision = d.revision + 1, updated_at = now()
    where d.counselor_id = me and d.student_id = target_student_id and d.week_start = target_week_start
    returning * into current_draft;
  else
    if expected_revision is not null then raise exception 'Draft has changed' using errcode='40001'; end if;
    if target_plan_id is not null then
      select p.updated_at into base_time from public.weekly_plans p
      where p.id = target_plan_id and p.counselor_id = me and p.student_id = target_student_id and p.week_start = target_week_start;
      if not found then raise exception 'Plan not available' using errcode='42501'; end if;
    elsif exists (select 1 from public.weekly_plans p where p.counselor_id = me and p.student_id = target_student_id and p.week_start = target_week_start) then
      raise exception 'Open the existing plan' using errcode='40001';
    end if;
    insert into private.planner_working_drafts(counselor_id,student_id,week_start,plan_id,base_plan_updated_at,snapshot)
    values(me,target_student_id,target_week_start,target_plan_id,base_time,target_snapshot) returning * into current_draft;
  end if;
  return jsonb_build_object('revision',current_draft.revision::text,'updated_at',current_draft.updated_at,
    'base_plan_updated_at',current_draft.base_plan_updated_at);
end; $$;
revoke all on function public.planner_save_working_draft(uuid,date,uuid,jsonb,text) from public, anon;
grant execute on function public.planner_save_working_draft(uuid,date,uuid,jsonb,text) to authenticated;

create function public.planner_discard_working_draft(target_student_id uuid, target_week_start date, expected_revision text)
returns void language plpgsql security definer set search_path = '' as $$
declare me uuid := (select auth.uid());
begin
  perform private.require_planner_draft_access(target_student_id);
  if target_week_start is null or expected_revision is null then raise exception 'Invalid draft' using errcode='22023'; end if;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(me::text || ':' || target_student_id::text || ':' || target_week_start::text, 73418));
  perform 1 from public.counselor_students where counselor_id = me and student_id = target_student_id for update;
  if not found then raise exception 'Student not available' using errcode='42501'; end if;
  perform private.require_planner_draft_access(target_student_id);
  delete from private.planner_working_drafts d where d.counselor_id = me and d.student_id = target_student_id
    and d.week_start = target_week_start and d.revision::text = expected_revision;
  if not found then raise exception 'Draft has changed' using errcode='40001'; end if;
end; $$;
revoke all on function public.planner_discard_working_draft(uuid,date,text) from public, anon;
grant execute on function public.planner_discard_working_draft(uuid,date,text) to authenticated;
notify pgrst, 'reload schema';
