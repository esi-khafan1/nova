# Follow-up 5A evidence — outside-79 books, part A (migration 239)

Branch `arena/9639a778-nova`. Audit standard: batch-spec (real PDF text +
printed page numbers; fingerprint first; pattern A new rows at positions
≥ 3000; pattern B guarded page-fills only). Prior seed state was established
by applying migrations 128–238 in PGlite and dumping every row for the five
subjects (all 111 migrations applied cleanly, zero failures).

## ⚠️ Brief correction — هویت اجتماعی combos

The task brief said «هویت اجتماعی: انسانی». That combo does not exist in
the catalog or the bank, and was **not** used. The book (code 112220) is
banked as subject **«علوم اجتماعی»** for **mathematics + experimental_sciences,
grade 12, final_exam only**: `lib/school-catalog.ts` offers «علوم اجتماعی»
to non-humanities grade 12 only (`commonExtras`), and humanities grade-12
students take جامعه‌شناسی ۳ instead. Prior migrations 154–161 seed exactly
those two combos. Inventing a humanities combo would contradict the catalog,
so this item follows the catalog + prior migrations, per the brief's own rule
("Never invent a combo the catalog does not support"). The coordinator
should correct the brief line for any later item touching this book.

Similarly for زمین‌شناسی the brief's «ریاضی/تجربی» is refined by the
catalog: experimental_sciences has it as a konkur subject (konkur +
final_exam), mathematics only via the school track (final_exam only — no
mathematics/konkur rows exist or were added).

## 1. کارگاه کارآفرینی و تولید دهم — 110224

- File: `~/workspace/your_files/karafarin-dahom/karafarin-dahom-110224-1405.pdf`
  (the only local copy; NOT in `ketab-darsi/`).
- SHA-256: `ce9a2d54482fecb9b6e88d344c40db7f9b55edf5be403813202ada7eea80dbf0` —
  matches the SHA given in the task and in `docs/planner-topic-sources.md`
  (migration 160). PDF pages: 137.
- Imprint (PDF p.3): code 110224, «سال انتشار و نوبت چاپ: 1405 چاپ دهم».
- Offset: printed = PDF − 9. Determined from printed footers: printed 1 =
  PDF 10 (بخش ۱), printed 127 = PDF 136 (last lesson page), printed 128 =
  PDF 137 (منابع). PDF 137 is the last page; max printed page 128.
- Structure (TOC, PDF pp.5–6, cross-checked against the text): 32 sections,
  starts 1, 5, 9, 13, 17, 21, 27, 31, 35, 41, 47, 51, 55, 59, 65, 69, 75, 79,
  81, 85, 89, 91, 93, 97, 99, 101, 103, 105, 109, 115, 119, 123; منابع 128.
  Every whole-section seed range matches its TOC start and the next section's
  start − 1.
- Prior seeds: 118 rows per combo (mathematics / experimental_sciences /
  humanities, grade 10, final_exam only), all with pages, 0 NULL. The 32
  whole-section rows + all subtopic rows (positions 101–110, 201–222,
  301–305) were spot-checked against the body headings (e.g. بخش ۲۳
  درآمدزایی 93–96, بخش ۲۹–۳۲ نگارش طرح 109–127) and match.
- What changed (pattern A, v239, position 3000):

  | Chapter | Position | Title | Printed pages |
  |---|---|---|---|
  | بخش‌های ۲۸ تا ۳۲ | 3000 ★ v239 | منابع و مآخذ | 128–128 |

  3 rows (one per field, final_exam). Precedent: batches 4/5/7 add the
  منابع section under the last chapter.
- Page-fills (pattern B): none — 0 NULL-page rows.
- Not added, with reason: front matter («سخنی با دانش‌آموزان»,
  «سخنی با دبیران ارجمند», the نمره‌دهی rubric page, فهرست) — teacher-facing
  / front matter, per batch-4/8 precedent. In-section فعالیت / کار در منزل /
  بحث و گفت‌وگو / پژوهش items fall inside their section/subtopic rows.
- Combos covered: mathematics + experimental_sciences + humanities, grade
  10, final_exam only (no konkur rows exist for this shared school book).
- Verdict: **COMPLETE**. Every section has a paged whole-section row, every
  named subtopic has a paged row, منابع now has a row, no NULL pages remain.

## 2. آمادگی دفاعی دهم — 110215

