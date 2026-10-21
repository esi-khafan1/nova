# Shared auth performance changes

## Changes
- Middleware matches `/dashboard/:path*`, `/auth`, `/auth/sign-in`, and
  `/auth/sign-up` only. Public editorial/course/static pages, APIs, signup
  confirmation and recovery handlers no longer pay the global middleware check.
- Middleware uses `auth.getClaims()` (signature/expiry verification), not
  `getSession()` or an untrusted request header. Asymmetric signing keys allow
  local verification using cached JWKS; legacy symmetric signing can still need
  a network call. Expired sessions are refreshed by Supabase SSR with cookies
  propagated to the request and response. Student guest redirects are retained.
- A React `cache()` user lookup is shared by layouts/pages and profile loading.
  The profile read is memoized within the React server request. `requireProfile`
  checks its caller's allowed roles, confirmed email and registration status on
  EVERY invocation; authorization decisions are not cached by argument arrays.
- No `unstable_cache`, global Map, persistent user cache, or public HTML caching.
  APIs/actions retain authenticated user validation, profile checks and DB RLS.
  Middleware claims are not a substitute for the fresh `getUser()` in protected
  page/action code. No UI, navbar, colors or database changes.

## Limitations
React request cache is not shared with middleware or a subsequent navigation.
Outside a React render/cache context (e.g. some action/route invocations), React
may not deduplicate; checks still run correctly. Do not reuse cached reads after
mutating auth or roles within the same request. The generic `/dashboard` role
redirect is still present. Public personalized headers still validate their user
server-side. This is not a replacement for optimizing each page's data queries.

## Measure on Runflare
1. Capture 5–10 runs before and after deploying, on the same network and account,
   with separate guest/authenticated, cold/warm and expired-session cases.
2. Temporarily set `AUTH_PERF_LOG=1` on the server and restart/redeploy. Middleware
   emits `Server-Timing: auth_claims;dur=...`. The shared server reads log
   `auth_timing` JSON with operation and duration only (no identities/tokens).
3. In DevTools separate the login `token?grant_type=password` duration from
   `/dashboard` and role-panel document/RSC timings. Check both ordinary and
   prefetched/client navigations. Record TTFB and p50/p95; don't sum parallel work.
4. Log out, open each role's panel directly as a guest; then try cross-role URLs,
   unconfirmed students and inactive registration. Verify no protected data leaks.
5. After testing disable `AUTH_PERF_LOG`. Do not export raw cookie/password/token
   payloads in HAR. Real speed gains cannot be stated until these runs are taken.

## Regression tests
- `node --conditions=react-server tests/request-auth-cache.test.cjs`: real React
  cache with isolated concurrent test request dispatchers, read counts, changed
  roles on a fresh request, guest/missing profile/unconfirmed/inactive denial.
- `node tests/auth-middleware.test.cjs`: actual Next matcher/response behavior;
  excludes public and callback routes, verifies refresh cookie propagation and
  rejects claims accompanied by an auth error. Auth network responses are mocked.
- Recovery and confirmation regression suites remain unchanged and pass.
