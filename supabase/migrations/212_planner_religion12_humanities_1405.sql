-- Religion and Life 3 for humanities, 112205, 1405 user PDF, printed pages.
-- Distinct from the non-humanities book. Install once and never overwrite existing records.
with installed as (insert into private.planner_seed_installations(seed_key) values ('religion12-humanities-1405-v212') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "کل درس",
  "start": 4,
  "end": 14,
  "position": 1
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "آیات و ترجمه آغاز درس",
  "start": 4,
  "end": 5,
  "position": 2
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "نیازمندی جهان به خدا در پیدایش",
  "start": 7,
  "end": 8,
  "position": 100
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "نیازمندی جهان به خدا در بقا",
  "start": 9,
  "end": 9,
  "position": 101
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "آگاهی، سرچشمه بندگی",
  "start": 10,
  "end": 10,
  "position": 102
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "نور هستی",
  "start": 11,
  "end": 11,
  "position": 103
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "ناتوانی در شناخت ذات و چیستی خداوند",
  "start": 12,
  "end": 12,
  "position": 104
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "چگونه می‌توان خدا را دید؟",
  "start": 13,
  "end": 13,
  "position": 105
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "اندیشه و تحقیق",
  "start": 14,
  "end": 14,
  "position": 106
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "مطالعه صفحه ۶",
  "start": 6,
  "end": 6,
  "position": 506
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "مطالعه صفحه ۷",
  "start": 7,
  "end": 7,
  "position": 507
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "مطالعه صفحه ۸",
  "start": 8,
  "end": 8,
  "position": 508
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "مطالعه صفحه ۹",
  "start": 9,
  "end": 9,
  "position": 509
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "مطالعه صفحه ۱۰",
  "start": 10,
  "end": 10,
  "position": 510
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "مطالعه صفحه ۱۱",
  "start": 11,
  "end": 11,
  "position": 511
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "مطالعه صفحه ۱۲",
  "start": 12,
  "end": 12,
  "position": 512
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "مطالعه صفحه ۱۳",
  "start": 13,
  "end": 13,
  "position": 513
 },
 {
  "chapter": "درس ۱: هستی‌بخش",
  "title": "مطالعه صفحه ۱۴",
  "start": 14,
  "end": 14,
  "position": 514
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "کل درس",
  "start": 16,
  "end": 26,
  "position": 1
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "آیات و ترجمه آغاز درس",
  "start": 16,
  "end": 17,
  "position": 2
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "توحید و برخی مراتب آن",
  "start": 19,
  "end": 19,
  "position": 100
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "توحید در خالقیت، مالکیت و ولایت",
  "start": 19,
  "end": 19,
  "position": 101
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "توحید در ربوبیت",
  "start": 20,
  "end": 20,
  "position": 102
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "شرک و مراتب آن",
  "start": 20,
  "end": 20,
  "position": 103
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "مراتب شرک",
  "start": 21,
  "end": 22,
  "position": 104
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "طرح چند سؤال",
  "start": 23,
  "end": 23,
  "position": 105
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "هم‌اندیشی",
  "start": 24,
  "end": 24,
  "position": 106
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "نمونه‌هایی از توسل در قرآن کریم",
  "start": 25,
  "end": 25,
  "position": 107
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "اندیشه و تحقیق",
  "start": 26,
  "end": 26,
  "position": 108
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "مطالعه صفحه ۱۸",
  "start": 18,
  "end": 18,
  "position": 518
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "مطالعه صفحه ۱۹",
  "start": 19,
  "end": 19,
  "position": 519
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "مطالعه صفحه ۲۰",
  "start": 20,
  "end": 20,
  "position": 520
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "مطالعه صفحه ۲۱",
  "start": 21,
  "end": 21,
  "position": 521
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "مطالعه صفحه ۲۲",
  "start": 22,
  "end": 22,
  "position": 522
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "مطالعه صفحه ۲۳",
  "start": 23,
  "end": 23,
  "position": 523
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "مطالعه صفحه ۲۴",
  "start": 24,
  "end": 24,
  "position": 524
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "مطالعه صفحه ۲۵",
  "start": 25,
  "end": 25,
  "position": 525
 },
 {
  "chapter": "درس ۲: یگانه بی‌همتا",
  "title": "مطالعه صفحه ۲۶",
  "start": 26,
  "end": 26,
  "position": 526
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "کل درس",
  "start": 28,
  "end": 38,
  "position": 1
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "آیات و ترجمه آغاز درس",
  "start": 28,
  "end": 29,
  "position": 2
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "بازتاب توحید در زندگی",
  "start": 31,
  "end": 31,
  "position": 100
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "بعد فردی توحید عملی و ثمرات آن",
  "start": 32,
  "end": 33,
  "position": 101
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "بعد اجتماعی توحید عملی و ثمرات آن",
  "start": 34,
  "end": 34,
  "position": 102
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "ارتباط دوسویه توحید فردی و اجتماعی",
  "start": 35,
  "end": 35,
  "position": 103
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "توحید و شرک در جهان امروز",
  "start": 36,
  "end": 36,
  "position": 104
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "تحلیل و بررسی",
  "start": 37,
  "end": 37,
  "position": 105
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "اندیشه و تحقیق",
  "start": 38,
  "end": 38,
  "position": 106
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "مطالعه صفحه ۳۰",
  "start": 30,
  "end": 30,
  "position": 530
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "مطالعه صفحه ۳۱",
  "start": 31,
  "end": 31,
  "position": 531
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "مطالعه صفحه ۳۲",
  "start": 32,
  "end": 32,
  "position": 532
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "مطالعه صفحه ۳۳",
  "start": 33,
  "end": 33,
  "position": 533
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "مطالعه صفحه ۳۴",
  "start": 34,
  "end": 34,
  "position": 534
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "مطالعه صفحه ۳۵",
  "start": 35,
  "end": 35,
  "position": 535
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "مطالعه صفحه ۳۶",
  "start": 36,
  "end": 36,
  "position": 536
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "مطالعه صفحه ۳۷",
  "start": 37,
  "end": 37,
  "position": 537
 },
 {
  "chapter": "درس ۳: توحید و سبک زندگی",
  "title": "مطالعه صفحه ۳۸",
  "start": 38,
  "end": 38,
  "position": 538
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "کل درس",
  "start": 40,
  "end": 50,
  "position": 1
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "آیات و ترجمه آغاز درس",
  "start": 40,
  "end": 41,
  "position": 2
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "اخلاص در بندگی",
  "start": 44,
  "end": 44,
  "position": 100
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "تفکر در حدیث و تطبیق",
  "start": 45,
  "end": 45,
  "position": 101
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "راه‌های تقویت اخلاص",
  "start": 46,
  "end": 47,
  "position": 102
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "میوه‌های درخت اخلاص",
  "start": 48,
  "end": 50,
  "position": 103
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "مطالعه صفحه ۴۲",
  "start": 42,
  "end": 42,
  "position": 542
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "مطالعه صفحه ۴۳",
  "start": 43,
  "end": 43,
  "position": 543
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "مطالعه صفحه ۴۴",
  "start": 44,
  "end": 44,
  "position": 544
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "مطالعه صفحه ۴۵",
  "start": 45,
  "end": 45,
  "position": 545
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "مطالعه صفحه ۴۶",
  "start": 46,
  "end": 46,
  "position": 546
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "مطالعه صفحه ۴۷",
  "start": 47,
  "end": 47,
  "position": 547
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "مطالعه صفحه ۴۸",
  "start": 48,
  "end": 48,
  "position": 548
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "مطالعه صفحه ۴۹",
  "start": 49,
  "end": 49,
  "position": 549
 },
 {
  "chapter": "درس ۴: فقط برای تو",
  "title": "مطالعه صفحه ۵۰",
  "start": 50,
  "end": 50,
  "position": 550
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "کل درس",
  "start": 52,
  "end": 62,
  "position": 1
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "آیات و ترجمه آغاز درس",
  "start": 52,
  "end": 53,
  "position": 2
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "اختیار، حقیقتی وجدانی و مشهود",
  "start": 55,
  "end": 55,
  "position": 100
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "نشانه‌های اختیار",
  "start": 56,
  "end": 56,
  "position": 101
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "قانونمندی جهان، زمینه‌ساز شکوفایی اختیار",
  "start": 57,
  "end": 57,
  "position": 102
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "قدر و قضای الهی",
  "start": 58,
  "end": 58,
  "position": 103
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "اختیار انسان، یک تقدیر الهی",
  "start": 59,
  "end": 59,
  "position": 104
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "رابطه اختیار انسان با اراده خداوند",
  "start": 60,
  "end": 61,
  "position": 105
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "پاسخ به یک پرسش درباره علم الهی",
  "start": 62,
  "end": 62,
  "position": 106
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "مطالعه صفحه ۵۴",
  "start": 54,
  "end": 54,
  "position": 554
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "مطالعه صفحه ۵۵",
  "start": 55,
  "end": 55,
  "position": 555
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "مطالعه صفحه ۵۶",
  "start": 56,
  "end": 56,
  "position": 556
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "مطالعه صفحه ۵۷",
  "start": 57,
  "end": 57,
  "position": 557
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "مطالعه صفحه ۵۸",
  "start": 58,
  "end": 58,
  "position": 558
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "مطالعه صفحه ۵۹",
  "start": 59,
  "end": 59,
  "position": 559
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "مطالعه صفحه ۶۰",
  "start": 60,
  "end": 60,
  "position": 560
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "مطالعه صفحه ۶۱",
  "start": 61,
  "end": 61,
  "position": 561
 },
 {
  "chapter": "درس ۵: قدرت پرواز",
  "title": "مطالعه صفحه ۶۲",
  "start": 62,
  "end": 62,
  "position": 562
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "کل درس",
  "start": 64,
  "end": 76,
  "position": 1
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "آیات و ترجمه آغاز درس",
  "start": 64,
  "end": 65,
  "position": 2
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "سنت‌های الهی و ابتلاء",
  "start": 69,
  "end": 71,
  "position": 100
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "امداد عام الهی",
  "start": 72,
  "end": 72,
  "position": 101
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "امداد خاص و سبقت رحمت بر غضب",
  "start": 73,
  "end": 73,
  "position": 102
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "املا و استدراج",
  "start": 74,
  "end": 74,
  "position": 103
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "تأثیر اعمال انسان در زندگی او",
  "start": 75,
  "end": 75,
  "position": 104
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "برنامه‌ریزی",
  "start": 76,
  "end": 76,
  "position": 105
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "مطالعه صفحه ۶۶",
  "start": 66,
  "end": 66,
  "position": 566
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "مطالعه صفحه ۶۷",
  "start": 67,
  "end": 67,
  "position": 567
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "مطالعه صفحه ۶۸",
  "start": 68,
  "end": 68,
  "position": 568
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "مطالعه صفحه ۶۹",
  "start": 69,
  "end": 69,
  "position": 569
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "مطالعه صفحه ۷۰",
  "start": 70,
  "end": 70,
  "position": 570
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "مطالعه صفحه ۷۱",
  "start": 71,
  "end": 71,
  "position": 571
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "مطالعه صفحه ۷۲",
  "start": 72,
  "end": 72,
  "position": 572
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "مطالعه صفحه ۷۳",
  "start": 73,
  "end": 73,
  "position": 573
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "مطالعه صفحه ۷۴",
  "start": 74,
  "end": 74,
  "position": 574
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "مطالعه صفحه ۷۵",
  "start": 75,
  "end": 75,
  "position": 575
 },
 {
  "chapter": "درس ۶: سنت‌های خداوند در زندگی",
  "title": "مطالعه صفحه ۷۶",
  "start": 76,
  "end": 76,
  "position": 576
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "کل درس",
  "start": 80,
  "end": 90,
  "position": 1
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "آیات و ترجمه آغاز درس",
  "start": 80,
  "end": 81,
  "position": 2
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "زمینه‌های گناه",
  "start": 84,
  "end": 85,
  "position": 100
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "ایمان، پشتوانه‌ای محکم برای دوری از گناه",
  "start": 86,
  "end": 87,
  "position": 101
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "فکر گناه و بدتر از گناه",
  "start": 88,
  "end": 88,
  "position": 102
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "گناهان صغیره و کبیره و کتمان گناه",
  "start": 89,
  "end": 89,
  "position": 103
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "آثار گناه",
  "start": 90,
  "end": 90,
  "position": 104
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "مطالعه صفحه ۸۲",
  "start": 82,
  "end": 82,
  "position": 582
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "مطالعه صفحه ۸۳",
  "start": 83,
  "end": 83,
  "position": 583
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "مطالعه صفحه ۸۴",
  "start": 84,
  "end": 84,
  "position": 584
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "مطالعه صفحه ۸۵",
  "start": 85,
  "end": 85,
  "position": 585
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "مطالعه صفحه ۸۶",
  "start": 86,
  "end": 86,
  "position": 586
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "مطالعه صفحه ۸۷",
  "start": 87,
  "end": 87,
  "position": 587
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "مطالعه صفحه ۸۸",
  "start": 88,
  "end": 88,
  "position": 588
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "مطالعه صفحه ۸۹",
  "start": 89,
  "end": 89,
  "position": 589
 },
 {
  "chapter": "درس ۷: در گرو کار خویش",
  "title": "مطالعه صفحه ۹۰",
  "start": 90,
  "end": 90,
  "position": 590
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "کل درس",
  "start": 92,
  "end": 104,
  "position": 1
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "آیات و ترجمه آغاز درس",
  "start": 92,
  "end": 93,
  "position": 2
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "انقلاب علیه خود",
  "start": 95,
  "end": 95,
  "position": 100
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "توبه و پاکی و حقیقت توبه",
  "start": 96,
  "end": 97,
  "position": 101
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "حیله‌های شیطان",
  "start": 98,
  "end": 99,
  "position": 102
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مراحل تکمیلی توبه",
  "start": 100,
  "end": 100,
  "position": 103
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "توبه اجتماعی",
  "start": 101,
  "end": 102,
  "position": 104
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مهلت توبه",
  "start": 103,
  "end": 104,
  "position": 105
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مطالعه صفحه ۹۴",
  "start": 94,
  "end": 94,
  "position": 594
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مطالعه صفحه ۹۵",
  "start": 95,
  "end": 95,
  "position": 595
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مطالعه صفحه ۹۶",
  "start": 96,
  "end": 96,
  "position": 596
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مطالعه صفحه ۹۷",
  "start": 97,
  "end": 97,
  "position": 597
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مطالعه صفحه ۹۸",
  "start": 98,
  "end": 98,
  "position": 598
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مطالعه صفحه ۹۹",
  "start": 99,
  "end": 99,
  "position": 599
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مطالعه صفحه ۱۰۰",
  "start": 100,
  "end": 100,
  "position": 600
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مطالعه صفحه ۱۰۱",
  "start": 101,
  "end": 101,
  "position": 601
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مطالعه صفحه ۱۰۲",
  "start": 102,
  "end": 102,
  "position": 602
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مطالعه صفحه ۱۰۳",
  "start": 103,
  "end": 103,
  "position": 603
 },
 {
  "chapter": "درس ۸: بازگشت",
  "title": "مطالعه صفحه ۱۰۴",
  "start": 104,
  "end": 104,
  "position": 604
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "کل درس",
  "start": 106,
  "end": 118,
  "position": 1
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "آیات و ترجمه آغاز درس",
  "start": 106,
  "end": 107,
  "position": 2
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "یگانه راه اطمینان",
  "start": 109,
  "end": 111,
  "position": 100
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "زندگی در شرایط ویژه",
  "start": 112,
  "end": 113,
  "position": 101
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "عرصه فرهنگ و ارتباطات",
  "start": 114,
  "end": 115,
  "position": 102
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "عرصه ورزش و بازی و اقتصاد",
  "start": 116,
  "end": 117,
  "position": 103
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "بررسی",
  "start": 118,
  "end": 118,
  "position": 104
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "مطالعه صفحه ۱۰۸",
  "start": 108,
  "end": 108,
  "position": 608
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "مطالعه صفحه ۱۰۹",
  "start": 109,
  "end": 109,
  "position": 609
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "مطالعه صفحه ۱۱۰",
  "start": 110,
  "end": 110,
  "position": 610
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "مطالعه صفحه ۱۱۱",
  "start": 111,
  "end": 111,
  "position": 611
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "مطالعه صفحه ۱۱۲",
  "start": 112,
  "end": 112,
  "position": 612
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "مطالعه صفحه ۱۱۳",
  "start": 113,
  "end": 113,
  "position": 613
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "مطالعه صفحه ۱۱۴",
  "start": 114,
  "end": 114,
  "position": 614
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "مطالعه صفحه ۱۱۵",
  "start": 115,
  "end": 115,
  "position": 615
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "مطالعه صفحه ۱۱۶",
  "start": 116,
  "end": 116,
  "position": 616
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "مطالعه صفحه ۱۱۷",
  "start": 117,
  "end": 117,
  "position": 617
 },
 {
  "chapter": "درس ۹: زندگی در دنیای امروز و عمل به احکام الهی",
  "title": "مطالعه صفحه ۱۱۸",
  "start": 118,
  "end": 118,
  "position": 618
 },
 {
  "chapter": "درس ۱۰: پایه‌های استوار",
  "title": "کل درس",
  "start": 120,
  "end": 128,
  "position": 1
 },
 {
  "chapter": "درس ۱۰: پایه‌های استوار",
  "title": "آیات و ترجمه آغاز درس",
  "start": 120,
  "end": 121,
  "position": 2
 },
 {
  "chapter": "درس ۱۰: پایه‌های استوار",
  "title": "معیارهای تمدن اسلامی",
  "start": 124,
  "end": 127,
  "position": 100
 },
 {
  "chapter": "درس ۱۰: پایه‌های استوار",
  "title": "تکمیل",
  "start": 128,
  "end": 128,
  "position": 101
 },
 {
  "chapter": "درس ۱۰: پایه‌های استوار",
  "title": "مطالعه صفحه ۱۲۲",
  "start": 122,
  "end": 122,
  "position": 622
 },
 {
  "chapter": "درس ۱۰: پایه‌های استوار",
  "title": "مطالعه صفحه ۱۲۳",
  "start": 123,
  "end": 123,
  "position": 623
 },
 {
  "chapter": "درس ۱۰: پایه‌های استوار",
  "title": "مطالعه صفحه ۱۲۴",
  "start": 124,
  "end": 124,
  "position": 624
 },
 {
  "chapter": "درس ۱۰: پایه‌های استوار",
  "title": "مطالعه صفحه ۱۲۵",
  "start": 125,
  "end": 125,
  "position": 625
 },
 {
  "chapter": "درس ۱۰: پایه‌های استوار",
  "title": "مطالعه صفحه ۱۲۶",
  "start": 126,
  "end": 126,
  "position": 626
 },
 {
  "chapter": "درس ۱۰: پایه‌های استوار",
  "title": "مطالعه صفحه ۱۲۷",
  "start": 127,
  "end": 127,
  "position": 627
 },
 {
  "chapter": "درس ۱۰: پایه‌های استوار",
  "title": "مطالعه صفحه ۱۲۸",
  "start": 128,
  "end": 128,
  "position": 628
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "کل درس",
  "start": 130,
  "end": 142,
  "position": 1
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "آیات و ترجمه آغاز درس",
  "start": 130,
  "end": 131,
  "position": 2
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "اوضاع اجتماعی و فرهنگی پیش از اسلام",
  "start": 133,
  "end": 135,
  "position": 100
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "گزارش تلاش مسلمانان صدر اسلام و تحکیم بنیان خانواده",
  "start": 136,
  "end": 137,
  "position": 101
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "رشد و بالندگی علم و فرهنگ",
  "start": 138,
  "end": 139,
  "position": 102
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "توجه به عدالت و حقوق مردم",
  "start": 140,
  "end": 140,
  "position": 103
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "هم‌اندیشی",
  "start": 141,
  "end": 142,
  "position": 104
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "مطالعه صفحه ۱۳۲",
  "start": 132,
  "end": 132,
  "position": 632
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "مطالعه صفحه ۱۳۳",
  "start": 133,
  "end": 133,
  "position": 633
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "مطالعه صفحه ۱۳۴",
  "start": 134,
  "end": 134,
  "position": 634
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "مطالعه صفحه ۱۳۵",
  "start": 135,
  "end": 135,
  "position": 635
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "مطالعه صفحه ۱۳۶",
  "start": 136,
  "end": 136,
  "position": 636
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "مطالعه صفحه ۱۳۷",
  "start": 137,
  "end": 137,
  "position": 637
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "مطالعه صفحه ۱۳۸",
  "start": 138,
  "end": 138,
  "position": 638
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "مطالعه صفحه ۱۳۹",
  "start": 139,
  "end": 139,
  "position": 639
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "مطالعه صفحه ۱۴۰",
  "start": 140,
  "end": 140,
  "position": 640
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "مطالعه صفحه ۱۴۱",
  "start": 141,
  "end": 141,
  "position": 641
 },
 {
  "chapter": "درس ۱۱: عصر شکوفایی",
  "title": "مطالعه صفحه ۱۴۲",
  "start": 142,
  "end": 142,
  "position": 642
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "کل درس",
  "start": 144,
  "end": 153,
  "position": 1
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "آیات و ترجمه آغاز درس",
  "start": 144,
  "end": 145,
  "position": 2
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "زمینه‌های پیدایش تمدن جدید",
  "start": 147,
  "end": 148,
  "position": 100
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "آثار و پیامدهای تمدن جدید در حوزه علم",
  "start": 149,
  "end": 149,
  "position": 101
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "آثار منفی تمدن جدید",
  "start": 150,
  "end": 150,
  "position": 102
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "حوزه عدل و قسط",
  "start": 151,
  "end": 151,
  "position": 103
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "حوزه خانواده",
  "start": 152,
  "end": 152,
  "position": 104
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "برداشت",
  "start": 153,
  "end": 153,
  "position": 105
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "مطالعه صفحه ۱۴۶",
  "start": 146,
  "end": 146,
  "position": 646
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "مطالعه صفحه ۱۴۷",
  "start": 147,
  "end": 147,
  "position": 647
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "مطالعه صفحه ۱۴۸",
  "start": 148,
  "end": 148,
  "position": 648
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "مطالعه صفحه ۱۴۹",
  "start": 149,
  "end": 149,
  "position": 649
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "مطالعه صفحه ۱۵۰",
  "start": 150,
  "end": 150,
  "position": 650
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "مطالعه صفحه ۱۵۱",
  "start": 151,
  "end": 151,
  "position": 651
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "مطالعه صفحه ۱۵۲",
  "start": 152,
  "end": 152,
  "position": 652
 },
 {
  "chapter": "درس ۱۲: نگاهی به تمدن جدید",
  "title": "مطالعه صفحه ۱۵۳",
  "start": 153,
  "end": 153,
  "position": 653
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "کل درس",
  "start": 154,
  "end": 167,
  "position": 1
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "آیات و ترجمه آغاز درس",
  "start": 154,
  "end": 155,
  "position": 2
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "تقویت توانایی‌های فردی",
  "start": 158,
  "end": 158,
  "position": 100
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "تحکیم بنیان خانواده و پایه‌های جامعه",
  "start": 159,
  "end": 161,
  "position": 101
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "حضور مؤثر و فعال در جامعه جهانی",
  "start": 162,
  "end": 162,
  "position": 102
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "ترسیم چهره منطقی دین و روش تبلیغ",
  "start": 163,
  "end": 163,
  "position": 103
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مبارزه با ستمگران و تقویت فرهنگ جهاد و شهادت",
  "start": 164,
  "end": 167,
  "position": 104
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۵۶",
  "start": 156,
  "end": 156,
  "position": 656
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۵۷",
  "start": 157,
  "end": 157,
  "position": 657
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۵۸",
  "start": 158,
  "end": 158,
  "position": 658
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۵۹",
  "start": 159,
  "end": 159,
  "position": 659
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۶۰",
  "start": 160,
  "end": 160,
  "position": 660
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۶۱",
  "start": 161,
  "end": 161,
  "position": 661
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۶۲",
  "start": 162,
  "end": 162,
  "position": 662
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۶۳",
  "start": 163,
  "end": 163,
  "position": 663
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۶۴",
  "start": 164,
  "end": 164,
  "position": 664
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۶۵",
  "start": 165,
  "end": 165,
  "position": 665
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۶۶",
  "start": 166,
  "end": 166,
  "position": 666
 },
 {
  "chapter": "درس ۱۳: مسئولیت بزرگ ما",
  "title": "مطالعه صفحه ۱۶۷",
  "start": 167,
  "end": 167,
  "position": 667
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v212:humanities:12:final_exam:تعلیمات دینی ۳:'||p.chapter||':'||p.position)::uuid,'1405','humanities','12','final_exam','تعلیمات دینی ۳',p.chapter,p.title,p.start,p."end",p.position from topics p cross join installed on conflict(id) do nothing;
