# Student exam review

The review reuses the actual uploaded PDF via `PdfViewer` next to the same numbered four-choice answer sheet used when taking the test. No question text or option content is extracted/retyped, and no location/overlay on the PDF is invented. Booklet selection swaps the full PDF and corresponding answer rows; status filters filter only the answer sheet, never the PDF. Bubbles are static spans, not editable form controls. Solid fill is the recorded student choice, outlined blue with a check is the key, orange fill is an incorrect recorded choice. Blank answers have no student fill. A missing key is explicitly ungraded.

## Release timing

The detail/list UI withholds review and scores until `starts_at + duration_minutes` for the whole exam. The review RPC independently enforces this same boundary with database `now()`, plus student role, own submitted attempt, published booklet exam, and current assignment. Neither finishing early nor a direct call to the review RPC releases the key. Reopen/refresh the page after the scheduled end. The existing test-taking/submission/timer logic is unchanged.

## PDF assets

`pdfjs-dist` is pinned to the same 3.11.174 version as the existing engine. `predev`/`prebuild` copy the engine, matching worker, CMaps and standard fonts to public/pdfjs. The worker/font assets were missing previously. `isEvalSupported: false` prevents PDF.js eval-based font execution. Generated assets are not checked in, and must be created before the OpenNext build. This is not a general upgrade of PDF.js to the latest major version.

## Deployment order and outstanding security dependency

1. Additive migration 028 provides own-review and owner-counselor RPCs (already applied).
2. Migration 030 adds the global end-time guard to the review RPC (applied before preview).
3. Deploy the app, including both counselor RPC consumers.
4. Apply migration 029 after the new app is live. This removes the existing table-wide authenticated SELECT of exam_booklets.key_answers while retaining metadata SELECT. Never apply this step while the old counselor routes are still deployed.

**Preview is not a complete key-confidentiality rollout until step 4.** Existing production grants still allow eligible students to select the key column directly. The new review RPC is time-gated, but that legacy path must be closed as part of the approved main rollout. Also, legacy attempt aggregates already stored in exam_attempts are not rewritten; the UI hides scores before the global end, not the historical DB aggregate column values. Submitted students cannot alter answers through this component.

## Verification

TypeScript and the actual server-page harness cover active submitted attempts (no review RPC/no UI score), ended submitted attempts, errors, absent/unfinished attempts and exam gates. Rollback-only database fixtures cover active/upcoming review denial despite submitted attempts, exact-end access, correct/wrong/blank/unknown keys, other/unsubmitted students, counselor ownership and anonymous denial. Local React+real PDF.js browser tests cover full PDF display, status filters, booklet switching, static answer bubbles, empty state and 390/1440 responsive widths. Signed-in real-student production end-to-end testing remains to be done; fixture tests are not a substitute.

## Approved palette and white sections

The answer sheet stays pure white (including rows). Palette 3 uses a narrow orange top edge, navy selected choices, blue key rings/checks, pale orange only inside incorrect selected bubbles, and a white active filter outlined in orange. Landing CSS is scoped by IDs to #mag, #podcasts, #konkur-news and #social, changing only section backgrounds to white; editorial colors, cards, icons, other sections and archive routes remain unchanged.

## Complete published keys

Migration 031 requires a numeric 1..4 key for every globally numbered question in every booklet when publishing. It has been applied and does not rewrite existing records; incomplete drafts remain allowed. The builder disables publish until all PDFs and all actual question keys are present, and the server action separately validates completion. Out-of-range extra keys cannot make a booklet appear complete. Legacy incomplete booklets show the original PDF with a general review-unavailable message, not fabricated right/wrong results or an unknown-key tab. The current key-completeness rollout does not replace pending migration 029 for legacy key-column confidentiality at main rollout.
