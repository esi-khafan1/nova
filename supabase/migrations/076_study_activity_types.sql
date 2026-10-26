-- These four labels are selectable only; they do not change plan completion rules.
alter type public.study_activity_type add value if not exists 'exam_analysis';
alter type public.study_activity_type add value if not exists 'simulation_exam';
alter type public.study_activity_type add value if not exists 'offline_class';
alter type public.study_activity_type add value if not exists 'textbook_reading';
notify pgrst, 'reload schema';
