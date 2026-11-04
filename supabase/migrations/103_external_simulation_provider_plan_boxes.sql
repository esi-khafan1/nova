-- External/institutional mock exams are selected in the subject box, distinct
-- from the existing simulation_exam activity and from Nova's exam designer.
-- No new table: keep the selected provider in the subject of this box.
alter type public.study_activity_type add value if not exists 'external_simulation_exam';

alter table public.weekly_plan_items add constraint external_simulation_provider_check check (
  activity_type::text <> 'external_simulation_exam' or (
    left(subject, char_length('آزمون شبیه‌ساز · ')) = 'آزمون شبیه‌ساز · '
    and char_length(substring(subject from char_length('آزمون شبیه‌ساز · ') + 1)) between 2 and 60
    and substring(subject from char_length('آزمون شبیه‌ساز · ') + 1) = btrim(substring(subject from char_length('آزمون شبیه‌ساز · ') + 1))
    and subject !~ '[[:cntrl:]]'
    and chapter is null and target_test_count is null
    and source_grade is null and preparation_track = 'konkur'
    and exam_year is null and recommended_publisher is null
  )
);

-- Preserve v8's existing authorization, day/completion locks, routines,
-- curriculum, publisher and designer-link behavior. Validate the new kind
-- before delegating so a caller cannot bypass the subject/provider rules.
create function public.save_weekly_plan_v9(
  target_plan_id uuid, target_student_id uuid, target_week_start date,
  target_title text, target_notes text, target_status public.content_status,
  target_items jsonb, target_routines jsonb
) returns uuid language plpgsql security definer set search_path = '' as $$
declare item jsonb; subject_value text; provider text;
begin
  if jsonb_typeof(target_items) is distinct from 'array' then
    raise exception 'Invalid items';
  end if;
  for item in select value from jsonb_array_elements(target_items) loop
    if item->>'activityType' = 'external_simulation_exam' then
      subject_value := item->>'subject';
      provider := substring(subject_value from char_length('آزمون شبیه‌ساز · ') + 1);
      if subject_value is null
        or left(subject_value, char_length('آزمون شبیه‌ساز · ')) <> 'آزمون شبیه‌ساز · '
        or char_length(provider) not between 2 and 60
        or provider <> btrim(provider) or subject_value ~ '[[:cntrl:]]'
        or coalesce(item->>'chapter', '') <> ''
        or item->>'targetTestCount' is not null
        or item->>'sourceGrade' is not null
        or item->>'preparationTrack' is distinct from 'konkur'
        or item->>'examYear' is not null
        or item->>'recommendedPublisher' is not null
      then raise exception 'Invalid external simulation provider or metadata'; end if;
    end if;
  end loop;
  return public.save_weekly_plan_v8(
    target_plan_id, target_student_id, target_week_start, target_title,
    target_notes, target_status, target_items, target_routines
  );
end; $$;
revoke all on function public.save_weekly_plan_v9(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) from public,anon;
grant execute on function public.save_weekly_plan_v9(uuid,uuid,date,text,text,public.content_status,jsonb,jsonb) to authenticated;
notify pgrst, 'reload schema';
