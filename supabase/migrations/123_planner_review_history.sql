-- Preserve review history when a legacy editor replaces or changes its source
-- item. The archive is private and contains only already-recorded reviews.
create table private.planner_review_history (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  source_item_id uuid not null,
  review_offset smallint not null check (review_offset in (1,3,7)),
  due_date date not null,
  subject text not null,
  chapter text,
  topics jsonb not null default '[]'::jsonb,
  completed boolean not null default true,
  completed_at timestamptz not null
);
create index planner_review_history_student_date on private.planner_review_history(student_id,due_date);
revoke all on private.planner_review_history from public,anon,authenticated;

-- Called only by private triggers; on account-deletion cascades or other
-- maintenance operations, keep the legacy deletion behavior.
create function private.planner_archive_item_reviews(target_item_id uuid)
returns void language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then return; end if;
 insert into private.planner_review_history(student_id,source_item_id,review_offset,due_date,subject,chapter,topics,completed_at)
 select p.student_id,i.id,c.review_offset,p.week_start+i.day_of_week+c.review_offset,i.subject,i.chapter,
   coalesce(e.data->'topics','[]'::jsonb),c.completed_at
 from public.weekly_plan_items i join public.weekly_plans p on p.id=i.plan_id
 join private.planner_review_completions c on c.item_id=i.id
 left join private.planner_item_extras e on e.item_id=i.id
 where i.id=target_item_id and p.status='published'::public.content_status;
 delete from private.planner_review_completions c where c.item_id=target_item_id;
end; $$;
revoke all on function private.planner_archive_item_reviews(uuid) from public,anon,authenticated;

create function private.planner_archive_changed_item_reviews()
returns trigger language plpgsql security definer set search_path='' as $$
begin
 if tg_op='DELETE' then
  perform private.planner_archive_item_reviews(old.id); return old;
 end if;
 if (new.day_of_week,new.subject,new.chapter,new.activity_type)
   is distinct from (old.day_of_week,old.subject,old.chapter,old.activity_type) then
  perform private.planner_archive_item_reviews(old.id);
 end if;
 return new;
end; $$;
revoke all on function private.planner_archive_changed_item_reviews() from public,anon,authenticated;
create trigger planner_archive_changed_item_reviews before update or delete on public.weekly_plan_items
for each row execute function private.planner_archive_changed_item_reviews();

create function private.planner_archive_changed_topic_reviews()
returns trigger language plpgsql security definer set search_path='' as $$
declare previous_topics jsonb; next_topics jsonb; target uuid;
begin
 target:=case when tg_op='DELETE' then old.item_id else new.item_id end;
 previous_topics:=case when tg_op='INSERT' then '[]'::jsonb else coalesce(old.data->'topics','[]'::jsonb) end;
 next_topics:=case when tg_op='DELETE' then '[]'::jsonb else coalesce(new.data->'topics','[]'::jsonb) end;
 if previous_topics is distinct from next_topics then perform private.planner_archive_item_reviews(target); end if;
 if tg_op='DELETE' then return old; end if; return new;
end; $$;
revoke all on function private.planner_archive_changed_topic_reviews() from public,anon,authenticated;
create trigger planner_archive_changed_topic_reviews before insert or update or delete on private.planner_item_extras
for each row execute function private.planner_archive_changed_topic_reviews();

-- Stage checkmarks only for an explicitly identified, unchanged source item.
-- The student's advisory lock is already held by the publisher. The old
-- checkmarks are deleted only in this transaction and restored after v9 saves.
-- Any failure rolls back the deletion, legacy save, metadata and draft removal.
create function private.planner_stage_review_transfer(target_plan uuid,target_items jsonb,target_extras jsonb)
returns jsonb language plpgsql security definer set search_path='' as $$
declare idx bigint; item jsonb; source_text text; source_id uuid; source public.weekly_plan_items%rowtype;
 new_topics jsonb; old_topics jsonb; stage jsonb:='[]'::jsonb; marks jsonb; seen uuid[]:=array[]::uuid[];
