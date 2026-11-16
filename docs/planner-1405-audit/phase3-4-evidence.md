# Phase 3 item 4 — دین و زندگی ranges + «مطالعهٔ صفحه» rows (migration 247)

## What this item did

Migration 155's convention let the دین و زندگی ۲ (ریاضی/تجربی) whole-lesson
rows «کل درس» run from the lesson title page to the page before the NEXT
lesson's title page, so 11 of 12 ranges include the next lesson's two
قرائت/ترجمه pages. Migration 161 fixed only درس ۱۰ (124–137 → 124–133) and
filled درس ۱۲ from NULL (148–158). This migration corrects all 12 lessons to
the convention the humanities books already use (the lesson's own two قرائت
pages → its last content page), and adds the single-page «مطالعهٔ صفحه» rows
for the ریاضی/تجربی دین و زندگی ۲/۳ books, which the humanities books
(212/213) and دین و زندگی ۱ ریاضی/تجربی (209) already have.

Files written (only these):

- `supabase/migrations/247_planner_phase3_dini_ranges_1405.sql`
- `tests/phase3-dini-ranges-1405.test.cjs`
- `docs/planner-1405-audit/phase3-4-evidence.md` (this file)

No other file was touched. No second migration was needed (248 not used).

## 1. Which books/lessons carry the 155 convention

Grepped migrations 155, 161, 153, 163, 209, 212, 213, 232 and 240 and parsed
every دین و زندگی seed row, then checked each range against its چاپ ۱۴۰۵ PDF:

| book | کل درس convention | carries the 155 convention? |
|---|---|---|
| دین و زندگی ۲, ریاضی/تجربی (111204) | title → page before next title (155) | **YES — 11 of 12 lessons** (درس ۱۰ already fixed by 161) |
| دین و زندگی ۳, ریاضی/تجربی (112204) | title → last content page (163: "Lesson ranges stop before the following lesson's recitation") | NO — ends verified correct against the PDF |
| دین و زندگی ۲, انسانی (111205) | own قرائت → last content page (213) | NO — verified programmatically: no کل درس end reaches the next lesson's آیات start |
| دین و زندگی ۳, انسانی (112205) | own قرائت → last content page (212) | NO — same check |
| دین و زندگی ۱, ریاضی/تجربی (110204) | title → last content page (209); the grade-10 book has no قرائت pages | NO (not in this item's book list; checked only to confirm the convention's scope) |

No subtopic row in any book crosses a lesson boundary: all 71 migration-161
دین و زندگی ۲ subtopic rows and all migration-163 دین و زندگی ۳ subtopic rows
sit inside their (corrected) lesson ranges. Only the 12 دین و زندگی ۲
«کل درس» rows were wrong.

## 2. دین و زندگی (۲) یازدهم، ریاضی/تجربی — `dini-11-111204-1405.pdf`

- SHA-256 of the file used:
  `77d162328373f92f31fc3cb335685d075372259debd4a52bbca8d7c9ffa36641`.
  This is the uncompressed copy; the documented SHA
  (`f12d5d311b0d2d87061d7db9b179d06699e1826a651c2aa9d0b981e33956d051`) is
  the compressed copy's SHA. Content equivalence of the two files was
  established by the follow-up-5B audit (same 160 pages, same imprint, same
  lesson starts); this item re-verified the imprint and every lesson
  boundary in the file used here.
- PDF pages: 160. Book code: **111204**. چاپ: **دهم 1405** (imprint, PDF p2:
  «سال انتشار و نوبت چاپ: 1405 چاپ دهم»). Stream: ریاضی و علوم تجربی
  (cover, PDF p1).
- Offset: **printed = PDF page** (footers on PDF pp.11 → 11, 21 → 21,
  51 → 51, 101 → 101, 156 → 156). Printed pages 1–158 are lesson content;
  pp.159–160 are back matter (معرفی کتاب table; teacher validation list).
- Combos: `mathematics` + `experimental_sciences` / grade 11 / `final_exam`
  only. The انسانی book 111205 is a separate book and was NOT touched.
- Structure: بخش اول «تفکر و اندیشه» (p9), درس ۱–۱۰; بخش دوم «در مسیر»
  (p134), درس ۱۱–۱۲. Every lesson opens with two قرائت/ترجمه pages, then
  the title page, then content. Blank separator pages sit between lessons
  (pp.19, 33, 45, 59, 71, 85, 95, 107, 121, 135, 145 — verified blank from
  the text layer, 2–3 chars = footer only).

### Lesson-by-lesson verdicts (کل درس, position 101, both fields)

