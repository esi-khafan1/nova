-- Psychology 111224, 1405, user-provided PDF. Printed-page lesson sections.
-- Existing groups, administrator changes, and snapshots are not rewritten.
with installed as (insert into private.planner_seed_installations(seed_key) values ('psychology-independent-1405-v182') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 300,
  "title": "کل درس",
  "start": 8,
  "end": 33
 },
 {
  "chapter": "درس ۱",
  "position": 301,
  "title": "مقدمه و کاربرد روان‌شناسی",
  "start": 10,
  "end": 11
 },
 {
  "chapter": "درس ۱",
  "position": 302,
  "title": "منابع کسب آگاهی و معرفت",
  "start": 11,
  "end": 12
 },
 {
  "chapter": "درس ۱",
  "position": 303,
  "title": "علم تجربی و فرضیه و نظریه",
  "start": 12,
  "end": 13
 },
 {
  "chapter": "درس ۱",
  "position": 304,
  "title": "هدف‌های علم روان‌شناسی",
  "start": 14,
  "end": 16
 },
 {
  "chapter": "درس ۱",
  "position": 305,
  "title": "روش علمی و ویژگی‌های آن",
  "start": 16,
  "end": 19
 },
 {
  "chapter": "درس ۱",
  "position": 306,
  "title": "تعریف روان‌شناسی و شناخت",
  "start": 20,
  "end": 22
 },
 {
  "chapter": "درس ۱",
  "position": 307,
  "title": "ماجرای تولد علم تجربی",
  "start": 23,
  "end": 26
 },
 {
  "chapter": "درس ۱",
  "position": 308,
  "title": "روش‌های جمع‌آوری اطلاعات",
  "start": 27,
  "end": 28
 },
 {
  "chapter": "درس ۱",
  "position": 309,
  "title": "نقش دستگاه عصبی",
  "start": 29,
  "end": 30
 },
 {
  "chapter": "درس ۱",
  "position": 310,
  "title": "گرایش‌های روان‌شناسی",
  "start": 31,
  "end": 31
 },
 {
  "chapter": "درس ۱",
  "position": 311,
  "title": "جمع‌بندی و واژگان",
  "start": 32,
  "end": 33
 },
 {
  "chapter": "درس ۲",
  "position": 300,
  "title": "کل درس",
  "start": 34,
  "end": 65
 },
 {
  "chapter": "درس ۲",
  "position": 301,
  "title": "تعریف روان‌شناسی رشد",
  "start": 37,
  "end": 38
 },
 {
  "chapter": "درس ۲",
  "position": 302,
  "title": "عوامل وراثتی و رسش",
  "start": 38,
  "end": 41
 },
 {
  "chapter": "درس ۲",
  "position": 303,
  "title": "عوامل محیطی و مراحل رشد",
  "start": 42,
  "end": 44
 },
 {
  "chapter": "درس ۲",
  "position": 304,
  "title": "دوره پیش از تولد",
  "start": 45,
  "end": 45
 },
 {
  "chapter": "درس ۲",
  "position": 305,
  "title": "رشد جسمانی و حرکتی در کودکی",
  "start": 45,
  "end": 47
 },
 {
  "chapter": "درس ۲",
  "position": 306,
  "title": "رشد شناختی در کودکی",
  "start": 48,
  "end": 48
 },
 {
  "chapter": "درس ۲",
  "position": 307,
  "title": "رشد هیجانی و اجتماعی در کودکی",
  "start": 49,
  "end": 50
 },
 {
  "chapter": "درس ۲",
  "position": 308,
  "title": "رشد اخلاقی در کودکی",
  "start": 51,
  "end": 52
 },
 {
  "chapter": "درس ۲",
  "position": 309,
  "title": "دوره نوجوانی و بلوغ",
  "start": 52,
  "end": 54
 },
 {
  "chapter": "درس ۲",
  "position": 310,
  "title": "رشد شناختی و هیجانی نوجوانی",
  "start": 55,
  "end": 57
 },
 {
  "chapter": "درس ۲",
  "position": 311,
  "title": "رشد اجتماعی و شکل‌گیری هویت",
  "start": 58,
  "end": 60
 },
 {
  "chapter": "درس ۲",
  "position": 312,
  "title": "رشد اخلاقی و خود آرمانی و واقعی",
  "start": 61,
  "end": 63
 },
 {
  "chapter": "درس ۲",
  "position": 313,
  "title": "جمع‌بندی و واژگان",
  "start": 64,
  "end": 65
 },
 {
  "chapter": "درس ۳",
  "position": 300,
  "title": "کل درس",
  "start": 66,
  "end": 87
 },
 {
  "chapter": "درس ۳",
  "position": 301,
  "title": "احساس و حواس مختلف",
  "start": 68,
  "end": 72
 },
 {
  "chapter": "درس ۳",
  "position": 302,
  "title": "توجه و انتخاب محرک‌ها",
  "start": 73,
  "end": 75
 },
 {
  "chapter": "درس ۳",
  "position": 303,
  "title": "موانع و عوامل ایجاد تمرکز",
  "start": 75,
  "end": 77
 },
 {
  "chapter": "درس ۳",
  "position": 304,
  "title": "کارکردها و ساماندهی توجه",
  "start": 77,
  "end": 81
 },
 {
  "chapter": "درس ۳",
  "position": 305,
  "title": "ادراک و تفسیر محرک‌ها",
  "start": 81,
  "end": 83
 },
 {
  "chapter": "درس ۳",
  "position": 306,
  "title": "اصول روان‌شناسی گشتالت",
  "start": 83,
  "end": 85
 },
 {
  "chapter": "درس ۳",
  "position": 307,
  "title": "جمع‌بندی و واژگان",
  "start": 86,
  "end": 87
 },
 {
  "chapter": "درس ۴",
  "position": 300,
  "title": "کل درس",
  "start": 88,
  "end": 111
 },
 {
  "chapter": "درس ۴",
  "position": 301,
  "title": "مراحل حافظه: رمزگردانی، ذخیره و بازیابی",
  "start": 91,
  "end": 94
 },
 {
  "chapter": "درس ۴",
  "position": 302,
  "title": "انواع حافظه",
  "start": 94,
  "end": 98
 },
 {
  "chapter": "درس ۴",
  "position": 303,
  "title": "خطاهای حافظه",
  "start": 99,
  "end": 99
 },
 {
  "chapter": "درس ۴",
  "position": 304,
  "title": "عوامل ایجاد فراموشی",
  "start": 100,
  "end": 104
 },
 {
  "chapter": "درس ۴",
  "position": 305,
  "title": "روش‌های مطالعه و بهسازی حافظه",
  "start": 105,
  "end": 109
 },
 {
  "chapter": "درس ۴",
  "position": 306,
  "title": "جمع‌بندی و واژگان",
  "start": 110,
  "end": 111
 },
 {
  "chapter": "درس ۵",
  "position": 300,
  "title": "کل درس",
  "start": 112,
  "end": 133
 },
 {
  "chapter": "درس ۵",
  "position": 301,
  "title": "تعریف و ویژگی‌های حل مسئله",
  "start": 114,
  "end": 116
 },
 {
  "chapter": "درس ۵",
  "position": 302,
  "title": "اهمیت و انواع مسئله",
  "start": 117,
  "end": 118
 },
 {
  "chapter": "درس ۵",
  "position": 303,
  "title": "مراحل حل مسئله",
  "start": 119,
  "end": 120
 },
 {
  "chapter": "درس ۵",
  "position": 304,
  "title": "عوامل مؤثر بر حل مسئله",
  "start": 121,
  "end": 123
 },
 {
  "chapter": "درس ۵",
  "position": 305,
  "title": "روش‌های تحلیلی و اکتشافی",
  "start": 123,
  "end": 125
 },
 {
  "chapter": "درس ۵",
  "position": 306,
  "title": "خرد کردن و کاهش تفاوت",
  "start": 126,
  "end": 127
 },
 {
  "chapter": "درس ۵",
  "position": 307,
  "title": "بارش مغزی و شروع از آخر",
  "start": 128,
  "end": 129
 },
 {
  "chapter": "درس ۵",
  "position": 308,
  "title": "پیامدهای ناتوانی در حل مسئله",
  "start": 130,
  "end": 131
 },
 {
  "chapter": "درس ۵",
  "position": 309,
  "title": "جمع‌بندی و واژگان",
  "start": 132,
  "end": 133
 },
 {
  "chapter": "درس ۶",
  "position": 300,
  "title": "کل درس",
  "start": 134,
  "end": 157
 },
 {
  "chapter": "درس ۶",
  "position": 301,
  "title": "تعریف تصمیم‌گیری و تفاوت آن با حل مسئله",
  "start": 136,
  "end": 138
 },
 {
  "chapter": "درس ۶",
  "position": 302,
  "title": "انواع تصمیم‌گیری",
  "start": 138,
  "end": 140
 },
 {
  "chapter": "درس ۶",
  "position": 303,
  "title": "ملاک‌های تصمیم‌گیری",
  "start": 141,
  "end": 141
 },
 {
  "chapter": "درس ۶",
  "position": 304,
  "title": "سبک‌های تکانشی، احساسی و وابسته",
  "start": 142,
  "end": 145
 },
 {
  "chapter": "درس ۶",
  "position": 305,
  "title": "سبک‌های اجتنابی و منطقی",
  "start": 146,
  "end": 147
 },
 {
  "chapter": "درس ۶",
  "position": 306,
  "title": "مراحل تصمیم‌گیری",
  "start": 148,
  "end": 148
 },
 {
  "chapter": "درس ۶",
  "position": 307,
  "title": "موانع و پیامدهای ناتوانی در تصمیم‌گیری",
  "start": 149,
  "end": 150
 },
 {
  "chapter": "درس ۶",
  "position": 308,
  "title": "انواع تعارض",
  "start": 151,
  "end": 152
 },
 {
  "chapter": "درس ۶",
  "position": 309,
  "title": "پیشنهادهایی برای تصمیم‌گیری بهتر",
  "start": 153,
  "end": 155
 },
 {
  "chapter": "درس ۶",
  "position": 310,
  "title": "جمع‌بندی و واژگان",
  "start": 156,
  "end": 157
 },
 {
  "chapter": "درس ۷",
  "position": 300,
  "title": "کل درس",
  "start": 158,
  "end": 185
 },
 {
  "chapter": "درس ۷",
  "position": 301,
  "title": "انگیزه و نگرش",
  "start": 160,
  "end": 162
 },
 {
  "chapter": "درس ۷",
  "position": 302,
  "title": "انگیزه‌های درونی و بیرونی",
  "start": 163,
  "end": 164
 },
 {
  "chapter": "درس ۷",
  "position": 303,
  "title": "باورها و نظام ارزشی",
  "start": 165,
  "end": 167
 },
 {
  "chapter": "درس ۷",
  "position": 304,
  "title": "هدفمندی و انتخاب هدف",
  "start": 168,
  "end": 168
 },
 {
  "chapter": "درس ۷",
  "position": 305,
  "title": "ناهماهنگی شناختی",
  "start": 169,
  "end": 171
 },
 {
  "chapter": "درس ۷",
  "position": 306,
  "title": "ادراک کنترل و کارایی",
  "start": 172,
  "end": 175
 },
 {
  "chapter": "درس ۷",
  "position": 307,
  "title": "درماندگی آموخته‌شده",
  "start": 176,
  "end": 180
 },
 {
  "chapter": "درس ۷",
  "position": 308,
  "title": "نیازهای انسان",
  "start": 182,
  "end": 183
 },
 {
  "chapter": "درس ۷",
  "position": 309,
  "title": "جمع‌بندی و واژگان",
  "start": 184,
  "end": 185
 },
 {
  "chapter": "درس ۸",
  "position": 300,
  "title": "کل درس",
  "start": 186,
  "end": 206
 },
 {
  "chapter": "درس ۸",
  "position": 301,
  "title": "روان‌شناسی سلامت و بیماری",
  "start": 189,
  "end": 190
 },
 {
  "chapter": "درس ۸",
  "position": 302,
  "title": "نقش متقابل عوامل جسمانی و روانی",
  "start": 191,
  "end": 191
 },
 {
  "chapter": "درس ۸",
  "position": 303,
  "title": "سبک زندگی و بیماری",
  "start": 192,
  "end": 194
 },
 {
  "chapter": "درس ۸",
  "position": 304,
  "title": "فشار روانی و نشانه‌ها",
  "start": 195,
  "end": 197
 },
 {
  "chapter": "درس ۸",
  "position": 305,
  "title": "مقابله سازگارانه با فشار روانی",
  "start": 198,
  "end": 201
 },
 {
  "chapter": "درس ۸",
  "position": 306,
  "title": "مقابله ناسازگارانه",
  "start": 202,
  "end": 203
 },
 {
  "chapter": "درس ۸",
  "position": 307,
  "title": "تأثیر مذهب بر سلامت",
  "start": 204,
  "end": 205
 },
 {
  "chapter": "درس ۸",
  "position": 308,
  "title": "جمع‌بندی و واژگان",
  "start": 206,
  "end": 206
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v182:humanities:11:'||r.track||':روان‌شناسی:'||p.chapter||':'||p.position)::uuid,'1405','humanities','11',r.track,'روان‌شناسی',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
