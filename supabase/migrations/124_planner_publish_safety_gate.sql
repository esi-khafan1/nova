-- Release safety gate, not a replacement for validation. Until the new editor's
-- publication path has authoritative validation and exam-link race protection,
-- no browser or other authenticated client may call the working-draft
-- publisher directly. Private draft operations and every legacy plan endpoint
-- remain unchanged. A later, separately reviewed migration must restore this
-- grant only after the integrated release passes its data-preservation tests.
revoke execute on function public.planner_publish_working_draft(uuid,date,text) from public, anon, authenticated;
notify pgrst, 'reload schema';
