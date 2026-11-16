# Follow-up item 3 — مطالعات اجتماعی ۹: 18 کاربرگه worksheets (migration 242)

## Book fingerprint

- File: `motaleat-ejtemai-9-907-1405.pdf` (paye-9)
- SHA-256: `4355abb0eff6f06de3e3274a024a9566c757903f65f2e133caa6658f029d93e3` — matches the value documented in `docs/planner-1405-audit/batch-5-evidence.md` (the only one of the 79 inventory files with no documented SHA; this local value is the documented one).
- PDF pages: 200. Book code: 907 (imprint, PDF p.2). چاپ: چاپ دوازدهم ۱۴۰۵ (imprint, PDF p.2).
- Offset: printed = PDF − 6 (batch-5 determination; re-confirmed here: PDF p.176 is the «واژه‌ها» page of درس ۲۴ with printed footer 170).
- Printed pagination ends at p.170. PDF p.177 is the «کاربرگۀ فعّالیت» section cover (no number). The 18 numbered worksheets run PDF pp.178–198. PDF p.199 is a foreign-words glossary table («واژهٔ بیگانه / معادل در کتاب / معادل مصوب فرهنگستان») and PDF p.200 is the back-cover quotation («انقلاب زنده است…») — neither is a worksheet.

## Verification: why the pages are NULL by design

Every worksheet page was extracted with PyMuPDF and checked for a printed
page-number footer. None of PDF pp.178–198 carries one (first/last text lines
checked per page; the only numbers are exercise content, e.g. coordinates and
dates inside the worksheets). The last numbered page of the book is printed
p.170 on PDF p.176. The worksheets are therefore unnumbered by design, and
no page numbers were invented: all 18 rows have `page_start`/`page_end` NULL.
Chapter «کاربرگه‌ها» is the page-less-by-design flag — every row in this
chapter is NULL-page, and this migration adds no NULL-page row anywhere else.

## What was added (migration 242, pattern A, install marker)

18 rows, subject مطالعات اجتماعی, chapter «کاربرگه‌ها», positions 3000–3017,
combo grade 9 / field `all` / track `final_exam` only (grade-9 rule; no رشته,
no konkur). Id formula per row:
`md5('nova:planner:1405:v242:all:9:final_exam:مطالعات اجتماعی:کاربرگه‌ها:'||position)::uuid`.
Install marker seed_key: `followup-motaleat-worksheets-1405-v242`.
No prior migration used chapter کاربرگه‌ها or positions 3000–3017 under it
(grepped all migrations for «کاربرگه» — no matches), so no collision.

| Position | Title | Lesson | PDF page(s) | Verified heading in PDF |
|---|---|---|---|---|
| 3000 | کاربرگه ۱: طول و عرض جغرافیایی | درس ۱ | 178 | «کاربرگۀ شمارۀ ١ / طول و عرض جغرافیایی» |
| 3001 | کاربرگه ۲: طول و عرض جغرافیایی بر روی نقشه | درس ۱ | 179 | «کاربرگۀ شمارۀ ٢ / طول و عرض جغرافیایی بر روی نقشه» (نقشهٔ استان کرمان) |
| 3002 | کاربرگه ۳: انواع ناهمواری‌ها | درس ۳ | 180 | «کاربرگۀ شمارۀ ٣ / انواع ناهمواری‌ها» |
| 3003 | کاربرگه ۴: رابطه پراکندگی زیست‌بوم‌های جهان با عرض جغرافیایی و بارش | درس ۵ | 181 | «کاربرگۀ شمارۀ ۴ / رابطهٴ پراکندگی زیست بوم‌های جهان با عرض جغرافیایی و بارش» |
| 3004 | کاربرگه ۵: زیست‌بوم‌های جهان | درس ۵ | 182 | «کاربرگۀ شمارۀ ۵ / زیست بوم‌های جهان» |
| 3005 | کاربرگه ۶: شگفتی‌های آفریقا | درس ۵ | 183 | «کاربرگۀ شمارۀ ۶ / شگفتی‌های آفریقا» |
| 3006 | کاربرگه ۷: نقشه سیاسی ایران در آستانه تأسیس حکومت صفویه | درس ۹ | 184–185 | «کاربرگۀ شمارۀ ٧ / نقشۀ سیاسی ایران در آستانهٴ تاٴسیس حکومت صفویه» + «ادامۀ کاربرگۀ شمارۀ ٧» |
| 3007 | کاربرگه ۸: اداره شهرها و روستاها در عصر صفوی | درس ۱۰ | 186 | «کاربرگۀ شمارۀ ٨ / ادارۀ شهرها و روستاها در عصر صفوی» |
| 3008 | کاربرگه ۹: جدایی سرزمین‌های ایرانی در دوره قاجار | درس ۱۱ | 187 | «کاربرگۀ شمارۀ ٩ / جدایی سرزمین‌های ایرانی در دورۀ قاجار» |
| 3009 | کاربرگه ۱۰: زمینه‌ها و عوامل نهضت مشروطه | درس ۱۳ | 188 | «کاربرگۀ شمارۀ ١٠ / زمینه‌ها و عوامل نهضت مشروطه» |
| 3010 | کاربرگه ۱۱: سخن امام درباره قرآن و روحانیت | درس ۱۵ | 189 | «کاربرگۀ شمارۀ ١١» + سخن امام (نقل‌قول دربارهٔ قرآن، روحانیت و فیضیه) |
| 3011 | کاربرگه ۱۲: رویدادهای مهم انقلاب اسلامی در سال ۱۳۵۷ | درس ۱۵ | 190 | «کاربرگۀ شمارۀ ١٢ / رویدادهای مهم انقالب اسالمی در سال ١٣۵٧» |
| 3012 | کاربرگه ۱۳: لایه‌های فرهنگ | درس ۱۷ | 191–193 | «کاربرگۀ شمارۀ ١٣ / لایه‌های فرهنگ» + «ادامۀ کاربرگۀ شمارۀ ١٣» (روستای خان‌آباد) |
| 3013 | کاربرگه ۱۴: سازگاری والدین و فرزندان | درس ۲۰ | 194 | «کاربرگۀ شمارۀ ١۴ / سازگاری والدین و فرزندان» (موقعیت‌ها و عبارات سازگاری) |
| 3014 | کاربرگه ۱۵: سازگاری والدین و فرزندان | درس ۲۰ | 195 | «کاربرگۀ شمارۀ ١۵ / سازگاری والدین و فرزندان» (جدول انتظارات متقابل) |
| 3015 | کاربرگه ۱۶: حقوق و تکالیف شهروندی | درس ۲۲ | 196 | «کاربرگۀ شمارۀ ١۶ / حقوق و تکالیف شهروندی» |
| 3016 | کاربرگه ۱۷: بهره‌وری | درس ۲۳ | 197 | «کاربرگۀ شمارۀ ١٧ / بهره‌وری» |
| 3017 | کاربرگه ۱۸: حل مسئله | درس ۲۴ | 198 | «کاربرگۀ شمارۀ ١٨ / حل مسئله» |

