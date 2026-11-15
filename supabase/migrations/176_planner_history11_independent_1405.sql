-- History 2 (111219, 1405), lessons 8–16 independent textbook subheadings.
-- Complements migration 171; no existing topic or snapshot is altered.
with installed as (insert into private.planner_seed_installations(seed_key) values ('history11-independent-8-16-1405-v176') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۸",
  "position": 301,
  "title": "اوضاع ایران در آستانه حمله اعراب",
  "start": 84,
  "end": 85
 },
 {
  "chapter": "درس ۸",
  "position": 302,
  "title": "ساسانیان و اعراب",
  "start": 84,
  "end": 85
 },
 {
  "chapter": "درس ۸",
  "position": 303,
  "title": "نخستین برخوردهای مسلمانان با ایرانیان",
  "start": 85,
  "end": 85
 },
 {
  "chapter": "درس ۸",
  "position": 304,
  "title": "حمله اعراب مسلمان به ایران",
  "start": 85,
  "end": 87
 },
 {
  "chapter": "درس ۸",
  "position": 305,
  "title": "جنگ نهاوند",
  "start": 87,
  "end": 87
 },
 {
  "chapter": "درس ۸",
  "position": 306,
  "title": "حکومت اعراب بر ایران: عصر خلفای نخستین",
  "start": 88,
  "end": 89
 },
 {
  "chapter": "درس ۸",
  "position": 307,
  "title": "دوره خلافت امویان",
  "start": 89,
  "end": 90
 },
 {
  "chapter": "درس ۸",
  "position": 308,
  "title": "عصر خلافت عباسیان",
  "start": 90,
  "end": 90
 },
 {
  "chapter": "درس ۸",
  "position": 309,
  "title": "جنبش‌های ایرانیان در دوران امویان",
  "start": 90,
  "end": 90
 },
 {
  "chapter": "درس ۸",
  "position": 310,
  "title": "جنبش‌های ایرانیان در عصر عباسیان",
  "start": 90,
  "end": 91
 },
 {
  "chapter": "درس ۸",
  "position": 311,
  "title": "روند اسلام آوردن مردم ایران",
  "start": 92,
  "end": 93
 },
 {
  "chapter": "درس ۸",
  "position": 312,
  "title": "عوامل مؤثر در اسلام آوردن مردم ایران",
  "start": 93,
  "end": 94
 },
 {
  "chapter": "درس ۹",
  "position": 301,
  "title": "زمینه‌های تأسیس سلسله‌های ایرانی مسلمان",
  "start": 95,
  "end": 96
 },
 {
  "chapter": "درس ۹",
  "position": 302,
  "title": "خاستگاه اجتماعی و جغرافیایی سلسله‌ها",
  "start": 96,
  "end": 97
 },
 {
  "chapter": "درس ۹",
  "position": 303,
  "title": "شیوه کسب قدرت",
  "start": 97,
  "end": 98
 },
 {
  "chapter": "درس ۹",
  "position": 304,
  "title": "روابط با خلافت عباسی",
  "start": 98,
  "end": 99
 },
 {
  "chapter": "درس ۹",
  "position": 305,
  "title": "آثار و پیامدهای سیاسی، اقتصادی و مذهبی",
  "start": 100,
  "end": 101
 },
 {
  "chapter": "درس ۹",
  "position": 306,
  "title": "زبان فارسی",
  "start": 101,
  "end": 102
 },
 {
  "chapter": "درس ۹",
  "position": 307,
  "title": "علم و آموزش",
  "start": 102,
  "end": 106
 },
 {
  "chapter": "درس ۹",
  "position": 308,
  "title": "معارف اسلامی",
  "start": 103,
  "end": 104
 },
 {
  "chapter": "درس ۹",
  "position": 309,
  "title": "فلسفه",
  "start": 104,
  "end": 104
 },
 {
  "chapter": "درس ۹",
  "position": 310,
  "title": "ریاضیات و نجوم",
  "start": 104,
  "end": 105
 },
 {
  "chapter": "درس ۹",
  "position": 311,
  "title": "پزشکی و داروسازی",
  "start": 105,
  "end": 106
 },
 {
  "chapter": "درس ۹",
  "position": 312,
  "title": "سایر علوم و فنون",
  "start": 106,
  "end": 106
 },
 {
  "chapter": "درس ۹",
  "position": 313,
  "title": "توسعه دریانوردی و تجارت دریایی",
  "start": 107,
  "end": 108
 },
 {
  "chapter": "درس ۱۰",
  "position": 301,
  "title": "غزنویان",
  "start": 109,
  "end": 110
 },
 {
  "chapter": "درس ۱۰",
  "position": 302,
  "title": "سلجوقیان",
  "start": 110,
  "end": 112
 },
 {
  "chapter": "درس ۱۰",
  "position": 303,
  "title": "خوارزمشاهیان",
  "start": 112,
  "end": 114
 },
 {
  "chapter": "درس ۱۰",
  "position": 304,
  "title": "نظام اداری",
  "start": 114,
  "end": 115
 },
 {
  "chapter": "درس ۱۰",
  "position": 305,
  "title": "اوضاع اجتماعی و اعتقادی",
  "start": 115,
  "end": 118
 },
 {
  "chapter": "درس ۱۰",
  "position": 306,
  "title": "اسماعیلیان ایران",
  "start": 117,
  "end": 118
 },
 {
  "chapter": "درس ۱۰",
  "position": 307,
  "title": "کشاورزی و زمین‌داری",
  "start": 118,
  "end": 118
 },
 {
  "chapter": "درس ۱۰",
  "position": 308,
  "title": "تجارت و پیشه‌وری",
  "start": 118,
  "end": 119
 },
 {
  "chapter": "درس ۱۰",
  "position": 309,
  "title": "زبان و ادب فارسی",
  "start": 119,
  "end": 119
 },
 {
  "chapter": "درس ۱۰",
  "position": 310,
  "title": "علم و آموزش",
  "start": 119,
  "end": 120
 },
 {
  "chapter": "درس ۱۰",
  "position": 311,
  "title": "هنر و معماری",
  "start": 120,
  "end": 123
 },
 {
  "chapter": "درس ۱۱",
  "position": 301,
  "title": "هجوم مغولان به ایران",
  "start": 124,
  "end": 125
 },
 {
  "chapter": "درس ۱۱",
  "position": 302,
  "title": "ایران در عهد ایلخانان",
  "start": 125,
  "end": 128
 },
 {
  "chapter": "درس ۱۱",
  "position": 303,
  "title": "قیام سربداران در سبزوار",
  "start": 127,
  "end": 128
 },
 {
  "chapter": "درس ۱۱",
  "position": 304,
  "title": "ایران در عهد تیموریان",
  "start": 128,
  "end": 129
 },
 {
  "chapter": "درس ۱۱",
  "position": 305,
  "title": "شهر و شهرنشینی",
  "start": 129,
  "end": 130
 },
 {
  "chapter": "درس ۱۱",
  "position": 306,
  "title": "گروه‌های اجتماعی",
  "start": 130,
  "end": 131
 },
 {
  "chapter": "درس ۱۱",
  "position": 307,
  "title": "نظام حقوقی و قضایی",
  "start": 131,
  "end": 132
 },
 {
  "chapter": "درس ۱۱",
  "position": 308,
  "title": "کشاورزی و تجارت",
  "start": 132,
  "end": 134
 },
 {
  "chapter": "درس ۱۱",
  "position": 309,
  "title": "پول و مالیات",
  "start": 134,
  "end": 134
 },
 {
  "chapter": "درس ۱۲",
  "position": 301,
  "title": "اسلام‌پذیری مغولان",
  "start": 135,
  "end": 137
 },
 {
  "chapter": "درس ۱۲",
  "position": 302,
  "title": "گسترش تصوف",
  "start": 137,
  "end": 138
 },
 {
  "chapter": "درس ۱۲",
  "position": 303,
  "title": "نگارگری و خوشنویسی",
  "start": 138,
  "end": 140
 },
 {
  "chapter": "درس ۱۲",
  "position": 304,
  "title": "معماری",
  "start": 140,
  "end": 143
 },
 {
  "chapter": "درس ۱۲",
  "position": 305,
  "title": "ادبیات و تاریخ‌نگاری",
  "start": 143,
  "end": 145
 },
 {
  "chapter": "درس ۱۲",
  "position": 306,
  "title": "دانش‌های دیگر",
  "start": 145,
  "end": 146
 },
 {
  "chapter": "درس ۱۳",
  "position": 301,
  "title": "زمینه‌های تشکیل حکومت صفویان",
  "start": 147,
  "end": 149
 },
 {
  "chapter": "درس ۱۳",
  "position": 302,
  "title": "تأسیس حکومت صفوی",
  "start": 149,
  "end": 151
 },
 {
  "chapter": "درس ۱۳",
  "position": 303,
  "title": "دوران تثبیت",
  "start": 151,
  "end": 151
 },
 {
  "chapter": "درس ۱۳",
  "position": 304,
  "title": "عصر اقتدار و شکوفایی",
  "start": 151,
  "end": 155
 },
 {
  "chapter": "درس ۱۳",
  "position": 305,
  "title": "ایجاد ثبات سیاسی و نظم و امنیت",
  "start": 151,
  "end": 151
 },
 {
  "chapter": "درس ۱۳",
  "position": 306,
  "title": "نوسازی تشکیلات و تجهیزات سپاه",
  "start": 151,
  "end": 153
 },
 {
  "chapter": "درس ۱۳",
  "position": 307,
  "title": "بیرون راندن نیروهای بیگانه از ایران",
  "start": 153,
  "end": 153
 },
 {
  "chapter": "درس ۱۳",
  "position": 308,
  "title": "توسعه اقتصادی، اجتماعی و فرهنگی",
  "start": 153,
  "end": 153
 },
 {
  "chapter": "درس ۱۳",
  "position": 309,
  "title": "انتقال پایتخت از قزوین به اصفهان",
  "start": 153,
  "end": 155
 },
 {
  "chapter": "درس ۱۳",
  "position": 310,
  "title": "دوران ضعف و انحطاط",
  "start": 155,
  "end": 156
 },
 {
  "chapter": "درس ۱۳",
  "position": 311,
  "title": "اوضاع اقتصادی و انواع اراضی",
  "start": 156,
  "end": 157
 },
 {
  "chapter": "درس ۱۳",
  "position": 312,
  "title": "روابط با عثمانی",
  "start": 157,
  "end": 159
 },
 {
  "chapter": "درس ۱۳",
  "position": 313,
  "title": "روابط با ازبکان و گورکانیان هند",
  "start": 159,
  "end": 160
 },
 {
  "chapter": "درس ۱۳",
  "position": 314,
  "title": "روابط با اروپا",
  "start": 160,
  "end": 161
 },
 {
  "chapter": "درس ۱۴",
  "position": 301,
  "title": "زمینه‌های شکوفایی فرهنگ و هنر",
  "start": 162,
  "end": 162
 },
 {
  "chapter": "درس ۱۴",
  "position": 302,
  "title": "تعلیم و تربیت و مراکز علمی و آموزشی",
  "start": 162,
  "end": 165
 },
 {
  "chapter": "درس ۱۴",
  "position": 303,
  "title": "تاریخ‌نگاری",
  "start": 163,
  "end": 164
 },
 {
  "chapter": "درس ۱۴",
  "position": 304,
  "title": "علما و دانشمندان",
  "start": 165,
  "end": 166
 },
 {
  "chapter": "درس ۱۴",
  "position": 305,
  "title": "معماری",
  "start": 166,
  "end": 168
 },
 {
  "chapter": "درس ۱۴",
  "position": 306,
  "title": "نگارگری و خوشنویسی",
  "start": 168,
  "end": 169
 },
 {
  "chapter": "درس ۱۴",
  "position": 307,
  "title": "بافندگی",
  "start": 169,
  "end": 171
 },
 {
  "chapter": "درس ۱۴",
  "position": 308,
  "title": "فلزکاری",
  "start": 171,
  "end": 172
 },
 {
  "chapter": "درس ۱۵",
  "position": 301,
  "title": "امپراتوری روم شرقی یا بیزانس",
  "start": 174,
  "end": 175
 },
 {
  "chapter": "درس ۱۵",
  "position": 302,
  "title": "تهاجم ژرمن‌ها به روم غربی",
  "start": 175,
  "end": 176
 },
 {
  "chapter": "درس ۱۵",
  "position": 303,
  "title": "پادشاهی شارلمانی و امپراتوری مقدس روم",
  "start": 176,
  "end": 178
 },
 {
  "chapter": "درس ۱۵",
  "position": 304,
  "title": "گسترش و تحکیم نظام فئودالیسم",
  "start": 178,
  "end": 180
 },
 {
  "chapter": "درس ۱۵",
  "position": 305,
  "title": "جنگ‌های صلیبی: علل، روند و پیامدها",
  "start": 180,
  "end": 182
 },
 {
  "chapter": "درس ۱۵",
  "position": 306,
  "title": "پیدایش پادشاهی‌های قدرتمند و جنگ‌های صدساله",
  "start": 182,
  "end": 183
 },
 {
  "chapter": "درس ۱۵",
  "position": 307,
  "title": "کلیسا و تحولات آن",
  "start": 183,
  "end": 186
 },
 {
  "chapter": "درس ۱۵",
  "position": 308,
  "title": "علم و آموزش",
  "start": 186,
  "end": 187
 },
 {
  "chapter": "درس ۱۶",
  "position": 301,
  "title": "زمینه‌ها و علل بروز رنسانس",
  "start": 188,
  "end": 191
 },
 {
  "chapter": "درس ۱۶",
  "position": 302,
  "title": "رشد شهرنشینی و تجارت",
  "start": 189,
  "end": 190
 },
 {
  "chapter": "درس ۱۶",
  "position": 303,
  "title": "گسترش روابط فرهنگی با جهان اسلام",
  "start": 190,
  "end": 191
 },
 {
  "chapter": "درس ۱۶",
  "position": 304,
  "title": "پیشینه فرهنگی و تاریخی",
  "start": 191,
  "end": 191
 },
 {
  "chapter": "درس ۱۶",
  "position": 305,
  "title": "گسترش اندیشه انسان‌گرایی",
  "start": 191,
  "end": 194
 },
 {
  "chapter": "درس ۱۶",
  "position": 306,
  "title": "تحولات علمی",
  "start": 194,
  "end": 196
 },
 {
  "chapter": "درس ۱۶",
  "position": 307,
  "title": "اکتشافات جغرافیایی و شروع استعمارگری",
  "start": 196,
  "end": 199
 },
 {
  "chapter": "درس ۱۶",
  "position": 308,
  "title": "انگیزه و عوامل اکتشافات جغرافیایی",
  "start": 196,
  "end": 197
 },
 {
  "chapter": "درس ۱۶",
  "position": 309,
  "title": "آثار و پیامدهای اکتشافات جغرافیایی",
  "start": 198,
  "end": 199
 },
 {
  "chapter": "درس ۱۶",
  "position": 310,
  "title": "تجارت بردگان آفریقایی",
  "start": 199,
  "end": 199
 },
 {
  "chapter": "درس ۱۶",
  "position": 311,
  "title": "جنبش اصلاح دین و نهضت پروتستان",
  "start": 199,
  "end": 201
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v176:humanities:11:'||r.track||':تاریخ ۲:'||p.chapter||':'||p.position)::uuid,'1405','humanities','11',r.track,'تاریخ ۲',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
