-- Apply ONLY AFTER the designer-enabled main UI has deployed successfully.
-- Retire the temporary 048 legacy counselor-builder entry point. The new
-- designer RPC and its private wrapper remain executable by their owners.
-- No exam, enrollment, answer, profile or report data is changed.
revoke all on function public.save_booklet_exam_with_window(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text,timestamptz) from public,anon,authenticated;
revoke all on function public.save_exam(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text) from public,anon,authenticated;
revoke all on function public.save_exam(uuid,text,text,public.exam_mode,public.exam_audience,text,public.content_status,jsonb) from public,anon,authenticated;
-- Operational rollback of the cutover alone (if the old UI must be restored):
-- grant execute on function public.save_booklet_exam_with_window(uuid,text,text,public.exam_audience,timestamptz,public.content_status,jsonb,text,timestamptz) to authenticated;
