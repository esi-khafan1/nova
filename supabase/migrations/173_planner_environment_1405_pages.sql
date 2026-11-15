-- Environmental studies (111268), user-supplied 1405 edition; printed pages.
-- Original seed updates only when completely untouched.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "position": 1,
  "title": "آب، سرچشمه زندگی",
  "start": 1,
  "end": 20
 },
 {
  "position": 2,
  "title": "خاک، بستر زندگی",
  "start": 21,
  "end": 32
 },
 {
  "position": 3,
  "title": "هوا، نفس زندگی",
  "start": 33,
  "end": 46
 },
 {
  "position": 4,
  "title": "انرژی، حرکت، زندگی",
  "start": 47,
  "end": 64
 },
 {
  "position": 5,
  "title": "زباله، فاجعه محیط زیست",
  "start": 65,
  "end": 84
 },
 {
  "position": 6,
  "title": "تنوع زیستی، تابلوی زیبای آفرینش",
  "start": 85,
  "end": 102
 },
 {
  "position": 7,
  "title": "محیط زیست، بستر گردشگری مسئولانه",
  "start": 103,
  "end": 120
 }
]$fixes$::jsonb) as p(position integer,title text,start integer,"end" integer)), fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join fields f
where t.id=md5('nova:planner:1405:v1:'||f.field||':11:final_exam:انسان و محیط زیست:درس‌ها:'||p.position)::uuid and t.edition='1405' and t.study_field=f.field and t.grade='11' and t.preparation_track='final_exam' and t.subject='انسان و محیط زیست' and t.chapter='درس‌ها' and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
with installed as (insert into private.planner_seed_installations(seed_key) values ('environment-1405-v173') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "position": 101,
  "title": "درس 1: آب، سرچشمه زندگی — آب، مهم اما محدود",
  "start": 3,
  "end": 3
 },
 {
  "position": 102,
  "title": "درس 1: آب، سرچشمه زندگی — وضعیت آب در ایران",
  "start": 4,
  "end": 5
 },
 {
  "position": 103,
  "title": "درس 1: آب، سرچشمه زندگی — وضعیت مصرف آب در ایران",
  "start": 6,
  "end": 6
 },
 {
  "position": 104,
  "title": "درس 1: آب، سرچشمه زندگی — مصرف آب در کشاورزی",
  "start": 7,
  "end": 8
 },
 {
  "position": 105,
  "title": "درس 1: آب، سرچشمه زندگی — مصرف آب در شهر و روستا و صنایع",
  "start": 9,
  "end": 9
 },
 {
  "position": 106,
  "title": "درس 1: آب، سرچشمه زندگی — آب مجازی",
  "start": 10,
  "end": 10
 },
 {
  "position": 107,
  "title": "درس 1: آب، سرچشمه زندگی — احیا و تعادل‌بخشی آب‌های زیرزمینی",
  "start": 11,
  "end": 12
 },
 {
  "position": 108,
  "title": "درس 1: آب، سرچشمه زندگی — تجربه احیای دریاچه ارومیه و تأمین آب",
  "start": 13,
  "end": 13
 },
 {
  "position": 109,
  "title": "درس 1: آب، سرچشمه زندگی — مدیریت منابع آب سطحی و زیرزمینی",
  "start": 14,
  "end": 15
 },
 {
  "position": 110,
  "title": "درس 1: آب، سرچشمه زندگی — آلودگی آب",
  "start": 16,
  "end": 17
 },
 {
  "position": 111,
  "title": "درس 1: آب، سرچشمه زندگی — بازچرخانی و استفاده مجدد آب",
  "start": 17,
  "end": 18
 },
 {
  "position": 112,
  "title": "درس 1: آب، سرچشمه زندگی — حریم منابع آبی",
  "start": 19,
  "end": 19
 },
 {
  "position": 113,
  "title": "درس 1: آب، سرچشمه زندگی — من چه کار کنم؟",
  "start": 20,
  "end": 20
 },
 {
  "position": 201,
  "title": "درس 2: خاک، بستر زندگی — خاک و اهمیت آن",
  "start": 23,
  "end": 23
 },
 {
  "position": 202,
  "title": "درس 2: خاک، بستر زندگی — ترکیبات خاک",
  "start": 24,
  "end": 24
 },
 {
  "position": 203,
  "title": "درس 2: خاک، بستر زندگی — از دست رفتن خاک خوب و آلودگی خاک",
  "start": 25,
  "end": 26
 },
 {
  "position": 204,
  "title": "درس 2: خاک، بستر زندگی — تجربه‌های موفق در حفاظت خاک",
  "start": 26,
  "end": 27
 },
 {
  "position": 205,
  "title": "درس 2: خاک، بستر زندگی — امنیت غذایی",
  "start": 28,
  "end": 28
 },
 {
  "position": 206,
  "title": "درس 2: خاک، بستر زندگی — محصولات غذایی تراریخته",
  "start": 29,
  "end": 29
 },
 {
  "position": 207,
  "title": "درس 2: خاک، بستر زندگی — کشت گلخانه‌ای",
  "start": 30,
  "end": 31
 },
 {
  "position": 208,
  "title": "درس 2: خاک، بستر زندگی — من چه کار کنم؟",
  "start": 32,
  "end": 32
 },
 {
  "position": 301,
  "title": "درس 3: هوا، نفس زندگی — اهمیت هوا",
  "start": 35,
  "end": 35
 },
 {
  "position": 302,
  "title": "درس 3: هوا، نفس زندگی — آلودگی هوا",
  "start": 36,
  "end": 37
 },
 {
  "position": 303,
  "title": "درس 3: هوا، نفس زندگی — منابع آلودگی هوا و وارونگی دما",
  "start": 38,
  "end": 38
 },
 {
  "position": 304,
  "title": "درس 3: هوا، نفس زندگی — شاخص کیفیت هوا",
  "start": 39,
  "end": 39
 },
 {
  "position": 305,
  "title": "درس 3: هوا، نفس زندگی — طوفان‌های گرد و غبار و اثرات آلودگی هوا",
  "start": 40,
  "end": 40
 },
 {
  "position": 306,
  "title": "درس 3: هوا، نفس زندگی — تجربه کشورها در مقابله با آلودگی هوا",
  "start": 41,
  "end": 41
 },
 {
  "position": 307,
  "title": "درس 3: هوا، نفس زندگی — آلودگی صوتی و الکترومغناطیسی",
  "start": 42,
  "end": 42
 },
 {
  "position": 308,
  "title": "درس 3: هوا، نفس زندگی — آلودگی نوری و هوا در محیط‌های بسته",
  "start": 43,
  "end": 44
 },
 {
  "position": 309,
  "title": "درس 3: هوا، نفس زندگی — تغییر اقلیم و علل آن",
  "start": 45,
  "end": 45
 },
 {
  "position": 310,
  "title": "درس 3: هوا، نفس زندگی — من چه کار کنم؟",
  "start": 46,
  "end": 46
 },
 {
  "position": 401,
  "title": "درس 4: انرژی، حرکت، زندگی — انرژی؛ نیازی پایان‌ناپذیر",
  "start": 49,
  "end": 52
 },
 {
  "position": 402,
  "title": "درس 4: انرژی، حرکت، زندگی — سوخت‌های فسیلی، گرمایش جهانی و باران اسیدی",
  "start": 53,
  "end": 56
 },
 {
  "position": 403,
  "title": "درس 4: انرژی، حرکت، زندگی — ردپای محیط‌زیستی",
  "start": 57,
  "end": 57
 },
 {
  "position": 404,
  "title": "درس 4: انرژی، حرکت، زندگی — تجربه‌های جهانی و انرژی باد",
  "start": 58,
  "end": 60
 },
 {
  "position": 405,
  "title": "درس 4: انرژی، حرکت، زندگی — انرژی زمین‌گرمایی",
  "start": 61,
  "end": 61
 },
 {
  "position": 406,
  "title": "درس 4: انرژی، حرکت، زندگی — انرژی خورشیدی",
  "start": 62,
  "end": 63
 },
 {
  "position": 407,
  "title": "درس 4: انرژی، حرکت، زندگی — سوخت‌های سبز",
  "start": 63,
  "end": 63
 },
 {
  "position": 408,
  "title": "درس 4: انرژی، حرکت، زندگی — ردپای زندگی روزانه",
  "start": 64,
  "end": 64
 },
 {
  "position": 501,
  "title": "درس 5: زباله، فاجعه محیط زیست — زباله در گذشته و حال",
  "start": 67,
  "end": 67
 },
 {
  "position": 502,
  "title": "درس 5: زباله، فاجعه محیط زیست — زباله و انواع آن",
  "start": 68,
  "end": 69
 },
 {
  "position": 503,
  "title": "درس 5: زباله، فاجعه محیط زیست — سیاره ما در چنگال هیولای زباله",
  "start": 70,
  "end": 71
 },
 {
  "position": 504,
  "title": "درس 5: زباله، فاجعه محیط زیست — مدیریت پسماند و گورستان زباله",
  "start": 72,
  "end": 73
 },
 {
  "position": 505,
  "title": "درس 5: زباله، فاجعه محیط زیست — سوزاندن زباله و تولید انرژی",
  "start": 73,
  "end": 74
 },
 {
  "position": 506,
  "title": "درس 5: زباله، فاجعه محیط زیست — تولید پوسال و بازیافت",
  "start": 74,
  "end": 77
 },
 {
  "position": 507,
  "title": "درس 5: زباله، فاجعه محیط زیست — تجربه کشورها در مدیریت پسماند",
  "start": 78,
  "end": 80
 },
 {
  "position": 508,
  "title": "درس 5: زباله، فاجعه محیط زیست — هرم مدیریت پسماند، بازکاهی و بازمصرف",
  "start": 81,
  "end": 83
 },
 {
  "position": 509,
  "title": "درس 5: زباله، فاجعه محیط زیست — بازیافت و تدبر در آیه",
  "start": 84,
  "end": 84
 },
 {
  "position": 601,
  "title": "درس 6: تنوع زیستی، تابلوی زیبای آفرینش — همه به هم وابسته‌ایم",
  "start": 87,
  "end": 87
 },
 {
  "position": 602,
  "title": "درس 6: تنوع زیستی، تابلوی زیبای آفرینش — تنوع زیستی",
  "start": 88,
  "end": 89
 },
 {
  "position": 603,
  "title": "درس 6: تنوع زیستی، تابلوی زیبای آفرینش — اهمیت و ارزش تنوع زیستی",
  "start": 90,
  "end": 90
 },
 {
  "position": 604,
  "title": "درس 6: تنوع زیستی، تابلوی زیبای آفرینش — گنجینه تنوع زیستی ایران",
  "start": 91,
  "end": 93
 },
 {
  "position": 605,
  "title": "درس 6: تنوع زیستی، تابلوی زیبای آفرینش — انقراض و تنوع زیستی در خطر",
  "start": 94,
  "end": 94
 },
 {
  "position": 606,
  "title": "درس 6: تنوع زیستی، تابلوی زیبای آفرینش — علل تهدید تنوع زیستی",
  "start": 95,
  "end": 97
 },
 {
  "position": 607,
  "title": "درس 6: تنوع زیستی، تابلوی زیبای آفرینش — راهکارهای حفاظت، مناطق حفاظت‌شده و بانک ذخایر",
  "start": 98,
  "end": 98
 },
 {
  "position": 608,
  "title": "درس 6: تنوع زیستی، تابلوی زیبای آفرینش — تجربه‌های موفق در حفاظت",
  "start": 99,
  "end": 100
 },
 {
  "position": 609,
  "title": "درس 6: تنوع زیستی، تابلوی زیبای آفرینش — من چه کار کنم؟",
  "start": 101,
  "end": 101
 },
 {
  "position": 701,
  "title": "درس 7: محیط زیست، بستر گردشگری مسئولانه — گردشگری و هدف‌های آن",
  "start": 105,
  "end": 105
 },
 {
  "position": 702,
  "title": "درس 7: محیط زیست، بستر گردشگری مسئولانه — مزایای گردشگری",
  "start": 106,
  "end": 107
 },
 {
  "position": 703,
  "title": "درس 7: محیط زیست، بستر گردشگری مسئولانه — پیشینه گردشگری در ایران",
  "start": 108,
  "end": 109
 },
 {
  "position": 704,
  "title": "درس 7: محیط زیست، بستر گردشگری مسئولانه — پیامدهای گردشگری بر محیط زیست",
  "start": 110,
  "end": 111
 },
 {
  "position": 705,
  "title": "درس 7: محیط زیست، بستر گردشگری مسئولانه — بوم‌گردشگری و اصول آن",
  "start": 112,
  "end": 113
 },
 {
  "position": 706,
  "title": "درس 7: محیط زیست، بستر گردشگری مسئولانه — انواع بوم‌گردشگری",
  "start": 114,
  "end": 115
 },
 {
  "position": 707,
  "title": "درس 7: محیط زیست، بستر گردشگری مسئولانه — مناطق تحت حفاظت ایران و مقررات",
  "start": 116,
  "end": 117
 },
 {
  "position": 708,
  "title": "درس 7: محیط زیست، بستر گردشگری مسئولانه — تجربه گردشگری سازگار با فرهنگ",
  "start": 118,
  "end": 118
 },
 {
  "position": 709,
  "title": "درس 7: محیط زیست، بستر گردشگری مسئولانه — چه باید کرد؟ و سفر مسئولانه",
  "start": 119,
  "end": 120
 },
 {
  "position": 901,
  "title": "واژه‌نامه",
  "start": 121,
  "end": 125
 }
]$topics$::jsonb) as p(position integer,title text,start integer,"end" integer)), fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v173:'||f.field||':11:final_exam:انسان و محیط زیست:درس‌ها:'||p.position)::uuid,'1405',f.field,'11','final_exam','انسان و محیط زیست','درس‌ها',p.title,p.start,p."end",p.position from topics p cross join fields f cross join installed on conflict(id) do nothing;