«Last content» is the last page carrying lesson content (main text, تدبّر در
قرآن, فعالیت کلاسی, تفکر در حدیث, دانش تکمیلی, بیشتر بدانیم, پیشنهاد,
اندیشه و تحقیق). The page after it is blank, except درس ۱۰ (p134 is the
بخش دوم title page) and درس ۱۲ (p159 is back matter).

| lesson | old range | new range | why |
|---|---|---|---|
| درس ۱: هدایت الهی | 12–21 | **10–18** | 20–21 are درس ۲'s قرائت (آل عمران 81–84); last content is اندیشه و تحقیق, p18; p19 blank |
| درس ۲: تداوم هدایت | 22–35 | **20–32** | 34–35 are درس ۳'s قرائت (یونس 55–61); last content p32 (اندیشه و تحقیق questions + دانش تکمیلی); p33 blank |
| درس ۳: معجزه جاویدان | 36–47 | **34–44** | 46–47 are درس ۴'s قرائت; last content is the پیشنهاد box on p44 (p43 holds تدبّر در قرآن + اندیشه و تحقیق); p45 blank |
| درس ۴: مسئولیت‌های پیامبر | 48–61 | **46–58** | 60–61 are درس ۵'s قرائت (مائده 51); last content is اندیشه و تحقیق, p58; p59 blank |
| درس ۵: امامت، تداوم رسالت | 62–73 | **60–70** | 72–73 are درس ۶'s قرائت (آل عمران 159); last content is نتیجه‌گیری, p70 (ends with تفکر در حدیث p69 + نتیجه‌گیری p70); p71 blank |
| درس ۶: پیشوایان اسوه | 74–87 | **72–84** | 86–87 are درس ۷'s قرائت (مائده 20); last content is بیشتر بدانیم, p84 (جرج جرداق); p85 blank |
| درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر | 88–97 | **86–94** | 96–97 are درس ۸'s قرائت (انبیاء 73); last content is اندیشه و تحقیق, p94; p95 blank |
| درس ۸: احیای ارزش‌های راستین | 98–109 | **96–106** | 108–109 are درس ۹'s قرائت (هود 84); last content is بیشتر بدانیم, p106; p107 blank |
| درس ۹: عصر غیبت | 110–123 | **108–120** | 122–123 are درس ۱۰'s قرائت (توبه 119); last content is اندیشه و تحقیق, p120; p121 blank |
| درس ۱۰: مرجعیت و ولایت فقیه | 124–133 | **122–133** | end already correct (fixed by 161); start only: 122–123 are this lesson's own قرائت (توبه 119); last content p133 (بیشتر بدانیم + اندیشه و تحقیق); p134 is the بخش دوم title page |
| درس ۱۱: عزت نفس | 138–147 | **136–144** | 146–147 are درس ۱۲'s قرائت (بقره 218); last content is بیشتر بدانیم, p144; p145 blank |
| درس ۱۲: پیوند مقدس | 148–158 | **146–158** | end already correct (filled by 161, verified: pp.156–158 are the lesson's closing content); start only: 146–147 are this lesson's own قرائت (بقره 218–219); pp.159–160 are back matter |

24 rows corrected (12 lessons × 2 fields), same ids. Guards match the exact
post-155/post-161 state: original v155 id formula, title «کل درس»,
position 101, the old pages above, revision 1 (lessons 1–9, 11) or revision 2
(درس ۱۰, درس ۱۲ — bumped by migration 161). A row edited or deleted by an
admin does not match and is left alone (proven in the test's second database).

Count note: the follow-up-5B open decision counted "22 rows" (the 11
end-wrong lessons × 2 fields). This migration corrects 24: the same 11
lessons plus the start-only normalisation of درس ۱۰ and درس ۱۲, so that
«کل درس» means the same thing in every lesson of the book (قرائت → last
content page). If the coordinator prefers درس ۱۰/۱۲ to keep title-page
starts, that is a 4-row revert (2 lessons × 2 fields).

### «مطالعهٔ صفحه» rows added (226 rows)

One row per page from each lesson's title page to its last content page —
the same coverage the humanities books have (212/213: مطالعه = [title,
کل درس end], position 500+page). Every candidate page was verified to carry
real study text (shortest: p44, the پیشنهاد box, 98 chars; next shortest:
p18, 476 chars).

| lesson | pages | rows/field |
|---|---|---|
| درس ۱: هدایت الهی | 12–18 | 7 |
| درس ۲: تداوم هدایت | 22–32 | 11 |
| درس ۳: معجزه جاویدان | 36–44 | 9 |
| درس ۴: مسئولیت‌های پیامبر | 48–58 | 11 |
| درس ۵: امامت، تداوم رسالت | 62–70 | 9 |
| درس ۶: پیشوایان اسوه | 74–84 | 11 |
| درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر | 88–94 | 7 |
| درس ۸: احیای ارزش‌های راستین | 98–106 | 9 |
| درس ۹: عصر غیبت | 110–120 | 11 |
| درس ۱۰: مرجعیت و ولایت فقیه | 124–133 | 10 |
| درس ۱۱: عزت نفس | 138–144 | 7 |
| درس ۱۲: پیوند مقدس | 148–158 | 11 |
| **total per field** | | **113** |

Positions are 3100+page (≥ 3000 per the batch spec; verified free — no prior
row for these subjects uses a position ≥ 3100). Titles use Persian digits,
exactly as in 212/213 («مطالعه صفحه ۱۲»). Ids use the `v247` tag.
Install-marker-gated (`planner-phase3-dini-ranges-1405-v247`).

## 3. دین و زندگی (۳) دوازدهم، ریاضی/تجربی — `dini-12-112204-1405-small.pdf`

- SHA-256: `48651de98db89bf0d5d982f450d7edceec9f2e359ea32d45762a8b52afc2f5d2` —
  matches `docs/planner-topic-sources.md` ✓ (compressed verified copy).
- PDF pages: 144. Book code: **112204**. چاپ: **نهم 1405** (imprint, PDF p2:
  «سال انتشار و نوبت چاپ: 1405 چاپ نهم»). Stream: ریاضی و تجربی (cover).
- Offset: **printed = PDF − 6** (footers on PDF pp.11 → 5, 51 → 45,
  101 → 95, 140 → 134, 143 → 137). Printed pages 1–138; p137 is the
  معرفی کتاب table and p138 (PDF p144) the teacher validation list.
- Combos: `mathematics` + `experimental_sciences` / grade 12 / `final_exam`
  only. The انسانی book 112205 is a separate book and was NOT touched.
- Structure: بخش اول «تفکّر و اندیشه» (printed p2), درس ۱–۶; بخش دوم
  «در مسیر» (printed p76), درس ۷–۱۰. Blank separators at printed pp.3, 15,
  27, 39, 49, 61, 77, 91, 105, 123 (verified blank). Printed p75 is the
  end-of-بخش معرفی کتاب table; p76 the بخش دوم opener.

### Lesson-by-lesson verdicts (کل درس, position 1, both fields) — NO changes

Migration 163's ends were re-verified against the PDF and are all correct:
each ends on its last content page, before the blank separator and the next
lesson's قرائت pages.

| lesson | کل درس range | verification |
|---|---|---|
| درس ۱ | 6–14 (unchanged) | last content اندیشه و تحقیق p14; p15 blank; قرائت درس ۲ pp.16–17 |
| درس ۲ | 18–26 (unchanged) | last content اندیشه و تحقیق + دانش تکمیلی p26; p27 blank; قرائت درس ۳ pp.28–29 |
| درس ۳ | 30–38 (unchanged) | last content اندیشه و تحقیق p38; p39 blank; قرائت درس ۴ pp.40–41 |
| درس ۴ | 42–48 (unchanged) | last content p48 (میوه‌های درخت اخلاص); p49 blank; قرائت درس ۵ pp.50–51 |
| درس ۵ | 52–60 (unchanged) | last content p60; p61 blank; قرائت درس ۶ pp.62–63 |
| درس ۶ | 64–74 (unchanged) | last content p74 (تأثیر اعمال انسان); p75 معرفی کتاب table, p76 بخش دوم opener, p77 blank; قرائت درس ۷ pp.78–79 |
| درس ۷ | 80–90 (unchanged) | last content p90; p91 blank; قرائت درس ۸ pp.92–93 |
| درس ۸ | 94–104 (unchanged) | last content p104; p105 blank; قرائت درس ۹ pp.106–107 |
| درس ۹ | 108–122 (unchanged) | last content هم‌اندیشی p122; p123 blank; قرائت درس ۱۰ pp.124–125 |
| درس ۱۰ | 126–136 (unchanged) | last content p136; p137 معرفی کتاب table, p138 validation list |

Deliberately NOT changed: the «کل درس» starts stay at the lesson title
page (migration 163's deliberate convention, e.g. درس ۱ is 6–14 while its
قرائت is 4–5). Changing them to the قرائت pages would be a further
normalisation — see Open decisions.

### «مطالعهٔ صفحه» rows added (204 rows)

Same coverage rule as book 2 ([title, last content]); every candidate page
verified to carry real study text (shortest: p38, اندیشه و تحقیق only,
105 chars).

| lesson | pages | rows/field |
|---|---|---|
| درس ۱ | 6–14 | 9 |
| درس ۲ | 18–26 | 9 |
| درس ۳ | 30–38 | 9 |
| درس ۴ | 42–48 | 7 |
| درس ۵ | 52–60 | 9 |
| درس ۶ | 64–74 | 11 |
| درس ۷ | 80–90 | 11 |
| درس ۸ | 94–104 | 11 |
| درس ۹ | 108–122 | 15 |
| درس ۱۰ | 126–136 | 11 |
| **total per field** | | **102** |

Positions 3100+page, Persian-digit titles, `v247` ids, same install marker
as book 2. No konkur rows (final_exam only).

## 4. دین و زندگی (۲) یازدهم، انسانی — `dini-2-ensani-11-111205-1405-small.pdf`

- SHA-256: `915c68aa8dfdd9566d12a6cad19408ee5bea338f599debfdcecd45373bb12026`.
- PDF pages: 240. Book code: **111205**. چاپ: **نهم 1405** (imprint, PDF p2:
  «سال انتشار و نوبت چاپ: 1405 چاپ نهم»). Stream: رشتۀ ادبیات و علوم
  انسانی (cover, PDF p1).
- Offset: **printed = PDF − 8** (footers: PDF p14 → 6, p22 → 14, p230 → 222,
  p240 → 232). Printed pages 1–232; lesson content ends p230; pp.231–232
  are back matter (validation lists).
- Combos: `humanities` / grade 11 / `final_exam` only — 295 rows, unchanged.
- Verdict: **no changes**. All 18 lessons' «کل درس» ranges (migration 213)
  are already قرائت → last content page, with the page after each end blank
  (the only non-blank followers are the بخش دوم opener after درس ۱۵, printed
  p192, and back matter after درس ۱۸). The «مطالعهٔ صفحه» rows already exist
  and cover exactly [title, کل درس end] per lesson (verified
  programmatically against the PDF: every مطالعه page carries content,
  minimum 194 chars). No row was added, moved or corrected for this book.

## 5. دین و زندگی (۳) دوازدهم، انسانی — `dini-12-112205-1405.pdf`

- SHA-256: `bd658da06551b92f530a4e92963ee10b69c1a0d8b98174f0c6347cadca1b0a08`.
- PDF pages: 176. Book code: **112205**. چاپ: **نهم 1405** (imprint, PDF p2:
  «سال انتشار و نوبت چاپ: 1405 چاپ نهم»). Stream: رشتۀ ادبیات و علوم
  انسانی (cover, PDF p1).
- Offset: **printed = PDF − 6** (footers: PDF p10 → 4, p22 → 16, p100 → 94).
  Printed pages 1–170; lesson content ends p167 (درس ۱۳); pp.168–170 are
  back matter (بخش دوم book list, validation lists).
- Combos: `humanities` / grade 12 / `final_exam` only — 225 rows, unchanged.
- Verdict: **no changes**. All 13 lessons' «کل درس» ranges (migration 212)
  are already قرائت → last content page with no overlap into the next
  lesson's قرائت (verified programmatically; the page after each end is
  blank except the بخش break after درس ۶, printed p77, and the immediate
  قرائت start of درس ۱۳ after درس ۱۲'s end p153 — correctly not included).
  The «مطالعهٔ صفحه» rows already exist and cover exactly [title,
  کل درس end] per lesson (minimum 105 chars per page). No row was added,
  moved or corrected for this book.

## 6. The «مطالعهٔ صفحه» finding

**Finding: equivalent rows SHOULD exist for the ریاضی/تجربی versions, and
this migration adds them (430 rows).** The same-edition text supports them
on every count:

- The ریاضی/تجربی books have the identical per-page lesson structure as
  their humanities siblings: title page → content pages → last content
  page, with the قرائت pages broken out into their own «آیات و ترجمه آغاز
  درس» rows. Every page in [title, last content] carries real study text
  (verified page by page; shortest pages are single-box pages — a 98-char
  پیشنهاد box, a 105-char اندیشه و تحقیق box — and the humanities books
  already give مطالعه rows to exactly such pages).
- Precedent inside the ریاضی/تجربی stream: migration 209 already seeded
  115 «مطالعهٔ صفحه» rows for دین و زندگی ۱ (ریاضی/تجربی, grade 10).
- The only difference from the humanities seeding is the position scheme:
  this migration uses 3100+page (batch-spec rule: new positions ≥ 3000)
  instead of the humanities 500+page, so the ids differ but the titles and
  page coverage match the siblings exactly.
- Nothing in the ریاضی/تجربی text argues against them: no lesson lacks
  per-page content, and the blank separators / بخش openers / back-matter
  pages were all excluded (they fall outside [title, last content]).

## 7. Tests

`node tests/phase3-dini-ranges-1405.test.cjs` from the repo root — **PASS,
exit 0** (both blocks print PASS, ~21 s). PGlite, migrations 128–246
applied first (119 files), then 247.

Main database asserts: pre-migration counts (دین و زندگی ۲: 101/field,
دین و زندگی ۳: 69/field, humanities 295/225); the 12 pre-state کل درس
pages/revisions; no prior position ≥ 3100; all 24 corrected rows land with
the exact new pages and revision+1 with unchanged ids; all 430 مطالعه rows
land with exact single pages, revision 1, no konkur rows; post-counts
(214/214/171/171, humanities unchanged); دین و زندگی ۳ کل درس starts
unchanged; bank delta is exactly 430 new ids + 24 changed rows (only
pages/revision/updated_at differ); re-run is a no-op; a simulated admin
edit (one corrected کل درس row + one مطالعه row) survives re-run; a
simulated admin delete (one مطالعه row + one corrected کل درس row) is NOT
resurrected; the simulated snapshot is untouched.

Second database asserts the guards: a pre-migration admin edit of درس ۵'s
کل درس row survives 247 untouched (title/pages/revision kept), a
pre-migration admin delete of درس ۶'s کل درس row is not resurrected, the
other 22 کل درس rows are still corrected, and all 430 مطالعه rows land.

## 8. Uncertainties

- **درس ۲'s اندیشه و تحقیق heading (دین و زندگی ۲, ریاضی/تجربی):** the
  heading text is not in the p32 text layer (it is likely rendered as a
  graphic); the page's questions are unmistakably درس ۲'s closing questions
  and p33 is blank, so the last-content page (32) and the migration-240 row
  (32–32) stand. No impact on any range in this migration.
- **Guard assumption:** the درس ۱۰/درس ۱۲ guards (revision 2) assume
  migration 161's updates applied in the live database. If an admin edited
  either row after 161, the guard silently skips it — by design — and the
  row stays at its admin-edited pages. The test proves this behaviour on
  the second database; the live database was not inspected.
- **Uncompressed dini-11 file:** the file used here is the uncompressed
  copy (SHA differs from the documented compressed copy). The follow-up-5B
  audit established content equivalence; this item re-verified the imprint
  and every lesson boundary in the file used.
- **درس ۳'s last content page (44):** p44 holds only the 98-char پیشنهاد
  box. It is counted as lesson content (and gets a «مطالعه صفحه ۴۴» row)
  because the box is درس ۳'s own activity (finding further scientific
  miracles of the Quran) and the humanities books likewise include
  single-box trailing pages in کل درس (e.g. 112205 p38, اندیشه و تحقیق only).

## 9. Open decisions for the user / coordinator

1. **دین و زندگی ۳ (ریاضی/تجربی) «کل درس» starts.** After this migration
   the four books are not uniform: دین و زندگی ۲ (ریاضی/تجربی) and both
   humanities books start «کل درس» at the lesson's قرائت pages, while
   دین و زندگی ۳ (ریاضی/تجربی) still starts at the title page (migration
   163's deliberate convention; e.g. درس ۱ is 6–14, قرائت 4–5). If the
   user wants the same قرائت-start convention there, that is 20 further
   guarded rows (10 lessons × 2 fields, guards on the post-163 state:
   revision 2, current pages). Say the word and it is a small follow-up.
2. **درس ۱۰/درس ۱۲ start-only normalisation.** This migration changed
   their starts (124 → 122, 148 → 146) although their ends were already
   correct — 4 of the 24 rows. If the coordinator prefers the strict
   22-row count from the follow-up-5B open decision (ends only), those 4
   rows are a trivial revert; the evidence above records exactly what
   would change back.
3. **Position scheme for the new مطالعه rows.** They use 3100+page (batch
   spec) rather than the humanities 500+page. Same titles, same coverage,
   different ids. If the coordinator prefers byte-identical positions with
   the humanities siblings, that is a re-seed, not a correction — flag
   before any such change, because the current ids are already live once
   247 is applied.
