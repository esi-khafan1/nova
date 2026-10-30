-- Completed activities keep their content and progress even if a stale form or
-- older save endpoint submits changes. Reordering (sort_order) and the exam
-- designer's link bookkeeping are separate from the completed activity content.
create function private.protect_completed_plan_item() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  -- Leave trusted maintenance and account-deletion cascades untouched.
  if (select private.current_user_role()) = 'counselor'::public.app_role
    and exists (select 1 from public.weekly_plan_item_completions c where c.item_id = old.id) then
    if TG_OP = 'DELETE' then
      raise exception 'Completed plan activity cannot be changed or removed' using errcode = 'PZ001';
    end if;
    if (new.plan_id, new.day_of_week, new.start_time, new.duration_minutes,
       new.subject, new.chapter, new.activity_type, new.target_test_count,
       new.details, new.source_grade, new.preparation_track, new.exam_year,
       new.recommended_publisher) is distinct from
      (old.plan_id, old.day_of_week, old.start_time, old.duration_minutes,
       old.subject, old.chapter, old.activity_type, old.target_test_count,
       old.details, old.source_grade, old.preparation_track, old.exam_year,
       old.recommended_publisher)
    then
      raise exception 'Completed plan activity cannot be changed or removed' using errcode = 'PZ001';
    end if;
  end if;
  if TG_OP = 'DELETE' then return old; end if;
  return new;
end; $$;
revoke all on function private.protect_completed_plan_item() from public, anon, authenticated;
create trigger protect_completed_plan_item before update or delete on public.weekly_plan_items
for each row execute function private.protect_completed_plan_item();

-- A counselor may explicitly remove an exam-linked box TODAY. Remove the box
-- before v5 snapshots its links, otherwise v5 could reattach that exam to a
-- different box with the same subject/chapter. Only the owner of this exact
-- published plan can do this; the save remains atomic. Old v7 callers retain
-- their previous behavior until their UI is deployed.
create function public.save_weekly_plan_v8(
  target_plan_id uuid, target_student_id uuid, target_week_start date,
  target_title text, target_notes text, target_status public.content_status,
  target_items jsonb, target_routines jsonb
) returns uuid language plpgsql security definer set search_path = '' as $$
declare original_status public.content_status;
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then
    raise exception 'Only counselors can save plans';
  end if;
  if target_plan_id is not null then
    select p.status into original_status from public.weekly_plans p
    where p.id = target_plan_id and p.counselor_id = (select auth.uid())
      and p.student_id = target_student_id and p.week_start = target_week_start
    for update;
  end if;
  if original_status = 'published'::public.content_status and jsonb_typeof(target_items) = 'array' then
    perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text, 73033));
    delete from public.weekly_plan_items i
    where i.plan_id = target_plan_id
      and target_week_start + i.day_of_week = timezone('Asia/Tehran', now())::date
      and i.linked_exam_id is not null
      and not exists (
        select 1 from jsonb_array_elements(target_items) submitted
        where submitted.value->>'id' = i.id::text
          and (submitted.value->>'dayOfWeek')::smallint = i.day_of_week
      )
      and not exists (select 1 from public.weekly_plan_item_completions c where c.item_id = i.id);
  end if;
  return public.save_weekly_plan_v7(
    target_plan_id, target_student_id, target_week_start,
    target_title, target_notes, target_status, target_items, target_routines
  );
end; $$;
revoke all on function public.save_weekly_plan_v8(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) from public, anon;
grant execute on function public.save_weekly_plan_v8(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) to authenticated;
notify pgrst, 'reload schema';
