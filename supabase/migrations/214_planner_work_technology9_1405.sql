-- Work and Technology 9 (917), 1405 user PDF, printed pages.
-- Modules 6-11 are semi-prescribed alternatives; users select two projects.
with installed as (insert into private.planner_seed_installations(seed_key) values ('work-technology9-1405-v214') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "کل پودمان",
  "start": 3,
  "end": 12,
  "position": 1
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "تعریف حل مسئله",
  "start": 4,
  "end": 5,
  "position": 100
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "الخوارزمی و الگوریتم",
  "start": 6,
  "end": 6,
  "position": 101
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "روش‌های بیان الگوریتم",
  "start": 7,
  "end": 7,
  "position": 102
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "روش روندنما",
  "start": 8,
  "end": 8,
  "position": 103
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "نرم‌افزار رسم روندنما",
  "start": 9,
  "end": 9,
  "position": 104
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "مثال‌های روندنما",
  "start": 10,
  "end": 12,
  "position": 105
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "مطالعه صفحه ۳",
  "start": 3,
  "end": 3,
  "position": 503
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "مطالعه صفحه ۴",
  "start": 4,
  "end": 4,
  "position": 504
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "مطالعه صفحه ۵",
  "start": 5,
  "end": 5,
  "position": 505
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "مطالعه صفحه ۶",
  "start": 6,
  "end": 6,
  "position": 506
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "مطالعه صفحه ۷",
  "start": 7,
  "end": 7,
  "position": 507
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "مطالعه صفحه ۸",
  "start": 8,
  "end": 8,
  "position": 508
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "مطالعه صفحه ۹",
  "start": 9,
  "end": 9,
  "position": 509
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "مطالعه صفحه ۱۰",
  "start": 10,
  "end": 10,
  "position": 510
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "مطالعه صفحه ۱۱",
  "start": 11,
  "end": 11,
  "position": 511
 },
 {
  "chapter": "پودمان ۱: الگوریتم",
  "title": "مطالعه صفحه ۱۲",
  "start": 12,
  "end": 12,
  "position": 512
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "کل پودمان",
  "start": 13,
  "end": 24,
  "position": 1
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "کاربرد ترسیم با رایانه در مشاغل",
  "start": 14,
  "end": 15,
  "position": 100
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "محیط نرم‌افزارهای ترسیم با رایانه",
  "start": 16,
  "end": 16,
  "position": 101
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "ترسیم شکل‌های ساده",
  "start": 17,
  "end": 17,
  "position": 102
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "ابزارهای ویرایش",
  "start": 18,
  "end": 18,
  "position": 103
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "ابزارهای دوران، برش، امتداد و مقیاس",
  "start": 19,
  "end": 19,
  "position": 104
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "ابزارهای کمک رسم",
  "start": 20,
  "end": 20,
  "position": 105
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "اندازه‌گذاری نقشه و ترسیم",
  "start": 21,
  "end": 24,
  "position": 106
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۱۳",
  "start": 13,
  "end": 13,
  "position": 513
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۱۴",
  "start": 14,
  "end": 14,
  "position": 514
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۱۵",
  "start": 15,
  "end": 15,
  "position": 515
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۱۶",
  "start": 16,
  "end": 16,
  "position": 516
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۱۷",
  "start": 17,
  "end": 17,
  "position": 517
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۱۸",
  "start": 18,
  "end": 18,
  "position": 518
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۱۹",
  "start": 19,
  "end": 19,
  "position": 519
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۲۰",
  "start": 20,
  "end": 20,
  "position": 520
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۲۱",
  "start": 21,
  "end": 21,
  "position": 521
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۲۲",
  "start": 22,
  "end": 22,
  "position": 522
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۲۳",
  "start": 23,
  "end": 23,
  "position": 523
 },
 {
  "chapter": "پودمان ۲: ترسیم با رایانه",
  "title": "مطالعه صفحه ۲۴",
  "start": 24,
  "end": 24,
  "position": 524
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "کل پودمان",
  "start": 25,
  "end": 38,
  "position": 1
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "ساز و کارهای حرکتی",
  "start": 26,
  "end": 30,
  "position": 100
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "نرم‌افزار Interactive Physics",
  "start": 31,
  "end": 31,
  "position": 101
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "پروژه طراحی و ساخت جرثقیل",
  "start": 32,
  "end": 33,
  "position": 102
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "پروژه طراحی و ساخت اسباب‌بازی",
  "start": 34,
  "end": 35,
  "position": 103
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "پل متحرک خضر",
  "start": 36,
  "end": 36,
  "position": 104
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "پروژه پیشنهادی",
  "start": 37,
  "end": 37,
  "position": 105
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "خودارزیابی پروژه",
  "start": 38,
  "end": 38,
  "position": 106
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۲۵",
  "start": 25,
  "end": 25,
  "position": 525
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۲۶",
  "start": 26,
  "end": 26,
  "position": 526
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۲۷",
  "start": 27,
  "end": 27,
  "position": 527
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۲۸",
  "start": 28,
  "end": 28,
  "position": 528
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۲۹",
  "start": 29,
  "end": 29,
  "position": 529
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۳۰",
  "start": 30,
  "end": 30,
  "position": 530
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۳۱",
  "start": 31,
  "end": 31,
  "position": 531
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۳۲",
  "start": 32,
  "end": 32,
  "position": 532
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۳۳",
  "start": 33,
  "end": 33,
  "position": 533
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۳۴",
  "start": 34,
  "end": 34,
  "position": 534
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۳۵",
  "start": 35,
  "end": 35,
  "position": 535
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۳۶",
  "start": 36,
  "end": 36,
  "position": 536
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۳۷",
  "start": 37,
  "end": 37,
  "position": 537
 },
 {
  "chapter": "پودمان ۳: ساز و کارهای حرکتی",
  "title": "مطالعه صفحه ۳۸",
  "start": 38,
  "end": 38,
  "position": 538
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "کل پودمان",
  "start": 39,
  "end": 55,
  "position": 1
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مقدمه و یادآوری تابع",
  "start": 40,
  "end": 40,
  "position": 100
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "محیط برنامه‌نویسی",
  "start": 41,
  "end": 41,
  "position": 101
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مفهوم args و kwargs",
  "start": 42,
  "end": 42,
  "position": 102
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "فضای نام و scope",
  "start": 43,
  "end": 43,
  "position": 103
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "توابع داخلی پایتون",
  "start": 44,
  "end": 44,
  "position": 104
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "آشنایی با شیءگرایی",
  "start": 45,
  "end": 45,
  "position": 105
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "کلاس و شیء",
  "start": 46,
  "end": 46,
  "position": 106
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "تابع init",
  "start": 47,
  "end": 49,
  "position": 107
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "کتابخانه tkinter",
  "start": 50,
  "end": 50,
  "position": 108
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "اندازه، عنوان، موقعیت و رنگ پنجره",
  "start": 51,
  "end": 53,
  "position": 109
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "ایجاد خروجی exe",
  "start": 54,
  "end": 55,
  "position": 110
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۳۹",
  "start": 39,
  "end": 39,
  "position": 539
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۴۰",
  "start": 40,
  "end": 40,
  "position": 540
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۴۱",
  "start": 41,
  "end": 41,
  "position": 541
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۴۲",
  "start": 42,
  "end": 42,
  "position": 542
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۴۳",
  "start": 43,
  "end": 43,
  "position": 543
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۴۴",
  "start": 44,
  "end": 44,
  "position": 544
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۴۵",
  "start": 45,
  "end": 45,
  "position": 545
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۴۶",
  "start": 46,
  "end": 46,
  "position": 546
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۴۷",
  "start": 47,
  "end": 47,
  "position": 547
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۴۸",
  "start": 48,
  "end": 48,
  "position": 548
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۴۹",
  "start": 49,
  "end": 49,
  "position": 549
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۵۰",
  "start": 50,
  "end": 50,
  "position": 550
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۵۱",
  "start": 51,
  "end": 51,
  "position": 551
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۵۲",
  "start": 52,
  "end": 52,
  "position": 552
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۵۳",
  "start": 53,
  "end": 53,
  "position": 553
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۵۴",
  "start": 54,
  "end": 54,
  "position": 554
 },
 {
  "chapter": "پودمان ۴: برنامه‌نویسی پایتون (۳)",
  "title": "مطالعه صفحه ۵۵",
  "start": 55,
  "end": 55,
  "position": 555
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "کل پودمان",
  "start": 57,
  "end": 69,
  "position": 1
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مقدمه",
  "start": 58,
  "end": 59,
  "position": 100
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "هدایت تحصیلی ـ حرفه‌ای",
  "start": 60,
  "end": 61,
  "position": 101
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "گام اول: شناخت خود",
  "start": 62,
  "end": 65,
  "position": 102
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "گام دوم: شناخت نیازهای جامعه",
  "start": 66,
  "end": 66,
  "position": 103
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "گام سوم: شناخت محیط",
  "start": 67,
  "end": 67,
  "position": 104
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "پروژه انتخاب رشته تحصیلی ـ حرفه‌ای",
  "start": 68,
  "end": 68,
  "position": 105
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "خودارزیابی پروژه",
  "start": 69,
  "end": 69,
  "position": 106
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۵۷",
  "start": 57,
  "end": 57,
  "position": 557
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۵۸",
  "start": 58,
  "end": 58,
  "position": 558
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۵۹",
  "start": 59,
  "end": 59,
  "position": 559
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۶۰",
  "start": 60,
  "end": 60,
  "position": 560
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۶۱",
  "start": 61,
  "end": 61,
  "position": 561
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۶۲",
  "start": 62,
  "end": 62,
  "position": 562
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۶۳",
  "start": 63,
  "end": 63,
  "position": 563
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۶۴",
  "start": 64,
  "end": 64,
  "position": 564
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۶۵",
  "start": 65,
  "end": 65,
  "position": 565
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۶۶",
  "start": 66,
  "end": 66,
  "position": 566
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۶۷",
  "start": 67,
  "end": 67,
  "position": 567
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۶۸",
  "start": 68,
  "end": 68,
  "position": 568
 },
 {
  "chapter": "پودمان ۵: هدایت تحصیلی ـ حرفه‌ای",
  "title": "مطالعه صفحه ۶۹",
  "start": 69,
  "end": 69,
  "position": 569
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "کل پودمان",
  "start": 73,
  "end": 86,
  "position": 1
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "ایمنی کار با برق",
  "start": 75,
  "end": 76,
  "position": 100
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "نقشه برق ساختمان",
  "start": 77,
  "end": 77,
  "position": 101
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "سیم‌کشی کلید یک‌پل، لامپ و پریز",
  "start": 78,
  "end": 83,
  "position": 102
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "سیم‌کشی کلید تبدیل، لامپ و پریز",
  "start": 84,
  "end": 85,
  "position": 103
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "خودارزیابی پروژه",
  "start": 86,
  "end": 86,
  "position": 104
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۷۳",
  "start": 73,
  "end": 73,
  "position": 573
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۷۴",
  "start": 74,
  "end": 74,
  "position": 574
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۷۵",
  "start": 75,
  "end": 75,
  "position": 575
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۷۶",
  "start": 76,
  "end": 76,
  "position": 576
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۷۷",
  "start": 77,
  "end": 77,
  "position": 577
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۷۸",
  "start": 78,
  "end": 78,
  "position": 578
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۷۹",
  "start": 79,
  "end": 79,
  "position": 579
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۸۰",
  "start": 80,
  "end": 80,
  "position": 580
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۸۱",
  "start": 81,
  "end": 81,
  "position": 581
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۸۲",
  "start": 82,
  "end": 82,
  "position": 582
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۸۳",
  "start": 83,
  "end": 83,
  "position": 583
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۸۴",
  "start": 84,
  "end": 84,
  "position": 584
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۸۵",
  "start": 85,
  "end": 85,
  "position": 585
 },
 {
  "chapter": "پودمان ۶: برق",
  "title": "مطالعه صفحه ۸۶",
  "start": 86,
  "end": 86,
  "position": 586
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "کل پودمان",
  "start": 87,
  "end": 100,
  "position": 1
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "ایمنی تأسیسات مکانیکی",
  "start": 89,
  "end": 89,
  "position": 100
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "تعویض شیر آب",
  "start": 90,
  "end": 92,
  "position": 101
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "رفع گرفتگی لوله آبراهه ظرف‌شویی",
  "start": 93,
  "end": 93,
  "position": 102
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "آب‌بندی فلاش‌تانک",
  "start": 94,
  "end": 95,
  "position": 103
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "سرویس دوره‌ای کولر آبی",
  "start": 96,
  "end": 99,
  "position": 104
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "خودارزیابی پروژه",
  "start": 100,
  "end": 100,
  "position": 105
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۸۷",
  "start": 87,
  "end": 87,
  "position": 587
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۸۸",
  "start": 88,
  "end": 88,
  "position": 588
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۸۹",
  "start": 89,
  "end": 89,
  "position": 589
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۹۰",
  "start": 90,
  "end": 90,
  "position": 590
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۹۱",
  "start": 91,
  "end": 91,
  "position": 591
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۹۲",
  "start": 92,
  "end": 92,
  "position": 592
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۹۳",
  "start": 93,
  "end": 93,
  "position": 593
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۹۴",
  "start": 94,
  "end": 94,
  "position": 594
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۹۵",
  "start": 95,
  "end": 95,
  "position": 595
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۹۶",
  "start": 96,
  "end": 96,
  "position": 596
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۹۷",
  "start": 97,
  "end": 97,
  "position": 597
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۹۸",
  "start": 98,
  "end": 98,
  "position": 598
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۹۹",
  "start": 99,
  "end": 99,
  "position": 599
 },
 {
  "chapter": "پودمان ۷: تأسیسات مکانیکی",
  "title": "مطالعه صفحه ۱۰۰",
  "start": 100,
  "end": 100,
  "position": 600
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "کل پودمان",
  "start": 101,
  "end": 114,
  "position": 1
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "آجر و ابعاد آن",
  "start": 103,
  "end": 103,
  "position": 100
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "اجزای آجر",
  "start": 104,
  "end": 105,
  "position": 101
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "نکات ایمنی",
  "start": 106,
  "end": 106,
  "position": 102
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "ساخت دیوار نیم‌آجری راسته‌نما",
  "start": 107,
  "end": 107,
  "position": 103
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "ساخت دیوار یک‌آجری کله‌نما",
  "start": 108,
  "end": 108,
  "position": 104
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "ساخت دیوار یک‌آجری کله و راسته",
  "start": 109,
  "end": 110,
  "position": 105
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "ساخت قطعات گچی و کنده‌کاری",
  "start": 111,
  "end": 111,
  "position": 106
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "لکه‌گیری و رنگ‌آمیزی دیوار گچی",
  "start": 112,
  "end": 113,
  "position": 107
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "خودارزیابی پروژه",
  "start": 114,
  "end": 114,
  "position": 108
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۰۱",
  "start": 101,
  "end": 101,
  "position": 601
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۰۲",
  "start": 102,
  "end": 102,
  "position": 602
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۰۳",
  "start": 103,
  "end": 103,
  "position": 603
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۰۴",
  "start": 104,
  "end": 104,
  "position": 604
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۰۵",
  "start": 105,
  "end": 105,
  "position": 605
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۰۶",
  "start": 106,
  "end": 106,
  "position": 606
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۰۷",
  "start": 107,
  "end": 107,
  "position": 607
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۰۸",
  "start": 108,
  "end": 108,
  "position": 608
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۰۹",
  "start": 109,
  "end": 109,
  "position": 609
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۱۰",
  "start": 110,
  "end": 110,
  "position": 610
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۱۱",
  "start": 111,
  "end": 111,
  "position": 611
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۱۲",
  "start": 112,
  "end": 112,
  "position": 612
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۱۳",
  "start": 113,
  "end": 113,
  "position": 613
 },
 {
  "chapter": "پودمان ۸: عمران",
  "title": "مطالعه صفحه ۱۱۴",
  "start": 114,
  "end": 114,
  "position": 614
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "کل پودمان",
  "start": 115,
  "end": 128,
  "position": 1
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "بازدید سطح مایع خنک‌کننده",
  "start": 118,
  "end": 118,
  "position": 100
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "بررسی سطح مایع ترمز",
  "start": 119,
  "end": 119,
  "position": 101
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "بررسی روغن موتور",
  "start": 120,
  "end": 120,
  "position": 102
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "بررسی مایع باتری",
  "start": 121,
  "end": 121,
  "position": 103
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مایع شیشه‌شوی و چراغ‌های هشداردهنده",
  "start": 122,
  "end": 122,
  "position": 104
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "بررسی فیوزها",
  "start": 123,
  "end": 123,
  "position": 105
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "بررسی تایرها",
  "start": 124,
  "end": 124,
  "position": 106
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "تعویض چرخ پنچر",
  "start": 125,
  "end": 125,
  "position": 107
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "بستن زنجیر چرخ",
  "start": 126,
  "end": 127,
  "position": 108
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "خودارزیابی پروژه",
  "start": 128,
  "end": 128,
  "position": 109
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۱۵",
  "start": 115,
  "end": 115,
  "position": 615
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۱۶",
  "start": 116,
  "end": 116,
  "position": 616
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۱۷",
  "start": 117,
  "end": 117,
  "position": 617
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۱۸",
  "start": 118,
  "end": 118,
  "position": 618
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۱۹",
  "start": 119,
  "end": 119,
  "position": 619
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۲۰",
  "start": 120,
  "end": 120,
  "position": 620
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۲۱",
  "start": 121,
  "end": 121,
  "position": 621
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۲۲",
  "start": 122,
  "end": 122,
  "position": 622
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۲۳",
  "start": 123,
  "end": 123,
  "position": 623
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۲۴",
  "start": 124,
  "end": 124,
  "position": 624
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۲۵",
  "start": 125,
  "end": 125,
  "position": 625
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۲۶",
  "start": 126,
  "end": 126,
  "position": 626
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۲۷",
  "start": 127,
  "end": 127,
  "position": 627
 },
 {
  "chapter": "پودمان ۹: خودرو",
  "title": "مطالعه صفحه ۱۲۸",
  "start": 128,
  "end": 128,
  "position": 628
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "کل پودمان",
  "start": 129,
  "end": 140,
  "position": 1
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "پایش رشد و تکامل کودک",
  "start": 132,
  "end": 132,
  "position": 100
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "اندازه‌گیری قد و محیط بدن",
  "start": 133,
  "end": 133,
  "position": 101
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "اندازه‌گیری دور بازو و شاخص‌های رشد",
  "start": 134,
  "end": 139,
  "position": 102
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "خودارزیابی پروژه",
  "start": 140,
  "end": 140,
  "position": 103
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۲۹",
  "start": 129,
  "end": 129,
  "position": 629
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۳۰",
  "start": 130,
  "end": 130,
  "position": 630
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۳۱",
  "start": 131,
  "end": 131,
  "position": 631
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۳۲",
  "start": 132,
  "end": 132,
  "position": 632
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۳۳",
  "start": 133,
  "end": 133,
  "position": 633
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۳۴",
  "start": 134,
  "end": 134,
  "position": 634
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۳۵",
  "start": 135,
  "end": 135,
  "position": 635
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۳۶",
  "start": 136,
  "end": 136,
  "position": 636
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۳۷",
  "start": 137,
  "end": 137,
  "position": 637
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۳۸",
  "start": 138,
  "end": 138,
  "position": 638
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۳۹",
  "start": 139,
  "end": 139,
  "position": 639
 },
 {
  "chapter": "پودمان ۱۰: پایش رشد و تکامل کودک",
  "title": "مطالعه صفحه ۱۴۰",
  "start": 140,
  "end": 140,
  "position": 640
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "کل پودمان",
  "start": 141,
  "end": 151,
  "position": 1
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "ابزار و وسایل مورد نیاز",
  "start": 143,
  "end": 143,
  "position": 100
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "ترسیم روندنما و انتقال طرح",
  "start": 144,
  "end": 144,
  "position": 101
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "برجسته‌کاری",
  "start": 145,
  "end": 145,
  "position": 102
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "بافت",
  "start": 146,
  "end": 146,
  "position": 103
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "پتینه پلاک مسی",
  "start": 147,
  "end": 149,
  "position": 104
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "پروژه‌های نیمه‌تجویزی",
  "start": 150,
  "end": 150,
  "position": 105
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "خودارزیابی پروژه",
  "start": 151,
  "end": 151,
  "position": 106
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "مطالعه صفحه ۱۴۱",
  "start": 141,
  "end": 141,
  "position": 641
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "مطالعه صفحه ۱۴۲",
  "start": 142,
  "end": 142,
  "position": 642
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "مطالعه صفحه ۱۴۳",
  "start": 143,
  "end": 143,
  "position": 643
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "مطالعه صفحه ۱۴۴",
  "start": 144,
  "end": 144,
  "position": 644
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "مطالعه صفحه ۱۴۵",
  "start": 145,
  "end": 145,
  "position": 645
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "مطالعه صفحه ۱۴۶",
  "start": 146,
  "end": 146,
  "position": 646
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "مطالعه صفحه ۱۴۷",
  "start": 147,
  "end": 147,
  "position": 647
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "مطالعه صفحه ۱۴۸",
  "start": 148,
  "end": 148,
  "position": 648
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "مطالعه صفحه ۱۴۹",
  "start": 149,
  "end": 149,
  "position": 649
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "مطالعه صفحه ۱۵۰",
  "start": 150,
  "end": 150,
  "position": 650
 },
 {
  "chapter": "پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس)",
  "title": "مطالعه صفحه ۱۵۱",
  "start": 151,
  "end": 151,
  "position": 651
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v214:all:9:final_exam:کار و فناوری:'||p.chapter||':'||p.position)::uuid,'1405','all','9','final_exam','کار و فناوری',p.chapter,p.title,p.start,p."end",p.position from topics p cross join installed on conflict(id) do nothing;
