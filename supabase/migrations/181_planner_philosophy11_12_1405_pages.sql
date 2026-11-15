-- Philosophy textbooks 111226 and 112226, 1405, user-provided PDFs, printed pages.
-- Add one time; preserve existing topics, administrator edits, and published snapshots.
with installed as (insert into private.planner_seed_installations(seed_key) values ('philosophy11-12-independent-1405-v181') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱",
  "position": 300,
  "title": "کل درس",
  "start": 2,
  "end": 11
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱",
  "position": 301,
  "title": "انسان و تفکر",
  "start": 4,
  "end": 5
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱",
  "position": 302,
  "title": "دانش فلسفه",
  "start": 6,
  "end": 6
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱",
  "position": 303,
  "title": "واژه فلسفه",
  "start": 7,
  "end": 7
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱",
  "position": 304,
  "title": "ویژگی‌های فلسفه",
  "start": 8,
  "end": 10
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱",
  "position": 305,
  "title": "به کار ببندیم",
  "start": 11,
  "end": 11
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۲",
  "position": 300,
  "title": "کل درس",
  "start": 12,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۲",
  "position": 301,
  "title": "بخش اصلی و ریشه‌ای فلسفه",
  "start": 13,
  "end": 13
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۲",
  "position": 302,
  "title": "شاخه‌های فلسفه",
  "start": 14,
  "end": 15
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۲",
  "position": 303,
  "title": "فلسفه‌های مضاف و علوم",
  "start": 15,
  "end": 17
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۲",
  "position": 304,
  "title": "به کار ببندیم",
  "start": 18,
  "end": 18
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۳",
  "position": 300,
  "title": "کل درس",
  "start": 19,
  "end": 27
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۳",
  "position": 301,
  "title": "معنای زندگی",
  "start": 21,
  "end": 21
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۳",
  "position": 302,
  "title": "فواید تفکر فلسفی و دوری از مغالطه",
  "start": 22,
  "end": 22
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۳",
  "position": 303,
  "title": "استقلال در اندیشه",
  "start": 23,
  "end": 23
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۳",
  "position": 304,
  "title": "رهایی از عادت‌های غیرمنطقی",
  "start": 24,
  "end": 25
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۳",
  "position": 305,
  "title": "به کار ببندیم",
  "start": 26,
  "end": 27
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۴",
  "position": 300,
  "title": "کل درس",
  "start": 28,
  "end": 35
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۴",
  "position": 301,
  "title": "فلسفه در یونان",
  "start": 30,
  "end": 33
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۴",
  "position": 302,
  "title": "سوفیست‌ها",
  "start": 34,
  "end": 34
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۴",
  "position": 303,
  "title": "به کار ببندیم",
  "start": 35,
  "end": 35
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۵",
  "position": 300,
  "title": "کل درس",
  "start": 36,
  "end": 42
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۵",
  "position": 301,
  "title": "زندگی بر اساس اندیشه",
  "start": 36,
  "end": 38
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۵",
  "position": 302,
  "title": "سقراط در برابر دادگاه",
  "start": 39,
  "end": 42
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۶",
  "position": 300,
  "title": "کل درس",
  "start": 44,
  "end": 49
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۶",
  "position": 301,
  "title": "چیستی معرفت",
  "start": 46,
  "end": 46
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۶",
  "position": 302,
  "title": "امکان معرفت",
  "start": 47,
  "end": 47
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۶",
  "position": 303,
  "title": "پیشرفت پیوسته دانش انسان",
  "start": 48,
  "end": 48
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۶",
  "position": 304,
  "title": "به کار ببندیم",
  "start": 49,
  "end": 49
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۷",
  "position": 300,
  "title": "کل درس",
  "start": 50,
  "end": 57
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۷",
  "position": 301,
  "title": "حس",
  "start": 51,
  "end": 51
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۷",
  "position": 302,
  "title": "عقل",
  "start": 52,
  "end": 53
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۷",
  "position": 303,
  "title": "قلب و وحی الهی",
  "start": 54,
  "end": 55
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۷",
  "position": 304,
  "title": "مقایسه ابزارها و به کار ببندیم",
  "start": 56,
  "end": 57
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 300,
  "title": "کل درس",
  "start": 58,
  "end": 68
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 301,
  "title": "دوره یونان باستان",
  "start": 59,
  "end": 60
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 302,
  "title": "دوره شکوفایی فلسفه در جهان اسلام و ایران",
  "start": 61,
  "end": 62
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 303,
  "title": "دوره جدید اروپا",
  "start": 63,
  "end": 64
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 304,
  "title": "تجربه‌گرایی مطلق",
  "start": 65,
  "end": 65
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 305,
  "title": "نسبی‌گرایی",
  "start": 66,
  "end": 66
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 306,
  "title": "پراگماتیسم",
  "start": 67,
  "end": 67
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۸",
  "position": 307,
  "title": "به کار ببندیم",
  "start": 68,
  "end": 68
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۹",
  "position": 300,
  "title": "کل درس",
  "start": 70,
  "end": 75
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۹",
  "position": 301,
  "title": "حقیقت انسان چیست؟",
  "start": 71,
  "end": 71
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۹",
  "position": 302,
  "title": "دیدگاه یونان باستان",
  "start": 72,
  "end": 72
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۹",
  "position": 303,
  "title": "دیدگاه دوره جدید اروپا",
  "start": 73,
  "end": 75
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۰",
  "position": 300,
  "title": "کل درس",
  "start": 76,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۰",
  "position": 301,
  "title": "دیدگاه فیلسوفان مسلمان درباره حقیقت انسان",
  "start": 78,
  "end": 78
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۰",
  "position": 302,
  "title": "از جانب بالا",
  "start": 79,
  "end": 79
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۰",
  "position": 303,
  "title": "حقیقت نورانی نفس",
  "start": 80,
  "end": 80
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۰",
  "position": 304,
  "title": "تا بی‌نهایت",
  "start": 81,
  "end": 81
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۰",
  "position": 305,
  "title": "به کار ببندیم",
  "start": 82,
  "end": 82
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۱",
  "position": 300,
  "title": "کل درس",
  "start": 83,
  "end": 93
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۱",
  "position": 301,
  "title": "فعل طبیعی و فعل اخلاقی",
  "start": 85,
  "end": 85
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۱",
  "position": 302,
  "title": "دیدگاه فیلسوفان یونان در معیار فعل اخلاقی",
  "start": 86,
  "end": 87
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۱",
  "position": 303,
  "title": "دیدگاه فیلسوفان دوره جدید اروپا",
  "start": 88,
  "end": 89
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۱",
  "position": 304,
  "title": "دیدگاه فیلسوفان مسلمان",
  "start": 90,
  "end": 92
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
  "chapter": "درس ۱۱",
  "position": 305,
  "title": "به کار ببندیم",
  "start": 93,
  "end": 93
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱",
  "position": 300,
  "title": "کل درس",
  "start": 2,
  "end": 7
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱",
  "position": 301,
  "title": "قدم نخست: واقعیت و هستی",
  "start": 2,
  "end": 2
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱",
  "position": 302,
  "title": "قدم دوم: هستی و چیستی",
  "start": 3,
  "end": 3
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱",
  "position": 303,
  "title": "قدم سوم: فارابی و ابن‌سینا",
  "start": 4,
  "end": 4
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱",
  "position": 304,
  "title": "قدم چهارم: استدلال ابن‌سینا",
  "start": 5,
  "end": 6
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱",
  "position": 305,
  "title": "گذری تاریخی و به کار ببندیم",
  "start": 6,
  "end": 7
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۲",
  "position": 300,
  "title": "کل درس",
  "start": 8,
  "end": 12
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۲",
  "position": 301,
  "title": "نسبت‌های سه‌گانه در قضایا",
  "start": 9,
  "end": 9
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۲",
  "position": 302,
  "title": "رابطه وجود با موضوع",
  "start": 10,
  "end": 10
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۲",
  "position": 303,
  "title": "تعیین رابطه و به کار ببندیم",
  "start": 11,
  "end": 12
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۳",
  "position": 300,
  "title": "کل درس",
  "start": 13,
  "end": 21
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۳",
  "position": 301,
  "title": "رابطه علیت و تفاوت آن با دیگر روابط",
  "start": 14,
  "end": 14
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۳",
  "position": 302,
  "title": "منشأ درک و پذیرش علیت",
  "start": 15,
  "end": 15
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۳",
  "position": 303,
  "title": "دیدگاه فیلسوفان اروپایی و مسلمان",
  "start": 16,
  "end": 17
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۳",
  "position": 304,
  "title": "وجوب علّی و معلولی و سنخیت",
  "start": 18,
  "end": 20
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۳",
  "position": 305,
  "title": "خلاصه، نتیجه و تمرین",
  "start": 20,
  "end": 21
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۴",
  "position": 300,
  "title": "کل درس",
  "start": 22,
  "end": 27
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۴",
  "position": 301,
  "title": "معانی اتفاق",
  "start": 23,
  "end": 24
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۴",
  "position": 302,
  "title": "بررسی چهار معنای اتفاق",
  "start": 24,
  "end": 26
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۴",
  "position": 303,
  "title": "به کار ببندیم",
  "start": 27,
  "end": 27
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۵",
  "position": 300,
  "title": "کل درس",
  "start": 30,
  "end": 40
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۵",
  "position": 301,
  "title": "خدا در فلسفه یونان باستان",
  "start": 31,
  "end": 34
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۵",
  "position": 302,
  "title": "خدا در فلسفه دوره جدید اروپا",
  "start": 34,
  "end": 36
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۵",
  "position": 303,
  "title": "باور به خدا و معناداری زندگی",
  "start": 37,
  "end": 39
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۵",
  "position": 304,
  "title": "به کار ببندیم",
  "start": 40,
  "end": 40
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۶",
  "position": 300,
  "title": "کل درس",
  "start": 41,
  "end": 50
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۶",
  "position": 301,
  "title": "برهان اثبات وجود خدا و استدلال فارابی",
  "start": 42,
  "end": 43
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۶",
  "position": 302,
  "title": "استدلال ابن‌سینا",
  "start": 44,
  "end": 45
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۶",
  "position": 303,
  "title": "بیان ملاصدرا",
  "start": 46,
  "end": 46
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۶",
  "position": 304,
  "title": "فلاسفه مسلمان و معناداری حیات",
  "start": 47,
  "end": 49
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۶",
  "position": 305,
  "title": "به کار ببندیم",
  "start": 50,
  "end": 50
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۷",
  "position": 300,
  "title": "کل درس",
  "start": 52,
  "end": 58
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۷",
  "position": 301,
  "title": "مقصود فیلسوفان از عقل",
  "start": 53,
  "end": 54
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۷",
  "position": 302,
  "title": "عقل در یونان باستان",
  "start": 54,
  "end": 55
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۷",
  "position": 303,
  "title": "عقل نزد فیلسوفان دوره جدید اروپا",
  "start": 56,
  "end": 57
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۷",
  "position": 304,
  "title": "به کار ببندیم",
  "start": 58,
  "end": 58
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۸",
  "position": 300,
  "title": "کل درس",
  "start": 59,
  "end": 67
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۸",
  "position": 301,
  "title": "نمونه‌ها و بررسی عقل در جهان اسلام",
  "start": 60,
  "end": 62
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۸",
  "position": 302,
  "title": "عقل به عنوان موجود متعالی",
  "start": 63,
  "end": 63
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۸",
  "position": 303,
  "title": "عقل به عنوان دستگاه تفکر",
  "start": 64,
  "end": 66
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۸",
  "position": 304,
  "title": "به کار ببندیم",
  "start": 67,
  "end": 67
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۹",
  "position": 300,
  "title": "کل درس",
  "start": 70,
  "end": 77
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۹",
  "position": 301,
  "title": "زمینه‌های رشد فلسفه در جهان اسلام",
  "start": 71,
  "end": 73
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۹",
  "position": 302,
  "title": "حکمای مشاء و فارابی",
  "start": 74,
  "end": 76
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۹",
  "position": 303,
  "title": "به کار ببندیم",
  "start": 77,
  "end": 77
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۰",
  "position": 300,
  "title": "کل درس",
  "start": 78,
  "end": 86
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۰",
  "position": 301,
  "title": "ابن‌سینا و طبیعت‌شناسی",
  "start": 78,
  "end": 82
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۰",
  "position": 302,
  "title": "سهروردی و حکمت اشراق",
  "start": 83,
  "end": 85
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۰",
  "position": 303,
  "title": "به کار ببندیم",
  "start": 86,
  "end": 86
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۱",
  "position": 300,
  "title": "کل درس",
  "start": 87,
  "end": 96
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۱",
  "position": 301,
  "title": "صاحب حکمت متعالیه",
  "start": 88,
  "end": 91
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۱",
  "position": 302,
  "title": "اصالت وجود",
  "start": 92,
  "end": 93
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۱",
  "position": 303,
  "title": "وحدت حقیقت وجود",
  "start": 94,
  "end": 95
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۱",
  "position": 304,
  "title": "مراتب وجود",
  "start": 95,
  "end": 95
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۱",
  "position": 305,
  "title": "به کار ببندیم",
  "start": 96,
  "end": 96
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۲",
  "position": 300,
  "title": "کل درس",
  "start": 97,
  "end": 111
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۲",
  "position": 301,
  "title": "حکیم و عارف مجاهد",
  "start": 99,
  "end": 102
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۲",
  "position": 302,
  "title": "حکیم بزرگ دوره معاصر",
  "start": 103,
  "end": 106
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۲",
  "position": 303,
  "title": "برجسته‌ترین شاگرد و نظام فکری و عملی",
  "start": 107,
  "end": 108
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
  "chapter": "درس ۱۲",
  "position": 304,
  "title": "خودارزیابی و تمرین",
  "start": 109,
  "end": 111
 }
]$topics$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)), tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v181:humanities:'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405','humanities',p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed on conflict(id) do nothing;