- File: `~/workspace/your_files/ketab-darsi/defai-10-110215-1405.pdf`
- SHA-256: `c870f2a5ef4feb7ef463eb62b7b95cd3cb148f6d5633f2b01d6c03496ba51c5d` —
  matches the documented SHA (migration 161). PDF pages: 168.
- Imprint (PDF p.2): code 110215, «سال انتشار و نوبت چاپ: 1405 چاپ دهم».
- Offset: printed = PDF − 8. Determined from footers: printed 2 = PDF 10
  (درس ۱), printed 157 = PDF 165, printed 159 = PDF 167 (منابع),
  printed 160 = PDF 168 (منابع, continued). Max printed page 160.
- Structure (TOC, PDF p.5, cross-checked against the text): 4 chapters,
  13 lessons. Lesson starts: 2, 11, 20, 26, 32, 45, 55, 64, **87**, 118,
  126, 136, 146; فصل title pages 1, 19, 54, 117; منابع 159. The TOC lists
  درس ۹ at 78, but the text starts درس ۹ on printed 87 (pp.78–86 are the
  end of درس ۸) — verified in migration 161 and re-confirmed from the text
  (درس ۸ subtopics run to 86; the درس ۹ title page is on printed 87).
  All whole-lesson seed ranges match (درس ۸: 64–86; درس ۹ verified row:
  87–116; درس ۱۳: 146–158).
- Prior seeds: 85 rows per combo (3 fields, grade 10, final_exam only),
  1 NULL-page row per combo (see below). All other rows paged.
- What changed (pattern A, v239, position 3000):

  | Chapter | Position | Title | Printed pages |
  |---|---|---|---|
  | فصل ۴: دفاع غیرنظامی | 3000 ★ v239 | منابع برای مطالعه بیشتر | 159–160 |

  3 rows (one per field, final_exam).
- Page-fills (pattern B): **none — deliberately**. The only NULL-page row
  is درس ۹ «جنگ‌افزارشناسی و اصول تیراندازی», فصل ۳: دفاع نظامی,
  position 3, in each field. It is **revision 2, not revision 1** (migration
  158 cleared its old 78–116 pages after the 78-vs-87 start dispute, which
  bumped the revision), so the pattern-B guard (`revision=1`) does not
  match. It is already superseded by the verified row at position 301
  («درس ۹: جنگ‌افزارشناسی و اصول تیراندازی (بازه تأییدشده)», 87–116,
  revision 1) added by migration 161. The old row is left untouched, as
  migration 161 intended. The test asserts it stays NULL/revision 2.
- Not added, with reason: the four فصل title pages (printed 1, 19, 54,
  117) contain only the words «فصل اول/دوم/سوم/چهارم» — no study text
  (batch-8 precedent: bare title pages not added); front matter (مقدمه,
  «سخنی با دبیران ارجمند و مربیان گرامی») — not added; in-lesson فعالیت
  items fall inside lesson/subtopic rows.
- Not touched: the grade-9 آمادگی دفاعی rows (field `all`, grade 9, 85
  rows — a different book, code 915) are untouched; the test asserts their
  count stays 85 and no position-3000 row appears there.
- Combos covered: mathematics + experimental_sciences + humanities, grade
  10, final_exam only.
- Verdict: **COMPLETE** (with the documented wart: the superseded NULL
  درس ۹ row at position 3 remains, by design, alongside its verified
  replacement at position 301 — same situation migration 161 created and
  documented).

## 3. هویت اجتماعی دوازدهم — 112220 (banked as «علوم اجتماعی»)

- File: `~/workspace/your_files/ketab-darsi/hoviat-12-112220-1405.pdf`
- SHA-256: `743a6ab6a27ac2ba0f8953139413ba52d0e8b87099bb3786195e64fc7312eab6` —
  matches the documented SHA (migration 161). PDF pages: 104.
- Imprint (PDF p.2): code 112220, «هویت اجتماعی (کتاب درسی علوم
  اجتماعی) — پایۀ دوازدهم», «سال انتشار و نوبت چاپ: 1405 چاپ نهم».
- Offset: printed = PDF − 8. Determined from footers: printed 1 = PDF 9
  (اهداف کتاب), printed 2 = PDF 10 (درس ۱), printed 92 = PDF 100 (منابع),
  printed 93 = PDF 101 (منابع, continued). Max printed page 93; PDF
  102–104 are the اعتبارسنجی list (printed 94+).
