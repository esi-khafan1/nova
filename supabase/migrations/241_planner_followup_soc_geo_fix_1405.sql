-- Follow-up item 2: fix two mis-filed old (v1) rows, 1405. Guarded in-place
-- updates only — same ids, so saved plans referencing them keep resolving.
-- No rows are inserted or deleted.
--
-- 1. جامعه‌شناسی ۲ (seeded by migration 144, v1 id formula): the row
--    «انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم» was filed under
--    درس ۱۵, position 1, with NULL pages. The comparison it names is
--    taught in درس ۱۴: درس ۱۴ opens on printed p.115, the comparison
--    discussion runs pp.120–123 (comparison table «مقایسۀ انقلاب اسلامی
--    ایران و انقلاب‌های آزادی‌بخش» on p.122), and درس ۱۵ opens on
--    printed p.124 — verified from jamee-2-11-111222-1405.pdf
--    (SHA-256 4a7fb8365c9c9b9d978ceb6e23282c9323c5a80b9727622e27bcd32d306c521e,
--    148 PDF pages, code 111222, چاپ دهم ۱۴۰۵; offset printed = PDF − 8).
--    The row is moved to درس ۱۴ with pages 120–123.
-- 2. جغرافیا ۲ (seeded by migration 148, v1 id formula): the row
--    «کانون و مرزهای ناحیه» was filed under درس ۱, position 3, with NULL
--    pages. The book teaches it in درس ۲: the section heading «کانون
--    ناحیه، مرزهای ناحیه» is on printed p.15, the discussion continues
--    on p.16, and the lesson activity + closing summary are on p.17;
--    p.18 opens the bridge text on political/administrative management
--    of regions, which is not کانون/مرز content — verified from
--    joghrafia-2-11-111218-1405.pdf (SHA-256
--    dd3f33d6cf9f352d539f55293fa95f03c552d45fb88c33b07573d29e5393e4b4,
--    176 PDF pages, code 111218, چاپ دهم ۱۴۰۵; offset printed = PDF − 8).
--    The row is moved to درس ۲ with pages 15–17.
--
-- Guard (pattern B): each update matches the row's ORIGINAL v1 id
-- formula (computed from the ORIGINAL chapter), original title, original
-- position, NULL pages and revision=1. A row edited, moved or deleted by
-- an admin does not match and is left untouched. The update bumps
-- revision to 2.
--
-- Known wart, NOT fixed here: each moved row now near-duplicates a
-- correct row that already exists in the target lesson (same lesson,
-- near-identical title, overlapping range):
--   جامعه‌شناسی ۲ درس ۱۴ pos 453 «مقایسه انقلاب اسلامی و انقلاب‌های
--     آزادی‌بخش» 120–123 (v204) vs the moved row (pos 1) 120–123;
--   جغرافیا ۲ درس ۲ pos 303 «کانون و مرز ناحیه» 15–18 (v180) vs the
--     moved row (pos 3) 15–17.
-- The moved rows also share their (chapter, position) with the v1 rows
-- already in the target lessons (جامعه‌شناسی ۲ درس ۱۴ pos 1 «جنبش تنباکو
-- و عدالتخانه»; جغرافیا ۲ درس ۲ pos 3 «تغییر نواحی و نقش تصمیم‌های
-- انسان»). Whether to delete or merge the duplicates is an OPEN DECISION
-- for the user — see docs/planner-1405-audit/followup-2-evidence.md.
-- Nothing is deleted or merged by this migration.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "old_chapter": "درس ۱۵",
  "new_chapter": "درس ۱۴",
  "position": 1,
  "title": "انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم",
  "start": 120,
  "end": 123
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "old_chapter": "درس ۱",
  "new_chapter": "درس ۲",
  "position": 3,
  "title": "کانون و مرزهای ناحیه",
  "start": 15,
  "end": 17
 }
]$fixes$::jsonb) as p(grade text,subject text,old_chapter text,new_chapter text,position integer,title text,start integer,"end" integer)),
tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set chapter=p.new_chapter,page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.old_chapter||':'||p.position)::uuid
 and t.edition='1405' and t.study_field='humanities' and t.grade=p.grade
 and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.old_chapter
 and t.title=p.title and t.position=p.position
 and t.page_start is null and t.page_end is null and t.revision=1;
