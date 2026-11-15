-- Textbook 110219, 1405; direct reading of printed headings and actual pages.
-- Page 69 is the beginning of lesson 8, despite the contents listing page 70.
with corrections as (select * from jsonb_to_recordset($corrections$[
 {
  "chapter": "درس ۷",
  "title": "کل درس: مطالعه و کاوش در گذشته‌های دور",
  "old_start": 62,
  "old_end": 69,
  "start": 62,
  "end": 68
 },
 {
  "chapter": "درس ۸",
  "title": "کل درس: سپیده‌دم تمدن ایرانی",
  "old_start": 70,
  "old_end": 79,
  "start": 69,
  "end": 79
 },
 {
  "chapter": "درس ۱۳",
  "title": "کل درس: اقتصاد و معیشت",
  "old_start": null,
  "old_end": null,
  "start": 118,
  "end": 127
 },
 {
  "chapter": "درس ۱۴",
  "title": "کل درس: دین و اعتقادات",
  "old_start": null,
  "old_end": null,
  "start": 128,
  "end": 135
 }
]$corrections$::jsonb) as p(chapter text,title text,old_start integer,old_end integer,start integer,"end" integer)),
 tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from corrections p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:10:'||r.track||':تاریخ ۱:'||p.chapter||':1')::uuid
 and t.edition='1405' and t.study_field='humanities' and t.grade='10' and t.preparation_track=r.track
 and t.subject='تاریخ ۱' and t.chapter=p.chapter and t.title=p.title and t.position=1
 and t.page_start is not distinct from p.old_start and t.page_end is not distinct from p.old_end and t.revision=1;