- Structure (TOC, PDF p.5 — its RTL number layout scrambles in
  extraction — cross-checked against the body): 10 lessons, starts 2, 8,
  17, 25, 34, 44, 53, 62, 72, 83; منابع 92. Body-verified starts: درس ۲
  p.8 (PDF 16), درس ۳ p.17 (PDF 25), درس ۴ p.25 (PDF 33), درس ۵ p.34
  (PDF 42), درس ۱۰ p.83 (PDF 91). All کل درس seed ranges match (each ends
  the page before the next lesson starts; درس ۱۰ ends 91, منابع 92).
- Prior seeds: 67 rows per combo (mathematics / experimental_sciences,
  grade 12, final_exam only), all with pages, 0 NULL. Subtopic ranges
  spot-checked (e.g. درس ۹: رابطه نظام سیاسی و فرهنگ 72–73, انواع نظام
  سیاسی 78–80).
- What changed (pattern A, v239, position 3000):

  | Chapter | Position | Title | Printed pages |
  |---|---|---|---|
  | درس ۱: کنش‌های ما | 3000 ★ v239 | اهداف کتاب | 1–1 |
  | درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران | 3000 ★ v239 | منابع | 92–93 |

  4 rows (2 topics × 2 fields, final_exam). Precedents: batch 4 added
  «اهداف کتاب» (p.1) under درس ۱ for جامعه‌شناسی ۳, and batches 4/5/7
  add منابع under the last chapter.
- Page-fills (pattern B): none — 0 NULL-page rows.
- Not added, with reason: the درس ۹ «سندپژوهی» box (printed p.77, inside
  the کل درس 72–82 range) — the book's own introduction (PDF p.7) states
  that سندپژوهی (like بخوانیم و بدانیم / ببینیم و بدانیم) is **not
  examined in the final exam**; it is an in-lesson enrichment box, and
  batch-4 precedent leaves in-lesson boxes inside their lesson rows.
  End-of-lesson «آنچه از این درس آموختیم» summary pages (7, 16, 24, 33,
  43, 52, 61, 71, 82, 91) are write-in worksheets inside the کل درس
  ranges. Front matter («سخنی با دانش‌آموزان», PDF pp.6–7) and the
  اعتبارسنجی list (94+) are not added.
- Combos covered: mathematics + experimental_sciences, grade 12,
  final_exam only. **No humanities combo** (see the correction at the top
  of this file).
- Verdict: **COMPLETE**. Every lesson has a paged کل درس row and paged
  subtopic rows, اهداف کتاب and منابع now have rows, no NULL pages remain.

## 4. زمین‌شناسی یازدهم — 111237

- File: `~/workspace/your_files/ketab-darsi/zamin-11-111237-1405.pdf`
- SHA-256: `d3933fd129e01b66c3ab681b1c849175fc6202f59a2fd87eb436522cb8182f54` —
  matches the documented SHA (migration 162). PDF pages: 128.
- Imprint (PDF p.2): code 111237, چاپ دهم 1405. Note: the imprint year
  extracts from the text layer as ASCII «1504» but **renders as ۱۴۰۵**
  on the page — verified visually from a rendered image of PDF p.2 (the
  same text-layer trap batch 8 recorded for زیست ۲/۳). Code and چاپ
  confirmed.
- Offset: printed = PDF page number (PDF 125 = printed 125; واژه‌نامه
  126–127; PDF 128 is the unnumbered اعتبارسنجی page). Max printed page
  127.
- Structure (TOC, PDF pp.5–6, cross-checked against the text): 7
  chapters, starts 9, 23, 41, 59, 77, 93, 109; واژه‌نامه 126; منابع 127.
  Chapter subtopic starts in the TOC match the seeds (e.g. فصل ۴:
  چرخه ویلسون 61, تنش 62, چین‌خوردگی 64, آتشفشان 66, زمین‌لرزه 68;
  فصل ۷: تاریخچه و نقشه‌ها 110, پهنه‌ها 113, منابع معدنی ایران 115,
  گسل‌ها 121, زمین‌گردشگری 122). Each کل فصل seed range starts on the
  فصل title/intro page and ends on its «علم، زندگی، کارآفرینی» page
  (فصل ۱: 9–21, فصل ۲: 23–39, فصل ۳: 41–57, فصل ۴: 59–75, فصل ۵: 77–91,
  فصل ۶: 93–107, فصل ۷: 109–125).
- Prior seeds: 42 rows per combo (experimental_sciences konkur,
  experimental_sciences final_exam, mathematics final_exam), all with
  pages, 0 NULL. 35 subtopic rows + 7 کل فصل rows per combo.
