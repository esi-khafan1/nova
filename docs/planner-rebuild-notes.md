# Planner rebuild: foundation and outstanding integration

The counselor approved the light Nova-style mockup in `planner-preview/` and requested all features together, with any seven-day start date. A draft must autosave without altering what the student sees until explicit publication. Existing plans, completion records, exam links, makeup boxes and both daily routines must remain intact.

## Current status

The new planner is **not connected to the app or ready for use**. The grid, autosave/session coordinator, analysis, review and topic suggestion modules are isolated components/helpers. Migration `118_planner_private_drafts.sql` provides a private working-copy store; `119_planner_atomic_publish.sql` delegates publication to the existing save chain after checking draft revision and base plan; `120_planner_personal_presets.sql` stores counselor-owned presets; `121_planner_reviews.sql` provides published-item review checkmarks; `122_planner_published_extras.sql` publishes extra week/item data atomically; `123_planner_review_history.sql` retains checkmarks through item replacement or changes. These migrations have **not been applied to any project**. No old plan is rewritten. The prototype images are static design references, not functional screens.

## Required before release

- Connect a responsive seven-day editor to the existing student selection, planning data and print/report paths; retain all existing subject, exam, simulation, makeup, routine, completion and protected-day behavior.
- Integrate draft loading, the serialized autosave session, existing server-side validation and the atomic publication RPC. The transport calls the RPC directly: before use, establish that all validations enforced by `saveWeeklyPlanCore` also run authoritatively for publication (not merely in the browser). Ensure the UI handles changed live plans and progress since editing began. Never clear or publish a draft after a failed or conflicting save.
- Connect preset storage and implement ready-block, personal-pattern and week-template interfaces. Connect topic suggestions and review completion (including the published-history RPC, historical toggles and draft previews). Carry prior-week reviews into the selected date range; exclude exam and makeup activities from automatically generated study reviews. On publication, supply each persisted item's `sourceItemId` even when v9 requires `id: null` for a future item. Unchanged reviews then transfer with their timestamp; changed/removed source reviews remain separately visible as history. Integrate and test this behavior end to end, including legacy clients.
- Implement keyboard and touch-accessible movement, day copying, undo, editing and responsive desktop/mobile layouts, without bypassing locks on completed or past activities.
- Implement the three selectable print sections and preserve the existing student/print data and routine behavior. Verify paper output with real PDF/print rendering, including large weeks and long text.
- Construct and verify the full topic/page bank by book edition. Do not fabricate missing topics or page ranges, and do not redistribute copyrighted book files. Document source, edition and verification for each entry.
- Test authorization, save/reload and navigation in the integrated browser at desktop/mobile sizes, actual PDF output, lint, TypeScript and build. A disposable multi-session PostgreSQL test exercises concurrent publish/autosave, completion and review ticks through the actual v9→v3 save chain (including current v4/v5); expand it to exam races. Apply any database migration only when the integrated change is ready and verified.

## Source investigation

A web search found a copy of [Chemistry 3, book code 112210](https://iranarze.ir/blog/wp-content/uploads/2025/02/shimi-12.pdf). Its publication page identifies it as the ninth printing, 1405. Only the initial pages were inspected; the file states that its contents are protected. This is not a complete, validated topic bank. Search results also identify download pages for biology and other books, but their actual edition, completeness and printed page numbers still require verification.
