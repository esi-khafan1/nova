# First-party signup email confirmation

## Deployment order (required)
1. Deploy branch `arena/9639a778-nova` containing `/auth/confirm` to Runflare.
2. Check `https://nova-academy.ir/auth/confirm` without a token: it must return
   a 303 to the canonical `/auth?mode=signin&error=callback&next=...`, not a 404.
3. Supabase Authentication > Email Templates > Confirm signup: replace the body
   with `supabase/templates/confirmation.html` and save. The connected management
   tool cannot update email templates; this is a dashboard step.
4. Send a NEW confirmation email. Previously sent emails retain their old links.
5. Test with a real account you control: link opens only the Nova host, pressing
   the button verifies the email, sets session cookies, and opens `/dashboard`.
   Reusing/expiring a token must show the callback failure rather than log in.

Site URL must be `https://nova-academy.ir`; redirect allowlist must include
`https://nova-academy.ir/auth/callback` and `/auth/confirm`.

GET does not consume tokens (email scanners often prefetch links). POST only
accepts the canonical origin, verifies a signup token server-to-server using the
normal publishable key, and does not expose session tokens in redirects. No
service-role key is needed. The server still needs access to Supabase.

Disable email-provider click tracking for authentication emails if enabled:
otherwise the provider may wrap the first-party link in its own tracking host.
Configure Runflare/proxy access logging to redact the `token_hash` query parameter
and never log POST form bodies. Token-bearing pages are no-store/no-referrer.

This addresses email confirmation only. The current browser sign-in/signup code
still calls Supabase directly; making *all* auth requests first-party is separate
work. Recovery/invite/email-change templates are not changed by this template.

Do not disable email verification or remove SMTP rate limits as a workaround.

## Email typography
The confirmation template requests the site's Estedad font from
`/fonts/estedad-arabic-wght-normal.woff2` (OFL license alongside it).
Deploy this asset before updating the template. Supporting email clients and
browser previews use Estedad; Gmail and clients that disallow web fonts use
Tahoma/Arial/system fallback. Identical typography across all inboxes cannot be
guaranteed. Body text and confirmation buttons remain real, selectable HTML.
