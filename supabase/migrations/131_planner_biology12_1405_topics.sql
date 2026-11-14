-- زیست‌شناسی (۳)، کد 112216، چاپ نهم ۱۴۰۵. Source and verification:
-- docs/planner-topic-sources.md. Titles are the book's table of contents.
-- Only chapter 1 page ranges have been checked against this edition; remaining
-- ranges stay NULL until independently verified. Include both planner tracks.
-- Stable IDs and DO NOTHING preserve any administrator edits on reapplication.
with topics(chapter, title, page_start, page_end, position) as (values
 ('فصل ۱: مولکول‌های اطلاعاتی','نوکلئیک اسیدها',2,8,1),
 ('فصل ۱: مولکول‌های اطلاعاتی','همانندسازی دنا',9,14,2),
 ('فصل ۱: مولکول‌های اطلاعاتی','پروتئین‌ها',15,20,3),
 ('فصل ۲: جریان اطلاعات در یاخته','رونویسی',null::integer,null::integer,1),
 ('فصل ۲: جریان اطلاعات در یاخته','به سوی پروتئین',null,null,2),
 ('فصل ۲: جریان اطلاعات در یاخته','تنظیم بیان ژن',null,null,3),
 ('فصل ۳: انتقال اطلاعات در نسل‌ها','مفاهیم پایه',null,null,1),
 ('فصل ۳: انتقال اطلاعات در نسل‌ها','انواع صفات',null,null,2),
 ('فصل ۴: تغییر در اطلاعات وراثتی','تغییر در ماده وراثتی جانداران',null,null,1),
 ('فصل ۴: تغییر در اطلاعات وراثتی','تغییر در جمعیت‌ها',null,null,2),
 ('فصل ۴: تغییر در اطلاعات وراثتی','تغییر در گونه‌ها',null,null,3),
 ('فصل ۵: از ماده به انرژی','تأمین انرژی',null,null,1),
 ('فصل ۵: از ماده به انرژی','اکسایش بیشتر',null,null,2),
 ('فصل ۵: از ماده به انرژی','زیستن مستقل از اکسیژن',null,null,3),
 ('فصل ۶: از انرژی به ماده','فتوسنتز: تبدیل انرژی نور به انرژی شیمیایی',null,null,1),
 ('فصل ۶: از انرژی به ماده','واکنش‌های فتوسنتزی',null,null,2),
 ('فصل ۶: از انرژی به ماده','فتوسنتز در شرایط دشوار',null,null,3),
 ('فصل ۷: فناوری‌های نوین زیستی','زیست فناوری و مهندسی ژنتیک',null,null,1),
 ('فصل ۷: فناوری‌های نوین زیستی','فناوری مهندسی پروتئین و بافت',null,null,2),
 ('فصل ۷: فناوری‌های نوین زیستی','کاربردهای زیست فناوری',null,null,3),
 ('فصل ۸: رفتارهای جانوران','اساس رفتار',null,null,1),
 ('فصل ۸: رفتارهای جانوران','انتخاب طبیعی و رفتار',null,null,2),
 ('فصل ۸: رفتارهای جانوران','ارتباط و زندگی گروهی',null,null,3)
), rows_to_add as (
 select md5('nova:planner:112216:1405:' || track || ':' || chapter || ':' || position::text)::uuid id,
        track, chapter, title, page_start, page_end, position
 from topics cross join (values ('konkur'),('final_exam')) tracks(track)
)
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select id,'1405','experimental_sciences','12',track,'زیست‌شناسی ۳',chapter,title,page_start,page_end,position from rows_to_add
on conflict (id) do nothing;
