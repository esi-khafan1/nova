-- User-supplied Logic 10 (110223), printed 1405; see docs/planner-topic-sources.md.
with installed as (insert into private.planner_seed_installations(seed_key) values ('logic-1405-v201') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 400,
  "title": "کل درس",
  "start": 3,
  "end": 10
 },
 {
  "chapter": "درس ۱",
  "position": 450,
  "title": "منطق و جلوگیری از مغالطه",
  "start": 3,
  "end": 4
 },
 {
  "chapter": "درس ۱",
  "position": 451,
  "title": "شرح: حیطه کاربرد منطق",
  "start": 5,
  "end": 5
 },
 {
  "chapter": "درس ۱",
  "position": 452,
  "title": "منطق و سیر گسترش آن",
  "start": 6,
  "end": 6
 },
 {
  "chapter": "درس ۱",
  "position": 453,
  "title": "شرح: دو بخش اصلی منطق: تعریف و استدلال",
  "start": 7,
  "end": 10
 },
 {
  "chapter": "درس ۲",
  "position": 400,
  "title": "کل درس",
  "start": 13,
  "end": 19
 },
 {
  "chapter": "درس ۲",
  "position": 450,
  "title": "شرح: اشتراک لفظ",
  "start": 13,
  "end": 13
 },
 {
  "chapter": "درس ۲",
  "position": 451,
  "title": "نحوه دلالت لفظ بر معنا در جملات",
  "start": 14,
  "end": 15
 },
 {
  "chapter": "درس ۲",
  "position": 452,
  "title": "شرح: شیوه نگارش کلمات",
  "start": 16,
  "end": 16
 },
 {
  "chapter": "درس ۲",
  "position": 453,
  "title": "شرح: ابهام در مرجع ضمیر",
  "start": 17,
  "end": 18
 },
 {
  "chapter": "درس ۲",
  "position": 454,
  "title": "دسته‌بندی نمونه‌ها",
  "start": 19,
  "end": 19
 },
 {
  "chapter": "درس ۳",
  "position": 400,
  "title": "کل درس",
  "start": 20,
  "end": 26
 },
 {
  "chapter": "درس ۳",
  "position": 450,
  "title": "شرح: مفهوم جزئی و مفهوم کلی",
  "start": 20,
  "end": 20
 },
 {
  "chapter": "درس ۳",
  "position": 451,
  "title": "رابطه میان مصادیق دو مفهوم کلی",
  "start": 21,
  "end": 22
 },
 {
  "chapter": "درس ۳",
  "position": 452,
  "title": "نسبت‌های چهارگانه و مجموعه‌ها",
  "start": 23,
  "end": 23
 },
 {
  "chapter": "درس ۳",
  "position": 453,
  "title": "استفاده از نسبت‌های چهارگانه در طبقه‌بندی مفاهیم",
  "start": 24,
  "end": 24
 },
 {
  "chapter": "درس ۳",
  "position": 454,
  "title": "مفاهیم کلی ذاتی و عرضی",
  "start": 25,
  "end": 26
 },
 {
  "chapter": "درس ۴",
  "position": 400,
  "title": "کل درس",
  "start": 29,
  "end": 38
 },
 {
  "chapter": "درس ۴",
  "position": 450,
  "title": "مقدمه تعریف",
  "start": 29,
  "end": 29
 },
 {
  "chapter": "درس ۴",
  "position": 451,
  "title": "اقسام تعریف",
  "start": 30,
  "end": 31
 },
 {
  "chapter": "درس ۴",
  "position": 452,
  "title": "تعریف به حد و رسم",
  "start": 32,
  "end": 33
 },
 {
  "chapter": "درس ۴",
  "position": 453,
  "title": "ترکیب انواع تعریف با یکدیگر",
  "start": 32,
  "end": 33
 },
 {
  "chapter": "درس ۴",
  "position": 454,
  "title": "شرح: شرایط تعریف صحیح",
  "start": 34,
  "end": 35
 },
 {
  "chapter": "درس ۴",
  "position": 455,
  "title": "اهمیت تعریف در اصطلاحات علمی",
  "start": 36,
  "end": 38
 },
 {
  "chapter": "درس ۵",
  "position": 400,
  "title": "کل درس",
  "start": 41,
  "end": 52
 },
 {
  "chapter": "درس ۵",
  "position": 450,
  "title": "اقسام استدلال",
  "start": 41,
  "end": 41
 },
 {
  "chapter": "درس ۵",
  "position": 451,
  "title": "شرح: استقرای تمثیلی",
  "start": 42,
  "end": 42
 },
 {
  "chapter": "درس ۵",
  "position": 452,
  "title": "تمثیل غار افلاطون",
  "start": 43,
  "end": 44
 },
 {
  "chapter": "درس ۵",
  "position": 453,
  "title": "شرح: استقرای تعمیمی",
  "start": 45,
  "end": 45
 },
 {
  "chapter": "درس ۵",
  "position": 454,
  "title": "استقرا و علوم تجربی",
  "start": 46,
  "end": 46
 },
 {
  "chapter": "درس ۵",
  "position": 455,
  "title": "شرایط استقرای تعمیمی قوی",
  "start": 47,
  "end": 47
 },
 {
  "chapter": "درس ۵",
  "position": 456,
  "title": "استقرای تام",
  "start": 47,
  "end": 47
 },
 {
  "chapter": "درس ۵",
  "position": 457,
  "title": "شرح: استنتاج بهترین تبیین",
  "start": 48,
  "end": 49
 },
 {
  "chapter": "درس ۵",
  "position": 458,
  "title": "استدلال دوری",
  "start": 50,
  "end": 52
 },
 {
  "chapter": "درس ۶",
  "position": 400,
  "title": "کل درس",
  "start": 55,
  "end": 61
 },
 {
  "chapter": "درس ۶",
  "position": 450,
  "title": "قضیه",
  "start": 55,
  "end": 55
 },
 {
  "chapter": "درس ۶",
  "position": 451,
  "title": "اقسام قضیه",
  "start": 56,
  "end": 57
 },
 {
  "chapter": "درس ۶",
  "position": 452,
  "title": "قضیه حملی",
  "start": 56,
  "end": 57
 },
 {
  "chapter": "درس ۶",
  "position": 453,
  "title": "اقسام قضایای حملی",
  "start": 58,
  "end": 58
 },
 {
  "chapter": "درس ۶",
  "position": 454,
  "title": "دامنه مصادیق موضوع",
  "start": 58,
  "end": 58
 },
 {
  "chapter": "درس ۶",
  "position": 455,
  "title": "اهمال سور در مکالمات روزمره",
  "start": 59,
  "end": 59
 },
 {
  "chapter": "درس ۶",
  "position": 456,
  "title": "سورهای غیراستاندارد",
  "start": 60,
  "end": 61
 },
 {
  "chapter": "درس ۷",
  "position": 400,
  "title": "کل درس",
  "start": 62,
  "end": 71
 },
 {
  "chapter": "درس ۷",
  "position": 450,
  "title": "مربع تقابل",
  "start": 62,
  "end": 62
 },
 {
  "chapter": "درس ۷",
  "position": 451,
  "title": "تناقض",
  "start": 63,
  "end": 63
 },
 {
  "chapter": "درس ۷",
  "position": 452,
  "title": "بدیهی‌ترین قضیه",
  "start": 63,
  "end": 63
 },
 {
  "chapter": "درس ۷",
  "position": 453,
  "title": "تضاد",
  "start": 64,
  "end": 64
 },
 {
  "chapter": "درس ۷",
  "position": 454,
  "title": "تداخل",
  "start": 65,
  "end": 65
 },
 {
  "chapter": "درس ۷",
  "position": 455,
  "title": "تداخل تحت تضاد",
  "start": 66,
  "end": 66
 },
 {
  "chapter": "درس ۷",
  "position": 456,
  "title": "شرح: عکس مستوی",
  "start": 67,
  "end": 68
 },
 {
  "chapter": "درس ۷",
  "position": 457,
  "title": "مغالطه ایهام انعکاس",
  "start": 69,
  "end": 70
 },
 {
  "chapter": "درس ۷",
  "position": 458,
  "title": "پارادوکس دروغگو",
  "start": 71,
  "end": 71
 },
 {
  "chapter": "درس ۸",
  "position": 400,
  "title": "کل درس",
  "start": 72,
  "end": 82
 },
 {
  "chapter": "درس ۸",
  "position": 450,
  "title": "قیاس اقترانی، مقدمات و نتیجه",
  "start": 72,
  "end": 73
 },
 {
  "chapter": "درس ۸",
  "position": 451,
  "title": "قانون نتیجه قیاس",
  "start": 74,
  "end": 75
 },
 {
  "chapter": "درس ۸",
  "position": 452,
  "title": "دامنه مصادیق موضوع و محمول",
  "start": 76,
  "end": 76
 },
 {
  "chapter": "درس ۸",
  "position": 453,
  "title": "شرایط معتبر بودن قیاس",
  "start": 77,
  "end": 77
 },
 {
  "chapter": "درس ۸",
  "position": 454,
  "title": "بررسی شرط نخست و دوم قیاس",
  "start": 78,
  "end": 78
 },
 {
  "chapter": "درس ۸",
  "position": 455,
  "title": "بررسی شرط سوم قیاس",
  "start": 79,
  "end": 80
 },
 {
  "chapter": "درس ۸",
  "position": 456,
  "title": "تاریخچه تعیین نتایج معتبر قیاس",
  "start": 81,
  "end": 82
 },
 {
  "chapter": "درس ۸",
  "position": 457,
  "title": "قانون کمیت نتیجه",
  "start": 81,
  "end": 82
 },
 {
  "chapter": "درس ۹",
  "position": 400,
  "title": "کل درس",
  "start": 85,
  "end": 96
 },
 {
  "chapter": "درس ۹",
  "position": 450,
  "title": "قضیه شرطی متصل",
  "start": 85,
  "end": 85
 },
 {
  "chapter": "درس ۹",
  "position": 451,
  "title": "قضیه شرطی منفصل و اقسام آن",
  "start": 86,
  "end": 87
 },
 {
  "chapter": "درس ۹",
  "position": 452,
  "title": "جست‌وجو در اینترنت به کمک عملگرهای منطقی",
  "start": 88,
  "end": 89
 },
 {
  "chapter": "درس ۹",
  "position": 453,
  "title": "قیاس استثنایی اتصالی",
  "start": 90,
  "end": 90
 },
 {
  "chapter": "درس ۹",
  "position": 454,
  "title": "آشنایی با منطق جدید",
  "start": 91,
  "end": 91
 },
 {
  "chapter": "درس ۹",
  "position": 455,
  "title": "قیاس استثنایی انفصالی",
  "start": 92,
  "end": 92
 },
 {
  "chapter": "درس ۹",
  "position": 456,
  "title": "قیاس انفصالی مانعة‌الجمع",
  "start": 93,
  "end": 93
 },
 {
  "chapter": "درس ۹",
  "position": 457,
  "title": "قیاس انفصالی مانعة‌الرفع",
  "start": 94,
  "end": 94
 },
 {
  "chapter": "درس ۹",
  "position": 458,
  "title": "منطق و هوش مصنوعی",
  "start": 95,
  "end": 96
 },
 {
  "chapter": "درس ۱۰",
  "position": 400,
  "title": "کل درس",
  "start": 99,
  "end": 113
 },
 {
  "chapter": "درس ۱۰",
  "position": 450,
  "title": "شرح: تفکر نقادانه",
  "start": 99,
  "end": 99
 },
 {
  "chapter": "درس ۱۰",
  "position": 451,
  "title": "سؤالات اصلی در تفکر نقادانه",
  "start": 99,
  "end": 99
 },
 {
  "chapter": "درس ۱۰",
  "position": 452,
  "title": "ویژگی‌های فرد منطقی",
  "start": 100,
  "end": 100
 },
 {
  "chapter": "درس ۱۰",
  "position": 453,
  "title": "بازسازی استدلال‌های زبان طبیعی",
  "start": 101,
  "end": 102
 },
 {
  "chapter": "درس ۱۰",
  "position": 454,
  "title": "کاربردهای استدلال",
  "start": 103,
  "end": 103
 },
 {
  "chapter": "درس ۱۰",
  "position": 455,
  "title": "مواد قیاس و صنعت‌های پنج‌گانه",
  "start": 104,
  "end": 104
 },
 {
  "chapter": "درس ۱۰",
  "position": 456,
  "title": "بار ارزشی کلمات در جملات",
  "start": 105,
  "end": 105
 },
 {
  "chapter": "درس ۱۰",
  "position": 457,
  "title": "شرح: مغالطه در اثر عوامل روانی",
  "start": 106,
  "end": 107
 },
 {
  "chapter": "درس ۱۰",
  "position": 458,
  "title": "مغالطه مسموم کردن چاه",
  "start": 108,
  "end": 108
 },
 {
  "chapter": "درس ۱۰",
  "position": 459,
  "title": "مغالطه تله‌گذاری",
  "start": 109,
  "end": 109
 },
 {
  "chapter": "درس ۱۰",
  "position": 460,
  "title": "مغالطه توسل به احساسات",
  "start": 109,
  "end": 109
 },
 {
  "chapter": "درس ۱۰",
  "position": 461,
  "title": "فنون متابعت",
  "start": 110,
  "end": 110
 },
 {
  "chapter": "درس ۱۰",
  "position": 462,
  "title": "مغالطه بزرگ‌نمایی و کوچک‌نمایی",
  "start": 111,
  "end": 111
 },
 {
  "chapter": "درس ۱۰",
  "position": 463,
  "title": "راهبرد مواجهه با مغالطات در زندگی",
  "start": 112,
  "end": 113
 },
 {
  "chapter": "درس ۱۰",
  "position": 700,
  "title": "جدول مغالطه‌های کتاب",
  "start": 114,
  "end": 114
 },
 {
  "chapter": "درس ۱۰",
  "position": 701,
  "title": "نسبت‌ها، اقسام تعریف و احکام قضایا",
  "start": 115,
  "end": 115
 },
 {
  "chapter": "درس ۱۰",
  "position": 702,
  "title": "اقسام قضیه و استدلال",
  "start": 116,
  "end": 116
 },
 {
  "chapter": "درس ۱۰",
  "position": 703,
  "title": "فرهنگ اصطلاحات",
  "start": 117,
  "end": 123
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v201:humanities:10:'||r.track||':منطق:'||p.chapter||':'||p.position)::uuid,'1405','humanities','10',r.track,'منطق',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "درس ۱",
  "position": 1,
  "title": "حیطه کاربرد منطق",
  "start": 5,
  "end": 6
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
  "start": 21,
  "end": 25
 },
 {
  "chapter": "درس ۴",
  "position": 1,
  "title": "تعریف لغوی، مصداقی و مفهومی",
  "start": 30,
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
  "end": 44
 },
 {
  "chapter": "درس ۵",
  "position": 2,
  "title": "استقرای تعمیمی",
  "start": 45,
  "end": 47
 },
 {
  "chapter": "درس ۵",
  "position": 3,
  "title": "استنتاج بهترین تبیین",
  "start": 48,
  "end": 52
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
  "start": 58,
  "end": 61
 },
 {
  "chapter": "درس ۷",
  "position": 1,
  "title": "روابط تقابل قضایا",
  "start": 62,
  "end": 66
 },
 {
  "chapter": "درس ۷",
  "position": 2,
  "title": "عکس مستوی",
  "start": 67,
  "end": 71
 },
 {
  "chapter": "درس ۸",
  "position": 1,
  "title": "مقدمه، نتیجه و حد وسط",
  "start": 72,
  "end": 75
 },
 {
  "chapter": "درس ۸",
  "position": 2,
  "title": "اشکال قیاس اقترانی و اعتبار آن",
  "start": 76,
  "end": 82
 },
 {
  "chapter": "درس ۹",
  "position": 1,
  "title": "قضیه شرطی متصل و منفصل",
  "start": 85,
  "end": 87
 },
 {
  "chapter": "درس ۹",
  "position": 2,
  "title": "اقسام قضیه منفصل",
  "start": 86,
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
  "end": 106
 },
 {
  "chapter": "درس ۱۰",
  "position": 3,
  "title": "مغالطه در اثر عوامل روانی",
  "start": 106,
  "end": 113
 }
]$fixes$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:10:'||r.track||':منطق:'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field='humanities' and t.grade='10' and t.preparation_track=r.track and t.subject='منطق' and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
