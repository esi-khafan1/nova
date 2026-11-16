-- Religion and Life 1 (110204/110205), first printing 1405, user PDFs.
-- Named headings and page-sized selections; field-specific books are kept separate.
with installed as (insert into private.planner_seed_installations(seed_key) values ('religion10-1405-v209') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "کل درس",
  "start": 2,
  "end": 11,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "جهان هدفمند",
  "start": 3,
  "end": 3,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "اختلاف در انتخاب هدف",
  "start": 4,
  "end": 6,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "معیارهای انتخاب هدف‌های اصلی",
  "start": 7,
  "end": 8,
  "position": 102
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "برترین هدف",
  "start": 9,
  "end": 11,
  "position": 103
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۲",
  "start": 2,
  "end": 2,
  "position": 502
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۳",
  "start": 3,
  "end": 3,
  "position": 503
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۴",
  "start": 4,
  "end": 4,
  "position": 504
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۵",
  "start": 5,
  "end": 5,
  "position": 505
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۶",
  "start": 6,
  "end": 6,
  "position": 506
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۷",
  "start": 7,
  "end": 7,
  "position": 507
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۸",
  "start": 8,
  "end": 8,
  "position": 508
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۹",
  "start": 9,
  "end": 9,
  "position": 509
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۱۰",
  "start": 10,
  "end": 10,
  "position": 510
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۱۱",
  "start": 11,
  "end": 11,
  "position": 511
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "کل درس",
  "start": 12,
  "end": 21,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "سرمایه‌های انسان",
  "start": 14,
  "end": 15,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "تناسب میان سرمایه‌ها و هدف زندگی",
  "start": 16,
  "end": 18,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "موانع راه",
  "start": 19,
  "end": 21,
  "position": 102
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۳",
  "start": 13,
  "end": 13,
  "position": 513
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۴",
  "start": 14,
  "end": 14,
  "position": 514
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۵",
  "start": 15,
  "end": 15,
  "position": 515
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۶",
  "start": 16,
  "end": 16,
  "position": 516
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۷",
  "start": 17,
  "end": 17,
  "position": 517
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۸",
  "start": 18,
  "end": 18,
  "position": 518
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۹",
  "start": 19,
  "end": 19,
  "position": 519
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۲۰",
  "start": 20,
  "end": 20,
  "position": 520
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۲۱",
  "start": 21,
  "end": 21,
  "position": 521
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "کل درس",
  "start": 22,
  "end": 32,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "دو نگاه درباره آینده انسان",
  "start": 24,
  "end": 24,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "آثار نگاه به مرگ به عنوان گذر به حیات جدید",
  "start": 25,
  "end": 28,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "نگاه پایان‌پذیری زندگی با مرگ و آثار آن",
  "start": 29,
  "end": 30,
  "position": 102
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "غفلت از زندگی پس از مرگ",
  "start": 31,
  "end": 32,
  "position": 103
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "مطالعه صفحه ۲۳",
  "start": 23,
  "end": 23,
  "position": 523
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "مطالعه صفحه ۲۴",
  "start": 24,
  "end": 24,
  "position": 524
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "مطالعه صفحه ۲۵",
  "start": 25,
  "end": 25,
  "position": 525
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "مطالعه صفحه ۲۶",
  "start": 26,
  "end": 26,
  "position": 526
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "مطالعه صفحه ۲۷",
  "start": 27,
  "end": 27,
  "position": 527
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "مطالعه صفحه ۲۸",
  "start": 28,
  "end": 28,
  "position": 528
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "مطالعه صفحه ۲۹",
  "start": 29,
  "end": 29,
  "position": 529
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "مطالعه صفحه ۳۰",
  "start": 30,
  "end": 30,
  "position": 530
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "مطالعه صفحه ۳۱",
  "start": 31,
  "end": 31,
  "position": 531
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: به سوی جاودانگی",
  "title": "مطالعه صفحه ۳۲",
  "start": 32,
  "end": 32,
  "position": 532
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "کل درس",
  "start": 33,
  "end": 41,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "اهمیت اندیشیدن به معاد و دفع خطر احتمالی",
  "start": 35,
  "end": 35,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "دلایل امکان معاد",
  "start": 36,
  "end": 36,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "دلایل ضرورت معاد",
  "start": 37,
  "end": 38,
  "position": 102
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "پرسش درباره بازگشت از مرگ",
  "start": 39,
  "end": 41,
  "position": 103
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "مطالعه صفحه ۳۴",
  "start": 34,
  "end": 34,
  "position": 534
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "مطالعه صفحه ۳۵",
  "start": 35,
  "end": 35,
  "position": 535
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "مطالعه صفحه ۳۶",
  "start": 36,
  "end": 36,
  "position": 536
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "مطالعه صفحه ۳۷",
  "start": 37,
  "end": 37,
  "position": 537
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "مطالعه صفحه ۳۸",
  "start": 38,
  "end": 38,
  "position": 538
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "مطالعه صفحه ۳۹",
  "start": 39,
  "end": 39,
  "position": 539
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "مطالعه صفحه ۴۰",
  "start": 40,
  "end": 40,
  "position": 540
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: آینده روشن",
  "title": "مطالعه صفحه ۴۱",
  "start": 41,
  "end": 41,
  "position": 541
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "کل درس",
  "start": 42,
  "end": 49,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "عالم برزخ و ویژگی‌های آن",
  "start": 44,
  "end": 44,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "ارتباط عالم برزخ و دنیا",
  "start": 45,
  "end": 45,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "آثار باقی‌مانده از اعمال",
  "start": 46,
  "end": 46,
  "position": 102
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "خیرات بازماندگان",
  "start": 47,
  "end": 47,
  "position": 103
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "پرسش درباره فشار قبر",
  "start": 48,
  "end": 49,
  "position": 104
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "مطالعه صفحه ۴۳",
  "start": 43,
  "end": 43,
  "position": 543
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "مطالعه صفحه ۴۴",
  "start": 44,
  "end": 44,
  "position": 544
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "مطالعه صفحه ۴۵",
  "start": 45,
  "end": 45,
  "position": 545
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "مطالعه صفحه ۴۶",
  "start": 46,
  "end": 46,
  "position": 546
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "مطالعه صفحه ۴۷",
  "start": 47,
  "end": 47,
  "position": 547
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "مطالعه صفحه ۴۸",
  "start": 48,
  "end": 48,
  "position": 548
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: منزلگاه بعد",
  "title": "مطالعه صفحه ۴۹",
  "start": 49,
  "end": 49,
  "position": 549
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: واقعه بزرگ",
  "title": "کل درس",
  "start": 50,
  "end": 57,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: واقعه بزرگ",
  "title": "مرحله اول و دوم قیامت",
  "start": 52,
  "end": 52,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: واقعه بزرگ",
  "title": "آشکار شدن حقایق و رسیدگی به اعمال",
  "start": 53,
  "end": 54,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: واقعه بزرگ",
  "title": "گرفتن کارنامه اعمال",
  "start": 55,
  "end": 57,
  "position": 102
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: واقعه بزرگ",
  "title": "مطالعه صفحه ۵۱",
  "start": 51,
  "end": 51,
  "position": 551
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: واقعه بزرگ",
  "title": "مطالعه صفحه ۵۲",
  "start": 52,
  "end": 52,
  "position": 552
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: واقعه بزرگ",
  "title": "مطالعه صفحه ۵۳",
  "start": 53,
  "end": 53,
  "position": 553
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: واقعه بزرگ",
  "title": "مطالعه صفحه ۵۴",
  "start": 54,
  "end": 54,
  "position": 554
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: واقعه بزرگ",
  "title": "مطالعه صفحه ۵۵",
  "start": 55,
  "end": 55,
  "position": 555
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: واقعه بزرگ",
  "title": "مطالعه صفحه ۵۶",
  "start": 56,
  "end": 56,
  "position": 556
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: واقعه بزرگ",
  "title": "مطالعه صفحه ۵۷",
  "start": 57,
  "end": 57,
  "position": 557
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "کل درس",
  "start": 58,
  "end": 69,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "جایگاه دوزخیان",
  "start": 60,
  "end": 63,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "جایگاه نیکوکاران",
  "start": 64,
  "end": 64,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "زندگی بهشتی و دل‌زدگی",
  "start": 65,
  "end": 65,
  "position": 102
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "رابطه عمل و پاداش و کیفر",
  "start": 66,
  "end": 69,
  "position": 103
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "مطالعه صفحه ۵۹",
  "start": 59,
  "end": 59,
  "position": 559
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "مطالعه صفحه ۶۰",
  "start": 60,
  "end": 60,
  "position": 560
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "مطالعه صفحه ۶۱",
  "start": 61,
  "end": 61,
  "position": 561
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "مطالعه صفحه ۶۲",
  "start": 62,
  "end": 62,
  "position": 562
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "مطالعه صفحه ۶۳",
  "start": 63,
  "end": 63,
  "position": 563
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "مطالعه صفحه ۶۴",
  "start": 64,
  "end": 64,
  "position": 564
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "مطالعه صفحه ۶۵",
  "start": 65,
  "end": 65,
  "position": 565
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "مطالعه صفحه ۶۶",
  "start": 66,
  "end": 66,
  "position": 566
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "مطالعه صفحه ۶۷",
  "start": 67,
  "end": 67,
  "position": 567
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "مطالعه صفحه ۶۸",
  "start": 68,
  "end": 68,
  "position": 568
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: فرجام کار",
  "title": "مطالعه صفحه ۶۹",
  "start": 69,
  "end": 69,
  "position": 569
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "کل درس",
  "start": 70,
  "end": 82,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "عهد بستن با خدا",
  "start": 72,
  "end": 72,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "تدبر در آیات",
  "start": 73,
  "end": 74,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مراقبت و وفای به عهد",
  "start": 75,
  "end": 76,
  "position": 102
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "پیامبر و اهل‌بیت به عنوان الگو",
  "start": 77,
  "end": 78,
  "position": 103
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "دفتر برنامه‌ریزی",
  "start": 79,
  "end": 79,
  "position": 104
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "ساخت عادت خوب و ترک عادت نادرست",
  "start": 80,
  "end": 82,
  "position": 105
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۷۰",
  "start": 70,
  "end": 70,
  "position": 570
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۷۱",
  "start": 71,
  "end": 71,
  "position": 571
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۷۲",
  "start": 72,
  "end": 72,
  "position": 572
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۷۳",
  "start": 73,
  "end": 73,
  "position": 573
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۷۴",
  "start": 74,
  "end": 74,
  "position": 574
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۷۵",
  "start": 75,
  "end": 75,
  "position": 575
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۷۶",
  "start": 76,
  "end": 76,
  "position": 576
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۷۷",
  "start": 77,
  "end": 77,
  "position": 577
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۷۸",
  "start": 78,
  "end": 78,
  "position": 578
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۷۹",
  "start": 79,
  "end": 79,
  "position": 579
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۸۰",
  "start": 80,
  "end": 80,
  "position": 580
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۸۱",
  "start": 81,
  "end": 81,
  "position": 581
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: آهنگ سفر",
  "title": "مطالعه صفحه ۸۲",
  "start": 82,
  "end": 82,
  "position": 582
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: اعتماد بر او",
  "title": "کل درس",
  "start": 83,
  "end": 88,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: اعتماد بر او",
  "title": "حقیقت توکل بر خدا",
  "start": 85,
  "end": 85,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: اعتماد بر او",
  "title": "شرایط توکل",
  "start": 86,
  "end": 88,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: اعتماد بر او",
  "title": "مطالعه صفحه ۸۴",
  "start": 84,
  "end": 84,
  "position": 584
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: اعتماد بر او",
  "title": "مطالعه صفحه ۸۵",
  "start": 85,
  "end": 85,
  "position": 585
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: اعتماد بر او",
  "title": "مطالعه صفحه ۸۶",
  "start": 86,
  "end": 86,
  "position": 586
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: اعتماد بر او",
  "title": "مطالعه صفحه ۸۷",
  "start": 87,
  "end": 87,
  "position": 587
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: اعتماد بر او",
  "title": "مطالعه صفحه ۸۸",
  "start": 88,
  "end": 88,
  "position": 588
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "کل درس",
  "start": 89,
  "end": 103,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "نماز و بازدارندگی از گناه",
  "start": 92,
  "end": 94,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "تکمیل احکام نماز",
  "start": 95,
  "end": 98,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "روزه و تقوا",
  "start": 99,
  "end": 100,
  "position": 102
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "احکام روزه",
  "start": 101,
  "end": 103,
  "position": 103
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۸۹",
  "start": 89,
  "end": 89,
  "position": 589
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۹۰",
  "start": 90,
  "end": 90,
  "position": 590
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۹۱",
  "start": 91,
  "end": 91,
  "position": 591
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۹۲",
  "start": 92,
  "end": 92,
  "position": 592
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۹۳",
  "start": 93,
  "end": 93,
  "position": 593
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۹۴",
  "start": 94,
  "end": 94,
  "position": 594
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۹۵",
  "start": 95,
  "end": 95,
  "position": 595
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۹۶",
  "start": 96,
  "end": 96,
  "position": 596
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۹۷",
  "start": 97,
  "end": 97,
  "position": 597
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۹۸",
  "start": 98,
  "end": 98,
  "position": 598
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۹۹",
  "start": 99,
  "end": 99,
  "position": 599
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۰",
  "start": 100,
  "end": 100,
  "position": 600
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۱",
  "start": 101,
  "end": 101,
  "position": 601
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۲",
  "start": 102,
  "end": 102,
  "position": 602
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۳",
  "start": 103,
  "end": 103,
  "position": 603
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "کل درس",
  "start": 104,
  "end": 116,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "آراستگی در سبک زندگی مؤمنانه",
  "start": 107,
  "end": 108,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "نیاز به مقبولیت و آراستگی",
  "start": 109,
  "end": 111,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "عفاف و آراستگی",
  "start": 112,
  "end": 113,
  "position": 102
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "معنای گسترده آراستگی و حیا",
  "start": 114,
  "end": 116,
  "position": 103
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۰۵",
  "start": 105,
  "end": 105,
  "position": 605
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۰۶",
  "start": 106,
  "end": 106,
  "position": 606
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۰۷",
  "start": 107,
  "end": 107,
  "position": 607
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۰۸",
  "start": 108,
  "end": 108,
  "position": 608
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۰۹",
  "start": 109,
  "end": 109,
  "position": 609
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۰",
  "start": 110,
  "end": 110,
  "position": 610
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۱",
  "start": 111,
  "end": 111,
  "position": 611
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۲",
  "start": 112,
  "end": 112,
  "position": 612
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۳",
  "start": 113,
  "end": 113,
  "position": 613
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۴",
  "start": 114,
  "end": 114,
  "position": 614
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۵",
  "start": 115,
  "end": 115,
  "position": 615
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۶",
  "start": 116,
  "end": 116,
  "position": 616
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "کل درس",
  "start": 117,
  "end": 125,
  "position": 1
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "حجاب در سایر ادیان",
  "start": 119,
  "end": 119,
  "position": 100
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "دستور قرآن درباره عفاف و پوشیدگی",
  "start": 120,
  "end": 121,
  "position": 101
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "شکل پوشش در اسلام و حضور زنان در جامعه",
  "start": 122,
  "end": 125,
  "position": 102
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۱۸",
  "start": 118,
  "end": 118,
  "position": 618
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۱۹",
  "start": 119,
  "end": 119,
  "position": 619
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۲۰",
  "start": 120,
  "end": 120,
  "position": 620
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۲۱",
  "start": 121,
  "end": 121,
  "position": 621
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۲۲",
  "start": 122,
  "end": 122,
  "position": 622
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۲۳",
  "start": 123,
  "end": 123,
  "position": 623
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۲۴",
  "start": 124,
  "end": 124,
  "position": 624
 },
 {
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۲۵",
  "start": 125,
  "end": 125,
  "position": 625
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "کل درس",
  "start": 2,
  "end": 11,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "جهان هدفمند",
  "start": 3,
  "end": 3,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "اختلاف در انتخاب هدف",
  "start": 4,
  "end": 6,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "معیارهای انتخاب هدف‌های اصلی",
  "start": 7,
  "end": 8,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "برترین هدف",
  "start": 9,
  "end": 11,
  "position": 103
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۲",
  "start": 2,
  "end": 2,
  "position": 502
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۳",
  "start": 3,
  "end": 3,
  "position": 503
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۴",
  "start": 4,
  "end": 4,
  "position": 504
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۵",
  "start": 5,
  "end": 5,
  "position": 505
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۶",
  "start": 6,
  "end": 6,
  "position": 506
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۷",
  "start": 7,
  "end": 7,
  "position": 507
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۸",
  "start": 8,
  "end": 8,
  "position": 508
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۹",
  "start": 9,
  "end": 9,
  "position": 509
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۱۰",
  "start": 10,
  "end": 10,
  "position": 510
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱: هدف زندگی",
  "title": "مطالعه صفحه ۱۱",
  "start": 11,
  "end": 11,
  "position": 511
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "کل درس",
  "start": 12,
  "end": 21,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "سرمایه‌های انسان",
  "start": 14,
  "end": 15,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "تناسب میان سرمایه‌ها و هدف زندگی",
  "start": 16,
  "end": 18,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "موانع راه",
  "start": 19,
  "end": 21,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۲",
  "start": 12,
  "end": 12,
  "position": 512
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۳",
  "start": 13,
  "end": 13,
  "position": 513
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۴",
  "start": 14,
  "end": 14,
  "position": 514
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۵",
  "start": 15,
  "end": 15,
  "position": 515
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۶",
  "start": 16,
  "end": 16,
  "position": 516
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۷",
  "start": 17,
  "end": 17,
  "position": 517
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۸",
  "start": 18,
  "end": 18,
  "position": 518
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۱۹",
  "start": 19,
  "end": 19,
  "position": 519
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۲۰",
  "start": 20,
  "end": 20,
  "position": 520
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۲: قدرت پرواز",
  "title": "مطالعه صفحه ۲۱",
  "start": 21,
  "end": 21,
  "position": 521
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۳: خود حقیقی",
  "title": "کل درس",
  "start": 22,
  "end": 28,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۳: خود حقیقی",
  "title": "ابعاد جسمانی و روحانی انسان و ثبات خود",
  "start": 24,
  "end": 26,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۳: خود حقیقی",
  "title": "خواب و رؤیا",
  "start": 27,
  "end": 27,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۳: خود حقیقی",
  "title": "بررسی رؤیاهای صادقه",
  "start": 28,
  "end": 28,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۳: خود حقیقی",
  "title": "مطالعه صفحه ۲۲",
  "start": 22,
  "end": 22,
  "position": 522
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۳: خود حقیقی",
  "title": "مطالعه صفحه ۲۳",
  "start": 23,
  "end": 23,
  "position": 523
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۳: خود حقیقی",
  "title": "مطالعه صفحه ۲۴",
  "start": 24,
  "end": 24,
  "position": 524
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۳: خود حقیقی",
  "title": "مطالعه صفحه ۲۵",
  "start": 25,
  "end": 25,
  "position": 525
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۳: خود حقیقی",
  "title": "مطالعه صفحه ۲۶",
  "start": 26,
  "end": 26,
  "position": 526
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۳: خود حقیقی",
  "title": "مطالعه صفحه ۲۷",
  "start": 27,
  "end": 27,
  "position": 527
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۳: خود حقیقی",
  "title": "مطالعه صفحه ۲۸",
  "start": 28,
  "end": 28,
  "position": 528
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "کل درس",
  "start": 29,
  "end": 37,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "حتمی بودن مرگ و اندیشه‌های گوناگون",
  "start": 31,
  "end": 31,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "نیست‌انگاری و آثار آن",
  "start": 32,
  "end": 33,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "تناسخ و باور به معاد",
  "start": 34,
  "end": 34,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "معنابخشی و ارزشمندی زندگی",
  "start": 35,
  "end": 35,
  "position": 103
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "اخلاق، مسئولیت در برابر عمل و نهراسیدن از مرگ",
  "start": 36,
  "end": 37,
  "position": 104
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "مطالعه صفحه ۲۹",
  "start": 29,
  "end": 29,
  "position": 529
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "مطالعه صفحه ۳۰",
  "start": 30,
  "end": 30,
  "position": 530
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "مطالعه صفحه ۳۱",
  "start": 31,
  "end": 31,
  "position": 531
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "مطالعه صفحه ۳۲",
  "start": 32,
  "end": 32,
  "position": 532
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "مطالعه صفحه ۳۳",
  "start": 33,
  "end": 33,
  "position": 533
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "مطالعه صفحه ۳۴",
  "start": 34,
  "end": 34,
  "position": 534
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "مطالعه صفحه ۳۵",
  "start": 35,
  "end": 35,
  "position": 535
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "مطالعه صفحه ۳۶",
  "start": 36,
  "end": 36,
  "position": 536
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۴: چیستی مرگ",
  "title": "مطالعه صفحه ۳۷",
  "start": 37,
  "end": 37,
  "position": 537
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "کل درس",
  "start": 38,
  "end": 45,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "احتضار و سکرات موت",
  "start": 40,
  "end": 40,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "توصیف مرگ مؤمنان و کافران",
  "start": 41,
  "end": 42,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "شهادت",
  "start": 43,
  "end": 43,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "شرط شهادت",
  "start": 44,
  "end": 45,
  "position": 103
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "مطالعه صفحه ۳۸",
  "start": 38,
  "end": 38,
  "position": 538
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "مطالعه صفحه ۳۹",
  "start": 39,
  "end": 39,
  "position": 539
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "مطالعه صفحه ۴۰",
  "start": 40,
  "end": 40,
  "position": 540
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "مطالعه صفحه ۴۱",
  "start": 41,
  "end": 41,
  "position": 541
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "مطالعه صفحه ۴۲",
  "start": 42,
  "end": 42,
  "position": 542
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "مطالعه صفحه ۴۳",
  "start": 43,
  "end": 43,
  "position": 543
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "مطالعه صفحه ۴۴",
  "start": 44,
  "end": 44,
  "position": 544
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۵: چگونگی مرگ",
  "title": "مطالعه صفحه ۴۵",
  "start": 45,
  "end": 45,
  "position": 545
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "کل درس",
  "start": 46,
  "end": 54,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "اهمیت اندیشیدن به معاد و دفع خطر احتمالی",
  "start": 48,
  "end": 48,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "دلایل امکان معاد",
  "start": 49,
  "end": 49,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "دلایل ضرورت معاد",
  "start": 50,
  "end": 51,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "پرسش درباره بازگشت از مرگ",
  "start": 52,
  "end": 54,
  "position": 103
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "مطالعه صفحه ۴۶",
  "start": 46,
  "end": 46,
  "position": 546
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "مطالعه صفحه ۴۷",
  "start": 47,
  "end": 47,
  "position": 547
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "مطالعه صفحه ۴۸",
  "start": 48,
  "end": 48,
  "position": 548
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "مطالعه صفحه ۴۹",
  "start": 49,
  "end": 49,
  "position": 549
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "مطالعه صفحه ۵۰",
  "start": 50,
  "end": 50,
  "position": 550
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "مطالعه صفحه ۵۱",
  "start": 51,
  "end": 51,
  "position": 551
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "مطالعه صفحه ۵۲",
  "start": 52,
  "end": 52,
  "position": 552
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "مطالعه صفحه ۵۳",
  "start": 53,
  "end": 53,
  "position": 553
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۶: آینده روشن",
  "title": "مطالعه صفحه ۵۴",
  "start": 54,
  "end": 54,
  "position": 554
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "کل درس",
  "start": 55,
  "end": 66,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "ویژگی‌های عالم پس از مرگ",
  "start": 57,
  "end": 57,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "خلوص لذت و رنج اخروی",
  "start": 58,
  "end": 58,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "پاداش و کیفر طبیعی",
  "start": 59,
  "end": 59,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "عوامل بهشتی یا جهنمی شدن انسان",
  "start": 60,
  "end": 61,
  "position": 103
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "عالم برزخ و ارتباط آن با دنیا",
  "start": 62,
  "end": 62,
  "position": 104
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "آثار باقی‌مانده از اعمال",
  "start": 63,
  "end": 63,
  "position": 105
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "خیرات بازماندگان",
  "start": 64,
  "end": 66,
  "position": 106
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۵۵",
  "start": 55,
  "end": 55,
  "position": 555
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۵۶",
  "start": 56,
  "end": 56,
  "position": 556
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۵۷",
  "start": 57,
  "end": 57,
  "position": 557
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۵۸",
  "start": 58,
  "end": 58,
  "position": 558
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۵۹",
  "start": 59,
  "end": 59,
  "position": 559
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۶۰",
  "start": 60,
  "end": 60,
  "position": 560
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۶۱",
  "start": 61,
  "end": 61,
  "position": 561
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۶۲",
  "start": 62,
  "end": 62,
  "position": 562
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۶۳",
  "start": 63,
  "end": 63,
  "position": 563
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۶۴",
  "start": 64,
  "end": 64,
  "position": 564
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۶۵",
  "start": 65,
  "end": 65,
  "position": 565
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۷: منزلگاه بعد",
  "title": "مطالعه صفحه ۶۶",
  "start": 66,
  "end": 66,
  "position": 566
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "کل درس",
  "start": 67,
  "end": 79,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مرحله اول و دوم قیامت",
  "start": 69,
  "end": 69,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "زنده شدن انسان‌ها و آشکار شدن حقایق",
  "start": 70,
  "end": 70,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "کارنامه و پاداش و کیفر اعمال",
  "start": 71,
  "end": 74,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "جایگاه دوزخیان",
  "start": 75,
  "end": 75,
  "position": 103
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "جایگاه نیکوکاران",
  "start": 76,
  "end": 76,
  "position": 104
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "زندگی بهشتی و دل‌زدگی",
  "start": 77,
  "end": 79,
  "position": 105
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۶۷",
  "start": 67,
  "end": 67,
  "position": 567
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۶۸",
  "start": 68,
  "end": 68,
  "position": 568
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۶۹",
  "start": 69,
  "end": 69,
  "position": 569
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۷۰",
  "start": 70,
  "end": 70,
  "position": 570
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۷۱",
  "start": 71,
  "end": 71,
  "position": 571
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۷۲",
  "start": 72,
  "end": 72,
  "position": 572
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۷۳",
  "start": 73,
  "end": 73,
  "position": 573
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۷۴",
  "start": 74,
  "end": 74,
  "position": 574
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۷۵",
  "start": 75,
  "end": 75,
  "position": 575
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۷۶",
  "start": 76,
  "end": 76,
  "position": 576
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۷۷",
  "start": 77,
  "end": 77,
  "position": 577
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۷۸",
  "start": 78,
  "end": 78,
  "position": 578
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۸: فرجام کار",
  "title": "مطالعه صفحه ۷۹",
  "start": 79,
  "end": 79,
  "position": 579
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "کل درس",
  "start": 80,
  "end": 92,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "عهد بستن با خدا",
  "start": 82,
  "end": 82,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "تدبر در آیات",
  "start": 83,
  "end": 84,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مراقبت و وفای به عهد",
  "start": 85,
  "end": 86,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "پیامبر و اهل‌بیت به عنوان الگو",
  "start": 87,
  "end": 88,
  "position": 103
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "دفتر برنامه‌ریزی",
  "start": 89,
  "end": 89,
  "position": 104
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "ساخت عادت خوب و ترک عادت نادرست",
  "start": 90,
  "end": 92,
  "position": 105
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۸۰",
  "start": 80,
  "end": 80,
  "position": 580
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۸۱",
  "start": 81,
  "end": 81,
  "position": 581
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۸۲",
  "start": 82,
  "end": 82,
  "position": 582
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۸۳",
  "start": 83,
  "end": 83,
  "position": 583
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۸۴",
  "start": 84,
  "end": 84,
  "position": 584
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۸۵",
  "start": 85,
  "end": 85,
  "position": 585
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۸۶",
  "start": 86,
  "end": 86,
  "position": 586
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۸۷",
  "start": 87,
  "end": 87,
  "position": 587
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۸۸",
  "start": 88,
  "end": 88,
  "position": 588
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۸۹",
  "start": 89,
  "end": 89,
  "position": 589
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۹۰",
  "start": 90,
  "end": 90,
  "position": 590
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۹۱",
  "start": 91,
  "end": 91,
  "position": 591
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۹: آهنگ سفر",
  "title": "مطالعه صفحه ۹۲",
  "start": 92,
  "end": 92,
  "position": 592
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۰: اعتماد بر او",
  "title": "کل درس",
  "start": 93,
  "end": 98,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۰: اعتماد بر او",
  "title": "حقیقت توکل بر خدا",
  "start": 95,
  "end": 95,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۰: اعتماد بر او",
  "title": "شرایط توکل",
  "start": 96,
  "end": 98,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۰: اعتماد بر او",
  "title": "مطالعه صفحه ۹۳",
  "start": 93,
  "end": 93,
  "position": 593
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۰: اعتماد بر او",
  "title": "مطالعه صفحه ۹۴",
  "start": 94,
  "end": 94,
  "position": 594
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۰: اعتماد بر او",
  "title": "مطالعه صفحه ۹۵",
  "start": 95,
  "end": 95,
  "position": 595
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۰: اعتماد بر او",
  "title": "مطالعه صفحه ۹۶",
  "start": 96,
  "end": 96,
  "position": 596
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۰: اعتماد بر او",
  "title": "مطالعه صفحه ۹۷",
  "start": 97,
  "end": 97,
  "position": 597
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۰: اعتماد بر او",
  "title": "مطالعه صفحه ۹۸",
  "start": 98,
  "end": 98,
  "position": 598
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "کل درس",
  "start": 99,
  "end": 113,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "نماز و بازدارندگی از گناه",
  "start": 102,
  "end": 104,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "تکمیل احکام نماز",
  "start": 105,
  "end": 108,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "روزه و تقوا",
  "start": 109,
  "end": 110,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "احکام روزه",
  "start": 111,
  "end": 113,
  "position": 103
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۹۹",
  "start": 99,
  "end": 99,
  "position": 599
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۰",
  "start": 100,
  "end": 100,
  "position": 600
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۱",
  "start": 101,
  "end": 101,
  "position": 601
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۲",
  "start": 102,
  "end": 102,
  "position": 602
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۳",
  "start": 103,
  "end": 103,
  "position": 603
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۴",
  "start": 104,
  "end": 104,
  "position": 604
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۵",
  "start": 105,
  "end": 105,
  "position": 605
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۶",
  "start": 106,
  "end": 106,
  "position": 606
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۷",
  "start": 107,
  "end": 107,
  "position": 607
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۸",
  "start": 108,
  "end": 108,
  "position": 608
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۰۹",
  "start": 109,
  "end": 109,
  "position": 609
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۱۰",
  "start": 110,
  "end": 110,
  "position": 610
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۱۱",
  "start": 111,
  "end": 111,
  "position": 611
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۱۲",
  "start": 112,
  "end": 112,
  "position": 612
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۱: یاری از دو یار عزیز",
  "title": "مطالعه صفحه ۱۱۳",
  "start": 113,
  "end": 113,
  "position": 613
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "کل درس",
  "start": 114,
  "end": 126,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "آراستگی در سبک زندگی مؤمنانه",
  "start": 117,
  "end": 118,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "نیاز به مقبولیت و آراستگی",
  "start": 119,
  "end": 121,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "عفاف و آراستگی",
  "start": 122,
  "end": 123,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "معنای گسترده آراستگی و حیا",
  "start": 124,
  "end": 126,
  "position": 103
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۴",
  "start": 114,
  "end": 114,
  "position": 614
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۵",
  "start": 115,
  "end": 115,
  "position": 615
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۶",
  "start": 116,
  "end": 116,
  "position": 616
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۷",
  "start": 117,
  "end": 117,
  "position": 617
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۸",
  "start": 118,
  "end": 118,
  "position": 618
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۱۹",
  "start": 119,
  "end": 119,
  "position": 619
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۲۰",
  "start": 120,
  "end": 120,
  "position": 620
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۲۱",
  "start": 121,
  "end": 121,
  "position": 621
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۲۲",
  "start": 122,
  "end": 122,
  "position": 622
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۲۳",
  "start": 123,
  "end": 123,
  "position": 623
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۲۴",
  "start": 124,
  "end": 124,
  "position": 624
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۲۵",
  "start": 125,
  "end": 125,
  "position": 625
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۲: فضیلت آراستگی",
  "title": "مطالعه صفحه ۱۲۶",
  "start": 126,
  "end": 126,
  "position": 626
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "کل درس",
  "start": 127,
  "end": 134,
  "position": 1
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "حجاب در سایر ادیان",
  "start": 129,
  "end": 129,
  "position": 100
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "دستور قرآن درباره عفاف و پوشیدگی",
  "start": 130,
  "end": 130,
  "position": 101
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "شکل پوشش در اسلام",
  "start": 131,
  "end": 131,
  "position": 102
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "حضور زنان در جامعه",
  "start": 132,
  "end": 134,
  "position": 103
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۲۷",
  "start": 127,
  "end": 127,
  "position": 627
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۲۸",
  "start": 128,
  "end": 128,
  "position": 628
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۲۹",
  "start": 129,
  "end": 129,
  "position": 629
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۳۰",
  "start": 130,
  "end": 130,
  "position": 630
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۳۱",
  "start": 131,
  "end": 131,
  "position": 631
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۳۲",
  "start": 132,
  "end": 132,
  "position": 632
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۳۳",
  "start": 133,
  "end": 133,
  "position": 633
 },
 {
  "fields": [
   "humanities"
  ],
  "chapter": "درس ۱۳: پیام پوشیدگی",
  "title": "مطالعه صفحه ۱۳۴",
  "start": 134,
  "end": 134,
  "position": 634
 }
]$topics$::jsonb) as p(fields text[],chapter text,title text,start integer,"end" integer,position integer))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v209:'||f.field||':10:final_exam:تعلیمات دینی ۱:'||p.chapter||':'||p.position)::uuid,'1405',f.field,'10','final_exam','تعلیمات دینی ۱',p.chapter,p.title,p.start,p."end",p.position
from topics p cross join lateral unnest(p.fields) f(field) cross join installed on conflict(id) do nothing;
