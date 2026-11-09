-- The second factor and security audit are private; no browser can read or
-- modify these records or call the service-only functions directly.
create table private.student_login_challenges (
 id uuid primary key,
 actor_id uuid not null,
 session_id uuid not null,
 email text not null,
 action text not null check (action in ('create','password','confirm','password_confirm')),
 phone text not null check (phone ~ '^989[0-9]{9}$'),
 target_id uuid references auth.users(id) on delete set null,
 code_digest text not null check (code_digest ~ '^[a-f0-9]{64}$'),
 created_at timestamptz not null default now(),
 expires_at timestamptz not null default now() + interval '5 minutes',
 attempts integer not null default 0,
 state text not null default 'pending' check (state in ('pending','running','success','failed','unknown')),
 finished_at timestamptz
);
alter table private.student_login_challenges enable row level security;
revoke all on private.student_login_challenges from public, anon, authenticated;
create index student_login_challenges_actor_created on private.student_login_challenges(actor_id,created_at desc);
create index student_login_challenges_running_target on private.student_login_challenges(target_id,expires_at) where state in ('running','unknown');

create function public.superadmin_student_login_lookup(target_phone text)
returns table(student_id uuid, full_name text, phone_confirmed boolean)
language plpgsql stable security definer set search_path='' as $$
begin
 if not private.is_super_admin() then raise exception 'Super admin only' using errcode='42501'; end if;
 if target_phone !~ '^989[0-9]{9}$' then raise exception 'Invalid phone'; end if;
 return query select p.id,p.full_name,u.phone_confirmed_at is not null
  from auth.users u join public.profiles p on p.id=u.id
  where u.phone=target_phone and p.role='student';
end;$$;
revoke all on function public.superadmin_student_login_lookup(text) from public,anon;
grant execute on function public.superadmin_student_login_lookup(text) to authenticated;

-- The role check is repeated under row lock when the code is consumed. While
-- the Admin Auth request is in flight, prevent promotion of that target.
create function private.guard_student_login_role_change() returns trigger
language plpgsql security definer set search_path='' as $$
begin
 if new.role is distinct from old.role and exists (
   select 1 from private.student_login_challenges c
   where c.target_id=old.id and c.state in ('running','unknown') and c.expires_at > now()
 ) then raise exception 'Student login operation in progress'; end if;
 return new;
end;$$;
revoke all on function private.guard_student_login_role_change() from public,anon,authenticated;
create trigger guard_student_login_role_change before update of role on public.profiles
 for each row execute function private.guard_student_login_role_change();

-- The verified operation refers to the exact phone seen in the email; it must
-- not be swapped between verification and the Auth Admin API call.
create function private.guard_student_login_phone_change() returns trigger
language plpgsql security definer set search_path='' as $$
begin
 if new.phone is distinct from old.phone and exists (
   select 1 from private.student_login_challenges c
   where c.target_id=old.id and c.state in ('running','unknown') and c.expires_at > now()
 ) then raise exception 'Student login operation in progress'; end if;
 return new;
end;$$;
revoke all on function private.guard_student_login_phone_change() from public,anon,authenticated;
create trigger guard_student_login_phone_change before update of phone on auth.users
 for each row execute function private.guard_student_login_phone_change();

create function public.service_student_login_challenge_start(
 challenge_id uuid, actor uuid, session uuid, verified_email text, operation text,
 target_phone text, target uuid, digest text
) returns boolean language plpgsql security definer set search_path='' as $$
begin
 if not exists (select 1 from private.super_admins s join public.profiles p on p.id=s.user_id
  join auth.users u on u.id=s.user_id where s.user_id=actor and p.role='admin'
  and u.email_confirmed_at is not null and u.email=verified_email) then return false; end if;
 if operation not in ('create','password','confirm','password_confirm') or target_phone !~ '^989[0-9]{9}$' or digest !~ '^[a-f0-9]{64}$' then return false; end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(actor::text,91947));
 if exists (select 1 from private.student_login_challenges where actor_id=actor and created_at > now()-interval '60 seconds')
   or (select count(*) from private.student_login_challenges where actor_id=actor and created_at > now()-interval '1 hour') >= 10 then return false; end if;
 if operation='create' then
   if target is not null or exists(select 1 from auth.users where phone=target_phone) then return false; end if;
 else
   if not exists(select 1 from auth.users u join public.profiles p on p.id=u.id
      where u.id=target and u.phone=target_phone and p.role='student'
      and (operation not in ('confirm','password_confirm') or u.phone_confirmed_at is null)) then return false; end if;
 end if;
 update private.student_login_challenges set state='failed',finished_at=now() where actor_id=actor and state='pending';
 insert into private.student_login_challenges(id,actor_id,session_id,email,action,phone,target_id,code_digest)
 values(challenge_id,actor,session,verified_email,operation,target_phone,target,digest);
 return true;
