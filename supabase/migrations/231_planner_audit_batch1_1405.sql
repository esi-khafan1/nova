-- Batch 1 audit (migration 231): books #1-10 checked against the user's 1405 PDFs.
-- Insert only. The installation marker prevents reinstating later administrator deletions.
-- New rows fill the gaps the audit found, all verified in the printed book text:
--  * آمار و احتمال ۱۱ (code 111215): فصل ۲ had no row for the تمرین on p.47;
--    فصل ۳ تمرین نمایش داده‌ها ends on p.78 (p.79 is the خواندنی تاریخچه, which had
--    no row), and چارک و نما ends on p.85 (p.86 is the خواندنی کاربرد علم آمار در
--    علوم شناختی و مغز, which had no row). The old v198 rows (positions 451 and
--    454, ends 79 and 86) are left untouched and superseded by the corrected rows
--    below (migration 161 precedent); they cannot be fixed in place because they
--    already carry page numbers, so pattern B does not apply to them.
--  * عربی نهم (code 909): the farewell سخن پایانی page (printed p.135) had no row;
--    sibling Arabic books all carry one (e.g. عربی ۱ تخصصی درس ۸, 120-120).
--  * عربی زبان قرآن ۲ (code 111206): درس ۷ البحث العلمی task on printed p.100 had
--    no row (rendered page checked; the box is genuinely on p.100).
--  * عربی زبان قرآن ۳ (code 112206) درس ۱ and عربی ۲ تخصصی (code 111207) درس ۱:
--    the legacy v1 تمرین‌های درس rows end one page late (10-16 and 10-15), running
--    into the پژوهش علمی page; the correct ranges (10-15 and 10-14) already exist
--    as v188/v189 rows, and the corrected rows below supersede the stale v1 rows,
--    which are left untouched.
-- No guarded page-fill (pattern B) applies: no pre-existing row for these ten
-- books has NULL pages (verified: 0 NULL-page rows across all ten books/combos;
-- the only NULL-page آمادگی دفاعی rows belong to the grade-10 book, not batch 1).
-- Two text-layer traps, recorded so they are not re-"fixed": in عربی ۱ (110206)
-- and عربی ۱ تخصصی (110207) the البحث العلمی box text leaks into the text layer
-- of the next lesson's first page, but the rendered pages show the box only on
-- its own page (60 and 66); the existing rows 60-60 and 66-66 are correct.
-- See docs/planner-1405-audit/batch-1-evidence.md for the per-book evidence.
with installed as (insert into private.planner_seed_installations(seed_key) values ('audit-batch1-1405-v231') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {"field": "mathematics", "grade": "11", "subject": "آمار و احتمال", "chapter": "فصل ۲: احتمال", "position": 3000, "title": "تمرین احتمال غیرهم‌شانس", "start": 47, "end": 47, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "آمار و احتمال", "chapter": "فصل ۳: آمار توصیفی", "position": 3000, "title": "تمرین نمایش داده‌ها", "start": 77, "end": 78, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "آمار و احتمال", "chapter": "فصل ۳: آمار توصیفی", "position": 3001, "title": "خواندنی: تاریخچۀ علم آمار و علم احتمال", "start": 79, "end": 79, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "آمار و احتمال", "chapter": "فصل ۳: آمار توصیفی", "position": 3002, "title": "چارک و نما", "start": 83, "end": 85, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "آمار و احتمال", "chapter": "فصل ۳: آمار توصیفی", "position": 3003, "title": "خواندنی: کاربرد علم آمار در علوم شناختی و مغز", "start": 86, "end": 86, "konkur": true},
 {"field": "all", "grade": "9", "subject": "عربی", "chapter": "درس ۱۰", "position": 3000, "title": "سخن پایانی", "start": 135, "end": 135, "konkur": false},
 {"field": "mathematics", "grade": "11", "subject": "عربی زبان قرآن ۲", "chapter": "درس ۷", "position": 3000, "title": "پژوهش علمی", "start": 100, "end": 100, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "عربی زبان قرآن ۲", "chapter": "درس ۷", "position": 3000, "title": "پژوهش علمی", "start": 100, "end": 100, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "عربی زبان قرآن ۳", "chapter": "درس ۱", "position": 3000, "title": "تمرین‌های درس", "start": 10, "end": 15, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "عربی زبان قرآن ۳", "chapter": "درس ۱", "position": 3000, "title": "تمرین‌های درس", "start": 10, "end": 15, "konkur": false},
 {"field": "humanities", "grade": "11", "subject": "عربی ۲ تخصصی", "chapter": "درس ۱", "position": 3000, "title": "تمرین‌های درس", "start": 10, "end": 14, "konkur": true}
]$topics$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,start integer,"end" integer,konkur boolean)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v231:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed where p.konkur or r.track='final_exam' on conflict(id) do nothing;