begin
 if target_plan is null then return stage; end if;
 for idx,item in select ordinality-1,value from jsonb_array_elements(target_items) with ordinality as x(value,ordinality) loop
  source_text:=coalesce(nullif(item->>'sourceItemId',''),nullif(item->>'id',''));
  if source_text is null then continue; end if;
  if source_text !~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' then raise exception 'Invalid source item' using errcode='22023'; end if;
  source_id:=source_text::uuid;
  if source_id=any(seen) then raise exception 'Duplicate source item' using errcode='22023'; end if;
  seen:=array_append(seen,source_id);
  select * into source from public.weekly_plan_items where id=source_id and plan_id=target_plan;
  if not found then raise exception 'Source item not available' using errcode='40001'; end if;
  if not exists(select 1 from private.planner_review_completions where item_id=source_id) then continue; end if;
  if (source.day_of_week,source.subject,coalesce(source.chapter,''),source.activity_type::text)
    is distinct from ((item->>'dayOfWeek')::smallint,btrim(item->>'subject'),btrim(coalesce(item->>'chapter','')),item->>'activityType') then continue; end if;
  select coalesce(e.data->'topics','[]'::jsonb) into old_topics from private.planner_item_extras e where e.item_id=source_id;
  old_topics:=coalesce(old_topics,'[]'::jsonb);
  new_topics:=case when jsonb_typeof(target_extras->'items')='array'
    then coalesce(target_extras->'items'->idx::integer->'topics','[]'::jsonb) else '[]'::jsonb end;
  if old_topics is distinct from new_topics then continue; end if;
  select jsonb_agg(jsonb_build_object('offset',review_offset,'completed_at',completed_at) order by review_offset)
   into marks from private.planner_review_completions where item_id=source_id;
  stage:=stage||jsonb_build_array(jsonb_build_object('index',idx,'day',source.day_of_week,'marks',marks));
  delete from private.planner_review_completions where item_id=source_id;
 end loop;
 return stage;
end; $$;
revoke all on function private.planner_stage_review_transfer(uuid,jsonb,jsonb) from public,anon,authenticated;

create function private.planner_restore_review_transfer(target_plan uuid,stage jsonb)
returns void language plpgsql security definer set search_path='' as $$
declare entry jsonb; mark jsonb; item uuid; count_items integer;
begin
 for entry in select value from jsonb_array_elements(stage) loop
  select count(*)::integer,(array_agg(i.id))[1] into count_items,item from public.weekly_plan_items i
   where i.plan_id=target_plan and i.sort_order=(entry->>'index')::integer and i.day_of_week=(entry->>'day')::smallint;
  if count_items<>1 then raise exception 'Cannot match review source' using errcode='40001'; end if;
  for mark in select value from jsonb_array_elements(entry->'marks') loop
   insert into private.planner_review_completions(item_id,review_offset,completed_at)
   values(item,(mark->>'offset')::smallint,(mark->>'completed_at')::timestamptz);
  end loop;
 end loop;
end; $$;
revoke all on function private.planner_restore_review_transfer(uuid,jsonb) from public,anon,authenticated;

create or replace function public.planner_review_week(target_student_id uuid,target_week_start date)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare result jsonb;
begin
 perform private.require_planner_review_access(target_student_id);
 if target_week_start is null then raise exception 'Invalid date' using errcode='22023'; end if;
 with all_reviews as (
  select p.week_start+i.day_of_week+o.days as due_date,i.subject,i.id as source_id,o.days as review_offset,
   jsonb_build_object('item_id',i.id,'plan_id',p.id,'source_week_start',p.week_start,'source_day',i.day_of_week,
    'due_date',p.week_start+i.day_of_week+o.days,'offset',o.days,'subject',i.subject,'chapter',i.chapter,
    'topics',coalesce(e.data->'topics','[]'::jsonb),'completed',c.item_id is not null,'historical',false) as value
  from public.weekly_plans p join public.weekly_plan_items i on i.plan_id=p.id
  cross join (values (1),(3),(7)) o(days)
  left join private.planner_review_completions c on c.item_id=i.id and c.review_offset=o.days
  left join private.planner_item_extras e on e.item_id=i.id
  where p.student_id=target_student_id and p.status='published'::public.content_status
   and p.week_start between target_week_start-13 and target_week_start+5
   and i.activity_type::text not in ('exam','simulation_exam','external_simulation_exam','makeup')
   and p.week_start+i.day_of_week+o.days between target_week_start and target_week_start+6
  union all
  select h.due_date,h.subject,h.source_item_id,h.review_offset,
   jsonb_build_object('archive_id',h.id,'item_id',h.source_item_id,'due_date',h.due_date,'offset',h.review_offset,
    'subject',h.subject,'chapter',h.chapter,'topics',h.topics,'completed',h.completed,'historical',true)
  from private.planner_review_history h where h.student_id=target_student_id
   and h.due_date between target_week_start and target_week_start+6
 )
 select coalesce(jsonb_agg(value order by due_date,subject,source_id,review_offset),'[]'::jsonb) into result from all_reviews;
 return result;
end; $$;

create function public.planner_set_historical_review_completed(target_archive_id uuid,target_completed boolean)
returns void language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid());
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role then raise exception 'Only students can update review progress' using errcode='42501'; end if;
 if target_archive_id is null or target_completed is null then raise exception 'Invalid review' using errcode='22023'; end if;
 perform private.require_planner_review_access(me);
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(me::text,73033));
 perform private.require_planner_review_access(me);
 update private.planner_review_history set completed=target_completed where id=target_archive_id and student_id=me;
 if not found then raise exception 'Review not available' using errcode='42501'; end if;
end; $$;
revoke all on function public.planner_set_historical_review_completed(uuid,boolean) from public,anon;
grant execute on function public.planner_set_historical_review_completed(uuid,boolean) to authenticated;
notify pgrst, 'reload schema';
