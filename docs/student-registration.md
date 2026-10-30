# Student registration and scoped reporting

- Migration 036 preserves existing profiles as active and defaults future profiles to incomplete.
- Incomplete/pending students are routed to `/dashboard/registration`; only staff may activate students, atomically with assigning an approved counselor.
- Required study/location fields and receipt ownership are validated again in the database. Status is not an authenticated-writable profile column.
- Receipts are in a private Supabase bucket (`registration-receipts`, JPEG/PNG/WebP, 5MB). The application verifies image signatures and provides authorization-checked, one-minute signed receipt redirects.
- Assignment creation/removal is admin-only; old counselor self-assignment RPC execution is revoked. Both directory RPCs filter by current assignments before returning any student data to counselors.
- Shared-exam result/count reads and result RPCs are scoped to assigned students; admin visibility is retained.
- Students can update today's/past published activity progress, not future activities or another student's records. Existing counselor edit-date and overlap restrictions remain intact.
- `/dashboard/student/plans/[planId]/print` checks role, activation, ownership, and published status and shares the existing counselor A4 template.
- School subjects are separate planning options (legacy `final_exam` storage identifier retained for compatibility), without an exam-year label. Student journey metrics combine activities for the same grade/book. Existing chapter lists are reused; missing chapter titles remain counselor-entered rather than guessed.

## Google Sheets status

The Google account is not connected in the agent browser. The scoped read-only endpoint, admin credential settings and private bound Apps Script connector are now prepared (migration 039, `integrations/google-apps-script`). Setup in the owner's browser and deployment to main are still required; no actual sheet has been created or connected. The CSV export remains an independent manual fallback. Counselor workbooks must be separate files shared as Viewer only; never grant counselors access to the master spreadsheet or its bound script. Credentials are 256-bit, SHA-256 stored, revocable, scoped by the database and valid for 90 days. The script checks both scope and subject ID, uses private Script Properties, refreshes current assignments hourly/on demand, and clears stale counselor rows if exports fail. Receipt URLs require application authentication. Google downloads/snapshots already made by recipients cannot be revoked by the application. See the Persian setup guide bundled with the script.

## Verification

- `npx tsc --noEmit`
- `node_modules/.bin/esbuild tests/registration-and-school.test.ts --bundle --platform=node --outfile=/tmp/registration-tests.cjs && node /tmp/registration-tests.cjs`
- `npm run build`
- `tests/sql/registration-access.sql`: rollback-only fixtures exercise incomplete validation, atomic approval/assignment, stale receipt rejection, counselor/receipt RLS, both blocked self-assignment paths, old progress editing, future/other-student/counselor progress denial, grade-10 school planning, unchanged past counselor activities, and shared exam result isolation. No fixture data persists.
- Offline Chromium mobile form preview and A4 landscape print preview inspected; sample seven-day print fits one A4 page.

## Historical assignment activation (migration 064; superseded for new saves by 093)

Historically, admin assignment to an approved counselor was also the account activation decision: `admin_assign_student_counselor` inserts the assignment and sets the student's `registration_status` to `active` atomically. No second activation/receipt confirmation is required for this route. Only admins can assign, only unassigned students are eligible, and existing counselors cannot be replaced (including same-counselor stale/double submissions). Existing role, email verification, assignment ownership, curriculum and planning validations remain intact; activation does not fabricate missing student information or verify an email.

Migration 093 changes the current rule: inactive accounts are activated through `admin_activate_student_auto`, which reads the locked receipt record and uses receipt approval if present or an audited manual activation if absent. A changed or missing receipt never silently falls back to the manual route. Direct assignment is restricted to already active students. The admin UI puts unassigned pending receipt submissions first and marks them for priority review; its only activation button states the path, and the two redundant checkboxes are replaced with a route-specific confirmation. This migration changes no existing student, receipt or assignment row.

Migration 064 also repairs already assigned inactive student profiles, limited to actual student accounts whose assigned counselor is still a counselor with approved status. Unassigned students and relationships to unapproved/non-counselor accounts are untouched. The repair changes only activation status (and normal updated-at triggers); assignments, receipt/purchase fields and receipt-approval metadata are unchanged. Existing explicit receipt/manual activation endpoints remain compatible.

Applied to the connected production project and verified: the reported Mohsen Yeganeh profile changed from incomplete with an approved assignment to active, with no valid approved-assigned inactive students remaining. The counselor should refresh their student/planning directory to discard previously loaded client state. No plan or receipt was created as a production test.

