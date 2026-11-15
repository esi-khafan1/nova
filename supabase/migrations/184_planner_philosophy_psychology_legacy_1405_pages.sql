-- Backfill verified broad legacy study groups for philosophy 1 and psychology.
-- CAS exact original identity/title/order and blank pages only; deleted or edited topics are preserved.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱",
  "position": 2,
  "title": "دو مرتبه از تفکر",
  "start": 5,
  "end": 5
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۳",
  "position": 2,
  "title": "برخی فواید تفکر فلسفی",
  "start": 22,
  "end": 25
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۷",
  "position": 3,
  "title": "قلب",
  "start": 54,
  "end": 55
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 4,
  "title": "دو جریان فکری در دوره جدید اروپا",
  "start": 64,
  "end": 64
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 5,
  "title": "حرکت به سوی تجربه‌گرایی مطلق",
  "start": 65,
  "end": 65
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 6,
  "title": "رشد اندیشه نسبی‌گرایی",
  "start": 66,
  "end": 66
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 7,
  "title": "ظهور پراگماتیسم",
  "start": 67,
  "end": 67
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۱",
  "position": 2,
  "title": "برخی دیدگاه‌ها در معیار فعل اخلاقی",
  "start": 86,
  "end": 92
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۱",
  "position": 2,
  "title": "علم تجربی چیست؟",
  "start": 12,
  "end": 13
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۱",
  "position": 4,
  "title": "روش علمی و محدودیت‌های آن",
  "start": 16,
  "end": 19
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۲",
  "position": 1,
  "title": "عوامل وراثتی و محیطی رشد",
  "start": 38,
  "end": 42
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۲",
  "position": 2,
  "title": "مراحل رشد در فراخنای زندگی",
  "start": 42,
  "end": 44
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۲",
  "position": 3,
  "title": "رشد پیش از تولد",
  "start": 45,
  "end": 45
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۲",
  "position": 4,
  "title": "رشد در کودکی",
  "start": 45,
  "end": 52
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۲",
  "position": 5,
  "title": "رشد در نوجوانی",
  "start": 52,
  "end": 63
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۳",
  "position": 1,
  "title": "احساس",
  "start": 68,
  "end": 72
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۳",
  "position": 2,
  "title": "توجه",
  "start": 73,
  "end": 81
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۳",
  "position": 3,
  "title": "ادراک",
  "start": 81,
  "end": 85
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۴",
  "position": 1,
  "title": "رمزگردانی، ذخیره‌سازی و بازیابی",
  "start": 91,
  "end": 94
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۴",
  "position": 2,
  "title": "حافظه حسی، کوتاه‌مدت و بلندمدت",
  "start": 94,
  "end": 98
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۴",
  "position": 3,
  "title": "علل فراموشی و خطاهای حافظه",
  "start": 99,
  "end": 104
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۵",
  "position": 1,
  "title": "انواع مسئله",
  "start": 117,
  "end": 118
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۵",
  "position": 4,
  "title": "روش‌های اکتشافی حل مسئله",
  "start": 123,
  "end": 129
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۶",
  "position": 2,
  "title": "سبک‌های تصمیم‌گیری",
  "start": 142,
  "end": 147
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۶",
  "position": 4,
  "title": "موانع تصمیم‌گیری",
  "start": 149,
  "end": 150
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۷",
  "position": 1,
  "title": "انگیزه درونی و بیرونی",
  "start": 163,
  "end": 164
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۷",
  "position": 2,
  "title": "نگرش و عوامل مؤثر بر آن",
  "start": 160,
  "end": 180
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۸",
  "position": 1,
  "title": "نقش عوامل روان‌شناختی در سلامت",
  "start": 189,
  "end": 194
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۸",
  "position": 2,
  "title": "فشار روانی",
  "start": 195,
  "end": 197
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
  "chapter": "درس ۸",
  "position": 3,
  "title": "مقابله سازگارانه و ناسازگارانه با فشار روانی",
  "start": 198,
  "end": 203
 }
]$fixes$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field='humanities' and t.grade=p.grade and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
