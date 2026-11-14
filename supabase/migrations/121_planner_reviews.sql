-- Review checkmarks belong to a published item and disappear with that item.
-- They never alter the legacy activity-completion or exam records.
create table private.planner_review_completions (
  item_id uuid not null references public.weekly_plan_items(id) on delete cascade,
  review_offset smallint not null check (review_offset in (1,3,7)),
  completed_at timestamptz not null default now(),
  primary key(item_id,review_offset)
);
revoke all on private.planner_review_completions from public,anon,authenticated;

-- Accessible to the student and the currently assigned approved counselor.
-- An inactive student, former counselor, unrelated user or admin is rejected.
create function private.require_planner_review_access(target_student_id uuid)
returns void language plpgsql security definer set search_path='' as $$
declare me uuid := (select auth.uid());
begin
 if not exists(select 1 from public.profiles where id=target_student_id and role='student' and registration_status='active')
   or not coalesce((me=target_student_id and (select private.current_user_role())='student'::public.app_role)
     or ((select private.current_user_role())='counselor'::public.app_role
       and exists(select 1 from public.counselor_profiles where user_id=me and approval_status='approved')
       and exists(select 1 from public.counselor_students where counselor_id=me and student_id=target_student_id)),false)
 then raise exception 'Student not available' using errcode='42501'; end if;
end; $$;
revoke all on function private.require_planner_review_access(uuid) from public,anon,authenticated;

create function public.planner_review_week(target_student_id uuid,target_week_start date)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare result jsonb;
begin
 perform private.require_planner_review_access(target_student_id);
 if target_week_start is null then raise exception 'Invalid date' using errcode='22023'; end if;
 select coalesce(jsonb_agg(jsonb_build_object(
  'item_id',i.id,'plan_id',p.id,'source_week_start',p.week_start,'source_day',i.day_of_week,
  'due_date',p.week_start+i.day_of_week+o.days,'offset',o.days,'subject',i.subject,'chapter',i.chapter,
  'completed',c.item_id is not null) order by p.week_start+i.day_of_week+o.days,i.subject,i.id,o.days),'[]'::jsonb)
 into result from public.weekly_plans p
 join public.weekly_plan_items i on i.plan_id=p.id
 cross join (values (1),(3),(7)) o(days)
 left join private.planner_review_completions c on c.item_id=i.id and c.review_offset=o.days
 where p.student_id=target_student_id and p.status='published'::public.content_status
  and p.week_start between target_week_start-13 and target_week_start+5
  and i.activity_type::text not in ('exam','simulation_exam','external_simulation_exam','makeup')
  and p.week_start+i.day_of_week+o.days between target_week_start and target_week_start+6;
 return result;
end; $$;
revoke all on function public.planner_review_week(uuid,date) from public,anon;
grant execute on function public.planner_review_week(uuid,date) to authenticated;

create function public.planner_set_review_completed(target_item_id uuid,target_offset integer,target_completed boolean)
returns void language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid());
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role then
  raise exception 'Only students can update review progress' using errcode='42501'; end if;
 if target_item_id is null or target_completed is null or target_offset is null or target_offset not in (1,3,7) then
  raise exception 'Invalid review' using errcode='22023'; end if;
 perform private.require_planner_review_access(me);
 -- Shared with progress and plan publication; makes validation and update atomic.
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(me::text,73033));
 perform private.require_planner_review_access(me);
 perform 1 from public.weekly_plan_items i join public.weekly_plans p on p.id=i.plan_id
 where i.id=target_item_id and p.student_id=me and p.status='published'::public.content_status
   and i.activity_type::text not in ('exam','simulation_exam','external_simulation_exam','makeup');
 if not found then raise exception 'Review not available' using errcode='42501'; end if;
 if target_completed then
  insert into private.planner_review_completions(item_id,review_offset) values(target_item_id,target_offset)
  on conflict(item_id,review_offset) do nothing;
 else
  delete from private.planner_review_completions where item_id=target_item_id and review_offset=target_offset;
 end if;
end; $$;
revoke all on function public.planner_set_review_completed(uuid,integer,boolean) from public,anon;
grant execute on function public.planner_set_review_completed(uuid,integer,boolean) to authenticated;
notify pgrst, 'reload schema';
