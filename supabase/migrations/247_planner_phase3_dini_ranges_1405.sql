-- Phase 3 item 4 (migration 247): دین و زندگی ranges + مطالعهٔ صفحه rows, 1405.
--
-- Background: migration 155 seeded the دین و زندگی ۲ (ریاضی/تجربی) whole-lesson
-- rows «کل درس» as title page -> page before the NEXT lesson's title page, so
-- 11 of 12 ranges include the next lesson's two قرائت/ترجمه pages (e.g. درس ۱
-- was 12-21, including درس ۲'s قرائت on 20-21). Migration 161 fixed only
-- درس ۱۰ (124-137 -> 124-133, because the بخش دوم boundary intervenes) and
-- filled درس ۱۲ from NULL (148-158). Migration 163 had already fixed the
-- دین و زندگی ۳ (ریاضی/تجربی) whole-lesson ends the same way ("Lesson ranges
-- stop before the following lesson's recitation"), and migrations 212/213
-- seeded the humanities books clean from the start (قرائت start -> last
-- content page). The humanities books carry no instance of the 155
-- convention (verified programmatically: no کل درس end reaches the next
-- lesson's آیات start), and دین و زندگی ۳ (ریاضی/تجربی) does not either
-- (migration 163 ends verified against the PDF below). Only دین و زندگی ۲
-- (ریاضی/تجربی) carries it, in 11 of 12 lessons.
--
-- What this migration does:
--  1. Guarded in-place correction of the 12 v155 «کل درس» rows
--     (mathematics + experimental_sciences, grade 11, final_exam, position
--     101, 24 rows) to the humanities convention: the lesson's own two
--     قرائت pages -> its last content page. The guard matches ONLY the row
--     in its exact post-155/post-161 state: original v155 id formula,
--     original title «کل درس», position 101, the exact old pages, and the
--     expected revision (1 for lessons 1-9 and 11; 2 for درس ۱۰ and درس ۱۲,
--     whose revisions were bumped to 2 by migration 161). An admin edit
--     (title/pages/revision change) or an admin delete means the guard does
--     not match and the row is left alone; the migration never inserts,
--     deletes, or merges a کل درس row, so existing plans keep resolving to
--     the same ids. Re-running is a no-op (revision is then bumped and the
--     old pages no longer match).
--  2. Pattern-A insert of the single-page «مطالعهٔ صفحه» rows that
--     migrations 212/213 seeded for the humanities books and migration 209
--     seeded for دین و زندگی ۱ (ریاضی/تجربی), now for the ریاضی/تجربی
--     دین و زندگی ۲ and ۳ books: one row per page from each lesson's title
--     page to its last content page (the قرائت pages already have their own
--     «آیات و ترجمه آغاز درس» rows from migration 240). Positions are
--     3100+page (verified free: no prior row for these subjects uses a
--     position >= 3100). Install-marker-gated, so a later admin delete is
--     never resurrected. 430 rows (226 دین و زندگی ۲ + 204 دین و زندگی ۳).
--
-- Verified against the چاپ ۱۴۰۵ PDFs (see
-- docs/planner-1405-audit/phase3-4-evidence.md for fingerprints, offsets
-- and the lesson-by-lesson verdicts):
--  * دین و زندگی (۲) یازدهم, ریاضی/تجربی, code 111204, چاپ دهم 1405,
--    160 PDF pages, printed = PDF page; SHA-256 of the file used
--    77d162328373f92f31fc3cb335685d075372259debd4a52bbca8d7c9ffa36641.
--  * دین و زندگی (۳) دوازدهم, ریاضی/تجربی, code 112204, چاپ نهم 1405,
--    144 PDF pages, printed = PDF - 6; SHA-256
--    48651de98db89bf0d5d982f450d7edceec9f2e359ea32d45762a8b52afc2f5d2.
--  * دین و زندگی (۲) یازدهم, انسانی, code 111205, چاپ نهم 1405,
--    240 PDF pages, printed = PDF - 8; SHA-256
--    915c68aa8dfdd9566d12a6cad19408ee5bea338f599debfdcecd45373bb12026.
--  * دین و زندگی (۳) دوازدهم, انسانی, code 112205, چاپ نهم 1405,
--    176 PDF pages, printed = PDF - 6; SHA-256
--    bd658da06551b92f530a4e92963ee10b69c1a0d8b98174f0c6347cadca1b0a08.
--
-- Deliberately NOT changed:
--  * The دین و زندگی ۳ (ریاضی/تجربی) «کل درس» starts stay at the lesson
--    title page (migration 163's deliberate convention: title -> last
--    content page, e.g. درس ۱ is 6-14 while its قرائت is 4-5). Its ends
--    were verified correct against the PDF and need no fix; changing its
--    starts to the قرائت pages would be a further normalisation, recorded
--    as an open decision in the evidence file.
--  * The humanities books (212/213) are untouched: their کل درس ranges
--    are already قرائت -> last content page and their مطالعه rows already
--    exist. No row is created for any humanities combo.
--  * No konkur rows: تعلیمات دینی ۲/۳ are final_exam only in all four
--    books. No plans, ticks, exams, snapshots or history are touched.

-- Part 1: guarded correction of the v155 دین و زندگی ۲ «کل درس» rows.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "درس ۱: هدایت الهی",
  "old_start": 12,
  "old_end": 21,
  "old_revision": 1,
  "start": 10,
  "end": 18
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "old_start": 22,
  "old_end": 35,
  "old_revision": 1,
  "start": 20,
  "end": 32
 },
 {
  "chapter": "درس ۳: معجزه جاویدان",
  "old_start": 36,
  "old_end": 47,
  "old_revision": 1,
  "start": 34,
  "end": 44
 },
 {
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "old_start": 48,
  "old_end": 61,
  "old_revision": 1,
  "start": 46,
  "end": 58
 },
 {
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "old_start": 62,
  "old_end": 73,
  "old_revision": 1,
  "start": 60,
  "end": 70
 },
 {
  "chapter": "درس ۶: پیشوایان اسوه",
  "old_start": 74,
  "old_end": 87,
  "old_revision": 1,
  "start": 72,
  "end": 84
 },
 {
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "old_start": 88,
  "old_end": 97,
  "old_revision": 1,
  "start": 86,
  "end": 94
 },
 {
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "old_start": 98,
  "old_end": 109,
  "old_revision": 1,
  "start": 96,
  "end": 106
 },
 {
  "chapter": "درس ۹: عصر غیبت",
  "old_start": 110,
  "old_end": 123,
  "old_revision": 1,
  "start": 108,
  "end": 120
 },
 {
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "old_start": 124,
  "old_end": 133,
  "old_revision": 2,
  "start": 122,
  "end": 133
 },
 {
  "chapter": "درس ۱۱: عزت نفس",
  "old_start": 138,
  "old_end": 147,
  "old_revision": 1,
  "start": 136,
  "end": 144
 },
 {
  "chapter": "درس ۱۲: پیوند مقدس",
  "old_start": 148,
  "old_end": 158,
  "old_revision": 2,
  "start": 146,
  "end": 158
 }
]$fixes$::jsonb)
 as p(chapter text,old_start integer,old_end integer,old_revision integer,start integer,"end" integer)),
