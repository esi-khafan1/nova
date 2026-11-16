-- 1405 geography: additional source-checked skills and finer sections.
-- Insert only. The installation marker prevents reinstating later administrator deletions.
with installed as (insert into private.planner_seed_installations(seed_key) values ('geography11-12-skills-1405-v230') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۲",
  "position": 2001,
  "title": "مهارت نقشه‌خوانی: نواحی زبانی سوئیس و مرزهای طبیعی",
  "start": 18,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 2001,
  "title": "مهارت نقشه هواشناسی: منحنی هم‌فشار و جبهه‌ها",
  "start": 35,
  "end": 36
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 2001,
  "title": "مهارت نقشه توپوگرافی: منحنی میزان و رسم نیم‌رخ",
  "start": 51,
  "end": 52
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 2001,
  "title": "مهارت سفر بیابانی: وسایل و جهت‌یابی",
  "start": 64,
  "end": 64
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 2001,
  "title": "مهارت: نقشۀ نواحی زبانی و کشورهای جهان اسلام",
  "start": 82,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 2002,
  "title": "پژوهش: تنوع و پخش فرهنگی",
  "start": 82,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 2001,
  "title": "مهارت تولید نقشه موضوعی کشورهای تولیدکنندۀ برنج",
  "start": 98,
  "end": 98
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 2002,
  "title": "پژوهش کشاورزی و محصول استوایی",
  "start": 98,
  "end": 98
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 2001,
  "title": "مهارت ترسیم نقشۀ کشورهای عضو اوپک",
  "start": 112,
  "end": 112
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 2002,
  "title": "پژوهش پیمان‌های اقتصادی و تجاری منطقه‌ای",
  "start": 112,
  "end": 112
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 2003,
  "title": "مطالعۀ موردی: اشتراکات و چالش‌های جهان اسلام",
  "start": 114,
  "end": 114
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 2001,
  "title": "مهارت اطلس: موقعیت نسبی مکان‌های جغرافیای سیاسی",
  "start": 126,
  "end": 126
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 2002,
  "title": "پژوهش: تأثیر متقابل سیاست و فضای جغرافیایی",
  "start": 126,
  "end": 126
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 2001,
  "title": "مهارت نقشه مرزهای ایران و همسایگان",
  "start": 141,
  "end": 141
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 2002,
  "title": "مهارت نمودار طول انواع مرزها و پژوهش اختلاف مرزی",
  "start": 141,
  "end": 141
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 2001,
  "title": "مهارت اطلس: کشورهای محصور در خشکی و شکل کشورها",
  "start": 153,
  "end": 153
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 2002,
  "title": "مهارت ترسیم خلیج فارس، بنادر و جزایر",
  "start": 153,
  "end": 153
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 2003,
  "title": "پژوهش قدرت دریایی و موقعیت جغرافیایی ایران",
  "start": 153,
  "end": 153
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 2001,
  "title": "شاخص انحراف مسیر و محاسبۀ آن",
  "start": 59,
  "end": 60
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 2002,
  "title": "شبکه جغرافیایی، ماتریس دسترسی و مکان‌یابی",
  "start": 60,
  "end": 62
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 2003,
  "title": "عوامل مؤثر بر انتخاب شیوۀ حمل‌ونقل",
  "start": 62,
  "end": 63
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 2004,
  "title": "پیامدهای زیست‌محیطی حمل‌ونقل",
  "start": 63,
  "end": 63
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 2005,
  "title": "ایمنی و پایش حمل‌ونقل و فرهنگ بیمه",
  "start": 64,
  "end": 65
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 2006,
  "title": "حمل‌ونقل چندوجهی و ترکیب شیوه‌ها",
  "start": 65,
  "end": 65
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 2001,
  "title": "زمین‌لرزه، کانون، گسل و حرکت ورقه‌ها",
  "start": 82,
  "end": 84
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 2002,
  "title": "اندازه‌گیری بزرگی و شدت: ریشتر و مرکالی",
  "start": 84,
  "end": 85
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 2003,
  "title": "لرزه‌نگاری و نواحی لرزه‌خیز جهان و ایران",
  "start": 86,
  "end": 88
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 2004,
  "title": "آبدهی رود، هیدروگراف و وقوع سیل",
  "start": 89,
  "end": 90
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 2005,
  "title": "علل طبیعی و انسانی و خسارت‌های سیل",
  "start": 90,
  "end": 92
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 2006,
  "title": "انواع حرکات دامنه‌ای و عوامل زمین‌لغزش",
  "start": 93,
  "end": 97
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 2007,
  "title": "انواع خشکسالی و پیامدهای آن",
  "start": 97,
  "end": 99
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 2001,
  "title": "مفهوم مخاطره و بحران و مدیریت پیش از زلزله",
  "start": 100,
  "end": 101
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 2002,
  "title": "مدیریت حین و پس از وقوع زمین‌لرزه",
  "start": 102,
  "end": 103
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 2003,
  "title": "مدیریت سیل: روش‌های سازه‌ای و غیرسازه‌ای",
  "start": 104,
  "end": 106
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 2004,
  "title": "مدیریت پیش، حین و پس از زمین‌لغزش",
  "start": 107,
  "end": 108
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 2005,
  "title": "مدیریت خشکسالی و حفاظت منابع آب",
  "start": 108,
  "end": 110
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 2006,
  "title": "سنجش از دور و تحلیل مخاطرات طبیعی",
  "start": 111,
  "end": 114
 }
]$topics$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v230:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405','humanities',p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
