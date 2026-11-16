# Follow-up 4b evidence — lab books for mathematics in the frozen publication catalog (migration 244)

## Problem (verified from the migration files)

Item 4 added «آزمایشگاه علوم تجربی ۱» (grade 10) and «آزمایشگاه علوم تجربی ۲»
(grade 11) to the mathematics stream in `lib/school-catalog.ts` (`labExtras`)
and to the topic bank (migration 243), so a math student can select them — but
the frozen catalog inside `private.planner_validate_publication` (defined in
migration 126, re-issued by migration 226) still omitted both books from
`finals.mathematics."10"` and `finals.mathematics."11"`. The finals gate at
226 line ~98 is:

```sql
not (coalesce(catalog->'finals'->field_key->item_grade::text,'[]'::jsonb) ? btrim(entry->>'subject'))
→ raise exception 'Invalid school subject'
```

so publishing a math student's plan containing a lab item would have raised
`Invalid school subject`. Without this fix the Item 4 capability was
half-broken. (Reproduced in PGlite before applying 244: see test section.)

## What changed — migration 244 only

File: `supabase/migrations/244_planner_followup_lab_math_publish_1405.sql`.
It re-issues `private.planner_validate_publication` based on migration 226
(the latest re-issue), not 126. Exactly six lists in the embedded catalog
changed, each by insertion of lab subjects only, in the exact positions the
app curriculum (`lib/planning-curriculum.ts`: `curriculumBooks` /
`routineSubjectOptions`) puts them — i.e. mirroring what
`experimental_sciences` has for lab:

| List | Change |
|---|---|
| `finals.mathematics."10"` (14 → 15) | `آزمایشگاه علوم تجربی ۱` appended at index 14 (last, after `تربیت بدنی ۱`) |
| `finals.mathematics."11"` (14 → 15) | `آزمایشگاه علوم تجربی ۲` appended at index 14 (last, after `زمین‌شناسی`) |
| `routines.mathematics."10"` (14 → 15) | `آزمایشگاه علوم تجربی ۱` appended at index 14 (last) |
| `routines.mathematics."11"` (28 → 30) | `آزمایشگاه علوم تجربی ۱` at index 14 (after `تربیت بدنی ۱`, end of the grade-10 block); `آزمایشگاه علوم تجربی ۲` at index 29 (last, after `زمین‌شناسی`) |
| `routines.mathematics."12"` (42 → 44) | `آزمایشگاه علوم تجربی ۱` at index 14 (after `تربیت بدنی ۱`); `آزمایشگاه علوم تجربی ۲` at index 29 (after `زمین‌شناسی`, before `حسابان ۲`) |
| `routines.mathematics."null"` (55 → 57) | `آزمایشگاه علوم تجربی ۱` at index 27 (after `تربیت بدنی ۱`); `آزمایشگاه علوم تجربی ۲` at index 42 (after `زمین‌شناسی`, before `حسابان ۲`) |

No other list changed. No grade-9 list changed (there is no grade-9 lab book,
in either field), no grade-12 finals list changed (there is no lab ۳), no other
field's list changed.

### Why the routines lists too

The routines path gates lab subjects the same way the finals path does: it
takes `allowed := catalog->'routines'->field_key->grade_key` (the student's own
field and grade) and raises `Invalid routine subject` for any non-empty routine
subject not in that list (unless retained from a previous routine). Under 226,
`routines.mathematics` contained no lab subject at any grade, while the app's
`routineSubjectOptions('mathematics', 11)` already lists both lab books (Item 4
test asserts this) — so a math student who put a lab book in a weekly routine
would equally have failed publication. The routines lists are cumulative by
grade (grade 11 includes the grade-10 subjects, etc.), exactly as
`experimental_sciences` does for lab, so lab ۱ appears in the grade-10 block
of the 11/12/`null` lists and lab ۲ at the end of the grade-11 block.

## Byte-identity proof (function body vs migration 226)

Proved two ways, both recorded in the test file
(`tests/followup-lab-math-publish-1405.test.cjs`, static proofs 1–2) and
re-checked with an independent Python pass before writing the migration:

