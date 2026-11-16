-- History 3 (112219), 1405. Sources and limits: docs/planner-topic-sources.md.
with installed as (insert into private.planner_seed_installations(seed_key) values ('history12-1405-v205') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 400,
  "title": "کل درس",
  "start": 2,
  "end": 15
 },
 {
  "chapter": "درس ۱",
  "position": 450,
  "title": "تاریخ‌نگاری سنتی و میراث تاریخی",
  "start": 2,
  "end": 2
 },
 {
  "chapter": "درس ۱",
  "position": 451,
  "title": "شرح: تاریخ‌نگاری جدید",
  "start": 3,
  "end": 6
 },
 {
  "chapter": "درس ۱",
  "position": 452,
  "title": "گونه‌های منابع تاریخی در دوره معاصر",
  "start": 7,
  "end": 7
 },
 {
  "chapter": "درس ۱",
  "position": 453,
  "title": "کتاب‌ها",
  "start": 8,
  "end": 11
 },
 {
  "chapter": "درس ۱",
  "position": 454,
  "title": "نشریات",
  "start": 12,
  "end": 12
 },
 {
  "chapter": "درس ۱",
  "position": 455,
  "title": "اسناد و منابع آرشیوی",
  "start": 13,
  "end": 14
 },
 {
  "chapter": "درس ۱",
  "position": 456,
  "title": "تاریخ شفاهی و بناها، اشیا و وسایل",
  "start": 15,
  "end": 15
 },
 {
  "chapter": "درس ۲",
  "position": 400,
  "title": "کل درس",
  "start": 16,
  "end": 31
 },
 {
  "chapter": "درس ۲",
  "position": 450,
  "title": "ایران از نادرشاه افشار تا آقامحمدخان قاجار",
  "start": 16,
  "end": 18
 },
 {
  "chapter": "درس ۲",
  "position": 451,
  "title": "حکومت افشاریه",
  "start": 16,
  "end": 18
 },
 {
  "chapter": "درس ۲",
  "position": 452,
  "title": "حکومت زندیه",
  "start": 19,
  "end": 20
 },
 {
  "chapter": "درس ۲",
  "position": 453,
  "title": "اوضاع سیاسی، اداری و اقتصادی ایران در عصر افشاریه و زندیه",
  "start": 21,
  "end": 23
 },
 {
  "chapter": "درس ۲",
  "position": 454,
  "title": "جهان در آستانه دوران معاصر",
  "start": 24,
  "end": 25
 },
 {
  "chapter": "درس ۲",
  "position": 455,
  "title": "اروپا و آمریکا؛ انقلاب و استعمار",
  "start": 26,
  "end": 31
 },
 {
  "chapter": "درس ۳",
  "position": 400,
  "title": "کل درس",
  "start": 32,
  "end": 46
 },
 {
  "chapter": "درس ۳",
  "position": 450,
  "title": "تحولات سیاسی قاجار",
  "start": 32,
  "end": 36
 },
 {
  "chapter": "درس ۳",
  "position": 451,
  "title": "نظام سیاسی و اداری",
  "start": 37,
  "end": 39
 },
 {
  "chapter": "درس ۳",
  "position": 452,
  "title": "ارتش و تشکیلات نظامی",
  "start": 40,
  "end": 40
 },
 {
  "chapter": "درس ۳",
  "position": 453,
  "title": "روابط خارجی",
  "start": 41,
  "end": 43
 },
 {
  "chapter": "درس ۳",
  "position": 454,
  "title": "روسیه",
  "start": 41,
  "end": 43
 },
 {
  "chapter": "درس ۳",
  "position": 455,
  "title": "انگلستان",
  "start": 44,
  "end": 44
 },
 {
  "chapter": "درس ۳",
  "position": 456,
  "title": "فرانسه",
  "start": 45,
  "end": 45
 },
 {
  "chapter": "درس ۳",
  "position": 457,
  "title": "عثمانی و سایر کشورها",
  "start": 46,
  "end": 46
 },
 {
  "chapter": "درس ۴",
  "position": 400,
  "title": "کل درس",
  "start": 47,
  "end": 60
 },
 {
  "chapter": "درس ۴",
  "position": 450,
  "title": "اوضاع اجتماعی",
  "start": 48,
  "end": 48
 },
 {
  "chapter": "درس ۴",
  "position": 451,
  "title": "اوضاع اقتصادی و نظام تولید",
  "start": 49,
  "end": 50
 },
 {
  "chapter": "درس ۴",
  "position": 452,
  "title": "کشاورزی",
  "start": 51,
  "end": 52
 },
 {
  "chapter": "درس ۴",
  "position": 453,
  "title": "اوضاع علمی و فرهنگی و مراکز آموزشی جدید",
  "start": 53,
  "end": 55
 },
 {
  "chapter": "درس ۴",
  "position": 454,
  "title": "هنر و معماری",
  "start": 56,
  "end": 60
 },
 {
  "chapter": "درس ۵",
  "position": 400,
  "title": "کل درس",
  "start": 61,
  "end": 77
 },
 {
  "chapter": "درس ۵",
  "position": 450,
  "title": "شرح: زمینه‌های نهضت مشروطه",
  "start": 61,
  "end": 64
 },
 {
  "chapter": "درس ۵",
  "position": 451,
  "title": "آغاز حرکت مردم علیه استبداد",
  "start": 65,
  "end": 66
 },
 {
  "chapter": "درس ۵",
  "position": 452,
  "title": "مهاجرت صغری و کبری",
  "start": 67,
  "end": 67
 },
 {
  "chapter": "درس ۵",
  "position": 453,
  "title": "پیروزی نهضت و تشکیل مجلس شورای ملی",
  "start": 68,
  "end": 68
 },
 {
  "chapter": "درس ۵",
  "position": 454,
  "title": "مشروطه در دوره محمدعلی شاه",
  "start": 69,
  "end": 71
 },
 {
  "chapter": "درس ۵",
  "position": 455,
  "title": "به توپ بستن مجلس و استبداد صغیر",
  "start": 72,
  "end": 73
 },
 {
  "chapter": "درس ۵",
  "position": 456,
  "title": "دوره دوم مشروطه",
  "start": 74,
  "end": 75
 },
 {
  "chapter": "درس ۵",
  "position": 457,
  "title": "چالش‌های دوره دوم مشروطه و مداخله بیگانگان",
  "start": 76,
  "end": 77
 },
 {
  "chapter": "درس ۶",
  "position": 400,
  "title": "کل درس",
  "start": 78,
  "end": 91
 },
 {
  "chapter": "درس ۶",
  "position": 450,
  "title": "زمینه‌های جنگ جهانی اول",
  "start": 78,
  "end": 81
 },
 {
  "chapter": "درس ۶",
  "position": 451,
  "title": "علل آغاز جنگ جهانی اول",
  "start": 82,
  "end": 83
 },
 {
  "chapter": "درس ۶",
  "position": 452,
  "title": "شروع جنگ",
  "start": 84,
  "end": 84
 },
 {
  "chapter": "درس ۶",
  "position": 453,
  "title": "انقلاب روسیه",
  "start": 85,
  "end": 85
 },
 {
  "chapter": "درس ۶",
  "position": 454,
  "title": "پایان جنگ و پیامدهای آن",
  "start": 86,
  "end": 86
 },
 {
  "chapter": "درس ۶",
  "position": 455,
  "title": "شرح: ایران در جنگ جهانی اول",
  "start": 87,
  "end": 87
 },
 {
  "chapter": "درس ۶",
  "position": 456,
  "title": "مقاومت ایرانیان در برابر اشغالگران",
  "start": 88,
  "end": 89
 },
 {
  "chapter": "درس ۶",
  "position": 457,
  "title": "قرارداد ۱۹۱۹",
  "start": 90,
  "end": 91
 },
 {
  "chapter": "درس ۷",
  "position": 400,
  "title": "کل درس",
  "start": 92,
  "end": 98
 },
 {
  "chapter": "درس ۷",
  "position": 450,
  "title": "انگلستان و تغییر سلطنت در ایران",
  "start": 92,
  "end": 93
 },
 {
  "chapter": "درس ۷",
  "position": 451,
  "title": "رضاخان از نخست‌وزیری تا پادشاهی",
  "start": 94,
  "end": 94
 },
 {
  "chapter": "درس ۷",
  "position": 452,
  "title": "ماهیت اصلاحات و اقدامات رضاشاه",
  "start": 95,
  "end": 96
 },
 {
  "chapter": "درس ۷",
  "position": 453,
  "title": "یک‌شکل کردن لباس و کشف حجاب",
  "start": 97,
  "end": 97
 },
 {
  "chapter": "درس ۷",
  "position": 454,
  "title": "از میان برداشتن مخالفان و شهادت مدرس",
  "start": 97,
  "end": 97
 },
 {
  "chapter": "درس ۷",
  "position": 455,
  "title": "سیاست گرایش به آلمان",
  "start": 98,
  "end": 98
 },
 {
  "chapter": "درس ۸",
  "position": 400,
  "title": "کل درس",
  "start": 99,
  "end": 116
 },
 {
  "chapter": "درس ۸",
  "position": 450,
  "title": "جهان در فاصله دو جنگ بزرگ",
  "start": 99,
  "end": 99
 },
 {
  "chapter": "درس ۸",
  "position": 451,
  "title": "بحران اقتصادی و ظهور حکومت‌های خودکامه",
  "start": 100,
  "end": 104
 },
 {
  "chapter": "درس ۸",
  "position": 452,
  "title": "شروع جنگ جهانی دوم",
  "start": 105,
  "end": 105
 },
 {
  "chapter": "درس ۸",
  "position": 453,
  "title": "پیروزی متفقین",
  "start": 106,
  "end": 106
 },
 {
  "chapter": "درس ۸",
  "position": 454,
  "title": "پایان جنگ",
  "start": 107,
  "end": 107
 },
 {
  "chapter": "درس ۸",
  "position": 455,
  "title": "آثار جنگ و ایران در جنگ",
  "start": 108,
  "end": 108
 },
 {
  "chapter": "درس ۸",
  "position": 456,
  "title": "جهان پس از جنگ و عصر جنگ سرد",
  "start": 109,
  "end": 109
 },
 {
  "chapter": "درس ۸",
  "position": 457,
  "title": "بازسازی اروپا و تحولات شرق آسیا",
  "start": 110,
  "end": 110
 },
 {
  "chapter": "درس ۸",
  "position": 458,
  "title": "استقلال‌طلبی و استعمارزدایی",
  "start": 111,
  "end": 116
 },
 {
  "chapter": "درس ۹",
  "position": 400,
  "title": "کل درس",
  "start": 117,
  "end": 127
 },
 {
  "chapter": "درس ۹",
  "position": 450,
  "title": "نفت و تاریخچه کشف و استخراج نفت ایران",
  "start": 117,
  "end": 117
 },
 {
  "chapter": "درس ۹",
  "position": 451,
  "title": "اوضاع سیاسی و اجتماعی ایران پس از شهریور ۱۳۲۰",
  "start": 118,
  "end": 118
 },
 {
  "chapter": "درس ۹",
  "position": 452,
  "title": "زمینه‌های نهضت ملی شدن نفت",
  "start": 119,
  "end": 120
 },
 {
  "chapter": "درس ۹",
  "position": 453,
  "title": "مبارزه برای ملی کردن نفت",
  "start": 121,
  "end": 121
 },
 {
  "chapter": "درس ۹",
  "position": 454,
  "title": "تصویب قانون ملی شدن صنعت نفت",
  "start": 122,
  "end": 122
 },
 {
  "chapter": "درس ۹",
  "position": 455,
  "title": "نخست‌وزیری مصدق و اجرای قانون ملی شدن",
  "start": 123,
  "end": 123
 },
 {
  "chapter": "درس ۹",
  "position": 456,
  "title": "قیام ۳۰ تیر",
  "start": 124,
  "end": 124
 },
 {
  "chapter": "درس ۹",
  "position": 457,
  "title": "شرح: کودتای ۲۸ مرداد",
  "start": 125,
  "end": 126
 },
 {
  "chapter": "درس ۹",
  "position": 458,
  "title": "ادامه مبارزه پس از کودتا",
  "start": 127,
  "end": 127
 },
 {
  "chapter": "درس ۱۰",
  "position": 400,
  "title": "کل درس",
  "start": 128,
  "end": 141
 },
 {
  "chapter": "درس ۱۰",
  "position": 450,
  "title": "زمینه‌های سلطه آمریکا بر ایران",
  "start": 128,
  "end": 128
 },
 {
  "chapter": "درس ۱۰",
  "position": 451,
  "title": "اصلاحات آمریکایی و آغاز مبارزه امام خمینی",
  "start": 129,
  "end": 129
 },
 {
  "chapter": "درس ۱۰",
  "position": 452,
  "title": "واقعه مدرسه فیضیه و قیام پانزده خرداد",
  "start": 130,
  "end": 132
 },
 {
  "chapter": "درس ۱۰",
  "position": 453,
  "title": "مخالفت با کاپیتولاسیون و تبعید امام خمینی",
  "start": 133,
  "end": 133
 },
 {
  "chapter": "درس ۱۰",
  "position": 454,
  "title": "تداوم مبارزه",
  "start": 134,
  "end": 134
 },
 {
  "chapter": "درس ۱۰",
  "position": 455,
  "title": "وضعیت عمومی ایران در سال ۱۳۵۶",
  "start": 135,
  "end": 137
 },
 {
  "chapter": "درس ۱۰",
  "position": 456,
  "title": "آغاز انقلاب اسلامی",
  "start": 138,
  "end": 138
 },
 {
  "chapter": "درس ۱۰",
  "position": 457,
  "title": "قیام خونین ۱۷ شهریور و هجرت امام خمینی",
  "start": 139,
  "end": 139
 },
 {
  "chapter": "درس ۱۰",
  "position": 458,
  "title": "حماسه ماه محرم",
  "start": 140,
  "end": 140
 },
 {
  "chapter": "درس ۱۰",
  "position": 459,
  "title": "ورود امام خمینی و پیروزی انقلاب",
  "start": 141,
  "end": 141
 },
 {
  "chapter": "درس ۱۱",
  "position": 400,
  "title": "کل درس",
  "start": 142,
  "end": 152
 },
 {
  "chapter": "درس ۱۱",
  "position": 450,
  "title": "شرح: استقرار نظام جمهوری اسلامی",
  "start": 142,
  "end": 142
 },
 {
  "chapter": "درس ۱۱",
  "position": 451,
  "title": "همه‌پرسی و تدوین قانون اساسی",
  "start": 142,
  "end": 142
 },
 {
  "chapter": "درس ۱۱",
  "position": 452,
  "title": "تشکیل دولت و تأسیس نهادهای انقلابی",
  "start": 143,
  "end": 144
 },
 {
  "chapter": "درس ۱۱",
  "position": 453,
  "title": "توطئه‌ها و تلاش‌های دشمنان",
  "start": 145,
  "end": 148
 },
 {
  "chapter": "درس ۱۱",
  "position": 454,
  "title": "تثبیت نظام جمهوری اسلامی",
  "start": 149,
  "end": 149
 },
 {
  "chapter": "درس ۱۱",
  "position": 455,
  "title": "ارتحال امام خمینی و انتخاب رهبر",
  "start": 150,
  "end": 152
 },
 {
  "chapter": "درس ۱۲",
  "position": 400,
  "title": "کل درس",
  "start": 153,
  "end": 163
 },
 {
  "chapter": "درس ۱۲",
  "position": 450,
  "title": "شروع جنگ تحمیلی",
  "start": 153,
  "end": 153
 },
 {
  "chapter": "درس ۱۲",
  "position": 451,
  "title": "انگیزه و اهداف صدام",
  "start": 154,
  "end": 154
 },
 {
  "chapter": "درس ۱۲",
  "position": 452,
  "title": "دفاع مقدس ملت ایران",
  "start": 155,
  "end": 156
 },
 {
  "chapter": "درس ۱۲",
  "position": 453,
  "title": "شرح: آزادسازی مناطق اشغالی",
  "start": 157,
  "end": 158
 },
 {
  "chapter": "درس ۱۲",
  "position": 454,
  "title": "رهبری امام خمینی در دفاع مقدس",
  "start": 159,
  "end": 160
 },
 {
  "chapter": "درس ۱۲",
  "position": 455,
  "title": "نقش مردم در دفاع مقدس",
  "start": 161,
  "end": 161
 },
 {
  "chapter": "درس ۱۲",
  "position": 456,
  "title": "پایان جنگ تحمیلی",
  "start": 162,
  "end": 162
 },
 {
  "chapter": "درس ۱۲",
  "position": 457,
  "title": "دستاوردهای دفاع مقدس",
  "start": 163,
  "end": 163
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)),tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v205:humanities:12:'||r.track||':تاریخ ۳:'||p.chapter||':'||p.position)::uuid,'1405','humanities','12',r.track,'تاریخ ۳',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "درس ۱",
  "position": 1,
  "title": "تاریخ‌نگاری سنتی",
  "start": 2,
  "end": 15
 },
 {
  "chapter": "درس ۱",
  "position": 2,
  "title": "تاریخ‌نگاری جدید",
  "start": 2,
  "end": 15
 },
 {
  "chapter": "درس ۱",
  "position": 3,
  "title": "منابع مکتوب: تاریخ‌ها، خاطرات و سفرنامه‌ها",
  "start": 2,
  "end": 15
 },
 {
  "chapter": "درس ۱",
  "position": 4,
  "title": "اسناد و منابع غیرمکتوب",
  "start": 2,
  "end": 15
 },
 {
  "chapter": "درس ۲",
  "position": 1,
  "title": "ایران پس از صفویه: افشاریه و زندیه",
  "start": 16,
  "end": 31
 },
 {
  "chapter": "درس ۲",
  "position": 2,
  "title": "حکومت، جامعه و اقتصاد در افشاریه و زندیه",
  "start": 16,
  "end": 31
 },
 {
  "chapter": "درس ۲",
  "position": 3,
  "title": "اروپا و گسترش استعمار",
  "start": 16,
  "end": 31
 },
 {
  "chapter": "درس ۲",
  "position": 4,
  "title": "انقلاب صنعتی و پیامدهای آن",
  "start": 16,
  "end": 31
 },
 {
  "chapter": "درس ۳",
  "position": 1,
  "title": "نظام سیاسی و جایگاه شاه",
  "start": 32,
  "end": 46
 },
 {
  "chapter": "درس ۳",
  "position": 2,
  "title": "تشکیلات اداری و نظامی قاجار",
  "start": 32,
  "end": 46
 },
 {
  "chapter": "درس ۳",
  "position": 3,
  "title": "روابط خارجی و جنگ‌های ایران و روسیه",
  "start": 32,
  "end": 46
 },
 {
  "chapter": "درس ۳",
  "position": 4,
  "title": "اصلاحات و روابط خارجی در دوره ناصرالدین شاه",
  "start": 32,
  "end": 46
 },
 {
  "chapter": "درس ۴",
  "position": 1,
  "title": "اوضاع اجتماعی و شیوه‌های زندگی",
  "start": 47,
  "end": 60
 },
 {
  "chapter": "درس ۴",
  "position": 2,
  "title": "کشاورزی، صنعت و تجارت",
  "start": 47,
  "end": 60
 },
 {
  "chapter": "درس ۴",
  "position": 3,
  "title": "فرهنگ، ادبیات و هنر",
  "start": 47,
  "end": 60
 },
 {
  "chapter": "درس ۴",
  "position": 4,
  "title": "آموزش سنتی و مراکز آموزشی جدید",
  "start": 47,
  "end": 60
 },
 {
  "chapter": "درس ۵",
  "position": 1,
  "title": "زمینه‌های نهضت مشروطه",
  "start": 61,
  "end": 77
 },
 {
  "chapter": "درس ۵",
  "position": 2,
  "title": "مهاجرت صغری و کبری و پیروزی مشروطه",
  "start": 61,
  "end": 77
 },
 {
  "chapter": "درس ۵",
  "position": 3,
  "title": "مجلس و قانون اساسی",
  "start": 61,
  "end": 77
 },
 {
  "chapter": "درس ۵",
  "position": 4,
  "title": "محمدعلی شاه، استبداد صغیر و مقاومت",
  "start": 61,
  "end": 77
 },
 {
  "chapter": "درس ۵",
  "position": 5,
  "title": "دوره دوم مشروطه و چالش‌ها",
  "start": 61,
  "end": 77
 },
 {
  "chapter": "درس ۶",
  "position": 1,
  "title": "زمینه‌ها و آغاز جنگ جهانی اول",
  "start": 78,
  "end": 91
 },
 {
  "chapter": "درس ۶",
  "position": 2,
  "title": "جبهه‌های جنگ و پیامدهای آن",
  "start": 78,
  "end": 91
 },
 {
  "chapter": "درس ۶",
  "position": 3,
  "title": "ایران در جنگ جهانی اول",
  "start": 78,
  "end": 91
 },
 {
  "chapter": "درس ۶",
  "position": 4,
  "title": "قرارداد ۱۹۱۹ و واکنش‌ها",
  "start": 78,
  "end": 91
 },
 {
  "chapter": "درس ۷",
  "position": 1,
  "title": "کودتای ۱۲۹۹ و قدرت‌گیری رضاشاه",
  "start": 92,
  "end": 98
 },
 {
  "chapter": "درس ۷",
  "position": 2,
  "title": "حکومت و اقدامات رضاشاه",
  "start": 92,
  "end": 98
 },
 {
  "chapter": "درس ۷",
  "position": 3,
  "title": "سیاست فرهنگی و محدودیت روحانیت",
  "start": 92,
  "end": 98
 },
 {
  "chapter": "درس ۸",
  "position": 1,
  "title": "جهان در فاصله دو جنگ و زمینه‌های جنگ جهانی دوم",
  "start": 99,
  "end": 116
 },
 {
  "chapter": "درس ۸",
  "position": 2,
  "title": "آغاز و روند جنگ جهانی دوم",
  "start": 99,
  "end": 116
 },
 {
  "chapter": "درس ۸",
  "position": 3,
  "title": "ایران در جنگ جهانی دوم",
  "start": 99,
  "end": 116
 },
 {
  "chapter": "درس ۸",
  "position": 4,
  "title": "پیامدهای جنگ و تحولات جهان پس از آن",
  "start": 99,
  "end": 116
 },
 {
  "chapter": "درس ۹",
  "position": 1,
  "title": "نفت و زمینه‌های نهضت ملی شدن",
  "start": 117,
  "end": 127
 },
 {
  "chapter": "درس ۹",
  "position": 2,
  "title": "مبارزه برای ملی شدن صنعت نفت",
  "start": 117,
  "end": 127
 },
 {
  "chapter": "درس ۹",
  "position": 3,
  "title": "دولت مصدق و چالش‌های ملی شدن نفت",
  "start": 117,
  "end": 127
 },
 {
  "chapter": "درس ۹",
  "position": 4,
  "title": "کودتای ۲۸ مرداد",
  "start": 117,
  "end": 127
 },
 {
  "chapter": "درس ۱۰",
  "position": 1,
  "title": "اوضاع ایران پس از کودتای ۲۸ مرداد",
  "start": 128,
  "end": 141
 },
 {
  "chapter": "درس ۱۰",
  "position": 2,
  "title": "آغاز نهضت اسلامی و قیام ۱۵ خرداد",
  "start": 128,
  "end": 141
 },
 {
  "chapter": "درس ۱۰",
  "position": 3,
  "title": "مبارزه سیاسی، فرهنگی و مسلحانه",
  "start": 128,
  "end": 141
 },
 {
  "chapter": "درس ۱۰",
  "position": 4,
  "title": "رویدادهای ۱۳۵۶ و ۱۳۵۷ و پیروزی انقلاب",
  "start": 128,
  "end": 141
 },
 {
  "chapter": "درس ۱۱",
  "position": 1,
  "title": "استقرار نظام جمهوری اسلامی",
  "start": 142,
  "end": 152
 },
 {
  "chapter": "درس ۱۱",
  "position": 2,
  "title": "نهادهای انقلاب و قانون اساسی",
  "start": 142,
  "end": 152
 },
 {
  "chapter": "درس ۱۱",
  "position": 3,
  "title": "چالش‌ها و توطئه‌های داخلی و خارجی",
  "start": 142,
  "end": 152
 },
 {
  "chapter": "درس ۱۲",
  "position": 1,
  "title": "آغاز جنگ تحمیلی و دفاع مردم",
  "start": 153,
  "end": 163
 },
 {
  "chapter": "درس ۱۲",
  "position": 2,
  "title": "آزادسازی مناطق اشغالی",
  "start": 153,
  "end": 163
 },
 {
  "chapter": "درس ۱۲",
  "position": 3,
  "title": "رهبری و نقش مردم در دفاع مقدس",
  "start": 153,
  "end": 163
 },
 {
  "chapter": "درس ۱۲",
  "position": 4,
  "title": "پایان جنگ و دستاوردهای دفاع مقدس",
  "start": 153,
  "end": 163
 }
]$fixes$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)),tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:12:'||r.track||':تاریخ ۳:'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field='humanities' and t.grade='12' and t.preparation_track=r.track and t.subject='تاریخ ۳' and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
