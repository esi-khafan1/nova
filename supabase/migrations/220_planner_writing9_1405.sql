-- Writing 9 (904), 1405 user PDF. Printed pages, sections and exercises.
-- Exact CAS backfill and one-time additions; edited/deleted entries are untouched.
with installed as (insert into private.planner_seed_installations(seed_key) values ('writing9-1405-v220') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — کل درس",
  "start": 13,
  "end": 24,
  "position": 310
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — نظم ذهن و پرورش نوشته",
  "start": 14,
  "end": 20,
  "position": 311
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — فعالیت‌های نگارشی",
  "start": 20,
  "end": 22,
  "position": 312
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — درست‌نویسی",
  "start": 23,
  "end": 23,
  "position": 313
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — تصویرنویسی",
  "start": 24,
  "end": 24,
  "position": 314
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۱۳",
  "start": 13,
  "end": 13,
  "position": 1013
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۱۴",
  "start": 14,
  "end": 14,
  "position": 1014
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۱۵",
  "start": 15,
  "end": 15,
  "position": 1015
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۱۶",
  "start": 16,
  "end": 16,
  "position": 1016
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۱۷",
  "start": 17,
  "end": 17,
  "position": 1017
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۱۸",
  "start": 18,
  "end": 18,
  "position": 1018
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۱۹",
  "start": 19,
  "end": 19,
  "position": 1019
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۲۰",
  "start": 20,
  "end": 20,
  "position": 1020
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۲۱",
  "start": 21,
  "end": 21,
  "position": 1021
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۲۲",
  "start": 22,
  "end": 22,
  "position": 1022
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۲۳",
  "start": 23,
  "end": 23,
  "position": 1023
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۱ — مطالعه صفحه ۲۴",
  "start": 24,
  "end": 24,
  "position": 1024
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — کل درس",
  "start": 25,
  "end": 34,
  "position": 320
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — ساختار نوشته و کاربرد واژگان",
  "start": 26,
  "end": 29,
  "position": 321
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — فعالیت‌های نگارشی",
  "start": 30,
  "end": 32,
  "position": 322
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — درست‌نویسی",
  "start": 33,
  "end": 33,
  "position": 323
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — حکایت‌نگاری",
  "start": 34,
  "end": 34,
  "position": 324
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — مطالعه صفحه ۲۵",
  "start": 25,
  "end": 25,
  "position": 1025
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — مطالعه صفحه ۲۶",
  "start": 26,
  "end": 26,
  "position": 1026
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — مطالعه صفحه ۲۷",
  "start": 27,
  "end": 27,
  "position": 1027
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — مطالعه صفحه ۲۸",
  "start": 28,
  "end": 28,
  "position": 1028
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — مطالعه صفحه ۲۹",
  "start": 29,
  "end": 29,
  "position": 1029
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — مطالعه صفحه ۳۰",
  "start": 30,
  "end": 30,
  "position": 1030
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — مطالعه صفحه ۳۱",
  "start": 31,
  "end": 31,
  "position": 1031
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — مطالعه صفحه ۳۲",
  "start": 32,
  "end": 32,
  "position": 1032
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — مطالعه صفحه ۳۳",
  "start": 33,
  "end": 33,
  "position": 1033
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۲ — مطالعه صفحه ۳۴",
  "start": 34,
  "end": 34,
  "position": 1034
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — کل درس",
  "start": 35,
  "end": 44,
  "position": 330
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — زبان عادی و ادبی",
  "start": 36,
  "end": 38,
  "position": 331
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — فعالیت‌های نگارشی",
  "start": 39,
  "end": 42,
  "position": 332
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — درست‌نویسی",
  "start": 43,
  "end": 43,
  "position": 333
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — مثل‌نویسی",
  "start": 44,
  "end": 44,
  "position": 334
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — مطالعه صفحه ۳۵",
  "start": 35,
  "end": 35,
  "position": 1035
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — مطالعه صفحه ۳۶",
  "start": 36,
  "end": 36,
  "position": 1036
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — مطالعه صفحه ۳۷",
  "start": 37,
  "end": 37,
  "position": 1037
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — مطالعه صفحه ۳۸",
  "start": 38,
  "end": 38,
  "position": 1038
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — مطالعه صفحه ۳۹",
  "start": 39,
  "end": 39,
  "position": 1039
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — مطالعه صفحه ۴۰",
  "start": 40,
  "end": 40,
  "position": 1040
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — مطالعه صفحه ۴۱",
  "start": 41,
  "end": 41,
  "position": 1041
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — مطالعه صفحه ۴۲",
  "start": 42,
  "end": 42,
  "position": 1042
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — مطالعه صفحه ۴۳",
  "start": 43,
  "end": 43,
  "position": 1043
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۳ — مطالعه صفحه ۴۴",
  "start": 44,
  "end": 44,
  "position": 1044
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — کل درس",
  "start": 45,
  "end": 58,
  "position": 340
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — فضای طنز و غیرطنز",
  "start": 46,
  "end": 52,
  "position": 341
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — فعالیت‌های نگارشی",
  "start": 53,
  "end": 56,
  "position": 342
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — درست‌نویسی",
  "start": 57,
  "end": 57,
  "position": 343
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — تصویرنویسی",
  "start": 58,
  "end": 58,
  "position": 344
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۴۵",
  "start": 45,
  "end": 45,
  "position": 1045
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۴۶",
  "start": 46,
  "end": 46,
  "position": 1046
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۴۷",
  "start": 47,
  "end": 47,
  "position": 1047
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۴۸",
  "start": 48,
  "end": 48,
  "position": 1048
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۴۹",
  "start": 49,
  "end": 49,
  "position": 1049
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۵۰",
  "start": 50,
  "end": 50,
  "position": 1050
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۵۱",
  "start": 51,
  "end": 51,
  "position": 1051
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۵۲",
  "start": 52,
  "end": 52,
  "position": 1052
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۵۳",
  "start": 53,
  "end": 53,
  "position": 1053
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۵۴",
  "start": 54,
  "end": 54,
  "position": 1054
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۵۵",
  "start": 55,
  "end": 55,
  "position": 1055
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۵۶",
  "start": 56,
  "end": 56,
  "position": 1056
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۵۷",
  "start": 57,
  "end": 57,
  "position": 1057
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۴ — مطالعه صفحه ۵۸",
  "start": 58,
  "end": 58,
  "position": 1058
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — کل درس",
  "start": 59,
  "end": 70,
  "position": 350
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — آغاز و پایان و نام‌گذاری نوشته",
  "start": 60,
  "end": 64,
  "position": 351
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — فعالیت‌های نگارشی",
  "start": 65,
  "end": 68,
  "position": 352
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — درست‌نویسی",
  "start": 69,
  "end": 69,
  "position": 353
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — حکایت‌نگاری",
  "start": 70,
  "end": 70,
  "position": 354
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۵۹",
  "start": 59,
  "end": 59,
  "position": 1059
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۶۰",
  "start": 60,
  "end": 60,
  "position": 1060
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۶۱",
  "start": 61,
  "end": 61,
  "position": 1061
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۶۲",
  "start": 62,
  "end": 62,
  "position": 1062
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۶۳",
  "start": 63,
  "end": 63,
  "position": 1063
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۶۴",
  "start": 64,
  "end": 64,
  "position": 1064
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۶۵",
  "start": 65,
  "end": 65,
  "position": 1065
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۶۶",
  "start": 66,
  "end": 66,
  "position": 1066
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۶۷",
  "start": 67,
  "end": 67,
  "position": 1067
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۶۸",
  "start": 68,
  "end": 68,
  "position": 1068
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۶۹",
  "start": 69,
  "end": 69,
  "position": 1069
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۵ — مطالعه صفحه ۷۰",
  "start": 70,
  "end": 70,
  "position": 1070
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — کل درس",
  "start": 71,
  "end": 84,
  "position": 360
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — قالب‌های نوشتاری: نامه، سفرنامه، گزارش و داستان",
  "start": 72,
  "end": 78,
  "position": 361
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — فعالیت‌های نگارشی",
  "start": 79,
  "end": 82,
  "position": 362
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — درست‌نویسی",
  "start": 83,
  "end": 83,
  "position": 363
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مثل‌نویسی",
  "start": 84,
  "end": 84,
  "position": 364
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۷۱",
  "start": 71,
  "end": 71,
  "position": 1071
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۷۲",
  "start": 72,
  "end": 72,
  "position": 1072
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۷۳",
  "start": 73,
  "end": 73,
  "position": 1073
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۷۴",
  "start": 74,
  "end": 74,
  "position": 1074
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۷۵",
  "start": 75,
  "end": 75,
  "position": 1075
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۷۶",
  "start": 76,
  "end": 76,
  "position": 1076
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۷۷",
  "start": 77,
  "end": 77,
  "position": 1077
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۷۸",
  "start": 78,
  "end": 78,
  "position": 1078
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۷۹",
  "start": 79,
  "end": 79,
  "position": 1079
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۸۰",
  "start": 80,
  "end": 80,
  "position": 1080
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۸۱",
  "start": 81,
  "end": 81,
  "position": 1081
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۸۲",
  "start": 82,
  "end": 82,
  "position": 1082
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۸۳",
  "start": 83,
  "end": 83,
  "position": 1083
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۶ — مطالعه صفحه ۸۴",
  "start": 84,
  "end": 84,
  "position": 1084
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — کل درس",
  "start": 85,
  "end": 96,
  "position": 370
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه و عمق‌بخشی به نوشته",
  "start": 86,
  "end": 91,
  "position": 371
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — فعالیت‌های نگارشی",
  "start": 92,
  "end": 94,
  "position": 372
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — درست‌نویسی",
  "start": 95,
  "end": 95,
  "position": 373
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — تصویرنویسی",
  "start": 96,
  "end": 96,
  "position": 374
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۸۵",
  "start": 85,
  "end": 85,
  "position": 1085
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۸۶",
  "start": 86,
  "end": 86,
  "position": 1086
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۸۷",
  "start": 87,
  "end": 87,
  "position": 1087
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۸۸",
  "start": 88,
  "end": 88,
  "position": 1088
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۸۹",
  "start": 89,
  "end": 89,
  "position": 1089
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۹۰",
  "start": 90,
  "end": 90,
  "position": 1090
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۹۱",
  "start": 91,
  "end": 91,
  "position": 1091
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۹۲",
  "start": 92,
  "end": 92,
  "position": 1092
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۹۳",
  "start": 93,
  "end": 93,
  "position": 1093
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۹۴",
  "start": 94,
  "end": 94,
  "position": 1094
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۹۵",
  "start": 95,
  "end": 95,
  "position": 1095
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۷ — مطالعه صفحه ۹۶",
  "start": 96,
  "end": 96,
  "position": 1096
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — کل درس",
  "start": 97,
  "end": 107,
  "position": 380
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — بازنویسی و ویرایش نوشته",
  "start": 98,
  "end": 102,
  "position": 381
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — فعالیت‌های نگارشی",
  "start": 103,
  "end": 105,
  "position": 382
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — درست‌نویسی",
  "start": 106,
  "end": 106,
  "position": 383
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — حکایت‌نگاری",
  "start": 107,
  "end": 107,
  "position": 384
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — مطالعه صفحه ۹۷",
  "start": 97,
  "end": 97,
  "position": 1097
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — مطالعه صفحه ۹۸",
  "start": 98,
  "end": 98,
  "position": 1098
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — مطالعه صفحه ۹۹",
  "start": 99,
  "end": 99,
  "position": 1099
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — مطالعه صفحه ۱۰۰",
  "start": 100,
  "end": 100,
  "position": 1100
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — مطالعه صفحه ۱۰۱",
  "start": 101,
  "end": 101,
  "position": 1101
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — مطالعه صفحه ۱۰۲",
  "start": 102,
  "end": 102,
  "position": 1102
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — مطالعه صفحه ۱۰۳",
  "start": 103,
  "end": 103,
  "position": 1103
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — مطالعه صفحه ۱۰۴",
  "start": 104,
  "end": 104,
  "position": 1104
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — مطالعه صفحه ۱۰۵",
  "start": 105,
  "end": 105,
  "position": 1105
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — مطالعه صفحه ۱۰۶",
  "start": 106,
  "end": 106,
  "position": 1106
 },
 {
  "chapter": "درس‌ها",
  "title": "درس ۸ — مطالعه صفحه ۱۰۷",
  "start": 107,
  "end": 107,
  "position": 1107
 },
 {
  "chapter": "درس‌ها",
  "title": "ستایش",
  "start": 12,
  "end": 12,
  "position": 290
 },
 {
  "chapter": "درس‌ها",
  "title": "نیایش",
  "start": 108,
  "end": 108,
  "position": 1400
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer)),
fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "درس‌ها",
  "title": "با ذهنی نظام‌مند و پرورده بنویسیم",
  "start": 13,
  "end": 24,
  "position": 1
 },
 {
  "chapter": "درس‌ها",
  "title": "واژه‌ها را بشناسیم، گزینش کنیم و به کار بگیریم",
  "start": 25,
  "end": 34,
  "position": 2
 },
 {
  "chapter": "درس‌ها",
  "title": "نوع زبان نوشته را انتخاب کنیم",
  "start": 35,
  "end": 44,
  "position": 3
 },
 {
  "chapter": "درس‌ها",
  "title": "فضا و رنگ نوشته را تغییر دهیم",
  "start": 45,
  "end": 58,
  "position": 4
 },
 {
  "chapter": "درس‌ها",
  "title": "نوشته را خوش آغاز کنیم؛ زیبا به پایان ببریم و نیکو نام‌گذاری کنیم",
  "start": 59,
  "end": 70,
  "position": 5
 },
 {
  "chapter": "درس‌ها",
  "title": "قالبی برای نوشتن برگزینیم",
  "start": 71,
  "end": 84,
  "position": 6
 },
 {
  "chapter": "درس‌ها",
  "title": "وسعت و عمق نوشته را بیشتر کنیم",
  "start": 85,
  "end": 96,
  "position": 7
 },
 {
  "chapter": "درس‌ها",
  "title": "نوشته را ویرایش کنیم",
  "start": 97,
  "end": 107,
  "position": 8
 }
]$fixes$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer)),
corrected as (update private.planner_topic_bank b set page_start=p.start,page_end=p."end",revision=b.revision+1,updated_at=now() from fixes p cross join installed
 where b.id=md5('nova:planner:1405:v1:all:9:final_exam:نگارش:'||p.chapter||':'||p.position)::uuid and b.edition='1405' and b.study_field='all' and b.grade='9' and b.preparation_track='final_exam' and b.subject='نگارش' and b.chapter=p.chapter and b.title=p.title and b.position=p.position and b.page_start is null and b.page_end is null and b.revision=1 returning b.id)
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v220:all:9:final_exam:نگارش:'||p.chapter||':'||p.position)::uuid,'1405','all','9','final_exam','نگارش',p.chapter,p.title,p.start,p."end",p.position from topics p cross join installed on conflict(id) do nothing;
