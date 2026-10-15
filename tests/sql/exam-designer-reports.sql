-- Integration QA, including authenticated RLS. Every change is rolled back.
begin;
set local statement_timeout='30s';
select set_config('qa.admin',(select id::text from public.profiles where role='admin' limit 1),true);
select set_config('qa.designer',(select p.id::text from public.profiles p join auth.users u on u.id=p.id where lower(u.email)='doob58157@gmail.com'),true);
select set_config('qa.student',(select p.id::text from public.profiles p join public.counselor_students cs on cs.student_id=p.id where p.role='student' and p.registration_status='active' and p.id::text<>current_setting('qa.designer') limit 1),true);
select set_config('qa.counselor',(select cs.counselor_id::text from public.counselor_students cs where cs.student_id::text=current_setting('qa.student') limit 1),true);
select set_config('qa.other',(select p.id::text from public.profiles p where p.role='student' and p.id::text not in (current_setting('qa.designer'),current_setting('qa.student')) limit 1),true);
select set_config('request.jwt.claim.sub',current_setting('qa.admin'),true);
select public.admin_set_user_role(current_setting('qa.designer')::uuid,'exam_designer');
set local role authenticated;
select set_config('request.jwt.claim.sub',current_setting('qa.designer'),true);
do $$ declare b jsonb;eid uuid;denied boolean;details jsonb;begin
 if (select count(*) from public.search_exam_students('',0,51))<2 then raise exception 'Directory not complete';end if;
 select jsonb_agg(item||jsonb_build_object('pdfUrl','https://example.invalid/qa.pdf','keyAnswers',(select jsonb_object_agg(q::text,1) from generate_series((item->'subjects'->0->>'start')::integer,(item->'subjects'->-1->>'end')::integer) q))) into b from jsonb_array_elements('[{"title":"ریاضی","questionCount":40,"durationMinutes":70,"subjects":[{"start":1,"end":40}]},{"title":"فیزیک و شیمی","questionCount":65,"durationMinutes":75,"subjects":[{"start":41,"end":105}]}]'::jsonb) item;
 denied:=false;begin perform public.save_designer_exam(null,'QA tampered',null,array[current_setting('qa.student')::uuid],now()+interval '2 hours','published',jsonb_set(b,'{1,questionCount}','64'),'mathematics',null);exception when others then if SQLERRM='Invalid exam template' then denied:=true;else raise;end if;end;
 if not denied then raise exception 'Tampered template accepted';end if;
 denied:=false;begin perform public.save_designer_exam(null,'QA no recipients',null,array[]::uuid[],now()+interval '2 hours','published',b,'mathematics',null);exception when others then if SQLERRM='Invalid selected students' then denied:=true;else raise;end if;end;
 if not denied then raise exception 'Empty recipients accepted';end if;
 eid:=public.save_designer_exam(null,'QA subject boundaries',null,array[current_setting('qa.student')::uuid],now()+interval '2 hours','published',b,'mathematics',null);
 perform set_config('qa.exam',eid::text,true);
 details:=public.designer_exam_details(eid);
 if jsonb_array_length(details->'booklets')<>2 or (details->'booklets'->1->'subject_ranges'->1->>'start')::integer<>76 then raise exception 'Canonical chemistry boundary wrong';end if;
 denied:=false;begin perform key_answers from public.exam_booklets where exam_id=eid;exception when insufficient_privilege then denied:=true;end;if not denied then raise exception 'Direct key SELECT permitted';end if;
 denied:=false;begin perform * from public.exam_attempts_for_counselor(eid);exception when insufficient_privilege then denied:=true;end;if not denied then raise exception 'Designer can review reports';end if;
 denied:=false;begin perform public.save_exam(null,'QA obsolete',null,'own_students',now()+interval '2 hours','draft',b,null);exception when insufficient_privilege then denied:=true;end;if not denied then raise exception 'Obsolete save callable';end if;
end $$;
reset role;
update public.exams set starts_at=now()-interval '1 minute' where id::text=current_setting('qa.exam');
set local role authenticated;
select set_config('request.jwt.claim.sub',current_setting('qa.other'),true);
do $$ begin
 if exists(select 1 from public.exams where id::text=current_setting('qa.exam')) then raise exception 'Unselected student sees exam';end if;
