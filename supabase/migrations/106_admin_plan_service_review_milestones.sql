-- Keep a multiple-of-four review pending until an administrator decides, even
-- if the counselor has already published the following plan. The pending
-- milestone is the greatest multiple of four not beyond the published count.
drop function if exists public.admin_student_plan_service_reviews();

create function public.admin_student_plan_service_reviews()
returns table (
  student_id uuid,
  published_plan_count integer,
  review_plan_count integer,
  latest_week_start date,
  latest_plan_updated_at timestamptz
)
language plpgsql stable security definer set search_path='' as $$
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only';
  end if;

  return query
  with published as (
    select
      p.student_id,
      count(*)::integer as plan_count,
      (count(*)::integer / 4) * 4 as review_count,
      max(p.week_start) as latest_week_start,
      max(p.updated_at) as latest_plan_updated_at
    from public.weekly_plans p
    join public.profiles student
      on student.id = p.student_id
      and student.role = 'student'
      and student.registration_status = 'active'
    where p.status = 'published'::public.content_status
    group by p.student_id
  )
  select
    published.student_id,
    published.plan_count,
    published.review_count,
    published.latest_week_start,
    published.latest_plan_updated_at
  from published
  where published.review_count >= 4
    and not exists (
      select 1
      from private.student_service_events event
      where event.student_id = published.student_id
        and event.event_type = 'plan_review_continued'
        and event.plan_review_plan_count = published.review_count
    )
  order by published.latest_plan_updated_at desc, published.student_id;
end;
$$;

create or replace function public.admin_continue_student_plan_service_review(
  target_student_id uuid,
  expected_plan_count integer
) returns void language plpgsql security definer set search_path='' as $$
declare current_plan_count integer; current_review_count integer;
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only';
  end if;
  if expected_plan_count is null or expected_plan_count < 4 or expected_plan_count % 4 <> 0 then
    raise exception 'Plan review milestone required';
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(target_student_id::text, 73034)
  );
  perform 1 from public.profiles
  where id = target_student_id
    and role = 'student'
    and registration_status = 'active'
  for update;
  if not found then raise exception 'Active student required'; end if;

  select count(*)::integer into current_plan_count
  from public.weekly_plans
  where student_id = target_student_id
    and status = 'published'::public.content_status;
  current_review_count := (current_plan_count / 4) * 4;
  if current_review_count is distinct from expected_plan_count then
    raise exception 'Published plan milestone changed; refresh';
  end if;
  if exists (
    select 1 from private.student_service_events
    where student_id = target_student_id
      and event_type = 'plan_review_continued'
      and plan_review_plan_count = expected_plan_count
  ) then
    raise exception 'Plan review already recorded; refresh';
  end if;

  insert into private.student_service_events(
    student_id, admin_id, event_type, plan_review_plan_count
  ) values (
    target_student_id, (select auth.uid()), 'plan_review_continued', expected_plan_count
  );
end;
$$;

revoke all on function public.admin_student_plan_service_reviews() from public, anon;
revoke all on function public.admin_continue_student_plan_service_review(uuid, integer) from public, anon;
grant execute on function public.admin_student_plan_service_reviews() to authenticated;
grant execute on function public.admin_continue_student_plan_service_review(uuid, integer) to authenticated;

notify pgrst, 'reload schema';
