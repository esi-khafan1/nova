-- Batch 6 audit (migration 236): books #51-60 checked against the user's 1405 PDFs.
-- Pattern B fills the 65 pristine NULL-page study-group rows for علوم تجربی ۹
-- (migration 139, v1 ids) with printed ranges verified against the PDF text; the
-- ranges follow the finer 211 subtopics, so overlapping group ranges are intended
-- (e.g. فصل ۴ تندی/سرعت, فصل ۵ قانون‌های نیوتن, فصل ۱۵ بوم‌سازگان/زنجیره غذایی).
-- Pattern A adds, insert-only with a one-time install marker: ستایش and نیایش
-- rows for نگارش ۱/۲/۳ (the نگارش family already rows ستایش/نیایش in 220 and 228);
-- corrected whole-lesson rows for نگارش ۳, whose 172 whole-lesson rows each end one
-- page short of the lesson's closing مثل‌نویسی/شعرگردانی/حکایت‌نگاری page (the old
-- rows are left untouched, migration 161 / batch-3 ketabnameh precedent); and the
-- periodic-table appendix for علوم تجربی ۹ (فصل ۱۵, printed pp.174-175).
-- No new rows for نگارش ۹, علوم و فنون ادبی ۱/۲/۳, پیام‌های آسمان ۹ or روان‌شناسی:
-- their lessons, subtopics, exercises and activities were verified against the
-- PDFs and are already covered with correct printed pages. Front matter
-- (پیشگفتار, فهرست), فصل/lesson divider and blank pages, منابع/کتابنامه and
-- نظرسنجی pages are left without rows, as in audit batches 1-2; نگارش ۱۲ منابع
-- p.106 and blank p.107 are not exercise rows. The «شرح» splits in علوم و فنون
-- (migration 200) and the same-title/same-range duplicates in روان‌شناسی
-- (migrations 138/182/217) are kept, not deleted; see batch-6 evidence.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "فصل ۱: مواد و نقش آنها در زندگی",
  "title": "مواد فلزی و کاربرد فلزها",
  "position": 1,
  "start": 2,
  "end": 2
 },
 {
  "chapter": "فصل ۱: مواد و نقش آنها در زندگی",
  "title": "واکنش‌پذیری فلزها",
  "position": 2,
  "start": 3,
  "end": 3
 },
 {
  "chapter": "فصل ۱: مواد و نقش آنها در زندگی",
  "title": "نافلزها و نقش آنها در مواد",
  "position": 3,
  "start": 4,
  "end": 6
 },
 {
  "chapter": "فصل ۱: مواد و نقش آنها در زندگی",
  "title": "بسپارهای طبیعی و مصنوعی",
  "position": 4,
  "start": 9,
  "end": 12
 },
 {
  "chapter": "فصل ۱: مواد و نقش آنها در زندگی",
  "title": "بازگردانی پلاستیک‌ها",
  "position": 5,
  "start": 11,
  "end": 12
 },
 {
  "chapter": "فصل ۲: رفتار اتم‌ها با یکدیگر",
  "title": "ذره‌های سازنده مواد",
  "position": 1,
  "start": 14,
  "end": 16
 },
 {
  "chapter": "فصل ۲: رفتار اتم‌ها با یکدیگر",
  "title": "داد و ستد الکترون و پیوند یونی",
  "position": 2,
  "start": 17,
  "end": 19
 },
 {
  "chapter": "فصل ۲: رفتار اتم‌ها با یکدیگر",
  "title": "یون‌ها در بدن ما",
  "position": 3,
  "start": 20,
  "end": 21
 },
 {
  "chapter": "فصل ۲: رفتار اتم‌ها با یکدیگر",
  "title": "ویژگی‌های ترکیب یونی",
  "position": 4,
  "start": 22,
  "end": 22
 },
 {
  "chapter": "فصل ۳: به دنبال محیطی بهتر برای زندگی",
  "title": "چرخه کربن",
  "position": 1,
  "start": 27,
  "end": 27
 },
 {
  "chapter": "فصل ۳: به دنبال محیطی بهتر برای زندگی",
  "title": "سوخت‌های فسیلی و محیط زیست",
  "position": 2,
  "start": 28,
  "end": 29
 },
 {
  "chapter": "فصل ۳: به دنبال محیطی بهتر برای زندگی",
  "title": "نفت خام و هیدروکربن‌ها",
  "position": 3,
  "start": 30,
  "end": 34
 },
 {
  "chapter": "فصل ۳: به دنبال محیطی بهتر برای زندگی",
  "title": "بسپار شدن و پلاستیک‌ها",
  "position": 4,
  "start": 35,
  "end": 37
 },
 {
  "chapter": "فصل ۴: حرکت چیست",
  "title": "مسافت و جابه‌جایی",
  "position": 1,
  "start": 40,
  "end": 41
 },
 {
  "chapter": "فصل ۴: حرکت چیست",
  "title": "تندی متوسط و لحظه‌ای",
  "position": 2,
  "start": 42,
  "end": 47
 },
 {
  "chapter": "فصل ۴: حرکت چیست",
  "title": "حرکت یکنواخت و سرعت",
  "position": 3,
  "start": 44,
  "end": 48
 },
 {
  "chapter": "فصل ۴: حرکت چیست",
  "title": "شتاب متوسط",
  "position": 4,
  "start": 49,
  "end": 50
 },
 {
  "chapter": "فصل ۵: نیرو",
  "title": "نیرو و نیروهای متوازن",
  "position": 1,
  "start": 52,
  "end": 53
 },
 {
  "chapter": "فصل ۵: نیرو",
  "title": "قانون‌های نیوتن",
  "position": 2,
  "start": 52,
  "end": 59
 },
 {
  "chapter": "فصل ۵: نیرو",
  "title": "نیروی خالص",
  "position": 3,
  "start": 54,
  "end": 56
 },
 {
  "chapter": "فصل ۵: نیرو",
  "title": "نیروی وزن",
  "position": 4,
  "start": 57,
  "end": 57
 },
 {
  "chapter": "فصل ۵: نیرو",
  "title": "کنش و واکنش",
  "position": 5,
  "start": 58,
  "end": 59
 },
 {
  "chapter": "فصل ۶: زمین‌ساخت ورقه‌ای",
  "title": "قاره‌های متحرک و نظریه وگنر",
  "position": 1,
  "start": 64,
  "end": 66
 },
 {
  "chapter": "فصل ۶: زمین‌ساخت ورقه‌ای",
  "title": "گسترش بستر اقیانوس‌ها",
  "position": 2,
  "start": 69,
  "end": 70
 },
 {
  "chapter": "فصل ۶: زمین‌ساخت ورقه‌ای",
  "title": "حرکت ورقه‌های سنگ‌کره",
  "position": 3,
  "start": 69,
  "end": 70
 },
 {
  "chapter": "فصل ۶: زمین‌ساخت ورقه‌ای",
  "title": "پیامدهای حرکت ورقه‌ها",
  "position": 4,
  "start": 71,
  "end": 72
 },
 {
  "chapter": "فصل ۷: آثاری از گذشته زمین",
  "title": "سنگواره‌ها و شرایط تشکیل آنها",
  "position": 1,
  "start": 74,
  "end": 75
 },
 {
  "chapter": "فصل ۷: آثاری از گذشته زمین",
  "title": "راه‌های تشکیل سنگواره",
  "position": 2,
  "start": 76,
  "end": 78
 },
 {
  "chapter": "فصل ۷: آثاری از گذشته زمین",
  "title": "کاربرد سنگواره‌ها و تعیین سن لایه‌ها",
  "position": 3,
  "start": 79,
  "end": 82
 },
 {
  "chapter": "فصل ۸: فشار و آثار آن",
  "title": "فشار و رابطه نیرو و سطح",
  "position": 1,
  "start": 84,
  "end": 86
 },
 {
  "chapter": "فصل ۸: فشار و آثار آن",
  "title": "فشار مایعات و عوامل مؤثر بر آن",
  "position": 2,
  "start": 87,
  "end": 88
 },
 {
  "chapter": "فصل ۸: فشار و آثار آن",
  "title": "فشار هوا",
  "position": 3,
  "start": 90,
  "end": 93
 },
 {
  "chapter": "فصل ۸: فشار و آثار آن",
  "title": "اصل پاسکال",
  "position": 4,
  "start": 89,
  "end": 89
 },
 {
  "chapter": "فصل ۹: ماشین‌ها",
  "title": "کار و نقش ماشین‌ها",
  "position": 1,
  "start": 96,
  "end": 97
 },
 {
  "chapter": "فصل ۹: ماشین‌ها",
  "title": "مزیت مکانیکی",
  "position": 2,
  "start": 100,
  "end": 105
 },
 {
  "chapter": "فصل ۹: ماشین‌ها",
  "title": "اهرم‌ها",
  "position": 3,
  "start": 99,
  "end": 99
 },
 {
  "chapter": "فصل ۹: ماشین‌ها",
  "title": "قرقره‌ها",
  "position": 4,
  "start": 102,
  "end": 103
 },
 {
  "chapter": "فصل ۹: ماشین‌ها",
  "title": "سطح شیب‌دار و چرخ و محور",
  "position": 5,
  "start": 104,
  "end": 105
 },
 {
  "chapter": "فصل ۱۰: نگاهی به فضا",
  "title": "کهکشان‌ها",
  "position": 1,
  "start": 110,
  "end": 110
 },
 {
  "chapter": "فصل ۱۰: نگاهی به فضا",
  "title": "ستاره‌ها و صورت‌های فلکی",
  "position": 2,
  "start": 110,
  "end": 113
 },
 {
  "chapter": "فصل ۱۰: نگاهی به فضا",
  "title": "سامانه خورشیدی و سیاره‌ها",
  "position": 3,
  "start": 114,
  "end": 115
 },
 {
  "chapter": "فصل ۱۰: نگاهی به فضا",
  "title": "قمرها و سیارک‌ها",
  "position": 4,
  "start": 116,
  "end": 117
 },
 {
  "chapter": "فصل ۱۰: نگاهی به فضا",
  "title": "سفر به فضا",
  "position": 5,
  "start": 119,
  "end": 119
 },
 {
  "chapter": "فصل ۱۱: گوناگونی جانداران",
  "title": "گروه‌بندی و کلید شناسایی جانداران",
  "position": 1,
  "start": 122,
  "end": 124
 },
 {
  "chapter": "فصل ۱۱: گوناگونی جانداران",
  "title": "گونه و نام‌گذاری علمی",
  "position": 2,
  "start": 124,
  "end": 125
 },
 {
  "chapter": "فصل ۱۱: گوناگونی جانداران",
  "title": "باکتری‌ها",
  "position": 3,
  "start": 126,
  "end": 126
 },
 {
  "chapter": "فصل ۱۱: گوناگونی جانداران",
  "title": "آغازیان",
  "position": 4,
  "start": 127,
  "end": 128
 },
 {
  "chapter": "فصل ۱۱: گوناگونی جانداران",
  "title": "قارچ‌ها",
  "position": 5,
  "start": 128,
  "end": 129
 },
 {
  "chapter": "فصل ۱۲: دنیای گیاهان",
  "title": "گیاهان بدون آوند و خزه‌ها",
  "position": 1,
  "start": 138,
  "end": 138
 },
 {
  "chapter": "فصل ۱۲: دنیای گیاهان",
  "title": "گیاهان آونددار و سرخس‌ها",
  "position": 2,
  "start": 135,
  "end": 137
 },
 {
  "chapter": "فصل ۱۲: دنیای گیاهان",
  "title": "بازدانگان",
  "position": 3,
  "start": 135,
  "end": 136
 },
 {
  "chapter": "فصل ۱۲: دنیای گیاهان",
  "title": "نهاندانگان و تک‌لپه‌ای و دولپه‌ای",
  "position": 4,
  "start": 136,
  "end": 137
 },
 {
  "chapter": "فصل ۱۳: جانوران بی‌مهره",
  "title": "اسفنج‌ها و کیسه‌تنان",
  "position": 1,
  "start": 142,
  "end": 143
 },
 {
  "chapter": "فصل ۱۳: جانوران بی‌مهره",
  "title": "کرم‌ها و نرم‌تنان",
  "position": 2,
  "start": 144,
  "end": 147
 },
 {
  "chapter": "فصل ۱۳: جانوران بی‌مهره",
  "title": "بندپایان",
  "position": 3,
  "start": 148,
  "end": 149
 },
 {
  "chapter": "فصل ۱۳: جانوران بی‌مهره",
  "title": "خارپوستان",
  "position": 4,
  "start": 150,
  "end": 150
 },
 {
  "chapter": "فصل ۱۴: جانوران مهره‌دار",
  "title": "ماهی‌ها",
  "position": 1,
  "start": 152,
  "end": 153
 },
 {
  "chapter": "فصل ۱۴: جانوران مهره‌دار",
  "title": "دوزیستان",
  "position": 2,
  "start": 154,
  "end": 154
 },
 {
  "chapter": "فصل ۱۴: جانوران مهره‌دار",
  "title": "خزندگان",
  "position": 3,
  "start": 155,
  "end": 157
 },
 {
  "chapter": "فصل ۱۴: جانوران مهره‌دار",
  "title": "پرندگان",
  "position": 4,
  "start": 158,
  "end": 159
 },
 {
  "chapter": "فصل ۱۴: جانوران مهره‌دار",
  "title": "پستانداران",
  "position": 5,
  "start": 160,
  "end": 162
 },
 {
  "chapter": "فصل ۱۵: باهم‌زیستن",
  "title": "بوم‌سازگان و اجزای آن",
  "position": 1,
  "start": 164,
  "end": 165
 },
 {
  "chapter": "فصل ۱۵: باهم‌زیستن",
  "title": "زنجیره و شبکه غذایی",
  "position": 2,
  "start": 164,
  "end": 165
 },
 {
  "chapter": "فصل ۱۵: باهم‌زیستن",
  "title": "شکار و رقابت",
  "position": 3,
  "start": 168,
  "end": 171
 },
 {
  "chapter": "فصل ۱۵: باهم‌زیستن",
  "title": "همزیستی: همیاری، همسفرگی و انگلی",
  "position": 4,
  "start": 167,
  "end": 167
 }
]$fixes$::jsonb) as p(chapter text,title text,position integer,start integer,"end" integer))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from fixes p
where t.id=md5('nova:planner:1405:v1:all:9:final_exam:علوم تجربی:'||p.chapter||':'||p.position)::uuid
 and t.edition='1405' and t.study_field='all' and t.grade='9' and t.preparation_track='final_exam' and t.subject='علوم تجربی' and t.chapter=p.chapter
 and t.title=p.title and t.position=p.position
 and t.page_start is null and t.page_end is null and t.revision=1;

