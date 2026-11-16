-- Psychology 11, textbook 111224, 1405 user PDF; printed pages.
-- Selected finer topics, one-time installation for both humanities tracks.
with installed as (insert into private.planner_seed_installations(seed_key) values ('psychology11-finer-1405-v217') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "title": "کاربرد روان‌شناسی و منابع آگاهی",
  "start": 10,
  "end": 11,
  "position": 700
 },
 {
  "chapter": "درس ۱",
  "title": "علم تجربی، فرضیه و نظریه",
  "start": 12,
  "end": 13,
  "position": 701
 },
 {
  "chapter": "درس ۱",
  "title": "هدف‌های روان‌شناسی: توصیف، تبیین، پیش‌بینی و کنترل",
  "start": 14,
  "end": 16,
  "position": 702
 },
 {
  "chapter": "درس ۱",
  "title": "روش علمی، آزمایش و تعریف عملیاتی",
  "start": 16,
  "end": 19,
  "position": 703
 },
 {
  "chapter": "درس ۱",
  "title": "تعریف روان‌شناسی و فرایندهای شناختی",
  "start": 20,
  "end": 22,
  "position": 704
 },
 {
  "chapter": "درس ۱",
  "title": "تاریخ علم تجربی و رابطه علم و فلسفه",
  "start": 23,
  "end": 26,
  "position": 705
 },
 {
  "chapter": "درس ۱",
  "title": "مشاهده، پرسش‌نامه و روش‌های گردآوری اطلاعات",
  "start": 27,
  "end": 28,
  "position": 706
 },
 {
  "chapter": "درس ۱",
  "title": "دستگاه عصبی و بخش‌های مغز",
  "start": 29,
  "end": 30,
  "position": 707
 },
 {
  "chapter": "درس ۱",
  "title": "گرایش‌های روان‌شناسی",
  "start": 31,
  "end": 31,
  "position": 708
 },
 {
  "chapter": "درس ۱",
  "title": "جمع‌بندی و واژگان",
  "start": 32,
  "end": 33,
  "position": 709
 },
 {
  "chapter": "درس ۲",
  "title": "مقدمه روان‌شناسی رشد و عوامل رشد",
  "start": 36,
  "end": 38,
  "position": 700
 },
 {
  "chapter": "درس ۲",
  "title": "عوامل وراثتی و رسش",
  "start": 40,
  "end": 41,
  "position": 701
 },
 {
  "chapter": "درس ۲",
  "title": "عوامل محیطی و مراحل فراخنای زندگی",
  "start": 42,
  "end": 44,
  "position": 702
 },
 {
  "chapter": "درس ۲",
  "title": "ویژگی‌های رشد و دوره پیش از تولد",
  "start": 45,
  "end": 45,
  "position": 703
 },
 {
  "chapter": "درس ۲",
  "title": "رشد جسمانی و حرکتی کودک",
  "start": 46,
  "end": 47,
  "position": 704
 },
 {
  "chapter": "درس ۲",
  "title": "رشد شناختی کودک",
  "start": 48,
  "end": 48,
  "position": 705
 },
 {
  "chapter": "درس ۲",
  "title": "رشد هیجانی و اجتماعی کودک",
  "start": 49,
  "end": 50,
  "position": 706
 },
 {
  "chapter": "درس ۲",
  "title": "رشد درک اخلاقی کودک",
  "start": 51,
  "end": 52,
  "position": 707
 },
 {
  "chapter": "درس ۲",
  "title": "نوجوانی و بلوغ جسمانی و جنسی",
  "start": 52,
  "end": 54,
  "position": 708
 },
 {
  "chapter": "درس ۲",
  "title": "رشد شناختی نوجوان",
  "start": 55,
  "end": 56,
  "position": 709
 },
 {
  "chapter": "درس ۲",
  "title": "رشد هیجانی و اجتماعی نوجوان",
  "start": 57,
  "end": 58,
  "position": 710
 },
 {
  "chapter": "درس ۲",
  "title": "هویت‌یابی در نوجوانی",
  "start": 59,
  "end": 60,
  "position": 711
 },
 {
  "chapter": "درس ۲",
  "title": "رشد اخلاقی و خود واقعی و آرمانی",
  "start": 61,
  "end": 63,
  "position": 712
 },
 {
  "chapter": "درس ۲",
  "title": "جمع‌بندی و واژگان",
  "start": 64,
  "end": 65,
  "position": 713
 },
 {
  "chapter": "درس ۳",
  "title": "احساس، توجه و ادراک",
  "start": 68,
  "end": 70,
  "position": 700
 },
 {
  "chapter": "درس ۳",
  "title": "آستانه احساس و حواس پنج‌گانه",
  "start": 71,
  "end": 73,
  "position": 701
 },
 {
  "chapter": "درس ۳",
  "title": "منابع توجه و آماده‌سازی",
  "start": 73,
  "end": 75,
  "position": 702
 },
 {
  "chapter": "درس ۳",
  "title": "موانع تمرکز و عوامل ایجاد آن",
  "start": 75,
  "end": 77,
  "position": 703
 },
 {
  "chapter": "درس ۳",
  "title": "کارکردهای توجه، ردیابی و جست‌وجو",
  "start": 77,
  "end": 80,
  "position": 704
 },
 {
  "chapter": "درس ۳",
  "title": "ساماندهی توجه و انجام چند تکلیف",
  "start": 80,
  "end": 81,
  "position": 705
 },
 {
  "chapter": "درس ۳",
  "title": "ادراک و خطاهای ادراکی",
  "start": 81,
  "end": 83,
  "position": 706
 },
 {
  "chapter": "درس ۳",
  "title": "اصول گشتالت و پردازش ادراکی",
  "start": 83,
  "end": 85,
  "position": 707
 },
 {
  "chapter": "درس ۳",
  "title": "جمع‌بندی و واژگان",
  "start": 86,
  "end": 87,
  "position": 708
 },
 {
  "chapter": "درس ۴",
  "title": "مراحل حافظه و رمزگردانی",
  "start": 90,
  "end": 92,
  "position": 700
 },
 {
  "chapter": "درس ۴",
  "title": "ذخیره‌سازی و بازیابی",
  "start": 93,
  "end": 94,
  "position": 701
 },
 {
  "chapter": "درس ۴",
  "title": "حافظه حسی، کوتاه‌مدت و بلندمدت",
  "start": 94,
  "end": 98,
  "position": 702
 },
 {
  "chapter": "درس ۴",
  "title": "تمرین، حافظه معنایی و حافظه رویدادی",
  "start": 97,
  "end": 98,
  "position": 703
 },
 {
  "chapter": "درس ۴",
  "title": "خطاهای حافظه و تعریف فراموشی",
  "start": 99,
  "end": 100,
  "position": 704
 },
 {
  "chapter": "درس ۴",
  "title": "عوامل فراموشی و تداخل اطلاعات",
  "start": 100,
  "end": 104,
  "position": 705
 },
 {
  "chapter": "درس ۴",
  "title": "روش‌های مطالعه و بهسازی حافظه",
  "start": 105,
  "end": 109,
  "position": 706
 },
 {
  "chapter": "درس ۴",
  "title": "کارآمدی مرور مطالب",
  "start": 106,
  "end": 106,
  "position": 707
 },
 {
  "chapter": "درس ۴",
  "title": "بسط معنایی",
  "start": 108,
  "end": 108,
  "position": 708
 },
 {
  "chapter": "درس ۴",
  "title": "آزمون مکرر و بازیابی",
  "start": 109,
  "end": 109,
  "position": 709
 },
 {
  "chapter": "درس ۴",
  "title": "جمع‌بندی و واژگان",
  "start": 110,
  "end": 111,
  "position": 710
 },
 {
  "chapter": "درس ۵",
  "title": "حل مسئله و تعریف مسئله",
  "start": 114,
  "end": 116,
  "position": 700
 },
 {
  "chapter": "درس ۵",
  "title": "ویژگی‌های مسئله و اهمیت حل آن",
  "start": 116,
  "end": 117,
  "position": 701
 },
 {
  "chapter": "درس ۵",
  "title": "انواع مسئله و تعریف‌شدگی",
  "start": 117,
  "end": 119,
  "position": 702
 },
 {
  "chapter": "درس ۵",
  "title": "مراحل حل مسئله",
  "start": 119,
  "end": 120,
  "position": 703
 },
 {
  "chapter": "درس ۵",
  "title": "تجربه گذشته و عوامل مؤثر بر حل مسئله",
  "start": 121,
  "end": 123,
  "position": 704
 },
 {
  "chapter": "درس ۵",
  "title": "روش‌های تحلیلی و اکتشافی",
  "start": 123,
  "end": 125,
  "position": 705
 },
 {
  "chapter": "درس ۵",
  "title": "خرد کردن مسئله و کاهش تفاوت",
  "start": 126,
  "end": 127,
  "position": 706
 },
 {
  "chapter": "درس ۵",
  "title": "بارش مغزی و شروع از آخر",
  "start": 128,
  "end": 129,
  "position": 707
 },
 {
  "chapter": "درس ۵",
  "title": "پیامدهای ناتوانی در حل مسئله",
  "start": 130,
  "end": 131,
  "position": 708
 },
 {
  "chapter": "درس ۵",
  "title": "جمع‌بندی درس و تمرین",
  "start": 132,
  "end": 133,
  "position": 709
 },
 {
  "chapter": "درس ۶",
  "title": "تعریف تصمیم‌گیری و تفاوت آن با حل مسئله",
  "start": 136,
  "end": 138,
  "position": 700
 },
 {
  "chapter": "درس ۶",
  "title": "انواع تصمیم‌گیری",
  "start": 138,
  "end": 140,
  "position": 701
 },
 {
  "chapter": "درس ۶",
  "title": "ملاک‌های تصمیم‌گیری",
  "start": 141,
  "end": 142,
  "position": 702
 },
 {
  "chapter": "درس ۶",
  "title": "سبک تصمیم‌گیری تکانشی",
  "start": 142,
  "end": 143,
  "position": 703
 },
 {
  "chapter": "درس ۶",
  "title": "سبک تصمیم‌گیری احساسی",
  "start": 144,
  "end": 144,
  "position": 704
 },
 {
  "chapter": "درس ۶",
  "title": "سبک‌های تصمیم‌گیری وابسته و اجتنابی",
  "start": 145,
  "end": 146,
  "position": 705
 },
 {
  "chapter": "درس ۶",
  "title": "سبک منطقی و مراحل تصمیم‌گیری",
  "start": 147,
  "end": 148,
  "position": 706
 },
 {
  "chapter": "درس ۶",
  "title": "موانع و پیامدهای ناتوانی در تصمیم‌گیری",
  "start": 149,
  "end": 150,
  "position": 707
 },
 {
  "chapter": "درس ۶",
  "title": "انواع تعارض در تصمیم‌گیری",
  "start": 151,
  "end": 153,
  "position": 708
 },
 {
  "chapter": "درس ۶",
  "title": "پیشنهادهایی برای تصمیم‌گیری بهتر",
  "start": 153,
  "end": 155,
  "position": 709
 },
 {
  "chapter": "درس ۶",
  "title": "جمع‌بندی و واژگان",
  "start": 156,
  "end": 157,
  "position": 710
 },
 {
  "chapter": "درس ۷",
  "title": "انگیزه، نگرش و عوامل آن",
  "start": 160,
  "end": 162,
  "position": 700
 },
 {
  "chapter": "درس ۷",
  "title": "انگیزه‌های درونی و بیرونی",
  "start": 163,
  "end": 164,
  "position": 701
 },
 {
  "chapter": "درس ۷",
  "title": "باورها، نظام ارزشی، اراده و هدف",
  "start": 165,
  "end": 168,
  "position": 702
 },
 {
  "chapter": "درس ۷",
  "title": "ناهماهنگی شناختی",
  "start": 169,
  "end": 171,
  "position": 703
 },
 {
  "chapter": "درس ۷",
  "title": "ادراک کنترل، کارایی و اسناد",
  "start": 172,
  "end": 174,
  "position": 704
 },
 {
  "chapter": "درس ۷",
  "title": "عوامل موفقیت و شکست",
  "start": 175,
  "end": 176,
  "position": 705
 },
 {
  "chapter": "درس ۷",
  "title": "درماندگی آموخته‌شده",
  "start": 176,
  "end": 180,
  "position": 706
 },
 {
  "chapter": "درس ۷",
  "title": "فعالیت منزل و سنجش نگرش",
  "start": 180,
  "end": 181,
  "position": 707
 },
 {
  "chapter": "درس ۷",
  "title": "سلسله‌مراتب نیازهای مازلو",
  "start": 182,
  "end": 183,
  "position": 708
 },
 {
  "chapter": "درس ۷",
  "title": "جمع‌بندی و واژگان",
  "start": 184,
  "end": 185,
  "position": 709
 },
 {
  "chapter": "درس ۸",
  "title": "روان‌شناسی سلامت و پیوستار سلامت و بیماری",
  "start": 188,
  "end": 190,
  "position": 700
 },
 {
  "chapter": "درس ۸",
  "title": "نقش متقابل عوامل جسمانی و روانی",
  "start": 191,
  "end": 191,
  "position": 701
 },
 {
  "chapter": "درس ۸",
  "title": "سبک زندگی، تغذیه و پرسش‌نامه",
  "start": 192,
  "end": 194,
  "position": 702
 },
 {
  "chapter": "درس ۸",
  "title": "ورزش و سلامت",
  "start": 195,
  "end": 195,
  "position": 703
 },
 {
  "chapter": "درس ۸",
  "title": "فشار روانی مثبت و منفی و نشانه‌ها",
  "start": 195,
  "end": 197,
  "position": 704
 },
 {
  "chapter": "درس ۸",
  "title": "راه‌ها و انواع مقابله با فشار روانی",
  "start": 198,
  "end": 199,
  "position": 705
 },
 {
  "chapter": "درس ۸",
  "title": "مقابله سازگارانه",
  "start": 199,
  "end": 201,
  "position": 706
 },
 {
  "chapter": "درس ۸",
  "title": "مقابله ناسازگارانه",
  "start": 202,
  "end": 203,
  "position": 707
 },
 {
  "chapter": "درس ۸",
  "title": "تأثیر مذهب بر سلامت",
  "start": 204,
  "end": 205,
  "position": 708
 },
 {
  "chapter": "درس ۸",
  "title": "جمع‌بندی درس",
  "start": 206,
  "end": 206,
  "position": 709
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v217:humanities:11:'||r.track||':روان‌شناسی:'||p.chapter||':'||p.position)::uuid,'1405','humanities','11',r.track,'روان‌شناسی',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
