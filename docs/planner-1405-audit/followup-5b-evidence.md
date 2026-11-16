# Follow-up 5B evidence — outside-79 books, part B (migration 240)

Scope: audit of 4 books outside the 79-file audit, each against its real 1405 PDF
text and printed page numbers, same standard as the 79-file audit. Work in
`~/workspace/nova/repo`, branch `arena/9639a778-nova`. No commit/push/PR; `main`
untouched; no user PDF put in git.

Files written (only these three):

- `supabase/migrations/240_planner_followup_outside79_b_1405.sql` (85 topic
  entries, 90 rows; insert only, install marker `audit-followup5b-1405-v240`)
- `tests/followup-outside79-b-1405.test.cjs` (PGlite)
- `docs/planner-1405-audit/followup-5b-evidence.md` (this file)

Test result: **PASS**, exit 0 — `node tests/followup-outside79-b-1405.test.cjs`
from the repo root (PGlite from the clone's `node_modules`). The test applies
migrations 128–239, asserts the pre-migration per-combo counts, asserts zero
NULL-page rows for these books, applies migration 240, asserts all 85 topics
land with exact pages/revision 1 in the right tracks, asserts post-migration
counts, asserts the bank delta is exactly the 90 new rows, asserts re-run is a
no-op, asserts a simulated admin edit (via `planner_save_topic`) survives a
re-run, asserts a simulated admin delete is NOT resurrected, asserts the
humanities دین و زندگی books are untouched, asserts no rows for unsupported
combos, and asserts the simulated published snapshot is unchanged.

Prior-seed verification method (all four books): the bank state was dumped from
PGlite after applying migrations 128–239 (635 prior rows for these books'
combos: 251 + 250 + 82 + 52 per combo). Every prior row was checked against the
PDF text: lesson starts against the printed contents, and every named row's
content words against its seeded page range. 31 rows were flagged by the
automated word check; every flag was inspected in the raw text and resolved as
a text-layer rendering variant (e.g. «تاریخ نگاری» vs «تاریخ‌نگاری», «اخلاص»
vs «اخلاص», «شکوفایی» vs «شکوفایى», Arabic-Indic vs Latin digits, reversed
line order in the text layer for «اسلام‌پذیری مغولان»). **No wrong title and
no wrong page range was found in any prior row.** There are **zero NULL-page
rows** in these four books' combos, so no guarded page-fill (pattern B)
applies anywhere in this migration. No position ≥ 3000 was in prior use for
these subjects, so the new positions 3000–3003 cannot collide.

## 1. تاریخ (۲) یازدهم انسانی — `tarikh-11-111219-1405-small.pdf`

- SHA-256: `c7b20d0c3207e115a8cd5658385c9102c46624d95a80d19ddd17cf67546f498c` —
  matches `docs/planner-topic-sources.md` ✓
- PDF pages: 216. Book code: **111219**. چاپ: **دهم ۱۴۰۵** (imprint, PDF p2;
  the text layer renders the year as «1504» but the page image reads
  «چاپ دهم ۱۴۰۵» — verified visually, same rendering quirk as the geology
  book in follow-up 5A).
- Offset: **printed = PDF − 10**, from printed footers on PDF pp.11 (→1),
  21 (→11), 51 (→41), 101 (→91), 212 (→202), 215 (→205). Printed pages 1–206.
- Combos: `humanities` / grade 11 / `konkur` + `final_exam` (konkur catalog
  lists «تاریخ ۲» with 16 درس; school track is the same book).
- Structure (printed contents): فصل اول: تاریخ‌شناسی (درس ۱–۲), فصل دوم:
  ظهور اسلام، حرکتی تازه در تاریخ بشر (درس ۳–۷), فصل سوم: ایران؛ از ورود
  اسلام تا پایان صفویه (درس ۸–۱۴), فصل چهارم: اروپا در قرون وسطا و عصر جدید
  (درس ۱۵–۱۶). Lesson starts (printed): 2, 13, 20, 31, 44, 56, 69, 84, 95,
  109, 124, 135, 147, 162, 174, 188 — all match the seeded کل درس starts.
- Prior seeds: 251 rows per track (16 کل درس + group rows + 301+ subtopics
  per lesson; chapters «درس ۱»–«درس ۱۶»). All verified as above; 0 NULL-page
  rows; no row for any unsupported combo.
- What changed (5 topics, 10 rows — both tracks):

| chapter | position | title | printed pages |
|---|---|---|---|
| درس ۱ | 3000 | آغاز فصل اول: تاریخ‌شناسی | 1–1 |
| درس ۳ | 3000 | آغاز فصل دوم: ظهور اسلام، حرکتی تازه در تاریخ بشر | 19–19 |
| درس ۸ | 3000 | آغاز فصل سوم: ایران؛ از ورود اسلام تا پایان صفویه | 83–83 |
| درس ۱۵ | 3000 | آغاز فصل چهارم: اروپا در قرون وسطا و عصر جدید | 173–173 |
| درس ۱۶ | 3000 | منابع و مآخذ | 202–205 |

  The four فصل opener pages each carry substantive introductory text (e.g.
  p19: the spread of Islam; p83: political/social/cultural change from the
  Arab arrival to the Safavids; p173: the ~1000-year period of European
  history). Filed under each فصل's first lesson, following the follow-up 5A
  precedent for تاریخ ۱. «منابع و مآخذ» (202–205, Persian/Arabic then
  English sources) is the book's end matter, filed under درس ۱۶.
- Deliberately NOT added: p206 is the teacher validation list (اعتبارسنجی),
  not study content. The per-lesson «بررسی شواهد و مدارک» activity boxes and
  «بیشتر بدانیم» boxes stay grouped under کل درس, as in the prior seeds and
  the 79-file batches; بیشتر بدانیم boxes are supplementary.
- Uncertainties: none material. The TOC's فصل/chapter page numbers were
  cross-checked against the running text (e.g. درس ۸ starts on printed p84,
  the page after the فصل سوم opener p83).
- Verdict: **COMPLETE**. Every lesson and planning-usable subtopic has a
  paged row; all correct combos have rows; no prior row was wrong or pageless.

## 2. تاریخ معاصر ایران یازدهم — `tarikh-moaser-11-111220-1405.pdf`

- SHA-256: `e8fbd9b450697bf6fd0861ee11beed921a3b564c6b6ceed2823dbced8ff4cba0` —
  matches `docs/planner-topic-sources.md` ✓
- PDF pages: 272. Book code: **111220**. چاپ: **دهم ۱۴۰۵** (imprint, PDF p3;
  text layer garbles the year, page image reads «چاپ دهم ۱۴۰۵» — verified
  visually).
- Offset: **printed = PDF − 9**, from printed footers on PDF pp.11 (→2),
  21 (→12), 51 (→42), 101 (→92), 268 (→259), 271 (→262). Printed pages 1–263.
- Combos: `mathematics` + `experimental_sciences` / grade 11 / `final_exam`
  only. The book is NOT in the konkur catalog; `lib/school-catalog.ts`
  `commonExtras` offers «تاریخ معاصر ایران» to non-humanities grade 11 only
  (humanities students take تاریخ ۲ instead). No konkur rows exist or were added.
- Structure (printed contents): a «مرور» review section (pp.1–16) then 26
  lessons. Lesson starts (printed): 17, 27, 37, 43, 52, 61, 73, 82, 90, 99,
  106, 113, 119, 129, 135, 142, 146, 152, 162, 173, 181, 190, 199, 210, 223,
  238 — all match the seeded کل درس starts. The last lesson ends on printed
  p263 («پرسش‌های نمونه» + «جست‌وجو و اندیشه»); there is no منابع section
  after it.
- Prior seeds: 250 rows per field (26 کل درس + group rows + 301+ subtopics
  per lesson; chapters «درس ۱»–«درس ۲۶»). All verified as above; 0 NULL-page
  rows; no row for any unsupported combo.
- What changed (4 topics, 8 rows — both fields, final_exam only). The مرور
  section is marked «برای مطالعه» in the contents and migration 166
  deliberately did NOT file it as درس ۱. It is added here as its own chapter
  «مرور», in the book's own four sections. The introduction («سخنی با
  دبیران») excludes only «بیشتر بدانید» / «برگی از تاریخ» boxes and
  footnotes from midterm/final exams — not the مرور:

