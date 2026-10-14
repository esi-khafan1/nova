begin;
do $$
declare a uuid; c uuid:=gen_random_uuid();s10 uuid:=gen_random_uuid();s12 uuid:=gen_random_uuid();receipt text;pid uuid;blocked boolean;start_day date:=timezone('Asia/Tehran',now())::date+14;payload jsonb;
begin
 select id into a from public.profiles where role='admin' limit 1;if a is null then raise exception 'Admin fixture unavailable';end if;
 insert into auth.users(id,email) select id,id::text||'@test.invalid' from unnest(array[c,s10,s12]) id;
 perform set_config('request.jwt.claim.sub',a::text,true);
 update public.profiles set role='counselor' where id=c;
 insert into public.counselor_profiles(user_id,approval_status)values(c,'approved');
 receipt:=s10::text||'/fixture.png';insert into storage.objects(bucket_id,name,metadata)values('registration-receipts',receipt,'{"mimetype":"image/png","size":100}');
 payload:=jsonb_build_object('full_name','سارا محمدی راد','phone','09121234567','telegram_id','student_1','grade',10,'study_field','mathematics','province','تهران','city','تهران','receipt_path',receipt,'receipt_name','receipt.png');
 perform set_config('request.jwt.claim.sub',s10::text,true);execute 'set local role authenticated';
 blocked:=false;begin perform public.submit_student_registration(payload-'full_name');exception when others then blocked:=true;end;if not blocked then raise exception 'Missing full name accepted';end if;
 perform public.submit_student_registration(payload);
 if not exists(select 1 from public.profiles where id=s10 and full_name='سارا محمدی راد')or not exists(select 1 from public.student_registrations where student_id=s10 and full_name='سارا محمدی راد')then raise exception 'Full name not preserved';end if;
 execute 'reset role';perform set_config('request.jwt.claim.sub',a::text,true);perform public.admin_activate_student(s10,c,receipt);
 update public.profiles set registration_status='active',grade=12,study_field='mathematics' where id=s12;perform public.admin_activate_student(s12,c,null);
 perform set_config('request.jwt.claim.sub',c::text,true);execute 'set local role authenticated';
 pid:=public.save_weekly_plan_v4(null,s10,start_day,'Cross-grade fixture','', 'draft',jsonb_build_array(jsonb_build_object('dayOfWeek',0,'durationMinutes',60,'subject','فارسی ۳','chapter','','activityType','lesson','targetTestCount',null,'details','','sourceGrade',12,'preparationTrack','final_exam','examYear',null)));
 if not exists(select 1 from public.weekly_plan_items where plan_id=pid and source_grade=12)then raise exception 'Grade 12 for grade 10 failed';end if;
 pid:=public.save_weekly_plan_v4(null,s12,start_day,'Cross-grade fixture','', 'draft',jsonb_build_array(jsonb_build_object('dayOfWeek',0,'durationMinutes',60,'subject','ریاضی ۱','chapter','','activityType','lesson','targetTestCount',null,'details','','sourceGrade',10,'preparationTrack','konkur','examYear',null)));
 if not exists(select 1 from public.weekly_plan_items where plan_id=pid and source_grade=10)then raise exception 'Grade 10 for grade 12 failed';end if;
 if has_function_privilege('authenticated','public.sheet_export_snapshot(text)','execute')or has_function_privilege('anon','public.sheet_export_snapshot(text)','execute')then raise exception 'External Sheets still accessible';end if;
 execute 'reset role';
end $$;
select 'Full name preserved; grade 12 for grade 10 and inverse saved; external Sheets disabled' as result;
rollback;
