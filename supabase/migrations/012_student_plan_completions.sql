create table public.weekly_plan_item_completions (
  item_id uuid primary key
    references public.weekly_plan_items(id) on delete cascade,
  student_id uuid not null
    references public.profiles(id) on delete cascade,
  completed_at timestamptz not null default now()
);

create index weekly_plan_completions_student_idx
on public.weekly_plan_item_completions(student_id, completed_at desc);

alter table public.weekly_plan_item_completions enable row level security;

drop policy "plan_participants_read" on public.weekly_plans;
create policy "plan_participants_read"
on public.weekly_plans
for select
to authenticated
using (
  counselor_id = (select auth.uid())
  or (
    student_id = (select auth.uid())
    and status = 'published'
  )
  or (select private.current_user_role()) = 'admin'
);

drop policy "plan_participants_read_items" on public.weekly_plan_items;
create policy "plan_participants_read_items"
on public.weekly_plan_items
for select
to authenticated
using (
  exists (
    select 1
    from public.weekly_plans plan
    where plan.id = weekly_plan_items.plan_id
      and (
        plan.counselor_id = (select auth.uid())
        or (
          plan.student_id = (select auth.uid())
          and plan.status = 'published'
        )
        or (select private.current_user_role()) = 'admin'
      )
  )
);

create policy "completion_participants_read"
on public.weekly_plan_item_completions
for select
to authenticated
using (
  student_id = (select auth.uid())
  or exists (
    select 1
    from public.weekly_plan_items item
    join public.weekly_plans plan on plan.id = item.plan_id
    where item.id = weekly_plan_item_completions.item_id
      and plan.counselor_id = (select auth.uid())
  )
  or (select private.current_user_role()) = 'admin'
);

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
    and plan.status = 'published';

  if target_student_id is null then
    raise exception 'Published plan item not found';
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

revoke all on function public.set_weekly_plan_item_completed(uuid, boolean)
from public, anon;

grant execute on function public.set_weekly_plan_item_completed(uuid, boolean)
to authenticated;