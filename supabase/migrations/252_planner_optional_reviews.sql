-- New review scheduling is additive: old clients keep their existing RPCs and
-- existing review/tick records remain untouched during the web rollout.
-- A first tick must survive unticking and later corrections to the duration.
create table private.planner_first_item_ticks (
  item_id uuid primary key,
  student_id uuid not null references public.profiles(id) on delete cascade,
  first_checked_at timestamptz not null
);
create index planner_first_item_ticks_student on private.planner_first_item_ticks(student_id);
revoke all on private.planner_first_item_ticks from public, anon, authenticated;

-- Serialize the initial snapshot with live ticks until the trigger is installed;
-- otherwise a tick committed between backfill and trigger creation is missed.
lock table public.weekly_plan_item_completions in share row exclusive mode;
lock table private.planner_item_extras in share row exclusive mode;
do $$ begin
 if exists(select 1 from private.planner_item_extras where data ? 'review') then
  raise exception 'Existing review metadata needs inspection before rollout';
 end if;
end $$;
-- Existing checked_at is the earliest still-recorded tick. Earlier removed
-- ticks cannot be reconstructed; no legacy item gets a review setting here.
insert into private.planner_first_item_ticks(item_id,student_id,first_checked_at)
select item_id,student_id,coalesce(checked_at,completed_at) from public.weekly_plan_item_completions
on conflict (item_id) do nothing;

create function private.planner_capture_first_item_tick() returns trigger
language plpgsql security definer set search_path='' as $$
begin
 insert into private.planner_first_item_ticks(item_id,student_id,first_checked_at)
 values(new.item_id,new.student_id,coalesce(new.checked_at,new.completed_at,now()))
 on conflict(item_id) do nothing;
 return new;
end; $$;
revoke all on function private.planner_capture_first_item_tick() from public,anon,authenticated;
create trigger planner_capture_first_item_tick after insert on public.weekly_plan_item_completions
for each row execute function private.planner_capture_first_item_tick();

-- v2 marks are separate from the legacy schedule and are never copied to a
-- different activity. No destructive cascade removes their historical record.
create table private.planner_review_v2_completions (
 item_id uuid primary key,
 student_id uuid not null references public.profiles(id) on delete cascade,
 completed_at timestamptz not null default now()
);
create index planner_review_v2_completions_student on private.planner_review_v2_completions(student_id);
revoke all on private.planner_review_v2_completions from public,anon,authenticated;

create function private.planner_validate_review_setting() returns trigger
language plpgsql security definer set search_path='' as $$
declare r jsonb;
begin
 r:=new.data->'review';
 if r is null then return new; end if;
 if jsonb_typeof(r) is distinct from 'object'
   or jsonb_typeof(r->'offset') is distinct from 'number'
   or r->>'offset' not in ('3','7','30')
   or jsonb_typeof(r->'kind') is distinct from 'string'
   or r->>'kind' not in ('general','specialist')
   or jsonb_typeof(r->'reading') is distinct from 'boolean'
   or jsonb_typeof(r->'practice') is distinct from 'boolean'
   or not ((r->>'reading')::boolean or (r->>'practice')::boolean)
   or (select count(*) from jsonb_object_keys(r)) <> 4
 then raise exception 'Invalid review setting' using errcode='22023'; end if;
 return new;
end; $$;
revoke all on function private.planner_validate_review_setting() from public,anon,authenticated;
create trigger planner_validate_review_setting before insert or update on private.planner_item_extras
for each row execute function private.planner_validate_review_setting();

-- Students and their approved assigned counselor can view only today's due
-- reviews. Previously generated 1/3/7-day entries remain stored separately.
create function public.planner_review_today_v2(target_student_id uuid)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare result jsonb; today date:=timezone('Asia/Tehran',now())::date;
begin
 perform private.require_planner_review_access(target_student_id);
 select coalesce(jsonb_agg(jsonb_build_object(
  'item_id',i.id,'plan_id',p.id,'due_date',today,'offset',(e.data->'review'->>'offset')::int,
  'subject',i.subject,'chapter',i.chapter,'topics',coalesce(e.data->'topics','[]'::jsonb),
  'review',e.data->'review','completed',v.item_id is not null
 ) order by i.subject,i.id),'[]'::jsonb) into result
 from public.weekly_plans p
 join public.weekly_plan_items i on i.plan_id=p.id
 join public.weekly_plan_item_completions c on c.item_id=i.id and c.student_id=p.student_id
 join private.planner_first_item_ticks f on f.item_id=i.id and f.student_id=p.student_id
 join private.planner_item_extras e on e.item_id=i.id
 left join private.planner_review_v2_completions v on v.item_id=i.id and v.student_id=p.student_id
 where p.student_id=target_student_id and p.status='published'::public.content_status
  and i.activity_type::text not in ('external_simulation_exam','makeup')
  and jsonb_typeof(e.data->'review')='object'
  and e.data->'review'->>'offset' in ('3','7','30')
  and (timezone('Asia/Tehran',f.first_checked_at)::date + (e.data->'review'->>'offset')::integer)=today;
 return result;
end; $$;
revoke all on function public.planner_review_today_v2(uuid) from public,anon;
grant execute on function public.planner_review_today_v2(uuid) to authenticated;

create function public.planner_set_review_today_v2(target_item_id uuid,target_completed boolean)
returns void language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid());
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role then raise exception 'Only students' using errcode='42501'; end if;
 if target_item_id is null or target_completed is null then raise exception 'Invalid review' using errcode='22023'; end if;
 perform private.require_planner_review_access(me);
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(me::text,73033));
 perform private.require_planner_review_access(me);
 if not exists(select 1 from jsonb_array_elements(public.planner_review_today_v2(me)) r where r->>'item_id'=target_item_id::text) then
  raise exception 'Review not available today' using errcode='42501';
 end if;
 if target_completed then
  insert into private.planner_review_v2_completions(item_id,student_id) values(target_item_id,me)
  on conflict(item_id) do nothing;
 else
  delete from private.planner_review_v2_completions where item_id=target_item_id and student_id=me;
 end if;
end; $$;
revoke all on function public.planner_set_review_today_v2(uuid,boolean) from public,anon;
grant execute on function public.planner_set_review_today_v2(uuid,boolean) to authenticated;
notify pgrst, 'reload schema';
