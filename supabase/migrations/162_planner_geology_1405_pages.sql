-- User-supplied 111237, tenth printing 1405: printed pages, not PDF offsets.
-- Update only untouched 152 defaults. Administrator edits and published plans survive.
with pages as (select * from jsonb_to_recordset($pages$[
 {
  "chapter": "فصل ۱: آفرینش کیهان و تکوین زمین",
  "title": "آفرینش کیهان و تشکیل عناصر",
  "position": 1,
  "start": 10,
  "end": 12
 },
 {
  "chapter": "فصل ۱: آفرینش کیهان و تکوین زمین",
  "title": "کهکشان راه شیری و سامانه خورشیدی",
  "position": 2,
  "start": 13,
  "end": 14
 },
 {
  "chapter": "فصل ۱: آفرینش کیهان و تکوین زمین",
  "title": "تکوین زمین و آغاز زندگی در آن",
  "position": 3,
  "start": 14,
  "end": 15
 },
 {
  "chapter": "فصل ۱: آفرینش کیهان و تکوین زمین",
  "title": "سن زمین و زمان در زمین‌شناسی",
  "position": 4,
  "start": 16,
  "end": 19
 },
 {
  "chapter": "فصل ۱: آفرینش کیهان و تکوین زمین",
  "title": "تغییرات آب و هوایی",
  "position": 5,
  "start": 20,
  "end": 20
 },
 {
  "chapter": "فصل ۲: منابع معدنی و ذخایر انرژی، زیربنای تمدن و توسعه",
  "title": "منابع معدنی در زندگی و غلظت عناصر در پوسته زمین",
  "position": 1,
  "start": 24,
  "end": 25
 },
 {
  "chapter": "فصل ۲: منابع معدنی و ذخایر انرژی، زیربنای تمدن و توسعه",
  "title": "کانی‌های سیلیکاتی و سری واکنش بوون",
  "position": 2,
  "start": 25,
  "end": 28
 },
 {
  "chapter": "فصل ۲: منابع معدنی و ذخایر انرژی، زیربنای تمدن و توسعه",
  "title": "کانه، کانسنگ و طبقه‌بندی کانسنگ‌ها",
  "position": 3,
  "start": 28,
  "end": 31
 },
 {
  "chapter": "فصل ۲: منابع معدنی و ذخایر انرژی، زیربنای تمدن و توسعه",
  "title": "اکتشاف، استخراج و فراوری ماده معدنی",
  "position": 4,
  "start": 31,
  "end": 32
 },
 {
  "chapter": "فصل ۲: منابع معدنی و ذخایر انرژی، زیربنای تمدن و توسعه",
  "title": "گوهرها و کانی‌ها",
  "position": 5,
  "start": 32,
  "end": 35
 },
 {
  "chapter": "فصل ۲: منابع معدنی و ذخایر انرژی، زیربنای تمدن و توسعه",
  "title": "سوخت‌های فسیلی",
  "position": 6,
  "start": 35,
  "end": 38
 },
 {
  "chapter": "فصل ۳: منابع آب و خاک",
  "title": "آب جاری",
  "position": 1,
  "start": 42,
  "end": 44
 },
 {
  "chapter": "فصل ۳: منابع آب و خاک",
  "title": "آب زیرزمینی و فرونشست زمین",
  "position": 2,
  "start": 44,
  "end": 52
 },
 {
  "chapter": "فصل ۳: منابع آب و خاک",
  "title": "منابع خاک و فرسایش",
  "position": 3,
  "start": 52,
  "end": 56
 },
 {
  "chapter": "فصل ۴: پویایی زمین",
  "title": "چرخه ویلسون",
  "position": 1,
  "start": 61,
  "end": 62
 },
 {
  "chapter": "فصل ۴: پویایی زمین",
  "title": "تنش، موقعیت لایه‌ها و شکستگی‌ها",
  "position": 2,
  "start": 62,
  "end": 64
 },
 {
  "chapter": "فصل ۴: پویایی زمین",
  "title": "چین‌خوردگی",
  "position": 3,
  "start": 64,
  "end": 65
 },
 {
  "chapter": "فصل ۴: پویایی زمین",
  "title": "آتشفشان و فواید آن",
  "position": 4,
  "start": 66,
  "end": 68
 },
 {
  "chapter": "فصل ۴: پویایی زمین",
  "title": "زمین‌لرزه و امواج لرزه‌ای",
  "position": 5,
  "start": 68,
  "end": 71
 },
 {
  "chapter": "فصل ۴: پویایی زمین",
  "title": "اندازه‌گیری، پیش‌بینی و ایمنی در برابر زمین‌لرزه",
  "position": 6,
  "start": 71,
  "end": 74
 },
 {
  "chapter": "فصل ۵: زمین‌شناسی و سلامت",
  "title": "زمین‌شناسی پزشکی و چرخه بیوژئوشیمیایی",
  "position": 1,
  "start": 78,
  "end": 79
 },
 {
  "chapter": "فصل ۵: زمین‌شناسی و سلامت",
  "title": "تقسیم‌بندی بیوشیمیایی عناصر",
  "position": 2,
  "start": 79,
  "end": 82
 },
 {
  "chapter": "فصل ۵: زمین‌شناسی و سلامت",
  "title": "منشأ بیماری‌های زمین‌زاد",
  "position": 3,
  "start": 82,
  "end": 88
 },
 {
  "chapter": "فصل ۵: زمین‌شناسی و سلامت",
  "title": "توفان‌های گردوغبار و ریزگردها",
  "position": 4,
  "start": 88,
  "end": 90
 },
 {
  "chapter": "فصل ۵: زمین‌شناسی و سلامت",
  "title": "کاربرد کانی‌ها در داروسازی و صنایع بهداشتی",
  "position": 5,
  "start": 90,
  "end": 90
 },
 {
  "chapter": "فصل ۶: زمین‌شناسی و سازه‌های مهندسی",
  "title": "مکان‌یابی سازه‌ها و عوامل مؤثر بر آن",
  "position": 1,
  "start": 94,
  "end": 100
 },
 {
  "chapter": "فصل ۶: زمین‌شناسی و سازه‌های مهندسی",
  "title": "مکان مناسب برای ساخت سد",
  "position": 2,
  "start": 101,
  "end": 102
 },
 {
  "chapter": "فصل ۶: زمین‌شناسی و سازه‌های مهندسی",
  "title": "مکان مناسب برای ساخت تونل و فضاهای زیرزمینی",
  "position": 3,
  "start": 102,
  "end": 103
 },
 {
  "chapter": "فصل ۶: زمین‌شناسی و سازه‌های مهندسی",
  "title": "مکان‌یابی سازه‌های دریایی",
  "position": 4,
  "start": 104,
  "end": 105
 },
 {
  "chapter": "فصل ۶: زمین‌شناسی و سازه‌های مهندسی",
  "title": "شاخص‌های مهندسی و مصالح موردنیاز سازه‌ها",
  "position": 5,
  "start": 105,
  "end": 107
 },
 {
  "chapter": "فصل ۷: زمین‌شناسی ایران",
  "title": "تاریخچه و نقشه‌های زمین‌شناسی ایران",
  "position": 1,
  "start": 110,
  "end": 112
 },
 {
  "chapter": "فصل ۷: زمین‌شناسی ایران",
  "title": "پهنه‌های زمین‌شناسی ایران",
  "position": 2,
  "start": 113,
  "end": 115
 },
 {
  "chapter": "فصل ۷: زمین‌شناسی ایران",
  "title": "منابع معدنی و ذخایر انرژی ایران",
  "position": 3,
  "start": 115,
  "end": 120
 },
 {
  "chapter": "فصل ۷: زمین‌شناسی ایران",
  "title": "گسل‌ها و آتشفشان‌های ایران",
  "position": 4,
  "start": 121,
  "end": 122
 },
 {
  "chapter": "فصل ۷: زمین‌شناسی ایران",
  "title": "زمین‌گردشگری و ژئوپارک",
  "position": 5,
  "start": 122,
  "end": 125
 }
]$pages$::jsonb)
 as p(chapter text,title text,position integer,start integer,"end" integer)),
 contexts(field,track) as (values ('experimental_sciences','konkur'),('experimental_sciences','final_exam'),('mathematics','final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from pages p cross join contexts c
where t.id=md5('nova:planner:1405:v1:'||c.field||':11:'||c.track||':زمین‌شناسی:'||p.chapter||':'||p.position)::uuid
 and t.edition='1405' and t.study_field=c.field and t.grade='11' and t.preparation_track=c.track
 and t.subject='زمین‌شناسی' and t.chapter=p.chapter and t.title=p.title and t.position=p.position
 and t.page_start is null and t.page_end is null and t.revision=1;

-- Add independently identified whole-chapter options without touching existing rows.
with chapters as (select * from jsonb_to_recordset($chapters$[
 {
  "chapter": "فصل ۱: آفرینش کیهان و تکوین زمین",
  "position": 101,
  "start": 9,
  "end": 21,
  "title": "کل فصل"
 },
 {
  "chapter": "فصل ۲: منابع معدنی و ذخایر انرژی، زیربنای تمدن و توسعه",
  "position": 101,
  "start": 23,
  "end": 39,
  "title": "کل فصل"
 },
 {
  "chapter": "فصل ۳: منابع آب و خاک",
  "position": 101,
  "start": 41,
  "end": 57,
  "title": "کل فصل"
 },
 {
  "chapter": "فصل ۴: پویایی زمین",
  "position": 101,
  "start": 59,
  "end": 75,
  "title": "کل فصل"
 },
 {
  "chapter": "فصل ۵: زمین‌شناسی و سلامت",
  "position": 101,
  "start": 77,
  "end": 91,
  "title": "کل فصل"
 },
 {
  "chapter": "فصل ۶: زمین‌شناسی و سازه‌های مهندسی",
  "position": 101,
  "start": 93,
  "end": 107,
  "title": "کل فصل"
 },
 {
  "chapter": "فصل ۷: زمین‌شناسی ایران",
  "position": 101,
  "start": 109,
  "end": 125,
  "title": "کل فصل"
 }
]$chapters$::jsonb)
 as p(chapter text,title text,position integer,start integer,"end" integer)),
 contexts(field,track) as (values ('experimental_sciences','konkur'),('experimental_sciences','final_exam'),('mathematics','final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v162:'||c.field||':11:'||c.track||':زمین‌شناسی:'||p.chapter||':'||p.position)::uuid,
 '1405',c.field,'11',c.track,'زمین‌شناسی',p.chapter,p.title,p.start,p."end",p.position
from chapters p cross join contexts c on conflict (id) do nothing;
