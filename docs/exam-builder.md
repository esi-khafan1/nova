# Counselor exam builder: editing and publication safeguards

- Field presets are starting templates. Booklet titles, question counts and durations may be customized.
- Answer keys are serialized using global question numbers, but each choice belongs to a local question within a stable booklet ID. `remapBookletKeys` preserves that ownership when counts change or earlier booklets are removed.
- Lowering a question count removes keys for deleted questions. Added questions have no inferred key; the counselor must choose one. Other booklets' PDF URLs, durations and retained choices are preserved.
- Publication still requires every booklet PDF, a valid key for every actual question, a future Tehran start time, an approved counselor and total duration at most 600 minutes. Incomplete keys and missing PDFs remain allowed only for drafts.
- Error messages use an allowlist. Raw database errors, SQL, titles and answer keys are never displayed in errors or written to application diagnostics. Diagnostics include only an error code and category.
- Compact key buttons have a counselor-builder-only font/line-height/centering override, independent of the broad portal font reset. Other buttons and student answer-sheet styles are unchanged.
- The key-remapping/font correction itself does not rewrite existing exams or change scoring. Optional floating scheduling is a separate additive feature described below.

## Verification

- Regression tests cover relative key ownership, count increases/decreases, removal, ordering, unknown-error safety and incomplete-publication rejection.
- The actual builder was tested locally at desktop and phone widths with server writes mocked. Key selection/toggling, count changes and removals preserve the expected JSON payload.
- The live `save_exam` function was tested in a transaction using an approved-counselor context: customized published booklets succeed; incomplete published keys are rejected; incomplete drafts succeed. The entire transaction was rolled back, leaving no QA exams or booklets.

## Optional floating start windows (migration 045)

- The builder defaults to the existing simultaneous-start mode. Floating mode adds a same-day Tehran opening and closing time; the closing instant is exclusive. A student who starts at 11:55 before a 12:00 cutoff gets the full configured duration from 11:55, and cannot start a new session at or after 12:00.
- All existing `exams.start_window_ends_at` values are NULL. Legacy timing, submission RPC and grading formula remain compatible. No existing exams, booklets or attempts are rewritten.
- Explicit POST start (not GET/prefetch) records a single server-timed session per student/exam. Refresh, reopen and a second tab cannot reset the start or expiry. Existing unexpired sessions can resume after the start window closes. Active service status and counselor assignment are required by server-side guards.
- Server checkpoints save current-booklet answers. Previous booklets freeze on advance. Booklet deadlines and the whole-exam deadline are persisted; waiting in a transition modal cannot extend them. Local cache restores only pending answers for the matching session/current booklet, never timestamps or position.
- Final submission allows a bounded 30-second transport grace. After that, only server-checkpointed answers can be finalized. An expired session offers saved-answer submission instead of a new start.
- Student answer review is released after start-window close plus the whole duration plus transport grace. PDF metadata is hidden until that student starts a floating session; answer-key column grants remain restricted. Session rows are own-student SELECT only; all writes go through authenticated guarded RPCs.
- Started floating exams cannot be edited via the exam save path. Preserve them and create a new exam for corrections.
- Migration verification runs security/timing/grading assertions inside a savepoint and rolls all QA rows back before commit. Production data hashes for the existing 11 exams, booklets and attempts matched before/after; no QA sessions remain.
- Frontend changes stay on the feature branch/preview until a separately authorized main merge. A frontend rollback can keep this additive schema; do not drop the session table once real sessions exist.
