-- Geography of Iran (110218), user-provided 1405 textbook.
-- Lesson 5 starts at printed 34, lesson 8 at 79 and lesson 10 at 96, as in the text; the table of contents has misordered numbers.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "درس ۱",
  "position": 1,
  "title": "تعریف جغرافیا و ارتباط با علوم دیگر",
  "start": 2,
  "end": 3
 },
 {
  "chapter": "درس ۱",
  "position": 2,
  "title": "مفاهیم مکان و روابط متقابل انسان و محیط",
  "start": 3,
  "end": 6
 },
 {
  "chapter": "درس ۱",
  "position": 3,
  "title": "کل‌نگری و دید ترکیبی در جغرافیا",
  "start": 7,
  "end": 7
 },
 {
  "chapter": "درس ۲",
  "position": 1,
  "title": "پرسش‌های کلیدی جغرافیا",
  "start": 8,
  "end": 9
 },
 {
  "chapter": "درس ۲",
  "position": 2,
  "title": "طرح مسئله و تدوین فرضیه",
  "start": 10,
  "end": 10
 },
 {
  "chapter": "درس ۲",
  "position": 3,
  "title": "جمع‌آوری و پردازش اطلاعات",
  "start": 11,
  "end": 12
 },
 {
  "chapter": "درس ۲",
  "position": 4,
  "title": "نتیجه‌گیری و ارائه پیشنهادها",
  "start": 12,
  "end": 12
 },
 {
  "chapter": "درس ۳",
  "position": 1,
  "title": "موقعیت ریاضی یا مطلق ایران",
  "start": 14,
  "end": 16
 },
 {
  "chapter": "درس ۳",
  "position": 2,
  "title": "موقعیت نسبی ایران و اهمیت خلیج فارس",
  "start": 16,
  "end": 18
 },
 {
  "chapter": "درس ۳",
  "position": 3,
  "title": "تنگه هرمز، دریای عمان و دریای خزر",
  "start": 19,
  "end": 19
 },
 {
  "chapter": "درس ۳",
  "position": 4,
  "title": "مرزها و ارتباطات ایران",
  "start": 20,
  "end": 21
 },
 {
  "chapter": "درس ۴",
  "position": 1,
  "title": "پیدایش و اهمیت ناهمواری‌های ایران",
  "start": 22,
  "end": 23
 },
 {
  "chapter": "درس ۴",
  "position": 2,
  "title": "سرزمین‌های کوهستانی ایران",
  "start": 24,
  "end": 30
 },
 {
  "chapter": "درس ۴",
  "position": 3,
  "title": "دشت‌ها و جلگه‌های ایران",
  "start": 31,
  "end": 33
 },
 {
  "chapter": "درس ۴",
  "position": 4,
  "title": "نقش ناهمواری‌ها در زندگی انسان",
  "start": 30,
  "end": 33
 },
 {
  "chapter": "درس ۵",
  "position": 1,
  "title": "عوامل مؤثر بر آب و هوای ایران",
  "start": 34,
  "end": 40
 },
 {
  "chapter": "درس ۵",
  "position": 2,
  "title": "توده‌های هوا و انواع اقلیم ایران",
  "start": 39,
  "end": 42
 },
 {
  "chapter": "درس ۵",
  "position": 3,
  "title": "بیابان‌های ایران",
  "start": 42,
  "end": 44
 },
 {
  "chapter": "درس ۵",
  "position": 4,
  "title": "آب و هوا و مسائل محیط زیستی",
  "start": 44,
  "end": 47
 },
 {
  "chapter": "درس ۶",
  "position": 1,
  "title": "منابع آب سطحی و زیرزمینی",
  "start": 48,
  "end": 50
 },
 {
  "chapter": "درس ۶",
  "position": 2,
  "title": "رودها، کانون‌های آبگیر و حوضه‌های آبریز",
  "start": 50,
  "end": 52
 },
 {
  "chapter": "درس ۶",
  "position": 3,
  "title": "دریاها و دریاچه‌های ایران",
  "start": 53,
  "end": 63
 },
 {
  "chapter": "درس ۷",
  "position": 1,
  "title": "پراکندگی جمعیت و عوامل آن",
  "start": 66,
  "end": 68
 },
 {
  "chapter": "درس ۷",
  "position": 2,
  "title": "رشد و ساختار جمعیت",
  "start": 69,
  "end": 73
 },
 {
  "chapter": "درس ۷",
  "position": 3,
  "title": "مهاجرت و پیامدهای آن",
  "start": 74,
  "end": 78
 },
 {
  "chapter": "درس ۸",
  "position": 1,
  "title": "سابقه تقسیمات کشوری ایران",
  "start": 79,
  "end": 81
 },
 {
  "chapter": "درس ۸",
  "position": 2,
  "title": "استان، شهرستان، بخش و دهستان",
  "start": 81,
  "end": 84
 },
 {
  "chapter": "درس ۹",
  "position": 1,
  "title": "شکل‌گیری سکونتگاه‌ها و عوامل مؤثر",
  "start": 85,
  "end": 87
 },
 {
  "chapter": "درس ۹",
  "position": 2,
  "title": "سکونتگاه‌های شهری، روستایی و عشایری",
  "start": 88,
  "end": 89
 },
 {
  "chapter": "درس ۹",
  "position": 3,
  "title": "شکل و تغییر سکونتگاه‌ها",
  "start": 89,
  "end": 95
 },
 {
  "chapter": "درس ۱۰",
  "position": 1,
  "title": "کشاورزی، زراعت و باغداری",
  "start": 96,
  "end": 99
 },
 {
  "chapter": "درس ۱۰",
  "position": 2,
  "title": "صنعت و پراکندگی قطب‌های صنعتی",
  "start": 100,
  "end": 103
 },
 {
  "chapter": "درس ۱۰",
  "position": 3,
  "title": "خدمات و گردشگری",
  "start": 104,
  "end": 108
 }
]$fixes$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), contexts(field,track) as (values ('humanities','konkur'),('humanities','final_exam'),('mathematics','final_exam'),('experimental_sciences','final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join contexts c
where t.id=md5('nova:planner:1405:v1:'||c.field||':10:'||c.track||':جغرافیای ایران:'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field=c.field and t.grade='10' and t.preparation_track=c.track and t.subject='جغرافیای ایران' and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
with installed as (insert into private.planner_seed_installations(seed_key) values ('geography10-1405-v178') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 100,
  "title": "کل درس",
  "start": 2,
  "end": 7
 },
 {
  "chapter": "درس ۱",
  "position": 101,
  "title": "مفاهیم اساسی دانش جغرافیا",
  "start": 3,
  "end": 3
 },
 {
  "chapter": "درس ۱",
  "position": 102,
  "title": "مکان",
  "start": 4,
  "end": 4
 },
 {
  "chapter": "درس ۱",
  "position": 103,
  "title": "روابط متقابل انسان و محیط",
  "start": 4,
  "end": 6
 },
 {
  "chapter": "درس ۱",
  "position": 104,
  "title": "کل‌نگری یا دید ترکیبی",
  "start": 7,
  "end": 7
 },
 {
  "chapter": "درس ۲",
  "position": 100,
  "title": "کل درس",
  "start": 8,
  "end": 12
 },
 {
  "chapter": "درس ۲",
  "position": 101,
  "title": "سؤالات کلیدی جغرافیا",
  "start": 8,
  "end": 9
 },
 {
  "chapter": "درس ۲",
  "position": 102,
  "title": "طرح سؤال و بیان مسئله",
  "start": 10,
  "end": 10
 },
 {
  "chapter": "درس ۲",
  "position": 103,
  "title": "تدوین فرضیه",
  "start": 10,
  "end": 10
 },
 {
  "chapter": "درس ۲",
  "position": 104,
  "title": "جمع‌آوری اطلاعات",
  "start": 11,
  "end": 11
 },
 {
  "chapter": "درس ۲",
  "position": 105,
  "title": "پردازش اطلاعات",
  "start": 12,
  "end": 12
 },
 {
  "chapter": "درس ۲",
  "position": 106,
  "title": "نتیجه‌گیری و پیشنهادها",
  "start": 12,
  "end": 12
 },
 {
  "chapter": "درس ۳",
  "position": 100,
  "title": "کل درس",
  "start": 14,
  "end": 21
 },
 {
  "chapter": "درس ۳",
  "position": 101,
  "title": "موقعیت ریاضی یا مطلق",
  "start": 14,
  "end": 16
 },
 {
  "chapter": "درس ۳",
  "position": 102,
  "title": "موقعیت نسبی ایران",
  "start": 16,
  "end": 17
 },
 {
  "chapter": "درس ۳",
  "position": 103,
  "title": "خلیج فارس",
  "start": 17,
  "end": 18
 },
 {
  "chapter": "درس ۳",
  "position": 104,
  "title": "تنگه هرمز و دریای خزر",
  "start": 19,
  "end": 19
 },
 {
  "chapter": "درس ۳",
  "position": 105,
  "title": "مرزهای سیاسی",
  "start": 20,
  "end": 21
 },
 {
  "chapter": "درس ۴",
  "position": 100,
  "title": "کل درس",
  "start": 22,
  "end": 33
 },
 {
  "chapter": "درس ۴",
  "position": 101,
  "title": "پیدایش ناهمواری ایران",
  "start": 22,
  "end": 23
 },
 {
  "chapter": "درس ۴",
  "position": 102,
  "title": "سرزمین‌های کوهستانی شمال کشور",
  "start": 24,
  "end": 26
 },
 {
  "chapter": "درس ۴",
  "position": 103,
  "title": "منطقه کوهستانی زاگرس",
  "start": 26,
  "end": 29
 },
 {
  "chapter": "درس ۴",
  "position": 104,
  "title": "منطقه کوهستانی مرکزی",
  "start": 29,
  "end": 29
 },
 {
  "chapter": "درس ۴",
  "position": 105,
  "title": "کوه‌های شرق و جنوب شرقی",
  "start": 30,
  "end": 30
 },
 {
  "chapter": "درس ۴",
  "position": 106,
  "title": "ارزش اقتصادی نواحی کوهستانی",
  "start": 30,
  "end": 30
 },
 {
  "chapter": "درس ۴",
  "position": 107,
  "title": "دشت‌ها و عوامل تغییر آنها",
  "start": 31,
  "end": 32
 },
 {
  "chapter": "درس ۴",
  "position": 108,
  "title": "جلگه‌ها و عوامل تغییر آنها",
  "start": 32,
  "end": 33
 },
 {
  "chapter": "درس ۵",
  "position": 100,
  "title": "کل درس",
  "start": 34,
  "end": 47
 },
 {
  "chapter": "درس ۵",
  "position": 101,
  "title": "هواشناسی و پیش‌بینی وضع هوا",
  "start": 34,
  "end": 36
 },
 {
  "chapter": "درس ۵",
  "position": 102,
  "title": "عوامل مؤثر بر آب و هوای ایران",
  "start": 36,
  "end": 40
 },
 {
  "chapter": "درس ۵",
  "position": 103,
  "title": "انواع آب و هوای ایران",
  "start": 41,
  "end": 42
 },
 {
  "chapter": "درس ۵",
  "position": 104,
  "title": "علل پیدایش بیابان‌های ایران",
  "start": 42,
  "end": 44
 },
 {
  "chapter": "درس ۵",
  "position": 105,
  "title": "آب و هوا و زندگی",
  "start": 44,
  "end": 45
 },
 {
  "chapter": "درس ۵",
  "position": 106,
  "title": "تغییر آب و هوا و مشکلات محیط زیستی",
  "start": 46,
  "end": 47
 },
 {
  "chapter": "درس ۶",
  "position": 100,
  "title": "کل درس",
  "start": 48,
  "end": 63
 },
 {
  "chapter": "درس ۶",
  "position": 101,
  "title": "آب قابل دسترس و ویژگی رودهای ایران",
  "start": 48,
  "end": 50
 },
 {
  "chapter": "درس ۶",
  "position": 102,
  "title": "کانون‌های آبگیر",
  "start": 51,
  "end": 51
 },
 {
  "chapter": "درس ۶",
  "position": 103,
  "title": "حوضه‌های آبریز داخلی و خارجی",
  "start": 52,
  "end": 52
 },
 {
  "chapter": "درس ۶",
  "position": 104,
  "title": "دریای خزر و اهمیت آن",
  "start": 53,
  "end": 54
 },
 {
  "chapter": "درس ۶",
  "position": 105,
  "title": "خلیج فارس و اهمیت آن",
  "start": 55,
  "end": 56
 },
 {
  "chapter": "درس ۶",
  "position": 106,
  "title": "دریای عمان",
  "start": 57,
  "end": 57
 },
 {
  "chapter": "درس ۶",
  "position": 107,
  "title": "آلودگی دریاها",
  "start": 58,
  "end": 58
 },
 {
  "chapter": "درس ۶",
  "position": 108,
  "title": "دریاچه‌های ایران",
  "start": 59,
  "end": 59
 },
 {
  "chapter": "درس ۶",
  "position": 109,
  "title": "دریاچه ارومیه و نجات آن",
  "start": 60,
  "end": 63
 },
 {
  "chapter": "درس ۷",
  "position": 100,
  "title": "کل درس",
  "start": 66,
  "end": 78
 },
 {
  "chapter": "درس ۷",
  "position": 101,
  "title": "پراکندگی جمعیت در ایران",
  "start": 66,
  "end": 68
 },
 {
  "chapter": "درس ۷",
  "position": 102,
  "title": "رشد جمعیت",
  "start": 69,
  "end": 71
 },
 {
  "chapter": "درس ۷",
  "position": 103,
  "title": "ساختمان جمعیت",
  "start": 72,
  "end": 72
 },
 {
  "chapter": "درس ۷",
  "position": 104,
  "title": "سیاست‌های جمعیتی",
  "start": 73,
  "end": 73
 },
 {
  "chapter": "درس ۷",
  "position": 105,
  "title": "مهاجرت",
  "start": 74,
  "end": 78
 },
 {
  "chapter": "درس ۸",
  "position": 100,
  "title": "کل درس",
  "start": 79,
  "end": 84
 },
 {
  "chapter": "درس ۸",
  "position": 101,
  "title": "تاریخچه تقسیمات کشوری در ایران",
  "start": 79,
  "end": 81
 },
 {
  "chapter": "درس ۸",
  "position": 102,
  "title": "استان، شهرستان، بخش و دهستان",
  "start": 81,
  "end": 83
 },
 {
  "chapter": "درس ۸",
  "position": 103,
  "title": "تقسیمات کشوری از دیدگاه نقشه",
  "start": 84,
  "end": 84
 },
 {
  "chapter": "درس ۹",
  "position": 100,
  "title": "کل درس",
  "start": 85,
  "end": 95
 },
 {
  "chapter": "درس ۹",
  "position": 101,
  "title": "شکل‌گیری و گسترش سکونتگاه‌ها",
  "start": 85,
  "end": 87
 },
 {
  "chapter": "درس ۹",
  "position": 102,
  "title": "انواع سکونتگاه",
  "start": 88,
  "end": 89
 },
 {
  "chapter": "درس ۹",
  "position": 103,
  "title": "شکل سکونتگاه و اشکال شهرها",
  "start": 89,
  "end": 91
 },
 {
  "chapter": "درس ۹",
  "position": 104,
  "title": "تغییرات جمعیتی سکونتگاه‌ها",
  "start": 92,
  "end": 93
 },
 {
  "chapter": "درس ۹",
  "position": 105,
  "title": "نقش سکونتگاه‌ها و شهرگریزی",
  "start": 94,
  "end": 95
 },
 {
  "chapter": "درس ۱۰",
  "position": 100,
  "title": "کل درس",
  "start": 96,
  "end": 108
 },
 {
  "chapter": "درس ۱۰",
  "position": 101,
  "title": "کشاورزی، زراعت و باغداری",
  "start": 96,
  "end": 99
 },
 {
  "chapter": "درس ۱۰",
  "position": 102,
  "title": "دامداری",
  "start": 99,
  "end": 99
 },
 {
  "chapter": "درس ۱۰",
  "position": 103,
  "title": "صنعت و معدن",
  "start": 100,
  "end": 103
 },
 {
  "chapter": "درس ۱۰",
  "position": 104,
  "title": "حمل و نقل",
  "start": 104,
  "end": 104
 },
 {
  "chapter": "درس ۱۰",
  "position": 105,
  "title": "آموزش و پرورش، تجارت و بازرگانی",
  "start": 105,
  "end": 105
 },
 {
  "chapter": "درس ۱۰",
  "position": 106,
  "title": "گردشگری",
  "start": 106,
  "end": 108
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), contexts(field,track) as (values ('humanities','konkur'),('humanities','final_exam'),('mathematics','final_exam'),('experimental_sciences','final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v178:'||c.field||':10:'||c.track||':جغرافیای ایران:'||p.chapter||':'||p.position)::uuid,'1405',c.field,'10',c.track,'جغرافیای ایران',p.chapter,p.title,p.start,p."end",p.position from topics p cross join contexts c cross join installed on conflict(id) do nothing;