- What changed (pattern A, v239, position 3000):

  | Chapter | Position | Title | Printed pages |
  |---|---|---|---|
  | فصل ۷: زمین‌شناسی ایران | 3000 ★ v239 | منابع | 127–127 |

  3 rows (experimental_sciences konkur + final_exam, mathematics
  final_exam). The منابع list shares printed p.127 with the end of the
  واژه‌نامه (glossary entries run to mid-page, then «منابع», «منابع فارسی»,
  «منابع لاتین», «وب‌گاه‌های علمی»).
- Page-fills (pattern B): none — 0 NULL-page rows.
- Not added, with reason: the six full-page photo pages between chapters
  (22 معدن مس سرچشمه, 40 رود کارون, 58 ماسه‌سنگ‌های سراوان, 76 blank
  photo page, 92 دریاچه پشت سد کارون, 108 تصویر ماهواره‌ای ایران) —
  image-only pages, explicitly excluded from کل فصل ranges by migration
  162; the واژه‌نامه (126–127) — glossary, left without a row per batch-8
  precedent; «علم، زندگی، کارآفرینی» boxes, فعالیت / بیشتر بدانید boxes
  — inside their فصل/subtopic rows; front matter (گفتار پیش, the زمان
  timeline chart on PDF p.8) — not added.
- Combos covered: experimental_sciences grade 11 konkur + final_exam,
  mathematics grade 11 final_exam. No mathematics/konkur combo (the
  catalog lists زمین‌شناسی as an experimental_sciences konkur subject
  only; mathematics gets it via the school track).
- Verdict: **COMPLETE**. Every chapter has a paged کل فصل row and paged
  subtopic rows, منابع now has a row, no NULL pages remain.

## 5. تاریخ (۱) دهم انسانی — 110219

- File: `~/workspace/your_files/ketab-darsi/tarikh-10-110219-1405.pdf`
- SHA-256: `11e8cc7a0eebaf5169b5688231be02a270ab11aa2b06ef4218668111a52f651f` —
  matches the documented SHA (migrations 164/168). PDF pages: 168.
- Imprint (PDF p.2): code 110219, «تاریخ (۱) ایران و جهان باستان —
  پایۀ دهم», «سال انتشار و نوبت چاپ: 1405 چاپ یازدهم».
- Offset: printed = PDF − 10. Determined from footers: printed 1 = PDF
  11 (فصل اول), printed 2 = PDF 12 (درس ۱), printed 153 = PDF 163
  (منابع و مآخذ), printed 157 = PDF 167 (منابع, last page). PDF 168 is
  the unnumbered نظرسنجی letter. Max printed page 157.
- Structure (TOC, PDF p.5, cross-checked against the text): 3 فصول,
  16 lessons. Lesson starts: 2, 12, 20, 30, 42, 50, 62, **69**, 80, 90,
  99, 109, 118, 128, 136, 143; منابع و مآخذ 153. The TOC lists درس ۸ at
  70, but the text starts درس ۸ on printed **69** (درس ۷ ends 68) —
  verified in migration 164 and re-confirmed; seeds already carry درس ۷:
  62–68 and درس ۸: 69–79. فصل intro pages 1, 29, 61 each carry a
  substantive introductory paragraph (not bare titles).
- Prior seeds: 198 rows per track (humanities, grade 10, konkur +
  final_exam), all with pages, 0 NULL. The درس ۱۳/۱۴ کل درس rows
  (118–127, 128–135) were page-filled by migration 164 (revision 2).
  Subtopic coverage spot-checked across lessons (e.g. درس ۱۶:
  هنر مادها 143, معماری هخامنشیان 144–146, سنگ‌نگاره 146, فلزکاری
  146–147, بافندگی 147, معماری اشکانیان 147–148, پیکرسازی 148,
  معماری ساسانیان 150, سنگ‌نگاره ساسانیان 150–151, نقاشی 151,
  قلم‌زنی 151–152, موسیقی 152, بافندگی ساسانیان 152 — all present).
- What changed (pattern A, v239, position 3000):

  | Chapter | Position | Title | Printed pages |
  |---|---|---|---|
  | درس ۱ | 3000 ★ v239 | آغاز فصل اول: تاریخ‌شناسی؛ کاوش گذشته | 1–1 |
  | درس ۴ | 3000 ★ v239 | آغاز فصل دوم: جهان در عصر باستان؛ میراث بشری | 29–29 |
  | درس ۷ | 3000 ★ v239 | آغاز فصل سوم: ایران در عصر باستان؛ سرآغاز هویت ایرانی | 61–61 |
  | درس ۱۶ | 3000 ★ v239 | منابع و مآخذ | 153–157 |

  8 rows (4 topics × 2 tracks). Precedent: batches 3/4/5 file فصل
  opener pages (with introductory text) under each فصل's first lesson,
  and منابع under the last lesson.
