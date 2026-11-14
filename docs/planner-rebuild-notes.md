# Planner rebuild: foundation and outstanding integration

The counselor approved the light Nova-style mockup in `planner-preview/` and requested all features together, with any seven-day start date. A draft must autosave without altering what the student sees until explicit publication. Existing plans, completion records, exam links, makeup boxes and both daily routines must remain intact.

## Current status

The new planner is **not connected to the app or ready for use**. `lib/planner-grid.ts` and `lib/planner-autosave.ts` are isolated helpers. Migration `118_planner_private_drafts.sql` provides a private working-copy store with counselor/assignment checks and optimistic revisions; it has **not been applied to any project**. It does not publish anything. No old plan is rewritten. The prototype images are static design references, not functional screens.

## Required before release

- Connect a responsive seven-day editor to the existing student selection, planning data and print/report paths; retain all existing subject, exam, simulation, makeup, routine, completion and protected-day behavior.
- Integrate draft loading and the serialized autosave queue; implement an atomic publication path that checks draft revision and `base_plan_updated_at`, handles changes to the live plan and progress since editing began, and delegates to the existing authorization, validation and protected-item rules. Never clear or publish a draft after a failed or conflicting save.
- Implement and persist ready blocks, personal patterns, templates, progress suggestions and review completion with appropriate ownership and RLS. Carry prior-week reviews into the selected date range; exclude exam and makeup activities from automatically generated study reviews.
- Implement keyboard and touch-accessible movement, day copying, undo, editing and responsive desktop/mobile layouts, without bypassing locks on completed or past activities.
- Implement the three selectable print sections and preserve the existing student/print data and routine behavior. Verify paper output with real PDF/print rendering, including large weeks and long text.
- Construct and verify the full topic/page bank by book edition. Do not fabricate missing topics or page ranges, and do not redistribute copyrighted book files. Document source, edition and verification for each entry.
- Test authorization and concurrency in isolated PostgreSQL, save/reload and navigation in the browser at desktop/mobile sizes, actual PDF output, lint, TypeScript and build. Apply any database migration only when the integrated change is ready and verified.

## Source investigation

A web search found a copy of [Chemistry 3, book code 112210](https://iranarze.ir/blog/wp-content/uploads/2025/02/shimi-12.pdf). Its publication page identifies it as the ninth printing, 1405. Only the initial pages were inspected; the file states that its contents are protected. This is not a complete, validated topic bank. Search results also identify download pages for biology and other books, but their actual edition, completeness and printed page numbers still require verification.
