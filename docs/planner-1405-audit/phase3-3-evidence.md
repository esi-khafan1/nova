# Phase 3 item 3 evidence — آمادگی دفاعی درس ۹ page (migration 246)

Branch `arena/9639a778-nova`. The old row is PRESERVED (same id, not merged
or deleted); its page was recorded only after verifying the range against
the actual PDF text, via a guarded correction.

## PDF fingerprint + imprint

- File: `~/workspace/your_files/ketab-darsi/defai-10-110215-1405.pdf`
- SHA-256: `c870f2a5ef4feb7ef463eb62b7b95cd3cb148f6d5633f2b01d6c03496ba51c5d` —
  matches the documented SHA (migration 161; also recorded in
  follow-up 5A evidence §2).
- PDF pages: 168 (`pdfinfo`).
- Imprint (PDF p.2): «نام کتاب 110215 آمادگی دفاعی ـ دورۀ دوم متوسطه»,
  «سال انتشار و نوبت چاپ: 1405 چاپ دهم». Code 110215, چاپ ۱۴۰۵ — verified.
- Offset: printed = PDF − 8. Determined from printed footers on several
  pages: printed 88 = PDF 96, printed 116 = PDF 124, printed 119 = PDF 127;
  also printed 2 = PDF 10 and printed 159 = PDF 167 per follow-up 5A.
  Max printed page 160.

## Where جنگ‌افزارشناسی was found in the text

The front TOC (PDF p.5) lists درس ۹ at printed p.78 — that is WRONG and
was not used (real text + printed pages are the authority). The body text
shows:

| Printed page | PDF page | What the text shows |
|---|---|---|
| 78–86 | 86–94 | End of درس ۸ («عوارض زمین», نگهبانی, etc.); درس ۸ content runs to printed 86 (PDF p.94) |
| **87** | **95** | Title page «درس نهم» (no printed number on the page itself) |
| **88** | **96** | جنگ‌افزارشناسی content begins: «جنگ‌افزارشناسی — به هرگونه وسیله و ابزاری که انسان برای دفاع از خود…» (footer printed 88); سیر تحول جنگ‌افزار, سلاح سرد/گرم |
| 89–115 | 97–123 | درس ۹ body: مشخصات و مختصات جنگ‌افزار (93–94), متعلقات (94–96), اجزا و مهمات (97–99), باز و بست قطعات (99–101), اصول و آمادگی تیراندازی (102–115) |
| **116** | **124** | Last درس ۹ page (footer printed 116): ends with the «بیشتر بدانید» (4) box on تیراندازی |
| 117 | 125 | Title page «فصل چهارم» — no lesson content |
| 118 | 126 | درس ۱۰ begins («جنگ نرم», footer printed 118 on PDF p.127) |

Verified range for درس ۹: **printed pp.87–116**. This is an independent
re-verification from the PDF text, not a copy of migration 161's range: the
title page (87), the جنگ‌افزارشناسی opening (88), the continuous body
through the تیراندازی material, the closing box on 116, and the فصل ۴
title page (117) followed by درس ۱۰ on 118 all pin both ends. It agrees
with the position-301 replacement row's 87–116 (migration 161) and with
follow-up 5A's re-confirmation.

## Row history (why the guard is revision 2, not 1)

- Migration 154 seeded the whole-lesson row with pages 78–116 (from the
  front TOC), id
  `md5('nova:planner:1405:v1:<field>:10:final_exam:آمادگی دفاعی:فصل ۳: دفاع نظامی:3')::uuid`,
  title «درس ۹: جنگ‌افزارشناسی و اصول تیراندازی», chapter
  «فصل ۳: دفاع نظامی», position 3, grade 10, final_exam, fields
  mathematics / experimental_sciences / humanities.
- Migration 158 cleared its pages to NULL and bumped revision 1 → 2,
  because the 78-vs-87 start was disputed; it matched the exact seeded
  range (78–116, revision 1).
- Migration 161 deliberately left the NULL/revision-2 row alone (its
  comment: the row «could be a deliberate manager edit») and added the
  verified replacement at position 301
  («درس ۹: جنگ‌افزارشناسی و اصول تیراندازی (بازه تأییدشده)», 87–116,
  revision 1).
- This item now fills the old row because the range is verified from the
  PDF text itself, as the task authorises — via a guard that matches the
  row's exact post-158 state, so any admin edit or delete still leaves it
  untouched.