with installed as (insert into private.planner_seed_installations(seed_key) values ('audit-batch6-1405-v236') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {"field": "mathematics", "grade": "10", "subject": "نگارش ۱", "chapter": "درس‌ها", "position": 3000, "title": "ستایش", "start": 11, "end": 11, "konkur": false},
 {"field": "experimental_sciences", "grade": "10", "subject": "نگارش ۱", "chapter": "درس‌ها", "position": 3000, "title": "ستایش", "start": 11, "end": 11, "konkur": false},
 {"field": "humanities", "grade": "10", "subject": "نگارش ۱", "chapter": "درس‌ها", "position": 3000, "title": "ستایش", "start": 11, "end": 11, "konkur": false},
 {"field": "mathematics", "grade": "10", "subject": "نگارش ۱", "chapter": "درس‌ها", "position": 3001, "title": "نیایش", "start": 123, "end": 123, "konkur": false},
 {"field": "experimental_sciences", "grade": "10", "subject": "نگارش ۱", "chapter": "درس‌ها", "position": 3001, "title": "نیایش", "start": 123, "end": 123, "konkur": false},
 {"field": "humanities", "grade": "10", "subject": "نگارش ۱", "chapter": "درس‌ها", "position": 3001, "title": "نیایش", "start": 123, "end": 123, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3000, "title": "ستایش", "start": 9, "end": 9, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3000, "title": "ستایش", "start": 9, "end": 9, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3000, "title": "ستایش", "start": 9, "end": 9, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3001, "title": "خاطره‌نگاری", "start": 12, "end": 27, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3001, "title": "خاطره‌نگاری", "start": 12, "end": 27, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3001, "title": "خاطره‌نگاری", "start": 12, "end": 27, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3002, "title": "نگارش ادبی ۱: نثر ادبی", "start": 30, "end": 41, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3002, "title": "نگارش ادبی ۱: نثر ادبی", "start": 30, "end": 41, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3002, "title": "نگارش ادبی ۱: نثر ادبی", "start": 30, "end": 41, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3003, "title": "نگارش ادبی ۲: قطعه ادبی", "start": 44, "end": 57, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3003, "title": "نگارش ادبی ۲: قطعه ادبی", "start": 44, "end": 57, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3003, "title": "نگارش ادبی ۲: قطعه ادبی", "start": 44, "end": 57, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3004, "title": "نامه‌نگاری", "start": 60, "end": 76, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3004, "title": "نامه‌نگاری", "start": 60, "end": 76, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3004, "title": "نامه‌نگاری", "start": 60, "end": 76, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3005, "title": "نگارش علمی: مقاله‌نویسی ۱", "start": 80, "end": 93, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3005, "title": "نگارش علمی: مقاله‌نویسی ۱", "start": 80, "end": 93, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3005, "title": "نگارش علمی: مقاله‌نویسی ۱", "start": 80, "end": 93, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3006, "title": "نگارش علمی: مقاله‌نویسی ۲", "start": 96, "end": 104, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3006, "title": "نگارش علمی: مقاله‌نویسی ۲", "start": 96, "end": 104, "konkur": false},
 {"field": "humanities", "grade": "12", "subject": "نگارش ۳", "chapter": "درس‌ها", "position": 3006, "title": "نگارش علمی: مقاله‌نویسی ۲", "start": 96, "end": 104, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "نگارش ۲", "chapter": "درس‌ها", "position": 3000, "title": "ستایش", "start": 11, "end": 11, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "نگارش ۲", "chapter": "درس‌ها", "position": 3000, "title": "ستایش", "start": 11, "end": 11, "konkur": false},
 {"field": "humanities", "grade": "11", "subject": "نگارش ۲", "chapter": "درس‌ها", "position": 3000, "title": "ستایش", "start": 11, "end": 11, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "نگارش ۲", "chapter": "درس‌ها", "position": 3001, "title": "نیایش", "start": 124, "end": 124, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "نگارش ۲", "chapter": "درس‌ها", "position": 3001, "title": "نیایش", "start": 124, "end": 124, "konkur": false},
 {"field": "humanities", "grade": "11", "subject": "نگارش ۲", "chapter": "درس‌ها", "position": 3001, "title": "نیایش", "start": 124, "end": 124, "konkur": false},
 {"field": "all", "grade": "9", "subject": "علوم تجربی", "chapter": "فصل ۱۵: باهم‌زیستن", "position": 3000, "title": "جدول تناوبی عنصرها", "start": 174, "end": 175, "konkur": false}
]$topics$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,start integer,"end" integer,konkur boolean)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v236:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed where p.konkur or r.track='final_exam' on conflict(id) do nothing;
