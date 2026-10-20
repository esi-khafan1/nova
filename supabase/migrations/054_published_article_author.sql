-- Public article attribution without opening access to private profiles.
-- Accept an article ID, not a profile ID, and expose only the author's name.
create or replace function public.published_article_author(target_resource_id uuid)
returns table(full_name text)
language sql
stable
security definer
set search_path = ''
as $$
  select p.full_name
  from public.resources r
  join public.profiles p on p.id = r.author_id
  where r.id = target_resource_id and r.status = 'published';
$$;

revoke all on function public.published_article_author(uuid) from public;
grant execute on function public.published_article_author(uuid) to anon, authenticated;

notify pgrst, 'reload schema';
