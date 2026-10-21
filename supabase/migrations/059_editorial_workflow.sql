-- Privileged role changes, including direct profile writes, are super-admin only.
create or replace function private.protect_profile_role()
returns trigger language plpgsql security definer set search_path='' as $$
begin
 if new.role is distinct from old.role then
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only' using errcode='42501'; end if;
  if exists(select 1 from private.super_admins where user_id=old.id) then raise exception 'Super administrator accounts are protected' using errcode='42501'; end if;
  if (new.role in ('admin','content_manager') or old.role in ('admin','content_manager')) and not private.is_super_admin() then raise exception 'Super administrator required' using errcode='42501'; end if;
 end if;
 return new;
end; $$;
revoke all on function private.protect_profile_role() from public,anon,authenticated;

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
    'content_manager'::public.app_role
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


create table public.content_submissions (
 id uuid primary key default gen_random_uuid(),
 kind text not null check(kind in ('resources','news','podcasts')),
 content_id uuid not null,
 author_id uuid not null references public.profiles(id) on delete restrict,
 payload jsonb not null check(jsonb_typeof(payload)='object'),
 state text not null default 'draft' check(state in ('draft','pending','rejected','published')),
 version integer not null default 1 check(version>0),
 rejection_reason text,
 reviewer_id uuid references public.profiles(id),
 submitted_at timestamptz,
 reviewed_at timestamptz,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(),
 unique(kind,content_id),
 check(state<>'rejected' or char_length(rejection_reason) between 5 and 2000)
);
create index content_submissions_queue on public.content_submissions(state,updated_at desc);
create index content_submissions_author on public.content_submissions(author_id,kind,updated_at desc);
alter table public.content_submissions enable row level security;
grant select on public.content_submissions to authenticated;
revoke insert,update,delete on public.content_submissions from public,anon,authenticated;
create policy submissions_read on public.content_submissions for select to authenticated using(author_id=(select auth.uid()) or ((select private.current_user_role())='content_manager' and state<>'draft'));

create table private.content_review_events (
 id bigint generated always as identity primary key,
 submission_id uuid not null references public.content_submissions(id),
 version integer not null,
 reviewer_id uuid not null references public.profiles(id),
 decision text not null,
 reason text,
 payload jsonb not null,
 created_at timestamptz not null default now()
);
alter table private.content_review_events enable row level security;
revoke all on private.content_review_events from public,anon,authenticated;

-- Whitelist editable fields; client payloads cannot override ownership/status/time.
create or replace function private.editorial_payload(kind text,payload jsonb)
returns jsonb language plpgsql set search_path='' as $$
declare fields text[]; result jsonb;
begin
 if coalesce(kind,'') not in ('resources','news','podcasts') or jsonb_typeof(payload)<>'object' then raise exception 'Invalid content'; end if;
 fields:=array['title','summary','body'];
 if kind in ('resources','podcasts') then fields:=fields||array['resource_type','grade','subject']; end if;
 if kind='news' then fields:=fields||array['source_name','source_url','source_published_at']; end if;
 if kind='podcasts' then fields:=fields||array['audio_url','audio_seconds']; end if;
 select coalesce(jsonb_object_agg(key,value),'{}'::jsonb) into result from jsonb_each(payload) where key=any(fields);
 if coalesce(char_length(result->>'title'),0) not between 3 and 160 or coalesce(char_length(result->>'summary'),0)>400 or coalesce(char_length(result->>'body'),0) not between 20 and 500000 then raise exception 'Invalid content length'; end if;
 if (result->>'body')::jsonb->>'type' is distinct from 'doc' then raise exception 'Invalid document'; end if;
 if kind in ('resources','podcasts') and (coalesce(result->>'resource_type','') not in ('konkur','final_exam') or (result->>'grade' is not null and (result->>'grade')::integer not in (10,11,12))) then raise exception 'Invalid classification'; end if;
 if kind='news' and (coalesce(char_length(result->>'source_name'),0) not between 2 and 120 or coalesce(result->>'source_url','') !~ '^https?://[^[:space:]]+$' or (result->>'source_published_at') is null or (result->>'source_published_at')::date>current_date) then raise exception 'Invalid news source'; end if;
 if kind='podcasts' and result->>'audio_url' is not null and (result->>'audio_url') !~ '^https://[^[:space:]]+$' then raise exception 'Invalid audio'; end if;
 return result;
