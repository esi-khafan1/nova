-- Public course offers are readable by visitors, but only a super admin can change them.
create table private.course_offer_settings (
  grade smallint not null check (grade between 9 and 12),
  plan text not null check (plan in ('base', 'progress')),
  discount_percent smallint not null check (discount_percent between 0 and 100),
  monthly_price integer not null check (monthly_price between 0 and 100000000 and monthly_price % 10000 = 0),
  primary key (grade, plan)
);
create table private.course_sale_status (
  singleton boolean primary key default true check (singleton),
  reservation boolean not null default false
);
alter table private.course_offer_settings enable row level security;
alter table private.course_sale_status enable row level security;
revoke all on private.course_offer_settings, private.course_sale_status from public, anon, authenticated;
insert into private.course_sale_status (singleton, reservation) values (true, false);
insert into private.course_offer_settings (grade,plan,discount_percent,monthly_price)
select g, p, case when g=12 then 15 else 17 end,
       case when g=12 then case when p='base' then 2700000 else 3000000 end
            else case when p='base' then 2490000 else 2790000 end end
from generate_series(9,12) g cross join (values ('base'),('progress')) plans(p);

create function public.get_course_offer_settings()
returns table(grade smallint, plan text, discount_percent smallint, monthly_price integer, reservation boolean)
language sql stable security definer set search_path = '' as $$
  select o.grade,o.plan,o.discount_percent,o.monthly_price,s.reservation
  from private.course_offer_settings o cross join private.course_sale_status s
  order by o.grade,o.plan;
$$;
revoke all on function public.get_course_offer_settings() from public;
grant execute on function public.get_course_offer_settings() to anon, authenticated;

create function public.super_admin_set_course_offer(p_grade smallint,p_plan text,p_discount_percent smallint,p_monthly_price integer)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if not private.is_super_admin() then raise exception 'Super admin only' using errcode='42501'; end if;
  if p_grade not between 9 and 12 or p_plan not in ('base','progress') or p_discount_percent not between 0 and 100 or p_monthly_price not between 0 and 100000000 or p_monthly_price % 10000 <> 0 or p_grade is null or p_plan is null or p_discount_percent is null or p_monthly_price is null then
    raise exception 'Invalid course offer' using errcode='22023';
  end if;
  update private.course_offer_settings set discount_percent=p_discount_percent,monthly_price=p_monthly_price where grade=p_grade and plan=p_plan;
end;
$$;
revoke all on function public.super_admin_set_course_offer(smallint,text,smallint,integer) from public, anon;
grant execute on function public.super_admin_set_course_offer(smallint,text,smallint,integer) to authenticated;

create function public.super_admin_set_course_reservation(p_reservation boolean)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if not private.is_super_admin() then raise exception 'Super admin only' using errcode='42501'; end if;
  if p_reservation is null then raise exception 'Invalid status' using errcode='22023'; end if;
  update private.course_sale_status set reservation=p_reservation where singleton;
end;
$$;
revoke all on function public.super_admin_set_course_reservation(boolean) from public, anon;
grant execute on function public.super_admin_set_course_reservation(boolean) to authenticated;
notify pgrst, 'reload schema';
