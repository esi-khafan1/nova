-- SQL CHECK treats UNKNOWN as passing. After relaxing NOT NULL for grade nine,
-- explicitly require a field for grades 10-12, including direct database writes.
alter table public.student_registrations drop constraint student_registrations_study_field_check;
alter table public.student_registrations add constraint student_registrations_study_field_check check (
 (grade=9 and study_field is null) or
 (grade in (10,11,12) and study_field is not null and study_field::text in
  ('mathematics','experimental_sciences','humanities','arts','foreign_languages'))
);
notify pgrst,'reload schema';