end;$$;
revoke all on function public.service_student_login_challenge_start(uuid,uuid,uuid,text,text,text,uuid,text) from public,anon,authenticated;
grant execute on function public.service_student_login_challenge_start(uuid,uuid,uuid,text,text,text,uuid,text) to service_role;

create function public.service_student_login_challenge_consume(
 challenge_id uuid, actor uuid, session uuid, verified_email text, digest text
) returns jsonb language plpgsql security definer set search_path='' as $$
declare c private.student_login_challenges%rowtype;
begin
 select * into c from private.student_login_challenges where id=challenge_id for update;
 if c.id is null or c.actor_id<>actor or c.session_id<>session or c.email<>verified_email
    or c.state<>'pending' or c.expires_at<=now() or c.attempts>=5
    or not exists (select 1 from private.super_admins s join public.profiles p on p.id=s.user_id
      join auth.users u on u.id=s.user_id where s.user_id=actor and p.role='admin'
      and u.email_confirmed_at is not null and u.email=verified_email) then return null; end if;
 if c.code_digest<>digest then
   update private.student_login_challenges set attempts=attempts+1,
     state=case when attempts+1>=5 then 'failed' else state end where id=c.id;
   return null;
 end if;
 if c.action='create' then
   if exists(select 1 from auth.users where phone=c.phone) then
     update private.student_login_challenges set state='failed',finished_at=now() where id=c.id; return null;
   end if;
 else
   perform 1 from public.profiles p join auth.users u on u.id=p.id
     where p.id=c.target_id and p.role='student' and u.phone=c.phone
       and (c.action not in ('confirm','password_confirm') or u.phone_confirmed_at is null)
     for update of p,u;
   if not found then update private.student_login_challenges set state='failed',finished_at=now() where id=c.id; return null; end if;
 end if;
 update private.student_login_challenges set state='running' where id=c.id;
 return pg_catalog.jsonb_build_object('action',c.action,'phone',c.phone,'target_id',c.target_id);
end;$$;
revoke all on function public.service_student_login_challenge_consume(uuid,uuid,uuid,text,text) from public,anon,authenticated;
grant execute on function public.service_student_login_challenge_consume(uuid,uuid,uuid,text,text) to service_role;

create function public.service_student_login_challenge_finish(challenge_id uuid, succeeded boolean, created_user_id uuid default null, attempted boolean default false)
returns void language plpgsql security definer set search_path='' as $$
declare c private.student_login_challenges%rowtype;
begin
 select * into c from private.student_login_challenges where id=challenge_id and state='running' for update;
 if c.id is null then raise exception 'Challenge not running'; end if;
 if succeeded and c.action='create' then
   update public.profiles p set phone='0'||pg_catalog.substr(c.phone,3)
   from auth.users u where p.id=created_user_id and u.id=p.id and p.role='student' and u.phone=c.phone;
   if not found then raise exception 'New student profile not ready'; end if;
   update private.student_login_challenges set target_id=created_user_id where id=c.id;
 end if;
 update private.student_login_challenges set state=case when succeeded then 'success' when attempted then 'unknown' else 'failed' end,finished_at=now()
 where id=challenge_id;
end;$$;
revoke all on function public.service_student_login_challenge_finish(uuid,boolean,uuid,boolean) from public,anon,authenticated;
grant execute on function public.service_student_login_challenge_finish(uuid,boolean,uuid,boolean) to service_role;
notify pgrst,'reload schema';
