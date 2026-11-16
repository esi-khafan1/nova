-- Grade 9 عربی, textbook 1405, printed pages (not Quran page references).
-- Existing untouched defaults only: compare full scope, title, position, empty pages and revision.
with installed as (insert into private.planner_seed_installations(seed_key) values ('arabic9-1405-v222') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "title": "کل درس",
  "start": 11,
  "end": 20,
  "position": 100
 },
 {
  "chapter": "درس ۱",
  "title": "واژه‌نامه",
  "start": 12,
  "end": 12,
  "position": 110
 },
 {
  "chapter": "درس ۱",
  "title": "متن و درک متن: أهلاً وسهلاً بالخريف",
  "start": 13,
  "end": 13,
  "position": 111
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین ۱",
  "start": 14,
  "end": 15,
  "position": 121
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین ۲",
  "start": 16,
  "end": 16,
  "position": 122
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین ۳",
  "start": 16,
  "end": 16,
  "position": 123
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین ۴",
  "start": 17,
  "end": 17,
  "position": 124
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین ۵",
  "start": 17,
  "end": 17,
  "position": 125
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین ۶",
  "start": 18,
  "end": 18,
  "position": 126
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین ۷",
  "start": 18,
  "end": 18,
  "position": 127
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین ۸",
  "start": 19,
  "end": 19,
  "position": 128
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین ۹",
  "start": 19,
  "end": 19,
  "position": 129
 },
 {
  "chapter": "درس ۱",
  "title": "جدول افعال و ضمایر",
  "start": 20,
  "end": 20,
  "position": 160
 },
 {
  "chapter": "درس ۲",
  "title": "کل درس",
  "start": 21,
  "end": 36,
  "position": 100
 },
 {
  "chapter": "درس ۲",
  "title": "واژه‌نامه",
  "start": 22,
  "end": 22,
  "position": 110
 },
 {
  "chapter": "درس ۲",
  "title": "متن و درک متن: العبور الآمن",
  "start": 23,
  "end": 24,
  "position": 111
 },
 {
  "chapter": "درس ۲",
  "title": "وزن، حروف اصلی و فاعل و مفعول",
  "start": 25,
  "end": 27,
  "position": 115
 },
 {
  "chapter": "درس ۲",
  "title": "تمرین ۱",
  "start": 27,
  "end": 27,
  "position": 121
 },
 {
  "chapter": "درس ۲",
  "title": "تمرین ۲",
  "start": 28,
  "end": 28,
  "position": 122
 },
 {
  "chapter": "درس ۲",
  "title": "تمرین ۳",
  "start": 29,
  "end": 29,
  "position": 123
 },
 {
  "chapter": "درس ۲",
  "title": "تمرین ۴",
  "start": 29,
  "end": 29,
  "position": 124
 },
 {
  "chapter": "درس ۲",
  "title": "تمرین ۵",
  "start": 30,
  "end": 30,
  "position": 125
 },
 {
  "chapter": "درس ۲",
  "title": "تمرین ۶",
  "start": 30,
  "end": 30,
  "position": 126
 },
 {
  "chapter": "درس ۲",
  "title": "تمرین ۷",
  "start": 31,
  "end": 31,
  "position": 127
 },
 {
  "chapter": "درس ۲",
  "title": "تمرین ۸",
  "start": 32,
  "end": 32,
  "position": 128
 },
 {
  "chapter": "درس ۲",
  "title": "نور السماء",
  "start": 33,
  "end": 33,
  "position": 150
 },
 {
  "chapter": "درس ۲",
  "title": "فعالیت علائم راهنمایی",
  "start": 36,
  "end": 36,
  "position": 151
 },
 {
  "chapter": "درس ۳",
  "title": "کل درس",
  "start": 37,
  "end": 48,
  "position": 100
 },
 {
  "chapter": "درس ۳",
  "title": "واژه‌نامه",
  "start": 38,
  "end": 38,
  "position": 110
 },
 {
  "chapter": "درس ۳",
  "title": "متن و درک متن: جسر الصداقة",
  "start": 39,
  "end": 41,
  "position": 111
 },
 {
  "chapter": "درس ۳",
  "title": "فعل امر مفرد",
  "start": 42,
  "end": 42,
  "position": 115
 },
 {
  "chapter": "درس ۳",
  "title": "تمرین ۱",
  "start": 43,
  "end": 43,
  "position": 121
 },
 {
  "chapter": "درس ۳",
  "title": "تمرین ۲",
  "start": 43,
  "end": 43,
  "position": 122
 },
 {
  "chapter": "درس ۳",
  "title": "تمرین ۳",
  "start": 44,
  "end": 44,
  "position": 123
 },
 {
  "chapter": "درس ۳",
  "title": "تمرین ۴",
  "start": 44,
  "end": 44,
  "position": 124
 },
 {
  "chapter": "درس ۳",
  "title": "تمرین ۵",
  "start": 45,
  "end": 45,
  "position": 125
 },
 {
  "chapter": "درس ۳",
  "title": "تمرین ۶",
  "start": 45,
  "end": 45,
  "position": 126
 },
 {
  "chapter": "درس ۳",
  "title": "تمرین ۷",
  "start": 46,
  "end": 46,
  "position": 127
 },
 {
  "chapter": "درس ۳",
  "title": "کنز الحکمة",
  "start": 46,
  "end": 46,
  "position": 150
 },
 {
  "chapter": "درس ۳",
  "title": "فعالیت متن دارای فعل امر",
  "start": 47,
  "end": 47,
  "position": 151
 },
 {
  "chapter": "درس ۳",
  "title": "تمرین ترجمه پایانی",
  "start": 48,
  "end": 48,
  "position": 160
 },
 {
  "chapter": "درس ۴",
  "title": "کل درس",
  "start": 49,
  "end": 60,
  "position": 100
 },
 {
  "chapter": "درس ۴",
  "title": "واژه‌نامه",
  "start": 50,
  "end": 50,
  "position": 110
 },
 {
  "chapter": "درس ۴",
  "title": "متن و درک متن: الصبر مفتاح الفرج",
  "start": 51,
  "end": 52,
  "position": 111
 },
 {
  "chapter": "درس ۴",
  "title": "فعل امر جمع و مثنی",
  "start": 53,
  "end": 54,
  "position": 115
 },
 {
  "chapter": "درس ۴",
  "title": "تمرین ۱",
  "start": 55,
  "end": 55,
  "position": 121
 },
 {
  "chapter": "درس ۴",
  "title": "تمرین ۲",
  "start": 55,
  "end": 56,
  "position": 122
 },
 {
  "chapter": "درس ۴",
  "title": "تمرین ۳",
  "start": 56,
  "end": 56,
  "position": 123
 },
 {
  "chapter": "درس ۴",
  "title": "تمرین ۴",
  "start": 57,
  "end": 57,
  "position": 124
 },
 {
  "chapter": "درس ۴",
  "title": "تمرین ۵",
  "start": 57,
  "end": 57,
  "position": 125
 },
 {
  "chapter": "درس ۴",
  "title": "کنز الحکمة",
  "start": 58,
  "end": 58,
  "position": 150
 },
 {
  "chapter": "درس ۴",
  "title": "تحقیق",
  "start": 59,
  "end": 59,
  "position": 151
 },
 {
  "chapter": "درس ۴",
  "title": "تمرین ترجمه پایانی",
  "start": 60,
  "end": 60,
  "position": 160
 },
 {
  "chapter": "درس ۵",
  "title": "کل درس",
  "start": 61,
  "end": 74,
  "position": 100
 },
 {
  "chapter": "درس ۵",
  "title": "واژه‌نامه",
  "start": 62,
  "end": 62,
  "position": 110
 },
 {
  "chapter": "درس ۵",
  "title": "متن و درک متن: الرجاء",
  "start": 63,
  "end": 65,
  "position": 111
 },
 {
  "chapter": "درس ۵",
  "title": "فعل نهی مفرد",
  "start": 66,
  "end": 66,
  "position": 115
 },
 {
  "chapter": "درس ۵",
  "title": "تمرین ۱",
  "start": 67,
  "end": 67,
  "position": 121
 },
 {
  "chapter": "درس ۵",
  "title": "تمرین ۲",
  "start": 67,
  "end": 67,
  "position": 122
 },
 {
  "chapter": "درس ۵",
  "title": "تمرین ۳",
  "start": 68,
  "end": 68,
  "position": 123
 },
 {
  "chapter": "درس ۵",
  "title": "تمرین ۴",
  "start": 69,
  "end": 69,
  "position": 124
 },
 {
  "chapter": "درس ۵",
  "title": "تمرین ۵",
  "start": 69,
  "end": 69,
  "position": 125
 },
 {
  "chapter": "درس ۵",
  "title": "تمرین ۶",
  "start": 70,
  "end": 70,
  "position": 126
 },
 {
  "chapter": "درس ۵",
  "title": "کنز الحکمة",
  "start": 71,
  "end": 71,
  "position": 150
 },
 {
  "chapter": "درس ۵",
  "title": "تحقیق",
  "start": 72,
  "end": 72,
  "position": 151
 },
 {
  "chapter": "درس ۵",
  "title": "تمرین ترجمه پایانی",
  "start": 73,
  "end": 74,
  "position": 160
 },
 {
  "chapter": "درس ۶",
  "title": "کل درس",
  "start": 75,
  "end": 86,
  "position": 100
 },
 {
  "chapter": "درس ۶",
  "title": "واژه‌نامه",
  "start": 76,
  "end": 76,
  "position": 110
 },
 {
  "chapter": "درس ۶",
  "title": "متن و درک متن: تغییر الحیاة",
  "start": 77,
  "end": 78,
  "position": 111
 },
 {
  "chapter": "درس ۶",
  "title": "فعل نهی جمع و مثنی",
  "start": 79,
  "end": 80,
  "position": 115
 },
 {
  "chapter": "درس ۶",
  "title": "تمرین ۱",
  "start": 81,
  "end": 81,
  "position": 121
 },
 {
  "chapter": "درس ۶",
  "title": "تمرین ۲",
  "start": 81,
  "end": 82,
  "position": 122
 },
 {
  "chapter": "درس ۶",
  "title": "تمرین ۳",
  "start": 82,
  "end": 82,
  "position": 123
 },
 {
  "chapter": "درس ۶",
  "title": "کنز الحکمة",
  "start": 83,
  "end": 83,
  "position": 150
 },
 {
  "chapter": "درس ۶",
  "title": "تحقیق",
  "start": 84,
  "end": 84,
  "position": 151
 },
 {
  "chapter": "درس ۶",
  "title": "تمرین ترجمه پایانی",
  "start": 85,
  "end": 86,
  "position": 160
 },
 {
  "chapter": "درس ۷",
  "title": "کل درس",
  "start": 87,
  "end": 98,
  "position": 100
 },
 {
  "chapter": "درس ۷",
  "title": "واژه‌نامه",
  "start": 88,
  "end": 88,
  "position": 110
 },
 {
  "chapter": "درس ۷",
  "title": "متن و درک متن: ثمرة الجد",
  "start": 89,
  "end": 90,
  "position": 111
 },
 {
  "chapter": "درس ۷",
  "title": "ترکیب وصفی و اضافی",
  "start": 91,
  "end": 93,
  "position": 115
 },
 {
  "chapter": "درس ۷",
  "title": "تمرین ۱",
  "start": 94,
  "end": 94,
  "position": 121
 },
 {
  "chapter": "درس ۷",
  "title": "تمرین ۲",
  "start": 94,
  "end": 95,
  "position": 122
 },
 {
  "chapter": "درس ۷",
  "title": "تمرین ۳",
  "start": 95,
  "end": 95,
  "position": 123
 },
 {
  "chapter": "درس ۷",
  "title": "تمرین ۴",
  "start": 96,
  "end": 96,
  "position": 124
 },
 {
  "chapter": "درس ۷",
  "title": "تمرین ۵",
  "start": 96,
  "end": 96,
  "position": 125
 },
 {
  "chapter": "درس ۷",
  "title": "کنز الحکمة",
  "start": 97,
  "end": 97,
  "position": 150
 },
 {
  "chapter": "درس ۷",
  "title": "تحقیق",
  "start": 97,
  "end": 97,
  "position": 151
 },
 {
  "chapter": "درس ۷",
  "title": "تمرین ترجمه پایانی",
  "start": 98,
  "end": 98,
  "position": 160
 },
 {
  "chapter": "درس ۸",
  "title": "کل درس",
  "start": 99,
  "end": 110,
  "position": 100
 },
 {
  "chapter": "درس ۸",
  "title": "واژه‌نامه",
  "start": 100,
  "end": 100,
  "position": 110
 },
 {
  "chapter": "درس ۸",
  "title": "متن و درک متن: حوار بین الزائر وسائق سیارة الأجرة",
  "start": 101,
  "end": 102,
  "position": 111
 },
 {
  "chapter": "درس ۸",
  "title": "ماضی استمراری",
  "start": 103,
  "end": 104,
  "position": 115
 },
 {
  "chapter": "درس ۸",
  "title": "تمرین ۱",
  "start": 104,
  "end": 104,
  "position": 121
 },
 {
  "chapter": "درس ۸",
  "title": "تمرین ۲",
  "start": 105,
  "end": 105,
  "position": 122
 },
 {
  "chapter": "درس ۸",
  "title": "تمرین ۳",
  "start": 105,
  "end": 105,
  "position": 123
 },
 {
  "chapter": "درس ۸",
  "title": "تمرین ۴",
  "start": 106,
  "end": 106,
  "position": 124
 },
 {
  "chapter": "درس ۸",
  "title": "تمرین ۵",
  "start": 106,
  "end": 106,
  "position": 125
 },
 {
  "chapter": "درس ۸",
  "title": "تمرین ۶",
  "start": 107,
  "end": 107,
  "position": 126
 },
 {
  "chapter": "درس ۸",
  "title": "تمرین ۷",
  "start": 108,
  "end": 108,
  "position": 127
 },
 {
  "chapter": "درس ۸",
  "title": "کنز الحکمة",
  "start": 109,
  "end": 109,
  "position": 150
 },
 {
  "chapter": "درس ۸",
  "title": "تحقیق",
  "start": 109,
  "end": 109,
  "position": 151
 },
 {
  "chapter": "درس ۸",
  "title": "تمرین ترجمه پایانی",
  "start": 110,
  "end": 110,
  "position": 160
 },
 {
  "chapter": "درس ۹",
  "title": "کل درس",
  "start": 111,
  "end": 124,
  "position": 100
 },
 {
  "chapter": "درس ۹",
  "title": "واژه‌نامه",
  "start": 112,
  "end": 112,
  "position": 110
 },
 {
  "chapter": "درس ۹",
  "title": "متن و درک متن: نصوص حول الصحة",
  "start": 113,
  "end": 114,
  "position": 111
 },
 {
  "chapter": "درس ۹",
  "title": "ساعت‌خوانی",
  "start": 115,
  "end": 117,
  "position": 115
 },
 {
  "chapter": "درس ۹",
  "title": "تمرین ۱",
  "start": 117,
  "end": 117,
  "position": 121
 },
 {
  "chapter": "درس ۹",
  "title": "تمرین ۲",
  "start": 118,
  "end": 119,
  "position": 122
 },
 {
  "chapter": "درس ۹",
  "title": "تمرین ۳",
  "start": 119,
  "end": 120,
  "position": 123
 },
 {
  "chapter": "درس ۹",
  "title": "تمرین ۴",
  "start": 120,
  "end": 120,
  "position": 124
 },
 {
  "chapter": "درس ۹",
  "title": "تمرین ۵",
  "start": 121,
  "end": 121,
  "position": 125
 },
 {
  "chapter": "درس ۹",
  "title": "تمرین ۶",
  "start": 121,
  "end": 121,
  "position": 126
 },
 {
  "chapter": "درس ۹",
  "title": "کنز الحکمة",
  "start": 122,
  "end": 123,
  "position": 150
 },
 {
  "chapter": "درس ۹",
  "title": "تحقیق",
  "start": 124,
  "end": 124,
  "position": 151
 },
 {
  "chapter": "درس ۱۰",
  "title": "کل درس",
  "start": 125,
  "end": 134,
  "position": 100
 },
 {
  "chapter": "درس ۱۰",
  "title": "واژه‌نامه",
  "start": 126,
  "end": 126,
  "position": 110
 },
 {
  "chapter": "درس ۱۰",
  "title": "متن و درک متن: رسالة الشهید سلیمانی",
  "start": 127,
  "end": 129,
  "position": 111
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین عمومی ۱",
  "start": 129,
  "end": 129,
  "position": 121
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین عمومی ۲",
  "start": 130,
  "end": 130,
  "position": 122
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین عمومی ۳",
  "start": 130,
  "end": 130,
  "position": 123
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین عمومی ۴",
  "start": 131,
  "end": 131,
  "position": 124
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین عمومی ۵",
  "start": 131,
  "end": 131,
  "position": 125
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین عمومی ۶",
  "start": 132,
  "end": 132,
  "position": 126
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین عمومی ۷",
  "start": 132,
  "end": 132,
  "position": 127
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین عمومی ۸",
  "start": 133,
  "end": 133,
  "position": 128
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین عمومی ۹",
  "start": 133,
  "end": 134,
  "position": 129
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer)),
fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "درس ۱",
  "title": "متن و واژگان: مراجعة دروس الصف السابع و الثامن",
  "newtitle": "متن و واژگان: أهلاً وسهلاً بالخريف",
  "start": 12,
  "end": 13,
  "position": 1
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین‌های درس",
  "newtitle": "تمرین‌های درس",
  "start": 14,
  "end": 19,
  "position": 2
 },
 {
  "chapter": "درس ۲",
  "title": "متن و واژگان: العبور الآمن",
  "newtitle": "متن و واژگان: العبور الآمن",
  "start": 22,
  "end": 24,
  "position": 1
 },
 {
  "chapter": "درس ۲",
  "title": "تمرین‌های درس",
  "newtitle": "تمرین‌های درس",
  "start": 27,
  "end": 32,
  "position": 2
 },
 {
  "chapter": "درس ۳",
  "title": "متن و واژگان: جسر الصداقة",
  "newtitle": "متن و واژگان: جسر الصداقة",
  "start": 38,
  "end": 41,
  "position": 1
 },
 {
  "chapter": "درس ۳",
  "title": "تمرین‌های درس",
  "newtitle": "تمرین‌های درس",
  "start": 43,
  "end": 46,
  "position": 2
 },
 {
  "chapter": "درس ۴",
  "title": "متن و واژگان: الصبر مفتاح الفرج",
  "newtitle": "متن و واژگان: الصبر مفتاح الفرج",
  "start": 50,
  "end": 52,
  "position": 1
 },
 {
  "chapter": "درس ۴",
  "title": "تمرین‌های درس",
  "newtitle": "تمرین‌های درس",
  "start": 55,
  "end": 57,
  "position": 2
 },
 {
  "chapter": "درس ۵",
  "title": "متن و واژگان: الرجاء",
  "newtitle": "متن و واژگان: الرجاء",
  "start": 62,
  "end": 65,
  "position": 1
 },
 {
  "chapter": "درس ۵",
  "title": "تمرین‌های درس",
  "newtitle": "تمرین‌های درس",
  "start": 67,
  "end": 70,
  "position": 2
 },
 {
  "chapter": "درس ۶",
  "title": "متن و واژگان: تغییر الحیاة",
  "newtitle": "متن و واژگان: تغییر الحیاة",
  "start": 76,
  "end": 78,
  "position": 1
 },
 {
  "chapter": "درس ۶",
  "title": "تمرین‌های درس",
  "newtitle": "تمرین‌های درس",
  "start": 81,
  "end": 82,
  "position": 2
 },
 {
  "chapter": "درس ۷",
  "title": "متن و واژگان: ثمرة الجد",
  "newtitle": "متن و واژگان: ثمرة الجد",
  "start": 88,
  "end": 90,
  "position": 1
 },
 {
  "chapter": "درس ۷",
  "title": "تمرین‌های درس",
  "newtitle": "تمرین‌های درس",
  "start": 94,
  "end": 96,
  "position": 2
 },
 {
  "chapter": "درس ۸",
  "title": "متن و واژگان: حوار بین الزائر و سائق سیارة الأجرة",
  "newtitle": "متن و واژگان: حوار بین الزائر و سائق سیارة الأجرة",
  "start": 100,
  "end": 102,
  "position": 1
 },
 {
  "chapter": "درس ۸",
  "title": "تمرین‌های درس",
  "newtitle": "تمرین‌های درس",
  "start": 104,
  "end": 108,
  "position": 2
 },
 {
  "chapter": "درس ۹",
  "title": "متن و واژگان: نصوص حول الصحة",
  "newtitle": "متن و واژگان: نصوص حول الصحة",
  "start": 112,
  "end": 114,
  "position": 1
 },
 {
  "chapter": "درس ۹",
  "title": "تمرین‌های درس",
  "newtitle": "تمرین‌های درس",
  "start": 117,
  "end": 121,
  "position": 2
 },
 {
  "chapter": "درس ۱۰",
  "title": "متن و واژگان: رسالة الشهید سلیمانی",
  "newtitle": "متن و واژگان: رسالة الشهید سلیمانی",
  "start": 126,
  "end": 129,
  "position": 1
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین‌های درس",
  "newtitle": "تمرین‌های درس",
  "start": 129,
  "end": 134,
  "position": 2
 }
]$fixes$::jsonb) as p(chapter text,title text,newtitle text,start integer,"end" integer,position integer)),
corrected as (update private.planner_topic_bank b set title=p.newtitle,page_start=p.start,page_end=p."end",revision=b.revision+1,updated_at=now() from fixes p cross join installed
 where b.id=md5('nova:planner:1405:v1:all:9:final_exam:عربی:'||p.chapter||':'||p.position)::uuid and b.edition='1405' and b.study_field='all' and b.grade='9' and b.preparation_track='final_exam' and b.subject='عربی' and b.chapter=p.chapter and b.title=p.title and b.position=p.position and b.page_start is null and b.page_end is null and b.revision=1 returning b.id)
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v222:all:9:final_exam:عربی:'||p.chapter||':'||p.position)::uuid,'1405','all','9','final_exam','عربی',p.chapter,p.title,p.start,p."end",p.position from topics p cross join installed on conflict(id) do nothing;
