-- Follow-up item 3: مطالعات اجتماعی ۹ — the 18 کاربرگه worksheets as selectable
-- topics WITHOUT printed page numbers (never invented). Insert only.
--
-- Verified against motaleat-ejtemai-9-907-1405.pdf (SHA-256
-- 4355abb0eff6f06de3e3274a024a9566c757903f65f2e133caa6658f029d93e3,
-- 200 PDF pages, code 907, چاپ دوازدهم ۱۴۰۵; offset printed = PDF − 6):
-- the book's printed pagination ends at p.170 (PDF p.176, the «واژه‌ها» page
-- of درس ۲۴). PDF p.177 is the «کاربرگۀ فعّالیت» section cover; the 18
-- numbered worksheets run PDF pp.178–198 and carry NO printed page-number
-- footer on any page, so page_start/page_end are NULL by design. PDF p.199
-- is a foreign-words glossary table and PDF p.200 the back-cover quotation —
-- neither is a worksheet.
--
-- Worksheet list (number, title as printed, lesson, PDF page(s)) — each
-- re-verified against the PDF text; see docs/planner-1405-audit/followup-3-evidence.md:
--  1  طول و عرض جغرافیایی — درس ۱ — PDF p.178
--  2  طول و عرض جغرافیایی بر روی نقشه — درس ۱ — PDF p.179
--  3  انواع ناهمواری‌ها — درس ۳ — PDF p.180
--  4  رابطه پراکندگی زیست‌بوم‌های جهان با عرض جغرافیایی و بارش — درس ۵ — PDF p.181
--  5  زیست‌بوم‌های جهان — درس ۵ — PDF p.182
--  6  شگفتی‌های آفریقا — درس ۵ — PDF p.183
--  7  نقشه سیاسی ایران در آستانه تأسیس حکومت صفویه — درس ۹ — PDF pp.184–185
--  8  اداره شهرها و روستاها در عصر صفوی — درس ۱۰ — PDF p.186
--  9  جدایی سرزمین‌های ایرانی در دوره قاجار — درس ۱۱ — PDF p.187
-- 10  زمینه‌ها و عوامل نهضت مشروطه — درس ۱۳ — PDF p.188
-- 11  سخن امام درباره قرآن و روحانیت — درس ۱۵ — PDF p.189
-- 12  رویدادهای مهم انقلاب اسلامی در سال ۱۳۵۷ — درس ۱۵ — PDF p.190
-- 13  لایه‌های فرهنگ — درس ۱۷ — PDF pp.191–193
-- 14  سازگاری والدین و فرزندان — درس ۲۰ — PDF p.194
-- 15  سازگاری والدین و فرزندان — درس ۲۰ — PDF p.195
--     (14 and 15 share the book's own heading; different exercises, different
--     positions — the کاربرگه number in the title distinguishes them.)
-- 16  حقوق و تکالیف شهروندی — درس ۲۲ — PDF p.196
-- 17  بهره‌وری — درس ۲۳ — PDF p.197
-- 18  حل مسئله — درس ۲۴ — PDF p.198
--
-- Chapter «کاربرگه‌ها» is the page-less-by-design flag: every row in this
-- chapter has NULL pages, and no other chapter may gain NULL-page rows from
-- this migration. Combo: grade 9 / field all / track final_exam only
-- (grade-9 rule; no رشته, no konkur).
--
-- The installation marker prevents reinstating later administrator deletions:
-- re-running this migration is a no-op (on conflict do nothing, gated on the
-- installed marker), and a deleted row is never re-inserted.
with installed as (insert into private.planner_seed_installations(seed_key) values ('followup-motaleat-worksheets-1405-v242') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3000, "title": "کاربرگه ۱: طول و عرض جغرافیایی", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3001, "title": "کاربرگه ۲: طول و عرض جغرافیایی بر روی نقشه", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3002, "title": "کاربرگه ۳: انواع ناهمواری‌ها", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3003, "title": "کاربرگه ۴: رابطه پراکندگی زیست‌بوم‌های جهان با عرض جغرافیایی و بارش", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3004, "title": "کاربرگه ۵: زیست‌بوم‌های جهان", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3005, "title": "کاربرگه ۶: شگفتی‌های آفریقا", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3006, "title": "کاربرگه ۷: نقشه سیاسی ایران در آستانه تأسیس حکومت صفویه", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3007, "title": "کاربرگه ۸: اداره شهرها و روستاها در عصر صفوی", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3008, "title": "کاربرگه ۹: جدایی سرزمین‌های ایرانی در دوره قاجار", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3009, "title": "کاربرگه ۱۰: زمینه‌ها و عوامل نهضت مشروطه", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3010, "title": "کاربرگه ۱۱: سخن امام درباره قرآن و روحانیت", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3011, "title": "کاربرگه ۱۲: رویدادهای مهم انقلاب اسلامی در سال ۱۳۵۷", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3012, "title": "کاربرگه ۱۳: لایه‌های فرهنگ", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3013, "title": "کاربرگه ۱۴: سازگاری والدین و فرزندان", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3014, "title": "کاربرگه ۱۵: سازگاری والدین و فرزندان", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3015, "title": "کاربرگه ۱۶: حقوق و تکالیف شهروندی", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3016, "title": "کاربرگه ۱۷: بهره‌وری", "start": null, "end": null},
 {"grade": "9", "subject": "مطالعات اجتماعی", "chapter": "کاربرگه‌ها", "position": 3017, "title": "کاربرگه ۱۸: حل مسئله", "start": null, "end": null}
]$topics$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)),
tracks(track) as (values ('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v242:all:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405','all',p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
