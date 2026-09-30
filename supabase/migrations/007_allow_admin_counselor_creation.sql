create policy "admins_insert_counselor_profiles"
on public.counselor_profiles
for insert
to authenticated
with check ((select private.current_user_role()) = 'admin');