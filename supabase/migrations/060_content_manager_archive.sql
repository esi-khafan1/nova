-- Archive the live version independently of any draft/pending revision.
create table private.content_archive_events (
 id bigint generated always as identity primary key,
 kind text not null,
 content_id uuid not null,
 manager_id uuid not null references public.profiles(id),
 payload jsonb not null,
 created_at timestamptz not null default now()
);
alter table private.content_archive_events enable row level security;
revoke all on private.content_archive_events from public,anon,authenticated;

create or replace function public.list_editorial_live(target_status text,page_number integer default 0)
returns table(kind text,content_id uuid,title text,summary text,updated_at timestamptz,total_count bigint)
language plpgsql stable security definer set search_path='' as $$
begin
 if (select private.current_user_role()) is distinct from 'content_manager'::public.app_role then raise exception 'Content manager only' using errcode='42501'; end if;
 if target_status is null or target_status not in ('published','archived') or page_number is null or page_number<0 or page_number>100000 then raise exception 'Invalid filter'; end if;
 return query
 select live.kind,live.id,live.title,live.summary,live.updated_at,count(*) over()
 from (
  select 'resources'::text as kind,r.id,r.title,r.summary,r.updated_at from public.resources r where r.status::text=target_status
  union all select 'news'::text,n.id,n.title,n.summary,n.updated_at from public.konkur_news n where n.status::text=target_status
  union all select 'podcasts'::text,p.id,p.title,p.summary,p.updated_at from public.podcasts p where p.status::text=target_status
 ) live order by live.updated_at desc,live.kind,live.id limit 50 offset page_number*50;
end; $$;
revoke all on function public.list_editorial_live(text,integer) from public,anon;
grant execute on function public.list_editorial_live(text,integer) to authenticated;

create or replace function public.archive_editorial_content(target_kind text,target_content_id uuid,expected_updated_at timestamptz)
returns void language plpgsql security definer set search_path='' as $$
declare table_name text; live jsonb; live_state text; live_updated timestamptz;
begin
 if (select private.current_user_role()) is distinct from 'content_manager'::public.app_role then raise exception 'Content manager only' using errcode='42501'; end if;
 if target_kind is null or target_kind not in ('resources','news','podcasts') or target_content_id is null or expected_updated_at is null then raise exception 'Invalid content'; end if;
 table_name:=case target_kind when 'news' then 'konkur_news' else target_kind end;
 execute format('select to_jsonb(r),r.status::text,r.updated_at from public.%I r where id=$1 for update',table_name) into live,live_state,live_updated using target_content_id;
 if live is null or live_state<>'published' or live_updated is distinct from expected_updated_at then raise exception 'Content changed; reload'; end if;
 insert into private.content_archive_events(kind,content_id,manager_id,payload) values(target_kind,target_content_id,auth.uid(),live);
 execute format('update public.%I set status=''archived'',published_at=null,updated_at=clock_timestamp() where id=$1',table_name) using target_content_id;
end; $$;
revoke all on function public.archive_editorial_content(text,uuid,timestamptz) from public,anon;
grant execute on function public.archive_editorial_content(text,uuid,timestamptz) to authenticated;
notify pgrst,'reload schema';
