-- Test-only budget; no phone numbers, OTPs or provider credentials are stored.
create table private.sms_test_attempts(event_id text primary key, created_at timestamptz not null default now());
alter table private.sms_test_attempts enable row level security;
revoke all on private.sms_test_attempts from public,anon,authenticated;
create function public.claim_sms_test_attempt(event_id text) returns boolean
language plpgsql security definer set search_path='' as $$
begin
 if event_id is null or length(event_id)>200 or length(event_id)=0 then return false; end if;
 perform pg_catalog.pg_advisory_xact_lock(566954072);
 if (select count(*) from private.sms_test_attempts)>=5 then return false; end if;
 insert into private.sms_test_attempts(event_id) values(claim_sms_test_attempt.event_id) on conflict do nothing;
 return found;
end;
$$;
revoke all on function public.claim_sms_test_attempt(text) from public,anon,authenticated;
grant execute on function public.claim_sms_test_attempt(text) to service_role;
notify pgrst,'reload schema';
