-- Arabic 111206 and 111207, user-provided 1405 PDFs; printed-page sections.
-- Install once and update untouched v1 rows only; never alter snapshots.
with installed as (insert into private.planner_seed_installations(seed_key) values ('arabic11-1405-v189') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 300,
    "title": "کل درس",
    "start": 1,
    "end": 16
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 301,
    "title": "متن: مواعظ قیمة",
    "start": 2,
    "end": 2
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 302,
    "title": "واژگان درس",
    "start": 3,
    "end": 3
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 303,
    "title": "اسم تفضیل",
    "start": 4,
    "end": 7
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 304,
    "title": "اسم مکان",
    "start": 8,
    "end": 8
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 305,
    "title": "گفت‌وگو در بازار",
    "start": 9,
    "end": 9
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 306,
    "title": "تمرین‌های درس",
    "start": 10,
    "end": 14
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 307,
    "title": "پژوهش علمی",
    "start": 15,
    "end": 15
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 308,
    "title": "تمرین تصویری",
    "start": 16,
    "end": 16
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۲",
    "position": 300,
    "title": "کل درس",
    "start": 17,
    "end": 30
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۲",
    "position": 301,
    "title": "متن: تلمیع در ادب فارسی",
    "start": 18,
    "end": 19
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۲",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 20,
    "end": 21
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۲",
    "position": 303,
    "title": "اسم فاعل و اسم مفعول",
    "start": 21,
    "end": 23
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۲",
    "position": 304,
    "title": "اسم مبالغه",
    "start": 24,
    "end": 25
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۲",
    "position": 305,
    "title": "تمرین‌های درس",
    "start": 26,
    "end": 30
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۳",
    "position": 300,
    "title": "کل درس",
    "start": 31,
    "end": 46
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۳",
    "position": 301,
    "title": "متن: عجایب مخلوقات",
    "start": 32,
    "end": 34
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۳",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 35,
    "end": 36
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۳",
    "position": 303,
    "title": "اسلوب شرط و ادوات آن",
    "start": 36,
    "end": 39
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۳",
    "position": 304,
    "title": "گفت‌وگو در ورزشگاه",
    "start": 40,
    "end": 40
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۳",
    "position": 305,
    "title": "تمرین‌های درس",
    "start": 41,
    "end": 46
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۴",
    "position": 300,
    "title": "کل درس",
    "start": 47,
    "end": 62
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۴",
    "position": 301,
    "title": "متن: تأثیر زبان فارسی بر عربی",
    "start": 48,
    "end": 49
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۴",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 50,
    "end": 50
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۴",
    "position": 303,
    "title": "معرفه و نکره",
    "start": 51,
    "end": 53
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۴",
    "position": 304,
    "title": "ترجمه فعل مضارع ۱",
    "start": 53,
    "end": 54
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۴",
    "position": 305,
    "title": "تمرین‌های درس",
    "start": 55,
    "end": 61
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۴",
    "position": 306,
    "title": "تمرین تصویری",
    "start": 62,
    "end": 62
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۵",
    "position": 300,
    "title": "کل درس",
    "start": 63,
    "end": 74
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۵",
    "position": 301,
    "title": "متن: الصدق",
    "start": 64,
    "end": 65
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۵",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 66,
    "end": 67
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۵",
    "position": 303,
    "title": "جمله پس از نکره",
    "start": 68,
    "end": 69
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۵",
    "position": 304,
    "title": "گفت‌وگو: خرید سیم‌کارت",
    "start": 70,
    "end": 70
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۵",
    "position": 305,
    "title": "تمرین‌های درس",
    "start": 71,
    "end": 73
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۵",
    "position": 306,
    "title": "تمرین تصویری",
    "start": 74,
    "end": 74
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۶",
    "position": 300,
    "title": "کل درس",
    "start": 75,
    "end": 88
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۶",
    "position": 301,
    "title": "متن: ارحموا ثلاثة",
    "start": 76,
    "end": 77
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۶",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 77,
    "end": 78
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۶",
    "position": 303,
    "title": "ترجمه فعل مضارع ۲",
    "start": 79,
    "end": 81
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۶",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 82,
    "end": 87
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۶",
    "position": 305,
    "title": "تمرین تصویری",
    "start": 88,
    "end": 88
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۷",
    "position": 300,
    "title": "کل درس",
    "start": 89,
    "end": 101
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۷",
    "position": 301,
    "title": "متن: لا تقنطوا",
    "start": 90,
    "end": 92
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۷",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 93,
    "end": 93
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۷",
    "position": 303,
    "title": "معانی افعال ناقصه",
    "start": 94,
    "end": 96
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۷",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 97,
    "end": 101
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۱",
    "position": 300,
    "title": "کل درس",
    "start": 1,
    "end": 18
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۱",
    "position": 301,
    "title": "متن: من آیات الأخلاق",
    "start": 2,
    "end": 3
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۱",
    "position": 302,
    "title": "واژگان درس",
    "start": 4,
    "end": 4
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۱",
    "position": 303,
    "title": "اسم تفضیل",
    "start": 5,
    "end": 8
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۱",
    "position": 304,
    "title": "اسم مکان",
    "start": 9,
    "end": 9
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۱",
    "position": 305,
    "title": "گفت‌وگو در بازار",
    "start": 10,
    "end": 11
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۱",
    "position": 306,
    "title": "تمرین‌های درس",
    "start": 12,
    "end": 17
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۱",
    "position": 307,
    "title": "پژوهش علمی",
    "start": 18,
    "end": 18
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۲",
    "position": 300,
    "title": "کل درس",
    "start": 19,
    "end": 32
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۲",
    "position": 301,
    "title": "متن: فی آداب الصف",
    "start": 20,
    "end": 21
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۲",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 22,
    "end": 23
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۲",
    "position": 303,
    "title": "اسلوب شرط و ادوات آن",
    "start": 24,
    "end": 26
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۲",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 27,
    "end": 31
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۲",
    "position": 305,
    "title": "پژوهش علمی",
    "start": 32,
    "end": 32
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۳",
    "position": 300,
    "title": "کل درس",
    "start": 33,
    "end": 48
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۳",
    "position": 301,
    "title": "متن: عجایب درختان",
    "start": 34,
    "end": 35
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۳",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 36,
    "end": 37
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۳",
    "position": 303,
    "title": "معرفه و نکره",
    "start": 37,
    "end": 39
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۳",
    "position": 304,
    "title": "گفت‌وگو در ورزشگاه",
    "start": 40,
    "end": 40
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۳",
    "position": 305,
    "title": "تمرین‌های درس",
    "start": 41,
    "end": 47
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۳",
    "position": 306,
    "title": "پژوهش علمی",
    "start": 48,
    "end": 48
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۴",
    "position": 300,
    "title": "کل درس",
    "start": 49,
    "end": 62
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۴",
    "position": 301,
    "title": "متن: آداب الکلام",
    "start": 50,
    "end": 51
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۴",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 52,
    "end": 52
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۴",
    "position": 303,
    "title": "جمله بعد از نکره",
    "start": 53,
    "end": 54
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۴",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 55,
    "end": 60
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۴",
    "position": 305,
    "title": "پژوهش علمی",
    "start": 61,
    "end": 61
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۴",
    "position": 306,
    "title": "تمرین تصویری",
    "start": 62,
    "end": 62
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۵",
    "position": 300,
    "title": "کل درس",
    "start": 63,
    "end": 74
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۵",
    "position": 301,
    "title": "متن: الکذب مفتاح لکل شر",
    "start": 64,
    "end": 66
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۵",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 66,
    "end": 67
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۵",
    "position": 303,
    "title": "ترجمه فعل مضارع ۱",
    "start": 68,
    "end": 69
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۵",
    "position": 304,
    "title": "گفت‌وگو در داروخانه",
    "start": 70,
    "end": 70
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۵",
    "position": 305,
    "title": "تمرین‌های درس",
    "start": 71,
    "end": 73
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۵",
    "position": 306,
    "title": "پژوهش علمی",
    "start": 74,
    "end": 74
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۶",
    "position": 300,
    "title": "کل درس",
    "start": 75,
    "end": 88
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۶",
    "position": 301,
    "title": "متن: آنه‌ماری شیمل",
    "start": 76,
    "end": 77
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۶",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 78,
    "end": 79
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۶",
    "position": 303,
    "title": "ترجمه فعل مضارع ۲",
    "start": 79,
    "end": 82
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۶",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 83,
    "end": 87
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۶",
    "position": 305,
    "title": "تمرین تصویری",
    "start": 88,
    "end": 88
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۷",
    "position": 300,
    "title": "کل درس",
    "start": 89,
    "end": 101
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۷",
    "position": 301,
    "title": "متن: تأثیر زبان فارسی بر عربی",
    "start": 90,
    "end": 91
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۷",
    "position": 302,
    "title": "واژگان و درک مطلب",
    "start": 92,
    "end": 92
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۷",
    "position": 303,
    "title": "افعال ناقصه",
    "start": 93,
    "end": 94
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۷",
    "position": 304,
    "title": "گفت‌وگو در مسجد",
    "start": 95,
    "end": 95
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۷",
    "position": 305,
    "title": "تمرین‌های درس",
    "start": 96,
    "end": 100
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۷",
    "position": 306,
    "title": "سخن پایانی",
    "start": 101,
    "end": 101
  }
]$topics$::jsonb) as p(subject text,chapter text,position integer,title text,start integer,"end" integer)),
contexts(subject,field,track) as (values ('عربی ۲ تخصصی','humanities','konkur'),('عربی ۲ تخصصی','humanities','final_exam'),('عربی زبان قرآن ۲','mathematics','final_exam'),('عربی زبان قرآن ۲','experimental_sciences','final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v189:'||c.field||':11:'||c.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',c.field,'11',c.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p join contexts c on c.subject=p.subject cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 1,
    "title": "متن و واژگان: مواعظ قیمة",
    "new_title": "متن و واژگان: مواعظ قیمة",
    "start": 2,
    "end": 3
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 2,
    "title": "قواعد: اسم تفضیل و اسم مکان",
    "new_title": "قواعد: اسم تفضیل و اسم مکان",
    "start": 4,
    "end": 8
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۱",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 10,
    "end": 15
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۲",
    "position": 1,
    "title": "متن و واژگان: صناعة التلمیع فی الأدب الفارسی",
    "new_title": "متن و واژگان: صناعة التلمیع فی الأدب الفارسی",
    "start": 18,
    "end": 21
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۲",
    "position": 2,
    "title": "قواعد: اسم فاعل، اسم مفعول و اسم مبالغه",
    "new_title": "قواعد: اسم فاعل، اسم مفعول و اسم مبالغه",
    "start": 21,
    "end": 25
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۲",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 26,
    "end": 30
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۳",
    "position": 1,
    "title": "متن و واژگان: عجائب المخلوقات",
    "new_title": "متن و واژگان: عجائب المخلوقات",
    "start": 32,
    "end": 36
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۳",
    "position": 2,
    "title": "قواعد: اسلوب شرط و ادوات آن",
    "new_title": "قواعد: اسلوب شرط و ادوات آن",
    "start": 36,
    "end": 39
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۳",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 41,
    "end": 46
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۴",
    "position": 1,
    "title": "متن و واژگان: تأثیر اللغة الفارسیة علی اللغة العربیة",
    "new_title": "متن و واژگان: تأثیر اللغة الفارسیة علی اللغة العربیة",
    "start": 48,
    "end": 50
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۴",
    "position": 2,
    "title": "قواعد: معرفه و نکره و ترجمه فعل مضارع",
    "new_title": "قواعد: معرفه و نکره و ترجمه فعل مضارع",
    "start": 51,
    "end": 54
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۴",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 55,
    "end": 61
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۵",
    "position": 1,
    "title": "متن و واژگان: الصدق",
    "new_title": "متن و واژگان: الصدق",
    "start": 64,
    "end": 67
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۵",
    "position": 2,
    "title": "قواعد: جمله بعد از نکره",
    "new_title": "قواعد: جمله بعد از نکره",
    "start": 68,
    "end": 69
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۵",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 71,
    "end": 73
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۶",
    "position": 1,
    "title": "متن و واژگان: ارحموا ثلاثاً",
    "new_title": "متن و واژگان: ارحموا ثلاثاً",
    "start": 76,
    "end": 78
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۶",
    "position": 2,
    "title": "قواعد: ترجمه فعل مضارع",
    "new_title": "قواعد: ترجمه فعل مضارع",
    "start": 79,
    "end": 81
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۶",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 82,
    "end": 87
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۷",
    "position": 1,
    "title": "متن و واژگان: لا تقنطوا",
    "new_title": "متن و واژگان: لا تقنطوا",
    "start": 90,
    "end": 93
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۷",
    "position": 2,
    "title": "قواعد: افعال ناقصه",
    "new_title": "قواعد: افعال ناقصه",
    "start": 94,
    "end": 96
  },
  {
    "subject": "عربی ۲ تخصصی",
    "chapter": "درس ۷",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 97,
    "end": 101
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۱",
    "position": 1,
    "title": "متن و واژگان: من آیات الأخلاق",
    "new_title": "متن و واژگان: من آیات الأخلاق",
    "start": 2,
    "end": 4
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۱",
    "position": 2,
    "title": "قواعد: اسم تفضیل و اسم مکان",
    "new_title": "قواعد: اسم تفضیل و اسم مکان",
    "start": 5,
    "end": 9
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۱",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 12,
    "end": 17
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۲",
    "position": 1,
    "title": "متن و واژگان: فی محضر المعلم",
    "new_title": "متن و واژگان: فی آداب الصف",
    "start": 20,
    "end": 23
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۲",
    "position": 2,
    "title": "قواعد: اسلوب شرط و ادوات آن",
    "new_title": "قواعد: اسلوب شرط و ادوات آن",
    "start": 24,
    "end": 26
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۲",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 27,
    "end": 31
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۳",
    "position": 1,
    "title": "متن و واژگان: عجائب الأشجار",
    "new_title": "متن و واژگان: عجائب الأشجار",
    "start": 34,
    "end": 37
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۳",
    "position": 2,
    "title": "قواعد: معرفه و نکره",
    "new_title": "قواعد: معرفه و نکره",
    "start": 37,
    "end": 39
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۳",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 41,
    "end": 47
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۴",
    "position": 1,
    "title": "متن و واژگان: آداب الکلام",
    "new_title": "متن و واژگان: آداب الکلام",
    "start": 50,
    "end": 52
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۴",
    "position": 2,
    "title": "قواعد: ترجمه فعل مضارع",
    "new_title": "قواعد: جمله بعد از نکره",
    "start": 53,
    "end": 54
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۴",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 55,
    "end": 60
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۵",
    "position": 1,
    "title": "متن و واژگان: الکذب مفتاح لکل شر",
    "new_title": "متن و واژگان: الکذب مفتاح لکل شر",
    "start": 64,
    "end": 67
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۵",
    "position": 2,
    "title": "قواعد: ترجمه فعل مضارع",
    "new_title": "قواعد: ترجمه فعل مضارع",
    "start": 68,
    "end": 69
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۵",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 71,
    "end": 73
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۶",
    "position": 1,
    "title": "متن و واژگان: آنّه ماری شیمل",
    "new_title": "متن و واژگان: آنّه ماری شیمل",
    "start": 76,
    "end": 79
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۶",
    "position": 2,
    "title": "قواعد: ترجمه فعل مضارع",
    "new_title": "قواعد: ترجمه فعل مضارع",
    "start": 79,
    "end": 82
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۶",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 83,
    "end": 87
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۷",
    "position": 1,
    "title": "متن و واژگان: تأثیر اللغة الفارسیة علی اللغة العربیة",
    "new_title": "متن و واژگان: تأثیر اللغة الفارسیة علی اللغة العربیة",
    "start": 90,
    "end": 92
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۷",
    "position": 2,
    "title": "قواعد: افعال ناقصه",
    "new_title": "قواعد: افعال ناقصه",
    "start": 93,
    "end": 94
  },
  {
    "subject": "عربی زبان قرآن ۲",
    "chapter": "درس ۷",
    "position": 3,
    "title": "تمرین‌های درس",
    "new_title": "تمرین‌های درس",
    "start": 96,
    "end": 100
  }
]$fixes$::jsonb) as p(subject text,chapter text,position integer,title text,new_title text,start integer,"end" integer)),
contexts(subject,field,track) as (values ('عربی ۲ تخصصی','humanities','konkur'),('عربی ۲ تخصصی','humanities','final_exam'),('عربی زبان قرآن ۲','mathematics','final_exam'),('عربی زبان قرآن ۲','experimental_sciences','final_exam'))
update private.planner_topic_bank t set title=p.new_title,page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p join contexts c on c.subject=p.subject
where t.id=md5('nova:planner:1405:v1:'||c.field||':11:'||c.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field=c.field and t.grade='11' and t.preparation_track=c.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
