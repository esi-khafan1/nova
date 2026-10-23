create or replace function public.admin_set_user_role(
  target_user_id uuid,
  target_role public.app_role
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  actor_role public.app_role;
  current_target_role public.app_role;
begin
  select role into actor_role
  from public.profiles
  where id = (select auth.uid());

  if actor_role is distinct from 'admin'::public.app_role then
    raise exception 'Only administrators can change user roles';
  end if;

  if target_role not in (
    'student'::public.app_role,
    'counselor'::public.app_role,
    'exam_designer'::public.app_role,
    'admin'::public.app_role,
    'content_manager'::public.app_role,
    'support_agent'::public.app_role
  ) then
    raise exception 'Unsupported target role';
  end if;

  select role into current_target_role
  from public.profiles
  where id = target_user_id
  for update;

  if not found then
    raise exception 'User not found';
  end if;

  if (target_role in ('admin'::public.app_role,'content_manager'::public.app_role) or current_target_role in ('admin'::public.app_role,'content_manager'::public.app_role)) and not private.is_super_admin() then
    raise exception 'Only super administrators can grant admin access' using errcode = '42501';
  end if;

  if exists(select 1 from public.admin_list_super_admins() a where a.user_id=target_user_id) then
    raise exception 'Super administrator accounts are protected' using errcode='42501';
  end if;

  if target_role = 'counselor'::public.app_role then
    if exists (
      select 1
      from public.counselor_profiles
      where user_id = target_user_id
    ) then
      update public.counselor_profiles
      set approval_status = 'approved'
      where user_id = target_user_id;
    else
      insert into public.counselor_profiles (
        user_id,
        headline,
        approval_status,
        is_accepting
      )
      values (
        target_user_id,
        'مشاور نووا',
        'approved',
        false
      );
    end if;

    update public.profiles
    set role = 'counselor'
    where id = target_user_id;
  else
    delete from public.counselor_profiles
    where user_id = target_user_id;

    update public.profiles
    set role = target_role
    where id = target_user_id;
  end if;
end;
$$;

revoke all on function public.admin_set_user_role(uuid, public.app_role)
from public, anon;

grant execute on function public.admin_set_user_role(uuid, public.app_role)
to authenticated;


create table private.support_threads (
 id uuid primary key default gen_random_uuid(), token_hash text unique not null,
 user_id uuid, -- Retain an ownership tombstone after account deletion; never turn private chats into guest chats.
 unanswered boolean not null default true, created_at timestamptz not null default now(),updated_at timestamptz not null default now()
);
create table private.support_messages (
 id bigint generated always as identity primary key,
 thread_id uuid not null references private.support_threads(id),
 sender text not null check(sender in ('visitor','support')),
 body text not null check(char_length(body) between 1 and 2000),
 agent_id uuid references public.profiles(id) on delete set null,
 created_at timestamptz not null default clock_timestamp()
);
create index on private.support_threads(unanswered,updated_at desc);
create index on private.support_messages(thread_id,id);
alter table private.support_threads enable row level security;
alter table private.support_messages enable row level security;
revoke all on private.support_threads,private.support_messages from public,anon,authenticated;

create function private.support_read(tid uuid,after_id bigint) returns jsonb language sql stable set search_path='' as $$
 select jsonb_build_object('realtime_topic','nova-support:'||tid::text,'messages',coalesce((select jsonb_agg(m order by m.id) from
 (select id,sender,body,created_at from private.support_messages where thread_id=tid and id>after_id order by id limit 200) m),'[]'::jsonb));
$$;
revoke all on function private.support_read(uuid,bigint) from public,anon,authenticated;

create function public.support_visitor(visitor_token text,after_id bigint default 0,message_text text default null)
returns jsonb language plpgsql security definer set search_path='' as $$
declare t private.support_threads; h text; msg text:=btrim(message_text); uid uuid:=(select auth.uid());
begin
 if visitor_token is null or visitor_token !~ '^[a-f0-9]{64}$' or after_id is null or after_id<0 then raise exception 'Invalid request'; end if;
 if message_text is not null and (msg is null or char_length(msg) not between 1 and 2000) then raise exception 'Invalid message'; end if;
 h:=encode(sha256(convert_to(visitor_token,'UTF8')),'hex');
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(h,701));
 select * into t from private.support_threads where token_hash=h for update;
 if t.id is null then
  if msg is null then return jsonb_build_object('messages','[]'::jsonb); end if;
  perform pg_catalog.pg_advisory_xact_lock(701,1);
  if (select count(*) from private.support_threads where created_at>now()-interval '1 minute')>=60 then raise exception 'Please try later'; end if;
  insert into private.support_threads(token_hash,user_id) values(h,uid) returning * into t;
 end if;
 if t.user_id is not null and t.user_id is distinct from uid then raise exception 'Session changed' using errcode='42501'; end if;
 if t.user_id is null and uid is not null then update private.support_threads set user_id=uid where id=t.id; end if;
 if msg is not null then
  if exists(select 1 from private.support_messages where thread_id=t.id and sender='visitor' and created_at>clock_timestamp()-interval '2 seconds')
   or (select count(*) from private.support_messages where thread_id=t.id and sender='visitor' and created_at>now()-interval '1 hour')>=60 then raise exception 'Please wait before sending'; end if;
  insert into private.support_messages(thread_id,sender,body) values(t.id,'visitor',msg);
  update private.support_threads set unanswered=true,updated_at=clock_timestamp() where id=t.id;
 end if;
 return private.support_read(t.id,after_id);
