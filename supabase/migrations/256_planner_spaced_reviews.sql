-- New reviews are separate from v2 and legacy history. Existing settings,
-- checkmarks, plans and private drafts remain unchanged.
create table private.planner_spaced_reviews (
 id uuid primary key default gen_random_uuid(),
 student_id uuid not null references public.profiles(id) on delete cascade,
 source_item_id uuid not null,
 review_offset smallint not null check (review_offset in (3,7,30,90)),
 due_date date not null,
 subject text not null,
 chapter text,
 topics jsonb not null default '[]'::jsonb check (jsonb_typeof(topics)='array'),
 review jsonb not null check (jsonb_typeof(review)='object'),
 completed_at timestamptz,
 cancelled_at timestamptz,
 unique(source_item_id,review_offset)
);
create index planner_spaced_reviews_student_due on private.planner_spaced_reviews(student_id,due_date) where cancelled_at is null;
alter table private.planner_spaced_reviews enable row level security;
revoke all on private.planner_spaced_reviews from public,anon,authenticated;

-- Accept existing single-offset settings verbatim and the new four-review
-- setting. Unknown or incomplete metadata is never silently accepted.
create or replace function private.planner_validate_review_setting() returns trigger
language plpgsql security definer set search_path='' as $$
declare r jsonb;
begin
 r:=new.data->'review';
 if r is null then return new; end if;
 if jsonb_typeof(r) is distinct from 'object'
  or jsonb_typeof(r->'kind') is distinct from 'string'
  or r->>'kind' not in ('general','specialist')
  or jsonb_typeof(r->'reading') is distinct from 'boolean'
  or jsonb_typeof(r->'practice') is distinct from 'boolean'
  or not ((r->>'reading')::boolean or (r->>'practice')::boolean)
  or (select count(*) from jsonb_object_keys(r)) <> 4
  or not coalesce((jsonb_typeof(r->'offset')='number' and r->>'offset' in ('3','7','30'))
       or (jsonb_typeof(r->'schedule')='string' and r->>'schedule'='spaced4'),false)
 then raise exception 'Invalid review setting' using errcode='22023';end if;
 return new;
end;$$;

-- Generate from the FIRST tick in Tehran, even if it was later unticked.
-- Uniqueness and retained cancellation tombstones prevent regeneration.
create function private.planner_generate_spaced_reviews(target_item_id uuid) returns void
language plpgsql security definer set search_path='' as $$
begin
 insert into private.planner_spaced_reviews(student_id,source_item_id,review_offset,due_date,subject,chapter,topics,review)
 select p.student_id,i.id,o.days,(timezone('Asia/Tehran',f.first_checked_at)::date + o.days),i.subject,i.chapter,
   coalesce(e.data->'topics','[]'::jsonb),e.data->'review'
 from public.weekly_plan_items i join public.weekly_plans p on p.id=i.plan_id
 join private.planner_item_extras e on e.item_id=i.id
 join private.planner_first_item_ticks f on f.item_id=i.id and f.student_id=p.student_id
 cross join (values (3::smallint),(7::smallint),(30::smallint),(90::smallint)) o(days)
 where i.id=target_item_id and p.status='published'::public.content_status
   and i.activity_type::text not in ('external_simulation_exam','makeup')
   and e.data->'review'->>'schedule'='spaced4'
 on conflict(source_item_id,review_offset) do nothing;
end;$$;
revoke all on function private.planner_generate_spaced_reviews(uuid) from public,anon,authenticated;
create function private.planner_generate_spaced_after_tick() returns trigger
language plpgsql security definer set search_path='' as $$
begin perform private.planner_generate_spaced_reviews(new.item_id);return new;end;$$;
revoke all on function private.planner_generate_spaced_after_tick() from public,anon,authenticated;
create trigger planner_generate_spaced_after_tick after insert on private.planner_first_item_ticks
for each row execute function private.planner_generate_spaced_after_tick();
create function private.planner_generate_spaced_after_extras() returns trigger
language plpgsql security definer set search_path='' as $$
begin perform private.planner_generate_spaced_reviews(new.item_id);return new;end;$$;
revoke all on function private.planner_generate_spaced_after_extras() from public,anon,authenticated;
create trigger planner_generate_spaced_after_extras after insert or update on private.planner_item_extras
for each row execute function private.planner_generate_spaced_after_extras();

-- Do not retroactively rewrite a schedule after the first tick. Other editable
-- metadata stays governed by the existing publication protections.
create function private.planner_protect_spaced_review_setting() returns trigger
language plpgsql security definer set search_path='' as $$
begin
 if old.data->'review'->>'schedule'='spaced4'
    and (tg_op='DELETE' or (old.data->'review') is distinct from (new.data->'review'))
    and exists(select 1 from private.planner_first_item_ticks f where f.item_id=old.item_id)
    and (tg_op<>'DELETE' or (exists(select 1 from public.weekly_plan_items i where i.id=old.item_id)
      and exists(select 1 from private.planner_spaced_reviews r where r.source_item_id=old.item_id
        and r.cancelled_at is null and r.completed_at is null and r.due_date>=timezone('Asia/Tehran',now())::date))) then
   raise exception 'Review settings are protected after first tick' using errcode='PZ001';
 end if;
 if tg_op='DELETE' then return old;end if;return new;