Every worksheet number, title, and lesson mapping matches the list in
`docs/planner-1405-audit/batch-5-evidence.md` line 1697, re-verified here
against the PDF text. Lesson mapping follows the book's own lesson content
(درس ۱: طول/عرض جغرافیایی؛ درس ۳: ناهمواری‌ها؛ درس ۵: زیست‌بوم‌ها؛ درس ۹:
صفویه؛ درس ۱۰: عصر صفوی؛ درس ۱۱: قاجار؛ درس ۱۳: مشروطه؛ درس ۱۵: انقلاب؛
درس ۱۷: فرهنگ؛ درس ۲۰: خانواده؛ درس ۲۲: شهروندی؛ درس ۲۳: بهره‌وری؛
درس ۲۴: حل مسئله).

## Notes / uncertainties

- کاربرگه ۱۱ has no printed title of its own: the page is headed only
  «کاربرگۀ شمارۀ ١١» followed by the Imam's words about the Quran and the
  clergy. The title «سخن امام درباره قرآن و روحانیت» is the batch-5
  evidence list's descriptive name for it, kept here for consistency.
- کاربرگه ۱۴ and ۱۵ share the book's own heading «سازگاری والدین و
  فرزندان» but are different exercises (14: matching situations to
  سازگاری phrases; 15: the mutual-expectations table). The کاربرگه number
  in the title is what distinguishes the two rows; no disambiguation was
  added beyond the number, per the brief.
- کاربرگه ۷ spans two PDF pages (184–185) and کاربرگه ۱۳ spans three
  (191–193, with an unheaded continuation on p.192). Since pages are NULL
  for all rows, the spans are recorded here only, not in the bank.
- The full-chain test's NULL-page allowlist was NOT updated here (the
  coordinator does that at the end); this item's 18 NULL-page rows are the
  only new NULL-page rows in the bank from migration 242.

## Test results

`node tests/followup-motaleat-worksheets-1405.test.cjs` from the repo root —
**PASS, exit 0** (PGlite, already installed in the clone's `node_modules`).
Dependency migrations applied in order: 128, 133, 151, 167, 192, then 242.
Assertions passed:

- The migration's JSON is exactly the 18 expected topics, positions 3000–3017.
- Exactly 18 rows exist for chapter کاربرگه‌ها, all NULL-page, revision 1,
  field `all` / grade 9 / track `final_exam` only, no konkur rows; ids match
  the v242 formula exactly.
- No other NULL-page rows from this migration: the subject's NULL-page count
  went from 8 (migration 151's eight unfilled whole-lesson rows) to 26
  (8 + 18); only 18 new ids in the whole bank, nothing else changed.
- `planner_list_topics('1405','all','9','final_exam','مطالعات اجتماعی','کاربرگه‌ها')`
  returns the 18 rows with NULL pages; `planner_list_topic_chapters` lists
  کاربرگه‌ها.
- Re-running migration 242 is a no-op.
- Simulated super-admin edit (title → «ویرایش مدیر», revision 1→2, pages
  stay NULL) survives re-run.
- Simulated super-admin delete of the position-3017 row is NOT resurrected
  by re-run (17 کاربرگه‌ها rows remain).
- The simulated `published_snapshot` is untouched.

## Files written

- `supabase/migrations/242_planner_followup_motaleat_worksheets_1405.sql`
- `tests/followup-motaleat-worksheets-1405.test.cjs`
- `docs/planner-1405-audit/followup-3-evidence.md` (this file)

No other files were edited. Nothing was committed, pushed, or merged; no
PDF was placed in git.

## Verdict

COMPLETE for this item: all 18 کاربرگه worksheets are now selectable topics
with NULL pages by design, verified one by one against the 1405 PDF, and the
test passes. This closes the INCOMPLETE verdict on مطالعات اجتماعی ۹ from
batch 5 (the worksheets were its only gap).