fields(field) as (values ('mathematics'),('experimental_sciences'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from fixes p cross join fields f
where t.id=md5('nova:planner:1405:v155:'||f.field||':11:final_exam:تعلیمات دینی ۲:'||p.chapter||':101')::uuid
 and t.edition='1405' and t.study_field=f.field and t.grade='11' and t.preparation_track='final_exam'
 and t.subject='تعلیمات دینی ۲' and t.chapter=p.chapter and t.title='کل درس' and t.position=101
 and t.page_start=p.old_start and t.page_end=p.old_end and t.revision=p.old_revision;

-- Part 2: «مطالعهٔ صفحه» rows for the ریاضی/تجربی دین و زندگی ۲/۳ books.
with installed as (insert into private.planner_seed_installations(seed_key) values ('planner-phase3-dini-ranges-1405-v247') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3112,
  "title": "مطالعه صفحه ۱۲",
  "start": 12,
  "end": 12
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3113,
  "title": "مطالعه صفحه ۱۳",
  "start": 13,
  "end": 13
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3114,
  "title": "مطالعه صفحه ۱۴",
  "start": 14,
  "end": 14
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3115,
  "title": "مطالعه صفحه ۱۵",
  "start": 15,
  "end": 15
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3116,
  "title": "مطالعه صفحه ۱۶",
  "start": 16,
  "end": 16
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3117,
  "title": "مطالعه صفحه ۱۷",
  "start": 17,
  "end": 17
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3118,
  "title": "مطالعه صفحه ۱۸",
  "start": 18,
  "end": 18
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3122,
  "title": "مطالعه صفحه ۲۲",
  "start": 22,
  "end": 22
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3123,
  "title": "مطالعه صفحه ۲۳",
  "start": 23,
  "end": 23
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3124,
  "title": "مطالعه صفحه ۲۴",
  "start": 24,
  "end": 24
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3125,
  "title": "مطالعه صفحه ۲۵",
  "start": 25,
  "end": 25
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3126,
  "title": "مطالعه صفحه ۲۶",
  "start": 26,
  "end": 26
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3127,
  "title": "مطالعه صفحه ۲۷",
  "start": 27,
  "end": 27
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3128,
  "title": "مطالعه صفحه ۲۸",
  "start": 28,
  "end": 28
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3129,
  "title": "مطالعه صفحه ۲۹",
  "start": 29,
  "end": 29
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3130,
  "title": "مطالعه صفحه ۳۰",
  "start": 30,
  "end": 30
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3131,
  "title": "مطالعه صفحه ۳۱",
  "start": 31,
  "end": 31
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3132,
  "title": "مطالعه صفحه ۳۲",
  "start": 32,
  "end": 32
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3136,
  "title": "مطالعه صفحه ۳۶",
  "start": 36,
  "end": 36
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3137,
  "title": "مطالعه صفحه ۳۷",
  "start": 37,
  "end": 37
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3138,
  "title": "مطالعه صفحه ۳۸",
  "start": 38,
  "end": 38
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3139,
  "title": "مطالعه صفحه ۳۹",
  "start": 39,
  "end": 39
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3140,
  "title": "مطالعه صفحه ۴۰",
  "start": 40,
  "end": 40
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3141,
  "title": "مطالعه صفحه ۴۱",
  "start": 41,
  "end": 41
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3142,
  "title": "مطالعه صفحه ۴۲",
  "start": 42,
  "end": 42
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3143,
  "title": "مطالعه صفحه ۴۳",
  "start": 43,
  "end": 43
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3144,
  "title": "مطالعه صفحه ۴۴",
  "start": 44,
  "end": 44
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3148,
  "title": "مطالعه صفحه ۴۸",
  "start": 48,
  "end": 48
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3149,
  "title": "مطالعه صفحه ۴۹",
  "start": 49,
  "end": 49
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3150,
  "title": "مطالعه صفحه ۵۰",
  "start": 50,
  "end": 50
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3151,
  "title": "مطالعه صفحه ۵۱",
  "start": 51,
  "end": 51
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3152,
  "title": "مطالعه صفحه ۵۲",
  "start": 52,
  "end": 52
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3153,
  "title": "مطالعه صفحه ۵۳",
  "start": 53,
  "end": 53
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3154,
  "title": "مطالعه صفحه ۵۴",
  "start": 54,
  "end": 54
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3155,
  "title": "مطالعه صفحه ۵۵",
  "start": 55,
  "end": 55
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3156,
  "title": "مطالعه صفحه ۵۶",
  "start": 56,
  "end": 56
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3157,
  "title": "مطالعه صفحه ۵۷",
  "start": 57,
  "end": 57
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3158,
  "title": "مطالعه صفحه ۵۸",
  "start": 58,
  "end": 58
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3162,
  "title": "مطالعه صفحه ۶۲",
  "start": 62,
  "end": 62
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3163,
  "title": "مطالعه صفحه ۶۳",
  "start": 63,
  "end": 63
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3164,
  "title": "مطالعه صفحه ۶۴",
  "start": 64,
  "end": 64
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3165,
  "title": "مطالعه صفحه ۶۵",
  "start": 65,
  "end": 65
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3166,
  "title": "مطالعه صفحه ۶۶",
  "start": 66,
  "end": 66
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3167,
  "title": "مطالعه صفحه ۶۷",
  "start": 67,
  "end": 67
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3168,
  "title": "مطالعه صفحه ۶۸",
  "start": 68,
  "end": 68
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3169,
  "title": "مطالعه صفحه ۶۹",
  "start": 69,
  "end": 69
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3170,
  "title": "مطالعه صفحه ۷۰",
  "start": 70,
  "end": 70
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3174,
  "title": "مطالعه صفحه ۷۴",
  "start": 74,
  "end": 74
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3175,
  "title": "مطالعه صفحه ۷۵",
  "start": 75,
  "end": 75
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3176,
  "title": "مطالعه صفحه ۷۶",
  "start": 76,
  "end": 76
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3177,
  "title": "مطالعه صفحه ۷۷",
  "start": 77,
  "end": 77
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3178,
  "title": "مطالعه صفحه ۷۸",
  "start": 78,
  "end": 78
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3179,
  "title": "مطالعه صفحه ۷۹",
  "start": 79,
  "end": 79
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3180,
  "title": "مطالعه صفحه ۸۰",
  "start": 80,
  "end": 80
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3181,
  "title": "مطالعه صفحه ۸۱",
  "start": 81,
  "end": 81
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3182,
  "title": "مطالعه صفحه ۸۲",
  "start": 82,
  "end": 82
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3183,
  "title": "مطالعه صفحه ۸۳",
  "start": 83,
  "end": 83
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3184,
  "title": "مطالعه صفحه ۸۴",
  "start": 84,
  "end": 84
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3188,
  "title": "مطالعه صفحه ۸۸",
  "start": 88,
  "end": 88
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3189,
  "title": "مطالعه صفحه ۸۹",
  "start": 89,
  "end": 89
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3190,
  "title": "مطالعه صفحه ۹۰",
  "start": 90,
  "end": 90
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3191,
  "title": "مطالعه صفحه ۹۱",
  "start": 91,
  "end": 91
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3192,
  "title": "مطالعه صفحه ۹۲",
  "start": 92,
  "end": 92
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3193,
  "title": "مطالعه صفحه ۹۳",
  "start": 93,
  "end": 93
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3194,
  "title": "مطالعه صفحه ۹۴",
  "start": 94,
  "end": 94
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3198,
  "title": "مطالعه صفحه ۹۸",
  "start": 98,
  "end": 98
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3199,
  "title": "مطالعه صفحه ۹۹",
  "start": 99,
  "end": 99
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3200,
  "title": "مطالعه صفحه ۱۰۰",
  "start": 100,
  "end": 100
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3201,
  "title": "مطالعه صفحه ۱۰۱",
  "start": 101,
  "end": 101
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3202,
  "title": "مطالعه صفحه ۱۰۲",
  "start": 102,
  "end": 102
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3203,
  "title": "مطالعه صفحه ۱۰۳",
  "start": 103,
  "end": 103
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3204,
  "title": "مطالعه صفحه ۱۰۴",
  "start": 104,
  "end": 104
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3205,
  "title": "مطالعه صفحه ۱۰۵",
  "start": 105,
  "end": 105
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3206,
  "title": "مطالعه صفحه ۱۰۶",
  "start": 106,
  "end": 106
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3210,
  "title": "مطالعه صفحه ۱۱۰",
  "start": 110,
  "end": 110
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3211,
  "title": "مطالعه صفحه ۱۱۱",
  "start": 111,
  "end": 111
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3212,
  "title": "مطالعه صفحه ۱۱۲",
  "start": 112,
  "end": 112
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3213,
  "title": "مطالعه صفحه ۱۱۳",
  "start": 113,
  "end": 113
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3214,
  "title": "مطالعه صفحه ۱۱۴",
  "start": 114,
  "end": 114
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3215,
  "title": "مطالعه صفحه ۱۱۵",
  "start": 115,
  "end": 115
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3216,
  "title": "مطالعه صفحه ۱۱۶",
  "start": 116,
  "end": 116
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3217,
  "title": "مطالعه صفحه ۱۱۷",
  "start": 117,
  "end": 117
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3218,
  "title": "مطالعه صفحه ۱۱۸",
  "start": 118,
  "end": 118
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3219,
  "title": "مطالعه صفحه ۱۱۹",
  "start": 119,
  "end": 119
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3220,
  "title": "مطالعه صفحه ۱۲۰",
  "start": 120,
  "end": 120
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3224,
  "title": "مطالعه صفحه ۱۲۴",
  "start": 124,
  "end": 124
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3225,
  "title": "مطالعه صفحه ۱۲۵",
  "start": 125,
  "end": 125
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3226,
  "title": "مطالعه صفحه ۱۲۶",
  "start": 126,
  "end": 126
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3227,
  "title": "مطالعه صفحه ۱۲۷",
  "start": 127,
  "end": 127
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3228,
  "title": "مطالعه صفحه ۱۲۸",
  "start": 128,
  "end": 128
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3229,
  "title": "مطالعه صفحه ۱۲۹",
  "start": 129,
  "end": 129
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3230,
  "title": "مطالعه صفحه ۱۳۰",
  "start": 130,
  "end": 130
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3231,
  "title": "مطالعه صفحه ۱۳۱",
  "start": 131,
  "end": 131
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3232,
  "title": "مطالعه صفحه ۱۳۲",
  "start": 132,
  "end": 132
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3233,
  "title": "مطالعه صفحه ۱۳۳",
  "start": 133,
  "end": 133
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3238,
  "title": "مطالعه صفحه ۱۳۸",
  "start": 138,
  "end": 138
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3239,
  "title": "مطالعه صفحه ۱۳۹",
  "start": 139,
  "end": 139
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3240,
  "title": "مطالعه صفحه ۱۴۰",
  "start": 140,
  "end": 140
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3241,
  "title": "مطالعه صفحه ۱۴۱",
  "start": 141,
  "end": 141
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3242,
  "title": "مطالعه صفحه ۱۴۲",
  "start": 142,
  "end": 142
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3243,
  "title": "مطالعه صفحه ۱۴۳",
  "start": 143,
  "end": 143
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3244,
  "title": "مطالعه صفحه ۱۴۴",
  "start": 144,
  "end": 144
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3248,
  "title": "مطالعه صفحه ۱۴۸",
  "start": 148,
  "end": 148
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3249,
  "title": "مطالعه صفحه ۱۴۹",
  "start": 149,
  "end": 149
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3250,
  "title": "مطالعه صفحه ۱۵۰",
  "start": 150,
  "end": 150
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3251,
  "title": "مطالعه صفحه ۱۵۱",
  "start": 151,
  "end": 151
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3252,
  "title": "مطالعه صفحه ۱۵۲",
  "start": 152,
  "end": 152
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3253,
  "title": "مطالعه صفحه ۱۵۳",
  "start": 153,
  "end": 153
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3254,
  "title": "مطالعه صفحه ۱۵۴",
  "start": 154,
  "end": 154
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3255,
  "title": "مطالعه صفحه ۱۵۵",
  "start": 155,
  "end": 155
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3256,
  "title": "مطالعه صفحه ۱۵۶",
  "start": 156,
  "end": 156
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3257,
  "title": "مطالعه صفحه ۱۵۷",
  "start": 157,
  "end": 157
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3258,
  "title": "مطالعه صفحه ۱۵۸",
  "start": 158,
  "end": 158
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3106,
  "title": "مطالعه صفحه ۶",
  "start": 6,
  "end": 6
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3107,
  "title": "مطالعه صفحه ۷",
  "start": 7,
  "end": 7
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3108,
  "title": "مطالعه صفحه ۸",
  "start": 8,
  "end": 8
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3109,
  "title": "مطالعه صفحه ۹",
  "start": 9,
  "end": 9
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3110,
  "title": "مطالعه صفحه ۱۰",
  "start": 10,
  "end": 10
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3111,
  "title": "مطالعه صفحه ۱۱",
  "start": 11,
  "end": 11
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3112,
  "title": "مطالعه صفحه ۱۲",
  "start": 12,
  "end": 12
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3113,
  "title": "مطالعه صفحه ۱۳",
  "start": 13,
  "end": 13
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3114,
  "title": "مطالعه صفحه ۱۴",
  "start": 14,
  "end": 14
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3118,
  "title": "مطالعه صفحه ۱۸",
  "start": 18,
  "end": 18
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3119,
  "title": "مطالعه صفحه ۱۹",
  "start": 19,
  "end": 19
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3120,
  "title": "مطالعه صفحه ۲۰",
  "start": 20,
  "end": 20
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3121,
  "title": "مطالعه صفحه ۲۱",
  "start": 21,
  "end": 21
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3122,
  "title": "مطالعه صفحه ۲۲",
  "start": 22,
  "end": 22
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3123,
  "title": "مطالعه صفحه ۲۳",
  "start": 23,
  "end": 23
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3124,
  "title": "مطالعه صفحه ۲۴",
  "start": 24,
  "end": 24
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3125,
  "title": "مطالعه صفحه ۲۵",
  "start": 25,
  "end": 25
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3126,
  "title": "مطالعه صفحه ۲۶",
  "start": 26,
  "end": 26
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3130,
  "title": "مطالعه صفحه ۳۰",
  "start": 30,
  "end": 30
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3131,
  "title": "مطالعه صفحه ۳۱",
  "start": 31,
  "end": 31
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3132,
  "title": "مطالعه صفحه ۳۲",
  "start": 32,
  "end": 32
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3133,
  "title": "مطالعه صفحه ۳۳",
  "start": 33,
  "end": 33
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3134,
  "title": "مطالعه صفحه ۳۴",
  "start": 34,
  "end": 34
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3135,
  "title": "مطالعه صفحه ۳۵",
  "start": 35,
  "end": 35
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3136,
  "title": "مطالعه صفحه ۳۶",
  "start": 36,
  "end": 36
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3137,
  "title": "مطالعه صفحه ۳۷",
  "start": 37,
  "end": 37
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3138,
  "title": "مطالعه صفحه ۳۸",
  "start": 38,
  "end": 38
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3142,
  "title": "مطالعه صفحه ۴۲",
  "start": 42,
  "end": 42
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3143,
  "title": "مطالعه صفحه ۴۳",
  "start": 43,
  "end": 43
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3144,
  "title": "مطالعه صفحه ۴۴",
  "start": 44,
  "end": 44
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3145,
  "title": "مطالعه صفحه ۴۵",
  "start": 45,
  "end": 45
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3146,
  "title": "مطالعه صفحه ۴۶",
  "start": 46,
  "end": 46
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3147,
  "title": "مطالعه صفحه ۴۷",
  "start": 47,
  "end": 47
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3148,
  "title": "مطالعه صفحه ۴۸",
  "start": 48,
  "end": 48
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3152,
  "title": "مطالعه صفحه ۵۲",
  "start": 52,
  "end": 52
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3153,
  "title": "مطالعه صفحه ۵۳",
  "start": 53,
  "end": 53
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3154,
  "title": "مطالعه صفحه ۵۴",
  "start": 54,
  "end": 54
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3155,
  "title": "مطالعه صفحه ۵۵",
  "start": 55,
  "end": 55
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3156,
  "title": "مطالعه صفحه ۵۶",
  "start": 56,
  "end": 56
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3157,
  "title": "مطالعه صفحه ۵۷",
  "start": 57,
  "end": 57
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3158,
  "title": "مطالعه صفحه ۵۸",
  "start": 58,
  "end": 58
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3159,
  "title": "مطالعه صفحه ۵۹",
  "start": 59,
  "end": 59
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3160,
  "title": "مطالعه صفحه ۶۰",
  "start": 60,
  "end": 60
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3164,
  "title": "مطالعه صفحه ۶۴",
  "start": 64,
  "end": 64
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3165,
  "title": "مطالعه صفحه ۶۵",
  "start": 65,
  "end": 65
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3166,
  "title": "مطالعه صفحه ۶۶",
  "start": 66,
  "end": 66
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3167,
  "title": "مطالعه صفحه ۶۷",
  "start": 67,
  "end": 67
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3168,
  "title": "مطالعه صفحه ۶۸",
  "start": 68,
  "end": 68
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3169,
  "title": "مطالعه صفحه ۶۹",
  "start": 69,
  "end": 69
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3170,
  "title": "مطالعه صفحه ۷۰",
  "start": 70,
  "end": 70
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3171,
  "title": "مطالعه صفحه ۷۱",
  "start": 71,
  "end": 71
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3172,
  "title": "مطالعه صفحه ۷۲",
  "start": 72,
  "end": 72
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3173,
  "title": "مطالعه صفحه ۷۳",
  "start": 73,
  "end": 73
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3174,
  "title": "مطالعه صفحه ۷۴",
  "start": 74,
  "end": 74
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3180,
  "title": "مطالعه صفحه ۸۰",
  "start": 80,
  "end": 80
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3181,
  "title": "مطالعه صفحه ۸۱",
  "start": 81,
  "end": 81
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3182,
  "title": "مطالعه صفحه ۸۲",
  "start": 82,
  "end": 82
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3183,
  "title": "مطالعه صفحه ۸۳",
  "start": 83,
  "end": 83
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3184,
  "title": "مطالعه صفحه ۸۴",
  "start": 84,
  "end": 84
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3185,
  "title": "مطالعه صفحه ۸۵",
  "start": 85,
  "end": 85
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3186,
  "title": "مطالعه صفحه ۸۶",
  "start": 86,
  "end": 86
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3187,
  "title": "مطالعه صفحه ۸۷",
  "start": 87,
  "end": 87
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3188,
  "title": "مطالعه صفحه ۸۸",
  "start": 88,
  "end": 88
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3189,
  "title": "مطالعه صفحه ۸۹",
  "start": 89,
  "end": 89
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3190,
  "title": "مطالعه صفحه ۹۰",
  "start": 90,
  "end": 90
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3194,
  "title": "مطالعه صفحه ۹۴",
  "start": 94,
  "end": 94
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3195,
  "title": "مطالعه صفحه ۹۵",
  "start": 95,
  "end": 95
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3196,
  "title": "مطالعه صفحه ۹۶",
  "start": 96,
  "end": 96
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3197,
  "title": "مطالعه صفحه ۹۷",
  "start": 97,
  "end": 97
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3198,
  "title": "مطالعه صفحه ۹۸",
  "start": 98,
  "end": 98
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3199,
  "title": "مطالعه صفحه ۹۹",
  "start": 99,
  "end": 99
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3200,
  "title": "مطالعه صفحه ۱۰۰",
  "start": 100,
  "end": 100
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3201,
  "title": "مطالعه صفحه ۱۰۱",
  "start": 101,
  "end": 101
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3202,
  "title": "مطالعه صفحه ۱۰۲",
  "start": 102,
  "end": 102
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3203,
  "title": "مطالعه صفحه ۱۰۳",
  "start": 103,
  "end": 103
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3204,
  "title": "مطالعه صفحه ۱۰۴",
  "start": 104,
  "end": 104
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3208,
  "title": "مطالعه صفحه ۱۰۸",
  "start": 108,
  "end": 108
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3209,
  "title": "مطالعه صفحه ۱۰۹",
  "start": 109,
  "end": 109
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3210,
  "title": "مطالعه صفحه ۱۱۰",
  "start": 110,
  "end": 110
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3211,
  "title": "مطالعه صفحه ۱۱۱",
  "start": 111,
  "end": 111
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3212,
  "title": "مطالعه صفحه ۱۱۲",
  "start": 112,
  "end": 112
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3213,
  "title": "مطالعه صفحه ۱۱۳",
  "start": 113,
  "end": 113
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3214,
  "title": "مطالعه صفحه ۱۱۴",
  "start": 114,
  "end": 114
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3215,
  "title": "مطالعه صفحه ۱۱۵",
  "start": 115,
  "end": 115
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3216,
  "title": "مطالعه صفحه ۱۱۶",
  "start": 116,
  "end": 116
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3217,
  "title": "مطالعه صفحه ۱۱۷",
  "start": 117,
  "end": 117
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3218,
  "title": "مطالعه صفحه ۱۱۸",
  "start": 118,
  "end": 118
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3219,
  "title": "مطالعه صفحه ۱۱۹",
  "start": 119,
  "end": 119
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3220,
  "title": "مطالعه صفحه ۱۲۰",
  "start": 120,
  "end": 120
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3221,
  "title": "مطالعه صفحه ۱۲۱",
  "start": 121,
  "end": 121
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3222,
  "title": "مطالعه صفحه ۱۲۲",
  "start": 122,
  "end": 122
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3226,
  "title": "مطالعه صفحه ۱۲۶",
  "start": 126,
  "end": 126
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3227,
  "title": "مطالعه صفحه ۱۲۷",
  "start": 127,
  "end": 127
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3228,
  "title": "مطالعه صفحه ۱۲۸",
  "start": 128,
  "end": 128
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3229,
  "title": "مطالعه صفحه ۱۲۹",
  "start": 129,
  "end": 129
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3230,
  "title": "مطالعه صفحه ۱۳۰",
  "start": 130,
  "end": 130
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3231,
  "title": "مطالعه صفحه ۱۳۱",
  "start": 131,
  "end": 131
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3232,
  "title": "مطالعه صفحه ۱۳۲",
  "start": 132,
  "end": 132
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3233,
  "title": "مطالعه صفحه ۱۳۳",
  "start": 133,
  "end": 133
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3234,
  "title": "مطالعه صفحه ۱۳۴",
  "start": 134,
  "end": 134
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3235,
  "title": "مطالعه صفحه ۱۳۵",
  "start": 135,
  "end": 135
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3236,
  "title": "مطالعه صفحه ۱۳۶",
  "start": 136,
  "end": 136
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3112,
  "title": "مطالعه صفحه ۱۲",
  "start": 12,
  "end": 12
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3113,
  "title": "مطالعه صفحه ۱۳",
  "start": 13,
  "end": 13
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3114,
  "title": "مطالعه صفحه ۱۴",
  "start": 14,
  "end": 14
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3115,
  "title": "مطالعه صفحه ۱۵",
  "start": 15,
  "end": 15
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3116,
  "title": "مطالعه صفحه ۱۶",
  "start": 16,
  "end": 16
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3117,
  "title": "مطالعه صفحه ۱۷",
  "start": 17,
  "end": 17
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱: هدایت الهی",
  "position": 3118,
  "title": "مطالعه صفحه ۱۸",
  "start": 18,
  "end": 18
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3122,
  "title": "مطالعه صفحه ۲۲",
  "start": 22,
  "end": 22
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3123,
  "title": "مطالعه صفحه ۲۳",
  "start": 23,
  "end": 23
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3124,
  "title": "مطالعه صفحه ۲۴",
  "start": 24,
  "end": 24
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3125,
  "title": "مطالعه صفحه ۲۵",
  "start": 25,
  "end": 25
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3126,
  "title": "مطالعه صفحه ۲۶",
  "start": 26,
  "end": 26
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3127,
  "title": "مطالعه صفحه ۲۷",
  "start": 27,
  "end": 27
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3128,
  "title": "مطالعه صفحه ۲۸",
  "start": 28,
  "end": 28
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3129,
  "title": "مطالعه صفحه ۲۹",
  "start": 29,
  "end": 29
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3130,
  "title": "مطالعه صفحه ۳۰",
  "start": 30,
  "end": 30
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3131,
  "title": "مطالعه صفحه ۳۱",
  "start": 31,
  "end": 31
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۲: تداوم هدایت",
  "position": 3132,
  "title": "مطالعه صفحه ۳۲",
  "start": 32,
  "end": 32
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3136,
  "title": "مطالعه صفحه ۳۶",
  "start": 36,
  "end": 36
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3137,
  "title": "مطالعه صفحه ۳۷",
  "start": 37,
  "end": 37
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3138,
  "title": "مطالعه صفحه ۳۸",
  "start": 38,
  "end": 38
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3139,
  "title": "مطالعه صفحه ۳۹",
  "start": 39,
  "end": 39
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3140,
  "title": "مطالعه صفحه ۴۰",
  "start": 40,
  "end": 40
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3141,
  "title": "مطالعه صفحه ۴۱",
  "start": 41,
  "end": 41
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3142,
  "title": "مطالعه صفحه ۴۲",
  "start": 42,
  "end": 42
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3143,
  "title": "مطالعه صفحه ۴۳",
  "start": 43,
  "end": 43
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۳: معجزه جاویدان",
  "position": 3144,
  "title": "مطالعه صفحه ۴۴",
  "start": 44,
  "end": 44
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3148,
  "title": "مطالعه صفحه ۴۸",
  "start": 48,
  "end": 48
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3149,
  "title": "مطالعه صفحه ۴۹",
  "start": 49,
  "end": 49
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3150,
  "title": "مطالعه صفحه ۵۰",
  "start": 50,
  "end": 50
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3151,
  "title": "مطالعه صفحه ۵۱",
  "start": 51,
  "end": 51
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3152,
  "title": "مطالعه صفحه ۵۲",
  "start": 52,
  "end": 52
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3153,
  "title": "مطالعه صفحه ۵۳",
  "start": 53,
  "end": 53
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3154,
  "title": "مطالعه صفحه ۵۴",
  "start": 54,
  "end": 54
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3155,
  "title": "مطالعه صفحه ۵۵",
  "start": 55,
  "end": 55
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3156,
  "title": "مطالعه صفحه ۵۶",
  "start": 56,
  "end": 56
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3157,
  "title": "مطالعه صفحه ۵۷",
  "start": 57,
  "end": 57
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "position": 3158,
  "title": "مطالعه صفحه ۵۸",
  "start": 58,
  "end": 58
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3162,
  "title": "مطالعه صفحه ۶۲",
  "start": 62,
  "end": 62
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3163,
  "title": "مطالعه صفحه ۶۳",
  "start": 63,
  "end": 63
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3164,
  "title": "مطالعه صفحه ۶۴",
  "start": 64,
  "end": 64
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3165,
  "title": "مطالعه صفحه ۶۵",
  "start": 65,
  "end": 65
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3166,
  "title": "مطالعه صفحه ۶۶",
  "start": 66,
  "end": 66
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3167,
  "title": "مطالعه صفحه ۶۷",
  "start": 67,
  "end": 67
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3168,
  "title": "مطالعه صفحه ۶۸",
  "start": 68,
  "end": 68
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3169,
  "title": "مطالعه صفحه ۶۹",
  "start": 69,
  "end": 69
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "position": 3170,
  "title": "مطالعه صفحه ۷۰",
  "start": 70,
  "end": 70
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3174,
  "title": "مطالعه صفحه ۷۴",
  "start": 74,
  "end": 74
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3175,
  "title": "مطالعه صفحه ۷۵",
  "start": 75,
  "end": 75
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3176,
  "title": "مطالعه صفحه ۷۶",
  "start": 76,
  "end": 76
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3177,
  "title": "مطالعه صفحه ۷۷",
  "start": 77,
  "end": 77
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3178,
  "title": "مطالعه صفحه ۷۸",
  "start": 78,
  "end": 78
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3179,
  "title": "مطالعه صفحه ۷۹",
  "start": 79,
  "end": 79
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3180,
  "title": "مطالعه صفحه ۸۰",
  "start": 80,
  "end": 80
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3181,
  "title": "مطالعه صفحه ۸۱",
  "start": 81,
  "end": 81
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3182,
  "title": "مطالعه صفحه ۸۲",
  "start": 82,
  "end": 82
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3183,
  "title": "مطالعه صفحه ۸۳",
  "start": 83,
  "end": 83
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۶: پیشوایان اسوه",
  "position": 3184,
  "title": "مطالعه صفحه ۸۴",
  "start": 84,
  "end": 84
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3188,
  "title": "مطالعه صفحه ۸۸",
  "start": 88,
  "end": 88
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3189,
  "title": "مطالعه صفحه ۸۹",
  "start": 89,
  "end": 89
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3190,
  "title": "مطالعه صفحه ۹۰",
  "start": 90,
  "end": 90
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3191,
  "title": "مطالعه صفحه ۹۱",
  "start": 91,
  "end": 91
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3192,
  "title": "مطالعه صفحه ۹۲",
  "start": 92,
  "end": 92
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3193,
  "title": "مطالعه صفحه ۹۳",
  "start": 93,
  "end": 93
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "position": 3194,
  "title": "مطالعه صفحه ۹۴",
  "start": 94,
  "end": 94
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3198,
  "title": "مطالعه صفحه ۹۸",
  "start": 98,
  "end": 98
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3199,
  "title": "مطالعه صفحه ۹۹",
  "start": 99,
  "end": 99
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3200,
  "title": "مطالعه صفحه ۱۰۰",
  "start": 100,
  "end": 100
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3201,
  "title": "مطالعه صفحه ۱۰۱",
  "start": 101,
  "end": 101
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3202,
  "title": "مطالعه صفحه ۱۰۲",
  "start": 102,
  "end": 102
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3203,
  "title": "مطالعه صفحه ۱۰۳",
  "start": 103,
  "end": 103
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3204,
  "title": "مطالعه صفحه ۱۰۴",
  "start": 104,
  "end": 104
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3205,
  "title": "مطالعه صفحه ۱۰۵",
  "start": 105,
  "end": 105
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "position": 3206,
  "title": "مطالعه صفحه ۱۰۶",
  "start": 106,
  "end": 106
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3210,
  "title": "مطالعه صفحه ۱۱۰",
  "start": 110,
  "end": 110
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3211,
  "title": "مطالعه صفحه ۱۱۱",
  "start": 111,
  "end": 111
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3212,
  "title": "مطالعه صفحه ۱۱۲",
  "start": 112,
  "end": 112
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3213,
  "title": "مطالعه صفحه ۱۱۳",
  "start": 113,
  "end": 113
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3214,
  "title": "مطالعه صفحه ۱۱۴",
  "start": 114,
  "end": 114
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3215,
  "title": "مطالعه صفحه ۱۱۵",
  "start": 115,
  "end": 115
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3216,
  "title": "مطالعه صفحه ۱۱۶",
  "start": 116,
  "end": 116
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3217,
  "title": "مطالعه صفحه ۱۱۷",
  "start": 117,
  "end": 117
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3218,
  "title": "مطالعه صفحه ۱۱۸",
  "start": 118,
  "end": 118
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3219,
  "title": "مطالعه صفحه ۱۱۹",
  "start": 119,
  "end": 119
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۹: عصر غیبت",
  "position": 3220,
  "title": "مطالعه صفحه ۱۲۰",
  "start": 120,
  "end": 120
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3224,
  "title": "مطالعه صفحه ۱۲۴",
  "start": 124,
  "end": 124
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3225,
  "title": "مطالعه صفحه ۱۲۵",
  "start": 125,
  "end": 125
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3226,
  "title": "مطالعه صفحه ۱۲۶",
  "start": 126,
  "end": 126
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3227,
  "title": "مطالعه صفحه ۱۲۷",
  "start": 127,
  "end": 127
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3228,
  "title": "مطالعه صفحه ۱۲۸",
  "start": 128,
  "end": 128
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3229,
  "title": "مطالعه صفحه ۱۲۹",
  "start": 129,
  "end": 129
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3230,
  "title": "مطالعه صفحه ۱۳۰",
  "start": 130,
  "end": 130
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3231,
  "title": "مطالعه صفحه ۱۳۱",
  "start": 131,
  "end": 131
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3232,
  "title": "مطالعه صفحه ۱۳۲",
  "start": 132,
  "end": 132
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "position": 3233,
  "title": "مطالعه صفحه ۱۳۳",
  "start": 133,
  "end": 133
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3238,
  "title": "مطالعه صفحه ۱۳۸",
  "start": 138,
  "end": 138
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3239,
  "title": "مطالعه صفحه ۱۳۹",
  "start": 139,
  "end": 139
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3240,
  "title": "مطالعه صفحه ۱۴۰",
  "start": 140,
  "end": 140
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3241,
  "title": "مطالعه صفحه ۱۴۱",
  "start": 141,
  "end": 141
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3242,
  "title": "مطالعه صفحه ۱۴۲",
  "start": 142,
  "end": 142
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3243,
  "title": "مطالعه صفحه ۱۴۳",
  "start": 143,
  "end": 143
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۱: عزت نفس",
  "position": 3244,
  "title": "مطالعه صفحه ۱۴۴",
  "start": 144,
  "end": 144
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3248,
  "title": "مطالعه صفحه ۱۴۸",
  "start": 148,
  "end": 148
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3249,
  "title": "مطالعه صفحه ۱۴۹",
  "start": 149,
  "end": 149
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3250,
  "title": "مطالعه صفحه ۱۵۰",
  "start": 150,
  "end": 150
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3251,
  "title": "مطالعه صفحه ۱۵۱",
  "start": 151,
  "end": 151
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3252,
  "title": "مطالعه صفحه ۱۵۲",
  "start": 152,
  "end": 152
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3253,
  "title": "مطالعه صفحه ۱۵۳",
  "start": 153,
  "end": 153
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3254,
  "title": "مطالعه صفحه ۱۵۴",
  "start": 154,
  "end": 154
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3255,
  "title": "مطالعه صفحه ۱۵۵",
  "start": 155,
  "end": 155
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3256,
  "title": "مطالعه صفحه ۱۵۶",
  "start": 156,
  "end": 156
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3257,
  "title": "مطالعه صفحه ۱۵۷",
  "start": 157,
  "end": 157
 },
 {
  "field": "experimental_sciences",
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "chapter": "درس ۱۲: پیوند مقدس",
  "position": 3258,
  "title": "مطالعه صفحه ۱۵۸",
  "start": 158,
  "end": 158
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3106,
  "title": "مطالعه صفحه ۶",
  "start": 6,
  "end": 6
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3107,
  "title": "مطالعه صفحه ۷",
  "start": 7,
  "end": 7
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3108,
  "title": "مطالعه صفحه ۸",
  "start": 8,
  "end": 8
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3109,
  "title": "مطالعه صفحه ۹",
  "start": 9,
  "end": 9
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3110,
  "title": "مطالعه صفحه ۱۰",
  "start": 10,
  "end": 10
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3111,
  "title": "مطالعه صفحه ۱۱",
  "start": 11,
  "end": 11
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3112,
  "title": "مطالعه صفحه ۱۲",
  "start": 12,
  "end": 12
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3113,
  "title": "مطالعه صفحه ۱۳",
  "start": 13,
  "end": 13
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱",
  "position": 3114,
  "title": "مطالعه صفحه ۱۴",
  "start": 14,
  "end": 14
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3118,
  "title": "مطالعه صفحه ۱۸",
  "start": 18,
  "end": 18
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3119,
  "title": "مطالعه صفحه ۱۹",
  "start": 19,
  "end": 19
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3120,
  "title": "مطالعه صفحه ۲۰",
  "start": 20,
  "end": 20
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3121,
  "title": "مطالعه صفحه ۲۱",
  "start": 21,
  "end": 21
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3122,
  "title": "مطالعه صفحه ۲۲",
  "start": 22,
  "end": 22
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3123,
  "title": "مطالعه صفحه ۲۳",
  "start": 23,
  "end": 23
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3124,
  "title": "مطالعه صفحه ۲۴",
  "start": 24,
  "end": 24
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3125,
  "title": "مطالعه صفحه ۲۵",
  "start": 25,
  "end": 25
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۲",
  "position": 3126,
  "title": "مطالعه صفحه ۲۶",
  "start": 26,
  "end": 26
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3130,
  "title": "مطالعه صفحه ۳۰",
  "start": 30,
  "end": 30
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3131,
  "title": "مطالعه صفحه ۳۱",
  "start": 31,
  "end": 31
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3132,
  "title": "مطالعه صفحه ۳۲",
  "start": 32,
  "end": 32
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3133,
  "title": "مطالعه صفحه ۳۳",
  "start": 33,
  "end": 33
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3134,
  "title": "مطالعه صفحه ۳۴",
  "start": 34,
  "end": 34
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3135,
  "title": "مطالعه صفحه ۳۵",
  "start": 35,
  "end": 35
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3136,
  "title": "مطالعه صفحه ۳۶",
  "start": 36,
  "end": 36
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3137,
  "title": "مطالعه صفحه ۳۷",
  "start": 37,
  "end": 37
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۳",
  "position": 3138,
  "title": "مطالعه صفحه ۳۸",
  "start": 38,
  "end": 38
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3142,
  "title": "مطالعه صفحه ۴۲",
  "start": 42,
  "end": 42
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3143,
  "title": "مطالعه صفحه ۴۳",
  "start": 43,
  "end": 43
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3144,
  "title": "مطالعه صفحه ۴۴",
  "start": 44,
  "end": 44
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3145,
  "title": "مطالعه صفحه ۴۵",
  "start": 45,
  "end": 45
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3146,
  "title": "مطالعه صفحه ۴۶",
  "start": 46,
  "end": 46
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3147,
  "title": "مطالعه صفحه ۴۷",
  "start": 47,
  "end": 47
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۴",
  "position": 3148,
  "title": "مطالعه صفحه ۴۸",
  "start": 48,
  "end": 48
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3152,
  "title": "مطالعه صفحه ۵۲",
  "start": 52,
  "end": 52
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3153,
  "title": "مطالعه صفحه ۵۳",
  "start": 53,
  "end": 53
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3154,
  "title": "مطالعه صفحه ۵۴",
  "start": 54,
  "end": 54
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3155,
  "title": "مطالعه صفحه ۵۵",
  "start": 55,
  "end": 55
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3156,
  "title": "مطالعه صفحه ۵۶",
  "start": 56,
  "end": 56
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3157,
  "title": "مطالعه صفحه ۵۷",
  "start": 57,
  "end": 57
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3158,
  "title": "مطالعه صفحه ۵۸",
  "start": 58,
  "end": 58
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3159,
  "title": "مطالعه صفحه ۵۹",
  "start": 59,
  "end": 59
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۵",
  "position": 3160,
  "title": "مطالعه صفحه ۶۰",
  "start": 60,
  "end": 60
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3164,
  "title": "مطالعه صفحه ۶۴",
  "start": 64,
  "end": 64
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3165,
  "title": "مطالعه صفحه ۶۵",
  "start": 65,
  "end": 65
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3166,
  "title": "مطالعه صفحه ۶۶",
  "start": 66,
  "end": 66
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3167,
  "title": "مطالعه صفحه ۶۷",
  "start": 67,
  "end": 67
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3168,
  "title": "مطالعه صفحه ۶۸",
  "start": 68,
  "end": 68
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3169,
  "title": "مطالعه صفحه ۶۹",
  "start": 69,
  "end": 69
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3170,
  "title": "مطالعه صفحه ۷۰",
  "start": 70,
  "end": 70
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3171,
  "title": "مطالعه صفحه ۷۱",
  "start": 71,
  "end": 71
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3172,
  "title": "مطالعه صفحه ۷۲",
  "start": 72,
  "end": 72
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3173,
  "title": "مطالعه صفحه ۷۳",
  "start": 73,
  "end": 73
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۶",
  "position": 3174,
  "title": "مطالعه صفحه ۷۴",
  "start": 74,
  "end": 74
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3180,
  "title": "مطالعه صفحه ۸۰",
  "start": 80,
  "end": 80
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3181,
  "title": "مطالعه صفحه ۸۱",
  "start": 81,
  "end": 81
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3182,
  "title": "مطالعه صفحه ۸۲",
  "start": 82,
  "end": 82
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3183,
  "title": "مطالعه صفحه ۸۳",
  "start": 83,
  "end": 83
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3184,
  "title": "مطالعه صفحه ۸۴",
  "start": 84,
  "end": 84
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3185,
  "title": "مطالعه صفحه ۸۵",
  "start": 85,
  "end": 85
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3186,
  "title": "مطالعه صفحه ۸۶",
  "start": 86,
  "end": 86
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3187,
  "title": "مطالعه صفحه ۸۷",
  "start": 87,
  "end": 87
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3188,
  "title": "مطالعه صفحه ۸۸",
  "start": 88,
  "end": 88
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3189,
  "title": "مطالعه صفحه ۸۹",
  "start": 89,
  "end": 89
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۷",
  "position": 3190,
  "title": "مطالعه صفحه ۹۰",
  "start": 90,
  "end": 90
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3194,
  "title": "مطالعه صفحه ۹۴",
  "start": 94,
  "end": 94
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3195,
  "title": "مطالعه صفحه ۹۵",
  "start": 95,
  "end": 95
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3196,
  "title": "مطالعه صفحه ۹۶",
  "start": 96,
  "end": 96
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3197,
  "title": "مطالعه صفحه ۹۷",
  "start": 97,
  "end": 97
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3198,
  "title": "مطالعه صفحه ۹۸",
  "start": 98,
  "end": 98
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3199,
  "title": "مطالعه صفحه ۹۹",
  "start": 99,
  "end": 99
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3200,
  "title": "مطالعه صفحه ۱۰۰",
  "start": 100,
  "end": 100
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3201,
  "title": "مطالعه صفحه ۱۰۱",
  "start": 101,
  "end": 101
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3202,
  "title": "مطالعه صفحه ۱۰۲",
  "start": 102,
  "end": 102
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3203,
  "title": "مطالعه صفحه ۱۰۳",
  "start": 103,
  "end": 103
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۸",
  "position": 3204,
  "title": "مطالعه صفحه ۱۰۴",
  "start": 104,
  "end": 104
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3208,
  "title": "مطالعه صفحه ۱۰۸",
  "start": 108,
  "end": 108
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3209,
  "title": "مطالعه صفحه ۱۰۹",
  "start": 109,
  "end": 109
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3210,
  "title": "مطالعه صفحه ۱۱۰",
  "start": 110,
  "end": 110
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3211,
  "title": "مطالعه صفحه ۱۱۱",
  "start": 111,
  "end": 111
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3212,
  "title": "مطالعه صفحه ۱۱۲",
  "start": 112,
  "end": 112
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3213,
  "title": "مطالعه صفحه ۱۱۳",
  "start": 113,
  "end": 113
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3214,
  "title": "مطالعه صفحه ۱۱۴",
  "start": 114,
  "end": 114
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3215,
  "title": "مطالعه صفحه ۱۱۵",
  "start": 115,
  "end": 115
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3216,
  "title": "مطالعه صفحه ۱۱۶",
  "start": 116,
  "end": 116
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3217,
  "title": "مطالعه صفحه ۱۱۷",
  "start": 117,
  "end": 117
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3218,
  "title": "مطالعه صفحه ۱۱۸",
  "start": 118,
  "end": 118
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3219,
  "title": "مطالعه صفحه ۱۱۹",
  "start": 119,
  "end": 119
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3220,
  "title": "مطالعه صفحه ۱۲۰",
  "start": 120,
  "end": 120
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3221,
  "title": "مطالعه صفحه ۱۲۱",
  "start": 121,
  "end": 121
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۹",
  "position": 3222,
  "title": "مطالعه صفحه ۱۲۲",
  "start": 122,
  "end": 122
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3226,
  "title": "مطالعه صفحه ۱۲۶",
  "start": 126,
  "end": 126
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3227,
  "title": "مطالعه صفحه ۱۲۷",
  "start": 127,
  "end": 127
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3228,
  "title": "مطالعه صفحه ۱۲۸",
  "start": 128,
  "end": 128
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3229,
  "title": "مطالعه صفحه ۱۲۹",
  "start": 129,
  "end": 129
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3230,
  "title": "مطالعه صفحه ۱۳۰",
  "start": 130,
  "end": 130
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3231,
  "title": "مطالعه صفحه ۱۳۱",
  "start": 131,
  "end": 131
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3232,
  "title": "مطالعه صفحه ۱۳۲",
  "start": 132,
  "end": 132
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3233,
  "title": "مطالعه صفحه ۱۳۳",
  "start": 133,
  "end": 133
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3234,
  "title": "مطالعه صفحه ۱۳۴",
  "start": 134,
  "end": 134
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3235,
  "title": "مطالعه صفحه ۱۳۵",
  "start": 135,
  "end": 135
 },
 {
  "field": "experimental_sciences",
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
  "chapter": "درس ۱۰",
  "position": 3236,
  "title": "مطالعه صفحه ۱۳۶",
  "start": 136,
  "end": 136
 }
]$topics$::jsonb)
 as p(field text,grade text,subject text,chapter text,position integer,title text,start integer,"end" integer))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v247:'||p.field||':'||p.grade||':final_exam:'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,'final_exam',p.subject,p.chapter,p.title,p.start,p."end",p.position
from topics p cross join installed on conflict(id) do nothing;
