-- The 1405 print contents verifies whole-lesson ranges in social identity.
-- The title denotes the full lesson, not a guessed subsection.
with lessons as (select * from jsonb_to_recordset($lessons$[
 {
  "chapter": "درس ۱: کنش‌های ما",
  "start": 2,
  "end": 7
 },
 {
  "chapter": "درس ۲: پدیده‌های اجتماعی",
  "start": 8,
  "end": 16
 },
 {
  "chapter": "درس ۳: جامعه و فرهنگ",
  "start": 17,
  "end": 24
 },
 {
  "chapter": "درس ۴: ارزیابی فرهنگ‌ها",
  "start": 25,
  "end": 33
 },
 {
  "chapter": "درس ۵: هویت",
  "start": 34,
  "end": 43
 },
 {
  "chapter": "درس ۶: بازتولید هویت اجتماعی",
  "start": 44,
  "end": 52
 },
 {
  "chapter": "درس ۷: تحولات هویتی جامعه",
  "start": 53,
  "end": 61
 },
 {
  "chapter": "درس ۸: بعد فرهنگی هویت ایران",
  "start": 62,
  "end": 71
 },
 {
  "chapter": "درس ۹: بعد سیاسی هویت ایران",
  "start": 72,
  "end": 82
 },
 {
  "chapter": "درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران",
  "start": 83,
  "end": 91
 }
]$lessons$::jsonb) as x(chapter text, start integer, "end" integer)),
fields(field) as (values ('mathematics'),('experimental_sciences'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v157:social-full:'||f.field||':'||l.chapter)::uuid,
 '1405',f.field,'12','final_exam','علوم اجتماعی',l.chapter,'کل درس',l.start,l."end",0
from lessons l cross join fields f
on conflict (id) do nothing;

-- Enrich only the exact unedited v154 entries; increment revision so concurrent
-- admin saves fail their CAS rather than silently overwriting the new ranges.
with parts as (select * from jsonb_to_recordset($parts$[
 {
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۱: تشکیل تیم",
  "position": 1,
  "start": 1,
  "end": 4
 },
 {
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۲: کار تیمی موفق",
  "position": 2,
  "start": 5,
  "end": 8
 },
 {
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۳: تقویت کار تیمی",
  "position": 3,
  "start": 9,
  "end": 12
 },
 {
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۴: حل مسئله",
  "position": 4,
  "start": 13,
  "end": 16
 },
 {
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۵: هدف‌گذاری و تصمیم‌گیری",
  "position": 1,
  "start": 17,
  "end": 20
 }
]$parts$::jsonb) as x(chapter text,title text,position integer,start integer,"end" integer)),
fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
update private.planner_topic_bank t
set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from parts p cross join fields f
where t.id=md5('nova:planner:1405:v1:' || f.field || ':10:final_exam:کارگاه کارآفرینی و تولید:' || p.chapter || ':' || p.position)::uuid
 and t.edition='1405' and t.study_field=f.field and t.grade='10' and t.preparation_track='final_exam'
 and t.subject='کارگاه کارآفرینی و تولید' and t.chapter=p.chapter and t.title=p.title and t.position=p.position
 and t.revision=1 and t.page_start is null and t.page_end is null;