- Page-fills (pattern B): none — 0 NULL-page rows.
- Not added, with reason: «بررسی شواهد و مدارک» boxes and numbered
  فعالیت boxes (e.g. pp.58, 65, 98, 152) fall inside subtopic rows, and
  the book's introduction states no exam question is set from بررسی
  شواهد و مدارک; the front-matter نمودار خط زمان (PDF pp.6–7) is a
  timeline chart, not a topic (batch-8 precedent); نظرسنجی letter
  (PDF 168) is not added.
- Combos covered: humanities, grade 10, konkur + final_exam.
- Verdict: **COMPLETE**. Every lesson has a paged کل درس row and paged
  subtopic rows, all three فصل openers and منابع و مآخذ now have rows, no
  NULL pages remain.

## Summary of the migration

- File: `supabase/migrations/239_planner_followup_outside79_a_1405.sql`
  (pattern A only, install marker `audit-followup5a-1405-v239`, id formula
  `md5('nova:planner:1405:v239:<field>:<grade>:<track>:<subject>:<chapter>:<position>')`).
- 9 new topics, 21 new rows: کارآفرینی 1 topic / 3 rows; دفاعی 1 / 3;
  علوم اجتماعی 2 / 4; زمین‌شناسی 1 / 3; تاریخ ۱ 4 / 8. All positions
  3000; collision check: position 3000 was free in every target
  (subject, chapter) in the full 128–238 seed dump.
- 0 guarded page-fills (pattern B): no eligible NULL-page row exists —
  the sole NULL row (دفاعی درس ۹, position 3) is revision 2 and already
  superseded (see §2).
- Post-migration per-combo counts: کارآفرینی 119 (×3 fields); دفاعی
  grade 10: 86 (×3 fields), grade 9 unchanged at 85; علوم اجتماعی 68
  (×2 fields); زمین‌شناسی 43 (×3 combos); تاریخ ۱ 202 (×2 tracks).
- No other file was edited. No commit / push / PR. No PDF was put in git.

## Test

- File: `tests/followup-outside79-a-1405.test.cjs`
- Run: `node tests/followup-outside79-a-1405.test.cjs` from the repo root
  (PGlite, already installed in the clone's `node_modules`).
- Result: **PASS, exit 0**. The test applies migrations 128–238 (111
  files), asserts the pre-migration counts and the exact three NULL-page
  rows, applies 239, asserts all 16 JSON topics land with exact pages and
  revision 1 in the right tracks only (21 rows), asserts post-migration
  counts, asserts the bank delta is exactly the 21 new rows (nothing else
  changed, the three NULL rows untouched), asserts re-running 239 is a
  no-op, asserts a simulated admin edit (via `planner_save_topic` on the
  تاریخ ۱ درس ۴ row) survives a re-run, asserts a simulated admin delete
  (علوم اجتماعی درس ۱۰ row) is NOT resurrected, and asserts the simulated
  published snapshot is unchanged.

## Uncertainties / open decisions

1. **Brief correction (هویت اجتماعی: انسانی)** — see the top of this file.
   The brief's combo is unsupported by the catalog and the bank; the
   coordinator should fix the brief, not the data.
2. **منابع precedent is split**: batches 4/5/7 add منابع rows; batch 8
   leaves منابع out. This item follows the majority (4/5/7) practice. If
   the coordinator standardises the other way, the 13 منابع rows added
   here (3 + 3 + 2 + 3 + 2 across the five books) would need revisiting —
   but they are ordinary pattern-A rows, removable without touching any
   other data.
3. **دفاعی درس ۹ wart**: the NULL position-3 row and its verified
   position-301 replacement coexist (migration 161's design). Merging or
   deleting the old row is an admin/user decision, not taken here.
4. Text-layer traps recorded so they are not re-"fixed": PyMuPDF swaps
   ل/ا in the «لا» ligature (e.g. «انقلاب»→«انقالب», «اسلامی»→«اسالمی»);
   the زمین‌شناسی imprint year extracts as «1504» but renders as ۱۴۰۵
   (verified visually).
