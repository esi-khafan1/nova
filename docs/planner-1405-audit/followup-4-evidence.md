# Follow-up 4 — آزمایشگاه ۱۰/۱۱: add the mathematics stream — evidence

Branch `arena/9639a778-nova`, school year 1405–1406. Migration 243, catalog
change, one combined test. No PDF work was needed: the topics are a mirror of
migration 206, whose topics were already audited against the 1405 lab PDFs
(codes 110217 / 111217) in batch 2.

## What changed

### 1. Catalog — `lib/school-catalog.ts` (one line, line 28)

```ts
// before
const labExtras=field==="experimental_sciences"?(grade===10?["آزمایشگاه علوم تجربی ۱"]:grade===11?["آزمایشگاه علوم تجربی ۲"]:[]):[];
// after
const labExtras=["experimental_sciences","mathematics"].includes(field)?(grade===10?["آزمایشگاه علوم تجربی ۱"]:grade===11?["آزمایشگاه علوم تجربی ۲"]:[]):[];
```

Same grade mapping for mathematics as for experimental_sciences (10 → ۱,
11 → ۲); grade 12 still gets no lab book in either field, humanities still
gets none.

Consumer check — the math student path actually lists the book:
`lib/planning-curriculum.ts` is the only `schoolBooks()` consumer.
`curriculumBooks(field, grade, 'final_exam')` returns `schoolBooks(field,
grade)`, so a mathematics/final_exam student now sees the lab book, and
`routineSubjectOptions('mathematics', 11)` includes both lab books. The
konkur path is untouched: it reads `studyCatalog[field][grade]`, and
`lib/study-catalog.ts` contains **zero** occurrences of «آزمایشگاه» (verified
by grep — count 0), so no konkur-track lab offering was invented and
`lib/study-catalog.ts` was left untouched.

Corroboration: the DB school-subjects table already offered lab to math
students — migration `037_all_school_subjects.sql` inserts
`('mathematics',10,'آزمایشگاه علوم تجربی ۱')` and
`('mathematics',11,'آزمایشگاه علوم تجربی ۲')`. Only the TS `labExtras`
lagged behind it.

### 2. Bank — `supabase/migrations/243_planner_followup_lab_math_1405.sql`

Pattern A (one-time install, `on conflict do nothing`, install marker
`labs-math-10-11-1405-v243`). **186 new rows**, all edition `1405`,
`study_field='mathematics'`, `preparation_track='final_exam'` only,
`revision=1`, all with non-null pages:

| Book | Grade | Rows | Chapters (rows each) |
|---|---|---|---|
| آزمایشگاه علوم تجربی ۱ (110217) | 10 | 101 | فصل ۱: کلیات 14 · فصل ۲: آزمایش‌های مربی 29 · فصل ۳: آزمایش‌های دستورالعملی 37 · فصل ۴: آزمایش‌های کاوشگری 21 |
| آزمایشگاه علوم تجربی ۲ (111217) | 11 | 85 | فصل ۱: کلیات 15 · فصل ۲: آزمایش‌های مربی 16 · فصل ۳: آزمایش‌های دستورالعملی 24 · فصل ۴: آزمایش‌های کاوشگری 28 · پروژه 2 |

Combos covered: `mathematics / 10 / final_exam` and `mathematics / 11 /
final_exam` only — no `konkur` rows, mirroring migration 206 exactly.

Mirror verification: the 243 topics JSON is **byte-identical in content** to
migration 206's topics (same grade/subject/chapter/title/start/end/position
for all 186 rows — checked by parsing both files and comparing the parsed
arrays). Titles ≤ 48 chars, chapters ≤ 29 chars, all page ranges satisfy
1 ≤ start ≤ end ≤ 9999 (constraint 128).

Id formula:
`md5('nova:planner:1405:v243:mathematics:'||grade||':final_exam:'||subject||':'||chapter||':'||position)::uuid`
— pinned example: grade 10, «فصل ۱: کلیات», position 1 («کل فصل», pp. 9–23)
→ `b0801f32-715b-8d3f-4d4a-c058fe27778d`.

Collision check (all confirmed by grep):
- No prior migration contains the string `v243`.
- No prior migration inserts a bank row with `study_field='mathematics'` and
  a lab subject. The only files mentioning lab + mathematics are
  `037_all_school_subjects.sql` (the `public.school_subjects` table, not bank
  rows) and the frozen publish-validation catalogs in migrations 126/226
  (constants, not bank rows — see open item below).
- Migration 232 (batch 2) explicitly declined to invent mathematics lab rows
  ("no mathematics rows are invented here") — its lab rows are
  `experimental_sciences` / `v232` only.
- All 186 v243 ids are unique, and none equals any v206 id (same topic under
  the other field is a different row — asserted in the test).

