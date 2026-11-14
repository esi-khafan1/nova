-- The application only opts into the private editor when every required RPC,
-- including the reviewed publisher, is installed and callable. This does not
-- grant the publisher: a separate, reviewed release is still required.
create function public.planner_editor_available() returns boolean
language plpgsql stable security definer set search_path='' as $$
declare signature text; routine oid;
begin
 perform private.require_planner_preset_access();
 foreach signature in array array[
  'public.planner_get_working_draft(uuid,date)',
  'public.planner_save_working_draft_checked(uuid,date,uuid,jsonb,text,timestamp with time zone)',
  'public.planner_discard_working_draft(uuid,date,text)',
  'public.planner_publish_working_draft(uuid,date,text)',
  'public.planner_get_published_extras(uuid)',
  'public.planner_list_presets(text)',
  'public.planner_save_preset(uuid,text,text,jsonb,boolean,text)',
  'public.planner_delete_preset(uuid,text)',
  'public.planner_review_week(uuid,date)',
  'public.planner_set_review_completed(uuid,integer,boolean)',
  'public.planner_set_historical_review_completed(uuid,boolean)',
  'public.planner_list_topics(text,text,text,text,text,text)',
  'public.planner_save_topic(uuid,text,text,text,text,text,text,text,text,integer,integer,integer)',
  'public.planner_delete_topic(uuid,text)',
  'public.planner_topic_history(uuid,date,integer,text,text,text)'
 ] loop
  routine:=pg_catalog.to_regprocedure(signature);
  if routine is null or not pg_catalog.has_function_privilege('authenticated',routine,'EXECUTE') then return false; end if;
 end loop;
 return true;
end; $$;
revoke all on function public.planner_editor_available() from public,anon;
grant execute on function public.planner_editor_available() to authenticated;
notify pgrst, 'reload schema';
