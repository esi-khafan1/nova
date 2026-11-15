-- Sociology 1 and statistics/probability 1405; printed page numbers from user PDFs.
with installed as (insert into private.planner_seed_installations(seed_key) values ('sociology10-statistics11-1405-v198') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱",
  "position": 400,
  "title": "کل درس",
  "start": 3,
  "end": 9
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۲",
  "position": 400,
  "title": "کل درس",
  "start": 10,
  "end": 18
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۳",
  "position": 400,
  "title": "کل درس",
  "start": 19,
  "end": 26
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۴",
  "position": 400,
  "title": "کل درس",
  "start": 27,
  "end": 35
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۵",
  "position": 400,
  "title": "کل درس",
  "start": 36,
  "end": 42
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۶",
  "position": 400,
  "title": "کل درس",
  "start": 43,
  "end": 52
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۷",
  "position": 400,
  "title": "کل درس",
  "start": 53,
  "end": 62
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۸",
  "position": 400,
  "title": "کل درس",
  "start": 65,
  "end": 76
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۹",
  "position": 400,
  "title": "کل درس",
  "start": 77,
  "end": 83
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۰",
  "position": 400,
  "title": "کل درس",
  "start": 84,
  "end": 90
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۱",
  "position": 400,
  "title": "کل درس",
  "start": 91,
  "end": 97
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۲",
  "position": 400,
  "title": "کل درس",
  "start": 98,
  "end": 105
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۳",
  "position": 400,
  "title": "کل درس",
  "start": 106,
  "end": 113
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۴",
  "position": 400,
  "title": "کل درس",
  "start": 114,
  "end": 120
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۵",
  "position": 400,
  "title": "کل درس",
  "start": 121,
  "end": 129
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۶",
  "position": 400,
  "title": "کل درس",
  "start": 130,
  "end": 141
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 400,
  "title": "کل فصل",
  "start": 1,
  "end": 34
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 401,
  "title": "درس: آشنایی با منطق ریاضی",
  "start": 2,
  "end": 15
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 402,
  "title": "درس: جبر مجموعه‌ها",
  "start": 16,
  "end": 34
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 450,
  "title": "گزاره، ارزش گزاره و نقیض آن",
  "start": 2,
  "end": 2
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 451,
  "title": "گزاره‌نما",
  "start": 3,
  "end": 3
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 452,
  "title": "دامنه متغیر گزاره‌نما و ترکیب عطفی",
  "start": 4,
  "end": 4
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 453,
  "title": "ترکیب فصلی دو گزاره",
  "start": 5,
  "end": 6
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 454,
  "title": "ترکیب شرطی دو گزاره",
  "start": 7,
  "end": 9
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 455,
  "title": "ترکیب دوشرطی دو گزاره",
  "start": 10,
  "end": 10
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 456,
  "title": "سورها",
  "start": 11,
  "end": 12
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 457,
  "title": "نقیض گزاره‌های سوری",
  "start": 13,
  "end": 13
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 458,
  "title": "تمرین منطق ریاضی",
  "start": 14,
  "end": 15
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 459,
  "title": "تعداد زیرمجموعه‌ها",
  "start": 16,
  "end": 16
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 460,
  "title": "تعریف زیرمجموعه با نمادهای ریاضی",
  "start": 17,
  "end": 17
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 461,
  "title": "روش عضوگیری دلخواه",
  "start": 18,
  "end": 18
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 462,
  "title": "دو مجموعه مساوی",
  "start": 19,
  "end": 20
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 463,
  "title": "قوانین اعمال بین مجموعه‌ها",
  "start": 21,
  "end": 26
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 464,
  "title": "قوانین دمورگان",
  "start": 27,
  "end": 29
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 465,
  "title": "ضرب دکارتی دو مجموعه",
  "start": 30,
  "end": 32
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 466,
  "title": "تمرین جبر مجموعه‌ها",
  "start": 33,
  "end": 34
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 400,
  "title": "کل فصل",
  "start": 35,
  "end": 68
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 401,
  "title": "درس: مبانی احتمال",
  "start": 36,
  "end": 43
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 402,
  "title": "درس: احتمال غیرهم‌شانس",
  "start": 44,
  "end": 47
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 403,
  "title": "درس: احتمال شرطی",
  "start": 48,
  "end": 62
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 404,
  "title": "درس: پیشامدهای مستقل و وابسته",
  "start": 63,
  "end": 68
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 450,
  "title": "کاربرد آمار و احتمال",
  "start": 36,
  "end": 37
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 451,
  "title": "ترجمه زبان گزاره‌ها به زبان مجموعه‌ها",
  "start": 38,
  "end": 38
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 452,
  "title": "تشخیص فضای نمونه",
  "start": 39,
  "end": 39
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 453,
  "title": "اصول احتمال",
  "start": 40,
  "end": 43
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 455,
  "title": "شرح: احتمال شرطی",
  "start": 48,
  "end": 48
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 456,
  "title": "کاهش فضای نمونه",
  "start": 49,
  "end": 51
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 457,
  "title": "قانون ضرب احتمال",
  "start": 52,
  "end": 54
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 458,
  "title": "قانون احتمال کل",
  "start": 55,
  "end": 56
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 459,
  "title": "قانون بیز",
  "start": 57,
  "end": 60
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 460,
  "title": "تمرین احتمال شرطی",
  "start": 61,
  "end": 62
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 461,
  "title": "شرح: پیشامدهای مستقل و وابسته",
  "start": 63,
  "end": 64
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 462,
  "title": "انتخاب با جایگذاری و بدون جایگذاری",
  "start": 65,
  "end": 66
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 463,
  "title": "تمرین استقلال پیشامدها",
  "start": 67,
  "end": 68
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 400,
  "title": "کل فصل",
  "start": 69,
  "end": 96
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 401,
  "title": "درس: توصیف و نمایش داده‌ها",
  "start": 70,
  "end": 79
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 402,
  "title": "درس: معیارهای گرایش به مرکز",
  "start": 80,
  "end": 86
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 403,
  "title": "درس: معیارهای پراکندگی",
  "start": 87,
  "end": 96
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 450,
  "title": "جدول فراوانی و نمایش داده‌ها",
  "start": 70,
  "end": 76
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 451,
  "title": "تمرین نمایش داده‌ها",
  "start": 77,
  "end": 79
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 452,
  "title": "میانگین",
  "start": 80,
  "end": 81
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 453,
  "title": "میانه",
  "start": 82,
  "end": 82
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 454,
  "title": "چارک و نما",
  "start": 83,
  "end": 86
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 455,
  "title": "انحراف معیار و واریانس داده‌ها",
  "start": 87,
  "end": 89
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 456,
  "title": "ضریب تغییرات داده‌ها",
  "start": 90,
  "end": 91
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 457,
  "title": "نمودار جعبه‌ای",
  "start": 92,
  "end": 92
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 458,
  "title": "تمرین معیارهای پراکندگی",
  "start": 93,
  "end": 94
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 459,
  "title": "خواندنی: نرخ بیکاری",
  "start": 95,
  "end": 96
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 400,
  "title": "کل فصل",
  "start": 97,
  "end": 121
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 401,
  "title": "درس: گردآوری داده‌ها",
  "start": 98,
  "end": 111
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 402,
  "title": "درس: برآورد",
  "start": 112,
  "end": 121
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 450,
  "title": "جامعه، نمونه و واحد آماری",
  "start": 98,
  "end": 101
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 451,
  "title": "نمونه‌گیری احتمالی و غیر احتمالی",
  "start": 102,
  "end": 107
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 452,
  "title": "روش‌های گردآوری داده‌ها",
  "start": 108,
  "end": 109
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 453,
  "title": "تمرین گردآوری داده‌ها",
  "start": 110,
  "end": 111
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 454,
  "title": "برآورد پارامتر جامعه",
  "start": 112,
  "end": 114
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 455,
  "title": "برآورد بازه‌ای و فاصله اطمینان",
  "start": 115,
  "end": 116
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 456,
  "title": "برآورد بازه‌ای نسبت",
  "start": 117,
  "end": 118
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 457,
  "title": "تمرین برآورد",
  "start": 119,
  "end": 121
 }
]$topics$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v198:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱",
  "position": 1,
  "title": "کنش ما انسان‌ها چه ویژگی‌هایی دارد؟",
  "new_title": "کنش ما انسان‌ها چه ویژگی‌هایی دارد؟",
  "start": 3,
  "end": 5
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱",
  "position": 2,
  "title": "کنش ما چه آثار و پیامدهایی دارد؟",
  "new_title": "کنش ما چه آثار و پیامدهایی دارد؟",
  "start": 6,
  "end": 9
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۲",
  "position": 1,
  "title": "کنش اجتماعی چیست؟",
  "new_title": "کنش اجتماعی چیست؟",
  "start": 10,
  "end": 11
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۲",
  "position": 2,
  "title": "پدیده‌های اجتماعی کدام‌اند و چگونه شکل می‌گیرند؟",
  "new_title": "پدیده‌های اجتماعی کدام‌اند و چگونه شکل می‌گیرند؟",
  "start": 12,
  "end": 14
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۲",
  "position": 3,
  "title": "از من تا ما",
  "new_title": "از من تا ما",
  "start": 15,
  "end": 18
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۳",
  "position": 1,
  "title": "چه تصوری از جهان اجتماعی دارید؟",
  "new_title": "چه تصوری از جهان اجتماعی دارید؟",
  "start": 19,
  "end": 21
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۳",
  "position": 2,
  "title": "گستره جهان اجتماعی کجاست؟",
  "new_title": "گستره جهان اجتماعی کجاست؟",
  "start": 22,
  "end": 26
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۴",
  "position": 1,
  "title": "جهان اجتماعی از چه اجزایی تشکیل شده است؟",
  "new_title": "جهان اجتماعی از چه اجزایی تشکیل شده است؟",
  "start": 27,
  "end": 30
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۴",
  "position": 2,
  "title": "لایه‌های جهان اجتماعی کدام‌اند؟",
  "new_title": "لایه‌های جهان اجتماعی کدام‌اند؟",
  "start": 31,
  "end": 35
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۵",
  "position": 1,
  "title": "جهان اجتماعی یا جهان‌های اجتماعی؟",
  "new_title": "جهان اجتماعی یا جهان‌های اجتماعی؟",
  "start": 36,
  "end": 38
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۵",
  "position": 2,
  "title": "آیا جهان‌های اجتماعی تاریخ یکسانی دارند؟",
  "new_title": "آیا جهان‌های اجتماعی تاریخ یکسانی دارند؟",
  "start": 39,
  "end": 42
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۶",
  "position": 1,
  "title": "آیا جهان اجتماعی صرفاً تابع خواست و اراده افراد است؟",
  "new_title": "آیا جهان اجتماعی صرفاً تابع خواست و اراده افراد است؟",
  "start": 43,
  "end": 44
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۶",
  "position": 2,
  "title": "پیامدهای جهان اجتماعی: محدودیت‌ها و فرصت‌ها",
  "new_title": "پیامدهای جهان اجتماعی: محدودیت‌ها و فرصت‌ها",
  "start": 45,
  "end": 47
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۶",
  "position": 3,
  "title": "فرصت‌ها و محدودیت‌های جهان متجدد",
  "new_title": "فرصت‌ها و محدودیت‌های جهان متجدد",
  "start": 48,
  "end": 52
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۷",
  "position": 1,
  "title": "قلمرو واقعی و آرمانی جهان اجتماعی کدام است؟",
  "new_title": "قلمرو واقعی و آرمانی جهان اجتماعی کدام است؟",
  "start": 53,
  "end": 54
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۷",
  "position": 2,
  "title": "قلمرو واقعی و آرمانی جهان اجتماعی را چگونه ارزیابی کنیم؟",
  "new_title": "قلمرو واقعی و آرمانی جهان اجتماعی را چگونه ارزیابی کنیم؟",
  "start": 55,
  "end": 56
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۷",
  "position": 3,
  "title": "آیا حق و باطل تابع جهان‌های اجتماعی‌اند؟",
  "new_title": "آیا حق و باطل تابع جهان‌های اجتماعی‌اند؟",
  "start": 57,
  "end": 62
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۸",
  "position": 1,
  "title": "در مورد هویت چه می‌دانید؟",
  "new_title": "در مورد هویت چه می‌دانید؟",
  "start": 65,
  "end": 68
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۸",
  "position": 2,
  "title": "هویت فردی و اجتماعی چه نسبتی با هم دارند؟",
  "new_title": "هویت فردی و اجتماعی چه نسبتی با هم دارند؟",
  "start": 69,
  "end": 73
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۸",
  "position": 3,
  "title": "خودآگاهی یا ناخودآگاهی؟",
  "new_title": "خودآگاهی یا ناخودآگاهی؟",
  "start": 74,
  "end": 76
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۹",
  "position": 1,
  "title": "جامعه‌پذیری چه نقشی در بازتولید هویت اجتماعی دارد؟",
  "new_title": "جامعه‌پذیری چه نقشی در بازتولید هویت اجتماعی دارد؟",
  "start": 77,
  "end": 78
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۹",
  "position": 2,
  "title": "کنترل اجتماعی چه نقشی در بازتولید هویت اجتماعی دارد؟",
  "new_title": "کنترل اجتماعی چه نقشی در بازتولید هویت اجتماعی دارد؟",
  "start": 79,
  "end": 83
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۰",
  "position": 1,
  "title": "تحرک اجتماعی چیست؟",
  "new_title": "تحرک اجتماعی چیست؟",
  "start": 84,
  "end": 85
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۰",
  "position": 2,
  "title": "فرصت‌ها و محدودیت‌های تغییرات هویتی کدام‌اند؟",
  "new_title": "فرصت‌ها و محدودیت‌های تغییرات هویتی کدام‌اند؟",
  "start": 86,
  "end": 90
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۱",
  "position": 1,
  "title": "هویت جهان اجتماعی چیست؟",
  "new_title": "هویت جهان اجتماعی چیست؟",
  "start": 91,
  "end": 92
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۱",
  "position": 2,
  "title": "فرایند تحولات هویتی جهان اجتماعی چگونه است؟",
  "new_title": "فرایند تحولات هویتی جهان اجتماعی چگونه است؟",
  "start": 93,
  "end": 97
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۲",
  "position": 1,
  "title": "ارتباط جهان‌های اجتماعی و تحولات فرهنگی",
  "new_title": "ارتباط جهان‌های اجتماعی و تحولات فرهنگی",
  "start": 98,
  "end": 101
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۲",
  "position": 2,
  "title": "از خودبیگانگی فرهنگی چیست؟",
  "new_title": "از خودبیگانگی فرهنگی چیست؟",
  "start": 102,
  "end": 105
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۳",
  "position": 1,
  "title": "هویت ایرانی در گذر زمان چه تحولاتی به خود دیده است؟",
  "new_title": "هویت ایرانی در گذر زمان چه تحولاتی به خود دیده است؟",
  "start": 106,
  "end": 109
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۳",
  "position": 2,
  "title": "انقلاب اسلامی چه تأثیری بر هویت ایرانی دارد؟",
  "new_title": "انقلاب اسلامی چه تأثیری بر هویت ایرانی دارد؟",
  "start": 110,
  "end": 113
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۴",
  "position": 1,
  "title": "هویت اجتماعی خانوادگی",
  "new_title": "هویت اجتماعی خانوادگی",
  "start": 114,
  "end": 116
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۵",
  "position": 1,
  "title": "رابطه جهان اجتماعی و نظام سیاسی",
  "new_title": "رابطه جهان اجتماعی و نظام سیاسی",
  "start": 121,
  "end": 125
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۵",
  "position": 2,
  "title": "انواع نظام‌های سیاسی",
  "new_title": "انواع نظام‌های سیاسی",
  "start": 126,
  "end": 129
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۶",
  "position": 1,
  "title": "رابطه جمعیت جامعه با هویت آن",
  "new_title": "رابطه جمعیت جامعه با هویت آن",
  "start": 130,
  "end": 135
 },
 {
  "field": "humanities",
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
  "chapter": "درس ۱۶",
  "position": 2,
  "title": "هویت اقتصادی جامعه",
  "new_title": "هویت اقتصادی جامعه",
  "start": 136,
  "end": 141
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 1,
  "title": "آشنایی با منطق ریاضی",
  "new_title": "آشنایی با منطق ریاضی",
  "start": 2,
  "end": 15
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
  "position": 2,
  "title": "جبر مجموعه‌ها",
  "new_title": "جبر مجموعه‌ها",
  "start": 16,
  "end": 34
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 1,
  "title": "مبانی احتمال",
  "new_title": "مبانی احتمال",
  "start": 36,
  "end": 43
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 2,
  "title": "احتمال غیرهم‌شانس",
  "new_title": "احتمال غیرهم‌شانس",
  "start": 44,
  "end": 47
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 3,
  "title": "احتمال شرطی",
  "new_title": "احتمال شرطی",
  "start": 48,
  "end": 62
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۲: احتمال",
  "position": 4,
  "title": "پیشامدهای مستقل و وابسته",
  "new_title": "پیشامدهای مستقل و وابسته",
  "start": 63,
  "end": 68
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 1,
  "title": "توصیف و نمایش داده‌ها",
  "new_title": "توصیف و نمایش داده‌ها",
  "start": 70,
  "end": 79
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 2,
  "title": "معیارهای گرایش به مرکز",
  "new_title": "معیارهای گرایش به مرکز",
  "start": 80,
  "end": 86
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۳: آمار توصیفی",
  "position": 3,
  "title": "معیارهای پراکندگی",
  "new_title": "معیارهای پراکندگی",
  "start": 87,
  "end": 96
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 1,
  "title": "گردآوری داده‌ها",
  "new_title": "گردآوری داده‌ها",
  "start": 98,
  "end": 111
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "آمار و احتمال",
  "chapter": "فصل ۴: آمار استنباطی",
  "position": 2,
  "title": "برآورد",
  "new_title": "برآورد",
  "start": 112,
  "end": 121
 }
]$fixes$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,new_title text,start integer,"end" integer)),
tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set title=p.new_title,page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field=p.field and t.grade=p.grade and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
