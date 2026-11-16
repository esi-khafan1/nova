-- Batch 4 audit (migration 234): books #31-40 checked against the user's 1405 PDFs.
-- Insert only. The installation marker prevents reinstating later administrator deletions.
-- New rows fill the gaps the audit found: end-of-lesson exercise (تمرین) blocks that
-- migration 199 left without a row (حسابان ۱ فصل ۱/۲/۳, حسابان ۲ فصل ۴/۵, گسسته همه فصل‌ها),
-- the two missing exposition (شرح) rows for حسابان ۱ فصل ۳ درس ۱/۲, back matter
-- (واژه‌نامه/فهرست منابع/منابع) for فیزیک ۲ (هر دو نسخه), گسسته, هندسه ۲/۳, حسابان ۱/۲ and
-- جامعه‌شناسی ۲/۳, chapter/part openers and اهداف pages for جامعه‌شناسی ۲ (چهار فصل) and
-- اهداف کتاب for جامعه‌شناسی ۳.
-- Corrected-page supersedes (old rows left untouched, migration 161 precedent): the
-- 196 finer rows for توزیع بار/آزمایش فاراده (فیزیک ۲ ریاضی), ترمیستور/مقاومت نوری and
-- بستن متوالی مقاومت‌ها (فیزیک ۲ تجربی), and eight 203 هندسه ۲ rows whose section
-- headings start one page before the seeded start (فصل ۱: وضعیت خط و دایره ۱۰–۱۱,
-- وتر/قطر/زاویه ۱۱–۱۲, اندازه زاویه ظلی ۱۴–۱۵, چهارضلعی محیطی ۲۷–۲۸; فصل ۲: بازتاب
-- ۳۵–۳۸, انتقال ۳۸–۳۹, تجانس ۴۳–۴۵, تبدیل همانی ۴۷–۴۹).
-- Deliberately NOT changed: the جامعه‌شناسی ۲ درس ۱۵ v1 row «انقلاب اسلامی در مقایسه
-- با انقلاب‌های قرن بیستم» (both tracks) stays NULL — its comparison text is in درس ۱۴,
-- where the correct row «مقایسه انقلاب اسلامی و انقلاب‌های آزادی‌بخش» (120-123) already
-- exists. The هندسه ۲ catalog chapter «فصل ۴: تجسم فضایی» is NOT in the PDF (only three
-- chapters); no content is invented for it and the catalog chapter is not deleted.
-- No guarded page-fill (pattern B) applies: every other pre-existing row for these
-- books already has pages (205 of 206 v1 titles were page-filled by migrations
-- 194/195/199/203/204; the one exception is the deliberate sociology row above).
-- هندسه ۱ needs no new row: all four chapters, lessons and subtopics already have
-- page-numbered rows and the book has no back matter.

