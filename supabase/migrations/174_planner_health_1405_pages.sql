-- Health and hygiene, user-supplied textbook code 112268, 1405, printed pages.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "position": 1,
  "title": "درس ۱: سلامت چیست؟",
  "start": 3,
  "end": 11
 },
 {
  "position": 2,
  "title": "درس ۲: سبک زندگی سالم",
  "start": 12,
  "end": 16
 },
 {
  "position": 3,
  "title": "درس ۳: برنامه غذایی سالم",
  "start": 19,
  "end": 32
 },
 {
  "position": 4,
  "title": "درس ۴: کنترل وزن و تناسب اندام",
  "start": 33,
  "end": 39
 },
 {
  "position": 5,
  "title": "درس ۵: بهداشت و ایمنی مواد غذایی",
  "start": 40,
  "end": 46
 },
 {
  "position": 6,
  "title": "درس ۶: بیماری‌های غیر واگیر",
  "start": 49,
  "end": 66
 },
 {
  "position": 7,
  "title": "درس ۷: بیماری‌های واگیردار",
  "start": 67,
  "end": 76
 },
 {
  "position": 8,
  "title": "درس ۸: بهداشت فردی",
  "start": 79,
  "end": 100
 },
 {
  "position": 9,
  "title": "درس ۹: بهداشت ازدواج و فرزندآوری",
  "start": 101,
  "end": 110
 },
 {
  "position": 10,
  "title": "درس ۱۰: بهداشت روان",
  "start": 111,
  "end": 125
 },
 {
  "position": 11,
  "title": "درس ۱۱: مصرف دخانیات و الکل",
  "start": 129,
  "end": 138
 },
 {
  "position": 12,
  "title": "درس ۱۲: اعتیاد و عوارض آن",
  "start": 139,
  "end": 153
 },
 {
  "position": 13,
  "title": "درس ۱۳: پیشگیری از اختلالات اسکلتی ـ عضلانی (کمردرد)",
  "start": 157,
  "end": 171
 },
 {
  "position": 14,
  "title": "درس ۱۴: پیشگیری از حوادث خانگی",
  "start": 172,
  "end": 184
 }
]$fixes$::jsonb) as p(position integer,title text,start integer,"end" integer)), fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join fields f
where t.id=md5('nova:planner:1405:v1:'||f.field||':12:final_exam:سلامت و بهداشت:درس‌ها:'||p.position)::uuid and t.edition='1405' and t.study_field=f.field and t.grade='12' and t.preparation_track='final_exam' and t.subject='سلامت و بهداشت' and t.chapter='درس‌ها' and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
with installed as (insert into private.planner_seed_installations(seed_key) values ('health-1405-v174') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "position": 101,
  "title": "درس 1: تعریف سلامت و بهداشت",
  "start": 3,
  "end": 5
 },
 {
  "position": 102,
  "title": "درس 1: ابعاد سلامت",
  "start": 6,
  "end": 9
 },
 {
  "position": 103,
  "title": "درس 1: عوامل مؤثر بر سلامت",
  "start": 10,
  "end": 11
 },
 {
  "position": 201,
  "title": "درس 2: سبک زندگی سالم",
  "start": 12,
  "end": 13
 },
 {
  "position": 202,
  "title": "درس 2: خودمراقبتی و ابعاد آن",
  "start": 14,
  "end": 15
 },
 {
  "position": 203,
  "title": "درس 2: گام‌های برنامه‌ریزی برای خودمراقبتی",
  "start": 15,
  "end": 16
 },
 {
  "position": 301,
  "title": "درس 3: مواد مغذی و کربوهیدرات‌ها",
  "start": 19,
  "end": 20
 },
 {
  "position": 302,
  "title": "درس 3: چربی‌ها و پروتئین‌ها",
  "start": 21,
  "end": 21
 },
 {
  "position": 303,
  "title": "درس 3: ویتامین‌ها و مواد معدنی",
  "start": 22,
  "end": 22
 },
 {
  "position": 304,
  "title": "درس 3: گروه‌های غذایی و هرم غذایی",
  "start": 23,
  "end": 25
 },
 {
  "position": 305,
  "title": "درس 3: اصول تغذیه سالم: تعادل، تنوع و تناسب",
  "start": 26,
  "end": 26
 },
 {
  "position": 306,
  "title": "درس 3: عادت‌های غذایی",
  "start": 27,
  "end": 29
 },
 {
  "position": 307,
  "title": "درس 3: سوءتغذیه ناشی از کمبود ریزمغذی‌ها",
  "start": 30,
  "end": 32
 },
 {
  "position": 401,
  "title": "درس 4: عوامل چاقی",
  "start": 33,
  "end": 34
 },
 {
  "position": 402,
  "title": "درس 4: مدیریت وزن و نمایه توده بدنی",
  "start": 35,
  "end": 37
 },
 {
  "position": 403,
  "title": "درس 4: اصول کاهش و تنظیم وزن",
  "start": 37,
  "end": 39
 },
 {
  "position": 501,
  "title": "درس 5: اصول بهداشتی جلوگیری از آلودگی و فساد غذا",
  "start": 40,
  "end": 42
 },
 {
  "position": 502,
  "title": "درس 5: فساد مواد غذایی و عوامل شیمیایی، بیولوژیکی و فیزیکی",
  "start": 43,
  "end": 45
 },
 {
  "position": 503,
  "title": "درس 5: بیماری‌های ناشی از غذا",
  "start": 45,
  "end": 46
 },
 {
  "position": 504,
  "title": "درس 5: خودمراقبتی برای تغذیه سالم و ایمن",
  "start": 46,
  "end": 46
 },
 {
  "position": 601,
  "title": "درس 6: بیماری‌های قلبی و عروقی",
  "start": 49,
  "end": 51
 },
 {
  "position": 602,
  "title": "درس 6: عوامل خطر و فشار خون بالا",
  "start": 52,
  "end": 54
 },
 {
  "position": 603,
  "title": "درس 6: اختلالات چربی خون و نقش رژیم غذایی",
  "start": 55,
  "end": 58
 },
 {
  "position": 604,
  "title": "درس 6: اقدامات اولیه در سکته قلبی و مغزی",
  "start": 58,
  "end": 59
 },
 {
  "position": 605,
  "title": "درس 6: پیشگیری از بیماری‌های قلبی و عروقی",
  "start": 60,
  "end": 60
 },
 {
  "position": 606,
  "title": "درس 6: سرطان و پیشگیری از آن",
  "start": 60,
  "end": 63
 },
 {
  "position": 607,
  "title": "درس 6: دیابت، علائم، عوامل خطر و پیشگیری",
  "start": 64,
  "end": 66
 },
 {
  "position": 701,
  "title": "درس 7: بیماری‌های انتقال‌یافته از دستگاه گوارش",
  "start": 67,
  "end": 68
 },
 {
  "position": 702,
  "title": "درس 7: بیماری‌های انتقال‌یافته از دستگاه تنفس",
  "start": 68,
  "end": 69
 },
 {
  "position": 703,
  "title": "درس 7: بیماری‌های انتقال‌یافته از پوست و مخاط",
  "start": 69,
  "end": 70
 },
 {
  "position": 704,
  "title": "درس 7: بیماری‌های انتقال‌یافته از دستگاه تناسلی",
  "start": 70,
  "end": 70
 },
 {
  "position": 705,
  "title": "درس 7: بیماری‌های انتقال‌یافته از خون و ترشحات بدن و هپاتیت",
  "start": 70,
  "end": 72
 },
 {
  "position": 706,
  "title": "درس 7: اچ‌آی‌وی و ایدز: علائم و پیشگیری",
  "start": 72,
  "end": 76
 },
 {
  "position": 801,
  "title": "درس 8: بهداشت فردی",
  "start": 79,
  "end": 79
 },
 {
  "position": 802,
  "title": "درس 8: بهداشت چشم و مراقبت در برابر آسیب‌های چشم",
  "start": 80,
  "end": 83
 },
 {
  "position": 803,
  "title": "درس 8: بهداشت گوش و مراقبت در برابر آسیب‌ها",
  "start": 84,
  "end": 87
 },
 {
  "position": 804,
  "title": "درس 8: بهداشت پوست و مو",
  "start": 88,
  "end": 92
 },
 {
  "position": 805,
  "title": "درس 8: خواب و بهداشت خواب",
  "start": 93,
  "end": 95
 },
 {
  "position": 806,
  "title": "درس 8: بهداشت دهان و دندان و پوسیدگی",
  "start": 95,
  "end": 97
 },
 {
  "position": 807,
  "title": "درس 8: روش صحیح مسواک و نخ دندان",
  "start": 98,
  "end": 99
 },
 {
  "position": 808,
  "title": "درس 8: خودمراقبتی بهداشت فردی",
  "start": 100,
  "end": 100
 },
 {
  "position": 901,
  "title": "درس 9: سن ازدواج و انواع بلوغ",
  "start": 101,
  "end": 102
 },
 {
  "position": 902,
  "title": "درس 9: اقدامات بهداشتی پیش از ازدواج",
  "start": 102,
  "end": 105
 },
 {
  "position": 903,
  "title": "درس 9: باروری و فرزندآوری و عوامل مؤثر",
  "start": 106,
  "end": 108
 },
 {
  "position": 904,
  "title": "درس 9: توصیه‌های بهداشتی باروری مردان",
  "start": 108,
  "end": 109
 },
 {
  "position": 905,
  "title": "درس 9: توصیه‌های بهداشتی بارداری زنان",
  "start": 109,
  "end": 110
 },
 {
  "position": 1001,
  "title": "درس 10: خودآگاهی",
  "start": 111,
  "end": 112
 },
 {
  "position": 1002,
  "title": "درس 10: عزت نفس و راهکارهای بهبود",
  "start": 113,
  "end": 114
 },
 {
  "position": 1003,
  "title": "درس 10: سرسختی و تاب‌آوری",
  "start": 115,
  "end": 116
 },
 {
  "position": 1004,
  "title": "درس 10: اختلالات روانی ـ رفتاری نوجوانی",
  "start": 117,
  "end": 117
 },
 {
  "position": 1005,
  "title": "درس 10: فشار روانی، اضطراب و مدیریت استرس",
  "start": 118,
  "end": 120
 },
 {
  "position": 1006,
  "title": "درس 10: افسردگی و علائم هشداردهنده",
  "start": 121,
  "end": 123
 },
 {
  "position": 1007,
  "title": "درس 10: خودمراقبتی برای سلامت روان",
  "start": 124,
  "end": 125
 },
 {
  "position": 1101,
  "title": "درس 11: سیگار و مواد تشکیل‌دهنده دود آن",
  "start": 129,
  "end": 130
 },
 {
  "position": 1102,
  "title": "درس 11: محصولات بدون دود و نوپدید دخانی",
  "start": 131,
  "end": 132
 },
 {
  "position": 1103,
  "title": "درس 11: باورهای غلط و قلیان",
  "start": 133,
  "end": 133
 },
 {
  "position": 1104,
  "title": "درس 11: مقابله با وسوسه مصرف دخانیات",
  "start": 134,
  "end": 135
 },
 {
  "position": 1105,
  "title": "درس 11: دود دست دوم و سوم و عوارض آن",
  "start": 135,
  "end": 136
 },
 {
  "position": 1106,
  "title": "درس 11: آثار مصرف مشروبات الکلی",
  "start": 137,
  "end": 138
 },
 {
  "position": 1201,
  "title": "درس 12: اعتیاد و وابستگی به مواد",
  "start": 139,
  "end": 143
 },
 {
  "position": 1202,
  "title": "درس 12: مواد اعتیادآور و انواع آن",
  "start": 143,
  "end": 144
 },
 {
  "position": 1203,
  "title": "درس 12: گرفتاری در دام اعتیاد و روش‌های خودمراقبتی",
  "start": 145,
  "end": 146
 },
 {
  "position": 1204,
  "title": "درس 12: عوامل مؤثر در شروع مصرف مواد",
  "start": 147,
  "end": 147
 },
 {
  "position": 1205,
  "title": "درس 12: چگونه بگوییم نه؟",
  "start": 148,
  "end": 150
 },
 {
  "position": 1206,
  "title": "درس 12: توصیه‌های پیشگیری از رفتارهای پرخطر",
  "start": 151,
  "end": 153
 },
 {
  "position": 1301,
  "title": "درس 13: حفظ وضعیت بدنی مناسب و اصلاح عادات",
  "start": 157,
  "end": 158
 },
 {
  "position": 1302,
  "title": "درس 13: انجام صحیح کارهای روزمره و حمل بار",
  "start": 159,
  "end": 161
 },
 {
  "position": 1303,
  "title": "درس 13: تقویت عضلات کمر",
  "start": 162,
  "end": 163
 },
 {
  "position": 1304,
  "title": "درس 13: ارگونومی و استفاده از کوله‌پشتی",
  "start": 164,
  "end": 165
 },
 {
  "position": 1305,
  "title": "درس 13: اصول ارگونومی",
  "start": 166,
  "end": 170
 },
 {
  "position": 1306,
  "title": "درس 13: توصیه‌های خودمراقبتی",
  "start": 171,
  "end": 171
 },
 {
  "position": 1401,
  "title": "درس 14: حوادث خانگی و خطر",
  "start": 172,
  "end": 174
 },
 {
  "position": 1402,
  "title": "درس 14: مسمومیت با گاز مونوکسید کربن",
  "start": 174,
  "end": 175
 },
 {
  "position": 1403,
  "title": "درس 14: مسمومیت با مواد شیمیایی",
  "start": 175,
  "end": 177
 },
 {
  "position": 1404,
  "title": "درس 14: آتش‌سوزی و اقدامات مقابله",
  "start": 177,
  "end": 180
 },
 {
  "position": 1405,
  "title": "درس 14: انسداد راه تنفس و خفگی",
  "start": 181,
  "end": 183
 },
 {
  "position": 1406,
  "title": "درس 14: توصیه‌های خودمراقبتی برای پیشگیری",
  "start": 184,
  "end": 184
 }
]$topics$::jsonb) as p(position integer,title text,start integer,"end" integer)), fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v174:'||f.field||':12:final_exam:سلامت و بهداشت:درس‌ها:'||p.position)::uuid,'1405',f.field,'12','final_exam','سلامت و بهداشت','درس‌ها',p.title,p.start,p."end",p.position from topics p cross join fields f cross join installed on conflict(id) do nothing;
