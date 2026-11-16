-- Philosophy 1, textbook 111226, 1405: finer subjects and exercises checked against the user PDF.
-- Existing records and administrator changes are not modified; installed once for both tracks.
with installed as (insert into private.planner_seed_installations(seed_key) values ('philosophy11-finer-1405-v215') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "title": "گفت‌وگو درباره پرسش‌های بنیادی",
  "start": 2,
  "end": 3,
  "position": 700
 },
 {
  "chapter": "درس ۱",
  "title": "پرسشگری انسان و مقایسه پرسش‌ها",
  "start": 4,
  "end": 4,
  "position": 701
 },
 {
  "chapter": "درس ۱",
  "title": "مراحل تفکر فلسفی و خودارزیابی",
  "start": 5,
  "end": 5,
  "position": 702
 },
 {
  "chapter": "درس ۱",
  "title": "شعر اقبال و گفت‌وگو درباره فلسفه",
  "start": 6,
  "end": 6,
  "position": 703
 },
 {
  "chapter": "درس ۱",
  "title": "معناهای تاریخی واژه فلسفه",
  "start": 8,
  "end": 8,
  "position": 704
 },
 {
  "chapter": "درس ۱",
  "title": "بنیادی بودن موضوع فلسفه و تفکیک موضوع‌ها",
  "start": 9,
  "end": 9,
  "position": 705
 },
 {
  "chapter": "درس ۱",
  "title": "روش عقلی و قیاسی در فلسفه",
  "start": 10,
  "end": 10,
  "position": 706
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین‌های تفکر فلسفی",
  "start": 11,
  "end": 11,
  "position": 707
 },
 {
  "chapter": "درس ۲",
  "title": "دسته‌بندی گزاره‌های بنیادی و شاخه‌ای",
  "start": 12,
  "end": 12,
  "position": 700
 },
 {
  "chapter": "درس ۲",
  "title": "وجودشناسی و معرفت‌شناسی",
  "start": 13,
  "end": 13,
  "position": 701
 },
 {
  "chapter": "درس ۲",
  "title": "شاخه‌های فلسفه و فلسفه‌های مضاف",
  "start": 14,
  "end": 15,
  "position": 702
 },
 {
  "chapter": "درس ۲",
  "title": "رابطه فلسفه مضاف با علوم؛ اصالت فرد و جامعه",
  "start": 15,
  "end": 16,
  "position": 703
 },
 {
  "chapter": "درس ۲",
  "title": "تجربه دانشجوی علوم تربیتی و دسته‌بندی",
  "start": 17,
  "end": 17,
  "position": 704
 },
 {
  "chapter": "درس ۲",
  "title": "تمرین موضوع فیزیک و قلمرو فلسفه",
  "start": 18,
  "end": 18,
  "position": 705
 },
 {
  "chapter": "درس ۳",
  "title": "گفت‌وگوی ماهیگیر و تاجر و بررسی سبک زندگی",
  "start": 19,
  "end": 20,
  "position": 700
 },
 {
  "chapter": "درس ۳",
  "title": "باورها، معنای زندگی و انتخاب هدف",
  "start": 21,
  "end": 22,
  "position": 701
 },
 {
  "chapter": "درس ۳",
  "title": "دوری از مغالطه و تأمل",
  "start": 22,
  "end": 22,
  "position": 702
 },
 {
  "chapter": "درس ۳",
  "title": "استقلال در اندیشه و رابطه دین و تفکر",
  "start": 23,
  "end": 23,
  "position": 703
 },
 {
  "chapter": "درس ۳",
  "title": "عادت‌های غیرمنطقی و تمثیل غار افلاطون",
  "start": 24,
  "end": 26,
  "position": 704
 },
 {
  "chapter": "درس ۳",
  "title": "تمرین‌های فلسفه و زندگی",
  "start": 26,
  "end": 27,
  "position": 705
 },
 {
  "chapter": "درس ۴",
  "title": "آغاز اندیشه فلسفی و تمدن‌های کهن",
  "start": 28,
  "end": 29,
  "position": 700
 },
 {
  "chapter": "درس ۴",
  "title": "پیدایش فلسفه در یونان و ایونیا",
  "start": 30,
  "end": 30,
  "position": 701
 },
 {
  "chapter": "درس ۴",
  "title": "تالس و مبدأ آب؛ فیثاغورس و اعداد",
  "start": 31,
  "end": 31,
  "position": 702
 },
 {
  "chapter": "درس ۴",
  "title": "هراکلیتوس، تضاد و تغییر دائمی",
  "start": 31,
  "end": 32,
  "position": 703
 },
 {
  "chapter": "درس ۴",
  "title": "پارمنیدس، هستی ثابت و شناخت عقلی",
  "start": 32,
  "end": 33,
  "position": 704
 },
 {
  "chapter": "درس ۴",
  "title": "نقشه مراکز اولیه فلسفه و حکمت",
  "start": 33,
  "end": 33,
  "position": 705
 },
 {
  "chapter": "درس ۴",
  "title": "سوفیست‌ها و فن سخنوری",
  "start": 34,
  "end": 34,
  "position": 706
 },
 {
  "chapter": "درس ۴",
  "title": "تمرین نسبت دادن اندیشه‌ها به فیلسوفان",
  "start": 35,
  "end": 35,
  "position": 707
 },
 {
  "chapter": "درس ۵",
  "title": "زندگی سقراط و وضعیت فکری آتن",
  "start": 36,
  "end": 37,
  "position": 700
 },
 {
  "chapter": "درس ۵",
  "title": "سقراط، حقیقت‌جویی و مقابله با سوفسطائیان",
  "start": 37,
  "end": 38,
  "position": 701
 },
 {
  "chapter": "درس ۵",
  "title": "روش سقراطی و پرسش و پاسخ",
  "start": 38,
  "end": 38,
  "position": 702
 },
 {
  "chapter": "درس ۵",
  "title": "اتهام‌های سقراط در دادگاه",
  "start": 39,
  "end": 39,
  "position": 703
 },
 {
  "chapter": "درس ۵",
  "title": "دفاعیات سقراط و پایان زندگی او",
  "start": 39,
  "end": 42,
  "position": 704
 },
 {
  "chapter": "درس ۵",
  "title": "تأمل درباره زندگی و منش سقراط",
  "start": 42,
  "end": 42,
  "position": 705
 },
 {
  "chapter": "درس ۶",
  "title": "گزاره‌ها و پرسش‌های مربوط به شناخت",
  "start": 44,
  "end": 45,
  "position": 700
 },
 {
  "chapter": "درس ۶",
  "title": "معرفت‌شناسی و چیستی معرفت",
  "start": 46,
  "end": 46,
  "position": 701
 },
 {
  "chapter": "درس ۶",
  "title": "امکان شناخت و تفاوت شک موردی و شک مطلق",
  "start": 47,
  "end": 48,
  "position": 702
 },
 {
  "chapter": "درس ۶",
  "title": "پیشرفت پیوسته دانش انسان",
  "start": 48,
  "end": 48,
  "position": 703
 },
 {
  "chapter": "درس ۶",
  "title": "تمرین پیشرفت دانش و امکان شناخت",
  "start": 49,
  "end": 49,
  "position": 704
 },
 {
  "chapter": "درس ۷",
  "title": "بررسی گزاره‌ها و ابزارهای شناخت",
  "start": 50,
  "end": 50,
  "position": 700
 },
 {
  "chapter": "درس ۷",
  "title": "شناخت حسی و قلمرو حواس",
  "start": 51,
  "end": 51,
  "position": 701
 },
 {
  "chapter": "درس ۷",
  "title": "شناخت عقلی و استدلال در علوم",
  "start": 52,
  "end": 54,
  "position": 702
 },
 {
  "chapter": "درس ۷",
  "title": "شناخت قلبی و شهود",
  "start": 54,
  "end": 55,
  "position": 703
 },
 {
  "chapter": "درس ۷",
  "title": "وحی الهی و تفاوت وحی با شهود عارفانه",
  "start": 55,
  "end": 56,
  "position": 704
 },
 {
  "chapter": "درس ۷",
  "title": "مقایسه و تمرین ابزارهای شناخت",
  "start": 56,
  "end": 57,
  "position": 705
 },
 {
  "chapter": "درس ۸",
  "title": "دوره‌های تاریخ معرفت و اختلاف حس و عقل",
  "start": 58,
  "end": 59,
  "position": 700
 },
 {
  "chapter": "درس ۸",
  "title": "پارمنیدس و هراکلیتوس: حس یا عقل",
  "start": 59,
  "end": 60,
  "position": 701
 },
 {
  "chapter": "درس ۸",
  "title": "سوفسطائیان و بی‌اعتباری کل معرفت",
  "start": 60,
  "end": 60,
  "position": 702
 },
 {
  "chapter": "درس ۸",
  "title": "افلاطون و ارسطو: اعتبار حس و عقل",
  "start": 60,
  "end": 61,
  "position": 703
 },
 {
  "chapter": "درس ۸",
  "title": "فیلسوفان مسلمان و اعتبار حس و عقل",
  "start": 61,
  "end": 62,
  "position": 704
 },
 {
  "chapter": "درس ۸",
  "title": "سهروردی و معرفت شهودی",
  "start": 62,
  "end": 62,
  "position": 705
 },
 {
  "chapter": "درس ۸",
  "title": "ملاصدرا و بهره‌گیری از همه ابزارهای معرفت",
  "start": 62,
  "end": 63,
  "position": 706
 },
 {
  "chapter": "درس ۸",
  "title": "دوره جدید اروپا: تجربه‌گرایی و عقل‌گرایی",
  "start": 63,
  "end": 64,
  "position": 707
 },
 {
  "chapter": "درس ۸",
  "title": "کانت و تجربه‌گرایی مطلق",
  "start": 65,
  "end": 65,
  "position": 708
 },
 {
  "chapter": "درس ۸",
  "title": "محدودیت تجربه و نسبی‌گرایی",
  "start": 66,
  "end": 66,
  "position": 709
 },
 {
  "chapter": "درس ۸",
  "title": "پراگماتیسم و اصالت عمل",
  "start": 67,
  "end": 67,
  "position": 710
 },
 {
  "chapter": "درس ۸",
  "title": "تمرین تاریخچه معرفت",
  "start": 68,
  "end": 68,
  "position": 711
 },
 {
  "chapter": "درس ۹",
  "title": "داستان اولویت‌های زندگی و پرسش از حقیقت انسان",
  "start": 70,
  "end": 71,
  "position": 700
 },
 {
  "chapter": "درس ۹",
  "title": "پرسش از من و حقیقت انسان",
  "start": 71,
  "end": 72,
  "position": 701
 },
 {
  "chapter": "درس ۹",
  "title": "دیدگاه افلاطون و ارسطو درباره نفس",
  "start": 72,
  "end": 72,
  "position": 702
 },
 {
  "chapter": "درس ۹",
  "title": "دکارت و دیدگاه معتقدان به روح و بدن",
  "start": 73,
  "end": 74,
  "position": 703
 },
 {
  "chapter": "درس ۹",
  "title": "ماتریالیسم و دیدگاه‌های داروینیستی",
  "start": 74,
  "end": 75,
  "position": 704
 },
 {
  "chapter": "درس ۹",
  "title": "مقایسه دیدگاه‌های حقیقت انسان",
  "start": 75,
  "end": 75,
  "position": 705
 },
 {
  "chapter": "درس ۱۰",
  "title": "شعر ابن‌سینا و تأمل درباره هبوط روح",
  "start": 76,
  "end": 77,
  "position": 700
 },
 {
  "chapter": "درس ۱۰",
  "title": "فیلسوفان مسلمان و حقیقت انسان",
  "start": 78,
  "end": 78,
  "position": 701
 },
 {
  "chapter": "درس ۱۰",
  "title": "دیدگاه ابن‌سینا درباره روح",
  "start": 79,
  "end": 79,
  "position": 702
 },
 {
  "chapter": "درس ۱۰",
  "title": "سهروردی و حقیقت نورانی نفس",
  "start": 80,
  "end": 80,
  "position": 703
 },
 {
  "chapter": "درس ۱۰",
  "title": "ملاصدرا و وحدت روح و بدن",
  "start": 81,
  "end": 82,
  "position": 704
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین و نکته درباره نفس",
  "start": 82,
  "end": 82,
  "position": 705
 },
 {
  "chapter": "درس ۱۱",
  "title": "اخلاق‌گرایی انسان و گفت‌وگوی داود و سامان",
  "start": 83,
  "end": 84,
  "position": 700
 },
 {
  "chapter": "درس ۱۱",
  "title": "فعل طبیعی، فعل اخلاقی و معیار اخلاق",
  "start": 85,
  "end": 86,
  "position": 701
 },
 {
  "chapter": "درس ۱۱",
  "title": "افلاطون و ارسطو و فضیلت‌های اخلاقی",
  "start": 86,
  "end": 87,
  "position": 702
 },
 {
  "chapter": "درس ۱۱",
  "title": "کانت و وجدان اخلاقی",
  "start": 88,
  "end": 88,
  "position": 703
 },
 {
  "chapter": "درس ۱۱",
  "title": "دیدگاه طبیعت‌گرایان درباره معیار اخلاق",
  "start": 89,
  "end": 89,
  "position": 704
 },
 {
  "chapter": "درس ۱۱",
  "title": "فیلسوفان مسلمان، عقل عملی و فضائل",
  "start": 90,
  "end": 91,
  "position": 705
 },
 {
  "chapter": "درس ۱۱",
  "title": "پشتوانه اخلاق و تمرین مصداق‌یابی",
  "start": 91,
  "end": 92,
  "position": 706
 },
 {
  "chapter": "درس ۱۱",
  "title": "تمرین معیار فعل اخلاقی",
  "start": 93,
  "end": 93,
  "position": 707
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v215:humanities:11:'||r.track||':فلسفه ۱:'||p.chapter||':'||p.position)::uuid,'1405','humanities','11',r.track,'فلسفه ۱',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