1. With the `$catalog$…$catalog$` literal masked out, the 244 file from
   `create or replace function` to the end (`revoke …; notify pgrst,
   'reload schema';`) is **byte-identical** to migration 226. The only
   difference outside the catalog literal is the file header comment (226's
   two-line grade-nine header replaced by 244's header describing this change).
2. Parsing both catalog JSONs: the only differing lists are the six above;
   each differs solely by insertion of `آزمایشگاه علوم تجربی ۱` and/or
   `آزمایشگاه علوم تجربی ۲`, with the order of all pre-existing elements
   preserved and nothing removed. The catalog JSON round-trips byte-identically
   through `json.dumps(..., ensure_ascii=False, separators=(',', ':'))`, so the
   re-emitted literal introduces no formatting drift.

## Parity with the app curriculum

The test bundles the real `lib/planning-curriculum.ts` (esbuild, same pattern
as the follow-up-4 test) and asserts:

- `244 finals.<field>.<grade>` equals `curriculumBooks(field, grade,
  'final_exam')` for every field (`null`, `mathematics`,
  `experimental_sciences`, `humanities`, `arts`, `foreign_languages`) and
  grade 9–12 — strict order, all pass.
- `244 routines.<field>.<grade>` equals `routineSubjectOptions(field, grade)`
  for every named field and grade 9–12 plus `null` — strict order, all pass.

### Known, deliberately untouched divergence: `routines."null"` ordering

`routines."null".10/11/12/null` are set-equal to the app but in a different
order: the app now puts `آزمایشگاه علوم تجربی ۱` right after `تربیت بدنی ۱`
(because Item 4 made lab appear via the mathematics block first in the
cross-field union), while the frozen 226 lists put it after `زیست‌شناسی ۱`
(via `experimental_sciences`). This is pre-existing (caused by Item 4, not by
244), purely an ordering difference in a membership-checked list — the
validator only ever does `allowed ? subject`, so it cannot change any
validation outcome. 244 leaves those four lists byte-identical to 226, per
the "only lab subjects added to the mathematics lists" scope. The test
asserts exactly that (byte-identical to 226, same subject set as the app).

Consequence to flag for the coordinator: the existing
`tests/planner-publication-validation.test.cjs` (which asserts strict order
parity of the 226 catalog against the app, including `routines."null"`)
currently FAILS at `routines.null.10` for this ordering reason — it fails
before it even reaches the mathematics lists. That failure predates 244 and
is not fixed by it; relaxing that test's `routines."null"` comparison to
set-equality (or re-freezing the order) is a coordinator decision, out of
scope for this item.

## Behavior matrix (PGlite: 126 + 226, then + 244)

276 cases per run: finals path (5 student fields × grades 9–12 × 9 subjects:
lab ۱, lab ۲, `ریاضی ۱`, `زیست‌شناسی ۱`, `هندسه ۱`, `تاریخ ۱`, `فارسی ۱`,
`ریاضی`, `درس نامعتبر`), konkur path (5 fields × 3 cases — the grade-9
`هوش و استعداد تحلیلی` rule), routines path (9 field+grade students × 9
subjects, baseline valid plan item). Results under 226-only vs 226+244 are
identical **except for exactly these 9 cases**, each changing from a rejection
to `OK`:

| Case | 226-only | 226+244 |
|---|---|---|
| finals `mathematics`, grade 10, `آزمایشگاه علوم تجربی ۱` | `Invalid school subject` | OK |
| finals `mathematics`, grade 11, `آزمایشگاه علوم تجربی ۲` | `Invalid school subject` | OK |
| routines math student grade 10, `آزمایشگاه علوم تجربی ۱` | `Invalid routine subject` | OK |
| routines math student grade 11, `آزمایشگاه علوم تجربی ۱` | `Invalid routine subject` | OK |
| routines math student grade 11, `آزمایشگاه علوم تجربی ۲` | `Invalid routine subject` | OK |
| routines math student grade 12, `آزمایشگاه علوم تجربی ۱` | `Invalid routine subject` | OK |
| routines math student grade 12, `آزمایشگاه علوم تجربی ۲` | `Invalid routine subject` | OK |
| routines math student grade `null`, `آزمایشگاه علوم تجربی ۱` | `Invalid routine subject` | OK |
| routines math student grade `null`, `آزمایشگاه علوم تجربی ۲` | `Invalid routine subject` | OK |

Spot checks that stayed rejected (unchanged behavior): mathematics grade-10
plan item with lab ۲, grade-11 plan item with lab ۱, mathematics grade-10
routine with lab ۲, `درس نامعتبر` everywhere, `زیست‌شناسی ۱` for a
mathematics student, lab subjects for humanities/arts students.
`experimental_sciences` lab items validate under both versions (finals and
routines). The konkur-path cases (including the grade-9
`هوش و استعداد تحلیلی` rule) are unchanged.

## Test result

`tests/followup-lab-math-publish-1405.test.cjs` — **PASS, exit 0**, run twice
from the repo root (`node tests/followup-lab-math-publish-1405.test.cjs`).
It applies 126 + 226 (+ a minimal preamble: roles, `private`/`auth` schemas,
`public.content_status`, `public.profiles` / `public.weekly_plans` /
`public.weekly_plan_items` / `public.counselor_students` /
`private.planner_working_drafts`, `auth.uid()` stub, and the stubs 126 needs
for its publisher rename), asserts (a)–(d) above, and asserts (e) re-running
244 is a no-op: `pg_get_functiondef` of the installed function is identical
before/after the second application, and the same cases still behave the same
way.

## Files written (only these three)

- `supabase/migrations/244_planner_followup_lab_math_publish_1405.sql`
- `tests/followup-lab-math-publish-1405.test.cjs`
- `docs/planner-1405-audit/followup-4b-evidence.md` (this file)

No other file was edited. Nothing was committed, pushed, or merged; no PDF
was put in git. `docs/planner-1405-audit-inventory.md`,
`docs/planner-topic-sources.md`, and
`tests/planner-audit-full-chain-1405.test.cjs` were not touched.

## Verdict

COMPLETE. Migration 244 restores the frozen publication catalog to parity
with the app curriculum for the mathematics stream (finals and routines), with
byte-identity of everything else vs migration 226 proven in-test, and the
276-case behavior matrix shows the only behavioral change is the nine
math+lab cases going from rejected to accepted. Re-running 244 is a no-op.

## Open items / uncertainties

- None for this item. The `routines."null"` ordering divergence noted above
  is pre-existing, behavior-neutral, and out of scope; the coordinator may
  want to relax `tests/planner-publication-validation.test.cjs` accordingly.
- 244 must be applied after 226 in the migration sequence (it is a full
  re-issue of the function, so it would also install cleanly on its own, but
  the intended order is 126 → 226 → 244).

## Amendment 4c — routines."null" order (migration 244, 2026-11-17)

This section supersedes the "Known, deliberately untouched divergence" section
above: the divergence is now fixed in 244, not left untouched.

**Trigger.** `tests/planner-publication-validation.test.cjs` failed (exit 1) at
the `routines."null"."10"` deepStrictEqual: the app puts
`آزمایشگاه علوم تجربی ۱` right after `تربیت بدنی ۱`, the frozen 226 list puts
it after `زیست‌شناسی ۱`. Same subject set — membership-only check at runtime —
but the test's contract is strict parity, including order.

**Correction to the 4b premise.** The drift was in **four** lists, not one.
Bundling the real `lib/planning-curriculum.ts` and diffing every
`routines."null"` list against 226 (grade 9 matches; the test aborts at the
first mismatch, `"10"`, so the other three were never reached): the same
union shift moved the labs in `"11"`, `"12"` and `"null"` too, because Item 4
made lab appear via the mathematics block first in the cross-field union.
All four are set-equal to the app; only the lab positions differ. All four
were reordered in 244, under the task's rule to fix order drift caused by
this same Item 4 change. Nothing else in 244 changed: the six
mathematics-list insertions are byte-identical to the 4b version, and the
function body outside the catalog literal is unchanged (the header comment
gained a short amendment note only).

| List | Move (index in 226 → index in amended 244) |
|---|---|
| `routines."null"."10"` (27 items) | lab ۱: 15 → 14 (after `تربیت بدنی ۱`, before `زیست‌شناسی ۱`) |
| `routines."null"."11"` (52 items) | lab ۱: 29 → 14 (after `تربیت بدنی ۱`); lab ۲: 32 → 29 (after `زمین‌شناسی`, before `زیست‌شناسی ۱`) |
| `routines."null"."12"` (75 items) | lab ۱: 43 → 14 (after `تربیت بدنی ۱`); lab ۲: 46 → 29 (after `زمین‌شناسی`, before `حسابان ۲`) |
| `routines."null"."null"` (88 items) | lab ۱: 56 → 27 (after `تربیت بدنی ۱`); lab ۲: 59 → 42 (after `زمین‌شناسی`, before `حسابان ۲`) |

In each list the non-lab subjects keep their exact relative order (only the
lab entries move); each amended list is deep-equal to
`routineSubjectOptions(null, grade)` and set-equal to its 226 version.

**Proofs.** `tests/followup-lab-math-publish-1405.test.cjs` now accounts for
**ten** differing lists vs 226 (six lab insertions + four lab-only reorders)
and asserts every `routines."null"` list equals the app order strictly, with
membership unchanged vs 226. The PGlite behavior matrix grew from 276 to
**312 cases** (36 new null-field routine cases: grade 10/11/12/`null`
students, konkur baselines so the empty `finals."null"` lists do not mask the
routine result); results are identical under 226-only vs 226+244 except for
the same 9 math+lab cases as before. The reorder changes no validation
outcome: the validator only ever does `allowed ? subject`.

**Test results.**

- `node tests/followup-lab-math-publish-1405.test.cjs` — **PASS, exit 0**.
- `node tests/planner-publication-validation.test.cjs` — **still FAILS
  (exit 1) at `routines."null"."10"`, as written on disk, because that test
  reads migration **226** (`tests/planner-publication-validation.test.cjs`
  line 5), not 244. No amendment to 244 can change what 226 contains; 226
  is frozen history. The coordinator must re-point that test at 244 (the
  latest re-issue of the function) for it to go green. Verified with a
  temporary replica of the test with only the file path swapped 226 → 244:
  it prints `PASS: authoritative publication validation, catalog parity and
  fail-closed grants` and exits 0, end to end (static parity loop + PGlite
  behavior). The replica was deleted afterwards; the on-disk test was not
  edited.
