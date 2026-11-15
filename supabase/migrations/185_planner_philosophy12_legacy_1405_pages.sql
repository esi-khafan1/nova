-- Philosophy 2 broader original groups: verified against the 1405 textbook.
-- Only untouched v1 originals with blank pages are changed; deletions and edits survive.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱",
  "position": 1,
  "title": "هستی و چیستی و ویژگی‌های ماهیت",
  "start": 2,
  "end": 4
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱",
  "position": 2,
  "title": "تمایز وجود و ماهیت در اندیشه فارابی و ابن‌سینا",
  "start": 4,
  "end": 4
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱",
  "position": 3,
  "title": "استدلال ابن‌سینا درباره مغایرت وجود و ماهیت",
  "start": 5,
  "end": 6
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱",
  "position": 4,
  "title": "گذری تاریخی بر تأثیر بحث وجود و ماهیت",
  "start": 6,
  "end": 7
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۲",
  "position": 1,
  "title": "نسبت‌های سه‌گانه وجوب، امکان و امتناع",
  "start": 9,
  "end": 11
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۲",
  "position": 2,
  "title": "واجب‌الوجود، ممکن‌الوجود و ممتنع‌الوجود",
  "start": 10,
  "end": 12
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۲",
  "position": 3,
  "title": "امکان ذاتی و خروج از امکان به واسطه علت",
  "start": 10,
  "end": 12
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۳",
  "position": 1,
  "title": "رابطه علیت و تفاوت آن با سایر روابط",
  "start": 14,
  "end": 14
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۳",
  "position": 2,
  "title": "منشأ درک علیت و دیدگاه فیلسوفان",
  "start": 15,
  "end": 18
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۳",
  "position": 3,
  "title": "وجوب علّی و معلولی",
  "start": 18,
  "end": 18
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۳",
  "position": 4,
  "title": "سنخیت علت و معلول و نتایج آن",
  "start": 18,
  "end": 21
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۴",
  "position": 1,
  "title": "معانی چهارگانه اتفاق",
  "start": 24,
  "end": 26
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۴",
  "position": 2,
  "title": "بررسی ضرورت و سنخیت علت و معلول",
  "start": 24,
  "end": 25
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۴",
  "position": 3,
  "title": "غایتمندی جهان و حادثه پیش‌بینی‌نشده",
  "start": 25,
  "end": 26
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۵",
  "position": 1,
  "title": "خدا در دیدگاه افلاطون و ارسطو",
  "start": 31,
  "end": 34
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۵",
  "position": 2,
  "title": "خدا در فلسفه دکارت، هیوم و کانت",
  "start": 34,
  "end": 37
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۵",
  "position": 3,
  "title": "باور به خدا و معنای زندگی",
  "start": 37,
  "end": 39
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۶",
  "position": 1,
  "title": "برهان علیت فارابی",
  "start": 42,
  "end": 44
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۶",
  "position": 2,
  "title": "برهان وجوب و امکان ابن‌سینا",
  "start": 44,
  "end": 46
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۶",
  "position": 3,
  "title": "امکان فقری و بیان ملاصدرا",
  "start": 46,
  "end": 47
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۶",
  "position": 4,
  "title": "خدا و معنای زندگی",
  "start": 47,
  "end": 49
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۷",
  "position": 1,
  "title": "عقل به عنوان قوه استدلال و عالم عقول",
  "start": 53,
  "end": 54
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۷",
  "position": 2,
  "title": "عقل نظری و عقل عملی در اندیشه ارسطو",
  "start": 55,
  "end": 56
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۷",
  "position": 3,
  "title": "عقل در دوران کلیسا و عصر جدید اروپا",
  "start": 56,
  "end": 57
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۷",
  "position": 4,
  "title": "دیدگاه دکارت و تجربه‌گرایان درباره عقل",
  "start": 56,
  "end": 58
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۸",
  "position": 1,
  "title": "عقلانیت و مخالفت با فلسفه در جهان اسلام",
  "start": 59,
  "end": 62
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۸",
  "position": 2,
  "title": "عالم عقول و عقل فعال",
  "start": 63,
  "end": 64
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۸",
  "position": 3,
  "title": "مراتب رشد عقل نزد فارابی و ابن‌سینا",
  "start": 64,
  "end": 66
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۸",
  "position": 4,
  "title": "رابطه عقل، دین و راه‌های معرفت",
  "start": 65,
  "end": 66
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۹",
  "position": 2,
  "title": "ترجمه و گسترش دانش فلسفی",
  "start": 73,
  "end": 74
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۹",
  "position": 3,
  "title": "فارابی و حکمت مشاء",
  "start": 74,
  "end": 76
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۰",
  "position": 1,
  "title": "ابن‌سینا و طبیعت و نظام احسن",
  "start": 78,
  "end": 82
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۰",
  "position": 3,
  "title": "نورالانوار و مراتب نور",
  "start": 84,
  "end": 85
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۰",
  "position": 4,
  "title": "استدلال و شهود در حکمت اشراقی",
  "start": 83,
  "end": 85
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۱",
  "position": 1,
  "title": "فیلسوفان دوره صفوی و حکمت متعالیه",
  "start": 87,
  "end": 92
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۱",
  "position": 4,
  "title": "مراتب و شدت و ضعف وجود",
  "start": 95,
  "end": 96
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۲",
  "position": 1,
  "title": "حکمت معاصر و رویارویی با فلسفه جدید",
  "start": 97,
  "end": 99
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۲",
  "position": 2,
  "title": "علامه طباطبایی و احیای فلسفه و تفسیر",
  "start": 103,
  "end": 106
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۲",
  "position": 3,
  "title": "امام خمینی و فلسفه معاصر",
  "start": 99,
  "end": 102
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۲",
  "position": 4,
  "title": "نظام فکری و عملی شهید مطهری",
  "start": 107,
  "end": 111
 }
]$fixes$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field='humanities' and t.grade=p.grade and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
