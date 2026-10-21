# Admin-initiated password recovery

Separate admin screen: `/dashboard/admin/password-recovery`.
Regular admins can send to non-admin users. Super admins can also send to admins.
The target email is resolved in a permission-checked DB function, never accepted
from a hidden field. Reservations are audited (IDs/time only), one per target
per minute and at most 10 per actor per hour. Failed sends reserve the same
cooldown to prevent retries bypassing throttling. Supabase/SMTP limits still apply.

## Deployment order
1. Apply migration 056 (applied live during implementation).
2. Deploy the latest `arena/9639a778-nova` commit on Runflare.
3. Supabase > Authentication > URL Configuration: include
   `https://nova-academy.ir/auth/recovery` in Redirect URLs; keep existing entries.
4. Authentication > Email Templates > **Reset password** (not Confirm signup):
   subject `بازیابی رمز عبور حساب نووا`; body from
   `supabase/templates/recovery.html`; save.
5. Disable email click tracking if enabled by the email provider.
6. Test with an account you control using the new admin screen. Do not send bulk
   test emails to real users. Test invalid/expired/replayed tokens too.

## User flow (no new visible page)
Email link opens `/auth/recovery`, a backend route with no HTML screen. It puts
the recovery hash in a Secure, HttpOnly, SameSite=Lax, /auth cookie (10 minutes)
and immediately redirects to the existing `/auth?mode=reset` page with a clean
URL. That page uses the normal auth layout and a new-password field.
Saving verifies the recovery token on the server using type=recovery, then
updates that token's account with a stateless client (not the browser's current
session). Recovery credentials never reach JavaScript. Success clears the
recovery cookie/session, shows the existing sign-in form and message
`رمز عبور تغییر کرد. با رمز عبور جدید وارد شوید.` The user signs in normally.
An admin never sees or chooses the password. No service-role key is needed.
English-keyboard validation and 8–128 character limits apply on both client and
server; passwords are never trimmed or transliterated.

A scanner GET doesn't consume the token. An expired upstream token is caught on
save; a missing cookie shows an error instead of a reset form. If verify succeeds
but updating fails (e.g. reused password policy), a fresh email is required.
No passwords/tokens are logged. Redact token_hash in proxy access logs; never
log server-action form bodies. Browser sign-in still calls Supabase directly.

Tests: `node tests/password-recovery.test.cjs` mocks Auth without sending mail.
Live SQL permission/cooldown checks must run in a transaction and roll back.
