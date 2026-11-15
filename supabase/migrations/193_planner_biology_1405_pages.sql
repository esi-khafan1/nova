-- User-supplied 1405 biology books: actual printed pages; see planner-topic-sources.
-- One-time additive selections and CAS repairs only for unchanged empty-page legacy rows.
with installed as (insert into private.planner_seed_installations(seed_key) values ('biology10-12-1405-v193') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۱: دنیای زنده",
    "position": 300,
    "title": "کل فصل",
    "start": 1,
    "end": 16
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۱: دنیای زنده",
    "position": 301,
    "title": "گفتار: زیست‌شناسی چیست؟",
    "start": 2,
    "end": 6
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۱: دنیای زنده",
    "position": 302,
    "title": "گفتار: گستره حیات",
    "start": 7,
    "end": 10
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۱: دنیای زنده",
    "position": 303,
    "title": "گفتار: یاخته و بافت در بدن انسان",
    "start": 11,
    "end": 16
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۱: دنیای زنده",
    "position": 304,
    "title": "محدوده علم زیست‌شناسی",
    "start": 2,
    "end": 2
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۱: دنیای زنده",
    "position": 305,
    "title": "زیست‌شناسی نوین",
    "start": 3,
    "end": 3
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۱: دنیای زنده",
    "position": 306,
    "title": "زیست‌شناسی در خدمت انسان",
    "start": 4,
    "end": 6
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۱: دنیای زنده",
    "position": 307,
    "title": "مولکول‌های زیستی",
    "start": 8,
    "end": 8
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۱: دنیای زنده",
    "position": 308,
    "title": "کربوهیدرات‌ها",
    "start": 9,
    "end": 9
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۱: دنیای زنده",
    "position": 309,
    "title": "لیپیدها، پروتئین‌ها و نوکلئیک اسیدها",
    "start": 10,
    "end": 10
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۱: دنیای زنده",
    "position": 310,
    "title": "غشای یاخته و سیتوپلاسم",
    "start": 12,
    "end": 16
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۲: گوارش و جذب مواد",
    "position": 300,
    "title": "کل فصل",
    "start": 17,
    "end": 32
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۲: گوارش و جذب مواد",
    "position": 301,
    "title": "گفتار: ساختار و عملکرد لوله گوارش",
    "start": 18,
    "end": 24
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۲: گوارش و جذب مواد",
    "position": 302,
    "title": "گفتار: جذب مواد و تنظیم فعالیت دستگاه گوارش",
    "start": 25,
    "end": 29
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۲: گوارش و جذب مواد",
    "position": 303,
    "title": "گفتار: تنوع گوارش در جانداران",
    "start": 30,
    "end": 32
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۲: گوارش و جذب مواد",
    "position": 304,
    "title": "گوارش غذا",
    "start": 19,
    "end": 24
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۲: گوارش و جذب مواد",
    "position": 305,
    "title": "جذب مواد در روده باریک",
    "start": 25,
    "end": 25
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۲: گوارش و جذب مواد",
    "position": 306,
    "title": "روده بزرگ و دفع",
    "start": 26,
    "end": 26
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۲: گوارش و جذب مواد",
    "position": 307,
    "title": "گردش خون دستگاه گوارش و تنظیم فرایندهای گوارشی",
    "start": 27,
    "end": 27
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۲: گوارش و جذب مواد",
    "position": 308,
    "title": "وزن مناسب",
    "start": 28,
    "end": 29
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 300,
    "title": "کل فصل",
    "start": 33,
    "end": 46
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 301,
    "title": "گفتار: سازوکار دستگاه تنفس در انسان",
    "start": 34,
    "end": 39
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 302,
    "title": "گفتار: تهویه ششی",
    "start": 40,
    "end": 44
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 303,
    "title": "گفتار: تنوع تبادلات گازی",
    "start": 45,
    "end": 46
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 304,
    "title": "چرا نفس می‌کشیم؟",
    "start": 34,
    "end": 34
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 305,
    "title": "بخش‌های عملکردی دستگاه تنفس و بخش هادی",
    "start": 35,
    "end": 36
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 306,
    "title": "بخش مبادله‌ای",
    "start": 37,
    "end": 38
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 307,
    "title": "حمل گازها در خون",
    "start": 39,
    "end": 39
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 308,
    "title": "شش‌ها",
    "start": 40,
    "end": 41
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 309,
    "title": "حجم‌های تنفسی",
    "start": 42,
    "end": 42
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 310,
    "title": "ظرفیت‌های تنفسی",
    "start": 43,
    "end": 43
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 311,
    "title": "تنظیم تنفس و سایر اعمال دستگاه تنفس",
    "start": 44,
    "end": 44
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 312,
    "title": "تنفس پوستی و نایدیسی",
    "start": 45,
    "end": 45
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۳: تبادلات گازی",
    "position": 313,
    "title": "تنفس آبششی و ششی",
    "start": 46,
    "end": 46
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 300,
    "title": "کل فصل",
    "start": 47,
    "end": 68
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 301,
    "title": "گفتار: قلب",
    "start": 48,
    "end": 54
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 302,
    "title": "گفتار: رگ‌ها",
    "start": 55,
    "end": 60
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 303,
    "title": "گفتار: خون",
    "start": 61,
    "end": 64
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 304,
    "title": "گفتار: تنوع گردش مواد در جانداران",
    "start": 65,
    "end": 68
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 305,
    "title": "دریچه‌های قلب و تأمین اکسیژن قلب",
    "start": 49,
    "end": 49
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 306,
    "title": "صداهای قلب",
    "start": 50,
    "end": 50
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 307,
    "title": "ساختار بافتی و ماهیچه‌ای قلب",
    "start": 51,
    "end": 51
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 308,
    "title": "چرخه ضربان و شبکه هادی قلب",
    "start": 52,
    "end": 52
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 309,
    "title": "برون‌ده قلبی",
    "start": 53,
    "end": 53
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 310,
    "title": "نوار قلب",
    "start": 54,
    "end": 54
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 311,
    "title": "سرخرگ‌ها",
    "start": 56,
    "end": 56
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 312,
    "title": "مویرگ‌ها",
    "start": 57,
    "end": 57
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 313,
    "title": "تبادل مواد در مویرگ و سیاهرگ‌ها",
    "start": 58,
    "end": 58
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 314,
    "title": "دستگاه لنفی",
    "start": 59,
    "end": 59
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 315,
    "title": "تنظیم دستگاه گردش خون",
    "start": 60,
    "end": 60
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 316,
    "title": "یاخته‌های خونی قرمز",
    "start": 62,
    "end": 62
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 317,
    "title": "یاخته‌های خونی سفید",
    "start": 63,
    "end": 63
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 318,
    "title": "گرده‌ها",
    "start": 64,
    "end": 64
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۴: گردش مواد در بدن",
    "position": 319,
    "title": "قلب و سامانه‌های گردش در پرندگان و پستانداران",
    "start": 67,
    "end": 68
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۵: تنظیم اسمزی و دفع مواد زائد",
    "position": 300,
    "title": "کل فصل",
    "start": 69,
    "end": 78
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۵: تنظیم اسمزی و دفع مواد زائد",
    "position": 301,
    "title": "گفتار: هم‌ایستایی و کلیه‌ها",
    "start": 70,
    "end": 72
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۵: تنظیم اسمزی و دفع مواد زائد",
    "position": 302,
    "title": "گفتار: تشکیل ادرار و تخلیه آن",
    "start": 73,
    "end": 75
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۵: تنظیم اسمزی و دفع مواد زائد",
    "position": 303,
    "title": "گفتار: تنوع دفع و تنظیم اسمزی در جانداران",
    "start": 76,
    "end": 78
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۵: تنظیم اسمزی و دفع مواد زائد",
    "position": 304,
    "title": "کلیه‌ها",
    "start": 70,
    "end": 71
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۵: تنظیم اسمزی و دفع مواد زائد",
    "position": 305,
    "title": "گردیزه و گردش خون در کلیه",
    "start": 72,
    "end": 72
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۵: تنظیم اسمزی و دفع مواد زائد",
    "position": 306,
    "title": "تخلیه ادرار",
    "start": 74,
    "end": 75
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۵: تنظیم اسمزی و دفع مواد زائد",
    "position": 307,
    "title": "دفع در بی‌مهرگان",
    "start": 76,
    "end": 76
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۵: تنظیم اسمزی و دفع مواد زائد",
    "position": 308,
    "title": "دفع در مهره‌داران",
    "start": 77,
    "end": 78
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 300,
    "title": "کل فصل",
    "start": 79,
    "end": 96
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 301,
    "title": "گفتار: ویژگی‌های یاخته گیاهی",
    "start": 80,
    "end": 85
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 302,
    "title": "گفتار: سامانه بافتی",
    "start": 86,
    "end": 89
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 303,
    "title": "گفتار: ساختار گیاهان",
    "start": 90,
    "end": 96
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 304,
    "title": "دیواره یاخته‌ای",
    "start": 80,
    "end": 81
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 305,
    "title": "واکوئول و ذخیره",
    "start": 82,
    "end": 82
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 306,
    "title": "رنگ‌ها در گیاهان",
    "start": 83,
    "end": 83
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 307,
    "title": "ترکیبات دیگر در گیاهان",
    "start": 84,
    "end": 85
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 308,
    "title": "سامانه بافت پوششی",
    "start": 86,
    "end": 86
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 309,
    "title": "سامانه بافت زمینه‌ای",
    "start": 87,
    "end": 87
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 310,
    "title": "سامانه بافت آوندی",
    "start": 88,
    "end": 89
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 311,
    "title": "از دانه تا درخت",
    "start": 90,
    "end": 91
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 312,
    "title": "مریستم‌هایی که بعداً عمل می‌کنند",
    "start": 92,
    "end": 93
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۶: از یاخته تا گیاه",
    "position": 313,
    "title": "سازش با محیط",
    "start": 94,
    "end": 96
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 300,
    "title": "کل فصل",
    "start": 97,
    "end": 111
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 301,
    "title": "گفتار: تغذیه گیاهی",
    "start": 98,
    "end": 101
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 302,
    "title": "گفتار: جانداران مؤثر در تغذیه گیاهی",
    "start": 102,
    "end": 104
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 303,
    "title": "گفتار: انتقال مواد در گیاهان",
    "start": 105,
    "end": 111
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 304,
    "title": "خاک و جذب مواد معدنی",
    "start": 98,
    "end": 98
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 305,
    "title": "جذب نیتروژن و فسفر",
    "start": 99,
    "end": 99
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 306,
    "title": "بهبود خاک",
    "start": 100,
    "end": 101
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 307,
    "title": "قارچ ریشه‌ای",
    "start": 102,
    "end": 102
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 308,
    "title": "همزیستی گیاه با تثبیت‌کننده‌های نیتروژن",
    "start": 103,
    "end": 103
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 309,
    "title": "روش‌های دیگر به دست آوردن مواد غذایی",
    "start": 104,
    "end": 104
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 310,
    "title": "انتقال از خاک به برگ و جابه‌جایی در مسیر کوتاه",
    "start": 105,
    "end": 106
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 311,
    "title": "انتقال آب و مواد معدنی در مسیرهای بلند",
    "start": 107,
    "end": 108
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 312,
    "title": "تعریق و عوامل باز و بسته شدن روزنه‌ها",
    "start": 109,
    "end": 109
  },
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 313,
    "title": "حرکت شیره پرورده",
    "start": 110,
    "end": 111
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 300,
    "title": "کل فصل",
    "start": 1,
    "end": 18
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 301,
    "title": "گفتار: یاخته‌های بافت عصبی",
    "start": 2,
    "end": 8
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 302,
    "title": "گفتار: ساختار دستگاه عصبی",
    "start": 9,
    "end": 18
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 303,
    "title": "انواع یاخته‌های عصبی و ایجاد پیام عصبی",
    "start": 3,
    "end": 5
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 304,
    "title": "نقش گره‌های رانویه",
    "start": 6,
    "end": 6
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 305,
    "title": "انتقال پیام عصبی",
    "start": 7,
    "end": 8
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 306,
    "title": "دستگاه عصبی مرکزی",
    "start": 9,
    "end": 10
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 307,
    "title": "ساختارهای دیگر مغز",
    "start": 11,
    "end": 13
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 308,
    "title": "تشریح مغز",
    "start": 14,
    "end": 15
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 309,
    "title": "دستگاه عصبی محیطی",
    "start": 16,
    "end": 17
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 310,
    "title": "دستگاه عصبی جانوران",
    "start": 18,
    "end": 18
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 300,
    "title": "کل فصل",
    "start": 19,
    "end": 36
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 301,
    "title": "گفتار: گیرنده‌های حسی",
    "start": 20,
    "end": 22
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 302,
    "title": "گفتار: حواس ویژه",
    "start": 23,
    "end": 32
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 303,
    "title": "گفتار: گیرنده‌های حسی جانوران",
    "start": 33,
    "end": 36
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 304,
    "title": "کار گیرنده‌های حسی و سازش گیرنده‌ها",
    "start": 20,
    "end": 20
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 305,
    "title": "حواس پیکری",
    "start": 21,
    "end": 22
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 306,
    "title": "بینایی",
    "start": 23,
    "end": 24
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 307,
    "title": "بیماری‌های چشم",
    "start": 25,
    "end": 27
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 308,
    "title": "شنوایی و تعادل",
    "start": 28,
    "end": 29
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 309,
    "title": "حفظ تعادل",
    "start": 30,
    "end": 30
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 310,
    "title": "بویایی",
    "start": 31,
    "end": 31
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 311,
    "title": "چشایی و پردازش اطلاعات حسی",
    "start": 32,
    "end": 32
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 300,
    "title": "کل فصل",
    "start": 37,
    "end": 52
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 301,
    "title": "گفتار: استخوان‌ها و اسکلت",
    "start": 38,
    "end": 44
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 302,
    "title": "گفتار: ماهیچه و حرکت",
    "start": 45,
    "end": 52
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 303,
    "title": "اعمال استخوان",
    "start": 38,
    "end": 38
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 304,
    "title": "انواع استخوان",
    "start": 39,
    "end": 39
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 305,
    "title": "تشکیل و تخریب استخوان",
    "start": 40,
    "end": 44
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 306,
    "title": "ساختار ماهیچه اسکلتی",
    "start": 46,
    "end": 47
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 307,
    "title": "مکانیسم انقباض ماهیچه",
    "start": 48,
    "end": 49
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 308,
    "title": "تأمین انرژی انقباض و انواع یاخته‌های ماهیچه‌ای",
    "start": 50,
    "end": 51
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 309,
    "title": "حرکت در جانوران",
    "start": 52,
    "end": 52
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 300,
    "title": "کل فصل",
    "start": 53,
    "end": 62
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 301,
    "title": "گفتار: ارتباط شیمیایی",
    "start": 54,
    "end": 55
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 302,
    "title": "گفتار: غده‌های درون‌ریز",
    "start": 56,
    "end": 62
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 303,
    "title": "پیک شیمیایی، کوتاه‌برد و دوربرد",
    "start": 54,
    "end": 54
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 304,
    "title": "غده‌های بدن",
    "start": 55,
    "end": 55
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 305,
    "title": "هیپوفیز و بخش پیشین",
    "start": 56,
    "end": 56
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 306,
    "title": "بخش پسین هیپوفیز",
    "start": 57,
    "end": 57
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 307,
    "title": "غده تیروئید",
    "start": 58,
    "end": 58
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 308,
    "title": "غده‌های پاراتیروئید و فوق کلیه",
    "start": 59,
    "end": 59
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 309,
    "title": "غده لوزالمعده",
    "start": 60,
    "end": 60
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 310,
    "title": "تنظیم ترشح و پاسخ به هورمون‌ها و سایر غدد",
    "start": 61,
    "end": 61
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 311,
    "title": "ارتباط شیمیایی در جانوران",
    "start": 62,
    "end": 62
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 300,
    "title": "کل فصل",
    "start": 63,
    "end": 78
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 301,
    "title": "گفتار: نخستین خط دفاعی: ورود ممنوع",
    "start": 64,
    "end": 65
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 302,
    "title": "گفتار: دومین خط دفاعی: واکنش‌های عمومی اما سریع",
    "start": 66,
    "end": 71
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 303,
    "title": "گفتار: سومین خط دفاعی: دفاع اختصاصی",
    "start": 72,
    "end": 78
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 304,
    "title": "خودی و بیگانه و بیگانه‌خوارها",
    "start": 66,
    "end": 66
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 305,
    "title": "گویچه‌های سفید",
    "start": 67,
    "end": 69
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 306,
    "title": "پاسخ التهابی و پروتئین‌ها",
    "start": 70,
    "end": 71
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 307,
    "title": "لنفوسیت‌ها و شناسایی پادگن؛ عملکرد لنفوسیت B",
    "start": 72,
    "end": 73
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 308,
    "title": "عملکرد لنفوسیت T و پاسخ اولیه و ثانویه",
    "start": 74,
    "end": 75
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 309,
    "title": "ایدز و ایمنی اختصاصی",
    "start": 76,
    "end": 76
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 310,
    "title": "حساسیت",
    "start": 77,
    "end": 77
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 311,
    "title": "بیماری‌های خودایمنی",
    "start": 78,
    "end": 78
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 300,
    "title": "کل فصل",
    "start": 79,
    "end": 96
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 301,
    "title": "گفتار: فام‌تن (کروموزوم)",
    "start": 80,
    "end": 83
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 302,
    "title": "گفتار: رشتمان (میتوز)",
    "start": 84,
    "end": 91
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 303,
    "title": "گفتار: کاستمان (میوز) و تولیدمثل جنسی",
    "start": 92,
    "end": 96
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 304,
    "title": "تعداد فام‌تن و یاخته‌های دولاد",
    "start": 81,
    "end": 81
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 305,
    "title": "چرخه یاخته‌ای",
    "start": 82,
    "end": 83
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 306,
    "title": "تقسیم سیتوپلاسم",
    "start": 85,
    "end": 86
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 307,
    "title": "تنظیم تقسیم یاخته",
    "start": 87,
    "end": 87
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 308,
    "title": "تقسیم بی‌رویه یاخته",
    "start": 88,
    "end": 88
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 309,
    "title": "تشخیص و درمان سرطان",
    "start": 89,
    "end": 89
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 310,
    "title": "نقش محیط و وراثت در سرطان",
    "start": 90,
    "end": 90
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 311,
    "title": "مرگ برنامه‌ریزی‌شده یاخته",
    "start": 91,
    "end": 91
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 312,
    "title": "کاستمان ۱",
    "start": 92,
    "end": 92
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 313,
    "title": "کاستمان ۲",
    "start": 93,
    "end": 93
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 314,
    "title": "تغییر تعداد فام‌تن‌ها",
    "start": 94,
    "end": 96
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 300,
    "title": "کل فصل",
    "start": 97,
    "end": 118
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 301,
    "title": "گفتار: دستگاه تولیدمثل در مرد",
    "start": 98,
    "end": 101
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 302,
    "title": "گفتار: دستگاه تولیدمثل در زن",
    "start": 102,
    "end": 107
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 303,
    "title": "گفتار: رشد و نمو جنین",
    "start": 108,
    "end": 114
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 304,
    "title": "گفتار: تولیدمثل در جانوران",
    "start": 115,
    "end": 118
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 305,
    "title": "زامه‌زایی",
    "start": 99,
    "end": 99
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 306,
    "title": "ساختار زامه و اندام‌های ضمیمه",
    "start": 100,
    "end": 101
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 307,
    "title": "تخمک‌زایی و دوره جنسی زنان",
    "start": 103,
    "end": 105
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 308,
    "title": "تنظیم هورمونی دستگاه تولیدمثل زن",
    "start": 106,
    "end": 107
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 309,
    "title": "وقایع پس از لقاح",
    "start": 109,
    "end": 110
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 310,
    "title": "کنترل ورود و خروج مواد در جفت و تشکیل بیش از یک جنین",
    "start": 111,
    "end": 111
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 311,
    "title": "رشد و نمو جنین و صوت‌نگاری",
    "start": 112,
    "end": 112
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 312,
    "title": "زایمان و تولد",
    "start": 113,
    "end": 114
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 313,
    "title": "نحوه لقاح در جانوران",
    "start": 115,
    "end": 115
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 314,
    "title": "بکرزایی و نرماده",
    "start": 116,
    "end": 116
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 315,
    "title": "تغذیه و حفاظت جنین",
    "start": 117,
    "end": 118
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 300,
    "title": "کل فصل",
    "start": 119,
    "end": 136
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 301,
    "title": "گفتار: تولیدمثل غیرجنسی",
    "start": 120,
    "end": 123
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 302,
    "title": "گفتار: تولیدمثل جنسی",
    "start": 124,
    "end": 129
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 303,
    "title": "گفتار: از یاخته تخم تا گیاه",
    "start": 130,
    "end": 136
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 304,
    "title": "تکثیر با بخش‌های رویشی",
    "start": 120,
    "end": 120
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 305,
    "title": "بخش‌های تخصص‌یافته",
    "start": 121,
    "end": 122
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 306,
    "title": "فناوری و تکثیر گیاهان",
    "start": 123,
    "end": 123
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 307,
    "title": "هر گلی کامل نیست",
    "start": 124,
    "end": 124
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 308,
    "title": "تشکیل یاخته‌های جنسی",
    "start": 125,
    "end": 126
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 309,
    "title": "گرده‌افشانی و لقاح",
    "start": 127,
    "end": 127
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 310,
    "title": "گل‌ها و گرده‌افشان‌ها",
    "start": 128,
    "end": 129
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 311,
    "title": "تقسیم یاخته تخم",
    "start": 130,
    "end": 130
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 312,
    "title": "رویش دانه",
    "start": 131,
    "end": 133
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 313,
    "title": "طول عمر گیاهان",
    "start": 134,
    "end": 136
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 300,
    "title": "کل فصل",
    "start": 137,
    "end": 152
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 301,
    "title": "گفتار: تنظیم‌کننده‌های رشد در گیاهان",
    "start": 138,
    "end": 145
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 302,
    "title": "گفتار: پاسخ به محیط",
    "start": 146,
    "end": 152
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 303,
    "title": "اولین آزمایش",
    "start": 138,
    "end": 139
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 304,
    "title": "محرک‌های رشد",
    "start": 140,
    "end": 142
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 305,
    "title": "بازدارنده‌های رشد",
    "start": 143,
    "end": 145
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 306,
    "title": "پاسخ به نور",
    "start": 146,
    "end": 146
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 307,
    "title": "پاسخ به دما و گرانش زمین",
    "start": 147,
    "end": 147
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 308,
    "title": "پاسخ به تماس و پاسخ‌های دفاعی",
    "start": 148,
    "end": 150
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 309,
    "title": "حفاظت گیاهان توسط جانوران",
    "start": 151,
    "end": 152
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 300,
    "title": "کل فصل",
    "start": 1,
    "end": 20
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 301,
    "title": "گفتار: نوکلئیک اسیدها",
    "start": 2,
    "end": 8
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 302,
    "title": "گفتار: همانندسازی دنا",
    "start": 9,
    "end": 14
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 303,
    "title": "گفتار: پروتئین‌ها",
    "start": 15,
    "end": 20
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 304,
    "title": "دنا عامل اصلی انتقال صفات وراثتی",
    "start": 3,
    "end": 3
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 305,
    "title": "ساختار نوکلئیک اسیدها",
    "start": 4,
    "end": 4
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 306,
    "title": "کشف ساختار مولکولی دنا",
    "start": 5,
    "end": 5
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 307,
    "title": "پرتو ایکس و مدل مولکولی دنا",
    "start": 6,
    "end": 6
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 308,
    "title": "نکات کلیدی مدل واتسون و کریک",
    "start": 7,
    "end": 7
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 309,
    "title": "رنا و انواع آن؛ ژن و نقش نوکلئوتیدها",
    "start": 8,
    "end": 8
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 310,
    "title": "طرح همانندسازی",
    "start": 9,
    "end": 10
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 311,
    "title": "عوامل و مراحل همانندسازی",
    "start": 11,
    "end": 11
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 312,
    "title": "همانندسازی در پروکاریوت‌ها و یوکاریوت‌ها",
    "start": 12,
    "end": 14
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 313,
    "title": "ساختار آمینواسیدها",
    "start": 15,
    "end": 15
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 314,
    "title": "سطوح ساختاری پروتئین",
    "start": 16,
    "end": 17
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 315,
    "title": "نقش پروتئین‌ها و آنزیم‌ها",
    "start": 18,
    "end": 18
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 316,
    "title": "ساختار و عملکرد اختصاصی آنزیم‌ها",
    "start": 19,
    "end": 19
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۱: مولکول‌های اطلاعاتی",
    "position": 317,
    "title": "کاربرد آنزیم‌ها در صنعت",
    "start": 20,
    "end": 20
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 300,
    "title": "کل فصل",
    "start": 21,
    "end": 36
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 301,
    "title": "گفتار: رونویسی",
    "start": 22,
    "end": 26
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 302,
    "title": "گفتار: به سوی پروتئین",
    "start": 27,
    "end": 32
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 303,
    "title": "گفتار: تنظیم بیان ژن",
    "start": 33,
    "end": 36
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 304,
    "title": "نقش رنا به عنوان میانجی",
    "start": 22,
    "end": 22
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 305,
    "title": "آنزیم‌ها و مراحل رونویسی",
    "start": 23,
    "end": 23
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 306,
    "title": "رونویسی یکی از دو رشته دنا",
    "start": 24,
    "end": 24
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 307,
    "title": "تغییرات رناهای ساخته‌شده",
    "start": 25,
    "end": 25
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 308,
    "title": "شدت و میزان رونویسی",
    "start": 26,
    "end": 26
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 309,
    "title": "تبدیل زبان نوکلئیک‌اسیدی به پلی‌پپتیدی",
    "start": 27,
    "end": 27
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 310,
    "title": "عوامل ترجمه و ساختار رنای ناقل",
    "start": 28,
    "end": 28
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 311,
    "title": "ساختار رناتن",
    "start": 29,
    "end": 29
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 312,
    "title": "مراحل ترجمه",
    "start": 30,
    "end": 30
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 313,
    "title": "محل پروتئین‌سازی و سرنوشت پروتئین‌ها",
    "start": 31,
    "end": 31
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 314,
    "title": "سرعت و مقدار پروتئین‌سازی",
    "start": 32,
    "end": 32
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 315,
    "title": "تنظیم بیان ژن در پروکاریوت‌ها",
    "start": 33,
    "end": 34
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 316,
    "title": "تنظیم بیان ژن در یوکاریوت‌ها",
    "start": 35,
    "end": 36
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۳: انتقال اطلاعات در نسل‌ها",
    "position": 300,
    "title": "کل فصل",
    "start": 37,
    "end": 46
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۳: انتقال اطلاعات در نسل‌ها",
    "position": 301,
    "title": "گفتار: مفاهیم پایه",
    "start": 38,
    "end": 41
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۳: انتقال اطلاعات در نسل‌ها",
    "position": 302,
    "title": "گفتار: انواع صفات",
    "start": 42,
    "end": 46
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۳: انتقال اطلاعات در نسل‌ها",
    "position": 303,
    "title": "گروه‌های خونی",
    "start": 38,
    "end": 40
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۳: انتقال اطلاعات در نسل‌ها",
    "position": 304,
    "title": "بارزیت ناقص",
    "start": 41,
    "end": 41
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۳: انتقال اطلاعات در نسل‌ها",
    "position": 305,
    "title": "وراثت صفات مستقل از جنس",
    "start": 42,
    "end": 42
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۳: انتقال اطلاعات در نسل‌ها",
    "position": 306,
    "title": "صفت وابسته به X",
    "start": 43,
    "end": 43
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۳: انتقال اطلاعات در نسل‌ها",
    "position": 307,
    "title": "صفات پیوسته و گسسته و چندجایگاهی",
    "start": 44,
    "end": 44
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۳: انتقال اطلاعات در نسل‌ها",
    "position": 308,
    "title": "اثر محیط و مهار بیماری‌های ژنتیک",
    "start": 45,
    "end": 46
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 300,
    "title": "کل فصل",
    "start": 47,
    "end": 62
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 301,
    "title": "گفتار: تغییر در ماده وراثتی جانداران",
    "start": 48,
    "end": 52
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 302,
    "title": "گفتار: تغییر در جمعیت‌ها",
    "start": 53,
    "end": 56
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 303,
    "title": "گفتار: تغییر در گونه‌ها",
    "start": 57,
    "end": 62
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 304,
    "title": "انواع جهش",
    "start": 48,
    "end": 50
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 305,
    "title": "علت و پیامدهای جهش",
    "start": 51,
    "end": 52
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 306,
    "title": "تغییر در گذر زمان",
    "start": 53,
    "end": 53
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 307,
    "title": "خزانه ژن و تعادل جمعیت",
    "start": 54,
    "end": 54
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 308,
    "title": "تداوم گوناگونی در جمعیت",
    "start": 55,
    "end": 56
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 309,
    "title": "شواهد تغییر گونه‌ها",
    "start": 57,
    "end": 59
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 310,
    "title": "گونه‌زایی",
    "start": 60,
    "end": 62
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 300,
    "title": "کل فصل",
    "start": 63,
    "end": 76
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 301,
    "title": "گفتار: تأمین انرژی",
    "start": 64,
    "end": 68
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 302,
    "title": "گفتار: اکسایش بیشتر",
    "start": 69,
    "end": 72
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 303,
    "title": "گفتار: زیستن مستقل از اکسیژن",
    "start": 73,
    "end": 76
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 304,
    "title": "تنفس یاخته‌ای و مولکول پرانرژی ATP",
    "start": 64,
    "end": 65
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 305,
    "title": "زیستن با اکسیژن",
    "start": 66,
    "end": 66
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 306,
    "title": "راکیزه، مقصد پیرووات",
    "start": 67,
    "end": 68
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 307,
    "title": "چرخه کربس و تشکیل ATP بیشتر",
    "start": 69,
    "end": 69
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 308,
    "title": "زنجیره انتقال الکترون",
    "start": 70,
    "end": 70
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 309,
    "title": "مروری بر تنفس یاخته‌ای",
    "start": 71,
    "end": 71
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 310,
    "title": "تنظیم تنفس یاخته‌ای",
    "start": 72,
    "end": 72
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 311,
    "title": "تخمیر",
    "start": 73,
    "end": 74
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 312,
    "title": "پاداکسنده‌ها و سلامت بدن",
    "start": 75,
    "end": 76
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 300,
    "title": "کل فصل",
    "start": 77,
    "end": 90
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 301,
    "title": "گفتار: فتوسنتز: تبدیل انرژی نور به انرژی شیمیایی",
    "start": 78,
    "end": 81
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 302,
    "title": "گفتار: واکنش‌های فتوسنتزی",
    "start": 82,
    "end": 85
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 303,
    "title": "گفتار: فتوسنتز در شرایط دشوار",
    "start": 86,
    "end": 90
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 304,
    "title": "ساختار برگ برای فتوسنتز",
    "start": 78,
    "end": 79
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 305,
    "title": "فتوسیستم و تبدیل انرژی",
    "start": 80,
    "end": 81
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 306,
    "title": "واکنش‌های وابسته به نور",
    "start": 82,
    "end": 82
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 307,
    "title": "ساخته شدن ATP در فتوسنتز",
    "start": 83,
    "end": 83
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 308,
    "title": "واکنش‌های تثبیت کربن",
    "start": 84,
    "end": 84
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 309,
    "title": "اثر محیط بر فتوسنتز",
    "start": 85,
    "end": 85
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 310,
    "title": "فتوسنتز در شرایط دشوار",
    "start": 86,
    "end": 88
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 311,
    "title": "جانداران فتوسنتزکننده دیگر",
    "start": 89,
    "end": 89
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 312,
    "title": "شیمیوسنتز",
    "start": 90,
    "end": 90
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 300,
    "title": "کل فصل",
    "start": 91,
    "end": 106
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 301,
    "title": "گفتار: زیست فناوری و مهندسی ژنتیک",
    "start": 92,
    "end": 96
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 302,
    "title": "گفتار: فناوری مهندسی پروتئین و بافت",
    "start": 97,
    "end": 100
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 303,
    "title": "گفتار: کاربردهای زیست فناوری",
    "start": 101,
    "end": 106
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 304,
    "title": "زیست‌فناوری و تاریخچه آن",
    "start": 92,
    "end": 92
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 305,
    "title": "مهندسی ژنتیک و مراحل آن",
    "start": 93,
    "end": 96
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 306,
    "title": "افزایش پایداری پروتئین‌ها",
    "start": 97,
    "end": 97
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 307,
    "title": "مهندسی بافت",
    "start": 98,
    "end": 99
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 308,
    "title": "بیوانفورماتیک",
    "start": 100,
    "end": 100
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 309,
    "title": "کاربرد زیست‌فناوری در کشاورزی",
    "start": 101,
    "end": 101
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 310,
    "title": "کاربرد زیست‌فناوری در پزشکی",
    "start": 102,
    "end": 104
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 311,
    "title": "تولید جانوران تراژنی",
    "start": 105,
    "end": 105
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 312,
    "title": "اقتصاد و اخلاق زیست‌فناوری",
    "start": 106,
    "end": 106
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 300,
    "title": "کل فصل",
    "start": 107,
    "end": 124
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 301,
    "title": "گفتار: اساس رفتار",
    "start": 108,
    "end": 114
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 302,
    "title": "گفتار: انتخاب طبیعی و رفتار",
    "start": 115,
    "end": 120
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 303,
    "title": "گفتار: ارتباط و زندگی گروهی",
    "start": 121,
    "end": 124
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 304,
    "title": "رفتار غریزی",
    "start": 108,
    "end": 108
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 305,
    "title": "یادگیری و رفتار",
    "start": 109,
    "end": 113
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 306,
    "title": "برهم‌کنش غریزه و یادگیری",
    "start": 114,
    "end": 114
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 307,
    "title": "زادآوری",
    "start": 116,
    "end": 117
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 308,
    "title": "غذایابی",
    "start": 118,
    "end": 119
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 309,
    "title": "خواب زمستانی و رکود تابستانی",
    "start": 120,
    "end": 120
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 310,
    "title": "ارتباط بین جانوران",
    "start": 121,
    "end": 121
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 311,
    "title": "زندگی گروهی",
    "start": 122,
    "end": 124
  }
]$topics$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v193:experimental_sciences:'||p.grade||':'||t.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405','experimental_sciences',p.grade,t.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks t cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
  {
    "grade": "10",
    "subject": "زیست‌شناسی ۱",
    "chapter": "فصل ۷: جذب و انتقال مواد در گیاهان",
    "position": 3,
    "title": "انتقال مواد در گیاهان",
    "start": 105,
    "end": 111,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 1,
    "title": "یاخته‌های بافت عصبی",
    "start": 2,
    "end": 8,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۱: تنظیم عصبی",
    "position": 2,
    "title": "ساختار دستگاه عصبی",
    "start": 9,
    "end": 18,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 1,
    "title": "گیرنده‌های حسی",
    "start": 20,
    "end": 22,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 2,
    "title": "حواس ویژه",
    "start": 23,
    "end": 32,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۲: حواس",
    "position": 3,
    "title": "گیرنده‌های حسی جانوران",
    "start": 33,
    "end": 36,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 1,
    "title": "استخوان‌ها و اسکلت",
    "start": 38,
    "end": 44,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۳: دستگاه حرکتی",
    "position": 2,
    "title": "ماهیچه و حرکت",
    "start": 45,
    "end": 52,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 1,
    "title": "ارتباط شیمیایی",
    "start": 54,
    "end": 55,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۴: تنظیم شیمیایی",
    "position": 2,
    "title": "غده‌های درون‌ریز",
    "start": 56,
    "end": 62,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 1,
    "title": "نخستین خط دفاعی: ورود ممنوع",
    "start": 64,
    "end": 65,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 2,
    "title": "دومین خط دفاعی: واکنش‌های عمومی اما سریع",
    "start": 66,
    "end": 71,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۵: ایمنی",
    "position": 3,
    "title": "سومین خط دفاعی: دفاع اختصاصی",
    "start": 72,
    "end": 78,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 1,
    "title": "فام‌تن (کروموزوم)",
    "start": 80,
    "end": 83,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 2,
    "title": "رشتمان (میتوز)",
    "start": 84,
    "end": 91,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۶: تقسیم یاخته",
    "position": 3,
    "title": "کاستمان (میوز) و تولیدمثل جنسی",
    "start": 92,
    "end": 96,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 1,
    "title": "دستگاه تولیدمثل در مرد",
    "start": 98,
    "end": 101,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 2,
    "title": "دستگاه تولیدمثل در زن",
    "start": 102,
    "end": 107,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 3,
    "title": "رشد و نمو جنین",
    "start": 108,
    "end": 114,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۷: تولید مثل",
    "position": 4,
    "title": "تولیدمثل در جانوران",
    "start": 115,
    "end": 118,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 1,
    "title": "تولیدمثل غیرجنسی",
    "start": 120,
    "end": 123,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 2,
    "title": "تولیدمثل جنسی",
    "start": 124,
    "end": 129,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۸: تولید مثل نهاندانگان",
    "position": 3,
    "title": "از یاخته تخم تا گیاه",
    "start": 130,
    "end": 136,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 1,
    "title": "تنظیم‌کننده‌های رشد در گیاهان",
    "start": 138,
    "end": 145,
    "kind": "v1"
  },
  {
    "grade": "11",
    "subject": "زیست‌شناسی ۲",
    "chapter": "فصل ۹: پاسخ گیاهان به محرک‌ها",
    "position": 2,
    "title": "پاسخ به محیط",
    "start": 146,
    "end": 152,
    "kind": "v1"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 1,
    "title": "رونویسی",
    "start": 22,
    "end": 26,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 2,
    "title": "به سوی پروتئین",
    "start": 27,
    "end": 32,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۲: جریان اطلاعات در یاخته",
    "position": 3,
    "title": "تنظیم بیان ژن",
    "start": 33,
    "end": 36,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۳: انتقال اطلاعات در نسل‌ها",
    "position": 1,
    "title": "مفاهیم پایه",
    "start": 38,
    "end": 41,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۳: انتقال اطلاعات در نسل‌ها",
    "position": 2,
    "title": "انواع صفات",
    "start": 42,
    "end": 46,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 1,
    "title": "تغییر در ماده وراثتی جانداران",
    "start": 48,
    "end": 52,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 2,
    "title": "تغییر در جمعیت‌ها",
    "start": 53,
    "end": 56,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۴: تغییر در اطلاعات وراثتی",
    "position": 3,
    "title": "تغییر در گونه‌ها",
    "start": 57,
    "end": 62,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 1,
    "title": "تأمین انرژی",
    "start": 64,
    "end": 68,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 2,
    "title": "اکسایش بیشتر",
    "start": 69,
    "end": 72,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۵: از ماده به انرژی",
    "position": 3,
    "title": "زیستن مستقل از اکسیژن",
    "start": 73,
    "end": 76,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 1,
    "title": "فتوسنتز: تبدیل انرژی نور به انرژی شیمیایی",
    "start": 78,
    "end": 81,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 2,
    "title": "واکنش‌های فتوسنتزی",
    "start": 82,
    "end": 85,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۶: از انرژی به ماده",
    "position": 3,
    "title": "فتوسنتز در شرایط دشوار",
    "start": 86,
    "end": 90,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 1,
    "title": "زیست فناوری و مهندسی ژنتیک",
    "start": 92,
    "end": 96,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 2,
    "title": "فناوری مهندسی پروتئین و بافت",
    "start": 97,
    "end": 100,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۷: فناوری‌های نوین زیستی",
    "position": 3,
    "title": "کاربردهای زیست فناوری",
    "start": 101,
    "end": 106,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 1,
    "title": "اساس رفتار",
    "start": 108,
    "end": 114,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 2,
    "title": "انتخاب طبیعی و رفتار",
    "start": 115,
    "end": 120,
    "kind": "bio12"
  },
  {
    "grade": "12",
    "subject": "زیست‌شناسی ۳",
    "chapter": "فصل ۸: رفتارهای جانوران",
    "position": 3,
    "title": "ارتباط و زندگی گروهی",
    "start": 121,
    "end": 124,
    "kind": "bio12"
  }
]$fixes$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer,kind text)),
tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=(case when p.kind='bio12' then md5('nova:planner:112216:1405:'||r.track||':'||p.chapter||':'||p.position)::uuid else md5('nova:planner:1405:v1:experimental_sciences:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid end)
and t.edition='1405' and t.study_field='experimental_sciences' and t.grade=p.grade and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
