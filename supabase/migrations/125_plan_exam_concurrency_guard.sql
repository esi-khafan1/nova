-- Serialize the existing designer box-assignment and plan link snapshot paths.
-- This updates functions only; it performs no data rewrite. Keep the new
-- planner publisher disabled until its other release gates are met.
create or replace function public.save_designer_exam(
 target_exam_id uuid,target_title text,target_description text,target_student_ids uuid[],target_starts_at timestamptz,
 target_status public.content_status,target_booklets jsonb,target_exam_field text default null,
 target_start_window_ends_at timestamptz default null,target_box_ids uuid[] default '{}'::uuid[]
) returns uuid language plpgsql security definer set search_path='' as $$
declare saved uuid; invalid_pdf boolean;
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role then
   raise exception 'Only exam designers can manage exams' using errcode='42501';end if;
 if target_student_ids is null or cardinality(target_student_ids)>10000 then
   raise exception 'Invalid selected students';end if;
 if target_box_ids is null or cardinality(target_box_ids)>200 then
   raise exception 'Invalid exam boxes';end if;
 if (target_status='published' and cardinality(target_student_ids)=0 and cardinality(target_box_ids)=0)
    or exists(select 1 from unnest(target_student_ids) x(id) where not exists(
     select 1 from public.profiles p
     join public.counselor_students cs on cs.student_id=p.id
     join public.profiles c on c.id=cs.counselor_id and c.role='counselor'
     where p.id=x.id and p.role='student'))
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
 -- Lock both selected boxes and previously linked boxes to serialize designer
 -- edits with plan publication. NOWAIT avoids a cycle with a plan save that
 -- already holds box rows and is waiting on the exam row. A retry is safe.
 begin
   perform 1 from public.weekly_plan_items i
   where i.id=any(target_box_ids) or (target_exam_id is not null and i.linked_exam_id=target_exam_id)
   order by i.id for update nowait;
 exception when lock_not_available then
   raise exception 'Exam boxes are being updated; try again' using errcode='40001';
 end;
 -- The initial eligibility check happened before the locks: a box could have
 -- been deleted, moved or assigned in the meantime. Check again under lock.
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
 -- The optional explanation belongs to the corresponding booklet, never to a student upload.
 if jsonb_typeof(target_booklets) is distinct from 'array' then raise exception 'Invalid booklets'; end if;
 select exists(select 1 from jsonb_array_elements(target_booklets) b
   where b ? 'explanationPdfUrl' and b->>'explanationPdfUrl' is not null
     and trim(b->>'explanationPdfUrl') <> ''
     and (length(trim(b->>'explanationPdfUrl')) > 2048 or left(trim(b->>'explanationPdfUrl'),8) <> 'https://'))
 into invalid_pdf;
 if invalid_pdf then raise exception 'Invalid explanation PDF'; end if;
 saved:=private.save_designer_exam_with_window(target_exam_id,target_title,target_description,'own_students',target_starts_at,target_status,target_booklets,target_exam_field,target_start_window_ends_at);
 -- The canonical save rebuilds booklets. Attach each optional PDF in the same
 -- transaction so a failed save never leaves the answer sheet mismatched.
 update public.exam_booklets b set explanation_pdf_url=nullif(trim(x.value->>'explanationPdfUrl'),'')
 from jsonb_array_elements(target_booklets) with ordinality as x(value,position)
 where b.exam_id=saved and b.sort_order=x.position-1;
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
    -- The legacy direct v5 caller has not acquired the student lock yet.
    -- Never wait for it while holding the plan row: older writers acquire the
    -- same locks in the reverse order. A conflict rolls back and can be retried.
    if found then
      if not pg_catalog.pg_try_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033)) then
        raise exception 'Student plan is busy; retry saving' using errcode='40001';
      end if;
      -- Hold each item before taking the link snapshot, so an exam assignment
      -- cannot slip in after the snapshot and be lost during item replacement.
      perform 1 from public.weekly_plan_items i where i.plan_id=target_plan_id
      order by i.id for update;
    end if;
    select coalesce(jsonb_agg(jsonb_build_object(
      'day',i.day_of_week,'subject',i.subject,
      'chapter',coalesce(i.chapter,''),'exam',i.linked_exam_id
    )),'[]'::jsonb) into saved_links
    from public.weekly_plan_items i
    where i.plan_id=target_plan_id and i.activity_type::text='exam' and i.linked_exam_id is not null;
  end if;

  -- A cached older planner sends only the original routine fields. Retain
  -- second-routine values already stored for that day unless explicitly sent.
  if original_routines is not null then
    select jsonb_agg(
      item.value
      || case when not (item.value ? 'secondSubject') and previous.value ? 'secondSubject'
           then jsonb_build_object('secondSubject', previous.value -> 'secondSubject') else '{}'::jsonb end
      || case when not (item.value ? 'secondDetails') and previous.value ? 'secondDetails'
           then jsonb_build_object('secondDetails', previous.value -> 'secondDetails') else '{}'::jsonb end
      order by (item.value ->> 'dayOfWeek')::smallint
    ) into normalized
    from jsonb_array_elements(normalized) as item(value)
    left join lateral (
      select value from jsonb_array_elements(original_routines)
      where (value ->> 'dayOfWeek')::smallint = (item.value ->> 'dayOfWeek')::smallint
      limit 1
    ) previous on true;
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

revoke all on function public.save_weekly_plan_v5(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) from public,anon;
grant execute on function public.save_weekly_plan_v5(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) to authenticated;
notify pgrst, 'reload schema';
