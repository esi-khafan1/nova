-- Isolated news storage: existing article types, rows and policies are untouched.
create table public.konkur_news (
  id uuid primary key default gen_random_uuid(),
  author_id uuid references public.profiles(id) on delete restrict,
  title text not null check (char_length(title) between 3 and 160),
  summary text check (char_length(summary) <= 400),
  body text not null check (char_length(body) <= 500000),
  source_name text not null check (char_length(source_name) between 2 and 120),
  source_url text not null check (char_length(source_url) <= 2048 and source_url ~ '^https?://[^[:space:]]+$'),
  source_published_at date not null,
  status public.content_status not null default 'draft',
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint news_publication_time check (
    (status = 'published' and published_at is not null) or
    (status <> 'published' and published_at is null)
  )
);
comment on column public.konkur_news.author_id is 'NULL only for editorial seed news; counselor writes require their own author id through RLS.';
create trigger konkur_news_updated_at before update on public.konkur_news
for each row execute function public.set_updated_at();
create index konkur_news_published_idx on public.konkur_news(source_published_at desc, published_at desc, id desc) where status = 'published';
create index konkur_news_author_idx on public.konkur_news(author_id, updated_at desc);

alter table public.konkur_news enable row level security;
grant select on public.konkur_news to anon, authenticated;
grant insert, update, delete on public.konkur_news to authenticated;
create policy "news_public_or_owned" on public.konkur_news for select to anon, authenticated
using (status = 'published' or author_id = (select auth.uid()) or (select private.current_user_role()) = 'admin');
create policy "approved_counselors_create_news" on public.konkur_news for insert to authenticated
with check (author_id = (select auth.uid()) and (select private.current_user_role()) = 'counselor' and (select private.is_approved_counselor()));
create policy "approved_authors_update_news" on public.konkur_news for update to authenticated
using ((author_id = (select auth.uid()) and (select private.current_user_role()) = 'counselor' and (select private.is_approved_counselor())) or (select private.current_user_role()) = 'admin')
with check ((author_id = (select auth.uid()) and (select private.current_user_role()) = 'counselor' and (select private.is_approved_counselor())) or (select private.current_user_role()) = 'admin');
create policy "approved_authors_delete_news" on public.konkur_news for delete to authenticated
using ((author_id = (select auth.uid()) and (select private.current_user_role()) = 'counselor' and (select private.is_approved_counselor())) or (select private.current_user_role()) = 'admin');
