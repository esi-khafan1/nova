-- Textbook 110219, 1405: independent subheadings of lessons 1 and 2.
-- Existing study groupings are intentionally retained; inserts never overwrite edits or restore deleted rows on rerun.
with installed as (insert into private.planner_seed_installations(seed_key) values ('history10-finer-1405-v168') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 201,
  "title": "انتخاب موضوع",
  "start": 6,
  "end": 6
 },
 {
  "chapter": "درس ۱",
  "position": 202,
  "title": "تدوین پرسش‌های تحقیق",
  "start": 6,
  "end": 6
 },
 {
  "chapter": "درس ۱",
  "position": 203,
  "title": "شناسایی منابع",
  "start": 6,
  "end": 6
 },
 {
  "chapter": "درس ۱",
  "position": 204,
  "title": "گردآوری و تنظیم اطلاعات",
  "start": 6,
  "end": 6
 },
 {
  "chapter": "درس ۱",
  "position": 205,
  "title": "تحلیل و تفسیر اطلاعات",
  "start": 7,
  "end": 7
 },
 {
  "chapter": "درس ۱",
  "position": 206,
  "title": "گزارش یافته‌های پژوهش",
  "start": 7,
  "end": 7
 },
 {
  "chapter": "درس ۱",
  "position": 207,
  "title": "منابع دست اول یا اصلی",
  "start": 8,
  "end": 8
 },
 {
  "chapter": "درس ۱",
  "position": 208,
  "title": "منابع دست دوم یا فرعی",
  "start": 9,
  "end": 9
 },
 {
  "chapter": "درس ۱",
  "position": 209,
  "title": "منبع شناخت و تفکر",
  "start": 9,
  "end": 9
 },
 {
  "chapter": "درس ۱",
  "position": 210,
  "title": "بهره‌گیری از گذشته برای حال و آینده",
  "start": 10,
  "end": 10
 },
 {
  "chapter": "درس ۱",
  "position": 211,
  "title": "تقویت حس میهن‌دوستی و هویت ملی",
  "start": 10,
  "end": 11
 },
 {
  "chapter": "درس ۲",
  "position": 201,
  "title": "ابداع گاه‌شماری",
  "start": 12,
  "end": 12
 },
 {
  "chapter": "درس ۲",
  "position": 202,
  "title": "تاریخچه گاه‌شماری در جهان",
  "start": 13,
  "end": 13
 },
 {
  "chapter": "درس ۲",
  "position": 203,
  "title": "تاریخچه گاه‌شماری در ایران",
  "start": 14,
  "end": 15
 },
 {
  "chapter": "درس ۲",
  "position": 204,
  "title": "تطبیق و تبدیل تقویم‌ها",
  "start": 15,
  "end": 15
 },
 {
  "chapter": "درس ۲",
  "position": 205,
  "title": "خط زمان",
  "start": 16,
  "end": 16
 },
 {
  "chapter": "درس ۲",
  "position": 206,
  "title": "جغرافیای تاریخی",
  "start": 17,
  "end": 18
 },
 {
  "chapter": "درس ۲",
  "position": 207,
  "title": "نقشه‌های تاریخی",
  "start": 18,
  "end": 19
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v168:humanities:10:'||r.track||':تاریخ ۱:'||p.chapter||':'||p.position)::uuid,
 '1405','humanities','10',r.track,'تاریخ ۱',p.chapter,p.title,p.start,p."end",p.position
from topics p cross join tracks r cross join installed on conflict(id) do nothing;
