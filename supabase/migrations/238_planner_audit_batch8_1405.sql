-- Batch 8 audit (migration 238): books #71-79 checked against the user's 1405 PDFs.
-- Insert only. The installation marker prevents reinstating later administrator deletions.
-- New rows fill the gaps the audit found, all verified in the printed book text:
--  * زیست‌شناسی ۱ (code 110216): فصل ۱ گفتار ۳ «یاخته و بافت در بدن انسان» had only
--    one subtopic row (position 310 «غشای یاخته و سیتوپلاسم», 12-16) for five pages
--    carrying four named first-level subheadings. Added «هسته» (12-12),
--    «ورود مواد به یاخته و خروج از آن» (12-14: انتشار ساده/تسهیل‌شده، اسمز، انتقال
--    فعال) and «بافت‌های بدن انسان» (15-16: پوششی، پیوندی، ماهیچه‌ای، عصبی).
--    The old row 310 is left untouched; it overlaps the new rows, as گفتار and
--    whole-chapter rows already overlap subtopic rows throughout the bank.
--  * زیست‌شناسی ۲ (code 111216): فصل ۱ «مغز» (10-10: مخ، نیمکره‌ها، قشر مخ، لوب‌ها)
--    was named by no row (row 306 «دستگاه عصبی مرکزی» 9-10 and row 307
--    «ساختارهای دیگر مغز» 11-13 cover the pages but not the heading); فصل ۷
--    «لقاح» (108-108; row 309 «وقایع پس از لقاح» starts on 109); فصل ۸ «میوه»
--    (132-133: تشکیل میوه حقیقی/کاذب و پراکنش میوه‌ها; row 312 «رویش دانه»
--    131-133 names only germination). All three added.
--  * زیست‌شناسی ۳ (code 112216): فصل ۶ گفتار ۳ had one row (position 310
--    «فتوسنتز در شرایط دشوار», 86-88) for the two named mechanisms on pp.87-88.
--    Added «فتوسنتز در گیاهان C4» (87-87) and «فتوسنتز در گیاهان CAM» (87-88;
--    the CAM heading is at the foot of p.87, its comparison figure and activity
--    are on p.88; row 311 starts on 89).
--  * شیمی ۲ (code 111210): the appendix «جدول دوره‌ای عنصرها» (127-127, a full-page
--    periodic table; heading verified at 24pt on the rendered page) had no row.
--    Added under فصل ۳ (the last chapter), following the batch-3/batch-6 precedent
--    (periodic table added as a row for فیزیک ۳ and for علوم تجربی ۹, chapter =
--    the last chapter). The واژه‌نامه (124-126), منابع (126) and نظرسنجی (128)
--    are left without rows, as elsewhere.
--  * تفکر و سواد رسانه‌ای (code 110225): the end-of-book «بازبینه‌های ارزیابی»
--    (169-173: student self-assessment checklist for نوبت اول, parent checklist
--    for نوبت اول, student checklist for نوبت دوم, parent checklist for نوبت دوم)
--    had no row. Added one row under فصل ۶ (it directly follows درس ۲۰, the
--    last lesson of فصل ۶, pp.167-168); it is a book-level self-assessment
--    activity, not part of any single lesson.
-- No guarded page-fill (pattern B) applies: no pre-existing row for these nine
-- books has NULL pages (verified: 0 NULL-page rows across all nine books/combos).
-- Deliberately NOT added (documented in docs/planner-1405-audit/batch-8-evidence.md):
-- chapter/lesson title pages (covered by the کل فصل / کل درس / whole-lesson rows);
-- «بیشتر بدانیم»/«بیشتر بدانید» boxes (grouped inside their lesson/subtopic rows);
-- front matter (covers, imprints, مقدمه, فهرست, Map, Spotlight); back matter
-- (منابع، واژه‌نامه، جدول دوره‌ای عنصرها، نظرسنجی، اجزای بستۀ آموزشی، authors);
-- image-only photo/divider pages; the timeline labels on the تاریخ ۳ front-matter
-- timeline (printed p.-3, e.g. «انقلاب صنعتی» is a timeline label, not a heading).
-- Text-layer traps, recorded so they are not re-"fixed": PyMuPDF swaps ل/ا in the
-- «لا» ligature in several PDFs (تاریخ ۳ «انقلاب»→«انقالب», «اسلامی»→«اسالمی»;
-- شیمی ۲ «پالایش»→«پاالیش»; تفکر «اخلاق»→«اخالق»; زیست «تبادلات»→«تبادالت»),
-- and the شیمی ۲ font swaps other pairs («سوختن»→«سوخنت», «تمرین»→«مترین»,
-- «اتم»→«امت»); the زیست ۲/۳ imprint year extracts as ASCII «1504» but renders
-- as ۱۴۰۵. All verified against the rendered pages, not the text layer.
-- See docs/planner-1405-audit/batch-8-evidence.md for the per-book evidence.
with installed as (insert into private.planner_seed_installations(seed_key) values ('audit-batch8-1405-v238') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {"field": "experimental_sciences", "grade": "10", "subject": "زیست‌شناسی ۱", "chapter": "فصل ۱: دنیای زنده", "position": 3000, "title": "هسته", "start": 12, "end": 12, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "زیست‌شناسی ۱", "chapter": "فصل ۱: دنیای زنده", "position": 3001, "title": "ورود مواد به یاخته و خروج از آن", "start": 12, "end": 14, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "زیست‌شناسی ۱", "chapter": "فصل ۱: دنیای زنده", "position": 3002, "title": "بافت‌های بدن انسان", "start": 15, "end": 16, "konkur": true},
 {"field": "experimental_sciences", "grade": "11", "subject": "زیست‌شناسی ۲", "chapter": "فصل ۱: تنظیم عصبی", "position": 3000, "title": "مغز", "start": 10, "end": 10, "konkur": true},
 {"field": "experimental_sciences", "grade": "11", "subject": "زیست‌شناسی ۲", "chapter": "فصل ۷: تولید مثل", "position": 3000, "title": "لقاح", "start": 108, "end": 108, "konkur": true},
 {"field": "experimental_sciences", "grade": "11", "subject": "زیست‌شناسی ۲", "chapter": "فصل ۸: تولید مثل نهاندانگان", "position": 3000, "title": "میوه", "start": 132, "end": 133, "konkur": true},
 {"field": "experimental_sciences", "grade": "12", "subject": "زیست‌شناسی ۳", "chapter": "فصل ۶: از انرژی به ماده", "position": 3000, "title": "فتوسنتز در گیاهان C4", "start": 87, "end": 87, "konkur": true},
 {"field": "experimental_sciences", "grade": "12", "subject": "زیست‌شناسی ۳", "chapter": "فصل ۶: از انرژی به ماده", "position": 3001, "title": "فتوسنتز در گیاهان CAM", "start": 87, "end": 88, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "شیمی ۲", "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر", "position": 3000, "title": "جدول دوره‌ای عنصرها", "start": 127, "end": 127, "konkur": true},
 {"field": "experimental_sciences", "grade": "11", "subject": "شیمی ۲", "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر", "position": 3000, "title": "جدول دوره‌ای عنصرها", "start": 127, "end": 127, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "تفکر و سواد رسانه‌ای", "chapter": "فصل ۶: رژیم مصرف رسانه‌ای", "position": 3000, "title": "بازبینه‌های ارزیابی", "start": 169, "end": 173, "konkur": false},
 {"field": "experimental_sciences", "grade": "10", "subject": "تفکر و سواد رسانه‌ای", "chapter": "فصل ۶: رژیم مصرف رسانه‌ای", "position": 3000, "title": "بازبینه‌های ارزیابی", "start": 169, "end": 173, "konkur": false},
 {"field": "humanities", "grade": "10", "subject": "تفکر و سواد رسانه‌ای", "chapter": "فصل ۶: رژیم مصرف رسانه‌ای", "position": 3000, "title": "بازبینه‌های ارزیابی", "start": 169, "end": 173, "konkur": false}
]$topics$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,start integer,"end" integer,konkur boolean)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v238:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed where p.konkur or r.track='final_exam' on conflict(id) do nothing;
