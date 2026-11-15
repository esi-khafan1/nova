-- History 1 (110219, 1405), independently selectable textbook subheadings.
-- Supplements, never overwrites, earlier study groups. The marker preserves deletions on rerun.
with installed as (insert into private.planner_seed_installations(seed_key) values ('history10-independent-1405-v170') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۳",
  "position": 301,
  "title": "باستان‌شناسی چیست؟",
  "start": 20,
  "end": 21
 },
 {
  "chapter": "درس ۳",
  "position": 302,
  "title": "آثار باستانی و تاریخی",
  "start": 22,
  "end": 23
 },
 {
  "chapter": "درس ۳",
  "position": 303,
  "title": "شناسایی و کشف آثار",
  "start": 24,
  "end": 24
 },
 {
  "chapter": "درس ۳",
  "position": 304,
  "title": "حفاری",
  "start": 25,
  "end": 25
 },
 {
  "chapter": "درس ۳",
  "position": 305,
  "title": "استخراج و تنظیم اطلاعات",
  "start": 26,
  "end": 26
 },
 {
  "chapter": "درس ۳",
  "position": 306,
  "title": "موزه ایران باستان",
  "start": 26,
  "end": 27
 },
 {
  "chapter": "درس ۳",
  "position": 307,
  "title": "باستان‌شناسی و تاریخ",
  "start": 27,
  "end": 28
 },
 {
  "chapter": "درس ۴",
  "position": 301,
  "title": "دوره گردآوری خوراک",
  "start": 30,
  "end": 32
 },
 {
  "chapter": "درس ۴",
  "position": 302,
  "title": "دوره تولید خوراک",
  "start": 33,
  "end": 34
 },
 {
  "chapter": "درس ۴",
  "position": 303,
  "title": "تمدن بین‌النهرین",
  "start": 35,
  "end": 38
 },
 {
  "chapter": "درس ۴",
  "position": 304,
  "title": "اکد و بابل",
  "start": 37,
  "end": 38
 },
 {
  "chapter": "درس ۴",
  "position": 305,
  "title": "میراث تمدن بین‌النهرین",
  "start": 38,
  "end": 38
 },
 {
  "chapter": "درس ۴",
  "position": 306,
  "title": "مصر، هدیه رود نیل",
  "start": 38,
  "end": 41
 },
 {
  "chapter": "درس ۴",
  "position": 307,
  "title": "مصر باستان: سیاست و حکومت",
  "start": 39,
  "end": 39
 },
 {
  "chapter": "درس ۴",
  "position": 308,
  "title": "مصر باستان: دین",
  "start": 39,
  "end": 40
 },
 {
  "chapter": "درس ۴",
  "position": 309,
  "title": "مصر باستان: جامعه و اقتصاد",
  "start": 40,
  "end": 40
 },
 {
  "chapter": "درس ۴",
  "position": 310,
  "title": "مصر باستان: ادبیات و هنر",
  "start": 40,
  "end": 41
 },
 {
  "chapter": "درس ۵",
  "position": 301,
  "title": "تمدن دره سند",
  "start": 42,
  "end": 42
 },
 {
  "chapter": "درس ۵",
  "position": 302,
  "title": "مهاجرت آریاییان به هند",
  "start": 43,
  "end": 43
 },
 {
  "chapter": "درس ۵",
  "position": 303,
  "title": "آیین برهمنی",
  "start": 43,
  "end": 45
 },
 {
  "chapter": "درس ۵",
  "position": 304,
  "title": "سلسله‌های پادشاهی هند",
  "start": 45,
  "end": 45
 },
 {
  "chapter": "درس ۵",
  "position": 305,
  "title": "چین باستان: ظهور تمدن",
  "start": 46,
  "end": 47
 },
 {
  "chapter": "درس ۵",
  "position": 306,
  "title": "نخستین امپراتور چین",
  "start": 47,
  "end": 48
 },
 {
  "chapter": "درس ۵",
  "position": 307,
  "title": "سلسله هان",
  "start": 48,
  "end": 49
 },
 {
  "chapter": "درس ۵",
  "position": 308,
  "title": "آیین و اندیشه کنفوسیوس",
  "start": 49,
  "end": 49
 },
 {
  "chapter": "درس ۶",
  "position": 301,
  "title": "تمدن مینوسی",
  "start": 51,
  "end": 51
 },
 {
  "chapter": "درس ۶",
  "position": 302,
  "title": "تمدن میسنی",
  "start": 51,
  "end": 51
 },
 {
  "chapter": "درس ۶",
  "position": 303,
  "title": "عصر دولت‌شهرها: آتن و اسپارت",
  "start": 52,
  "end": 52
 },
 {
  "chapter": "درس ۶",
  "position": 304,
  "title": "جنگ‌های داخلی یونان و برآمدن اسکندر مقدونی",
  "start": 52,
  "end": 53
 },
 {
  "chapter": "درس ۶",
  "position": 305,
  "title": "یونان باستان: دین",
  "start": 53,
  "end": 54
 },
 {
  "chapter": "درس ۶",
  "position": 306,
  "title": "یونان باستان: حکومت و سیاست",
  "start": 54,
  "end": 54
 },
 {
  "chapter": "درس ۶",
  "position": 307,
  "title": "یونان باستان: فلسفه",
  "start": 54,
  "end": 55
 },
 {
  "chapter": "درس ۶",
  "position": 308,
  "title": "یونان باستان: علوم",
  "start": 55,
  "end": 55
 },
 {
  "chapter": "درس ۶",
  "position": 309,
  "title": "یونان باستان: هنر و ادبیات",
  "start": 55,
  "end": 55
 },
 {
  "chapter": "درس ۶",
  "position": 310,
  "title": "جمهوری روم",
  "start": 55,
  "end": 56
 },
 {
  "chapter": "درس ۶",
  "position": 311,
  "title": "امپراتوری روم",
  "start": 56,
  "end": 58
 },
 {
  "chapter": "درس ۶",
  "position": 312,
  "title": "زندگی در روم",
  "start": 58,
  "end": 60
 },
 {
  "chapter": "درس ۶",
  "position": 313,
  "title": "ظهور و گسترش مسیحیت",
  "start": 60,
  "end": 60
 },
 {
  "chapter": "درس ۷",
  "position": 301,
  "title": "آگاهی تاریخی آمیخته با افسانه",
  "start": 62,
  "end": 63
 },
 {
  "chapter": "درس ۷",
  "position": 302,
  "title": "آگاهی تاریخی متکی به پژوهش و کاوش‌های جدید",
  "start": 63,
  "end": 65
 },
 {
  "chapter": "درس ۷",
  "position": 303,
  "title": "دستاوردهای کاوش‌ها و تحقیقات جدید",
  "start": 65,
  "end": 65
 },
 {
  "chapter": "درس ۷",
  "position": 304,
  "title": "منابع دست اول غیرنوشتاری",
  "start": 65,
  "end": 66
 },
 {
  "chapter": "درس ۷",
  "position": 305,
  "title": "منابع دست اول نوشتاری",
  "start": 66,
  "end": 67
 },
 {
  "chapter": "درس ۷",
  "position": 306,
  "title": "منابع نوشتاری ایرانی",
  "start": 67,
  "end": 68
 },
 {
  "chapter": "درس ۷",
  "position": 307,
  "title": "منابع دست دوم",
  "start": 68,
  "end": 68
 },
 {
  "chapter": "درس ۸",
  "position": 301,
  "title": "کهن‌ترین ساکنان فلات ایران",
  "start": 71,
  "end": 72
 },
 {
  "chapter": "درس ۸",
  "position": 302,
  "title": "از نخستین روستاها تا نخستین شهرها",
  "start": 72,
  "end": 75
 },
 {
  "chapter": "درس ۸",
  "position": 303,
  "title": "سفالگری",
  "start": 72,
  "end": 73
 },
 {
  "chapter": "درس ۸",
  "position": 304,
  "title": "فلزکاری",
  "start": 73,
  "end": 74
 },
 {
  "chapter": "درس ۸",
  "position": 305,
  "title": "خانه‌سازی",
  "start": 74,
  "end": 75
 },
 {
  "chapter": "درس ۸",
  "position": 306,
  "title": "پدید آمدن شهرها",
  "start": 75,
  "end": 75
 },
 {
  "chapter": "درس ۸",
  "position": 307,
  "title": "تمدن ایلام",
  "start": 76,
  "end": 79
 },
 {
  "chapter": "درس ۸",
  "position": 308,
  "title": "شهر و شهرنشینی ایلام",
  "start": 77,
  "end": 78
 },
 {
  "chapter": "درس ۸",
  "position": 309,
  "title": "دین و اعتقادات ایلام",
  "start": 79,
  "end": 79
 },
 {
  "chapter": "درس ۹",
  "position": 301,
  "title": "تأسیس حکومت ماد",
  "start": 80,
  "end": 81
 },
 {
  "chapter": "درس ۹",
  "position": 302,
  "title": "ماد در اوج قدرت",
  "start": 82,
  "end": 82
 },
 {
  "chapter": "درس ۹",
  "position": 303,
  "title": "سقوط حکومت ماد",
  "start": 82,
  "end": 82
 },
 {
  "chapter": "درس ۹",
  "position": 304,
  "title": "تأسیس حکومت هخامنشی",
  "start": 82,
  "end": 84
 },
 {
  "chapter": "درس ۹",
  "position": 305,
  "title": "تثبیت شاهنشاهی هخامنشیان",
  "start": 85,
  "end": 86
 },
 {
  "chapter": "درس ۹",
  "position": 306,
  "title": "رقابت و درگیری یونان با ایران",
  "start": 86,
  "end": 87
 },
 {
  "chapter": "درس ۹",
  "position": 307,
  "title": "انحطاط و فروپاشی هخامنشیان",
  "start": 87,
  "end": 89
 },
 {
  "chapter": "درس ۹",
  "position": 308,
  "title": "میراث هخامنشی در یک نگاه کلی",
  "start": 89,
  "end": 89
 },
 {
  "chapter": "درس ۱۰",
  "position": 301,
  "title": "سلوکیان",
  "start": 90,
  "end": 91
 },
 {
  "chapter": "درس ۱۰",
  "position": 302,
  "title": "تأسیس سلسله اشکانیان",
  "start": 91,
  "end": 92
 },
 {
  "chapter": "درس ۱۰",
  "position": 303,
  "title": "گسترش و تثبیت قدرت اشکانیان",
  "start": 92,
  "end": 93
 },
 {
  "chapter": "درس ۱۰",
  "position": 304,
  "title": "اشکانیان و روم",
  "start": 93,
  "end": 93
 },
 {
  "chapter": "درس ۱۰",
  "position": 305,
  "title": "انحطاط و سقوط اشکانیان",
  "start": 93,
  "end": 94
 },
 {
  "chapter": "درس ۱۰",
  "position": 306,
  "title": "میراث اشکانیان",
  "start": 94,
  "end": 94
 },
 {
  "chapter": "درس ۱۰",
  "position": 307,
  "title": "شکل‌گیری حکومت ساسانیان",
  "start": 94,
  "end": 94
 },
 {
  "chapter": "درس ۱۰",
  "position": 308,
  "title": "تثبیت قدرت ساسانیان",
  "start": 94,
  "end": 96
 },
 {
  "chapter": "درس ۱۰",
  "position": 309,
  "title": "ساسانیان و روم",
  "start": 96,
  "end": 97
 },
 {
  "chapter": "درس ۱۰",
  "position": 310,
  "title": "مقابله با بیابانگردان",
  "start": 97,
  "end": 98
 },
 {
  "chapter": "درس ۱۰",
  "position": 311,
  "title": "انحطاط و فروپاشی ساسانیان",
  "start": 98,
  "end": 98
 },
 {
  "chapter": "درس ۱۱",
  "position": 301,
  "title": "نظام سیاسی و اداری هخامنشیان",
  "start": 99,
  "end": 101
 },
 {
  "chapter": "درس ۱۱",
  "position": 302,
  "title": "نظام سیاسی و اداری سلوکیان",
  "start": 102,
  "end": 102
 },
 {
  "chapter": "درس ۱۱",
  "position": 303,
  "title": "نظام سیاسی و اداری اشکانیان",
  "start": 102,
  "end": 103
 },
 {
  "chapter": "درس ۱۱",
  "position": 304,
  "title": "نظام سیاسی و اداری ساسانیان",
  "start": 103,
  "end": 104
 },
 {
  "chapter": "درس ۱۱",
  "position": 305,
  "title": "سپاه مادی و هخامنشی",
  "start": 106,
  "end": 107
 },
 {
  "chapter": "درس ۱۱",
  "position": 306,
  "title": "سپاه اشکانیان",
  "start": 107,
  "end": 107
 },
 {
  "chapter": "درس ۱۱",
  "position": 307,
  "title": "سپاه ساسانیان",
  "start": 107,
  "end": 108
 },
 {
  "chapter": "درس ۱۲",
  "position": 301,
  "title": "گروه‌ها و طبقات اجتماعی دوره ماد و هخامنشی",
  "start": 109,
  "end": 110
 },
 {
  "chapter": "درس ۱۲",
  "position": 302,
  "title": "گروه‌ها و طبقات اجتماعی دوره اشکانیان",
  "start": 110,
  "end": 111
 },
 {
  "chapter": "درس ۱۲",
  "position": 303,
  "title": "گروه‌ها و طبقات اجتماعی دوره ساسانیان",
  "start": 111,
  "end": 112
 },
 {
  "chapter": "درس ۱۲",
  "position": 304,
  "title": "خانواده",
  "start": 113,
  "end": 114
 },
 {
  "chapter": "درس ۱۲",
  "position": 305,
  "title": "زنان",
  "start": 114,
  "end": 115
 },
 {
  "chapter": "درس ۱۲",
  "position": 306,
  "title": "جشن و سوگواری",
  "start": 116,
  "end": 117
 },
 {
  "chapter": "درس ۱۳",
  "position": 301,
  "title": "رونق و پیشرفت کشاورزی",
  "start": 118,
  "end": 120
 },
 {
  "chapter": "درس ۱۳",
  "position": 302,
  "title": "راه و حمل و نقل",
  "start": 120,
  "end": 123
 },
 {
  "chapter": "درس ۱۳",
  "position": 303,
  "title": "کشف راه‌های دریایی",
  "start": 121,
  "end": 123
 },
 {
  "chapter": "درس ۱۳",
  "position": 304,
  "title": "پول",
  "start": 123,
  "end": 124
 },
 {
  "chapter": "درس ۱۳",
  "position": 305,
  "title": "اوزان و مقیاس",
  "start": 124,
  "end": 124
 },
 {
  "chapter": "درس ۱۳",
  "position": 306,
  "title": "صنعت",
  "start": 124,
  "end": 125
 },
 {
  "chapter": "درس ۱۳",
  "position": 307,
  "title": "تجارت",
  "start": 125,
  "end": 127
 },
 {
  "chapter": "درس ۱۳",
  "position": 308,
  "title": "درآمدها و مخارج",
  "start": 127,
  "end": 127
 },
 {
  "chapter": "درس ۱۴",
  "position": 301,
  "title": "تعالیم زرتشت",
  "start": 128,
  "end": 129
 },
 {
  "chapter": "درس ۱۴",
  "position": 302,
  "title": "اوستا",
  "start": 129,
  "end": 130
 },
 {
  "chapter": "درس ۱۴",
  "position": 303,
  "title": "دین و عقاید مادها",
  "start": 130,
  "end": 131
 },
 {
  "chapter": "درس ۱۴",
  "position": 304,
  "title": "دین و عقاید هخامنشیان",
  "start": 131,
  "end": 132
 },
 {
  "chapter": "درس ۱۴",
  "position": 305,
  "title": "دین و عقاید سلوکیان و اشکانیان",
  "start": 131,
  "end": 133
 },
 {
  "chapter": "درس ۱۴",
  "position": 306,
  "title": "دین و عقاید ساسانیان",
  "start": 133,
  "end": 135
 },
 {
  "chapter": "درس ۱۵",
  "position": 301,
  "title": "زبان",
  "start": 136,
  "end": 138
 },
 {
  "chapter": "درس ۱۵",
  "position": 302,
  "title": "ادبیات",
  "start": 138,
  "end": 139
 },
 {
  "chapter": "درس ۱۵",
  "position": 303,
  "title": "آموزش",
  "start": 140,
  "end": 141
 },
 {
  "chapter": "درس ۱۵",
  "position": 304,
  "title": "علوم و مراکز آموزش عالی",
  "start": 141,
  "end": 142
 },
 {
  "chapter": "درس ۱۵",
  "position": 305,
  "title": "دانشگاه جندی‌شاپور",
  "start": 142,
  "end": 142
 },
 {
  "chapter": "درس ۱۶",
  "position": 301,
  "title": "هنر مادها",
  "start": 143,
  "end": 143
 },
 {
  "chapter": "درس ۱۶",
  "position": 302,
  "title": "معماری هخامنشیان",
  "start": 144,
  "end": 146
 },
 {
  "chapter": "درس ۱۶",
  "position": 303,
  "title": "سنگ‌نگاره هخامنشیان",
  "start": 146,
  "end": 146
 },
 {
  "chapter": "درس ۱۶",
  "position": 304,
  "title": "فلزکاری و جواهرسازی هخامنشیان",
  "start": 146,
  "end": 147
 },
 {
  "chapter": "درس ۱۶",
  "position": 305,
  "title": "بافندگی هخامنشیان",
  "start": 147,
  "end": 147
 },
 {
  "chapter": "درس ۱۶",
  "position": 306,
  "title": "معماری و شهرسازی اشکانیان",
  "start": 147,
  "end": 148
 },
 {
  "chapter": "درس ۱۶",
  "position": 307,
  "title": "پیکرسازی اشکانیان",
  "start": 148,
  "end": 148
 },
 {
  "chapter": "درس ۱۶",
  "position": 308,
  "title": "معماری و شهرسازی ساسانیان",
  "start": 150,
  "end": 150
 },
 {
  "chapter": "درس ۱۶",
  "position": 309,
  "title": "سنگ‌نگاره ساسانیان",
  "start": 150,
  "end": 151
 },
 {
  "chapter": "درس ۱۶",
  "position": 310,
  "title": "نقاشی و نگارگری ساسانیان",
  "start": 151,
  "end": 151
 },
 {
  "chapter": "درس ۱۶",
  "position": 311,
  "title": "قلم‌زنی و فلزکاری ساسانیان",
  "start": 151,
  "end": 152
 },
 {
  "chapter": "درس ۱۶",
  "position": 312,
  "title": "موسیقی ساسانیان",
  "start": 152,
  "end": 152
 },
 {
  "chapter": "درس ۱۶",
  "position": 313,
  "title": "بافندگی ساسانیان",
  "start": 152,
  "end": 152
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v170:humanities:10:'||r.track||':تاریخ ۱:'||p.chapter||':'||p.position)::uuid, '1405','humanities','10',r.track,'تاریخ ۱',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