end; $$;
revoke all on function private.editorial_payload(text,jsonb) from public,anon,authenticated;

-- Public/live records can no longer be published, edited or deleted by authors
-- or admins. Only content-manager review RPCs write live tables.
create or replace function private.guard_editorial_live()
returns trigger language plpgsql set search_path='' as $$
begin
 if current_user in ('anon','authenticated') or (auth.uid() is not null and (select private.current_user_role()) is distinct from 'content_manager'::public.app_role) then
   raise exception 'Use the editorial submission workflow' using errcode='42501';
 end if;
 if tg_op='DELETE' then return old; end if;
 return new;
end; $$;
revoke all on function private.guard_editorial_live() from public,anon,authenticated;
create trigger editorial_guard before insert or update or delete on public.resources for each row execute function private.guard_editorial_live();
create trigger editorial_guard before insert or update or delete on public.konkur_news for each row execute function private.guard_editorial_live();
create trigger editorial_guard before insert or update or delete on public.podcasts for each row execute function private.guard_editorial_live();

create or replace function public.save_content_submission(target_kind text,target_content_id uuid,content_payload jsonb,send_for_review boolean,expected_version integer default 0)
returns uuid language plpgsql security definer set search_path='' as $$
declare s public.content_submissions; cid uuid:=coalesce(target_content_id,gen_random_uuid()); owner_id uuid; existing_live boolean; clean jsonb; table_name text;
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role or not private.is_approved_counselor() then raise exception 'Approved counselor required' using errcode='42501'; end if;
 clean:=private.editorial_payload(target_kind,content_payload);
 if target_kind='podcasts' and send_for_review and clean->>'audio_url' is null then raise exception 'Audio required'; end if;
 table_name:=case target_kind when 'resources' then 'resources' when 'news' then 'konkur_news' when 'podcasts' then 'podcasts' end;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_kind||cid::text,0));
 execute format('select author_id,true from public.%I where id=$1',table_name) into owner_id,existing_live using cid;
 if existing_live and owner_id is distinct from auth.uid() then raise exception 'Not your content' using errcode='42501'; end if;
 select * into s from public.content_submissions where kind=target_kind and content_id=cid for update;
 if found then
  if s.author_id<>auth.uid() then raise exception 'Not your submission' using errcode='42501'; end if;
  if s.state='pending' or expected_version is null or s.version<>expected_version then raise exception 'Submission is under review or changed; reload'; end if;
  update public.content_submissions set payload=clean,state=case when send_for_review then 'pending' else 'draft' end,version=version+1,rejection_reason=null,reviewer_id=null,reviewed_at=null,submitted_at=case when send_for_review then now() else null end,updated_at=now() where id=s.id;
 else
  if expected_version is null or expected_version<>0 then raise exception 'Submission changed; reload'; end if;
  insert into public.content_submissions(kind,content_id,author_id,payload,state,submitted_at) values(target_kind,cid,auth.uid(),clean,case when send_for_review then 'pending' else 'draft' end,case when send_for_review then now() else null end);
 end if;
 return cid;
end; $$;
revoke all on function public.save_content_submission(text,uuid,jsonb,boolean,integer) from public,anon;
grant execute on function public.save_content_submission(text,uuid,jsonb,boolean,integer) to authenticated;

create or replace function public.edit_content_submission(target_submission_id uuid,content_payload jsonb,expected_version integer)
returns void language plpgsql security definer set search_path='' as $$
declare s public.content_submissions; clean jsonb;
begin
 if (select private.current_user_role()) is distinct from 'content_manager'::public.app_role then raise exception 'Content manager only' using errcode='42501'; end if;
 select * into s from public.content_submissions where id=target_submission_id for update;
 if not found or s.state<>'pending' or expected_version is null or s.version<>expected_version then raise exception 'Submission changed; reload'; end if;
 clean:=private.editorial_payload(s.kind,content_payload);
 if s.kind='podcasts' and clean->>'audio_url' is null then raise exception 'Audio required'; end if;
 update public.content_submissions set payload=clean,version=version+1,updated_at=now() where id=s.id;
 insert into private.content_review_events(submission_id,version,reviewer_id,decision,payload) values(s.id,s.version,auth.uid(),'edit',s.payload);
