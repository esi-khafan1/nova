# Exam designer and printable student reports — production rollout

Branch: `feature/exam-designer-reports`. The owner has completed preview QA and explicitly approved merging this release into `main`.

## Production cutover checklist

1. Merge the approved feature branch through a PR and wait for the main Cloudflare build to succeed.
2. Only after the new UI is live, apply migration 049 to retire the temporary legacy counselor-save RPC grants from migration 048. The designer entry point stays available.
3. Run `tests/sql/exam-designer-reports.sql`; it now expects the legacy counselor entry point to be denied. All QA writes roll back.
4. Check the public main site, authentication redirects and absence of local QA routes. Do not delete or rewrite historic exam/answer/report data.

Migration 049 contains the narrowly scoped permission rollback command as an operational comment, should the old UI ever need restoring.

## Changes

- Separate `exam_designer` role, routes and designer-only server action. No results/report access.
- Paginated, Persian-normalized student name search. Only ID, name, grade and study field are returned.
- Explicit exam-to-student enrollment, independent of a counselor relationship. Enrollment and exam saving are atomic.
- Locked national templates use real booklet groupings and server-owned subject ranges. Custom mode keeps independent subject selection.
- Shared printable report component for counselor and student, including per-subject percentages and performance history. Student release is checked with database time after the global fixed/floating exam end.
- Counselor reports are restricted to the counselor's own students, even when another account designed the exam.
- Preserve two decimal places and negative marks for new submissions. Historic stored scores are not rewritten; printable totals are recalculated from the original question keys and answers.
- Admin role selector supports student, counselor and exam designer. Admin accounts cannot be demoted through this control.

## Database rollout

Migrations 046–047 were applied before the owner requested branch-only delivery. No application code was pushed to `main`. After the preview deployed successfully and the owner approved database changes, `doob58157@gmail.com` was changed to `exam_designer` through the protected admin role RPC.

Migration 048 restores legacy counselor-builder compatibility while the feature is in preview. The new preview action remains designer-only and uses a separate private wrapper. Migration 048 was applied after the owner's explicit approval and the integration suite was rerun.

Migration 049 removes legacy counselor-save grants and entry points after the designer UI is deployed, completing production cutover. Do not edit existing migration history. Do not disable either the profile role-change trigger or row-level security.

During preview, the branch shared the production Supabase project. **The requested test account now has the designer role on the shared database, including the main site**, whose current build has no designer page. This account becomes usable on the main site once the designer-enabled production build is deployed. This shared-backend limitation was explained to the owner. Other users retain their original roles. Do not create a login bypass or expose auth secrets for QA.

## QA performed

- `npm run build` and TypeScript compilation.
- All TypeScript assertion test files using `node scripts/run-tests.cjs tests/<file>.test.ts`.
- `tests/konkur-subject-results.test.ts`: five template totals, exact continuous question ranges, tamper rejection, physics/chemistry boundary isolation, negative percentages, fractions and legacy fallback.
- `tests/sql/exam-designer-reports.sql`: transactional authenticated-role/RLS integration tests. All test writes and temporary role changes roll back. Covers selected/unselected students, forbidden key-column reads, forbidden designer report access, rejected counselor design calls, early report rejection, 23.81% grading and 100% physics vs −33.33% chemistry.

- Local-only Chromium smoke test: all five template booklet/question totals, frozen add/delete controls, custom subject mode, no designer report navigation, and zero horizontal overflow at 390px. The temporary local route was removed and never committed.
- Shared printable-report render test with synthetic data: nine subject rows, six historical exams, nine legend entries, and exactly one A4 PDF page. The temporary mock script was removed and never committed.
- Cloudflare preview build succeeded. Public sign-in returns 200; unauthenticated designer and student-report routes redirect to sign-in.

Authenticated browser testing with the owner's account has not yet been performed. ImageKit upload requires existing runtime secrets and must be checked on the preview; no upload secrets are committed here.

## Preview

https://feature-exam-designer-reports-nova.doob4347.workers.dev

Production `main` was independently verified at commit `970034b196b3e155c52dea8c91ea7ed00dce1a0d`; the feature application commit is `f5de2bfcc25f23aef393139d31e7af23cfc3867e`.


## Additional owner-reviewed fixes included in this release

- Course type, duration in months and additional notes are appended to admin CSV exports; Persian encoding, multiline fields and spreadsheet-formula escaping are retained.
- Desktop auth uses the same right-side password eye and left-aligned credentials as mobile; admin role controls have separate labels and adequate spacing.
- Student exam cards use the landing editorial visual language on white; the designer workspace uses the approved landing header, ice-blue/orange theme and no duplicate upper action links.
- Publication diagnostics identify missing PDFs, students and exact globally numbered keys. Incomplete publication is blocked without losing form values; a complete 105-question payload was tested through the form action with synthetic data.
- Today's exam time selects the earliest valid minute in Asia/Tehran with the existing five-minute lead. Calendar today markers, late-night limits, open-form clock refresh, arbitrary valid minutes and floating-window end adjustment are covered.
- Final application build and all 25 TypeScript test files passed. Local browser QA used synthetic fixtures only; those routes were removed before the release commit.
