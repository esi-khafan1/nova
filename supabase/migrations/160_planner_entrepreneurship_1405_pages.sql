-- Book provided by the user: 110224, tenth printing 1405, printed pages.
-- Ranges are inclusive educational groupings, not all verbatim book headings.
-- Compare the complete original seed identity, pages and revision before updating.
with pages as (select * from jsonb_to_recordset($pages$[
 {
  "generation": "v155",
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۶: تیپ‌های شخصیتی",
  "position": 103,
  "start": 21,
  "end": 24
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۶: شناخت شخصیت و انتخاب شغل",
  "position": 104,
  "start": 24,
  "end": 26
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۷: طراحی مسیر شغلی آینده",
  "position": 105,
  "start": 27,
  "end": 28
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۷: نگرش‌ها و توسعه شخصی",
  "position": 106,
  "start": 29,
  "end": 30
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۸: شناسایی ارزش‌ها",
  "position": 107,
  "start": 31,
  "end": 32
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۸: شناسایی نیازها",
  "position": 108,
  "start": 32,
  "end": 34
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۹: شناسایی مهارت‌ها و استعدادها",
  "position": 109,
  "start": 35,
  "end": 37
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۵ تا ۹",
  "title": "بخش ۹: علایق و گرایش‌ها و جمع‌بندی",
  "position": 110,
  "start": 37,
  "end": 40
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۰: تفکر انتقادی و جست‌وجوی واقعیت",
  "position": 101,
  "start": 43,
  "end": 44
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۰: مدل ایجاد تفکر انتقادی",
  "position": 102,
  "start": 44,
  "end": 44
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۱: تفکر خلاق و واگرا",
  "position": 103,
  "start": 47,
  "end": 48
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۱: موانع تفکر خلاق",
  "position": 104,
  "start": 48,
  "end": 50
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۲: خلاقیت و روش‌های توسعه آن",
  "position": 105,
  "start": 51,
  "end": 54
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۲: روش اسکمپر",
  "position": 106,
  "start": 52,
  "end": 53
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۳: روش طوفان فکری",
  "position": 107,
  "start": 55,
  "end": 55
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۳: روش شکوفه نیلوفر آبی",
  "position": 108,
  "start": 58,
  "end": 58
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۴: تشخیص و منابع فرصت",
  "position": 109,
  "start": 59,
  "end": 60
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۴: ایده‌پردازی و روش‌های ایده‌یابی",
  "position": 110,
  "start": 61,
  "end": 62
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۴: ارزیابی خوب بودن و عملی بودن ایده",
  "position": 111,
  "start": 63,
  "end": 64
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۵: ایده‌یابی بر مبنای تجربه",
  "position": 112,
  "start": 65,
  "end": 66
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۵: ساختن ایده و الگوبرداری",
  "position": 113,
  "start": 67,
  "end": 68
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۶: نوآوری و روش تریز",
  "position": 114,
  "start": 69,
  "end": 69
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۶: اصول ابداعی و کاربرد آنها",
  "position": 115,
  "start": 70,
  "end": 74
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۷: کارآفرینی و انواع آن",
  "position": 116,
  "start": 75,
  "end": 76
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۷: مهارت‌های کارآفرین",
  "position": 117,
  "start": 77,
  "end": 77
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۷: تولید ملی و حمایت از کار و سرمایه ایرانی",
  "position": 118,
  "start": 78,
  "end": 78
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۱۸: مفهوم و انواع کسب‌وکار",
  "position": 101,
  "start": 79,
  "end": 79
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۱۸: انتخاب نوع کسب‌وکار",
  "position": 102,
  "start": 80,
  "end": 80
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۱۹: بوم مدل کسب‌وکار",
  "position": 103,
  "start": 81,
  "end": 82
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۱۹: بخش‌بندی و شناسایی مشتریان",
  "position": 104,
  "start": 83,
  "end": 83
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۱۹: ارزیابی مشتری‌شناسی",
  "position": 105,
  "start": 84,
  "end": 84
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۲۹: معرفی و اهداف کسب‌وکار",
  "position": 101,
  "start": 109,
  "end": 110
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۲۹: نام، محصول و محل اجرای طرح",
  "position": 102,
  "start": 111,
  "end": 111
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۲۹: مالکیت و سازماندهی نیروی انسانی",
  "position": 103,
  "start": 112,
  "end": 114
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۳۲: سرمایه‌گذاری و هزینه‌های طرح",
  "position": 104,
  "start": 123,
  "end": 124
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۳۲: برآورد درآمد و سودآوری",
  "position": 105,
  "start": 125,
  "end": 126
 },
 {
  "generation": "v155",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۳۲: برنامه زمان‌بندی و ارائه طرح در نمایشگاه",
  "position": 106,
  "start": 126,
  "end": 127
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۰: راه‌های توسعه ارزش پیشنهادی",
  "position": 201,
  "start": 85,
  "end": 85
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۰: شناسایی نیاز و رضایت مشتری",
  "position": 202,
  "start": 86,
  "end": 87
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۰: تکمیل و ارزیابی ارزش پیشنهادی در بوم",
  "position": 203,
  "start": 88,
  "end": 88
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۱: انواع کانال‌های مستقیم، غیرمستقیم و شریکی",
  "position": 204,
  "start": 89,
  "end": 89
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۱: وظایف کانال از آگاهی تا خدمات پس از فروش",
  "position": 205,
  "start": 89,
  "end": 89
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۱: انتخاب و ارزیابی کانال توزیع",
  "position": 206,
  "start": 90,
  "end": 90
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۲: نیازها و انتظارات مشتری",
  "position": 207,
  "start": 91,
  "end": 91
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۲: شیوه‌های ارتباط و اخلاق مشتری‌مداری",
  "position": 208,
  "start": 91,
  "end": 92
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۲: تکمیل و ارزیابی ارتباط با مشتری",
  "position": 209,
  "start": 92,
  "end": 92
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۳: روش‌های درآمدزایی",
  "position": 210,
  "start": 93,
  "end": 94
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۳: قیمت‌گذاری مقطوع و پویا",
  "position": 211,
  "start": 94,
  "end": 94
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۳: خطرپذیری و بازی پرتاب حلقه",
  "position": 212,
  "start": 95,
  "end": 95
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۳: تکمیل و ارزیابی الگوی درآمدی",
  "position": 213,
  "start": 96,
  "end": 96
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۴: منابع انسانی، معنوی، مالی، فیزیکی و اجتماعی",
  "position": 214,
  "start": 97,
  "end": 97
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۴: شناسایی و ارزیابی منابع کلیدی",
  "position": 215,
  "start": 98,
  "end": 98
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۵: تولید و خدمات، حل مسئله و شبکه",
  "position": 216,
  "start": 99,
  "end": 99
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۵: انتخاب و ارزیابی فعالیت‌های کلیدی",
  "position": 217,
  "start": 100,
  "end": 100
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۶: انگیزه‌های شراکت و کاهش خطر",
  "position": 218,
  "start": 101,
  "end": 101
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۶: تکمیل و ارزیابی شریک‌یابی",
  "position": 219,
  "start": 102,
  "end": 102
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۷: ساختار هزینه‌محور و ارزش‌محور",
  "position": 220,
  "start": 103,
  "end": 103
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۷: هزینه‌های ثابت و متغیر",
  "position": 221,
  "start": 104,
  "end": 104
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۱۸ تا ۲۷",
  "title": "بخش ۲۷: تکمیل و ارزیابی هزینه‌ها",
  "position": 222,
  "start": 104,
  "end": 104
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۲۸: تعریف و اجزای طرح کسب‌وکار",
  "position": 201,
  "start": 105,
  "end": 108
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۲۸: نقاط قوت، ضعف، فرصت‌ها و تهدیدها",
  "position": 202,
  "start": 107,
  "end": 107
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۲۸: طراحی راهبرد و بررسی نمونه طرح‌ها",
  "position": 203,
  "start": 107,
  "end": 108
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۳۰: بررسی بازار، مشتریان و رقیبان",
  "position": 204,
  "start": 115,
  "end": 116
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۳۰: پیش‌بینی فروش",
  "position": 205,
  "start": 115,
  "end": 116
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۳۰: بازاریابی: محصول، قیمت، تبلیغ، فروش و توزیع",
  "position": 206,
  "start": 116,
  "end": 117
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۳۰: اخلاق و احکام بازار اسلامی",
  "position": 207,
  "start": 118,
  "end": 118
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۳۱: روش اجرای کار و مکان‌یابی",
  "position": 208,
  "start": 119,
  "end": 120
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۳۱: چیدمان دفاتر و تجهیزات",
  "position": 209,
  "start": 120,
  "end": 120
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۳۱: طراحی و توسعه محصول یا خدمت",
  "position": 210,
  "start": 121,
  "end": 121
 },
 {
  "generation": "v156",
  "chapter": "بخش‌های ۲۸ تا ۳۲",
  "title": "بخش ۳۱: منابع موردنیاز و کیفیت",
  "position": 211,
  "start": 121,
  "end": 121
 }
]$pages$::jsonb)
 as p(generation text,chapter text,title text,position integer,start integer,"end" integer)),
 fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
