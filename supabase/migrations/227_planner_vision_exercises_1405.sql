-- Vision 1-3 (1405), printed-page exercise subdivisions; preserve all preexisting rows.
-- One-time installation means later administrator edits/deletes are not undone by rerun.
with installed as (insert into private.planner_seed_installations(seed_key) values ('vision-exercises-1405-v227') on conflict do nothing returning seed_key),
books as (select * from jsonb_to_recordset($books$[
 {
  "grade": "10",
  "subject": "زبان خارجی ۱",
  "topics": [
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Get Ready — A: تصاویر و عبارت‌های مراقبت از طبیعت",
    "start": 17,
    "end": 17,
    "position": 1001
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Get Ready — B: رفتارهای مفید و زیان‌بار برای طبیعت",
    "start": 17,
    "end": 17,
    "position": 1002
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Get Ready — A: تصاویر و نام جانوران",
    "start": 18,
    "end": 18,
    "position": 1003
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Get Ready — B: دسته‌بندی جانوران",
    "start": 18,
    "end": 18,
    "position": 1004
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary — A: واژه‌های جانوران و طبیعت در مثال‌ها",
    "start": 20,
    "end": 21,
    "position": 1005
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary — B: تمرین واژگان",
    "start": 21,
    "end": 21,
    "position": 1006
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary — C: ارجاع به تمرین‌های کتاب کار",
    "start": 21,
    "end": 21,
    "position": 1007
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Reading — A: انتخاب پاسخ درباره جانوران در خطر",
    "start": 23,
    "end": 23,
    "position": 1008
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Reading — B: درست و نادرست",
    "start": 23,
    "end": 23,
    "position": 1009
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Reading — C: وصل کردن دو نیمه جمله",
    "start": 23,
    "end": 23,
    "position": 1010
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — A: خواندن متن‌های زمان آینده",
    "start": 24,
    "end": 24,
    "position": 1011
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — B: مثال‌های زمان آینده",
    "start": 25,
    "end": 25,
    "position": 1012
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — C: ساخت آینده ساده",
    "start": 26,
    "end": 26,
    "position": 1013
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — D: یافتن فعل‌های آینده در متن درس",
    "start": 26,
    "end": 26,
    "position": 1014
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — E: انتخاب شکل درست فعل در متن",
    "start": 26,
    "end": 26,
    "position": 1015
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — F: پرسش‌های آینده با واژه‌های پرسشی",
    "start": 27,
    "end": 27,
    "position": 1016
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — G: جمله‌سازی و پرسش درباره آینده",
    "start": 28,
    "end": 28,
    "position": 1017
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — H: ارجاع به تمرین‌های کتاب کار",
    "start": 28,
    "end": 28,
    "position": 1018
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — See Also — A: مثال‌های be going to",
    "start": 29,
    "end": 29,
    "position": 1019
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — See Also — B: ارجاع به کتاب کار",
    "start": 29,
    "end": 29,
    "position": 1020
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Listening — A: گفت‌وگو درباره برنامه‌ها",
    "start": 30,
    "end": 30,
    "position": 1021
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Listening — B: شنیدن مکالمه و تکمیل جمله‌ها",
    "start": 31,
    "end": 31,
    "position": 1022
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Pronunciation — A: آهنگ افتان جمله",
    "start": 32,
    "end": 32,
    "position": 1023
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Pronunciation — B: تشخیص پایان جمله با شنیدن",
    "start": 33,
    "end": 33,
    "position": 1024
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Pronunciation — C: ارجاع به کتاب کار",
    "start": 33,
    "end": 33,
    "position": 1025
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — A: دسته‌بندی اسم‌های متن",
    "start": 36,
    "end": 36,
    "position": 1026
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — B: شکل مفرد و جمع اسم‌ها",
    "start": 37,
    "end": 37,
    "position": 1027
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — C: اسم خاص و عام و حروف بزرگ",
    "start": 38,
    "end": 38,
    "position": 1028
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — D: یافتن اسم‌ها در جمله",
    "start": 39,
    "end": 39,
    "position": 1029
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — What You Learned — A: گزارش شنیداری زمین و فعل‌ها و اسم‌ها",
    "start": 41,
    "end": 41,
    "position": 1030
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — What You Learned — B: خواندن ادامه گزارش",
    "start": 41,
    "end": 41,
    "position": 1031
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — What You Learned — C: پرسش و پاسخ دونفره",
    "start": 41,
    "end": 41,
    "position": 1032
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Get Ready — A: تطبیق تصویر و جمله",
    "start": 45,
    "end": 45,
    "position": 1033
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Get Ready — B: مرتب کردن موضوع‌ها بر اساس علاقه",
    "start": 45,
    "end": 45,
    "position": 1034
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Get Ready — A: تطبیق تصویر و واژه",
    "start": 46,
    "end": 46,
    "position": 1035
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Get Ready — B: دسته‌بندی واژه‌ها",
    "start": 46,
    "end": 46,
    "position": 1036
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary — A: خواندن و تمرین واژگان",
    "start": 48,
    "end": 49,
    "position": 1037
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary — B: تمرین واژگان",
    "start": 49,
    "end": 49,
    "position": 1038
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary — C: ارجاع به کتاب کار",
    "start": 49,
    "end": 49,
    "position": 1039
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Reading — A: انتخاب پاسخ درباره متن خون",
    "start": 51,
    "end": 51,
    "position": 1040
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Reading — B: درست و نادرست",
    "start": 51,
    "end": 51,
    "position": 1041
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Reading — C: وصل کردن دو نیمه جمله",
    "start": 51,
    "end": 51,
    "position": 1042
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — A: خواندن متن درباره ویژگی‌ها",
    "start": 52,
    "end": 52,
    "position": 1043
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — B: مثال‌های صفت",
    "start": 53,
    "end": 53,
    "position": 1044
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — C: کاربرد صفت در جمله",
    "start": 54,
    "end": 54,
    "position": 1045
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — D: یافتن صفت‌های مکالمه",
    "start": 54,
    "end": 54,
    "position": 1046
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — E: انتخاب جمله متناسب با تصویر",
    "start": 55,
    "end": 55,
    "position": 1047
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — F: تمرین دونفره صفت‌ها",
    "start": 56,
    "end": 56,
    "position": 1048
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — G: ارجاع به کتاب کار",
    "start": 56,
    "end": 56,
    "position": 1049
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — See Also — A: صفت‌های مقایسه‌ای و عالی",
    "start": 57,
    "end": 57,
    "position": 1050
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — See Also — B: ارجاع به کتاب کار",
    "start": 57,
    "end": 57,
    "position": 1051
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Listening — A: پرسش درباره جزئیات با صفت",
    "start": 58,
    "end": 58,
    "position": 1052
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Listening — B: شنیدن مکالمه و تکمیل جمله",
    "start": 59,
    "end": 59,
    "position": 1053
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Pronunciation — A: آهنگ خیزان پرسش",
    "start": 60,
    "end": 60,
    "position": 1054
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Pronunciation — B: ارجاع به کتاب کار",
    "start": 60,
    "end": 60,
    "position": 1055
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Pronunciation — C: آهنگ خیزان و افتان در مکالمه",
    "start": 61,
    "end": 61,
    "position": 1056
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — A: یافتن صفت‌ها در متن درس",
    "start": 64,
    "end": 64,
    "position": 1057
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — B: تکمیل جمله با صفت مناسب",
    "start": 65,
    "end": 65,
    "position": 1058
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — C: ساخت شکل مقایسه‌ای و عالی",
    "start": 67,
    "end": 67,
    "position": 1059
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — D: تکمیل جمله با صفت مقایسه‌ای یا عالی",
    "start": 67,
    "end": 67,
    "position": 1060
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — What You Learned — A: شنیدن نکته‌هایی درباره مغز",
    "start": 69,
    "end": 69,
    "position": 1061
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — What You Learned — B: خواندن نکته‌های دیگر درباره مغز",
    "start": 69,
    "end": 69,
    "position": 1062
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — What You Learned — C: پرسش و پاسخ دونفره",
    "start": 69,
    "end": 69,
    "position": 1063
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Get Ready — A: تطبیق تصویر و جمله",
    "start": 73,
    "end": 73,
    "position": 1064
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Get Ready — B: مرتب کردن اختراع‌ها از قدیم به جدید",
    "start": 74,
    "end": 74,
    "position": 1065
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Get Ready — A: تطبیق تصویر و واژه",
    "start": 75,
    "end": 75,
    "position": 1066
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Get Ready — B: انتخاب صفت برای واژه‌ها",
    "start": 75,
    "end": 75,
    "position": 1067
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary — A: واژه‌ها و مثال‌ها",
    "start": 77,
    "end": 79,
    "position": 1068
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary — B: تمرین واژگان",
    "start": 79,
    "end": 79,
    "position": 1069
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary — C: ارجاع به کتاب کار",
    "start": 79,
    "end": 79,
    "position": 1070
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Reading — A: انتخاب پاسخ درباره متن درس",
    "start": 81,
    "end": 81,
    "position": 1071
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Reading — B: درست و نادرست",
    "start": 81,
    "end": 81,
    "position": 1072
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Reading — C: وصل کردن دو نیمه جمله",
    "start": 81,
    "end": 81,
    "position": 1073
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — A: خواندن متن‌های گذشته استمراری",
    "start": 82,
    "end": 82,
    "position": 1074
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — B: مثال‌های گذشته استمراری",
    "start": 83,
    "end": 83,
    "position": 1075
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — C: ساخت گذشته استمراری",
    "start": 84,
    "end": 84,
    "position": 1076
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — D: یافتن گذشته استمراری در مکالمه",
    "start": 84,
    "end": 84,
    "position": 1077
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — E: انتخاب شکل درست فعل",
    "start": 85,
    "end": 85,
    "position": 1078
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — F: گفت‌وگوی دونفره درباره کارهای گذشته",
    "start": 85,
    "end": 85,
    "position": 1079
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — G: ارجاع به کتاب کار",
    "start": 85,
    "end": 85,
    "position": 1080
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — See Also — A: ضمیرهای انعکاسی",
    "start": 86,
    "end": 86,
    "position": 1081
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — See Also — B: ارجاع به کتاب کار",
    "start": 86,
    "end": 86,
    "position": 1082
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Listening — A: روایت با گذشته ساده و استمراری",
    "start": 87,
    "end": 87,
    "position": 1083
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Listening — B: شنیدن مکالمه و تکمیل جمله",
    "start": 88,
    "end": 88,
    "position": 1084
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Pronunciation — A: تکیه تأکیدی در جمله",
    "start": 89,
    "end": 89,
    "position": 1085
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Pronunciation — B: خواندن جمله با تکیه تأکیدی",
    "start": 90,
    "end": 90,
    "position": 1086
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Pronunciation — C: ارجاع به کتاب کار",
    "start": 90,
    "end": 90,
    "position": 1087
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — A: یافتن فعل‌های کنشی و حالتی",
    "start": 92,
    "end": 92,
    "position": 1088
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — B: انتخاب شکل ساده یا استمراری فعل",
    "start": 93,
    "end": 93,
    "position": 1089
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — What You Learned — A: شنیدن بخش اول داستان",
    "start": 95,
    "end": 95,
    "position": 1090
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — What You Learned — B: شنیدن ادامه داستان",
    "start": 95,
    "end": 95,
    "position": 1091
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — What You Learned — C: پرسش و پاسخ دونفره",
    "start": 95,
    "end": 95,
    "position": 1092
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Get Ready — A: تطبیق تصویر و جمله",
    "start": 99,
    "end": 99,
    "position": 1093
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Get Ready — B: انتخاب مکان سفر",
    "start": 100,
    "end": 100,
    "position": 1094
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Get Ready — A: تطبیق تصویر و واژه",
    "start": 101,
    "end": 101,
    "position": 1095
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Get Ready — B: تکمیل جمله با واژه‌ها",
    "start": 101,
    "end": 101,
    "position": 1096
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Vocabulary — A: خواندن و تمرین واژه‌ها",
    "start": 103,
    "end": 104,
    "position": 1097
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Vocabulary — B: تمرین واژگان",
    "start": 104,
    "end": 104,
    "position": 1098
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Vocabulary — C: ارجاع به کتاب کار",
    "start": 104,
    "end": 104,
    "position": 1099
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Reading — A: انتخاب پاسخ درباره متن سفر در ایران",
    "start": 106,
    "end": 106,
    "position": 1100
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Reading — B: درست و نادرست",
    "start": 106,
    "end": 106,
    "position": 1101
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Reading — C: وصل کردن دو نیمه جمله",
    "start": 106,
    "end": 106,
    "position": 1102
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Grammar — A: خواندن متن‌های افعال وجهی",
    "start": 107,
    "end": 107,
    "position": 1103
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Grammar — B: مثال‌های افعال وجهی",
    "start": 108,
    "end": 108,
    "position": 1104
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Grammar — C: کاربرد can و may و must و should",
    "start": 109,
    "end": 109,
    "position": 1105
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Grammar — D: یافتن افعال وجهی مکالمه",
    "start": 109,
    "end": 109,
    "position": 1106
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Grammar — E: تکمیل جمله با فعل وجهی",
    "start": 109,
    "end": 109,
    "position": 1107
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Grammar — F: پرسش و پاسخ دونفره",
    "start": 109,
    "end": 109,
    "position": 1108
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Grammar — G: ارجاع به کتاب کار",
    "start": 109,
    "end": 109,
    "position": 1109
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — See Also — A: حروف اضافه در مثال‌ها",
    "start": 110,
    "end": 111,
    "position": 1110
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — See Also — B: ارجاع به کتاب کار",
    "start": 111,
    "end": 111,
    "position": 1111
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Listening — A: گفت‌وگو درباره الزام و ضرورت",
    "start": 112,
    "end": 112,
    "position": 1112
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Listening — B: شنیدن مکالمه و تکمیل جمله",
    "start": 113,
    "end": 113,
    "position": 1113
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Pronunciation — A: تکیه تقابلی در جمله",
    "start": 114,
    "end": 114,
    "position": 1114
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Pronunciation — B: یافتن کلمات دارای تکیه تقابلی",
    "start": 114,
    "end": 114,
    "position": 1115
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Pronunciation — C: ارجاع به کتاب کار",
    "start": 114,
    "end": 114,
    "position": 1116
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Writing — A: تشخیص فعل و قید در جمله",
    "start": 115,
    "end": 115,
    "position": 1117
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Writing — B: ساخت قید از صفت",
    "start": 116,
    "end": 116,
    "position": 1118
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — Writing — A: تکمیل جمله با شکل درست قید",
    "start": 117,
    "end": 117,
    "position": 1119
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — What You Learned — A: شنیدن برنامه سفر",
    "start": 119,
    "end": 119,
    "position": 1120
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — What You Learned — B: خواندن ادامه برنامه",
    "start": 119,
    "end": 119,
    "position": 1121
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 4 — What You Learned — C: پرسش و پاسخ دونفره",
    "start": 119,
    "end": 119,
    "position": 1122
   }
  ]
 },
 {
  "grade": "11",
  "subject": "زبان خارجی ۲",
  "topics": [
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Get Ready — A: کشورها و زبان‌ها روی نقشه",
    "start": 17,
    "end": 17,
    "position": 1001
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Get Ready — B: تطبیق نشانه‌ها و معنی آن‌ها",
    "start": 18,
    "end": 18,
    "position": 1002
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Get Ready — C: فراوانی فعالیت‌های یادگیری زبان",
    "start": 18,
    "end": 18,
    "position": 1003
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary — A: خواندن و تمرین واژه‌ها",
    "start": 21,
    "end": 23,
    "position": 1004
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary — B: تمرین واژگان",
    "start": 23,
    "end": 23,
    "position": 1005
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary — C: ارجاع به کتاب کار",
    "start": 23,
    "end": 23,
    "position": 1006
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Reading — A: یافتن اعداد در متن",
    "start": 26,
    "end": 26,
    "position": 1007
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Reading — B: یافتن اسم‌های خاص",
    "start": 26,
    "end": 26,
    "position": 1008
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Reading — C: پرسش‌های متن زبان‌های جهان",
    "start": 26,
    "end": 26,
    "position": 1009
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Reading — D: درست و نادرست",
    "start": 26,
    "end": 26,
    "position": 1010
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary Development — A: واژه‌های هم‌معنی و تصویر",
    "start": 27,
    "end": 27,
    "position": 1011
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary Development — B: یافتن مترادف‌ها",
    "start": 27,
    "end": 27,
    "position": 1012
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary Development — C: یافتن مترادف در متن درس",
    "start": 27,
    "end": 27,
    "position": 1013
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — A: خواندن متن‌های اسم قابل‌شمارش و غیرقابل‌شمارش",
    "start": 28,
    "end": 28,
    "position": 1014
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — B: مقایسه مثال‌های اسم‌ها",
    "start": 29,
    "end": 30,
    "position": 1015
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — C: تفاوت اسم قابل‌شمارش و غیرقابل‌شمارش",
    "start": 31,
    "end": 31,
    "position": 1016
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — D: یافتن اسم‌ها در متن درس",
    "start": 31,
    "end": 31,
    "position": 1017
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — E: انتخاب واژه مناسب",
    "start": 31,
    "end": 31,
    "position": 1018
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — F: پرسش و پاسخ how much و how many",
    "start": 31,
    "end": 31,
    "position": 1019
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — G: ارجاع به کتاب کار",
    "start": 31,
    "end": 31,
    "position": 1020
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — See Also — A: کاربرد عدد پیش از اسم",
    "start": 32,
    "end": 32,
    "position": 1021
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — See Also — B: کاربرد عدد در مثال‌ها",
    "start": 33,
    "end": 33,
    "position": 1022
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Listening — A: پرسیدن قیمت",
    "start": 34,
    "end": 34,
    "position": 1023
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Listening — B: شنیدن مکالمه و پاسخ به پرسش‌ها",
    "start": 35,
    "end": 35,
    "position": 1024
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Pronunciation — A: تکیه اعداد دهگان",
    "start": 36,
    "end": 36,
    "position": 1025
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Pronunciation — B: تکیه اعداد teen",
    "start": 36,
    "end": 36,
    "position": 1026
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — A: تشخیص جمله و بازنویسی",
    "start": 40,
    "end": 40,
    "position": 1027
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — B: تکمیل نهاد جمله",
    "start": 41,
    "end": 41,
    "position": 1028
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — C: تکمیل فعل جمله",
    "start": 41,
    "end": 41,
    "position": 1029
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — D: تشخیص مفعول",
    "start": 43,
    "end": 43,
    "position": 1030
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — E: تکمیل مفعول جمله",
    "start": 43,
    "end": 43,
    "position": 1031
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — F: مرتب کردن واژه‌های جمله",
    "start": 44,
    "end": 44,
    "position": 1032
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — G: تشخیص نهاد فعل مفعول و اطلاعات تکمیلی",
    "start": 45,
    "end": 45,
    "position": 1033
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — H: نوشتن جمله‌های ساده در زمان‌های مختلف",
    "start": 45,
    "end": 45,
    "position": 1034
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — What You Learned — A: شنیدن بخش اول داستان",
    "start": 47,
    "end": 47,
    "position": 1035
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — What You Learned — B: خواندن ادامه داستان",
    "start": 47,
    "end": 47,
    "position": 1036
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — What You Learned — C: پرسش و پاسخ دونفره",
    "start": 47,
    "end": 47,
    "position": 1037
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Get Ready — A: تشخیص عادت‌های افراد در تصویر",
    "start": 51,
    "end": 51,
    "position": 1038
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Get Ready — B: هرم غذایی و خوراک روزانه",
    "start": 52,
    "end": 52,
    "position": 1039
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Get Ready — C: قیدهای تکرار برای عادت‌ها",
    "start": 52,
    "end": 52,
    "position": 1040
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary — A: خواندن و تمرین واژه‌ها",
    "start": 55,
    "end": 57,
    "position": 1041
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary — B: تمرین واژگان",
    "start": 57,
    "end": 57,
    "position": 1042
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary — C: ارجاع به کتاب کار",
    "start": 57,
    "end": 57,
    "position": 1043
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Reading — A: یافتن نظرها در متن سلامت",
    "start": 60,
    "end": 60,
    "position": 1044
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Reading — B: یافتن ایده اصلی",
    "start": 60,
    "end": 60,
    "position": 1045
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Reading — C: یافتن اطلاعات متن",
    "start": 60,
    "end": 60,
    "position": 1046
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary Development — A: شناسایی پیشوندها",
    "start": 63,
    "end": 63,
    "position": 1047
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary Development — B: شناسایی پسوندها",
    "start": 63,
    "end": 63,
    "position": 1048
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary Development — C: یافتن پسوند در متن",
    "start": 63,
    "end": 63,
    "position": 1049
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary Development — D: یافتن صفت‌های اسم‌ها",
    "start": 63,
    "end": 63,
    "position": 1050
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — A: خواندن متن زمان حال کامل",
    "start": 64,
    "end": 64,
    "position": 1051
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — B: مثال‌های زمان حال کامل",
    "start": 65,
    "end": 65,
    "position": 1052
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — C: ساخت زمان حال کامل",
    "start": 66,
    "end": 66,
    "position": 1053
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — D: یافتن حال کامل در مکالمه",
    "start": 66,
    "end": 66,
    "position": 1054
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — E: انتخاب شکل درست فعل",
    "start": 66,
    "end": 66,
    "position": 1055
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — F: مثال‌ها و جمله‌های حال کامل",
    "start": 67,
    "end": 67,
    "position": 1056
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — G: گفت‌وگوی دونفره درباره تجربه‌ها",
    "start": 67,
    "end": 67,
    "position": 1057
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — H: ارجاع به کتاب کار",
    "start": 67,
    "end": 67,
    "position": 1058
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Listening — A: گفت‌وگو درباره تجربه گذشته",
    "start": 69,
    "end": 69,
    "position": 1059
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Listening — B: شنیدن مکالمه و تکمیل جای خالی",
    "start": 70,
    "end": 70,
    "position": 1060
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Pronunciation — A: تکیه در افعال عبارتی",
    "start": 71,
    "end": 71,
    "position": 1061
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Pronunciation — B: گفتن جمله با تکیه مناسب",
    "start": 71,
    "end": 71,
    "position": 1062
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — A: ساخت مصدر ing و تکمیل جمله",
    "start": 73,
    "end": 73,
    "position": 1063
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — B: ساخت مصدر ing پس از فعل",
    "start": 75,
    "end": 75,
    "position": 1064
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — C: جمله‌سازی با مصدر ing",
    "start": 75,
    "end": 75,
    "position": 1065
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — D: تشخیص کارکرد شکل ing",
    "start": 76,
    "end": 76,
    "position": 1066
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — E: یافتن مصدر ing در مکالمه",
    "start": 77,
    "end": 77,
    "position": 1067
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — What You Learned — A: شنیدن بخش اول گزارش",
    "start": 79,
    "end": 79,
    "position": 1068
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — What You Learned — B: خواندن ادامه گزارش",
    "start": 79,
    "end": 79,
    "position": 1069
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — What You Learned — C: پرسش و پاسخ دونفره",
    "start": 79,
    "end": 79,
    "position": 1070
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Get Ready — A: هنرهای دستی روی نقشه ایران",
    "start": 83,
    "end": 83,
    "position": 1071
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Get Ready — B: تکمیل جمله با نام هنرها",
    "start": 84,
    "end": 84,
    "position": 1072
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Get Ready — C: احساس هنگام دیدن اثر هنری",
    "start": 84,
    "end": 84,
    "position": 1073
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary — A: خواندن و تمرین واژه‌ها",
    "start": 87,
    "end": 89,
    "position": 1074
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary — B: تمرین واژگان",
    "start": 89,
    "end": 89,
    "position": 1075
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary — C: ارجاع به کتاب کار",
    "start": 89,
    "end": 89,
    "position": 1076
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Reading — A: تشخیص مرجع ضمیرهای متن",
    "start": 92,
    "end": 92,
    "position": 1077
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Reading — B: یافتن اطلاعات متن هنر و فرهنگ",
    "start": 92,
    "end": 92,
    "position": 1078
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Reading — C: یافتن ایده‌ها در متن",
    "start": 92,
    "end": 92,
    "position": 1079
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary Development — A: نوشتن واژه متضاد",
    "start": 93,
    "end": 93,
    "position": 1080
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary Development — B: تشخیص دو واژه متضاد",
    "start": 94,
    "end": 94,
    "position": 1081
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary Development — C: یافتن مترادف و متضاد در متن",
    "start": 94,
    "end": 94,
    "position": 1082
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — A: خواندن متن شرطی",
    "start": 95,
    "end": 95,
    "position": 1083
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — B: مثال‌های شرطی نوع اول",
    "start": 96,
    "end": 96,
    "position": 1084
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — C: ساخت جمله شرطی",
    "start": 96,
    "end": 96,
    "position": 1085
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — D: یافتن جمله شرطی در مکالمه",
    "start": 96,
    "end": 96,
    "position": 1086
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — E: انتخاب شکل درست فعل",
    "start": 97,
    "end": 97,
    "position": 1087
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — F: گفت‌وگو درباره شرط و نتیجه آینده",
    "start": 97,
    "end": 97,
    "position": 1088
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — G: ارجاع به کتاب کار",
    "start": 97,
    "end": 97,
    "position": 1089
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Listening — A: گفت‌وگو درباره شرط و نتیجه",
    "start": 99,
    "end": 99,
    "position": 1090
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Listening — B: شنیدن مکالمه و تکمیل جمله",
    "start": 100,
    "end": 100,
    "position": 1091
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Pronunciation — A: آهنگ جمله شرطی",
    "start": 101,
    "end": 101,
    "position": 1092
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Pronunciation — B: تشخیص آهنگ خیزان و افتان",
    "start": 101,
    "end": 101,
    "position": 1093
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — A: تکمیل جمله با مصدر ing یا infinitive",
    "start": 103,
    "end": 103,
    "position": 1094
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — B: جمله‌سازی با صفت و infinitive",
    "start": 105,
    "end": 105,
    "position": 1095
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — C: یافتن مصدرها در متن درس",
    "start": 105,
    "end": 105,
    "position": 1096
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — What You Learned — A: شنیدن بخش اول گزارش",
    "start": 107,
    "end": 107,
    "position": 1097
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — What You Learned — B: خواندن ادامه گزارش",
    "start": 107,
    "end": 107,
    "position": 1098
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — What You Learned — C: پرسش و پاسخ دونفره",
    "start": 107,
    "end": 107,
    "position": 1099
   }
  ]
 },
 {
  "grade": "12",
  "subject": "زبان خارجی ۳",
  "topics": [
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Get Ready — A: تطبیق تصویر و جمله درباره احترام و کمک",
    "start": 17,
    "end": 17,
    "position": 1001
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Get Ready — B: افراد فداکار و علت شهرت آن‌ها",
    "start": 18,
    "end": 18,
    "position": 1002
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Get Ready — C: صفت‌ها و اسم‌های مناسب",
    "start": 18,
    "end": 18,
    "position": 1003
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary — A: خواندن و تمرین واژه‌ها",
    "start": 21,
    "end": 23,
    "position": 1004
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary — B: تمرین واژگان",
    "start": 23,
    "end": 23,
    "position": 1005
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary — C: ارجاع به کتاب کار",
    "start": 23,
    "end": 23,
    "position": 1006
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Reading — A: طرح پرسش از متن احترام به والدین",
    "start": 26,
    "end": 26,
    "position": 1007
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Reading — B: یافتن ایده اصلی متن",
    "start": 26,
    "end": 26,
    "position": 1008
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Reading — C: تشخیص مرجع واژه‌ها",
    "start": 26,
    "end": 26,
    "position": 1009
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary Development — A: ساخت هم‌آیندها از مکالمه",
    "start": 28,
    "end": 28,
    "position": 1010
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Vocabulary Development — B: بررسی هم‌آیندها با متن",
    "start": 28,
    "end": 28,
    "position": 1011
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — A: خواندن متن مجهول",
    "start": 29,
    "end": 29,
    "position": 1012
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — B: مثال‌های فعل مجهول",
    "start": 29,
    "end": 29,
    "position": 1013
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — C: ساخت فعل مجهول",
    "start": 30,
    "end": 30,
    "position": 1014
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — D: یافتن مجهول در مکالمه",
    "start": 30,
    "end": 30,
    "position": 1015
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — E: انتخاب شکل درست فعل",
    "start": 30,
    "end": 30,
    "position": 1016
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — F: گفت‌وگو درباره رویداد گذشته",
    "start": 30,
    "end": 30,
    "position": 1017
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Grammar — G: ارجاع به کتاب کار",
    "start": 30,
    "end": 30,
    "position": 1018
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — See Also — A: مثال‌های tag question",
    "start": 31,
    "end": 31,
    "position": 1019
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — See Also — B: ارجاع به کتاب کار",
    "start": 31,
    "end": 31,
    "position": 1020
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Listening — A: پرسش تأییدی و عدم قطعیت",
    "start": 32,
    "end": 32,
    "position": 1021
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Listening — B: شنیدن مکالمه و پاسخ به پرسش‌ها",
    "start": 33,
    "end": 33,
    "position": 1022
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — A: تکمیل جمله با and و but",
    "start": 35,
    "end": 35,
    "position": 1023
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — B: تکمیل جمله با or و so",
    "start": 37,
    "end": 37,
    "position": 1024
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — C: ترکیب جمله‌ها با حروف ربط",
    "start": 38,
    "end": 38,
    "position": 1025
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — D: تکمیل جمله‌های مرکب",
    "start": 38,
    "end": 38,
    "position": 1026
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — E: نوشتن جمله مرکب درباره خود و خانواده",
    "start": 39,
    "end": 39,
    "position": 1027
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — Writing — F: یافتن جمله ساده و مرکب در متن",
    "start": 39,
    "end": 39,
    "position": 1028
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — What You Learned — A: شنیدن مصاحبه و پرسش‌ها",
    "start": 41,
    "end": 41,
    "position": 1029
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — What You Learned — B: خواندن ادامه مصاحبه",
    "start": 41,
    "end": 41,
    "position": 1030
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 1 — What You Learned — C: پرسش و پاسخ دونفره",
    "start": 41,
    "end": 41,
    "position": 1031
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Get Ready — A: تصاویر و انواع فرهنگ لغت",
    "start": 45,
    "end": 45,
    "position": 1032
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Get Ready — B: انتخاب فرهنگ لغت در موقعیت‌ها",
    "start": 46,
    "end": 46,
    "position": 1033
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Get Ready — C: اطلاعات موجود در فرهنگ لغت انگلیسی",
    "start": 46,
    "end": 46,
    "position": 1034
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary — A: خواندن و تمرین واژه‌ها",
    "start": 49,
    "end": 51,
    "position": 1035
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary — B: تمرین واژگان",
    "start": 51,
    "end": 51,
    "position": 1036
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary — C: ارجاع به کتاب کار",
    "start": 51,
    "end": 51,
    "position": 1037
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Reading — A: برجسته کردن نکات مهم پاراگراف",
    "start": 54,
    "end": 54,
    "position": 1038
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Reading — B: یافتن اطلاعات متن فرهنگ لغت",
    "start": 54,
    "end": 54,
    "position": 1039
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Reading — C: پرسش‌سازی از متن",
    "start": 54,
    "end": 54,
    "position": 1040
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary Development — A: واژه‌های هم‌خانواده",
    "start": 56,
    "end": 56,
    "position": 1041
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Vocabulary Development — B: یافتن معنی واژه‌ها با اجزای آن‌ها",
    "start": 56,
    "end": 56,
    "position": 1042
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — A: خواندن متن جمله موصولی",
    "start": 57,
    "end": 57,
    "position": 1043
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — B: مثال‌های جمله موصولی",
    "start": 57,
    "end": 57,
    "position": 1044
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — C: ساخت جمله موصولی",
    "start": 58,
    "end": 58,
    "position": 1045
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — D: تکمیل متن با who و which",
    "start": 59,
    "end": 59,
    "position": 1046
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — E: تکمیل جمله‌های موصولی",
    "start": 59,
    "end": 59,
    "position": 1047
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Grammar — F: ارجاع به کتاب کار",
    "start": 59,
    "end": 59,
    "position": 1048
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — See Also — A: مثال‌های شرطی نوع دوم",
    "start": 60,
    "end": 60,
    "position": 1049
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — See Also — B: ارجاع به کتاب کار",
    "start": 60,
    "end": 60,
    "position": 1050
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Listening — A: گفت‌وگو درباره موقعیت فرضی",
    "start": 61,
    "end": 61,
    "position": 1051
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Listening — B: شنیدن مکالمه و پاسخ به پرسش‌ها",
    "start": 62,
    "end": 62,
    "position": 1052
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — A: تشخیص شکل درست پاراگراف",
    "start": 64,
    "end": 64,
    "position": 1053
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — B: موضوع و ایده کنترل‌کننده جمله",
    "start": 65,
    "end": 65,
    "position": 1054
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — متن تمرین: یافتن جمله موضوعی و ایده اصلی پاراگراف‌ها",
    "start": 66,
    "end": 67,
    "position": 1055
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — Writing — C: نوشتن جمله موضوعی",
    "start": 67,
    "end": 67,
    "position": 1056
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — What You Learned — A: شنیدن بخش اول گزارش",
    "start": 69,
    "end": 69,
    "position": 1057
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — What You Learned — B: خواندن ادامه گزارش",
    "start": 69,
    "end": 69,
    "position": 1058
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 2 — What You Learned — C: پرسش و پاسخ دونفره",
    "start": 69,
    "end": 69,
    "position": 1059
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Get Ready — A: تصاویر و منابع انرژی",
    "start": 73,
    "end": 73,
    "position": 1060
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Get Ready — B: تشخیص انرژی تجدیدپذیر",
    "start": 74,
    "end": 74,
    "position": 1061
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Get Ready — C: روش‌های صرفه‌جویی در انرژی",
    "start": 74,
    "end": 74,
    "position": 1062
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary — A: خواندن و تمرین واژه‌ها",
    "start": 77,
    "end": 79,
    "position": 1063
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary — B: تمرین واژگان",
    "start": 79,
    "end": 79,
    "position": 1064
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary — C: ارجاع به کتاب کار",
    "start": 79,
    "end": 79,
    "position": 1065
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Reading — A: یادداشت‌برداری از متن",
    "start": 82,
    "end": 82,
    "position": 1066
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Reading — B: تکمیل یادداشت‌های متن",
    "start": 82,
    "end": 82,
    "position": 1067
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Reading — C: تشخیص مرجع واژه‌ها",
    "start": 82,
    "end": 82,
    "position": 1068
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary Development — A: معنی ضرب‌المثل‌ها",
    "start": 84,
    "end": 84,
    "position": 1069
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Vocabulary Development — B: معادل فارسی ضرب‌المثل‌ها",
    "start": 85,
    "end": 85,
    "position": 1070
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — A: خواندن متن مجهول با افعال وجهی",
    "start": 86,
    "end": 86,
    "position": 1071
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — B: مثال‌های مجهول با افعال وجهی",
    "start": 86,
    "end": 86,
    "position": 1072
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — C: ساخت مجهول با افعال وجهی",
    "start": 87,
    "end": 87,
    "position": 1073
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — D: یافتن مجهول با افعال وجهی در مکالمه",
    "start": 87,
    "end": 87,
    "position": 1074
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — E: ساخت جمله مجهول",
    "start": 87,
    "end": 87,
    "position": 1075
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — F: گفت‌وگو درباره اقدام‌های ممکن و لازم",
    "start": 87,
    "end": 87,
    "position": 1076
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Grammar — G: ارجاع به کتاب کار",
    "start": 87,
    "end": 87,
    "position": 1077
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — See Also — A: مثال‌های گذشته کامل",
    "start": 88,
    "end": 88,
    "position": 1078
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — See Also — B: ارجاع به کتاب کار",
    "start": 88,
    "end": 88,
    "position": 1079
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Listening — A: گفت‌وگو با گذشته کامل",
    "start": 89,
    "end": 89,
    "position": 1080
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Listening — B: شنیدن مکالمه و پاسخ به پرسش‌ها",
    "start": 90,
    "end": 90,
    "position": 1081
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — A: تشخیص جمله‌های نامرتبط با موضوع",
    "start": 91,
    "end": 91,
    "position": 1082
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — B: تشخیص جمله پایانی پاراگراف",
    "start": 92,
    "end": 92,
    "position": 1083
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — C: مرتب کردن جمله‌های پاراگراف",
    "start": 93,
    "end": 93,
    "position": 1084
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — D: تشخیص جمله موضوعی پشتیبان و پایانی",
    "start": 94,
    "end": 94,
    "position": 1085
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — E: نوشتن پاراگراف درباره یادگیری زبان",
    "start": 95,
    "end": 95,
    "position": 1086
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — F: نوشتن پاراگراف درباره ورزش",
    "start": 96,
    "end": 96,
    "position": 1087
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — Writing — G: نوشتن پاراگراف درباره تصویر ایران",
    "start": 97,
    "end": 97,
    "position": 1088
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — What You Learned — A: شنیدن بخش اول داستان",
    "start": 99,
    "end": 99,
    "position": 1089
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — What You Learned — B: خواندن ادامه داستان",
    "start": 99,
    "end": 99,
    "position": 1090
   },
   {
    "chapter": "درس‌ها",
    "title": "درس 3 — What You Learned — C: پرسش و پاسخ دونفره",
    "start": 99,
    "end": 99,
    "position": 1091
   }
  ]
 }
]$books$::jsonb) as b(grade text,subject text,topics jsonb)),
topics as (select b.grade,b.subject,p.* from books b cross join lateral jsonb_to_recordset(b.topics) as p(chapter text,title text,start integer,"end" integer,position integer)),
fields as (select unnest(array['mathematics','experimental_sciences','humanities']) as field)
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v227:'||f.field||':'||p.grade||':final_exam:'||p.subject||':'||p.chapter||':'||p.position)::uuid,
'1405',f.field,p.grade,'final_exam',p.subject,p.chapter,p.title,p.start,p."end",p.position
from topics p cross join fields f cross join installed on conflict(id) do nothing;