end; $$;
revoke all on function public.edit_content_submission(uuid,jsonb,integer) from public,anon;
grant execute on function public.edit_content_submission(uuid,jsonb,integer) to authenticated;

create or replace function public.review_content_submission(target_submission_id uuid,decision text,reason text,expected_version integer)
returns uuid language plpgsql security definer set search_path='' as $$
declare s public.content_submissions; p jsonb; table_name text; fields text[]; cols text; updates text; affected integer;
begin
 if (select private.current_user_role()) is distinct from 'content_manager'::public.app_role then raise exception 'Content manager only' using errcode='42501'; end if;
 select * into s from public.content_submissions where id=target_submission_id for update;
 if not found or s.state<>'pending' or expected_version is null or s.version<>expected_version then raise exception 'Submission changed; reload'; end if;
 if decision is null or decision not in ('approve','reject') then raise exception 'Invalid decision'; end if;
 if decision='reject' and coalesce(char_length(btrim(reason)),0) not between 5 and 2000 then raise exception 'Rejection reason required (5-2000 characters)'; end if;
 if decision='approve' then
  p:=private.editorial_payload(s.kind,s.payload);
  if s.kind='podcasts' and p->>'audio_url' is null then raise exception 'Audio required'; end if;
  table_name:=case s.kind when 'resources' then 'resources' when 'news' then 'konkur_news' when 'podcasts' then 'podcasts' end;
  fields:=array['id','author_id','title','summary','body','status','published_at'];
  if s.kind in ('resources','podcasts') then fields:=fields||array['resource_type','grade','subject']; end if;
  if s.kind='news' then fields:=fields||array['source_name','source_url','source_published_at']; end if;
  if s.kind='podcasts' then fields:=fields||array['audio_url','audio_seconds']; end if;
  p:=p||jsonb_build_object('id',s.content_id,'author_id',s.author_id,'status','published','published_at',now());
  select string_agg(format('%I',f),','),string_agg(format('%I=excluded.%I',f,f),',') filter(where f not in ('id','author_id','published_at')) into cols,updates from unnest(fields) f;
  -- Conflict ownership is checked atomically, including NULL-author seed items.
  -- Revising a published item must retain its original publication date.
  execute format('insert into public.%I as live (%s) select %s from jsonb_populate_record(null::public.%I,$1) on conflict(id) do update set %s,published_at=coalesce(live.published_at,excluded.published_at) where live.author_id=excluded.author_id',table_name,cols,cols,table_name,updates) using p;
  get diagnostics affected=row_count;
  if affected<>1 then raise exception 'Content ownership changed' using errcode='42501'; end if;
 end if;
 update public.content_submissions set state=case when decision='approve' then 'published' else 'rejected' end,rejection_reason=case when decision='reject' then btrim(reason) else null end,reviewer_id=auth.uid(),reviewed_at=now(),updated_at=now(),version=version+1 where id=s.id;
 insert into private.content_review_events(submission_id,version,reviewer_id,decision,reason,payload) values(s.id,s.version,auth.uid(),decision,case when decision='reject' then btrim(reason) else null end,s.payload);
 return s.content_id;
end; $$;
revoke all on function public.review_content_submission(uuid,text,text,integer) from public,anon;
grant execute on function public.review_content_submission(uuid,text,text,integer) to authenticated;
notify pgrst,'reload schema';

create or replace function public.editorial_authors()
returns table(author_id uuid,full_name text) language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'content_manager'::public.app_role then raise exception 'Content manager only' using errcode='42501'; end if;
 return query select distinct p.id,p.full_name from public.profiles p join public.content_submissions s on s.author_id=p.id where s.state<>'draft';
end; $$;
revoke all on function public.editorial_authors() from public,anon;
grant execute on function public.editorial_authors() to authenticated;
notify pgrst,'reload schema';
