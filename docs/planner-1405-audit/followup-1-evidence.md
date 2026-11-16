# Follow-up 1 — هندسه ۲: hide «فصل ۴: تجسم فضایی» from the selector

## What changed

- **One line removed, one file edited:** `lib/study-catalog.ts`, the `geometry2`
  array (lines 119–124 before the change) — deleted the entry
  `"فصل ۴: تجسم فضایی"`. The array is now exactly:
  `فصل ۱: دایره`، `فصل ۲: تبدیل‌های هندسی و کاربردها`،
  `فصل ۳: روابط طولی در مثلث`.
- **Nothing else changed.** `geometry1` (هندسه ۱, grade 10) still lists
  «فصل ۴: تجسم فضایی» — it is a real chapter of هندسه ۱ and was not touched.
  `git diff lib/study-catalog.ts` shows exactly one deleted line. No migration
  was created, no bank row was deleted, edited, or added, and no other file
  was modified by this item.

## Why

Batch-4 evidence (`docs/planner-1405-audit/batch-4-evidence.md`, #36 هندسه ۲):
the 1405 PDF `hendese-2-11-111213-1405.pdf` (code 111213, 80 PDF pages,
SHA-256 `2bf760bf2263662b8f1426652c33e53531052e36d84fbb3023fe5aa5e150e421`,
چاپ ۱۴۰۵, printed = PDF − 0) has only three chapters — دایره، تبدیل‌های
هندسی، روابط طولی در مثلث — and ends at printed p.80 after فصل ۳. The catalog
nevertheless offered a fourth chapter, «فصل ۴: تجسم فضایی», which does not
exist in the book. This follow-up removes it from the selector only.

## Bank: zero rows, zero deletions

- The bank has **zero rows** for هندسه ۲ chapter 4. Verified by grep: no
  migration file seeds a row with subject هندسه ۲ and chapter
  «فصل ۴: تجسم فضایی» (the only hit is a comment in
  `supabase/migrations/234_planner_audit_batch4_1405.sql` line 18 noting the
  discrepancy). The batch-4 test independently asserts the count is 0.
- No bank row was deleted — there was nothing to delete, and this item has no
  migration at all. All 64 هندسه ۲ rows per track (فصل ۱–۳, migrations 195 /
  203 / 234) are untouched.

## Stored plans referencing (هندسه ۲, فصل ۴) — what was checked

A plan saved before this change stores the chapter as a plain string on the
item (`weekly_plan_items.chapter`) and its topics as JSON in the item extras
(`topics: [{ title, pageStart, pageEnd, bankId? }]`). The catalog is only
consulted when *offering* chapters for a new selection, never when *reading*
a stored plan. Checked in the actual code (not just assumed):

1. **`lib/planner-plan-adapter.ts` — `plannerGridFromPlan`:** reads
   `item.subject` / `item.chapter` straight off the stored item and passes
   stored topics through `readTopics`, which validates only shape (title is a
   string, pages are a valid pair, `bankId` is a string or null) and then
   `structuredClone`s them verbatim. It never looks at `studyCatalog`.
   Verified at runtime in the new test (below): a stored draft item
   (هندسه ۲, فصل ۴, three topics incl. a free-text topic with `bankId: null`
   and one carrying a `bankId` string) loads into the editor grid with
   subject, chapter, and topics byte-identical, and a
   `plannerSnapshotFromEditor` round-trip preserves them too.
2. **`components/dashboard/weekly-plan-builder.tsx` (chapter dropdown,
   ~line 774):** the chapter `<select>` is built from the current catalog
   chapters, but with an explicit fallback —
   `{item.chapter && !chapters(item).includes(item.chapter) && <option
   value={item.chapter}>{item.chapter} (ثبت قبلی)</option>}` — so a stored
   فصل ۴ stays selected and visible, labelled «(ثبت قبلی)» (previously
   recorded), instead of being dropped or silently switched. The new test
   asserts this fallback line is still present in the source and simulates
   its condition against the post-change chapter list. (Not verified in a
   live browser render — no browser is available to this worker; see
   "Could not verify".)
3. **`lib/planner-topics.ts` — `suggestNextTopic`:** filters the bank by
   subject/grade/chapter; with no chapter-4 bank rows it returns `null`
   rather than crashing or suggesting another chapter's topic. Verified at
   runtime in the new test with a bank holding only فصل ۱ and فصل ۳ rows.
4. **Both tracks affected equally:** `curriculumBooks` returns the
   `studyCatalog` list for `konkur` and `schoolBooks` (which reuses the same
   `studyCatalog` chapter lists, `lib/school-catalog.ts` line 25) for
   `final_exam`, so فصل ۴ disappears from the هندسه ۲ selector in both
   tracks. A counselor can no longer *pick* فصل ۴ for هندسه ۲, but existing
   plans keep working as in (1)–(3).
5. **No silent data loss on re-save:** because the snapshot round-trip keeps
   the stored chapter string, re-saving an old plan does not erase it. Note
   the one deliberate asymmetry: if the counselor *changes* the chapter on
   that item, the builder asks for confirmation (`confirmTopicScope`) and the
   old topics are cleared — that is the pre-existing behaviour for any
   chapter change, not something introduced here.

## Test

- New test: `tests/followup-geometry2-selector.test.cjs` (plain node script;
  bundles the real TS with esbuild, same pattern as the batch-4 test).
  It asserts: هندسه ۲ chapters are exactly فصل ۱–۳ for both `konkur` and
  `final_exam`; هندسه ۱ still has all 4 chapters incl. فصل ۴ in both tracks;
  هندسه ۳ unchanged; «تجسم فضایی» occurs exactly once in
  `lib/study-catalog.ts` (inside `geometry1`, never `geometry2`); stored-plan
  read-back + snapshot round-trip preserve subject/chapter/topics; the
  `(ثبت قبلی)` fallback is present; `suggestNextTopic` returns null for
  فصل ۴.
- Result: **PASS, exit 0.** Run from the repo root:
  `node tests/followup-geometry2-selector.test.cjs`.

## Known consequence (not mine to fix — for the coordinator)

- `tests/planner-audit-batch-4-1405.test.cjs` line 65 asserts the OLD catalog
  shape: `g2.chapters` deep-equals the 4-chapter list including فصل ۴. After
  this change that test now fails at exactly that assertion (verified by
  running it: all DB assertions pass first, then
  `AssertionError ... at planner-audit-batch-4-1405.test.cjs:65:10`, actual
  chapters = فصل ۱–۳). That assertion needs updating to the 3-chapter list
  (and its comment about the unresolved discrepancy needs retiring). I did
  NOT edit that file — it is outside this item's write list.

## Verdict

**COMPLETE.** The phantom chapter is gone from the هندسه ۲ selector in both
tracks, هندسه ۱ is untouched, no bank row was touched (none existed to
touch), and stored plans referencing (هندسه ۲, فصل ۴) still read back intact
and remain visible as «(ثبت قبلی)».

## Could not verify

- Live-browser render of the chapter dropdown showing «فصل ۴: تجسم فضایی
  (ثبت قبلی)» on a stored plan: no browser is available to this worker. The
  fallback was verified by source inspection + a runtime simulation of its
  condition, not by opening the UI.
- Whether any real stored plan in production actually references
  (هندسه ۲, فصل ۴): no production database was queried (out of scope for
  this item; the code paths above hold regardless of whether such a plan
  exists).

## Open decisions

- None for this item. The batch-4 test update noted above is coordinator
  work, not a user decision.

## Files written

- `lib/study-catalog.ts` (edited: one line removed from `geometry2` only)
- `tests/followup-geometry2-selector.test.cjs` (new)
- `docs/planner-1405-audit/followup-1-evidence.md` (new — this file)
