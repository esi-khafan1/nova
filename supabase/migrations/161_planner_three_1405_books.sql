-- Directly checked against the three user-provided 1405 textbooks, printed page numbers.
-- Preserve a manager's edits by matching seed identity, original NULL pages and revision 1.
with pages as (select * from jsonb_to_recordset($pages$[
 {
  "generation": "v1",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۵: علوم و معارف دفاع مقدس",
  "new_title": "درس ۵: علوم و معارف دفاع مقدس",
  "position": 3,
  "start": 32,
  "end": 44
 },
 {
  "generation": "v1",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۶: الگوها و اسوه‌های پایداری و مقاومت",
  "new_title": "درس ۶: الگوها و اسوه‌های پایداری و مقاومت",
  "position": 4,
  "start": 45,
  "end": 53
 },
 {
  "generation": "v1",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۷: آشنایی با نیروهای مسلح و خدمت مقدس سربازی",
  "new_title": "درس ۷: آشنایی با نیروهای مسلح و خدمت مقدس سربازی",
  "position": 1,
  "start": 55,
  "end": 63
 },
 {
  "generation": "v1",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۸: نظام جمع و شیوه‌های رزم انفرادی",
  "new_title": "درس ۸: نظام جمع و شیوه‌های رزم انفرادی",
  "position": 2,
  "start": 64,
  "end": 86
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۱: آموزه‌های دفاعی",
  "title": "درس ۱: امنیت و امنیت ملی",
  "new_title": "درس ۱: امنیت و امنیت ملی",
  "position": 101,
  "start": 3,
  "end": 5
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۱: آموزه‌های دفاعی",
  "title": "درس ۱: صلح و انواع تهدید",
  "new_title": "درس ۱: صلح و انواع تهدید",
  "position": 102,
  "start": 8,
  "end": 9
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۱: آموزه‌های دفاعی",
  "title": "درس ۱: حفاظت از اطلاعات کشور",
  "new_title": "درس ۱: حفاظت از اطلاعات کشور",
  "position": 103,
  "start": 9,
  "end": 10
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۱: آموزه‌های دفاعی",
  "title": "درس ۲: مفهوم و منابع اقتدار",
  "new_title": "درس ۲: مفهوم و منابع اقتدار",
  "position": 104,
  "start": 12,
  "end": 13
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۱: آموزه‌های دفاعی",
  "title": "درس ۲: اقتدار و دستاوردهای دفاعی",
  "new_title": "درس ۲: اقتدار و دستاوردهای دفاعی",
  "position": 105,
  "start": 14,
  "end": 18
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۳: انقلاب اسلامی و ضرورت دفاع از آن",
  "new_title": "درس ۳: انقلاب اسلامی و ضرورت دفاع از آن",
  "position": 101,
  "start": 21,
  "end": 22
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۳: دستاوردها و گام دوم انقلاب",
  "new_title": "درس ۳: دستاوردها و گام دوم انقلاب",
  "position": 102,
  "start": 22,
  "end": 25
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۴: ضرورت و تاریخچه تشکیل بسیج",
  "new_title": "درس ۴: ضرورت تشکیل بسیج از دیدگاه قرآن",
  "position": 103,
  "start": 26,
  "end": 27
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۴: اهداف و مأموریت‌ها",
  "new_title": "درس ۴: اهداف و مأموریت‌ها",
  "position": 104,
  "start": 27,
  "end": 28
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۴: شاخص‌های بسیجی نمونه",
  "new_title": "درس ۴: شاخص‌های بسیجی نمونه",
  "position": 105,
  "start": 29,
  "end": 31
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۵: دفاع همه‌جانبه و تجربه‌های دفاع مقدس",
  "new_title": "درس ۵: دفاع همه‌جانبه و تجربه‌های دفاع مقدس",
  "position": 106,
  "start": 33,
  "end": 35
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۵: فرهنگ ایثار و شهادت و سبک زندگی",
  "new_title": "درس ۵: فرهنگ ایثار و شهادت و سبک زندگی",
  "position": 107,
  "start": 36,
  "end": 38
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۵: راهیان نور و آداب سفر",
  "new_title": "درس ۵: راهیان نور و آداب سفر",
  "position": 108,
  "start": 38,
  "end": 44
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۶: حماسه‌سازان نوجوان",
  "new_title": "درس ۶: حماسه‌سازان نوجوان",
  "position": 109,
  "start": 46,
  "end": 48
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۶: شهدای مدافع حرم و الگوهای پایداری",
  "new_title": "درس ۶: شهدای مدافع حرم و الگوهای پایداری",
  "position": 110,
  "start": 49,
  "end": 53
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۷: نیروهای مسلح و فرماندهی کل قوا",
  "new_title": "درس ۷: نیروهای مسلح و فرماندهی کل قوا",
  "position": 101,
  "start": 56,
  "end": 59
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۷: سربازی و تعیین وضعیت خدمت",
  "new_title": "درس ۷: سربازی و تعیین وضعیت خدمت",
  "position": 102,
  "start": 60,
  "end": 61
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۷: مهارت‌آموزی در سربازی",
  "new_title": "درس ۷: مهارت‌آموزی در سربازی",
  "position": 103,
  "start": 62,
  "end": 63
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۸: نظام جمع",
  "new_title": "درس ۸: نظام جمع",
  "position": 104,
  "start": 65,
  "end": 75
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۸: عوارض زمین و شناسایی آن",
  "new_title": "درس ۸: عوارض زمین و شناسایی آن",
  "position": 105,
  "start": 76,
  "end": 83
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۸: اصول نگهبانی",
  "new_title": "درس ۸: اصول نگهبانی",
  "position": 106,
  "start": 83,
  "end": 86
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۹: آشنایی با جنگ‌افزارها",
  "new_title": "درس ۹: آشنایی با جنگ‌افزارها",
  "position": 107,
  "start": 88,
  "end": 101
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۹: اصول و ایمنی تیراندازی",
  "new_title": "درس ۹: اصول و ایمنی تیراندازی",
  "position": 108,
  "start": 102,
  "end": 115
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۰: مفهوم و هدف جنگ نرم",
  "new_title": "درس ۱۰: مفهوم و هدف جنگ نرم",
  "position": 101,
  "start": 119,
  "end": 120
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۰: حوزه‌های جنگ نرم",
  "new_title": "درس ۱۰: حوزه‌های جنگ نرم",
  "position": 102,
  "start": 120,
  "end": 124
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۰: روش‌ها و مراحل مقابله",
  "new_title": "درس ۱۰: روش‌ها و مراحل مقابله",
  "position": 103,
  "start": 125,
  "end": 125
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۱: مفهوم، مأموریت‌ها و اولویت‌های پدافند غیرعامل",
  "new_title": "درس ۱۱: مفهوم، مأموریت‌ها و اولویت‌های پدافند غیرعامل",
  "position": 104,
  "start": 127,
  "end": 128
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۱: پدافند سایبری، اقتصادی و زیستی",
  "new_title": "درس ۱۱: پدافند سایبری، اقتصادی و زیستی",
  "position": 105,
  "start": 128,
  "end": 133
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۲: هشدارها و مخاطره",
  "new_title": "درس ۱۲: هشدارها و مخاطره",
  "position": 106,
  "start": 137,
  "end": 139
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۲: نقشه خطر بلایا",
  "new_title": "درس ۱۲: نقشه خطر بلایا",
  "position": 107,
  "start": 140,
  "end": 141
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۲: ایمنی و پیشگیری",
  "new_title": "درس ۱۲: ایمنی و پیشگیری",
  "position": 108,
  "start": 142,
  "end": 145
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۳: کمک‌های اولیه و ارزیابی مصدوم",
  "new_title": "درس ۱۳: کمک‌های اولیه و ارزیابی مصدوم",
  "position": 109,
  "start": 148,
  "end": 149
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۳: خون‌ریزی و شوک",
  "new_title": "درس ۱۳: خون‌ریزی و شوک",
  "position": 110,
  "start": 149,
  "end": 153
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۳: سوختگی و آسیب‌های اسکلتی",
  "new_title": "درس ۱۳: سوختگی و آسیب‌های اسکلتی",
  "position": 111,
  "start": 154,
  "end": 155
 },
 {
  "generation": "v155",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۳: آتش‌سوزی و خروج یا پناه‌گیری ایمن",
  "new_title": "درس ۱۳: آتش‌سوزی و خروج یا پناه‌گیری ایمن",
  "position": 112,
  "start": 156,
  "end": 158
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۱: آموزه‌های دفاعی",
  "title": "درس ۱: امنیت فردی و اجتماعی و انواع تهدید",
  "new_title": "درس ۱: امنیت فردی و اجتماعی و انواع تهدید",
  "position": 201,
  "start": 3,
  "end": 9
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۱: آموزه‌های دفاعی",
  "title": "درس ۱: حفاظت از اطلاعات و نقش مردم",
  "new_title": "درس ۱: حفاظت از اطلاعات و نقش مردم",
  "position": 202,
  "start": 9,
  "end": 10
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۱: آموزه‌های دفاعی",
  "title": "درس ۲: منابع اقتدار ملی",
  "new_title": "درس ۲: منابع اقتدار ملی",
  "position": 203,
  "start": 12,
  "end": 13
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۱: آموزه‌های دفاعی",
  "title": "درس ۲: خودکفایی و دستاوردهای دفاعی",
  "new_title": "درس ۲: خودکفایی و دستاوردهای دفاعی",
  "position": 204,
  "start": 14,
  "end": 18
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۳: دفاع از انقلاب و آرمان‌های آن",
  "new_title": "درس ۳: دفاع از انقلاب و آرمان‌های آن",
  "position": 201,
  "start": 21,
  "end": 22
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۳: حوزه‌های نقش‌آفرینی در گام دوم",
  "new_title": "درس ۳: حوزه‌های نقش‌آفرینی در گام دوم",
  "position": 202,
  "start": 23,
  "end": 25
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۴: تاریخچه و ضرورت شکل‌گیری بسیج",
  "new_title": "درس ۴: آمادگی دفاعی و ضرورت بسیج",
  "position": 203,
  "start": 26,
  "end": 27
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۴: مأموریت‌ها و ویژگی‌های بسیجی",
  "new_title": "درس ۴: مأموریت‌ها و ویژگی‌های بسیجی",
  "position": 204,
  "start": 28,
  "end": 29
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۵: دفاع همه‌جانبه و مراحل جنگ",
  "new_title": "درس ۵: دفاع همه‌جانبه و مراحل جنگ",
  "position": 205,
  "start": 33,
  "end": 35
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۵: بهره‌گیری از تجربه‌های دفاع مقدس",
  "new_title": "درس ۵: بهره‌گیری از تجربه‌های دفاع مقدس",
  "position": 206,
  "start": 35,
  "end": 36
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۶: اسوه‌های مقاومت و حماسه‌سازان نوجوان",
  "new_title": "درس ۶: اسوه‌های مقاومت و حماسه‌سازان نوجوان",
  "position": 207,
  "start": 46,
  "end": 48
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۲: فرهنگ دفاع",
  "title": "درس ۶: تداوم دفاع و مدافعان حرم",
  "new_title": "درس ۶: تداوم دفاع و مدافعان حرم",
  "position": 208,
  "start": 49,
  "end": 53
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۷: فرماندهی و ویژگی‌های نیروهای مسلح",
  "new_title": "درس ۷: فرماندهی و ویژگی‌های نیروهای مسلح",
  "position": 201,
  "start": 56,
  "end": 59
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۷: وظیفه ملی سربازی و فرصت مهارت‌آموزی",
  "new_title": "درس ۷: وظیفه ملی سربازی و فرصت مهارت‌آموزی",
  "position": 202,
  "start": 60,
  "end": 63
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۸: اهداف آموزش نظام جمع",
  "new_title": "درس ۸: اهداف آموزش نظام جمع",
  "position": 203,
  "start": 65,
  "end": 65
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۸: شناخت و تقسیم‌بندی عوارض زمین",
  "new_title": "درس ۸: شناخت و تقسیم‌بندی عوارض زمین",
  "position": 204,
  "start": 76,
  "end": 83
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۹: سیر تحول و دسته‌بندی جنگ‌افزارها",
  "new_title": "درس ۹: سیر تحول و دسته‌بندی جنگ‌افزارها",
  "position": 205,
  "start": 88,
  "end": 92
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۳: دفاع نظامی",
  "title": "درس ۹: قوانین و مقررات ایمنی",
  "new_title": "درس ۹: قوانین و مقررات ایمنی",
  "position": 206,
  "start": 102,
  "end": 103
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۰: جنگ نرم و حوزه‌های فرهنگی، اجتماعی و سیاسی",
  "new_title": "درس ۱۰: جنگ نرم و حوزه‌های فرهنگی، اجتماعی و سیاسی",
  "position": 201,
  "start": 119,
  "end": 121
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۰: حوزه‌های اقتصادی، علمی و زیست‌محیطی",
  "new_title": "درس ۱۰: حوزه‌های اقتصادی، علمی و زیست‌محیطی",
  "position": 202,
  "start": 122,
  "end": 124
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۱: اولویت‌های پدافند غیرعامل",
  "new_title": "درس ۱۱: اولویت‌های پدافند غیرعامل",
  "position": 203,
  "start": 127,
  "end": 128
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۱: نبرد سایبری و پدافند زیستی و اقتصادی",
  "new_title": "درس ۱۱: نبرد سایبری و پدافند زیستی و اقتصادی",
  "position": 204,
  "start": 128,
  "end": 133
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۲: شناسایی خطر و نقشه خطر بلایا",
  "new_title": "درس ۱۲: شناسایی خطر و نقشه خطر بلایا",
  "position": 205,
  "start": 137,
  "end": 141
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۲: توصیه‌های ایمنی و پیشگیری",
  "new_title": "درس ۱۲: توصیه‌های ایمنی و پیشگیری",
  "position": 206,
  "start": 142,
  "end": 145
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۳: مهم‌ترین اقدامات کمک‌های اولیه",
  "new_title": "درس ۱۳: مهم‌ترین اقدامات کمک‌های اولیه",
  "position": 207,
  "start": 148,
  "end": 150
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۳: خون‌ریزی داخلی و خارجی و شوک",
  "new_title": "درس ۱۳: خون‌ریزی داخلی و خارجی و شوک",
  "position": 208,
  "start": 149,
  "end": 153
 },
 {
  "generation": "v156",
  "subject": "آمادگی دفاعی",
  "grade": "10",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapter": "فصل ۴: دفاع غیرنظامی",
  "title": "درس ۱۳: آسیب‌های اسکلتی، سوختگی و آتش‌سوزی",
  "new_title": "درس ۱۳: آسیب‌های اسکلتی، سوختگی و آتش‌سوزی",
  "position": 209,
  "start": 154,
  "end": 158
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: پدیده‌های اجتماعی",
  "title": "کنش اجتماعی",
  "new_title": "کنش اجتماعی",
  "position": 1,
  "start": 8,
  "end": 10
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: پدیده‌های اجتماعی",
  "title": "شکل‌گیری و انواع پدیده‌های اجتماعی",
  "new_title": "شکل‌گیری و انواع پدیده‌های اجتماعی",
  "position": 2,
  "start": 10,
  "end": 12
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: پدیده‌های اجتماعی",
  "title": "پیوند کنش‌ها و پدیده‌های اجتماعی",
  "new_title": "پیوند کنش‌ها و پدیده‌های اجتماعی",
  "position": 3,
  "start": 10,
  "end": 13
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: جامعه و فرهنگ",
  "title": "جامعه و فرهنگ",
  "new_title": "جامعه و فرهنگ",
  "position": 1,
  "start": 17,
  "end": 20
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: جامعه و فرهنگ",
  "title": "الزامات و فرصت‌های جهان اجتماعی",
  "new_title": "الزامات و فرصت‌های جهان اجتماعی",
  "position": 2,
  "start": 21,
  "end": 23
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: جامعه و فرهنگ",
  "title": "محدودیت‌های جامعه و فرهنگ",
  "new_title": "محدودیت‌های جامعه و فرهنگ",
  "position": 3,
  "start": 21,
  "end": 23
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: ارزیابی فرهنگ‌ها",
  "title": "فرهنگ واقعی و فرهنگ آرمانی",
  "new_title": "فرهنگ واقعی و فرهنگ آرمانی",
  "position": 1,
  "start": 25,
  "end": 27
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: ارزیابی فرهنگ‌ها",
  "title": "فرهنگ حق و فرهنگ باطل",
  "new_title": "فرهنگ حق و فرهنگ باطل",
  "position": 2,
  "start": 27,
  "end": 28
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: ارزیابی فرهنگ‌ها",
  "title": "معیار ارزیابی فرهنگ‌ها",
  "new_title": "معیار ارزیابی فرهنگ‌ها",
  "position": 3,
  "start": 28,
  "end": 32
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: هویت",
  "title": "هویت فردی و اجتماعی",
  "new_title": "هویت فردی و اجتماعی",
  "position": 1,
  "start": 34,
  "end": 36
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: هویت",
  "title": "نسبت هویت فرد و جامعه",
  "new_title": "نسبت هویت فرد و جامعه",
  "position": 2,
  "start": 36,
  "end": 39
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: هویت",
  "title": "خودآگاهی و هویت",
  "new_title": "خودآگاهی و هویت",
  "position": 3,
  "start": 40,
  "end": 42
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: بازتولید هویت اجتماعی",
  "title": "جامعه‌پذیری",
  "new_title": "جامعه‌پذیری",
  "position": 1,
  "start": 44,
  "end": 45
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: بازتولید هویت اجتماعی",
  "title": "کنترل اجتماعی و روش‌های آن",
  "new_title": "کنترل اجتماعی و روش‌های آن",
  "position": 2,
  "start": 45,
  "end": 46
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: بازتولید هویت اجتماعی",
  "title": "تحرک اجتماعی",
  "new_title": "تحرک اجتماعی",
  "position": 3,
  "start": 47,
  "end": 50
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: تحولات هویتی جامعه",
  "title": "علل درونی تحولات هویتی",
  "new_title": "علل درونی تحولات هویتی",
  "position": 1,
  "start": 53,
  "end": 55
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: تحولات هویتی جامعه",
  "title": "تعامل فرهنگی جوامع",
  "new_title": "تعامل فرهنگی جوامع",
  "position": 2,
  "start": 55,
  "end": 57
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: تحولات هویتی جامعه",
  "title": "خودباختگی فرهنگی",
  "new_title": "خودباختگی فرهنگی",
  "position": 3,
  "start": 57,
  "end": 58
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: بعد فرهنگی هویت ایران",
  "title": "ویژگی‌های هویت فرهنگی ایران",
  "new_title": "ویژگی‌های هویت فرهنگی ایران",
  "position": 1,
  "start": 62,
  "end": 66
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: بعد فرهنگی هویت ایران",
  "title": "نقش اسلام در هویت ایرانی",
  "new_title": "نقش اسلام در هویت ایرانی",
  "position": 2,
  "start": 63,
  "end": 64
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: بعد فرهنگی هویت ایران",
  "title": "انقلاب اسلامی و هویت فرهنگی",
  "new_title": "انقلاب اسلامی و هویت فرهنگی",
  "position": 3,
  "start": 66,
  "end": 67
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: بعد سیاسی هویت ایران",
  "title": "رابطه نظام سیاسی و فرهنگ",
  "new_title": "رابطه نظام سیاسی و فرهنگ",
  "position": 1,
  "start": 72,
  "end": 73
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: بعد سیاسی هویت ایران",
  "title": "انواع نظام سیاسی",
  "new_title": "انواع نظام سیاسی",
  "position": 2,
  "start": 78,
  "end": 80
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: بعد سیاسی هویت ایران",
  "title": "هویت سیاسی ایران و جمهوری اسلامی",
  "new_title": "هویت سیاسی ایران و جمهوری اسلامی",
  "position": 3,
  "start": 80,
  "end": 81
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران",
  "title": "جمعیت و هویت اجتماعی",
  "new_title": "جمعیت و هویت اجتماعی",
  "position": 1,
  "start": 83,
  "end": 85
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران",
  "title": "وضعیت جمعیت ایران",
  "new_title": "وضعیت جمعیت ایران",
  "position": 2,
  "start": 85,
  "end": 87
 },
 {
  "generation": "v1",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران",
  "title": "اقتصاد و هویت اقتصادی ایران",
  "new_title": "اقتصاد و هویت اقتصادی ایران",
  "position": 3,
  "start": 88,
  "end": 90
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: پدیده‌های اجتماعی",
  "title": "ارزش‌ها و هنجارهای اجتماعی",
  "new_title": "ارزش‌ها و هنجارهای اجتماعی",
  "position": 201,
  "start": 11,
  "end": 12
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: پدیده‌های اجتماعی",
  "title": "معناداری و استقلال پدیده اجتماعی",
  "new_title": "معناداری و استقلال پدیده اجتماعی",
  "position": 202,
  "start": 10,
  "end": 12
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: پدیده‌های اجتماعی",
  "title": "از من تا ما و پیوند افراد",
  "new_title": "از من تا ما و پیوند افراد",
  "position": 203,
  "start": 13,
  "end": 15
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: جامعه و فرهنگ",
  "title": "فرصت‌ها و محدودیت‌های جامعه و فرهنگ",
  "new_title": "فرصت‌ها و محدودیت‌های جامعه و فرهنگ",
  "position": 201,
  "start": 21,
  "end": 23
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: جامعه و فرهنگ",
  "title": "رابطه فرهنگ و جامعه",
  "new_title": "رابطه فرهنگ و جامعه",
  "position": 202,
  "start": 17,
  "end": 19
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: ارزیابی فرهنگ‌ها",
  "title": "ارزیابی واقعیت با آرمان",
  "new_title": "ارزیابی واقعیت با آرمان",
  "position": 201,
  "start": 25,
  "end": 27
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: ارزیابی فرهنگ‌ها",
  "title": "شناخت و معیار حق و باطل",
  "new_title": "شناخت و معیار حق و باطل",
  "position": 202,
  "start": 27,
  "end": 32
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: هویت",
  "title": "هویت انتسابی و اکتسابی",
  "new_title": "هویت انتسابی و اکتسابی",
  "position": 201,
  "start": 34,
  "end": 36
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: هویت",
  "title": "هویت ثابت و متغیر",
  "new_title": "هویت ثابت و متغیر",
  "position": 202,
  "start": 35,
  "end": 36
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: هویت",
  "title": "خودآگاهی و ناخودآگاهی",
  "new_title": "خودآگاهی و ناخودآگاهی",
  "position": 203,
  "start": 40,
  "end": 42
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: بازتولید هویت اجتماعی",
  "title": "کژروی اجتماعی و پیشگیری از آن",
  "new_title": "کژروی اجتماعی و پیشگیری از آن",
  "position": 201,
  "start": 45,
  "end": 46
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: بازتولید هویت اجتماعی",
  "title": "انواع تحرک اجتماعی: صعودی، نزولی و افقی",
  "new_title": "انواع تحرک اجتماعی: صعودی، نزولی و افقی",
  "position": 202,
  "start": 47,
  "end": 50
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: تحولات هویتی جامعه",
  "title": "تحولات مثبت و منفی فرهنگی",
  "new_title": "تحولات مثبت و منفی فرهنگی",
  "position": 201,
  "start": 54,
  "end": 55
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: تحولات هویتی جامعه",
  "title": "علل بیرونی و تعامل فرهنگ‌ها",
  "new_title": "علل بیرونی و تعامل فرهنگ‌ها",
  "position": 202,
  "start": 55,
  "end": 57
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: تحولات هویتی جامعه",
  "title": "از خودبیگانگی فرهنگی",
  "new_title": "از خودبیگانگی فرهنگی",
  "position": 203,
  "start": 58,
  "end": 60
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: بعد فرهنگی هویت ایران",
  "title": "ایران پیش و پس از اسلام",
  "new_title": "ایران پیش و پس از اسلام",
  "position": 201,
  "start": 62,
  "end": 64
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: بعد فرهنگی هویت ایران",
  "title": "زبان فارسی و تمدن اسلامی",
  "new_title": "زبان فارسی و تمدن اسلامی",
  "position": 202,
  "start": 63,
  "end": 64
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: بعد فرهنگی هویت ایران",
  "title": "رویارویی با فرهنگ جدید غرب",
  "new_title": "رویارویی با فرهنگ جدید غرب",
  "position": 203,
  "start": 64,
  "end": 66
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: بعد سیاسی هویت ایران",
  "title": "قدرت فردی و قدرت اجتماعی",
  "new_title": "قدرت فردی و قدرت اجتماعی",
  "position": 201,
  "start": 73,
  "end": 74
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: بعد سیاسی هویت ایران",
  "title": "مقبولیت، مشروعیت و اقتدار",
  "new_title": "مقبولیت، مشروعیت و اقتدار",
  "position": 202,
  "start": 75,
  "end": 76
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: بعد سیاسی هویت ایران",
  "title": "قدرت سخت و نرم",
  "new_title": "قدرت سخت و نرم",
  "position": 203,
  "start": 74,
  "end": 75
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: بعد سیاسی هویت ایران",
  "title": "نظام سیاسی و مقایسه جمهوری اسلامی و لیبرال دموکراسی",
  "new_title": "نظام سیاسی و مقایسه جمهوری اسلامی و لیبرال دموکراسی",
  "position": 204,
  "start": 78,
  "end": 81
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران",
  "title": "کمیت و کیفیت جمعیت",
  "new_title": "کمیت و کیفیت جمعیت",
  "position": 201,
  "start": 83,
  "end": 85
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران",
  "title": "سیاست‌های جمعیتی ایران",
  "new_title": "سیاست‌های جمعیتی ایران",
  "position": 202,
  "start": 85,
  "end": 87
 },
 {
  "generation": "v156",
  "subject": "علوم اجتماعی",
  "grade": "12",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران",
  "title": "هویت اقتصادی و فرهنگ اقتصادی",
  "new_title": "هویت اقتصادی و فرهنگ اقتصادی",
  "position": 203,
  "start": 88,
  "end": 90
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدایت الهی",
  "title": "نیازهای طبیعی و نیازهای برتر",
  "new_title": "نیازهای طبیعی و نیازهای برتر",
  "position": 1,
  "start": 13,
  "end": 14
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدایت الهی",
  "title": "پاسخ به نیازهای برتر",
  "new_title": "پاسخ به نیازهای برتر",
  "position": 2,
  "start": 14,
  "end": 15
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدایت الهی",
  "title": "شیوه هدایت خداوند",
  "new_title": "شیوه هدایت خداوند",
  "position": 3,
  "start": 15,
  "end": 16
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: تداوم هدایت",
  "title": "فطرت مشترک و دین واحد",
  "new_title": "فطرت مشترک و دین واحد",
  "position": 1,
  "start": 23,
  "end": 25
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: تداوم هدایت",
  "title": "علل فرستادن پیامبران متعدد",
  "new_title": "علل فرستادن پیامبران متعدد",
  "position": 2,
  "start": 25,
  "end": 28
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: تداوم هدایت",
  "title": "ختم نبوت و عوامل آن",
  "new_title": "ختم نبوت و عوامل آن",
  "position": 3,
  "start": 28,
  "end": 30
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: معجزه جاویدان",
  "title": "معجزه پیامبران و معجزه جاویدان",
  "new_title": "معجزه پیامبران و معجزه جاویدان",
  "position": 1,
  "start": 36,
  "end": 38
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: معجزه جاویدان",
  "title": "تحدی قرآن",
  "new_title": "تحدی قرآن",
  "position": 2,
  "start": 37,
  "end": 38
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: معجزه جاویدان",
  "title": "جنبه‌های اعجاز قرآن",
  "new_title": "جنبه‌های اعجاز قرآن",
  "position": 3,
  "start": 39,
  "end": 43
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "title": "دریافت و ابلاغ وحی",
  "new_title": "دریافت و ابلاغ وحی",
  "position": 1,
  "start": 49,
  "end": 49
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "title": "مرجعیت دینی و تبیین قرآن",
  "new_title": "مرجعیت دینی و تبیین قرآن",
  "position": 2,
  "start": 49,
  "end": 49
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "title": "ولایت ظاهری و معنوی",
  "new_title": "ولایت ظاهری و معنوی",
  "position": 3,
  "start": 49,
  "end": 53
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "title": "عصمت پیامبر",
  "new_title": "عصمت پیامبر",
  "position": 4,
  "start": 53,
  "end": 54
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "title": "استمرار امامت",
  "new_title": "استمرار امامت",
  "position": 1,
  "start": 62,
  "end": 63
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "title": "تعیین امام",
  "new_title": "تعیین امام",
  "position": 2,
  "start": 64,
  "end": 68
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "title": "آیات و احادیث امامت",
  "new_title": "آیات و احادیث امامت",
  "position": 3,
  "start": 64,
  "end": 70
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: پیشوایان اسوه",
  "title": "اسوه‌های رهبری",
  "new_title": "اسوه‌های رهبری",
  "position": 1,
  "start": 74,
  "end": 75
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: پیشوایان اسوه",
  "title": "ویژگی‌های سیره پیامبر",
  "new_title": "ویژگی‌های سیره پیامبر",
  "position": 2,
  "start": 75,
  "end": 78
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: پیشوایان اسوه",
  "title": "رهبری و اصلاحات امام علی",
  "new_title": "رهبری و اصلاحات امام علی",
  "position": 3,
  "start": 79,
  "end": 83
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "title": "رویدادهای پس از رحلت پیامبر",
  "new_title": "رویدادهای پس از رحلت پیامبر",
  "position": 1,
  "start": 88,
  "end": 90
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "title": "چالش‌های سیاسی، اجتماعی و فرهنگی عصر امامان",
  "new_title": "چالش‌های سیاسی، اجتماعی و فرهنگی عصر امامان",
  "position": 2,
  "start": 91,
  "end": 93
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "title": "تحریف معارف و جعل حدیث",
  "new_title": "تحریف معارف و جعل حدیث",
  "position": 3,
  "start": 91,
  "end": 92
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "title": "احیای معارف اسلامی",
  "new_title": "احیای معارف اسلامی",
  "position": 1,
  "start": 100,
  "end": 102
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "title": "مجاهده در راستای ولایت ظاهری",
  "new_title": "مجاهده در راستای ولایت ظاهری",
  "position": 2,
  "start": 102,
  "end": 104
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "title": "وظیفه ما در برابر پیامبر و امامان",
  "new_title": "وظیفه ما در برابر پیامبر و امامان",
  "position": 3,
  "start": 105,
  "end": 106
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: عصر غیبت",
  "title": "غیبت صغری و کبری",
  "new_title": "غیبت صغری و کبری",
  "position": 1,
  "start": 110,
  "end": 113
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: عصر غیبت",
  "title": "رهبری امام در عصر غیبت",
  "new_title": "رهبری امام در عصر غیبت",
  "position": 2,
  "start": 113,
  "end": 114
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: عصر غیبت",
  "title": "انتظار و آمادگی برای ظهور",
  "new_title": "انتظار و آمادگی برای ظهور",
  "position": 3,
  "start": 116,
  "end": 120
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "title": "تداوم مسئولیت‌های امام در عصر غیبت",
  "new_title": "تداوم مسئولیت‌های امام در عصر غیبت",
  "position": 1,
  "start": 124,
  "end": 126
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "title": "مرجع تقلید و شرایط آن",
  "new_title": "مرجع تقلید و شرایط آن",
  "position": 2,
  "start": 127,
  "end": 128
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "title": "ولایت فقیه و انتخاب رهبر",
  "new_title": "ولایت فقیه و انتخاب رهبر",
  "position": 3,
  "start": 128,
  "end": 132
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: عزت نفس",
  "title": "عزت و ذلت",
  "new_title": "عزت و ذلت",
  "position": 1,
  "start": 139,
  "end": 139
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: عزت نفس",
  "title": "راه‌های تقویت عزت نفس",
  "new_title": "راه‌های تقویت عزت نفس",
  "position": 2,
  "start": 140,
  "end": 141
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: عزت نفس",
  "title": "اسوه‌های عزت نفس",
  "new_title": "اسوه‌های عزت نفس",
  "position": 3,
  "start": 141,
  "end": 141
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: عزت نفس",
  "title": "ایستادگی در برابر تمایلات پست",
  "new_title": "ایستادگی در برابر تمایلات پست",
  "position": 4,
  "start": 141,
  "end": 143
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیوند مقدس",
  "title": "اهمیت ازدواج و تشکیل خانواده",
  "new_title": "اهمیت ازدواج و تشکیل خانواده",
  "position": 1,
  "start": 148,
  "end": 149
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیوند مقدس",
  "title": "ویژگی‌های زن و مرد و زندگی مشترک",
  "new_title": "ویژگی‌های زن و مرد و زندگی مشترک",
  "position": 2,
  "start": 149,
  "end": 151
 },
 {
  "generation": "v1",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیوند مقدس",
  "title": "مسئولیت و روابط اعضای خانواده",
  "new_title": "مسئولیت و روابط اعضای خانواده",
  "position": 3,
  "start": 150,
  "end": 153
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدایت الهی",
  "title": "شناخت هدف زندگی، آینده و راه درست زندگی",
  "new_title": "شناخت هدف زندگی، آینده و راه درست زندگی",
  "position": 201,
  "start": 13,
  "end": 14
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱: هدایت الهی",
  "title": "هدایت تکوینی و تشریعی",
  "new_title": "شیوه هدایت انسان: عقل و وحی",
  "position": 202,
  "start": 15,
  "end": 16
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: تداوم هدایت",
  "title": "نیاز همیشگی انسان به هدایت",
  "new_title": "نیاز همیشگی انسان به هدایت",
  "position": 201,
  "start": 22,
  "end": 25
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۲: تداوم هدایت",
  "title": "فطرت، دین واحد و ختم نبوت",
  "new_title": "فطرت، دین واحد و ختم نبوت",
  "position": 202,
  "start": 24,
  "end": 30
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: معجزه جاویدان",
  "title": "اعجاز لفظی و محتوایی قرآن",
  "new_title": "اعجاز لفظی و محتوایی قرآن",
  "position": 201,
  "start": 39,
  "end": 43
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۳: معجزه جاویدان",
  "title": "تدبر و پیام آیات مربوط به اعجاز",
  "new_title": "تدبر و پیام آیات مربوط به اعجاز",
  "position": 202,
  "start": 37,
  "end": 43
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "title": "ضرورت تشکیل حکومت اسلامی",
  "new_title": "ضرورت تشکیل حکومت اسلامی",
  "position": 201,
  "start": 50,
  "end": 52
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "title": "ولایت ظاهری و ولایت معنوی",
  "new_title": "ولایت ظاهری و ولایت معنوی",
  "position": 202,
  "start": 49,
  "end": 53
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۴: مسئولیت‌های پیامبر",
  "title": "آیات و پیام‌های مسئولیت پیامبر",
  "new_title": "آیات و پیام‌های مسئولیت پیامبر",
  "position": 203,
  "start": 49,
  "end": 54
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "title": "آیه انذار، ولایت و اولی‌الامر",
  "new_title": "آیه انذار، ولایت و اولی‌الامر",
  "position": 201,
  "start": 64,
  "end": 66
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "title": "حدیث ثقلین و منزلت",
  "new_title": "حدیث ثقلین و منزلت",
  "position": 202,
  "start": 67,
  "end": 67
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "title": "آیه تبلیغ و واقعه غدیر",
  "new_title": "آیه تبلیغ و واقعه غدیر",
  "position": 203,
  "start": 68,
  "end": 69
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۵: امامت، تداوم رسالت",
  "title": "آیه تطهیر و عصمت اهل بیت",
  "new_title": "آیه تطهیر و عصمت اهل بیت",
  "position": 204,
  "start": 69,
  "end": 70
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: پیشوایان اسوه",
  "title": "سیره و ویژگی‌های پیامبر",
  "new_title": "سیره و ویژگی‌های پیامبر",
  "position": 201,
  "start": 75,
  "end": 78
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: پیشوایان اسوه",
  "title": "همراهی امام علی با پیامبر",
  "new_title": "همراهی امام علی با پیامبر",
  "position": 202,
  "start": 79,
  "end": 81
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۶: پیشوایان اسوه",
  "title": "عدالت و دانش امام علی",
  "new_title": "عدالت و دانش امام علی",
  "position": 203,
  "start": 82,
  "end": 83
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "title": "وضعیت حکومت پس از رحلت پیامبر",
  "new_title": "وضعیت حکومت پس از رحلت پیامبر",
  "position": 201,
  "start": 88,
  "end": 90
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "title": "جلوگیری از نقل حدیث و پیامدها",
  "new_title": "ممنوعیت نوشتن حدیث و پیامدها",
  "position": 202,
  "start": 91,
  "end": 92
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
  "title": "تحریف معارف و پیدایش جریان‌های فکری",
  "new_title": "تحریف معارف و الگوهای نامناسب",
  "position": 203,
  "start": 92,
  "end": 93
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "title": "حفظ سخنان پیامبر و تبیین معارف",
  "new_title": "حفظ سخنان پیامبر و تبیین معارف",
  "position": 201,
  "start": 100,
  "end": 102
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "title": "اصول و شیوه‌های مبارزه امامان",
  "new_title": "اصول و شیوه‌های مبارزه امامان",
  "position": 202,
  "start": 102,
  "end": 104
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۸: احیای ارزش‌های راستین",
  "title": "تقیه و حفظ تشیع",
  "new_title": "تقیه و حفظ تشیع",
  "position": 203,
  "start": 104,
  "end": 105
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: عصر غیبت",
  "title": "موعود در ادیان و اسلام",
  "new_title": "موعود در ادیان و اسلام",
  "position": 201,
  "start": 114,
  "end": 115
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: عصر غیبت",
  "title": "مسئولیت‌های منتظران",
  "new_title": "مسئولیت‌های منتظران",
  "position": 202,
  "start": 116,
  "end": 119
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۹: عصر غیبت",
  "title": "ویژگی‌های جامعه مهدوی",
  "new_title": "ویژگی‌های جامعه مهدوی",
  "position": 203,
  "start": 119,
  "end": 120
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "title": "فقاهت و وظیفه مرجع تقلید",
  "new_title": "فقاهت و وظیفه مرجع تقلید",
  "position": 201,
  "start": 127,
  "end": 128
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
  "title": "وظایف رهبر، مردم و کارگزاران",
  "new_title": "وظایف رهبر، مردم و کارگزاران",
  "position": 202,
  "start": 129,
  "end": 132
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: عزت نفس",
  "title": "شناخت ارزش خود و بندگی خدا",
  "new_title": "شناخت ارزش خود و بندگی خدا",
  "position": 201,
  "start": 140,
  "end": 141
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۱: عزت نفس",
  "title": "عزت در برابر هوس و ستم",
  "new_title": "عزت در برابر هوس و ستم",
  "position": 202,
  "start": 141,
  "end": 143
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیوند مقدس",
  "title": "آمادگی و اهداف تشکیل خانواده",
  "new_title": "آمادگی و اهداف تشکیل خانواده",
  "position": 201,
  "start": 151,
  "end": 153
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیوند مقدس",
  "title": "معیارهای انتخاب همسر و مشورت",
  "new_title": "معیارهای انتخاب همسر و مشورت",
  "position": 202,
  "start": 153,
  "end": 155
 },
 {
  "generation": "v156",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیوند مقدس",
  "title": "بلوغ عقلی و زمان مناسب ازدواج",
  "new_title": "بلوغ عقلی و زمان مناسب ازدواج",
  "position": 203,
  "start": 155,
  "end": 156
 },
 {
  "generation": "v155",
  "subject": "تعلیمات دینی ۲",
  "grade": "11",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapter": "درس ۱۲: پیوند مقدس",
  "title": "کل درس",
  "new_title": "کل درس",
  "position": 101,
  "start": 148,
  "end": 158
 }
]$pages$::jsonb)
 as p(generation text,subject text,grade text,fields jsonb,chapter text,title text,new_title text,position integer,start integer,"end" integer)),
 expanded as (select p.*,f.field from pages p cross join lateral jsonb_array_elements_text(p.fields) f(field))
