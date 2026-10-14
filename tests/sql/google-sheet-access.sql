begin;
do $$
declare administrator uuid;c1 uuid:=gen_random_uuid();c2 uuid:=gen_random_uuid();s1 uuid:=gen_random_uuid();s2 uuid:=gen_random_uuid();credential uuid;master uuid;snapshot jsonb;blocked boolean;
begin
 select id into administrator from public.profiles where role='admin' limit 1;
 if administrator is null then raise exception 'Admin fixture bootstrap unavailable';end if;
 insert into auth.users(id,email) select id,id::text||'@test.invalid' from unnest(array[c1,c2,s1,s2])id;
 perform set_config('request.jwt.claim.sub',administrator::text,true);
 update public.profiles set role='counselor' where id=any(array[c1,c2]);
 insert into public.counselor_profiles(user_id,approval_status)values(c1,'approved'),(c2,'approved');
 update public.profiles set registration_status='active' where id=any(array[s1,s2]);
 insert into public.counselor_students(counselor_id,student_id)values(c1,s1),(c2,s2);
 select id into credential from public.admin_issue_sheet_export_token(repeat('a',64),c1);
 select id into master from public.admin_issue_sheet_export_token(repeat('b',64),null);
 perform public.admin_attach_google_sheet(credential,repeat('S',44));
 snapshot:=public.sheet_export_snapshot(repeat('b',64));
 if (select count(*) from jsonb_array_elements(snapshot->'students') s where s->>'student_id' in(s1::text,s2::text))<>2 then raise exception 'Admin export incomplete';end if;
 perform set_config('request.jwt.claim.sub',c1::text,true);execute 'set local role authenticated';
 if (select count(*) from public.my_google_sheet_links())<>1 then raise exception 'Counselor sheet link missing';end if;
 blocked:=false;begin perform public.admin_issue_sheet_export_token(repeat('c',64),null);exception when others then blocked:=true;end;if not blocked then raise exception 'Counselor can issue global credentials';end if;
 blocked:=false;begin perform * from public.google_sheet_export_tokens;exception when insufficient_privilege then blocked:=true;end;if not blocked then raise exception 'Stored token hashes readable';end if;
 execute 'reset role';perform set_config('request.jwt.claim.sub','',true);execute 'set local role anon';
 snapshot:=public.sheet_export_snapshot(repeat('a',64));
 if snapshot->>'scope'<>'counselor' or snapshot->>'subject_id'<>c1::text or jsonb_array_length(snapshot->'students')<>1 or snapshot->'students'->0->>'student_id'<>s1::text then raise exception 'Counselor export scope leaked';end if;
 blocked:=false;begin perform public.sheet_export_snapshot(repeat('0',64));exception when invalid_authorization_specification then blocked:=true;end;if not blocked then raise exception 'Missing token accepted';end if;
 blocked:=false;begin perform public.admin_list_sheet_export_tokens();exception when insufficient_privilege then blocked:=true;end;if not blocked then raise exception 'Anonymous credential metadata readable';end if;
 execute 'reset role';
 -- Read current assignment, not a frozen list saved at credential creation.
 delete from public.counselor_students where counselor_id=c1 and student_id=s1;
 execute 'set local role anon';snapshot:=public.sheet_export_snapshot(repeat('a',64));if jsonb_array_length(snapshot->'students')<>0 then raise exception 'Former assignment remains exported';end if;execute 'reset role';
 perform set_config('request.jwt.claim.sub',administrator::text,true);perform public.admin_revoke_sheet_export_token(credential);
 execute 'set local role anon';blocked:=false;begin perform public.sheet_export_snapshot(repeat('a',64));exception when invalid_authorization_specification then blocked:=true;end;if not blocked then raise exception 'Revoked token accepted';end if;execute 'reset role';
 update public.google_sheet_export_tokens set expires_at=now()-interval '1 second' where id=master;
 execute 'set local role anon';blocked:=false;begin perform public.sheet_export_snapshot(repeat('b',64));exception when invalid_authorization_specification then blocked:=true;end;if not blocked then raise exception 'Expired token accepted';end if;execute 'reset role';
end;$$;
select 'Scoped read-only export, private links, current assignments, revocation, expiry and metadata permissions passed' as result;
rollback;
