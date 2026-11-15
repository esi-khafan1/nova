-- Geography 11 and 12 legacy groups: page spans verified against 1405 PDF text.
-- Original grade 11 lesson 1's "کانون و مرزهای ناحیه" stays unpaged: the textbook teaches it in lesson 2.
-- Only untouched v1 originals with blank pages are changed.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱",
  "position": 1,
  "title": "مفهوم ناحیه و ویژگی‌های آن",
  "start": 2,
  "end": 4
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱",
  "position": 2,
  "title": "معیارهای طبیعی و انسانی ناحیه‌بندی",
  "start": 4,
  "end": 8
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۲",
  "position": 1,
  "title": "تعامل انسان و ناحیه",
  "start": 11,
  "end": 15
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۲",
  "position": 2,
  "title": "تأثیر ناحیه بر فعالیت انسان",
  "start": 12,
  "end": 13
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۲",
  "position": 3,
  "title": "تغییر نواحی و نقش تصمیم‌های انسان",
  "start": 12,
  "end": 15
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 1,
  "title": "هوا، آب و هوا و هواکره",
  "start": 20,
  "end": 23
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 2,
  "title": "عوامل پیدایش نواحی آب و هوایی",
  "start": 23,
  "end": 29
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۳",
  "position": 3,
  "title": "طبقه‌بندی اقلیم‌ها",
  "start": 29,
  "end": 32
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 2,
  "title": "اشکال ناهمواری‌ها",
  "start": 37,
  "end": 50
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۴",
  "position": 3,
  "title": "نقشه‌های توپوگرافی",
  "start": 51,
  "end": 52
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 1,
  "title": "بوم‌سازگان و زیست‌بوم",
  "start": 53,
  "end": 55
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 2,
  "title": "زیست‌بوم‌های جهان",
  "start": 54,
  "end": 58
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 3,
  "title": "حفاظت از نواحی زیستی",
  "start": 58,
  "end": 64
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۵",
  "position": 4,
  "title": "مطالعه موردی ۱: نپال، زندگی در بلندی‌ها",
  "start": 65,
  "end": 66
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 1,
  "title": "مفهوم ناحیه فرهنگی",
  "start": 68,
  "end": 71
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۶",
  "position": 2,
  "title": "زبان، دین و نواحی فرهنگی جهان",
  "start": 69,
  "end": 78
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 1,
  "title": "فعالیت‌های اقتصادی و کشاورزی",
  "start": 83,
  "end": 85
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 2,
  "title": "نواحی کشاورزی و دامداری جهان",
  "start": 84,
  "end": 94
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۷",
  "position": 3,
  "title": "نواحی صنعتی",
  "start": 95,
  "end": 98
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 1,
  "title": "نابرابری اقتصادی و توسعه",
  "start": 102,
  "end": 107
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 2,
  "title": "اقتصاد جهانی و تجارت",
  "start": 99,
  "end": 103
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 3,
  "title": "همکاری و اتحادیه‌های اقتصادی",
  "start": 108,
  "end": 110
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۸",
  "position": 4,
  "title": "مطالعه موردی ۲: ناحیه فرهنگی جهان اسلام",
  "start": 113,
  "end": 114
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 1,
  "title": "مفهوم و ارکان ناحیه سیاسی",
  "start": 116,
  "end": 119
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۹",
  "position": 2,
  "title": "انواع نواحی سیاسی",
  "start": 118,
  "end": 120
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 1,
  "title": "کشور و قلمرو",
  "start": 127,
  "end": 129
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 2,
  "title": "جمعیت و حکومت",
  "start": 127,
  "end": 129
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۰",
  "position": 3,
  "title": "مرز و مدیریت کشور",
  "start": 129,
  "end": 141
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 1,
  "title": "ژئوپلیتیک و قدرت",
  "start": 142,
  "end": 145
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 2,
  "title": "عوامل جغرافیایی مؤثر بر قدرت",
  "start": 149,
  "end": 152
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 3,
  "title": "مناطق ژئوپلیتیکی",
  "start": 152,
  "end": 154
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 4,
  "title": "مطالعه موردی ۳: ناحیه ژئوپلیتیکی خلیج فارس",
  "start": 154,
  "end": 156
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
  "chapter": "درس ۱۱",
  "position": 5,
  "title": "مطالعه موردی ۴: ناحیه ژئوپلیتیکی اتحادیه اروپا",
  "start": 157,
  "end": 159
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 1,
  "title": "هسته اولیه و موقعیت سکونتگاه‌ها",
  "start": 2,
  "end": 5
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 2,
  "title": "تفاوت‌ها و روابط شهر و روستا",
  "start": 6,
  "end": 20
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۱",
  "position": 3,
  "title": "تغییر سکونتگاه‌ها و شهرگرایی",
  "start": 10,
  "end": 17
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 1,
  "title": "مدیریت سکونتگاه‌های شهری و روستایی",
  "start": 28,
  "end": 34
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 2,
  "title": "مسائل شهرها و روستاها",
  "start": 21,
  "end": 27
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 3,
  "title": "برنامه‌ریزی و توسعه پایدار",
  "start": 28,
  "end": 37
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۲",
  "position": 4,
  "title": "فنون و مهارت‌های جغرافیایی ۱",
  "start": 38,
  "end": 40
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 1,
  "title": "مفهوم و اهمیت حمل و نقل",
  "start": 42,
  "end": 44
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 2,
  "title": "حمل و نقل جاده‌ای و ریلی",
  "start": 45,
  "end": 51
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۳",
  "position": 3,
  "title": "حمل و نقل آبی، هوایی و خطوط لوله",
  "start": 52,
  "end": 58
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 1,
  "title": "مدیریت و حمل و نقل پایدار",
  "start": 59,
  "end": 64
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 2,
  "title": "حمل و نقل چندوجهی و ایمنی",
  "start": 65,
  "end": 66
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 3,
  "title": "حمل و نقل عمومی شهری",
  "start": 67,
  "end": 72
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۴",
  "position": 4,
  "title": "فنون و مهارت‌های جغرافیایی ۲",
  "start": 73,
  "end": 80
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 1,
  "title": "مفهوم و انواع مخاطرات طبیعی",
  "start": 82,
  "end": 82
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 2,
  "title": "زمین‌لرزه و آتشفشان",
  "start": 82,
  "end": 88
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۵",
  "position": 3,
  "title": "سیل و خشکسالی",
  "start": 89,
  "end": 99
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 1,
  "title": "مفهوم مدیریت مخاطرات",
  "start": 100,
  "end": 100
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 2,
  "title": "اقدامات پیش از وقوع مخاطرات",
  "start": 101,
  "end": 108
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 3,
  "title": "اقدامات هنگام و پس از وقوع مخاطرات",
  "start": 102,
  "end": 110
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
  "chapter": "درس ۶",
  "position": 4,
  "title": "فنون و مهارت‌های جغرافیایی ۳",
  "start": 111,
  "end": 114
 }
]$fixes$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field='humanities' and t.grade=p.grade and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
