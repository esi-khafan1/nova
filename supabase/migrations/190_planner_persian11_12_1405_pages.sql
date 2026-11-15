-- Persian 111201 and 112201, user-supplied 1405 books; printed pages.
-- The 134 seed has page ranges on original lessons. Additional selections are one-time installed;
-- old rows and published snapshots are not altered.
with installed as (insert into private.planner_seed_installations(seed_key) values ('persian11-12-1405-v190') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 300,
    "title": "درس ۱: نیکی — متن درس",
    "start": 12,
    "end": 13
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 301,
    "title": "درس ۱: نیکی — کارگاه متن‌پژوهی",
    "start": 14,
    "end": 15
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 302,
    "title": "درس ۱: نیکی — قلمرو زبانی",
    "start": 14,
    "end": 15
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 303,
    "title": "درس ۱: نیکی — قلمرو ادبی",
    "start": 15,
    "end": 15
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 304,
    "title": "درس ۱: نیکی — قلمرو فکری",
    "start": 15,
    "end": 15
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 305,
    "title": "درس ۲: قاضی بست — متن درس",
    "start": 17,
    "end": 20
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 306,
    "title": "درس ۲: قاضی بست — کارگاه متن‌پژوهی",
    "start": 21,
    "end": 23
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 307,
    "title": "درس ۲: قاضی بست — قلمرو زبانی",
    "start": 21,
    "end": 22
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 308,
    "title": "درس ۲: قاضی بست — قلمرو ادبی",
    "start": 22,
    "end": 23
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 309,
    "title": "درس ۲: قاضی بست — قلمرو فکری",
    "start": 23,
    "end": 23
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 300,
    "title": "درس ۳: در امواج سند — متن درس",
    "start": 28,
    "end": 30
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 301,
    "title": "درس ۳: در امواج سند — کارگاه متن‌پژوهی",
    "start": 31,
    "end": 32
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 302,
    "title": "درس ۳: در امواج سند — قلمرو زبانی",
    "start": 31,
    "end": 31
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 303,
    "title": "درس ۳: در امواج سند — قلمرو ادبی",
    "start": 31,
    "end": 32
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 304,
    "title": "درس ۳: در امواج سند — قلمرو فکری",
    "start": 32,
    "end": 32
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 305,
    "title": "درس ۴: آزاد — درس آزاد",
    "start": 34,
    "end": 35
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 306,
    "title": "درس ۵: آغازگری تنها — متن درس",
    "start": 38,
    "end": 42
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 307,
    "title": "درس ۵: آغازگری تنها — کارگاه متن‌پژوهی",
    "start": 43,
    "end": 44
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 308,
    "title": "درس ۵: آغازگری تنها — قلمرو زبانی",
    "start": 43,
    "end": 44
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 309,
    "title": "درس ۵: آغازگری تنها — قلمرو ادبی",
    "start": 44,
    "end": 44
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 310,
    "title": "درس ۵: آغازگری تنها — قلمرو فکری",
    "start": 44,
    "end": 44
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 300,
    "title": "درس ۶: پرورده عشق — متن درس",
    "start": 52,
    "end": 53
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 301,
    "title": "درس ۶: پرورده عشق — کارگاه متن‌پژوهی",
    "start": 54,
    "end": 55
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 302,
    "title": "درس ۶: پرورده عشق — قلمرو زبانی",
    "start": 54,
    "end": 54
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 303,
    "title": "درس ۶: پرورده عشق — قلمرو ادبی",
    "start": 54,
    "end": 55
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 304,
    "title": "درس ۶: پرورده عشق — قلمرو فکری",
    "start": 55,
    "end": 55
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 305,
    "title": "درس ۷: باران محبت — متن درس",
    "start": 57,
    "end": 59
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 306,
    "title": "درس ۷: باران محبت — کارگاه متن‌پژوهی",
    "start": 60,
    "end": 62
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 307,
    "title": "درس ۷: باران محبت — قلمرو زبانی",
    "start": 60,
    "end": 61
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 308,
    "title": "درس ۷: باران محبت — قلمرو ادبی",
    "start": 61,
    "end": 61
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 309,
    "title": "درس ۷: باران محبت — قلمرو فکری",
    "start": 61,
    "end": 62
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 300,
    "title": "درس ۸: در کوی عاشقان — متن درس",
    "start": 66,
    "end": 71
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 301,
    "title": "درس ۸: در کوی عاشقان — کارگاه متن‌پژوهی",
    "start": 72,
    "end": 73
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 302,
    "title": "درس ۸: در کوی عاشقان — قلمرو زبانی",
    "start": 72,
    "end": 72
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 303,
    "title": "درس ۸: در کوی عاشقان — قلمرو ادبی",
    "start": 72,
    "end": 73
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 304,
    "title": "درس ۸: در کوی عاشقان — قلمرو فکری",
    "start": 73,
    "end": 73
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 305,
    "title": "درس ۹: ذوق لطیف — متن درس",
    "start": 75,
    "end": 78
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 306,
    "title": "درس ۹: ذوق لطیف — کارگاه متن‌پژوهی",
    "start": 79,
    "end": 80
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 307,
    "title": "درس ۹: ذوق لطیف — قلمرو زبانی",
    "start": 79,
    "end": 79
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 308,
    "title": "درس ۹: ذوق لطیف — قلمرو ادبی",
    "start": 79,
    "end": 80
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 309,
    "title": "درس ۹: ذوق لطیف — قلمرو فکری",
    "start": 80,
    "end": 80
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 300,
    "title": "درس ۱۰: بانگ جرس — متن درس",
    "start": 86,
    "end": 87
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 301,
    "title": "درس ۱۰: بانگ جرس — کارگاه متن‌پژوهی",
    "start": 88,
    "end": 89
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 302,
    "title": "درس ۱۰: بانگ جرس — قلمرو زبانی",
    "start": 88,
    "end": 88
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 303,
    "title": "درس ۱۰: بانگ جرس — قلمرو ادبی",
    "start": 88,
    "end": 89
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 304,
    "title": "درس ۱۰: بانگ جرس — قلمرو فکری",
    "start": 89,
    "end": 89
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 305,
    "title": "درس ۱۱: یاران عاشق — متن درس",
    "start": 91,
    "end": 91
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 306,
    "title": "درس ۱۱: یاران عاشق — کارگاه متن‌پژوهی",
    "start": 92,
    "end": 94
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 307,
    "title": "درس ۱۱: یاران عاشق — قلمرو زبانی",
    "start": 92,
    "end": 93
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 308,
    "title": "درس ۱۱: یاران عاشق — قلمرو ادبی",
    "start": 93,
    "end": 94
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 309,
    "title": "درس ۱۱: یاران عاشق — قلمرو فکری",
    "start": 94,
    "end": 94
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 300,
    "title": "درس ۱۲: کاوه دادخواه — متن درس",
    "start": 98,
    "end": 103
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 301,
    "title": "درس ۱۲: کاوه دادخواه — کارگاه متن‌پژوهی",
    "start": 104,
    "end": 105
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 302,
    "title": "درس ۱۲: کاوه دادخواه — قلمرو زبانی",
    "start": 104,
    "end": 105
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 303,
    "title": "درس ۱۲: کاوه دادخواه — قلمرو ادبی",
    "start": 105,
    "end": 105
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 304,
    "title": "درس ۱۲: کاوه دادخواه — قلمرو فکری",
    "start": 105,
    "end": 105
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 305,
    "title": "درس ۱۳: آزاد — نگارش درس بومی",
    "start": 107,
    "end": 108
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 306,
    "title": "درس ۱۳: آزاد — کارگاه متن‌پژوهی",
    "start": 109,
    "end": 109
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 307,
    "title": "درس ۱۳: آزاد — قلمرو زبانی",
    "start": 109,
    "end": 109
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 308,
    "title": "درس ۱۳: آزاد — قلمرو ادبی",
    "start": 109,
    "end": 109
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 309,
    "title": "درس ۱۳: آزاد — قلمرو فکری",
    "start": 109,
    "end": 109
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 310,
    "title": "درس ۱۴: حمله حیدری — متن درس",
    "start": 110,
    "end": 112
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 311,
    "title": "درس ۱۴: حمله حیدری — کارگاه متن‌پژوهی",
    "start": 113,
    "end": 114
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 312,
    "title": "درس ۱۴: حمله حیدری — قلمرو زبانی",
    "start": 113,
    "end": 113
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 313,
    "title": "درس ۱۴: حمله حیدری — قلمرو ادبی",
    "start": 113,
    "end": 114
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 314,
    "title": "درس ۱۴: حمله حیدری — قلمرو فکری",
    "start": 114,
    "end": 114
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 300,
    "title": "درس ۱۵: کبوتر طوق‌دار — متن درس",
    "start": 118,
    "end": 120
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 301,
    "title": "درس ۱۵: کبوتر طوق‌دار — کارگاه متن‌پژوهی",
    "start": 121,
    "end": 122
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 302,
    "title": "درس ۱۵: کبوتر طوق‌دار — قلمرو زبانی",
    "start": 121,
    "end": 121
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 303,
    "title": "درس ۱۵: کبوتر طوق‌دار — قلمرو ادبی",
    "start": 121,
    "end": 122
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 304,
    "title": "درس ۱۵: کبوتر طوق‌دار — قلمرو فکری",
    "start": 122,
    "end": 122
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 305,
    "title": "درس ۱۶: قصه عینکم — متن درس",
    "start": 124,
    "end": 129
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 306,
    "title": "درس ۱۶: قصه عینکم — کارگاه متن‌پژوهی",
    "start": 130,
    "end": 131
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 307,
    "title": "درس ۱۶: قصه عینکم — قلمرو زبانی",
    "start": 130,
    "end": 131
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 308,
    "title": "درس ۱۶: قصه عینکم — قلمرو ادبی",
    "start": 131,
    "end": 131
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 309,
    "title": "درس ۱۶: قصه عینکم — قلمرو فکری",
    "start": 131,
    "end": 131
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 300,
    "title": "درس ۱۷: خاموشی دریا — متن درس",
    "start": 140,
    "end": 141
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 301,
    "title": "درس ۱۷: خاموشی دریا — کارگاه متن‌پژوهی",
    "start": 142,
    "end": 143
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 302,
    "title": "درس ۱۷: خاموشی دریا — قلمرو زبانی",
    "start": 142,
    "end": 143
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 303,
    "title": "درس ۱۷: خاموشی دریا — قلمرو ادبی",
    "start": 143,
    "end": 143
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 304,
    "title": "درس ۱۷: خاموشی دریا — قلمرو فکری",
    "start": 143,
    "end": 143
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 305,
    "title": "درس ۱۸: خوان عدل — متن درس",
    "start": 145,
    "end": 146
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 306,
    "title": "درس ۱۸: خوان عدل — کارگاه متن‌پژوهی",
    "start": 147,
    "end": 148
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 307,
    "title": "درس ۱۸: خوان عدل — قلمرو زبانی",
    "start": 147,
    "end": 147
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 308,
    "title": "درس ۱۸: خوان عدل — قلمرو ادبی",
    "start": 147,
    "end": 148
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 309,
    "title": "درس ۱۸: خوان عدل — قلمرو فکری",
    "start": 148,
    "end": 148
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 310,
    "title": "گنج حکمت: همت",
    "start": 16,
    "end": 16
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 311,
    "title": "شعرخوانی: زاغ و کبک",
    "start": 24,
    "end": 25
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 311,
    "title": "گنج حکمت: چو سرو باش",
    "start": 33,
    "end": 33
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 312,
    "title": "واژه‌های فارسی در عربی",
    "start": 36,
    "end": 37
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 313,
    "title": "روان‌خوانی: تا غزل بعد",
    "start": 45,
    "end": 49
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 310,
    "title": "گنج حکمت: مردان واقعی",
    "start": 56,
    "end": 56
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 311,
    "title": "شعرخوانی: آفتاب حسن",
    "start": 63,
    "end": 63
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 310,
    "title": "گنج حکمت: چنان باش",
    "start": 74,
    "end": 74
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 311,
    "title": "روان‌خوانی: میثاق دوستی",
    "start": 81,
    "end": 84
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 310,
    "title": "گنج حکمت: به یاد ۲۲ بهمن",
    "start": 90,
    "end": 90
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 311,
    "title": "شعرخوانی: صبح بی‌تو",
    "start": 95,
    "end": 95
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 315,
    "title": "گنج حکمت: کاردانی",
    "start": 106,
    "end": 106
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 316,
    "title": "شعرخوانی: وطن",
    "start": 115,
    "end": 115
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 310,
    "title": "گنج حکمت: مهمان ناخوانده",
    "start": 123,
    "end": 123
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 311,
    "title": "روان‌خوانی: دیدار",
    "start": 132,
    "end": 137
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 310,
    "title": "گنج حکمت: تجسم عشق",
    "start": 144,
    "end": 144
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 311,
    "title": "روان‌خوانی: آذرباد",
    "start": 149,
    "end": 154
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 300,
    "title": "درس ۱: شکر نعمت — متن درس",
    "start": 12,
    "end": 14
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 301,
    "title": "درس ۱: شکر نعمت — کارگاه متن‌پژوهی",
    "start": 15,
    "end": 17
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 302,
    "title": "درس ۱: شکر نعمت — قلمرو زبانی",
    "start": 15,
    "end": 16
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 303,
    "title": "درس ۱: شکر نعمت — قلمرو ادبی",
    "start": 16,
    "end": 16
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 304,
    "title": "درس ۱: شکر نعمت — قلمرو فکری",
    "start": 16,
    "end": 17
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 305,
    "title": "درس ۲: مست و هشیار — متن درس",
    "start": 19,
    "end": 19
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 306,
    "title": "درس ۲: مست و هشیار — کارگاه متن‌پژوهی",
    "start": 20,
    "end": 21
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 307,
    "title": "درس ۲: مست و هشیار — قلمرو زبانی",
    "start": 20,
    "end": 20
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 308,
    "title": "درس ۲: مست و هشیار — قلمرو ادبی",
    "start": 20,
    "end": 21
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 309,
    "title": "درس ۲: مست و هشیار — قلمرو فکری",
    "start": 21,
    "end": 21
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 300,
    "title": "درس ۳: آزادی — متن درس",
    "start": 26,
    "end": 27
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 301,
    "title": "درس ۳: آزادی — کارگاه متن‌پژوهی",
    "start": 28,
    "end": 29
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 302,
    "title": "درس ۳: آزادی — قلمرو زبانی",
    "start": 28,
    "end": 28
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 303,
    "title": "درس ۳: آزادی — قلمرو ادبی",
    "start": 28,
    "end": 28
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 304,
    "title": "درس ۳: آزادی — قلمرو فکری",
    "start": 28,
    "end": 29
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 305,
    "title": "درس ۴: آزاد — نگارش درس بومی",
    "start": 32,
    "end": 32
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 306,
    "title": "درس ۴: آزاد — کارگاه متن‌پژوهی",
    "start": 33,
    "end": 33
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 307,
    "title": "درس ۴: آزاد — قلمرو زبانی",
    "start": 33,
    "end": 33
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 308,
    "title": "درس ۴: آزاد — قلمرو ادبی",
    "start": 33,
    "end": 33
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 309,
    "title": "درس ۴: آزاد — قلمرو فکری",
    "start": 33,
    "end": 33
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 310,
    "title": "درس ۵: دماوندیه — متن درس",
    "start": 36,
    "end": 37
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 311,
    "title": "درس ۵: دماوندیه — کارگاه متن‌پژوهی",
    "start": 38,
    "end": 39
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 312,
    "title": "درس ۵: دماوندیه — قلمرو زبانی",
    "start": 38,
    "end": 38
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 313,
    "title": "درس ۵: دماوندیه — قلمرو ادبی",
    "start": 38,
    "end": 39
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 314,
    "title": "درس ۵: دماوندیه — قلمرو فکری",
    "start": 39,
    "end": 39
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 300,
    "title": "درس ۶: نی‌نامه — متن درس",
    "start": 48,
    "end": 49
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 301,
    "title": "درس ۶: نی‌نامه — کارگاه متن‌پژوهی",
    "start": 50,
    "end": 52
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 302,
    "title": "درس ۶: نی‌نامه — قلمرو زبانی",
    "start": 50,
    "end": 50
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 303,
    "title": "درس ۶: نی‌نامه — قلمرو ادبی",
    "start": 50,
    "end": 51
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 304,
    "title": "درس ۶: نی‌نامه — قلمرو فکری",
    "start": 51,
    "end": 52
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 305,
    "title": "درس ۷: در حقیقت عشق — متن درس",
    "start": 54,
    "end": 55
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 306,
    "title": "درس ۷: در حقیقت عشق — کارگاه متن‌پژوهی",
    "start": 56,
    "end": 58
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 307,
    "title": "درس ۷: در حقیقت عشق — قلمرو زبانی",
    "start": 56,
    "end": 57
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 308,
    "title": "درس ۷: در حقیقت عشق — قلمرو ادبی",
    "start": 57,
    "end": 58
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 309,
    "title": "درس ۷: در حقیقت عشق — قلمرو فکری",
    "start": 58,
    "end": 58
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 300,
    "title": "درس ۸: از پاریز تا پاریس — متن درس",
    "start": 62,
    "end": 66
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 301,
    "title": "درس ۸: از پاریز تا پاریس — کارگاه متن‌پژوهی",
    "start": 67,
    "end": 70
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 302,
    "title": "درس ۸: از پاریز تا پاریس — قلمرو زبانی",
    "start": 67,
    "end": 69
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 303,
    "title": "درس ۸: از پاریز تا پاریس — قلمرو ادبی",
    "start": 69,
    "end": 70
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 304,
    "title": "درس ۸: از پاریز تا پاریس — قلمرو فکری",
    "start": 70,
    "end": 70
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 305,
    "title": "درس ۹: کویر — متن درس",
    "start": 72,
    "end": 75
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 306,
    "title": "درس ۹: کویر — کارگاه متن‌پژوهی",
    "start": 76,
    "end": 78
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 307,
    "title": "درس ۹: کویر — قلمرو زبانی",
    "start": 76,
    "end": 77
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 308,
    "title": "درس ۹: کویر — قلمرو ادبی",
    "start": 77,
    "end": 78
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 309,
    "title": "درس ۹: کویر — قلمرو فکری",
    "start": 78,
    "end": 78
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 300,
    "title": "درس ۱۰: فصل شکوفایی — متن درس",
    "start": 86,
    "end": 87
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 301,
    "title": "درس ۱۰: فصل شکوفایی — کارگاه متن‌پژوهی",
    "start": 88,
    "end": 88
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 302,
    "title": "درس ۱۰: فصل شکوفایی — قلمرو زبانی",
    "start": 88,
    "end": 88
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 303,
    "title": "درس ۱۰: فصل شکوفایی — قلمرو ادبی",
    "start": 88,
    "end": 88
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 304,
    "title": "درس ۱۰: فصل شکوفایی — قلمرو فکری",
    "start": 88,
    "end": 88
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 305,
    "title": "درس ۱۱: آن شب عزیز — متن درس",
    "start": 90,
    "end": 95
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 306,
    "title": "درس ۱۱: آن شب عزیز — کارگاه متن‌پژوهی",
    "start": 96,
    "end": 97
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 307,
    "title": "درس ۱۱: آن شب عزیز — قلمرو زبانی",
    "start": 96,
    "end": 96
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 308,
    "title": "درس ۱۱: آن شب عزیز — قلمرو ادبی",
    "start": 96,
    "end": 97
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 309,
    "title": "درس ۱۱: آن شب عزیز — قلمرو فکری",
    "start": 97,
    "end": 97
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 300,
    "title": "درس ۱۲: گذر سیاوش از آتش — متن درس",
    "start": 102,
    "end": 106
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 301,
    "title": "درس ۱۲: گذر سیاوش از آتش — کارگاه متن‌پژوهی",
    "start": 107,
    "end": 109
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 302,
    "title": "درس ۱۲: گذر سیاوش از آتش — قلمرو زبانی",
    "start": 107,
    "end": 108
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 303,
    "title": "درس ۱۲: گذر سیاوش از آتش — قلمرو ادبی",
    "start": 108,
    "end": 108
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 304,
    "title": "درس ۱۲: گذر سیاوش از آتش — قلمرو فکری",
    "start": 108,
    "end": 109
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 305,
    "title": "درس ۱۳: خوان هشتم — متن درس",
    "start": 111,
    "end": 116
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 306,
    "title": "درس ۱۳: خوان هشتم — کارگاه متن‌پژوهی",
    "start": 117,
    "end": 118
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 307,
    "title": "درس ۱۳: خوان هشتم — قلمرو زبانی",
    "start": 117,
    "end": 117
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 308,
    "title": "درس ۱۳: خوان هشتم — قلمرو ادبی",
    "start": 117,
    "end": 118
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 309,
    "title": "درس ۱۳: خوان هشتم — قلمرو فکری",
    "start": 118,
    "end": 118
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 300,
    "title": "درس ۱۴: سی مرغ و سیمرغ — متن درس",
    "start": 122,
    "end": 127
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 301,
    "title": "درس ۱۴: سی مرغ و سیمرغ — کارگاه متن‌پژوهی",
    "start": 128,
    "end": 129
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 302,
    "title": "درس ۱۴: سی مرغ و سیمرغ — قلمرو زبانی",
    "start": 128,
    "end": 128
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 303,
    "title": "درس ۱۴: سی مرغ و سیمرغ — قلمرو ادبی",
    "start": 128,
    "end": 129
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 304,
    "title": "درس ۱۴: سی مرغ و سیمرغ — قلمرو فکری",
    "start": 129,
    "end": 129
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 305,
    "title": "درس ۱۵: آزاد — نگارش درس بومی",
    "start": 131,
    "end": 132
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 306,
    "title": "درس ۱۵: آزاد — کارگاه متن‌پژوهی",
    "start": 133,
    "end": 133
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 307,
    "title": "درس ۱۵: آزاد — قلمرو زبانی",
    "start": 133,
    "end": 133
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 308,
    "title": "درس ۱۵: آزاد — قلمرو ادبی",
    "start": 133,
    "end": 133
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 309,
    "title": "درس ۱۵: آزاد — قلمرو فکری",
    "start": 133,
    "end": 133
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 310,
    "title": "درس ۱۶: کباب غاز — متن درس",
    "start": 134,
    "end": 142
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 311,
    "title": "درس ۱۶: کباب غاز — کارگاه متن‌پژوهی",
    "start": 143,
    "end": 144
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 312,
    "title": "درس ۱۶: کباب غاز — قلمرو زبانی",
    "start": 143,
    "end": 144
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 313,
    "title": "درس ۱۶: کباب غاز — قلمرو ادبی",
    "start": 144,
    "end": 144
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 314,
    "title": "درس ۱۶: کباب غاز — قلمرو فکری",
    "start": 144,
    "end": 144
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 300,
    "title": "درس ۱۷: خنده تو — متن درس",
    "start": 152,
    "end": 153
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 301,
    "title": "درس ۱۷: خنده تو — کارگاه متن‌پژوهی",
    "start": 154,
    "end": 155
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 302,
    "title": "درس ۱۷: خنده تو — قلمرو زبانی",
    "start": 154,
    "end": 154
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 303,
    "title": "درس ۱۷: خنده تو — قلمرو ادبی",
    "start": 154,
    "end": 155
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 304,
    "title": "درس ۱۷: خنده تو — قلمرو فکری",
    "start": 155,
    "end": 155
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 305,
    "title": "درس ۱۸: عشق جاودانی — متن درس",
    "start": 157,
    "end": 157
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 306,
    "title": "درس ۱۸: عشق جاودانی — کارگاه متن‌پژوهی",
    "start": 158,
    "end": 158
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 307,
    "title": "درس ۱۸: عشق جاودانی — قلمرو زبانی",
    "start": 158,
    "end": 158
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 308,
    "title": "درس ۱۸: عشق جاودانی — قلمرو ادبی",
    "start": 158,
    "end": 158
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 309,
    "title": "درس ۱۸: عشق جاودانی — قلمرو فکری",
    "start": 158,
    "end": 158
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 310,
    "title": "گنج حکمت: گمان",
    "start": 18,
    "end": 18
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 311,
    "title": "شعرخوانی: در مکتب حقایق",
    "start": 22,
    "end": 23
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 315,
    "title": "گنج حکمت: خاکریز",
    "start": 30,
    "end": 31
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 316,
    "title": "واژه‌های فارسی",
    "start": 34,
    "end": 35
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۲: ادبیات پایداری",
    "position": 317,
    "title": "روان‌خوانی: جاسوسی که الاغ بود",
    "start": 40,
    "end": 45
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 310,
    "title": "گنج حکمت: آفتاب جمال حق",
    "start": 53,
    "end": 53
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۳: ادبیات غنایی",
    "position": 311,
    "title": "شعرخوانی: صبح ستاره‌باران",
    "start": 59,
    "end": 59
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 310,
    "title": "گنج حکمت: سه مرکب زندگی",
    "start": 71,
    "end": 71
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۴: ادبیات سفر و زندگی",
    "position": 311,
    "title": "روان‌خوانی: بوی جوی مولیان",
    "start": 79,
    "end": 83
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 310,
    "title": "گنج حکمت: تیرانا",
    "start": 89,
    "end": 89
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۵: ادبیات انقلاب اسلامی",
    "position": 311,
    "title": "شعرخوانی: شکوه چشمان تو",
    "start": 98,
    "end": 99
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 310,
    "title": "گنج حکمت: به جوانمردی کوش",
    "start": 110,
    "end": 110
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۶: ادبیات حماسی",
    "position": 311,
    "title": "شعرخوانی: ای میهن",
    "start": 119,
    "end": 119
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 315,
    "title": "گنج حکمت: کلان‌تر و اولی‌تر",
    "start": 130,
    "end": 130
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۷: ادبیات داستانی",
    "position": 316,
    "title": "روان‌خوانی: ارمیا",
    "start": 145,
    "end": 149
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 310,
    "title": "گنج حکمت: مسافر",
    "start": 156,
    "end": 156
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 311,
    "title": "روان‌خوانی: آخرین درس",
    "start": 159,
    "end": 164
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 312,
    "title": "ستایش: لطف خدا",
    "start": 10,
    "end": 10
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 312,
    "title": "نیایش: الهی",
    "start": 155,
    "end": 155
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 313,
    "title": "واژه‌نامه",
    "start": 157,
    "end": 166
  },
  {
    "grade": "11",
    "subject": "فارسی ۲",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 314,
    "title": "کتابنامه",
    "start": 167,
    "end": 167
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۱: ادبیات تعلیمی",
    "position": 312,
    "title": "ستایش: ملکا ذکر تو گویم",
    "start": 10,
    "end": 10
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 312,
    "title": "نیایش: لطف تو",
    "start": 165,
    "end": 165
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 313,
    "title": "واژه‌نامه",
    "start": 167,
    "end": 179
  },
  {
    "grade": "12",
    "subject": "فارسی ۳",
    "chapter": "فصل ۸: ادبیات جهان",
    "position": 314,
    "title": "کتابنامه",
    "start": 181,
    "end": 183
  }
]$topics$::jsonb) as p(grade text,subject text,chapter text,position integer,title text,start integer,"end" integer)),
fields(field) as (values ('humanities'),('mathematics'),('experimental_sciences'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v190:'||f.field||':'||p.grade||':final_exam:'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',f.field,p.grade,'final_exam',p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join fields f cross join installed on conflict(id) do nothing;
