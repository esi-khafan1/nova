-- Calculus 1/2 and discrete mathematics 1405; sources and limitations in docs.
with installed as (insert into private.planner_seed_installations(seed_key) values ('calculus-discrete-1405-v199') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 400,
  "title": "کل فصل",
  "start": 1,
  "end": 36
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 401,
  "title": "درس: مجموع جملات دنباله‌های حسابی و هندسی",
  "start": 2,
  "end": 6
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 402,
  "title": "درس: معادلات درجه دوم",
  "start": 7,
  "end": 16
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 403,
  "title": "درس: معادلات گویا و گنگ",
  "start": 17,
  "end": 22
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 404,
  "title": "درس: قدر مطلق و ویژگی‌های آن",
  "start": 23,
  "end": 28
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 405,
  "title": "درس: آشنایی با هندسه تحلیلی",
  "start": 29,
  "end": 36
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 450,
  "title": "مجموع جمله‌های دنباله حسابی",
  "start": 2,
  "end": 3
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 451,
  "title": "مجموع جمله‌های دنباله هندسی",
  "start": 4,
  "end": 6
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 452,
  "title": "معادله درجه دوم",
  "start": 7,
  "end": 7
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 453,
  "title": "رابطه ضرایب و ریشه‌های معادله درجه دوم",
  "start": 8,
  "end": 9
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 454,
  "title": "صفرهای تابع",
  "start": 10,
  "end": 13
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 455,
  "title": "روش هندسی حل معادله",
  "start": 14,
  "end": 16
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 456,
  "title": "معادله‌های گویا",
  "start": 17,
  "end": 19
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 457,
  "title": "معادله‌های گنگ",
  "start": 20,
  "end": 22
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 458,
  "title": "قدر مطلق",
  "start": 23,
  "end": 23
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 459,
  "title": "رسم توابع قدر مطلقی",
  "start": 24,
  "end": 24
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 460,
  "title": "ویژگی‌های قدر مطلق",
  "start": 25,
  "end": 25
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 461,
  "title": "معادلات قدر مطلقی",
  "start": 26,
  "end": 28
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 462,
  "title": "فاصله بین دو نقطه",
  "start": 29,
  "end": 31
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 463,
  "title": "مختصات نقطه وسط پاره‌خط",
  "start": 32,
  "end": 32
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 464,
  "title": "فاصله نقطه از خط",
  "start": 33,
  "end": 36
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 400,
  "title": "کل فصل",
  "start": 37,
  "end": 70
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 401,
  "title": "درس: آشنایی بیشتر با تابع",
  "start": 38,
  "end": 43
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 402,
  "title": "درس: انواع توابع",
  "start": 44,
  "end": 53
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 403,
  "title": "درس: وارون تابع",
  "start": 54,
  "end": 62
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 404,
  "title": "درس: اعمال روی توابع",
  "start": 63,
  "end": 70
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 450,
  "title": "شرح: آشنایی بیشتر با تابع",
  "start": 38,
  "end": 39
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 451,
  "title": "تابع به عنوان ماشین",
  "start": 40,
  "end": 40
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 452,
  "title": "برابری دو تابع",
  "start": 41,
  "end": 41
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 453,
  "title": "تمرین تابع",
  "start": 42,
  "end": 43
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 454,
  "title": "توابع گویا",
  "start": 44,
  "end": 45
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 455,
  "title": "توابع رادیکالی",
  "start": 46,
  "end": 47
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 456,
  "title": "معادله‌ها و توابع",
  "start": 48,
  "end": 48
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 457,
  "title": "تابع پله‌ای و جزء صحیح",
  "start": 49,
  "end": 51
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 458,
  "title": "تمرین انواع توابع",
  "start": 52,
  "end": 53
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 459,
  "title": "شرح: وارون تابع",
  "start": 54,
  "end": 54
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 460,
  "title": "توابع یک‌به‌یک",
  "start": 55,
  "end": 56
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 461,
  "title": "محاسبه وارون تابع",
  "start": 57,
  "end": 62
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 462,
  "title": "شرح: اعمال روی توابع",
  "start": 63,
  "end": 65
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 463,
  "title": "ترکیب توابع",
  "start": 66,
  "end": 70
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۳: توابع نمایی و لگاریتمی",
  "position": 400,
  "title": "کل فصل",
  "start": 71,
  "end": 90
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۳: توابع نمایی و لگاریتمی",
  "position": 401,
  "title": "درس: تابع نمایی",
  "start": 72,
  "end": 79
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۳: توابع نمایی و لگاریتمی",
  "position": 402,
  "title": "درس: تابع لگاریتمی و لگاریتم",
  "start": 80,
  "end": 85
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۳: توابع نمایی و لگاریتمی",
  "position": 403,
  "title": "درس: ویژگی‌های لگاریتم و حل معادله‌های لگاریتمی",
  "start": 86,
  "end": 90
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۳: توابع نمایی و لگاریتمی",
  "position": 452,
  "title": "ویژگی‌های لگاریتم",
  "start": 86,
  "end": 86
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۳: توابع نمایی و لگاریتمی",
  "position": 453,
  "title": "معادلات لگاریتمی",
  "start": 87,
  "end": 87
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۳: توابع نمایی و لگاریتمی",
  "position": 454,
  "title": "کاربردهای لگاریتم",
  "start": 88,
  "end": 90
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 400,
  "title": "کل فصل",
  "start": 91,
  "end": 112
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 401,
  "title": "درس: رادیان",
  "start": 92,
  "end": 97
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 402,
  "title": "درس: نسبت‌های مثلثاتی برخی زوایا",
  "start": 98,
  "end": 104
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 403,
  "title": "درس: توابع مثلثاتی",
  "start": 105,
  "end": 109
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 404,
  "title": "درس: روابط مثلثاتی مجموع و تفاضل زوایا",
  "start": 110,
  "end": 112
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 450,
  "title": "شرح: رادیان",
  "start": 92,
  "end": 95
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 451,
  "title": "تمرین رادیان",
  "start": 96,
  "end": 97
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 452,
  "title": "نسبت‌های مثلثاتی زوایای متمم",
  "start": 98,
  "end": 98
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 453,
  "title": "نسبت‌های مثلثاتی زوایای قرینه و مکمل",
  "start": 99,
  "end": 100
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 454,
  "title": "نسبت‌های مثلثاتی مجموع یا تفاضل",
  "start": 101,
  "end": 103
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 455,
  "title": "تمرین نسبت‌های مثلثاتی",
  "start": 104,
  "end": 104
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 456,
  "title": "شرح: توابع مثلثاتی",
  "start": 105,
  "end": 108
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 457,
  "title": "تمرین توابع مثلثاتی",
  "start": 109,
  "end": 109
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 458,
  "title": "شرح: روابط مثلثاتی مجموع و تفاضل زوایا",
  "start": 110,
  "end": 111
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 459,
  "title": "تمرین روابط مثلثاتی",
  "start": 112,
  "end": 112
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 400,
  "title": "کل فصل",
  "start": 113,
  "end": 151
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 401,
  "title": "درس: مفهوم حد و فرایندهای حدی",
  "start": 114,
  "end": 122
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 402,
  "title": "درس: حدهای یک‌طرفه",
  "start": 123,
  "end": 129
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 403,
  "title": "درس: قضایای حد",
  "start": 130,
  "end": 140
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 404,
  "title": "درس: محاسبه حد توابع کسری",
  "start": 141,
  "end": 144
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 405,
  "title": "درس: پیوستگی",
  "start": 145,
  "end": 151
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 450,
  "title": "شرح: مفهوم حد و فرایندهای حدی",
  "start": 114,
  "end": 119
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 451,
  "title": "تمرین مفهوم حد",
  "start": 120,
  "end": 122
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 452,
  "title": "شرح: حدهای یک‌طرفه",
  "start": 123,
  "end": 126
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 453,
  "title": "تمرین حدهای یک‌طرفه",
  "start": 127,
  "end": 129
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 454,
  "title": "شرح: قضایای حد",
  "start": 130,
  "end": 136
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 455,
  "title": "حد توابع مثلثاتی",
  "start": 137,
  "end": 138
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 456,
  "title": "تمرین قضایای حد",
  "start": 139,
  "end": 140
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 457,
  "title": "شرح: محاسبه حد توابع کسری",
  "start": 141,
  "end": 143
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 458,
  "title": "تمرین حد توابع کسری",
  "start": 144,
  "end": 144
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 459,
  "title": "شرح: پیوستگی",
  "start": 145,
  "end": 150
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 460,
  "title": "تمرین پیوستگی",
  "start": 151,
  "end": 151
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 400,
  "title": "کل فصل",
  "start": 1,
  "end": 22
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 401,
  "title": "درس: تبدیل نمودار توابع",
  "start": 2,
  "end": 12
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 402,
  "title": "درس: تابع درجه سوم، توابع یکنوا و بخش‌پذیری و تقسیم",
  "start": 13,
  "end": 22
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 450,
  "title": "انتقال‌های افقی و عمودی نمودار",
  "start": 2,
  "end": 5
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 451,
  "title": "انقباض و انبساط عمودی",
  "start": 6,
  "end": 7
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 452,
  "title": "انقباض و انبساط افقی",
  "start": 8,
  "end": 10
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 453,
  "title": "تمرین تبدیل نمودار",
  "start": 11,
  "end": 12
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 454,
  "title": "تابع درجه سوم",
  "start": 13,
  "end": 14
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 455,
  "title": "توابع صعودی و نزولی",
  "start": 15,
  "end": 17
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 456,
  "title": "بخش‌پذیری و تقسیم",
  "start": 18,
  "end": 20
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 457,
  "title": "تمرین تابع درجه سوم",
  "start": 21,
  "end": 22
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 400,
  "title": "کل فصل",
  "start": 23,
  "end": 44
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 401,
  "title": "درس: تناوب و تانژانت",
  "start": 24,
  "end": 34
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 402,
  "title": "درس: معادلات مثلثاتی",
  "start": 35,
  "end": 44
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 450,
  "title": "تناوب تابع",
  "start": 24,
  "end": 28
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 451,
  "title": "تانژانت",
  "start": 29,
  "end": 29
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 452,
  "title": "تغییرات تانژانت",
  "start": 30,
  "end": 31
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 453,
  "title": "رسم تابع تانژانت",
  "start": 32,
  "end": 32
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 454,
  "title": "تمرین تناوب و تانژانت",
  "start": 33,
  "end": 34
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 455,
  "title": "شرح: معادلات مثلثاتی",
  "start": 35,
  "end": 43
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 456,
  "title": "تمرین معادلات مثلثاتی",
  "start": 44,
  "end": 44
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 400,
  "title": "کل فصل",
  "start": 45,
  "end": 70
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 401,
  "title": "درس: حدهای نامتناهی",
  "start": 46,
  "end": 58
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 402,
  "title": "درس: حد در بی‌نهایت",
  "start": 59,
  "end": 70
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 450,
  "title": "شرح: حدهای نامتناهی",
  "start": 46,
  "end": 50
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 451,
  "title": "قضایای حدهای بی‌نهایت",
  "start": 51,
  "end": 54
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 452,
  "title": "مجانب قائم",
  "start": 55,
  "end": 57
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 453,
  "title": "تمرین حدهای نامتناهی",
  "start": 58,
  "end": 58
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 454,
  "title": "شرح: حد در بی‌نهایت",
  "start": 59,
  "end": 62
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 455,
  "title": "حدهای نامتناهی در بی‌نهایت",
  "start": 63,
  "end": 66
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 456,
  "title": "مجانب افقی",
  "start": 67,
  "end": 68
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 457,
  "title": "تمرین حد در بی‌نهایت",
  "start": 69,
  "end": 70
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 400,
  "title": "کل فصل",
  "start": 71,
  "end": 110
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 401,
  "title": "درس: آشنایی با مفهوم مشتق",
  "start": 72,
  "end": 83
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 402,
  "title": "درس: مشتق‌پذیری و پیوستگی",
  "start": 84,
  "end": 101
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 403,
  "title": "درس: آهنگ متوسط تغییر و آهنگ لحظه‌ای تغییر",
  "start": 102,
  "end": 110
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 450,
  "title": "مفهوم مشتق",
  "start": 72,
  "end": 72
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 451,
  "title": "خط مماس بر منحنی",
  "start": 73,
  "end": 77
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 452,
  "title": "محاسبه مشتق به روش دیگر",
  "start": 78,
  "end": 83
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 453,
  "title": "شرح: مشتق‌پذیری و پیوستگی",
  "start": 84,
  "end": 89
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 454,
  "title": "تابع مشتق",
  "start": 90,
  "end": 91
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 455,
  "title": "محاسبه مشتق برخی توابع",
  "start": 92,
  "end": 94
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 456,
  "title": "مشتق توابع مثلثاتی",
  "start": 95,
  "end": 95
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 457,
  "title": "مشتق تابع مرکب و قاعده زنجیری",
  "start": 96,
  "end": 96
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 458,
  "title": "مشتق‌پذیری روی بازه",
  "start": 97,
  "end": 97
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 459,
  "title": "مشتق مرتبه دوم",
  "start": 98,
  "end": 101
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 460,
  "title": "آهنگ متوسط و لحظه‌ای تغییر",
  "start": 102,
  "end": 104
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 461,
  "title": "کاربردهای آهنگ تغییر",
  "start": 105,
  "end": 106
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 462,
  "title": "سرعت متوسط و سرعت لحظه‌ای",
  "start": 107,
  "end": 110
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 400,
  "title": "کل فصل",
  "start": 111,
  "end": 144
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 401,
  "title": "درس: اکسترمم‌های یک تابع و توابع صعودی و نزولی",
  "start": 112,
  "end": 126
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 402,
  "title": "درس: جهت تقعر نمودار یک تابع و نقطه عطف آن",
  "start": 127,
  "end": 136
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 403,
  "title": "درس: رسم نمودار تابع",
  "start": 137,
  "end": 144
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 450,
  "title": "اکسترمم‌های تابع",
  "start": 112,
  "end": 119
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 451,
  "title": "تشخیص صعودی یا نزولی بودن تابع",
  "start": 120,
  "end": 122
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 452,
  "title": "آزمون مشتق اول",
  "start": 123,
  "end": 126
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 453,
  "title": "جهت تقعر نمودار تابع",
  "start": 127,
  "end": 130
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 454,
  "title": "نقطه عطف نمودار",
  "start": 131,
  "end": 136
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 400,
  "title": "کل فصل",
  "start": 1,
  "end": 30
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 401,
  "title": "درس: استدلال ریاضی",
  "start": 2,
  "end": 8
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 402,
  "title": "درس: بخش‌پذیری در اعداد صحیح",
  "start": 9,
  "end": 17
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 403,
  "title": "درس: هم‌نهشتی در اعداد صحیح و کاربردها",
  "start": 18,
  "end": 30
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 450,
  "title": "شرح: استدلال ریاضی",
  "start": 2,
  "end": 3
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 451,
  "title": "اثبات با در نظر گرفتن همه حالت‌ها",
  "start": 4,
  "end": 4
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 452,
  "title": "اثبات غیرمستقیم",
  "start": 5,
  "end": 5
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 453,
  "title": "اثبات بازگشتی و گزاره‌های هم‌ارز",
  "start": 6,
  "end": 8
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 454,
  "title": "شرح: بخش‌پذیری در اعداد صحیح",
  "start": 9,
  "end": 9
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 455,
  "title": "ویژگی‌های رابطه عاد کردن",
  "start": 10,
  "end": 12
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 456,
  "title": "بزرگ‌ترین مقسوم‌علیه مشترک و کوچک‌ترین مضرب مشترک",
  "start": 13,
  "end": 13
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 457,
  "title": "قضیه تقسیم و کاربردها",
  "start": 14,
  "end": 14
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 458,
  "title": "افراز مجموعه به کمک قضیه تقسیم",
  "start": 15,
  "end": 17
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 459,
  "title": "هم‌نهشتی در اعداد صحیح",
  "start": 18,
  "end": 23
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 460,
  "title": "معادله هم‌نهشتی",
  "start": 24,
  "end": 25
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 461,
  "title": "معادلات سیاله و کاربردها",
  "start": 26,
  "end": 30
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۲: گراف و مدل‌سازی",
  "position": 400,
  "title": "کل فصل",
  "start": 31,
  "end": 54
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۲: گراف و مدل‌سازی",
  "position": 401,
  "title": "درس: معرفی گراف",
  "start": 32,
  "end": 42
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۲: گراف و مدل‌سازی",
  "position": 402,
  "title": "درس: مدل‌سازی با گراف",
  "start": 43,
  "end": 54
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۲: گراف و مدل‌سازی",
  "position": 451,
  "title": "شرح: مدل‌سازی با گراف",
  "start": 43,
  "end": 46
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۲: گراف و مدل‌سازی",
  "position": 452,
  "title": "معرفی یک نماد",
  "start": 47,
  "end": 54
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 400,
  "title": "کل فصل",
  "start": 55,
  "end": 84
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 401,
  "title": "درس: مباحثی در ترکیبیات",
  "start": 56,
  "end": 72
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 402,
  "title": "درس: روش‌هایی برای شمارش",
  "start": 73,
  "end": 84
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 450,
  "title": "یادآوری و تکمیل ترکیبیات",
  "start": 56,
  "end": 57
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 451,
  "title": "جایگشت‌های با تکرار",
  "start": 58,
  "end": 61
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 452,
  "title": "مربع‌های لاتین",
  "start": 62,
  "end": 63
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 453,
  "title": "دو مربع لاتین متعامد",
  "start": 64,
  "end": 69
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 454,
  "title": "ساخت مربع لاتین متعامد از مرتبه فرد",
  "start": 70,
  "end": 72
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 455,
  "title": "اصل شمول و عدم شمول",
  "start": 73,
  "end": 78
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 456,
  "title": "اصل لانه کبوتری",
  "start": 79,
  "end": 84
 }
]$topics$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v199:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 1,
  "title": "مجموع جملات دنباله‌های حسابی و هندسی",
  "new_title": "مجموع جملات دنباله‌های حسابی و هندسی",
  "start": 2,
  "end": 6
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 2,
  "title": "معادلات درجه دوم",
  "new_title": "معادلات درجه دوم",
  "start": 7,
  "end": 16
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 3,
  "title": "معادلات گویا و گنگ",
  "new_title": "معادلات گویا و گنگ",
  "start": 17,
  "end": 22
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 4,
  "title": "قدر مطلق و ویژگی‌های آن",
  "new_title": "قدر مطلق و ویژگی‌های آن",
  "start": 23,
  "end": 28
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۱: جبر و معادله",
  "position": 5,
  "title": "آشنایی با هندسه تحلیلی",
  "new_title": "آشنایی با هندسه تحلیلی",
  "start": 29,
  "end": 36
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 1,
  "title": "آشنایی بیشتر با تابع",
  "new_title": "آشنایی بیشتر با تابع",
  "start": 38,
  "end": 43
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 2,
  "title": "انواع توابع",
  "new_title": "انواع توابع",
  "start": 44,
  "end": 53
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 3,
  "title": "وارون تابع",
  "new_title": "وارون تابع",
  "start": 54,
  "end": 62
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۲: تابع",
  "position": 4,
  "title": "اعمال روی توابع",
  "new_title": "اعمال روی توابع",
  "start": 63,
  "end": 70
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۳: توابع نمایی و لگاریتمی",
  "position": 1,
  "title": "تابع نمایی",
  "new_title": "تابع نمایی",
  "start": 72,
  "end": 79
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۳: توابع نمایی و لگاریتمی",
  "position": 2,
  "title": "تابع لگاریتمی و لگاریتم",
  "new_title": "تابع لگاریتمی و لگاریتم",
  "start": 80,
  "end": 85
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۳: توابع نمایی و لگاریتمی",
  "position": 3,
  "title": "ویژگی‌های لگاریتم و حل معادله‌های لگاریتمی",
  "new_title": "ویژگی‌های لگاریتم و حل معادله‌های لگاریتمی",
  "start": 86,
  "end": 90
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 1,
  "title": "رادیان",
  "new_title": "رادیان",
  "start": 92,
  "end": 97
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 2,
  "title": "نسبت‌های مثلثاتی برخی زوایا",
  "new_title": "نسبت‌های مثلثاتی برخی زوایا",
  "start": 98,
  "end": 104
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 3,
  "title": "توابع مثلثاتی",
  "new_title": "توابع مثلثاتی",
  "start": 105,
  "end": 109
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۴: مثلثات",
  "position": 4,
  "title": "روابط مثلثاتی مجموع و تفاضل زوایا",
  "new_title": "روابط مثلثاتی مجموع و تفاضل زوایا",
  "start": 110,
  "end": 112
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 1,
  "title": "مفهوم حد و فرایندهای حدی",
  "new_title": "مفهوم حد و فرایندهای حدی",
  "start": 114,
  "end": 122
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 2,
  "title": "حدهای یک‌طرفه",
  "new_title": "حدهای یک‌طرفه",
  "start": 123,
  "end": 129
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 3,
  "title": "قضایای حد",
  "new_title": "قضایای حد",
  "start": 130,
  "end": 140
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 4,
  "title": "محاسبه حد توابع کسری",
  "new_title": "محاسبه حد توابع کسری",
  "start": 141,
  "end": 144
 },
 {
  "field": "mathematics",
  "grade": "11",
  "subject": "حسابان ۱",
  "chapter": "فصل ۵: حد و پیوستگی",
  "position": 5,
  "title": "پیوستگی",
  "new_title": "پیوستگی",
  "start": 145,
  "end": 151
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 1,
  "title": "تبدیل نمودار توابع",
  "new_title": "تبدیل نمودار توابع",
  "start": 2,
  "end": 12
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۱: تابع",
  "position": 2,
  "title": "تابع درجه سوم، توابع یکنوا و بخش‌پذیری و تقسیم",
  "new_title": "تابع درجه سوم، توابع یکنوا و بخش‌پذیری و تقسیم",
  "start": 13,
  "end": 22
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 1,
  "title": "تناوب و تانژانت",
  "new_title": "تناوب و تانژانت",
  "start": 24,
  "end": 34
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۲: مثلثات",
  "position": 2,
  "title": "معادلات مثلثاتی",
  "new_title": "معادلات مثلثاتی",
  "start": 35,
  "end": 44
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 1,
  "title": "حدهای نامتناهی",
  "new_title": "حدهای نامتناهی",
  "start": 46,
  "end": 58
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
  "position": 2,
  "title": "حد در بی‌نهایت",
  "new_title": "حد در بی‌نهایت",
  "start": 59,
  "end": 70
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 1,
  "title": "آشنایی با مفهوم مشتق",
  "new_title": "آشنایی با مفهوم مشتق",
  "start": 72,
  "end": 83
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 2,
  "title": "مشتق‌پذیری و پیوستگی",
  "new_title": "مشتق‌پذیری و پیوستگی",
  "start": 84,
  "end": 101
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۴: مشتق",
  "position": 3,
  "title": "آهنگ متوسط تغییر و آهنگ لحظه‌ای تغییر",
  "new_title": "آهنگ متوسط تغییر و آهنگ لحظه‌ای تغییر",
  "start": 102,
  "end": 110
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 1,
  "title": "اکسترمم‌های یک تابع و توابع صعودی و نزولی",
  "new_title": "اکسترمم‌های یک تابع و توابع صعودی و نزولی",
  "start": 112,
  "end": 126
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 2,
  "title": "جهت تقعر نمودار یک تابع و نقطه عطف آن",
  "new_title": "جهت تقعر نمودار یک تابع و نقطه عطف آن",
  "start": 127,
  "end": 136
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "حسابان ۲",
  "chapter": "فصل ۵: کاربردهای مشتق",
  "position": 3,
  "title": "رسم نمودار تابع",
  "new_title": "رسم نمودار تابع",
  "start": 137,
  "end": 144
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 1,
  "title": "استدلال ریاضی",
  "new_title": "استدلال ریاضی",
  "start": 2,
  "end": 8
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 2,
  "title": "بخش‌پذیری در اعداد صحیح",
  "new_title": "بخش‌پذیری در اعداد صحیح",
  "start": 9,
  "end": 17
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۱: آشنایی با نظریه اعداد",
  "position": 3,
  "title": "هم‌نهشتی در اعداد صحیح و کاربردها",
  "new_title": "هم‌نهشتی در اعداد صحیح و کاربردها",
  "start": 18,
  "end": 30
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۲: گراف و مدل‌سازی",
  "position": 1,
  "title": "معرفی گراف",
  "new_title": "معرفی گراف",
  "start": 32,
  "end": 42
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۲: گراف و مدل‌سازی",
  "position": 2,
  "title": "مدل‌سازی با گراف",
  "new_title": "مدل‌سازی با گراف",
  "start": 43,
  "end": 54
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 1,
  "title": "مباحثی در ترکیبیات",
  "new_title": "مباحثی در ترکیبیات",
  "start": 56,
  "end": 72
 },
 {
  "field": "mathematics",
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "chapter": "فصل ۳: ترکیبیات",
  "position": 2,
  "title": "روش‌هایی برای شمارش",
  "new_title": "روش‌هایی برای شمارش",
  "start": 73,
  "end": 84
 }
]$fixes$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,new_title text,start integer,"end" integer)),
tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set title=p.new_title,page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field=p.field and t.grade=p.grade and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
