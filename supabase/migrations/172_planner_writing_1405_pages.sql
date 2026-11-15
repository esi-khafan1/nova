-- Three user-provided writing textbooks (1405). Printed page numbers only.
-- Existing lesson rows: CAS against the exact original v1 seed; never touch edited/deleted rows.
with fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "grade": "10",
  "subject": "نگارش ۱",
  "position": 1,
  "title": "پرورش موضوع",
  "start": 14,
  "end": 25
 },
 {
  "grade": "10",
  "subject": "نگارش ۱",
  "position": 2,
  "title": "عینک نوشتن",
  "start": 28,
  "end": 39
 },
 {
  "grade": "10",
  "subject": "نگارش ۱",
  "position": 3,
  "title": "نوشته‌های عینی",
  "start": 42,
  "end": 55
 },
 {
  "grade": "10",
  "subject": "نگارش ۱",
  "position": 4,
  "title": "نوشته‌های گزارش‌گونه",
  "start": 58,
  "end": 71
 },
 {
  "grade": "10",
  "subject": "نگارش ۱",
  "position": 5,
  "title": "نوشته ذهنی ۱: جانشین‌سازی",
  "start": 74,
  "end": 83
 },
 {
  "grade": "10",
  "subject": "نگارش ۱",
  "position": 6,
  "title": "نوشته ذهنی ۲: سنجش و مقایسه",
  "start": 86,
  "end": 97
 },
 {
  "grade": "10",
  "subject": "نگارش ۱",
  "position": 7,
  "title": "نوشته ذهنی ۳: ناسازی معنایی یا تضاد مفاهیم",
  "start": 100,
  "end": 110
 },
 {
  "grade": "10",
  "subject": "نگارش ۱",
  "position": 8,
  "title": "نوشته‌های داستان‌گونه",
  "start": 112,
  "end": 122
 },
 {
  "grade": "11",
  "subject": "نگارش ۲",
  "position": 1,
  "title": "اجزای نوشته: ساختار و محتوا",
  "start": 14,
  "end": 32
 },
 {
  "grade": "11",
  "subject": "نگارش ۲",
  "position": 2,
  "title": "گسترش محتوا ۱: زمان و مکان",
  "start": 36,
  "end": 51
 },
 {
  "grade": "11",
  "subject": "نگارش ۲",
  "position": 3,
  "title": "گسترش محتوا ۲: شخصیت",
  "start": 54,
  "end": 68
 },
 {
  "grade": "11",
  "subject": "نگارش ۲",
  "position": 4,
  "title": "گسترش محتوا ۳: گفت‌وگو",
  "start": 72,
  "end": 83
 },
 {
  "grade": "11",
  "subject": "نگارش ۲",
  "position": 5,
  "title": "سفرنامه",
  "start": 86,
  "end": 103
 },
 {
  "grade": "11",
  "subject": "نگارش ۲",
  "position": 6,
  "title": "کاهش محتوا: خلاصه‌نویسی",
  "start": 106,
  "end": 123
 }
]$fixes$::jsonb) as p(grade text,subject text,position integer,title text,start integer,"end" integer)), fields(field) as (values ('mathematics'),('experimental_sciences'),('humanities'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p cross join fields f
where t.id=md5('nova:planner:1405:v1:'||f.field||':'||p.grade||':final_exam:'||p.subject||':درس‌ها:'||p.position)::uuid and t.edition='1405' and t.study_field=f.field and t.grade=p.grade and t.preparation_track='final_exam' and t.subject=p.subject and t.chapter='درس‌ها' and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;

-- Requires private seed marker from migration 167; install additions only once.
with installed as (insert into private.planner_seed_installations(seed_key) values ('writing-1405-v172') on conflict do nothing returning seed_key),
books as (select * from jsonb_to_recordset($books$[
 {
  "grade": "10",
  "subject": "نگارش ۱",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "topics": [
   {
    "position": 101,
    "title": "درس 1: پرورش موضوع — متن آموزشی",
    "start": 14,
    "end": 18
   },
   {
    "position": 102,
    "title": "درس 1: پرورش موضوع — کارگاه نوشتن",
    "start": 19,
    "end": 22
   },
   {
    "position": 103,
    "title": "درس 1: پرورش موضوع — هنجار نوشتار",
    "start": 23,
    "end": 24
   },
   {
    "position": 104,
    "title": "درس 1: پرورش موضوع — حکایت‌نگاری",
    "start": 25,
    "end": 25
   },
   {
    "position": 201,
    "title": "درس 2: عینک نوشتن — متن آموزشی",
    "start": 28,
    "end": 32
   },
   {
    "position": 202,
    "title": "درس 2: عینک نوشتن — کارگاه نوشتن",
    "start": 33,
    "end": 37
   },
   {
    "position": 203,
    "title": "درس 2: عینک نوشتن — هنجار نوشتار",
    "start": 38,
    "end": 38
   },
   {
    "position": 204,
    "title": "درس 2: عینک نوشتن — مثل‌نویسی",
    "start": 39,
    "end": 39
   },
   {
    "position": 301,
    "title": "درس 3: نوشته‌های عینی — متن آموزشی",
    "start": 42,
    "end": 46
   },
   {
    "position": 302,
    "title": "درس 3: نوشته‌های عینی — کارگاه نوشتن",
    "start": 47,
    "end": 53
   },
   {
    "position": 303,
    "title": "درس 3: نوشته‌های عینی — هنجار نوشتار",
    "start": 54,
    "end": 54
   },
   {
    "position": 304,
    "title": "درس 3: نوشته‌های عینی — شعرگردانی",
    "start": 55,
    "end": 55
   },
   {
    "position": 401,
    "title": "درس 4: نوشته‌های گزارش‌گونه — متن آموزشی",
    "start": 58,
    "end": 63
   },
   {
    "position": 402,
    "title": "درس 4: نوشته‌های گزارش‌گونه — کارگاه نوشتن",
    "start": 64,
    "end": 68
   },
   {
    "position": 403,
    "title": "درس 4: نوشته‌های گزارش‌گونه — هنجار نوشتار",
    "start": 69,
    "end": 70
   },
   {
    "position": 404,
    "title": "درس 4: نوشته‌های گزارش‌گونه — حکایت‌نگاری",
    "start": 71,
    "end": 71
   },
   {
    "position": 501,
    "title": "درس 5: نوشته ذهنی: جانشین‌سازی — متن آموزشی",
    "start": 74,
    "end": 76
   },
   {
    "position": 502,
    "title": "درس 5: نوشته ذهنی: جانشین‌سازی — کارگاه نوشتن",
    "start": 77,
    "end": 81
   },
   {
    "position": 503,
    "title": "درس 5: نوشته ذهنی: جانشین‌سازی — هنجار نوشتار",
    "start": 82,
    "end": 82
   },
   {
    "position": 504,
    "title": "درس 5: نوشته ذهنی: جانشین‌سازی — مثل‌نویسی",
    "start": 83,
    "end": 83
   },
   {
    "position": 601,
    "title": "درس 6: نوشته ذهنی: سنجش و مقایسه — متن آموزشی",
    "start": 86,
    "end": 90
   },
   {
    "position": 602,
    "title": "درس 6: نوشته ذهنی: سنجش و مقایسه — کارگاه نوشتن",
    "start": 91,
    "end": 95
   },
   {
    "position": 603,
    "title": "درس 6: نوشته ذهنی: سنجش و مقایسه — هنجار نوشتار",
    "start": 96,
    "end": 96
   },
   {
    "position": 604,
    "title": "درس 6: نوشته ذهنی: سنجش و مقایسه — شعرگردانی",
    "start": 97,
    "end": 97
   },
   {
    "position": 701,
    "title": "درس 7: نوشته ذهنی: ناسازی معنایی یا تضاد مفاهیم — متن آموزشی",
    "start": 100,
    "end": 104
   },
   {
    "position": 702,
    "title": "درس 7: نوشته ذهنی: ناسازی معنایی یا تضاد مفاهیم — کارگاه نوشتن",
    "start": 105,
    "end": 108
   },
   {
    "position": 703,
    "title": "درس 7: نوشته ذهنی: ناسازی معنایی یا تضاد مفاهیم — هنجار نوشتار",
    "start": 109,
    "end": 109
   },
   {
    "position": 704,
    "title": "درس 7: نوشته ذهنی: ناسازی معنایی یا تضاد مفاهیم — حکایت‌نگاری",
    "start": 110,
    "end": 110
   },
   {
    "position": 801,
    "title": "درس 8: نوشته‌های داستان‌گونه — متن آموزشی",
    "start": 112,
    "end": 116
   },
   {
    "position": 802,
    "title": "درس 8: نوشته‌های داستان‌گونه — کارگاه نوشتن",
    "start": 117,
    "end": 120
   },
   {
    "position": 803,
    "title": "درس 8: نوشته‌های داستان‌گونه — هنجار نوشتار",
    "start": 121,
    "end": 121
   },
   {
    "position": 804,
    "title": "درس 8: نوشته‌های داستان‌گونه — مثل‌نویسی",
    "start": 122,
    "end": 122
   }
  ]
 },
 {
  "grade": "11",
  "subject": "نگارش ۲",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "topics": [
   {
    "position": 101,
    "title": "درس 1: اجزای نوشته: ساختار و محتوا — متن آموزشی",
    "start": 14,
    "end": 28
   },
   {
    "position": 102,
    "title": "درس 1: اجزای نوشته: ساختار و محتوا — کارگاه نوشتن",
    "start": 29,
    "end": 31
   },
   {
    "position": 104,
    "title": "درس 1: اجزای نوشته: ساختار و محتوا — مثل‌نویسی",
    "start": 32,
    "end": 32
   },
   {
    "position": 201,
    "title": "درس 2: گسترش محتوا: زمان و مکان — متن آموزشی",
    "start": 36,
    "end": 47
   },
   {
    "position": 202,
    "title": "درس 2: گسترش محتوا: زمان و مکان — کارگاه نوشتن",
    "start": 48,
    "end": 50
   },
   {
    "position": 204,
    "title": "درس 2: گسترش محتوا: زمان و مکان — شعرگردانی",
    "start": 51,
    "end": 51
   },
   {
    "position": 301,
    "title": "درس 3: گسترش محتوا: شخصیت — متن آموزشی",
    "start": 54,
    "end": 63
   },
   {
    "position": 302,
    "title": "درس 3: گسترش محتوا: شخصیت — کارگاه نوشتن",
    "start": 64,
    "end": 67
   },
   {
    "position": 304,
    "title": "درس 3: گسترش محتوا: شخصیت — حکایت‌نگاری",
    "start": 68,
    "end": 68
   },
   {
    "position": 401,
    "title": "درس 4: گسترش محتوا: گفت‌وگو — متن آموزشی",
    "start": 72,
    "end": 80
   },
   {
    "position": 402,
    "title": "درس 4: گسترش محتوا: گفت‌وگو — کارگاه نوشتن",
    "start": 81,
    "end": 82
   },
   {
    "position": 404,
    "title": "درس 4: گسترش محتوا: گفت‌وگو — مثل‌نویسی",
    "start": 83,
    "end": 83
   },
   {
    "position": 501,
    "title": "درس 5: سفرنامه — متن آموزشی",
    "start": 86,
    "end": 99
   },
   {
    "position": 502,
    "title": "درس 5: سفرنامه — کارگاه نوشتن",
    "start": 100,
    "end": 102
   },
   {
    "position": 504,
    "title": "درس 5: سفرنامه — شعرگردانی",
    "start": 103,
    "end": 103
   },
   {
    "position": 601,
    "title": "درس 6: کاهش محتوا: خلاصه‌نویسی — متن آموزشی",
    "start": 106,
    "end": 119
   },
   {
    "position": 602,
    "title": "درس 6: کاهش محتوا: خلاصه‌نویسی — کارگاه نوشتن",
    "start": 120,
    "end": 122
   },
   {
    "position": 604,
    "title": "درس 6: کاهش محتوا: خلاصه‌نویسی — حکایت‌نگاری",
    "start": 123,
    "end": 123
   }
  ]
 },
 {
  "grade": "12",
  "subject": "نگارش ۳",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "topics": [
   {
    "position": 101,
    "title": "درس 1: خاطره‌نگاری — متن آموزشی",
    "start": 12,
    "end": 22
   },
   {
    "position": 102,
    "title": "درس 1: خاطره‌نگاری — کارگاه نوشتن",
    "start": 23,
    "end": 26
   },
   {
    "position": 104,
    "title": "درس 1: خاطره‌نگاری — مثل‌نویسی",
    "start": 27,
    "end": 27
   },
   {
    "position": 201,
    "title": "درس 2: نگارش ادبی: نثر ادبی — متن آموزشی",
    "start": 30,
    "end": 36
   },
   {
    "position": 202,
    "title": "درس 2: نگارش ادبی: نثر ادبی — کارگاه نوشتن",
    "start": 37,
    "end": 40
   },
   {
    "position": 204,
    "title": "درس 2: نگارش ادبی: نثر ادبی — شعرگردانی",
    "start": 41,
    "end": 41
   },
   {
    "position": 301,
    "title": "درس 3: نگارش ادبی: قطعه ادبی — متن آموزشی",
    "start": 44,
    "end": 50
   },
   {
    "position": 302,
    "title": "درس 3: نگارش ادبی: قطعه ادبی — کارگاه نوشتن",
    "start": 51,
    "end": 56
   },
   {
    "position": 304,
    "title": "درس 3: نگارش ادبی: قطعه ادبی — حکایت‌نگاری",
    "start": 57,
    "end": 57
   },
   {
    "position": 401,
    "title": "درس 4: نامه‌نگاری — متن آموزشی",
    "start": 60,
    "end": 71
   },
   {
    "position": 402,
    "title": "درس 4: نامه‌نگاری — کارگاه نوشتن",
    "start": 72,
    "end": 75
   },
   {
    "position": 404,
    "title": "درس 4: نامه‌نگاری — شعرگردانی",
    "start": 76,
    "end": 76
   },
   {
    "position": 501,
    "title": "درس 5: نگارش علمی: مقاله‌نویسی ۱ — متن آموزشی",
    "start": 80,
    "end": 88
   },
   {
    "position": 502,
    "title": "درس 5: نگارش علمی: مقاله‌نویسی ۱ — کارگاه نوشتن",
    "start": 89,
    "end": 92
   },
   {
    "position": 504,
    "title": "درس 5: نگارش علمی: مقاله‌نویسی ۱ — مثل‌نویسی",
    "start": 93,
    "end": 93
   },
   {
    "position": 601,
    "title": "درس 6: نگارش علمی: مقاله‌نویسی ۲ — متن آموزشی",
    "start": 96,
    "end": 100
   },
   {
    "position": 602,
    "title": "درس 6: نگارش علمی: مقاله‌نویسی ۲ — کارگاه نوشتن",
    "start": 101,
    "end": 103
   },
   {
    "position": 604,
    "title": "درس 6: نگارش علمی: مقاله‌نویسی ۲ — حکایت‌نگاری",
    "start": 104,
    "end": 104
   },
   {
    "position": 901,
    "title": "نمونه‌های خاطره‌نگاری",
    "start": 108,
    "end": 110
   },
   {
    "position": 902,
    "title": "نمونه نثر ادبی",
    "start": 111,
    "end": 112
   },
   {
    "position": 903,
    "title": "نمونه قطعه ادبی",
    "start": 113,
    "end": 113
   },
   {
    "position": 904,
    "title": "نمونه نامه",
    "start": 114,
    "end": 121
   },
   {
    "position": 905,
    "title": "نمونه مقاله",
    "start": 122,
    "end": 125
   }
  ]
 }
]$books$::jsonb) as b(grade text,subject text,fields jsonb,topics jsonb)),
expanded as (select b.grade,b.subject,f.field,(p.item->>'position')::integer position,p.item->>'title' title,(p.item->>'start')::integer page_start,(p.item->>'end')::integer page_end from books b cross join lateral jsonb_array_elements_text(b.fields) f(field) cross join lateral jsonb_array_elements(b.topics) p(item))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v172:'||field||':'||grade||':final_exam:'||subject||':درس‌ها:'||position)::uuid, '1405',field,grade,'final_exam',subject,'درس‌ها',title,page_start,page_end,position from expanded cross join installed on conflict(id) do nothing;
