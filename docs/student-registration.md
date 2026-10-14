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
