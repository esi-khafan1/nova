-- Workbook 9 (911), 1405: labelled subparts of multipart exercises.
-- New deterministic rows; installation marker preserves admin edits and deletions on rerun.
with installed as (insert into private.planner_seed_installations(seed_key) values ('workbook9-subparts-1405-v225') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس‌ها",
  "title": "درس 1 — تمرین 6 — الف: یافتن واژگان شخصیت",
  "start": 12,
  "end": 12,
  "position": 701
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 1 — تمرین 6 — ب: دسته‌بندی واژه‌های مثبت و منفی",
  "start": 12,
  "end": 12,
  "position": 702
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 1 — تمرین 6 — پ: کامل کردن جمله با واژه‌ها",
  "start": 13,
  "end": 13,
  "position": 703
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 1 — تمرین 10 — الف: یافتن افعال to be در متن",
  "start": 17,
  "end": 17,
  "position": 704
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 1 — تمرین 10 — ب: پاسخ به پرسش‌های متن",
  "start": 18,
  "end": 18,
  "position": 705
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 1 — تمرین 10 — پ: بازنویسی متن درباره خود",
  "start": 18,
  "end": 19,
  "position": 706
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 2 — تمرین 6 — الف: یافتن واژگان سفر",
  "start": 27,
  "end": 27,
  "position": 707
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 2 — تمرین 6 — ب: دسته‌بندی اسم و فعل",
  "start": 27,
  "end": 27,
  "position": 708
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 2 — تمرین 6 — پ: جمله‌سازی با واژه‌ها",
  "start": 27,
  "end": 27,
  "position": 709
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 2 — تمرین 8 — الف: ترتیب زمانی تصاویر سفر",
  "start": 29,
  "end": 29,
  "position": 710
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 2 — تمرین 8 — ب: جمله‌سازی برای تصاویر",
  "start": 30,
  "end": 30,
  "position": 711
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 2 — تمرین 10 — الف: یافتن حال استمراری در مکالمه",
  "start": 32,
  "end": 32,
  "position": 712
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 2 — تمرین 10 — ب: بله یا خیر",
  "start": 33,
  "end": 33,
  "position": 713
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 2 — تمرین 10 — پ: پاسخ به پرسش‌های مکالمه",
  "start": 33,
  "end": 33,
  "position": 714
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 3 — تمرین 7 — الف: یافتن واژگان جشن‌ها",
  "start": 43,
  "end": 43,
  "position": 715
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 3 — تمرین 7 — ب: واژگان در کنار فعل‌ها",
  "start": 44,
  "end": 44,
  "position": 716
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 3 — تمرین 7 — پ: جمله‌سازی با عبارت‌ها",
  "start": 44,
  "end": 44,
  "position": 717
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 3 — تمرین 8 — الف: ویرایش متن نوروز",
  "start": 45,
  "end": 45,
  "position": 718
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 3 — تمرین 8 — ب: بازنویسی متن درباره خود",
  "start": 46,
  "end": 46,
  "position": 719
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 3 — تمرین 10 — الف: یافتن حال ساده در متن",
  "start": 48,
  "end": 48,
  "position": 720
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 3 — تمرین 10 — ب: بله یا خیر",
  "start": 49,
  "end": 49,
  "position": 721
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 3 — تمرین 10 — پ: پاسخ به پرسش‌های متن",
  "start": 49,
  "end": 49,
  "position": 722
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 3 — تمرین 10 — ت: نوشتن درباره مناسبت ایرانی اسلامی",
  "start": 50,
  "end": 51,
  "position": 723
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 4 — تمرین 7 — الف: یافتن واژگان خدمات و تکمیل جمله",
  "start": 60,
  "end": 60,
  "position": 724
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 4 — تمرین 7 — ب: دسته‌بندی اسم، فعل و صفت",
  "start": 61,
  "end": 61,
  "position": 725
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 4 — تمرین 7 — پ: جمله‌سازی با واژگان",
  "start": 61,
  "end": 61,
  "position": 726
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 4 — تمرین 10 — الف: خواندن متن و یافتن قید تکرار",
  "start": 64,
  "end": 64,
  "position": 727
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 4 — تمرین 10 — ب: بله یا خیر",
  "start": 65,
  "end": 65,
  "position": 728
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 4 — تمرین 10 — پ: پرسش‌های اردوی مدرسه",
  "start": 65,
  "end": 65,
  "position": 729
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 5 — تمرین 7 — الف: یافتن واژگان رسانه",
  "start": 73,
  "end": 73,
  "position": 730
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 5 — تمرین 7 — ب: ارتباط واژه و تصویر",
  "start": 74,
  "end": 74,
  "position": 731
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 5 — تمرین 7 — پ: دسته‌بندی واژگان رسانه",
  "start": 75,
  "end": 75,
  "position": 732
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 5 — تمرین 7 — ت: تکمیل جمله با واژگان",
  "start": 75,
  "end": 75,
  "position": 733
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 5 — تمرین 8 — الف: ویرایش رایانامه",
  "start": 76,
  "end": 76,
  "position": 734
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 5 — تمرین 8 — ب: بازنویسی متن درباره خود",
  "start": 77,
  "end": 77,
  "position": 735
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 5 — تمرین 10 — الف: خواندن گزارش و یافتن افعال گذشته",
  "start": 79,
  "end": 79,
  "position": 736
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 5 — تمرین 10 — ب: بله یا خیر",
  "start": 80,
  "end": 80,
  "position": 737
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 5 — تمرین 10 — پ: پاسخ به پرسش‌های گزارش",
  "start": 80,
  "end": 80,
  "position": 738
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 6 — تمرین 7 — الف: یافتن واژگان سلامت و آسیب",
  "start": 90,
  "end": 90,
  "position": 739
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 6 — تمرین 7 — ب: قرار دادن واژگان در جمله",
  "start": 90,
  "end": 90,
  "position": 740
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 6 — تمرین 7 — پ: دسته‌بندی بدن و فعل‌ها",
  "start": 90,
  "end": 90,
  "position": 741
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 6 — تمرین 7 — ت: جمله‌سازی با واژه‌ها",
  "start": 91,
  "end": 91,
  "position": 742
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 6 — تمرین 8 — الف: ویرایش متن سفر",
  "start": 91,
  "end": 91,
  "position": 743
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 6 — تمرین 8 — ب: بازنویسی متن درباره خود",
  "start": 92,
  "end": 92,
  "position": 744
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 6 — تمرین 10 — الف: یافتن افعال گذشته در داستان",
  "start": 94,
  "end": 94,
  "position": 745
 },
 {
  "chapter": "درس‌ها",
  "title": "درس 6 — تمرین 10 — ب: بله یا خیر درباره داستان",
  "start": 95,
  "end": 95,
  "position": 746
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v225:all:9:final_exam:کتاب کار زبان انگلیسی:'||p.chapter||':'||p.position)::uuid,'1405','all','9','final_exam','کتاب کار زبان انگلیسی',p.chapter,p.title,p.start,p."end",p.position from topics p cross join installed on conflict(id) do nothing;
