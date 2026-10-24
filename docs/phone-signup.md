# Phone signup and password login (existing auth theme)

## User flow

When `PHONE_SIGNUP_ENABLED=true` on the application server, signup asks for full name, mobile and chosen password in the existing form/theme. It requests an SMS, adds a code field in the same form and keeps the original values read-only. It does not ask for the password again. A successful confirmation sets Supabase SSR session cookies and full-navigates directly to the safe dashboard/course destination. Neither password nor OTP is saved to localStorage, metadata, logs or challenge cookies.

Login uses one identifier field (mobile OR email) and a password. Phone login calls `signInWithPassword`, never `signInWithOtp`; email login preserves the existing SDK/password path. No login SMS is requested by this UI. Supabase's public API still offers OTP endpoints; hook-side quotas therefore apply even to calls bypassing this UI. This change does not claim to disable those Supabase endpoints or all direct email signups while Email provider remains enabled for existing accounts.

Old accounts remain intact. `/dashboard/student/account` and `/dashboard/account` offer authenticated phone attachment using `updateUser({phone})` and `verifyOtp(type:phone_change)`. The verified UID must match the same current account. Existing verified phone numbers cannot be replaced using this form, and occupied numbers are not transferred/merged. Editable profile contact phone is NOT proof of Auth ownership. Password/email are not updated when linking. Users must keep the current password to use either identifier.

Repeated Supabase signUp does not overwrite a pre-existing unconfirmed account's password. After signup, the API checks the chosen password using `signInWithPassword`: only `phone_not_confirmed` is accepted as the expected proof. A mismatched password never produces a confirmation challenge in this flow. Such older pending accounts need their original password or support, rather than silently activating a different password. This extra password check does not send another SMS. Do not disable phone confirmations or enable auto-confirm.

OTP/resend stays in the same browser, with a 10-minute HttpOnly/SameSite challenge cookie. Supabase remains authoritative for token validity/expiry and attempt limits; OTP is six digits and existing Auth expiry settings are retained (operator configured 300 seconds). New codes use `resend`, not another signup. A timeout is ambiguous and never causes automatic retry. Old email confirmation/recovery routes and SMTP remain intact.

## Release switches and deployment

- Application/Runflare: `PHONE_SIGNUP_ENABLED=true` selects phone-only signup UI and allows signup/link/verify API operations. It is server-only; rebuild/redeploy after setting it. False/unset temporarily retains the old email signup for continuity during deployment. Password login accepts both identifiers either way.
- Supabase Edge Secrets: `SMS_SIGNUP_ENABLED=true` opens general Iranian-mobile sending with durable production quotas. It is independent of the test gate. Keep `SMS_TEST_ENABLED=false` in normal use. Existing provider username/key, hook signing secret, and template 566954 are reused; never place them in browser code.
- Apply 074 and 075, deploy the updated send-sms function (JWT check off; Standard Webhooks signature mandatory), deploy the application commit, then enable release switches together after smoke testing. Closing SMS_SIGNUP_ENABLED stops new sends, not existing password login. Closing PHONE_SIGNUP_ENABLED hides linking and restores legacy signup; it does not disable password login or already-issued OTP validity, but its API currently requires the flag for confirmation too, so leave a short drain window when closing it.

Production changes in this task: 074/075 applied, updated Edge function deployed, **both SMS gates explicitly left false**. No real signup, link, password change, SMS or role/student data mutation was performed in this implementation task. The site's new UI still requires application deployment and explicit release configuration. Do not describe a Git push or a mocked test as a production deployment.

The earlier standalone test created a separate phone account for the owner's test number. It is not automatically merged/deleted or given a password here. Trying to signup again or link that occupied number should be rejected. Use a consenting fresh test number for a fresh signup/link smoke test, or agree on cleanup of the disposable test account separately.

## Abuse controls and costs

The public hook claims attempts atomically BEFORE sending. It deduplicates signed events and allows one attempt/60 seconds, three/hour and five/day per HMAC-derived phone key, plus 50/hour and 200/day across this hook. Failed/ambiguous sends consume budget. HMAC uses the hook signing secret; raw phone, OTP, provider keys and recIds are not persisted. Records older than seven days are deleted on the next claim. These limits are conservative starting limits, not unlimited availability, a currency spending cap, a full bot/DDoS solution or controls on unrelated panel sends. Carrier billing may count multiple SMS parts. Configure gateway/IP protections and consider a CAPTCHA before broad release; no CAPTCHA keys were supplied and none is silently claimed to be active.

API requests are same-origin, JSON-only and byte-bounded; names/phone/password/code are validated and arbitrary role metadata is discarded. No service-role key is used in the site API. Hook writes require service_role and private tables remain RLS/no direct grants. Email-or-phone confirmation is added only to the three existing registration SQL guards, preserving all receipt ownership, manual approval, role checks and never-reassign-counselor logic. A verified signup does not activate paid educational services.

Phone API traffic is same-origin via the app server, avoiding direct browser-to-Supabase traffic for phone signup/login/link. Email keeps its previous transport/performance baseline. This is not proof of reliable connectivity from every Iranian network, or from Runflare to either external service. Existing admin recovery is email-based; phone-only password recovery needs a separately designed identity-checked flow, not attaching an email or issuing credentials without proof.

## Validation

- `node tests/phone-auth.test.cjs`: actual API handler, mocked Supabase; normalization, same-origin/size guards, stripped metadata, challenge binding, password-only login, code verification, linking, no merging, repeated-unconfirmed-password protection.
- `node tests/phone-schema.test.cjs`: disposable PostgreSQL, actual 074/075 migrations, atomic quota/grant/dedup/cooldown enforcement and confirmation guards with receipt/admin checks retained.
- `node tests/sms-hook.test.mjs`: test/public gates, destination priority for phone changes, provider error handling, no automatic retry; mocked transport.
- `tests/phone-signup.browser.cjs`: real browser/UI on 390x844 and 1440x900, mocked transport; password retained, code field, direct selected-course return, phone password login without SMS, old email login path, no horizontal overflow.
- Existing Auth UI, middleware, request-scoped cache, email confirmation/return-path, recovery, receipt and enrollment tests plus production build/TypeScript/targeted ESLint.

The prior standalone real OTP delivery+verification succeeded, but the NEW signup-with-password and linking flows are not yet live production E2E-tested. Verify fresh phone signup, logout/password re-login, occupied-number rejection, linking to an existing email account with UID unchanged, email login with old password, resend/invalid/expired codes and course return before broad launch.
