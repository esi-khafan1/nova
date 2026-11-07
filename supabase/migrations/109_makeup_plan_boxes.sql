-- The subject column remains non-null for existing plan infrastructure, so the
-- label is stored there; this activity has no curriculum subject or chapter.
alter type public.study_activity_type add value if not exists 'makeup';

alter table public.weekly_plan_items
  add constraint makeup_plan_box_shape check (
    activity_type::text <> 'makeup' or (
      subject = 'باکس جبرانی'
      and chapter is null
      and source_grade is null
      and preparation_track = 'konkur'
      and exam_year is null
      and target_test_count is null
      and recommended_publisher is null
      and linked_exam_id is null
    )
  );
notify pgrst, 'reload schema';
