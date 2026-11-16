-- Batch 2 audit (migration 232) against the user's 1405 PDFs.
-- One genuine gap was found: آزمایشگاه علوم تجربی ۱ (code 110217) has a پروژه
-- section on printed pp.146–148 (project introduction and forms: مشخصات پروژه
-- on p.147 and تقویم اجرایی on p.148) with no seed row in migration 206.
-- Install that single row once; never resurrect an admin deletion.
-- All other Batch 2 books were verified against the same PDFs and needed no
-- new rows and no guarded page fills: every lesson, subtopic, exercise and
-- activity already has a row with correct printed pages, and no pre-existing
-- row for these books has NULL pages. See
-- docs/planner-1405-audit/batch-2-evidence.md for the per-book evidence.
-- Unresolved catalog discrepancy (recorded, not papered over): both آزمایشگاه
-- books state on the cover that they cover the mathematics and
-- experimental_sciences tracks, but the catalog only has them in
-- experimental_sciences, so no mathematics rows are invented here.
with installed as (insert into private.planner_seed_installations(seed_key) values ('audit-batch2-1405-v232') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "grade": "10",
  "subject": "آزمایشگاه علوم تجربی ۱",
  "chapter": "پروژه",
  "position": 3001,
  "title": "کل پروژه",
  "start": 146,
  "end": 148
 }
]$topics$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v232:experimental_sciences:'||p.grade||':final_exam:'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405','experimental_sciences',p.grade,'final_exam',p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join installed on conflict(id) do nothing;
