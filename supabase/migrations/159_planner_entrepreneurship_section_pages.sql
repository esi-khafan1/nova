-- Whole section boundaries from the 1405 printed contents, cross-checked against
-- the legible 1403 contents to disambiguate OCR glyphs. Only the original v1
-- untouched seed row is updated. Granular topics are not assigned these spans.
with pages as (select * from jsonb_to_recordset($pages$[
 {
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۶: خودشناسی",
  "position": 2,
  "page_start": 21,
  "page_end": 26
 },
 {
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۷: طراحی مسیر شغلی: کارگاه توسعه شخصی",
  "position": 3,
  "page_start": 27,
  "page_end": 30
 },
 {
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۸: طراحی مسیر شغلی: شناسایی ارزش‌ها و نیازها",
  "position": 4,
  "page_start": 31,
  "page_end": 34
 },
 {
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۹: طراحی مسیر شغلی: شناسایی مهارت‌ها، استعدادها و علایق",
  "position": 5,
  "page_start": 35,
  "page_end": 40
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۰: تفکر",
  "position": 1,
  "page_start": 41,
  "page_end": 46
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۱: تفکر خلاق (واگرا)",
  "position": 2,
  "page_start": 47,
  "page_end": 50
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۲: توسعه خلاقیت فردی",
  "position": 3,
  "page_start": 51,
  "page_end": 54
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۳: توسعه خلاقیت تیمی",
  "position": 4,
  "page_start": 55,
  "page_end": 58
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۴: تشخیص فرصت، ایده‌پردازی و ارزیابی ایده",
  "position": 5,
  "page_start": 59,
  "page_end": 64
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۵: ایده‌یابی، ساختن ایده و الگوبرداری",
  "position": 6,
  "page_start": 65,
  "page_end": 68
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۶: نوآوری و تریز",
  "position": 7,
  "page_start": 69,
  "page_end": 74
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۷: سنجش کارآفرینی",
  "position": 8,
  "page_start": 75,
  "page_end": 78
 }
]$pages$::jsonb)
 as p(chapter text,title text,position integer,page_start integer,page_end integer)),
 fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
update private.planner_topic_bank t
set page_start=p.page_start,page_end=p.page_end,revision=t.revision+1,updated_at=now()
from pages p cross join fields f
where t.id=md5('nova:planner:1405:v1:'||f.field||':10:final_exam:کارگاه کارآفرینی و تولید:'||p.chapter||':'||p.position)::uuid
 and t.edition='1405' and t.study_field=f.field and t.grade='10' and t.preparation_track='final_exam'
 and t.subject='کارگاه کارآفرینی و تولید' and t.chapter=p.chapter and t.title=p.title and t.position=p.position
 and t.page_start is null and t.page_end is null and t.revision=1;
