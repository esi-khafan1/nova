create or replace function public.set_weekly_plan_item_completed(
  target_item_id uuid,
  target_completed boolean
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_student_id uuid;
  tehran_today date := timezone('Asia/Tehran', now())::date;
begin
  if (select private.current_user_role())
    is distinct from 'student'::public.app_role
  then
    raise exception 'Only students can update plan progress';
  end if;

  select plan.student_id
  into target_student_id
  from public.weekly_plan_items item
  join public.weekly_plans plan on plan.id = item.plan_id
  where item.id = target_item_id
    and plan.student_id = (select auth.uid())
    and plan.status = 'published'
    and plan.week_start + item.day_of_week = tehran_today;

  if target_student_id is null then
    raise exception 'Only today''s published plan items can be updated';
  end if;

  if target_completed then
    insert into public.weekly_plan_item_completions (
      item_id,
      student_id,
      completed_at
    )
    values (
      target_item_id,
      target_student_id,
      now()
    )
    on conflict (item_id) do nothing;
  else
    delete from public.weekly_plan_item_completions
    where item_id = target_item_id
      and student_id = target_student_id;
  end if;
end;
$$;