The former admin directory copy/button tied assignment to activation; migration 093 replaces that UI for inactive accounts with receipt-aware activation, leaving direct assignment only for already active students. Assignment and activation actions still invalidate student home/account/exams/registration and counselor planning/directory views.

Validation: `node tests/assignment-activation.test.cjs` uses disposable PostgreSQL to verify new assignment activation for incomplete/pending/already-active students, legacy backfill, exclusion of unassigned/unapproved cases, admin-only/anonymous guards, reassignment protection, rollback of the inserted relation if activation fails, unchanged receipts and repeat-safe backfill. Updated the SQL registration-access fixture to reflect the new rule. TypeScript, targeted ESLint and production build pass. Planning permissions are not bypassed or made public.

## Counselor editing of student grade/field (066)

Approved counselors can set or change the canonical `profiles.grade` and `profiles.study_field` for an active student currently assigned to them. The editor appears before the weekly plan form for the currently selected student and on that student's report page. Existing labels, colors and responsive form styles are reused. Saving has pending/error/success states, does not submit the plan form, and revalidates dashboard views so the directory, student profile and curriculum choices use the saved values. It does not reset the weekly builder's in-progress plan state or rewrite existing plan items; when changing fields, review subjects in an existing plan before resaving it.

`066_counselor_student_study.sql` adds a narrow SECURITY DEFINER RPC with empty search path, fresh database role/approved-counselor checks, a locked own assignment, active student-role guard, required valid grade/enum field and the same per-student advisory lock as plan saving. It grants no direct profile-update permission and accepts no other profile fields. Anonymous execution is denied. Original registration/account submissions, receipts, roles, activation, assignments, plans and progress remain untouched.

The migration was applied to the connected nova database; function security/search path/execute grants were verified read-only. No real student's fields were changed in validation. Disposable PostgreSQL tests (`tests/counselor-student-study.test.cjs`) cover filling null fields, subsequent edits, other counselors, unapproved counselors, other roles, missing/revoked assignments, inactive/non-student targets, invalid values, denied direct writes and preserved history/unrelated fields. `tests/counselor-study-action.test.cjs` checks fresh action role validation, tampered inputs, RPC errors, successful invalidation and selected-student/non-nested-form wiring. TypeScript, targeted ESLint, production build and existing auth, assignment, report and planning regressions passed. No authenticated production-browser interaction is claimed.

## Optional personal details (088)

In both the account form (before or after activation) and course enrollment, grade, study field, province and city remain required. Name, Telegram ID and a manually entered phone are optional; a confirmed signup phone is still read from the authenticated user and used automatically. If an optional field is provided, its format is validated. Selecting a course and submitting a private receipt remain required for normal paid enrollment; saving account details never changes activation or payment status.

Migration 088 relaxes only the `full_name`, `phone` and `telegram_id` non-null columns on the existing account and registration tables, and updates their SECURITY DEFINER functions without opening direct writes. The migration was applied to the connected nova project and verified read-only: grade/field/province/city are still NOT NULL, authenticated users have EXECUTE and anon does not. PGlite tests cover blank optional details, required fields, receipt ownership, role access and activation status; no production test account was created or modified.

## Required signup name (089)

Name is collected at phone signup, checked as a full name on both client and server, and prefilled from the same student's profile in both the account and enrollment forms. It is required alongside grade, field, province and city; contact phone entry and Telegram ID remain optional. Missing or incomplete legacy names trigger the active-student completion reminder. Migration 089 restores NOT NULL for existing account/registration names, backfills only from the same student's valid profile name if needed, and rejects blank names in both RPCs; it does not fabricate names, change activation, or affect the private receipt checks.

Migration 089 was applied to the connected nova database after a read-only check found zero null names in both tables. Read-only verification confirmed `full_name` is NOT NULL again, phone/Telegram remain nullable, both functions require full names and valid study fields, and anonymous EXECUTE remains denied. No real account was modified as a test.

## Reminder on student panel entry

On `/dashboard/student`, `/dashboard/student/account` (including the panel's account icon), and course-registration entry, an incomplete student's required name/grade/field/province/city triggers an inline notice and a dismissible dialog with a direct link to the relevant form. This applies before and after activation; complete profiles and temporary account-read errors do not trigger a false reminder. Following the link to the account form suppresses an immediate second dialog, while direct account-icon entry shows it. The reminder does not change activation/payment or request another receipt. No new database migration is needed.
