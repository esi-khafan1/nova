-- Activity blocks of user-provided 1405 geography books. Add only; do not touch earlier seeds.
-- The one-time marker prevents re-creating administrator-deleted rows when this migration is retried.
with installed as (insert into private.planner_seed_installations(seed_key) values ('geography10-12-activities-1405-v229') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۱",
  "position": 1001,
  "title": "فعالیت ۱ — کارکرد مثبت و منفی انسان در نواحی طبیعی",
  "start": 6,
  "end": 6
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۱",
  "position": 1002,
  "title": "فعالیت ۲ — پرسش‌های دید ترکیبی درباره روستا",
  "start": 7,
  "end": 7
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۲",
  "position": 1001,
  "title": "فعالیت ۱ — پرسش‌های کلیدی جغرافیا درباره سیل کن و سولقان",
  "start": 9,
  "end": 9
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۲",
  "position": 1002,
  "title": "فعالیت ۲ — طرح مسئله و روش پژوهش جغرافیایی",
  "start": 12,
  "end": 12
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۳",
  "position": 1001,
  "title": "فعالیت ۱ — موقعیت ریاضی استان، مدرسه و منزل",
  "start": 14,
  "end": 14
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۳",
  "position": 1002,
  "title": "فعالیت ۲ — مقایسۀ موقعیت‌های فرضی و واقعی ایران",
  "start": 15,
  "end": 15
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۳",
  "position": 1003,
  "title": "فعالیت ۳ — بررسی موقعیت نسبی ایران",
  "start": 16,
  "end": 16
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۳",
  "position": 1004,
  "title": "فعالیت ۴ — مقایسۀ وسعت، جمعیت و تولید نفت کشورهای خلیج فارس",
  "start": 18,
  "end": 18
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۳",
  "position": 1005,
  "title": "فعالیت ۵ — تراکم جمعیت نواحی کم‌تراکم",
  "start": 18,
  "end": 18
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۳",
  "position": 1006,
  "title": "فعالیت ۶ — پژوهش دربارۀ زندگی یک شهید مرزبان استان",
  "start": 21,
  "end": 21
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۳",
  "position": 1007,
  "title": "فعالیت ۷ — مزیت مرزهای آبی و اهمیت تنگه‌ها",
  "start": 21,
  "end": 21
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۴",
  "position": 1001,
  "title": "فعالیت ۱ — جاده‌های البرز و تغییر ناهمواری‌ها",
  "start": 26,
  "end": 26
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۴",
  "position": 1002,
  "title": "فعالیت ۲ — عوامل انسانی تغییر شکل ناهمواری محل زندگی",
  "start": 29,
  "end": 29
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۴",
  "position": 1003,
  "title": "فعالیت ۳ — ارزش اقتصادی و دفاعی دشت‌های داخلی",
  "start": 32,
  "end": 32
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۴",
  "position": 1004,
  "title": "فعالیت ۴ — اهمیت ارتباطی و اقتصادی جلگه‌های ساحلی",
  "start": 33,
  "end": 33
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۵",
  "position": 1001,
  "title": "فعالیت ۱ — بازدید هواشناسی و بررسی تصاویر ماهواره‌ای",
  "start": 36,
  "end": 36
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۵",
  "position": 1002,
  "title": "فعالیت ۲ — جهت کوهستان، بارش و دمای شهرها",
  "start": 39,
  "end": 39
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۵",
  "position": 1003,
  "title": "فعالیت ۳ — جدول ویژگی و منشأ توده‌های هوا",
  "start": 40,
  "end": 40
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۵",
  "position": 1004,
  "title": "فعالیت ۴ — توده‌های هوای مؤثر بر محل زندگی",
  "start": 40,
  "end": 40
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۵",
  "position": 1005,
  "title": "فعالیت ۵ — نوع آب و هوای استان محل زندگی",
  "start": 42,
  "end": 42
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۵",
  "position": 1006,
  "title": "فعالیت ۶ — عوامل به‌وجودآمدن شرایط بیابانی",
  "start": 43,
  "end": 43
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۵",
  "position": 1007,
  "title": "فعالیت ۷ — سازگاری معماری با آب و هوا",
  "start": 47,
  "end": 47
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۶",
  "position": 1001,
  "title": "فعالیت ۱ — تأمین آب و الگوی مصرف محل زندگی",
  "start": 49,
  "end": 49
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۶",
  "position": 1002,
  "title": "فعالیت ۲ — عوامل مؤثر بر بارش استان",
  "start": 50,
  "end": 50
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۶",
  "position": 1003,
  "title": "فعالیت ۳ — حوضۀ آبریز استان محل زندگی",
  "start": 52,
  "end": 52
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۶",
  "position": 1004,
  "title": "فعالیت ۴ — حفظ حیات وحش دریای خزر",
  "start": 54,
  "end": 54
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۶",
  "position": 1005,
  "title": "فعالیت ۵ — نام خلیج فارس و نقش تنگۀ هرمز و جزایر",
  "start": 56,
  "end": 56
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۶",
  "position": 1006,
  "title": "فعالیت ۶ — گزارش ویژگی‌های جغرافیایی یا اقتصادی دریا",
  "start": 58,
  "end": 58
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۶",
  "position": 1007,
  "title": "فعالیت ۷ — راهکارهای مبارزه با آلودگی دریاها",
  "start": 58,
  "end": 58
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۶",
  "position": 1008,
  "title": "فعالیت ۸ — گزارش دریاچه و آیات مرتبط با آب",
  "start": 63,
  "end": 63
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۷",
  "position": 1001,
  "title": "فعالیت ۱ — عوامل طبیعی و انسانی پراکندگی جمعیت",
  "start": 68,
  "end": 68
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۷",
  "position": 1002,
  "title": "فعالیت ۲ — عوامل مؤثر بر تغییر جمعیت محل زندگی",
  "start": 68,
  "end": 68
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۷",
  "position": 1003,
  "title": "فعالیت ۳ — مقایسۀ رشد جمعیت استان و کشور",
  "start": 70,
  "end": 70
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۷",
  "position": 1004,
  "title": "فعالیت ۴ — بررسی تفاوت اعداد جمعیتی در سال‌های مختلف",
  "start": 72,
  "end": 72
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۷",
  "position": 1005,
  "title": "فعالیت ۵ — سرشماری و مقایسۀ هرم‌های سنی",
  "start": 73,
  "end": 73
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۷",
  "position": 1006,
  "title": "فعالیت ۶ — نمودار مهاجرپذیری استان‌ها",
  "start": 76,
  "end": 76
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۷",
  "position": 1007,
  "title": "فعالیت ۷ — اجرای سیاست‌های مرتبط با مهاجرت در منطقه",
  "start": 77,
  "end": 77
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۷",
  "position": 1008,
  "title": "فعالیت ۸ — عوامل تاریخی و طبیعی مهاجرت روی نقشه",
  "start": 77,
  "end": 77
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۷",
  "position": 1009,
  "title": "فعالیت ۹ — تغییرات جمعیتی آبادان و مهاجرت",
  "start": 78,
  "end": 78
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۸",
  "position": 1001,
  "title": "فعالیت ۱ — تقسیمات کشوری در شناسنامه",
  "start": 79,
  "end": 79
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۸",
  "position": 1002,
  "title": "فعالیت ۲ — ترسیم نقشۀ استان و تقسیمات محل زندگی",
  "start": 84,
  "end": 84
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۹",
  "position": 1001,
  "title": "فعالیت ۱ — عوامل مؤثر بر شکل‌گیری سکونتگاه",
  "start": 86,
  "end": 86
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۹",
  "position": 1002,
  "title": "فعالیت ۲ — عامل گسترش سکونتگاه در تصاویر",
  "start": 87,
  "end": 87
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۹",
  "position": 1003,
  "title": "فعالیت ۳ — علت شکل‌گیری سکونتگاه محل زندگی",
  "start": 87,
  "end": 87
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۹",
  "position": 1004,
  "title": "فعالیت ۴ — پراکندگی روستاهای متمرکز و پراکنده",
  "start": 91,
  "end": 91
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۹",
  "position": 1005,
  "title": "فعالیت ۵ — بحث زندگی در شهرهای بزرگ",
  "start": 94,
  "end": 94
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۹",
  "position": 1006,
  "title": "فعالیت ۶ — جدول موقعیت و نقش سکونتگاه‌ها",
  "start": 95,
  "end": 95
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۹",
  "position": 1007,
  "title": "فعالیت ۷ — مشاغل و امکانات محل زندگی",
  "start": 95,
  "end": 95
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۹",
  "position": 1008,
  "title": "فعالیت ۸ — پیامدهای مهاجرت معکوس",
  "start": 95,
  "end": 95
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۱۰",
  "position": 1001,
  "title": "فعالیت ۱ — پراکندگی محصولات کشاورزی و کشت گلخانه‌ای",
  "start": 99,
  "end": 99
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۱۰",
  "position": 1002,
  "title": "فعالیت ۲ — تولیدات دامی و صنایع غذایی استان",
  "start": 100,
  "end": 100
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۱۰",
  "position": 1003,
  "title": "فعالیت ۳ — صنایع دستی محل زندگی",
  "start": 101,
  "end": 101
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۱۰",
  "position": 1004,
  "title": "فعالیت ۴ — صنایع ماشینی استان",
  "start": 102,
  "end": 102
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۱۰",
  "position": 1005,
  "title": "فعالیت ۵ — مزایا و معایب تجارت الکترونیکی",
  "start": 105,
  "end": 105
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "chapter": "درس ۱۰",
  "position": 1006,
  "title": "فعالیت ۶ — جاذبه‌های گردشگری و حفاظت از آنها",
  "start": 107,
  "end": 107
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱",
  "position": 1001,
  "title": "فعالیت — ناحیه‌بندی و معیارهای نقشه‌ها",
  "start": 10,
  "end": 10
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۲",
  "position": 1001,
  "title": "فعالیت — مرزهای طبیعی، انسانی و سیاسی و مفهوم ناحیه",
  "start": 17,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 1001,
  "title": "فعالیت — مقایسۀ اقلیم اولان‌باتور و جاکارتا",
  "start": 20,
  "end": 21
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 1002,
  "title": "فعالیت — ترکیب هواکره و میانگین دما",
  "start": 22,
  "end": 22
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 1003,
  "title": "فعالیت — عرض جغرافیایی، ارتفاع و توده‌های هوا",
  "start": 25,
  "end": 25
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 1004,
  "title": "فعالیت — بارش و دامنه‌های کوهستان و نقشه بارندگی",
  "start": 28,
  "end": 28
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 1005,
  "title": "فعالیت — طبقه‌بندی اقلیم‌های جهان",
  "start": 31,
  "end": 31
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 1006,
  "title": "فعالیت — عوامل بیابان و مقایسۀ بیابان‌ها",
  "start": 34,
  "end": 34
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 1001,
  "title": "فعالیت — شناسایی انواع ناهمواری روی نقشه",
  "start": 37,
  "end": 37
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 1002,
  "title": "فعالیت — پیامد نبود ناهمواری بر محیط و زندگی",
  "start": 40,
  "end": 40
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 1003,
  "title": "فعالیت — عوامل فرسایش و هوازدگی",
  "start": 43,
  "end": 43
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 1004,
  "title": "فعالیت — شکل دره‌ها و بازدید غار آهکی",
  "start": 46,
  "end": 46
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 1005,
  "title": "فعالیت — اشکال فرسایشی بیابانی و ساحلی",
  "start": 50,
  "end": 50
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 1001,
  "title": "فعالیت — زیست‌کره و روابط گیاهان، جانوران و انسان",
  "start": 53,
  "end": 53
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 1002,
  "title": "فعالیت — تشخیص زیست‌بوم‌ها و انطباق با نقشه",
  "start": 56,
  "end": 56
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 1003,
  "title": "فعالیت — تولید مواد آلی و زیست‌بوم‌ها",
  "start": 57,
  "end": 57
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 1004,
  "title": "فعالیت — قابلیت و حفاظت محیط‌های ساحل، بیابان و کوهستان",
  "start": 63,
  "end": 63
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 1005,
  "title": "فعالیت — جغرافیا و مشکلات و گردشگری نپال",
  "start": 66,
  "end": 66
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 1001,
  "title": "فعالیت — مقایسۀ مشاهدات فرهنگی دو گردشگر",
  "start": 68,
  "end": 68
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 1002,
  "title": "فعالیت — زبان‌های جهان و علل پراکندگی آنها",
  "start": 71,
  "end": 71
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 1003,
  "title": "فعالیت — نمایشگاه عکس چشم‌انداز فرهنگی",
  "start": 75,
  "end": 75
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 1004,
  "title": "فعالیت — نقشۀ نواحی فرهنگی جهان و جدول ویژگی‌ها",
  "start": 76,
  "end": 78
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 1005,
  "title": "فعالیت — مهارت نقشه‌خوانی خانواده‌های زبانی",
  "start": 82,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 1001,
  "title": "فعالیت — جداول تولید برنج و گندم",
  "start": 90,
  "end": 90
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 1002,
  "title": "فعالیت — شرکت‌های چندملیتی و کارگران مزارع",
  "start": 93,
  "end": 93
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 1003,
  "title": "فعالیت — راهکار گرسنگی و نقشۀ سوءتغذیه",
  "start": 94,
  "end": 94
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 1004,
  "title": "فعالیت — صنایع پیشرفته و پارک‌های علم و فناوری",
  "start": 98,
  "end": 98
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 1001,
  "title": "فعالیت — صادرات و واردات ایران",
  "start": 101,
  "end": 101
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 1002,
  "title": "فعالیت — خواندن هرم توزیع ثروت جهان",
  "start": 105,
  "end": 105
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 1003,
  "title": "فعالیت — مقایسۀ کشورهای مرکز، پیرامون و نیمه‌پیرامون",
  "start": 108,
  "end": 108
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 1004,
  "title": "فعالیت — اقتصاد مقاومتی و اتحادیه‌های منطقه‌ای",
  "start": 108,
  "end": 109
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 1005,
  "title": "فعالیت — منطقۀ آزاد تجاری و مدل مرکز و پیرامون",
  "start": 112,
  "end": 112
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 1001,
  "title": "فعالیت — ارکان ناحیۀ سیاسی با مثال فروشگاه",
  "start": 117,
  "end": 117
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 1002,
  "title": "فعالیت — ناحیه‌های سیاسی و قلمروهای اداری",
  "start": 120,
  "end": 120
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 1003,
  "title": "فعالیت — ارکان ناحیۀ سیاسی و تعریف جغرافیای سیاسی",
  "start": 126,
  "end": 126
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 1001,
  "title": "فعالیت — مقایسۀ ارکان کشور و ناحیۀ سیاسی",
  "start": 127,
  "end": 127
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 1002,
  "title": "فعالیت — تعلق مکانی و وابستگی به وطن",
  "start": 129,
  "end": 129
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 1003,
  "title": "فعالیت — انواع مرز بر اساس تصاویر و نقشه",
  "start": 133,
  "end": 133
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 1004,
  "title": "فعالیت — اختلافات مرزی و همسایگان ایران",
  "start": 136,
  "end": 136
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 1005,
  "title": "فعالیت — نظام‌های سیاسی یکپارچه و فدرال",
  "start": 140,
  "end": 140
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 1001,
  "title": "فعالیت — قدرت دریایی و شرایط ایران",
  "start": 146,
  "end": 146
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 1002,
  "title": "فعالیت — عوامل مؤثر در قدرت ملی",
  "start": 149,
  "end": 149
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 1003,
  "title": "فعالیت — قدرت ملی و مطالعۀ مناطق ژئوپلیتیکی",
  "start": 152,
  "end": 153
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 1004,
  "title": "فعالیت — منطقۀ ژئوپلیتیکی خلیج فارس",
  "start": 156,
  "end": 156
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 1005,
  "title": "فعالیت — کشورها و همگرایی و واگرایی اتحادیۀ اروپا",
  "start": 159,
  "end": 159
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 1001,
  "title": "فعالیت — هستۀ اولیه شهر یا روستا و حفاظت از بافت تاریخی",
  "start": 3,
  "end": 3
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 1002,
  "title": "فعالیت — موقعیت قاهره و انتخاب مکان سکونتگاه",
  "start": 5,
  "end": 5
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 1003,
  "title": "فعالیت — شباهت‌های شهر و روستا",
  "start": 6,
  "end": 6
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 1004,
  "title": "فعالیت — سلسلۀ مراتب، حوزۀ نفوذ و مکان‌یابی خدمات",
  "start": 9,
  "end": 9
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 1005,
  "title": "فعالیت — حومه‌نشینی، کلان‌شهرها و فشار بر محیط زیست",
  "start": 16,
  "end": 16
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 1006,
  "title": "فعالیت — روابط شهر و روستا و عملکردهای روستایی",
  "start": 18,
  "end": 18
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 1007,
  "title": "فعالیت — مهاجرت، تبدیل روستا به شهر و کلان‌شهرهای ایران",
  "start": 20,
  "end": 20
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 1001,
  "title": "فعالیت — تحقیق دربارۀ حاشیه‌نشینی",
  "start": 23,
  "end": 23
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 1002,
  "title": "فعالیت — برنامه‌های آموزشی شهرداری",
  "start": 24,
  "end": 24
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 1003,
  "title": "فعالیت — زیباسازی، مبلمان و هوشمندسازی شهری",
  "start": 27,
  "end": 27
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 1004,
  "title": "فعالیت — کاربری اراضی و مکان‌یابی فروشگاه",
  "start": 29,
  "end": 30
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 1005,
  "title": "فعالیت — خدمات روستایی و حفاظت از محیط زیست",
  "start": 34,
  "end": 34
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 1006,
  "title": "فعالیت — شوراهای شهر و روستا و عملکرد شهرداری",
  "start": 35,
  "end": 35
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 1007,
  "title": "فعالیت — پوستر آمایش سرزمین",
  "start": 37,
  "end": 37
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 1008,
  "title": "فعالیت — مقایسۀ نقشه GIS و همپوشانی لایه‌ها",
  "start": 40,
  "end": 40
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 1001,
  "title": "فعالیت — تنگه‌ها، تحولات و موضوع جغرافیایی حمل‌ونقل",
  "start": 45,
  "end": 45
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 1002,
  "title": "فعالیت — خواندن اطلس راه‌ها و یافتن مسیر",
  "start": 47,
  "end": 47
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 1003,
  "title": "فعالیت — شبکۀ ریلی جهان و ایران و تاریخ راه‌آهن",
  "start": 51,
  "end": 51
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 1004,
  "title": "فعالیت — بنادر ایران و حمل‌ونقل دریایی",
  "start": 55,
  "end": 55
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 1005,
  "title": "فعالیت — مقایسۀ شیوه‌های حمل‌ونقل و خطوط لوله",
  "start": 58,
  "end": 58
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 1001,
  "title": "فعالیت — ماتریس شبکه و شاخص انحراف مسیر",
  "start": 61,
  "end": 61
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 1002,
  "title": "فعالیت — تصادف، بیمه و انتخاب مسیر جاده",
  "start": 66,
  "end": 66
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 1003,
  "title": "فعالیت — ترافیک شهری، دوچرخه و نمودار تردد",
  "start": 70,
  "end": 70
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 1004,
  "title": "فعالیت — سامانه‌های اطلاع‌رسانی حمل‌ونقل",
  "start": 72,
  "end": 72
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 1005,
  "title": "فعالیت — نصف‌النهار مبدأ بر روی کرۀ جغرافیایی",
  "start": 73,
  "end": 73
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 1006,
  "title": "فعالیت — زمان اذان و ساعت محلی شهرها",
  "start": 74,
  "end": 74
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 1007,
  "title": "فعالیت — مناطق زمانی و محاسبۀ اختلاف ساعت",
  "start": 76,
  "end": 77
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 1008,
  "title": "فعالیت — مسیریابی و کاربردهای GPS",
  "start": 80,
  "end": 80
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 1001,
  "title": "فعالیت — کمربندهای زمین‌لرزه و مقیاس‌های اندازه‌گیری",
  "start": 88,
  "end": 88
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 1002,
  "title": "فعالیت — وقوع سیل، خسارات و ترسیم هیدروگراف",
  "start": 92,
  "end": 93
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 1003,
  "title": "فعالیت — پراکندگی زمین‌لغزش و بررسی نمونه",
  "start": 96,
  "end": 96
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 1004,
  "title": "فعالیت — تحقیق دربارۀ خشکسالی و پیامدها",
  "start": 99,
  "end": 99
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 1001,
  "title": "فعالیت — مدیریت زلزله، آموزش و مانور",
  "start": 103,
  "end": 103
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 1002,
  "title": "فعالیت — مقایسۀ تغییرات و مدیریت خطر سیل",
  "start": 106,
  "end": 106
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 1003,
  "title": "فعالیت — آبیاری، محصولات کم‌آب‌بر و نمودار دما و بارش",
  "start": 110,
  "end": 110
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 1004,
  "title": "فعالیت — تصاویر ماهواره‌ای، سیلاب سفیدرود و گوگل ارث",
  "start": 114,
  "end": 114
 }
]$topics$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)),
contexts(grade,field,track) as (values ('10','humanities','konkur'),('10','humanities','final_exam'),('10','mathematics','final_exam'),('10','experimental_sciences','final_exam'),('11','humanities','konkur'),('11','humanities','final_exam'),('12','humanities','konkur'),('12','humanities','final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v229:'||c.field||':'||p.grade||':'||c.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',c.field,p.grade,c.track,p.subject,p.chapter,p.title,p.start,p."end",p.position
from topics p join contexts c on c.grade=p.grade cross join installed on conflict(id) do nothing;
