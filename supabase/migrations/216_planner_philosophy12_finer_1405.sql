-- Philosophy 2, textbook 112226, 1405: finer subjects checked against user PDF.
-- Existing records and administrator changes are not modified; installed once for both tracks.
with installed as (insert into private.planner_seed_installations(seed_key) values ('philosophy12-finer-1405-v216') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱",
  "title": "قدم نخست: توجه به واقعیت",
  "start": 2,
  "end": 2,
  "position": 700
 },
 {
  "chapter": "درس ۱",
  "title": "قدم دوم: پرسش از چیستی",
  "start": 3,
  "end": 3,
  "position": 701
 },
 {
  "chapter": "درس ۱",
  "title": "قدم سوم: تمایز هستی و چیستی",
  "start": 4,
  "end": 4,
  "position": 702
 },
 {
  "chapter": "درس ۱",
  "title": "قدم چهارم: استدلال ابن‌سینا",
  "start": 5,
  "end": 6,
  "position": 703
 },
 {
  "chapter": "درس ۱",
  "title": "بازبینی و گذری تاریخی",
  "start": 6,
  "end": 6,
  "position": 704
 },
 {
  "chapter": "درس ۱",
  "title": "تمرین هستی و چیستی",
  "start": 7,
  "end": 7,
  "position": 705
 },
 {
  "chapter": "درس ۲",
  "title": "مقدمه جهان ممکنات",
  "start": 8,
  "end": 8,
  "position": 700
 },
 {
  "chapter": "درس ۲",
  "title": "نسبت‌های ضرورت، امکان و امتناع",
  "start": 9,
  "end": 9,
  "position": 701
 },
 {
  "chapter": "درس ۲",
  "title": "رابطه وجود با موضوع و تعیین نسبت",
  "start": 10,
  "end": 11,
  "position": 702
 },
 {
  "chapter": "درس ۲",
  "title": "تفکر و تمرین نسبت‌ها",
  "start": 12,
  "end": 12,
  "position": 703
 },
 {
  "chapter": "درس ۳",
  "title": "مقدمه رابطه علت و معلول",
  "start": 13,
  "end": 14,
  "position": 700
 },
 {
  "chapter": "درس ۳",
  "title": "تمایز علیت با سایر روابط",
  "start": 14,
  "end": 14,
  "position": 701
 },
 {
  "chapter": "درس ۳",
  "title": "منشأ درک رابطه علیت",
  "start": 15,
  "end": 15,
  "position": 702
 },
 {
  "chapter": "درس ۳",
  "title": "دیوید هیوم و دیدگاه تجربه‌گرایانه",
  "start": 16,
  "end": 17,
  "position": 703
 },
 {
  "chapter": "درس ۳",
  "title": "دیدگاه فلاسفه مسلمان درباره علیت",
  "start": 17,
  "end": 18,
  "position": 704
 },
 {
  "chapter": "درس ۳",
  "title": "وجوب علّی و معلولی",
  "start": 18,
  "end": 18,
  "position": 705
 },
 {
  "chapter": "درس ۳",
  "title": "سنخیت علت و معلول",
  "start": 18,
  "end": 19,
  "position": 706
 },
 {
  "chapter": "درس ۳",
  "title": "نتیجه اصل علیت و تمرین",
  "start": 20,
  "end": 21,
  "position": 707
 },
 {
  "chapter": "درس ۴",
  "title": "تصاویر جهان و مسئله اتفاق",
  "start": 22,
  "end": 23,
  "position": 700
 },
 {
  "chapter": "درس ۴",
  "title": "معانی چهارگانه اتفاق",
  "start": 24,
  "end": 24,
  "position": 701
 },
 {
  "chapter": "درس ۴",
  "title": "بررسی ضرورت و سنخیت علت و معلول",
  "start": 24,
  "end": 25,
  "position": 702
 },
 {
  "chapter": "درس ۴",
  "title": "علت تامه و علت ناقصه",
  "start": 25,
  "end": 25,
  "position": 703
 },
 {
  "chapter": "درس ۴",
  "title": "بررسی اتفاق و غایت‌مندی جهان",
  "start": 25,
  "end": 26,
  "position": 704
 },
 {
  "chapter": "درس ۴",
  "title": "مقایسه دیدگاه‌ها",
  "start": 26,
  "end": 26,
  "position": 705
 },
 {
  "chapter": "درس ۴",
  "title": "تمرین اتفاق و علت",
  "start": 27,
  "end": 27,
  "position": 706
 },
 {
  "chapter": "درس ۵",
  "title": "مقدمه خدا در فلسفه",
  "start": 30,
  "end": 31,
  "position": 700
 },
 {
  "chapter": "درس ۵",
  "title": "سقراط و افلاطون و خداشناسی",
  "start": 31,
  "end": 32,
  "position": 701
 },
 {
  "chapter": "درس ۵",
  "title": "ارسطو و استدلال بر وجود خدا",
  "start": 32,
  "end": 34,
  "position": 702
 },
 {
  "chapter": "درس ۵",
  "title": "خدا در فلسفه دکارت",
  "start": 34,
  "end": 35,
  "position": 703
 },
 {
  "chapter": "درس ۵",
  "title": "برهان نظم و دیدگاه تجربه‌گرایان",
  "start": 35,
  "end": 36,
  "position": 704
 },
 {
  "chapter": "درس ۵",
  "title": "کانت و استدلال اخلاقی",
  "start": 36,
  "end": 36,
  "position": 705
 },
 {
  "chapter": "درس ۵",
  "title": "باور به خدا و معناداری زندگی",
  "start": 37,
  "end": 39,
  "position": 706
 },
 {
  "chapter": "درس ۵",
  "title": "تمرین خدا در فلسفه",
  "start": 40,
  "end": 40,
  "position": 707
 },
 {
  "chapter": "درس ۶",
  "title": "مقدمه برهان‌های فیلسوفان مسلمان",
  "start": 41,
  "end": 42,
  "position": 700
 },
 {
  "chapter": "درس ۶",
  "title": "استدلال فارابی و پاسخ به نقد علیت",
  "start": 42,
  "end": 44,
  "position": 701
 },
 {
  "chapter": "درس ۶",
  "title": "استدلال ابن‌سینا و برهان صدیقین",
  "start": 44,
  "end": 45,
  "position": 702
 },
 {
  "chapter": "درس ۶",
  "title": "بیان ملاصدرا و برهان وجوب و امکان",
  "start": 46,
  "end": 46,
  "position": 703
 },
 {
  "chapter": "درس ۶",
  "title": "فلاسفه مسلمان و معناداری حیات",
  "start": 47,
  "end": 49,
  "position": 704
 },
 {
  "chapter": "درس ۶",
  "title": "تمرین برهان‌های اثبات خدا",
  "start": 50,
  "end": 50,
  "position": 705
 },
 {
  "chapter": "درس ۷",
  "title": "مقدمه و دو معنای عقل",
  "start": 52,
  "end": 53,
  "position": 700
 },
 {
  "chapter": "درس ۷",
  "title": "عقل به عنوان دستگاه تفکر و استدلال",
  "start": 53,
  "end": 53,
  "position": 701
 },
 {
  "chapter": "درس ۷",
  "title": "عقل به عنوان موجود متعالی",
  "start": 54,
  "end": 54,
  "position": 702
 },
 {
  "chapter": "درس ۷",
  "title": "عقل در فلسفه یونان باستان",
  "start": 54,
  "end": 55,
  "position": 703
 },
 {
  "chapter": "درس ۷",
  "title": "عقل نظری و عملی در اندیشه ارسطو",
  "start": 55,
  "end": 56,
  "position": 704
 },
 {
  "chapter": "درس ۷",
  "title": "عقل نزد فیلسوفان جدید اروپا",
  "start": 56,
  "end": 57,
  "position": 705
 },
 {
  "chapter": "درس ۷",
  "title": "تمرین عقل در فلسفه",
  "start": 58,
  "end": 58,
  "position": 706
 },
 {
  "chapter": "درس ۸",
  "title": "دو نمونه درباره عقل در جهان اسلام",
  "start": 59,
  "end": 61,
  "position": 700
 },
 {
  "chapter": "درس ۸",
  "title": "عقل به عنوان موجود متعالی نزد مسلمانان",
  "start": 62,
  "end": 63,
  "position": 701
 },
 {
  "chapter": "درس ۸",
  "title": "عقل به عنوان دستگاه تفکر نزد مسلمانان",
  "start": 64,
  "end": 66,
  "position": 702
 },
 {
  "chapter": "درس ۸",
  "title": "بررسی و تفکر درباره عقل",
  "start": 65,
  "end": 66,
  "position": 703
 },
 {
  "chapter": "درس ۸",
  "title": "تمرین عقل در فلسفه اسلامی",
  "start": 67,
  "end": 67,
  "position": 704
 },
 {
  "chapter": "درس ۹",
  "title": "آغاز فلسفه در جهان اسلام",
  "start": 70,
  "end": 71,
  "position": 700
 },
 {
  "chapter": "درس ۹",
  "title": "زمینه‌های رشد فلسفه",
  "start": 72,
  "end": 73,
  "position": 701
 },
 {
  "chapter": "درس ۹",
  "title": "حکمای مشاء",
  "start": 74,
  "end": 74,
  "position": 702
 },
 {
  "chapter": "درس ۹",
  "title": "فارابی، معلم ثانی و مقام علمی او",
  "start": 75,
  "end": 75,
  "position": 703
 },
 {
  "chapter": "درس ۹",
  "title": "فلسفه سیاسی فارابی",
  "start": 76,
  "end": 76,
  "position": 704
 },
 {
  "chapter": "درس ۹",
  "title": "تمرین آغاز فلسفه اسلامی",
  "start": 77,
  "end": 77,
  "position": 705
 },
 {
  "chapter": "درس ۱۰",
  "title": "ابن‌سینا و تحصیل فلسفه",
  "start": 78,
  "end": 79,
  "position": 700
 },
 {
  "chapter": "درس ۱۰",
  "title": "تألیفات ابن‌سینا",
  "start": 80,
  "end": 80,
  "position": 701
 },
 {
  "chapter": "درس ۱۰",
  "title": "طبیعت‌شناسی و نظام احسن نزد ابن‌سینا",
  "start": 80,
  "end": 82,
  "position": 702
 },
 {
  "chapter": "درس ۱۰",
  "title": "تأمل در طبیعت‌شناسی ابن‌سینا",
  "start": 82,
  "end": 82,
  "position": 703
 },
 {
  "chapter": "درس ۱۰",
  "title": "سهروردی و بنیان حکمت اشراق",
  "start": 83,
  "end": 84,
  "position": 704
 },
 {
  "chapter": "درس ۱۰",
  "title": "اشراق نور و دسته‌بندی جویندگان معرفت",
  "start": 84,
  "end": 85,
  "position": 705
 },
 {
  "chapter": "درس ۱۰",
  "title": "تفاوت حکمت مشاء و اشراق",
  "start": 85,
  "end": 85,
  "position": 706
 },
 {
  "chapter": "درس ۱۰",
  "title": "تمرین حکمت مشاء و اشراق",
  "start": 86,
  "end": 86,
  "position": 707
 },
 {
  "chapter": "درس ۱۱",
  "title": "زندگی ملاصدرا و شکل‌گیری حکمت متعالیه",
  "start": 87,
  "end": 90,
  "position": 700
 },
 {
  "chapter": "درس ۱۱",
  "title": "تألیفات ملاصدرا و اسفار اربعه",
  "start": 90,
  "end": 91,
  "position": 701
 },
 {
  "chapter": "درس ۱۱",
  "title": "روش حکمت متعالیه",
  "start": 91,
  "end": 91,
  "position": 702
 },
 {
  "chapter": "درس ۱۱",
  "title": "اصل اصالت وجود و اصالت ماهیت",
  "start": 92,
  "end": 93,
  "position": 703
 },
 {
  "chapter": "درس ۱۱",
  "title": "نمودار سیر بحث اصالت وجود",
  "start": 93,
  "end": 93,
  "position": 704
 },
 {
  "chapter": "درس ۱۱",
  "title": "وحدت حقیقت وجود",
  "start": 94,
  "end": 95,
  "position": 705
 },
 {
  "chapter": "درس ۱۱",
  "title": "مراتب وجود",
  "start": 95,
  "end": 95,
  "position": 706
 },
 {
  "chapter": "درس ۱۱",
  "title": "تمرین اصول حکمت متعالیه",
  "start": 96,
  "end": 96,
  "position": 707
 },
 {
  "chapter": "درس ۱۲",
  "title": "فلسفه معاصر و ورود اندیشه‌های جدید اروپا",
  "start": 97,
  "end": 99,
  "position": 700
 },
 {
  "chapter": "درس ۱۲",
  "title": "امام خمینی: فلسفه، عرفان و تربیت شاگردان",
  "start": 99,
  "end": 102,
  "position": 701
 },
 {
  "chapter": "درس ۱۲",
  "title": "علامه طباطبایی و فعالیت علمی و فرهنگی",
  "start": 103,
  "end": 106,
  "position": 702
 },
 {
  "chapter": "درس ۱۲",
  "title": "فلسفه تطبیقی و گفت‌وگو با هانری کربن",
  "start": 105,
  "end": 106,
  "position": 703
 },
 {
  "chapter": "درس ۱۲",
  "title": "مرتضی مطهری و جایگاه علمی او",
  "start": 107,
  "end": 107,
  "position": 704
 },
 {
  "chapter": "درس ۱۲",
  "title": "الگوی نظام فکری و عملی",
  "start": 108,
  "end": 108,
  "position": 705
 },
 {
  "chapter": "درس ۱۲",
  "title": "خودارزیابی و تمرین حکمت معاصر",
  "start": 109,
  "end": 111,
  "position": 706
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v216:humanities:12:'||r.track||':فلسفه ۲:'||p.chapter||':'||p.position)::uuid,'1405','humanities','12',r.track,'فلسفه ۲',p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
