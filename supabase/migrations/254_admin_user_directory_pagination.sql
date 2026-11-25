-- Page and search in PostgreSQL, before returning accounts to the browser.
-- This does not change roles, student services, or authentication.
create function public.admin_user_directory_page(
  search_query text default '', requested_page integer default 1
) returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare result jsonb; q text; phone_query text;
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Only administrators can list users' using errcode = '42501';
  end if;
  q := pg_catalog.lower(pg_catalog.translate(pg_catalog.left(pg_catalog.btrim(coalesce(search_query, '')), 120), 'يكى', 'یکی'));
  phone_query := private.registration_search_phone(q);

  with candidates as materialized (
    select p.id, p.full_name, p.role, p.grade, p.created_at, a.email::text as email
    from public.profiles p left join auth.users a on a.id = p.id
    where q = ''
      or pg_catalog.strpos(pg_catalog.lower(pg_catalog.translate(coalesce(p.full_name, ''), 'يكى', 'یکی')), q) > 0
      or pg_catalog.strpos(pg_catalog.lower(coalesce(a.email::text, '')), q) > 0
      or (phone_query <> '' and q ~ '^[0-9۰-۹٠-٩+()[:space:]-]+$' and (
        pg_catalog.strpos(private.registration_search_phone(coalesce(p.phone, '')), phone_query) > 0
        or pg_catalog.strpos(private.registration_search_phone(coalesce(a.phone::text, '')), phone_query) > 0
      ))
  ), stats as (
    select count(*)::integer as total from candidates
  ), pagination as (
    select total, greatest(1, (total + 9) / 10) as pages,
      least(greatest(coalesce(requested_page, 1), 1), greatest(1, (total + 9) / 10)) as page
    from stats
  ), page_rows as (
    select c.* from candidates c order by c.created_at desc, c.id
    limit 10 offset ((select page from pagination) - 1) * 10
  )
  select pg_catalog.jsonb_build_object(
    'total', pagination.total, 'page', pagination.page, 'pages', pagination.pages,
    'rows', coalesce((select pg_catalog.jsonb_agg(pg_catalog.to_jsonb(r) order by r.created_at desc, r.id) from page_rows r), '[]'::jsonb)
  ) into result from pagination;
  return result;
end; $$;
revoke all on function public.admin_user_directory_page(text, integer) from public, anon;
grant execute on function public.admin_user_directory_page(text, integer) to authenticated;
notify pgrst, 'reload schema';
