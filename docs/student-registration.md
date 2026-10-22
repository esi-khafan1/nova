# Student registration and scoped reporting

- Migration 036 preserves existing profiles as active and defaults future profiles to incomplete.
- Incomplete/pending students are routed to `/dashboard/registration`; only staff may activate students, atomically with assigning an approved counselor.
- Required fields and receipt ownership are validated again in the database. Status is not an authenticated-writable profile column.
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

## Assignment is activation (migration 064; supersedes 052/053 separation)

Admin assignment to an approved counselor is now the account activation decision: `admin_assign_student_counselor` inserts the assignment and sets the student's `registration_status` to `active` atomically. No second activation/receipt confirmation is required for this route. Only admins can assign, only unassigned students are eligible, and existing counselors cannot be replaced (including same-counselor stale/double submissions). Existing role, email verification, assignment ownership, curriculum and planning validations remain intact; activation does not fabricate missing student information or verify an email.

Migration 064 also repairs already assigned inactive student profiles, limited to actual student accounts whose assigned counselor is still a counselor with approved status. Unassigned students and relationships to unapproved/non-counselor accounts are untouched. The repair changes only activation status (and normal updated-at triggers); assignments, receipt/purchase fields and receipt-approval metadata are unchanged. Existing explicit receipt/manual activation endpoints remain compatible.

Applied to the connected production project and verified: the reported Mohsen Yeganeh profile changed from incomplete with an approved assignment to active, with no valid approved-assigned inactive students remaining. The counselor should refresh their student/planning directory to discard previously loaded client state. No plan or receipt was created as a production test.

Admin directory copy/button/success messages now state that assignment activates the account. Assignment actions invalidate student home/account/exams/registration and the counselor planning/directory views.

Validation: `node tests/assignment-activation.test.cjs` uses disposable PostgreSQL to verify new assignment activation for incomplete/pending/already-active students, legacy backfill, exclusion of unassigned/unapproved cases, admin-only/anonymous guards, reassignment protection, rollback of the inserted relation if activation fails, unchanged receipts and repeat-safe backfill. Updated the SQL registration-access fixture to reflect the new rule. TypeScript, targeted ESLint and production build pass. Planning permissions are not bypassed or made public.
