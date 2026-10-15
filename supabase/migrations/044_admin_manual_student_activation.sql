-- Explicit administrator-only exception; never fabricate or publicly expose a receipt.
create table public.student_manual_activations (
 id uuid primary key default gen_random_uuid(),
 student_id uuid not null references public.profiles(id) on delete cascade,
 activated_by uuid references public.profiles(id) on delete set null,
 counselor_id uuid references public.profiles(id) on delete set null,
 previous_status text not null,
 activated_at timestamptz not null default now()
);
alter table public.student_manual_activations enable row level security;
revoke all on public.student_manual_activations from anon,authenticated;
grant select on public.student_manual_activations to authenticated;
create policy manual_activations_admin_read on public.student_manual_activations for select to authenticated using((select private.current_user_role())='admin');
create function public.admin_activate_student_without_receipt(target_student_id uuid,target_counselor_id uuid) returns void language plpgsql security definer set search_path='' as $$
declare state text;
begin
 if (select private.current_user_role()) is distinct from 'admin'::public.app_role then raise exception 'Admin only';end if;
 perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(target_student_id::text,73033));
 select registration_status into state from public.profiles where id=target_student_id and role='student' for update;
 if state is null or state='active' then raise exception 'Inactive student required';end if;
 if not exists(select 1 from auth.users where id=target_student_id and email_confirmed_at is not null) then raise exception 'Confirmed student required';end if;
 if not exists(select 1 from public.student_account_details where student_id=target_student_id) and not exists(select 1 from public.student_registrations where student_id=target_student_id) then raise exception 'Complete account information required';end if;
 if not exists(select 1 from public.profiles p join public.counselor_profiles c on c.user_id=p.id where p.id=target_counselor_id and p.role='counselor' and c.approval_status='approved') then raise exception 'Approved counselor required';end if;
 delete from public.counselor_students where student_id=target_student_id;
 insert into public.counselor_students(counselor_id,student_id)values(target_counselor_id,target_student_id);
 insert into public.student_manual_activations(student_id,activated_by,counselor_id,previous_status)values(target_student_id,(select auth.uid()),target_counselor_id,state);
 update public.profiles set registration_status='active' where id=target_student_id;
 -- Receipt and purchase fields intentionally unchanged; manual approval has its own audit.
end;$$;
revoke all on function public.admin_activate_student_without_receipt(uuid,uuid) from public,anon;
grant execute on function public.admin_activate_student_without_receipt(uuid,uuid) to authenticated;