end; $$;
revoke all on function public.support_visitor(text,bigint,text) from public;
grant execute on function public.support_visitor(text,bigint,text) to anon,authenticated;

create function public.support_inbox(needs_reply boolean,page_number integer default 0)
returns jsonb language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'support_agent'::public.app_role then raise exception 'Support only' using errcode='42501'; end if;
 if needs_reply is null or page_number is null or page_number<0 or page_number>100000 then raise exception 'Invalid filter'; end if;
 return coalesce((select jsonb_agg(r order by r.updated_at desc,r.id) from (
  select t.id,t.unanswered,t.updated_at,case when t.user_id is null then 'مهمان' else coalesce(nullif(p.full_name,''),'کاربر نووا') end as visitor_name,
   (select body from private.support_messages m where m.thread_id=t.id order by id desc limit 1) as preview,
   count(*) over() as total_count
  from private.support_threads t left join public.profiles p on p.id=t.user_id
  where t.unanswered=needs_reply order by t.updated_at desc,t.id limit 50 offset page_number*50
 ) r),'[]'::jsonb);
end; $$;
revoke all on function public.support_inbox(boolean,integer) from public,anon;
grant execute on function public.support_inbox(boolean,integer) to authenticated;

create function public.support_agent_thread(target_thread uuid,after_id bigint default 0,message_text text default null)
returns jsonb language plpgsql security definer set search_path='' as $$
declare msg text:=btrim(message_text);
begin
 if (select private.current_user_role()) is distinct from 'support_agent'::public.app_role then raise exception 'Support only' using errcode='42501'; end if;
 if after_id is null or after_id<0 then raise exception 'Invalid cursor'; end if;
 perform 1 from private.support_threads where id=target_thread for update;
 if not found then raise exception 'Thread unavailable'; end if;
 if message_text is not null then
  if msg is null or char_length(msg) not between 1 and 2000 then raise exception 'Invalid message'; end if;
  insert into private.support_messages(thread_id,sender,body,agent_id) values(target_thread,'support',msg,auth.uid());
  update private.support_threads set unanswered=false,updated_at=clock_timestamp() where id=target_thread;
 end if;
 return private.support_read(target_thread,after_id);
end; $$;
revoke all on function public.support_agent_thread(uuid,bigint,text) from public,anon;
grant execute on function public.support_agent_thread(uuid,bigint,text) to authenticated;
notify pgrst,'reload schema';

-- Opaque capability topics carry ONLY invalidation, never messages or identities.
create table private.support_live_config(id boolean primary key default true check(id),topic text not null default ('nova-inbox:'||gen_random_uuid()::text));
insert into private.support_live_config(id) values(true);
alter table private.support_live_config enable row level security;
revoke all on private.support_live_config from public,anon,authenticated;
create function public.support_inbox_topic() returns text language plpgsql security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'support_agent'::public.app_role then raise exception 'Support only' using errcode='42501'; end if;
 return (select topic from private.support_live_config where id);
end; $$;
revoke all on function public.support_inbox_topic() from public,anon;
grant execute on function public.support_inbox_topic() to authenticated;
create function private.support_notify() returns trigger language plpgsql security definer set search_path='' as $$
declare topic text;
begin
 -- Notification failure/quotas must never roll back a saved support message.
 begin
  perform realtime.send('{"changed":true}'::jsonb,'changed','nova-support:'||new.thread_id::text,false);
  select c.topic into topic from private.support_live_config c where c.id;
  perform realtime.send('{"changed":true}'::jsonb,'changed',topic,false);
 exception when others then null;
 end;
 return new;
end; $$;
revoke all on function private.support_notify() from public,anon,authenticated;
create trigger support_live_notify after insert on private.support_messages for each row execute function private.support_notify();
