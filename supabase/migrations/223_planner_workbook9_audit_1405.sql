-- Workbook 9 (911), print 1405: exercise 10 of lesson 5 ends on page 80.
-- Page 81 is blank; update only the unmodified seed v169 row.
with installed as (insert into private.planner_seed_installations(seed_key) values ('workbook9-page80-1405-v223') on conflict do nothing returning seed_key)
update private.planner_topic_bank b set page_end=80,revision=b.revision+1,updated_at=now() from installed
where b.id=md5('nova:planner:1405:v169:all:9:final_exam:کتاب کار زبان انگلیسی:درس‌ها:511')::uuid
 and b.edition='1405' and b.study_field='all' and b.grade='9' and b.preparation_track='final_exam' and b.subject='کتاب کار زبان انگلیسی' and b.chapter='درس‌ها'
 and b.position=511 and b.title='درس 5: Media — تمرین 10: خواندن گزارش و پرسش‌ها' and b.page_start=79 and b.page_end=81 and b.revision=1;
