# Isolated MeliPayamak SMS hook test

Not deployed or enabled. Email Auth, existing profiles and site login UI are unchanged.
Template: 566954 (one OTP variable). No real SMS has been sent by these tests.

## Setup (project operator)

1. Apply `072_sms_test_budget.sql` once. It provides a durable, globally serialized budget of FIVE attempts, including failed or ambiguous deliveries. Only service_role may claim. No user/phone/OTP is stored. Do not reset the budget without inspecting provider history.
2. Deploy `supabase/functions/send-sms` with JWT verification disabled (`supabase functions deploy send-sms --no-verify-jwt`). Auth Hooks use Standard Webhooks signatures, NOT a user JWT. The handler rejects unsigned, invalid or stale signatures using standardwebhooks.
3. Set Edge Function secrets in the dashboard (never chat/Git):
   - `SMS_TEST_ENABLED=false` initially
   - `SMS_TEST_PHONE`: the owner's approved test number, 09… or +989…
   - `MELIPAYAMAK_USERNAME`: panel username
   - `MELIPAYAMAK_API_KEY`: ROTATED API key, sent in provider's password parameter
   - `SEND_SMS_HOOK_SECRET`: complete generated Auth Hook secret, including v1,whsec_ prefix
   Supabase supplies SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in hosted Edge Functions. Do not expose them to browser code.
4. Hook URL: https://<project-ref>.supabase.co/functions/v1/send-sms. Configure HTTPS Send SMS Hook with the SAME signing secret, but do not enable until the function and budget are deployed. If the dashboard requires saving to generate the secret, keep the hook disabled until secrets are configured. Never use the MeliPayamak key as signing secret.
5. Only after explicit operator approval: enable the test secret and hook and, if needed, Phone provider. Keep Email provider, templates, SMTP and existing login paths unchanged. Do not enable automatic account linking or modify existing email accounts.
6. Request ONE OTP manually using Supabase Auth signInWithOtp for the allowlisted number. This can create a SEPARATE Auth user and trigger existing profile provisioning; inspect project signup triggers before this step. It must not attach to an existing email account. Submit the code privately using verifyOtp type sms, never in chat. There is no public test page in this change.
7. Check actual handset receipt, provider delivery history, latency and balance. Provider acceptance alone is not delivery. Turn SMS_TEST_ENABLED=false after the test. Do not leave the phone test advertised as production login.

Non-allowlisted requests fail closed. A signed event ID is claimed BEFORE sending; retries of that ID cannot send again. Different IDs share the total five-attempt cap. Provider timeouts/uncertain results consume an attempt and must be checked manually; no automatic resend. A recId is processed as text, avoiding JavaScript integer precision loss. No raw provider errors, keys or OTPs are logged/returned. No TLS verification bypass. This is a deliberately restricted test hook, NOT production SMS authentication UX.

The current coding sandbox cannot reach the MeliPayamak API host; real delivery must run from the deployed Edge Function. Confirm outbound connectivity/IP restrictions there. Hook availability and complete end-to-end timing still require a live test; no deployment or delivery is claimed.

Validation: `node tests/sms-hook.test.mjs` uses mocked verification and provider transport; real Standard Webhooks verification, SQL concurrency and Supabase/MeliPayamak integration require further validation before enabling. No browser/login changes are included.
