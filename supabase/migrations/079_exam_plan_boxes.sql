-- Counselors mark a plan item as an "exam box" (activity_type = 'exam').
-- Those boxes — with their student, weekday/date and subject — are sent to the
-- exam designer. The designer attaches one exam to each box, and can still
-- assign that same exam to other students through the existing picker.
-- Only 'exam' boxes are shared; 'simulation_exam' boxes stay private.

alter table public.weekly_plan_items
  add column if not exists linked_exam_id uuid references public.exams(id) on delete set null;

create index if not exists weekly_plan_items_linked_exam_idx
  on public.weekly_plan_items(linked_exam_id) where linked_exam_id is not null;

-- A box link is itself an enrollment: the student can open and review the exam
-- even when they were not added through the manual student picker.
create or replace function private.student_can_access_exam(target_exam_id uuid,target_student_id uuid)
returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.exams e join public.profiles p on p.id=target_student_id
 where e.id=target_exam_id and e.status='published' and p.role='student' and p.registration_status='active'
 and (case when e.explicit_students then
   exists(select 1 from public.exam_students s where s.exam_id=e.id and s.student_id=p.id)
   or exists(select 1 from public.weekly_plan_items i join public.weekly_plans wp on wp.id=i.plan_id
      where i.linked_exam_id=e.id and wp.student_id=p.id and wp.status='published'
        and i.activity_type::text='exam')
 else exists(select 1 from public.counselor_students a where a.student_id=p.id and (e.audience='all_assigned_students' or a.counselor_id=e.counselor_id)) end));
$$;
revoke all on function private.student_can_access_exam(uuid,uuid) from public,anon;
grant execute on function private.student_can_access_exam(uuid,uuid) to authenticated;

-- Designer-only, read-only view of exam boxes from published plans. Past boxes
-- are kept only while linked, so a designer can still detach them.
create or replace function public.designer_exam_boxes()
returns table(
  item_id uuid, plan_id uuid, student_id uuid, student_name text,
  box_date date, day_of_week smallint, week_start date,
  subject text, chapter text, duration_minutes smallint,
  linked_exam_id uuid, linked_exam_title text, linked_exam_owned boolean
) language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role then
   raise exception 'Only exam designers can view exam boxes' using errcode='42501';
 end if;
 return query
 select i.id, p.id, p.student_id, coalesce(nullif(btrim(pr.full_name),''),'دانشآموز نووا'),
   (p.week_start + i.day_of_week)::date, i.day_of_week, p.week_start,
   i.subject, i.chapter, i.duration_minutes,
   i.linked_exam_id, e.title, coalesce(e.counselor_id=(select auth.uid()),false)
 from public.weekly_plan_items i
 join public.weekly_plans p on p.id=i.plan_id
 join public.profiles pr on pr.id=p.student_id
 left join public.exams e on e.id=i.linked_exam_id
 where p.status='published'
   and i.activity_type::text='exam'
   and pr.role='student'
   and pr.registration_status='active'
   and ((p.week_start + i.day_of_week) >= timezone('Asia/Tehran',now())::date or i.linked_exam_id is not null)
 order by (p.week_start + i.day_of_week), pr.full_name, i.sort_order, i.id
 limit 500;
end $$;
revoke all on function public.designer_exam_boxes() from public,anon;
grant execute on function public.designer_exam_boxes() to authenticated;

-- Keep an authoritative list of this exam's boxes for the edit form.
create or replace function public.designer_exam_details(target_exam_id uuid)
returns jsonb language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role
    or not exists(select 1 from public.exams where id=target_exam_id and counselor_id=(select auth.uid()))
 then raise exception 'Exam not found' using errcode='42501'; end if;
 return jsonb_build_object(
  'locked',exists(select 1 from public.exam_sessions where exam_id=target_exam_id) or exists(select 1 from public.exam_attempts where exam_id=target_exam_id) or exists(select 1 from public.exams where id=target_exam_id and starts_at<=now()),
  'booklets',coalesce((select jsonb_agg(to_jsonb(b) order by b.sort_order) from public.exam_booklets b where b.exam_id=target_exam_id),'[]'::jsonb),
  'students',coalesce((select jsonb_agg(jsonb_build_object('id',p.id,'full_name',p.full_name,'grade',p.grade,'study_field',p.study_field) order by p.full_name,p.id) from public.exam_students s join public.profiles p on p.id=s.student_id where s.exam_id=target_exam_id),'[]'::jsonb),
  'box_ids',coalesce((select jsonb_agg(i.id order by i.id) from public.weekly_plan_items i where i.linked_exam_id=target_exam_id and i.activity_type::text='exam'),'[]'::jsonb)
 );
end $$;
revoke all on function public.designer_exam_details(uuid) from public,anon;
grant execute on function public.designer_exam_details(uuid) to authenticated;