end $$;
select set_config('request.jwt.claim.sub',current_setting('qa.student'),true);
do $$ declare result record;ans jsonb;denied boolean;begin
 if not exists(select 1 from public.exams where id::text=current_setting('qa.exam')) then raise exception 'Selected student cannot see exam';end if;
 denied:=false;begin perform * from public.search_exam_students('',0,51);exception when insufficient_privilege then denied:=true;end;if not denied then raise exception 'Student can search full directory';end if;
 select jsonb_object_agg(q::text,case when q<=75 then 1 else 2 end) into ans from generate_series(41,105) q;
 select * into result from public.submit_booklet_exam(current_setting('qa.exam')::uuid,ans);
 if result.score<>23.81 or result.correct_answers<>35 or result.incorrect_answers<>30 or result.unanswered_count<>40 then raise exception 'Precise grading incorrect: %',row_to_json(result);end if;
 denied:=false;begin perform * from public.exam_booklets_for_student_report(current_setting('qa.exam')::uuid);exception when insufficient_privilege then denied:=true;end;if not denied then raise exception 'Early report available';end if;
 if exists(select 1 from public.student_exam_subject_history(current_setting('qa.student')::uuid,12) where exam_id::text=current_setting('qa.exam')) then raise exception 'Early report history leaked';end if;
end $$;
reset role;
update public.exams set starts_at=now()-interval '146 minutes' where id::text=current_setting('qa.exam');
set local role authenticated;
select set_config('request.jwt.claim.sub',current_setting('qa.student'),true);
do $$ declare v numeric;begin
 if (select count(*) from public.exam_booklets_for_student_report(current_setting('qa.exam')::uuid))<>2 then raise exception 'Student report missing';end if;
 select percentage into v from public.student_exam_subject_history(current_setting('qa.student')::uuid,12) where exam_id::text=current_setting('qa.exam') and subject_title='فیزیک';if v is distinct from 100::numeric then raise exception 'Physics percentage swapped: %',v;end if;
 select percentage into v from public.student_exam_subject_history(current_setting('qa.student')::uuid,12) where exam_id::text=current_setting('qa.exam') and subject_title='شیمی';if v is distinct from (-33.33)::numeric then raise exception 'Chemistry percentage swapped: %',v;end if;
end $$;
select set_config('request.jwt.claim.sub',current_setting('qa.counselor'),true);
do $$ declare denied boolean;begin
 if (select count(*) from public.exam_attempts_for_counselor(current_setting('qa.exam')::uuid))<>1 then raise exception 'Assigned counselor cannot see attempt';end if;
 if (select count(*) from public.exam_booklets_for_counselor(current_setting('qa.exam')::uuid))<>2 then raise exception 'Counselor report missing';end if;
 denied:=false;begin perform public.save_designer_exam(null,'QA denied',null,array[current_setting('qa.student')::uuid],now()+interval '2 hours','draft','[]',null,null);exception when insufficient_privilege then denied:=true;end;if not denied then raise exception 'Counselor can create exam';end if;
end $$;
-- Production cutover: obsolete counselor RPC is no longer callable.
select set_config('request.jwt.claim.sub',current_setting('qa.counselor'),true);
do $$ declare denied boolean:=false;begin
 begin
  perform public.save_booklet_exam_with_window(null,'QA obsolete counselor builder',null,'own_students',now()+interval '2 hours','draft','[{"title":"ریاضی","questionCount":20,"durationMinutes":30,"pdfUrl":"","keyAnswers":{}}]'::jsonb,'mathematics',null);
 exception when insufficient_privilege then denied:=true;
 end;
 if not denied then raise exception 'Legacy counselor builder still callable after production cutover';end if;
end $$;
select set_config('request.jwt.claim.sub',current_setting('qa.designer'),true);
do $$ begin
 if exists(select 1 from public.exam_attempts where exam_id::text=current_setting('qa.exam')) then raise exception 'Designer sees results via table';end if;
end $$;
rollback;
select 'PASS: immutable template, recipient selection, RLS, role separation and retired legacy counselor builder, 23.81% precision, correct physics/chemistry boundaries, global report-release guard, identical subject history. QA data rolled back.' as result;
