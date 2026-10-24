-- Widen ONLY the verified-contact predicate, preserving the deployed receipt,
-- enrollment, role, locking and never-reassign-counselor checks verbatim.
do $$
declare signature text; source text; updated text;
begin
 foreach signature in array array[
 'public.save_student_account_details(jsonb)',
 'public.submit_student_registration(jsonb)',
 'public.admin_activate_student_without_receipt(uuid,uuid)'
 ] loop
  source:=pg_get_functiondef(signature::regprocedure);
  updated:=replace(source,'and u.email_confirmed_at is not null','and (u.email_confirmed_at is not null or u.phone_confirmed_at is not null)');
  updated:=replace(updated,'and email_confirmed_at is not null','and (email_confirmed_at is not null or phone_confirmed_at is not null)');
  if source=updated then raise exception 'Expected confirmation guard missing: %',signature;end if;
  execute updated;
 end loop;
end;$$;
notify pgrst,'reload schema';
