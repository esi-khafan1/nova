-- Preserve the original per-table RLS and own-counselor filters, but use a single
-- HTTP request for the five independent dashboard reads.
create or replace function public.counselor_dashboard_summary()
returns table(headline text,specialty text,is_accepting boolean,resources bigint,requests bigint,students bigint,plans bigint)
language plpgsql stable security invoker set search_path='' as $$
declare me uuid:=(select auth.uid());
begin
 if (select private.current_user_role()) is distinct from 'counselor'::public.app_role then raise exception 'Counselor only' using errcode='42501'; end if;
 return query select cp.headline,cp.specialty,coalesce(cp.is_accepting,false),
  (select count(*) from public.resources r where r.author_id=me),
  (select count(*) from public.consultation_requests r where r.counselor_id=me),
  (select count(*) from public.counselor_students s where s.counselor_id=me),
  (select count(*) from public.weekly_plans p where p.counselor_id=me)
 from (select me as id) caller left join public.counselor_profiles cp on cp.user_id=caller.id;
end; $$;
revoke all on function public.counselor_dashboard_summary() from public,anon;
grant execute on function public.counselor_dashboard_summary() to authenticated;
notify pgrst,'reload schema';
