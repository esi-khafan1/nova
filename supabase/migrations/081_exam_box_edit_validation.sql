-- Keep a box that is already attached to this exam valid even after its week
-- passes (or its student becomes inactive); editing the exam must not detach it.
create or replace function public.save_designer_exam(
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

notify pgrst, 'reload schema';
