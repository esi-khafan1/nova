# Follow-up item 2 — جامعه‌شناسی ۲ + جغرافیا ۲: mis-filed old rows fixed (migration 241)

Migration: `supabase/migrations/241_planner_followup_soc_geo_fix_1405.sql`
Test: `tests/followup-soc-geo-fix-1405.test.cjs` — PASS, exit 0 (PGlite, run with
`node tests/followup-soc-geo-fix-1405.test.cjs` from the repo root).

## Correction to the brief

The old rows were **not** seeded by migrations 204 / 229 / 230. They are v1 rows
seeded by migration **144** (جامعه‌شناسی ۲) and migration **148** (جغرافیا ۲),
both using the id formula
`md5('nova:planner:1405:v1:' || field || ':' || grade || ':' || track || ':' || subject || ':' || chapter || ':' || position)::uuid`.
Migrations 204 and 180 seeded the *correct* rows that already exist in the
target lessons; 229/230 added activities/skills and never touched these rows.
Migration 241's guard uses the v1 formula with the **original** chapter, as
verified by the test (pinned ids below resolve to the pre-state rows).

## #40 — جامعه‌شناسی ۲

- File: `jamee-2-11-111222-1405.pdf` (paye-11)
- SHA-256: `4a7fb8365c9c9b9d978ceb6e23282c9323c5a80b9727622e27bcd32d306c521e` — matches the SHA documented in batch-4 evidence: yes
- PDF pages: 148. Book code: 111222 (imprint, PDF p.2). چاپ: چاپ دهم ۱۴۰۵
  («سال انتشار و نوبت چاپ: 1405 چاپ دهم», imprint p.2).
- Offset: printed = PDF − 8 (batch-4, 138 footer pairs; re-confirmed here:
  درس ۱۴ opens on printed p.115 = PDF p.123; درس ۱۵ opens on printed p.124
  = PDF p.132).
- Combos: humanities, grade 11, konkur + final_exam.
- What changed (guarded in-place update, SAME ids, revision 1 → 2):

| Track | id | Before | After |
|---|---|---|---|
| konkur | `e1f041b8-3698-b415-9346-605aee28bdc0` | درس ۱۵, pos 1, NULL pages, rev 1 | **درس ۱۴, pos 1, 120–123, rev 2** |
| final_exam | `0259b466-5818-af75-41de-dae34dd9d24a` | درس ۱۵, pos 1, NULL pages, rev 1 | **درس ۱۴, pos 1, 120–123, rev 2** |

  Title unchanged: «انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم».
- Verification from the PDF text (re-checked, not taken from the TOC):
  درس ۱۴ «انقلاب اسلامی ایران، نقطۀ عطف بیداری اسلامی» opens on printed
  p.115; the comparison discussion runs through pp.120–121 («اما انقلاب
  اسلامی ایران با انقلاب‌های آزادی‌بخش این قرن تفاوت‌هایی دارد», p.121)
  and the table «مقایسۀ انقلاب اسلامی ایران و انقلاب‌های آزادی‌بخش» is on
  printed p.122 (continuing p.123); درس ۱۵ «افق بیداری اسلامی» opens on
  printed p.124. The range 120–123 is therefore the comparison text, and
  it sits in درس ۱۴, not درس ۱۵.
- Uncertainty (minor): the p.120 section heading itself did not surface as
  a distinct heading line in PyMuPDF text extraction (p.120 extracts as
  running text continuing the امام خمینی discussion); the 120–123 range is
  corroborated by the p.121 comparison passage, the p.122 comparison table,
  and the درس ۱۵ start on p.124, and it matches the already-existing correct
  row. No page was guessed.
- Untouched: the correct row «مقایسه انقلاب اسلامی و انقلاب‌های آزادی‌بخش»
  (درس ۱۴, pos 453, 120–123, rev 1) in both tracks —
  konkur `3f8e8ce1-7250-5670-eabb-02b7b93e8a4c`,
  final_exam `1c627f07-0d65-f180-0f43-f9c6e1bb2591`.

## #44 — جغرافیا ۲

- File: `joghrafia-2-11-111218-1405.pdf` (paye-11)
- SHA-256: `dd3f33d6cf9f352d539f55293fa95f03c552d45fb88c33b07573d29e5393e4b4` — matches the SHA documented in batch-5 evidence: yes
- PDF pages: 176. Book code: 111218 (imprint, PDF p.2). چاپ: چاپ دهم ۱۴۰۵
  («سال انتشار و نوبت چاپ: 1405 چاپ دهم», imprint p.2).
- Offset: printed = PDF − 8 (batch-5, 153 footer samples; re-confirmed here:
  the «کانون ناحیه، مرزهای ناحیه» heading is on printed p.15 = PDF p.23).
- Combos: humanities, grade 11, konkur + final_exam.
- What changed (guarded in-place update, SAME ids, revision 1 → 2):

| Track | id | Before | After |
|---|---|---|---|
| konkur | `15268375-d484-b1fa-0dcf-6f2db3fa14db` | درس ۱, pos 3, NULL pages, rev 1 | **درس ۲, pos 3, 15–17, rev 2** |
| final_exam | `58396032-946b-72d8-44c8-46d6c8d182aa` | درس ۱, pos 3, NULL pages, rev 1 | **درس ۲, pos 3, 15–17, rev 2** |

  Title unchanged: «کانون و مرزهای ناحیه».
