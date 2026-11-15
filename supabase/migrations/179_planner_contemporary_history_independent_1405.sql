-- Contemporary history 111220, 1405, user-provided PDF: independent sections of all 26 lessons.
-- Previous groupings and snapshots are retained, with a one-time installation marker.
with installed as (insert into private.planner_seed_installations(seed_key) values ('contemporary-history-independent-1405-v179') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 301,
  "title": "بنیاد سلسله قاجار",
  "start": 17,
  "end": 18
 },
 {
  "chapter": "درس ۱",
  "position": 302,
  "title": "هجوم سیاسی و نظامی استعمارگران و جنگ‌های ایران و روس",
  "start": 18,
  "end": 21
 },
 {
  "chapter": "درس ۱",
  "position": 303,
  "title": "رقابت و توسعه‌طلبی فرانسه و انگلستان",
  "start": 22,
  "end": 23
 },
 {
  "chapter": "درس ۱",
  "position": 304,
  "title": "جنگ هرات",
  "start": 24,
  "end": 25
 },
 {
  "chapter": "درس ۱",
  "position": 305,
  "title": "معاهده دوم ارزنةالروم",
  "start": 25,
  "end": 26
 },
 {
  "chapter": "درس ۲",
  "position": 301,
  "title": "صدارت امیرکبیر",
  "start": 27,
  "end": 28
 },
 {
  "chapter": "درس ۲",
  "position": 302,
  "title": "واگذاری امتیازات به بیگانگان",
  "start": 29,
  "end": 31
 },
 {
  "chapter": "درس ۲",
  "position": 303,
  "title": "نهضت تحریم تنباکو",
  "start": 32,
  "end": 35
 },
 {
  "chapter": "درس ۲",
  "position": 304,
  "title": "سید جمال‌الدین اسدآبادی",
  "start": 34,
  "end": 35
 },
 {
  "chapter": "درس ۳",
  "position": 301,
  "title": "از دست رفتن بخش‌هایی از سرزمین ایران",
  "start": 37,
  "end": 37
 },
 {
  "chapter": "درس ۳",
  "position": 302,
  "title": "غلبه استعمار بر کشور",
  "start": 38,
  "end": 38
 },
 {
  "chapter": "درس ۳",
  "position": 303,
  "title": "استبداد دستگاه حاکم",
  "start": 39,
  "end": 39
 },
 {
  "chapter": "درس ۳",
  "position": 304,
  "title": "مخالفت مردم و علما با استبداد و استعمار",
  "start": 39,
  "end": 40
 },
 {
  "chapter": "درس ۳",
  "position": 305,
  "title": "ورود اندیشه‌های جدید",
  "start": 40,
  "end": 42
 },
 {
  "chapter": "درس ۳",
  "position": 306,
  "title": "روزنامه‌ها و آثار روشنفکران",
  "start": 41,
  "end": 42
 },
 {
  "chapter": "درس ۴",
  "position": 301,
  "title": "ماجرای نوز بلژیکی",
  "start": 44,
  "end": 44
 },
 {
  "chapter": "درس ۴",
  "position": 302,
  "title": "نارضایتی مردم ایالت‌ها",
  "start": 45,
  "end": 45
 },
 {
  "chapter": "درس ۴",
  "position": 303,
  "title": "ماجرای بانک استقراضی روس",
  "start": 46,
  "end": 46
 },
 {
  "chapter": "درس ۴",
  "position": 304,
  "title": "فلک شدن بازرگانان",
  "start": 46,
  "end": 47
 },
 {
  "chapter": "درس ۴",
  "position": 305,
  "title": "مهاجرت صغری",
  "start": 47,
  "end": 48
 },
 {
  "chapter": "درس ۴",
  "position": 306,
  "title": "مهاجرت کبری و تحصن در سفارت انگلیس",
  "start": 48,
  "end": 49
 },
 {
  "chapter": "درس ۴",
  "position": 307,
  "title": "پیروزی نهضت و تشکیل مجلس شورای ملی",
  "start": 49,
  "end": 51
 },
 {
  "chapter": "درس ۵",
  "position": 301,
  "title": "تدوین متمم قانون اساسی و اختلاف‌ها",
  "start": 53,
  "end": 54
 },
 {
  "chapter": "درس ۵",
  "position": 302,
  "title": "خودداری شاه از امضای متمم و اهداف روسیه و انگلستان",
  "start": 54,
  "end": 55
 },
 {
  "chapter": "درس ۵",
  "position": 303,
  "title": "قرارداد ۱۹۰۷ روس و انگلیس",
  "start": 55,
  "end": 56
 },
 {
  "chapter": "درس ۵",
  "position": 304,
  "title": "اقدام انقلابی مردم و مجلس",
  "start": 56,
  "end": 57
 },
 {
  "chapter": "درس ۵",
  "position": 305,
  "title": "به توپ بستن مجلس و استبداد صغیر",
  "start": 57,
  "end": 58
 },
 {
  "chapter": "درس ۵",
  "position": 306,
  "title": "مقاومت مردم",
  "start": 58,
  "end": 60
 },
 {
  "chapter": "درس ۶",
  "position": 301,
  "title": "قدرت گرفتن جریان جدید و اختلاف‌های داخلی",
  "start": 61,
  "end": 62
 },
 {
  "chapter": "درس ۶",
  "position": 302,
  "title": "شهادت شیخ فضل‌الله نوری",
  "start": 62,
  "end": 63
 },
 {
  "chapter": "درس ۶",
  "position": 303,
  "title": "تشدید اختلاف میان مشروطه‌خواهان",
  "start": 64,
  "end": 65
 },
 {
  "chapter": "درس ۶",
  "position": 304,
  "title": "مجلس نوپای مشروطه و مداخله بیگانگان",
  "start": 65,
  "end": 67
 },
 {
  "chapter": "درس ۶",
  "position": 305,
  "title": "تاج‌گذاری احمدشاه و جنگ جهانی اول",
  "start": 68,
  "end": 72
 },
 {
  "chapter": "درس ۷",
  "position": 301,
  "title": "اهمیت ایران برای انگلستان",
  "start": 73,
  "end": 75
 },
 {
  "chapter": "درس ۷",
  "position": 302,
  "title": "تسلط انگلستان بر نیروهای نظامی ایران",
  "start": 75,
  "end": 75
 },
 {
  "chapter": "درس ۷",
  "position": 303,
  "title": "قرارداد ۱۹۱۹",
  "start": 75,
  "end": 76
 },
 {
  "chapter": "درس ۷",
  "position": 304,
  "title": "کودتای ۱۲۹۹ و عاملان آن",
  "start": 76,
  "end": 77
 },
 {
  "chapter": "درس ۷",
  "position": 305,
  "title": "چگونگی اجرای کودتا",
  "start": 77,
  "end": 81
 },
 {
  "chapter": "درس ۸",
  "position": 301,
  "title": "سقوط کابینه سیاه و دولت‌های ناپایدار",
  "start": 82,
  "end": 83
 },
 {
  "chapter": "درس ۸",
  "position": 302,
  "title": "نخست‌وزیری رضاخان",
  "start": 84,
  "end": 84
 },
 {
  "chapter": "درس ۸",
  "position": 303,
  "title": "قدرت‌طلبی به اسم جمهوری‌خواهی",
  "start": 84,
  "end": 85
 },
 {
  "chapter": "درس ۸",
  "position": 304,
  "title": "برکناری قاجار و تغییر سلطنت",
  "start": 85,
  "end": 86
 },
 {
  "chapter": "درس ۸",
  "position": 305,
  "title": "شرایط داخلی ایران",
  "start": 87,
  "end": 87
 },
 {
  "chapter": "درس ۸",
  "position": 306,
  "title": "حزب‌ها و جریان‌های سیاسی، اجتماعی و فرهنگی",
  "start": 88,
  "end": 89
 },
 {
  "chapter": "درس ۹",
  "position": 301,
  "title": "وابستگی و خودکامگی",
  "start": 90,
  "end": 90
 },
 {
  "chapter": "درس ۹",
  "position": 302,
  "title": "ترویج ملی‌گرایی افراطی",
  "start": 91,
  "end": 91
 },
 {
  "chapter": "درس ۹",
  "position": 303,
  "title": "نظامی‌گری و تضعیف ارزش‌های دینی",
  "start": 92,
  "end": 94
 },
 {
  "chapter": "درس ۹",
  "position": 304,
  "title": "تغییر کلاه و لباس",
  "start": 95,
  "end": 95
 },
 {
  "chapter": "درس ۹",
  "position": 305,
  "title": "کشف حجاب",
  "start": 96,
  "end": 98
 },
 {
  "chapter": "درس ۱۰",
  "position": 301,
  "title": "گرایش رضاشاه به آلمان و جنگ جهانی دوم",
  "start": 99,
  "end": 99
 },
 {
  "chapter": "درس ۱۰",
  "position": 302,
  "title": "اشغال ایران",
  "start": 100,
  "end": 100
 },
 {
  "chapter": "درس ۱۰",
  "position": 303,
  "title": "برکناری و تبعید رضاشاه",
  "start": 101,
  "end": 101
 },
 {
  "chapter": "درس ۱۰",
  "position": 304,
  "title": "کارنامه حکومت رضاشاه",
  "start": 102,
  "end": 104
 },
 {
  "chapter": "درس ۱۰",
  "position": 305,
  "title": "قرارداد نفت ۱۹۳۳ و پیمان سعدآباد",
  "start": 103,
  "end": 103
 },
 {
  "chapter": "درس ۱۱",
  "position": 301,
  "title": "نخستین سال‌های حکومت محمدرضا پهلوی",
  "start": 106,
  "end": 106
 },
 {
  "chapter": "درس ۱۱",
  "position": 302,
  "title": "تصاحب امکانات ایران توسط متفقین",
  "start": 107,
  "end": 107
 },
 {
  "chapter": "درس ۱۱",
  "position": 303,
  "title": "تشکیل حزب‌های سیاسی و دخالت بیگانگان",
  "start": 107,
  "end": 108
 },
 {
  "chapter": "درس ۱۱",
  "position": 304,
  "title": "مذاکره‌های نفت و سیاست موازنه منفی",
  "start": 108,
  "end": 108
 },
 {
  "chapter": "درس ۱۱",
  "position": 305,
  "title": "شکست تجزیه‌طلبان و تخلیه نیروهای شوروی",
  "start": 108,
  "end": 109
 },
 {
  "chapter": "درس ۱۱",
  "position": 306,
  "title": "دولت‌های بی‌ثبات و شناسایی رژیم اشغالگر قدس",
  "start": 109,
  "end": 110
 },
 {
  "chapter": "درس ۱۱",
  "position": 307,
  "title": "تغییر قانون اساسی برای افزایش اختیارات شاه",
  "start": 110,
  "end": 112
 },
 {
  "chapter": "درس ۱۲",
  "position": 301,
  "title": "زمینه‌های شکل‌گیری نهضت ملی شدن نفت",
  "start": 113,
  "end": 115
 },
 {
  "chapter": "درس ۱۲",
  "position": 302,
  "title": "دولت رزم‌آرا و ملی شدن نفت",
  "start": 115,
  "end": 116
 },
 {
  "chapter": "درس ۱۲",
  "position": 303,
  "title": "تصویب ملی شدن صنعت نفت",
  "start": 116,
  "end": 116
 },
 {
  "chapter": "درس ۱۲",
  "position": 304,
  "title": "نخست‌وزیری مصدق",
  "start": 116,
  "end": 118
 },
 {
  "chapter": "درس ۱۳",
  "position": 301,
  "title": "قیام سی تیر",
  "start": 119,
  "end": 120
 },
 {
  "chapter": "درس ۱۳",
  "position": 302,
  "title": "دور دوم نخست‌وزیری مصدق",
  "start": 120,
  "end": 121
 },
 {
  "chapter": "درس ۱۳",
  "position": 303,
  "title": "نقش آمریکا و انگلستان در زمینه‌سازی کودتا",
  "start": 121,
  "end": 123
 },
 {
  "chapter": "درس ۱۳",
  "position": 304,
  "title": "حزب توده و شبکه بدامن",
  "start": 123,
  "end": 125
 },
 {
  "chapter": "درس ۱۳",
  "position": 305,
  "title": "نقش شاه، درباریان و مطبوعات",
  "start": 125,
  "end": 126
 },
 {
  "chapter": "درس ۱۳",
  "position": 306,
  "title": "انحلال مجلس و اعتماد به آمریکا",
  "start": 126,
  "end": 127
 },
 {
  "chapter": "درس ۱۳",
  "position": 307,
  "title": "جدایی مصدق از روحانیت",
  "start": 127,
  "end": 128
 },
 {
  "chapter": "درس ۱۴",
  "position": 301,
  "title": "طراحی کودتا و رویدادهای ۲۵ مرداد",
  "start": 129,
  "end": 130
 },
 {
  "chapter": "درس ۱۴",
  "position": 302,
  "title": "اجرای کودتای ۲۸ مرداد",
  "start": 131,
  "end": 132
 },
 {
  "chapter": "درس ۱۴",
  "position": 303,
  "title": "بازگشت محمدرضا پهلوی و نتیجه‌گیری",
  "start": 133,
  "end": 134
 },
 {
  "chapter": "درس ۱۵",
  "position": 301,
  "title": "اوضاع سیاسی پس از کودتا",
  "start": 135,
  "end": 136
 },
 {
  "chapter": "درس ۱۵",
  "position": 302,
  "title": "انتخابات دوره هجدهم مجلس",
  "start": 136,
  "end": 137
 },
 {
  "chapter": "درس ۱۵",
  "position": 303,
  "title": "قرارداد کنسرسیوم و دولت حسین علاء",
  "start": 137,
  "end": 138
 },
 {
  "chapter": "درس ۱۵",
  "position": 304,
  "title": "پیمان بغداد",
  "start": 138,
  "end": 138
 },
 {
  "chapter": "درس ۱۵",
  "position": 305,
  "title": "تأسیس ساواک",
  "start": 139,
  "end": 140
 },
 {
  "chapter": "درس ۱۵",
  "position": 306,
  "title": "دولت منوچهر اقبال",
  "start": 141,
  "end": 141
 },
 {
  "chapter": "درس ۱۶",
  "position": 301,
  "title": "تحولات بین‌المللی و منطقه‌ای و اتحاد برای پیشرفت",
  "start": 142,
  "end": 144
 },
 {
  "chapter": "درس ۱۶",
  "position": 302,
  "title": "نخست‌وزیری شریف امامی",
  "start": 144,
  "end": 144
 },
 {
  "chapter": "درس ۱۶",
  "position": 303,
  "title": "اصلاحات دوره نخست‌وزیری علی امینی",
  "start": 144,
  "end": 145
 },
 {
  "chapter": "درس ۱۷",
  "position": 301,
  "title": "دولت اسدالله علم",
  "start": 146,
  "end": 147
 },
 {
  "chapter": "درس ۱۷",
  "position": 302,
  "title": "تصویب انجمن‌های ایالتی و ولایتی",
  "start": 147,
  "end": 148
 },
 {
  "chapter": "درس ۱۷",
  "position": 303,
  "title": "انقلاب سفید",
  "start": 148,
  "end": 149
 },
 {
  "chapter": "درس ۱۷",
  "position": 304,
  "title": "تحریم رفراندوم و قیام مردم",
  "start": 149,
  "end": 151
 },
 {
  "chapter": "درس ۱۸",
  "position": 301,
  "title": "حمله به فیضیه",
  "start": 152,
  "end": 153
 },
 {
  "chapter": "درس ۱۸",
  "position": 302,
  "title": "قیام پانزده خرداد",
  "start": 153,
  "end": 157
 },
 {
  "chapter": "درس ۱۸",
  "position": 303,
  "title": "دستاوردهای قیام ۱۵ خرداد و دولت حسنعلی منصور",
  "start": 158,
  "end": 158
 },
 {
  "chapter": "درس ۱۸",
  "position": 304,
  "title": "بازگشت کاپیتولاسیون",
  "start": 159,
  "end": 159
 },
 {
  "chapter": "درس ۱۸",
  "position": 305,
  "title": "دستگیری و تبعید امام خمینی",
  "start": 160,
  "end": 160
 },
 {
  "chapter": "درس ۱۸",
  "position": 306,
  "title": "آثار و نتایج نهضت بیدارگری اسلامی",
  "start": 161,
  "end": 161
 },
 {
  "chapter": "درس ۱۹",
  "position": 301,
  "title": "سیاست داخلی و حزب رستاخیز",
  "start": 162,
  "end": 164
 },
 {
  "chapter": "درس ۱۹",
  "position": 302,
  "title": "جشن‌های ۲۵۰۰ ساله و تقویم شاهنشاهی",
  "start": 164,
  "end": 165
 },
 {
  "chapter": "درس ۱۹",
  "position": 303,
  "title": "سیاست خارجی",
  "start": 165,
  "end": 166
 },
 {
  "chapter": "درس ۱۹",
  "position": 304,
  "title": "فساد اقتصادی",
  "start": 166,
  "end": 167
 },
 {
  "chapter": "درس ۱۹",
  "position": 305,
  "title": "استمرار مبارزه پس از تبعید امام",
  "start": 167,
  "end": 169
 },
 {
  "chapter": "درس ۱۹",
  "position": 306,
  "title": "مبارزات روحانیت و احیای هویت دینی",
  "start": 169,
  "end": 170
 },
 {
  "chapter": "درس ۱۹",
  "position": 307,
  "title": "جریان‌های سیاسی و مسلمانان انقلابی",
  "start": 171,
  "end": 172
 },
 {
  "chapter": "درس ۲۰",
  "position": 301,
  "title": "کارتر، شاه و فضای باز سیاسی",
  "start": 173,
  "end": 174
 },
 {
  "chapter": "درس ۲۰",
  "position": 302,
  "title": "دولت آموزگار و رحلت آیت‌الله سیدمصطفی خمینی",
  "start": 175,
  "end": 176
 },
 {
  "chapter": "درس ۲۰",
  "position": 303,
  "title": "سفر کارتر و انتشار مقاله توهین‌آمیز",
  "start": 176,
  "end": 177
 },
 {
  "chapter": "درس ۲۰",
  "position": 304,
  "title": "قیام مردم قم و تبریز",
  "start": 177,
  "end": 178
 },
 {
  "chapter": "درس ۲۰",
  "position": 305,
  "title": "شریف امامی و ادامه کشتارها",
  "start": 178,
  "end": 180
 },
 {
  "chapter": "درس ۲۱",
  "position": 301,
  "title": "هجرت امام خمینی به پاریس",
  "start": 181,
  "end": 182
 },
 {
  "chapter": "درس ۲۱",
  "position": 302,
  "title": "تشکیل دولت نظامی ازهاری",
  "start": 182,
  "end": 183
 },
 {
  "chapter": "درس ۲۱",
  "position": 303,
  "title": "تظاهرات عاشورا",
  "start": 183,
  "end": 184
 },
 {
  "chapter": "درس ۲۱",
  "position": 304,
  "title": "نخست‌وزیری بختیار و فرار شاه",
  "start": 184,
  "end": 185
 },
 {
  "chapter": "درس ۲۱",
  "position": 305,
  "title": "تظاهرات اربعین و بازگشت امام خمینی",
  "start": 185,
  "end": 187
 },
 {
  "chapter": "درس ۲۱",
  "position": 306,
  "title": "تشکیل دولت موقت و پیروزی انقلاب",
  "start": 188,
  "end": 189
 },
 {
  "chapter": "درس ۲۲",
  "position": 301,
  "title": "همه‌پرسی نظام سیاسی و تصویب قانون اساسی",
  "start": 191,
  "end": 192
 },
 {
  "chapter": "درس ۲۲",
  "position": 302,
  "title": "تأسیس نهادهای انقلابی",
  "start": 192,
  "end": 192
 },
 {
  "chapter": "درس ۲۲",
  "position": 303,
  "title": "اوضاع داخلی کشور در زمان دولت موقت",
  "start": 192,
  "end": 193
 },
 {
  "chapter": "درس ۲۲",
  "position": 304,
  "title": "توطئه آمریکا و گروهک‌های ضد انقلاب",
  "start": 193,
  "end": 194
 },
 {
  "chapter": "درس ۲۲",
  "position": 305,
  "title": "توطئه حزب خلق مسلمان و حوادث کردستان",
  "start": 194,
  "end": 196
 },
 {
  "chapter": "درس ۲۲",
  "position": 306,
  "title": "حوادث ترکمن‌صحرا، خوزستان و سیستان و بلوچستان",
  "start": 197,
  "end": 198
 },
 {
  "chapter": "درس ۲۲",
  "position": 307,
  "title": "استعفای دولت موقت",
  "start": 198,
  "end": 198
 },
 {
  "chapter": "درس ۲۳",
  "position": 301,
  "title": "ریاست جمهوری بنی‌صدر و آرایش گروه‌های سیاسی",
  "start": 199,
  "end": 200
 },
 {
  "chapter": "درس ۲۳",
  "position": 302,
  "title": "نیروهای انقلابی و انتخاب نخست‌وزیر",
  "start": 201,
  "end": 201
 },
 {
  "chapter": "درس ۲۳",
  "position": 303,
  "title": "انقلاب فرهنگی و برکناری بنی‌صدر",
  "start": 202,
  "end": 203
 },
 {
  "chapter": "درس ۲۳",
  "position": 304,
  "title": "ترور شخصیت‌های طراز اول کشور",
  "start": 203,
  "end": 209
 },
 {
  "chapter": "درس ۲۴",
  "position": 301,
  "title": "زمینه‌ها و آغاز جنگ تحمیلی",
  "start": 210,
  "end": 211
 },
 {
  "chapter": "درس ۲۴",
  "position": 302,
  "title": "بسیج ایرانیان و مقاومت در خرمشهر و آبادان",
  "start": 212,
  "end": 213
 },
 {
  "chapter": "درس ۲۴",
  "position": 303,
  "title": "حمله موشکی عراق و واکنش ایران",
  "start": 214,
  "end": 215
 },
 {
  "chapter": "درس ۲۴",
  "position": 304,
  "title": "قطعنامه ۵۹۸ و پایان جنگ",
  "start": 216,
  "end": 216
 },
 {
  "chapter": "درس ۲۴",
  "position": 305,
  "title": "ارتحال امام خمینی و رهبری آیت‌الله خامنه‌ای",
  "start": 217,
  "end": 222
 },
 {
  "chapter": "درس ۲۵",
  "position": 301,
  "title": "آرمان‌ها و هدف‌های انقلاب اسلامی",
  "start": 223,
  "end": 225
 },
 {
  "chapter": "درس ۲۵",
  "position": 302,
  "title": "استقلال فکری، سیاسی و اقتصادی",
  "start": 223,
  "end": 224
 },
 {
  "chapter": "درس ۲۵",
  "position": 303,
  "title": "جمهوری اسلامی و مردم‌سالاری دینی",
  "start": 225,
  "end": 225
 },
 {
  "chapter": "درس ۲۵",
  "position": 304,
  "title": "دستاوردهای سیاسی انقلاب",
  "start": 226,
  "end": 227
 },
 {
  "chapter": "درس ۲۵",
  "position": 305,
  "title": "دستاوردهای فرهنگی و اجتماعی",
  "start": 228,
  "end": 229
 },
 {
  "chapter": "درس ۲۵",
  "position": 306,
  "title": "دستاوردهای اقتصادی و عمرانی",
  "start": 230,
  "end": 232
 },
 {
  "chapter": "درس ۲۵",
  "position": 307,
  "title": "دستاوردهای علمی و فناوری",
  "start": 232,
  "end": 234
 },
 {
  "chapter": "درس ۲۵",
  "position": 308,
  "title": "استقلال و توان دفاعی",
  "start": 235,
  "end": 235
 },
 {
  "chapter": "درس ۲۵",
  "position": 309,
  "title": "بیداری اسلامی",
  "start": 235,
  "end": 237
 },
 {
  "chapter": "درس ۲۶",
  "position": 301,
  "title": "پایان جنگ سرد و شکل‌گیری نظم تک‌قطبی",
  "start": 238,
  "end": 239
 },
 {
  "chapter": "درس ۲۶",
  "position": 302,
  "title": "اهمیت غرب آسیا برای آمریکا",
  "start": 239,
  "end": 240
 },
 {
  "chapter": "درس ۲۶",
  "position": 303,
  "title": "رژیم اسرائیل و امنیت غرب آسیا",
  "start": 241,
  "end": 242
 },
 {
  "chapter": "درس ۲۶",
  "position": 304,
  "title": "راهبرد امنیت مستقل ایران",
  "start": 243,
  "end": 245
 },
 {
  "chapter": "درس ۲۶",
  "position": 305,
  "title": "فشار برای مهار ایران",
  "start": 246,
  "end": 247
 },
 {
  "chapter": "درس ۲۶",
  "position": 306,
  "title": "افزایش بحران در دهه‌های بعد",
  "start": 248,
  "end": 250
 },
 {
  "chapter": "درس ۲۶",
  "position": 307,
  "title": "انسجام و گسترش جبهه مقاومت",
  "start": 251,
  "end": 253
 },
 {
  "chapter": "درس ۲۶",
  "position": 308,
  "title": "از طوفان الاقصی تا گسترش جنگ منطقه‌ای",
  "start": 254,
  "end": 256
 },
 {
  "chapter": "درس ۲۶",
  "position": 309,
  "title": "جنگ دوازده روزه",
  "start": 257,
  "end": 258
 },
 {
  "chapter": "درس ۲۶",
  "position": 310,
  "title": "آغاز جنگ رمضان",
  "start": 259,
  "end": 260
 },
 {
  "chapter": "درس ۲۶",
  "position": 311,
  "title": "پاسخ ایران و بسته شدن تنگه هرمز",
  "start": 261,
  "end": 263
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), fields(field) as (values ('mathematics'),('experimental_sciences'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v179:'||f.field||':11:final_exam:تاریخ معاصر ایران:'||p.chapter||':'||p.position)::uuid,'1405',f.field,'11','final_exam','تاریخ معاصر ایران',p.chapter,p.title,p.start,p."end",p.position from topics p cross join fields f cross join installed on conflict(id) do nothing;
