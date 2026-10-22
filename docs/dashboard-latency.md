# Reduce cross-region dashboard latency

## Changes

- `getRequestClient` memoizes only the Supabase client within a React request. `getRequestUser` still calls fresh `auth.getUser()` once per request; no process/global user cache or unsigned session authorization was introduced.
- `own_dashboard_profile()` is a zero-argument, SECURITY INVOKER RPC. It selects the existing profile fields for `auth.uid()` only, under existing profile RLS. It accepts no caller-supplied identity. Its independent query can start alongside `getUser()` rather than waiting for Auth's response before sending the profile query. Protected pages/actions wait for **both** and reject a missing user/profile or a profile/user identity mismatch. Email confirmation, registration-state checks and per-caller allowed roles remain unchanged.
- `/dashboard` is a redirect-only router, not a protected content endpoint. It reads the own-row RPC to select an allowlisted destination and no longer pays for an additional remote Auth user request. The actual destination page/actions still run full `requireProfile` and fresh `getUser`; a revoked/banned/missing session cannot obtain protected content just by being routed. No client-side role hint or role stored in JWT metadata is used for authorization.
- Admin dashboard counts now use one admin-guarded `admin_dashboard_counts()` RPC with one aggregate scan instead of three separate exact-count HTTP queries. Counts remain exact and current. Errors are shown as unavailable rather than zero users.
- Landing resources, news, podcasts and existing authentication lookup are now awaited in parallel instead of four serial operations. Queries, publication filters, visible content, navbar links, styling and colors are unchanged.

## Deployment

`062_dashboard_latency.sql` was applied and verified on the connected nova project before the application deployment: both functions exist, own-profile uses SECURITY INVOKER and neither function grants anonymous execution. No content, roles, credentials, auth settings or data were changed. Deploy the associated application commit. A code-only rollback to the prior revision remains compatible with these additive RPCs.

Diagnostic tooling remains reverted. The residual temporary diagnostic database objects from the blocked cleanup are unrelated and are not called by this implementation. No new diagnostics, browser tokens, permanent caches, background polling or intentionally stale authorization are introduced.

## Validation

- `node --conditions=react-server tests/request-auth-cache.test.cjs`: actual React request-cache isolation, one client/user/profile read, concurrent start, route-only profile lookup, mismatched/revoked user denial, role restrictions, confirmation and registration checks.
- `node tests/supabase-parallel.test.cjs`: actual installed Supabase SSR/auth/PostgREST clients with a fake local test session and mocked HTTP transport. Confirms Auth getUser and own-profile RPC reach transport concurrently with no extra refresh call. Never contacts Supabase or uses real credentials.
- `node tests/editorial-workflow.test.cjs`: disposable PostgreSQL applies migration 062 as well as the editorial migrations. Checks own-profile isolation for multiple roles, single aggregate counts, non-admin/anonymous denial, and existing review/archive authorization.
- TypeScript, targeted ESLint, production build, middleware and selected auth/recovery/content regressions pass.

These changes reduce sequential work/request count; they do not move the database out of Japan or remove the network latency of each remaining call. No production speed percentage or guaranteed millisecond improvement is claimed before deployment and comparison under the same browser/network/cache conditions. The earlier diagnostic permission query is absent from both the baseline and this optimized version.

## Counselor sign-in follow-up (migration 063)

A subsequent Network capture showed two overlapping `/dashboard` RSC requests after password sign-in and ~1.4 seconds on the counselor destination. The sign-in handler previously called `router.push(destination)` immediately followed by `router.refresh()`. It now performs a single full navigation with `window.location.assign(destination)` after successful password authentication. The destination still passes through `safeReturnPath`. This avoids competing App Router navigations and stale pre-login Router Cache responses; it trades an SPA transition for one fresh document navigation, with normal browser asset caching. Password recovery, signup, confirmation, password validation and error messaging are unchanged. Extra automatic prefetch entries after the panel loads are not counted as proof of additional blocking navigations.

The counselor home previously made five parallel HTTP reads for counselor metadata and resource/request/student/plan counts. `counselor_dashboard_summary()` aggregates those same exact own-account reads into one HTTP request. It is counselor-only, takes no user ID, and uses SECURITY INVOKER so existing per-table RLS still applies. No stale cache or wider access is introduced. The card layout/text/colors remain the same, except failures now show an unavailable message and dashes instead of misleading zero counts.

Migration 063 was applied to the connected project; no records or roles were changed. Validation: a disposable PostgreSQL test checks own-account counts, different-counselor isolation, RLS filtering (including a hidden own row), admin/anonymous denial and preserved recovery navigation. Updated auth UI assertions, TypeScript, targeted ESLint, production build and existing auth/request-cache/recovery tests pass. No live-user sign-in or post-deployment latency improvement is claimed; compare a fresh capture after deployment. The Auth password-grant duration itself and remaining Tehran–Japan round trips are not eliminated by these changes.

## Student dashboard (migration 065)

