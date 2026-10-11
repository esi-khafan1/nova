# Student planning panel refresh

## Navigation and scope
Every student DashboardShell reuses the actual LandingHeader (same logo, menu/cart/account appearance and responsive behavior); no permanent desktop/mobile sidebar remains. Existing five landing menu entries are retained. The weekly link targets #weekly-plan, daily targets #daily-plan, account icon goes to student account. Profile editing and account deletion remain available; logout is in the student footer. Public landing header behavior is unchanged. Counselor/admin shells retain their old theme.

## Reports and measurement
- Daily view: choose any date from first published plan onward; reports for prior days readonly. Only today's activities can be changed, with existing role/owner/Tehran-date RPC checks.
- Weekly view: select any published seven-day plan (past/current/future), see its own full summary and each day's activities/report. A Wednesday plan runs Wednesday through Tuesday, not a calendar Saturday week.
- Study activities: checkbox = 100% fulfillment; unchecked = 0%.
- Test activities: recorded count / target, capped at 100%; unchecked = 0%. Daily and weekly percentages are the unweighted mean of activity ratios; empty periods display a dash, not false 0% failure. Legacy test records without a valid target have no computable ratio and count as 0, not automatic 100%.
- Time: planned duration for checked activities, NOT actual tracked elapsed time. Partial test fulfillment still contributes the full planned duration when checked, per user instruction.
- No student comment field is added. Tests and checkbox use existing completion records.
- Journey: earliest published plan start date; totals by subject/chapter include all published history. Catalogue chapters with no logged activity display 0. Custom subjects/chapters remain visible. Existing completion rows are joined by item ID, not inferred from submission timestamp.
- Student loader paginates plans and completions; a query error is a retry message, never silently empty history. Student/profile filters and existing RLS remain enforced.

## Counselor and database
Migration 033 adds save_weekly_plan_v3 rather than changing old v2 in-place, preserving old client compatibility. New starts today/future; dates are offsets 0..6 from the selected start. Existing ongoing plan edits preserve published today/past activities and their completion IDs. Printed weekday headings also follow the actual start date.
A security-definer trigger serializes checks per student with transaction advisory locking and rejects overlapping active draft/published windows across counselors and direct writes. Adjacent +7 starts are allowed. Existing legacy overlaps are preserved, not deleted or rewritten; unchanged existing windows remain editable under existing date locks. Student daily view chooses latest start in a legacy overlap and warns; weekly reports remain separate.

## Verification
Production build and TypeScript/ESLint, pure ratio/date/boundary unit tests, actual React browser tests at 1440 and 390, and rollback-only authenticated database fixtures. No signed-in real-student production E2E claimed. Main rollout still requires user approval.
