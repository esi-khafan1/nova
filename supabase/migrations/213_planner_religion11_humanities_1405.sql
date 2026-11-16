-- Religion and Life 2 for humanities, 111205, 1405 user PDF, printed pages.
-- Distinct from the non-humanities textbook; one-time install, no legacy updates.
with installed as (insert into private.planner_seed_installations(seed_key) values ('religion11-humanities-1405-v213') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "کل درس",
  "start": 4,
  "end": 12,
  "position": 1
 },
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "آیات و ترجمه آغاز درس",
  "start": 4,
  "end": 5,
  "position": 2
 },
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "نیازهای برتر",
  "start": 7,
  "end": 8,
  "position": 100
 },
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "شیوه هدایت خداوند",
  "start": 9,
  "end": 11,
  "position": 101
 },
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "اندیشه و تحقیق",
  "start": 12,
  "end": 12,
  "position": 102
 },
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "مطالعه صفحه ۶",
  "start": 6,
  "end": 6,
  "position": 506
 },
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "مطالعه صفحه ۷",
  "start": 7,
  "end": 7,
  "position": 507
 },
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "مطالعه صفحه ۸",
  "start": 8,
  "end": 8,
  "position": 508
 },
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "مطالعه صفحه ۹",
  "start": 9,
  "end": 9,
  "position": 509
 },
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "مطالعه صفحه ۱۰",
  "start": 10,
  "end": 10,
  "position": 510
 },
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "مطالعه صفحه ۱۱",
  "start": 11,
  "end": 11,
  "position": 511
 },
 {
  "chapter": "درس ۱: هدایت الهی",
  "title": "مطالعه صفحه ۱۲",
  "start": 12,
  "end": 12,
  "position": 512
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "کل درس",
  "start": 14,
  "end": 24,
  "position": 1
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "آیات و ترجمه آغاز درس",
  "start": 14,
  "end": 15,
  "position": 2
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "فطرت مشترک، منشأ دین واحد",
  "start": 18,
  "end": 18,
  "position": 100
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "علل فرستادن پیامبران متعدد",
  "start": 19,
  "end": 19,
  "position": 101
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "تحریف تعلیمات پیامبر پیشین",
  "start": 20,
  "end": 21,
  "position": 102
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "علل وجود ادیان مختلف",
  "start": 22,
  "end": 22,
  "position": 103
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "پیامبران در سرزمین‌های گوناگون",
  "start": 23,
  "end": 24,
  "position": 104
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "مطالعه صفحه ۱۶",
  "start": 16,
  "end": 16,
  "position": 516
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "مطالعه صفحه ۱۷",
  "start": 17,
  "end": 17,
  "position": 517
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "مطالعه صفحه ۱۸",
  "start": 18,
  "end": 18,
  "position": 518
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "مطالعه صفحه ۱۹",
  "start": 19,
  "end": 19,
  "position": 519
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "مطالعه صفحه ۲۰",
  "start": 20,
  "end": 20,
  "position": 520
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "مطالعه صفحه ۲۱",
  "start": 21,
  "end": 21,
  "position": 521
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "مطالعه صفحه ۲۲",
  "start": 22,
  "end": 22,
  "position": 522
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "مطالعه صفحه ۲۳",
  "start": 23,
  "end": 23,
  "position": 523
 },
 {
  "chapter": "درس ۲: تداوم هدایت",
  "title": "مطالعه صفحه ۲۴",
  "start": 24,
  "end": 24,
  "position": 524
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "کل درس",
  "start": 26,
  "end": 36,
  "position": 1
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "آیات و ترجمه آغاز درس",
  "start": 26,
  "end": 27,
  "position": 2
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "عوامل ختم نبوت",
  "start": 29,
  "end": 29,
  "position": 100
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "نیازهای ثابت و متغیر",
  "start": 30,
  "end": 30,
  "position": 101
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "قوانین تنظیم‌کننده و مصونیت قرآن",
  "start": 31,
  "end": 32,
  "position": 102
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "وظیفه پیروان پیامبران گذشته",
  "start": 33,
  "end": 36,
  "position": 103
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "مطالعه صفحه ۲۸",
  "start": 28,
  "end": 28,
  "position": 528
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "مطالعه صفحه ۲۹",
  "start": 29,
  "end": 29,
  "position": 529
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "مطالعه صفحه ۳۰",
  "start": 30,
  "end": 30,
  "position": 530
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "مطالعه صفحه ۳۱",
  "start": 31,
  "end": 31,
  "position": 531
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "مطالعه صفحه ۳۲",
  "start": 32,
  "end": 32,
  "position": 532
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "مطالعه صفحه ۳۳",
  "start": 33,
  "end": 33,
  "position": 533
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "مطالعه صفحه ۳۴",
  "start": 34,
  "end": 34,
  "position": 534
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "مطالعه صفحه ۳۵",
  "start": 35,
  "end": 35,
  "position": 535
 },
 {
  "chapter": "درس ۳: آخرین پیامبر",
  "title": "مطالعه صفحه ۳۶",
  "start": 36,
  "end": 36,
  "position": 536
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "کل درس",
  "start": 38,
  "end": 50,
  "position": 1
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "آیات و ترجمه آغاز درس",
  "start": 38,
  "end": 39,
  "position": 2
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "تناسب معجزه هر پیامبر با زمان خود",
  "start": 41,
  "end": 43,
  "position": 100
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "جنبه‌های اعجاز قرآن کریم",
  "start": 44,
  "end": 44,
  "position": 101
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "اعجاز محتوایی",
  "start": 45,
  "end": 45,
  "position": 102
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "جامعیت و تأثیرناپذیری از عقاید جاهلیت",
  "start": 46,
  "end": 46,
  "position": 103
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "نمونه‌هایی از معجزات علمی قرآن",
  "start": 47,
  "end": 50,
  "position": 104
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "مطالعه صفحه ۴۰",
  "start": 40,
  "end": 40,
  "position": 540
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "مطالعه صفحه ۴۱",
  "start": 41,
  "end": 41,
  "position": 541
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "مطالعه صفحه ۴۲",
  "start": 42,
  "end": 42,
  "position": 542
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "مطالعه صفحه ۴۳",
  "start": 43,
  "end": 43,
  "position": 543
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "مطالعه صفحه ۴۴",
  "start": 44,
  "end": 44,
  "position": 544
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "مطالعه صفحه ۴۵",
  "start": 45,
  "end": 45,
  "position": 545
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "مطالعه صفحه ۴۶",
  "start": 46,
  "end": 46,
  "position": 546
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "مطالعه صفحه ۴۷",
  "start": 47,
  "end": 47,
  "position": 547
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "مطالعه صفحه ۴۸",
  "start": 48,
  "end": 48,
  "position": 548
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "مطالعه صفحه ۴۹",
  "start": 49,
  "end": 49,
  "position": 549
 },
 {
  "chapter": "درس ۴: معجزه جاویدان",
  "title": "مطالعه صفحه ۵۰",
  "start": 50,
  "end": 50,
  "position": 550
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "کل درس",
  "start": 52,
  "end": 64,
  "position": 1
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "آیات و ترجمه آغاز درس",
  "start": 52,
  "end": 53,
  "position": 2
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "دریافت و ابلاغ وحی و مرجعیت دینی",
  "start": 55,
  "end": 55,
  "position": 100
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "اجرای قوانین الهی و ولایت ظاهری",
  "start": 56,
  "end": 56,
  "position": 101
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "ضرورت تشکیل حکومت اسلامی",
  "start": 57,
  "end": 59,
  "position": 102
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "ولایت معنوی رسول خدا",
  "start": 60,
  "end": 60,
  "position": 103
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "عصمت پیامبر اکرم",
  "start": 61,
  "end": 64,
  "position": 104
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "مطالعه صفحه ۵۴",
  "start": 54,
  "end": 54,
  "position": 554
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "مطالعه صفحه ۵۵",
  "start": 55,
  "end": 55,
  "position": 555
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "مطالعه صفحه ۵۶",
  "start": 56,
  "end": 56,
  "position": 556
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "مطالعه صفحه ۵۷",
  "start": 57,
  "end": 57,
  "position": 557
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "مطالعه صفحه ۵۸",
  "start": 58,
  "end": 58,
  "position": 558
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "مطالعه صفحه ۵۹",
  "start": 59,
  "end": 59,
  "position": 559
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "مطالعه صفحه ۶۰",
  "start": 60,
  "end": 60,
  "position": 560
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "مطالعه صفحه ۶۱",
  "start": 61,
  "end": 61,
  "position": 561
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "مطالعه صفحه ۶۲",
  "start": 62,
  "end": 62,
  "position": 562
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "مطالعه صفحه ۶۳",
  "start": 63,
  "end": 63,
  "position": 563
 },
 {
  "chapter": "درس ۵: مسئولیت‌های پیامبر",
  "title": "مطالعه صفحه ۶۴",
  "start": 64,
  "end": 64,
  "position": 564
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "کل درس",
  "start": 66,
  "end": 78,
  "position": 1
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "آیات و ترجمه آغاز درس",
  "start": 66,
  "end": 67,
  "position": 2
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "رسول خدا، اسوه رهبری",
  "start": 69,
  "end": 69,
  "position": 100
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "محبت و مدارا و هدایت مردم",
  "start": 70,
  "end": 71,
  "position": 101
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مبارزه با فقر و محرومیت",
  "start": 72,
  "end": 72,
  "position": 102
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "ایجاد اخوت اسلامی",
  "start": 73,
  "end": 74,
  "position": 103
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "برنامه‌ای برای وحدت مسلمانان",
  "start": 75,
  "end": 76,
  "position": 104
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "حامیان وحدت",
  "start": 77,
  "end": 78,
  "position": 105
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مطالعه صفحه ۶۸",
  "start": 68,
  "end": 68,
  "position": 568
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مطالعه صفحه ۶۹",
  "start": 69,
  "end": 69,
  "position": 569
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مطالعه صفحه ۷۰",
  "start": 70,
  "end": 70,
  "position": 570
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مطالعه صفحه ۷۱",
  "start": 71,
  "end": 71,
  "position": 571
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مطالعه صفحه ۷۲",
  "start": 72,
  "end": 72,
  "position": 572
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مطالعه صفحه ۷۳",
  "start": 73,
  "end": 73,
  "position": 573
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مطالعه صفحه ۷۴",
  "start": 74,
  "end": 74,
  "position": 574
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مطالعه صفحه ۷۵",
  "start": 75,
  "end": 75,
  "position": 575
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مطالعه صفحه ۷۶",
  "start": 76,
  "end": 76,
  "position": 576
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مطالعه صفحه ۷۷",
  "start": 77,
  "end": 77,
  "position": 577
 },
 {
  "chapter": "درس ۶: پیشوای اسوه",
  "title": "مطالعه صفحه ۷۸",
  "start": 78,
  "end": 78,
  "position": 578
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "کل درس",
  "start": 80,
  "end": 92,
  "position": 1
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "آیات و ترجمه آغاز درس",
  "start": 80,
  "end": 81,
  "position": 2
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "تعیین امام و آیه انذار",
  "start": 84,
  "end": 84,
  "position": 100
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "آیه ولایت",
  "start": 85,
  "end": 85,
  "position": 101
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "حدیث جابر",
  "start": 86,
  "end": 86,
  "position": 102
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "حدیث ثقلین",
  "start": 87,
  "end": 87,
  "position": 103
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "حدیث منزلت و حدیث غدیر",
  "start": 88,
  "end": 89,
  "position": 104
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "عصمت ائمه اطهار",
  "start": 90,
  "end": 92,
  "position": 105
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "مطالعه صفحه ۸۲",
  "start": 82,
  "end": 82,
  "position": 582
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "مطالعه صفحه ۸۳",
  "start": 83,
  "end": 83,
  "position": 583
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "مطالعه صفحه ۸۴",
  "start": 84,
  "end": 84,
  "position": 584
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "مطالعه صفحه ۸۵",
  "start": 85,
  "end": 85,
  "position": 585
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "مطالعه صفحه ۸۶",
  "start": 86,
  "end": 86,
  "position": 586
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "مطالعه صفحه ۸۷",
  "start": 87,
  "end": 87,
  "position": 587
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "مطالعه صفحه ۸۸",
  "start": 88,
  "end": 88,
  "position": 588
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "مطالعه صفحه ۸۹",
  "start": 89,
  "end": 89,
  "position": 589
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "مطالعه صفحه ۹۰",
  "start": 90,
  "end": 90,
  "position": 590
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "مطالعه صفحه ۹۱",
  "start": 91,
  "end": 91,
  "position": 591
 },
 {
  "chapter": "درس ۷: امامت، تداوم رسالت",
  "title": "مطالعه صفحه ۹۲",
  "start": 92,
  "end": 92,
  "position": 592
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "کل درس",
  "start": 94,
  "end": 106,
  "position": 1
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "آیات و ترجمه آغاز درس",
  "start": 94,
  "end": 95,
  "position": 2
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "پرورش در دامان پیامبر",
  "start": 97,
  "end": 97,
  "position": 100
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "امیرالمؤمنین علی از دیدگاه پیامبر",
  "start": 98,
  "end": 99,
  "position": 101
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "پرسش درباره شناخت امام علی پس از پیامبر",
  "start": 100,
  "end": 101,
  "position": 102
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "سؤال در میدان جنگ",
  "start": 102,
  "end": 102,
  "position": 103
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "عدالت بی‌مانند",
  "start": 103,
  "end": 106,
  "position": 104
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "مطالعه صفحه ۹۶",
  "start": 96,
  "end": 96,
  "position": 596
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "مطالعه صفحه ۹۷",
  "start": 97,
  "end": 97,
  "position": 597
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "مطالعه صفحه ۹۸",
  "start": 98,
  "end": 98,
  "position": 598
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "مطالعه صفحه ۹۹",
  "start": 99,
  "end": 99,
  "position": 599
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "مطالعه صفحه ۱۰۰",
  "start": 100,
  "end": 100,
  "position": 600
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "مطالعه صفحه ۱۰۱",
  "start": 101,
  "end": 101,
  "position": 601
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "مطالعه صفحه ۱۰۲",
  "start": 102,
  "end": 102,
  "position": 602
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "مطالعه صفحه ۱۰۳",
  "start": 103,
  "end": 103,
  "position": 603
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "مطالعه صفحه ۱۰۴",
  "start": 104,
  "end": 104,
  "position": 604
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "مطالعه صفحه ۱۰۵",
  "start": 105,
  "end": 105,
  "position": 605
 },
 {
  "chapter": "درس ۸: جان و جانشین پیامبر",
  "title": "مطالعه صفحه ۱۰۶",
  "start": 106,
  "end": 106,
  "position": 606
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "کل درس",
  "start": 108,
  "end": 118,
  "position": 1
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "آیات و ترجمه آغاز درس",
  "start": 108,
  "end": 109,
  "position": 2
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "مشکلات فرهنگی، اجتماعی و سیاسی پس از رسول خدا",
  "start": 113,
  "end": 113,
  "position": 100
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "تحریف معارف اسلامی و جعل احادیث",
  "start": 114,
  "end": 114,
  "position": 101
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "ارائه الگوهای نامناسب",
  "start": 115,
  "end": 115,
  "position": 102
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "تبدیل حکومت عدل نبوی به سلطنت",
  "start": 116,
  "end": 118,
  "position": 103
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "مطالعه صفحه ۱۱۰",
  "start": 110,
  "end": 110,
  "position": 610
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "مطالعه صفحه ۱۱۱",
  "start": 111,
  "end": 111,
  "position": 611
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "مطالعه صفحه ۱۱۲",
  "start": 112,
  "end": 112,
  "position": 612
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "مطالعه صفحه ۱۱۳",
  "start": 113,
  "end": 113,
  "position": 613
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "مطالعه صفحه ۱۱۴",
  "start": 114,
  "end": 114,
  "position": 614
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "مطالعه صفحه ۱۱۵",
  "start": 115,
  "end": 115,
  "position": 615
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "مطالعه صفحه ۱۱۶",
  "start": 116,
  "end": 116,
  "position": 616
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "مطالعه صفحه ۱۱۷",
  "start": 117,
  "end": 117,
  "position": 617
 },
 {
  "chapter": "درس ۹: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت رسول خدا",
  "title": "مطالعه صفحه ۱۱۸",
  "start": 118,
  "end": 118,
  "position": 618
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "کل درس",
  "start": 120,
  "end": 130,
  "position": 1
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "آیات و ترجمه آغاز درس",
  "start": 120,
  "end": 121,
  "position": 2
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "تعلیم و تفسیر قرآن کریم",
  "start": 124,
  "end": 124,
  "position": 100
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "حفظ سخنان و سیره پیامبر",
  "start": 125,
  "end": 125,
  "position": 101
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "تبیین معارف اسلامی متناسب با نیازهای نو",
  "start": 126,
  "end": 126,
  "position": 102
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "تربیت شخصیت‌های اسلامی",
  "start": 127,
  "end": 130,
  "position": 103
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "مطالعه صفحه ۱۲۲",
  "start": 122,
  "end": 122,
  "position": 622
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "مطالعه صفحه ۱۲۳",
  "start": 123,
  "end": 123,
  "position": 623
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "مطالعه صفحه ۱۲۴",
  "start": 124,
  "end": 124,
  "position": 624
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "مطالعه صفحه ۱۲۵",
  "start": 125,
  "end": 125,
  "position": 625
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "مطالعه صفحه ۱۲۶",
  "start": 126,
  "end": 126,
  "position": 626
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "مطالعه صفحه ۱۲۷",
  "start": 127,
  "end": 127,
  "position": 627
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "مطالعه صفحه ۱۲۸",
  "start": 128,
  "end": 128,
  "position": 628
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "مطالعه صفحه ۱۲۹",
  "start": 129,
  "end": 129,
  "position": 629
 },
 {
  "chapter": "درس ۱۰: احیای ارزش‌های راستین",
  "title": "مطالعه صفحه ۱۳۰",
  "start": 130,
  "end": 130,
  "position": 630
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "کل درس",
  "start": 132,
  "end": 144,
  "position": 1
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "آیات و ترجمه آغاز درس",
  "start": 132,
  "end": 133,
  "position": 2
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "معرفی امام بر حق و شیوه‌های درست مبارزه",
  "start": 136,
  "end": 137,
  "position": 100
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مروری کوتاه بر مبارزه امامان",
  "start": 138,
  "end": 140,
  "position": 101
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "توفیق خدمت در جبهه مشرکان",
  "start": 141,
  "end": 141,
  "position": 102
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "وظیفه ما در برابر پیامبر و امامان",
  "start": 142,
  "end": 142,
  "position": 103
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "محبت توأم با معرفت",
  "start": 143,
  "end": 144,
  "position": 104
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مطالعه صفحه ۱۳۴",
  "start": 134,
  "end": 134,
  "position": 634
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مطالعه صفحه ۱۳۵",
  "start": 135,
  "end": 135,
  "position": 635
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مطالعه صفحه ۱۳۶",
  "start": 136,
  "end": 136,
  "position": 636
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مطالعه صفحه ۱۳۷",
  "start": 137,
  "end": 137,
  "position": 637
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مطالعه صفحه ۱۳۸",
  "start": 138,
  "end": 138,
  "position": 638
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مطالعه صفحه ۱۳۹",
  "start": 139,
  "end": 139,
  "position": 639
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مطالعه صفحه ۱۴۰",
  "start": 140,
  "end": 140,
  "position": 640
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مطالعه صفحه ۱۴۱",
  "start": 141,
  "end": 141,
  "position": 641
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مطالعه صفحه ۱۴۲",
  "start": 142,
  "end": 142,
  "position": 642
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مطالعه صفحه ۱۴۳",
  "start": 143,
  "end": 143,
  "position": 643
 },
 {
  "chapter": "درس ۱۱: جهاد در راستای ولایت ظاهری",
  "title": "مطالعه صفحه ۱۴۴",
  "start": 144,
  "end": 144,
  "position": 644
 },
 {
  "chapter": "درس ۱۲: عصر غیبت امام زمان",
  "title": "کل درس",
  "start": 146,
  "end": 152,
  "position": 1
 },
 {
  "chapter": "درس ۱۲: عصر غیبت امام زمان",
  "title": "آیات و ترجمه آغاز درس",
  "start": 146,
  "end": 147,
  "position": 2
 },
 {
  "chapter": "درس ۱۲: عصر غیبت امام زمان",
  "title": "غیبت امام مهدی",
  "start": 149,
  "end": 150,
  "position": 100
 },
 {
  "chapter": "درس ۱۲: عصر غیبت امام زمان",
  "title": "چگونگی امامت حضرت مهدی در عصر غیبت",
  "start": 151,
  "end": 151,
  "position": 101
 },
 {
  "chapter": "درس ۱۲: عصر غیبت امام زمان",
  "title": "هدایت معنوی و امداد امام عصر",
  "start": 152,
  "end": 152,
  "position": 102
 },
 {
  "chapter": "درس ۱۲: عصر غیبت امام زمان",
  "title": "مطالعه صفحه ۱۴۸",
  "start": 148,
  "end": 148,
  "position": 648
 },
 {
  "chapter": "درس ۱۲: عصر غیبت امام زمان",
  "title": "مطالعه صفحه ۱۴۹",
  "start": 149,
  "end": 149,
  "position": 649
 },
 {
  "chapter": "درس ۱۲: عصر غیبت امام زمان",
  "title": "مطالعه صفحه ۱۵۰",
  "start": 150,
  "end": 150,
  "position": 650
 },
 {
  "chapter": "درس ۱۲: عصر غیبت امام زمان",
  "title": "مطالعه صفحه ۱۵۱",
  "start": 151,
  "end": 151,
  "position": 651
 },
 {
  "chapter": "درس ۱۲: عصر غیبت امام زمان",
  "title": "مطالعه صفحه ۱۵۲",
  "start": 152,
  "end": 152,
  "position": 652
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "کل درس",
  "start": 154,
  "end": 166,
  "position": 1
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "آیات و ترجمه آغاز درس",
  "start": 154,
  "end": 155,
  "position": 2
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "آینده تاریخ",
  "start": 157,
  "end": 157,
  "position": 100
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "موعود و منجی در ادیان",
  "start": 158,
  "end": 158,
  "position": 101
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "موعود در اسلام",
  "start": 159,
  "end": 159,
  "position": 102
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مسئولیت‌های منتظران",
  "start": 160,
  "end": 162,
  "position": 103
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "دعا برای ظهور امام",
  "start": 163,
  "end": 163,
  "position": 104
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "نگاهی به جامعه مهدوی",
  "start": 164,
  "end": 164,
  "position": 105
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "شکوفایی عقل و علم",
  "start": 165,
  "end": 166,
  "position": 106
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مطالعه صفحه ۱۵۶",
  "start": 156,
  "end": 156,
  "position": 656
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مطالعه صفحه ۱۵۷",
  "start": 157,
  "end": 157,
  "position": 657
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مطالعه صفحه ۱۵۸",
  "start": 158,
  "end": 158,
  "position": 658
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مطالعه صفحه ۱۵۹",
  "start": 159,
  "end": 159,
  "position": 659
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مطالعه صفحه ۱۶۰",
  "start": 160,
  "end": 160,
  "position": 660
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مطالعه صفحه ۱۶۱",
  "start": 161,
  "end": 161,
  "position": 661
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مطالعه صفحه ۱۶۲",
  "start": 162,
  "end": 162,
  "position": 662
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مطالعه صفحه ۱۶۳",
  "start": 163,
  "end": 163,
  "position": 663
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مطالعه صفحه ۱۶۴",
  "start": 164,
  "end": 164,
  "position": 664
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مطالعه صفحه ۱۶۵",
  "start": 165,
  "end": 165,
  "position": 665
 },
 {
  "chapter": "درس ۱۳: در انتظار ظهور",
  "title": "مطالعه صفحه ۱۶۶",
  "start": 166,
  "end": 166,
  "position": 666
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "کل درس",
  "start": 168,
  "end": 176,
  "position": 1
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "آیات و ترجمه آغاز درس",
  "start": 168,
  "end": 169,
  "position": 2
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "راهکار پیامبر و امامان برای عصر غیبت",
  "start": 172,
  "end": 173,
  "position": 100
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "شرایط مرجع تقلید و راه‌های شناخت مرجع",
  "start": 174,
  "end": 175,
  "position": 101
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "انتخاب رهبر توسط خبرگان",
  "start": 176,
  "end": 176,
  "position": 102
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "مطالعه صفحه ۱۷۰",
  "start": 170,
  "end": 170,
  "position": 670
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "مطالعه صفحه ۱۷۱",
  "start": 171,
  "end": 171,
  "position": 671
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "مطالعه صفحه ۱۷۲",
  "start": 172,
  "end": 172,
  "position": 672
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "مطالعه صفحه ۱۷۳",
  "start": 173,
  "end": 173,
  "position": 673
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "مطالعه صفحه ۱۷۴",
  "start": 174,
  "end": 174,
  "position": 674
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "مطالعه صفحه ۱۷۵",
  "start": 175,
  "end": 175,
  "position": 675
 },
 {
  "chapter": "درس ۱۴: مرجعیت و ولایت فقیه",
  "title": "مطالعه صفحه ۱۷۶",
  "start": 176,
  "end": 176,
  "position": 676
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "کل درس",
  "start": 178,
  "end": 191,
  "position": 1
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "آیات و ترجمه آغاز درس",
  "start": 178,
  "end": 179,
  "position": 2
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مردم‌سالاری دینی",
  "start": 181,
  "end": 181,
  "position": 100
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "تفاوت حکومت مردم‌سالار دینی با حکومت‌های غربی",
  "start": 182,
  "end": 182,
  "position": 101
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "وظایف رهبر",
  "start": 183,
  "end": 184,
  "position": 102
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مردم و رهبری",
  "start": 185,
  "end": 187,
  "position": 103
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "وظایف کارگزاران",
  "start": 188,
  "end": 189,
  "position": 104
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "آمادگی برای حکومت جهانی امام عصر",
  "start": 190,
  "end": 191,
  "position": 105
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۸۰",
  "start": 180,
  "end": 180,
  "position": 680
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۸۱",
  "start": 181,
  "end": 181,
  "position": 681
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۸۲",
  "start": 182,
  "end": 182,
  "position": 682
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۸۳",
  "start": 183,
  "end": 183,
  "position": 683
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۸۴",
  "start": 184,
  "end": 184,
  "position": 684
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۸۵",
  "start": 185,
  "end": 185,
  "position": 685
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۸۶",
  "start": 186,
  "end": 186,
  "position": 686
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۸۷",
  "start": 187,
  "end": 187,
  "position": 687
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۸۸",
  "start": 188,
  "end": 188,
  "position": 688
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۸۹",
  "start": 189,
  "end": 189,
  "position": 689
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۹۰",
  "start": 190,
  "end": 190,
  "position": 690
 },
 {
  "chapter": "درس ۱۵: رهبری و مردم",
  "title": "مطالعه صفحه ۱۹۱",
  "start": 191,
  "end": 191,
  "position": 691
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "کل درس",
  "start": 194,
  "end": 204,
  "position": 1
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "آیات و ترجمه آغاز درس",
  "start": 194,
  "end": 195,
  "position": 2
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "عزت و ذلت",
  "start": 197,
  "end": 198,
  "position": 100
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "راه‌های تقویت عزت",
  "start": 199,
  "end": 199,
  "position": 101
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "اسوه‌های عزت و ایستادگی",
  "start": 200,
  "end": 200,
  "position": 102
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "خود عالی و خود دانی",
  "start": 201,
  "end": 204,
  "position": 103
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "مطالعه صفحه ۱۹۶",
  "start": 196,
  "end": 196,
  "position": 696
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "مطالعه صفحه ۱۹۷",
  "start": 197,
  "end": 197,
  "position": 697
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "مطالعه صفحه ۱۹۸",
  "start": 198,
  "end": 198,
  "position": 698
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "مطالعه صفحه ۱۹۹",
  "start": 199,
  "end": 199,
  "position": 699
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "مطالعه صفحه ۲۰۰",
  "start": 200,
  "end": 200,
  "position": 700
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "مطالعه صفحه ۲۰۱",
  "start": 201,
  "end": 201,
  "position": 701
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "مطالعه صفحه ۲۰۲",
  "start": 202,
  "end": 202,
  "position": 702
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "مطالعه صفحه ۲۰۳",
  "start": 203,
  "end": 203,
  "position": 703
 },
 {
  "chapter": "درس ۱۶: عزت نفس",
  "title": "مطالعه صفحه ۲۰۴",
  "start": 204,
  "end": 204,
  "position": 704
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "کل درس",
  "start": 206,
  "end": 218,
  "position": 1
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "آیات و ترجمه آغاز درس",
  "start": 206,
  "end": 207,
  "position": 2
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "جایگاه زن در قرآن و مقایسه آن با تورات و انجیل",
  "start": 210,
  "end": 210,
  "position": 100
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "نقش‌های مکمل",
  "start": 211,
  "end": 211,
  "position": 101
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "خانواده‌های سنتی و غربی",
  "start": 212,
  "end": 212,
  "position": 102
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "خانواده متعادل و آمادگی برای ازدواج",
  "start": 213,
  "end": 214,
  "position": 103
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "توجه به اهداف ازدواج",
  "start": 215,
  "end": 218,
  "position": 104
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "مطالعه صفحه ۲۰۸",
  "start": 208,
  "end": 208,
  "position": 708
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "مطالعه صفحه ۲۰۹",
  "start": 209,
  "end": 209,
  "position": 709
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "مطالعه صفحه ۲۱۰",
  "start": 210,
  "end": 210,
  "position": 710
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "مطالعه صفحه ۲۱۱",
  "start": 211,
  "end": 211,
  "position": 711
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "مطالعه صفحه ۲۱۲",
  "start": 212,
  "end": 212,
  "position": 712
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "مطالعه صفحه ۲۱۳",
  "start": 213,
  "end": 213,
  "position": 713
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "مطالعه صفحه ۲۱۴",
  "start": 214,
  "end": 214,
  "position": 714
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "مطالعه صفحه ۲۱۵",
  "start": 215,
  "end": 215,
  "position": 715
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "مطالعه صفحه ۲۱۶",
  "start": 216,
  "end": 216,
  "position": 716
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "مطالعه صفحه ۲۱۷",
  "start": 217,
  "end": 217,
  "position": 717
 },
 {
  "chapter": "درس ۱۷: زمینه‌های پیوند",
  "title": "مطالعه صفحه ۲۱۸",
  "start": 218,
  "end": 218,
  "position": 718
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "کل درس",
  "start": 220,
  "end": 230,
  "position": 1
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "آیات و ترجمه آغاز درس",
  "start": 220,
  "end": 221,
  "position": 2
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "انتخاب همسر و مسئولیت آینده",
  "start": 223,
  "end": 223,
  "position": 100
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "معیارها و راه‌های شناخت همسر شایسته",
  "start": 224,
  "end": 224,
  "position": 101
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "زمان ازدواج",
  "start": 225,
  "end": 226,
  "position": 102
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "مشکلات پیش‌رو و راه حل",
  "start": 227,
  "end": 227,
  "position": 103
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "خواستگاری پسر از دختر یا دختر از پسر",
  "start": 228,
  "end": 228,
  "position": 104
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "دوستی خارج از چارچوب شرع",
  "start": 229,
  "end": 230,
  "position": 105
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "مطالعه صفحه ۲۲۲",
  "start": 222,
  "end": 222,
  "position": 722
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "مطالعه صفحه ۲۲۳",
  "start": 223,
  "end": 223,
  "position": 723
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "مطالعه صفحه ۲۲۴",
  "start": 224,
  "end": 224,
  "position": 724
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "مطالعه صفحه ۲۲۵",
  "start": 225,
  "end": 225,
  "position": 725
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "مطالعه صفحه ۲۲۶",
  "start": 226,
  "end": 226,
  "position": 726
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "مطالعه صفحه ۲۲۷",
  "start": 227,
  "end": 227,
  "position": 727
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "مطالعه صفحه ۲۲۸",
  "start": 228,
  "end": 228,
  "position": 728
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "مطالعه صفحه ۲۲۹",
  "start": 229,
  "end": 229,
  "position": 729
 },
 {
  "chapter": "درس ۱۸: پیوند مقدس",
  "title": "مطالعه صفحه ۲۳۰",
  "start": 230,
  "end": 230,
  "position": 730
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v213:humanities:11:final_exam:تعلیمات دینی ۲:'||p.chapter||':'||p.position)::uuid,'1405','humanities','11','final_exam','تعلیمات دینی ۲',p.chapter,p.title,p.start,p."end",p.position from topics p cross join installed on conflict(id) do nothing;
