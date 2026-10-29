-- Restrict manual designer exam recipients to students assigned to a counselor.
-- Search and edit selection use the same eligibility rule as the save RPC.
-- Preserve the 082 explanation-PDF save and 081 already-linked exam-box behavior.
create or replace function public.search_exam_students(search_text text default '',page_offset integer default 0,page_size integer default 51)
returns table(id uuid,full_name text,grade smallint,study_field text) language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role then raise exception 'Only exam designers can search students' using errcode='42501';end if;
 return query select p.id,p.full_name,p.grade,p.study_field::text from public.profiles p where p.role='student'
 and exists(select 1 from public.counselor_students cs join public.profiles c on c.id=cs.counselor_id and c.role='counselor' where cs.student_id=p.id)
 and strpos(private.normalize_student_name(p.full_name),trim(private.normalize_student_name(left(coalesce(search_text,''),100))))>0
 order by p.full_name,p.id limit greatest(1,least(coalesce(page_size,51),51)) offset greatest(0,coalesce(page_offset,0));
end $$;
revoke all on function public.search_exam_students(text,integer,integer) from public,anon;
grant execute on function public.search_exam_students(text,integer,integer) to authenticated;

create or replace function public.designer_exam_details(target_exam_id uuid)
returns jsonb language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'exam_designer'::public.app_role
    or not exists(select 1 from public.exams where id=target_exam_id and counselor_id=(select auth.uid()))
 then raise exception 'Exam not found' using errcode='42501'; end if;
 return jsonb_build_object(
  'locked',exists(select 1 from public.exam_sessions where exam_id=target_exam_id) or exists(select 1 from public.exam_attempts where exam_id=target_exam_id) or exists(select 1 from public.exams where id=target_exam_id and starts_at<=now()),
  'booklets',coalesce((select jsonb_agg(to_jsonb(b) order by b.sort_order) from public.exam_booklets b where b.exam_id=target_exam_id),'[]'::jsonb),
  'students',coalesce((select jsonb_agg(jsonb_build_object('id',p.id,'full_name',p.full_name,'grade',p.grade,'study_field',p.study_field) order by p.full_name,p.id) from public.exam_students s join public.profiles p on p.id=s.student_id where s.exam_id=target_exam_id and p.role='student'
   and exists(select 1 from public.counselor_students cs join public.profiles c on c.id=cs.counselor_id and c.role='counselor' where cs.student_id=p.id)),'[]'::jsonb),
  'excluded_student_count',(select count(*) from public.exam_students s where s.exam_id=target_exam_id
   and not exists(select 1 from public.profiles p join public.counselor_students cs on cs.student_id=p.id
    join public.profiles c on c.id=cs.counselor_id and c.role='counselor'
    where p.id=s.student_id and p.role='student')),
  'box_ids',coalesce((select jsonb_agg(i.id order by i.id) from public.weekly_plan_items i where i.linked_exam_id=target_exam_id and i.activity_type::text='exam'),'[]'::jsonb)
 );
end $$;
revoke all on function public.designer_exam_details(uuid) from public,anon;
grant execute on function public.designer_exam_details(uuid) to authenticated;


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


notify pgrst, 'reload schema';
