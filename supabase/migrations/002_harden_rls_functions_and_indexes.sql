create schema if not exists private;
revoke all on schema private from public;
grant usage on schema private to anon, authenticated;

create or replace function private.current_user_role() returns public.app_role language sql stable security definer set search_path = '' as $$
  select role from public.profiles where id = (select auth.uid());
$$;
create or replace function private.is_approved_counselor() returns boolean language sql stable security definer set search_path = '' as $$
  select exists(select 1 from public.counselor_profiles where user_id = (select auth.uid()) and approval_status = 'approved');
$$;
grant execute on function private.current_user_role() to anon, authenticated;
grant execute on function private.is_approved_counselor() to authenticated;
revoke all on function public.handle_new_user() from public, anon, authenticated;

drop policy "profiles_read_own_or_admin" on public.profiles;
drop policy "profiles_update_own_or_admin" on public.profiles;
create policy "profiles_read_own_or_admin" on public.profiles for select to authenticated using (id = (select auth.uid()) or (select private.current_user_role()) = 'admin');
create policy "profiles_update_own_or_admin" on public.profiles for update to authenticated using (id = (select auth.uid()) or (select private.current_user_role()) = 'admin') with check (id = (select auth.uid()) or (select private.current_user_role()) = 'admin');

drop policy "approved_counselors_are_public" on public.counselor_profiles;
drop policy "counselor_profile_owner_insert" on public.counselor_profiles;
drop policy "counselor_profile_owner_update" on public.counselor_profiles;
create policy "approved_counselors_are_public" on public.counselor_profiles for select to anon, authenticated using (approval_status = 'approved' or user_id = (select auth.uid()) or (select private.current_user_role()) = 'admin');
create policy "counselor_profile_owner_insert" on public.counselor_profiles for insert to authenticated with check (user_id = (select auth.uid()));
create policy "counselor_profile_owner_update" on public.counselor_profiles for update to authenticated using (user_id = (select auth.uid()) or (select private.current_user_role()) = 'admin') with check (user_id = (select auth.uid()) or (select private.current_user_role()) = 'admin');

drop policy "published_resources_are_public" on public.resources;
drop policy "approved_counselors_create_resources" on public.resources;
drop policy "authors_manage_resources" on public.resources;
drop policy "authors_delete_resources" on public.resources;
create policy "published_resources_are_public" on public.resources for select to anon, authenticated using (status = 'published' or author_id = (select auth.uid()) or (select private.current_user_role()) = 'admin');
create policy "approved_counselors_create_resources" on public.resources for insert to authenticated with check (author_id = (select auth.uid()) and (select private.is_approved_counselor()));
create policy "authors_manage_resources" on public.resources for update to authenticated using (author_id = (select auth.uid()) or (select private.current_user_role()) = 'admin') with check (author_id = (select auth.uid()) or (select private.current_user_role()) = 'admin');
create policy "authors_delete_resources" on public.resources for delete to authenticated using (author_id = (select auth.uid()) or (select private.current_user_role()) = 'admin');

drop policy "consultation_participants_read" on public.consultation_requests;
drop policy "students_create_requests" on public.consultation_requests;
drop policy "participants_update_requests" on public.consultation_requests;
create policy "consultation_participants_read" on public.consultation_requests for select to authenticated using (student_id = (select auth.uid()) or counselor_id = (select auth.uid()) or (select private.current_user_role()) = 'admin');
create policy "students_create_requests" on public.consultation_requests for insert to authenticated with check (student_id = (select auth.uid()) and (select private.current_user_role()) = 'student');
create policy "participants_update_requests" on public.consultation_requests for update to authenticated using (student_id = (select auth.uid()) or counselor_id = (select auth.uid()) or (select private.current_user_role()) = 'admin') with check (student_id = (select auth.uid()) or counselor_id = (select auth.uid()) or (select private.current_user_role()) = 'admin');

create index resources_author_idx on public.resources(author_id);
drop function public.current_user_role();
drop function public.is_approved_counselor();
