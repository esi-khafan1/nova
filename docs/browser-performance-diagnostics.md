# Browser-visible dashboard timings

No Node/Runflare log access or environment variable is needed for this opt-in tool.

## Usage

1. As superadmin, open `/dashboard/performance`. To test another admin/content-manager account, select that exact account and grant access for one hour. No role changes occur. Grants can be revoked immediately; expired grants are ignored.
2. In the account to be tested, open `/dashboard/performance` and enable measurement for this browser. An HttpOnly, SameSite=Lax cookie scoped to `/dashboard`, with a one-hour maximum age, only requests diagnostics; it is **not** authorization. Every measured request checks the database grant/superadmin capability. Errors fail closed.
3. Return to the landing page and click the account icon. In diagnostic mode only, `/dashboard` pauses to show its own measurements instead of redirecting. Copy its report, then click Continue to panel and copy the destination report. With diagnostics disabled, the normal immediate redirect is unchanged. For a clean sample use fresh navigation/reload, No throttling, and note VPN/cache conditions. Next prefetch/cached responses can appear in browser resource entries.
4. Send both reports plus Network Timing screenshots. Disable measurement at the same settings page when finished. Both the browser opt-in and delegated access expire after one hour. Superadmins have authorization but still must opt in per browser.

## Coverage and interpretation

- `middleware_claims`: the existing verified-claims call; also available in Server-Timing while opted in.
- `auth_user`: the existing server getUser request.
- `profile`: the existing profile query.
- `editorial_queue` / `editorial_authors`: existing parallel queue/author queries in content-manager pending/rejected tabs. Do **not** sum parallel durations.
- `editorial_live`: the existing published/archived catalogue RPC.
- `admin_counts_parallel`: the existing group of parallel admin count queries, when testing an admin.
- `debug_access`: the diagnostic permission check itself, reported separately. It is extra overhead only for opted-in browsers. When off, there is no diagnostic database query.
- `server_ready_ms`: approximate wall-clock elapsed from middleware entry to generating the report. It includes authorization overhead and middleware-to-render handoff; it is **not** complete response-stream duration, full SSR completion, database-internal execution time, browser render time or total network time. This is why it is rendered in the page rather than presented as a complete Server-Timing header.
- Browser request samples: same-origin entries for that exact route from Resource/Navigation Timing. Query strings, full URLs, identities and payloads are not included. Entries may include prefetch, previous navigation or cached results; these samples are supplemental, not correlated request IDs. Network Timing remains the source for identifying a particular request/Receiving duration.

Reports contain static route/stage labels, durations and transfer byte counts only. No cookies, tokens, email, user IDs, query strings or content are copied. Timing records live only in React's per-request cache and the rendered authorized response, not a global cache or database. The private grant table stores only account ID and expiry; access is controlled through superadmin-only RPCs. No analytics endpoint, permanent browser storage, polling, additional auth checks, artificial delay or database execution of a duplicate business query is added. Instrumentation never relaxes auth/RLS.

## Validation/deployment

Migration `061_temporary_performance_access.sql` was applied to the connected nova project. It creates no automatic delegated grants and does not change content, roles or auth settings. Deploy the application commit, then use the steps above.

Validated with TypeScript, targeted ESLint, the production build, middleware cookie-refresh/header-spoof tests, actual React request-cache/isolation tests, disposable PostgreSQL permission/grant/expiry/revocation tests, and opt-in/fail-closed access tests. Live end-user browser testing is left for the deployment; no production latency conclusions are asserted by these tests.
