-- A newer plan may start in the trailing days of an earlier plan only when
-- the earlier plan has no activity boxes on or after that start. Routines do
-- not reserve a day. Drafts reserve their dates for editing but never alter
-- what the student sees until they are published.
create or replace function private.prevent_plan_window_overlap()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if new.status not in ('draft'::public.content_status, 'published'::public.content_status) then return new; end if;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(new.student_id::text,73033));
  if TG_OP = 'UPDATE' and new.student_id = old.student_id and new.week_start = old.week_start
    and old.status in ('draft'::public.content_status, 'published'::public.content_status) then
    return new;
  end if;
  if exists (
    select 1 from public.weekly_plans p
    where p.student_id = new.student_id and p.id <> new.id
      and p.status in ('draft'::public.content_status, 'published'::public.content_status)
      and p.week_start <= new.week_start + 6 and p.week_start + 6 >= new.week_start
      and (
        p.week_start = new.week_start
        or (p.week_start < new.week_start and exists (
          select 1 from public.weekly_plan_items i
          where i.plan_id = p.id and p.week_start + i.day_of_week >= new.week_start
        ))
        or (p.week_start > new.week_start and exists (
          select 1 from public.weekly_plan_items i
          where i.plan_id = new.id and new.week_start + i.day_of_week >= p.week_start
        ))
      )
  ) then raise exception 'Plan overlaps a day with an existing activity' using errcode='23P01'; end if;
  return new;
end; $$;

-- Check boxes as well as plan windows: an older plan must not be edited to
-- add a box into a day already reserved by a newer draft or published plan.
create or replace function private.prevent_plan_item_overlap()
returns trigger language plpgsql security definer set search_path = '' as $$
declare owner_plan public.weekly_plans%rowtype;
begin
  select * into owner_plan from public.weekly_plans where id = new.plan_id;
  if not found or owner_plan.status not in ('draft'::public.content_status, 'published'::public.content_status) then return new; end if;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(owner_plan.student_id::text,73033));
  if exists (
    select 1 from public.weekly_plans p
    where p.student_id = owner_plan.student_id and p.id <> owner_plan.id
      and p.status in ('draft'::public.content_status, 'published'::public.content_status)
      and p.week_start > owner_plan.week_start and p.week_start <= owner_plan.week_start + 6
      and owner_plan.week_start + new.day_of_week >= p.week_start
  ) then raise exception 'Plan activity overlaps a newer plan' using errcode='23P01'; end if;
  return new;
end; $$;
revoke all on function private.prevent_plan_item_overlap() from public,anon,authenticated;
create trigger weekly_plan_items_no_new_overlap
  before insert or update of plan_id,day_of_week on public.weekly_plan_items
  for each row execute function private.prevent_plan_item_overlap();
