-- Logic (110223), textbook 1405, printed pages.
-- No mutation of modified, moved, deleted, or previously paged seed rows.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "درس ۱",
  "position": 1,
  "title": "حیطه کاربرد منطق",
  "start": 3,
  "end": 7
 },
 {
  "chapter": "درس ۱",
  "position": 2,
  "title": "دو بخش اصلی منطق: تعریف و استدلال",
  "start": 7,
  "end": 10
 },
 {
  "chapter": "درس ۲",
  "position": 1,
  "title": "اشتراک لفظ",
  "start": 13,
  "end": 14
 },
 {
  "chapter": "درس ۲",
  "position": 2,
  "title": "نحوه دلالت لفظ بر معنا",
  "start": 14,
  "end": 15
 },
 {
  "chapter": "درس ۲",
  "position": 3,
  "title": "شیوه نگارش کلمات",
  "start": 16,
  "end": 16
 },
 {
  "chapter": "درس ۲",
  "position": 4,
  "title": "ابهام در مرجع ضمیر",
  "start": 17,
  "end": 19
 },
 {
  "chapter": "درس ۳",
  "position": 1,
  "title": "مفهوم جزئی و مفهوم کلی",
  "start": 20,
  "end": 21
 },
 {
  "chapter": "درس ۳",
  "position": 2,
  "title": "رابطه مفاهیم: نسبت‌های چهارگانه",
  "start": 22,
  "end": 24
 },
 {
  "chapter": "درس ۴",
  "position": 1,
  "title": "تعریف لغوی، مصداقی و مفهومی",
  "start": 29,
  "end": 33
 },
 {
  "chapter": "درس ۴",
  "position": 2,
  "title": "شرایط تعریف صحیح",
  "start": 34,
  "end": 38
 },
 {
  "chapter": "درس ۵",
  "position": 1,
  "title": "استقرای تمثیلی",
  "start": 42,
  "end": 45
 },
 {
  "chapter": "درس ۵",
  "position": 2,
  "title": "استقرای تعمیمی",
  "start": 46,
  "end": 48
 },
 {
  "chapter": "درس ۵",
  "position": 3,
  "title": "استنتاج بهترین تبیین",
  "start": 48,
  "end": 50
 },
 {
  "chapter": "درس ۶",
  "position": 1,
  "title": "قضیه و اجزای قضیه حملی",
  "start": 55,
  "end": 57
 },
 {
  "chapter": "درس ۶",
  "position": 2,
  "title": "قضایای شخصیه و محصوره",
  "start": 58,
  "end": 60
 },
 {
  "chapter": "درس ۶",
  "position": 3,
  "title": "کمیت و کیفیت قضیه",
  "start": 57,
  "end": 60
 },
 {
  "chapter": "درس ۷",
  "position": 1,
  "title": "روابط تقابل قضایا",
  "start": 62,
  "end": 67
 },
 {
  "chapter": "درس ۷",
  "position": 2,
  "title": "عکس مستوی",
  "start": 67,
  "end": 70
 },
 {
  "chapter": "درس ۸",
  "position": 1,
  "title": "مقدمه، نتیجه و حد وسط",
  "start": 72,
  "end": 73
 },
 {
  "chapter": "درس ۸",
  "position": 2,
  "title": "اشکال قیاس اقترانی و اعتبار آن",
  "start": 73,
  "end": 82
 },
 {
  "chapter": "درس ۹",
  "position": 1,
  "title": "قضیه شرطی متصل و منفصل",
  "start": 85,
  "end": 89
 },
 {
  "chapter": "درس ۹",
  "position": 2,
  "title": "اقسام قضیه منفصل",
  "start": 87,
  "end": 89
 },
 {
  "chapter": "درس ۹",
  "position": 3,
  "title": "قیاس استثنایی اتصالی و انفصالی",
  "start": 90,
  "end": 96
 },
 {
  "chapter": "درس ۱۰",
  "position": 1,
  "title": "تفکر نقادانه",
  "start": 99,
  "end": 104
 },
 {
  "chapter": "درس ۱۰",
  "position": 2,
  "title": "بار ارزشی کلمات",
  "start": 105,
  "end": 107
 },
 {
  "chapter": "درس ۱۰",
  "position": 3,
  "title": "مغالطه در اثر عوامل روانی",
  "start": 108,
  "end": 113
 }
]$fixes$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:10:'||r.track||':منطق:'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field='humanities' and t.grade='10' and t.preparation_track=r.track and t.subject='منطق' and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
with installed as (insert into private.planner_seed_installations(seed_key) values ('logic-1405-v175') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 100,
  "title": "کل درس",
  "start": 3,
  "end": 10
 },
 {
  "chapter": "درس ۱",
  "position": 101,
  "title": "منطق، خطای اندیشه و حیطه کاربرد",
  "start": 3,
  "end": 7
 },
 {
  "chapter": "درس ۱",
  "position": 102,
  "title": "تصور و تصدیق",
  "start": 7,
  "end": 8
 },
 {
  "chapter": "درس ۱",
  "position": 103,
  "title": "تعریف و استدلال",
  "start": 8,
  "end": 10
 },
 {
  "chapter": "درس ۲",
  "position": 100,
  "title": "کل درس",
  "start": 13,
  "end": 19
 },
 {
  "chapter": "درس ۲",
  "position": 101,
  "title": "مغالطه اشتراک لفظ",
  "start": 13,
  "end": 14
 },
 {
  "chapter": "درس ۲",
  "position": 102,
  "title": "نحوه دلالت لفظ بر معنا",
  "start": 14,
  "end": 15
 },
 {
  "chapter": "درس ۲",
  "position": 103,
  "title": "مغالطه نگارشی کلمات",
  "start": 16,
  "end": 16
 },
 {
  "chapter": "درس ۲",
  "position": 104,
  "title": "ابهام در مرجع ضمیر",
  "start": 17,
  "end": 19
 },
 {
  "chapter": "درس ۳",
  "position": 100,
  "title": "کل درس",
  "start": 20,
  "end": 26
 },
 {
  "chapter": "درس ۳",
  "position": 101,
  "title": "مفهوم و مصداق؛ جزئی و کلی",
  "start": 20,
  "end": 21
 },
 {
  "chapter": "درس ۳",
  "position": 102,
  "title": "نسبت‌های چهارگانه میان مفاهیم",
  "start": 22,
  "end": 24
 },
 {
  "chapter": "درس ۳",
  "position": 103,
  "title": "مفاهیم کلی ذاتی و عرضی",
  "start": 25,
  "end": 26
 },
 {
  "chapter": "درس ۴",
  "position": 100,
  "title": "کل درس",
  "start": 29,
  "end": 38
 },
 {
  "chapter": "درس ۴",
  "position": 101,
  "title": "تعریف لغوی",
  "start": 29,
  "end": 30
 },
 {
  "chapter": "درس ۴",
  "position": 102,
  "title": "تعریف از طریق ذکر مصادیق",
  "start": 30,
  "end": 31
 },
 {
  "chapter": "درس ۴",
  "position": 103,
  "title": "تعریف مفهومی و حد و رسم",
  "start": 31,
  "end": 33
 },
 {
  "chapter": "درس ۴",
  "position": 104,
  "title": "شرایط تعریف صحیح و مغالطات تعریف",
  "start": 34,
  "end": 38
 },
 {
  "chapter": "درس ۵",
  "position": 100,
  "title": "کل درس",
  "start": 41,
  "end": 52
 },
 {
  "chapter": "درس ۵",
  "position": 101,
  "title": "استدلال قیاسی و استقرایی",
  "start": 41,
  "end": 42
 },
 {
  "chapter": "درس ۵",
  "position": 102,
  "title": "استقرای تمثیلی و مغالطه تمثیل ناروا",
  "start": 42,
  "end": 45
 },
 {
  "chapter": "درس ۵",
  "position": 103,
  "title": "استقرای تعمیمی و شرایط استقرای قوی",
  "start": 46,
  "end": 48
 },
 {
  "chapter": "درس ۵",
  "position": 104,
  "title": "استنتاج بهترین تبیین",
  "start": 48,
  "end": 50
 },
 {
  "chapter": "درس ۵",
  "position": 105,
  "title": "تمرین اقسام استدلال استقرایی",
  "start": 51,
  "end": 52
 },
 {
  "chapter": "درس ۶",
  "position": 100,
  "title": "کل درس",
  "start": 55,
  "end": 61
 },
 {
  "chapter": "درس ۶",
  "position": 101,
  "title": "قضیه و اجزای قضیه حملی",
  "start": 55,
  "end": 57
 },
 {
  "chapter": "درس ۶",
  "position": 102,
  "title": "قضایای شخصیه و محصوره",
  "start": 58,
  "end": 59
 },
 {
  "chapter": "درس ۶",
  "position": 103,
  "title": "کمیت و کیفیت قضیه و سور",
  "start": 57,
  "end": 60
 },
 {
  "chapter": "درس ۶",
  "position": 104,
  "title": "تمرین قضیه حملی",
  "start": 61,
  "end": 61
 },
 {
  "chapter": "درس ۷",
  "position": 100,
  "title": "کل درس",
  "start": 62,
  "end": 71
 },
 {
  "chapter": "درس ۷",
  "position": 101,
  "title": "مربع تقابل و تناقض",
  "start": 62,
  "end": 63
 },
 {
  "chapter": "درس ۷",
  "position": 102,
  "title": "تضاد",
  "start": 64,
  "end": 64
 },
 {
  "chapter": "درس ۷",
  "position": 103,
  "title": "تداخل و تحت تضاد",
  "start": 65,
  "end": 67
 },
 {
  "chapter": "درس ۷",
  "position": 104,
  "title": "عکس مستوی و مغالطه ایهام انعکاس",
  "start": 67,
  "end": 70
 },
 {
  "chapter": "درس ۷",
  "position": 105,
  "title": "پارادوکس دروغگو",
  "start": 71,
  "end": 71
 },
 {
  "chapter": "درس ۸",
  "position": 100,
  "title": "کل درس",
  "start": 72,
  "end": 82
 },
 {
  "chapter": "درس ۸",
  "position": 101,
  "title": "اجزای قیاس اقترانی و حد وسط",
  "start": 72,
  "end": 73
 },
 {
  "chapter": "درس ۸",
  "position": 102,
  "title": "اشکال قیاس اقترانی",
  "start": 73,
  "end": 74
 },
 {
  "chapter": "درس ۸",
  "position": 103,
  "title": "قواعد اعتبار قیاس",
  "start": 75,
  "end": 80
 },
 {
  "chapter": "درس ۸",
  "position": 104,
  "title": "تاریخچه تعیین نتایج معتبر قیاس",
  "start": 81,
  "end": 81
 },
 {
  "chapter": "درس ۸",
  "position": 105,
  "title": "تمرین قیاس اقترانی",
  "start": 82,
  "end": 82
 },
 {
  "chapter": "درس ۹",
  "position": 100,
  "title": "کل درس",
  "start": 85,
  "end": 96
 },
 {
  "chapter": "درس ۹",
  "position": 101,
  "title": "قضیه شرطی متصل و مقدم و تالی",
  "start": 85,
  "end": 86
 },
 {
  "chapter": "درس ۹",
  "position": 102,
  "title": "قضیه شرطی منفصل و اقسام آن",
  "start": 87,
  "end": 89
 },
 {
  "chapter": "درس ۹",
  "position": 103,
  "title": "قیاس استثنایی اتصالی",
  "start": 90,
  "end": 92
 },
 {
  "chapter": "درس ۹",
  "position": 104,
  "title": "قیاس استثنایی انفصالی",
  "start": 92,
  "end": 95
 },
 {
  "chapter": "درس ۹",
  "position": 105,
  "title": "تمرین قضایا و قیاس استثنایی",
  "start": 96,
  "end": 96
 },
 {
  "chapter": "درس ۱۰",
  "position": 100,
  "title": "کل درس",
  "start": 99,
  "end": 113
 },
 {
  "chapter": "درس ۱۰",
  "position": 101,
  "title": "سنجشگری در تفکر و پرسش‌های سقراطی",
  "start": 99,
  "end": 100
 },
 {
  "chapter": "درس ۱۰",
  "position": 102,
  "title": "بازسازی استدلال و نشانه‌های مقدمات و نتیجه",
  "start": 101,
  "end": 102
 },
 {
  "chapter": "درس ۱۰",
  "position": 103,
  "title": "کاربردهای استدلال",
  "start": 103,
  "end": 104
 },
 {
  "chapter": "درس ۱۰",
  "position": 104,
  "title": "بار ارزشی کلمات",
  "start": 105,
  "end": 107
 },
 {
  "chapter": "درس ۱۰",
  "position": 105,
  "title": "مغالطات عوامل روانی",
  "start": 108,
  "end": 113
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v175:humanities:10:'||r.track||':منطق:'||p.chapter||':'||p.position)::uuid,'1405','humanities','10',r.track,'منطق',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
