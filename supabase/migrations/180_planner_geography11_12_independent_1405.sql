-- Geography 2 and 3, 1405 user PDFs; printed page ranges.
-- Existing topic groups are intentionally untouched, including historical null pages.
with installed as (insert into private.planner_seed_installations(seed_key) values ('geography11-12-independent-1405-v180') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱",
  "position": 301,
  "title": "معنا و مفهوم ناحیه",
  "start": 2,
  "end": 4
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱",
  "position": 302,
  "title": "ناحیه‌بندی و معیارهای طبیعی و انسانی",
  "start": 4,
  "end": 8
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱",
  "position": 303,
  "title": "مهارت ناحیه‌بندی",
  "start": 10,
  "end": 10
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۲",
  "position": 301,
  "title": "انسان و ناحیه و ایجاد نواحی",
  "start": 11,
  "end": 13
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۲",
  "position": 302,
  "title": "تصمیم‌های سیاسی و روابط متقابل نواحی",
  "start": 13,
  "end": 15
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۲",
  "position": 303,
  "title": "کانون و مرز ناحیه",
  "start": 15,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 301,
  "title": "هواکره و اهمیت آن",
  "start": 20,
  "end": 23
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 302,
  "title": "فشار هوا، توده هوا و جبهه",
  "start": 24,
  "end": 26
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 303,
  "title": "کمربندهای فشار و گردش عمومی جو",
  "start": 26,
  "end": 27
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 304,
  "title": "انواع بارش",
  "start": 27,
  "end": 28
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 305,
  "title": "طبقه‌بندی اقلیم‌های جهان",
  "start": 29,
  "end": 31
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 306,
  "title": "بیابان‌های گرم و سرد",
  "start": 32,
  "end": 34
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 307,
  "title": "علل ایجاد بیابان",
  "start": 34,
  "end": 35
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 308,
  "title": "مهارت نقشه‌های هواشناسی",
  "start": 35,
  "end": 36
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 301,
  "title": "ناهمواری‌ها و عوامل درونی",
  "start": 37,
  "end": 40
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 302,
  "title": "هوازدگی و فرسایش",
  "start": 41,
  "end": 43
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 303,
  "title": "فرسایش آب‌های جاری و انحلالی",
  "start": 44,
  "end": 46
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 304,
  "title": "فرسایش بادی و اشکال بیابانی",
  "start": 47,
  "end": 49
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 305,
  "title": "فرسایش طبیعی سواحل",
  "start": 49,
  "end": 50
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 306,
  "title": "مهارت نقشه توپوگرافی",
  "start": 51,
  "end": 52
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 301,
  "title": "جغرافیای زیستی و زیست‌بوم‌ها",
  "start": 53,
  "end": 56
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 302,
  "title": "پراکندگی پوشش گیاهی و ارتفاع",
  "start": 57,
  "end": 58
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 303,
  "title": "حفاظت از نواحی بیابانی",
  "start": 58,
  "end": 60
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 304,
  "title": "حفاظت از نواحی ساحلی",
  "start": 60,
  "end": 62
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 305,
  "title": "نواحی کوهستانی و حفاظت از آنها",
  "start": 62,
  "end": 64
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 306,
  "title": "مهارت سفر به بیابان",
  "start": 64,
  "end": 64
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 307,
  "title": "مطالعه موردی نپال، زندگی در بلندی‌ها",
  "start": 65,
  "end": 66
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 301,
  "title": "مفهوم ناحیه فرهنگی و خانواده‌های زبانی",
  "start": 68,
  "end": 71
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 302,
  "title": "تغییر پراکندگی و تنوع زبان‌ها",
  "start": 71,
  "end": 73
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 303,
  "title": "چشم‌انداز فرهنگی و دین",
  "start": 74,
  "end": 75
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 304,
  "title": "نواحی فرهنگی عمده جهان",
  "start": 75,
  "end": 78
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 305,
  "title": "پخش فرهنگی",
  "start": 79,
  "end": 81
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 306,
  "title": "مهارت نقشه‌خوانی و نقشه موضوعی",
  "start": 82,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 301,
  "title": "کشاورزی و نواحی عمده کشاورزی جهان",
  "start": 83,
  "end": 85
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 302,
  "title": "کشاورزی معیشتی و تجاری",
  "start": 84,
  "end": 88
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 303,
  "title": "انقلاب سبز",
  "start": 88,
  "end": 89
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 304,
  "title": "کشت تک‌محصولی و شرکت‌های چندملیتی",
  "start": 91,
  "end": 94
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 305,
  "title": "نواحی عمده صنعتی جهان",
  "start": 95,
  "end": 96
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 306,
  "title": "صنایع نو با فناوری پیشرفته",
  "start": 96,
  "end": 98
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 301,
  "title": "تجارت و اقتصاد جهانی",
  "start": 99,
  "end": 101
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 302,
  "title": "نابرابری در اقتصاد جهانی و شاخص توسعه انسانی",
  "start": 102,
  "end": 105
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 303,
  "title": "الگوی مرکز و پیرامون",
  "start": 106,
  "end": 107
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 304,
  "title": "تجارت بین‌المللی و حفاظت از اقتصاد کشورها",
  "start": 108,
  "end": 110
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 305,
  "title": "تجارت و حمل و نقل دریایی",
  "start": 110,
  "end": 112
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 306,
  "title": "مهارت ترسیم نقشه موضوعی",
  "start": 112,
  "end": 112
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 307,
  "title": "مطالعه موردی ناحیه فرهنگی جهان اسلام",
  "start": 113,
  "end": 114
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 301,
  "title": "فضا و قلمرو جغرافیایی",
  "start": 116,
  "end": 117
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 302,
  "title": "ارکان و انواع ناحیه سیاسی",
  "start": 118,
  "end": 119
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 303,
  "title": "کانون و مرز ناحیه سیاسی",
  "start": 120,
  "end": 120
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 304,
  "title": "جغرافیای سیاسی",
  "start": 121,
  "end": 126
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 301,
  "title": "ارکان کشور و سرزمین",
  "start": 127,
  "end": 129
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 302,
  "title": "مرز و انواع مرز",
  "start": 129,
  "end": 135
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 303,
  "title": "اهمیت مرزها",
  "start": 135,
  "end": 137
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 304,
  "title": "وظایف مدیریت کشور",
  "start": 138,
  "end": 139
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 305,
  "title": "الگوهای مدیریت سیاسی فضا و بقای کشور",
  "start": 139,
  "end": 141
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 301,
  "title": "ژئوپلیتیک، قدرت و سیاست",
  "start": 142,
  "end": 144
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 302,
  "title": "نظریه‌های ژئوپلیتیکی و قدرت دریایی",
  "start": 144,
  "end": 147
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 303,
  "title": "ایران و قدرت دریایی",
  "start": 147,
  "end": 148
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 304,
  "title": "قدرت ملی و عوامل مؤثر",
  "start": 148,
  "end": 150
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 305,
  "title": "نقش عوامل جغرافیایی در قدرت ملی",
  "start": 150,
  "end": 152
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 306,
  "title": "منطقه ژئوپلیتیکی",
  "start": 152,
  "end": 154
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 307,
  "title": "مطالعه موردی منطقه ژئوپلیتیکی خلیج فارس",
  "start": 154,
  "end": 156
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 308,
  "title": "مطالعه موردی منطقه ژئوپلیتیکی اتحادیه اروپا",
  "start": 157,
  "end": 159
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 301,
  "title": "مقر و موقعیت سکونتگاه",
  "start": 2,
  "end": 5
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 302,
  "title": "تفاوت‌های شهر و روستا",
  "start": 6,
  "end": 6
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 303,
  "title": "سلسله مراتب سکونتگاه‌ها",
  "start": 7,
  "end": 8
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 304,
  "title": "حوزه نفوذ سکونتگاه",
  "start": 9,
  "end": 9
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 305,
  "title": "جهان در حال شهری شدن",
  "start": 10,
  "end": 11
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 306,
  "title": "از مادرشهر تا زنجیره کلان‌شهرها",
  "start": 12,
  "end": 15
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 307,
  "title": "تغییر در روستانشینی و مهاجرت",
  "start": 16,
  "end": 17
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 308,
  "title": "روابط شهر و روستا",
  "start": 18,
  "end": 20
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 301,
  "title": "نیازها و مسائل شهرهای امروز",
  "start": 21,
  "end": 27
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 302,
  "title": "تجهیزات عمومی، مسکن و اشتغال شهری",
  "start": 21,
  "end": 23
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 303,
  "title": "امنیت شهری و محیط زیست شهری",
  "start": 24,
  "end": 25
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 304,
  "title": "زیباسازی، مبلمان و هوشمندسازی شهر",
  "start": 25,
  "end": 27
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 305,
  "title": "مدیریت شهرها و شهر پایدار",
  "start": 28,
  "end": 29
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 306,
  "title": "مدیریت روستاها و توسعه روستایی",
  "start": 30,
  "end": 34
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 307,
  "title": "نهادهای مدیریت شهر و روستا",
  "start": 35,
  "end": 35
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 308,
  "title": "آمایش سرزمین",
  "start": 35,
  "end": 37
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 309,
  "title": "مهارت سامانه اطلاعات جغرافیایی",
  "start": 38,
  "end": 40
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 301,
  "title": "گسترش حمل و نقل و نقش آن",
  "start": 42,
  "end": 44
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 302,
  "title": "حمل و نقل جاده‌ای",
  "start": 45,
  "end": 47
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 303,
  "title": "حمل و نقل ریلی",
  "start": 48,
  "end": 51
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 304,
  "title": "حمل و نقل آبی",
  "start": 52,
  "end": 55
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 305,
  "title": "حمل و نقل هوایی",
  "start": 55,
  "end": 56
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 306,
  "title": "حمل و نقل از طریق خطوط لوله",
  "start": 57,
  "end": 58
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 301,
  "title": "مدیریت حمل و نقل پایدار و شبکه‌ها",
  "start": 59,
  "end": 62
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 302,
  "title": "حفظ محیط زیست در حمل و نقل",
  "start": 63,
  "end": 64
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 303,
  "title": "حمل و نقل چندوجهی",
  "start": 65,
  "end": 66
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 304,
  "title": "مدیریت حمل و نقل شهری",
  "start": 67,
  "end": 70
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 305,
  "title": "مدیریت حمل و نقل در ایران",
  "start": 71,
  "end": 72
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 306,
  "title": "مهارت زمان محلی و رسمی",
  "start": 73,
  "end": 76
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 307,
  "title": "سامانه موقعیت‌یاب جهانی",
  "start": 77,
  "end": 80
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 301,
  "title": "مخاطرات طبیعی و زمین‌لرزه",
  "start": 82,
  "end": 83
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 302,
  "title": "گسل‌ها و اندازه‌گیری زمین‌لرزه",
  "start": 84,
  "end": 85
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 303,
  "title": "پراکندگی زمین‌لرزه و نواحی لرزه‌خیز ایران",
  "start": 86,
  "end": 88
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 304,
  "title": "آبدهی رود و سیل",
  "start": 89,
  "end": 92
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 305,
  "title": "حرکات دامنه‌ای و زمین‌لغزش",
  "start": 93,
  "end": 96
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 306,
  "title": "خشکسالی و پیامدهای آن",
  "start": 97,
  "end": 99
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 301,
  "title": "مخاطره، بحران و مدیریت مخاطرات طبیعی",
  "start": 100,
  "end": 100
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 302,
  "title": "مدیریت پیش، هنگام و پس از زمین‌لرزه",
  "start": 100,
  "end": 103
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 303,
  "title": "مدیریت پیش، هنگام و پس از سیل",
  "start": 104,
  "end": 106
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 304,
  "title": "مدیریت زمین‌لغزش",
  "start": 107,
  "end": 108
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 305,
  "title": "مدیریت خشکسالی",
  "start": 108,
  "end": 110
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 306,
  "title": "سنجش از دور در مطالعات جغرافیایی",
  "start": 111,
  "end": 112
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 307,
  "title": "سنجش از دور در مطالعه مخاطرات طبیعی",
  "start": 113,
  "end": 114
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 2,
  "end": 10
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۲",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 11,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 20,
  "end": 36
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 37,
  "end": 52
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 53,
  "end": 66
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 68,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 83,
  "end": 98
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 99,
  "end": 114
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 116,
  "end": 126
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 127,
  "end": 141
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 142,
  "end": 159
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 2,
  "end": 20
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 21,
  "end": 40
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 42,
  "end": 58
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 59,
  "end": 80
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 82,
  "end": 99
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 300,
  "title": "کل درس و مهارت‌ها",
  "start": 100,
  "end": 114
 }
]$topics$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v180:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405','humanities',p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
