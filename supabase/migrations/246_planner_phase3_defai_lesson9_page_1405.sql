-- Phase 3 item 3: آمادگی دفاعی دهم (110215), درس ۹ page — guarded correction only.
--
-- History: migration 154 seeded the whole-lesson row
-- «درس ۹: جنگ‌افزارشناسی و اصول تیراندازی» (فصل ۳: دفاع نظامی, position 3)
-- with pages 78–116, taken from the front TOC. Migration 158 cleared those
-- pages to NULL (revision 1 -> 2) because the TOC start (78) conflicts with
-- the real text, and migration 161 deliberately left the NULL/revision-2 row
-- alone and added a verified replacement at position 301 (87–116).
--
-- This migration fills the OLD row's page ONLY because the range 87–116 has
-- now been verified against the actual PDF text (see
-- docs/planner-1405-audit/phase3-3-evidence.md): the درس ۹ title page is
-- printed p.87 (PDF p.95), its جنگ‌افزارشناسی content runs printed pp.88–116
-- (PDF pp.96–124, ending with the «بیشتر بدانید» box), the فصل ۴ title page
-- is printed p.117 (PDF p.125), and درس ۱۰ starts printed p.118 (PDF p.126).
-- The front TOC's «78» is wrong: printed pp.78–86 are the end of درس ۸.
--
-- Guard: the update matches ONLY the row in its exact post-158 state —
-- original v1 id formula, original title, position 3, NULL pages,
-- revision=2. An admin edit (title/position/revision change) or an admin
-- delete means the guard does not match and the row is left alone; the
-- migration never inserts, deletes, or merges anything, so the old row is
-- preserved (same id) and the position-301 replacement is untouched.
-- Re-running is a no-op (revision is then 3 and pages are non-NULL).
with fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
update private.planner_topic_bank t set page_start=87,page_end=116,revision=t.revision+1,updated_at=now()
from fields f
where t.id=md5('nova:planner:1405:v1:'||f.field||':10:final_exam:آمادگی دفاعی:فصل ۳: دفاع نظامی:3')::uuid
 and t.edition='1405' and t.study_field=f.field and t.grade='10' and t.preparation_track='final_exam'
 and t.subject='آمادگی دفاعی' and t.chapter='فصل ۳: دفاع نظامی' and t.title='درس ۹: جنگ‌افزارشناسی و اصول تیراندازی'
 and t.position=3 and t.page_start is null and t.page_end is null and t.revision=2;
