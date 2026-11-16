-- Ninth-grade Defense Readiness (915), first printing 1405, user PDF.
with installed as (insert into private.planner_seed_installations(seed_key) values ('defense9-1405-v207') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱: تهدید چیست؟ دشمن کیست؟",
  "title": "کل درس",
  "start": 10,
  "end": 24,
  "position": 1
 },
 {
  "chapter": "درس ۱: تهدید چیست؟ دشمن کیست؟",
  "title": "سلامت و امنیت",
  "start": 10,
  "end": 10,
  "position": 10
 },
 {
  "chapter": "درس ۱: تهدید چیست؟ دشمن کیست؟",
  "title": "ابعاد سلامت فردی و اجتماعی",
  "start": 11,
  "end": 13,
  "position": 11
 },
 {
  "chapter": "درس ۱: تهدید چیست؟ دشمن کیست؟",
  "title": "از سلامت تا امنیت",
  "start": 14,
  "end": 15,
  "position": 12
 },
 {
  "chapter": "درس ۱: تهدید چیست؟ دشمن کیست؟",
  "title": "تهدید و انواع آن",
  "start": 16,
  "end": 16,
  "position": 13
 },
 {
  "chapter": "درس ۱: تهدید چیست؟ دشمن کیست؟",
  "title": "تهدید نظامی و اقتصادی",
  "start": 17,
  "end": 17,
  "position": 14
 },
 {
  "chapter": "درس ۱: تهدید چیست؟ دشمن کیست؟",
  "title": "تهدید سیاسی، اجتماعی و سایبری",
  "start": 18,
  "end": 18,
  "position": 15
 },
 {
  "chapter": "درس ۱: تهدید چیست؟ دشمن کیست؟",
  "title": "تهدید فرهنگی، رسانه‌ای و زیست‌محیطی",
  "start": 19,
  "end": 20,
  "position": 16
 },
 {
  "chapter": "درس ۱: تهدید چیست؟ دشمن کیست؟",
  "title": "دشمن و دشمن‌شناسی",
  "start": 21,
  "end": 22,
  "position": 17
 },
 {
  "chapter": "درس ۱: تهدید چیست؟ دشمن کیست؟",
  "title": "دشمن‌شناسی در بیان امام علی",
  "start": 23,
  "end": 24,
  "position": 18
 },
 {
  "chapter": "درس ۲: موقعیت ایران و تهدیدهای آن",
  "title": "کل درس",
  "start": 25,
  "end": 38,
  "position": 1
 },
 {
  "chapter": "درس ۲: موقعیت ایران و تهدیدهای آن",
  "title": "مکان و جغرافیای ایران",
  "start": 25,
  "end": 28,
  "position": 10
 },
 {
  "chapter": "درس ۲: موقعیت ایران و تهدیدهای آن",
  "title": "منابع طبیعی ایران و جهان",
  "start": 29,
  "end": 30,
  "position": 11
 },
 {
  "chapter": "درس ۲: موقعیت ایران و تهدیدهای آن",
  "title": "تاریخ و زمان",
  "start": 31,
  "end": 33,
  "position": 12
 },
 {
  "chapter": "درس ۲: موقعیت ایران و تهدیدهای آن",
  "title": "فرهنگ و فضا",
  "start": 34,
  "end": 35,
  "position": 13
 },
 {
  "chapter": "درس ۲: موقعیت ایران و تهدیدهای آن",
  "title": "انقلاب اسلامی و دفع تهدیدهای ایران",
  "start": 36,
  "end": 38,
  "position": 14
 },
 {
  "chapter": "درس ۳: روایت فتح",
  "title": "کل درس",
  "start": 40,
  "end": 58,
  "position": 1
 },
 {
  "chapter": "درس ۳: روایت فتح",
  "title": "شهریور ۱۳۵۹ و هجوم سراسری",
  "start": 41,
  "end": 41,
  "position": 10
 },
 {
  "chapter": "درس ۳: روایت فتح",
  "title": "مقاومت در شهرها",
  "start": 42,
  "end": 42,
  "position": 11
 },
 {
  "chapter": "درس ۳: روایت فتح",
  "title": "حملات موشکی به دزفول",
  "start": 43,
  "end": 44,
  "position": 12
 },
 {
  "chapter": "درس ۳: روایت فتح",
  "title": "متوقف کردن و مهار متجاوز",
  "start": 45,
  "end": 47,
  "position": 13
 },
 {
  "chapter": "درس ۳: روایت فتح",
  "title": "حمله برای بازپس‌گیری سرزمین",
  "start": 48,
  "end": 52,
  "position": 14
 },
 {
  "chapter": "درس ۳: روایت فتح",
  "title": "آزادسازی خرمشهر و نصرت الهی",
  "start": 53,
  "end": 54,
  "position": 15
 },
 {
  "chapter": "درس ۳: روایت فتح",
  "title": "دستاوردهای داخلی دفاع مقدس",
  "start": 55,
  "end": 56,
  "position": 16
 },
 {
  "chapter": "درس ۳: روایت فتح",
  "title": "دانستنی‌های دفاع مقدس",
  "start": 57,
  "end": 58,
  "position": 17
 },
 {
  "chapter": "درس ۴: باید برخاست",
  "title": "کل درس",
  "start": 59,
  "end": 85,
  "position": 1
 },
 {
  "chapter": "درس ۴: باید برخاست",
  "title": "تعقیب و تنبیه متجاوز",
  "start": 61,
  "end": 68,
  "position": 10
 },
 {
  "chapter": "درس ۴: باید برخاست",
  "title": "رویارویی با نظام سلطه",
  "start": 69,
  "end": 70,
  "position": 11
 },
 {
  "chapter": "درس ۴: باید برخاست",
  "title": "دشمن علیه همه ما",
  "start": 71,
  "end": 73,
  "position": 12
 },
 {
  "chapter": "درس ۴: باید برخاست",
  "title": "پایان جنگ",
  "start": 74,
  "end": 76,
  "position": 13
 },
 {
  "chapter": "درس ۴: باید برخاست",
  "title": "درس‌های جنگ",
  "start": 77,
  "end": 78,
  "position": 14
 },
 {
  "chapter": "درس ۴: باید برخاست",
  "title": "ایران پس از جنگ و توسعه جبهه مقاومت",
  "start": 79,
  "end": 79,
  "position": 15
 },
 {
  "chapter": "درس ۴: باید برخاست",
  "title": "سردار دل‌ها، افتخار ایران",
  "start": 80,
  "end": 82,
  "position": 16
 },
 {
  "chapter": "درس ۴: باید برخاست",
  "title": "بخش‌هایی از وصیت‌نامه شهید سلیمانی",
  "start": 83,
  "end": 85,
  "position": 17
 },
 {
  "chapter": "درس ۵: رویارویی قدرت‌ها",
  "title": "کل درس",
  "start": 86,
  "end": 102,
  "position": 1
 },
 {
  "chapter": "درس ۵: رویارویی قدرت‌ها",
  "title": "رژیم اسرائیل و جنگ تحمیلی دوم",
  "start": 86,
  "end": 86,
  "position": 10
 },
 {
  "chapter": "درس ۵: رویارویی قدرت‌ها",
  "title": "هدف‌های ایران در جنگ دوازده‌روزه",
  "start": 87,
  "end": 90,
  "position": 11
 },
 {
  "chapter": "درس ۵: رویارویی قدرت‌ها",
  "title": "آمریکا و نظام سلطه",
  "start": 91,
  "end": 92,
  "position": 12
 },
 {
  "chapter": "درس ۵: رویارویی قدرت‌ها",
  "title": "ظهور یک قدرت جهانی",
  "start": 93,
  "end": 93,
  "position": 13
 },
 {
  "chapter": "درس ۵: رویارویی قدرت‌ها",
  "title": "تلفات نیروی هوایی آمریکا در عملیات جنگ رمضان",
  "start": 94,
  "end": 102,
  "position": 14
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "کل درس",
  "start": 104,
  "end": 132,
  "position": 1
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "نظام جمع و اهمیت نظم",
  "start": 105,
  "end": 105,
  "position": 10
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "نظم در مدرسه",
  "start": 106,
  "end": 106,
  "position": 11
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "اهداف و فرمان‌های نظام جمع",
  "start": 107,
  "end": 107,
  "position": 12
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "قرار گرفتن افراد در صف و ستون",
  "start": 108,
  "end": 108,
  "position": 13
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "ایستادن و از جلو نظام",
  "start": 109,
  "end": 109,
  "position": 14
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "خبردار، به جای خود و از راست نظام",
  "start": 110,
  "end": 110,
  "position": 15
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "مهارت رزم و جهت‌یابی",
  "start": 111,
  "end": 111,
  "position": 16
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "روش‌های جهت‌یابی",
  "start": 112,
  "end": 112,
  "position": 17
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "جهت‌یابی با خورشید",
  "start": 113,
  "end": 113,
  "position": 18
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "جهت‌یابی با خورشید و ساعت عقربه‌دار",
  "start": 114,
  "end": 114,
  "position": 19
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "جهت‌یابی با سایه شاخص",
  "start": 115,
  "end": 117,
  "position": 20
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "جهت‌یابی در شب",
  "start": 118,
  "end": 120,
  "position": 21
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "تخمین مسافت",
  "start": 121,
  "end": 121,
  "position": 22
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "روش‌های تخمین مسافت",
  "start": 122,
  "end": 126,
  "position": 23
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "مهارت‌های اولیه زندگی در شرایط سخت",
  "start": 127,
  "end": 127,
  "position": 24
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "افروختن آتش و تهیه آب سالم",
  "start": 128,
  "end": 129,
  "position": 25
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "تهیه غذا",
  "start": 130,
  "end": 130,
  "position": 26
 },
 {
  "chapter": "درس ۶: نظام جمع و مهارت‌های رزم",
  "title": "تکاوران شجاع کشور",
  "start": 131,
  "end": 132,
  "position": 27
 },
 {
  "chapter": "درس ۷: پدافند غیرعامل",
  "title": "کل درس",
  "start": 133,
  "end": 140,
  "position": 1
 },
 {
  "chapter": "درس ۷: پدافند غیرعامل",
  "title": "یک رؤیا",
  "start": 134,
  "end": 135,
  "position": 10
 },
 {
  "chapter": "درس ۷: پدافند غیرعامل",
  "title": "تعریف و دسته‌بندی دفاع و پدافند",
  "start": 136,
  "end": 136,
  "position": 11
 },
 {
  "chapter": "درس ۷: پدافند غیرعامل",
  "title": "روش‌ها و راهکارهای پدافند غیرعامل",
  "start": 137,
  "end": 139,
  "position": 12
 },
 {
  "chapter": "درس ۷: پدافند غیرعامل",
  "title": "مکان‌یابی تأسیسات",
  "start": 140,
  "end": 140,
  "position": 13
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "کل درس",
  "start": 141,
  "end": 157,
  "position": 1
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "زندگی جدید، جنگ جدید",
  "start": 141,
  "end": 141,
  "position": 10
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "جنگ ترکیبی",
  "start": 142,
  "end": 142,
  "position": 11
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "شناخت جنگ شناختی",
  "start": 143,
  "end": 144,
  "position": 12
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "شایعه و دروغ",
  "start": 145,
  "end": 145,
  "position": 13
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "عملیات پرچم دروغین",
  "start": 146,
  "end": 147,
  "position": 14
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "احساسات به عنوان جنگ‌افزار",
  "start": 148,
  "end": 149,
  "position": 15
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "اشباع نفرت و تحمیل سکوت",
  "start": 150,
  "end": 151,
  "position": 16
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "فرایند جنگ شناختی احساسی",
  "start": 152,
  "end": 152,
  "position": 17
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "دفاع شناختی خوب",
  "start": 153,
  "end": 153,
  "position": 18
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "آزمایشگاه احساسات",
  "start": 154,
  "end": 154,
  "position": 19
 },
 {
  "chapter": "درس ۸: جنگ پنهان",
  "title": "کارنامه جنگ شناختی و واقع‌بینی رسانه‌ای",
  "start": 155,
  "end": 157,
  "position": 20
 },
 {
  "chapter": "درس ۹: امداد و نجات",
  "title": "کل درس",
  "start": 158,
  "end": 175,
  "position": 1
 },
 {
  "chapter": "درس ۹: امداد و نجات",
  "title": "سنگر بچه‌های محل",
  "start": 158,
  "end": 159,
  "position": 10
 },
 {
  "chapter": "درس ۹: امداد و نجات",
  "title": "وظایف شورای ایمنی در برابر زمین‌لرزه",
  "start": 160,
  "end": 161,
  "position": 11
 },
 {
  "chapter": "درس ۹: امداد و نجات",
  "title": "آمادگی در برابر زمین‌لرزه و توصیه‌های پیش از زلزله",
  "start": 162,
  "end": 163,
  "position": 12
 },
 {
  "chapter": "درس ۹: امداد و نجات",
  "title": "توصیه‌های ایمنی هنگام زلزله",
  "start": 164,
  "end": 164,
  "position": 13
 },
 {
  "chapter": "درس ۹: امداد و نجات",
  "title": "توصیه‌های ایمنی بعد از زلزله",
  "start": 165,
  "end": 167,
  "position": 14
 },
 {
  "chapter": "درس ۹: امداد و نجات",
  "title": "بررسی وضعیت مصدوم و مهار خون‌ریزی",
  "start": 168,
  "end": 169,
  "position": 15
 },
 {
  "chapter": "درس ۹: امداد و نجات",
  "title": "حمل مصدوم",
  "start": 170,
  "end": 172,
  "position": 16
 },
 {
  "chapter": "درس ۹: امداد و نجات",
  "title": "مراجعه به مراکز درمانی و کمک‌های اولیه",
  "start": 173,
  "end": 175,
  "position": 17
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v207:all:9:final_exam:آمادگی دفاعی:'||p.chapter||':'||p.position)::uuid,'1405','all','9','final_exam','آمادگی دفاعی',p.chapter,p.title,p.start,p."end",p.position
from topics p cross join installed on conflict(id) do nothing;
