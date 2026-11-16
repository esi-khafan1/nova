-- Writing 1–3, 1405: body headings and workshop exercises checked against printed pages.
-- Addition only; seed marker prevents restoration of later administrator deletions.
with installed as (insert into private.planner_seed_installations(seed_key) values ('writing-10-12-finer-1405-v228') on conflict do nothing returning seed_key),
books as (select * from jsonb_to_recordset($books$[
 {
  "grade": "10",
  "subject": "نگارش ۱",
  "topics": [
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — انتخاب و پرورش موضوع با پرسش‌سازی",
    "start": 14,
    "end": 15,
    "position": 1101
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — بارش فکری و پرسش‌های متنوع درباره موضوع",
    "start": 15,
    "end": 16,
    "position": 1102
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — اگرنویسی و گُزین‌گفته‌ها",
    "start": 16,
    "end": 17,
    "position": 1103
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — گسترش و سازماندهی موضوع",
    "start": 18,
    "end": 18,
    "position": 1104
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — کارگاه ۱: تشخیص شگردهای پرورش موضوع",
    "start": 19,
    "end": 19,
    "position": 1105
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — کارگاه ۲: پرسش‌سازی و تولید متن",
    "start": 20,
    "end": 21,
    "position": 1106
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — کارگاه ۳: ارزشیابی متن و پرسش‌ها",
    "start": 22,
    "end": 22,
    "position": 1107
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — هنجار نوشتار: کوتاه‌نویسی جمله",
    "start": 23,
    "end": 24,
    "position": 1108
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — حکایت‌نگاری: سگ و استخوان",
    "start": 25,
    "end": 25,
    "position": 1109
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — نوع نگاه نویسنده: عینی و ذهنی",
    "start": 28,
    "end": 29,
    "position": 1110
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — نمونه‌های نگاه عینی و ذهنی به مداد",
    "start": 29,
    "end": 32,
    "position": 1111
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — کارگاه ۱: تشخیص فضای عینی و ذهنی متن‌ها",
    "start": 33,
    "end": 35,
    "position": 1112
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — کارگاه ۲: نوشتن متن درباره موضوع انتخابی",
    "start": 36,
    "end": 36,
    "position": 1113
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — کارگاه ۳: ارزشیابی نوشتۀ دوستان",
    "start": 37,
    "end": 37,
    "position": 1114
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — هنجار نوشتار: واژه و بافت جمله",
    "start": 38,
    "end": 38,
    "position": 1115
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — مثل‌نویسی: انتخاب و گسترش مثل",
    "start": 39,
    "end": 39,
    "position": 1116
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — شناخت نوشته عینی و حواس پنج‌گانه",
    "start": 42,
    "end": 42,
    "position": 1117
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — مراحل نوشتۀ عینی: طرح و انتخاب پرسش‌ها",
    "start": 43,
    "end": 44,
    "position": 1118
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — پاسخ‌سازی و ساماندهی متن تلفن همراه",
    "start": 45,
    "end": 46,
    "position": 1119
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — کارگاه ۱ الف: انتخاب و سازماندهی پرسش‌های زعفران",
    "start": 47,
    "end": 48,
    "position": 1120
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — کارگاه ۱ ب: پرسش‌سازی برای متن کیک زرد",
    "start": 49,
    "end": 50,
    "position": 1121
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — کارگاه ۲: نگارش متن عینی",
    "start": 51,
    "end": 52,
    "position": 1122
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — کارگاه ۳: ارزشیابی متن عینی",
    "start": 53,
    "end": 53,
    "position": 1123
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — هنجار نوشتار: گزینش واژه و آهنگ و معنا",
    "start": 54,
    "end": 54,
    "position": 1124
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — شعرگردانی: ایستاده‌ام، ایستاده‌ای، ایستاده‌ایم",
    "start": 55,
    "end": 55,
    "position": 1125
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — گزارش‌نویسی و طرح پرسش‌های عینی",
    "start": 58,
    "end": 59,
    "position": 1126
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — چهارچوب گزارش و ترتیب جزئیات",
    "start": 60,
    "end": 61,
    "position": 1127
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — نمونه گزارش بازدید از دبیرستان",
    "start": 61,
    "end": 63,
    "position": 1128
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — کارگاه ۱: پرسش و سازماندهی گزارش موزۀ آذربایجان",
    "start": 64,
    "end": 65,
    "position": 1129
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — کارگاه ۲: نگارش گزارش",
    "start": 66,
    "end": 67,
    "position": 1130
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — کارگاه ۳: ارزشیابی گزارش",
    "start": 68,
    "end": 68,
    "position": 1131
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — هنجار نوشتار: واژه و فضای عینی و ذهنی",
    "start": 69,
    "end": 70,
    "position": 1132
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — حکایت‌نگاری: سخن گفتن و نادانی",
    "start": 71,
    "end": 71,
    "position": 1133
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — نوشته ذهنی و روش جانشین‌سازی",
    "start": 74,
    "end": 75,
    "position": 1134
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — نمونه جانشین‌سازی: آفتاب از نگاه یخ",
    "start": 76,
    "end": 76,
    "position": 1135
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — کارگاه ۱: تشخیص متن ذهنی و جانشین‌سازی",
    "start": 77,
    "end": 79,
    "position": 1136
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — کارگاه ۲: نوشتن متن با جانشین‌سازی",
    "start": 80,
    "end": 80,
    "position": 1137
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — کارگاه ۳: ارزشیابی نوشته",
    "start": 81,
    "end": 81,
    "position": 1138
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — هنجار نوشتار: پیوند جمله‌ها و انسجام",
    "start": 82,
    "end": 82,
    "position": 1139
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — مثل‌نویسی: انتخاب و گسترش مثل",
    "start": 83,
    "end": 83,
    "position": 1140
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — شناخت سنجش و مقایسه در نوشتۀ ذهنی",
    "start": 86,
    "end": 87,
    "position": 1141
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — ترسیم پیوندهای مقایسه‌ای موضوع",
    "start": 88,
    "end": 88,
    "position": 1142
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — نمونه‌های مقایسه: کتاب و آدم‌ها",
    "start": 89,
    "end": 90,
    "position": 1143
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — کارگاه ۱: تشخیص موضوعات مقایسه‌شده",
    "start": 91,
    "end": 93,
    "position": 1144
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — کارگاه ۲: نگارش متن با سنجش و مقایسه",
    "start": 94,
    "end": 94,
    "position": 1145
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — کارگاه ۳: ارزشیابی متن مقایسه‌ای",
    "start": 95,
    "end": 95,
    "position": 1146
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — هنجار نوشتار: ابزارهای انسجام و افزودن معنا",
    "start": 96,
    "end": 96,
    "position": 1147
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — شعرگردانی: کرم شب‌تاب",
    "start": 97,
    "end": 97,
    "position": 1148
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 7 — ناسازی معنایی و ترسیم پیوند مفاهیم",
    "start": 100,
    "end": 101,
    "position": 1149
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 7 — نمونه متن‌های تضاد مفاهیم",
    "start": 102,
    "end": 104,
    "position": 1150
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 7 — کارگاه ۱: ترسیم نمودار روابط مفاهیم",
    "start": 105,
    "end": 106,
    "position": 1151
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 7 — کارگاه ۲: نگارش متن با تضاد مفاهیم",
    "start": 107,
    "end": 107,
    "position": 1152
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 7 — کارگاه ۳: ارزشیابی نوشته",
    "start": 108,
    "end": 108,
    "position": 1153
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 7 — هنجار نوشتار: پیوندهای تقابل",
    "start": 109,
    "end": 109,
    "position": 1154
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 7 — حکایت‌نگاری: یونس و نجات از شکم ماهی",
    "start": 110,
    "end": 110,
    "position": 1155
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 8 — نوشتۀ داستان‌گونه و شخصیت و ماجرا",
    "start": 112,
    "end": 114,
    "position": 1156
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 8 — زمان و واژه‌های نشان‌دهندۀ رخداد",
    "start": 115,
    "end": 115,
    "position": 1157
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 8 — بیان داستان‌گونۀ خبر رسیدن بهار",
    "start": 116,
    "end": 116,
    "position": 1158
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 8 — کارگاه ۱: تشخیص عناصر داستان دو کوزه",
    "start": 117,
    "end": 118,
    "position": 1159
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 8 — کارگاه ۲: تعیین عناصر و نوشتن داستان",
    "start": 119,
    "end": 119,
    "position": 1160
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 8 — کارگاه ۳: ارزشیابی نوشتۀ داستان‌گونه",
    "start": 120,
    "end": 120,
    "position": 1161
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 8 — هنجار نوشتار: پیوندهای علّی",
    "start": 121,
    "end": 121,
    "position": 1162
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 8 — مثل‌نویسی: انتخاب و گسترش مثل",
    "start": 122,
    "end": 122,
    "position": 1163
   }
  ]
 },
 {
  "grade": "11",
  "subject": "نگارش ۲",
  "topics": [
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — نمونۀ توصیف کویر و اجزای نوشته",
    "start": 14,
    "end": 15,
    "position": 1101
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — ساختار بیرونی و درونی و محتوای نوشته",
    "start": 15,
    "end": 16,
    "position": 1102
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — پیش از نوشتن: انتخاب موضوع، بارش فکری و طرح",
    "start": 17,
    "end": 19,
    "position": 1103
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — نوشتن: بند آغازین، میانی و پایانی",
    "start": 20,
    "end": 21,
    "position": 1104
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — فعالیت ۱: انتخاب موضوع و تنظیم طرح",
    "start": 22,
    "end": 23,
    "position": 1105
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — فعالیت ۲: نگارش متن بر اساس طرح",
    "start": 24,
    "end": 25,
    "position": 1106
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — پس از نوشتن: بازبینی، اصلاح و ارزشیابی",
    "start": 26,
    "end": 28,
    "position": 1107
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — کارگاه ۱: شناسایی طرح اولیۀ متن",
    "start": 29,
    "end": 29,
    "position": 1108
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — کارگاه ۲: نوشتن با رعایت مراحل",
    "start": 30,
    "end": 30,
    "position": 1109
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — کارگاه ۳: ارزشیابی نوشته",
    "start": 31,
    "end": 31,
    "position": 1110
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — مثل‌نویسی: انتخاب و گسترش مثل",
    "start": 32,
    "end": 32,
    "position": 1111
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — توصیف زمان و مکان و جزئیات",
    "start": 36,
    "end": 37,
    "position": 1112
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — فعالیت ۱: انتخاب موضوع",
    "start": 38,
    "end": 38,
    "position": 1113
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — فعالیت ۲: بارش فکری موضوع",
    "start": 39,
    "end": 39,
    "position": 1114
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — سازماندهی و فعالیت ۳: طرح اولیه",
    "start": 40,
    "end": 41,
    "position": 1115
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — پیش‌نویس: بندهای سفر به کاشان",
    "start": 42,
    "end": 44,
    "position": 1116
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — بازبینی و گسترش و ارزشیابی متن",
    "start": 45,
    "end": 47,
    "position": 1117
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — کارگاه ۱: تحلیل زمان، مکان و حال و هوا",
    "start": 48,
    "end": 48,
    "position": 1118
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — کارگاه ۲: نگارش متن با مراحل نوشتن",
    "start": 49,
    "end": 49,
    "position": 1119
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — کارگاه ۳: ارزشیابی نوشته",
    "start": 50,
    "end": 50,
    "position": 1120
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — شعرگردانی: دیدار یار غایب",
    "start": 51,
    "end": 51,
    "position": 1121
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — توصیف شخصیت و ویژگی‌های رفتاری",
    "start": 54,
    "end": 55,
    "position": 1122
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — فعالیت ۱ و ۲: انتخاب و تجسم شخصیت",
    "start": 56,
    "end": 57,
    "position": 1123
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — فعالیت ۳: طرح اولیۀ نوشته",
    "start": 58,
    "end": 58,
    "position": 1124
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — پیش‌نویس شخصیت و فعالیت ۴",
    "start": 59,
    "end": 60,
    "position": 1125
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — بازبینی و ارزشیابی توصیف شخصیت",
    "start": 61,
    "end": 63,
    "position": 1126
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — کارگاه ۱: بررسی ویژگی‌های شخصیت‌ها",
    "start": 64,
    "end": 65,
    "position": 1127
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — کارگاه ۲: نگارش متن",
    "start": 66,
    "end": 66,
    "position": 1128
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — کارگاه ۳: ارزشیابی متن",
    "start": 67,
    "end": 67,
    "position": 1129
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — حکایت‌نگاری: طاووس و زاغ",
    "start": 68,
    "end": 68,
    "position": 1130
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — گفت‌وگو و نقش آن در معرفی شخصیت",
    "start": 72,
    "end": 73,
    "position": 1131
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — فعالیت ۱: انتخاب موضوع",
    "start": 74,
    "end": 74,
    "position": 1132
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — تجسم موضوع و فعالیت ۲: بارش فکری",
    "start": 75,
    "end": 76,
    "position": 1133
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — طرح اولیه و پیش‌نویس گفت‌وگو",
    "start": 77,
    "end": 78,
    "position": 1134
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — بازبینی و ارزشیابی گفت‌وگو",
    "start": 79,
    "end": 80,
    "position": 1135
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — کارگاه ۱: تشخیص موضوع و طرح گفت‌وگو",
    "start": 81,
    "end": 81,
    "position": 1136
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — کارگاه ۲ و ۳: نگارش و ارزشیابی گفت‌وگو",
    "start": 82,
    "end": 82,
    "position": 1137
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — مثل‌نویسی: انتخاب و گسترش مثل",
    "start": 83,
    "end": 83,
    "position": 1138
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — سفرنامه و نمونه‌های روایت سفر",
    "start": 86,
    "end": 89,
    "position": 1139
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — انتخاب سفر و فعالیت ۲: تجسم و بارش فکری",
    "start": 90,
    "end": 91,
    "position": 1140
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — سازماندهی و فعالیت ۳: طرح سفرنامه",
    "start": 92,
    "end": 93,
    "position": 1141
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — پیش‌نویس سفر به اصفهان",
    "start": 94,
    "end": 96,
    "position": 1142
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — بازبینی و ارزشیابی سفرنامه",
    "start": 97,
    "end": 99,
    "position": 1143
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — کارگاه ۱: مکان و موضوع و لحظه‌های سفرنامه",
    "start": 100,
    "end": 100,
    "position": 1144
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — کارگاه ۲: نگارش سفرنامه",
    "start": 101,
    "end": 101,
    "position": 1145
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — کارگاه ۳: ارزشیابی سفرنامه",
    "start": 102,
    "end": 102,
    "position": 1146
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — شعرگردانی: نسیم باد نوروزی",
    "start": 103,
    "end": 103,
    "position": 1147
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — مفهوم و نمونه خلاصه‌نویسی",
    "start": 106,
    "end": 108,
    "position": 1148
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — فعالیت ۱: خلاصه‌نویسی با حفظ زبان متن",
    "start": 109,
    "end": 111,
    "position": 1149
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — خلاصه‌نویسی آزاد به زبان خود",
    "start": 112,
    "end": 113,
    "position": 1150
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — فعالیت ۲: خلاصه‌نویسی متن",
    "start": 114,
    "end": 114,
    "position": 1151
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — یادداشت‌برداری: نمودار، جدول و نقشۀ مفهومی",
    "start": 115,
    "end": 117,
    "position": 1152
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — فعالیت ۳: خلاصه‌نویسی و دسته‌بندی",
    "start": 118,
    "end": 118,
    "position": 1153
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — ارزشیابی خلاصه",
    "start": 119,
    "end": 119,
    "position": 1154
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — کارگاه ۱: تشخیص شیوۀ خلاصه‌نویسی",
    "start": 120,
    "end": 121,
    "position": 1155
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — کارگاه ۲ و ۳: تولید و ارزشیابی خلاصه",
    "start": 122,
    "end": 122,
    "position": 1156
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — حکایت‌نگاری: پند پیر مربی",
    "start": 123,
    "end": 123,
    "position": 1157
   }
  ]
 },
 {
  "grade": "12",
  "subject": "نگارش ۳",
  "topics": [
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — نمونۀ خاطره و تعریف خاطره‌نگاری",
    "start": 12,
    "end": 14,
    "position": 1101
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — راوی و زاویۀ دید و فضاسازی خاطره",
    "start": 14,
    "end": 15,
    "position": 1102
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — آغاز خاطره با زمان، مکان یا رویداد",
    "start": 16,
    "end": 18,
    "position": 1103
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — تفاوت خاطره گفتاری و نوشتاری و نمونۀ آن",
    "start": 19,
    "end": 20,
    "position": 1104
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — کاربرد خاطره‌نگاری و نمونه کتاب‌ها",
    "start": 20,
    "end": 22,
    "position": 1105
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — کارگاه ۱: تحلیل خاطره از کتاب روزها",
    "start": 23,
    "end": 23,
    "position": 1106
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — کارگاه ۲: نگارش خاطره شخصی",
    "start": 24,
    "end": 25,
    "position": 1107
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — کارگاه ۳: ارزشیابی خاطره",
    "start": 26,
    "end": 26,
    "position": 1108
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — مثل‌نویسی: انتخاب و گسترش مثل",
    "start": 27,
    "end": 27,
    "position": 1109
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — نثر زبانی و نثر ادبی و نقش خیال و احساس",
    "start": 30,
    "end": 31,
    "position": 1110
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — تبدیل جملۀ زبانی و گزینش واژه در نثر ادبی",
    "start": 32,
    "end": 33,
    "position": 1111
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — کاربرد نثر ادبی در پیام و نوشته‌های روزمره",
    "start": 34,
    "end": 36,
    "position": 1112
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — کارگاه ۱: بررسی خیال، احساس و واژه",
    "start": 37,
    "end": 37,
    "position": 1113
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — کارگاه ۲: نوشتن متن ادبی صبح برفی",
    "start": 38,
    "end": 39,
    "position": 1114
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — کارگاه ۳: ارزشیابی متن ادبی",
    "start": 40,
    "end": 40,
    "position": 1115
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — شعرگردانی: عشق شوری در نهاد ما نهاد",
    "start": 41,
    "end": 41,
    "position": 1116
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — نثر زبانی و قطعۀ ادبی و مشاهدات",
    "start": 44,
    "end": 45,
    "position": 1117
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — نمونۀ قطعۀ ادبی و تأمل در متن",
    "start": 46,
    "end": 47,
    "position": 1118
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — ویژگی‌های قطعۀ ادبی: نگاه تازه و آرایه",
    "start": 48,
    "end": 50,
    "position": 1119
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — کارگاه ۱: تحلیل قطعۀ ادبی نماز",
    "start": 51,
    "end": 53,
    "position": 1120
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — کارگاه ۲: نگارش قطعۀ ادبی",
    "start": 54,
    "end": 55,
    "position": 1121
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — کارگاه ۳: ارزشیابی قطعۀ ادبی",
    "start": 56,
    "end": 56,
    "position": 1122
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — حکایت‌نگاری: اعرابی و جوهریان بصره",
    "start": 57,
    "end": 57,
    "position": 1123
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — مفهوم نامه و شیوه‌های انتقال پیام",
    "start": 60,
    "end": 62,
    "position": 1124
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — اجزای ظاهری نامه و نامه اداری",
    "start": 63,
    "end": 64,
    "position": 1125
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — نمونه و زبان نامۀ اداری",
    "start": 65,
    "end": 66,
    "position": 1126
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — نامه‌های رسمی",
    "start": 67,
    "end": 67,
    "position": 1127
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — نامه خصوصی و دوستانه و تفاوت با اداری",
    "start": 68,
    "end": 70,
    "position": 1128
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — نامۀ سرگشاده و مخاطب عام",
    "start": 71,
    "end": 71,
    "position": 1129
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — کارگاه ۱: بررسی ساختار نامۀ اداری",
    "start": 72,
    "end": 72,
    "position": 1130
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — کارگاه ۲: نگارش نامه",
    "start": 73,
    "end": 74,
    "position": 1131
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — کارگاه ۳: ارزشیابی نامه",
    "start": 75,
    "end": 75,
    "position": 1132
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — شعرگردانی: یار بیار",
    "start": 76,
    "end": 76,
    "position": 1133
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — مقالۀ تحقیقی و نمونۀ یادگیری معنادار",
    "start": 80,
    "end": 83,
    "position": 1134
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — ساختار مقاله: عنوان",
    "start": 84,
    "end": 84,
    "position": 1135
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — مقدمه: زمینۀ مسئله و بیان مسئله",
    "start": 85,
    "end": 86,
    "position": 1136
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — بدنۀ اصلی و بحث و نتیجه‌گیری مقاله",
    "start": 87,
    "end": 88,
    "position": 1137
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — کارگاه ۱: تحلیل مقاله‌های تحقیقی",
    "start": 89,
    "end": 89,
    "position": 1138
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — کارگاه ۲: نگارش مقالۀ تحقیقی",
    "start": 90,
    "end": 91,
    "position": 1139
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — کارگاه ۳: ارزشیابی مقاله",
    "start": 92,
    "end": 92,
    "position": 1140
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 5 — مثل‌نویسی: انتخاب و گسترش مثل",
    "start": 93,
    "end": 93,
    "position": 1141
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — فهرست منابع و ترتیب اطلاعات منابع",
    "start": 96,
    "end": 97,
    "position": 1142
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — نام نویسنده و آغاز مقاله",
    "start": 98,
    "end": 98,
    "position": 1143
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — چکیده: هدف، روش، یافته‌ها و نتیجه",
    "start": 98,
    "end": 99,
    "position": 1144
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — کلیدواژه‌ها و فعالیت مقالۀ سنگی زیر آب",
    "start": 100,
    "end": 100,
    "position": 1145
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — کارگاه ۱: مقایسۀ فهرست منابع کتاب‌ها",
    "start": 101,
    "end": 101,
    "position": 1146
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — کارگاه ۲: نوشتن چکیده، کلیدواژه و منابع",
    "start": 102,
    "end": 102,
    "position": 1147
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — کارگاه ۳: ارزشیابی مقاله",
    "start": 103,
    "end": 103,
    "position": 1148
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 6 — حکایت‌نگاری: سوداگر و باج‌گیر",
    "start": 104,
    "end": 104,
    "position": 1149
   },
   {
    "chapter": "درس‌ها",
    "title": "پیوست — نیایش",
    "start": 105,
    "end": 105,
    "position": 1150
   },
   {
    "chapter": "درس‌ها",
    "title": "پیوست — نمونۀ خاطره: دفاع مقدس",
    "start": 108,
    "end": 109,
    "position": 1151
   },
   {
    "chapter": "درس‌ها",
    "title": "پیوست — نمونۀ خاطره: روزها",
    "start": 109,
    "end": 110,
    "position": 1152
   },
   {
    "chapter": "درس‌ها",
    "title": "پیوست — نمونۀ خاطره: خاطرات سرآرتور هاردینگ",
    "start": 110,
    "end": 111,
    "position": 1153
   },
   {
    "chapter": "درس‌ها",
    "title": "پیوست — نمونۀ نثر ادبی: خون خورشید",
    "start": 111,
    "end": 112,
    "position": 1154
   },
   {
    "chapter": "درس‌ها",
    "title": "پیوست — نمونۀ قطعۀ ادبی: عشق خیلی تنهاست",
    "start": 113,
    "end": 113,
    "position": 1155
   },
   {
    "chapter": "درس‌ها",
    "title": "پیوست — نمونۀ نامۀ سرگشاده",
    "start": 114,
    "end": 116,
    "position": 1156
   },
   {
    "chapter": "درس‌ها",
    "title": "پیوست — نمونۀ نامۀ اخلاقی و عرفانی",
    "start": 117,
    "end": 117,
    "position": 1157
   },
   {
    "chapter": "درس‌ها",
    "title": "پیوست — نمونۀ نامۀ امام موسی صدر",
    "start": 118,
    "end": 121,
    "position": 1158
   },
   {
    "chapter": "درس‌ها",
    "title": "پیوست — نمونۀ مقالۀ سنگی زیر آب",
    "start": 122,
    "end": 125,
    "position": 1159
   }
  ]
 }
]$books$::jsonb) as b(grade text,subject text,topics jsonb)),
topics as (select b.grade,b.subject,p.* from books b cross join lateral jsonb_to_recordset(b.topics) as p(chapter text,title text,start integer,"end" integer,position integer)),
fields as (select unnest(array['mathematics','experimental_sciences','humanities']) as field)
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v228:'||f.field||':'||p.grade||':final_exam:'||p.subject||':'||p.chapter||':'||p.position)::uuid,
'1405',f.field,p.grade,'final_exam',p.subject,p.chapter,p.title,p.start,p."end",p.position
from topics p cross join fields f cross join installed on conflict(id) do nothing;
