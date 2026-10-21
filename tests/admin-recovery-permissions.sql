-- Run as database owner; assertions only, no emails, no persisted test rows.
begin;
select set_config('test.super_id',(select user_id::text from private.super_admins limit 1),true);
select set_config('test.admin_id',(select id::text from public.profiles where role='admin' and id not in(select user_id from private.super_admins) limit 1),true);
select set_config('test.student_id',(select id::text from public.profiles where role='student' limit 1),true);
set local role authenticated;
do $$
declare target uuid:=current_setting('test.student_id')::uuid; blocked boolean; email text;
begin
  if target is null or nullif(current_setting('test.admin_id'),'') is null or nullif(current_setting('test.super_id'),'') is null then raise exception 'Missing test actors'; end if;
  perform set_config('request.jwt.claim.sub',current_setting('test.admin_id'),true);
  blocked:=false;
  begin perform public.admin_prepare_password_recovery(current_setting('test.super_id')::uuid); exception when insufficient_privilege then blocked:=true; end;
  if not blocked then raise exception 'Regular admin can reset super-admin'; end if;
  email:=public.admin_prepare_password_recovery(target);
  if email is null then raise exception 'Regular admin recovery failed'; end if;
  blocked:=false;
  begin perform public.admin_prepare_password_recovery(target); exception when raise_exception then blocked:=true; end;
  if not blocked then raise exception 'Recovery cooldown bypassed'; end if;
  perform set_config('request.jwt.claim.sub',current_setting('test.super_id'),true);
  email:=public.admin_prepare_password_recovery(current_setting('test.admin_id')::uuid);
  if email is null then raise exception 'Super admin recovery failed'; end if;
  perform set_config('request.jwt.claim.sub',current_setting('test.student_id'),true);
  blocked:=false;
  begin perform public.admin_prepare_password_recovery(target); exception when insufficient_privilege then blocked:=true; end;
  if not blocked then raise exception 'Student initiated recovery'; end if;
end;
$$;
rollback;