| chapter | position | title | printed pages |
|---|---|---|---|
| مرور | 3000 | ایران پیش از اسلام | 1–7 |
| مرور | 3001 | ایران بعد از اسلام | 8–9 |
| مرور | 3002 | ایران از دوران غزنویان تا خوارزمشاهیان و هجوم مغول | 10–12 |
| مرور | 3003 | ایران در عصر صفویه | 13–16 |

- Deliberately NOT added: «بیشتر بدانید» and «برگی از تاریخ» boxes
  (exam-excluded by the introduction, e.g. the بنی‌صدر box on p200); the
  per-lesson «جست‌وجو و اندیشه» / «پرسش‌های نمونه» question sets and the
  numbered «فعالیت» boxes inside درس ۲۶ stay grouped under کل درس, as in
  the prior seeds.
- Uncertainties: the «غزنویان تا خوارزمشاهیان» and «هجوم مغول» headings
  both fall on printed p10; their intra-page boundary was not pinned down,
  so they share one row (10–12) whose title carries both. If the
  coordinator wants them split, the split point is mid-page 10.
- Verdict: **COMPLETE**. Every lesson, the مرور review section, and every
  planning-usable subtopic has a paged row; all correct combos have rows.

## 3. دین و زندگی (۲) یازدهم، ریاضی/تجربی — `dini-11-111204-1405.pdf`