update private.planner_topic_bank t
set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from pages p cross join fields f
where t.id=md5('nova:planner:1405:'||p.generation||':'||f.field||':10:final_exam:کارگاه کارآفرینی و تولید:'||p.chapter||':'||p.position)::uuid
 and t.edition='1405' and t.study_field=f.field and t.grade='10' and t.preparation_track='final_exam'
 and t.subject='کارگاه کارآفرینی و تولید' and t.chapter=p.chapter and t.title=p.title and t.position=p.position
 and t.page_start is null and t.page_end is null and t.revision=1;

-- Preserve edits made to existing seed rows; these additional named headings have
-- independent stable IDs and never update existing or published plan snapshots.
with topics as (select * from jsonb_to_recordset($new$[
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۰: کارکرد نیم‌کره‌های مغز",
  "position": 305,
  "start": 41,
  "end": 42
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۰: تفکر همگرا",
  "position": 301,
  "start": 45,
  "end": 46
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۲: روش کشش مسئله",
  "position": 302,
  "start": 54,
  "end": 54
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۳: روش شش کلاه تفکر",
  "position": 303,
  "start": 56,
  "end": 57
 },
 {
  "chapter": "بخش‌های ۱۰ تا ۱۷",
  "title": "بخش ۱۶: طراحی و ارزیابی نوآوری",
  "position": 304,
  "start": 73,
  "end": 74
 }
]$new$::jsonb)
 as p(chapter text,title text,position integer,start integer,"end" integer)),
 fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v160:'||f.field||':10:final_exam:کارگاه کارآفرینی و تولید:'||p.chapter||':'||p.position)::uuid,
 '1405',f.field,'10','final_exam','کارگاه کارآفرینی و تولید',p.chapter,p.title,p.start,p."end",p.position
from topics p cross join fields f on conflict (id) do nothing;