with installed as (insert into private.planner_seed_installations(seed_key) values ('audit-batch4-1405-v234') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {"field": "mathematics", "grade": "11", "subject": "فیزیک ۲", "chapter": "فصل ۱: الکتریسیته ساکن", "position": 3000, "title": "توزیع بار در رسانا و آزمایش فاراده", "start": 27, "end": 28, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "فیزیک ۲", "chapter": "فصل ۴: القای الکترومغناطیسی و جریان متناوب", "position": 3000, "title": "واژه‌نامه فارسی–انگلیسی", "start": 132, "end": 133, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "فیزیک ۲", "chapter": "فصل ۴: القای الکترومغناطیسی و جریان متناوب", "position": 3001, "title": "فهرست منابع", "start": 134, "end": 135, "konkur": true},
 {"field": "experimental_sciences", "grade": "11", "subject": "فیزیک ۲", "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم", "position": 3000, "title": "ترمیستور و مقاومت نوری", "start": 48, "end": 49, "konkur": true},
 {"field": "experimental_sciences", "grade": "11", "subject": "فیزیک ۲", "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم", "position": 3001, "title": "بستن متوالی مقاومت‌ها", "start": 56, "end": 57, "konkur": true},
 {"field": "experimental_sciences", "grade": "11", "subject": "فیزیک ۲", "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی", "position": 3000, "title": "واژه‌نامه فارسی–انگلیسی", "start": 106, "end": 107, "konkur": true},
 {"field": "experimental_sciences", "grade": "11", "subject": "فیزیک ۲", "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی", "position": 3001, "title": "فهرست منابع", "start": 108, "end": 109, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "ریاضیات گسسته", "chapter": "فصل ۱: آشنایی با نظریه اعداد", "position": 3000, "title": "تمرین استدلال ریاضی", "start": 8, "end": 8, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "ریاضیات گسسته", "chapter": "فصل ۱: آشنایی با نظریه اعداد", "position": 3001, "title": "تمرین بخش‌پذیری در اعداد صحیح", "start": 16, "end": 17, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "ریاضیات گسسته", "chapter": "فصل ۱: آشنایی با نظریه اعداد", "position": 3002, "title": "تمرین هم‌نهشتی در اعداد صحیح و کاربردها", "start": 29, "end": 30, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "ریاضیات گسسته", "chapter": "فصل ۲: گراف و مدل‌سازی", "position": 3000, "title": "تمرین معرفی گراف", "start": 41, "end": 42, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "ریاضیات گسسته", "chapter": "فصل ۲: گراف و مدل‌سازی", "position": 3001, "title": "تمرین مدل‌سازی با گراف", "start": 52, "end": 54, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "ریاضیات گسسته", "chapter": "فصل ۳: ترکیبیات", "position": 3000, "title": "تمرین مباحثی در ترکیبیات", "start": 71, "end": 72, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "ریاضیات گسسته", "chapter": "فصل ۳: ترکیبیات", "position": 3001, "title": "تمرین روش‌هایی برای شمارش", "start": 83, "end": 84, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "ریاضیات گسسته", "chapter": "فصل ۳: ترکیبیات", "position": 3002, "title": "منابع", "start": 85, "end": 85, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "هندسه ۳", "chapter": "فصل ۳: بردارها", "position": 3000, "title": "منابع", "start": 87, "end": 87, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "هندسه ۲", "chapter": "فصل ۱: دایره", "position": 3000, "title": "وضعیت خط و دایره", "start": 10, "end": 11, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "هندسه ۲", "chapter": "فصل ۱: دایره", "position": 3001, "title": "وتر، قطر، زاویه مرکزی و محاطی و کمان", "start": 11, "end": 12, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "هندسه ۲", "chapter": "فصل ۱: دایره", "position": 3002, "title": "اندازه زاویه ظلی", "start": 14, "end": 15, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "هندسه ۲", "chapter": "فصل ۱: دایره", "position": 3003, "title": "چهارضلعی محیطی", "start": 27, "end": 28, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "هندسه ۲", "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها", "position": 3000, "title": "بازتاب و نقطه ثابت", "start": 35, "end": 38, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "هندسه ۲", "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها", "position": 3001, "title": "انتقال با بردار", "start": 38, "end": 39, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "هندسه ۲", "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها", "position": 3002, "title": "تجانس و نسبت تجانس", "start": 43, "end": 45, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "هندسه ۲", "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها", "position": 3003, "title": "تبدیل همانی", "start": 47, "end": 49, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "هندسه ۲", "chapter": "فصل ۳: روابط طولی در مثلث", "position": 3000, "title": "منابع", "start": 76, "end": 77, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۱: جبر و معادله", "position": 3000, "title": "تمرین مجموع جملات دنباله‌های حسابی و هندسی", "start": 6, "end": 6, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۱: جبر و معادله", "position": 3001, "title": "تمرین معادلات درجه دوم", "start": 15, "end": 16, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۱: جبر و معادله", "position": 3002, "title": "تمرین معادلات گویا و گنگ", "start": 22, "end": 22, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۱: جبر و معادله", "position": 3003, "title": "تمرین قدر مطلق", "start": 28, "end": 28, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۱: جبر و معادله", "position": 3004, "title": "تمرین آشنایی با هندسه تحلیلی", "start": 35, "end": 36, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۲: تابع", "position": 3000, "title": "تمرین وارون تابع", "start": 62, "end": 62, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۲: تابع", "position": 3001, "title": "تمرین اعمال روی توابع", "start": 69, "end": 70, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۳: توابع نمایی و لگاریتمی", "position": 3000, "title": "شرح: تابع نمایی", "start": 72, "end": 76, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۳: توابع نمایی و لگاریتمی", "position": 3001, "title": "تمرین تابع نمایی", "start": 77, "end": 79, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۳: توابع نمایی و لگاریتمی", "position": 3002, "title": "شرح: تابع لگاریتمی و لگاریتم", "start": 80, "end": 84, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۳: توابع نمایی و لگاریتمی", "position": 3003, "title": "تمرین تابع لگاریتمی و لگاریتم", "start": 85, "end": 85, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۳: توابع نمایی و لگاریتمی", "position": 3004, "title": "تمرین ویژگی‌های لگاریتم و حل معادله‌های لگاریتمی", "start": 90, "end": 90, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "حسابان ۱", "chapter": "فصل ۵: حد و پیوستگی", "position": 3000, "title": "منابع", "start": 152, "end": 153, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "حسابان ۲", "chapter": "فصل ۴: مشتق", "position": 3000, "title": "تمرین آشنایی با مفهوم مشتق", "start": 81, "end": 83, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "حسابان ۲", "chapter": "فصل ۴: مشتق", "position": 3001, "title": "تمرین مشتق‌پذیری و پیوستگی", "start": 99, "end": 101, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "حسابان ۲", "chapter": "فصل ۴: مشتق", "position": 3002, "title": "تمرین آهنگ متوسط تغییر و آهنگ لحظه‌ای تغییر", "start": 108, "end": 110, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "حسابان ۲", "chapter": "فصل ۵: کاربردهای مشتق", "position": 3000, "title": "تمرین اکسترمم‌های یک تابع و توابع صعودی و نزولی", "start": 125, "end": 126, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "حسابان ۲", "chapter": "فصل ۵: کاربردهای مشتق", "position": 3001, "title": "تمرین جهت تقعر نمودار یک تابع و نقطه عطف آن", "start": 136, "end": 136, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "حسابان ۲", "chapter": "فصل ۵: کاربردهای مشتق", "position": 3002, "title": "تمرین رسم نمودار تابع", "start": 144, "end": 144, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "حسابان ۲", "chapter": "فصل ۵: کاربردهای مشتق", "position": 3003, "title": "منابع", "start": 145, "end": 145, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "جامعه‌شناسی ۳", "chapter": "درس ۱", "position": 3000, "title": "اهداف کتاب", "start": 1, "end": 1, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "جامعه‌شناسی ۳", "chapter": "درس ۱۰", "position": 3000, "title": "منابع", "start": 116, "end": 119, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "جامعه‌شناسی ۲", "chapter": "درس ۱", "position": 3000, "title": "آغاز فصل اوّل: فرهنگ جهانی", "start": 1, "end": 1, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "جامعه‌شناسی ۲", "chapter": "درس ۱", "position": 3001, "title": "اهداف فصل اوّل", "start": 2, "end": 2, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "جامعه‌شناسی ۲", "chapter": "درس ۵", "position": 3000, "title": "آغاز فصل دوم: فرهنگ معاصر غرب", "start": 35, "end": 35, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "جامعه‌شناسی ۲", "chapter": "درس ۵", "position": 3001, "title": "اهداف فصل دوم", "start": 36, "end": 36, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "جامعه‌شناسی ۲", "chapter": "درس ۹", "position": 3000, "title": "آغاز فصل سوم: چالش‌های جهانی", "start": 73, "end": 73, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "جامعه‌شناسی ۲", "chapter": "درس ۹", "position": 3001, "title": "اهداف فصل سوم", "start": 74, "end": 74, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "جامعه‌شناسی ۲", "chapter": "درس ۱۳", "position": 3000, "title": "آغاز فصل چهارم: بیداری اسلامی", "start": 105, "end": 105, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "جامعه‌شناسی ۲", "chapter": "درس ۱۳", "position": 3001, "title": "اهداف فصل چهارم", "start": 106, "end": 106, "konkur": true},
 {"field": "humanities", "grade": "11", "subject": "جامعه‌شناسی ۲", "chapter": "درس ۱۵", "position": 3000, "title": "منابع", "start": 137, "end": 138, "konkur": true}
]$topics$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,start integer,"end" integer,konkur boolean)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v234:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed where p.konkur or r.track='final_exam' on conflict(id) do nothing;
