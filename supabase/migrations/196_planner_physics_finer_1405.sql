-- Additional 1405 physics subheadings, by printed page; source and scope in planner-topic-sources.md.
with installed as (insert into private.planner_seed_installations(seed_key) values ('physics-finer-1405-v196') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 500,
  "title": "تبدیل یکاها",
  "start": 10,
  "end": 10
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 501,
  "title": "سازگاری یکاها و پیشوندها",
  "start": 11,
  "end": 11
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 502,
  "title": "نمادگذاری علمی",
  "start": 12,
  "end": 13
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 503,
  "title": "دقت وسیله اندازه‌گیری و مهارت آزمایشگر",
  "start": 14,
  "end": 14
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 504,
  "title": "تعداد دفعات اندازه‌گیری و تفاوت دقت و درستی",
  "start": 15,
  "end": 15
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 505,
  "title": "رقم‌های بامعنا",
  "start": 16,
  "end": 18
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 500,
  "title": "پخش در مایع‌ها",
  "start": 25,
  "end": 25
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 501,
  "title": "پلاسما",
  "start": 26,
  "end": 26
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 502,
  "title": "ویژگی مواد در مقیاس نانو",
  "start": 27,
  "end": 27
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 503,
  "title": "کشش سطحی",
  "start": 29,
  "end": 29
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 504,
  "title": "ترشوندگی",
  "start": 30,
  "end": 30
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 505,
  "title": "اثر مویینگی",
  "start": 31,
  "end": 31
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 506,
  "title": "محاسبه فشار در شاره‌ها",
  "start": 33,
  "end": 36
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 507,
  "title": "فشارسنج هوا",
  "start": 37,
  "end": 37
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 508,
  "title": "مانومتر",
  "start": 38,
  "end": 38
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 509,
  "title": "فشارسنج بوردون",
  "start": 39,
  "end": 39
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 510,
  "title": "اصل ارشمیدس",
  "start": 42,
  "end": 42
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 511,
  "title": "آهنگ شارش حجمی شاره",
  "start": 44,
  "end": 44
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 512,
  "title": "معادله پیوستگی",
  "start": 45,
  "end": 45
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 513,
  "title": "کاربردهای اصل برنولی",
  "start": 46,
  "end": 47
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۳: کار، انرژی و توان",
  "position": 500,
  "title": "کار کل",
  "start": 59,
  "end": 60
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۳: کار، انرژی و توان",
  "position": 501,
  "title": "قانون پایستگی انرژی",
  "start": 72,
  "end": 72
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۳: کار، انرژی و توان",
  "position": 502,
  "title": "بهینه‌سازی مصرف انرژی",
  "start": 77,
  "end": 77
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 500,
  "title": "انبساط طولی",
  "start": 88,
  "end": 89
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 501,
  "title": "دماسنج نواری دوفلزه",
  "start": 90,
  "end": 90
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 502,
  "title": "دماپا",
  "start": 91,
  "end": 91
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 503,
  "title": "انبساط سطحی و حجمی",
  "start": 92,
  "end": 94
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 504,
  "title": "انبساط غیرعادی آب",
  "start": 95,
  "end": 95
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 505,
  "title": "ظرفیت گرمایی",
  "start": 97,
  "end": 97
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 506,
  "title": "گرمای ویژه",
  "start": 98,
  "end": 98
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 507,
  "title": "گرمای ویژه مولی",
  "start": 99,
  "end": 99
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 508,
  "title": "دمای تعادل",
  "start": 100,
  "end": 100
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 509,
  "title": "گرماسنج و گرماسنجی",
  "start": 101,
  "end": 102
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 510,
  "title": "تغییر حالت جامد و مایع",
  "start": 104,
  "end": 106
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 511,
  "title": "تغییر حالت مایع و بخار",
  "start": 107,
  "end": 110
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 512,
  "title": "رسانش گرمایی",
  "start": 112,
  "end": 114
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 513,
  "title": "تابش گرمایی",
  "start": 115,
  "end": 116
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 514,
  "title": "بررسی گاز در فشار ثابت",
  "start": 118,
  "end": 118
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 515,
  "title": "بررسی گاز در حجم ثابت",
  "start": 119,
  "end": 119
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 516,
  "title": "بررسی گاز در دمای ثابت",
  "start": 120,
  "end": 120
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 517,
  "title": "قانون آووگادرو",
  "start": 121,
  "end": 121
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 518,
  "title": "قانون گازهای آرمانی",
  "start": 122,
  "end": 123
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۵: ترمودینامیک",
  "position": 500,
  "title": "تبادل انرژی به صورت گرما و کار",
  "start": 129,
  "end": 129
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۵: ترمودینامیک",
  "position": 501,
  "title": "فرایند هم‌حجم",
  "start": 131,
  "end": 131
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۵: ترمودینامیک",
  "position": 502,
  "title": "فرایند هم‌فشار",
  "start": 132,
  "end": 134
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۵: ترمودینامیک",
  "position": 503,
  "title": "فرایند هم‌دما",
  "start": 135,
  "end": 136
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۵: ترمودینامیک",
  "position": 504,
  "title": "فرایند بی‌دررو",
  "start": 137,
  "end": 138
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۵: ترمودینامیک",
  "position": 505,
  "title": "ماشین گرمایی برون‌سوز",
  "start": 141,
  "end": 141
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۵: ترمودینامیک",
  "position": 506,
  "title": "ماشین گرمایی درون‌سوز",
  "start": 142,
  "end": 143
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۵: ترمودینامیک",
  "position": 507,
  "title": "چرخه اتو",
  "start": 144,
  "end": 144
 },
 {
  "grade": "10",
  "field": "mathematics",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۵: ترمودینامیک",
  "position": 508,
  "title": "بازده ماشین گرمایی",
  "start": 145,
  "end": 145
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 500,
  "title": "تبدیل یکاها",
  "start": 10,
  "end": 10
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 501,
  "title": "سازگاری یکاها و پیشوندها",
  "start": 11,
  "end": 11
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 502,
  "title": "نمادگذاری علمی",
  "start": 12,
  "end": 13
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 503,
  "title": "دقت وسیله اندازه‌گیری و مهارت آزمایشگر",
  "start": 14,
  "end": 14
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 504,
  "title": "تعداد دفعات اندازه‌گیری و تفاوت دقت و درستی",
  "start": 15,
  "end": 15
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
  "position": 505,
  "title": "رقم‌های بامعنا",
  "start": 16,
  "end": 18
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 500,
  "title": "پخش در مایع‌ها",
  "start": 25,
  "end": 25
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 501,
  "title": "پلاسما",
  "start": 26,
  "end": 26
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 502,
  "title": "ویژگی مواد در مقیاس نانو",
  "start": 27,
  "end": 27
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 503,
  "title": "کشش سطحی",
  "start": 29,
  "end": 29
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 504,
  "title": "ترشوندگی",
  "start": 30,
  "end": 30
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 505,
  "title": "اثر مویینگی",
  "start": 31,
  "end": 31
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 506,
  "title": "محاسبه فشار در شاره‌ها",
  "start": 33,
  "end": 36
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 507,
  "title": "فشارسنج هوا",
  "start": 37,
  "end": 37
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 508,
  "title": "مانومتر",
  "start": 38,
  "end": 38
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 509,
  "title": "فشارسنج بوردون",
  "start": 39,
  "end": 39
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 510,
  "title": "اصل ارشمیدس",
  "start": 42,
  "end": 42
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 511,
  "title": "آهنگ شارش حجمی شاره",
  "start": 44,
  "end": 44
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 512,
  "title": "معادله پیوستگی",
  "start": 45,
  "end": 45
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
  "position": 513,
  "title": "کاربردهای اصل برنولی",
  "start": 46,
  "end": 47
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۳: کار، انرژی و توان",
  "position": 500,
  "title": "کار کل",
  "start": 59,
  "end": 60
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۳: کار، انرژی و توان",
  "position": 501,
  "title": "قانون پایستگی انرژی",
  "start": 72,
  "end": 72
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۳: کار، انرژی و توان",
  "position": 502,
  "title": "بهینه‌سازی مصرف انرژی",
  "start": 77,
  "end": 77
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 500,
  "title": "انبساط طولی",
  "start": 88,
  "end": 89
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 501,
  "title": "دماسنج نواری دوفلزه",
  "start": 90,
  "end": 90
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 502,
  "title": "دماپا",
  "start": 91,
  "end": 91
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 503,
  "title": "انبساط سطحی و حجمی",
  "start": 92,
  "end": 94
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 504,
  "title": "انبساط غیرعادی آب",
  "start": 95,
  "end": 95
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 505,
  "title": "ظرفیت گرمایی",
  "start": 97,
  "end": 97
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 506,
  "title": "گرمای ویژه",
  "start": 98,
  "end": 98
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 507,
  "title": "دمای تعادل",
  "start": 99,
  "end": 100
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 508,
  "title": "گرماسنج و گرماسنجی",
  "start": 101,
  "end": 102
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 509,
  "title": "تغییر حالت جامد و مایع",
  "start": 103,
  "end": 105
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 510,
  "title": "تغییر حالت مایع و بخار",
  "start": 106,
  "end": 110
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 511,
  "title": "رسانش گرمایی",
  "start": 112,
  "end": 114
 },
 {
  "grade": "10",
  "field": "experimental_sciences",
  "subject": "فیزیک ۱",
  "chapter": "فصل ۴: دما و گرما",
  "position": 512,
  "title": "تابش گرمایی",
  "start": 115,
  "end": 117
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 500,
  "title": "برهم‌نهی نیروهای الکتروستاتیکی",
  "start": 8,
  "end": 9
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 501,
  "title": "مولد وان دوگراف",
  "start": 13,
  "end": 13
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 502,
  "title": "برهم‌نهی میدان‌های الکتریکی",
  "start": 14,
  "end": 16
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 503,
  "title": "میدان الکتریکی یکنواخت و نیرو بر بار",
  "start": 19,
  "end": 20
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 504,
  "title": "رابطه اختلاف پتانسیل و میدان یکنواخت",
  "start": 26,
  "end": 26
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 505,
  "title": "توزیع بار در رسانا و آزمایش فاراده",
  "start": 27,
  "end": 27
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 506,
  "title": "رسانای خنثی در میدان الکتریکی",
  "start": 28,
  "end": 28
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 507,
  "title": "چگالی سطحی بار رسانا",
  "start": 29,
  "end": 31
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 508,
  "title": "باردار کردن خازن",
  "start": 32,
  "end": 32
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 509,
  "title": "ظرفیت خازن",
  "start": 33,
  "end": 33
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 510,
  "title": "ظرفیت خازن تخت",
  "start": 35,
  "end": 37
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 511,
  "title": "فروریزش الکتریکی",
  "start": 38,
  "end": 40
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 500,
  "title": "تغییر مقاومت ویژه با دما",
  "start": 52,
  "end": 55
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 501,
  "title": "انواع مقاومت و کدگذاری رنگی",
  "start": 56,
  "end": 57
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 502,
  "title": "ترمیستور",
  "start": 58,
  "end": 58
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 503,
  "title": "مقاومت نوری",
  "start": 59,
  "end": 59
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 504,
  "title": "دیودها",
  "start": 60,
  "end": 60
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 505,
  "title": "مدار تک‌حلقه‌ای و افت پتانسیل",
  "start": 64,
  "end": 66
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 506,
  "title": "توان مصرفی در مقاومت",
  "start": 67,
  "end": 68
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 507,
  "title": "توان خروجی منبع واقعی",
  "start": 69,
  "end": 69
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 508,
  "title": "بستن متوالی مقاومت‌ها",
  "start": 70,
  "end": 71
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 509,
  "title": "قاعده انشعاب و بستن موازی",
  "start": 72,
  "end": 78
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس",
  "position": 500,
  "title": "میدان مغناطیسی زمین",
  "start": 87,
  "end": 87
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس",
  "position": 501,
  "title": "میدان مغناطیسی یکنواخت",
  "start": 88,
  "end": 88
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس",
  "position": 502,
  "title": "عوامل مؤثر بر نیروی وارد بر سیم حامل جریان",
  "start": 93,
  "end": 93
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس",
  "position": 503,
  "title": "نیروی بین سیم‌های موازی حامل جریان",
  "start": 96,
  "end": 96
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس",
  "position": 504,
  "title": "میدان حلقه حامل جریان",
  "start": 97,
  "end": 98
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس",
  "position": 505,
  "title": "میدان سیملوله حامل جریان",
  "start": 99,
  "end": 100
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس",
  "position": 506,
  "title": "آهنربای الکتریکی",
  "start": 101,
  "end": 101
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس",
  "position": 507,
  "title": "مواد دیامغناطیسی، پارامغناطیسی و فرومغناطیسی",
  "start": 102,
  "end": 103
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۴: القای الکترومغناطیسی و جریان متناوب",
  "position": 500,
  "title": "خودالقاوری",
  "start": 118,
  "end": 118
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۴: القای الکترومغناطیسی و جریان متناوب",
  "position": 501,
  "title": "ضریب القاوری",
  "start": 119,
  "end": 119
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۴: القای الکترومغناطیسی و جریان متناوب",
  "position": 502,
  "title": "القای متقابل",
  "start": 120,
  "end": 120
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۴: القای الکترومغناطیسی و جریان متناوب",
  "position": 503,
  "title": "انرژی ذخیره‌شده در القاگر",
  "start": 121,
  "end": 121
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۴: القای الکترومغناطیسی و جریان متناوب",
  "position": 504,
  "title": "تولید جریان متناوب",
  "start": 123,
  "end": 125
 },
 {
  "grade": "11",
  "field": "mathematics",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۴: القای الکترومغناطیسی و جریان متناوب",
  "position": 505,
  "title": "مبدل‌ها",
  "start": 126,
  "end": 127
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 500,
  "title": "برایند نیروهای الکتریکی",
  "start": 7,
  "end": 9
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 501,
  "title": "مولد وان دوگراف",
  "start": 12,
  "end": 12
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 502,
  "title": "برایند میدان‌های الکتریکی",
  "start": 13,
  "end": 15
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 503,
  "title": "میدان الکتریکی یکنواخت و نیرو بر بار",
  "start": 18,
  "end": 19
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 504,
  "title": "رابطه اختلاف پتانسیل و میدان یکنواخت",
  "start": 24,
  "end": 24
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 505,
  "title": "آزمایش فاراده",
  "start": 25,
  "end": 27
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 506,
  "title": "باردار کردن خازن",
  "start": 28,
  "end": 28
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 507,
  "title": "ظرفیت خازن",
  "start": 29,
  "end": 29
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 508,
  "title": "ظرفیت خازن تخت",
  "start": 30,
  "end": 31
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۱: الکتریسیته ساکن",
  "position": 509,
  "title": "فروریزش الکتریکی",
  "start": 32,
  "end": 32
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 500,
  "title": "رئوستا",
  "start": 46,
  "end": 46
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 501,
  "title": "مقاومت‌های ترکیبی",
  "start": 47,
  "end": 47
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 502,
  "title": "ترمیستور و مقاومت نوری",
  "start": 48,
  "end": 48
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 503,
  "title": "دیودها",
  "start": 49,
  "end": 49
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 504,
  "title": "توان مصرفی در مقاومت",
  "start": 54,
  "end": 54
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 505,
  "title": "بستن متوالی مقاومت‌ها",
  "start": 56,
  "end": 56
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
  "position": 506,
  "title": "بستن موازی مقاومت‌ها",
  "start": 57,
  "end": 61
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 500,
  "title": "میدان مغناطیسی زمین",
  "start": 69,
  "end": 69
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 501,
  "title": "میدان مغناطیسی یکنواخت",
  "start": 70,
  "end": 70
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 502,
  "title": "عوامل مؤثر بر نیروی وارد بر سیم حامل جریان",
  "start": 75,
  "end": 75
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 503,
  "title": "نیروی بین سیم‌های موازی و میدان حلقه",
  "start": 79,
  "end": 80
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 504,
  "title": "میدان سیملوله حامل جریان",
  "start": 81,
  "end": 81
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 505,
  "title": "آهنربای الکتریکی",
  "start": 82,
  "end": 82
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 506,
  "title": "مواد پارامغناطیسی",
  "start": 83,
  "end": 83
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 507,
  "title": "مواد دیامغناطیسی و فرومغناطیسی",
  "start": 84,
  "end": 84
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 508,
  "title": "کاربرد القاگرها و خودالقاوری",
  "start": 94,
  "end": 94
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 509,
  "title": "انرژی ذخیره‌شده در القاگر",
  "start": 95,
  "end": 96
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 510,
  "title": "تولید جریان متناوب",
  "start": 97,
  "end": 98
 },
 {
  "grade": "11",
  "field": "experimental_sciences",
  "subject": "فیزیک ۲",
  "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
  "position": 511,
  "title": "مبدل‌ها",
  "start": 99,
  "end": 99
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 500,
  "title": "مسافت و جابه‌جایی",
  "start": 2,
  "end": 2
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 501,
  "title": "تندی متوسط و سرعت متوسط",
  "start": 3,
  "end": 6
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 502,
  "title": "سرعت متوسط از نمودار مکان ـ زمان",
  "start": 7,
  "end": 8
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 503,
  "title": "تندی و سرعت لحظه‌ای",
  "start": 9,
  "end": 9
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 504,
  "title": "شتاب متوسط و لحظه‌ای",
  "start": 10,
  "end": 10
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 505,
  "title": "شتاب از نمودار سرعت ـ زمان",
  "start": 11,
  "end": 12
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 506,
  "title": "معادله سرعت ـ زمان در حرکت با شتاب ثابت",
  "start": 15,
  "end": 16
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 507,
  "title": "معادله مکان ـ زمان در حرکت با شتاب ثابت",
  "start": 17,
  "end": 17
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 508,
  "title": "معادله سرعت ـ جابه‌جایی در حرکت با شتاب ثابت",
  "start": 18,
  "end": 20
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 509,
  "title": "سقوط آزاد بدون سرعت اولیه",
  "start": 22,
  "end": 24
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 500,
  "title": "قانون اول نیوتون",
  "start": 30,
  "end": 31
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 501,
  "title": "قانون دوم نیوتون",
  "start": 32,
  "end": 33
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 502,
  "title": "قانون سوم نیوتون",
  "start": 34,
  "end": 34
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 503,
  "title": "نیروی مقاومت شاره",
  "start": 36,
  "end": 36
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 504,
  "title": "نیروی عمودی سطح",
  "start": 37,
  "end": 38
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 505,
  "title": "نیروی اصطکاک",
  "start": 39,
  "end": 39
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 506,
  "title": "اصطکاک ایستایی",
  "start": 40,
  "end": 41
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 507,
  "title": "نیروی اصطکاک جنبشی",
  "start": 42,
  "end": 42
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 508,
  "title": "نیروی کشسانی فنر",
  "start": 43,
  "end": 43
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 509,
  "title": "نیروی کشش طناب",
  "start": 44,
  "end": 45
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 510,
  "title": "شتاب مرکزگرا و قانون دوم نیوتون",
  "start": 51,
  "end": 51
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
  "position": 511,
  "title": "نیروی مرکزگرا",
  "start": 52,
  "end": 52
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 500,
  "title": "آونگ ساده",
  "start": 67,
  "end": 67
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 501,
  "title": "موج عرضی و مشخصه‌های آن",
  "start": 72,
  "end": 73
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 502,
  "title": "انتقال انرژی و امواج الکترومغناطیسی",
  "start": 74,
  "end": 75
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 503,
  "title": "طیف امواج الکترومغناطیسی",
  "start": 76,
  "end": 76
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 504,
  "title": "موج طولی و مشخصه‌های آن",
  "start": 77,
  "end": 77
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 505,
  "title": "موج صوتی",
  "start": 78,
  "end": 79
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 506,
  "title": "شدت و تراز شدت صوت",
  "start": 80,
  "end": 80
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 507,
  "title": "ادراک شنوایی و اثر دوپلر",
  "start": 81,
  "end": 81
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 508,
  "title": "اثر دوپلر با چشمه متحرک",
  "start": 82,
  "end": 82
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 509,
  "title": "اثر دوپلر با ناظر متحرک",
  "start": 83,
  "end": 84
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: برهم‌کنش‌های موج",
  "position": 500,
  "title": "بازتاب امواج مکانیکی",
  "start": 90,
  "end": 92
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: برهم‌کنش‌های موج",
  "position": 501,
  "title": "بازتاب امواج الکترومغناطیسی",
  "start": 93,
  "end": 93
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: برهم‌کنش‌های موج",
  "position": 502,
  "title": "قانون شکست عمومی",
  "start": 96,
  "end": 96
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: برهم‌کنش‌های موج",
  "position": 503,
  "title": "شکست امواج الکترومغناطیسی",
  "start": 97,
  "end": 99
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: برهم‌کنش‌های موج",
  "position": 504,
  "title": "پاشندگی نور",
  "start": 100,
  "end": 100
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: برهم‌کنش‌های موج",
  "position": 505,
  "title": "تداخل امواج سطحی آب",
  "start": 103,
  "end": 103
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: برهم‌کنش‌های موج",
  "position": 506,
  "title": "تداخل امواج صوتی و نوری",
  "start": 104,
  "end": 104
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: برهم‌کنش‌های موج",
  "position": 507,
  "title": "موج ایستاده و تشدید در ریسمان",
  "start": 105,
  "end": 105
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: برهم‌کنش‌های موج",
  "position": 508,
  "title": "بسامدهای تشدید تار",
  "start": 106,
  "end": 107
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: برهم‌کنش‌های موج",
  "position": 509,
  "title": "موج ایستاده در لوله صوتی",
  "start": 108,
  "end": 109
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: برهم‌کنش‌های موج",
  "position": 510,
  "title": "آزمایش هرتز",
  "start": 110,
  "end": 110
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۵: آشنایی با فیزیک اتمی",
  "position": 500,
  "title": "ترازهای انرژی الکترون در مدل بور",
  "start": 128,
  "end": 128
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۵: آشنایی با فیزیک اتمی",
  "position": 501,
  "title": "معادله ریدبرگ و طیف جذبی هیدروژن",
  "start": 129,
  "end": 130
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۵: آشنایی با فیزیک اتمی",
  "position": 502,
  "title": "موفقیت‌ها و نارسایی‌های مدل بور",
  "start": 131,
  "end": 131
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای",
  "position": 500,
  "title": "ایزوتوپ‌ها",
  "start": 139,
  "end": 139
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای",
  "position": 501,
  "title": "پایداری هسته",
  "start": 140,
  "end": 140
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای",
  "position": 502,
  "title": "انرژی بستگی هسته‌ای",
  "start": 141,
  "end": 141
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای",
  "position": 503,
  "title": "نیمه‌عمر",
  "start": 146,
  "end": 147
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای",
  "position": 504,
  "title": "واکنش زنجیری",
  "start": 148,
  "end": 149
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای",
  "position": 505,
  "title": "غنی‌سازی اورانیوم و راکتورهای شکافت",
  "start": 150,
  "end": 151
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای",
  "position": 506,
  "title": "پوزیترون، نوترینو و میون",
  "start": 153,
  "end": 153
 },
 {
  "grade": "12",
  "field": "mathematics",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای",
  "position": 507,
  "title": "طبقه‌بندی ذرات و کوارک‌ها",
  "start": 154,
  "end": 154
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 500,
  "title": "مسافت و جابه‌جایی",
  "start": 2,
  "end": 2
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 501,
  "title": "تندی متوسط و سرعت متوسط",
  "start": 3,
  "end": 6
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 502,
  "title": "سرعت متوسط از نمودار مکان ـ زمان",
  "start": 7,
  "end": 8
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 503,
  "title": "تندی و سرعت لحظه‌ای",
  "start": 9,
  "end": 9
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 504,
  "title": "شتاب متوسط و لحظه‌ای",
  "start": 10,
  "end": 10
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 505,
  "title": "شتاب از نمودار سرعت ـ زمان",
  "start": 11,
  "end": 12
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 506,
  "title": "معادله سرعت ـ زمان در حرکت با شتاب ثابت",
  "start": 15,
  "end": 16
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 507,
  "title": "معادله مکان ـ زمان در حرکت با شتاب ثابت",
  "start": 17,
  "end": 17
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۱: حرکت بر خط راست",
  "position": 508,
  "title": "معادله سرعت ـ جابه‌جایی در حرکت با شتاب ثابت",
  "start": 18,
  "end": 21
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک",
  "position": 500,
  "title": "قانون اول نیوتون",
  "start": 28,
  "end": 29
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک",
  "position": 501,
  "title": "قانون دوم نیوتون",
  "start": 30,
  "end": 31
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک",
  "position": 502,
  "title": "قانون سوم نیوتون",
  "start": 32,
  "end": 32
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک",
  "position": 503,
  "title": "نیروی مقاومت شاره",
  "start": 34,
  "end": 34
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک",
  "position": 504,
  "title": "نیروی عمودی سطح",
  "start": 35,
  "end": 36
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک",
  "position": 505,
  "title": "نیروی اصطکاک",
  "start": 37,
  "end": 37
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک",
  "position": 506,
  "title": "اصطکاک ایستایی",
  "start": 38,
  "end": 39
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک",
  "position": 507,
  "title": "نیروی اصطکاک جنبشی",
  "start": 40,
  "end": 40
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک",
  "position": 508,
  "title": "نیروی کشسانی فنر",
  "start": 41,
  "end": 41
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۲: دینامیک",
  "position": 509,
  "title": "نیروی کشش طناب",
  "start": 42,
  "end": 43
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 500,
  "title": "آونگ ساده",
  "start": 59,
  "end": 59
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 501,
  "title": "موج عرضی و مشخصه‌های آن",
  "start": 64,
  "end": 65
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 502,
  "title": "انتقال انرژی و امواج الکترومغناطیسی",
  "start": 66,
  "end": 67
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 503,
  "title": "طیف امواج الکترومغناطیسی",
  "start": 68,
  "end": 68
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 504,
  "title": "موج طولی و مشخصه‌های آن",
  "start": 69,
  "end": 69
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 505,
  "title": "موج صوتی",
  "start": 70,
  "end": 71
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 506,
  "title": "شدت و تراز شدت صوت",
  "start": 72,
  "end": 72
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 507,
  "title": "ادراک شنوایی",
  "start": 73,
  "end": 74
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 508,
  "title": "اثر دوپلر و چشمه متحرک",
  "start": 75,
  "end": 75
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 509,
  "title": "اثر دوپلر با ناظر متحرک",
  "start": 76,
  "end": 76
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 510,
  "title": "بازتاب امواج مکانیکی",
  "start": 77,
  "end": 79
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 511,
  "title": "بازتاب امواج الکترومغناطیسی",
  "start": 80,
  "end": 80
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 512,
  "title": "قانون شکست عمومی",
  "start": 83,
  "end": 83
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 513,
  "title": "شکست امواج الکترومغناطیسی",
  "start": 84,
  "end": 86
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 514,
  "title": "پاشندگی نور",
  "start": 87,
  "end": 87
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۳: نوسان و موج",
  "position": 515,
  "title": "تار نوری",
  "start": 88,
  "end": 88
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای",
  "position": 500,
  "title": "ترازهای انرژی الکترون در مدل بور",
  "start": 106,
  "end": 106
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای",
  "position": 501,
  "title": "معادله ریدبرگ و طیف جذبی هیدروژن",
  "start": 107,
  "end": 108
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای",
  "position": 502,
  "title": "موفقیت‌ها و نارسایی‌های مدل بور",
  "start": 109,
  "end": 109
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای",
  "position": 503,
  "title": "ایزوتوپ‌ها و پایداری هسته",
  "start": 113,
  "end": 114
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای",
  "position": 504,
  "title": "انرژی بستگی هسته‌ای",
  "start": 115,
  "end": 119
 },
 {
  "grade": "12",
  "field": "experimental_sciences",
  "subject": "فیزیک ۳",
  "chapter": "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای",
  "position": 505,
  "title": "نیمه‌عمر",
  "start": 120,
  "end": 121
 }
]$topics$::jsonb) as p(grade text,field text,subject text,chapter text,position integer,title text,start integer,"end" integer)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v196:'||p.field||':'||p.grade||':'||t.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,t.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks t cross join installed on conflict(id) do nothing;
