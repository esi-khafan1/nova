-- Keep lock ordering consistent with v3 during concurrent saves.
create or replace function public.save_weekly_plan_v4(target_plan_id uuid,target_student_id uuid,target_week_start date,target_title text,target_notes text,target_status public.content_status,target_items jsonb)
returns uuid language plpgsql security definer set search_path='' as $$
declare saved uuid; item jsonb; item_index integer:=0; g smallint; track text; y smallint; student_grade smallint; student_field text; original_status public.content_status; today date:=timezone('Asia/Tehran',now())::date;
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then raise exception 'Only counselors can save plans'; end if;
 if not exists(select 1 from public.counselor_students where student_id=target_student_id and counselor_id=(select auth.uid())) then raise exception 'Student not assigned'; end if;
 if target_items is null or jsonb_typeof(target_items)<>'array' or jsonb_array_length(target_items)>100 then raise exception 'Invalid items'; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 select grade,study_field::text into student_grade,student_field from public.profiles where id=target_student_id;
 if target_plan_id is not null then select status into original_status from public.weekly_plans where id=target_plan_id and counselor_id=(select auth.uid()) for update; end if;
 for item in select value from jsonb_array_elements(target_items) loop
  g:=nullif(item->>'sourceGrade','')::smallint;track:=coalesce(item->>'preparationTrack','konkur');y:=nullif(item->>'examYear','')::smallint;
  if track not in ('konkur','final_exam') or (g is not null and (g not in (10,11,12) or student_grade is null or g>student_grade)) then raise exception 'Invalid curriculum grade or track'; end if;
  if track='konkur' and y is not null then raise exception 'Invalid exam year'; end if;
  if track='final_exam' then
   if g is null or g not in (11,12) or y is distinct from 1406 or not exists(select 1 from (values
('experimental_sciences',11,'فارسی ۲'),
('experimental_sciences',11,'تعلیمات دینی ۲'),
('experimental_sciences',11,'زبان خارجی ۲'),
('experimental_sciences',11,'عربی زبان قرآن ۲'),
('experimental_sciences',11,'زیست‌شناسی ۲'),
('experimental_sciences',11,'شیمی ۲'),
('experimental_sciences',12,'فارسی ۳'),
('experimental_sciences',12,'تعلیمات دینی ۳'),
('experimental_sciences',12,'زبان خارجی ۳'),
('experimental_sciences',12,'عربی زبان قرآن ۳'),
('experimental_sciences',12,'زیست‌شناسی ۳'),
('experimental_sciences',12,'ریاضی ۳'),
('experimental_sciences',12,'فیزیک ۳'),
('experimental_sciences',12,'شیمی ۳'),
('experimental_sciences',12,'سلامت و بهداشت'),
('experimental_sciences',12,'علوم اجتماعی'),
('mathematics',11,'فارسی ۲'),
('mathematics',11,'تعلیمات دینی ۲'),
('mathematics',11,'زبان خارجی ۲'),
('mathematics',11,'عربی زبان قرآن ۲'),
('mathematics',11,'هندسه ۲'),
('mathematics',11,'فیزیک ۲'),
('mathematics',12,'فارسی ۳'),
('mathematics',12,'تعلیمات دینی ۳'),
('mathematics',12,'زبان خارجی ۳'),
('mathematics',12,'عربی زبان قرآن ۳'),
('mathematics',12,'حسابان ۲'),
('mathematics',12,'هندسه ۳'),
('mathematics',12,'ریاضیات گسسته'),
('mathematics',12,'فیزیک ۳'),
('mathematics',12,'شیمی ۳'),
('mathematics',12,'سلامت و بهداشت'),
('mathematics',12,'علوم اجتماعی'),
('humanities',11,'فارسی ۲'),
('humanities',11,'تعلیمات دینی ۲'),
('humanities',11,'زبان خارجی ۲'),
('humanities',11,'عربی ۲ تخصصی'),
('humanities',11,'تاریخ ۲'),
('humanities',11,'جامعه‌شناسی ۲'),
('humanities',12,'فارسی ۳'),
('humanities',12,'تعلیمات دینی ۳'),
('humanities',12,'زبان خارجی ۳'),
('humanities',12,'عربی ۳ تخصصی'),
('humanities',12,'علوم و فنون ادبی ۳'),
('humanities',12,'ریاضی و آمار ۳'),
('humanities',12,'تاریخ ۳'),
('humanities',12,'جغرافیا ۳'),
('humanities',12,'جامعه‌شناسی ۳'),
('humanities',12,'فلسفه ۲'),
('humanities',12,'سلامت و بهداشت')
   ) as official(field,grade,subject) where official.field=student_field and official.grade=g and official.subject=btrim(item->>'subject')) then raise exception 'Subject not in official final curriculum for 1406'; end if;
  end if;
 end loop;
 -- Delegate all existing authorization, date locks, overlap checks and atomic persistence to v3.
 saved:=public.save_weekly_plan_v3(target_plan_id,target_student_id,target_week_start,target_title,target_notes,target_status,target_items);
 for item in select value from jsonb_array_elements(target_items) loop
  update public.weekly_plan_items set source_grade=nullif(item->>'sourceGrade','')::smallint,preparation_track=coalesce(item->>'preparationTrack','konkur'),exam_year=nullif(item->>'examYear','')::smallint
  where plan_id=saved and sort_order=item_index and day_of_week=(item->>'dayOfWeek')::smallint
   and ((original_status='published'::public.content_status and target_week_start+day_of_week>today) or (original_status is distinct from 'published'::public.content_status and target_week_start+day_of_week>=today));
  item_index:=item_index+1;
 end loop;
 return saved;
end; $$;