The student home previously waited for complete authentication/profile, then all paginated published-plan reads, then a separate sequence of completion reads. It now starts its own-session planning RPC concurrently with `requireProfile`. No result renders until fresh Auth, identity, confirmation and student-role checks succeed. The loader's returned student ID must also match the authenticated profile. Inactive students still receive the service notice with no planning data.

`student_dashboard_page(offset)` returns up to 200 **published own** plans, their existing projected item fields and just the current student's completions for the visible items in those plans. The RPC derives `auth.uid()` internally, has student-role/activation guards and is SECURITY INVOKER under all original table RLS. No service-role client or cached/stale authorization is used. Typical accounts need one planning request rather than separate plan and completion requests. The 201st row is only a pagination sentinel: the loader keeps reading subsequent pages, so history is not capped at 200 plans. Any page error, identity/activation change or invalid pagination response discards the whole partial dataset and shows the existing failure UI instead of misleading report totals.

Migration 065 was applied to the connected project. It adds only a read-only RPC and does not alter plans, progress, roles or activation. Original page styling, report calculations, progress editing rules, service notices and day-change refresh behavior are retained. The `/dashboard` redirect and network distance to Japan still have costs; no fixed latency improvement is guaranteed.

`node tests/student-dashboard-load.test.cjs` validates 201-plan pagination and matching progress, exclusion of drafts/other students/RLS-hidden items, inactive/anonymous/admin denial, empty history, invalid offsets, whole-history failure handling, identity mismatch rejection and concurrent page wiring. TypeScript, targeted ESLint, production build, real React auth-cache tests and student planning calculation tests pass. Browser latency comparison is left to the deployment.

## Shared/site-wide read follow-up (application-only)

Audit found repeat same-render reads and serial **independent** queries beyond the student home. This change does not alter fonts, CSS, colors, images, published content, exam report-release gates or password verification.

| Area | Previous dependency chain | Change |
| --- | --- | --- |
| Shared server client | Multiple callers could construct cookie-backed clients in one render | React request-scoped client reuse; no global session/client singleton |
| News/podcast detail and listings | Repeated calls, including metadata + page, repeated database reads | React request-scoped memoization by arguments; a 3-item teaser never replaces a full listing |
| Magazine detail | Article then privacy-scoped author RPC, repeated for metadata/page | Independent published-row/author reads overlap; same-render result reused; invalid UUIDs skip reads |
| Study reports | All plan pages, then all completion pages | Both pagination sequences start together; every page retained; any failed page rejects the whole history |
| Counselor plan editor | Student directory, then all plan pages | Directory and complete own-plan history overlap; same failure UI |
| Counselor student report | Fetch entire counselor directory to locate one student | Server-side student-ID filter; ownership check still precedes the report |
| Admin users/recovery | Users then superadmin IDs | Independent existing admin RPCs overlap |
| Registration directory | Entire directory then approved counselors | Reads overlap, preserving approval filters and separate failure messages |
| Designer exam editor | Owned exam then guarded exam-details RPC | Reads overlap after role validation; the RPC independently verifies role and ownership |
| Sitemap | Published podcasts then resources | Independent published queries overlap |
| Upload authorization | Fresh Auth user then database role | Fresh Auth and existing own-profile RPC overlap; exact identity match required before all existing role/purpose/approval/assignment checks and signature creation |

React `cache` here means **only the current server render**, not `unstable_cache`, a persistent Next data cache, or shared authorization across users. Outside a React cache dispatcher it is a passthrough, not a process-wide cache. No service-role client, cached password check, skipped authorization or stale role allowance was introduced. The landing's Auth read also reuses the existing request-auth helper.

Validation executed:
- `node --conditions=react-server tests/shared-read-performance.test.cjs`: actual React request-cache dispatcher with isolated request stores; one client/cookie read per render, metadata/detail deduplication, distinct list limits, concurrent user isolation, fresh next-request archive visibility, magazine author/read overlap and invalid-ID short circuit.
- `node tests/report-read-performance.test.cjs`: gated concurrent reads, complete 201-plan/501-completion history, failed subsequent page discards the report; counselor history also retains 201 plans and rejects a failed later page.
- `node tests/upload-auth-performance.test.cjs`: actual route with mocked services; Auth/profile overlap, anonymous/mismatched identity rejection, manager/designer purpose boundaries, counselor approval and student assignment gates; denied requests never issue a signature.
- Existing actual React auth-cache and installed Supabase SDK concurrency tests, middleware, student/counselor dashboard integration, recovery and editorial PostgreSQL integration passed. Selected TypeScript assertion tests for auth, planning/report rules, news, podcasts, exam editing/publication and editorial theme also passed.
- TypeScript, targeted ESLint and production build passed. Unrelated previously recorded full-suite failures are not claimed fixed.

No new migration is required: upload authorization reuses the already-applied `062` own-profile RPC. No production database data or configuration was changed for this follow-up. These tests establish query overlap, call counts and isolation with mocked I/O; they **do not measure production latency**. Deploy the application commit and compare the same routes/browser/network conditions. Remaining Tehran–Japan round trips and Auth password-grant latency are not eliminated.
