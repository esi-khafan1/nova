-- Arabic 110206 and 110207, user-supplied 1405 PDFs; printed-page sections.
-- One-time installation and exact compare-and-set leave admin edits/deletions and snapshots alone.
with installed as (insert into private.planner_seed_installations(seed_key) values ('arabic10-1405-v191') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 300,
    "title": "کل درس",
    "start": 1,
    "end": 16
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 301,
    "title": "متن و واژگان: ذاک هو الله",
    "start": 2,
    "end": 4
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 302,
    "title": "قواعد: افعال، ضمایر و اسم اشاره",
    "start": 5,
    "end": 9
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 303,
    "title": "گفت‌وگو: التعارف",
    "start": 10,
    "end": 10
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 11,
    "end": 14
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 305,
    "title": "فعل‌ها و ضمیرها",
    "start": 5,
    "end": 8
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 306,
    "title": "اسم اشاره",
    "start": 9,
    "end": 9
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 307,
    "title": "پژوهش علمی",
    "start": 15,
    "end": 15
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 308,
    "title": "تصاویر و مکان‌ها",
    "start": 16,
    "end": 16
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۲",
    "position": 300,
    "title": "کل درس",
    "start": 17,
    "end": 30
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۲",
    "position": 301,
    "title": "متن و واژگان: إنکم مسؤولون",
    "start": 18,
    "end": 21
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۲",
    "position": 302,
    "title": "قواعد: اعداد از یک تا صد",
    "start": 22,
    "end": 24
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۲",
    "position": 303,
    "title": "گفت‌وگو: گردشگر ایرانی",
    "start": 25,
    "end": 25
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۲",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 26,
    "end": 29
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۲",
    "position": 305,
    "title": "پژوهش علمی",
    "start": 30,
    "end": 30
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 300,
    "title": "کل درس",
    "start": 31,
    "end": 50
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 301,
    "title": "متن و واژگان: مطر السمک",
    "start": 32,
    "end": 35
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 302,
    "title": "قواعد: فعل ثلاثی مجرد و مزید ۱",
    "start": 36,
    "end": 43
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 303,
    "title": "گفت‌وگو: فی قسم الجوازات",
    "start": 44,
    "end": 44
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 45,
    "end": 48
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 305,
    "title": "فعل ثلاثی مجرد و مزید",
    "start": 36,
    "end": 37
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 306,
    "title": "فعل لازم و متعدی",
    "start": 38,
    "end": 38
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 307,
    "title": "یادآوری فعل‌ها",
    "start": 39,
    "end": 43
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 308,
    "title": "پژوهش علمی",
    "start": 49,
    "end": 49
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 309,
    "title": "تمرین در منزل",
    "start": 50,
    "end": 50
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 300,
    "title": "کل درس",
    "start": 51,
    "end": 66
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 301,
    "title": "متن و واژگان: التعایش السلمی",
    "start": 52,
    "end": 55
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 302,
    "title": "قواعد: فعل ثلاثی مزید ۲",
    "start": 56,
    "end": 59
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 303,
    "title": "گفت‌وگو: فی صالة التفتیش",
    "start": 60,
    "end": 60
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 61,
    "end": 65
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 305,
    "title": "باب‌های فعل مزید",
    "start": 56,
    "end": 56
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 306,
    "title": "یادآوری شناسه‌های فعل",
    "start": 57,
    "end": 59
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 307,
    "title": "پژوهش علمی",
    "start": 66,
    "end": 66
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۵",
    "position": 300,
    "title": "کل درس",
    "start": 67,
    "end": 80
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۵",
    "position": 301,
    "title": "متن و واژگان: هذا خلق الله",
    "start": 68,
    "end": 71
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۵",
    "position": 302,
    "title": "قواعد: جمله اسمیه و فعلیه",
    "start": 72,
    "end": 73
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۵",
    "position": 303,
    "title": "گفت‌وگو: مع سائق سیارة الأجرة",
    "start": 74,
    "end": 74
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۵",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 75,
    "end": 79
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۵",
    "position": 305,
    "title": "پژوهش علمی",
    "start": 80,
    "end": 80
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 300,
    "title": "کل درس",
    "start": 81,
    "end": 92
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 301,
    "title": "متن و واژگان: المعالم الخلابة",
    "start": 82,
    "end": 84
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 302,
    "title": "قواعد: اعراب اجزای جمله اسمیه و فعلیه",
    "start": 85,
    "end": 88
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 303,
    "title": "گفت‌وگو: فی الصیدلیة",
    "start": 89,
    "end": 89
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 90,
    "end": 92
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 305,
    "title": "اعراب و علامت‌های آن",
    "start": 85,
    "end": 86
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 306,
    "title": "اعراب فاعل و مفعول و مبتدا و خبر",
    "start": 87,
    "end": 87
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 307,
    "title": "اعراب صفت و مضاف‌الیه",
    "start": 88,
    "end": 88
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۷",
    "position": 300,
    "title": "کل درس",
    "start": 93,
    "end": 104
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۷",
    "position": 301,
    "title": "متن و واژگان: صناعة النفط",
    "start": 94,
    "end": 96
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۷",
    "position": 302,
    "title": "قواعد: فعل معلوم و مجهول",
    "start": 97,
    "end": 99
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۷",
    "position": 303,
    "title": "گفت‌وگو: مع مسؤول استقبال الفندق",
    "start": 100,
    "end": 100
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۷",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 101,
    "end": 103
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۷",
    "position": 305,
    "title": "پژوهش علمی",
    "start": 104,
    "end": 104
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 300,
    "title": "کل درس",
    "start": 105,
    "end": 120
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 301,
    "title": "متن و واژگان: یا من فی البحار عجائبه",
    "start": 106,
    "end": 108
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 302,
    "title": "قواعد: جار و مجرور و نون وقایه",
    "start": 109,
    "end": 113
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 303,
    "title": "گفت‌وگو: مع مشرف خدمات الفندق",
    "start": 114,
    "end": 114
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 115,
    "end": 118
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 305,
    "title": "جار و مجرور",
    "start": 109,
    "end": 112
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 306,
    "title": "نون وقایه",
    "start": 113,
    "end": 113
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 307,
    "title": "پژوهش علمی",
    "start": 119,
    "end": 119
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 308,
    "title": "سخن پایانی",
    "start": 120,
    "end": 120
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 300,
    "title": "کل درس",
    "start": 1,
    "end": 14
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 301,
    "title": "متن و واژگان: ذاک هو الله",
    "start": 2,
    "end": 3
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 302,
    "title": "قواعد: افعال، ضمایر و اسم اشاره",
    "start": 5,
    "end": 9
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 303,
    "title": "گفت‌وگو: التعارف",
    "start": 4,
    "end": 4
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 10,
    "end": 12
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 305,
    "title": "فعل‌ها و ضمیرها",
    "start": 5,
    "end": 8
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 306,
    "title": "اسم اشاره",
    "start": 9,
    "end": 9
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 307,
    "title": "پژوهش علمی",
    "start": 13,
    "end": 13
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 308,
    "title": "تصاویر و مکان‌ها",
    "start": 14,
    "end": 14
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۲",
    "position": 300,
    "title": "کل درس",
    "start": 15,
    "end": 26
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۲",
    "position": 301,
    "title": "متن و واژگان: المواعظ العددیة",
    "start": 16,
    "end": 18
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۲",
    "position": 302,
    "title": "قواعد: اعداد از یک تا صد",
    "start": 19,
    "end": 20
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۲",
    "position": 303,
    "title": "گفت‌وگو: گردشگر ایرانی",
    "start": 21,
    "end": 21
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۲",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 22,
    "end": 26
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 300,
    "title": "کل درس",
    "start": 27,
    "end": 44
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 301,
    "title": "متن و واژگان: مطر السمک",
    "start": 28,
    "end": 31
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 302,
    "title": "قواعد: اشکال افعال ۱",
    "start": 32,
    "end": 38
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 303,
    "title": "گفت‌وگو: فی قسم الجوازات",
    "start": 39,
    "end": 39
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 40,
    "end": 43
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 305,
    "title": "اشکال فعل‌ها",
    "start": 32,
    "end": 33
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 306,
    "title": "یادآوری فعل ماضی و امر",
    "start": 34,
    "end": 38
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 307,
    "title": "پژوهش علمی",
    "start": 44,
    "end": 44
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 300,
    "title": "کل درس",
    "start": 45,
    "end": 60
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 301,
    "title": "متن و واژگان: التعایش السلمی",
    "start": 46,
    "end": 49
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 302,
    "title": "قواعد: اشکال افعال ۲",
    "start": 50,
    "end": 54
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 303,
    "title": "گفت‌وگو: فی صالة التفتیش",
    "start": 51,
    "end": 51
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 55,
    "end": 59
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 305,
    "title": "اشکال فعل‌ها",
    "start": 50,
    "end": 50
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 306,
    "title": "یادآوری شناسه‌های فعل",
    "start": 52,
    "end": 54
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 307,
    "title": "پژوهش علمی",
    "start": 60,
    "end": 60
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۵",
    "position": 300,
    "title": "کل درس",
    "start": 61,
    "end": 76
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۵",
    "position": 301,
    "title": "متن و واژگان: هذا خلق الله",
    "start": 62,
    "end": 66
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۵",
    "position": 302,
    "title": "قواعد: جمله فعلیه و اسمیه",
    "start": 67,
    "end": 68
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۵",
    "position": 303,
    "title": "گفت‌وگو: مع سائق سیارة الأجرة",
    "start": 69,
    "end": 69
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۵",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 70,
    "end": 75
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۵",
    "position": 305,
    "title": "پژوهش علمی",
    "start": 76,
    "end": 76
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۶",
    "position": 300,
    "title": "کل درس",
    "start": 77,
    "end": 88
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۶",
    "position": 301,
    "title": "متن و واژگان: ذوالقرنین",
    "start": 78,
    "end": 80
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۶",
    "position": 302,
    "title": "قواعد: فعل مجهول",
    "start": 81,
    "end": 82
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۶",
    "position": 303,
    "title": "گفت‌وگو: مع مسؤول استقبال الفندق",
    "start": 83,
    "end": 83
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۶",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 84,
    "end": 87
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۶",
    "position": 305,
    "title": "پژوهش علمی",
    "start": 88,
    "end": 88
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 300,
    "title": "کل درس",
    "start": 89,
    "end": 104
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 301,
    "title": "متن و واژگان: یا من فی البحار عجائبه",
    "start": 90,
    "end": 92
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 302,
    "title": "قواعد: جار و مجرور و نون وقایه",
    "start": 93,
    "end": 96
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 303,
    "title": "گفت‌وگو: مع مشرف خدمات الفندق",
    "start": 97,
    "end": 97
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 98,
    "end": 103
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 305,
    "title": "جار و مجرور",
    "start": 93,
    "end": 95
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 306,
    "title": "نون وقایه",
    "start": 96,
    "end": 96
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 307,
    "title": "پژوهش علمی",
    "start": 104,
    "end": 104
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 300,
    "title": "کل درس",
    "start": 105,
    "end": 118
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 301,
    "title": "متن و واژگان: صناعة التلمیع فی الأدب الفارسی",
    "start": 106,
    "end": 108
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 302,
    "title": "قواعد: اسم فاعل، اسم مفعول و اسم مبالغه",
    "start": 109,
    "end": 111
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 303,
    "title": "گفت‌وگو: شراء شریحة الهاتف الجوال",
    "start": 112,
    "end": 112
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 113,
    "end": 117
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 305,
    "title": "اسم فاعل و اسم مفعول",
    "start": 109,
    "end": 110
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 306,
    "title": "اسم مبالغه",
    "start": 111,
    "end": 111
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 307,
    "title": "سخن پایانی",
    "start": 118,
    "end": 118
  }
]$topics$::jsonb) as p(subject text,chapter text,position integer,title text,start integer,"end" integer)),
contexts(subject,field,track) as (values ('عربی ۱ تخصصی','humanities','konkur'),('عربی ۱ تخصصی','humanities','final_exam'),('عربی زبان قرآن ۱','mathematics','final_exam'),('عربی زبان قرآن ۱','experimental_sciences','final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v191:'||c.field||':10:'||c.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',c.field,'10',c.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p join contexts c on c.subject=p.subject cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 1,
    "title": "متن و واژگان: ذاک هو الله",
    "start": 2,
    "end": 4,
    "new_title": "متن و واژگان: ذاک هو الله"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 2,
    "title": "قواعد: افعال، ضمایر و اسم اشاره",
    "start": 5,
    "end": 9,
    "new_title": "قواعد: افعال، ضمایر و اسم اشاره"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 3,
    "title": "گفت‌وگو: التعارف",
    "start": 10,
    "end": 10,
    "new_title": "گفت‌وگو: التعارف"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۱",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 11,
    "end": 14,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۲",
    "position": 1,
    "title": "متن و واژگان: إنکم مسؤولون",
    "start": 18,
    "end": 21,
    "new_title": "متن و واژگان: إنکم مسؤولون"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۲",
    "position": 2,
    "title": "قواعد: اعداد از یک تا صد",
    "start": 22,
    "end": 24,
    "new_title": "قواعد: اعداد از یک تا صد"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۲",
    "position": 3,
    "title": "گفت‌وگو: فی مطار النجف",
    "start": 25,
    "end": 25,
    "new_title": "گفت‌وگو: گردشگر ایرانی"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۲",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 26,
    "end": 29,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 1,
    "title": "متن و واژگان: مطر السمک",
    "start": 32,
    "end": 35,
    "new_title": "متن و واژگان: مطر السمک"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 2,
    "title": "قواعد: فعل ثلاثی مجرد و مزید ۱",
    "start": 36,
    "end": 43,
    "new_title": "قواعد: فعل ثلاثی مجرد و مزید ۱"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 3,
    "title": "گفت‌وگو: فی قسم الجوازات",
    "start": 44,
    "end": 44,
    "new_title": "گفت‌وگو: فی قسم الجوازات"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۳",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 45,
    "end": 48,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 1,
    "title": "متن و واژگان: التعایش السلمی",
    "start": 52,
    "end": 55,
    "new_title": "متن و واژگان: التعایش السلمی"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 2,
    "title": "قواعد: فعل ثلاثی مزید ۲",
    "start": 56,
    "end": 59,
    "new_title": "قواعد: فعل ثلاثی مزید ۲"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 3,
    "title": "گفت‌وگو: فی صالة التفتیش",
    "start": 60,
    "end": 60,
    "new_title": "گفت‌وگو: فی صالة التفتیش"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۴",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 61,
    "end": 65,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۵",
    "position": 1,
    "title": "متن و واژگان: هذا خلق الله",
    "start": 68,
    "end": 71,
    "new_title": "متن و واژگان: هذا خلق الله"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۵",
    "position": 2,
    "title": "قواعد: جمله اسمیه و فعلیه",
    "start": 72,
    "end": 73,
    "new_title": "قواعد: جمله اسمیه و فعلیه"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۵",
    "position": 3,
    "title": "گفت‌وگو: مع سائق سیارة الأجرة",
    "start": 74,
    "end": 74,
    "new_title": "گفت‌وگو: مع سائق سیارة الأجرة"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۵",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 75,
    "end": 79,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 1,
    "title": "متن و واژگان: المعالم الخلابة",
    "start": 82,
    "end": 84,
    "new_title": "متن و واژگان: المعالم الخلابة"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 2,
    "title": "قواعد: اعراب اجزای جمله اسمیه و فعلیه",
    "start": 85,
    "end": 88,
    "new_title": "قواعد: اعراب اجزای جمله اسمیه و فعلیه"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 3,
    "title": "گفت‌وگو: فی الصیدلیة",
    "start": 89,
    "end": 89,
    "new_title": "گفت‌وگو: فی الصیدلیة"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۶",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 90,
    "end": 92,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۷",
    "position": 1,
    "title": "متن و واژگان: صناعة النفط",
    "start": 94,
    "end": 96,
    "new_title": "متن و واژگان: صناعة النفط"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۷",
    "position": 2,
    "title": "قواعد: فعل معلوم و مجهول",
    "start": 97,
    "end": 99,
    "new_title": "قواعد: فعل معلوم و مجهول"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۷",
    "position": 3,
    "title": "گفت‌وگو: مع مسؤول استقبال الفندق",
    "start": 100,
    "end": 100,
    "new_title": "گفت‌وگو: مع مسؤول استقبال الفندق"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۷",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 101,
    "end": 103,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 1,
    "title": "متن و واژگان: یا من فی البحار عجائبه",
    "start": 106,
    "end": 108,
    "new_title": "متن و واژگان: یا من فی البحار عجائبه"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 2,
    "title": "قواعد: جار و مجرور و نون وقایه",
    "start": 109,
    "end": 113,
    "new_title": "قواعد: جار و مجرور و نون وقایه"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 3,
    "title": "گفت‌وگو: مع مشرف خدمات الفندق",
    "start": 114,
    "end": 114,
    "new_title": "گفت‌وگو: مع مشرف خدمات الفندق"
  },
  {
    "subject": "عربی ۱ تخصصی",
    "chapter": "درس ۸",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 115,
    "end": 118,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 1,
    "title": "متن و واژگان: ذاک هو الله",
    "start": 2,
    "end": 3,
    "new_title": "متن و واژگان: ذاک هو الله"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 2,
    "title": "قواعد: افعال، ضمایر و اسم اشاره",
    "start": 5,
    "end": 9,
    "new_title": "قواعد: افعال، ضمایر و اسم اشاره"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 3,
    "title": "گفت‌وگو: التعارف",
    "start": 4,
    "end": 4,
    "new_title": "گفت‌وگو: التعارف"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۱",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 10,
    "end": 12,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۲",
    "position": 1,
    "title": "متن و واژگان: المواعظ العددیة",
    "start": 16,
    "end": 18,
    "new_title": "متن و واژگان: المواعظ العددیة"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۲",
    "position": 2,
    "title": "قواعد: اعداد از یک تا صد",
    "start": 19,
    "end": 20,
    "new_title": "قواعد: اعداد از یک تا صد"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۲",
    "position": 3,
    "title": "گفت‌وگو: فی مطار النجف",
    "start": 21,
    "end": 21,
    "new_title": "گفت‌وگو: گردشگر ایرانی"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۲",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 22,
    "end": 26,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 1,
    "title": "متن و واژگان: مطر السمک",
    "start": 28,
    "end": 31,
    "new_title": "متن و واژگان: مطر السمک"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 2,
    "title": "قواعد: اشکال افعال ۱",
    "start": 32,
    "end": 38,
    "new_title": "قواعد: اشکال افعال ۱"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 3,
    "title": "گفت‌وگو: فی قسم الجوازات",
    "start": 39,
    "end": 39,
    "new_title": "گفت‌وگو: فی قسم الجوازات"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۳",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 40,
    "end": 43,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 1,
    "title": "متن و واژگان: التعایش السلمی",
    "start": 46,
    "end": 49,
    "new_title": "متن و واژگان: التعایش السلمی"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 2,
    "title": "قواعد: اشکال افعال ۲",
    "start": 50,
    "end": 54,
    "new_title": "قواعد: اشکال افعال ۲"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 3,
    "title": "گفت‌وگو: فی صالة التفتیش",
    "start": 51,
    "end": 51,
    "new_title": "گفت‌وگو: فی صالة التفتیش"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۴",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 55,
    "end": 59,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۵",
    "position": 1,
    "title": "متن و واژگان: هذا خلق الله",
    "start": 62,
    "end": 66,
    "new_title": "متن و واژگان: هذا خلق الله"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۵",
    "position": 2,
    "title": "قواعد: جمله فعلیه و اسمیه",
    "start": 67,
    "end": 68,
    "new_title": "قواعد: جمله فعلیه و اسمیه"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۵",
    "position": 3,
    "title": "گفت‌وگو: مع سائق سیارة الأجرة",
    "start": 69,
    "end": 69,
    "new_title": "گفت‌وگو: مع سائق سیارة الأجرة"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۵",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 70,
    "end": 75,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۶",
    "position": 1,
    "title": "متن و واژگان: ذوالقرنین",
    "start": 78,
    "end": 80,
    "new_title": "متن و واژگان: ذوالقرنین"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۶",
    "position": 2,
    "title": "قواعد: فعل مجهول",
    "start": 81,
    "end": 82,
    "new_title": "قواعد: فعل مجهول"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۶",
    "position": 3,
    "title": "گفت‌وگو: مع مسؤول استقبال الفندق",
    "start": 83,
    "end": 83,
    "new_title": "گفت‌وگو: مع مسؤول استقبال الفندق"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۶",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 84,
    "end": 87,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 1,
    "title": "متن و واژگان: یا من فی البحار عجائبه",
    "start": 90,
    "end": 92,
    "new_title": "متن و واژگان: یا من فی البحار عجائبه"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 2,
    "title": "قواعد: جار و مجرور و نون وقایه",
    "start": 93,
    "end": 96,
    "new_title": "قواعد: جار و مجرور و نون وقایه"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 3,
    "title": "گفت‌وگو: مع مشرف خدمات الفندق",
    "start": 97,
    "end": 97,
    "new_title": "گفت‌وگو: مع مشرف خدمات الفندق"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۷",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 98,
    "end": 103,
    "new_title": "تمرین‌های درس"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 1,
    "title": "متن و واژگان: صناعة التلمیع فی الأدب الفارسی",
    "start": 106,
    "end": 108,
    "new_title": "متن و واژگان: صناعة التلمیع فی الأدب الفارسی"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 2,
    "title": "قواعد: اسم فاعل، اسم مفعول و اسم مبالغه",
    "start": 109,
    "end": 111,
    "new_title": "قواعد: اسم فاعل، اسم مفعول و اسم مبالغه"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 3,
    "title": "گفت‌وگو: شراء شریحة الهاتف الجوال",
    "start": 112,
    "end": 112,
    "new_title": "گفت‌وگو: شراء شریحة الهاتف الجوال"
  },
  {
    "subject": "عربی زبان قرآن ۱",
    "chapter": "درس ۸",
    "position": 4,
    "title": "تمرین‌های درس",
    "start": 113,
    "end": 117,
    "new_title": "تمرین‌های درس"
  }
]$fixes$::jsonb) as p(subject text,chapter text,position integer,title text,new_title text,start integer,"end" integer)),
contexts(subject,field,track) as (values ('عربی ۱ تخصصی','humanities','konkur'),('عربی ۱ تخصصی','humanities','final_exam'),('عربی زبان قرآن ۱','mathematics','final_exam'),('عربی زبان قرآن ۱','experimental_sciences','final_exam'))
update private.planner_topic_bank t set title=p.new_title,page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p join contexts c on c.subject=p.subject
where t.id=md5('nova:planner:1405:v1:'||c.field||':10:'||c.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field=c.field and t.grade='10' and t.preparation_track=c.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
