-- User-supplied 112204, ninth printing 1405. Lesson ranges stop before the following lesson's recitation.
-- Update only exact original 153 seed values; never replace manager edits, moves, or deletions.
with pages as (select * from jsonb_to_recordset($pages$[
 {
  "chapter": "درس ۱",
  "title": "کل درس: هستی‌بخش",
  "position": 1,
  "old_start": 6,
  "old_end": 17,
  "start": 6,
  "end": 14
 },
 {
  "chapter": "درس ۱",
  "title": "نیازمندی جهان به خدا در پیدایش",
  "position": 2,
  "old_start": null,
  "old_end": null,
  "start": 7,
  "end": 8
 },
 {
  "chapter": "درس ۱",
  "title": "نیازمندی جهان به خدا در بقا",
  "position": 3,
  "old_start": null,
  "old_end": null,
  "start": 9,
  "end": 9
 },
 {
  "chapter": "درس ۱",
  "title": "آگاهی، سرچشمه بندگی و نور هستی",
  "position": 4,
  "old_start": null,
  "old_end": null,
  "start": 10,
  "end": 11
 },
 {
  "chapter": "درس ۱",
  "title": "ناتوانی در شناخت ذات و چیستی خداوند",
  "position": 5,
  "old_start": null,
  "old_end": null,
  "start": 12,
  "end": 14
 },
 {
  "chapter": "درس ۲",
  "title": "کل درس: یگانه بی‌همتا",
  "position": 1,
  "old_start": 18,
  "old_end": 29,
  "start": 18,
  "end": 26
 },
 {
  "chapter": "درس ۲",
  "title": "توحید و یکتاپرستی",
  "position": 2,
  "old_start": null,
  "old_end": null,
  "start": 19,
  "end": 19
 },
 {
  "chapter": "درس ۲",
  "title": "مراتب توحید: خالقیت، مالکیت، ولایت و ربوبیت",
  "position": 3,
  "old_start": null,
  "old_end": null,
  "start": 19,
  "end": 20
 },
 {
  "chapter": "درس ۲",
  "title": "شرک و مراتب آن",
  "position": 4,
  "old_start": null,
  "old_end": null,
  "start": 21,
  "end": 23
 },
 {
  "chapter": "درس ۲",
  "title": "توسل و شفاعت",
  "position": 5,
  "old_start": null,
  "old_end": null,
  "start": 23,
  "end": 26
 },
 {
  "chapter": "درس ۳",
  "title": "کل درس: توحید و سبک زندگی",
  "position": 1,
  "old_start": 30,
  "old_end": 41,
  "start": 30,
  "end": 38
 },
 {
  "chapter": "درس ۳",
  "title": "بازتاب توحید در زندگی",
  "position": 2,
  "old_start": null,
  "old_end": null,
  "start": 31,
  "end": 32
 },
 {
  "chapter": "درس ۳",
  "title": "بعد فردی توحید عملی",
  "position": 3,
  "old_start": null,
  "old_end": null,
  "start": 32,
  "end": 34
 },
 {
  "chapter": "درس ۳",
  "title": "بعد اجتماعی توحید عملی",
  "position": 4,
  "old_start": null,
  "old_end": null,
  "start": 35,
  "end": 35
 },
 {
  "chapter": "درس ۳",
  "title": "توحید و شرک در جهان امروز",
  "position": 5,
  "old_start": null,
  "old_end": null,
  "start": 36,
  "end": 38
 },
 {
  "chapter": "درس ۴",
  "title": "کل درس: فقط برای تو",
  "position": 1,
  "old_start": 42,
  "old_end": 51,
  "start": 42,
  "end": 48
 },
 {
  "chapter": "درس ۴",
  "title": "اخلاص در بندگی",
  "position": 2,
  "old_start": null,
  "old_end": null,
  "start": 44,
  "end": 45
 },
 {
  "chapter": "درس ۴",
  "title": "نیت و حسن فاعلی و فعلی",
  "position": 3,
  "old_start": null,
  "old_end": null,
  "start": 44,
  "end": 45
 },
 {
  "chapter": "درس ۴",
  "title": "راه‌های تقویت اخلاص",
  "position": 4,
  "old_start": null,
  "old_end": null,
  "start": 45,
  "end": 47
 },
 {
  "chapter": "درس ۴",
  "title": "میوه‌های درخت اخلاص",
  "position": 5,
  "old_start": null,
  "old_end": null,
  "start": 47,
  "end": 48
 },
 {
  "chapter": "درس ۵",
  "title": "کل درس: قدرت پرواز",
  "position": 1,
  "old_start": 52,
  "old_end": 63,
  "start": 52,
  "end": 60
 },
 {
  "chapter": "درس ۵",
  "title": "اختیار و نشانه‌های آن",
  "position": 2,
  "old_start": null,
  "old_end": null,
  "start": 53,
  "end": 55
 },
 {
  "chapter": "درس ۵",
  "title": "زمینه‌ساز شکوفایی اختیار",
  "position": 3,
  "old_start": null,
  "old_end": null,
  "start": 55,
  "end": 56
 },
 {
  "chapter": "درس ۵",
  "title": "قضا و قدر الهی",
  "position": 4,
  "old_start": null,
  "old_end": null,
  "start": 56,
  "end": 57
 },
 {
  "chapter": "درس ۵",
  "title": "اختیار انسان و اراده خدا",
  "position": 5,
  "old_start": null,
  "old_end": null,
  "start": 58,
  "end": 60
 },
 {
  "chapter": "درس ۶",
  "title": "کل درس: سنت‌های خداوند در زندگی",
  "position": 1,
  "old_start": 64,
  "old_end": 75,
  "start": 64,
  "end": 74
 },
 {
  "chapter": "درس ۶",
  "title": "سنت امتحان و ابتلا",
  "position": 2,
  "old_start": null,
  "old_end": null,
  "start": 68,
  "end": 70
 },
 {
  "chapter": "درس ۶",
  "title": "سنت امداد و توفیق",
  "position": 3,
  "old_start": null,
  "old_end": null,
  "start": 70,
  "end": 71
 },
 {
  "chapter": "درس ۶",
  "title": "سبقت رحمت بر غضب",
  "position": 4,
  "old_start": null,
  "old_end": null,
  "start": 71,
  "end": 72
 },
 {
  "chapter": "درس ۶",
  "title": "سنت املا و استدراج",
  "position": 5,
  "old_start": null,
  "old_end": null,
  "start": 72,
  "end": 73
 },
 {
  "chapter": "درس ۶",
  "title": "تأثیر اعمال انسان در زندگی",
  "position": 6,
  "old_start": null,
  "old_end": null,
  "start": 74,
  "end": 74
 },
 {
  "chapter": "درس ۷",
  "title": "کل درس: بازگشت",
  "position": 1,
  "old_start": 80,
  "old_end": 93,
  "start": 80,
  "end": 90
 },
 {
  "chapter": "درس ۷",
  "title": "حقیقت توبه و پاکی از گناه",
  "position": 2,
  "old_start": null,
  "old_end": null,
  "start": 82,
  "end": 84
 },
 {
  "chapter": "درس ۷",
  "title": "توبه و حیله‌های شیطان",
  "position": 3,
  "old_start": null,
  "old_end": null,
  "start": 84,
  "end": 86
 },
 {
  "chapter": "درس ۷",
  "title": "مراحل تکمیلی توبه",
  "position": 4,
  "old_start": null,
  "old_end": null,
  "start": 86,
  "end": 87
 },
 {
  "chapter": "درس ۷",
  "title": "توبه اجتماعی",
  "position": 5,
  "old_start": null,
  "old_end": null,
  "start": 88,
  "end": 90
 },
 {
  "chapter": "درس ۸",
  "title": "کل درس: زندگی در دنیای امروز و عمل به احکام الهی",
  "position": 1,
  "old_start": 94,
  "old_end": 107,
  "start": 94,
  "end": 104
 },
 {
  "chapter": "درس ۸",
  "title": "احکام الهی و زندگی امروز",
  "position": 2,
  "old_start": null,
  "old_end": null,
  "start": 95,
  "end": 100
 },
 {
  "chapter": "درس ۸",
  "title": "عرصه فرهنگ",
  "position": 3,
  "old_start": null,
  "old_end": null,
  "start": 100,
  "end": 101
 },
 {
  "chapter": "درس ۸",
  "title": "عرصه ورزش و بازی",
  "position": 4,
  "old_start": null,
  "old_end": null,
  "start": 102,
  "end": 103
 },
 {
  "chapter": "درس ۸",
  "title": "عرصه اقتصاد",
  "position": 5,
  "old_start": null,
  "old_end": null,
  "start": 103,
  "end": 104
 },
 {
  "chapter": "درس ۹",
  "title": "کل درس: پایه‌های استوار",
  "position": 1,
  "old_start": 108,
  "old_end": 125,
  "start": 108,
  "end": 122
 },
 {
  "chapter": "درس ۹",
  "title": "معیار توحید و معاد",
  "position": 2,
  "old_start": null,
  "old_end": null,
  "start": 109,
  "end": 109
 },
 {
  "chapter": "درس ۹",
  "title": "معیار ولایت و حکومت",
  "position": 3,
  "old_start": null,
  "old_end": null,
  "start": 109,
  "end": 110
 },
 {
  "chapter": "درس ۹",
  "title": "معیار عدالت اجتماعی",
  "position": 4,
  "old_start": null,
  "old_end": null,
  "start": 110,
  "end": 112
 },
 {
  "chapter": "درس ۹",
  "title": "جایگاه خانواده",
  "position": 5,
  "old_start": null,
  "old_end": null,
  "start": 112,
  "end": 115
 },
 {
  "chapter": "درس ۹",
  "title": "جایگاه علم و دانش",
  "position": 6,
  "old_start": null,
  "old_end": null,
  "start": 115,
  "end": 122
 },
 {
  "chapter": "درس ۱۰",
  "title": "کل درس: تمدن جدید و مسئولیت ما",
  "position": 1,
  "old_start": null,
  "old_end": null,
  "start": 126,
  "end": 136
 },
 {
  "chapter": "درس ۱۰",
  "title": "زمینه‌های پیدایش تمدن جدید",
  "position": 2,
  "old_start": null,
  "old_end": null,
  "start": 127,
  "end": 129
 },
 {
  "chapter": "درس ۱۰",
  "title": "آثار و پیامدهای تمدن جدید در حوزه علم",
  "position": 3,
  "old_start": null,
  "old_end": null,
  "start": 129,
  "end": 132
 },
 {
  "chapter": "درس ۱۰",
  "title": "عدل و قسط و مسئولیت ما",
  "position": 4,
  "old_start": null,
  "old_end": null,
  "start": 133,
  "end": 135
 },
 {
  "chapter": "درس ۱۰",
  "title": "خانواده و مسئولیت ما",
  "position": 5,
  "old_start": null,
  "old_end": null,
  "start": 135,
  "end": 136
 }
]$pages$::jsonb)
 as p(chapter text,title text,position integer,old_start integer,old_end integer,start integer,"end" integer)),
 fields(field) as (values ('experimental_sciences'),('mathematics'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from pages p cross join fields f
where t.id=md5('nova:planner:1405:v1:'||f.field||':12:final_exam:تعلیمات دینی ۳:'||p.chapter||':'||p.position)::uuid
 and t.edition='1405' and t.study_field=f.field and t.grade='12' and t.preparation_track='final_exam'
 and t.subject='تعلیمات دینی ۳' and t.chapter=p.chapter and t.title=p.title and t.position=p.position
 and t.page_start is not distinct from p.old_start and t.page_end is not distinct from p.old_end and t.revision=1;