## What changed (migration 246)

File: `supabase/migrations/246_planner_phase3_defai_lesson9_page_1405.sql`
— one guarded `UPDATE`, no inserts, no deletes, no merge. It sets
`page_start=87, page_end=116, revision=revision+1` for the three rows
below, and only if each matches: original v1 id, edition 1405, field,
grade 10, track final_exam, subject «آمادگی دفاعی», chapter
«فصل ۳: دفاع نظامی», title «درس ۹: جنگ‌افزارشناسی و اصول تیراندازی»,
position 3, NULL pages, `revision=2`.

| Field | Row id | Position | Pages before → after | Revision |
|---|---|---|---|---|
| mathematics | `993769bf-84d7-6070-c368-b2aef0f44c0b` | 3 | NULL → 87–116 | 2 → 3 |
| experimental_sciences | `e9e2cad2-5dac-d53b-da1e-74222a6c3d64` | 3 | NULL → 87–116 | 2 → 3 |
| humanities | `a2f3856c-ec5e-c0e5-462f-664868c357d4` | 3 | NULL → 87–116 | 2 → 3 |

Not touched: the position-301 replacement rows (ids below, 87–116,
revision 1, unchanged); the grade-9 آمادگی دفاعی rows (different book,
code 915); every other row in the bank. The old row keeps its id, so any
plan referencing it still resolves — now with pages.

Position-301 replacement rows (verified untouched by the test):

| Field | Row id | Title | Pages | Revision |
|---|---|---|---|---|
| mathematics | `22a9dbf6-30fc-b96b-2f03-fdbf4c522c8e` | درس ۹: جنگ‌افزارشناسی و اصول تیراندازی (بازه تأییدشده) | 87–116 | 1 |
| experimental_sciences | `f57969f2-00a8-e619-830a-816f54989d49` | درس ۹: جنگ‌افزارشناسی و اصول تیراندازی (بازه تأییدشده) | 87–116 | 1 |
| humanities | `81f99696-bdc0-d766-7527-7dce73a7186f` | درس ۹: جنگ‌افزارشناسی و اصول تیراندازی (بازه تأییدشده) | 87–116 | 1 |

## Test

- File: `tests/phase3-defai-lesson9-page-1405.test.cjs`
- Run: `node tests/phase3-defai-lesson9-page-1405.test.cjs` from the repo
  root (PGlite, already installed in the clone's `node_modules`).
- Result: **PASS, exit 0**. The test applies migrations 128–244 (117
  files), asserts the pre-migration state (86 rows per grade-10 combo,
  85 grade-9 rows; exactly the three old rows NULL-page at revision 2
  with the exact ids above; the three pos-301 rows at 87–116/revision 1),
  applies 246, asserts the three old rows keep their ids with pages
  87–116 and revision 3, asserts the pos-301 rows are byte-identical,
  asserts the bank delta is exactly those three rows (no row added or
  removed, nothing else changed) and no NULL-page grade-10 defence row
  remains, asserts re-running 246 is a no-op, asserts a simulated admin
  edit (via `planner_save_topic` on the mathematics old row) survives a
  re-run, asserts a simulated admin delete (humanities old row) is NOT
  resurrected, and asserts the simulated published snapshot is unchanged.

## Verdict

**COMPLETE.** The page 87–116 is verified from the real PDF text (both
ends pinned by the title page, the body, the closing box, and the next
chapter/lesson boundaries); the guarded correction filled exactly the
three old rows and nothing else; the replacement row is untouched; tests
pass.

## Uncertainties / open decisions

1. The old NULL row and its verified position-301 replacement now both
   carry 87–116 with near-identical titles. That near-duplicate is a
   data wart inherited from migration 161's design (keep both, never
   delete the old row). Whether to hide or merge them in the selector is
   an open decision for the user/admin — this item does not merge or
   delete anything, per the task.
2. The lesson-9 title page (PDF p.95, printed 87) carries only the words
   «درس نهم»; the full lesson title comes from the TOC and the body
   content (جنگ‌افزارشناسی opening on printed 88). The range start 87
   follows the book's own convention (title page = lesson start, as with
   درس ۸'s title page at printed 64 and درس ۱۰'s at 118) and matches the
   already-verified position-301 row.
3. No commit / push / PR. No PDF was put in git. Only the three files
   listed in the report were written.
