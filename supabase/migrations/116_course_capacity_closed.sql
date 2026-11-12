-- A third global state. The existing sale/reservation setting remains intact
-- and defaults to its current value; migration does not close enrollment.
alter table private.course_sale_status add column sold_out boolean not null default false;

-- New read RPC leaves the old web version's result signature unchanged.
create function public.get_course_offer_settings_v2()
returns table(grade smallint, plan text, discount_percent smallint, monthly_price integer, reservation boolean, sold_out boolean)
language sql stable security definer set search_path = '' as $$
  select o.grade,o.plan,o.discount_percent,o.monthly_price,s.reservation,s.sold_out
  from private.course_offer_settings o cross join private.course_sale_status s
  order by o.grade,o.plan;
$$;
revoke all on function public.get_course_offer_settings_v2() from public, anon, authenticated;
grant execute on function public.get_course_offer_settings_v2() to anon, authenticated;

create function public.super_admin_set_course_status(p_status text)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if not private.is_super_admin() then raise exception 'Super admin only' using errcode='42501'; end if;
  if p_status is null or p_status not in ('sale','reservation','sold_out') then raise exception 'Invalid status' using errcode='22023'; end if;
  update private.course_sale_status set reservation=(p_status='reservation'), sold_out=(p_status='sold_out') where singleton;
end;
$$;
revoke all on function public.super_admin_set_course_status(text) from public, anon, authenticated;
grant execute on function public.super_admin_set_course_status(text) to authenticated;

-- Older deployments may still set the two original states; selecting either
-- must reopen enrollment rather than leave a hidden sold-out flag behind.
create or replace function public.super_admin_set_course_reservation(p_reservation boolean)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if not private.is_super_admin() then raise exception 'Super admin only' using errcode='42501'; end if;
  if p_reservation is null then raise exception 'Invalid status' using errcode='22023'; end if;
  update private.course_sale_status set reservation=p_reservation, sold_out=false where singleton;
end;
$$;

create function public.course_enrollment_open() returns boolean
language sql stable security definer set search_path = '' as $$
  select coalesce((select not sold_out from private.course_sale_status where singleton), false);
$$;
revoke all on function public.course_enrollment_open() from public, anon, authenticated;
grant execute on function public.course_enrollment_open() to authenticated;

-- Retain every existing identity, confirmation, receipt and registration check.
-- The old implementation is no longer independently callable by API roles.
alter function public.submit_student_registration(jsonb) set schema private;
revoke all on function private.submit_student_registration(jsonb) from public, anon, authenticated, service_role;
create function public.submit_student_registration(payload jsonb) returns void
language plpgsql security definer set search_path = '' as $$
declare closed boolean;
begin
  -- Serialize against status changes, including requests from an old open tab.
  select sold_out into closed from private.course_sale_status where singleton for share;
  if closed is distinct from false then raise exception 'Course capacity full' using errcode='P0001'; end if;
  perform private.submit_student_registration(payload);
end;
$$;
revoke all on function public.submit_student_registration(jsonb) from public, anon, authenticated;
grant execute on function public.submit_student_registration(jsonb) to authenticated;

-- Keep admin receipt handling and deletion of unused uploads unchanged.
alter policy receipt_upload_own_pending on storage.objects with check (
  bucket_id = 'registration-receipts'
  and (storage.foldername(name))[1] = (select auth.uid())::text
  and (select public.course_enrollment_open())
  and exists (select 1 from public.profiles p where p.id = (select auth.uid()) and p.role = 'student' and p.registration_status in ('incomplete','pending'))
);
notify pgrst, 'reload schema';
