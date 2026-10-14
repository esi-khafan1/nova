-- Rename the user-facing track to school subjects without rewriting historical identifiers.
create table public.school_subjects (study_field public.study_field not null,grade smallint not null check(grade in (10,11,12)),subject text not null,primary key(study_field,grade,subject));
alter table public.school_subjects enable row level security;
grant select on public.school_subjects to authenticated;
create policy school_catalog_read on public.school_subjects for select to authenticated using(true);
insert into public.school_subjects(study_field,grade,subject) values
('mathematics',10,'ریاضی ۱'),
('mathematics',10,'هندسه ۱'),
('mathematics',10,'فیزیک ۱'),
('mathematics',10,'شیمی ۱'),
('mathematics',10,'فارسی ۱'),
('mathematics',10,'نگارش ۱'),
('mathematics',10,'تعلیمات دینی ۱'),
('mathematics',10,'زبان خارجی ۱'),
('mathematics',10,'عربی زبان قرآن ۱'),
('mathematics',10,'جغرافیای ایران'),
('mathematics',10,'تفکر و سواد رسانه‌ای'),
('mathematics',10,'آمادگی دفاعی'),
('mathematics',10,'کارگاه کارآفرینی و تولید'),
('mathematics',10,'تربیت بدنی ۱'),
('mathematics',10,'آزمایشگاه علوم تجربی ۱'),
('mathematics',11,'حسابان ۱'),
('mathematics',11,'هندسه ۲'),
('mathematics',11,'آمار و احتمال'),
('mathematics',11,'فیزیک ۲'),
('mathematics',11,'شیمی ۲'),
('mathematics',11,'فارسی ۲'),
('mathematics',11,'نگارش ۲'),
('mathematics',11,'تعلیمات دینی ۲'),
('mathematics',11,'زبان خارجی ۲'),
('mathematics',11,'عربی زبان قرآن ۲'),
('mathematics',11,'انسان و محیط زیست'),
('mathematics',11,'تربیت بدنی ۲'),
('mathematics',11,'آزمایشگاه علوم تجربی ۲'),
('mathematics',11,'تاریخ معاصر ایران'),
('mathematics',11,'زمین‌شناسی'),
('mathematics',12,'حسابان ۲'),
('mathematics',12,'هندسه ۳'),
('mathematics',12,'ریاضیات گسسته'),
('mathematics',12,'فیزیک ۳'),
('mathematics',12,'شیمی ۳'),
('mathematics',12,'فارسی ۳'),
('mathematics',12,'نگارش ۳'),
('mathematics',12,'تعلیمات دینی ۳'),
('mathematics',12,'زبان خارجی ۳'),
('mathematics',12,'عربی زبان قرآن ۳'),
('mathematics',12,'سلامت و بهداشت'),
('mathematics',12,'مدیریت خانواده و سبک زندگی'),
('mathematics',12,'تربیت بدنی ۳'),
('mathematics',12,'علوم اجتماعی'),
('experimental_sciences',10,'زیست‌شناسی ۱'),
('experimental_sciences',10,'ریاضی ۱'),
('experimental_sciences',10,'فیزیک ۱'),
('experimental_sciences',10,'شیمی ۱'),
('experimental_sciences',10,'فارسی ۱'),
('experimental_sciences',10,'نگارش ۱'),
('experimental_sciences',10,'تعلیمات دینی ۱'),
('experimental_sciences',10,'زبان خارجی ۱'),
('experimental_sciences',10,'عربی زبان قرآن ۱'),
('experimental_sciences',10,'جغرافیای ایران'),
('experimental_sciences',10,'تفکر و سواد رسانه‌ای'),
('experimental_sciences',10,'آمادگی دفاعی'),
('experimental_sciences',10,'کارگاه کارآفرینی و تولید'),
('experimental_sciences',10,'تربیت بدنی ۱'),
('experimental_sciences',10,'آزمایشگاه علوم تجربی ۱'),
('experimental_sciences',11,'زیست‌شناسی ۲'),
('experimental_sciences',11,'ریاضی ۲'),
('experimental_sciences',11,'فیزیک ۲'),
('experimental_sciences',11,'شیمی ۲'),
('experimental_sciences',11,'زمین‌شناسی'),
('experimental_sciences',11,'فارسی ۲'),
('experimental_sciences',11,'نگارش ۲'),
('experimental_sciences',11,'تعلیمات دینی ۲'),
('experimental_sciences',11,'زبان خارجی ۲'),
('experimental_sciences',11,'عربی زبان قرآن ۲'),
('experimental_sciences',11,'انسان و محیط زیست'),
('experimental_sciences',11,'تربیت بدنی ۲'),
('experimental_sciences',11,'آزمایشگاه علوم تجربی ۲'),
('experimental_sciences',11,'تاریخ معاصر ایران'),
('experimental_sciences',12,'زیست‌شناسی ۳'),
('experimental_sciences',12,'ریاضی ۳'),
('experimental_sciences',12,'فیزیک ۳'),
('experimental_sciences',12,'شیمی ۳'),
('experimental_sciences',12,'فارسی ۳'),
('experimental_sciences',12,'نگارش ۳'),
('experimental_sciences',12,'تعلیمات دینی ۳'),
('experimental_sciences',12,'زبان خارجی ۳'),
('experimental_sciences',12,'عربی زبان قرآن ۳'),
('experimental_sciences',12,'سلامت و بهداشت'),
('experimental_sciences',12,'مدیریت خانواده و سبک زندگی'),
('experimental_sciences',12,'تربیت بدنی ۳'),
('experimental_sciences',12,'علوم اجتماعی'),
('humanities',10,'ریاضی و آمار ۱'),
('humanities',10,'علوم و فنون ادبی ۱'),
('humanities',10,'عربی ۱ تخصصی'),
('humanities',10,'اقتصاد'),
('humanities',10,'تاریخ ۱'),
('humanities',10,'جغرافیای ایران'),
('humanities',10,'جامعه‌شناسی ۱'),
('humanities',10,'منطق'),
('humanities',10,'فارسی ۱'),
('humanities',10,'نگارش ۱'),
('humanities',10,'تعلیمات دینی ۱'),
('humanities',10,'زبان خارجی ۱'),
('humanities',10,'تفکر و سواد رسانه‌ای'),
('humanities',10,'آمادگی دفاعی'),
('humanities',10,'کارگاه کارآفرینی و تولید'),
('humanities',10,'تربیت بدنی ۱'),
('humanities',11,'ریاضی و آمار ۲'),
('humanities',11,'علوم و فنون ادبی ۲'),
('humanities',11,'عربی ۲ تخصصی'),
('humanities',11,'تاریخ ۲'),
('humanities',11,'جغرافیا ۲'),
('humanities',11,'جامعه‌شناسی ۲'),
('humanities',11,'فلسفه ۱'),
('humanities',11,'روان‌شناسی'),
('humanities',11,'فارسی ۲'),
('humanities',11,'نگارش ۲'),
('humanities',11,'تعلیمات دینی ۲'),
('humanities',11,'زبان خارجی ۲'),
('humanities',11,'انسان و محیط زیست'),
('humanities',11,'تربیت بدنی ۲'),
('humanities',12,'ریاضی و آمار ۳'),
('humanities',12,'علوم و فنون ادبی ۳'),
('humanities',12,'عربی ۳ تخصصی'),
('humanities',12,'تاریخ ۳'),
('humanities',12,'جغرافیا ۳'),
('humanities',12,'جامعه‌شناسی ۳'),
('humanities',12,'فلسفه ۲'),
('humanities',12,'فارسی ۳'),
('humanities',12,'نگارش ۳'),
('humanities',12,'تعلیمات دینی ۳'),
('humanities',12,'زبان خارجی ۳'),
('humanities',12,'سلامت و بهداشت'),
('humanities',12,'مدیریت خانواده و سبک زندگی'),
('humanities',12,'تربیت بدنی ۳');
alter table public.weekly_plan_items drop constraint final_exam_metadata_check;
alter table public.weekly_plan_items add constraint school_metadata_check check ((preparation_track='konkur' and exam_year is null) or (preparation_track='final_exam' and source_grade is not null and source_grade in (10,11,12) and (exam_year is null or exam_year=1406)));
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
   if g is null or not exists(select 1 from public.school_subjects official where official.study_field::text=student_field and official.grade=g and official.subject=btrim(item->>'subject')) then raise exception 'Subject not in school curriculum'; end if;
  end if;
 end loop;
 -- Delegate all existing authorization, date locks, overlap checks and atomic persistence to v3.
 saved:=public.save_weekly_plan_v3(target_plan_id,target_student_id,target_week_start,target_title,target_notes,target_status,target_items);
 for item in select value from jsonb_array_elements(target_items) loop
  update public.weekly_plan_items set source_grade=nullif(item->>'sourceGrade','')::smallint,preparation_track=coalesce(item->>'preparationTrack','konkur'),exam_year=null
  where plan_id=saved and sort_order=item_index and day_of_week=(item->>'dayOfWeek')::smallint
   and ((original_status='published'::public.content_status and target_week_start+day_of_week>today) or (original_status is distinct from 'published'::public.content_status and target_week_start+day_of_week>=today));
  item_index:=item_index+1;
 end loop;
 return saved;
end; $$;