No existing row was updated or deleted; the 186 experimental_sciences rows
from migration 206 are byte-identical before/after 243 (asserted in the
test).

## Tests

`tests/followup-lab-math-1405.test.cjs` — one file, two parts, run from the
repo root with `node tests/followup-lab-math-1405.test.cjs`.

- Part A (catalog, esbuild bundle of the real code, no DB): `schoolBooks`
  mathematics 10/11 lists the lab books; mathematics 12 and humanities do
  not; experimental_sciences unchanged; `curriculumBooks(mathematics, 10/11,
  'final_exam')` lists them; `curriculumBooks(..., 'konkur')` does not;
  `routineSubjectOptions('mathematics', 11)` includes both; source guard that
  `lib/study-catalog.ts` has zero «آزمایشگاه» mentions.
- Part B (PGlite, deps 128 + 167 + 206, then 243): pre-state has 186
  experimental_sciences lab rows and 0 mathematics lab rows; after 243,
  exactly 186 mathematics rows, every one checked field-by-field against its
  206 mirror (id via the v243 formula recomputed in JS, chapter/title/pages/
  position/revision); per-chapter counts as in the table above; all 206 rows
  untouched; `planner_list_topics('1405','mathematics','10','final_exam',
  'آزمایشگاه علوم تجربی ۱','فصل ۱: کلیات')` returns 14 rows starting with
  «کل فصل» pp. 9–23; konkur listings return `[]`; end-to-end selection — the
  catalog subject string equals the bank subject, and the topic picked from
  the listed chapter («تخمین مسافت و مهارت استفاده از نقشه», pp. 56–57,
  فصل ۳, position 10) resolves to the exact bank row by id, while the same
  topic under experimental_sciences is a different row (different id, same
  title); re-running 243 is a no-op (full bank snapshot identical); a
  simulated super-admin edit (`planner_save_topic`, title change) survives a
  re-run (revision 2); a simulated super-admin delete
  (`planner_delete_topic`) is NOT resurrected by a re-run; the
  `published_snapshot` fixture is untouched.

Result: **PASS, exit 0** (`node tests/followup-lab-math-1405.test.cjs`).
Regression check: `tests/followup-geometry2-selector.test.cjs` (PASS, exit 0)
and `tests/followup-soc-geo-fix-1405.test.cjs` (PASS, exit 0) still pass
after this change.

## Files written (only these)

- `lib/school-catalog.ts` — one-line `labExtras` change (see above).
- `supabase/migrations/243_planner_followup_lab_math_1405.sql` — 186-row install.
- `tests/followup-lab-math-1405.test.cjs` — catalog + PGlite test.
- `docs/planner-1405-audit/followup-4-evidence.md` — this file.

`lib/study-catalog.ts` was NOT edited (verified: no lab entry belongs there).
`docs/planner-1405-audit-inventory.md`, `docs/planner-topic-sources.md`, and
`tests/planner-audit-full-chain-1405.test.cjs` were NOT edited. Nothing was
committed, pushed, or PR'd; no PDF was put in git.

## Uncertainties / what was not verified

- No new PDF audit: topics/pages are inherited from migration 206 as
  instructed; the 1405 lab PDFs themselves were not re-read here.
- The publish flow was not run live (it needs profiles/weekly_plans/auth
  scaffolding beyond the PGlite preamble used here).

## OPEN ITEM for the coordinator — publish validation still blocks math lab

The frozen catalog embedded in `private.planner_validate_publication`
(migrations `126_planner_publish_validation.sql`, re-issued by
`226_planner_grade9_catalog_1405.sql`) still omits the lab books from the
mathematics lists: `finals.mathematics."10"` and `finals.mathematics."11"`
(and `routines.mathematics."10"/"11"`) contain no «آزمایشگاه علوم تجربی».
The function raises `'Invalid school subject'` for any `final_exam` item
whose subject is not in `catalog->'finals'->field->grade` (126 line ~100;
226 line ~98). So after this item, a mathematics student can select lab
topics in the planner UI and the bank serves them — but **publishing a plan
containing a lab item would be rejected** until a future migration updates
that frozen catalog (migration 126's own comment anticipates this:
"update it with the catalog in a future migration"). This was out of scope
for this item (assigned files only) and is recorded here, not papered over.
The same gap pre-existed for experimental_sciences? No — the
experimental_sciences finals lists DO contain both lab books; only the
mathematics lists lack them.

## Verdict

COMPLETE for the assigned scope: catalog lists both lab books for
mathematics students (final_exam path), 186 mathematics/final_exam bank rows
mirror migration 206 exactly with fresh v243 ids, no collisions, tests pass.
The publish-validation catalog gap above remains open for a follow-up
migration.