end;$$;
revoke all on function private.planner_protect_spaced_review_setting() from public,anon,authenticated;
create trigger planner_protect_spaced_review_setting before update or delete on private.planner_item_extras
for each row execute function private.planner_protect_spaced_review_setting();

-- Remove only future uncompleted occurrences when the source is removed or
-- changes identity; completed reviews and prior history remain untouched.
create function private.planner_cancel_removed_source_reviews() returns trigger
language plpgsql security definer set search_path='' as $$
begin
 if tg_op='DELETE' or (new.day_of_week,new.subject,new.chapter,new.activity_type) is distinct from (old.day_of_week,old.subject,old.chapter,old.activity_type) then
  update private.planner_spaced_reviews set cancelled_at=now()
  where source_item_id=old.id and completed_at is null and cancelled_at is null
    and due_date>=timezone('Asia/Tehran',now())::date;
 end if;
 if tg_op='DELETE' then return old;end if;return new;
end;$$;
revoke all on function private.planner_cancel_removed_source_reviews() from public,anon,authenticated;
create trigger planner_cancel_removed_source_reviews before update or delete on public.weekly_plan_items
for each row execute function private.planner_cancel_removed_source_reviews();

-- The assigned counselor and the student can load any selected seven-day
-- window, not just today's reviews. Never return another student's records.
create function public.planner_spaced_reviews_week(target_student_id uuid,target_week_start date)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare result jsonb;
begin
 perform private.require_planner_review_access(target_student_id);
 if target_week_start is null then raise exception 'Invalid date' using errcode='22023';end if;
 select coalesce(jsonb_agg(jsonb_build_object('id',r.id,'item_id',r.source_item_id,'due_date',r.due_date,
  'offset',r.review_offset,'subject',r.subject,'chapter',r.chapter,'topics',r.topics,'review',r.review,'completed',r.completed_at is not null)
  order by r.due_date,r.subject,r.id),'[]'::jsonb) into result
 from private.planner_spaced_reviews r where r.student_id=target_student_id and r.cancelled_at is null
  and r.due_date between target_week_start and target_week_start+6;
 return result;
end;$$;
revoke all on function public.planner_spaced_reviews_week(uuid,date) from public,anon;
grant execute on function public.planner_spaced_reviews_week(uuid,date) to authenticated;

-- Deleting a review is an explicit, immediate action, separate from plan
-- publication. A completed or elapsed occurrence cannot be removed.
create function public.planner_cancel_spaced_review(target_review_id uuid) returns void
language plpgsql security definer set search_path='' as $$
declare student uuid; r private.planner_spaced_reviews%rowtype;
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role or target_review_id is null then raise exception 'Counselor only' using errcode='42501';end if;
 select student_id into student from private.planner_spaced_reviews where id=target_review_id;
 if student is null then raise exception 'Review unavailable' using errcode='42501';end if;
 perform private.require_planner_draft_access(student);
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(student::text,73033));
 perform 1 from public.counselor_students where counselor_id=(select auth.uid()) and student_id=student for update;
 if not found then raise exception 'Student not available' using errcode='42501';end if;
 perform private.require_planner_draft_access(student);
 select * into r from private.planner_spaced_reviews where id=target_review_id for update;
 if not found or r.student_id<>student or r.cancelled_at is not null or r.completed_at is not null or r.due_date<timezone('Asia/Tehran',now())::date then
  raise exception 'Review is protected or no longer available' using errcode='PZ001';end if;
 update private.planner_spaced_reviews set cancelled_at=now() where id=r.id;
end;$$;
revoke all on function public.planner_cancel_spaced_review(uuid) from public,anon;
grant execute on function public.planner_cancel_spaced_review(uuid) to authenticated;

create function public.planner_set_spaced_review_completed(target_review_id uuid,target_completed boolean) returns void
language plpgsql security definer set search_path='' as $$
declare me uuid:=(select auth.uid());r private.planner_spaced_reviews%rowtype;
begin
 if (select private.current_user_role()) is distinct from 'student'::public.app_role or target_review_id is null or target_completed is null then raise exception 'Student only' using errcode='42501';end if;
 perform private.require_planner_review_access(me);
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(me::text,73033));
 perform private.require_planner_review_access(me);
 select * into r from private.planner_spaced_reviews where id=target_review_id and student_id=me for update;
 if not found or r.cancelled_at is not null or r.due_date<>timezone('Asia/Tehran',now())::date then raise exception 'Review unavailable' using errcode='42501';end if;
 update private.planner_spaced_reviews set completed_at=case when target_completed then coalesce(completed_at,now()) else null end where id=r.id;
end;$$;
revoke all on function public.planner_set_spaced_review_completed(uuid,boolean) from public,anon;
grant execute on function public.planner_set_spaced_review_completed(uuid,boolean) to authenticated;
notify pgrst,'reload schema';
