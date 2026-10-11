-- Deploy the updated counselor routes before applying this migration.
-- Table-wide SELECT currently exposes answer keys to eligible students.
revoke select on public.exam_booklets from authenticated,anon,public;
revoke select (key_answers) on public.exam_booklets from authenticated,anon,public;
grant select (id,exam_id,title,pdf_url,question_count,start_question_number,end_question_number,duration_minutes,sort_order,created_at)
 on public.exam_booklets to authenticated;
-- Keys remain available only through ownership/role-checked review RPCs.
