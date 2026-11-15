-- User-supplied 111220, tenth printing 1405. Page 263 is the final lesson's final page.
-- Backfill only unchanged seed rows; keep administrator changes and source snapshots.
with lessons as (select * from jsonb_to_recordset($lessons$[
 {
  "chapter": "درس ۱",
  "title": "کل درس: حکومت قاجار از آقامحمدخان تا محمدشاه",
  "start": 17,
  "end": 26
 },
 {
  "chapter": "درس ۲",
  "title": "کل درس: دوران ناصرالدین شاه",
  "start": 27,
  "end": 36
 },
 {
  "chapter": "درس ۳",
  "title": "کل درس: زمینه‌های نهضت مشروطه",
  "start": 37,
  "end": 42
 },
 {
  "chapter": "درس ۴",
  "title": "کل درس: آغاز حرکت مردم علیه استبداد داخلی و استعمار خارجی",
  "start": 43,
  "end": 51
 },
 {
  "chapter": "درس ۵",
  "title": "کل درس: مشروطه در دوره محمدعلی شاه",
  "start": 52,
  "end": 60
 },
 {
  "chapter": "درس ۶",
  "title": "کل درس: دوره دوم مشروطه",
  "start": 61,
  "end": 72
 },
 {
  "chapter": "درس ۷",
  "title": "کل درس: کودتای ۱۲۹۹",
  "start": 73,
  "end": 81
 },
 {
  "chapter": "درس ۸",
  "title": "کل درس: رضاخان؛ تثبیت قدرت",
  "start": 82,
  "end": 89
 },
 {
  "chapter": "درس ۹",
  "title": "کل درس: ویژگی‌های حکومت رضاشاه",
  "start": 90,
  "end": 98
 },
 {
  "chapter": "درس ۱۰",
  "title": "کل درس: سقوط رضاشاه",
  "start": 99,
  "end": 105
 },
 {
  "chapter": "درس ۱۱",
  "title": "کل درس: اشغال ایران توسط متفقین و آثار آن",
  "start": 106,
  "end": 112
 },
 {
  "chapter": "درس ۱۲",
  "title": "کل درس: نهضت ملی شدن صنعت نفت",
  "start": 113,
  "end": 118
 },
 {
  "chapter": "درس ۱۳",
  "title": "کل درس: زمینه‌های کودتای ۲۸ مرداد",
  "start": 119,
  "end": 128
 },
 {
  "chapter": "درس ۱۴",
  "title": "کل درس: کودتای بیست و هشتم مرداد",
  "start": 129,
  "end": 134
 },
 {
  "chapter": "درس ۱۵",
  "title": "کل درس: ربع قرن سیطره آمریکا بر ایران",
  "start": 135,
  "end": 141
 },
 {
  "chapter": "درس ۱۶",
  "title": "کل درس: زمینه‌ها و هدف‌های اصلاحات آمریکایی در ایران",
  "start": 142,
  "end": 145
 },
 {
  "chapter": "درس ۱۷",
  "title": "کل درس: پیدایش نهضت روحانیت و اوج‌گیری بیداری اسلامی",
  "start": 146,
  "end": 151
 },
 {
  "chapter": "درس ۱۸",
  "title": "کل درس: قیام ۱۵ خرداد",
  "start": 152,
  "end": 161
 },
 {
  "chapter": "درس ۱۹",
  "title": "کل درس: تحولات ایران پس از تبعید امام خمینی",
  "start": 162,
  "end": 172
 },
 {
  "chapter": "درس ۲۰",
  "title": "کل درس: ایران در مسیر انقلاب اسلامی",
  "start": 173,
  "end": 180
 },
 {
  "chapter": "درس ۲۱",
  "title": "کل درس: پیروزی انقلاب اسلامی ایران",
  "start": 181,
  "end": 189
 },
 {
  "chapter": "درس ۲۲",
  "title": "کل درس: دولت موقت مهندس مهدی بازرگان",
  "start": 190,
  "end": 198
 },
 {
  "chapter": "درس ۲۳",
  "title": "کل درس: اولین دوره ریاست جمهوری در ایران",
  "start": 199,
  "end": 209
 },
 {
  "chapter": "درس ۲۴",
  "title": "کل درس: جنگ تحمیلی رژیم بعثی حاکم بر عراق علیه ایران",
  "start": 210,
  "end": 222
 },
 {
  "chapter": "درس ۲۵",
  "title": "کل درس: آرمان‌ها و دستاوردهای انقلاب اسلامی ایران",
  "start": 223,
  "end": 237
 },
 {
  "chapter": "درس ۲۶",
  "title": "کل درس: جمهوری اسلامی ایران پس از جنگ تحمیلی هشت‌ساله در جهان جدید",
  "start": 238,
  "end": 263
 }
]$lessons$::jsonb) as p(chapter text,title text,start integer,"end" integer)),
 fields(field) as (values ('mathematics'),('experimental_sciences'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from lessons p cross join fields f where t.id=md5('nova:planner:1405:v1:'||f.field||':11:final_exam:تاریخ معاصر ایران:'||p.chapter||':1')::uuid
 and t.edition='1405' and t.study_field=f.field and t.grade='11' and t.preparation_track='final_exam'
 and t.subject='تاریخ معاصر ایران' and t.chapter=p.chapter and t.title=p.title and t.position=1
 and t.page_start is null and t.page_end is null and t.revision=1;

-- Planner study groupings. Groups that start on the same page can overlap.
with topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 101,
  "title": "بنیاد سلسله قاجار",
  "start": 17,
  "end": 18
 },
 {
  "chapter": "درس ۱",
  "position": 102,
  "title": "هجوم استعمارگران اروپایی به ایران",
  "start": 18,
  "end": 24
 },
 {
  "chapter": "درس ۱",
  "position": 103,
  "title": "جنگ هرات و معاهده ارزنةالروم",
  "start": 24,
  "end": 26
 },
 {
  "chapter": "درس ۲",
  "position": 101,
  "title": "صدارت امیرکبیر",
  "start": 27,
  "end": 29
 },
 {
  "chapter": "درس ۲",
  "position": 102,
  "title": "واگذاری امتیازات به بیگانگان",
  "start": 29,
  "end": 32
 },
 {
  "chapter": "درس ۲",
  "position": 103,
  "title": "نهضت تحریم تنباکو",
  "start": 32,
  "end": 36
 },
 {
  "chapter": "درس ۳",
  "position": 101,
  "title": "از دست رفتن سرزمین و غلبه استعمار",
  "start": 37,
  "end": 39
 },
 {
  "chapter": "درس ۳",
  "position": 102,
  "title": "استبداد و مخالفت مردم و علما",
  "start": 39,
  "end": 40
 },
 {
  "chapter": "درس ۳",
  "position": 103,
  "title": "ورود اندیشه‌های جدید",
  "start": 40,
  "end": 42
 },
 {
  "chapter": "درس ۴",
  "position": 101,
  "title": "مظفرالدین‌شاه و نارضایتی مردم",
  "start": 43,
  "end": 46
 },
 {
  "chapter": "درس ۴",
  "position": 102,
  "title": "مهاجرت صغری و کبری",
  "start": 47,
  "end": 48
 },
 {
  "chapter": "درس ۴",
  "position": 103,
  "title": "تحصن سفارت انگلیس و تشکیل مجلس",
  "start": 48,
  "end": 51
 },
 {
  "chapter": "درس ۵",
  "position": 101,
  "title": "تدوین متمم قانون اساسی و اختلاف‌ها",
  "start": 52,
  "end": 54
 },
 {
  "chapter": "درس ۵",
  "position": 102,
  "title": "مداخله روس و انگلیس و قرارداد ۱۹۰۷",
  "start": 54,
  "end": 56
 },
 {
  "chapter": "درس ۵",
  "position": 103,
  "title": "استبداد صغیر و مقاومت مردم",
  "start": 57,
  "end": 60
 },
 {
  "chapter": "درس ۶",
  "position": 101,
  "title": "قدرت گرفتن جریان جدید و اختلاف‌ها",
  "start": 61,
  "end": 64
 },
 {
  "chapter": "درس ۶",
  "position": 102,
  "title": "مجلس مشروطه و مداخله بیگانگان",
  "start": 65,
  "end": 68
 },
 {
  "chapter": "درس ۶",
  "position": 103,
  "title": "جنگ جهانی اول و اعلام بی‌طرفی",
  "start": 68,
  "end": 72
 },
 {
  "chapter": "درس ۷",
  "position": 101,
  "title": "اهمیت ایران برای انگلستان و قرارداد ۱۹۱۹",
  "start": 73,
  "end": 76
 },
 {
  "chapter": "درس ۷",
  "position": 102,
  "title": "کودتای ۱۲۹۹ و عاملان آن",
  "start": 76,
  "end": 81
 },
 {
  "chapter": "درس ۸",
  "position": 101,
  "title": "دولت‌های ناپایدار و سقوط کابینه سیاه",
  "start": 82,
  "end": 83
 },
 {
  "chapter": "درس ۸",
  "position": 102,
  "title": "نخست‌وزیری رضاخان و جمهوری‌خواهی",
  "start": 84,
  "end": 85
 },
 {
  "chapter": "درس ۸",
  "position": 103,
  "title": "برکناری قاجار و تغییر سلطنت",
  "start": 85,
  "end": 89
 },
 {
  "chapter": "درس ۹",
  "position": 101,
  "title": "وابستگی، استبداد و ملی‌گرایی افراطی",
  "start": 90,
  "end": 93
 },
 {
  "chapter": "درس ۹",
  "position": 102,
  "title": "سیاست‌های ضد دینی",
  "start": 93,
  "end": 95
 },
 {
  "chapter": "درس ۹",
  "position": 103,
  "title": "تغییر لباس و کشف حجاب",
  "start": 95,
  "end": 98
 },
 {
  "chapter": "درس ۱۰",
  "position": 101,
  "title": "گرایش رضاشاه به آلمان و جنگ جهانی دوم",
  "start": 99,
  "end": 100
 },
 {
  "chapter": "درس ۱۰",
  "position": 102,
  "title": "اشغال ایران و تبعید رضاشاه",
  "start": 100,
  "end": 102
 },
 {
  "chapter": "درس ۱۰",
  "position": 103,
  "title": "کارنامه حکومت رضاشاه",
  "start": 102,
  "end": 105
 },
 {
  "chapter": "درس ۱۱",
  "position": 101,
  "title": "نخستین سال‌های حکومت محمدرضا پهلوی و اشغال",
  "start": 106,
  "end": 108
 },
 {
  "chapter": "درس ۱۱",
  "position": 102,
  "title": "موازنه منفی و تخلیه ایران از نیروهای شوروی",
  "start": 108,
  "end": 109
 },
 {
  "chapter": "درس ۱۱",
  "position": 103,
  "title": "دولت‌ها، سیاست خارجی و تغییر قانون اساسی",
  "start": 109,
  "end": 112
 },
 {
  "chapter": "درس ۱۲",
  "position": 101,
  "title": "زمینه‌های نهضت ملی شدن نفت",
  "start": 113,
  "end": 115
 },
 {
  "chapter": "درس ۱۲",
  "position": 102,
  "title": "دولت رزم‌آرا و تصویب ملی شدن نفت",
  "start": 115,
  "end": 116
 },
 {
  "chapter": "درس ۱۲",
  "position": 103,
  "title": "نخست‌وزیری مصدق",
  "start": 116,
  "end": 118
 },
 {
  "chapter": "درس ۱۳",
  "position": 101,
  "title": "قیام ۳۰ تیر و دور دوم نخست‌وزیری مصدق",
  "start": 119,
  "end": 121
 },
 {
  "chapter": "درس ۱۳",
  "position": 102,
  "title": "عوامل خارجی و داخلی زمینه‌ساز کودتا",
  "start": 121,
  "end": 128
 },
 {
  "chapter": "درس ۱۴",
  "position": 101,
  "title": "اجرای کودتای ۲۸ مرداد",
  "start": 129,
  "end": 132
 },
 {
  "chapter": "درس ۱۴",
  "position": 102,
  "title": "بازگشت محمدرضا پهلوی و نتیجه‌گیری",
  "start": 133,
  "end": 134
 },
 {
  "chapter": "درس ۱۵",
  "position": 101,
  "title": "اوضاع سیاسی و انتخابات پس از کودتا",
  "start": 135,
  "end": 137
 },
 {
  "chapter": "درس ۱۵",
  "position": 102,
  "title": "قرارداد کنسرسیوم نفت و دولت حسین علاء",
  "start": 137,
  "end": 138
 },
 {
  "chapter": "درس ۱۵",
  "position": 103,
  "title": "پیمان بغداد، ساواک و دولت منوچهر اقبال",
  "start": 138,
  "end": 141
 },
 {
  "chapter": "درس ۱۶",
  "position": 101,
  "title": "تحولات بین‌المللی و منطقه‌ای",
  "start": 142,
  "end": 144
 },
 {
  "chapter": "درس ۱۶",
  "position": 102,
  "title": "نخست‌وزیری شریف‌امامی و اصلاحات امینی",
  "start": 144,
  "end": 145
 },
 {
  "chapter": "درس ۱۷",
  "position": 101,
  "title": "دولت اسدالله علم و انجمن‌های ایالتی و ولایتی",
  "start": 146,
  "end": 148
 },
 {
  "chapter": "درس ۱۷",
  "position": 102,
  "title": "انقلاب سفید و تحریم رفراندوم",
  "start": 148,
  "end": 151
 },
 {
  "chapter": "درس ۱۸",
  "position": 101,
  "title": "حمله به فیضیه و قیام پانزده خرداد",
  "start": 152,
  "end": 158
 },
 {
  "chapter": "درس ۱۸",
  "position": 102,
  "title": "دستاوردها، کاپیتولاسیون و تبعید امام خمینی",
  "start": 158,
  "end": 161
 },
 {
  "chapter": "درس ۱۹",
  "position": 101,
  "title": "سیاست داخلی حکومت پهلوی",
  "start": 162,
  "end": 165
 },
 {
  "chapter": "درس ۱۹",
  "position": 102,
  "title": "سیاست خارجی، هزینه‌های نظامی و فساد",
  "start": 165,
  "end": 167
 },
 {
  "chapter": "درس ۱۹",
  "position": 103,
  "title": "مبارزات مخالفان و نقش امام خمینی",
  "start": 168,
  "end": 172
 },
 {
  "chapter": "درس ۲۰",
  "position": 101,
  "title": "تحولات سیاسی و دولت آموزگار",
  "start": 173,
  "end": 175
 },
 {
  "chapter": "درس ۲۰",
  "position": 102,
  "title": "رحلت مصطفی خمینی و آغاز انقلاب",
  "start": 175,
  "end": 177
 },
 {
  "chapter": "درس ۲۰",
  "position": 103,
  "title": "دولت شریف‌امامی و ادامه اعتراضات",
  "start": 178,
  "end": 180
 },
 {
  "chapter": "درس ۲۱",
  "position": 101,
  "title": "هجرت امام خمینی و دولت نظامی ازهاری",
  "start": 181,
  "end": 183
 },
 {
  "chapter": "درس ۲۱",
  "position": 102,
  "title": "تظاهرات، فرار شاه و بازگشت امام",
  "start": 183,
  "end": 187
 },
 {
  "chapter": "درس ۲۱",
  "position": 103,
  "title": "تشکیل دولت موقت و پیروزی انقلاب",
  "start": 188,
  "end": 189
 },
 {
  "chapter": "درس ۲۲",
  "position": 101,
  "title": "دولت موقت، همه‌پرسی و قانون اساسی",
  "start": 190,
  "end": 192
 },
 {
  "chapter": "درس ۲۲",
  "position": 102,
  "title": "نهادهای انقلابی و اوضاع داخلی",
  "start": 192,
  "end": 193
 },
 {
  "chapter": "درس ۲۲",
  "position": 103,
  "title": "توطئه‌های ضدانقلاب و استعفای دولت موقت",
  "start": 193,
  "end": 198
 },
 {
  "chapter": "درس ۲۳",
  "position": 101,
  "title": "ریاست‌جمهوری بنی‌صدر و آرایش سیاسی",
  "start": 199,
  "end": 201
 },
 {
  "chapter": "درس ۲۳",
  "position": 102,
  "title": "انتخاب نخست‌وزیر و انقلاب فرهنگی",
  "start": 201,
  "end": 202
 },
 {
  "chapter": "درس ۲۳",
  "position": 103,
  "title": "برکناری بنی‌صدر و ترور شخصیت‌ها",
  "start": 202,
  "end": 209
 },
 {
  "chapter": "درس ۲۴",
  "position": 101,
  "title": "آغاز جنگ تحمیلی و بسیج مردم",
  "start": 210,
  "end": 213
 },
 {
  "chapter": "درس ۲۴",
  "position": 102,
  "title": "ادامه جنگ و حملات به شهرها",
  "start": 214,
  "end": 216
 },
 {
  "chapter": "درس ۲۴",
  "position": 103,
  "title": "قطعنامه ۵۹۸ و پایان جنگ",
  "start": 216,
  "end": 217
 },
 {
  "chapter": "درس ۲۴",
  "position": 104,
  "title": "ارتحال امام خمینی و رهبری آیت‌الله خامنه‌ای",
  "start": 217,
  "end": 222
 },
 {
  "chapter": "درس ۲۵",
  "position": 101,
  "title": "آرمان‌ها و اهداف انقلاب اسلامی",
  "start": 223,
  "end": 225
 },
 {
  "chapter": "درس ۲۵",
  "position": 102,
  "title": "دستاوردهای سیاسی و فرهنگی و اجتماعی",
  "start": 226,
  "end": 229
 },
 {
  "chapter": "درس ۲۵",
  "position": 103,
  "title": "دستاوردهای اقتصادی، علمی و دفاعی",
  "start": 230,
  "end": 235
 },
 {
  "chapter": "درس ۲۵",
  "position": 104,
  "title": "احیای بیداری اسلامی",
  "start": 235,
  "end": 237
 },
 {
  "chapter": "درس ۲۶",
  "position": 101,
  "title": "پایان جنگ سرد و نظم جدید",
  "start": 238,
  "end": 241
 },
 {
  "chapter": "درس ۲۶",
  "position": 102,
  "title": "امنیت غرب آسیا و راهبرد ایران",
  "start": 241,
  "end": 248
 },
 {
  "chapter": "درس ۲۶",
  "position": 103,
  "title": "جبهه مقاومت و نقش ایران",
  "start": 248,
  "end": 253
 },
 {
  "chapter": "درس ۲۶",
  "position": 104,
  "title": "گسترش جنگ منطقه‌ای و جنگ دوازده‌روزه",
  "start": 254,
  "end": 259
 },
 {
  "chapter": "درس ۲۶",
  "position": 105,
  "title": "جنگ رمضان و پاسخ ایران",
  "start": 259,
  "end": 263
 }
]$topics$::jsonb) as p(chapter text,title text,position integer,start integer,"end" integer)),
 fields(field) as (values ('mathematics'),('experimental_sciences'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v166:'||f.field||':11:final_exam:تاریخ معاصر ایران:'||p.chapter||':'||p.position)::uuid,
 '1405',f.field,'11','final_exam','تاریخ معاصر ایران',p.chapter,p.title,p.start,p."end",p.position
from topics p cross join fields f on conflict (id) do nothing;