-- Extend the save RPC with the selected boxes. A single overload is kept so
-- PostgREST never has to choose between ambiguous signatures.
drop function if exists public.save_designer_exam(uuid,text,text,uuid[],timestamptz,public.content_status,jsonb,text,timestamptz);
create function public.save_designer_exam(
 target_exam_id uuid,target_title text,target_description text,target_student_ids uuid[],target_starts_at timestamptz,
 target_status public.content_status,target_booklets jsonb,target_exam_field text default null,
 target_start_window_ends_at timestamptz default null,target_box_ids uuid[] default '{}'::uuid[]
) returns uuid language plpgsql security definer set search_path='' as $$
declare saved uuid;
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role then
   raise exception 'Only exam designers can manage exams' using errcode='42501';end if;
 if target_student_ids is null or cardinality(target_student_ids)>10000 then
   raise exception 'Invalid selected students';end if;
 if target_box_ids is null or cardinality(target_box_ids)>200 then
   raise exception 'Invalid exam boxes';end if;
 if (target_status='published' and cardinality(target_student_ids)=0 and cardinality(target_box_ids)=0)
    or exists(select 1 from unnest(target_student_ids) x(id) where not exists(select 1 from public.profiles p where p.id=x.id and p.role='student'))
 then raise exception 'Invalid selected students';end if;
 -- A new box must be a published, current/future 'exam' plan item of an active
 -- student, and must not already belong to another designer's exam. Boxes that
 -- are already attached to this exam stay valid even after their week passes.
 if exists(select 1 from unnest(target_box_ids) b(id) where not exists(
   select 1 from public.weekly_plan_items i
   join public.weekly_plans p on p.id=i.plan_id
   join public.profiles pr on pr.id=p.student_id
   where i.id=b.id and i.activity_type::text='exam' and p.status='published'
     and (
       (target_exam_id is not null and i.linked_exam_id=target_exam_id)
       or (
         (p.week_start + i.day_of_week) >= timezone('Asia/Tehran',now())::date
         and pr.role='student' and pr.registration_status='active'
         and (i.linked_exam_id is null
           or exists(select 1 from public.exams e where e.id=i.linked_exam_id and e.counselor_id=(select auth.uid())))
       )
     )
 )) then raise exception 'Invalid exam boxes';end if;
 if target_exam_id is not null then
   perform 1 from public.exams where id=target_exam_id and counselor_id=(select auth.uid()) for update;
   if not found then raise exception 'Exam not found';end if;
 end if;
 saved:=private.save_designer_exam_with_window(target_exam_id,target_title,target_description,'own_students',target_starts_at,target_status,target_booklets,target_exam_field,target_start_window_ends_at);
 update public.exams set explicit_students=true,template_version=case when target_exam_field is null then null else 'national-1404-v1' end where id=saved;
 update public.weekly_plan_items set linked_exam_id=null
   where linked_exam_id=saved and not (id=any(target_box_ids));
 update public.weekly_plan_items set linked_exam_id=saved
   where id=any(target_box_ids) and activity_type::text='exam';
 delete from public.exam_students where exam_id=saved;
 insert into public.exam_students(exam_id,student_id) select saved,id from (select distinct unnest(target_student_ids) id) selected;
 return saved;
end $$;
revoke all on function public.save_designer_exam(uuid,text,text,uuid[],timestamptz,public.content_status,jsonb,text,timestamptz,uuid[]) from public,anon;
grant execute on function public.save_designer_exam(uuid,text,text,uuid[],timestamptz,public.content_status,jsonb,text,timestamptz,uuid[]) to authenticated;

-- Re-saving a plan deletes and re-inserts its future items, so their ids change.
-- Re-attach exam links by the box's stable day + subject + chapter identity.
create or replace function public.save_weekly_plan_v5(
  target_plan_id uuid,
  target_student_id uuid,
  target_week_start date,
  target_title text,
  target_notes text,
  target_status public.content_status,
  target_items jsonb,
  target_routines jsonb
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  saved uuid;
  original_routines jsonb;
  original_status public.content_status;
  normalized jsonb;
  saved_links jsonb := '[]'::jsonb;
begin
  if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then
    raise exception 'Only counselors can save plans';
  end if;
  if not exists (
    select 1 from public.counselor_students
    where student_id = target_student_id and counselor_id = (select auth.uid())
  ) then
    raise exception 'Student not assigned';
  end if;

  normalized := public.normalize_weekly_plan_routines(target_routines);

  if target_plan_id is not null then
    select routines, status into original_routines, original_status
    from public.weekly_plans
    where id = target_plan_id and counselor_id = (select auth.uid())
    for update;
    select coalesce(jsonb_agg(jsonb_build_object(
      'day',i.day_of_week,'subject',i.subject,
      'chapter',coalesce(i.chapter,''),'exam',i.linked_exam_id
    )),'[]'::jsonb) into saved_links
    from public.weekly_plan_items i
    where i.plan_id=target_plan_id and i.activity_type::text='exam' and i.linked_exam_id is not null;
  end if;

  saved := public.save_weekly_plan_v4(
    target_plan_id, target_student_id, target_week_start,
    target_title, target_notes, target_status, target_items
  );

  update public.weekly_plans
  set routines = normalized
  where id = saved
    and counselor_id = (select auth.uid());

  if saved_links <> '[]'::jsonb then
    update public.weekly_plan_items i
    set linked_exam_id = (l.link->>'exam')::uuid
    from jsonb_array_elements(saved_links) as l(link)
    where i.plan_id=saved and i.activity_type::text='exam' and i.linked_exam_id is null
      and i.day_of_week=(l.link->>'day')::smallint
      and i.subject=l.link->>'subject'
      and coalesce(i.chapter,'')=l.link->>'chapter'
      and exists(select 1 from public.exams e where e.id=(l.link->>'exam')::uuid);
  end if;

  return saved;
end;
$$;

revoke all on function public.save_weekly_plan_v5(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) from public, anon;
grant execute on function public.save_weekly_plan_v5(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) to authenticated;

notify pgrst, 'reload schema';
