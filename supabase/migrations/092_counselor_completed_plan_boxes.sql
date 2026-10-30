-- Authoritative completion flags for the counselor's current-day plan editor.
-- Never treat a missing/hidden nested relation as "not completed".
create function public.counselor_completed_plan_item_ids()
returns table(item_id uuid)
language plpgsql stable security definer set search_path = '' as $$
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then
    raise exception 'Only counselors can view completion flags' using errcode = '42501';
  end if;
  return query
  select c.item_id
  from public.weekly_plan_item_completions c
  join public.weekly_plan_items i on i.id = c.item_id
  join public.weekly_plans p on p.id = i.plan_id
  join public.counselor_students a on a.student_id = p.student_id
    and a.counselor_id = (select auth.uid())
  where p.counselor_id = (select auth.uid())
    and p.status = 'published'::public.content_status
    and p.week_start + i.day_of_week = timezone('Asia/Tehran', now())::date;
end; $$;
revoke all on function public.counselor_completed_plan_item_ids() from public, anon;
grant execute on function public.counselor_completed_plan_item_ids() to authenticated;
notify pgrst, 'reload schema';