update private.planner_topic_bank t set title=p.new_title,page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from expanded p
where t.id=md5('nova:planner:1405:'||p.generation||':'||p.field||':'||p.grade||':final_exam:'||p.subject||':'||p.chapter||':'||p.position)::uuid
 and t.edition='1405' and t.study_field=p.field and t.grade=p.grade and t.preparation_track='final_exam'
 and t.subject=p.subject and t.chapter=p.chapter and t.title=p.title and t.position=p.position
 and t.page_start is null and t.page_end is null and t.revision=1;

-- Pages 134-135 begin a new book section; 136-137 are the next lesson's recitation.
-- Correct only the exact original v155 default, retaining any administrator edits.
with fields(field) as (values ('mathematics'),('experimental_sciences'))
update private.planner_topic_bank t set page_end=133,revision=t.revision+1,updated_at=now()
from fields f where t.id=md5('nova:planner:1405:v155:'||f.field||':11:final_exam:تعلیمات دینی ۲:درس ۱۰: مرجعیت و ولایت فقیه:101')::uuid
 and t.edition='1405' and t.study_field=f.field and t.grade='11' and t.preparation_track='final_exam'
 and t.subject='تعلیمات دینی ۲' and t.chapter='درس ۱۰: مرجعیت و ولایت فقیه'
 and t.title='کل درس' and t.position=101 and t.page_start=124 and t.page_end=137 and t.revision=1;

