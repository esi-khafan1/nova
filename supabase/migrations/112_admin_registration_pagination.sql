-- Keep the existing full-directory RPC for CSV exports. This separate admin-only
-- endpoint filters and orders globally before returning at most ten detailed rows.
create function public.admin_registration_directory_page(
  search_query text default '', province_filter text default null,
  review_only boolean default false, requested_page integer default 1
) returns jsonb language plpgsql stable security definer set search_path = '' as $$
declare result jsonb; q text; phone_query text;
begin
  if (select private.current_user_role()) is distinct from 'admin'::public.app_role then
    raise exception 'Admin only';
  end if;
  q := pg_catalog.lower(pg_catalog.translate(pg_catalog.btrim(coalesce(search_query, '')), 'يكى', 'یکی'));
  phone_query := pg_catalog.regexp_replace(pg_catalog.translate(q, '۰۱۲۳۴۵۶۷۸۹٠١٢٣٤٥٦٧٨٩', '01234567890123456789'), '[^0-9]', '', 'g');

  with reviews as materialized (
    select r.student_id, r.review_plan_count from public.admin_student_plan_service_reviews() r
  ), candidates as materialized (
    select p.id, p.full_name, coalesce(r.phone,p.phone) as phone,
      case when r.student_id is not null then r.province else a.province end as province,
      p.registration_status, r.receipt_path, p.created_at,
      assignment.counselor_id, reviews.review_plan_count
    from public.profiles p
    left join public.student_registrations r on r.student_id=p.id
    left join public.student_account_details a on a.student_id=p.id
    left join lateral (
      select cs.counselor_id from public.counselor_students cs
      where cs.student_id=p.id order by cs.created_at desc, cs.counselor_id limit 1
    ) assignment on true
    left join reviews on reviews.student_id=p.id
    where p.role='student'
      and (province_filter is null or province_filter = '' or
        (case when r.student_id is not null then r.province else a.province end) = province_filter)
      and (q = '' or
        pg_catalog.strpos(pg_catalog.lower(pg_catalog.translate(coalesce(p.full_name,''), 'يكى', 'یکی')), q) > 0 or
        (phone_query <> '' and q ~ '^[0-9۰-۹٠-٩+()[:space:]-]+$' and
          pg_catalog.strpos(pg_catalog.regexp_replace(pg_catalog.translate(coalesce(r.phone,p.phone,''), '۰۱۲۳۴۵۶۷۸۹٠١٢٣٤٥٦٧٨٩', '01234567890123456789'), '[^0-9]', '', 'g'), phone_query) > 0) or
        exists (select 1 from public.counselor_students cs join public.profiles counselor on counselor.id=cs.counselor_id
          where cs.student_id=p.id and pg_catalog.strpos(pg_catalog.lower(pg_catalog.translate(coalesce(counselor.full_name,''), 'يكى', 'یکی')), q) > 0))
  ), selected as materialized (
    select *, (registration_status='pending' and coalesce(receipt_path,'') <> '' and counselor_id is null) as priority
    from candidates where not coalesce(review_only,false) or review_plan_count is not null
  ), stats as (
    select count(*)::integer as total,
      count(*) filter (where priority)::integer as waiting,
      count(*) filter (where counselor_id is null)::integer as unassigned,
      count(*) filter (where counselor_id is not null)::integer as assigned
    from selected
  ), pagination as (
    select *, greatest(1, (total + 9) / 10) as pages,
      least(greatest(coalesce(requested_page,1),1), greatest(1,(total + 9) / 10)) as page from stats
  ), page_rows as materialized (
    select s.* from selected s order by s.priority desc, s.created_at desc, s.id
    limit 10 offset ((select page from pagination) - 1) * 10
  ), detail as (
    select s.*, p.grade, p.study_field, p.service_course_type, p.service_course_duration_months,
      r.receipt_name, r.course_type, r.course_duration_months,
      case when r.student_id is not null then r.telegram_id else a.telegram_id end as telegram_id,
      case when r.student_id is not null then r.city else a.city end as city,
      case when r.student_id is not null then r.additional_notes else a.additional_notes end as additional_notes,
      (r.student_id is not null or a.student_id is not null) as has_account_details,
      (select pg_catalog.string_agg(c.full_name, '، ' order by c.full_name)
       from public.counselor_students cs join public.profiles c on c.id=cs.counselor_id where cs.student_id=s.id) as counselor_name
    from page_rows s join public.profiles p on p.id=s.id
    left join public.student_registrations r on r.student_id=s.id
    left join public.student_account_details a on a.student_id=s.id
  )
  select pg_catalog.jsonb_build_object(
    'total', pagination.total, 'waiting', pagination.waiting, 'unassigned', pagination.unassigned,
    'assigned', pagination.assigned, 'page', pagination.page, 'pages', pagination.pages,
    'review_count', (select count(*) from candidates where review_plan_count is not null),
    'rows', coalesce((select pg_catalog.jsonb_agg(pg_catalog.jsonb_build_object(
      'student_id',d.id,'full_name',d.full_name,'phone',d.phone,'telegram_id',d.telegram_id,
      'grade',d.grade,'study_field',d.study_field,'province',d.province,'city',d.city,
      'registration_status',d.registration_status,'receipt_path',d.receipt_path,'receipt_name',d.receipt_name,
      'counselor_name',d.counselor_name,'counselor_id',d.counselor_id,'created_at',d.created_at,
      'course_type',d.course_type,'course_duration_months',d.course_duration_months,
      'service_course_type',d.service_course_type,'service_course_duration_months',d.service_course_duration_months,
      'additional_notes',d.additional_notes,'has_account_details',d.has_account_details,'review_plan_count',d.review_plan_count
    ) order by d.priority desc, d.created_at desc, d.id) from detail d), '[]'::jsonb)
  ) into result from pagination;
  return result;
end; $$;
revoke all on function public.admin_registration_directory_page(text,text,boolean,integer) from public, anon;
grant execute on function public.admin_registration_directory_page(text,text,boolean,integer) to authenticated;
notify pgrst, 'reload schema';
