-- Sociology 2 and 3, printed 1405, using the user's textbook PDFs.
with installed as (insert into private.planner_seed_installations(seed_key) values ('sociology-11-12-1405-v204') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱",
  "position": 400,
  "title": "کل درس",
  "start": 3,
  "end": 10
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱",
  "position": 450,
  "title": "جهان انسانی",
  "start": 4,
  "end": 5
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱",
  "position": 451,
  "title": "جهان تکوینی",
  "start": 6,
  "end": 6
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱",
  "position": 452,
  "title": "شرح: تعامل جهان‌های ذهنی، فرهنگی و تکوینی",
  "start": 7,
  "end": 10
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۲",
  "position": 400,
  "title": "کل درس",
  "start": 11,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۲",
  "position": 450,
  "title": "فرهنگ جهانی و ظرفیت جهانی‌شدن",
  "start": 12,
  "end": 13
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۲",
  "position": 451,
  "title": "ویژگی‌های فرهنگ جهانی مطلوب",
  "start": 14,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۳",
  "position": 400,
  "title": "کل درس",
  "start": 19,
  "end": 26
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۳",
  "position": 450,
  "title": "شرح: غلبه نظامی و غلبه فرهنگی",
  "start": 19,
  "end": 19
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۳",
  "position": 451,
  "title": "شرح: جهان‌گشایی و امپراتوری",
  "start": 20,
  "end": 21
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۳",
  "position": 452,
  "title": "شرح: امپریالیسم و استعمار",
  "start": 22,
  "end": 26
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۴",
  "position": 400,
  "title": "کل درس",
  "start": 27,
  "end": 36
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۴",
  "position": 450,
  "title": "شرح: عقاید و ارزش‌های جهانی اسلام",
  "start": 27,
  "end": 27
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۴",
  "position": 451,
  "title": "مراحل گسترش فرهنگ اسلامی",
  "start": 28,
  "end": 29
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۴",
  "position": 452,
  "title": "استعمار و بیداری اسلامی",
  "start": 30,
  "end": 36
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۵",
  "position": 400,
  "title": "کل درس",
  "start": 37,
  "end": 44
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۵",
  "position": 450,
  "title": "شرح: باورها و ارزش‌های بنیادین فرهنگ غرب",
  "start": 37,
  "end": 37
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۵",
  "position": 451,
  "title": "سکولاریسم و رویکرد دنیوی",
  "start": 38,
  "end": 38
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۵",
  "position": 452,
  "title": "اومانیسم و اصالت انسان دنیوی",
  "start": 39,
  "end": 40
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۵",
  "position": 453,
  "title": "روشنگری و علوم جدید",
  "start": 41,
  "end": 44
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۶",
  "position": 400,
  "title": "کل درس",
  "start": 45,
  "end": 54
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۶",
  "position": 450,
  "title": "رنسانس و زمینه‌های تاریخی آن",
  "start": 46,
  "end": 47
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۶",
  "position": 451,
  "title": "رابطه فلسفه روشنگری و فرهنگ جدید غرب",
  "start": 48,
  "end": 49
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۶",
  "position": 452,
  "title": "آثار فرهنگ جدید غرب در زندگی اجتماعی",
  "start": 50,
  "end": 54
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۷",
  "position": 400,
  "title": "کل درس",
  "start": 55,
  "end": 63
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۷",
  "position": 450,
  "title": "جامعه جهانی در گذشته و حال",
  "start": 56,
  "end": 56
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۷",
  "position": 451,
  "title": "شکل‌گیری نظام نوین جهانی",
  "start": 57,
  "end": 63
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۸",
  "position": 400,
  "title": "کل درس",
  "start": 64,
  "end": 74
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۸",
  "position": 450,
  "title": "تحولات اقتصادی و سیاسی",
  "start": 65,
  "end": 66
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۸",
  "position": 451,
  "title": "افول دولت ملت‌ها و جهانی‌شدن",
  "start": 67,
  "end": 68
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۸",
  "position": 452,
  "title": "امپراتوری رسانه، علم و فرهنگ",
  "start": 69,
  "end": 74
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۹",
  "position": 400,
  "title": "کل درس",
  "start": 75,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۹",
  "position": 450,
  "title": "چالش فقر و غنا",
  "start": 76,
  "end": 78
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۹",
  "position": 451,
  "title": "شکل‌گیری بلوک شرق و غرب",
  "start": 79,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۰",
  "position": 400,
  "title": "کل درس",
  "start": 83,
  "end": 90
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۰",
  "position": 450,
  "title": "جنگ‌های جهانی",
  "start": 84,
  "end": 87
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۰",
  "position": 451,
  "title": "شمال و جنوب",
  "start": 88,
  "end": 90
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۱",
  "position": 400,
  "title": "کل درس",
  "start": 91,
  "end": 97
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۱",
  "position": 450,
  "title": "شرح: نظام، تعادل و بحران",
  "start": 91,
  "end": 91
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۱",
  "position": 451,
  "title": "بحران‌های اقتصادی",
  "start": 92,
  "end": 93
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۱",
  "position": 452,
  "title": "شرح: بحران‌های زیست‌محیطی",
  "start": 94,
  "end": 97
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۲",
  "position": 400,
  "title": "کل درس",
  "start": 98,
  "end": 106
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۲",
  "position": 450,
  "title": "بحران معرفتی",
  "start": 99,
  "end": 99
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۲",
  "position": 451,
  "title": "بحران معنویت",
  "start": 100,
  "end": 106
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۳",
  "position": 400,
  "title": "کل درس",
  "start": 107,
  "end": 114
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۳",
  "position": 450,
  "title": "شرح: رویارویی جوامع اسلامی با جهان غرب",
  "start": 107,
  "end": 107
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۳",
  "position": 451,
  "title": "شرح: نخستین بیدارگران اسلامی",
  "start": 108,
  "end": 109
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۳",
  "position": 452,
  "title": "منورالفکران و روشنفکران غرب‌گرا",
  "start": 110,
  "end": 114
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۴",
  "position": 400,
  "title": "کل درس",
  "start": 115,
  "end": 123
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۴",
  "position": 450,
  "title": "شرح: جنبش تنباکو و عدالتخانه",
  "start": 115,
  "end": 115
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۴",
  "position": 451,
  "title": "انقلاب مشروطه",
  "start": 116,
  "end": 117
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۴",
  "position": 452,
  "title": "انقلاب اسلامی",
  "start": 118,
  "end": 119
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۴",
  "position": 453,
  "title": "مقایسه انقلاب اسلامی و انقلاب‌های آزادی‌بخش",
  "start": 120,
  "end": 123
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۵",
  "position": 400,
  "title": "کل درس",
  "start": 124,
  "end": 136
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۵",
  "position": 450,
  "title": "نخستین انقلاب",
  "start": 125,
  "end": 126
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۵",
  "position": 451,
  "title": "تأثیرات انقلاب اسلامی ایران بر جهان اسلام",
  "start": 127,
  "end": 130
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۵",
  "position": 452,
  "title": "شرح: جغرافیای فرهنگی جهان جدید",
  "start": 131,
  "end": 136
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱",
  "position": 400,
  "title": "کل درس",
  "start": 2,
  "end": 9
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱",
  "position": 450,
  "title": "ذخیره دانشی",
  "start": 2,
  "end": 2
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱",
  "position": 451,
  "title": "شرح: دانش عمومی",
  "start": 3,
  "end": 4
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱",
  "position": 452,
  "title": "شرح: دانش علمی",
  "start": 5,
  "end": 9
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۲",
  "position": 400,
  "title": "کل درس",
  "start": 10,
  "end": 18
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۲",
  "position": 450,
  "title": "شرح: علوم انسانی و علوم اجتماعی",
  "start": 11,
  "end": 11
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۲",
  "position": 451,
  "title": "شرح: فواید علوم اجتماعی",
  "start": 12,
  "end": 14
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۲",
  "position": 452,
  "title": "شرح: شاخه‌های علوم اجتماعی",
  "start": 15,
  "end": 18
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۳",
  "position": 400,
  "title": "کل درس",
  "start": 19,
  "end": 31
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۳",
  "position": 450,
  "title": "نظم اجتماعی",
  "start": 19,
  "end": 19
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۳",
  "position": 451,
  "title": "قواعد اجتماعی",
  "start": 20,
  "end": 22
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۳",
  "position": 452,
  "title": "نظام اجتماعی",
  "start": 23,
  "end": 24
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۳",
  "position": 453,
  "title": "جامعه‌شناسی تبیینی",
  "start": 25,
  "end": 31
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۴",
  "position": 400,
  "title": "کل درس",
  "start": 32,
  "end": 41
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۴",
  "position": 450,
  "title": "شرح: کنش اجتماعی و ساختار اجتماعی",
  "start": 32,
  "end": 32
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۴",
  "position": 451,
  "title": "خشت بنای جامعه",
  "start": 33,
  "end": 35
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۴",
  "position": 452,
  "title": "پیامدهای نادیده گرفتن کنش اجتماعی",
  "start": 36,
  "end": 41
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۵",
  "position": 400,
  "title": "کل درس",
  "start": 42,
  "end": 53
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۵",
  "position": 450,
  "title": "پرسش از معنای زندگی",
  "start": 43,
  "end": 43
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۵",
  "position": 451,
  "title": "شرح: پیچیدگی پدیده‌های انسانی و اجتماعی",
  "start": 44,
  "end": 47
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۵",
  "position": 452,
  "title": "جامعه‌شناسی تفسیری",
  "start": 48,
  "end": 53
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۶",
  "position": 400,
  "title": "کل درس",
  "start": 54,
  "end": 68
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۶",
  "position": 450,
  "title": "قدرت اجتماعی",
  "start": 54,
  "end": 54
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۶",
  "position": 451,
  "title": "چگونگی رفع اختلافات اجتماعی",
  "start": 55,
  "end": 57
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۶",
  "position": 452,
  "title": "تغییرات قدرت در گذر زمان",
  "start": 58,
  "end": 61
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۶",
  "position": 453,
  "title": "مطالعه علمی قدرت و سیاست",
  "start": 62,
  "end": 68
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۷",
  "position": 400,
  "title": "کل درس",
  "start": 69,
  "end": 81
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۷",
  "position": 450,
  "title": "تفاوت یا نابرابری",
  "start": 70,
  "end": 70
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۷",
  "position": 451,
  "title": "سه رویکرد به نابرابری اجتماعی",
  "start": 71,
  "end": 71
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۷",
  "position": 452,
  "title": "رویکرد لیبرالی",
  "start": 72,
  "end": 73
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۷",
  "position": 453,
  "title": "رویکرد کمونیستی",
  "start": 74,
  "end": 74
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۷",
  "position": 454,
  "title": "رویکرد عدالت اجتماعی",
  "start": 75,
  "end": 75
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۷",
  "position": 455,
  "title": "جامعه‌شناسی انتقادی",
  "start": 76,
  "end": 81
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۸",
  "position": 400,
  "title": "کل درس",
  "start": 82,
  "end": 92
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۸",
  "position": 450,
  "title": "تنازع هویت‌ها: وحدت یا کثرت هویت‌ها",
  "start": 83,
  "end": 86
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۸",
  "position": 451,
  "title": "تعارف هویت‌ها: وحدت و کثرت هویت‌ها",
  "start": 87,
  "end": 88
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۸",
  "position": 452,
  "title": "علوم اجتماعی و سیاست هویت",
  "start": 89,
  "end": 92
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۹",
  "position": 400,
  "title": "کل درس",
  "start": 93,
  "end": 104
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۹",
  "position": 450,
  "title": "منزلت علم",
  "start": 94,
  "end": 95
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۹",
  "position": 451,
  "title": "علوم اجتماعی در قرآن",
  "start": 96,
  "end": 96
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۹",
  "position": 452,
  "title": "علم مدنی و علم عمران",
  "start": 97,
  "end": 104
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱۰",
  "position": 400,
  "title": "کل درس",
  "start": 105,
  "end": 115
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱۰",
  "position": 450,
  "title": "افق علوم اجتماعی در جهان اسلام",
  "start": 105,
  "end": 105
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱۰",
  "position": 451,
  "title": "مدارا، مقاومت و عدالت",
  "start": 106,
  "end": 107
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱۰",
  "position": 452,
  "title": "دو انقلاب در یک قرن",
  "start": 108,
  "end": 110
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱۰",
  "position": 453,
  "title": "ویژگی‌ها و ظرفیت‌های علوم اجتماعی جهان اسلام",
  "start": 111,
  "end": 115
 }
]$topics$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)),tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v204:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405','humanities',p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱",
  "position": 1,
  "title": "جهان انسانی و بخش‌های فردی و اجتماعی",
  "start": 3,
  "end": 10
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱",
  "position": 2,
  "title": "جهان تکوینی و بخش‌های طبیعت و فوق طبیعت",
  "start": 3,
  "end": 10
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱",
  "position": 3,
  "title": "تعامل جهان‌های ذهنی، فرهنگی و تکوینی",
  "start": 3,
  "end": 10
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۲",
  "position": 1,
  "title": "فرهنگ جهانی و شرایط جهانی‌شدن فرهنگ‌ها",
  "start": 11,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۲",
  "position": 2,
  "title": "فرهنگ سلطه و فرهنگ جهانی مطلوب",
  "start": 11,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۲",
  "position": 3,
  "title": "حقیقت، معنویت، عدالت و آزادی",
  "start": 11,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۲",
  "position": 4,
  "title": "تعهد و مسئولیت و عقلانیت در فرهنگ جهانی",
  "start": 11,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۳",
  "position": 1,
  "title": "جهان‌گشایی و امپراتوری",
  "start": 19,
  "end": 26
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۳",
  "position": 2,
  "title": "غلبه نظامی و غلبه فرهنگی",
  "start": 19,
  "end": 26
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۳",
  "position": 3,
  "title": "امپریالیسم و استعمار",
  "start": 19,
  "end": 26
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۴",
  "position": 1,
  "title": "عقاید و ارزش‌های جهانی اسلام",
  "start": 27,
  "end": 36
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۴",
  "position": 2,
  "title": "گسترش فرهنگ اسلامی در عصر نبوی و دوران خلافت",
  "start": 27,
  "end": 36
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۴",
  "position": 3,
  "title": "دوران استعمار و بیداری اسلامی",
  "start": 27,
  "end": 36
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۵",
  "position": 1,
  "title": "باورها و ارزش‌های بنیادین فرهنگ غرب",
  "start": 37,
  "end": 44
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۵",
  "position": 2,
  "title": "سکولاریسم و نگاه هستی‌شناختی",
  "start": 37,
  "end": 44
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۵",
  "position": 3,
  "title": "اومانیسم و نگاه انسان‌شناختی",
  "start": 37,
  "end": 44
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۵",
  "position": 4,
  "title": "روشنگری و نگاه معرفت‌شناختی",
  "start": 37,
  "end": 44
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۶",
  "position": 1,
  "title": "دوره‌های تاریخی فرهنگ غرب",
  "start": 45,
  "end": 54
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۶",
  "position": 2,
  "title": "رنسانس و دگرگونی هنر، دین و فلسفه",
  "start": 45,
  "end": 54
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۶",
  "position": 3,
  "title": "تکوین علم و فناوری و اقتصاد جدید",
  "start": 45,
  "end": 54
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۶",
  "position": 4,
  "title": "تحولات حقوقی و سیاسی غرب",
  "start": 45,
  "end": 54
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۷",
  "position": 1,
  "title": "جامعه جهانی و شکل‌های آن",
  "start": 55,
  "end": 63
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۷",
  "position": 2,
  "title": "جامعه جهانی پیش از غرب جدید",
  "start": 55,
  "end": 63
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۷",
  "position": 3,
  "title": "جامعه جهانی در دوران جدید",
  "start": 55,
  "end": 63
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۸",
  "position": 1,
  "title": "تحولات اقتصادی و سیاسی نظام جهانی",
  "start": 64,
  "end": 74
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۸",
  "position": 2,
  "title": "دولت‌ ملت‌ها و استعمار",
  "start": 64,
  "end": 74
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۸",
  "position": 3,
  "title": "جهانی‌شدن و شرکت‌های چندملیتی",
  "start": 64,
  "end": 74
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۸",
  "position": 4,
  "title": "رسانه، علم و فرهنگ در نظام جهانی",
  "start": 64,
  "end": 74
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۹",
  "position": 1,
  "title": "چالش فقر و غنا و لیبرالیسم اولیه",
  "start": 75,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۹",
  "position": 2,
  "title": "مارکسیسم، سوسیالیسم و کمونیسم",
  "start": 75,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۹",
  "position": 3,
  "title": "جهان دوقطبی شرق و غرب",
  "start": 75,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۰",
  "position": 1,
  "title": "جنگ‌های جهانی اول و دوم",
  "start": 83,
  "end": 90
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۰",
  "position": 2,
  "title": "جنگ سرد و جنگ‌های مناطق پیرامونی",
  "start": 83,
  "end": 90
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۰",
  "position": 3,
  "title": "نظریه جنگ تمدن‌ها",
  "start": 83,
  "end": 90
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۰",
  "position": 4,
  "title": "شمال و جنوب و مرکز و پیرامون",
  "start": 83,
  "end": 90
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۱",
  "position": 1,
  "title": "نظام، تعادل و بحران",
  "start": 91,
  "end": 97
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۱",
  "position": 2,
  "title": "بحران‌های اقتصادی و پیامدهای جهانی آنها",
  "start": 91,
  "end": 97
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۱",
  "position": 3,
  "title": "بحران‌های زیست‌محیطی",
  "start": 91,
  "end": 97
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۲",
  "position": 1,
  "title": "چالش‌های بنیادین فرهنگ غرب",
  "start": 98,
  "end": 106
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۲",
  "position": 2,
  "title": "بحران معرفتی و سیر شناخت",
  "start": 98,
  "end": 106
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۲",
  "position": 3,
  "title": "بحران معنوی و اخلاقی",
  "start": 98,
  "end": 106
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۳",
  "position": 1,
  "title": "رویارویی جوامع اسلامی با جهان غرب",
  "start": 107,
  "end": 114
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۳",
  "position": 2,
  "title": "نخستین بیدارگران اسلامی",
  "start": 107,
  "end": 114
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۳",
  "position": 3,
  "title": "جنبش‌ها و نقاط ضعف بیداری نخستین",
  "start": 107,
  "end": 114
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۴",
  "position": 1,
  "title": "جنبش تنباکو و عدالتخانه",
  "start": 115,
  "end": 123
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۴",
  "position": 2,
  "title": "انقلاب مشروطه و برداشت‌های متفاوت",
  "start": 115,
  "end": 123
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۴",
  "position": 3,
  "title": "انقلاب اسلامی و بیداری اسلامی",
  "start": 115,
  "end": 123
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۵",
  "position": 2,
  "title": "جغرافیای فرهنگی جهان جدید",
  "start": 124,
  "end": 136
 },
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
  "chapter": "درس ۱۵",
  "position": 3,
  "title": "افق بیداری اسلامی و مواجهه فرهنگ‌ها",
  "start": 124,
  "end": 136
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱",
  "position": 1,
  "title": "ذخیره دانشی و نقش آن در زندگی",
  "start": 2,
  "end": 9
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱",
  "position": 2,
  "title": "دانش عمومی",
  "start": 2,
  "end": 9
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱",
  "position": 3,
  "title": "دانش علمی",
  "start": 2,
  "end": 9
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱",
  "position": 4,
  "title": "تعامل و تعارض دانش عمومی و دانش علمی",
  "start": 2,
  "end": 9
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۲",
  "position": 1,
  "title": "علوم انسانی و علوم اجتماعی",
  "start": 10,
  "end": 18
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۲",
  "position": 2,
  "title": "فواید علوم اجتماعی",
  "start": 10,
  "end": 18
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۲",
  "position": 3,
  "title": "شاخه‌های علوم اجتماعی",
  "start": 10,
  "end": 18
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۲",
  "position": 4,
  "title": "جامعه‌شناسی خرد و کلان و رویکردهای جامعه‌شناسی",
  "start": 10,
  "end": 18
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۳",
  "position": 1,
  "title": "نظم اجتماعی و قواعد زندگی جمعی",
  "start": 19,
  "end": 31
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۳",
  "position": 2,
  "title": "آشنایی‌زدایی و شناخت نظم اجتماعی",
  "start": 19,
  "end": 31
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۳",
  "position": 3,
  "title": "دانش عملی و دانش علمی درباره نظم",
  "start": 19,
  "end": 31
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۴",
  "position": 1,
  "title": "کنش اجتماعی و ساختار اجتماعی",
  "start": 32,
  "end": 41
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۴",
  "position": 2,
  "title": "تأثیر کنش‌ها بر حفظ و تغییر جامعه",
  "start": 32,
  "end": 41
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۴",
  "position": 3,
  "title": "پیامدهای نادیده گرفتن معنای کنش اجتماعی",
  "start": 32,
  "end": 41
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۵",
  "position": 1,
  "title": "پرسش از معنای زندگی و معنای کنش",
  "start": 42,
  "end": 53
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۵",
  "position": 2,
  "title": "پیچیدگی پدیده‌های انسانی و اجتماعی",
  "start": 42,
  "end": 53
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۵",
  "position": 3,
  "title": "رویکرد تفسیری به معنای زندگی",
  "start": 42,
  "end": 53
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۶",
  "position": 1,
  "title": "قدرت اجتماعی، مقبولیت و مشروعیت",
  "start": 54,
  "end": 68
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۶",
  "position": 2,
  "title": "قدرت سخت و قدرت نرم",
  "start": 54,
  "end": 68
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۶",
  "position": 3,
  "title": "سیاست و انواع نظام سیاسی",
  "start": 54,
  "end": 68
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۶",
  "position": 4,
  "title": "جامعه‌شناسی و ارزش‌های سیاسی",
  "start": 54,
  "end": 68
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۷",
  "position": 1,
  "title": "تفاوت‌های اسمی و رتبه‌ای",
  "start": 69,
  "end": 81
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۷",
  "position": 2,
  "title": "نابرابری اجتماعی و توزیع فرصت‌ها",
  "start": 69,
  "end": 81
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۷",
  "position": 3,
  "title": "رویکردهای نابرابری اجتماعی",
  "start": 69,
  "end": 81
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۸",
  "position": 1,
  "title": "هویت ملی و شکل‌گیری سیاست‌گذاری هویتی",
  "start": 82,
  "end": 92
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۸",
  "position": 2,
  "title": "سیاست همانندسازی هویت‌ها",
  "start": 82,
  "end": 92
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۸",
  "position": 3,
  "title": "سیاست تکثرگرایی و تنوع هویت‌ها",
  "start": 82,
  "end": 92
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۹",
  "position": 1,
  "title": "علوم نافع و روش‌های شناخت",
  "start": 93,
  "end": 104
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۹",
  "position": 2,
  "title": "علوم اجتماعی در قرآن و سنت‌های الهی",
  "start": 93,
  "end": 104
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۹",
  "position": 3,
  "title": "متفکران مسلمان و علوم اجتماعی",
  "start": 93,
  "end": 104
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱۰",
  "position": 1,
  "title": "ویژگی‌های تمدن اسلامی",
  "start": 105,
  "end": 115
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱۰",
  "position": 2,
  "title": "مسئله‌ها و نیازهای علوم اجتماعی جهان اسلام",
  "start": 105,
  "end": 115
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
  "chapter": "درس ۱۰",
  "position": 3,
  "title": "آگاهی و عمل در حیات اجتماعی",
  "start": 105,
  "end": 115
 }
]$fixes$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)),tracks(track) as (values ('konkur'),('final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join tracks r
where t.id=md5('nova:planner:1405:v1:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field='humanities' and t.grade=p.grade and t.preparation_track=r.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
