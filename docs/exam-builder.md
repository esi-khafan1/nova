# Counselor exam builder: editing and publication safeguards

- Field presets are starting templates. Booklet titles, question counts and durations may be customized.
- Answer keys are serialized using global question numbers, but each choice belongs to a local question within a stable booklet ID. `remapBookletKeys` preserves that ownership when counts change or earlier booklets are removed.
- Lowering a question count removes keys for deleted questions. Added questions have no inferred key; the counselor must choose one. Other booklets' PDF URLs, durations and retained choices are preserved.
- Publication still requires every booklet PDF, a valid key for every actual question, a future Tehran start time, an approved counselor and total duration at most 600 minutes. Incomplete keys and missing PDFs remain allowed only for drafts.
- Error messages use an allowlist. Raw database errors, SQL, titles and answer keys are never displayed in errors or written to application diagnostics. Diagnostics include only an error code and category.
- Compact key buttons have a counselor-builder-only font/line-height/centering override, independent of the broad portal font reset. Other buttons and student answer-sheet styles are unchanged.
- Timing, exam attempts, grading and access policies are unchanged by this correction. No database migration is required and no existing exams are rewritten.

## Verification

- Regression tests cover relative key ownership, count increases/decreases, removal, ordering, unknown-error safety and incomplete-publication rejection.
- The actual builder was tested locally at desktop and phone widths with server writes mocked. Key selection/toggling, count changes and removals preserve the expected JSON payload.
- The live `save_exam` function was tested in a transaction using an approved-counselor context: customized published booklets succeed; incomplete published keys are rejected; incomplete drafts succeed. The entire transaction was rolled back, leaving no QA exams or booklets.