- Verification from the PDF text (re-checked): the section heading «کانون
  ناحیه، مرزهای ناحیه» is on printed p.15 (PDF p.23); the discussion of
  کانون/مرز and transitional zones continues on p.16 (PDF p.24, incl. the
  language-boundary map); printed p.17 (PDF p.25) holds the lesson activity
  (map questions on natural/human regions) and the closing summary
  paragraph («شما با مطالعهٔ این فصل…»). Printed p.18 (PDF p.26) opens
  bridge text on the political/administrative management of regions
  («به‌طور کلی، امروزه همهٔ نواحی طبیعی یا انسانی جهان تحت مدیریت نهادهای
  سیاسی یا اداری قرار دارند») — not کانون/مرز content — so the moved row
  is paged **15–17**, not 15–18.
- Note on the 1-page difference: the existing correct row «کانون و مرز
  ناحیه» (درس ۲, pos 303) is paged 15–18 (v180), i.e. it runs to the end
  of the lesson under the "range ends where the lesson ends" convention,
  while this fix pages the moved row 15–17, where the کانون/مرز content
  proper ends. Both ranges are defensible; the overlap (15–17) is part of
  the near-duplicate wart below.
- Untouched: the correct row «کانون و مرز ناحیه» (درس ۲, pos 303, 15–18,
  rev 1) in both tracks —
  konkur `3eb9f3c1-f2cb-e727-0433-46f8eafdd516`,
  final_exam `2b7d8343-c945-c735-85d2-8a20610ab495`.

## Imprint note (both books)

PyMuPDF's logical text extraction returns the imprint year digits in
content-stream order as "1504" for the sociology PDF; sorting the glyphs by
their x-coordinates gives the visual left-to-right order **1405** in both
PDFs, matching «سال انتشار و نوبت چاپ: 1405 چاپ دهم». This is an extraction
ordering artifact, not a different print year.

## Guard behaviour

Migration 241 updates only rows matching the original v1 id formula,
original title, original position, NULL pages and revision=1. It inserts
nothing and deletes nothing. The test proves the guard in a second PGlite
instance: a row admin-edited before the migration (title changed, revision
2) was left untouched in درس ۱۵ with NULL pages, and a row admin-deleted
before the migration was NOT resurrected, while the two pristine rows still
moved.

## Test results

`node tests/followup-soc-geo-fix-1405.test.cjs` — **PASS, exit 0**.
PGlite (`node_modules/@electric-sql/pglite`) applied 128 + 144 + 148 + 167 +
180 + 204 + 229 + 230, then 241, and asserted:
- the four old rows exist pre-migration with the pinned ids, NULL pages,
  revision 1, in the wrong lessons; the four correct rows exist paged,
  revision 1;
- after 241 the four moved rows keep their ids with the new chapter/pages
  and revision 2; row count is unchanged; exactly those four rows changed;
  the correct rows are byte-identical;
- a simulated plan reference (lookup by old id, plus `planner_list_topics`
  for the new chapter) resolves to the moved row under the new chapter and
  no longer under the old chapter, for both tracks of both books;
- re-running 241 is a no-op;
- a simulated super-admin edit of a moved row (via `planner_save_topic`)
  survives a re-run (revision 3, edited title intact);
- a simulated super-admin delete of a moved row (via
  `planner_delete_topic`) is NOT resurrected by a re-run;
- the published-snapshot guard row is untouched;
- in a second instance, a pre-edited old row is left untouched and a
  pre-deleted old row stays deleted.

## OPEN DECISION for the user — near-duplicates (do not silently merge)

Each moved row now near-duplicates the correct row that already exists in
its target lesson (same lesson, near-identical title, overlapping range):

1. جامعه‌شناسی ۲, درس ۱۴: moved row pos 1 «انقلاب اسلامی در مقایسه با
   انقلاب‌های قرن بیستم» 120–123 vs correct row pos 453 «مقایسه انقلاب
   اسلامی و انقلاب‌های آزادی‌بخش» 120–123 (identical range).
2. جغرافیا ۲, درس ۲: moved row pos 3 «کانون و مرزهای ناحیه» 15–17 vs
   correct row pos 303 «کانون و مرز ناحیه» 15–18 (overlapping range;
   see the 15–17 vs 15–18 note above).

In addition, the moved rows share their (chapter, position) with v1 rows
already in the target lessons: جامعه‌شناسی ۲ درس ۱۴ pos 1 «جنبش تنباکو و
عدالتخانه», and جغرافیا ۲ درس ۲ pos 3 «تغییر نواحی و نقش تصمیم‌های انسان».
(`planner_list_topics` orders by position then id, so both rows at one
position still list; the schema has no unique constraint on
chapter+position.)

Options for the user: (a) keep both rows (plans referencing the old ids
keep working; the selector shows two near-identical entries); (b) delete
the moved old rows now that the correct rows exist — but only after
confirming no saved plan references the old ids, since deletion would break
those references; (c) delete/merge the correct rows instead and keep the
moved ones. **Nothing was deleted or merged here** — this needs a user
decision.

## Verdict

Both mis-filed rows are fixed in place (same ids, correct lesson, verified
printed pages, revision 2) in both tracks. The batch-4/batch-5
"INCOMPLETE" flags for these two rows are resolved; what remains is only
the OPEN DECISION above on the near-duplicates. No other rows were changed,
no rows were added or deleted, and no other book was touched.
