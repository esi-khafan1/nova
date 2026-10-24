-- Diagnostics contain only a fixed outcome, bounded numeric code and elapsed time.
-- No phone, OTP, keys, provider recId or raw provider response is persisted.
alter table private.sms_test_attempts
 add column outcome text not null default 'reserved',
 add column provider_code integer,
 add column elapsed_ms integer;
create function public.record_sms_test_outcome(event_id text,outcome text,provider_code integer,elapsed_ms integer)
returns void language plpgsql security definer set search_path='' as $$
begin
 if outcome not in ('accepted','http_error','provider_rejected','unrecognized_response','timeout','network_error')
 or elapsed_ms is null or elapsed_ms<0 or elapsed_ms>60000
 or (provider_code is not null and (provider_code < -999 or provider_code>599)) then
  raise exception 'Invalid diagnostic';
 end if;
 update private.sms_test_attempts t set outcome=record_sms_test_outcome.outcome,
 provider_code=record_sms_test_outcome.provider_code,elapsed_ms=record_sms_test_outcome.elapsed_ms
 where t.event_id=record_sms_test_outcome.event_id and t.outcome='reserved';
end; $$;
revoke all on function public.record_sms_test_outcome(text,text,integer,integer) from public,anon,authenticated;
grant execute on function public.record_sms_test_outcome(text,text,integer,integer) to service_role;
notify pgrst,'reload schema';
