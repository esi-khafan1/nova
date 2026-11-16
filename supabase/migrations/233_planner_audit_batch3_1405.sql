-- Batch 3 audit (migration 233): books #21-30 checked against the user's 1405 PDFs.
-- Insert only. The installation marker prevents reinstating later administrator deletions.
-- New rows fill the gaps the audit found: philosophy 2 part-introductions and two
-- end-of-lesson further-reading pages; culture-and-art 9 illustrated chapter openers
-- and prose introductions; Persian 10/11/12 and Persian 9 back matter (ketabnameh);
-- physics 1/3 reference appendices (glossary, sources, periodic and trig tables).
-- No guarded page-fill (pattern B) applies: no pre-existing row for these books has
-- NULL pages. The Persian 11 ketabnameh row from migration 190 (167-167) is left
-- untouched and superseded by the corrected 167-168 row below (migration 161 precedent).
with installed as (insert into private.planner_seed_installations(seed_key) values ('audit-batch3-1405-v233') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {"field": "humanities", "grade": "12", "subject": "فلسفه ۲", "chapter": "درس ۱", "position": 3000, "title": "مقدمه بخش اول: پیرامون واقعیت و هستی", "start": 1, "end": 1, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "فلسفه ۲", "chapter": "درس ۵", "position": 3000, "title": "مقدمه بخش دوم: پیرامون خدا و عقل", "start": 29, "end": 29, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "فلسفه ۲", "chapter": "درس ۶", "position": 3000, "title": "مطالعه بیشتر: منابع درس ششم", "start": 51, "end": 51, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "فلسفه ۲", "chapter": "درس ۸", "position": 3000, "title": "مطالعه بیشتر: منابع درس هشتم", "start": 68, "end": 68, "konkur": true},
 {"field": "humanities", "grade": "12", "subject": "فلسفه ۲", "chapter": "درس ۹", "position": 3000, "title": "مقدمه بخش سوم: نگاهی اجمالی به سیر فلسفه در جهان اسلام", "start": 69, "end": 69, "konkur": true},
 {"field": "all", "grade": "9", "subject": "فرهنگ و هنر", "chapter": "هنرهای تجسمی ـ طراحی ـ درس ۱: فضا و عمق", "position": 3000, "title": "آغاز فصل اول: طراحی", "start": 2, "end": 2, "konkur": false},
 {"field": "all", "grade": "9", "subject": "فرهنگ و هنر", "chapter": "هنرهای تجسمی ـ نگاشتار ـ درس ۱: نگاشتار و تبلیغات", "position": 3000, "title": "آغاز فصل دوم: نگاشتار (گرافیک)", "start": 38, "end": 38, "konkur": false},
 {"field": "all", "grade": "9", "subject": "فرهنگ و هنر", "chapter": "هنرهای تجسمی ـ عکاسی ـ درس ۱: عکس‌های ترکیبی", "position": 3000, "title": "آغاز فصل سوم: عکاسی", "start": 56, "end": 56, "konkur": false},
 {"field": "all", "grade": "9", "subject": "فرهنگ و هنر", "chapter": "خوشنویسی ـ درس ۱: تراشیدن قلم و قالب‌های اجرایی خوشنویسی", "position": 3000, "title": "مقدمه خوشنویسی", "start": 73, "end": 73, "konkur": false},
 {"field": "all", "grade": "9", "subject": "فرهنگ و هنر", "chapter": "هنرهای سنتی ـ نقوش تزیینی ـ درس ۱: چهارلنگه", "position": 3000, "title": "مقدمه طراحی نقوش تزیینی", "start": 106, "end": 106, "konkur": false},
 {"field": "all", "grade": "9", "subject": "فرهنگ و هنر", "chapter": "هنرهای سنتی ـ نقوش تزیینی ـ درس ۱: چهارلنگه", "position": 3001, "title": "آغاز فصل اول: طراحی نقوش تزیینی", "start": 107, "end": 107, "konkur": false},
 {"field": "all", "grade": "9", "subject": "فرهنگ و هنر", "chapter": "هنرهای سنتی ـ زیرلاکی ـ درس ۱: جلدسازی سنتی با لایه‌های کاغذ", "position": 3000, "title": "آغاز فصل دوم: هنرهای زیرلاکی", "start": 120, "end": 120, "konkur": false},
 {"field": "all", "grade": "9", "subject": "فرهنگ و هنر", "chapter": "هنرهای سنتی ـ سوزن‌دوزی ـ درس ۱: درویش‌دوزی", "position": 3000, "title": "آغاز فصل سوم: سوزن‌دوزی‌های سنتی ایران", "start": 134, "end": 134, "konkur": false},
 {"field": "all", "grade": "9", "subject": "فرهنگ و هنر", "chapter": "هنرهای سنتی ـ سوزن‌دوزی ـ درس ۱: درویش‌دوزی", "position": 3001, "title": "مقدمه سوزن‌دوزی‌های سنتی ایران", "start": 135, "end": 135, "konkur": false},
 {"field": "all", "grade": "9", "subject": "فرهنگ و هنر", "chapter": "هنرهای آوایی ـ درس ۱: آواهای قومی", "position": 3000, "title": "مقدمه هنرهای آوایی", "start": 150, "end": 150, "konkur": false},
 {"field": "all", "grade": "9", "subject": "فرهنگ و هنر", "chapter": "هنرهای نمایشی ـ درس ۳: حرکت و چیدمان روی صحنه", "position": 3000, "title": "واژه‌نامه", "start": 185, "end": 186, "konkur": false},
 {"field": "mathematics", "grade": "10", "subject": "فارسی ۱", "chapter": "فصل ۸: ادبیات جهان", "position": 3000, "title": "کتابنامه", "start": 164, "end": 168, "konkur": false},
 {"field": "humanities", "grade": "10", "subject": "فارسی ۱", "chapter": "فصل ۸: ادبیات جهان", "position": 3000, "title": "کتابنامه", "start": 164, "end": 168, "konkur": false},
 {"field": "experimental_sciences", "grade": "10", "subject": "فارسی ۱", "chapter": "فصل ۸: ادبیات جهان", "position": 3000, "title": "کتابنامه", "start": 164, "end": 168, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "فارسی ۲", "chapter": "فصل ۸: ادبیات جهان", "position": 3000, "title": "کتابنامه", "start": 167, "end": 168, "konkur": false},
 {"field": "humanities", "grade": "11", "subject": "فارسی ۲", "chapter": "فصل ۸: ادبیات جهان", "position": 3000, "title": "کتابنامه", "start": 167, "end": 168, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "فارسی ۲", "chapter": "فصل ۸: ادبیات جهان", "position": 3000, "title": "کتابنامه", "start": 167, "end": 168, "konkur": false},
 {"field": "all", "grade": "9", "subject": "فارسی", "chapter": "پیوست‌های کتاب", "position": 3000, "title": "کتابنامه", "start": 158, "end": 160, "konkur": false},
 {"field": "mathematics", "grade": "10", "subject": "فیزیک ۱", "chapter": "فصل ۵: ترمودینامیک", "position": 3000, "title": "واژه‌نامه فارسی–انگلیسی", "start": 150, "end": 151, "konkur": true},
 {"field": "mathematics", "grade": "10", "subject": "فیزیک ۱", "chapter": "فصل ۵: ترمودینامیک", "position": 3001, "title": "فهرست منابع", "start": 152, "end": 152, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "فیزیک ۱", "chapter": "فصل ۴: دما و گرما", "position": 3000, "title": "واژه‌نامه فارسی–انگلیسی", "start": 121, "end": 123, "konkur": true},
 {"field": "experimental_sciences", "grade": "10", "subject": "فیزیک ۱", "chapter": "فصل ۴: دما و گرما", "position": 3001, "title": "فهرست منابع", "start": 124, "end": 125, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "فیزیک ۳", "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای", "position": 3000, "title": "جدول دوره‌ای عناصر", "start": 157, "end": 157, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "فیزیک ۳", "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای", "position": 3001, "title": "جدول مثلثاتی", "start": 158, "end": 158, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "فیزیک ۳", "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای", "position": 3002, "title": "واژه‌نامه فارسی–انگلیسی", "start": 159, "end": 163, "konkur": true},
 {"field": "mathematics", "grade": "12", "subject": "فیزیک ۳", "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای", "position": 3003, "title": "فهرست منابع", "start": 164, "end": 165, "konkur": true},
 {"field": "experimental_sciences", "grade": "12", "subject": "فیزیک ۳", "chapter": "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای", "position": 3000, "title": "جدول دوره‌ای عناصر", "start": 126, "end": 126, "konkur": true},
 {"field": "experimental_sciences", "grade": "12", "subject": "فیزیک ۳", "chapter": "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای", "position": 3001, "title": "جدول مثلثاتی", "start": 127, "end": 127, "konkur": true},
 {"field": "experimental_sciences", "grade": "12", "subject": "فیزیک ۳", "chapter": "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای", "position": 3002, "title": "واژه‌نامه فارسی–انگلیسی", "start": 128, "end": 131, "konkur": true},
 {"field": "experimental_sciences", "grade": "12", "subject": "فیزیک ۳", "chapter": "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای", "position": 3003, "title": "فهرست منابع", "start": 132, "end": 133, "konkur": true}
]$topics$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,start integer,"end" integer,konkur boolean)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v233:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed where p.konkur or r.track='final_exam' on conflict(id) do nothing;
