-- Geometry 2 (111213), printed 1405. Only the three chapters present in the supplied PDF.
with installed as (insert into private.planner_seed_installations(seed_key) values ('geometry2-1405-v203') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "فصل ۱: دایره",
  "position": 400,
  "title": "کل فصل",
  "start": 9,
  "end": 30
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 450,
  "title": "مفاهیم اولیه دایره",
  "start": 10,
  "end": 10
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 451,
  "title": "وضعیت خط و دایره",
  "start": 11,
  "end": 11
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 452,
  "title": "وتر، قطر، زاویه مرکزی و محاطی و کمان",
  "start": 12,
  "end": 12
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 453,
  "title": "وترها و کمان‌های برابر",
  "start": 13,
  "end": 13
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 454,
  "title": "اندازه زاویه محاطی",
  "start": 14,
  "end": 14
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 455,
  "title": "اندازه زاویه ظلی",
  "start": 15,
  "end": 15
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 456,
  "title": "زاویه‌های حاصل از تقاطع خطوط با دایره",
  "start": 16,
  "end": 17
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 457,
  "title": "روابط طولی دو وتر متقاطع",
  "start": 18,
  "end": 18
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 458,
  "title": "رابطه طولی مماس و قاطع",
  "start": 19,
  "end": 19
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 459,
  "title": "وضعیت دو دایره نسبت به هم",
  "start": 20,
  "end": 20
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 460,
  "title": "مماس مشترک خارجی و داخلی",
  "start": 21,
  "end": 23
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 461,
  "title": "چندضلعی محاطی و محیطی",
  "start": 24,
  "end": 25
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 462,
  "title": "دایره محاطی خارجی مثلث",
  "start": 26,
  "end": 26
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 463,
  "title": "چهارضلعی محاطی",
  "start": 27,
  "end": 27
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 464,
  "title": "چهارضلعی محیطی",
  "start": 28,
  "end": 28
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 465,
  "title": "چندضلعی منتظم محاطی و محیطی",
  "start": 29,
  "end": 30
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 400,
  "title": "کل فصل",
  "start": 31,
  "end": 58
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 450,
  "title": "آشنایی با تبدیل‌های هندسی",
  "start": 32,
  "end": 32
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 451,
  "title": "بازتاب، انتقال و دوران",
  "start": 33,
  "end": 33
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 452,
  "title": "تبدیل طول‌پا",
  "start": 34,
  "end": 35
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 453,
  "title": "بازتاب و نقطه ثابت",
  "start": 36,
  "end": 38
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 454,
  "title": "انتقال با بردار",
  "start": 39,
  "end": 39
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 455,
  "title": "دوران",
  "start": 40,
  "end": 43
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 456,
  "title": "تجانس و نسبت تجانس",
  "start": 44,
  "end": 45
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 457,
  "title": "تجانس مستقیم و معکوس، انقباض و انبساط",
  "start": 46,
  "end": 46
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 458,
  "title": "حفظ زاویه در تجانس",
  "start": 47,
  "end": 47
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 459,
  "title": "تبدیل همانی",
  "start": 48,
  "end": 49
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 460,
  "title": "کاربرد تبدیل‌های هندسی",
  "start": 50,
  "end": 50
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 461,
  "title": "کاربرد بازتاب",
  "start": 51,
  "end": 51
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 462,
  "title": "مسائل کوتاه‌ترین مسیر",
  "start": 52,
  "end": 54
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 463,
  "title": "تبدیل‌های تقارنی",
  "start": 55,
  "end": 55
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 464,
  "title": "تقارن بازتابی و دورانی",
  "start": 56,
  "end": 56
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 465,
  "title": "تقارن همانی",
  "start": 57,
  "end": 58
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 400,
  "title": "کل فصل",
  "start": 59,
  "end": 75
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 450,
  "title": "روابط طولی و نسبت‌های مثلثاتی",
  "start": 60,
  "end": 60
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 451,
  "title": "دایره محیطی مثلث",
  "start": 61,
  "end": 61
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 452,
  "title": "اثبات و کاربرد قضیه سینوس‌ها",
  "start": 62,
  "end": 63
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 453,
  "title": "شرح: قضیه کسینوس‌ها",
  "start": 64,
  "end": 66
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 454,
  "title": "قضیه میانه",
  "start": 67,
  "end": 67
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 455,
  "title": "قضیه نیمسازهای زوایای داخلی",
  "start": 68,
  "end": 68
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 456,
  "title": "محاسبه طول نیمسازهای داخلی",
  "start": 69,
  "end": 70
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 457,
  "title": "ارتفاع و مساحت مثلث",
  "start": 71,
  "end": 71
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 458,
  "title": "دستور هرون",
  "start": 72,
  "end": 72
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 459,
  "title": "مساحت مثلث با سینوس",
  "start": 73,
  "end": 74
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 460,
  "title": "اثبات دستور هرون",
  "start": 75,
  "end": 75
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v203:mathematics:11:'||r.track||':هندسه ۲:'||p.chapter||':'||p.position)::uuid,'1405','mathematics','11',r.track,'هندسه ۲',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "فصل ۱: دایره",
  "position": 1,
  "title": "مفاهیم اولیه و زاویه‌ها در دایره",
  "start": 10,
  "end": 17
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 2,
  "title": "رابطه‌های طولی در دایره",
  "start": 18,
  "end": 23
 },
 {
  "chapter": "فصل ۱: دایره",
  "position": 3,
  "title": "چندضلعی‌های محاطی و محیطی",
  "start": 24,
  "end": 30
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 1,
  "title": "تبدیل‌های هندسی",
  "start": 32,
  "end": 49
 },
 {
  "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
  "position": 2,
  "title": "کاربرد تبدیل‌ها",
  "start": 50,
  "end": 58
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 1,
  "title": "قضیه سینوس‌ها",
  "start": 60,
  "end": 63
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 2,
  "title": "قضیه کسینوس‌ها",
  "start": 64,
  "end": 67
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 3,
  "title": "قضیه نیمسازهای زوایای داخلی و محاسبه طول نیمسازها",
  "start": 68,
  "end": 70
 },
 {
  "chapter": "فصل ۳: روابط طولی در مثلث",
  "position": 4,
  "title": "قضیه هرون (محاسبه ارتفاع‌ها و مساحت مثلث)",
  "start": 71,
  "end": 75
 }
]$fixes$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:mathematics:11:'||r.track||':هندسه ۲:'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field='mathematics' and t.grade='11' and t.preparation_track=r.track and t.subject='هندسه ۲' and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
