# Exam designer and printable student reports — preview only

Branch: `feature/exam-designer-reports`. **Do not merge or deploy to production until the owner completes QA.**

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

Before eventual production cutover, remove legacy counselor-save grants and entry points in a new migration, only after the designer UI is deployed. Do not edit existing migration history. Do not disable either the profile role-change trigger or row-level security.

The preview currently shares the production Supabase project. **The requested test account now has the designer role on the shared database, including the main site**, whose current build has no designer page. Use the preview URL for that account until production cutover. This shared-backend limitation was explained to the owner. Other users retain their original roles. Do not create a login bypass or expose auth secrets for QA.

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
