-- Persian 9 (903), 1405: text and exercises and named reading sections.
-- Exact guarded backfill of seed v1; never overwrite a changed or deleted row.
with installed as (insert into private.planner_seed_installations(seed_key) values ('persian9-1405-v224') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "درس ۱ — کل درس",
  "start": 12,
  "end": 15,
  "position": 110
 },
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "درس ۱ — متن درس",
  "start": 13,
  "end": 13,
  "position": 111
 },
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "درس ۱ — خودارزیابی",
  "start": 14,
  "end": 14,
  "position": 112
 },
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "درس ۱ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 15,
  "end": 15,
  "position": 113
 },
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "درس ۲ — کل درس",
  "start": 17,
  "end": 21,
  "position": 120
 },
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "درس ۲ — متن درس",
  "start": 17,
  "end": 19,
  "position": 121
 },
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "درس ۲ — خودارزیابی",
  "start": 20,
  "end": 20,
  "position": 122
 },
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "درس ۲ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 21,
  "end": 21,
  "position": 123
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "درس ۳ — کل درس",
  "start": 24,
  "end": 28,
  "position": 130
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "درس ۳ — متن درس",
  "start": 24,
  "end": 26,
  "position": 131
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "درس ۳ — خودارزیابی",
  "start": 27,
  "end": 27,
  "position": 132
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "درس ۳ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 28,
  "end": 28,
  "position": 133
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "درس ۴ — کل درس",
  "start": 30,
  "end": 35,
  "position": 140
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "درس ۴ — متن درس",
  "start": 30,
  "end": 32,
  "position": 141
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "درس ۴ — خودارزیابی",
  "start": 33,
  "end": 33,
  "position": 142
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "درس ۴ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 34,
  "end": 35,
  "position": 143
 },
 {
  "chapter": "فصل آزاد: ادبیات بومی ۱",
  "title": "درس ۵ — کل درس",
  "start": 42,
  "end": 44,
  "position": 150
 },
 {
  "chapter": "فصل آزاد: ادبیات بومی ۱",
  "title": "درس ۵ — نگارش متن درس آزاد",
  "start": 42,
  "end": 42,
  "position": 151
 },
 {
  "chapter": "فصل آزاد: ادبیات بومی ۱",
  "title": "درس ۵ — پرسش‌ها و فعالیت‌های درس آزاد",
  "start": 43,
  "end": 44,
  "position": 152
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۶ — کل درس",
  "start": 48,
  "end": 52,
  "position": 160
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۶ — متن درس",
  "start": 48,
  "end": 49,
  "position": 161
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۶ — خودارزیابی",
  "start": 50,
  "end": 50,
  "position": 162
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۶ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 51,
  "end": 52,
  "position": 163
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۷ — کل درس",
  "start": 54,
  "end": 57,
  "position": 170
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۷ — متن درس",
  "start": 54,
  "end": 55,
  "position": 171
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۷ — خودارزیابی",
  "start": 56,
  "end": 56,
  "position": 172
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۷ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 57,
  "end": 57,
  "position": 173
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۸ — کل درس",
  "start": 58,
  "end": 63,
  "position": 180
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۸ — متن درس",
  "start": 58,
  "end": 61,
  "position": 181
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۸ — خودارزیابی",
  "start": 62,
  "end": 62,
  "position": 182
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۸ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 63,
  "end": 63,
  "position": 183
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۹ — کل درس",
  "start": 66,
  "end": 73,
  "position": 190
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۹ — متن درس",
  "start": 66,
  "end": 70,
  "position": 191
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۹ — خودارزیابی",
  "start": 71,
  "end": 71,
  "position": 192
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۹ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 72,
  "end": 73,
  "position": 193
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۱۰ — کل درس",
  "start": 74,
  "end": 80,
  "position": 200
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۱۰ — متن درس",
  "start": 74,
  "end": 78,
  "position": 201
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۱۰ — خودارزیابی",
  "start": 79,
  "end": 79,
  "position": 202
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۱۰ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 80,
  "end": 80,
  "position": 203
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۱۱ — کل درس",
  "start": 82,
  "end": 87,
  "position": 210
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۱۱ — متن درس",
  "start": 82,
  "end": 84,
  "position": 211
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۱۱ — خودارزیابی",
  "start": 85,
  "end": 85,
  "position": 212
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۱۱ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 86,
  "end": 87,
  "position": 213
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۲ — کل درس",
  "start": 92,
  "end": 96,
  "position": 220
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۲ — متن درس",
  "start": 92,
  "end": 93,
  "position": 221
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۲ — خودارزیابی",
  "start": 94,
  "end": 94,
  "position": 222
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۲ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 95,
  "end": 96,
  "position": 223
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۳ — کل درس",
  "start": 98,
  "end": 102,
  "position": 230
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۳ — متن درس",
  "start": 98,
  "end": 99,
  "position": 231
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۳ — خودارزیابی",
  "start": 100,
  "end": 100,
  "position": 232
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۳ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 101,
  "end": 102,
  "position": 233
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۴ — کل درس",
  "start": 103,
  "end": 109,
  "position": 240
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۴ — متن درس",
  "start": 103,
  "end": 107,
  "position": 241
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۴ — خودارزیابی",
  "start": 108,
  "end": 108,
  "position": 242
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۴ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 109,
  "end": 109,
  "position": 243
 },
 {
  "chapter": "فصل آزاد: ادبیات بومی ۲",
  "title": "درس ۱۵ — کل درس",
  "start": 112,
  "end": 114,
  "position": 250
 },
 {
  "chapter": "فصل آزاد: ادبیات بومی ۲",
  "title": "درس ۱۵ — نگارش متن درس آزاد",
  "start": 112,
  "end": 112,
  "position": 251
 },
 {
  "chapter": "فصل آزاد: ادبیات بومی ۲",
  "title": "درس ۱۵ — پرسش‌ها و فعالیت‌های درس آزاد",
  "start": 113,
  "end": 114,
  "position": 252
 },
 {
  "chapter": "فصل ۶: ادبیات جهان",
  "title": "درس ۱۶ — کل درس",
  "start": 118,
  "end": 122,
  "position": 260
 },
 {
  "chapter": "فصل ۶: ادبیات جهان",
  "title": "درس ۱۶ — متن درس",
  "start": 118,
  "end": 120,
  "position": 261
 },
 {
  "chapter": "فصل ۶: ادبیات جهان",
  "title": "درس ۱۶ — خودارزیابی",
  "start": 121,
  "end": 121,
  "position": 262
 },
 {
  "chapter": "فصل ۶: ادبیات جهان",
  "title": "درس ۱۶ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 122,
  "end": 122,
  "position": 263
 },
 {
  "chapter": "فصل ۶: ادبیات جهان",
  "title": "درس ۱۷ — کل درس",
  "start": 123,
  "end": 134,
  "position": 270
 },
 {
  "chapter": "فصل ۶: ادبیات جهان",
  "title": "درس ۱۷ — متن درس",
  "start": 123,
  "end": 131,
  "position": 271
 },
 {
  "chapter": "فصل ۶: ادبیات جهان",
  "title": "درس ۱۷ — خودارزیابی",
  "start": 132,
  "end": 132,
  "position": 272
 },
 {
  "chapter": "فصل ۶: ادبیات جهان",
  "title": "درس ۱۷ — دانش زبانی و فعالیت‌های نوشتاری و گفتاری",
  "start": 133,
  "end": 134,
  "position": 273
 },
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "حکایت: سفر",
  "start": 16,
  "end": 16,
  "position": 500
 },
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "شعرخوانی: پرواز",
  "start": 22,
  "end": 22,
  "position": 501
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "حکایت: باغبان نیک‌اندیش",
  "start": 29,
  "end": 29,
  "position": 502
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "روان‌خوانی: دریچه‌های شکوفایی",
  "start": 36,
  "end": 40,
  "position": 503
 },
 {
  "chapter": "فصل آزاد: ادبیات بومی ۱",
  "title": "حکایت آزاد",
  "start": 45,
  "end": 45,
  "position": 504
 },
 {
  "chapter": "فصل آزاد: ادبیات بومی ۱",
  "title": "شعرخوانی آزاد",
  "start": 46,
  "end": 46,
  "position": 505
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "حکایت: شو، خطر کن!",
  "start": 53,
  "end": 53,
  "position": 506
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "شعرخوانی: دوراندیشی",
  "start": 64,
  "end": 64,
  "position": 507
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "حکایت: نیک‌رایان",
  "start": 81,
  "end": 81,
  "position": 508
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "روان‌خوانی: دریچه‌ای به آسمان",
  "start": 88,
  "end": 90,
  "position": 509
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "حکایت: سیرت سلمان",
  "start": 97,
  "end": 97,
  "position": 510
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "شعرخوانی: بود قدر تو افزون از ملایک",
  "start": 110,
  "end": 110,
  "position": 511
 },
 {
  "chapter": "فصل آزاد: ادبیات بومی ۲",
  "title": "روان‌خوانی ادبیات بومی ۲",
  "start": 115,
  "end": 116,
  "position": 512
 },
 {
  "chapter": "فصل ۶: ادبیات جهان",
  "title": "روان‌خوانی: دو نقاش",
  "start": 135,
  "end": 137,
  "position": 513
 },
 {
  "chapter": "پیوست‌های کتاب",
  "title": "ستایش: به نام خداوند جان و خرد",
  "start": 9,
  "end": 10,
  "position": 100
 },
 {
  "chapter": "پیوست‌های کتاب",
  "title": "نیایش: بیا تا برآریم دستی ز دل",
  "start": 138,
  "end": 138,
  "position": 101
 },
 {
  "chapter": "پیوست‌های کتاب",
  "title": "واژه‌نامه",
  "start": 139,
  "end": 146,
  "position": 102
 },
 {
  "chapter": "پیوست‌های کتاب",
  "title": "اعلام: اشخاص و آثار",
  "start": 147,
  "end": 157,
  "position": 103
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer)),
fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "درس ۱: آفرینش همه تنبیه خداوند دل است",
  "start": 12,
  "end": 15,
  "position": 1
 },
 {
  "chapter": "فصل ۱: زیبایی آفرینش",
  "title": "درس ۲: عجایب صنع حق تعالی",
  "start": 17,
  "end": 21,
  "position": 2
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "درس ۳: مثل آیینه، کار و شایستگی",
  "start": 24,
  "end": 28,
  "position": 1
 },
 {
  "chapter": "فصل ۲: شکفتن",
  "title": "درس ۴: هم‌نشین",
  "start": 30,
  "end": 35,
  "position": 2
 },
 {
  "chapter": "فصل آزاد: ادبیات بومی ۱",
  "title": "درس ۵: آزاد",
  "start": 42,
  "end": 44,
  "position": 1
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۶: آداب زندگانی",
  "start": 48,
  "end": 52,
  "position": 1
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۷: پرتو امید",
  "start": 54,
  "end": 57,
  "position": 2
 },
 {
  "chapter": "فصل ۳: سبک زندگی",
  "title": "درس ۸: هم‌زیستی با مام میهن",
  "start": 58,
  "end": 63,
  "position": 3
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۹: راز موفقیت",
  "start": 66,
  "end": 73,
  "position": 1
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۱۰: آرشی دیگر",
  "start": 74,
  "end": 80,
  "position": 2
 },
 {
  "chapter": "فصل ۴: نام‌ها و یادها",
  "title": "درس ۱۱: زن پارسا",
  "start": 82,
  "end": 87,
  "position": 3
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۲: پیام‌آور رحمت",
  "start": 92,
  "end": 96,
  "position": 1
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۳: آشنای غریبان، میلاد گل",
  "start": 98,
  "end": 102,
  "position": 2
 },
 {
  "chapter": "فصل ۵: اسلام و انقلاب اسلامی",
  "title": "درس ۱۴: پیدای پنهان",
  "start": 103,
  "end": 109,
  "position": 3
 },
 {
  "chapter": "فصل آزاد: ادبیات بومی ۲",
  "title": "درس ۱۵: آزاد",
  "start": 112,
  "end": 114,
  "position": 1
 },
 {
  "chapter": "فصل ۶: ادبیات جهان",
  "title": "درس ۱۶: آرزو",
  "start": 118,
  "end": 122,
  "position": 1
 },
 {
  "chapter": "فصل ۶: ادبیات جهان",
  "title": "درس ۱۷: شازده کوچولو",
  "start": 123,
  "end": 134,
  "position": 2
 }
]$fixes$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer)),
corrected as (update private.planner_topic_bank b set page_start=p.start,page_end=p."end",revision=b.revision+1,updated_at=now() from fixes p cross join installed
 where b.id=md5('nova:planner:1405:v1:all:9:final_exam:فارسی:'||p.chapter||':'||p.position)::uuid and b.edition='1405' and b.study_field='all' and b.grade='9' and b.preparation_track='final_exam' and b.subject='فارسی' and b.chapter=p.chapter and b.title=p.title and b.position=p.position and b.page_start is null and b.page_end is null and b.revision=1 returning b.id)
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v224:all:9:final_exam:فارسی:'||p.chapter||':'||p.position)::uuid,'1405','all','9','final_exam','فارسی',p.chapter,p.title,p.start,p."end",p.position from topics p cross join installed on conflict(id) do nothing;
