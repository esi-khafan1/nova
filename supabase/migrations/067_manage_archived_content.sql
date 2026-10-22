-- Manager reads of archived versions only; no draft or write-policy expansion.
create policy manager_read_archived_resources on public.resources for select to authenticated
 using(status='archived' and (select private.current_user_role())='content_manager');
create policy manager_read_archived_news on public.konkur_news for select to authenticated
 using(status='archived' and (select private.current_user_role())='content_manager');
create policy manager_read_archived_podcasts on public.podcasts for select to authenticated
 using(status='archived' and (select private.current_user_role())='content_manager');

-- Archived live content can be edited/restored or returned without overwriting author work.
create table private.archived_content_events (
 id bigint generated always as identity primary key,
 kind text not null, content_id uuid not null,
 manager_id uuid not null references public.profiles(id),
 action text not null, reason text, payload jsonb not null,
 created_at timestamptz not null default now()
);
alter table private.archived_content_events enable row level security;
revoke all on private.archived_content_events from public,anon,authenticated;

create or replace function public.manage_archived_content(
 target_kind text,target_content_id uuid,expected_updated_at timestamptz,
 operation text,content_payload jsonb default null,reason text default null
) returns void language plpgsql security definer set search_path='' as $$
declare table_name text; live jsonb; s public.content_submissions; clean jsonb;
 fields text[]; assignments text; sid uuid;
begin
 if (select private.current_user_role()) is distinct from 'content_manager'::public.app_role then raise exception 'Content manager only' using errcode='42501'; end if;
 if target_kind is null or target_kind not in ('resources','news','podcasts') or target_content_id is null or expected_updated_at is null
 or operation is null or operation not in ('edit','publish','return') then raise exception 'Invalid operation'; end if;
 table_name:=case target_kind when 'news' then 'konkur_news' else target_kind end;
 -- Match author-save locking, and review's submission-before-live row lock order.
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_kind||target_content_id::text,0));
 select * into s from public.content_submissions where kind=target_kind and content_id=target_content_id for update;
 execute format('select to_jsonb(r) from public.%I r where id=$1 for update',table_name) into live using target_content_id;
 if live is null or live->>'status'<>'archived' or (live->>'updated_at')::timestamptz is distinct from expected_updated_at then raise exception 'Content changed; reload'; end if;
 if operation='return' then
  if coalesce(char_length(btrim(reason)),0) not between 5 and 2000 then raise exception 'Rejection reason required (5-2000 characters)'; end if;
  if not exists(select 1 from public.profiles where id=(live->>'author_id')::uuid and role='counselor') then raise exception 'No eligible author'; end if;
  if s.id is not null and (s.author_id is distinct from (live->>'author_id')::uuid or s.state<>'published') then raise exception 'Author revision exists; review it separately'; end if;
  clean:=live;
  -- Older live records may contain plain text rather than editor JSON.
  if left(ltrim(clean->>'body'),1)<>'{' then
   clean:=clean||jsonb_build_object('body',jsonb_build_object('type','doc','content',jsonb_build_array(jsonb_build_object('type','paragraph','content',jsonb_build_array(jsonb_build_object('type','text','text',clean->>'body')))))::text);
  end if;
  clean:=private.editorial_payload(target_kind,clean);
  if s.id is null then
   insert into public.content_submissions(kind,content_id,author_id,payload,state,rejection_reason,reviewer_id,reviewed_at)
    values(target_kind,target_content_id,(live->>'author_id')::uuid,clean,'rejected',btrim(reason),auth.uid(),now()) returning id into sid;
  else
   sid:=s.id;
   update public.content_submissions set payload=clean,state='rejected',rejection_reason=btrim(reason),reviewer_id=auth.uid(),reviewed_at=now(),updated_at=clock_timestamp(),version=version+1 where id=s.id;
  end if;
  insert into private.content_review_events(submission_id,version,reviewer_id,decision,reason,payload)
   values(sid,coalesce(s.version,0),auth.uid(),'return_archived',btrim(reason),clean);
 elsif operation='edit' then
  clean:=private.editorial_payload(target_kind,content_payload);
  fields:=array['title','summary','body'];
  if target_kind in ('resources','podcasts') then fields:=fields||array['resource_type','grade','subject']; end if;
  if target_kind='news' then fields:=fields||array['source_name','source_url','source_published_at']; end if;
  if target_kind='podcasts' then fields:=fields||array['audio_url','audio_seconds']; end if;
  select string_agg(format('%I=p.%I',f,f),',') into assignments from unnest(fields) f;
  execute format('update public.%I as r set %s from jsonb_populate_record(null::public.%I,$1) p where r.id=$2',table_name,assignments,table_name) using clean,target_content_id;
 else
  -- Restore the existing stored version, including legacy plain-text bodies.
  if target_kind='podcasts' and live->>'audio_url' is null then raise exception 'Audio required'; end if;
  execute format('update public.%I set status=''published'',published_at=coalesce(published_at,now()) where id=$1',table_name) using target_content_id;
 end if;
 execute format('update public.%I set updated_at=clock_timestamp() where id=$1',table_name) using target_content_id;
 insert into private.archived_content_events(kind,content_id,manager_id,action,reason,payload)
  values(target_kind,target_content_id,auth.uid(),operation,case when operation='return' then btrim(reason) end,live);
end; $$;
revoke all on function public.manage_archived_content(text,uuid,timestamptz,text,jsonb,text) from public,anon;
grant execute on function public.manage_archived_content(text,uuid,timestamptz,text,jsonb,text) to authenticated;
notify pgrst,'reload schema';
