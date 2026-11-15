-- Verified printed pages for the original unedited seeded topics, not published plans.
-- The original id, context, title, order, null pages and revision protect admin edits.
with data as (select * from jsonb_to_recordset($pages$[
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: کنش‌های ما",
  "title": "کنش و کنشگر",
  "position": 1,
  "start": 2,
  "end": 2
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: کنش‌های ما",
  "title": "آگاهی، اراده و هدف در کنش",
  "position": 2,
  "start": 3,
  "end": 4
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: کنش‌های ما",
  "title": "آثار و پیامدهای کنش",
  "position": 3,
  "start": 5,
  "end": 6
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: کنش‌های ما",
  "title": "ویژگی‌های کنش آگاهانه، ارادی و هدف‌دار",
  "position": 201,
  "start": 3,
  "end": 4
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: کنش‌های ما",
  "title": "پیامدهای ارادی و غیرارادی کنش",
  "position": 202,
  "start": 5,
  "end": 6
 },
 {
  "generation": "v155",
  "subject": "کارگاه کارآفرینی و تولید",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۱: تعریف تیم و مراحل تشکیل و توسعه",
  "position": 101,
  "start": 1,
  "end": 1
 },
 {
  "generation": "v155",
  "subject": "کارگاه کارآفرینی و تولید",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۱: تفاوت تیم و گروه و ویژگی‌های راهنما",
  "position": 102,
  "start": 2,
  "end": 3
 },
 {
  "generation": "v155",
  "subject": "کارگاه کارآفرینی و تولید",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۱: بازی تیمی برج روزنامه",
  "position": 103,
  "start": 4,
  "end": 4
 },
 {
  "generation": "v155",
  "subject": "کارگاه کارآفرینی و تولید",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۲: عوامل موفقیت کار تیمی",
  "position": 104,
  "start": 5,
  "end": 6
 },
 {
  "generation": "v155",
  "subject": "کارگاه کارآفرینی و تولید",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۲: بوم کار تیمی و تهیه روزنامه دیواری",
  "position": 105,
  "start": 6,
  "end": 8
 },
 {
  "generation": "v155",
  "subject": "کارگاه کارآفرینی و تولید",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۳: موانع کار تیمی اثربخش",
  "position": 106,
  "start": 9,
  "end": 10
 },
 {
  "generation": "v155",
  "subject": "کارگاه کارآفرینی و تولید",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۳: مرحله طوفان و راهکارهای تقویت تیم",
  "position": 107,
  "start": 11,
  "end": 12
 },
 {
  "generation": "v155",
  "subject": "کارگاه کارآفرینی و تولید",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۴: مسئله‌یابی و مراحل حل مسئله",
  "position": 108,
  "start": 13,
  "end": 14
 },
 {
  "generation": "v155",
  "subject": "کارگاه کارآفرینی و تولید",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "بخش‌های ۱ تا ۴",
  "title": "بخش ۴: اصلاح الگوی مصرف",
  "position": 109,
  "start": 15,
  "end": 16
 },
 {
  "generation": "v155",
  "subject": "کارگاه کارآفرینی و تولید",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۵: هدف‌گذاری مؤثر",
  "position": 101,
  "start": 17,
  "end": 18
 },
 {
  "generation": "v155",
  "subject": "کارگاه کارآفرینی و تولید",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۵: فرایند تصمیم‌گیری",
  "position": 102,
  "start": 19,
  "end": 20
 },
 {
  "generation": "v1",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۳: انقلاب اسلامی",
  "position": 1,
  "start": 20,
  "end": 25
 },
 {
  "generation": "v1",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۴: آشنایی با بسیج",
  "position": 2,
  "start": 26,
  "end": 31
 },
 {
  "generation": "v1",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۳: امداد و نجات",
  "position": 4,
  "start": 146,
  "end": 158
 }
]$pages$::jsonb)
 as p(generation text,subject text,grade text,fields jsonb,chapter text,title text,position integer,start integer,"end" integer)), expanded as (
 select p.*,f.field from data p cross join lateral jsonb_array_elements_text(p.fields) f(field)
)
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from expanded p
where t.id=md5('nova:planner:1405:'||p.generation||':'||p.field||':'||p.grade||':final_exam:'||p.subject||':'||p.chapter||':'||p.position)::uuid
 and t.edition='1405' and t.study_field=p.field and t.grade=p.grade and t.preparation_track='final_exam'
 and t.subject=p.subject and t.chapter=p.chapter and t.title=p.title and t.position=p.position
 and t.page_start is null and t.page_end is null and t.revision=1;

-- Conflicting 1405 copies disagree on lesson nine's start. Clear only the exact
-- unedited v154 range rather than serving an unverified default. A CAS revision
-- bump protects concurrent admin edits and repeated runs are no-ops.
with fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
update private.planner_topic_bank t set page_start=null,page_end=null,revision=t.revision+1,updated_at=now()
from fields f
where t.id=md5('nova:planner:1405:v1:'||f.field||':10:final_exam:آمادگی دفاعی:فصل ۳: دفاع نظامی:3')::uuid
 and t.edition='1405' and t.study_field=f.field and t.grade='10' and t.preparation_track='final_exam'
 and t.subject='آمادگی دفاعی' and t.chapter='فصل ۳: دفاع نظامی' and t.title='درس ۹: جنگ‌افزارشناسی و اصول تیراندازی'
 and t.position=3 and t.page_start=78 and t.page_end=116 and t.revision=1;
