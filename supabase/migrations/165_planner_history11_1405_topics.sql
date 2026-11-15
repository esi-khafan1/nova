-- Textbook 111219, tenth printing 1405, groupings based on book headings.
with topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "position": 101,
  "title": "منابع غیرنوشتاری تاریخ اسلام و ایران",
  "start": 2,
  "end": 4
 },
 {
  "chapter": "درس ۱",
  "position": 102,
  "title": "مراجع و منابع نوشتاری",
  "start": 4,
  "end": 12
 },
 {
  "chapter": "درس ۲",
  "position": 101,
  "title": "معیارهای سنجش اعتبار خبر و نقد منابع تاریخی",
  "start": 13,
  "end": 16
 },
 {
  "chapter": "درس ۲",
  "position": 102,
  "title": "روش‌های تاریخ‌نگاری",
  "start": 17,
  "end": 18
 },
 {
  "chapter": "درس ۳",
  "position": 101,
  "title": "شبه‌جزیره عربستان در آستانه ظهور اسلام",
  "start": 20,
  "end": 24
 },
 {
  "chapter": "درس ۳",
  "position": 102,
  "title": "بعثت پیامبر و دعوت به اسلام",
  "start": 25,
  "end": 30
 },
 {
  "chapter": "درس ۴",
  "position": 101,
  "title": "مدینه و هجرت پیامبر و پیروانش",
  "start": 31,
  "end": 35
 },
 {
  "chapter": "درس ۴",
  "position": 102,
  "title": "تشکیل امت و حکومت نبوی",
  "start": 35,
  "end": 38
 },
 {
  "chapter": "درس ۴",
  "position": 103,
  "title": "مخالفت با حکومت نوپای اسلامی",
  "start": 38,
  "end": 39
 },
 {
  "chapter": "درس ۴",
  "position": 104,
  "title": "گسترش حکومت پیامبر، صلح حدیبیه و فتح مکه",
  "start": 39,
  "end": 41
 },
 {
  "chapter": "درس ۴",
  "position": 105,
  "title": "روش حکومت‌داری و تعلیم و تربیت",
  "start": 41,
  "end": 43
 },
 {
  "chapter": "درس ۵",
  "position": 101,
  "title": "جانشینی پیامبر و شکل‌گیری خلافت",
  "start": 44,
  "end": 46
 },
 {
  "chapter": "درس ۵",
  "position": 102,
  "title": "خلافت عمر و عثمان و امام علی",
  "start": 46,
  "end": 49
 },
 {
  "chapter": "درس ۵",
  "position": 103,
  "title": "اوضاع اجتماعی و اقتصادی دوران خلفای نخستین",
  "start": 49,
  "end": 51
 },
 {
  "chapter": "درس ۵",
  "position": 104,
  "title": "فتوحات مسلمانان و پیامدهای آن",
  "start": 51,
  "end": 55
 },
 {
  "chapter": "درس ۶",
  "position": 101,
  "title": "استقرار خلافت امویان و فتوحات",
  "start": 56,
  "end": 59
 },
 {
  "chapter": "درس ۶",
  "position": 102,
  "title": "سیاست و حکومت امویان",
  "start": 59,
  "end": 62
 },
 {
  "chapter": "درس ۶",
  "position": 103,
  "title": "قیام‌ها و جنبش‌های دوره اموی",
  "start": 62,
  "end": 65
 },
 {
  "chapter": "درس ۶",
  "position": 104,
  "title": "سقوط امویان و امویان اندلس",
  "start": 65,
  "end": 68
 },
 {
  "chapter": "درس ۷",
  "position": 101,
  "title": "سیاست و حکومت خلافت عباسیان",
  "start": 69,
  "end": 75
 },
 {
  "chapter": "درس ۷",
  "position": 102,
  "title": "نهضت علمی و فکری مسلمانان",
  "start": 75,
  "end": 78
 },
 {
  "chapter": "درس ۷",
  "position": 103,
  "title": "خلافت فاطمیان",
  "start": 78,
  "end": 82
 },
 {
  "chapter": "درس ۸",
  "position": 101,
  "title": "فتح ایران و برخورد مسلمانان و ایرانیان",
  "start": 84,
  "end": 88
 },
 {
  "chapter": "درس ۸",
  "position": 102,
  "title": "دو قرن حکومت اعراب و جنبش‌های ایرانیان",
  "start": 88,
  "end": 92
 },
 {
  "chapter": "درس ۸",
  "position": 103,
  "title": "اسلام‌پذیری ایرانیان",
  "start": 92,
  "end": 94
 },
 {
  "chapter": "درس ۹",
  "position": 101,
  "title": "سلسله‌های ایرانی مسلمان و پیدایش آنها",
  "start": 95,
  "end": 100
 },
 {
  "chapter": "درس ۹",
  "position": 102,
  "title": "فرهنگ و تمدن، زبان و علم و دریانوردی",
  "start": 101,
  "end": 108
 },
 {
  "chapter": "درس ۱۰",
  "position": 101,
  "title": "تحولات سیاسی غزنویان، سلجوقیان و خوارزمشاهیان",
  "start": 109,
  "end": 113
 },
 {
  "chapter": "درس ۱۰",
  "position": 102,
  "title": "نظام اداری، اجتماع و اعتقادات",
  "start": 114,
  "end": 117
 },
 {
  "chapter": "درس ۱۰",
  "position": 103,
  "title": "اقتصاد، زبان، علم و هنر",
  "start": 118,
  "end": 123
 },
 {
  "chapter": "درس ۱۱",
  "position": 101,
  "title": "تحولات سیاسی عصر مغول و تیموری",
  "start": 124,
  "end": 128
 },
 {
  "chapter": "درس ۱۱",
  "position": 102,
  "title": "نظام اجتماعی و حقوقی",
  "start": 129,
  "end": 131
 },
 {
  "chapter": "درس ۱۱",
  "position": 103,
  "title": "وضعیت اقتصادی",
  "start": 132,
  "end": 134
 },
 {
  "chapter": "درس ۱۲",
  "position": 101,
  "title": "دین، اعتقادات و گسترش تصوف",
  "start": 135,
  "end": 137
 },
 {
  "chapter": "درس ۱۲",
  "position": 102,
  "title": "هنر و معماری",
  "start": 138,
  "end": 142
 },
 {
  "chapter": "درس ۱۲",
  "position": 103,
  "title": "علم، ادب و تاریخ‌نگاری",
  "start": 143,
  "end": 146
 },
 {
  "chapter": "درس ۱۳",
  "position": 101,
  "title": "تشکیل و تحولات حکومت صفوی",
  "start": 147,
  "end": 155
 },
 {
  "chapter": "درس ۱۳",
  "position": 102,
  "title": "اوضاع اقتصادی",
  "start": 156,
  "end": 157
 },
 {
  "chapter": "درس ۱۳",
  "position": 103,
  "title": "روابط خارجی با همسایگان و اروپا",
  "start": 157,
  "end": 161
 },
 {
  "chapter": "درس ۱۴",
  "position": 101,
  "title": "زمینه‌های شکوفایی فرهنگ و آموزش",
  "start": 162,
  "end": 165
 },
 {
  "chapter": "درس ۱۴",
  "position": 102,
  "title": "علما و دانشمندان",
  "start": 165,
  "end": 166
 },
 {
  "chapter": "درس ۱۴",
  "position": 103,
  "title": "معماری و هنر",
  "start": 166,
  "end": 172
 },
 {
  "chapter": "درس ۱۵",
  "position": 101,
  "title": "تحولات سیاسی، اجتماعی و فئودالیسم",
  "start": 174,
  "end": 179
 },
 {
  "chapter": "درس ۱۵",
  "position": 102,
  "title": "جنگ‌های صلیبی و پیدایش پادشاهی‌ها",
  "start": 180,
  "end": 182
 },
 {
  "chapter": "درس ۱۵",
  "position": 103,
  "title": "کلیسا و تحولات آن",
  "start": 183,
  "end": 186
 },
 {
  "chapter": "درس ۱۵",
  "position": 104,
  "title": "علم و آموزش",
  "start": 186,
  "end": 187
 },
 {
  "chapter": "درس ۱۶",
  "position": 101,
  "title": "ایتالیا و زمینه‌های رنسانس",
  "start": 188,
  "end": 191
 },
 {
  "chapter": "درس ۱۶",
  "position": 102,
  "title": "دستاوردهای رنسانس و عصر جدید",
  "start": 191,
  "end": 199
 },
 {
  "chapter": "درس ۱۶",
  "position": 103,
  "title": "اصلاح دین و نهضت پروتستان",
  "start": 199,
  "end": 201
 }
]$topics$::jsonb) as p(chapter text,title text,position integer,start integer,"end" integer)),
 tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v165:humanities:11:'||r.track||':تاریخ ۲:'||p.chapter||':'||p.position)::uuid,
 '1405','humanities','11',r.track,'تاریخ ۲',p.chapter,p.title,p.start,p."end",p.position
from topics p cross join tracks r on conflict (id) do nothing;
