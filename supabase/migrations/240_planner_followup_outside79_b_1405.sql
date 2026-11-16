-- Follow-up 5B (migration 240): books outside the 79-file audit, part B, checked
-- against the user's 1405 PDFs (printed page numbers). Insert only. The
-- installation marker prevents reinstating later administrator deletions.
-- Fingerprints (local files used):
--  * تاریخ (۲) یازدهم انسانی, code 111219, چاپ دهم 1405, 216 PDF pages,
--    printed 1-206, printed = PDF - 10; SHA-256
--    c7b20d0c3207e115a8cd5658385c9102c46624d95a80d19ddd17cf67546f498c
--    (matches docs/planner-topic-sources.md). Imprint verified visually:
--    «سال انتشار و نوبت چاپ: چاپ دهم ۱۴۰۵».
--  * تاریخ معاصر ایران یازدهم, code 111220, چاپ دهم 1405, 272 PDF pages,
--    printed 1-263, printed = PDF - 9; SHA-256
--    e8fbd9b450697bf6fd0861ee11beed921a3b564c6b6ceed2823dbced8ff4cba0
--    (matches docs/planner-topic-sources.md). Imprint verified visually:
--    «چاپ دهم ۱۴۰۵». The text layer renders the year garbled; the page
--    image reads ۱۴۰۵.
--  * دین و زندگی (۲) یازدهم, ریاضی/تجربی, code 111204, چاپ دهم 1405,
--    160 PDF pages, printed = PDF page; SHA-256 of the file used
--    77d162328373f92f31fc3cb335685d075372259debd4a52bbca8d7c9ffa36641.
--    The compressed copy dini-11-111204-1405-small.pdf has SHA-256
--    f12d5d311b0d2d87061d7db9b179d06699e1826a651c2aa9d0b981e33956d051
--    (the documented SHA); page-by-page text comparison of the two files
--    shows only compression/encoding artifacts (spacing, diacritic
--    placement, dot counts), identical content, same 160 pages, same
--    imprint «سال انتشار و نوبت چاپ: 1405 چاپ دهم», same lesson starts
--    12, 22, 36, 48, 62, 74, 88, 98, 110, 124, 138, 148. The file used
--    is therefore the same 1405 edition.
--  * دین و زندگی (۳) دوازدهم, ریاضی/تجربی, code 112204, چاپ نهم 1405,
--    144 PDF pages, printed 1-138, printed = PDF - 6; SHA-256
--    48651de98db89bf0d5d982f450d7edceec9f2e359ea32d45762a8b52afc2f5d2
--    (matches docs/planner-topic-sources.md).
-- What was verified: all 635 prior seed rows for these four books' combos
-- (251 + 250 + 82 + 52 per combo) were checked against the PDF text; every
-- lesson start matches the printed contents, and every named row's content
-- words occur inside its seeded page range (the few apparent mismatches
-- were text-layer rendering variants, e.g. «تاریخ نگاری» vs «تاریخ‌نگاری»,
-- «اخلاص» vs «اخلاص», Arabic-Indic vs Latin digits). No wrong title or
-- page range was found. There are ZERO NULL-page rows in these combos, so
-- no guarded page-fill (pattern B) applies.
-- What was added (45 distinct topics, 85 entries, 90 rows):
--  * تاریخ ۲ (humanities, grade 11, konkur + final_exam): the four فصل
--    opener pages, which carry substantive introductory text (batch-5A
--    precedent for تاریخ ۱), filed under each فصل's first lesson, plus
--    «منابع و مآخذ» (202-205) under درس ۱۶. Page 206 is the teacher
--    validation list, not study content.
--  * تاریخ معاصر ایران (mathematics + experimental_sciences, grade 11,
--    final_exam only): the «مرور» review section (printed 1-16), which
--    the book marks «برای مطالعه» and migration 166 deliberately did NOT
--    file as درس ۱. It is added here as its own chapter «مرور» in four
--    sections (1-7, 8-9, 10-12, 13-16). The introduction excludes only
--    «بیشتر بدانید» / «برگی از تاریخ» boxes and footnotes from exams, not
--    the مرور. The per-lesson «جست‌وجو و اندیشه» / «پرسش‌های نمونه»
--    question sets stay grouped under کل درس, as in the prior seeds.
--  * تعلیمات دینی ۲ / ۳, ریاضی/تجربی only (mathematics +
--    experimental_sciences, final_exam only; the انسانی books 111205 /
--    112205 are separate books and are NOT touched): per lesson,
--    «آیات و ترجمه آغاز درس» (the two قرائت/ترجمه pages opening each
--    lesson — graded 4 marks for correct recitation per «سخنی با دبیران»)
--    and the lesson-end graded activity boxes that mirror the humanities
--    siblings' rows (migration 212/213): «اندیشه و تحقیق» (graded 3
--    marks), plus for دین و زندگی ۳ «تحلیل و بررسی» (درس ۳),
--    «برداشت (۱)» / «برداشت (۲)» / «هم‌اندیشی» (درس ۹). In-lesson
--    activities (تدبّر در قرآن, فعالیت کلاسی, تفکر در حدیث, بررسی,
--    دانش تکمیلی, بیشتر بدانیم) stay grouped under کل درس: the book's own
--    assessment scheme groups them as «فعالیت‌های داخل درس» (8 marks),
--    and بیشتر بدانیم boxes are explicitly not examined.
-- Deliberately NOT changed: the دین و زندگی ۲ کل درس ranges (migration
-- 155 convention: title page to the page before the next lesson's title)
-- include the next lesson's two قرائت pages for 11 of 12 lessons (درس ۱۰
-- was fixed to 124-133 by migration 161 because the بخش دوم boundary
-- intervenes). The new آیات rows overlap those ranges by design, exactly
-- as in the humanities books, where the آیات rows sit inside the کل درس
-- ranges. No کل درس range is rewritten here (pattern B covers NULL-page
-- fills only). The single-page «مطالعهٔ صفحه» rows that migrations
-- 212/213 seeded for the humanities دین و زندگی books were NOT replicated
-- for the ریاضی/تجربی versions; that is a known granularity difference,
-- recorded in the evidence file for the coordinator.
with installed as (insert into private.planner_seed_installations(seed_key) values ('audit-followup5b-1405-v240') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {"field": "humanities", "grade": "11", "subject": "تاریخ ۲", "chapter": "درس ۱", "position": 3000, "title": "آغاز فصل اول: تاریخ‌شناسی", "start": 1, "end": 1, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "تاریخ ۲", "chapter": "درس ۳", "position": 3000, "title": "آغاز فصل دوم: ظهور اسلام، حرکتی تازه در تاریخ بشر", "start": 19, "end": 19, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "تاریخ ۲", "chapter": "درس ۸", "position": 3000, "title": "آغاز فصل سوم: ایران؛ از ورود اسلام تا پایان صفویه", "start": 83, "end": 83, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "تاریخ ۲", "chapter": "درس ۱۵", "position": 3000, "title": "آغاز فصل چهارم: اروپا در قرون وسطا و عصر جدید", "start": 173, "end": 173, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "تاریخ ۲", "chapter": "درس ۱۶", "position": 3000, "title": "منابع و مآخذ", "start": 202, "end": 205, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "تاریخ معاصر ایران", "chapter": "مرور", "position": 3000, "title": "ایران پیش از اسلام", "start": 1, "end": 7, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تاریخ معاصر ایران", "chapter": "مرور", "position": 3001, "title": "ایران بعد از اسلام", "start": 8, "end": 9, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تاریخ معاصر ایران", "chapter": "مرور", "position": 3002, "title": "ایران از دوران غزنویان تا خوارزمشاهیان و هجوم مغول", "start": 10, "end": 12, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تاریخ معاصر ایران", "chapter": "مرور", "position": 3003, "title": "ایران در عصر صفویه", "start": 13, "end": 16, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تاریخ معاصر ایران", "chapter": "مرور", "position": 3000, "title": "ایران پیش از اسلام", "start": 1, "end": 7, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تاریخ معاصر ایران", "chapter": "مرور", "position": 3001, "title": "ایران بعد از اسلام", "start": 8, "end": 9, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تاریخ معاصر ایران", "chapter": "مرور", "position": 3002, "title": "ایران از دوران غزنویان تا خوارزمشاهیان و هجوم مغول", "start": 10, "end": 12, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تاریخ معاصر ایران", "chapter": "مرور", "position": 3003, "title": "ایران در عصر صفویه", "start": 13, "end": 16, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱: هدایت الهی", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 10, "end": 11, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۲: تداوم هدایت", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 20, "end": 21, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۳: معجزه جاویدان", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 34, "end": 35, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۴: مسئولیت‌های پیامبر", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 46, "end": 47, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۵: امامت، تداوم رسالت", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 60, "end": 61, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۶: پیشوایان اسوه", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 72, "end": 73, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 86, "end": 87, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۸: احیای ارزش‌های راستین", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 96, "end": 97, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۹: عصر غیبت", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 108, "end": 109, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱۰: مرجعیت و ولایت فقیه", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 122, "end": 123, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱۱: عزت نفس", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 136, "end": 137, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱۲: پیوند مقدس", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 146, "end": 147, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱: هدایت الهی", "position": 3001, "title": "اندیشه و تحقیق", "start": 18, "end": 18, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۲: تداوم هدایت", "position": 3001, "title": "اندیشه و تحقیق", "start": 32, "end": 32, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۳: معجزه جاویدان", "position": 3001, "title": "اندیشه و تحقیق", "start": 43, "end": 43, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۴: مسئولیت‌های پیامبر", "position": 3001, "title": "اندیشه و تحقیق", "start": 58, "end": 58, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر", "position": 3001, "title": "اندیشه و تحقیق", "start": 94, "end": 94, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۹: عصر غیبت", "position": 3001, "title": "اندیشه و تحقیق", "start": 120, "end": 120, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱۰: مرجعیت و ولایت فقیه", "position": 3001, "title": "اندیشه و تحقیق", "start": 133, "end": 133, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱: هدایت الهی", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 10, "end": 11, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۲: تداوم هدایت", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 20, "end": 21, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۳: معجزه جاویدان", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 34, "end": 35, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۴: مسئولیت‌های پیامبر", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 46, "end": 47, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۵: امامت، تداوم رسالت", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 60, "end": 61, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۶: پیشوایان اسوه", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 72, "end": 73, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 86, "end": 87, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۸: احیای ارزش‌های راستین", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 96, "end": 97, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۹: عصر غیبت", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 108, "end": 109, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱۰: مرجعیت و ولایت فقیه", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 122, "end": 123, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱۱: عزت نفس", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 136, "end": 137, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱۲: پیوند مقدس", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 146, "end": 147, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱: هدایت الهی", "position": 3001, "title": "اندیشه و تحقیق", "start": 18, "end": 18, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۲: تداوم هدایت", "position": 3001, "title": "اندیشه و تحقیق", "start": 32, "end": 32, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۳: معجزه جاویدان", "position": 3001, "title": "اندیشه و تحقیق", "start": 43, "end": 43, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۴: مسئولیت‌های پیامبر", "position": 3001, "title": "اندیشه و تحقیق", "start": 58, "end": 58, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر", "position": 3001, "title": "اندیشه و تحقیق", "start": 94, "end": 94, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۹: عصر غیبت", "position": 3001, "title": "اندیشه و تحقیق", "start": 120, "end": 120, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "تعلیمات دینی ۲", "chapter": "درس ۱۰: مرجعیت و ولایت فقیه", "position": 3001, "title": "اندیشه و تحقیق", "start": 133, "end": 133, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۱", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 4, "end": 5, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۲", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 16, "end": 17, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۳", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 28, "end": 29, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۴", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 40, "end": 41, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۵", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 50, "end": 51, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۶", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 62, "end": 63, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۷", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 78, "end": 79, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۸", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 92, "end": 93, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۹", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 106, "end": 107, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۱۰", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 124, "end": 125, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۱", "position": 3001, "title": "اندیشه و تحقیق", "start": 14, "end": 14, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۲", "position": 3001, "title": "اندیشه و تحقیق", "start": 26, "end": 26, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۳", "position": 3001, "title": "اندیشه و تحقیق", "start": 38, "end": 38, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۳", "position": 3002, "title": "تحلیل و بررسی", "start": 37, "end": 37, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۹", "position": 3001, "title": "برداشت (۱)", "start": 117, "end": 120, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۹", "position": 3002, "title": "برداشت (۲)", "start": 121, "end": 121, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۹", "position": 3003, "title": "هم‌اندیشی", "start": 122, "end": 122, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۱", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 4, "end": 5, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۲", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 16, "end": 17, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۳", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 28, "end": 29, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۴", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 40, "end": 41, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۵", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 50, "end": 51, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۶", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 62, "end": 63, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۷", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 78, "end": 79, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۸", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 92, "end": 93, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۹", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 106, "end": 107, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۱۰", "position": 3000, "title": "آیات و ترجمه آغاز درس", "start": 124, "end": 125, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۱", "position": 3001, "title": "اندیشه و تحقیق", "start": 14, "end": 14, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۲", "position": 3001, "title": "اندیشه و تحقیق", "start": 26, "end": 26, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۳", "position": 3001, "title": "اندیشه و تحقیق", "start": 38, "end": 38, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۳", "position": 3002, "title": "تحلیل و بررسی", "start": 37, "end": 37, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۹", "position": 3001, "title": "برداشت (۱)", "start": 117, "end": 120, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۹", "position": 3002, "title": "برداشت (۲)", "start": 121, "end": 121, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "تعلیمات دینی ۳", "chapter": "درس ۹", "position": 3003, "title": "هم‌اندیشی", "start": 122, "end": 122, "konkur": false}
]$topics$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,start integer,"end" integer,konkur boolean)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v240:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed where p.konkur or r.track='final_exam' on conflict(id) do nothing;
