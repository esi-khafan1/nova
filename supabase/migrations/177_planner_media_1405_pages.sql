-- Media literacy (110225), user-supplied 1405 textbook.
-- Original lesson seeds remain unchanged; these are added once without reviving deleted rows.
with installed as (insert into private.planner_seed_installations(seed_key) values ('media-literacy-1405-v177') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "فصل ۱: ما و رسانه‌ها",
  "position": 101,
  "title": "درس 1: تاریخ تحولات رسانه و سواد",
  "start": 12,
  "end": 13
 },
 {
  "chapter": "فصل ۱: ما و رسانه‌ها",
  "position": 102,
  "title": "درس 1: فناوری‌های نو و اینترنت اشیا",
  "start": 14,
  "end": 16
 },
 {
  "chapter": "فصل ۱: ما و رسانه‌ها",
  "position": 103,
  "title": "درس 1: رسانه‌ها و مخاطب فعال",
  "start": 17,
  "end": 18
 },
 {
  "chapter": "فصل ۱: ما و رسانه‌ها",
  "position": 201,
  "title": "درس 2: پیام آشکار و مفهوم متن و زیرمتن",
  "start": 19,
  "end": 20
 },
 {
  "chapter": "فصل ۱: ما و رسانه‌ها",
  "position": 202,
  "title": "درس 2: تصویر و اندازه نما",
  "start": 21,
  "end": 21
 },
 {
  "chapter": "فصل ۱: ما و رسانه‌ها",
  "position": 203,
  "title": "درس 2: پیام پنهان و زیرمتن",
  "start": 22,
  "end": 23
 },
 {
  "chapter": "فصل ۱: ما و رسانه‌ها",
  "position": 301,
  "title": "درس 3: رسانه و مخاطب فعال و منفعل",
  "start": 24,
  "end": 25
 },
 {
  "chapter": "فصل ۱: ما و رسانه‌ها",
  "position": 302,
  "title": "درس 3: پنج پرسش کلیدی سواد رسانه‌ای",
  "start": 26,
  "end": 30
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 401,
  "title": "درس 4: بازنمایی در تولید پیام",
  "start": 32,
  "end": 34
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 402,
  "title": "درس 4: تصویرسازی ملی و تصویر ایران",
  "start": 35,
  "end": 38
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 501,
  "title": "درس 5: کلیشه‌سازی در رسانه",
  "start": 39,
  "end": 41
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 502,
  "title": "درس 5: تعمیم و تکرار",
  "start": 42,
  "end": 42
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 503,
  "title": "درس 5: کلیشه‌سازی ایران و ایرانیان",
  "start": 43,
  "end": 44
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 601,
  "title": "درس 6: اقناع و زبان اقناع",
  "start": 45,
  "end": 46
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 602,
  "title": "درس 6: گواهی دادن و ستاره‌ها و نخبگان",
  "start": 47,
  "end": 47
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 603,
  "title": "درس 6: تکرار، مقایسه و تازگی",
  "start": 48,
  "end": 50
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 604,
  "title": "درس 6: تمرین تحلیل فنون اقناع",
  "start": 51,
  "end": 56
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 701,
  "title": "درس 7: دو شیوه تفکر: سریع و آهسته",
  "start": 57,
  "end": 59
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 702,
  "title": "درس 7: خطاهای شناختی رایج",
  "start": 60,
  "end": 62
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 703,
  "title": "درس 7: زندگی در عصر پساحقیقت",
  "start": 63,
  "end": 63
 },
 {
  "chapter": "فصل ۲: فنون خلق پیام رسانه‌ای",
  "position": 704,
  "title": "درس 7: راهکارهای مقابله با خطاهای شناختی",
  "start": 64,
  "end": 64
 },
 {
  "chapter": "فصل ۳: نادیده‌های رسانه‌ها",
  "position": 801,
  "title": "درس 8: تخصص‌های تولید اثر رسانه‌ای",
  "start": 66,
  "end": 68
 },
 {
  "chapter": "فصل ۳: نادیده‌های رسانه‌ها",
  "position": 802,
  "title": "درس 8: مراحل مدیریت پیام و گروه‌های شغلی",
  "start": 68,
  "end": 69
 },
 {
  "chapter": "فصل ۳: نادیده‌های رسانه‌ها",
  "position": 803,
  "title": "درس 8: طراحی پیام و انتخاب رسانه و قالب",
  "start": 70,
  "end": 71
 },
 {
  "chapter": "فصل ۳: نادیده‌های رسانه‌ها",
  "position": 804,
  "title": "درس 8: کارزار موفق سیاساکتی",
  "start": 72,
  "end": 72
 },
 {
  "chapter": "فصل ۳: نادیده‌های رسانه‌ها",
  "position": 901,
  "title": "درس 9: مطالعات موردی تولید پیام",
  "start": 73,
  "end": 75
 },
 {
  "chapter": "فصل ۳: نادیده‌های رسانه‌ها",
  "position": 902,
  "title": "درس 9: صنعت رسانه و شرکت‌های رسانه‌ای",
  "start": 76,
  "end": 78
 },
 {
  "chapter": "فصل ۳: نادیده‌های رسانه‌ها",
  "position": 903,
  "title": "درس 9: اقتصاد توجه و نظارت بر اطلاعات",
  "start": 79,
  "end": 80
 },
 {
  "chapter": "فصل ۳: نادیده‌های رسانه‌ها",
  "position": 1001,
  "title": "درس 10: انتخاب و چینش اخبار",
  "start": 81,
  "end": 85
 },
 {
  "chapter": "فصل ۳: نادیده‌های رسانه‌ها",
  "position": 1002,
  "title": "درس 10: دروازه‌بانی خبر",
  "start": 86,
  "end": 86
 },
 {
  "chapter": "فصل ۳: نادیده‌های رسانه‌ها",
  "position": 1003,
  "title": "درس 10: برجسته‌سازی",
  "start": 87,
  "end": 87
 },
 {
  "chapter": "فصل ۳: نادیده‌های رسانه‌ها",
  "position": 1004,
  "title": "درس 10: الگوریتم‌ها و انتخاب خبر",
  "start": 88,
  "end": 90
 },
 {
  "chapter": "فصل ۴: مخاطب‌شناسی",
  "position": 1101,
  "title": "درس 11: مخاطب خاص و تفاوت برداشت‌ها",
  "start": 92,
  "end": 94
 },
 {
  "chapter": "فصل ۴: مخاطب‌شناسی",
  "position": 1102,
  "title": "درس 11: مقاومت مخاطب در برابر نوآوری و تغییر",
  "start": 95,
  "end": 97
 },
 {
  "chapter": "فصل ۴: مخاطب‌شناسی",
  "position": 1103,
  "title": "درس 11: تحلیل مخاطب یک برنامه",
  "start": 98,
  "end": 98
 },
 {
  "chapter": "فصل ۴: مخاطب‌شناسی",
  "position": 1201,
  "title": "درس 12: مخاطب فعال و منفعل و خودارزیابی",
  "start": 99,
  "end": 102
 },
 {
  "chapter": "فصل ۴: مخاطب‌شناسی",
  "position": 1202,
  "title": "درس 12: تفاوت دریافت و تفسیر مخاطبان",
  "start": 103,
  "end": 108
 },
 {
  "chapter": "فصل ۴: مخاطب‌شناسی",
  "position": 1301,
  "title": "درس 13: حقوق مخاطب در برابر رسانه",
  "start": 109,
  "end": 111
 },
 {
  "chapter": "فصل ۴: مخاطب‌شناسی",
  "position": 1302,
  "title": "درس 13: حریم خصوصی و حفاظت برخط",
  "start": 112,
  "end": 113
 },
 {
  "chapter": "فصل ۴: مخاطب‌شناسی",
  "position": 1303,
  "title": "درس 13: از مخاطب صرف تا کاربر فعال",
  "start": 114,
  "end": 116
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1401,
  "title": "درس 14: رسانه، ارزش‌ها و سبک زندگی",
  "start": 118,
  "end": 119
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1402,
  "title": "درس 14: تأثیر محتوایی و ماهیتی رسانه",
  "start": 120,
  "end": 122
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1403,
  "title": "درس 14: فناوری رسانه‌ای و رویکرد انتقادی",
  "start": 123,
  "end": 124
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1501,
  "title": "درس 15: کلیشه بدن و الگوی زیبایی",
  "start": 125,
  "end": 127
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1502,
  "title": "درس 15: پیامدهای کلیشه بدن",
  "start": 128,
  "end": 129
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1601,
  "title": "درس 16: بازی دیجیتال و راز قدرت بازی",
  "start": 130,
  "end": 133
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1602,
  "title": "درس 16: انواع بازیکنان و انگیزه‌ها",
  "start": 133,
  "end": 134
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1603,
  "title": "درس 16: تله‌های توجه در بازی",
  "start": 135,
  "end": 136
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1604,
  "title": "درس 16: محدودیت سنی و آسیب‌های بازی",
  "start": 137,
  "end": 138
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1605,
  "title": "درس 16: بازی‌وارسازی زندگی",
  "start": 139,
  "end": 139
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1701,
  "title": "درس 17: فضای مجازی و زندگی دوم",
  "start": 140,
  "end": 140
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1702,
  "title": "درس 17: توصیه‌های استفاده از تلفن همراه",
  "start": 141,
  "end": 141
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1703,
  "title": "درس 17: شبکه‌های اجتماعی و امنیت",
  "start": 142,
  "end": 142
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1704,
  "title": "درس 17: هوش مصنوعی در زندگی و آینده شغلی",
  "start": 143,
  "end": 144
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1801,
  "title": "درس 18: خبر جعلی و تله کلیک",
  "start": 145,
  "end": 146
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1802,
  "title": "درس 18: جعل عمیق",
  "start": 147,
  "end": 147
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1803,
  "title": "درس 18: راه‌های بررسی اعتبار اخبار",
  "start": 148,
  "end": 149
 },
 {
  "chapter": "فصل ۵: رسانه و سبک زندگی",
  "position": 1804,
  "title": "درس 18: فعالیت مبارزه با اخبار جعلی",
  "start": 150,
  "end": 152
 },
 {
  "chapter": "فصل ۶: رژیم مصرف رسانه‌ای",
  "position": 1901,
  "title": "درس 19: سلامت رسانه‌ای و رفتار دیجیتال",
  "start": 154,
  "end": 156
 },
 {
  "chapter": "فصل ۶: رژیم مصرف رسانه‌ای",
  "position": 1902,
  "title": "درس 19: مدیریت مصرف در زندگی دیجیتال",
  "start": 157,
  "end": 159
 },
 {
  "chapter": "فصل ۶: رژیم مصرف رسانه‌ای",
  "position": 1903,
  "title": "درس 19: بهزیستی دیجیتال",
  "start": 160,
  "end": 160
 },
 {
  "chapter": "فصل ۶: رژیم مصرف رسانه‌ای",
  "position": 1904,
  "title": "درس 19: مدیریت مصرف و بازگشت به تعادل",
  "start": 161,
  "end": 163
 },
 {
  "chapter": "فصل ۶: رژیم مصرف رسانه‌ای",
  "position": 2001,
  "title": "درس 20: اخلاق رسانه‌ای و مسئولیت مخاطب",
  "start": 164,
  "end": 166
 },
 {
  "chapter": "فصل ۶: رژیم مصرف رسانه‌ای",
  "position": 2002,
  "title": "درس 20: مسئولیت گفتار و محتوای مجرمانه",
  "start": 167,
  "end": 168
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v177:'||f.field||':10:final_exam:تفکر و سواد رسانه‌ای:'||p.chapter||':'||p.position)::uuid,'1405',f.field,'10','final_exam','تفکر و سواد رسانه‌ای',p.chapter,p.title,p.start,p."end",p.position from topics p cross join fields f cross join installed on conflict(id) do nothing;
