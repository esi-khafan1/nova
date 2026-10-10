-- Independent podcast storage; existing resources and news remain untouched.
create table public.podcasts (
 id uuid primary key default gen_random_uuid(),
 author_id uuid references public.profiles(id) on delete restrict,
 title text not null check (char_length(title) between 3 and 160),
 summary text check (char_length(summary) <= 400),
 body text not null check (char_length(body) <= 500000),
 resource_type public.resource_type not null default 'konkur',
 subject text check (char_length(subject) <= 100),
 grade integer check (grade in (10,11,12)),
 audio_url text check (char_length(audio_url) <= 2048 and (audio_url ~ '^https://[^[:space:]]+$' or audio_url in ('/podcasts/audio/planning','/podcasts/audio/focus','/podcasts/audio/review'))),
 audio_seconds integer check (audio_seconds between 1 and 10800),
 is_sample boolean not null default false,
 status public.content_status not null default 'draft',
 published_at timestamptz,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 constraint podcast_publication_time check ((status='published' and published_at is not null and audio_url is not null) or (status<>'published' and published_at is null)),
 constraint podcast_duration_has_audio check (audio_seconds is null or audio_url is not null)
);
comment on column public.podcasts.author_id is 'NULL only for the three editorial sample podcasts. Counselor writes require their own author id.';
create trigger podcasts_updated_at before update on public.podcasts for each row execute function public.set_updated_at();
create index podcasts_public_idx on public.podcasts(published_at desc,id desc) where status='published';
create index podcasts_author_idx on public.podcasts(author_id,updated_at desc);
alter table public.podcasts enable row level security;
grant select on public.podcasts to anon,authenticated;
grant insert,update,delete on public.podcasts to authenticated;
create policy "podcasts_public_or_owned" on public.podcasts for select to anon,authenticated using(status='published' or author_id=(select auth.uid()) or (select private.current_user_role())='admin');
create policy "approved_counselors_create_podcasts" on public.podcasts for insert to authenticated with check(author_id=(select auth.uid()) and not is_sample and (select private.current_user_role())='counselor' and (select private.is_approved_counselor()));
create policy "approved_authors_update_podcasts" on public.podcasts for update to authenticated using((author_id=(select auth.uid()) and (select private.current_user_role())='counselor' and (select private.is_approved_counselor())) or (select private.current_user_role())='admin') with check((author_id=(select auth.uid()) and not is_sample and (select private.current_user_role())='counselor' and (select private.is_approved_counselor())) or (select private.current_user_role())='admin');
create policy "approved_authors_delete_podcasts" on public.podcasts for delete to authenticated using((author_id=(select auth.uid()) and (select private.current_user_role())='counselor' and (select private.is_approved_counselor())) or (select private.current_user_role())='admin');
