-- Economics 110221 printed 1405, user PDF; see docs/planner-topic-sources.md.
-- Installation is one-time; legacy rows update only if untouched.
with installed as (insert into private.planner_seed_installations(seed_key) values ('economics-1405-v197') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 300,
  "title": "کل درس",
  "start": 2,
  "end": 11
 },
 {
  "chapter": "درس ۱",
  "position": 301,
  "title": "فراز و فرود کسب‌وکارها",
  "start": 4,
  "end": 4
 },
 {
  "chapter": "درس ۱",
  "position": 302,
  "title": "نقش کارآفرینان",
  "start": 5,
  "end": 7
 },
 {
  "chapter": "درس ۱",
  "position": 303,
  "title": "هزینه‌های تولید، درآمد و سود",
  "start": 8,
  "end": 8
 },
 {
  "chapter": "درس ۱",
  "position": 304,
  "title": "مسئولیت اخلاقی و کسب درآمد حلال",
  "start": 9,
  "end": 9
 },
 {
  "chapter": "درس ۱",
  "position": 305,
  "title": "برای تفکر و تمرین",
  "start": 10,
  "end": 11
 },
 {
  "chapter": "درس ۲",
  "position": 300,
  "title": "کل درس",
  "start": 12,
  "end": 21
 },
 {
  "chapter": "درس ۲",
  "position": 301,
  "title": "کدام کسب‌وکار؟ کسب‌وکار شخصی",
  "start": 14,
  "end": 14
 },
 {
  "chapter": "درس ۲",
  "position": 302,
  "title": "شرکت",
  "start": 15,
  "end": 16
 },
 {
  "chapter": "درس ۲",
  "position": 303,
  "title": "ایجاد یک شرکت",
  "start": 17,
  "end": 18
 },
 {
  "chapter": "درس ۲",
  "position": 304,
  "title": "تعاونی‌ها و مؤسسات غیرانتفاعی",
  "start": 19,
  "end": 20
 },
 {
  "chapter": "درس ۲",
  "position": 305,
  "title": "برای تفکر و تمرین",
  "start": 21,
  "end": 21
 },
 {
  "chapter": "درس ۳",
  "position": 300,
  "title": "کل درس",
  "start": 22,
  "end": 33
 },
 {
  "chapter": "درس ۳",
  "position": 301,
  "title": "اقتصاد و مسئله انتخاب: شناسایی منابع کمیاب",
  "start": 24,
  "end": 24
 },
 {
  "chapter": "درس ۳",
  "position": 302,
  "title": "هزینه فرصت هر انتخاب",
  "start": 25,
  "end": 26
 },
 {
  "chapter": "درس ۳",
  "position": 303,
  "title": "قید بودجه",
  "start": 27,
  "end": 27
 },
 {
  "chapter": "درس ۳",
  "position": 304,
  "title": "هزینه‌های هدررفته",
  "start": 28,
  "end": 28
 },
 {
  "chapter": "درس ۳",
  "position": 305,
  "title": "مقایسه هزینه‌ها و منافع",
  "start": 29,
  "end": 29
 },
 {
  "chapter": "درس ۳",
  "position": 306,
  "title": "تصمیمات غیرمنطقی",
  "start": 30,
  "end": 31
 },
 {
  "chapter": "درس ۳",
  "position": 307,
  "title": "برای تفکر و تمرین",
  "start": 32,
  "end": 33
 },
 {
  "chapter": "درس ۴",
  "position": 300,
  "title": "کل درس",
  "start": 34,
  "end": 42
 },
 {
  "chapter": "درس ۴",
  "position": 301,
  "title": "الگوهای اقتصادی",
  "start": 35,
  "end": 35
 },
 {
  "chapter": "درس ۴",
  "position": 302,
  "title": "الگوی مرز امکانات تولید",
  "start": 36,
  "end": 36
 },
 {
  "chapter": "درس ۴",
  "position": 303,
  "title": "هزینه فرصت اجتماع",
  "start": 37,
  "end": 37
 },
 {
  "chapter": "درس ۴",
  "position": 304,
  "title": "کارایی و ناکارایی",
  "start": 38,
  "end": 39
 },
 {
  "chapter": "درس ۴",
  "position": 305,
  "title": "برای تفکر و تمرین",
  "start": 40,
  "end": 42
 },
 {
  "chapter": "درس ۵",
  "position": 300,
  "title": "کل درس",
  "start": 44,
  "end": 54
 },
 {
  "chapter": "درس ۵",
  "position": 301,
  "title": "بنگاه و خانوار در اقتصاد و جریان چرخشی ساده",
  "start": 46,
  "end": 47
 },
 {
  "chapter": "درس ۵",
  "position": 302,
  "title": "بازار کالا و خدمات و تقاضاکنندگان",
  "start": 48,
  "end": 48
 },
 {
  "chapter": "درس ۵",
  "position": 303,
  "title": "کالای معمولی و پست، کالای جانشین و مکمل",
  "start": 49,
  "end": 49
 },
 {
  "chapter": "درس ۵",
  "position": 304,
  "title": "عرضه‌کنندگان و تصمیم‌گیری آنها",
  "start": 50,
  "end": 50
 },
 {
  "chapter": "درس ۵",
  "position": 305,
  "title": "تعادل و انواع بازار",
  "start": 51,
  "end": 53
 },
 {
  "chapter": "درس ۵",
  "position": 306,
  "title": "برای تفکر و تمرین",
  "start": 54,
  "end": 54
 },
 {
  "chapter": "درس ۶",
  "position": 300,
  "title": "کل درس",
  "start": 55,
  "end": 68
 },
 {
  "chapter": "درس ۶",
  "position": 301,
  "title": "وظایف دولت و بهبود عملکرد بازار",
  "start": 56,
  "end": 57
 },
 {
  "chapter": "درس ۶",
  "position": 302,
  "title": "ارائه کالای عمومی",
  "start": 58,
  "end": 58
 },
 {
  "chapter": "درس ۶",
  "position": 303,
  "title": "جایگاه دولت در جریان چرخشی و تأمین مالی دولت",
  "start": 59,
  "end": 59
 },
 {
  "chapter": "درس ۶",
  "position": 304,
  "title": "مالیات و اهداف آن",
  "start": 60,
  "end": 60
 },
 {
  "chapter": "درس ۶",
  "position": 305,
  "title": "مالیات مستقیم",
  "start": 61,
  "end": 61
 },
 {
  "chapter": "درس ۶",
  "position": 306,
  "title": "مالیات غیرمستقیم و عوارض گمرکی",
  "start": 62,
  "end": 62
 },
 {
  "chapter": "درس ۶",
  "position": 307,
  "title": "مالیات بر مصرف و ارزش افزوده",
  "start": 63,
  "end": 63
 },
 {
  "chapter": "درس ۶",
  "position": 308,
  "title": "سایر درآمدهای دولت",
  "start": 64,
  "end": 64
 },
 {
  "chapter": "درس ۶",
  "position": 309,
  "title": "بودجه دولت",
  "start": 65,
  "end": 66
 },
 {
  "chapter": "درس ۶",
  "position": 310,
  "title": "برای تفکر و تمرین",
  "start": 67,
  "end": 68
 },
 {
  "chapter": "درس ۷",
  "position": 300,
  "title": "کل درس",
  "start": 69,
  "end": 80
 },
 {
  "chapter": "درس ۷",
  "position": 301,
  "title": "کالاها و شرکت‌های چندملیتی و اهمیت تجارت",
  "start": 71,
  "end": 71
 },
 {
  "chapter": "درس ۷",
  "position": 302,
  "title": "مزیت مطلق و نسبی در تجارت",
  "start": 72,
  "end": 72
 },
 {
  "chapter": "درس ۷",
  "position": 303,
  "title": "مزیت نسبی و هزینه فرصت",
  "start": 73,
  "end": 73
 },
 {
  "chapter": "درس ۷",
  "position": 304,
  "title": "دولت‌ها و تجارت بین‌الملل",
  "start": 74,
  "end": 75
 },
 {
  "chapter": "درس ۷",
  "position": 305,
  "title": "جنگ‌های تجاری و تحریم‌های اقتصادی",
  "start": 76,
  "end": 79
 },
 {
  "chapter": "درس ۷",
  "position": 306,
  "title": "برای تفکر و تمرین",
  "start": 80,
  "end": 80
 },
 {
  "chapter": "درس ۸",
  "position": 300,
  "title": "کل درس",
  "start": 82,
  "end": 91
 },
 {
  "chapter": "درس ۸",
  "position": 301,
  "title": "منابع غیرفعال و مرز امکانات تولید",
  "start": 84,
  "end": 84
 },
 {
  "chapter": "درس ۸",
  "position": 302,
  "title": "بیکاری و اشتغال",
  "start": 85,
  "end": 85
 },
 {
  "chapter": "درس ۸",
  "position": 303,
  "title": "نرخ بیکاری و بازار نیروی کار",
  "start": 86,
  "end": 86
 },
 {
  "chapter": "درس ۸",
  "position": 304,
  "title": "انواع بیکاری",
  "start": 87,
  "end": 88
 },
 {
  "chapter": "درس ۸",
  "position": 305,
  "title": "پیامدهای بیکاری، رکود و فقر",
  "start": 88,
  "end": 89
 },
 {
  "chapter": "درس ۸",
  "position": 306,
  "title": "دولت و مسئله بیکاری و فقر",
  "start": 90,
  "end": 90
 },
 {
  "chapter": "درس ۸",
  "position": 307,
  "title": "برای تفکر و تمرین",
  "start": 91,
  "end": 91
 },
 {
  "chapter": "درس ۹",
  "position": 300,
  "title": "کل درس",
  "start": 92,
  "end": 104
 },
 {
  "chapter": "درس ۹",
  "position": 301,
  "title": "پول، ثروت و قدرت خرید",
  "start": 93,
  "end": 93
 },
 {
  "chapter": "درس ۹",
  "position": 302,
  "title": "پول چیست؟",
  "start": 94,
  "end": 97
 },
 {
  "chapter": "درس ۹",
  "position": 303,
  "title": "وظایف پول و نقدینگی",
  "start": 98,
  "end": 99
 },
 {
  "chapter": "درس ۹",
  "position": 304,
  "title": "تورم",
  "start": 100,
  "end": 100
 },
 {
  "chapter": "درس ۹",
  "position": 305,
  "title": "محاسبه نرخ تورم",
  "start": 101,
  "end": 101
 },
 {
  "chapter": "درس ۹",
  "position": 306,
  "title": "علل و پیامدهای تورم و نقش دولت",
  "start": 102,
  "end": 103
 },
 {
  "chapter": "درس ۹",
  "position": 307,
  "title": "برای تفکر و تمرین",
  "start": 104,
  "end": 104
 },
 {
  "chapter": "درس ۱۰",
  "position": 300,
  "title": "کل درس",
  "start": 105,
  "end": 115
 },
 {
  "chapter": "درس ۱۰",
  "position": 301,
  "title": "اقتصاد و جهان پیچیده و مسیر تاریخی اقتصاد ایران",
  "start": 107,
  "end": 110
 },
 {
  "chapter": "درس ۱۰",
  "position": 302,
  "title": "اقتصاد مقاومتی و استقلال اقتصادی",
  "start": 111,
  "end": 114
 },
 {
  "chapter": "درس ۱۰",
  "position": 303,
  "title": "تحلیل کنید",
  "start": 115,
  "end": 115
 },
 {
  "chapter": "درس ۱۱",
  "position": 300,
  "title": "کل درس",
  "start": 116,
  "end": 128
 },
 {
  "chapter": "درس ۱۱",
  "position": 301,
  "title": "تکاپو برای پیشرفت و رشد اقتصادی",
  "start": 118,
  "end": 118
 },
 {
  "chapter": "درس ۱۱",
  "position": 302,
  "title": "رشد با الگوی مرز امکانات تولید",
  "start": 119,
  "end": 119
 },
 {
  "chapter": "درس ۱۱",
  "position": 303,
  "title": "تولید ناخالص داخلی و اندازه‌گیری رشد",
  "start": 120,
  "end": 121
 },
 {
  "chapter": "درس ۱۱",
  "position": 304,
  "title": "محاسبه تولید ناخالص داخلی و نرخ رشد",
  "start": 122,
  "end": 123
 },
 {
  "chapter": "درس ۱۱",
  "position": 305,
  "title": "شاخص دهک",
  "start": 124,
  "end": 124
 },
 {
  "chapter": "درس ۱۱",
  "position": 306,
  "title": "وضعیت توزیع درآمد",
  "start": 125,
  "end": 125
 },
 {
  "chapter": "درس ۱۱",
  "position": 307,
  "title": "شاخص توسعه انسانی",
  "start": 126,
  "end": 126
 },
 {
  "chapter": "درس ۱۱",
  "position": 308,
  "title": "الگوی پیشرفت اسلامی ـ ایرانی",
  "start": 127,
  "end": 127
 },
 {
  "chapter": "درس ۱۱",
  "position": 309,
  "title": "برای تفکر و تمرین",
  "start": 128,
  "end": 128
 },
 {
  "chapter": "درس ۱۲",
  "position": 300,
  "title": "کل درس",
  "start": 130,
  "end": 139
 },
 {
  "chapter": "درس ۱۲",
  "position": 301,
  "title": "پول‌هایی که بلعیده می‌شوند",
  "start": 132,
  "end": 132
 },
 {
  "chapter": "درس ۱۲",
  "position": 302,
  "title": "ثبت هزینه‌ها و درآمدها",
  "start": 133,
  "end": 136
 },
 {
  "chapter": "درس ۱۲",
  "position": 303,
  "title": "مراحل بودجه‌ریزی ماهیانه",
  "start": 137,
  "end": 137
 },
 {
  "chapter": "درس ۱۲",
  "position": 304,
  "title": "تعیین سال خمسی در برنامه مخارج",
  "start": 138,
  "end": 138
 },
 {
  "chapter": "درس ۱۲",
  "position": 305,
  "title": "تحلیل کنید",
  "start": 139,
  "end": 139
 },
 {
  "chapter": "درس ۱۳",
  "position": 300,
  "title": "کل درس",
  "start": 140,
  "end": 149
 },
 {
  "chapter": "درس ۱۳",
  "position": 301,
  "title": "مهارت خرید",
  "start": 142,
  "end": 142
 },
 {
  "chapter": "درس ۱۳",
  "position": 302,
  "title": "خرید هوشمندانه",
  "start": 143,
  "end": 143
 },
 {
  "chapter": "درس ۱۳",
  "position": 303,
  "title": "خرید مقایسه‌ای",
  "start": 144,
  "end": 145
 },
 {
  "chapter": "درس ۱۳",
  "position": 304,
  "title": "روش‌های فروش و الگوی خرج کردن",
  "start": 146,
  "end": 147
 },
 {
  "chapter": "درس ۱۳",
  "position": 305,
  "title": "مصرف مسئولانه",
  "start": 148,
  "end": 148
 },
 {
  "chapter": "درس ۱۳",
  "position": 306,
  "title": "تحلیل کنید",
  "start": 149,
  "end": 149
 },
 {
  "chapter": "درس ۱۴",
  "position": 300,
  "title": "کل درس",
  "start": 150,
  "end": 160
 },
 {
  "chapter": "درس ۱۴",
  "position": 301,
  "title": "به فکر آینده باشیم",
  "start": 151,
  "end": 151
 },
 {
  "chapter": "درس ۱۴",
  "position": 302,
  "title": "تعیین هدف و برنامه پس‌انداز",
  "start": 152,
  "end": 153
 },
 {
  "chapter": "درس ۱۴",
  "position": 303,
  "title": "روش‌های پس‌انداز و سرمایه‌گذاری در بانک",
  "start": 154,
  "end": 154
 },
 {
  "chapter": "درس ۱۴",
  "position": 304,
  "title": "خرید سهام",
  "start": 155,
  "end": 156
 },
 {
  "chapter": "درس ۱۴",
  "position": 305,
  "title": "اوراق مشارکت",
  "start": 157,
  "end": 157
 },
 {
  "chapter": "درس ۱۴",
  "position": 306,
  "title": "خرید طلا",
  "start": 158,
  "end": 158
 },
 {
  "chapter": "درس ۱۴",
  "position": 307,
  "title": "بیمه و پوشش خطرپذیری سرمایه‌گذاری",
  "start": 159,
  "end": 159
 },
 {
  "chapter": "درس ۱۴",
  "position": 308,
  "title": "تحلیل کنید",
  "start": 160,
  "end": 160
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v197:humanities:10:'||t.track||':اقتصاد:'||p.chapter||':'||p.position)::uuid,'1405','humanities','10',t.track,'اقتصاد',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks t cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "درس ۱",
  "position": 1,
  "title": "فراز و فرود کسب‌وکارها",
  "start": 4,
  "end": 4
 },
 {
  "chapter": "درس ۱",
  "position": 2,
  "title": "نقش و ویژگی‌های کارآفرینان",
  "start": 5,
  "end": 7
 },
 {
  "chapter": "درس ۱",
  "position": 3,
  "title": "هزینه‌های تولید، درآمد، سود و زیان",
  "start": 8,
  "end": 8
 },
 {
  "chapter": "درس ۱",
  "position": 4,
  "title": "مسئولیت اخلاقی در کسب‌وکار",
  "start": 9,
  "end": 9
 },
 {
  "chapter": "درس ۲",
  "position": 1,
  "title": "سازمان تولید و مالکیت کسب‌وکار",
  "start": 14,
  "end": 19
 },
 {
  "chapter": "درس ۲",
  "position": 2,
  "title": "کسب‌وکار شخصی و مزایا و معایب آن",
  "start": 14,
  "end": 15
 },
 {
  "chapter": "درس ۲",
  "position": 3,
  "title": "شرکت سهامی و سهامداران",
  "start": 15,
  "end": 18
 },
 {
  "chapter": "درس ۲",
  "position": 4,
  "title": "تعاونی‌ها",
  "start": 19,
  "end": 19
 },
 {
  "chapter": "درس ۳",
  "position": 1,
  "title": "هزینه فرصت و بده‌بستان",
  "start": 25,
  "end": 26
 },
 {
  "chapter": "درس ۳",
  "position": 2,
  "title": "شناسایی منابع کمیاب",
  "start": 24,
  "end": 24
 },
 {
  "chapter": "درس ۳",
  "position": 3,
  "title": "قید بودجه",
  "start": 27,
  "end": 27
 },
 {
  "chapter": "درس ۳",
  "position": 4,
  "title": "هزینه‌های دررفته",
  "start": 28,
  "end": 28
 },
 {
  "chapter": "درس ۳",
  "position": 5,
  "title": "مقایسه هزینه‌ها و منافع",
  "start": 29,
  "end": 29
 },
 {
  "chapter": "درس ۴",
  "position": 1,
  "title": "الگوی مرز امکانات تولید",
  "start": 36,
  "end": 37
 },
 {
  "chapter": "درس ۴",
  "position": 2,
  "title": "نقاط کارا، ناکارا و دست‌نیافتنی",
  "start": 37,
  "end": 39
 },
 {
  "chapter": "درس ۴",
  "position": 3,
  "title": "هزینه فرصت اجتماع",
  "start": 37,
  "end": 38
 },
 {
  "chapter": "درس ۴",
  "position": 4,
  "title": "انتقال مرز امکانات تولید",
  "start": 41,
  "end": 41
 },
 {
  "chapter": "درس ۵",
  "position": 1,
  "title": "جریان چرخشی خانوار و بنگاه",
  "start": 46,
  "end": 47
 },
 {
  "chapter": "درس ۵",
  "position": 2,
  "title": "بازار کالا و خدمات و تقاضا",
  "start": 48,
  "end": 49
 },
 {
  "chapter": "درس ۵",
  "position": 3,
  "title": "عرضه و عوامل مؤثر بر آن",
  "start": 50,
  "end": 50
 },
 {
  "chapter": "درس ۵",
  "position": 4,
  "title": "تعادل بازار، کمبود و مازاد",
  "start": 51,
  "end": 51
 },
 {
  "chapter": "درس ۵",
  "position": 5,
  "title": "بازار رقابتی و انواع بازار",
  "start": 51,
  "end": 53
 },
 {
  "chapter": "درس ۶",
  "position": 1,
  "title": "نقش دولت و خدمات عمومی",
  "start": 56,
  "end": 59
 },
 {
  "chapter": "درس ۶",
  "position": 2,
  "title": "مالیات مستقیم و غیرمستقیم",
  "start": 61,
  "end": 63
 },
 {
  "chapter": "درس ۶",
  "position": 3,
  "title": "مالیات بر ارزش افزوده و عوارض گمرکی",
  "start": 62,
  "end": 63
 },
 {
  "chapter": "درس ۶",
  "position": 4,
  "title": "سایر درآمدهای دولت",
  "start": 64,
  "end": 64
 },
 {
  "chapter": "درس ۶",
  "position": 5,
  "title": "جایگاه دولت در جریان چرخشی درآمد",
  "start": 59,
  "end": 59
 },
 {
  "chapter": "درس ۷",
  "position": 1,
  "title": "دلایل تجارت بین کشورها و صادرات و واردات",
  "start": 71,
  "end": 71
 },
 {
  "chapter": "درس ۷",
  "position": 2,
  "title": "مزیت مطلق و نسبی و هزینه فرصت",
  "start": 72,
  "end": 73
 },
 {
  "chapter": "درس ۷",
  "position": 3,
  "title": "سیاست تجاری دولت‌ها و تعرفه‌ها",
  "start": 74,
  "end": 75
 },
 {
  "chapter": "درس ۷",
  "position": 4,
  "title": "جنگ تجاری، تحریم و استقلال اقتصادی",
  "start": 76,
  "end": 79
 },
 {
  "chapter": "درس ۸",
  "position": 1,
  "title": "رکود و منابع بیکار",
  "start": 84,
  "end": 85
 },
 {
  "chapter": "درس ۸",
  "position": 2,
  "title": "جمعیت فعال و نرخ بیکاری",
  "start": 85,
  "end": 86
 },
 {
  "chapter": "درس ۸",
  "position": 3,
  "title": "انواع بیکاری",
  "start": 87,
  "end": 88
 },
 {
  "chapter": "درس ۸",
  "position": 4,
  "title": "پیامدهای رکود و بیکاری و فقر",
  "start": 88,
  "end": 90
 },
 {
  "chapter": "درس ۸",
  "position": 5,
  "title": "فقر مطلق و نسبی و سیاست‌های فقرزدایی",
  "start": 88,
  "end": 91
 },
 {
  "chapter": "درس ۹",
  "position": 1,
  "title": "پول و تاریخچه مبادله",
  "start": 93,
  "end": 97
 },
 {
  "chapter": "درس ۹",
  "position": 2,
  "title": "وظایف پول و نقدینگی",
  "start": 98,
  "end": 99
 },
 {
  "chapter": "درس ۹",
  "position": 3,
  "title": "تورم و قدرت خرید",
  "start": 100,
  "end": 101
 },
 {
  "chapter": "درس ۹",
  "position": 4,
  "title": "شاخص قیمت مصرف‌کننده و محاسبه نرخ تورم",
  "start": 101,
  "end": 101
 },
 {
  "chapter": "درس ۹",
  "position": 5,
  "title": "پیامدها و علل تورم و نقش دولت",
  "start": 102,
  "end": 103
 },
 {
  "chapter": "درس ۱۰",
  "position": 1,
  "title": "مسیر تاریخی اقتصاد ایران",
  "start": 107,
  "end": 110
 },
 {
  "chapter": "درس ۱۰",
  "position": 2,
  "title": "مقاوم‌سازی اقتصاد و تاب‌آوری",
  "start": 111,
  "end": 115
 },
 {
  "chapter": "درس ۱۰",
  "position": 3,
  "title": "اقتصاد مقاومتی و استقلال اقتصادی",
  "start": 111,
  "end": 115
 },
 {
  "chapter": "درس ۱۱",
  "position": 1,
  "title": "رشد اقتصادی و مرز امکانات تولید",
  "start": 118,
  "end": 119
 },
 {
  "chapter": "درس ۱۱",
  "position": 2,
  "title": "تولید ناخالص داخلی و درآمد سرانه",
  "start": 120,
  "end": 123
 },
 {
  "chapter": "درس ۱۱",
  "position": 3,
  "title": "توزیع درآمد و شاخص دهک‌ها",
  "start": 124,
  "end": 125
 },
 {
  "chapter": "درس ۱۱",
  "position": 4,
  "title": "شاخص توسعه انسانی",
  "start": 126,
  "end": 126
 },
 {
  "chapter": "درس ۱۱",
  "position": 5,
  "title": "الگوی پیشرفت اسلامی ایرانی",
  "start": 127,
  "end": 127
 },
 {
  "chapter": "درس ۱۲",
  "position": 1,
  "title": "درآمد و مخارج خانوار",
  "start": 132,
  "end": 136
 },
 {
  "chapter": "درس ۱۲",
  "position": 2,
  "title": "مراحل بودجه‌ریزی ماهانه",
  "start": 137,
  "end": 137
 },
 {
  "chapter": "درس ۱۲",
  "position": 3,
  "title": "هزینه‌های ثابت و متغیر",
  "start": 133,
  "end": 136
 },
 {
  "chapter": "درس ۱۲",
  "position": 4,
  "title": "خمس و سال مالی در برنامه مخارج",
  "start": 138,
  "end": 138
 },
 {
  "chapter": "درس ۱۳",
  "position": 1,
  "title": "خرید هوشمندانه",
  "start": 143,
  "end": 143
 },
 {
  "chapter": "درس ۱۳",
  "position": 2,
  "title": "خرید مقایسه‌ای و معیارهای انتخاب",
  "start": 144,
  "end": 146
 },
 {
  "chapter": "درس ۱۳",
  "position": 3,
  "title": "الگوی خرج کردن و مصرف‌گرایی",
  "start": 146,
  "end": 148
 },
 {
  "chapter": "درس ۱۴",
  "position": 1,
  "title": "پس‌انداز و سرمایه‌گذاری",
  "start": 152,
  "end": 155
 },
 {
  "chapter": "درس ۱۴",
  "position": 2,
  "title": "سهام و اوراق مشارکت",
  "start": 155,
  "end": 158
 },
 {
  "chapter": "درس ۱۴",
  "position": 3,
  "title": "خرید طلا",
  "start": 158,
  "end": 158
 },
 {
  "chapter": "درس ۱۴",
  "position": 4,
  "title": "بیمه و پوشش خطر سرمایه‌گذاری",
  "start": 159,
  "end": 160
 }
]$fixes$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)),
tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:10:'||r.track||':اقتصاد:'||p.chapter||':'||p.position)::uuid
and t.edition='1405' and t.study_field='humanities' and t.grade='10' and t.preparation_track=r.track and t.subject='اقتصاد' and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
