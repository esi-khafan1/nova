-- Chemistry 110210, 111210, 112210, 1405 user PDFs; printed pages.
-- One-time inserts and compare-and-set backfills preserve administrator edits and snapshots.
with installed as (insert into private.planner_seed_installations(seed_key) values ('chemistry-10-12-1405-v187') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 300,
    "title": "کل فصل",
    "start": 1,
    "end": 46
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 301,
    "title": "پیدایش عنصرها و مهبانگ",
    "start": 2,
    "end": 4
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 302,
    "title": "ایزوتوپ و پایداری اتم‌ها",
    "start": 5,
    "end": 6
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 303,
    "title": "تکنسیم و غنی‌سازی ایزوتوپی",
    "start": 7,
    "end": 8
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 304,
    "title": "طبقه‌بندی عنصرها و جدول دوره‌ای",
    "start": 9,
    "end": 12
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 305,
    "title": "جرم اتمی و یکای جرم اتمی",
    "start": 13,
    "end": 15
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 306,
    "title": "شمارش ذره‌ها، مول و جرم مولی",
    "start": 16,
    "end": 18
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 307,
    "title": "نور، طیف الکترومغناطیسی و طیف نشری",
    "start": 19,
    "end": 23
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 308,
    "title": "ساختار اتم، مدل بور و انرژی کوانتومی",
    "start": 24,
    "end": 25
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 309,
    "title": "مدل کوانتومی و ترازهای انرژی",
    "start": 26,
    "end": 26
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 310,
    "title": "توزیع الکترون‌ها در لایه و زیرلایه",
    "start": 27,
    "end": 29
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 311,
    "title": "آرایش الکترونی و قاعده آفبا",
    "start": 30,
    "end": 31
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 312,
    "title": "آرایش فشرده و الکترون‌های ظرفیت",
    "start": 32,
    "end": 33
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 313,
    "title": "ساختار اتم و رفتار آن",
    "start": 34,
    "end": 37
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 314,
    "title": "یون‌ها و پیوند یونی",
    "start": 38,
    "end": 39
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 315,
    "title": "مولکول و پیوند کووالانسی",
    "start": 40,
    "end": 41
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 316,
    "title": "تمرین‌های دوره‌ای",
    "start": 42,
    "end": 46
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 300,
    "title": "کل فصل",
    "start": 47,
    "end": 84
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 301,
    "title": "هواکره و لایه‌های آن",
    "start": 48,
    "end": 49
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 302,
    "title": "هوا معجونی ارزشمند و تقطیر جزء به جزء",
    "start": 50,
    "end": 53
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 303,
    "title": "اکسیژن و واکنش‌پذیری آن",
    "start": 54,
    "end": 54
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 304,
    "title": "ترکیب اکسیژن با فلزها و نافلزها",
    "start": 55,
    "end": 56
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 305,
    "title": "ساختار الکترون‌نقطه‌ای لوویس",
    "start": 57,
    "end": 57
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 306,
    "title": "اکسیدها و سوختن ناقص",
    "start": 58,
    "end": 59
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 307,
    "title": "رفتار اکسیدهای فلزی و نافلزی",
    "start": 60,
    "end": 61
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 308,
    "title": "واکنش شیمیایی و پایستگی جرم",
    "start": 62,
    "end": 62
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 309,
    "title": "موازنه واکنش‌های شیمیایی",
    "start": 63,
    "end": 65
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 310,
    "title": "آلودگی هواکره و اثر گلخانه‌ای",
    "start": 66,
    "end": 69
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 311,
    "title": "شیمی سبز و سوخت سبز",
    "start": 70,
    "end": 71
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 312,
    "title": "اوزون و دگرشکلی اکسیژن",
    "start": 72,
    "end": 75
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 313,
    "title": "رفتار گازها و شرایط استاندارد",
    "start": 76,
    "end": 78
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 314,
    "title": "استوکیومتری واکنش گازها",
    "start": 79,
    "end": 80
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 315,
    "title": "تولید آمونیاک",
    "start": 81,
    "end": 81
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 316,
    "title": "تمرین‌های دوره‌ای",
    "start": 82,
    "end": 84
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 300,
    "title": "کل فصل",
    "start": 85,
    "end": 122
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 301,
    "title": "آب‌کره و چرخه آب",
    "start": 86,
    "end": 88
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 302,
    "title": "یون‌های همراه آب",
    "start": 89,
    "end": 90
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 303,
    "title": "یون‌های چنداتمی",
    "start": 91,
    "end": 92
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 304,
    "title": "محلول و مقدار حل‌شونده",
    "start": 93,
    "end": 93
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 305,
    "title": "غلظت قسمت در میلیون",
    "start": 94,
    "end": 95
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 306,
    "title": "درصد جرمی",
    "start": 96,
    "end": 97
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 307,
    "title": "غلظت مولی",
    "start": 98,
    "end": 99
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 308,
    "title": "انحلال‌پذیری نمک‌ها",
    "start": 100,
    "end": 102
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 309,
    "title": "رفتار مولکول‌ها در میدان الکتریکی",
    "start": 103,
    "end": 104
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 310,
    "title": "نیروهای بین‌مولکولی و پیوند هیدروژنی",
    "start": 105,
    "end": 108
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 311,
    "title": "آب و دیگر حلال‌ها",
    "start": 109,
    "end": 109
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 312,
    "title": "انحلال مولکولی و یونی",
    "start": 110,
    "end": 111
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 313,
    "title": "انحلال‌پذیری گازها و قانون هنری",
    "start": 112,
    "end": 115
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 314,
    "title": "ردپای آب در زندگی",
    "start": 116,
    "end": 116
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 315,
    "title": "غشای نیمه‌تراوا و اسمز وارونه",
    "start": 117,
    "end": 119
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 316,
    "title": "تمرین‌های دوره‌ای",
    "start": 120,
    "end": 122
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 300,
    "title": "کل فصل",
    "start": 1,
    "end": 50
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 301,
    "title": "مواد طبیعی و ساختگی",
    "start": 2,
    "end": 5
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 302,
    "title": "الگوها و روندها در رفتار عنصرها",
    "start": 6,
    "end": 9
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 303,
    "title": "رفتار عنصرها و شعاع اتم",
    "start": 10,
    "end": 13
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 304,
    "title": "عنصرهای دسته d",
    "start": 14,
    "end": 17
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 305,
    "title": "عنصرها در طبیعت و واکنش‌پذیری فلزها",
    "start": 18,
    "end": 21
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 306,
    "title": "دنیای واقعی واکنش‌ها",
    "start": 22,
    "end": 22
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 307,
    "title": "درصد خلوص و بازده درصدی",
    "start": 23,
    "end": 24
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 308,
    "title": "استخراج فلزها و محیط زیست",
    "start": 25,
    "end": 28
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 309,
    "title": "نفت، هدیه‌ای شگفت‌انگیز",
    "start": 29,
    "end": 30
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 310,
    "title": "کربن و ساختار هیدروکربن‌ها",
    "start": 31,
    "end": 32
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 311,
    "title": "آلکان‌ها و پیوند یگانه",
    "start": 33,
    "end": 36
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 312,
    "title": "نام‌گذاری آلکان‌ها",
    "start": 37,
    "end": 39
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 313,
    "title": "آلکن‌ها و پیوند دوگانه",
    "start": 40,
    "end": 41
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 314,
    "title": "آلکین‌ها",
    "start": 42,
    "end": 42
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 315,
    "title": "هیدروکربن‌های حلقوی و آروماتیک",
    "start": 43,
    "end": 43
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 316,
    "title": "نفت و پالایش آن",
    "start": 44,
    "end": 47
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 317,
    "title": "تمرین‌های دوره‌ای",
    "start": 48,
    "end": 50
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 300,
    "title": "کل فصل",
    "start": 51,
    "end": 98
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 301,
    "title": "غذا، مواد مغذی و انرژی",
    "start": 52,
    "end": 53
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 302,
    "title": "غذا، ماده و انرژی و گرماشیمی",
    "start": 54,
    "end": 55
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 303,
    "title": "دما و انرژی گرمایی",
    "start": 56,
    "end": 58
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 304,
    "title": "ظرفیت گرمایی",
    "start": 59,
    "end": 59
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 305,
    "title": "جاری شدن انرژی گرمایی و سامانه",
    "start": 60,
    "end": 61
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 306,
    "title": "گرما در واکنش‌های شیمیایی",
    "start": 62,
    "end": 64
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 307,
    "title": "آنتالپی",
    "start": 65,
    "end": 66
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 308,
    "title": "آنتالپی پیوند",
    "start": 67,
    "end": 69
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 309,
    "title": "گروه‌های عاملی اکسیژن‌دار",
    "start": 70,
    "end": 71
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 310,
    "title": "آنتالپی سوختن",
    "start": 72,
    "end": 73
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 311,
    "title": "قانون هس و جمع‌پذیری گرمای واکنش",
    "start": 74,
    "end": 76
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 312,
    "title": "غذای سالم",
    "start": 77,
    "end": 78
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 313,
    "title": "آهنگ واکنش و عوامل مؤثر",
    "start": 79,
    "end": 84
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 314,
    "title": "سینتیک شیمیایی و سرعت واکنش",
    "start": 85,
    "end": 87
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 315,
    "title": "سرعت متوسط و شیب نمودار",
    "start": 88,
    "end": 89
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 316,
    "title": "بازدارنده‌های طبیعی",
    "start": 90,
    "end": 92
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 317,
    "title": "غذا، پسماند و ردپای آن",
    "start": 93,
    "end": 95
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 318,
    "title": "تمرین‌های دوره‌ای",
    "start": 96,
    "end": 98
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 300,
    "title": "کل فصل",
    "start": 99,
    "end": 123
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 301,
    "title": "پوشاک و تولید آن",
    "start": 100,
    "end": 101
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 302,
    "title": "الیاف و درشت‌مولکول‌ها",
    "start": 102,
    "end": 103
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 303,
    "title": "بسپارش و مونومر",
    "start": 104,
    "end": 106
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 304,
    "title": "تولید و کاربرد پلیمرها",
    "start": 107,
    "end": 108
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 305,
    "title": "پلی‌استرها",
    "start": 109,
    "end": 110
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 306,
    "title": "الکل‌ها و اسیدها",
    "start": 111,
    "end": 113
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 307,
    "title": "واکنش استری شدن",
    "start": 114,
    "end": 115
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 308,
    "title": "پلی‌آمیدها و کولار",
    "start": 116,
    "end": 117
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 309,
    "title": "پلیمرهای ماندگار و تخریب‌پذیر",
    "start": 118,
    "end": 120
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 310,
    "title": "پلیمر سبز",
    "start": 121,
    "end": 121
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 311,
    "title": "تمرین‌های دوره‌ای",
    "start": 122,
    "end": 123
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 300,
    "title": "کل فصل",
    "start": 1,
    "end": 36
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 301,
    "title": "پاکیزگی و بهداشت",
    "start": 2,
    "end": 3
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 302,
    "title": "پاکیزگی محیط با مولکول‌ها",
    "start": 4,
    "end": 4
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 303,
    "title": "اسیدهای چرب و صابون",
    "start": 5,
    "end": 6
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 304,
    "title": "کلوئید و سوسپانسیون",
    "start": 7,
    "end": 7
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 305,
    "title": "شویندگی صابون و آب سخت",
    "start": 8,
    "end": 9
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 306,
    "title": "پاک‌کننده‌های غیرصابونی",
    "start": 10,
    "end": 11
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 307,
    "title": "پاک‌کننده‌های خورنده",
    "start": 12,
    "end": 12
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 308,
    "title": "اسیدها و بازها",
    "start": 13,
    "end": 15
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 309,
    "title": "رسانایی الکتریکی و قدرت اسیدی",
    "start": 16,
    "end": 18
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 310,
    "title": "درجه یونش",
    "start": 19,
    "end": 19
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 311,
    "title": "تعادل شیمیایی و قدرت اسیدی",
    "start": 20,
    "end": 21
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 312,
    "title": "ثابت تعادل و ثابت یونش اسید",
    "start": 22,
    "end": 23
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 313,
    "title": "مقیاس pH",
    "start": 24,
    "end": 27
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 314,
    "title": "بازها و محلول‌های بازی",
    "start": 28,
    "end": 29
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 315,
    "title": "عملکرد شوینده‌های خورنده",
    "start": 30,
    "end": 30
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 316,
    "title": "واکنش خنثی شدن و ضداسیدها",
    "start": 31,
    "end": 32
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 317,
    "title": "تمرین‌های دوره‌ای",
    "start": 33,
    "end": 36
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 300,
    "title": "کل فصل",
    "start": 37,
    "end": 66
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 301,
    "title": "الکتروشیمی",
    "start": 38,
    "end": 38
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 302,
    "title": "واکنش اکسایش و کاهش",
    "start": 39,
    "end": 41
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 303,
    "title": "جریان انرژی و سفر الکترون",
    "start": 42,
    "end": 43
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 304,
    "title": "سلول گالوانی",
    "start": 44,
    "end": 45
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 305,
    "title": "نیروی الکتروموتوری و پتانسیل استاندارد",
    "start": 46,
    "end": 48
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 306,
    "title": "لیتیم و باتری‌ها",
    "start": 49,
    "end": 50
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 307,
    "title": "سلول سوختی",
    "start": 50,
    "end": 54
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 308,
    "title": "عدد اکسایش",
    "start": 52,
    "end": 53
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 309,
    "title": "سلول الکترولیتی و برقکافت",
    "start": 54,
    "end": 55
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 310,
    "title": "خوردگی و واکنش ناخواسته",
    "start": 56,
    "end": 57
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 311,
    "title": "حفاظت آهن و فلز فداشونده",
    "start": 58,
    "end": 59
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 312,
    "title": "آبکاری",
    "start": 60,
    "end": 61
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 313,
    "title": "فرایند هال",
    "start": 62,
    "end": 62
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 314,
    "title": "تمرین‌های دوره‌ای",
    "start": 63,
    "end": 66
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 300,
    "title": "کل فصل",
    "start": 67,
    "end": 90
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 301,
    "title": "خاک رس و درصد جرمی",
    "start": 69,
    "end": 69
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 302,
    "title": "سیلیس، کوارتز و ماندگاری",
    "start": 70,
    "end": 71
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 303,
    "title": "گرافن",
    "start": 72,
    "end": 72
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 304,
    "title": "سازه‌های یخی",
    "start": 73,
    "end": 74
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 305,
    "title": "رفتار مولکول‌ها و توزیع الکترون‌ها",
    "start": 75,
    "end": 76
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 306,
    "title": "شاره‌های مولکولی و یونی",
    "start": 77,
    "end": 78
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 307,
    "title": "چینش یون‌ها در جامد یونی",
    "start": 79,
    "end": 82
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 308,
    "title": "فلزها و مدل دریای الکترونی",
    "start": 83,
    "end": 84
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 309,
    "title": "رنگ و رنگ‌دانه",
    "start": 85,
    "end": 86
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 310,
    "title": "تیتانیم و نیتینول",
    "start": 87,
    "end": 88
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 311,
    "title": "تمرین‌های دوره‌ای",
    "start": 89,
    "end": 90
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 300,
    "title": "کل فصل",
    "start": 91,
    "end": 123
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 301,
    "title": "هوای پاک و آلاینده‌ها",
    "start": 93,
    "end": 94
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 302,
    "title": "طیف‌سنجی فروسرخ",
    "start": 95,
    "end": 95
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 303,
    "title": "انرژی فعال‌سازی واکنش‌ها",
    "start": 96,
    "end": 100
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 304,
    "title": "مبدل کاتالیستی",
    "start": 101,
    "end": 102
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 305,
    "title": "آمونیاک و بهره‌وری کشاورزی",
    "start": 103,
    "end": 104
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 306,
    "title": "اصل لوشاتلیه و تعادل",
    "start": 105,
    "end": 105
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 307,
    "title": "تغییر حجم در تعادل گازی",
    "start": 106,
    "end": 106
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 308,
    "title": "اثر دما بر تعادل",
    "start": 107,
    "end": 110
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 309,
    "title": "ارزش فناوری‌های شیمیایی",
    "start": 111,
    "end": 112
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 310,
    "title": "گروه عاملی و سنتز مولکول‌های آلی",
    "start": 113,
    "end": 114
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 311,
    "title": "ساخت بطری پلی‌اتیلن ترفتال‌ات",
    "start": 115,
    "end": 118
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 312,
    "title": "بازیافت",
    "start": 119,
    "end": 121
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 313,
    "title": "تمرین‌های دوره‌ای",
    "start": 122,
    "end": 123
  }
]$topics$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)),
fields(field) as (values ('mathematics'),('experimental_sciences')), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v187:'||f.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',f.field,p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join fields f cross join tracks r cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 1,
    "title": "عنصرها چگونه پدید آمدند؟",
    "start": 2,
    "end": 4
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 2,
    "title": "آیا همه اتم‌های یک عنصر پایدارند؟",
    "start": 5,
    "end": 8
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 3,
    "title": "طبقه‌بندی عنصرها",
    "start": 9,
    "end": 18
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 4,
    "title": "نور، کلید شناخت جهان",
    "start": 19,
    "end": 23
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 5,
    "title": "کشف ساختار اتم",
    "start": 24,
    "end": 29
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 6,
    "title": "آرایش الکترونی اتم",
    "start": 30,
    "end": 33
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "position": 7,
    "title": "ساختار اتم و رفتار آن",
    "start": 34,
    "end": 41
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 1,
    "title": "هواکره",
    "start": 48,
    "end": 53
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 2,
    "title": "ترکیب اکسیژن با فلزها و نافلزها و ساختار لوویس",
    "start": 55,
    "end": 59
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 3,
    "title": "خواص اکسیدهای فلزی و نافلزی",
    "start": 60,
    "end": 61
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 4,
    "title": "واکنش‌های شیمیایی و قانون پایستگی جرم",
    "start": 62,
    "end": 65
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 5,
    "title": "چه بر سر هواکره می‌آوریم؟",
    "start": 66,
    "end": 75
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 6,
    "title": "خواص و رفتار گازها",
    "start": 76,
    "end": 78
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "position": 7,
    "title": "استوکیومتری واکنش‌ها",
    "start": 79,
    "end": 81
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 1,
    "title": "آب‌کره",
    "start": 85,
    "end": 92
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 2,
    "title": "محلول و مقدار حل‌شونده‌ها",
    "start": 93,
    "end": 99
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 3,
    "title": "آیا نمک‌ها به یک اندازه در آب حل می‌شوند؟",
    "start": 100,
    "end": 102
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 4,
    "title": "رفتار آب و دیگر مولکول‌ها در میدان الکتریکی",
    "start": 103,
    "end": 104
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 5,
    "title": "نیروهای بین‌مولکولی آب، فراتر از انتظار",
    "start": 105,
    "end": 108
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 6,
    "title": "آب و دیگر حلال‌ها و انحلال‌پذیری گازها",
    "start": 109,
    "end": 115
  },
  {
    "grade": "10",
    "subject": "شیمی ۱",
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "position": 7,
    "title": "ردپای آب در زندگی",
    "start": 116,
    "end": 119
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 1,
    "title": "هدایای زمینی",
    "start": 1,
    "end": 5
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 2,
    "title": "الگوها و روندها در رفتار مواد و عنصرها",
    "start": 6,
    "end": 9
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 3,
    "title": "رفتار عنصرها و شعاع اتم",
    "start": 10,
    "end": 13
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 4,
    "title": "دنیایی رنگی با عنصرهای دسته d",
    "start": 14,
    "end": 17
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 5,
    "title": "عنصرها به چه شکلی در طبیعت یافت می‌شوند",
    "start": 18,
    "end": 21
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 6,
    "title": "دنیای واقعی واکنش‌ها",
    "start": 22,
    "end": 28
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 7,
    "title": "نفت، هدیه‌ای شگفت‌انگیز",
    "start": 29,
    "end": 30
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 8,
    "title": "هیدروکربن‌ها",
    "start": 31,
    "end": 43
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۱: قدر هدایای زمینی را بدانیم",
    "position": 9,
    "title": "نفت، ماده‌ای که اقتصاد جهان را دگرگون ساخت",
    "start": 44,
    "end": 47
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 1,
    "title": "مفاهیم اولیه ترموشیمی",
    "start": 51,
    "end": 59
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 2,
    "title": "جاری شدن انرژی گرمایی",
    "start": 60,
    "end": 61
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 3,
    "title": "آنتالپی، آنتالپی پیوند، گروه‌های عاملی اکسیژن‌دار و آنتالپی سوختن",
    "start": 65,
    "end": 73
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 4,
    "title": "تعیین آنتالپی واکنش‌های شیمیایی",
    "start": 74,
    "end": 76
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 5,
    "title": "سرعت فرایندهای شیمیایی",
    "start": 79,
    "end": 92
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۲: در پی غذای سالم",
    "position": 6,
    "title": "غذا، پسماند و ردپای آن",
    "start": 93,
    "end": 95
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 1,
    "title": "مفاهیم اولیه تولید پوشاک",
    "start": 99,
    "end": 101
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 2,
    "title": "الیاف و درشت‌مولکول‌ها",
    "start": 102,
    "end": 108
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 3,
    "title": "پلی‌استرها، الکل‌ها و اسیدها",
    "start": 109,
    "end": 113
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 4,
    "title": "واکنش استری شدن",
    "start": 114,
    "end": 115
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 5,
    "title": "پلی‌آمیدها",
    "start": 116,
    "end": 117
  },
  {
    "grade": "11",
    "subject": "شیمی ۲",
    "chapter": "فصل ۳: پوشاک، نیازی پایان‌ناپذیر",
    "position": 6,
    "title": "پلیمرها، ماندگار یا تخریب‌پذیر",
    "start": 118,
    "end": 121
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 1,
    "title": "زندگی با شوینده‌ها، آلاینده‌ها و پاک‌کننده‌ها",
    "start": 2,
    "end": 9
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 2,
    "title": "پاک‌کننده‌های غیرصابونی و خورنده",
    "start": 10,
    "end": 12
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 3,
    "title": "اسیدها و بازها و رسانایی الکتریکی و درجه یونش اسیدها",
    "start": 13,
    "end": 19
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 4,
    "title": "سامانه‌های تعادلی و pH محلول‌ها",
    "start": 20,
    "end": 29
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "position": 5,
    "title": "واکنش شوینده‌های خورنده",
    "start": 30,
    "end": 32
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 1,
    "title": "الکتروشیمی و واکنش‌های اکسایش و کاهش",
    "start": 38,
    "end": 41
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 2,
    "title": "تبدیل انرژی شیمیایی به الکتریکی",
    "start": 42,
    "end": 49
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 3,
    "title": "تولید انرژی سبز با سلول سوختی و برقکافت",
    "start": 50,
    "end": 55
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "position": 4,
    "title": "خوردگی و رقابت برای اکسایش",
    "start": 56,
    "end": 59
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 1,
    "title": "سیلیس رمز ماندگاری، گرافن و سازه‌های یخی",
    "start": 70,
    "end": 74
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 2,
    "title": "رفتار مولکول‌ها و توزیع الکترون‌ها، شاره‌های مولکولی و یونی",
    "start": 75,
    "end": 78
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 3,
    "title": "چینش یون‌ها در جامد یونی",
    "start": 79,
    "end": 82
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "position": 4,
    "title": "فلزها، عنصرهایی شکل‌پذیر با جلایی زیبا",
    "start": 83,
    "end": 84
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 1,
    "title": "کاهش آلودگی هوا و انرژی فعال‌سازی واکنش‌ها",
    "start": 93,
    "end": 102
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 2,
    "title": "آمونیاک و بهره‌وری در کشاورزی و تغییر حجم سامانه در تعادل‌های گازی",
    "start": 103,
    "end": 110
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 3,
    "title": "ارزش فناوری‌های شیمیایی و سنتز مولکول‌های آلی",
    "start": 111,
    "end": 114
  },
  {
    "grade": "12",
    "subject": "شیمی ۳",
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "position": 4,
    "title": "بطری PET و بازیافت آن",
    "start": 115,
    "end": 121
  }
]$fixes$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)), fields(field) as (values ('mathematics'),('experimental_sciences')), tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join fields f cross join tracks r
where t.id=md5('nova:planner:1405:v1:'||f.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field=f.field and t.grade=p.grade and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