- SHA-256 of the file used:
  `77d162328373f92f31fc3cb335685d075372259debd4a52bbca8d7c9ffa36641`.
  This does **not** equal the SHA documented in
  `docs/planner-topic-sources.md`
  (`f12d5d311b0d2d87061d7db9b179d06699e1826a651c2aa9d0b981e33956d051`) — but
  that documented SHA is the SHA of the compressed copy
  `dini-11-111204-1405-small.pdf` in the same directory (verified: the small
  file's SHA is exactly the documented value). Page-by-page text comparison
  of the two files shows only compression/encoding artifacts (spacing,
  diacritic placement, dot counts in filler lines); the content is identical,
  both have 160 pages, the same imprint, and the same lesson starts
  (12, 22, 36, 48, 62, 74, 88, 98, 110, 124, 138, 148). The file used is
  therefore the same 1405 edition, and it is fingerprinted here by its own SHA.
- PDF pages: 160. Book code: **111204**. چاپ: **دهم 1405** (imprint, PDF p2:
  «سال انتشار و نوبت چاپ: 1405 چاپ دهم»).
- Offset: **printed = PDF page** (footers on PDF pp.11 → 11, 21 → 21,
  51 → 51, 101 → 101, 156 → 156). Printed pages 1–158 are lesson content;
  pp.159–160 are back matter (معرفی کتاب table; teacher validation list).
- Combos: `mathematics` + `experimental_sciences` / grade 11 / `final_exam`
  only. This is the ریاضی/تجربی book; the انسانی book 111205 is a separate
  book (295 humanities rows) and was NOT touched — the test asserts its
  counts are unchanged and it gains no position ≥ 3000 row.
- Structure: two بخشs — بخش اول «تفکر و اندیشه» (p9) with درس ۱–۱۰, بخش دوم
  «در مسیر» (p134) with درس ۱۱–۱۲. Every lesson opens with two
  قرائت/ترجمه pages, then the lesson title page, then content, then (in 7
  of 12 lessons) an «اندیشه و تحقیق» question box. Blank separator pages
  sit between lessons (pp.19, 59, 71, 85, 107, 135, 145).
- Prior seeds: 82 rows per field (12 کل درس + named subtopics at positions
  1–4 + groupings at 201–204; chapters «درس ۱: هدایت الهی» … «درس ۱۲: پیوند
  مقدس»). All verified as above; 0 NULL-page rows. Lesson starts match the
  printed contents exactly.
- What changed (19 topics, 38 rows — both fields, final_exam only).
  «سخنی با دبیران» grades قرائت صحیح آیات 4 marks and پاسخ به سؤال‌های
  بخش اندیشه و تحقیق 3 marks (continuous assessment); in-lesson activities
  (تدبّر در قرآن, فعالیت کلاسی, …) are grouped as «فعالیت‌های داخل درس»
  (8 marks). The new rows mirror the humanities siblings' rows from
  migrations 212/213 (same titles, same per-lesson positions):

  «آیات و ترجمه آغاز درس» (position 3000 per chapter):

| chapter | pages |
|---|---|
| درس ۱: هدایت الهی | 10–11 |
| درس ۲: تداوم هدایت | 20–21 |
| درس ۳: معجزه جاویدان | 34–35 |
| درس ۴: مسئولیت‌های پیامبر | 46–47 |
| درس ۵: امامت، تداوم رسالت | 60–61 |
| درس ۶: پیشوایان اسوه | 72–73 |
| درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر | 86–87 |
| درس ۸: احیای ارزش‌های راستین | 96–97 |
| درس ۹: عصر غیبت | 108–109 |
| درس ۱۰: مرجعیت و ولایت فقیه | 122–123 |
| درس ۱۱: عزت نفس | 136–137 |
| درس ۱۲: پیوند مقدس | 146–147 |

  «اندیشه و تحقیق» (position 3001 per chapter; only the 7 lessons that
  have the box — verified by full-text search that درس ۵، ۶، ۸، ۱۱، ۱۲ have
  no «اندیشه و تحقیق» box):

| chapter | pages |
|---|---|
| درس ۱: هدایت الهی | 18–18 |
| درس ۲: تداوم هدایت | 32–32 |
| درس ۳: معجزه جاویدان | 43–43 |
| درس ۴: مسئولیت‌های پیامبر | 58–58 |
| درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر | 94–94 |
| درس ۹: عصر غیبت | 120–120 |
| درس ۱۰: مرجعیت و ولایت فقیه | 133–133 |

- Deliberately NOT added / NOT changed:
  - The کل درس ranges follow migration 155's documented convention (title
    page → page before the next lesson's title), so 11 of 12 include the
    next lesson's two قرائت pages (e.g. درس ۱ is 12–21, including درس ۲'s
    قرائت on 20–21). Migration 161 fixed only درس ۱۰ (124–133) because the
    بخش دوم boundary intervenes there. The new آیات rows overlap the
    previous lesson's کل درس range by design — exactly as in the humanities
    books, where the آیات rows sit inside the کل درس ranges. No کل درس
    range is rewritten here: pattern B covers NULL-page fills only, and
    there are none. Recorded as a known wart for the coordinator (see Open
    decisions).
  - In-lesson activities (تدبّر در قرآن, فعالیت کلاسی, تفکر در حدیث,
    دانش تکمیلی, بیشتر بدانیم, پیشنهاد boxes) stay grouped under کل درس,
    per the book's own assessment scheme; بیشتر بدانیم boxes are explicitly
    not examined («این قسمت صرفاً جهت توسعه اطلاعات دانش‌آموز بوده و در
    امتحانات پایانی … سؤالی از آن طرح نمی‌شود», p17). The «پیشنهاد» boxes
    are bonus activities (up to +2 on the continuous-assessment mean).
  - بخش openers (بخش اول p9, بخش دوم «در مسیر» p134) and the معرفی کتاب
    table (p159) are not rows, following the batch-2 precedent for the
    humanities دین و زندگی books (their بخش دوم title page and end-of-بخش
    book table are likewise uncovered, verdict COMPLETE).
  - The single-page «مطالعهٔ صفحه» rows that migrations 212/213 seeded for
    the humanities دین و زندگی books were NOT replicated for the
    ریاضی/تجربی versions (see Open decisions).
