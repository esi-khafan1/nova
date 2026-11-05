-- Designer-only read of counselor notes on published Nova exam boxes. No
-- public table or student projection is added. The existing exam-only box RPC
-- enforces the designer role, active student and published plan restrictions.
create function public.designer_exam_box_notes()
returns table(item_id uuid, note text)
language sql stable security definer set search_path = '' as $$
 select b.item_id, i.details
 from public.designer_exam_boxes() b
 join public.weekly_plan_items i on i.id=b.item_id
 where i.activity_type::text='exam' and i.details is not null;
$$;
revoke all on function public.designer_exam_box_notes() from public,anon;
grant execute on function public.designer_exam_box_notes() to authenticated;

-- Five most recent *started* published booklet exams for one currently
-- assigned student, with a sixth row to determine whether another page exists.
-- Include explicit enrollment, linked plan boxes and submitted historical
-- attempts. Never expose another counselor's student or their exam attempts.
create function public.counselor_student_exam_history(
 target_student_id uuid, page_offset integer default 0, page_size integer default 6
) returns table(
 exam_id uuid, title text, starts_at timestamptz, attempt_id uuid,
 submitted_at timestamptz, score numeric
) language plpgsql stable security definer set search_path = '' as $$
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role
    or not exists(select 1 from public.counselor_students cs
                  where cs.student_id=target_student_id and cs.counselor_id=(select auth.uid()))
 then raise exception 'Student not assigned' using errcode='42501'; end if;
 if page_offset is null or page_offset < 0 or page_offset > 10000
    or page_size is null or page_size < 1 or page_size > 6
 then raise exception 'Invalid page'; end if;
 return query
 select e.id, e.title, e.starts_at, a.id, a.submitted_at, a.score
 from public.exams e
 left join lateral (
   select attempt.id,attempt.submitted_at,attempt.score
   from public.exam_attempts attempt
   where attempt.exam_id=e.id and attempt.student_id=target_student_id
     and attempt.submitted_at is not null
   order by attempt.submitted_at desc,attempt.id desc limit 1
 ) a on true
 where e.status='published' and e.mode='booklet' and e.starts_at <= now()
   and (private.student_can_access_exam(e.id,target_student_id)
        or exists(select 1 from public.exam_attempts old_attempt
          where old_attempt.exam_id=e.id and old_attempt.student_id=target_student_id
            and old_attempt.submitted_at is not null))
 order by e.starts_at desc,e.id desc
 limit page_size offset page_offset;
end $$;
revoke all on function public.counselor_student_exam_history(uuid,integer,integer) from public,anon;
grant execute on function public.counselor_student_exam_history(uuid,integer,integer) to authenticated;
notify pgrst, 'reload schema';