-- Study groupings reflect the 1405 book headings; boundaries may overlap where sections share a page.
with topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 101,
  "title": "تاریخ چیست؟",
  "start": 2,
  "end": 2
 },
 {
  "chapter": "درس ۱",
  "position": 102,
  "title": "پیشینه تاریخ‌نگاری",
  "start": 3,
  "end": 5
 },
 {
  "chapter": "درس ۱",
  "position": 103,
  "title": "مراحل پژوهش در تاریخ",
  "start": 6,
  "end": 7
 },
 {
  "chapter": "درس ۱",
  "position": 104,
  "title": "منابع پژوهش علمی در تاریخ",
  "start": 8,
  "end": 8
 },
 {
  "chapter": "درس ۱",
  "position": 105,
  "title": "فواید و کارکردهای مطالعه تاریخ",
  "start": 9,
  "end": 11
 },
 {
  "chapter": "درس ۲",
  "position": 101,
  "title": "تاریخ، زمان و گاه‌شماری",
  "start": 12,
  "end": 16
 },
 {
  "chapter": "درس ۲",
  "position": 102,
  "title": "تاریخ و مکان؛ تأثیر جغرافیا بر رویدادهای تاریخی",
  "start": 17,
  "end": 19
 },
 {
  "chapter": "درس ۳",
  "position": 101,
  "title": "باستان‌شناسی و آثار باستانی",
  "start": 20,
  "end": 23
 },
 {
  "chapter": "درس ۳",
  "position": 102,
  "title": "مراحل کار باستان‌شناسان",
  "start": 24,
  "end": 25
 },
 {
  "chapter": "درس ۳",
  "position": 103,
  "title": "تعیین سن آثار باستانی",
  "start": 26,
  "end": 26
 },
 {
  "chapter": "درس ۳",
  "position": 104,
  "title": "موزه‌ها؛ گنجینه آثار باستانی",
  "start": 26,
  "end": 28
 },
 {
  "chapter": "درس ۴",
  "position": 101,
  "title": "سیر پیدایش تمدن",
  "start": 30,
  "end": 34
 },
 {
  "chapter": "درس ۴",
  "position": 102,
  "title": "تمدن‌های نخستین؛ بین‌النهرین و مصر",
  "start": 35,
  "end": 41
 },
 {
  "chapter": "درس ۵",
  "position": 101,
  "title": "هند باستان",
  "start": 42,
  "end": 45
 },
 {
  "chapter": "درس ۵",
  "position": 102,
  "title": "چین باستان",
  "start": 46,
  "end": 49
 },
 {
  "chapter": "درس ۶",
  "position": 101,
  "title": "یونان باستان و فرهنگ و تمدن آن",
  "start": 50,
  "end": 55
 },
 {
  "chapter": "درس ۶",
  "position": 102,
  "title": "روم باستان و گسترش مسیحیت",
  "start": 55,
  "end": 60
 },
 {
  "chapter": "درس ۷",
  "position": 101,
  "title": "پیشینه پژوهش در تاریخ ایران باستان",
  "start": 62,
  "end": 64
 },
 {
  "chapter": "درس ۷",
  "position": 102,
  "title": "منابع تحقیق تاریخ ایران در دوران باستان",
  "start": 65,
  "end": 68
 },
 {
  "chapter": "درس ۸",
  "position": 101,
  "title": "جغرافیای تمدنی ایران",
  "start": 69,
  "end": 70
 },
 {
  "chapter": "درس ۸",
  "position": 102,
  "title": "ایران در دوران پیش از تاریخ",
  "start": 71,
  "end": 75
 },
 {
  "chapter": "درس ۸",
  "position": 103,
  "title": "دوران تاریخی و تمدن ایلام",
  "start": 76,
  "end": 79
 },
 {
  "chapter": "درس ۹",
  "position": 101,
  "title": "اقوام آریایی و حکومت ماد",
  "start": 80,
  "end": 82
 },
 {
  "chapter": "درس ۹",
  "position": 102,
  "title": "هخامنشیان",
  "start": 82,
  "end": 89
 },
 {
  "chapter": "درس ۱۰",
  "position": 101,
  "title": "اوضاع ایران پس از هخامنشیان و سلوکیان",
  "start": 90,
  "end": 91
 },
 {
  "chapter": "درس ۱۰",
  "position": 102,
  "title": "اشکانیان",
  "start": 91,
  "end": 94
 },
 {
  "chapter": "درس ۱۰",
  "position": 103,
  "title": "ساسانیان",
  "start": 94,
  "end": 98
 },
 {
  "chapter": "درس ۱۱",
  "position": 101,
  "title": "نظام سیاسی و اداری",
  "start": 99,
  "end": 103
 },
 {
  "chapter": "درس ۱۱",
  "position": 102,
  "title": "قضاوت و دادرسی",
  "start": 104,
  "end": 105
 },
 {
  "chapter": "درس ۱۱",
  "position": 103,
  "title": "سپاه و جنگ‌افزارها",
  "start": 106,
  "end": 108
 },
 {
  "chapter": "درس ۱۲",
  "position": 101,
  "title": "گروه‌ها و طبقات اجتماعی",
  "start": 109,
  "end": 112
 },
 {
  "chapter": "درس ۱۲",
  "position": 102,
  "title": "خانواده و زنان",
  "start": 113,
  "end": 115
 },
 {
  "chapter": "درس ۱۲",
  "position": 103,
  "title": "جشن و سوگواری",
  "start": 116,
  "end": 117
 },
 {
  "chapter": "درس ۱۳",
  "position": 101,
  "title": "کشاورزی و دامداری",
  "start": 118,
  "end": 120
 },
 {
  "chapter": "درس ۱۳",
  "position": 102,
  "title": "راه و حمل و نقل",
  "start": 120,
  "end": 123
 },
 {
  "chapter": "درس ۱۳",
  "position": 103,
  "title": "پول، اوزان و مقیاس‌ها",
  "start": 123,
  "end": 124
 },
 {
  "chapter": "درس ۱۳",
  "position": 104,
  "title": "صنعت و تجارت",
  "start": 124,
  "end": 127
 },
 {
  "chapter": "درس ۱۳",
  "position": 105,
  "title": "درآمدها و مخارج",
  "start": 127,
  "end": 127
 },
 {
  "chapter": "درس ۱۴",
  "position": 101,
  "title": "باورهای کهن آریایی",
  "start": 128,
  "end": 128
 },
 {
  "chapter": "درس ۱۴",
  "position": 102,
  "title": "زرتشت و تعالیم او",
  "start": 128,
  "end": 130
 },
 {
  "chapter": "درس ۱۴",
  "position": 103,
  "title": "دین و عقاید از ماد تا ساسانیان",
  "start": 130,
  "end": 135
 },
 {
  "chapter": "درس ۱۵",
  "position": 101,
  "title": "زبان و ادبیات",
  "start": 136,
  "end": 139
 },
 {
  "chapter": "درس ۱۵",
  "position": 102,
  "title": "آموزش، علوم و مراکز آموزش عالی",
  "start": 140,
  "end": 142
 },
 {
  "chapter": "درس ۱۶",
  "position": 101,
  "title": "هنر و معماری مادها و هخامنشیان",
  "start": 143,
  "end": 146
 },
 {
  "chapter": "درس ۱۶",
  "position": 102,
  "title": "هنر و معماری اشکانیان",
  "start": 147,
  "end": 148
 },
 {
  "chapter": "درس ۱۶",
  "position": 103,
  "title": "هنر و معماری ساسانیان",
  "start": 149,
  "end": 152
 }
]$topics$::jsonb) as p(chapter text,title text,position integer,start integer,"end" integer)),
 tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v164:humanities:10:'||r.track||':تاریخ ۱:'||p.chapter||':'||p.position)::uuid,
 '1405','humanities','10',r.track,'تاریخ ۱',p.chapter,p.title,p.start,p."end",p.position
from topics p cross join tracks r on conflict (id) do nothing;