- Uncertainties: the dini-11 file used is the uncompressed copy (SHA differs
  from the documented compressed copy; content equivalence verified as
  above). درس ۵ ends with «تفکر در حدیث» (p69) + «نتیجه‌گیری» (p70) rather
  than «اندیشه و تحقیق»; درس ۶/۸/۱۱/۱۲ end with content + بیشتر بدانیم and
  have no graded end-activity box — that is the book's structure, not a gap
  in the audit.
- Verdict: **COMPLETE** on the named-topic standard applied to the other
  books in this audit (کل درس + named subtopics + the graded آیات and
  end-activity boxes). Every lesson has paged rows; all correct combos have
  rows; no prior row was wrong or pageless. The two recorded warts (کل درس
  / قرائت overlap; no single-page rows, unlike the humanities siblings) do
  not leave any lesson or graded component without a row.

## 4. دین و زندگی (۳) دوازدهم، ریاضی/تجربی — `dini-12-112204-1405-small.pdf`

- SHA-256: `48651de98db89bf0d5d982f450d7edceec9f2e359ea32d45762a8b52afc2f5d2` —
  matches `docs/planner-topic-sources.md` ✓ (compressed verified copy; the
  uncompressed `dini-12-112204-1405.pdf` has a different SHA,
  `b2dced5aa6cb5e83a976f15e7c8f29f57540655c6954b3e65f61e2ca8294f6f2`, and
  page-by-page text comparison shows only compression artifacts).
