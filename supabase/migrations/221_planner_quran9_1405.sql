-- Grade 9 آموزش قرآن, textbook 1405, printed pages (not Quran page references).
-- Existing untouched defaults only: compare full scope, title, position, empty pages and revision.
with installed as (insert into private.planner_seed_installations(seed_key) values ('quran9-1405-v221') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "title": "کل درس",
  "start": 14,
  "end": 23,
  "position": 100
 },
 {
  "chapter": "درس ۱",
  "title": "جلسه اول — تدبر و فعالیت آغازین",
  "start": 14,
  "end": 14,
  "position": 110
 },
 {
  "chapter": "درس ۱",
  "title": "جلسه اول — قرائت سوره شوری",
  "start": 15,
  "end": 15,
  "position": 111
 },
 {
  "chapter": "درس ۱",
  "title": "جلسه اول — واژگان و درک و فهم آیات",
  "start": 16,
  "end": 16,
  "position": 112
 },
 {
  "chapter": "درس ۱",
  "title": "جلسه اول — ترجمه و پیام قرآنی",
  "start": 17,
  "end": 17,
  "position": 113
 },
 {
  "chapter": "درس ۱",
  "title": "جلسه دوم — تلفظ ح، ع، غ و ق",
  "start": 18,
  "end": 18,
  "position": 120
 },
 {
  "chapter": "درس ۱",
  "title": "جلسه دوم — قرائت سوره زخرف",
  "start": 19,
  "end": 19,
  "position": 121
 },
 {
  "chapter": "درس ۱",
  "title": "جلسه دوم — واژگان و درک و فهم آیات",
  "start": 20,
  "end": 20,
  "position": 122
 },
 {
  "chapter": "درس ۱",
  "title": "جلسه دوم — ترجمه و پیام قرآنی",
  "start": 21,
  "end": 21,
  "position": 123
 },
 {
  "chapter": "درس ۱",
  "title": "شناخت قرآن — مانند کتاب بی‌مانند",
  "start": 22,
  "end": 23,
  "position": 130
 },
 {
  "chapter": "درس ۲",
  "title": "کل درس",
  "start": 24,
  "end": 32,
  "position": 100
 },
 {
  "chapter": "درس ۲",
  "title": "جلسه اول — تدبر و فعالیت آغازین",
  "start": 24,
  "end": 24,
  "position": 110
 },
 {
  "chapter": "درس ۲",
  "title": "جلسه اول — قرائت سوره دخان",
  "start": 25,
  "end": 25,
  "position": 111
 },
 {
  "chapter": "درس ۲",
  "title": "جلسه اول — واژگان و درک و فهم آیات",
  "start": 26,
  "end": 26,
  "position": 112
 },
 {
  "chapter": "درس ۲",
  "title": "جلسه اول — ترجمه و پیام قرآنی",
  "start": 27,
  "end": 27,
  "position": 113
 },
 {
  "chapter": "درس ۲",
  "title": "جلسه دوم — تلفظ ط، ص و ث",
  "start": 28,
  "end": 28,
  "position": 120
 },
 {
  "chapter": "درس ۲",
  "title": "جلسه دوم — قرائت سوره جاثیه",
  "start": 29,
  "end": 29,
  "position": 121
 },
 {
  "chapter": "درس ۲",
  "title": "جلسه دوم — واژگان و درک و فهم آیات",
  "start": 30,
  "end": 30,
  "position": 122
 },
 {
  "chapter": "درس ۲",
  "title": "جلسه دوم — ترجمه و پیام قرآنی",
  "start": 31,
  "end": 31,
  "position": 123
 },
 {
  "chapter": "درس ۲",
  "title": "شناخت قرآن — محمد رسول‌الله",
  "start": 32,
  "end": 32,
  "position": 130
 },
 {
  "chapter": "درس ۳",
  "title": "کل درس",
  "start": 33,
  "end": 42,
  "position": 100
 },
 {
  "chapter": "درس ۳",
  "title": "جلسه اول — تدبر و فعالیت آغازین",
  "start": 33,
  "end": 33,
  "position": 110
 },
 {
  "chapter": "درس ۳",
  "title": "جلسه اول — قرائت سوره احقاف",
  "start": 34,
  "end": 34,
  "position": 111
 },
 {
  "chapter": "درس ۳",
  "title": "جلسه اول — واژگان و درک و فهم آیات",
  "start": 35,
  "end": 35,
  "position": 112
 },
 {
  "chapter": "درس ۳",
  "title": "جلسه اول — ترجمه و پیام قرآنی",
  "start": 36,
  "end": 36,
  "position": 113
 },
 {
  "chapter": "درس ۳",
  "title": "جلسه دوم — تلفظ ذ، ظ و ض",
  "start": 37,
  "end": 37,
  "position": 120
 },
 {
  "chapter": "درس ۳",
  "title": "جلسه دوم — قرائت سوره محمد",
  "start": 38,
  "end": 38,
  "position": 121
 },
 {
  "chapter": "درس ۳",
  "title": "جلسه دوم — واژگان و درک و فهم آیات",
  "start": 39,
  "end": 39,
  "position": 122
 },
 {
  "chapter": "درس ۳",
  "title": "جلسه دوم — ترجمه و پیام قرآنی",
  "start": 40,
  "end": 40,
  "position": 123
 },
 {
  "chapter": "درس ۳",
  "title": "شناخت قرآن — بهداشت روانی در قرآن ۱",
  "start": 41,
  "end": 42,
  "position": 130
 },
 {
  "chapter": "درس ۴",
  "title": "کل درس",
  "start": 43,
  "end": 51,
  "position": 100
 },
 {
  "chapter": "درس ۴",
  "title": "جلسه اول — تدبر و فعالیت آغازین",
  "start": 43,
  "end": 43,
  "position": 110
 },
 {
  "chapter": "درس ۴",
  "title": "جلسه اول — قرائت سوره فتح",
  "start": 44,
  "end": 44,
  "position": 111
 },
 {
  "chapter": "درس ۴",
  "title": "جلسه اول — واژگان و درک و فهم آیات",
  "start": 45,
  "end": 45,
  "position": 112
 },
 {
  "chapter": "درس ۴",
  "title": "جلسه اول — ترجمه و پیام قرآنی",
  "start": 46,
  "end": 46,
  "position": 113
 },
 {
  "chapter": "درس ۴",
  "title": "جلسه دوم — وقف بر جمله",
  "start": 47,
  "end": 47,
  "position": 120
 },
 {
  "chapter": "درس ۴",
  "title": "جلسه دوم — قرائت سوره حجرات",
  "start": 48,
  "end": 48,
  "position": 121
 },
 {
  "chapter": "درس ۴",
  "title": "جلسه دوم — واژگان و درک و فهم آیات",
  "start": 49,
  "end": 49,
  "position": 122
 },
 {
  "chapter": "درس ۴",
  "title": "جلسه دوم — ترجمه و پیام قرآنی",
  "start": 50,
  "end": 50,
  "position": 123
 },
 {
  "chapter": "درس ۴",
  "title": "شناخت قرآن — بهداشت روانی در قرآن ۲",
  "start": 51,
  "end": 51,
  "position": 130
 },
 {
  "chapter": "درس ۵",
  "title": "کل درس",
  "start": 52,
  "end": 59,
  "position": 100
 },
 {
  "chapter": "درس ۵",
  "title": "جلسه اول — تدبر و فعالیت آغازین",
  "start": 52,
  "end": 52,
  "position": 110
 },
 {
  "chapter": "درس ۵",
  "title": "جلسه اول — قرائت سوره ذاریات",
  "start": 53,
  "end": 53,
  "position": 111
 },
 {
  "chapter": "درس ۵",
  "title": "جلسه اول — واژگان و درک و فهم آیات",
  "start": 54,
  "end": 54,
  "position": 112
 },
 {
  "chapter": "درس ۵",
  "title": "جلسه اول — ترجمه و پیام قرآنی",
  "start": 55,
  "end": 55,
  "position": 113
 },
 {
  "chapter": "درس ۵",
  "title": "جلسه دوم — وقف بر کلمات",
  "start": 56,
  "end": 56,
  "position": 120
 },
 {
  "chapter": "درس ۵",
  "title": "جلسه دوم — قرائت سوره قمر",
  "start": 57,
  "end": 57,
  "position": 121
 },
 {
  "chapter": "درس ۵",
  "title": "جلسه دوم — واژگان و درک و فهم آیات",
  "start": 58,
  "end": 58,
  "position": 122
 },
 {
  "chapter": "درس ۵",
  "title": "جلسه دوم — ترجمه و پیام قرآنی",
  "start": 59,
  "end": 59,
  "position": 123
 },
 {
  "chapter": "درس ۶",
  "title": "کل درس",
  "start": 60,
  "end": 68,
  "position": 100
 },
 {
  "chapter": "درس ۶",
  "title": "جلسه اول — تدبر و فعالیت آغازین",
  "start": 60,
  "end": 60,
  "position": 110
 },
 {
  "chapter": "درس ۶",
  "title": "جلسه اول — قرائت سوره الرحمن",
  "start": 61,
  "end": 61,
  "position": 111
 },
 {
  "chapter": "درس ۶",
  "title": "جلسه اول — واژگان و درک و فهم آیات",
  "start": 62,
  "end": 62,
  "position": 112
 },
 {
  "chapter": "درس ۶",
  "title": "جلسه اول — ترجمه و پیام قرآنی",
  "start": 63,
  "end": 63,
  "position": 113
 },
 {
  "chapter": "درس ۶",
  "title": "جلسه دوم — الف وصل",
  "start": 64,
  "end": 64,
  "position": 120
 },
 {
  "chapter": "درس ۶",
  "title": "جلسه دوم — قرائت سوره واقعه",
  "start": 65,
  "end": 65,
  "position": 121
 },
 {
  "chapter": "درس ۶",
  "title": "جلسه دوم — واژگان و درک و فهم آیات",
  "start": 66,
  "end": 66,
  "position": 122
 },
 {
  "chapter": "درس ۶",
  "title": "جلسه دوم — ترجمه و پیام قرآنی",
  "start": 67,
  "end": 67,
  "position": 123
 },
 {
  "chapter": "درس ۶",
  "title": "شناخت قرآن — تلخ و شیرین",
  "start": 68,
  "end": 68,
  "position": 130
 },
 {
  "chapter": "درس ۷",
  "title": "کل درس",
  "start": 69,
  "end": 78,
  "position": 100
 },
 {
  "chapter": "درس ۷",
  "title": "جلسه اول — تدبر و فعالیت آغازین",
  "start": 69,
  "end": 69,
  "position": 110
 },
 {
  "chapter": "درس ۷",
  "title": "جلسه اول — قرائت سوره حدید",
  "start": 70,
  "end": 70,
  "position": 111
 },
 {
  "chapter": "درس ۷",
  "title": "جلسه اول — واژگان و درک و فهم آیات",
  "start": 71,
  "end": 71,
  "position": 112
 },
 {
  "chapter": "درس ۷",
  "title": "جلسه اول — ترجمه و پیام قرآنی",
  "start": 72,
  "end": 72,
  "position": 113
 },
 {
  "chapter": "درس ۷",
  "title": "جلسه دوم — کوتاهی و کشیدگی حرکات",
  "start": 73,
  "end": 73,
  "position": 120
 },
 {
  "chapter": "درس ۷",
  "title": "جلسه دوم — قرائت سوره حشر",
  "start": 74,
  "end": 74,
  "position": 121
 },
 {
  "chapter": "درس ۷",
  "title": "جلسه دوم — واژگان و درک و فهم آیات",
  "start": 75,
  "end": 75,
  "position": 122
 },
 {
  "chapter": "درس ۷",
  "title": "جلسه دوم — ترجمه و پیام قرآنی",
  "start": 76,
  "end": 76,
  "position": 123
 },
 {
  "chapter": "درس ۷",
  "title": "شناخت قرآن — پیرمرد شامی و امام سجاد",
  "start": 77,
  "end": 78,
  "position": 130
 },
 {
  "chapter": "درس ۸",
  "title": "کل درس",
  "start": 79,
  "end": 87,
  "position": 100
 },
 {
  "chapter": "درس ۸",
  "title": "جلسه اول — تدبر و فعالیت آغازین",
  "start": 79,
  "end": 79,
  "position": 110
 },
 {
  "chapter": "درس ۸",
  "title": "جلسه اول — قرائت سوره صف",
  "start": 80,
  "end": 80,
  "position": 111
 },
 {
  "chapter": "درس ۸",
  "title": "جلسه اول — واژگان و درک و فهم آیات",
  "start": 81,
  "end": 81,
  "position": 112
 },
 {
  "chapter": "درس ۸",
  "title": "جلسه اول — ترجمه و پیام قرآنی",
  "start": 82,
  "end": 82,
  "position": 113
 },
 {
  "chapter": "درس ۸",
  "title": "جلسه دوم — فصاحت لفظ جلاله",
  "start": 83,
  "end": 83,
  "position": 120
 },
 {
  "chapter": "درس ۸",
  "title": "جلسه دوم — قرائت سوره جمعه",
  "start": 84,
  "end": 84,
  "position": 121
 },
 {
  "chapter": "درس ۸",
  "title": "جلسه دوم — واژگان و درک و فهم آیات",
  "start": 85,
  "end": 85,
  "position": 122
 },
 {
  "chapter": "درس ۸",
  "title": "جلسه دوم — ترجمه و پیام قرآنی",
  "start": 86,
  "end": 86,
  "position": 123
 },
 {
  "chapter": "درس ۸",
  "title": "شناخت قرآن — او خواهد آمد",
  "start": 87,
  "end": 87,
  "position": 130
 },
 {
  "chapter": "درس ۹",
  "title": "کل درس",
  "start": 88,
  "end": 97,
  "position": 100
 },
 {
  "chapter": "درس ۹",
  "title": "جلسه اول — تدبر و فعالیت آغازین",
  "start": 88,
  "end": 88,
  "position": 110
 },
 {
  "chapter": "درس ۹",
  "title": "جلسه اول — قرائت سوره تغابن",
  "start": 89,
  "end": 89,
  "position": 111
 },
 {
  "chapter": "درس ۹",
  "title": "جلسه اول — واژگان و درک و فهم آیات",
  "start": 90,
  "end": 90,
  "position": 112
 },
 {
  "chapter": "درس ۹",
  "title": "جلسه اول — ترجمه و پیام قرآنی",
  "start": 91,
  "end": 91,
  "position": 113
 },
 {
  "chapter": "درس ۹",
  "title": "جلسه دوم — فصاحت نون ساکن و تنوین",
  "start": 92,
  "end": 92,
  "position": 120
 },
 {
  "chapter": "درس ۹",
  "title": "جلسه دوم — قرائت سوره ملک",
  "start": 93,
  "end": 93,
  "position": 121
 },
 {
  "chapter": "درس ۹",
  "title": "جلسه دوم — واژگان و درک و فهم آیات",
  "start": 94,
  "end": 94,
  "position": 122
 },
 {
  "chapter": "درس ۹",
  "title": "جلسه دوم — ترجمه و پیام قرآنی",
  "start": 95,
  "end": 95,
  "position": 123
 },
 {
  "chapter": "درس ۹",
  "title": "شناخت قرآن — هیهات منا الذلة",
  "start": 96,
  "end": 97,
  "position": 130
 },
 {
  "chapter": "درس ۱۰",
  "title": "کل درس",
  "start": 98,
  "end": 106,
  "position": 100
 },
 {
  "chapter": "درس ۱۰",
  "title": "جلسه اول — تدبر و فعالیت آغازین",
  "start": 98,
  "end": 98,
  "position": 110
 },
 {
  "chapter": "درس ۱۰",
  "title": "جلسه اول — قرائت سوره نوح",
  "start": 99,
  "end": 99,
  "position": 111
 },
 {
  "chapter": "درس ۱۰",
  "title": "جلسه اول — واژگان و درک و فهم آیات",
  "start": 100,
  "end": 100,
  "position": 112
 },
 {
  "chapter": "درس ۱۰",
  "title": "جلسه اول — ترجمه و پیام قرآنی",
  "start": 101,
  "end": 101,
  "position": 113
 },
 {
  "chapter": "درس ۱۰",
  "title": "جلسه دوم — قرائت نماز",
  "start": 102,
  "end": 102,
  "position": 120
 },
 {
  "chapter": "درس ۱۰",
  "title": "جلسه دوم — قرائت سوره مزمل",
  "start": 103,
  "end": 103,
  "position": 121
 },
 {
  "chapter": "درس ۱۰",
  "title": "جلسه دوم — واژگان و درک و فهم آیات",
  "start": 104,
  "end": 104,
  "position": 122
 },
 {
  "chapter": "درس ۱۰",
  "title": "جلسه دوم — ترجمه و پیام قرآنی",
  "start": 105,
  "end": 105,
  "position": 123
 },
 {
  "chapter": "درس ۱۰",
  "title": "شناخت قرآن — از معلم زبان آموختیم",
  "start": 106,
  "end": 106,
  "position": 130
 },
 {
  "chapter": "درس ۱۱",
  "title": "کل درس",
  "start": 107,
  "end": 115,
  "position": 100
 },
 {
  "chapter": "درس ۱۱",
  "title": "جلسه اول — تدبر و فعالیت آغازین",
  "start": 107,
  "end": 107,
  "position": 110
 },
 {
  "chapter": "درس ۱۱",
  "title": "جلسه اول — قرائت سوره نبأ",
  "start": 108,
  "end": 108,
  "position": 111
 },
 {
  "chapter": "درس ۱۱",
  "title": "جلسه اول — واژگان و درک و فهم آیات",
  "start": 109,
  "end": 109,
  "position": 112
 },
 {
  "chapter": "درس ۱۱",
  "title": "جلسه اول — ترجمه و پیام قرآنی",
  "start": 110,
  "end": 110,
  "position": 113
 },
 {
  "chapter": "درس ۱۱",
  "title": "جلسه دوم — قرائت سوره غاشیه",
  "start": 111,
  "end": 111,
  "position": 121
 },
 {
  "chapter": "درس ۱۱",
  "title": "جلسه دوم — واژگان و درک و فهم آیات",
  "start": 112,
  "end": 112,
  "position": 122
 },
 {
  "chapter": "درس ۱۱",
  "title": "جلسه دوم — ترجمه و پیام قرآنی",
  "start": 113,
  "end": 113,
  "position": 123
 },
 {
  "chapter": "درس ۱۱",
  "title": "شناخت قرآن — من زنده‌ام",
  "start": 114,
  "end": 115,
  "position": 130
 },
 {
  "chapter": "پایان کتاب",
  "title": "نیایش: دعای ختم قرآن",
  "start": 116,
  "end": 116,
  "position": 100
 },
 {
  "chapter": "پایان کتاب",
  "title": "فهرست کلمات",
  "start": 117,
  "end": 127,
  "position": 110
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer)),
fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "درس ۱",
  "title": "جلسه اول: سوره شوری",
  "newtitle": "جلسه اول: سوره شوری",
  "start": 14,
  "end": 17,
  "position": 1
 },
 {
  "chapter": "درس ۱",
  "title": "جلسه دوم: سوره زخرف",
  "newtitle": "جلسه دوم: سوره زخرف",
  "start": 18,
  "end": 21,
  "position": 2
 },
 {
  "chapter": "درس ۲",
  "title": "جلسه اول: سوره دخان",
  "newtitle": "جلسه اول: سوره دخان",
  "start": 24,
  "end": 27,
  "position": 1
 },
 {
  "chapter": "درس ۲",
  "title": "جلسه دوم: سوره جاثیه",
  "newtitle": "جلسه دوم: سوره جاثیه",
  "start": 28,
  "end": 31,
  "position": 2
 },
 {
  "chapter": "درس ۳",
  "title": "جلسه اول: سوره احقاف",
  "newtitle": "جلسه اول: سوره احقاف",
  "start": 33,
  "end": 36,
  "position": 1
 },
 {
  "chapter": "درس ۳",
  "title": "جلسه دوم: سوره محمد",
  "newtitle": "جلسه دوم: سوره محمد",
  "start": 37,
  "end": 40,
  "position": 2
 },
 {
  "chapter": "درس ۴",
  "title": "جلسه اول: سوره فتح",
  "newtitle": "جلسه اول: سوره فتح",
  "start": 43,
  "end": 46,
  "position": 1
 },
 {
  "chapter": "درس ۴",
  "title": "جلسه دوم: سوره حجرات",
  "newtitle": "جلسه دوم: سوره حجرات",
  "start": 47,
  "end": 50,
  "position": 2
 },
 {
  "chapter": "درس ۵",
  "title": "جلسه اول: سوره ذاریات",
  "newtitle": "جلسه اول: سوره ذاریات",
  "start": 52,
  "end": 55,
  "position": 1
 },
 {
  "chapter": "درس ۵",
  "title": "جلسه دوم: سوره قمر",
  "newtitle": "جلسه دوم: سوره قمر",
  "start": 56,
  "end": 59,
  "position": 2
 },
 {
  "chapter": "درس ۶",
  "title": "جلسه اول: سوره الرحمن",
  "newtitle": "جلسه اول: سوره الرحمن",
  "start": 60,
  "end": 63,
  "position": 1
 },
 {
  "chapter": "درس ۶",
  "title": "جلسه دوم: سوره واقعه",
  "newtitle": "جلسه دوم: سوره واقعه",
  "start": 64,
  "end": 67,
  "position": 2
 },
 {
  "chapter": "درس ۷",
  "title": "جلسه اول: سوره حدید",
  "newtitle": "جلسه اول: سوره حدید",
  "start": 69,
  "end": 72,
  "position": 1
 },
 {
  "chapter": "درس ۷",
  "title": "جلسه دوم: سوره حشر",
  "newtitle": "جلسه دوم: سوره حشر",
  "start": 73,
  "end": 76,
  "position": 2
 },
 {
  "chapter": "درس ۸",
  "title": "جلسه اول: سوره صف",
  "newtitle": "جلسه اول: سوره صف",
  "start": 79,
  "end": 82,
  "position": 1
 },
 {
  "chapter": "درس ۸",
  "title": "جلسه دوم: سوره جمعه",
  "newtitle": "جلسه دوم: سوره جمعه",
  "start": 83,
  "end": 86,
  "position": 2
 },
 {
  "chapter": "درس ۹",
  "title": "جلسه اول: سوره تغابن",
  "newtitle": "جلسه اول: سوره تغابن",
  "start": 88,
  "end": 91,
  "position": 1
 },
 {
  "chapter": "درس ۹",
  "title": "جلسه دوم: سوره ملک",
  "newtitle": "جلسه دوم: سوره ملک",
  "start": 92,
  "end": 95,
  "position": 2
 },
 {
  "chapter": "درس ۱۰",
  "title": "جلسه اول: سوره نوح",
  "newtitle": "جلسه اول: سوره نوح",
  "start": 98,
  "end": 101,
  "position": 1
 },
 {
  "chapter": "درس ۱۰",
  "title": "جلسه دوم: سوره مزمل",
  "newtitle": "جلسه دوم: سوره مزمل",
  "start": 102,
  "end": 105,
  "position": 2
 },
 {
  "chapter": "درس ۱۱",
  "title": "جلسه اول: سوره نبأ",
  "newtitle": "جلسه اول: سوره نبأ",
  "start": 107,
  "end": 110,
  "position": 1
 },
 {
  "chapter": "درس ۱۱",
  "title": "جلسه دوم: سوره غاشیه",
  "newtitle": "جلسه دوم: سوره غاشیه",
  "start": 111,
  "end": 113,
  "position": 2
 }
]$fixes$::jsonb) as p(chapter text,title text,newtitle text,start integer,"end" integer,position integer)),
corrected as (update private.planner_topic_bank b set title=p.newtitle,page_start=p.start,page_end=p."end",revision=b.revision+1,updated_at=now() from fixes p cross join installed
 where b.id=md5('nova:planner:1405:v1:all:9:final_exam:آموزش قرآن:'||p.chapter||':'||p.position)::uuid and b.edition='1405' and b.study_field='all' and b.grade='9' and b.preparation_track='final_exam' and b.subject='آموزش قرآن' and b.chapter=p.chapter and b.title=p.title and b.position=p.position and b.page_start is null and b.page_end is null and b.revision=1 returning b.id)
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v221:all:9:final_exam:آموزش قرآن:'||p.chapter||':'||p.position)::uuid,'1405','all','9','final_exam','آموزش قرآن',p.chapter,p.title,p.start,p."end",p.position from topics p cross join installed on conflict(id) do nothing;
