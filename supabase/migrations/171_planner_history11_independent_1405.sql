-- History 2 (111219, 1405): independent subheadings, lessons 1–7.
-- Additive one-time seed; earlier grouped rows and administrator changes are preserved.
with installed as (insert into private.planner_seed_installations(seed_key) values ('history11-independent-1405-v171') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 301,
  "title": "محوطه‌ها و بناهای تاریخی",
  "start": 2,
  "end": 3
 },
 {
  "chapter": "درس ۱",
  "position": 302,
  "title": "ابزارها و وسایل دست‌ساخته انسان",
  "start": 3,
  "end": 3
 },
 {
  "chapter": "درس ۱",
  "position": 303,
  "title": "آثار شفاهی",
  "start": 3,
  "end": 4
 },
 {
  "chapter": "درس ۱",
  "position": 304,
  "title": "قرآن کریم",
  "start": 4,
  "end": 4
 },
 {
  "chapter": "درس ۱",
  "position": 305,
  "title": "حدیث و سیره نبوی",
  "start": 4,
  "end": 4
 },
 {
  "chapter": "درس ۱",
  "position": 306,
  "title": "تاریخ‌های عمومی",
  "start": 4,
  "end": 5
 },
 {
  "chapter": "درس ۱",
  "position": 307,
  "title": "تاریخ‌های محلی",
  "start": 5,
  "end": 6
 },
 {
  "chapter": "درس ۱",
  "position": 308,
  "title": "تاریخ‌های سلسله‌ای",
  "start": 6,
  "end": 6
 },
 {
  "chapter": "درس ۱",
  "position": 309,
  "title": "تک‌نگاری",
  "start": 6,
  "end": 7
 },
 {
  "chapter": "درس ۱",
  "position": 310,
  "title": "تاریخ‌های منظوم",
  "start": 7,
  "end": 7
 },
 {
  "chapter": "درس ۱",
  "position": 311,
  "title": "سفرنامه‌ها",
  "start": 7,
  "end": 8
 },
 {
  "chapter": "درس ۱",
  "position": 312,
  "title": "نوشته‌های جغرافیایی",
  "start": 8,
  "end": 10
 },
 {
  "chapter": "درس ۱",
  "position": 313,
  "title": "ادبیات و متون ادبی",
  "start": 10,
  "end": 11
 },
 {
  "chapter": "درس ۱",
  "position": 314,
  "title": "سیاست‌نامه‌ها و اندرزنامه‌ها",
  "start": 11,
  "end": 11
 },
 {
  "chapter": "درس ۱",
  "position": 315,
  "title": "سایر نوشته‌ها",
  "start": 11,
  "end": 12
 },
 {
  "chapter": "درس ۲",
  "position": 301,
  "title": "سنجش اعتبار و نقد راوی",
  "start": 14,
  "end": 15
 },
 {
  "chapter": "درس ۲",
  "position": 302,
  "title": "مطابقت با عقل",
  "start": 15,
  "end": 15
 },
 {
  "chapter": "درس ۲",
  "position": 303,
  "title": "مقایسه و تطبیق با سایر منابع و شواهد",
  "start": 15,
  "end": 16
 },
 {
  "chapter": "درس ۲",
  "position": 304,
  "title": "مطابقت با نتایج تحقیقات باستان‌شناسی",
  "start": 16,
  "end": 16
 },
 {
  "chapter": "درس ۲",
  "position": 305,
  "title": "سنجش گزارش‌ها براساس زمان و مکان",
  "start": 16,
  "end": 16
 },
 {
  "chapter": "درس ۲",
  "position": 306,
  "title": "اعتبارسنجی با تکیه بر دستاوردهای علوم تجربی",
  "start": 16,
  "end": 17
 },
 {
  "chapter": "درس ۲",
  "position": 307,
  "title": "اعتبارسنجی به کمک دستاوردهای سایر علوم انسانی",
  "start": 17,
  "end": 17
 },
 {
  "chapter": "درس ۲",
  "position": 308,
  "title": "تاریخ‌نگاری روایی",
  "start": 17,
  "end": 17
 },
 {
  "chapter": "درس ۲",
  "position": 309,
  "title": "تاریخ‌نگاری ترکیبی",
  "start": 17,
  "end": 18
 },
 {
  "chapter": "درس ۲",
  "position": 310,
  "title": "تاریخ‌نگاری تحلیلی",
  "start": 18,
  "end": 18
 },
 {
  "chapter": "درس ۳",
  "position": 301,
  "title": "نظام اجتماعی و سیاسی شبه‌جزیره عربستان",
  "start": 21,
  "end": 22
 },
 {
  "chapter": "درس ۳",
  "position": 302,
  "title": "اقتصاد و معیشت",
  "start": 22,
  "end": 22
 },
 {
  "chapter": "درس ۳",
  "position": 303,
  "title": "علم و فرهنگ",
  "start": 22,
  "end": 23
 },
 {
  "chapter": "درس ۳",
  "position": 304,
  "title": "دین و اعتقادات",
  "start": 23,
  "end": 24
 },
 {
  "chapter": "درس ۳",
  "position": 305,
  "title": "بعثت پیامبر",
  "start": 25,
  "end": 26
 },
 {
  "chapter": "درس ۳",
  "position": 306,
  "title": "دعوت خاص و محدود",
  "start": 27,
  "end": 28
 },
 {
  "chapter": "درس ۳",
  "position": 307,
  "title": "دعوت عمومی و عکس‌العمل سران قریش",
  "start": 28,
  "end": 29
 },
 {
  "chapter": "درس ۳",
  "position": 308,
  "title": "تحریم و محاصره اجتماعی و اقتصادی بنی‌هاشم",
  "start": 29,
  "end": 30
 },
 {
  "chapter": "درس ۳",
  "position": 309,
  "title": "در اندیشه پایگاهی جدید برای اسلام",
  "start": 30,
  "end": 30
 },
 {
  "chapter": "درس ۴",
  "position": 301,
  "title": "اوضاع اجتماعی، سیاسی و اقتصادی مدینه",
  "start": 31,
  "end": 33
 },
 {
  "chapter": "درس ۴",
  "position": 302,
  "title": "ارتباط مردم یثرب با رسول خدا",
  "start": 33,
  "end": 34
 },
 {
  "chapter": "درس ۴",
  "position": 303,
  "title": "هجرت پیامبر و پیروانش از مکه به مدینه",
  "start": 34,
  "end": 35
 },
 {
  "chapter": "درس ۴",
  "position": 304,
  "title": "سکونت مهاجران در مدینه",
  "start": 35,
  "end": 35
 },
 {
  "chapter": "درس ۴",
  "position": 305,
  "title": "پیمان برادری و تحکیم وحدت دینی",
  "start": 36,
  "end": 36
 },
 {
  "chapter": "درس ۴",
  "position": 306,
  "title": "پیمان‌نامه عمومی مدینه",
  "start": 36,
  "end": 38
 },
 {
  "chapter": "درس ۴",
  "position": 307,
  "title": "مخالفت مشرکان",
  "start": 38,
  "end": 39
 },
 {
  "chapter": "درس ۴",
  "position": 308,
  "title": "مخالفت منافقان",
  "start": 39,
  "end": 39
 },
 {
  "chapter": "درس ۴",
  "position": 309,
  "title": "مخالفت یهودیان",
  "start": 39,
  "end": 39
 },
 {
  "chapter": "درس ۴",
  "position": 310,
  "title": "صلح حدیبیه و پیامدهای آن",
  "start": 39,
  "end": 40
 },
 {
  "chapter": "درس ۴",
  "position": 311,
  "title": "فتح مکه و پیامدهای آن",
  "start": 40,
  "end": 40
 },
 {
  "chapter": "درس ۴",
  "position": 312,
  "title": "اعلان برائت از مشرکان",
  "start": 40,
  "end": 41
 },
 {
  "chapter": "درس ۴",
  "position": 313,
  "title": "حجةالوداع و غدیر خم",
  "start": 41,
  "end": 41
 },
 {
  "chapter": "درس ۴",
  "position": 314,
  "title": "سپاه و مدیریت امور نظامی",
  "start": 41,
  "end": 42
 },
 {
  "chapter": "درس ۴",
  "position": 315,
  "title": "منابع مالی و شیوه گردآوری و توزیع آنها",
  "start": 42,
  "end": 42
 },
 {
  "chapter": "درس ۴",
  "position": 316,
  "title": "تعلیم و تربیت",
  "start": 42,
  "end": 42
 },
 {
  "chapter": "درس ۴",
  "position": 317,
  "title": "خلق و خوی رسول خدا",
  "start": 42,
  "end": 43
 },
 {
  "chapter": "درس ۵",
  "position": 301,
  "title": "ماجرای سقیفه و انتخاب ابوبکر به خلافت",
  "start": 44,
  "end": 46
 },
 {
  "chapter": "درس ۵",
  "position": 302,
  "title": "چالش‌های حکومت ابوبکر",
  "start": 46,
  "end": 46
 },
 {
  "chapter": "درس ۵",
  "position": 303,
  "title": "خلافت عمر و عثمان",
  "start": 46,
  "end": 47
 },
 {
  "chapter": "درس ۵",
  "position": 304,
  "title": "شورای شش نفره و خلافت عثمان",
  "start": 47,
  "end": 47
 },
 {
  "chapter": "درس ۵",
  "position": 305,
  "title": "خلافت امام علی",
  "start": 47,
  "end": 49
 },
 {
  "chapter": "درس ۵",
  "position": 306,
  "title": "اوضاع اجتماعی دوران خلفای نخستین",
  "start": 49,
  "end": 49
 },
 {
  "chapter": "درس ۵",
  "position": 307,
  "title": "تحولات اقتصادی دوران خلفای نخستین",
  "start": 49,
  "end": 51
 },
 {
  "chapter": "درس ۵",
  "position": 308,
  "title": "فتح شام",
  "start": 52,
  "end": 54
 },
 {
  "chapter": "درس ۵",
  "position": 309,
  "title": "فتح مصر",
  "start": 54,
  "end": 55
 },
 {
  "chapter": "درس ۵",
  "position": 310,
  "title": "آثار و پیامدهای فتوحات در زمان خلفای نخستین",
  "start": 55,
  "end": 55
 },
 {
  "chapter": "درس ۶",
  "position": 301,
  "title": "امویان پیش از خلافت",
  "start": 56,
  "end": 57
 },
 {
  "chapter": "درس ۶",
  "position": 302,
  "title": "حکومت معاویه بر شام",
  "start": 57,
  "end": 57
 },
 {
  "chapter": "درس ۶",
  "position": 303,
  "title": "تأسیس خلافت امویان",
  "start": 57,
  "end": 58
 },
 {
  "chapter": "درس ۶",
  "position": 304,
  "title": "فتوحات بنی‌امیه",
  "start": 58,
  "end": 59
 },
 {
  "chapter": "درس ۶",
  "position": 305,
  "title": "استفاده از زور برای کسب و حفظ قدرت",
  "start": 59,
  "end": 60
 },
 {
  "chapter": "درس ۶",
  "position": 306,
  "title": "موروثی شدن خلافت",
  "start": 60,
  "end": 60
 },
 {
  "chapter": "درس ۶",
  "position": 307,
  "title": "قومیت‌گرایی و تشدید تعصبات قبیله‌ای",
  "start": 60,
  "end": 61
 },
 {
  "chapter": "درس ۶",
  "position": 308,
  "title": "تبعیض و نابرابری اقتصادی",
  "start": 61,
  "end": 61
 },
 {
  "chapter": "درس ۶",
  "position": 309,
  "title": "ترویج تفکر جبرگرایی",
  "start": 61,
  "end": 62
 },
 {
  "chapter": "درس ۶",
  "position": 310,
  "title": "قیام امام حسین",
  "start": 62,
  "end": 64
 },
 {
  "chapter": "درس ۶",
  "position": 311,
  "title": "قیام‌های ضداموی",
  "start": 64,
  "end": 65
 },
 {
  "chapter": "درس ۶",
  "position": 312,
  "title": "امامان شیعه در دوره بنی‌امیه",
  "start": 65,
  "end": 65
 },
 {
  "chapter": "درس ۶",
  "position": 313,
  "title": "قیام عباسیان و سقوط امویان",
  "start": 65,
  "end": 66
 },
 {
  "chapter": "درس ۶",
  "position": 314,
  "title": "امویان اندلس",
  "start": 66,
  "end": 67
 },
 {
  "chapter": "درس ۶",
  "position": 315,
  "title": "اندلس: رفاه و رونق اقتصادی",
  "start": 67,
  "end": 67
 },
 {
  "chapter": "درس ۶",
  "position": 316,
  "title": "اندلس: پیشرفت علمی",
  "start": 67,
  "end": 68
 },
 {
  "chapter": "درس ۶",
  "position": 317,
  "title": "اندلس: شکوفایی معماری",
  "start": 68,
  "end": 68
 },
 {
  "chapter": "درس ۷",
  "position": 301,
  "title": "استقرار و تثبیت خلافت عباسیان",
  "start": 69,
  "end": 71
 },
 {
  "chapter": "درس ۷",
  "position": 302,
  "title": "دوره نیرومندی و شکوفایی عباسیان",
  "start": 71,
  "end": 73
 },
 {
  "chapter": "درس ۷",
  "position": 303,
  "title": "نقش و جایگاه ایرانیان در خلافت عباسیان",
  "start": 72,
  "end": 73
 },
 {
  "chapter": "درس ۷",
  "position": 304,
  "title": "دوره ضعف و تجزیه عباسیان",
  "start": 73,
  "end": 74
 },
 {
  "chapter": "درس ۷",
  "position": 305,
  "title": "نظام اداری عباسیان",
  "start": 74,
  "end": 75
 },
 {
  "chapter": "درس ۷",
  "position": 306,
  "title": "زمینه‌ها و علل شکوفایی علمی و فکری",
  "start": 75,
  "end": 76
 },
 {
  "chapter": "درس ۷",
  "position": 307,
  "title": "علوم در قرن اول هجری",
  "start": 75,
  "end": 76
 },
 {
  "chapter": "درس ۷",
  "position": 308,
  "title": "اوج‌گیری فعالیت‌های علمی و فکری مسلمانان",
  "start": 76,
  "end": 77
 },
 {
  "chapter": "درس ۷",
  "position": 309,
  "title": "نهضت ترجمه",
  "start": 76,
  "end": 77
 },
 {
  "chapter": "درس ۷",
  "position": 310,
  "title": "نقش علمی و فرهنگی امامان",
  "start": 77,
  "end": 78
 },
 {
  "chapter": "درس ۷",
  "position": 311,
  "title": "تأسیس خلافت فاطمیان",
  "start": 78,
  "end": 79
 },
 {
  "chapter": "درس ۷",
  "position": 312,
  "title": "روابط فاطمیان و عباسیان",
  "start": 79,
  "end": 80
 },
 {
  "chapter": "درس ۷",
  "position": 313,
  "title": "سیاست مذهبی فاطمیان",
  "start": 80,
  "end": 80
 },
 {
  "chapter": "درس ۷",
  "position": 314,
  "title": "فعالیت‌های علمی و فرهنگی فاطمیان",
  "start": 80,
  "end": 81
 },
 {
  "chapter": "درس ۷",
  "position": 315,
  "title": "معماری فاطمیان",
  "start": 80,
  "end": 81
 },
 {
  "chapter": "درس ۷",
  "position": 316,
  "title": "هنر و صنایع فاطمیان",
  "start": 81,
  "end": 82
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v171:humanities:11:'||r.track||':تاریخ ۲:'||p.chapter||':'||p.position)::uuid, '1405','humanities','11',r.track,'تاریخ ۲',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
