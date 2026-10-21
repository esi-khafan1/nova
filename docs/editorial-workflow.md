# Content-manager editorial workflow

## Roles and screens

- `content_manager` is an independent `app_role`, not an admin capability. Its dashboard is `/dashboard/content_manager`, with the existing student **visual theme**, shared site header and bottom/logout area. No student planning, exams or registration features are added to this role.
- Only a protected superadmin can assign/remove content-manager or admin roles. Superadmins can demote ordinary admins; superadmin accounts themselves remain protected. Ordinary admins cannot change admin/content-manager accounts, including through direct profile updates or counselor-approval side paths.
- Only `content_manager` can review/edit/approve/reject submissions. Admin and superadmin roles have no editorial rights. Upload authorization supports content managers for image/audio editorial scopes.

## Lifecycle

Counselor draft → submit → pending → manager edits and saves → approve/publish OR reject with a 5–2000-character textual reason → counselor revises and resubmits.

Pending submissions are read-only to their authors. Authors see status and rejection reasons in their article/news/podcast directories. Counselor drafts are not visible in the review queue until submitted. The manager queue includes pending/published/rejected tabs and 50-item pagination. Approval uses the last **saved** version; the screen explicitly asks managers to save edits before approving.

The three live tables (`resources`, `konkur_news`, `podcasts`) remain the public read sources. `content_submissions` stores private snapshots with an independent revision counter. Starting an edit, saving a draft, submitting or rejecting never modifies an existing public row. Approval upserts the saved snapshot atomically, preserves its original author and publication date, and validates conflict ownership. Existing legacy drafts are loaded from the original table until first saved/submitted. Existing NULL-author seeds cannot be claimed by counselors.

`private.content_review_events` preserves pre-edit/review snapshots and decisions. Row locks, per-item advisory locks on saves, unique `(kind,content_id)` and expected-version checks prevent duplicate/stale saves and double approval. All RPCs check the actual database role; request roles and payload ownership/status/timestamps are never trusted. Direct authenticated writes to live tables are blocked even for managers; publication goes through the review RPC. Private snapshots have SELECT-only authenticated grants and role/ownership RLS. Trusted maintenance with no end-user identity remains possible.

Draft saves and rejections only invalidate dashboard paths. Public listing/detail/sitemap paths are invalidated on approval, not on each private edit.

## Migration / deployment

1. Apply `058_content_manager_role.sql` and commit its transaction (the enum value must be committed before use).
2. Apply `059_editorial_workflow.sql` in a separate transaction.
3. Deploy the application commit and assign the manager role from the superadmin user directory. No account is automatically assigned the new role.

Both migrations were applied to the connected nova project on 2026-10-22. Public data was compared before/after using counts and whole-row fingerprints: **all rows unchanged** (resources 8 total / 1 published; news 4 / 3; podcasts 8 / 6). No submissions, publications or role changes were created as production test fixtures.

**Deploy this application alongside the migration:** the previous counselor UI still attempts direct live-table writes, which the new database guard intentionally rejects. Reverting just the application is not a supported editorial rollback; it does not disable those guards.

## Validation

- `node tests/editorial-workflow.test.cjs`: disposable PostgreSQL/WASM integration tests; no production connection. Uses the original table DDL plus migrations 058/059. Tests all three kinds, role management, RLS, author ownership and seed protection, private drafts, pending locks, manager edits, rejection/resubmission, stale and NULL versions/decisions, publication timestamp retention, atomic ownership-conflict failures, denied anonymous/direct writes, and denial of admin/superadmin editorial actions.
- `npx tsc --noEmit`, targeted ESLint and `npm run build`: passed.
- Auth/confirmation/password/recovery/middleware/request-cache and content validation/theme regression tests: passed. Run request-cache tests with `node --conditions=react-server tests/request-auth-cache.test.cjs`.
- Full regression sweep also finds existing failures in course-carousel-cities, course-enrollment, magazine-theme, mobile-landing-ui, registration-csv (stale query mock), apps-script and counselor-curriculum tests. Each was reproduced against the preceding commit in a disposable checkout; their unrelated implementation was not changed. The old auth-role-layout test was updated to assert the new five-option, superadmin-only privileged-role controls.

No real-user browser end-to-end review flow or Runflare deployment was performed in this session.
