-- Persian 1, textbook 110201, 1405, user PDF; printed page numbers.
-- One-time additions and exact CAS backfill; never revive deleted or overwrite edited rows.
with installed as (
 insert into private.planner_seed_installations(seed_key) values ('persian10-1405-v210') on conflict do nothing returning seed_key
), topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "ستایش: به نام کردگار",
  "start": 10,
  "end": 10,
  "position": 301
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۱: چشمه — متن درس",
  "start": 13,
  "end": 14,
  "position": 302
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۱: چشمه — کارگاه متن‌پژوهی",
  "start": 15,
  "end": 16,
  "position": 303
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۱: چشمه — قلمرو زبانی",
  "start": 15,
  "end": 15,
  "position": 304
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۱: چشمه — قلمرو ادبی",
  "start": 15,
  "end": 16,
  "position": 305
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۱: چشمه — قلمرو فکری",
  "start": 16,
  "end": 16,
  "position": 306
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۲: از آموختن، ننگ مدار — متن درس",
  "start": 18,
  "end": 18,
  "position": 307
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۲: از آموختن، ننگ مدار — کارگاه متن‌پژوهی",
  "start": 19,
  "end": 20,
  "position": 308
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۲: از آموختن، ننگ مدار — قلمرو زبانی",
  "start": 19,
  "end": 20,
  "position": 309
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۲: از آموختن، ننگ مدار — قلمرو ادبی",
  "start": 20,
  "end": 20,
  "position": 310
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۲: از آموختن، ننگ مدار — قلمرو فکری",
  "start": 20,
  "end": 20,
  "position": 311
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۳: پاسداری از حقیقت — متن درس",
  "start": 31,
  "end": 33,
  "position": 301
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۳: پاسداری از حقیقت — کارگاه متن‌پژوهی",
  "start": 34,
  "end": 35,
  "position": 302
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۳: پاسداری از حقیقت — قلمرو زبانی",
  "start": 34,
  "end": 34,
  "position": 303
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۳: پاسداری از حقیقت — قلمرو ادبی",
  "start": 34,
  "end": 35,
  "position": 304
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۳: پاسداری از حقیقت — قلمرو فکری",
  "start": 35,
  "end": 35,
  "position": 305
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۴: آزاد — متن درس",
  "start": 37,
  "end": 37,
  "position": 306
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۴: آزاد — کارگاه متن‌پژوهی",
  "start": 38,
  "end": 38,
  "position": 307
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۴: آزاد — قلمرو زبانی",
  "start": 38,
  "end": 38,
  "position": 308
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۴: آزاد — قلمرو ادبی",
  "start": 38,
  "end": 38,
  "position": 309
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۴: آزاد — قلمرو فکری",
  "start": 38,
  "end": 38,
  "position": 310
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۵: بیداد ظالمان — متن درس",
  "start": 41,
  "end": 41,
  "position": 311
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۵: بیداد ظالمان — کارگاه متن‌پژوهی",
  "start": 42,
  "end": 43,
  "position": 312
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۵: بیداد ظالمان — قلمرو زبانی",
  "start": 42,
  "end": 42,
  "position": 313
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۵: بیداد ظالمان — قلمرو ادبی",
  "start": 42,
  "end": 43,
  "position": 314
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۵: بیداد ظالمان — قلمرو فکری",
  "start": 43,
  "end": 43,
  "position": 315
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۶: مهر و وفا — متن درس",
  "start": 49,
  "end": 49,
  "position": 301
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۶: مهر و وفا — کارگاه متن‌پژوهی",
  "start": 50,
  "end": 51,
  "position": 302
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۶: مهر و وفا — قلمرو زبانی",
  "start": 50,
  "end": 50,
  "position": 303
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۶: مهر و وفا — قلمرو ادبی",
  "start": 51,
  "end": 51,
  "position": 304
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۶: مهر و وفا — قلمرو فکری",
  "start": 51,
  "end": 51,
  "position": 305
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۷: جمال و کمال — متن درس",
  "start": 53,
  "end": 54,
  "position": 306
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۷: جمال و کمال — کارگاه متن‌پژوهی",
  "start": 55,
  "end": 56,
  "position": 307
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۷: جمال و کمال — قلمرو زبانی",
  "start": 55,
  "end": 55,
  "position": 308
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۷: جمال و کمال — قلمرو ادبی",
  "start": 55,
  "end": 56,
  "position": 309
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۷: جمال و کمال — قلمرو فکری",
  "start": 56,
  "end": 56,
  "position": 310
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۸: سفر به بصره — متن درس",
  "start": 61,
  "end": 62,
  "position": 301
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۸: سفر به بصره — کارگاه متن‌پژوهی",
  "start": 63,
  "end": 64,
  "position": 302
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۸: سفر به بصره — قلمرو زبانی",
  "start": 63,
  "end": 64,
  "position": 303
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۸: سفر به بصره — قلمرو ادبی",
  "start": 64,
  "end": 64,
  "position": 304
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۸: سفر به بصره — قلمرو فکری",
  "start": 64,
  "end": 64,
  "position": 305
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۹: کلاس نقاشی — متن درس",
  "start": 66,
  "end": 67,
  "position": 306
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۹: کلاس نقاشی — کارگاه متن‌پژوهی",
  "start": 68,
  "end": 69,
  "position": 307
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۹: کلاس نقاشی — قلمرو زبانی",
  "start": 68,
  "end": 69,
  "position": 308
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۹: کلاس نقاشی — قلمرو ادبی",
  "start": 69,
  "end": 69,
  "position": 309
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۹: کلاس نقاشی — قلمرو فکری",
  "start": 69,
  "end": 69,
  "position": 310
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۰: دریادلان صف‌شکن — متن درس",
  "start": 77,
  "end": 80,
  "position": 301
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۰: دریادلان صف‌شکن — کارگاه متن‌پژوهی",
  "start": 81,
  "end": 82,
  "position": 302
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۰: دریادلان صف‌شکن — قلمرو زبانی",
  "start": 81,
  "end": 82,
  "position": 303
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۰: دریادلان صف‌شکن — قلمرو ادبی",
  "start": 82,
  "end": 82,
  "position": 304
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۰: دریادلان صف‌شکن — قلمرو فکری",
  "start": 82,
  "end": 82,
  "position": 305
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۱: خاک آزادگان — متن درس",
  "start": 84,
  "end": 84,
  "position": 306
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۱: خاک آزادگان — کارگاه متن‌پژوهی",
  "start": 85,
  "end": 86,
  "position": 307
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۱: خاک آزادگان — قلمرو زبانی",
  "start": 85,
  "end": 85,
  "position": 308
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۱: خاک آزادگان — قلمرو ادبی",
  "start": 86,
  "end": 86,
  "position": 309
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۱: خاک آزادگان — قلمرو فکری",
  "start": 86,
  "end": 86,
  "position": 310
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۲: رستم و اشکبوس — متن درس",
  "start": 97,
  "end": 100,
  "position": 301
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۲: رستم و اشکبوس — کارگاه متن‌پژوهی",
  "start": 101,
  "end": 102,
  "position": 302
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۲: رستم و اشکبوس — قلمرو زبانی",
  "start": 101,
  "end": 102,
  "position": 303
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۲: رستم و اشکبوس — قلمرو ادبی",
  "start": 102,
  "end": 102,
  "position": 304
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۲: رستم و اشکبوس — قلمرو فکری",
  "start": 102,
  "end": 102,
  "position": 305
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۳: گردآفرید — متن درس",
  "start": 104,
  "end": 107,
  "position": 306
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۳: گردآفرید — کارگاه متن‌پژوهی",
  "start": 108,
  "end": 109,
  "position": 307
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۳: گردآفرید — قلمرو زبانی",
  "start": 108,
  "end": 108,
  "position": 308
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۳: گردآفرید — قلمرو ادبی",
  "start": 108,
  "end": 108,
  "position": 309
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۳: گردآفرید — قلمرو فکری",
  "start": 109,
  "end": 109,
  "position": 310
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۴: طوطی و بقال — متن درس",
  "start": 115,
  "end": 116,
  "position": 301
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۴: طوطی و بقال — کارگاه متن‌پژوهی",
  "start": 117,
  "end": 118,
  "position": 302
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۴: طوطی و بقال — قلمرو زبانی",
  "start": 117,
  "end": 117,
  "position": 303
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۴: طوطی و بقال — قلمرو ادبی",
  "start": 117,
  "end": 118,
  "position": 304
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۴: طوطی و بقال — قلمرو فکری",
  "start": 118,
  "end": 118,
  "position": 305
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۵: آزاد — متن درس",
  "start": 120,
  "end": 120,
  "position": 306
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۵: آزاد — کارگاه متن‌پژوهی",
  "start": 121,
  "end": 121,
  "position": 307
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۵: آزاد — قلمرو زبانی",
  "start": 121,
  "end": 121,
  "position": 308
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۵: آزاد — قلمرو ادبی",
  "start": 121,
  "end": 121,
  "position": 309
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۵: آزاد — قلمرو فکری",
  "start": 121,
  "end": 121,
  "position": 310
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۶: خسرو — متن درس",
  "start": 122,
  "end": 127,
  "position": 311
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۶: خسرو — کارگاه متن‌پژوهی",
  "start": 128,
  "end": 129,
  "position": 312
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۶: خسرو — قلمرو زبانی",
  "start": 128,
  "end": 128,
  "position": 313
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۶: خسرو — قلمرو ادبی",
  "start": 128,
  "end": 129,
  "position": 314
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۶: خسرو — قلمرو فکری",
  "start": 129,
  "end": 129,
  "position": 315
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۷: سپیده‌دم — متن درس",
  "start": 135,
  "end": 137,
  "position": 301
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۷: سپیده‌دم — کارگاه متن‌پژوهی",
  "start": 138,
  "end": 140,
  "position": 302
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۷: سپیده‌دم — قلمرو زبانی",
  "start": 138,
  "end": 138,
  "position": 303
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۷: سپیده‌دم — قلمرو ادبی",
  "start": 139,
  "end": 139,
  "position": 304
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۷: سپیده‌دم — قلمرو فکری",
  "start": 139,
  "end": 140,
  "position": 305
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۸: عظمت نگاه — متن درس",
  "start": 142,
  "end": 143,
  "position": 306
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۸: عظمت نگاه — کارگاه متن‌پژوهی",
  "start": 144,
  "end": 145,
  "position": 307
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۸: عظمت نگاه — قلمرو زبانی",
  "start": 144,
  "end": 144,
  "position": 308
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۸: عظمت نگاه — قلمرو ادبی",
  "start": 144,
  "end": 144,
  "position": 309
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۸: عظمت نگاه — قلمرو فکری",
  "start": 145,
  "end": 145,
  "position": 310
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "کل فصل",
  "start": 11,
  "end": 27,
  "position": 312
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "کل فصل",
  "start": 29,
  "end": 45,
  "position": 316
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "کل فصل",
  "start": 47,
  "end": 57,
  "position": 311
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "کل فصل",
  "start": 59,
  "end": 73,
  "position": 311
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "کل فصل",
  "start": 75,
  "end": 93,
  "position": 311
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "کل فصل",
  "start": 95,
  "end": 111,
  "position": 311
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "کل فصل",
  "start": 113,
  "end": 131,
  "position": 316
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "کل فصل",
  "start": 133,
  "end": 150,
  "position": 311
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "گنج حکمت: پیرایه خرد",
  "start": 17,
  "end": 17,
  "position": 313
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "روان‌خوانی: دیوار",
  "start": 21,
  "end": 27,
  "position": 314
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "دیوار — درک و دریافت",
  "start": 27,
  "end": 27,
  "position": 315
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "گنج حکمت: دیوار عدل",
  "start": 36,
  "end": 36,
  "position": 317
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "فارسی‌واژه‌ها: واژه‌های فارسی‌شده",
  "start": 39,
  "end": 40,
  "position": 318
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "شعرخوانی: همای رحمت",
  "start": 44,
  "end": 45,
  "position": 319
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "همای رحمت — درک و دریافت",
  "start": 45,
  "end": 45,
  "position": 320
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "گنج حکمت: حقه راز",
  "start": 52,
  "end": 52,
  "position": 312
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "شعرخوانی: بوی گل و ریحان‌ها",
  "start": 57,
  "end": 57,
  "position": 313
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "بوی گل و ریحان‌ها — درک و دریافت",
  "start": 57,
  "end": 57,
  "position": 314
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "گنج حکمت: شبی در کاروان",
  "start": 65,
  "end": 65,
  "position": 312
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "روان‌خوانی: پیرمرد چشم ما بود",
  "start": 70,
  "end": 73,
  "position": 313
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "پیرمرد چشم ما بود — درک و دریافت",
  "start": 73,
  "end": 73,
  "position": 314
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "گنج حکمت: یک گام فراتر",
  "start": 83,
  "end": 83,
  "position": 312
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "روان‌خوانی: شیرزنان ایران",
  "start": 87,
  "end": 93,
  "position": 313
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "شیرزنان ایران — درک و دریافت",
  "start": 93,
  "end": 93,
  "position": 314
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "گنج حکمت: عامل و رعیت",
  "start": 103,
  "end": 103,
  "position": 312
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "شعرخوانی: دلیران و مردان ایران‌زمین",
  "start": 110,
  "end": 111,
  "position": 313
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "دلیران و مردان ایران‌زمین — درک و دریافت",
  "start": 111,
  "end": 111,
  "position": 314
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "گنج حکمت: ای رفیق",
  "start": 119,
  "end": 119,
  "position": 317
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "روان‌خوانی: طراران",
  "start": 130,
  "end": 131,
  "position": 318
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "طراران — درک و دریافت",
  "start": 131,
  "end": 131,
  "position": 319
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "گنج حکمت: مزار شاعر",
  "start": 141,
  "end": 141,
  "position": 312
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "روان‌خوانی: سه پرسش",
  "start": 146,
  "end": 150,
  "position": 313
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "سه پرسش — درک و دریافت",
  "start": 150,
  "end": 150,
  "position": 314
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "نیایش: الهی",
  "start": 151,
  "end": 151,
  "position": 315
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "واژه‌نامه",
  "start": 153,
  "end": 163,
  "position": 316
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer)),
fixes as (select * from jsonb_to_recordset($fixes$[
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۱: چشمه",
  "position": 1,
  "start": 13,
  "end": 16
 },
 {
  "chapter": "فصل ۱: ادبیات تعلیمی",
  "title": "درس ۲: از آموختن، ننگ مدار",
  "position": 2,
  "start": 18,
  "end": 20
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۳: پاسداری از حقیقت",
  "position": 1,
  "start": 31,
  "end": 35
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۴: آزاد",
  "position": 2,
  "start": 37,
  "end": 38
 },
 {
  "chapter": "فصل ۲: ادبیات پایداری",
  "title": "درس ۵: بیداد ظالمان",
  "position": 3,
  "start": 41,
  "end": 43
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۶: مهر و وفا",
  "position": 1,
  "start": 49,
  "end": 51
 },
 {
  "chapter": "فصل ۳: ادبیات غنایی",
  "title": "درس ۷: جمال و کمال",
  "position": 2,
  "start": 53,
  "end": 56
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۸: سفر به بصره",
  "position": 1,
  "start": 61,
  "end": 64
 },
 {
  "chapter": "فصل ۴: ادبیات سفر و زندگی",
  "title": "درس ۹: کلاس نقاشی",
  "position": 2,
  "start": 66,
  "end": 69
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۰: دریادلان صف‌شکن",
  "position": 1,
  "start": 77,
  "end": 82
 },
 {
  "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
  "title": "درس ۱۱: خاک آزادگان",
  "position": 2,
  "start": 84,
  "end": 86
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۲: رستم و اشکبوس",
  "position": 1,
  "start": 97,
  "end": 102
 },
 {
  "chapter": "فصل ۶: ادبیات حماسی",
  "title": "درس ۱۳: گردآفرید",
  "position": 2,
  "start": 104,
  "end": 109
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۴: طوطی و بقال",
  "position": 1,
  "start": 115,
  "end": 118
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۵: آزاد",
  "position": 2,
  "start": 120,
  "end": 121
 },
 {
  "chapter": "فصل ۷: ادبیات داستانی",
  "title": "درس ۱۶: خسرو",
  "position": 3,
  "start": 122,
  "end": 129
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۷: سپیده‌دم",
  "position": 1,
  "start": 135,
  "end": 140
 },
 {
  "chapter": "فصل ۸: ادبیات جهان",
  "title": "درس ۱۸: عظمت نگاه",
  "position": 2,
  "start": 142,
  "end": 145
 }
]$fixes$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer)),
fields as (select unnest(array['mathematics','experimental_sciences','humanities']) field),
corrected as (
 update private.planner_topic_bank b set page_start=f.start,page_end=f."end",revision=b.revision+1,updated_at=now()
 from fixes f cross join fields c cross join installed
 where b.id=md5('nova:planner:1405:v1:'||c.field||':10:final_exam:فارسی ۱:'||f.chapter||':'||f.position)::uuid
 and b.edition='1405' and b.study_field=c.field and b.grade='10' and b.preparation_track='final_exam'
 and b.subject='فارسی ۱' and b.chapter=f.chapter and b.title=f.title and b.position=f.position
 and b.page_start is null and b.page_end is null and b.revision=1
 returning b.id
)
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v210:'||c.field||':10:final_exam:فارسی ۱:'||p.chapter||':'||p.position)::uuid,
 '1405',c.field,'10','final_exam','فارسی ۱',p.chapter,p.title,p.start,p."end",p.position
from topics p cross join fields c cross join installed on conflict(id) do nothing;
