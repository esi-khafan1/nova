-- Match booklet save_exam validation (each booklet 1..360, total 1..600).
-- Preserve the original 5..360 range for legacy non-booklet modes.
-- No existing exam rows are modified.
begin;
alter table public.exams drop constraint exams_duration_minutes_check;
alter table public.exams add constraint exams_duration_minutes_check check (
  (mode = 'booklet'::public.exam_mode and duration_minutes between 1 and 600)
  or (mode <> 'booklet'::public.exam_mode and duration_minutes between 5 and 360)
);
commit;
