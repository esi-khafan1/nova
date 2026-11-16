-- Enable the validated private-draft publisher after the publication, progress,
-- exam-link and concurrent-write safeguards have been exercised together.
-- The unvalidated implementation and validator remain private.
do $$
begin
  if to_regprocedure('public.planner_publish_working_draft(uuid,date,text)') is null
     or to_regprocedure('private.planner_publish_working_draft_unvalidated(uuid,date,text)') is null
     or to_regprocedure('private.planner_validate_publication(uuid,uuid,date,jsonb)') is null then
    raise exception 'Reviewed planner publication dependencies are missing';
  end if;
  if has_function_privilege('anon','public.planner_publish_working_draft(uuid,date,text)','EXECUTE')
     or has_function_privilege('authenticated','private.planner_publish_working_draft_unvalidated(uuid,date,text)','EXECUTE')
     or has_function_privilege('authenticated','private.planner_validate_publication(uuid,uuid,date,jsonb)','EXECUTE') then
    raise exception 'Planner publication privileges are unsafe';
  end if;
end; $$;
grant execute on function public.planner_publish_working_draft(uuid,date,text) to authenticated;
notify pgrst, 'reload schema';
