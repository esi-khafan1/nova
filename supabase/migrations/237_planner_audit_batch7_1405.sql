-- Batch 7 audit (migration 237): books #61-70 checked against the user's 1405 PDFs.
-- Pattern A only, insert-only with a one-time install marker. No Pattern B fills:
-- after the dependency migrations (132/135/137/174/187/195/202) every row for
-- these ten books already has printed pages -- a PGlite probe over the full
-- dependency chain found zero NULL-page rows for all ten subjects, and no prior
-- migration uses positions >= 3000 for any of these (subject, chapter) combos,
-- so nothing collides and nothing is silently skipped.
-- What is added, per book (all page ranges verified against the PDF text):
--  * ریاضی ۱ (195): the 26 end-of-lesson/subtopic تمرین blocks the 195 seed
--    omits (فعالیت/کار در کلاس/خواندنی boxes stay grouped inside their lesson
--    rows, as in batch 4). Two lessons have two تمرین blocks each -- ریشه nام
--    (56, 57-58) and ترکیب (138, 139-140) -- so the lesson-end block is
--    titled "تمرین <lesson> (پایان درس)". Both fields, both tracks.
--  * ریاضی ۲ / ریاضی ۳ (195): no standalone تمرین headings exist (exercises
--    are کار در کلاس blocks inside the lesson rows); only the back-matter
--    منابع row is added under فصل ۷ (ریاضی ۲: 167; ریاضی ۳: 149-151).
--    PDF p.177 (ریاضی ۲, printed 168) and PDF p.160 (ریاضی ۳, printed 152)
--    are the اعتبارسنجی teacher lists and get no row.
--  * ریاضی و آمار ۱/۲/۳ (195): the 18/8/9 تمرین blocks the 195 seed omits,
--    titled by the lesson/subtopic each block follows (multi-block lessons
--    are split by subtopic, e.g. amar1 حل معادله درجه دوم: تجزیه 21-22,
--    مربع کامل 27, مسائل کاربردی 31-32; amar1 فصل ۴ درس ۱ has two blocks
--    inside one subtopic, so the lesson-end one is "(پایان درس)"); plus the
--    منابع row under the last فصل (amar1: 118; amar2: 71; amar3: 105).
--    The اعتبارسنجی lists (amar2 p.72, amar3 p.106) get no row.
--  * ریاضی ۹ (202): no rows. The 202 seed already covers every chapter,
--    lesson, subtopic and per-page فعالیت/کار در کلاس/تمرین/خواندنی row;
--    all 13 token-match flags were checked by reading the pages and are
--    verifier artefacts (paraphrased titles, section-opener activities).
--    PDF p.152 (printed 144) is the نظرسنجی letter -- no row.
--  * سلامت و بهداشت (174): seven whole-lesson rows corrected via Pattern A
--    (migration-161 precedent -- the old rows are page-filled already, so
--    Pattern B cannot apply; the old rows are left untouched): the first
--    lesson of each فصل opens with an intro page (خبر + فعالیت ۱) one page
--    before its title page, so درس ۱/۳/۶/۸/۱۱/۱۳ each start one page earlier
--    than 174 says, and درس ۱۰ ends on p.126 (not 125). Plus the منابع row
--    (185). The نظرسنجی letter on p.186 gets no row.
--  * شیمی ۱ / شیمی ۳ (187): واژه‌نامه and منابع at the end, which sit OUTSIDE
--    the chapter ranges (the فصل ۳/۴ کل فصل rows keep ending at 122/123):
--    شیمی ۱ واژه‌نامه 123-126 + منابع 126 (منابع starts at the bottom of
--    p.126); شیمی ۳ واژه‌نامه 124-125 + منابع 126 (TOC + page sequence after
--    the last numbered page 123; the appendix pages are unnumbered). The
--    جدول دوره‌ای and اعتبارسنجی pages get no row.
-- Front matter, فصل/lesson divider and blank pages get no rows, as in prior
-- audit batches.
with installed as (insert into private.planner_seed_installations(seed_key) values ('audit-batch7-1405-v237') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۱: مجموعه، الگو و دنباله", "position": 3000, "title": "تمرین مجموعه‌های متناهی و نامتناهی", "start": 7, "end": 7, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۱: مجموعه، الگو و دنباله", "position": 3001, "title": "تمرین متمم یک مجموعه", "start": 12, "end": 13, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۱: مجموعه، الگو و دنباله", "position": 3002, "title": "تمرین الگو و دنباله", "start": 20, "end": 20, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۱: مجموعه، الگو و دنباله", "position": 3003, "title": "تمرین دنباله حسابی", "start": 24, "end": 24, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۱: مجموعه، الگو و دنباله", "position": 3004, "title": "تمرین دنباله هندسی", "start": 27, "end": 27, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۲: مثلثات", "position": 3000, "title": "تمرین نسبت‌های مثلثاتی", "start": 34, "end": 35, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۲: مثلثات", "position": 3001, "title": "تمرین دایره مثلثاتی", "start": 40, "end": 41, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۲: مثلثات", "position": 3002, "title": "تمرین روابط بین نسبت‌های مثلثاتی", "start": 45, "end": 46, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۳: توان‌های گویا و عبارت‌های جبری", "position": 3000, "title": "تمرین ریشه و توان", "start": 51, "end": 53, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۳: توان‌های گویا و عبارت‌های جبری", "position": 3001, "title": "تمرین ریشه nام", "start": 56, "end": 56, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۳: توان‌های گویا و عبارت‌های جبری", "position": 3002, "title": "تمرین ریشه nام (پایان درس)", "start": 57, "end": 58, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۳: توان‌های گویا و عبارت‌های جبری", "position": 3003, "title": "تمرین توان‌های گویا", "start": 61, "end": 61, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۳: توان‌های گویا و عبارت‌های جبری", "position": 3004, "title": "تمرین عبارت‌های جبری", "start": 67, "end": 67, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۴: معادله‌ها و نامعادله‌ها", "position": 3000, "title": "تمرین حل معادله درجه دوم به روش فرمول کلی", "start": 76, "end": 77, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۴: معادله‌ها و نامعادله‌ها", "position": 3001, "title": "تمرین سهمی", "start": 81, "end": 82, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۴: معادله‌ها و نامعادله‌ها", "position": 3002, "title": "تمرین تعیین علامت", "start": 93, "end": 93, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۵: تابع", "position": 3000, "title": "تمرین مفهوم تابع و بازنمایی‌های آن", "start": 100, "end": 100, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۵: تابع", "position": 3001, "title": "تمرین دامنه و برد توابع", "start": 105, "end": 108, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۵: تابع", "position": 3002, "title": "تمرین انواع تابع", "start": 115, "end": 117, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۶: شمارش، بدون شمردن", "position": 3000, "title": "تمرین شمارش", "start": 124, "end": 126, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۶: شمارش، بدون شمردن", "position": 3001, "title": "تمرین جایگشت", "start": 131, "end": 132, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۶: شمارش، بدون شمردن", "position": 3002, "title": "تمرین ترکیب", "start": 138, "end": 138, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۶: شمارش، بدون شمردن", "position": 3003, "title": "تمرین ترکیب (پایان درس)", "start": 139, "end": 140, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۷: آمار و احتمال", "position": 3000, "title": "تمرین احتمال یا اندازه‌گیری شانس", "start": 150, "end": 151, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۷: آمار و احتمال", "position": 3001, "title": "تمرین مقدمه‌ای بر علم آمار، جامعه و نمونه", "start": 158, "end": 158, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۷: آمار و احتمال", "position": 3002, "title": "تمرین متغیر و انواع آن", "start": 168, "end": 170, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۱: مجموعه، الگو و دنباله", "position": 3000, "title": "تمرین مجموعه‌های متناهی و نامتناهی", "start": 7, "end": 7, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۱: مجموعه، الگو و دنباله", "position": 3001, "title": "تمرین متمم یک مجموعه", "start": 12, "end": 13, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۱: مجموعه، الگو و دنباله", "position": 3002, "title": "تمرین الگو و دنباله", "start": 20, "end": 20, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۱: مجموعه، الگو و دنباله", "position": 3003, "title": "تمرین دنباله حسابی", "start": 24, "end": 24, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۱: مجموعه، الگو و دنباله", "position": 3004, "title": "تمرین دنباله هندسی", "start": 27, "end": 27, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۲: مثلثات", "position": 3000, "title": "تمرین نسبت‌های مثلثاتی", "start": 34, "end": 35, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۲: مثلثات", "position": 3001, "title": "تمرین دایره مثلثاتی", "start": 40, "end": 41, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۲: مثلثات", "position": 3002, "title": "تمرین روابط بین نسبت‌های مثلثاتی", "start": 45, "end": 46, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۳: توان‌های گویا و عبارت‌های جبری", "position": 3000, "title": "تمرین ریشه و توان", "start": 51, "end": 53, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۳: توان‌های گویا و عبارت‌های جبری", "position": 3001, "title": "تمرین ریشه nام", "start": 56, "end": 56, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۳: توان‌های گویا و عبارت‌های جبری", "position": 3002, "title": "تمرین ریشه nام (پایان درس)", "start": 57, "end": 58, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۳: توان‌های گویا و عبارت‌های جبری", "position": 3003, "title": "تمرین توان‌های گویا", "start": 61, "end": 61, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۳: توان‌های گویا و عبارت‌های جبری", "position": 3004, "title": "تمرین عبارت‌های جبری", "start": 67, "end": 67, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۴: معادله‌ها و نامعادله‌ها", "position": 3000, "title": "تمرین حل معادله درجه دوم به روش فرمول کلی", "start": 76, "end": 77, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۴: معادله‌ها و نامعادله‌ها", "position": 3001, "title": "تمرین سهمی", "start": 81, "end": 82, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۴: معادله‌ها و نامعادله‌ها", "position": 3002, "title": "تمرین تعیین علامت", "start": 93, "end": 93, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۵: تابع", "position": 3000, "title": "تمرین مفهوم تابع و بازنمایی‌های آن", "start": 100, "end": 100, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۵: تابع", "position": 3001, "title": "تمرین دامنه و برد توابع", "start": 105, "end": 108, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۵: تابع", "position": 3002, "title": "تمرین انواع تابع", "start": 115, "end": 117, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۶: شمارش، بدون شمردن", "position": 3000, "title": "تمرین شمارش", "start": 124, "end": 126, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۶: شمارش، بدون شمردن", "position": 3001, "title": "تمرین جایگشت", "start": 131, "end": 132, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۶: شمارش، بدون شمردن", "position": 3002, "title": "تمرین ترکیب", "start": 138, "end": 138, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۶: شمارش، بدون شمردن", "position": 3003, "title": "تمرین ترکیب (پایان درس)", "start": 139, "end": 140, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۷: آمار و احتمال", "position": 3000, "title": "تمرین احتمال یا اندازه‌گیری شانس", "start": 150, "end": 151, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۷: آمار و احتمال", "position": 3001, "title": "تمرین مقدمه‌ای بر علم آمار، جامعه و نمونه", "start": 158, "end": 158, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "ریاضی ۱", "chapter": "فصل ۷: آمار و احتمال", "position": 3002, "title": "تمرین متغیر و انواع آن", "start": 168, "end": 170, "konkur": true},
 {"field": "experimental_sciences", "grade": "11", "subject": "ریاضی ۲", "chapter": "فصل ۷: آمار و احتمال", "position": 3000, "title": "منابع", "start": 167, "end": 167, "konkur": true},
 {"field": "experimental_sciences", "grade": "12", "subject": "ریاضی ۳", "chapter": "فصل ۷: احتمال", "position": 3000, "title": "منابع", "start": 149, "end": 151, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۱", "position": 3000, "title": "تمرین معادله و مسائل توصیفی", "start": 14, "end": 18, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۱", "position": 3001, "title": "تمرین تجزیه عبارت‌های جبری", "start": 21, "end": 22, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۱", "position": 3002, "title": "تمرین روش مربع کامل", "start": 27, "end": 27, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۱", "position": 3003, "title": "تمرین مسائل کاربردی معادله درجه دوم", "start": 31, "end": 32, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۱", "position": 3004, "title": "تمرین مسائل معادله‌های شامل عبارت گویا", "start": 37, "end": 38, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۲", "position": 3000, "title": "تمرین مفهوم تابع", "start": 48, "end": 49, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۲", "position": 3001, "title": "تمرین ضابطه جبری تابع", "start": 53, "end": 55, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۲", "position": 3002, "title": "تمرین نمودار تابع خطی", "start": 61, "end": 62, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۲", "position": 3003, "title": "تمرین رسم تابع درجه دوم", "start": 70, "end": 70, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۳", "position": 3000, "title": "تمرین پرسش‌های آمارگیری", "start": 77, "end": 77, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۳", "position": 3001, "title": "تمرین مقیاس‌های اندازه‌گیری", "start": 81, "end": 81, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۳", "position": 3002, "title": "تمرین آمار چیست؟", "start": 83, "end": 84, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۳", "position": 3003, "title": "تمرین معیارهای گرایش به مرکز", "start": 87, "end": 87, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۳", "position": 3004, "title": "تمرین معیارهای پراکندگی", "start": 96, "end": 98, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۴", "position": 3000, "title": "تمرین نمودار میله‌ای", "start": 104, "end": 104, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۴", "position": 3001, "title": "تمرین نمایش داده (پایان درس)", "start": 109, "end": 109, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۴", "position": 3002, "title": "تمرین پراکنش نگاشت جمعیت و مساحت", "start": 112, "end": 112, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۴", "position": 3003, "title": "تمرین نمودار راداری", "start": 117, "end": 117, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "ریاضی و آمار ۱", "chapter": "فصل ۴", "position": 3004, "title": "منابع", "start": 118, "end": 118, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "ریاضی و آمار ۲", "chapter": "فصل ۱", "position": 3000, "title": "تمرین گزاره‌ها و ترکیب گزاره‌ها", "start": 10, "end": 11, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "ریاضی و آمار ۲", "chapter": "فصل ۱", "position": 3001, "title": "تمرین استدلال ریاضی", "start": 18, "end": 18, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "ریاضی و آمار ۲", "chapter": "فصل ۲", "position": 3000, "title": "تمرین انواع توابع", "start": 24, "end": 26, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "ریاضی و آمار ۲", "chapter": "فصل ۲", "position": 3001, "title": "تمرین توابع ثابت، چندضابطه‌ای و همانی", "start": 31, "end": 33, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "ریاضی و آمار ۲", "chapter": "فصل ۲", "position": 3002, "title": "تمرین توابع پلکانی و قدر مطلقی", "start": 43, "end": 44, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "ریاضی و آمار ۲", "chapter": "فصل ۲", "position": 3003, "title": "تمرین اعمال بر روی توابع", "start": 52, "end": 53, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "ریاضی و آمار ۲", "chapter": "فصل ۳", "position": 3000, "title": "تمرین شاخص‌های آماری", "start": 61, "end": 62, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "ریاضی و آمار ۲", "chapter": "فصل ۳", "position": 3001, "title": "تمرین سری‌های زمانی", "start": 68, "end": 70, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "ریاضی و آمار ۲", "chapter": "فصل ۳", "position": 3002, "title": "منابع", "start": 71, "end": 71, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "ریاضی و آمار ۳", "chapter": "فصل ۱", "position": 3000, "title": "تمرین شمارش", "start": 10, "end": 11, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "ریاضی و آمار ۳", "chapter": "فصل ۱", "position": 3001, "title": "تمرین احتمال", "start": 25, "end": 26, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "ریاضی و آمار ۳", "chapter": "فصل ۱", "position": 3002, "title": "تمرین چرخه آمار در حل مسائل", "start": 39, "end": 44, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "ریاضی و آمار ۳", "chapter": "فصل ۲", "position": 3000, "title": "تمرین مدل‌سازی و دنباله", "start": 57, "end": 60, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "ریاضی و آمار ۳", "chapter": "فصل ۲", "position": 3001, "title": "تمرین دنباله‌های حسابی", "start": 71, "end": 72, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "ریاضی و آمار ۳", "chapter": "فصل ۳", "position": 3000, "title": "تمرین دنباله هندسی", "start": 83, "end": 85, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "ریاضی و آمار ۳", "chapter": "فصل ۳", "position": 3001, "title": "تمرین ریشه nام و توان گویا", "start": 93, "end": 94, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "ریاضی و آمار ۳", "chapter": "فصل ۳", "position": 3002, "title": "تمرین تابع نمایی", "start": 101, "end": 102, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "ریاضی و آمار ۳", "chapter": "فصل ۳", "position": 3003, "title": "تمرین تابع نمایی (پایان درس)", "start": 104, "end": 104, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "ریاضی و آمار ۳", "chapter": "فصل ۳", "position": 3004, "title": "منابع", "start": 105, "end": 105, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3000, "title": "درس ۱: سلامت چیست؟", "start": 2, "end": 11, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3001, "title": "درس ۳: برنامه غذایی سالم", "start": 18, "end": 32, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3002, "title": "درس ۶: بیماری‌های غیر واگیر", "start": 48, "end": 66, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3003, "title": "درس ۸: بهداشت فردی", "start": 78, "end": 100, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3004, "title": "درس ۱۰: بهداشت روان", "start": 111, "end": 126, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3005, "title": "درس ۱۱: مصرف دخانیات و الکل", "start": 128, "end": 138, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3006, "title": "درس ۱۳: پیشگیری از اختلالات اسکلتی ـ عضلانی (کمردرد)", "start": 156, "end": 171, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3007, "title": "منابع", "start": 185, "end": 185, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3000, "title": "درس ۱: سلامت چیست؟", "start": 2, "end": 11, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3001, "title": "درس ۳: برنامه غذایی سالم", "start": 18, "end": 32, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3002, "title": "درس ۶: بیماری‌های غیر واگیر", "start": 48, "end": 66, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3003, "title": "درس ۸: بهداشت فردی", "start": 78, "end": 100, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3004, "title": "درس ۱۰: بهداشت روان", "start": 111, "end": 126, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3005, "title": "درس ۱۱: مصرف دخانیات و الکل", "start": 128, "end": 138, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3006, "title": "درس ۱۳: پیشگیری از اختلالات اسکلتی ـ عضلانی (کمردرد)", "start": 156, "end": 171, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3007, "title": "منابع", "start": 185, "end": 185, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3000, "title": "درس ۱: سلامت چیست؟", "start": 2, "end": 11, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3001, "title": "درس ۳: برنامه غذایی سالم", "start": 18, "end": 32, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3002, "title": "درس ۶: بیماری‌های غیر واگیر", "start": 48, "end": 66, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3003, "title": "درس ۸: بهداشت فردی", "start": 78, "end": 100, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3004, "title": "درس ۱۰: بهداشت روان", "start": 111, "end": 126, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3005, "title": "درس ۱۱: مصرف دخانیات و الکل", "start": 128, "end": 138, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3006, "title": "درس ۱۳: پیشگیری از اختلالات اسکلتی ـ عضلانی (کمردرد)", "start": 156, "end": 171, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "سلامت و بهداشت", "chapter": "درس‌ها", "position": 3007, "title": "منابع", "start": 185, "end": 185, "konkur": false},
 {"field": "mathematics", "grade": "10", "subject": "شیمی ۱", "chapter": "فصل ۳: آب، آهنگ زندگی", "position": 3000, "title": "واژه‌نامه", "start": 123, "end": 126, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "شیمی ۱", "chapter": "فصل ۳: آب، آهنگ زندگی", "position": 3001, "title": "منابع", "start": 126, "end": 126, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "شیمی ۱", "chapter": "فصل ۳: آب، آهنگ زندگی", "position": 3000, "title": "واژه‌نامه", "start": 123, "end": 126, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "شیمی ۱", "chapter": "فصل ۳: آب، آهنگ زندگی", "position": 3001, "title": "منابع", "start": 126, "end": 126, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "شیمی ۳", "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر", "position": 3000, "title": "واژه‌نامه", "start": 124, "end": 125, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "شیمی ۳", "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر", "position": 3001, "title": "منابع", "start": 126, "end": 126, "konkur": true},
 {"field": "experimental_sciences", "grade": "12", "subject": "شیمی ۳", "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر", "position": 3000, "title": "واژه‌نامه", "start": 124, "end": 125, "konkur": true},
 {"field": "experimental_sciences", "grade": "12", "subject": "شیمی ۳", "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر", "position": 3001, "title": "منابع", "start": 126, "end": 126, "konkur": true}
]$topics$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,start integer,"end" integer,konkur boolean)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v237:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed where p.konkur or r.track='final_exam' on conflict(id) do nothing;
