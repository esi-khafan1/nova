-- Mathematics 9 (905), printed 1405, user-supplied book; see source notes.
with installed as (insert into private.planner_seed_installations(seed_key) values ('math9-1405-v202') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 400,
  "title": "کل فصل",
  "start": 1,
  "end": 17
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 450,
  "title": "اعضای مجموعه و نمایش مجموعه",
  "start": 2,
  "end": 2
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 451,
  "title": "مجموعه تهی و عضویت",
  "start": 3,
  "end": 5
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 452,
  "title": "مجموعه‌های برابر",
  "start": 6,
  "end": 6
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 453,
  "title": "زیرمجموعه",
  "start": 7,
  "end": 8
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 454,
  "title": "نمایش مجموعه با نمادهای ریاضی",
  "start": 9,
  "end": 10
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 455,
  "title": "اجتماع و اشتراک مجموعه‌ها",
  "start": 11,
  "end": 12
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 456,
  "title": "تفاضل مجموعه‌ها",
  "start": 13,
  "end": 14
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 457,
  "title": "شرح: مجموعه‌ها و احتمال",
  "start": 15,
  "end": 17
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 700,
  "title": "فعالیت صفحه 2",
  "start": 2,
  "end": 2
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 701,
  "title": "فعالیت صفحه 3",
  "start": 3,
  "end": 3
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 702,
  "title": "کار در کالس صفحه 4",
  "start": 4,
  "end": 4
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 703,
  "title": "تمرین صفحه 5",
  "start": 5,
  "end": 5
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 704,
  "title": "فعالیت صفحه 6",
  "start": 6,
  "end": 6
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 705,
  "title": "کار در کالس صفحه 6",
  "start": 6,
  "end": 6
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 706,
  "title": "فعالیت صفحه 7",
  "start": 7,
  "end": 7
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 707,
  "title": "کار در کالس صفحه 8",
  "start": 8,
  "end": 8
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 708,
  "title": "تمرین صفحه 10",
  "start": 10,
  "end": 10
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 709,
  "title": "کار در کالس صفحه 10",
  "start": 10,
  "end": 10
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 710,
  "title": "فعالیت صفحه 11",
  "start": 11,
  "end": 11
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 711,
  "title": "فعالیت صفحه 12",
  "start": 12,
  "end": 12
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 712,
  "title": "کار در کالس صفحه 13",
  "start": 13,
  "end": 13
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 713,
  "title": "تمرین صفحه 14",
  "start": 14,
  "end": 14
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 714,
  "title": "فعالیت صفحه 16",
  "start": 16,
  "end": 16
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 715,
  "title": "کار در کالس صفحه 16",
  "start": 16,
  "end": 16
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 716,
  "title": "تمرین صفحه 17",
  "start": 17,
  "end": 17
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 717,
  "title": "خواندنی صفحه 17",
  "start": 17,
  "end": 17
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 400,
  "title": "کل فصل",
  "start": 18,
  "end": 31
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 450,
  "title": "نمایش عددهای گویا",
  "start": 19,
  "end": 19
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 451,
  "title": "عددهای گویا بین دو کسر",
  "start": 20,
  "end": 20
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 452,
  "title": "نمایش عددهای گویا روی محور",
  "start": 21,
  "end": 21
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 453,
  "title": "نمایش اعشاری عددهای گویا",
  "start": 22,
  "end": 22
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 454,
  "title": "عددهای گنگ و حقیقی",
  "start": 23,
  "end": 24
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 455,
  "title": "تقریب ریشه روی محور",
  "start": 25,
  "end": 27
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 456,
  "title": "قدر مطلق",
  "start": 28,
  "end": 28
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 457,
  "title": "محاسبه تقریبی",
  "start": 29,
  "end": 30
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 458,
  "title": "محاسبه با قدر مطلق",
  "start": 31,
  "end": 31
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 700,
  "title": "فعالیت صفحه 19",
  "start": 19,
  "end": 19
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 701,
  "title": "فعالیت صفحه 20",
  "start": 20,
  "end": 20
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 702,
  "title": "کار در کالس صفحه 20",
  "start": 20,
  "end": 20
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 703,
  "title": "تمرین صفحه 22",
  "start": 22,
  "end": 22
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 704,
  "title": "کار در کالس صفحه 22",
  "start": 22,
  "end": 22
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 705,
  "title": "فعالیت صفحه 23",
  "start": 23,
  "end": 23
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 706,
  "title": "فعالیت صفحه 24",
  "start": 24,
  "end": 24
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 707,
  "title": "کار در کالس صفحه 24",
  "start": 24,
  "end": 24
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 708,
  "title": "کار در کالس صفحه 25",
  "start": 25,
  "end": 25
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 709,
  "title": "فعالیت صفحه 26",
  "start": 26,
  "end": 26
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 710,
  "title": "کار در کالس صفحه 26",
  "start": 26,
  "end": 26
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 711,
  "title": "تمرین صفحه 27",
  "start": 27,
  "end": 27
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 712,
  "title": "فعالیت صفحه 28",
  "start": 28,
  "end": 28
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 713,
  "title": "فعالیت صفحه 29",
  "start": 29,
  "end": 29
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 714,
  "title": "کار در کالس صفحه 29",
  "start": 29,
  "end": 29
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 715,
  "title": "فعالیت صفحه 30",
  "start": 30,
  "end": 30
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 716,
  "title": "تمرین صفحه 31",
  "start": 31,
  "end": 31
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 717,
  "title": "کار در کالس صفحه 31",
  "start": 31,
  "end": 31
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 400,
  "title": "کل فصل",
  "start": 32,
  "end": 58
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 450,
  "title": "استدلال و نتیجه‌گیری",
  "start": 33,
  "end": 34
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 451,
  "title": "مثال نقض",
  "start": 35,
  "end": 36
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 452,
  "title": "فرض و حکم در اثبات هندسی",
  "start": 37,
  "end": 40
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 453,
  "title": "استدلال درباره زاویه‌های مثلث",
  "start": 41,
  "end": 41
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 454,
  "title": "اثبات زاویه‌های متقابل به رأس",
  "start": 42,
  "end": 43
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 455,
  "title": "حالت‌های هم‌نهشتی مثلث‌ها",
  "start": 44,
  "end": 48
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 456,
  "title": "مراحل حل مسئله در هندسه",
  "start": 49,
  "end": 52
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 457,
  "title": "شرح: شکل‌های متشابه",
  "start": 53,
  "end": 53
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 458,
  "title": "نسبت تشابه",
  "start": 54,
  "end": 56
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 459,
  "title": "تشابه در صفحه مختصات",
  "start": 57,
  "end": 58
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 700,
  "title": "فعالیت صفحه 33",
  "start": 33,
  "end": 33
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 701,
  "title": "کار در کالس صفحه 33",
  "start": 33,
  "end": 33
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 702,
  "title": "فعالیت صفحه 34",
  "start": 34,
  "end": 34
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 703,
  "title": "کار در کالس صفحه 34",
  "start": 34,
  "end": 34
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 704,
  "title": "تمرین صفحه 35",
  "start": 35,
  "end": 35
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 705,
  "title": "فعالیت صفحه 37",
  "start": 37,
  "end": 37
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 706,
  "title": "کار در کالس صفحه 38",
  "start": 38,
  "end": 38
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 707,
  "title": "فعالیت صفحه 39",
  "start": 39,
  "end": 39
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 708,
  "title": "کار در کالس صفحه 40",
  "start": 40,
  "end": 40
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 709,
  "title": "فعالیت صفحه 41",
  "start": 41,
  "end": 41
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 710,
  "title": "تمرین صفحه 42",
  "start": 42,
  "end": 42
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 711,
  "title": "فعالیت صفحه 44",
  "start": 44,
  "end": 44
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 712,
  "title": "فعالیت صفحه 45",
  "start": 45,
  "end": 45
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 713,
  "title": "فعالیت صفحه 46",
  "start": 46,
  "end": 46
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 714,
  "title": "کار در کالس صفحه 46",
  "start": 46,
  "end": 46
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 715,
  "title": "تمرین صفحه 48",
  "start": 48,
  "end": 48
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 716,
  "title": "فعالیت صفحه 50",
  "start": 50,
  "end": 50
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 717,
  "title": "تمرین صفحه 51",
  "start": 51,
  "end": 51
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 718,
  "title": "کار در کالس صفحه 51",
  "start": 51,
  "end": 51
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 719,
  "title": "فعالیت صفحه 54",
  "start": 54,
  "end": 54
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 720,
  "title": "کار در کالس صفحه 55",
  "start": 55,
  "end": 55
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 721,
  "title": "فعالیت صفحه 56",
  "start": 56,
  "end": 56
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 722,
  "title": "کار در کالس صفحه 56",
  "start": 56,
  "end": 56
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 723,
  "title": "تمرین صفحه 57",
  "start": 57,
  "end": 57
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 400,
  "title": "کل فصل",
  "start": 59,
  "end": 77
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 450,
  "title": "توان صحیح و توان منفی",
  "start": 60,
  "end": 61
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 451,
  "title": "قوانین توان‌های صحیح",
  "start": 62,
  "end": 64
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 452,
  "title": "ضرب و تقسیم در توان‌های ده",
  "start": 65,
  "end": 65
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 453,
  "title": "شرح: نماد علمی",
  "start": 66,
  "end": 67
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 454,
  "title": "ریشه دوم",
  "start": 68,
  "end": 68
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 455,
  "title": "ریشه سوم",
  "start": 69,
  "end": 69
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 456,
  "title": "ضرب و تقسیم رادیکال‌ها",
  "start": 70,
  "end": 72
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 457,
  "title": "شرح: جمع و تفریق رادیکال‌ها",
  "start": 73,
  "end": 73
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 458,
  "title": "ساده کردن عبارت‌های رادیکالی",
  "start": 74,
  "end": 75
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 459,
  "title": "گویا کردن مخرج",
  "start": 76,
  "end": 77
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 700,
  "title": "فعالیت صفحه 60",
  "start": 60,
  "end": 60
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 701,
  "title": "کار در کالس صفحه 61",
  "start": 61,
  "end": 61
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 702,
  "title": "فعالیت صفحه 62",
  "start": 62,
  "end": 62
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 703,
  "title": "کار در کالس صفحه 62",
  "start": 62,
  "end": 62
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 704,
  "title": "تمرین صفحه 63",
  "start": 63,
  "end": 63
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 705,
  "title": "کار در کالس صفحه 63",
  "start": 63,
  "end": 63
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 706,
  "title": "فعالیت صفحه 65",
  "start": 65,
  "end": 65
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 707,
  "title": "کار در کالس صفحه 66",
  "start": 66,
  "end": 66
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 708,
  "title": "تمرین صفحه 67",
  "start": 67,
  "end": 67
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 709,
  "title": "فعالیت صفحه 68",
  "start": 68,
  "end": 68
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 710,
  "title": "کار در کالس صفحه 69",
  "start": 69,
  "end": 69
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 711,
  "title": "فعالیت صفحه 70",
  "start": 70,
  "end": 70
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 712,
  "title": "کار در کالس صفحه 70",
  "start": 70,
  "end": 70
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 713,
  "title": "تمرین صفحه 71",
  "start": 71,
  "end": 71
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 714,
  "title": "فعالیت صفحه 73",
  "start": 73,
  "end": 73
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 715,
  "title": "کار در کالس صفحه 73",
  "start": 73,
  "end": 73
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 716,
  "title": "فعالیت صفحه 74",
  "start": 74,
  "end": 74
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 717,
  "title": "فعالیت صفحه 75",
  "start": 75,
  "end": 75
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 718,
  "title": "کار در کالس صفحه 75",
  "start": 75,
  "end": 75
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 719,
  "title": "تمرین صفحه 76",
  "start": 76,
  "end": 76
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 720,
  "title": "کار در کالس صفحه 76",
  "start": 76,
  "end": 76
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 721,
  "title": "خواندنی صفحه 77",
  "start": 77,
  "end": 77
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 400,
  "title": "کل فصل",
  "start": 78,
  "end": 94
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 450,
  "title": "تک‌جمله‌ای و درجه آن",
  "start": 79,
  "end": 79
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 451,
  "title": "عبارت‌های جبری و چندجمله‌ای",
  "start": 80,
  "end": 81
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 452,
  "title": "اتحاد مربع دو جمله",
  "start": 82,
  "end": 82
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 453,
  "title": "خاصیت توزیعی و اتحاد",
  "start": 83,
  "end": 83
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 454,
  "title": "تجزیه با اتحاد مربع دو جمله",
  "start": 84,
  "end": 85
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 455,
  "title": "اتحاد مربع سه جمله",
  "start": 86,
  "end": 86
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 456,
  "title": "اتحاد مزدوج",
  "start": 87,
  "end": 87
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 457,
  "title": "اتحاد جمله مشترک و تجزیه",
  "start": 88,
  "end": 89
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 458,
  "title": "نابرابری",
  "start": 90,
  "end": 90
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 459,
  "title": "جمع و تفریق در نابرابری",
  "start": 91,
  "end": 91
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 460,
  "title": "ضرب و تقسیم در نابرابری",
  "start": 92,
  "end": 92
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 461,
  "title": "حل نامعادله",
  "start": 93,
  "end": 94
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 700,
  "title": "فعالیت صفحه 79",
  "start": 79,
  "end": 79
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 701,
  "title": "کار در کالس صفحه 80",
  "start": 80,
  "end": 80
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 702,
  "title": "فعالیت صفحه 81",
  "start": 81,
  "end": 81
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 703,
  "title": "فعالیت صفحه 83",
  "start": 83,
  "end": 83
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 704,
  "title": "کار در کالس صفحه 83",
  "start": 83,
  "end": 83
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 705,
  "title": "کار در کالس صفحه 84",
  "start": 84,
  "end": 84
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 706,
  "title": "تمرین صفحه 85",
  "start": 85,
  "end": 85
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 707,
  "title": "فعالیت صفحه 86",
  "start": 86,
  "end": 86
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 708,
  "title": "کار در کالس صفحه 86",
  "start": 86,
  "end": 86
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 709,
  "title": "فعالیت صفحه 87",
  "start": 87,
  "end": 87
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 710,
  "title": "کار در کالس صفحه 87",
  "start": 87,
  "end": 87
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 711,
  "title": "فعالیت صفحه 88",
  "start": 88,
  "end": 88
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 712,
  "title": "تمرین صفحه 89",
  "start": 89,
  "end": 89
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 713,
  "title": "فعالیت صفحه 90",
  "start": 90,
  "end": 90
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 714,
  "title": "فعالیت صفحه 91",
  "start": 91,
  "end": 91
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 715,
  "title": "کار در کالس صفحه 91",
  "start": 91,
  "end": 91
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 716,
  "title": "تمرین صفحه 93",
  "start": 93,
  "end": 93
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 717,
  "title": "کار در کالس صفحه 93",
  "start": 93,
  "end": 93
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 718,
  "title": "خواندنی صفحه 94",
  "start": 94,
  "end": 94
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 400,
  "title": "کل فصل",
  "start": 95,
  "end": 112
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 450,
  "title": "رابطه خطی و معادله خط",
  "start": 96,
  "end": 97
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 451,
  "title": "نمودار خط",
  "start": 98,
  "end": 101
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 452,
  "title": "شرح: شیب خط و عرض از مبدأ",
  "start": 102,
  "end": 103
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 453,
  "title": "محاسبه شیب با دو نقطه",
  "start": 104,
  "end": 104
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 454,
  "title": "خط عمودی و شکل کلی معادله خط",
  "start": 105,
  "end": 107
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 455,
  "title": "شرح: دستگاه معادله‌های خطی",
  "start": 108,
  "end": 108
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 456,
  "title": "حل دستگاه به روش نموداری",
  "start": 109,
  "end": 110
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 457,
  "title": "حل دستگاه به روش جایگزینی",
  "start": 111,
  "end": 112
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 700,
  "title": "فعالیت صفحه 96",
  "start": 96,
  "end": 96
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 701,
  "title": "فعالیت صفحه 97",
  "start": 97,
  "end": 97
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 702,
  "title": "کار در کالس صفحه 97",
  "start": 97,
  "end": 97
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 703,
  "title": "فعالیت صفحه 99",
  "start": 99,
  "end": 99
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 704,
  "title": "کار در کالس صفحه 99",
  "start": 99,
  "end": 99
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 705,
  "title": "تمرین صفحه 100",
  "start": 100,
  "end": 100
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 706,
  "title": "کار در کالس صفحه 100",
  "start": 100,
  "end": 100
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 707,
  "title": "فعالیت صفحه 102",
  "start": 102,
  "end": 102
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 708,
  "title": "فعالیت صفحه 103",
  "start": 103,
  "end": 103
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 709,
  "title": "کار در کالس صفحه 103",
  "start": 103,
  "end": 103
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 710,
  "title": "فعالیت صفحه 105",
  "start": 105,
  "end": 105
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 711,
  "title": "تمرین صفحه 106",
  "start": 106,
  "end": 106
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 712,
  "title": "کار در کالس صفحه 106",
  "start": 106,
  "end": 106
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 713,
  "title": "فعالیت صفحه 108",
  "start": 108,
  "end": 108
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 714,
  "title": "فعالیت صفحه 109",
  "start": 109,
  "end": 109
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 715,
  "title": "کار در کالس صفحه 109",
  "start": 109,
  "end": 109
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 716,
  "title": "کار در کالس صفحه 110",
  "start": 110,
  "end": 110
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 717,
  "title": "فعالیت صفحه 111",
  "start": 111,
  "end": 111
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 718,
  "title": "تمرین صفحه 112",
  "start": 112,
  "end": 112
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 719,
  "title": "کار در کالس صفحه 112",
  "start": 112,
  "end": 112
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 400,
  "title": "کل فصل",
  "start": 113,
  "end": 129
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 450,
  "title": "معرفی عبارت گویا",
  "start": 114,
  "end": 114
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 451,
  "title": "مقدارهای مجاز عبارت گویا",
  "start": 115,
  "end": 115
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 452,
  "title": "ساده کردن عبارت‌های گویا",
  "start": 116,
  "end": 118
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 453,
  "title": "ضرب و تقسیم عبارت‌های گویا",
  "start": 119,
  "end": 119
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 454,
  "title": "جمع و تفریق عبارت‌های گویا",
  "start": 120,
  "end": 120
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 455,
  "title": "ساده کردن عبارت‌های مرکب",
  "start": 121,
  "end": 125
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 456,
  "title": "تقسیم تک‌جمله‌ای و چندجمله‌ای بر تک‌جمله‌ای",
  "start": 126,
  "end": 126
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 457,
  "title": "تقسیم چندجمله‌ای بر چندجمله‌ای",
  "start": 127,
  "end": 129
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 700,
  "title": "فعالیت صفحه 115",
  "start": 115,
  "end": 115
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 701,
  "title": "کار در کالس صفحه 115",
  "start": 115,
  "end": 115
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 702,
  "title": "فعالیت صفحه 116",
  "start": 116,
  "end": 116
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 703,
  "title": "کار در کالس صفحه 116",
  "start": 116,
  "end": 116
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 704,
  "title": "تمرین صفحه 117",
  "start": 117,
  "end": 117
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 705,
  "title": "کار در کالس صفحه 117",
  "start": 117,
  "end": 117
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 706,
  "title": "فعالیت صفحه 119",
  "start": 119,
  "end": 119
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 707,
  "title": "فعالیت صفحه 120",
  "start": 120,
  "end": 120
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 708,
  "title": "کار در کالس صفحه 120",
  "start": 120,
  "end": 120
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 709,
  "title": "فعالیت صفحه 121",
  "start": 121,
  "end": 121
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 710,
  "title": "کار در کالس صفحه 121",
  "start": 121,
  "end": 121
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 711,
  "title": "فعالیت صفحه 122",
  "start": 122,
  "end": 122
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 712,
  "title": "کار در کالس صفحه 122",
  "start": 122,
  "end": 122
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 713,
  "title": "تمرین صفحه 123",
  "start": 123,
  "end": 123
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 714,
  "title": "کار در کالس صفحه 123",
  "start": 123,
  "end": 123
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 715,
  "title": "فعالیت صفحه 126",
  "start": 126,
  "end": 126
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 716,
  "title": "کار در کالس صفحه 127",
  "start": 127,
  "end": 127
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 717,
  "title": "فعالیت صفحه 128",
  "start": 128,
  "end": 128
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 718,
  "title": "تمرین صفحه 129",
  "start": 129,
  "end": 129
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 719,
  "title": "کار در کالس صفحه 129",
  "start": 129,
  "end": 129
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 400,
  "title": "کل فصل",
  "start": 130,
  "end": 143
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 450,
  "title": "شرح: حجم و مساحت کره",
  "start": 131,
  "end": 131
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 451,
  "title": "حجم کره و استوانه محیطی",
  "start": 132,
  "end": 132
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 452,
  "title": "مساحت رویه کره",
  "start": 133,
  "end": 134
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 453,
  "title": "هرم و اجزای آن",
  "start": 135,
  "end": 136
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 454,
  "title": "محاسبه حجم هرم",
  "start": 137,
  "end": 138
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 455,
  "title": "حجم مخروط",
  "start": 139,
  "end": 139
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 456,
  "title": "گسترده و مساحت سطح",
  "start": 140,
  "end": 140
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 457,
  "title": "حجم حاصل از دوران",
  "start": 141,
  "end": 141
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 458,
  "title": "سطح مقطع حجم‌ها",
  "start": 142,
  "end": 143
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 700,
  "title": "فعالیت صفحه 131",
  "start": 131,
  "end": 131
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 701,
  "title": "کار در کالس صفحه 132",
  "start": 132,
  "end": 132
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 702,
  "title": "فعالیت صفحه 133",
  "start": 133,
  "end": 133
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 703,
  "title": "کار در کالس صفحه 133",
  "start": 133,
  "end": 133
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 704,
  "title": "تمرین صفحه 134",
  "start": 134,
  "end": 134
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 705,
  "title": "فعالیت صفحه 135",
  "start": 135,
  "end": 135
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 706,
  "title": "کار در کالس صفحه 136",
  "start": 136,
  "end": 136
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 707,
  "title": "فعالیت صفحه 137",
  "start": 137,
  "end": 137
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 708,
  "title": "کار در کالس صفحه 137",
  "start": 137,
  "end": 137
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 709,
  "title": "فعالیت صفحه 138",
  "start": 138,
  "end": 138
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 710,
  "title": "تمرین صفحه 139",
  "start": 139,
  "end": 139
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 711,
  "title": "کار در کالس صفحه 139",
  "start": 139,
  "end": 139
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 712,
  "title": "فعالیت صفحه 140",
  "start": 140,
  "end": 140
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 713,
  "title": "فعالیت صفحه 141",
  "start": 141,
  "end": 141
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 714,
  "title": "کار در کالس صفحه 141",
  "start": 141,
  "end": 141
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 715,
  "title": "فعالیت صفحه 142",
  "start": 142,
  "end": 142
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 716,
  "title": "کار در کالس صفحه 142",
  "start": 142,
  "end": 142
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 717,
  "title": "تمرین صفحه 143",
  "start": 143,
  "end": 143
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 718,
  "title": "کار در کالس صفحه 143",
  "start": 143,
  "end": 143
 }
]$topics$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v202:all:9:final_exam:ریاضی:'||p.chapter||':'||p.position)::uuid,'1405','all','9','final_exam','ریاضی',p.chapter,p.title,p.start,p."end",p.position from topics p cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 1,
  "title": "معرفی مجموعه",
  "start": 2,
  "end": 5
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 2,
  "title": "مجموعه‌های برابر و نمایش مجموعه‌ها",
  "start": 6,
  "end": 10
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 3,
  "title": "اجتماع، اشتراک و تفاضل مجموعه‌ها",
  "start": 11,
  "end": 14
 },
 {
  "chapter": "فصل ۱: مجموعه‌ها",
  "position": 4,
  "title": "مجموعه‌ها و احتمال",
  "start": 15,
  "end": 17
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 1,
  "title": "عددهای گویا",
  "start": 19,
  "end": 22
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 2,
  "title": "عددهای حقیقی",
  "start": 23,
  "end": 27
 },
 {
  "chapter": "فصل ۲: عددهای حقیقی",
  "position": 3,
  "title": "قدر مطلق و محاسبه تقریبی",
  "start": 28,
  "end": 31
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 1,
  "title": "استدلال",
  "start": 33,
  "end": 36
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 2,
  "title": "آشنایی با اثبات در هندسه",
  "start": 37,
  "end": 43
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 3,
  "title": "هم‌نهشتی مثلث‌ها",
  "start": 44,
  "end": 48
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 4,
  "title": "حل مسئله در هندسه",
  "start": 49,
  "end": 52
 },
 {
  "chapter": "فصل ۳: استدلال و اثبات در هندسه",
  "position": 5,
  "title": "شکل‌های متشابه",
  "start": 53,
  "end": 58
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 1,
  "title": "توان صحیح",
  "start": 60,
  "end": 64
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 2,
  "title": "نماد علمی",
  "start": 65,
  "end": 67
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 3,
  "title": "ریشه‌گیری",
  "start": 68,
  "end": 72
 },
 {
  "chapter": "فصل ۴: توان و ریشه",
  "position": 4,
  "title": "جمع و تفریق رادیکال‌ها",
  "start": 73,
  "end": 77
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 1,
  "title": "عبارت‌های جبری و مفهوم اتحاد",
  "start": 79,
  "end": 85
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 2,
  "title": "چند اتحاد دیگر، تجزیه و کاربردها",
  "start": 86,
  "end": 89
 },
 {
  "chapter": "فصل ۵: عبارت‌های جبری",
  "position": 3,
  "title": "نابرابری و نامعادله‌ها",
  "start": 90,
  "end": 94
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 1,
  "title": "معادله خط",
  "start": 96,
  "end": 101
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 2,
  "title": "شیب خط و عرض از مبدأ",
  "start": 102,
  "end": 107
 },
 {
  "chapter": "فصل ۶: خط و معادله‌های خطی",
  "position": 3,
  "title": "دستگاه معادله‌های خطی",
  "start": 108,
  "end": 112
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 1,
  "title": "معرفی و ساده کردن عبارت‌های گویا",
  "start": 114,
  "end": 118
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 2,
  "title": "محاسبات عبارت‌های گویا",
  "start": 119,
  "end": 125
 },
 {
  "chapter": "فصل ۷: عبارت‌های گویا",
  "position": 3,
  "title": "تقسیم چندجمله‌ای‌ها",
  "start": 126,
  "end": 129
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 1,
  "title": "حجم و مساحت کره",
  "start": 131,
  "end": 134
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 2,
  "title": "حجم هرم و مخروط",
  "start": 135,
  "end": 139
 },
 {
  "chapter": "فصل ۸: حجم و مساحت",
  "position": 3,
  "title": "سطح و حجم",
  "start": 140,
  "end": 143
 }
]$fixes$::jsonb) as p(chapter text,position integer,title text,start integer,"end" integer))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p
where t.id=md5('nova:planner:1405:v1:all:9:final_exam:ریاضی:'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field='all' and t.grade='9' and t.preparation_track='final_exam' and t.subject='ریاضی' and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