-- The 158 NULL/revision-2 row could be a deliberate manager edit. Do not
-- change it: offer a distinct verified whole-lesson row and detailed headings.
with topics as (select * from jsonb_to_recordset($new$[
 {
  "title": "درس ۹: جنگ‌افزارشناسی و اصول تیراندازی (بازه تأییدشده)",
  "position": 301,
  "start": 87,
  "end": 116
 },
 {
  "title": "درس ۹: مشخصات و مختصات جنگ‌افزار",
  "position": 302,
  "start": 93,
  "end": 94
 },
 {
  "title": "درس ۹: متعلقات جنگ‌افزار",
  "position": 303,
  "start": 94,
  "end": 96
 },
 {
  "title": "درس ۹: اجزا و مهمات",
  "position": 304,
  "start": 97,
  "end": 99
 },
 {
  "title": "درس ۹: باز و بست قطعات",
  "position": 305,
  "start": 99,
  "end": 101
 },
 {
  "title": "درس ۹: اصول و آمادگی تیراندازی",
  "position": 306,
  "start": 102,
  "end": 103
 },
 {
  "title": "درس ۹: حالت‌گیری تیراندازی",
  "position": 307,
  "start": 103,
  "end": 109
 },
 {
  "title": "درس ۹: نشانه‌گیری و کنترل تنفس",
  "position": 308,
  "start": 109,
  "end": 112
 },
 {
  "title": "درس ۹: ماشه‌کشی و عملیات تکمیلی",
  "position": 309,
  "start": 112,
  "end": 114
 },
 {
  "title": "درس ۹: قلق‌گیری",
  "position": 310,
  "start": 114,
  "end": 115
 }
]$new$::jsonb)
 as p(title text,position integer,start integer,"end" integer)),
 fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v161:'||f.field||':10:final_exam:آمادگی دفاعی:فصل ۳: دفاع نظامی:'||p.position)::uuid,
 '1405',f.field,'10','final_exam','آمادگی دفاعی','فصل ۳: دفاع نظامی',p.title,p.start,p."end",p.position
from topics p cross join fields f on conflict (id) do nothing;