- PDF pages: 144. Book code: **112204**. چاپ: **نهم 1405** (imprint, PDF p2:
  «سال انتشار و نوبت چاپ: 1405 چاپ نهم»).
- Offset: **printed = PDF − 6**, from printed footers on PDF pp.11 (→5),
  51 (→45), 101 (→95), 140 (→134), 143 (→137). Printed pages 1–138; p137
  is the معرفی کتاب table and p138 (PDF p144) the teacher validation list.
- Combos: `mathematics` + `experimental_sciences` / grade 12 / `final_exam`
  only. This is the ریاضی/تجربی book; the انسانی book 112205 is a separate
  book (225 humanities rows) and was NOT touched (test asserts unchanged).
- Structure: بخش اول «تفکّر و اندیشه» (printed p2) with درس ۱–۶, بخش دوم
  «در مسیر» (p76) with درس ۷–۱۰. Every lesson opens with two قرائت/ترجمه
  pages, then the title page; blank separator pages sit between lessons
  (printed pp.3, 15, 27, 39, 49, 61, 77, 91, 105, 123). Lesson starts
  (printed): 6, 18, 30, 42, 52, 64, 80, 94, 108, 126 — all match the seeded
  کل درس starts. Unlike دین و زندگی ۲, the کل درس ranges here are clean:
  each ends before the blank separator and the next lesson's قرائت pages.
- Prior seeds: 52 rows per field (10 کل درس + named subtopics at positions
  1–6; chapters «درس ۱»–«درس ۱۰»). All verified as above; 0 NULL-page rows.
- What changed (17 topics, 34 rows — both fields, final_exam only).
  Same grading basis and humanities-mirroring titles as book 3:

  «آیات و ترجمه آغاز درس» (position 3000 per chapter):

| chapter | pages |
|---|---|
| درس ۱ | 4–5 |
| درس ۲ | 16–17 |
| درس ۳ | 28–29 |
| درس ۴ | 40–41 |
| درس ۵ | 50–51 |
| درس ۶ | 62–63 |
| درس ۷ | 78–79 |
| درس ۸ | 92–93 |
| درس ۹ | 106–107 |
| درس ۱۰ | 124–125 |

  Lesson-end graded activity boxes (positions 3001–3003):

