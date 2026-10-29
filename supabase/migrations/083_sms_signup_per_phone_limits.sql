-- Allow up to ten attempts per hour and twenty per day per phone.
-- Preserve the one-minute cooldown, global budgets, deduplication and private ledger.
create or replace function public.claim_sms_signup_attempt(event_id text, phone_key text)
returns boolean language plpgsql security definer set search_path='' as $$
begin
 if event_id is null or length(event_id) not between 1 and 200 or phone_key is null or phone_key !~ '^[0-9a-f]{64}$' then return false;end if;
 perform pg_catalog.pg_advisory_xact_lock(566954074);
 delete from private.sms_signup_attempts where created_at<now()-interval '7 days';
 if exists(select 1 from private.sms_test_attempts t where t.event_id=claim_sms_signup_attempt.event_id) then return false;end if;
 if exists(select 1 from private.sms_signup_attempts t where t.event_id=claim_sms_signup_attempt.event_id) then return false;end if;
 if (select count(*) from private.sms_signup_attempts where created_at>now()-interval '1 day')>=200
 or (select count(*) from private.sms_signup_attempts where created_at>now()-interval '1 hour')>=50
 or exists(select 1 from private.sms_signup_attempts t where t.phone_key=claim_sms_signup_attempt.phone_key and created_at>now()-interval '60 seconds')
 or (select count(*) from private.sms_signup_attempts t where t.phone_key=claim_sms_signup_attempt.phone_key and created_at>now()-interval '1 hour')>=10
 or (select count(*) from private.sms_signup_attempts t where t.phone_key=claim_sms_signup_attempt.phone_key and created_at>now()-interval '1 day')>=20 then return false;end if;
 insert into private.sms_signup_attempts(event_id,phone_key) values(claim_sms_signup_attempt.event_id,claim_sms_signup_attempt.phone_key);
 return true;
end;$$;
revoke all on function public.claim_sms_signup_attempt(text,text) from public,anon,authenticated;
grant execute on function public.claim_sms_signup_attempt(text,text) to service_role;
notify pgrst,'reload schema';
