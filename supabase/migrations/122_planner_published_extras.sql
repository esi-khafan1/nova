-- Optional published metadata lives separately from Nova's existing plan rows.
-- It is written only inside the same transaction as draft publication; private
-- working copies never appear here, and old plans remain valid without extras.
create table private.planner_week_extras (
  plan_id uuid primary key references public.weekly_plans(id) on delete cascade,
  data jsonb not null check (jsonb_typeof(data)='object')
);
create table private.planner_item_extras (
  item_id uuid primary key references public.weekly_plan_items(id) on delete cascade,
  data jsonb not null check (jsonb_typeof(data)='object')
);
revoke all on private.planner_week_extras, private.planner_item_extras from public,anon,authenticated;

-- Old editors do not know about topic/action metadata. If they change an
-- activity's identity, remove its old extra rather than displaying stale data.
create function private.planner_forget_changed_item_extras()
returns trigger language plpgsql security definer set search_path='' as $$
begin
 if (new.subject,new.chapter,new.day_of_week,new.activity_type)
    is distinct from (old.subject,old.chapter,old.day_of_week,old.activity_type) then
  delete from private.planner_item_extras where item_id=old.id;
 end if;
 return new;
end; $$;
revoke all on function private.planner_forget_changed_item_extras() from public,anon,authenticated;
create trigger planner_forget_changed_item_extras after update on public.weekly_plan_items
for each row execute function private.planner_forget_changed_item_extras();

-- Item extras are aligned with the submitted v9 items. The legacy saver sets
-- sort_order to the submitted position; matching by both day and sort_order
-- allows older past days to stay intact. Require exactly one match, or abort
-- the entire publication rather than associating topics with the wrong block.
create function private.planner_persist_published_extras(target_plan_id uuid,target_items jsonb,target_extras jsonb)
returns void language plpgsql security definer set search_path='' as $$
declare idx bigint; item jsonb; extra jsonb; matched uuid; match_count integer;
begin
 if target_plan_id is null or jsonb_typeof(target_items) is distinct from 'array'
  or jsonb_typeof(target_extras) is distinct from 'object'
  or jsonb_typeof(target_extras->'week') is distinct from 'object'
  or jsonb_typeof(target_extras->'items') is distinct from 'array'
  or jsonb_array_length(target_items) <> jsonb_array_length(target_extras->'items')
  or octet_length(target_extras::text)>200000
 then raise exception 'Invalid plan extras' using errcode='22023'; end if;
 if not exists(select 1 from public.weekly_plans p where p.id=target_plan_id and p.counselor_id=(select auth.uid()) and p.status='published'::public.content_status) then
  raise exception 'Plan not available' using errcode='42501';
 end if;
 if exists(select 1 from jsonb_array_elements(target_extras->'items') x(value)
  where jsonb_typeof(x.value) not in ('object','null')) then
  raise exception 'Invalid item extras' using errcode='22023';
 end if;
 insert into private.planner_week_extras(plan_id,data) values(target_plan_id,target_extras->'week')
 on conflict(plan_id) do update set data=excluded.data;
 for idx,item in select ordinality-1,value from jsonb_array_elements(target_items) with ordinality as x(value,ordinality) loop
  extra := target_extras->'items'->idx::integer;
  select count(*)::integer,(array_agg(i.id))[1] into match_count,matched from public.weekly_plan_items i
  where i.plan_id=target_plan_id and i.sort_order=idx and i.day_of_week=(item->>'dayOfWeek')::smallint;
  if match_count<>1 then raise exception 'Cannot match published activity extras' using errcode='40001'; end if;
  -- A ticked activity is immutable in the legacy editor; extending its visible
  -- topic/action metadata must not allow that protection to be bypassed.
  if exists(select 1 from public.weekly_plan_item_completions c where c.item_id=matched)
    and extra is distinct from coalesce((select e.data from private.planner_item_extras e where e.item_id=matched),'null'::jsonb) then
    raise exception 'Completed plan activity cannot be changed' using errcode='PZ001';
  end if;
  if jsonb_typeof(extra)='null' then
    delete from private.planner_item_extras where item_id=matched;
  else
    insert into private.planner_item_extras(item_id,data) values(matched,extra)
    on conflict(item_id) do update set data=excluded.data;
  end if;
 end loop;
end; $$;
revoke all on function private.planner_persist_published_extras(uuid,jsonb,jsonb) from public,anon,authenticated;

-- Published metadata has the same audience as the review schedule: the active
-- student or their currently assigned, approved counselor. Never return drafts.
create function public.planner_get_published_extras(target_plan_id uuid)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare student uuid; result jsonb;
begin
 select p.student_id into student from public.weekly_plans p
 where p.id=target_plan_id and p.status='published'::public.content_status;
 if student is null then raise exception 'Plan not available' using errcode='42501'; end if;
 perform private.require_planner_review_access(student);
 select jsonb_build_object(
  'week',coalesce((select e.data from private.planner_week_extras e where e.plan_id=target_plan_id),'{}'::jsonb),
  'items',coalesce((select jsonb_object_agg(i.id::text,e.data) from public.weekly_plan_items i
    join private.planner_item_extras e on e.item_id=i.id where i.plan_id=target_plan_id),'{}'::jsonb)) into result;
 return result;
end; $$;
revoke all on function public.planner_get_published_extras(uuid) from public,anon;
grant execute on function public.planner_get_published_extras(uuid) to authenticated;
notify pgrst, 'reload schema';
