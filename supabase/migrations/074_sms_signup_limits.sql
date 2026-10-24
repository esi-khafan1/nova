-- Separate from the five-attempt diagnostic budget. Enabled only by an Edge secret.
create table private.sms_signup_attempts (
 event_id text primary key,
 phone_key text not null check(phone_key ~ '^[0-9a-f]{64}$'),
 outcome text not null default 'reserved', provider_code integer, elapsed_ms integer,
 created_at timestamptz not null default now()
);
alter table private.sms_signup_attempts enable row level security;
revoke all on private.sms_signup_attempts from public,anon,authenticated;
create index sms_signup_by_phone on private.sms_signup_attempts(phone_key,created_at);
create index sms_signup_by_time on private.sms_signup_attempts(created_at);
create function public.claim_sms_signup_attempt(event_id text,phone_key text) returns boolean
language plpgsql security definer set search_path='' as $$
begin
 if event_id is null or length(event_id) not between 1 and 200 or phone_key is null or phone_key !~ '^[0-9a-f]{64}$' then return false;end if;
 perform pg_catalog.pg_advisory_xact_lock(566954074);
 delete from private.sms_signup_attempts where created_at<now()-interval '7 days';
 if exists(select 1 from private.sms_test_attempts t where t.event_id=claim_sms_signup_attempt.event_id) then return false;end if;
 if exists(select 1 from private.sms_signup_attempts t where t.event_id=claim_sms_signup_attempt.event_id) then return false;end if;
 if (select count(*) from private.sms_signup_attempts where created_at>now()-interval '1 day')>=200
 or (select count(*) from private.sms_signup_attempts where created_at>now()-interval '1 hour')>=50
 or exists(select 1 from private.sms_signup_attempts t where t.phone_key=claim_sms_signup_attempt.phone_key and created_at>now()-interval '60 seconds')
 or (select count(*) from private.sms_signup_attempts t where t.phone_key=claim_sms_signup_attempt.phone_key and created_at>now()-interval '1 hour')>=3
 or (select count(*) from private.sms_signup_attempts t where t.phone_key=claim_sms_signup_attempt.phone_key and created_at>now()-interval '1 day')>=5 then return false;end if;
 insert into private.sms_signup_attempts(event_id,phone_key) values(claim_sms_signup_attempt.event_id,claim_sms_signup_attempt.phone_key);
 return true;
end;$$;
revoke all on function public.claim_sms_signup_attempt(text,text) from public,anon,authenticated;
grant execute on function public.claim_sms_signup_attempt(text,text) to service_role;
create or replace function public.record_sms_test_outcome(event_id text,outcome text,provider_code integer,elapsed_ms integer)
returns void language plpgsql security definer set search_path='' as $$
begin
 if outcome not in ('accepted','http_error','provider_rejected','unrecognized_response','timeout','network_error')
 or elapsed_ms is null or elapsed_ms<0 or elapsed_ms>60000
 or (provider_code is not null and (provider_code < -999 or provider_code>599)) then raise exception 'Invalid diagnostic';end if;
 update private.sms_test_attempts t set outcome=record_sms_test_outcome.outcome,provider_code=record_sms_test_outcome.provider_code,elapsed_ms=record_sms_test_outcome.elapsed_ms where t.event_id=record_sms_test_outcome.event_id and t.outcome='reserved';
 update private.sms_signup_attempts t set outcome=record_sms_test_outcome.outcome,provider_code=record_sms_test_outcome.provider_code,elapsed_ms=record_sms_test_outcome.elapsed_ms where t.event_id=record_sms_test_outcome.event_id and t.outcome='reserved';
end;$$;
revoke all on function public.record_sms_test_outcome(text,text,integer,integer) from public,anon,authenticated;
grant execute on function public.record_sms_test_outcome(text,text,integer,integer) to service_role;
notify pgrst,'reload schema';
