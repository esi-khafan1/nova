-- Humanities literary studies 10/11/12 from the user PDFs (1405).
with installed as (insert into private.planner_seed_installations(seed_key) values ('literary-studies-1405-v200') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۱",
  "position": 400,
  "title": "کل فصل",
  "start": 11,
  "end": 36
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۱",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 31,
  "end": 36
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۱",
  "position": 450,
  "title": "شرح: مبانی تحلیل متن",
  "start": 12,
  "end": 18
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۱",
  "position": 451,
  "title": "خودارزیابی مبانی تحلیل متن",
  "start": 19,
  "end": 20
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۱",
  "position": 452,
  "title": "سازه‌ها و عوامل مؤثر در شعر",
  "start": 21,
  "end": 22
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۱",
  "position": 453,
  "title": "خودارزیابی سازه‌های شعر",
  "start": 23,
  "end": 25
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۱",
  "position": 454,
  "title": "واج‌آرایی و واژه‌آرایی",
  "start": 26,
  "end": 27
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۱",
  "position": 455,
  "title": "خودارزیابی واج‌آرایی و واژه‌آرایی",
  "start": 28,
  "end": 30
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 400,
  "title": "کل فصل",
  "start": 37,
  "end": 58
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 56,
  "end": 58
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 450,
  "title": "ادبیات پیش از اسلام",
  "start": 38,
  "end": 40
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 451,
  "title": "سه قرن اول هجری و قرن چهارم",
  "start": 41,
  "end": 42
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 452,
  "title": "شعر و نثر",
  "start": 43,
  "end": 44
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 453,
  "title": "خودارزیابی تاریخ ادبیات",
  "start": 45,
  "end": 46
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 454,
  "title": "شرح: هماهنگی پاره‌های کلام",
  "start": 47,
  "end": 49
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 455,
  "title": "خودارزیابی هماهنگی کلام",
  "start": 50,
  "end": 51
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 456,
  "title": "شرح: سجع و انواع آن",
  "start": 52,
  "end": 53
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 457,
  "title": "خودارزیابی سجع",
  "start": 54,
  "end": 55
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 400,
  "title": "کل فصل",
  "start": 59,
  "end": 78
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 77,
  "end": 78
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 450,
  "title": "سبک و سبک‌شناسی",
  "start": 60,
  "end": 61
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 451,
  "title": "سبک خراسانی و ویژگی‌های شعر",
  "start": 62,
  "end": 63
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 452,
  "title": "نثر دوره اول",
  "start": 64,
  "end": 64
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 453,
  "title": "خودارزیابی سبک خراسانی",
  "start": 65,
  "end": 66
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 454,
  "title": "شرح: وزن شعر فارسی",
  "start": 67,
  "end": 67
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 455,
  "title": "خط عروضی",
  "start": 68,
  "end": 70
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 456,
  "title": "خودارزیابی وزن شعر",
  "start": 71,
  "end": 72
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 457,
  "title": "شرح: موازنه و ترصیع",
  "start": 73,
  "end": 74
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 458,
  "title": "خودارزیابی موازنه و ترصیع",
  "start": 75,
  "end": 76
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 400,
  "title": "کل فصل",
  "start": 79,
  "end": 106
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 102,
  "end": 106
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 450,
  "title": "شعر فارسی سده پنجم و ششم",
  "start": 80,
  "end": 81
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 451,
  "title": "نثر فارسی سده پنجم و ششم",
  "start": 82,
  "end": 85
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 452,
  "title": "خودارزیابی تاریخ ادبیات",
  "start": 86,
  "end": 87
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 453,
  "title": "شرح: قافیه",
  "start": 88,
  "end": 88
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 454,
  "title": "قافیه و ردیف",
  "start": 89,
  "end": 89
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 455,
  "title": "قواعد قافیه",
  "start": 90,
  "end": 91
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 456,
  "title": "قافیه در شعر نو",
  "start": 92,
  "end": 92
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 457,
  "title": "خودارزیابی قافیه",
  "start": 93,
  "end": 96
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 458,
  "title": "شرح: جناس و انواع آن",
  "start": 97,
  "end": 99
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 459,
  "title": "خودارزیابی جناس",
  "start": 100,
  "end": 101
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 400,
  "title": "کل فصل",
  "start": 11,
  "end": 34
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 34,
  "end": 34
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 450,
  "title": "ادبیات قرن هفتم",
  "start": 12,
  "end": 15
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 451,
  "title": "ادبیات قرن هشتم",
  "start": 16,
  "end": 17
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 452,
  "title": "ادبیات قرن نهم",
  "start": 18,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 453,
  "title": "خودارزیابی تاریخ ادبیات",
  "start": 19,
  "end": 19
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 454,
  "title": "شرح: پایه‌های آوایی",
  "start": 20,
  "end": 22
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 455,
  "title": "خودارزیابی پایه‌های آوایی",
  "start": 23,
  "end": 25
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 456,
  "title": "شرح: تشبیه",
  "start": 26,
  "end": 27
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 457,
  "title": "انواع تشبیه از نظر پایه‌ها",
  "start": 28,
  "end": 30
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 458,
  "title": "خودارزیابی تشبیه",
  "start": 31,
  "end": 33
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 400,
  "title": "کل فصل",
  "start": 35,
  "end": 56
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 55,
  "end": 56
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 450,
  "title": "ویژگی‌های شعر سبک عراقی",
  "start": 36,
  "end": 37
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 451,
  "title": "ویژگی‌های نثر سبک عراقی",
  "start": 38,
  "end": 39
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 452,
  "title": "خودارزیابی سبک عراقی",
  "start": 40,
  "end": 41
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 453,
  "title": "پایه‌های آوایی همسان",
  "start": 42,
  "end": 45
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 454,
  "title": "خودارزیابی پایه‌های همسان",
  "start": 46,
  "end": 50
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 455,
  "title": "شرح: مجاز",
  "start": 51,
  "end": 52
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 456,
  "title": "خودارزیابی مجاز",
  "start": 53,
  "end": 54
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 400,
  "title": "کل فصل",
  "start": 57,
  "end": 78
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 77,
  "end": 78
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 450,
  "title": "ادبیات قرن دهم",
  "start": 58,
  "end": 59
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 451,
  "title": "ادبیات قرن یازدهم",
  "start": 60,
  "end": 60
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 452,
  "title": "خودارزیابی تاریخ ادبیات",
  "start": 61,
  "end": 62
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 453,
  "title": "شرح: پایه‌های آوایی همسان ۲",
  "start": 63,
  "end": 66
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 454,
  "title": "خودارزیابی پایه‌های آوایی",
  "start": 67,
  "end": 70
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 455,
  "title": "شرح: استعاره",
  "start": 71,
  "end": 74
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 456,
  "title": "خودارزیابی استعاره",
  "start": 75,
  "end": 76
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 400,
  "title": "کل فصل",
  "start": 79,
  "end": 107
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 100,
  "end": 107
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 450,
  "title": "شعر سبک هندی",
  "start": 80,
  "end": 80
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 451,
  "title": "ویژگی‌های شعر سبک هندی",
  "start": 81,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 452,
  "title": "نثر سبک هندی",
  "start": 83,
  "end": 85
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 453,
  "title": "خودارزیابی سبک هندی",
  "start": 86,
  "end": 87
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 454,
  "title": "پایه‌های آوایی همسان دو لختی",
  "start": 88,
  "end": 91
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 455,
  "title": "خودارزیابی پایه‌های دو لختی",
  "start": 92,
  "end": 94
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 456,
  "title": "شرح: کنایه",
  "start": 95,
  "end": 95
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 457,
  "title": "تفاوت کنایه و مجاز",
  "start": 96,
  "end": 96
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 458,
  "title": "تفاوت استعاره و کنایه و خودارزیابی",
  "start": 97,
  "end": 99
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 400,
  "title": "کل فصل",
  "start": 11,
  "end": 40
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 38,
  "end": 40
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 450,
  "title": "دوره بازگشت ادبی",
  "start": 12,
  "end": 12
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 451,
  "title": "شاعران دوره بازگشت",
  "start": 13,
  "end": 14
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 452,
  "title": "زبان و شعر دوره بیداری",
  "start": 15,
  "end": 15
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 453,
  "title": "شاعران دوره بیداری",
  "start": 16,
  "end": 17
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 454,
  "title": "نثر فارسی دوره بیداری",
  "start": 18,
  "end": 19
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 455,
  "title": "نویسندگان دوره بیداری",
  "start": 20,
  "end": 20
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 456,
  "title": "خودارزیابی تاریخ ادبیات",
  "start": 21,
  "end": 21
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 457,
  "title": "شرح: پایه‌های آوایی ناهمسان",
  "start": 22,
  "end": 25
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 458,
  "title": "خودارزیابی پایه‌های آوایی",
  "start": 26,
  "end": 28
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 459,
  "title": "مراعات نظیر",
  "start": 29,
  "end": 30
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 460,
  "title": "تلمیح",
  "start": 31,
  "end": 32
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 461,
  "title": "تضمین",
  "start": 33,
  "end": 33
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 462,
  "title": "خودارزیابی آرایه‌ها",
  "start": 34,
  "end": 37
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 400,
  "title": "کل فصل",
  "start": 41,
  "end": 66
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 64,
  "end": 66
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 450,
  "title": "سبک شعر دوره بیداری",
  "start": 42,
  "end": 44
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 451,
  "title": "سبک نثر دوره بیداری",
  "start": 45,
  "end": 45
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 452,
  "title": "خودارزیابی سبک",
  "start": 46,
  "end": 47
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 453,
  "title": "اختیارات زبانی",
  "start": 48,
  "end": 53
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 454,
  "title": "خودارزیابی اختیارات زبانی",
  "start": 54,
  "end": 56
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 455,
  "title": "لف و نشر",
  "start": 57,
  "end": 58
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 456,
  "title": "تضاد",
  "start": 59,
  "end": 59
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 457,
  "title": "متناقض‌نما",
  "start": 60,
  "end": 60
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 458,
  "title": "تفاوت متناقض‌نما و تضاد",
  "start": 61,
  "end": 61
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 459,
  "title": "خودارزیابی آرایه‌ها",
  "start": 62,
  "end": 63
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 400,
  "title": "کل فصل",
  "start": 67,
  "end": 94
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 93,
  "end": 94
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 450,
  "title": "دوره معاصر تا انقلاب اسلامی",
  "start": 68,
  "end": 69
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 451,
  "title": "شاعران معاصر",
  "start": 70,
  "end": 73
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 452,
  "title": "نویسندگان معاصر",
  "start": 74,
  "end": 74
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 453,
  "title": "دوره انقلاب اسلامی",
  "start": 75,
  "end": 79
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 454,
  "title": "خودارزیابی تاریخ ادبیات",
  "start": 80,
  "end": 82
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 455,
  "title": "اختیارات وزنی",
  "start": 83,
  "end": 85
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 456,
  "title": "خودارزیابی اختیارات وزنی",
  "start": 86,
  "end": 87
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 457,
  "title": "اغراق",
  "start": 88,
  "end": 88
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 458,
  "title": "ایهام",
  "start": 89,
  "end": 89
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 459,
  "title": "ایهام تناسب",
  "start": 90,
  "end": 91
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 460,
  "title": "خودارزیابی آرایه‌ها",
  "start": 92,
  "end": 92
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 400,
  "title": "کل فصل",
  "start": 95,
  "end": 121
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 401,
  "title": "کارگاه تحلیل فصل",
  "start": 118,
  "end": 121
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 450,
  "title": "سبک‌شناسی ادبیات معاصر",
  "start": 96,
  "end": 98
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 451,
  "title": "سبک‌شناسی دوره انقلاب اسلامی",
  "start": 99,
  "end": 102
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 452,
  "title": "خودارزیابی سبک‌شناسی",
  "start": 103,
  "end": 103
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 453,
  "title": "شرح: وزن در شعر نیمایی",
  "start": 104,
  "end": 106
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 454,
  "title": "نام‌گذاری وزن‌ها",
  "start": 107,
  "end": 108
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 455,
  "title": "خودارزیابی وزن شعر نیمایی",
  "start": 109,
  "end": 111
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 456,
  "title": "حسن تعلیل",
  "start": 112,
  "end": 112
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 457,
  "title": "حس‌آمیزی",
  "start": 113,
  "end": 113
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 458,
  "title": "اسلوب معادله",
  "start": 114,
  "end": 115
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 459,
  "title": "خودارزیابی آرایه‌ها",
  "start": 116,
  "end": 117
 }
]$topics$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v200:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405','humanities',p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۱",
  "position": 1,
  "title": "مبانی تحلیل متن",
  "new_title": "مبانی تحلیل متن",
  "start": 12,
  "end": 20
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۱",
  "position": 2,
  "title": "سازه‌ها و عوامل تأثیرگذار در شعر فارسی",
  "new_title": "سازه‌ها و عوامل تأثیرگذار در شعر فارسی",
  "start": 21,
  "end": 25
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۱",
  "position": 3,
  "title": "واج‌آرایی، واژه‌آرایی",
  "new_title": "واج‌آرایی، واژه‌آرایی",
  "start": 26,
  "end": 30
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 1,
  "title": "تاریخ ادبیات پیش از اسلام و قرن‌های اولیه هجری",
  "new_title": "تاریخ ادبیات پیش از اسلام و قرن‌های اولیه هجری",
  "start": 38,
  "end": 46
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 2,
  "title": "هماهنگی پاره‌های کلام",
  "new_title": "هماهنگی پاره‌های کلام",
  "start": 47,
  "end": 51
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۲",
  "position": 3,
  "title": "سجع و انواع آن",
  "new_title": "سجع و انواع آن",
  "start": 52,
  "end": 55
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 1,
  "title": "سبک و سبک‌شناسی (سبک خراسانی)",
  "new_title": "سبک و سبک‌شناسی (سبک خراسانی)",
  "start": 60,
  "end": 66
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 2,
  "title": "وزن شعر فارسی",
  "new_title": "وزن شعر فارسی",
  "start": 67,
  "end": 72
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۳",
  "position": 3,
  "title": "موازنه و ترصیع",
  "new_title": "موازنه و ترصیع",
  "start": 73,
  "end": 76
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 1,
  "title": "زبان و ادبیات فارسی در سده‌های پنجم و ششم و ویژگی‌های سبکی آن",
  "new_title": "زبان و ادبیات فارسی در سده‌های پنجم و ششم و ویژگی‌های سبکی آن",
  "start": 80,
  "end": 87
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 2,
  "title": "قافیه",
  "new_title": "قافیه",
  "start": 88,
  "end": 96
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "chapter": "فصل ۴",
  "position": 3,
  "title": "جناس و انواع آن",
  "new_title": "جناس و انواع آن",
  "start": 97,
  "end": 101
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 1,
  "title": "تاریخ ادبیات فارسی در قرن‌های هفتم، هشتم و نهم",
  "new_title": "تاریخ ادبیات فارسی در قرن‌های هفتم، هشتم و نهم",
  "start": 12,
  "end": 19
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 2,
  "title": "پایه‌های آوایی",
  "new_title": "پایه‌های آوایی",
  "start": 20,
  "end": 25
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۱",
  "position": 3,
  "title": "تشبیه",
  "new_title": "تشبیه",
  "start": 26,
  "end": 33
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 1,
  "title": "سبک‌شناسی قرن‌های هفتم، هشتم و نهم (سبک عراقی)",
  "new_title": "سبک‌شناسی قرن‌های هفتم، هشتم و نهم (سبک عراقی)",
  "start": 36,
  "end": 41
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 2,
  "title": "پایه‌های آوایی همسان ۱",
  "new_title": "پایه‌های آوایی همسان ۱",
  "start": 42,
  "end": 50
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۲",
  "position": 3,
  "title": "مجاز",
  "new_title": "مجاز",
  "start": 51,
  "end": 54
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 1,
  "title": "تاریخ ادبیات فارسی در قرن‌های دهم و یازدهم",
  "new_title": "تاریخ ادبیات فارسی در قرن‌های دهم و یازدهم",
  "start": 58,
  "end": 62
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 2,
  "title": "پایه‌های آوایی همسان ۲",
  "new_title": "پایه‌های آوایی همسان ۲",
  "start": 63,
  "end": 70
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۳",
  "position": 3,
  "title": "استعاره",
  "new_title": "استعاره",
  "start": 71,
  "end": 76
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 1,
  "title": "سبک‌شناسی قرن‌های دهم و یازدهم (سبک هندی)",
  "new_title": "سبک‌شناسی قرن‌های دهم و یازدهم (سبک هندی)",
  "start": 80,
  "end": 87
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 2,
  "title": "پایه‌های آوایی همسان دولختی",
  "new_title": "پایه‌های آوایی همسان دولختی",
  "start": 88,
  "end": 94
 },
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "chapter": "فصل ۴",
  "position": 3,
  "title": "کنایه",
  "new_title": "کنایه",
  "start": 95,
  "end": 99
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 1,
  "title": "تاریخ ادبیات قرن‌های دوازدهم و سیزدهم (دوره بازگشت و بیداری)",
  "new_title": "تاریخ ادبیات قرن‌های دوازدهم و سیزدهم (دوره بازگشت و بیداری)",
  "start": 12,
  "end": 21
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 2,
  "title": "پایه‌های آوایی ناهمسان",
  "new_title": "پایه‌های آوایی ناهمسان",
  "start": 22,
  "end": 28
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۱",
  "position": 3,
  "title": "مراعات نظیر، تلمیح و تضمین",
  "new_title": "مراعات نظیر، تلمیح و تضمین",
  "start": 29,
  "end": 37
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 1,
  "title": "سبک‌شناسی قرن‌های دوازدهم و سیزدهم (دوره بازگشت و بیداری)",
  "new_title": "سبک‌شناسی قرن‌های دوازدهم و سیزدهم (دوره بازگشت و بیداری)",
  "start": 42,
  "end": 47
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 2,
  "title": "اختیارات شاعری ۱: زبانی",
  "new_title": "اختیارات شاعری ۱: زبانی",
  "start": 48,
  "end": 56
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۲",
  "position": 3,
  "title": "لف و نشر، تضاد و متناقض‌نما",
  "new_title": "لف و نشر، تضاد و متناقض‌نما",
  "start": 57,
  "end": 63
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 1,
  "title": "تاریخ ادبیات قرن چهاردهم (دوره معاصر و انقلاب اسلامی)",
  "new_title": "تاریخ ادبیات قرن چهاردهم (دوره معاصر و انقلاب اسلامی)",
  "start": 68,
  "end": 82
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 2,
  "title": "اختیارات شاعری ۲: وزنی",
  "new_title": "اختیارات شاعری ۲: وزنی",
  "start": 83,
  "end": 87
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۳",
  "position": 3,
  "title": "اغراق، ایهام و ایهام تناسب",
  "new_title": "اغراق، ایهام و ایهام تناسب",
  "start": 88,
  "end": 92
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 1,
  "title": "سبک‌شناسی دوره معاصر و انقلاب اسلامی",
  "new_title": "سبک‌شناسی دوره معاصر و انقلاب اسلامی",
  "start": 96,
  "end": 103
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 2,
  "title": "وزن در شعر نیمایی",
  "new_title": "وزن در شعر نیمایی",
  "start": 104,
  "end": 111
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "chapter": "فصل ۴",
  "position": 3,
  "title": "حسن تعلیل، حس‌آمیزی و اسلوب معادله",
  "new_title": "حسن تعلیل، حس‌آمیزی و اسلوب معادله",
  "start": 112,
  "end": 117
 }
]$fixes$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,new_title text,start integer,"end" integer)),tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set title=p.new_title,revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field='humanities' and t.grade=p.grade and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.title<>p.new_title and t.page_start=p.start and t.page_end=p."end" and t.revision=1;