| chapter | position | title | printed pages |
|---|---|---|---|
| درس ۱ | 3001 | اندیشه و تحقیق | 14–14 |
| درس ۲ | 3001 | اندیشه و تحقیق | 26–26 |
| درس ۳ | 3001 | اندیشه و تحقیق | 38–38 |
| درس ۳ | 3002 | تحلیل و بررسی | 37–37 |
| درس ۹ | 3001 | برداشت (۱) | 117–120 |
| درس ۹ | 3002 | برداشت (۲) | 121–121 |
| درس ۹ | 3003 | هم‌اندیشی | 122–122 |

  «برداشت (۱)» is the report on Islamic civilisation's hygiene/science
  (pp.117–120); «برداشت (۲)» (p121) introduces the report on the decline
  of Islamic civilisation, which continues onto p122 under the «هم‌اندیشی»
  heading with the discussion questions at the foot of p122 — the split is
  heading-based. «مراحل تکمیلی توبه» (درس ۷, pp.86–87) is already a seeded
  row (position 4), so it was not re-added.
- Deliberately NOT added: in-lesson activities (تدبّر در قرآن, فعالیت
  کلاسی, تفکر در حدیث, بررسی boxes mid-lesson, دانش تکمیلی, بیشتر بدانیم,
  پیشنهاد poem box on p90) stay grouped under کل درس, per the book's own
  assessment scheme (see book 3). بخش openers (p2, p76), the end-of-بخش
  معرفی کتاب table (p75), the final معرفی کتاب table (p137), and blank
  separators are not rows, following the batch-2 precedent. درس ۴، ۵، ۶، ۷،
  ۸، ۱۰ have no «اندیشه و تحقیق» box — verified by full-text search; their
  lessons end with content / بیشتر بدانیم / the seeded «مراحل تکمیلی توبه»
  section, which is the book's structure, not an audit gap.
- Uncertainties: the برداشت (۲) / هم‌اندیشی split is heading-based (see
  above); the report text flows across the p121→p122 boundary. No other
  material uncertainty.
- Verdict: **COMPLETE** on the same named-topic standard as book 3. Every
  lesson has paged rows; all correct combos have rows; no prior row was
  wrong or pageless.

## Cross-book notes

- Combos covered (all and only the catalog-supported ones): تاریخ ۲ —
  humanities / 11 / konkur + final_exam; تاریخ معاصر ایران — mathematics +
  experimental_sciences / 11 / final_exam; تعلیمات دینی ۲ — mathematics +
  experimental_sciences / 11 / final_exam; تعلیمات دینی ۳ — mathematics +
  experimental_sciences / 12 / final_exam. No rows were created for
  humanities تاریخ معاصر, konkur تاریخ معاصر / دین و زندگی, or the انسانی
  دین و زندگی books; the test asserts all of these absences.
- Pattern B: not applicable — zero NULL-page rows across all four books'
  combos (asserted in the test).
- New positions 3000–3003 were verified free of collisions (no prior row at
  position ≥ 3000 for these subjects); new ids use the `v240` tag.
- The existing full-chain test (`tests/planner-audit-full-chain-1405.test.cjs`)
  was NOT edited and is unaffected: it applies only migrations 128–238.

## Open decisions for the user / coordinator

1. **دین و زندگی ۲ کل درس ranges include the next lesson's قرائت pages**
   (11 of 12 lessons; درس ۱۰ was already fixed to 124–133 by migration
   161). Fixing them would mean rewriting 22 rows to the humanities
   convention (قرائت-to-last-content-page, e.g. درس ۱ would become 10–18)
   with a guarded update matching the old pages — outside the pattern-B
   scope of this item, and it would change ranges existing plans may rely
   on. Left untouched and recorded here; say the word if they should be
   normalised.
2. **Single-page «مطالعهٔ صفحه» rows for ریاضی/تجربی دین و زندگی**: the
   humanities books have them (migrations 212/213); the ریاضی/تجربی books
   do not, and this audit did not add ~250 of them. If the coordinator wants
   the same page-study granularity for the ریاضی/تجربی versions, that is a
   separate seeding task, not a follow-up diff.
3. **تاریخ معاصر مرور**: added as its own chapter «مرور» (4 rows). If the
   coordinator prefers the مرور to stay unbanked (migration 166's original
   choice), deleting those 8 rows is a one-line revert of the مرور topics;
   the rest of the migration is unaffected.
