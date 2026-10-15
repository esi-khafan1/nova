-- Run as the database owner on a test environment; all QA rows are rolled back.
begin;
set local statement_timeout='20s';
do $$
declare coach uuid; student uuid; eid uuid; row_a record; row_b record; outcome record; stamp timestamptz; denied boolean;
begin
 select cs.counselor_id,cs.student_id into coach,student from public.counselor_students cs join public.profiles p on p.id=cs.student_id join public.counselor_profiles cp on cp.user_id=cs.counselor_id where p.registration_status='active' and cp.approval_status='approved' limit 1;
 insert into public.exams(counselor_id,title,mode,status,starts_at,start_window_ends_at,duration_minutes) values(coach,'Floating deadline QA temporary','booklet','published',clock_timestamp()-interval '1 hour',clock_timestamp()+interval '1 hour',3) returning id into eid;
 insert into public.exam_booklets(exam_id,title,pdf_url,question_count,start_question_number,end_question_number,duration_minutes,sort_order,key_answers) values(eid,'First','https://example.invalid/qa.pdf',1,1,1,1,0,'{"1":2}'),(eid,'Second','https://example.invalid/qa.pdf',1,2,2,1,1,'{"2":3}'),(eid,'Third','https://example.invalid/qa.pdf',1,3,3,1,2,'{"3":4}');
 perform set_config('request.jwt.claim.sub',student::text,true);
 select * into row_a from public.begin_floating_exam(eid);
 perform public.update_floating_exam_progress(eid,0,'{"1":2}',false);
 stamp:=clock_timestamp();
 update public.exam_sessions set started_at=stamp-interval '70 seconds',expires_at=stamp+interval '110 seconds',booklet_started_at=stamp-interval '70 seconds' where exam_id=eid;
 select * into row_b from public.update_floating_exam_progress(eid,0,'{"1":4}',true);
 if row_b.booklet_started_at<>stamp-interval '10 seconds' or row_b.answers->>'1'<>'2' then raise exception 'Overdue booklet extended or late answer accepted';end if;
 update public.exam_sessions set started_at=stamp-interval '4 minutes',expires_at=stamp-interval '1 minute',booklet_started_at=stamp-interval '3 minutes' where exam_id=eid;
 denied:=false;begin perform public.begin_floating_exam(eid);exception when others then if SQLERRM='Exam session has expired' then denied:=true;else raise;end if;end;
 if not denied then raise exception 'Expired session restarted';end if;
 denied:=false;begin perform public.update_floating_exam_progress(eid,1,'{"2":3}',false);exception when others then if SQLERRM='Exam session has expired' then denied:=true;else raise;end if;end;
 if not denied then raise exception 'Expired draft accepted';end if;
 select * into outcome from public.submit_floating_booklet_exam(eid,null,'{}',true);
 if outcome.correct_answers<>1 or outcome.unanswered_count<>2 then raise exception 'Saved-only finalization changed answers';end if;
end $$;
rollback;
select 'PASS: overdue modal cannot extend timing, late edits rejected, expired session cannot restart, saved-only finalization preserves answers; all QA writes rolled back' as result;
