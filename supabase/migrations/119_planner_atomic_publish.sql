-- Publish an autosaved snapshot as a single transaction. The live plan is
-- changed only through the existing save RPC and all its protection checks.
create function public.planner_publish_working_draft(
  target_student_id uuid, target_week_start date, expected_revision text
) returns uuid language plpgsql security definer set search_path = '' as $$
declare
  me uuid := (select auth.uid());
  draft private.planner_working_drafts%rowtype;
  current_updated_at timestamptz;
  saved_id uuid;
begin
  perform private.require_planner_draft_access(target_student_id);
  if target_week_start is null or expected_revision is null or expected_revision !~ '^[1-9][0-9]{0,18}$' then
    raise exception 'Invalid draft' using errcode='22023';
  end if;
  -- The legacy v8/v9 path locks an existing plan row before the student lock.
  -- Keep that order, and acquire the assignment row after the student lock as
  -- the study-update path does, to avoid a lock-order cycle.
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(me::text || ':' || target_student_id::text || ':' || target_week_start::text, 73418));
  select * into draft from private.planner_working_drafts d
  where d.counselor_id=me and d.student_id=target_student_id and d.week_start=target_week_start for update;
  if not found or draft.revision::text <> expected_revision then
    raise exception 'Draft has changed' using errcode='40001';
  end if;
  if draft.plan_id is not null then
    select p.updated_at into current_updated_at from public.weekly_plans p
    where p.id=draft.plan_id and p.counselor_id=me and p.student_id=target_student_id and p.week_start=target_week_start for update;
    if not found or current_updated_at is distinct from draft.base_plan_updated_at then
      raise exception 'Published plan has changed' using errcode='40001';
    end if;
  end if;
  -- Older save endpoints take the student lock before the plan row, whereas
  -- v8/v9 take the plan row first. Never wait while holding a plan row: if an
  -- older writer holds this lock, abort safely instead of forming a deadlock.
  if not pg_catalog.pg_try_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text, 73033)) then
    raise exception 'Student plan is busy; retry publication' using errcode='40001';
  end if;
  perform 1 from public.counselor_students where counselor_id=me and student_id=target_student_id for update;
  if not found then raise exception 'Student not available' using errcode='42501'; end if;
  perform private.require_planner_draft_access(target_student_id);
  if draft.plan_id is null and exists (select 1 from public.weekly_plans p where p.counselor_id=me and p.student_id=target_student_id and p.week_start=target_week_start) then
    raise exception 'Plan has changed' using errcode='40001';
  end if;

  -- Drafts may be incomplete while editing. Reject malformed snapshots instead
  -- of silently dropping any data, and let v9 validate the complete plan.
  if jsonb_typeof(draft.snapshot->'title') is distinct from 'string'
     or jsonb_typeof(draft.snapshot->'notes') is distinct from 'string'
     or jsonb_typeof(draft.snapshot->'items') is distinct from 'array'
     or jsonb_typeof(draft.snapshot->'routines') is distinct from 'array' then
    raise exception 'Draft is incomplete' using errcode='22023';
  end if;
  saved_id := public.save_weekly_plan_v9(
    draft.plan_id, target_student_id, target_week_start,
    draft.snapshot->>'title', draft.snapshot->>'notes', 'published'::public.content_status,
    draft.snapshot->'items', draft.snapshot->'routines'
  );
  -- Optional rich metadata is installed in migration 122. Store it in the same
  -- transaction as the legacy plan; any mapping/validation failure rolls both back.
  if draft.snapshot ? 'extras' then
    perform private.planner_persist_published_extras(saved_id,draft.snapshot->'items',draft.snapshot->'extras');
  end if;
  delete from private.planner_working_drafts d where d.counselor_id=me and d.student_id=target_student_id
    and d.week_start=target_week_start and d.revision::text=expected_revision;
  if not found then raise exception 'Draft has changed' using errcode='40001'; end if;
  return saved_id;
end; $$;
revoke all on function public.planner_publish_working_draft(uuid,date,text) from public, anon;
grant execute on function public.planner_publish_working_draft(uuid,date,text) to authenticated;
notify pgrst, 'reload schema';
