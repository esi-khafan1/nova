# One-click first-party signup confirmation

## Deployment
1. Deploy branch `arena/9639a778-nova` containing `/auth/confirm` to Runflare.
2. In Supabase Authentication > Email Templates > Confirm signup, use the body
   in `supabase/templates/confirmation.html`. If already installed, do not change it.
3. Site URL must be `https://nova-academy.ir`; allow `/auth/callback` and `/auth/confirm`.
4. Send a fresh signup confirmation to an account you control. A single click
   verifies server-to-server and immediately redirects to
   `https://nova-academy.ir/auth?mode=signin&confirmed=1`.
5. The normal login form appears, with a confirmation message. Verification does
   not persist a login session or overwrite the visitor's existing auth cookies.
   The user then enters their email and password to log in normally.
6. Invalid/expired/reused tokens or network failures redirect to the same login
   page with an explanatory callback error. No token is retained in that URL.

No intermediate HTML page, no second button, no browser redirect to Supabase.
The server still needs access to Supabase. No service-role key is needed.

## Operational notes
- One-click GET consumes the token. Email security scanners that prefetch links
  can consume it before the user. This tradeoff follows the explicit one-click
  requirement; a separate confirmation button was intentionally removed.
- Disable email-provider click tracking for auth emails if enabled.
- Redact `token_hash` in Runflare/proxy access logs; never log verification responses.
- Token responses are no-store/no-referrer. Existing email links remain valid
  only until their token expires or is used; changing a template does not rewrite them.
- Browser sign-in/signup still calls Supabase directly. This change only addresses
  the signup confirmation link, not all browser-to-Supabase connectivity.
- Recovery/invite/email-change templates are not changed.

## Email typography
Deploy `/fonts/estedad-arabic-wght-normal.woff2` (OFL license alongside it).
The exact public font URL has CORS headers for cross-origin previews. A 404
requires deploying the correct branch/artifact. If no font request is made,
check whether the preview strips @font-face or blocks it via CSP. Do not weaken
its security policy. Some email clients ignore web fonts and use Tahoma/Arial.
Text and buttons remain HTML, not images. Identical fonts across inboxes cannot
be guaranteed.

## Diagnosing failed confirmation
Verification now distinguishes confirmed, expired, rate-limited and unavailable
results. A network/server failure must not be described as an expired token.
Runflare logs include `signup_confirmation_failed` with machine code/status only,
never tokens/email/raw upstream messages. The existing login page offers a resend
button on confirmation errors or `email_not_confirmed`; Supabase's resend/email
rate limits still apply. Only the latest unexpired link should be used.
A password-grant `/token` 400 is not a `/verify` error and cannot diagnose why a
confirmation failed. Inspect the safe server log or Auth `/verify` error code.
No manual email confirmation/password changes are performed by this fix.
