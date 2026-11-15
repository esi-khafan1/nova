-- Backfill only verbatim matching untouched legacy rows; no guess for broader older groupings.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 1,
  "title": "هوازدگی و فرسایش",
  "start": 41,
  "end": 43
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 3,
  "title": "پخش فرهنگی",
  "start": 79,
  "end": 81
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 3,
  "title": "جغرافیای سیاسی",
  "start": 121,
  "end": 126
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱",
  "position": 1,
  "title": "انسان و تفکر",
  "start": 4,
  "end": 5
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱",
  "position": 3,
  "title": "دانش فلسفه",
  "start": 6,
  "end": 6
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱",
  "position": 4,
  "title": "واژه فلسفه",
  "start": 7,
  "end": 7
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱",
  "position": 5,
  "title": "ویژگی‌های فلسفه",
  "start": 8,
  "end": 10
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۲",
  "position": 1,
  "title": "بخش اصلی و ریشه‌ای فلسفه",
  "start": 13,
  "end": 13
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۲",
  "position": 2,
  "title": "شاخه‌های فلسفه",
  "start": 14,
  "end": 15
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۳",
  "position": 1,
  "title": "معنای زندگی",
  "start": 21,
  "end": 21
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۴",
  "position": 1,
  "title": "فلسفه در یونان",
  "start": 30,
  "end": 33
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۴",
  "position": 2,
  "title": "سوفیست‌ها",
  "start": 34,
  "end": 34
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۵",
  "position": 1,
  "title": "سقراط در برابر دادگاه",
  "start": 39,
  "end": 42
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۶",
  "position": 1,
  "title": "چیستی معرفت",
  "start": 46,
  "end": 46
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۶",
  "position": 2,
  "title": "امکان معرفت",
  "start": 47,
  "end": 47
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۶",
  "position": 3,
  "title": "پیشرفت پیوسته دانش انسان",
  "start": 48,
  "end": 48
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۷",
  "position": 1,
  "title": "حس",
  "start": 51,
  "end": 51
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۷",
  "position": 2,
  "title": "عقل",
  "start": 52,
  "end": 53
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 1,
  "title": "دوره یونان باستان",
  "start": 59,
  "end": 60
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 2,
  "title": "دوره شکوفایی فلسفه در جهان اسلام و ایران",
  "start": 61,
  "end": 62
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 3,
  "title": "دوره جدید اروپا",
  "start": 63,
  "end": 64
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۹",
  "position": 1,
  "title": "حقیقت انسان چیست؟",
  "start": 71,
  "end": 71
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۰",
  "position": 1,
  "title": "دیدگاه فیلسوفان مسلمان درباره حقیقت انسان",
  "start": 78,
  "end": 78
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۰",
  "position": 2,
  "title": "از جانب بالا",
  "start": 79,
  "end": 79
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۰",
  "position": 3,
  "title": "حقیقت نورانی نفس",
  "start": 80,
  "end": 80
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۰",
  "position": 4,
  "title": "تا بی‌نهایت",
  "start": 81,
  "end": 81
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۱",
  "position": 1,
  "title": "فعل طبیعی و فعل اخلاقی",
  "start": 85,
  "end": 85
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۹",
  "position": 1,
  "title": "زمینه‌های رشد فلسفه در جهان اسلام",
  "start": 71,
  "end": 73
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۰",
  "position": 2,
  "title": "سهروردی و حکمت اشراق",
  "start": 83,
  "end": 85
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۱",
  "position": 2,
  "title": "اصالت وجود",
  "start": 92,
  "end": 93
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۱",
  "position": 3,
  "title": "وحدت حقیقت وجود",
  "start": 94,
  "end": 95
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۱",
  "position": 1,
  "title": "منابع کسب آگاهی و معرفت",
  "start": 11,
  "end": 12
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۱",
  "position": 3,
  "title": "هدف‌های علم روان‌شناسی",
  "start": 14,
  "end": 16
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۵",
  "position": 2,
  "title": "مراحل حل مسئله",
  "start": 119,
  "end": 120
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۵",
  "position": 3,
  "title": "عوامل مؤثر بر حل مسئله",
  "start": 121,
  "end": 123
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۶",
  "position": 1,
  "title": "انواع تصمیم‌گیری",
  "start": 138,
  "end": 140
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۶",
  "position": 3,
  "title": "مراحل تصمیم‌گیری",
  "start": 148,
  "end": 148
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۷",
  "position": 3,
  "title": "ناهماهنگی شناختی",
  "start": 169,
  "end": 171
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۷",
  "position": 4,
  "title": "ادراک کنترل و کارایی",
  "start": 172,
  "end": 175
 }
]$fixes$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field='humanities' and t.grade=p.grade and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
