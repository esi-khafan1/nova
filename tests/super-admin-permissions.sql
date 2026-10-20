-- Run with database-owner privileges on a seeded database. All changes roll back.
begin;
select set_config('test.super_id', (select user_id::text from private.super_admins limit 1), true);
select set_config('test.admin_id', (select id::text from public.profiles where role='admin' and id not in(select user_id from private.super_admins) limit 1), true);
select set_config('test.student_id', (select id::text from public.profiles where role='student' limit 1), true);
set local role authenticated;
do $$
declare target uuid := current_setting('test.student_id')::uuid; blocked boolean;
begin
  if target is null or nullif(current_setting('test.admin_id'),'') is null or nullif(current_setting('test.super_id'),'') is null then raise exception 'Missing test actors'; end if;
  perform set_config('request.jwt.claim.sub',current_setting('test.admin_id'),true);
  if private.is_super_admin() then raise exception 'Regular admin has super privilege'; end if;
  blocked := false;
  begin perform public.admin_set_user_role(target,'admin'); exception when insufficient_privilege then blocked := true; end;
  if not blocked then raise exception 'Regular admin granted admin via RPC'; end if;
  blocked := false;
  begin update public.profiles set role='admin' where id=target; exception when insufficient_privilege then blocked := true; end;
  if not blocked then raise exception 'Regular admin granted admin directly'; end if;
  -- Nested exception rolls back the successful test mutation.
  begin
    perform public.admin_set_user_role(target,'exam_designer');
    if not exists(select 1 from public.profiles where id=target and role='exam_designer') then raise exception 'Existing admin capability regressed'; end if;
    raise exception using errcode='P0002', message='Rollback test mutation';
  exception when no_data_found then null; end;
  perform set_config('request.jwt.claim.sub',current_setting('test.super_id'),true);
  if not private.is_super_admin() then raise exception 'Super privilege missing'; end if;
  begin
    perform public.admin_set_user_role(target,'admin');
    if not exists(select 1 from public.profiles where id=target and role='admin') then raise exception 'Super admin promotion failed'; end if;
    raise exception using errcode='P0002', message='Rollback test mutation';
  exception when no_data_found then null; end;
  perform set_config('request.jwt.claim.sub',current_setting('test.student_id'),true);
  if private.is_super_admin() then raise exception 'Student has super privilege'; end if;
  blocked := false;
  begin update public.profiles set role='admin' where id=target; exception when insufficient_privilege then blocked := true; end;
  if not blocked then raise exception 'Student escalated privileges'; end if;
  blocked := false;
  begin insert into private.super_admins(user_id) values(target); exception when insufficient_privilege then blocked := true; end;
  if not blocked then raise exception 'Client wrote protected super-admin capability'; end if;
end;
$$;
rollback;
