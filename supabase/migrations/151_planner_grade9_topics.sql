-- Ninth-grade books, 1405: verified lesson spans and session groupings.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "9",
  "subject": "مطالعات اجتماعی",
  "fields": [
   "all"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: سیاره ما، زمین",
    "topics": [
     {
      "title": "درس ۱: زمین، مهد زیبای انسان‌ها",
      "start": 2,
      "end": 8
     },
     {
      "title": "درس ۲: حرکات زمین",
      "start": 9,
      "end": 14
     }
    ]
   },
   {
    "chapter": "فصل ۲: سنگ‌کره، آب‌کره، هواکره",
    "topics": [
     {
      "title": "درس ۳: چهره زمین",
      "start": 16,
      "end": 20
     },
     {
      "title": "درس ۴: آب فراوان، هوای پاک",
      "start": 21,
      "end": 28
     }
    ]
   },
   {
    "chapter": "فصل ۳: زیست‌کره، تنوع شگفت‌انگیز",
    "topics": [
     {
      "title": "درس ۵: پراکندگی زیست‌بوم‌های جهان",
      "start": 30,
      "end": 35
     },
     {
      "title": "درس ۶: زیست‌بوم‌ها در خطرند",
      "start": 36,
      "end": 40
     }
    ]
   },
   {
    "chapter": "فصل ۴: ساکنان سیاره زمین",
    "topics": [
     {
      "title": "درس ۷: جمعیت جهان"
     },
     {
      "title": "درس ۸: بی‌عدالتی و نابرابری در جهان"
     }
    ]
   },
   {
    "chapter": "فصل ۵: عصر یکپارچگی و شکوفایی",
    "topics": [
     {
      "title": "درس ۹: ایرانی متحد و یکپارچه",
      "start": 54,
      "end": 59
     },
     {
      "title": "درس ۱۰: اوضاع اجتماعی، اقتصادی، علمی و فرهنگی ایران در عصر صفوی",
      "start": 60,
      "end": 66
     }
    ]
   },
   {
    "chapter": "فصل ۶: ایران از عهد نادرشاه تا ناصرالدین شاه",
    "topics": [
     {
      "title": "درس ۱۱: تلاش برای حفظ استقلال و اتحاد سیاسی ایران",
      "start": 68,
      "end": 73
     },
     {
      "title": "درس ۱۲: در جست‌وجوی پیشرفت و رهایی از سلطه خارجی",
      "start": 74,
      "end": 80
     }
    ]
   },
   {
    "chapter": "فصل ۷: ایران در عصر مشروطه",
    "topics": [
     {
      "title": "درس ۱۳: نهضت مشروطه"
     },
     {
      "title": "درس ۱۴: ایران در دوران حکومت پهلوی"
     }
    ]
   },
   {
    "chapter": "فصل ۸: سقوط حکومت شاهنشاهی و شکل‌گیری نظام جمهوری اسلامی",
    "topics": [
     {
      "title": "درس ۱۵: انقلاب اسلامی ایران"
     },
     {
      "title": "درس ۱۶: ایران در دوران پس از پیروزی انقلاب اسلامی"
     }
    ]
   },
   {
    "chapter": "فصل ۹: فرهنگ و هویت",
    "topics": [
     {
      "title": "درس ۱۷: فرهنگ",
      "start": 118,
      "end": 123
     },
     {
      "title": "درس ۱۸: هویت",
      "start": 124,
      "end": 130
     }
    ]
   },
   {
    "chapter": "فصل ۱۰: خانواده و جامعه",
    "topics": [
     {
      "title": "درس ۱۹: ارزش‌ها و کارکردهای خانواده",
      "start": 132,
      "end": 135
     },
     {
      "title": "درس ۲۰: آرامش در خانواده",
      "start": 136,
      "end": 142
     }
    ]
   },
   {
    "chapter": "فصل ۱۱: حکومت و مردم",
    "topics": [
     {
      "title": "درس ۲۱: نهاد حکومت",
      "start": 144,
      "end": 149
     },
     {
      "title": "درس ۲۲: حقوق و تکالیف شهروندی",
      "start": 150,
      "end": 156
     }
    ]
   },
   {
    "chapter": "فصل ۱۲: بهره‌وری",
    "topics": [
     {
      "title": "درس ۲۳: بهره‌وری چیست؟"
     },
     {
      "title": "درس ۲۴: اقتصاد و بهره‌وری"
     }
    ]
   }
  ]
 },
 {
  "grade": "9",
  "subject": "عربی",
  "fields": [
   "all"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس ۱",
    "topics": [
     {
      "title": "متن و واژگان: مراجعة دروس الصف السابع و الثامن"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "متن و واژگان: العبور الآمن"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "متن و واژگان: جسر الصداقة"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "متن و واژگان: الصبر مفتاح الفرج"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "متن و واژگان: الرجاء"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "متن و واژگان: تغییر الحیاة"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "متن و واژگان: ثمرة الجد"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "متن و واژگان: حوار بین الزائر و سائق سیارة الأجرة"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "متن و واژگان: نصوص حول الصحة"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "متن و واژگان: رسالة الشهید سلیمانی"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   }
  ]
 },
 {
  "grade": "9",
  "subject": "آموزش قرآن",
  "fields": [
   "all"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس ۱",
    "topics": [
     {
      "title": "جلسه اول: سوره شوری"
     },
     {
      "title": "جلسه دوم: سوره زخرف"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "جلسه اول: سوره دخان"
     },
     {
      "title": "جلسه دوم: سوره جاثیه"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "جلسه اول: سوره احقاف"
     },
     {
      "title": "جلسه دوم: سوره محمد"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "جلسه اول: سوره فتح"
     },
     {
      "title": "جلسه دوم: سوره حجرات"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "جلسه اول: سوره ذاریات"
     },
     {
      "title": "جلسه دوم: سوره قمر"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "جلسه اول: سوره الرحمن"
     },
     {
      "title": "جلسه دوم: سوره واقعه"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "جلسه اول: سوره حدید"
     },
     {
      "title": "جلسه دوم: سوره حشر"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "جلسه اول: سوره صف"
     },
     {
      "title": "جلسه دوم: سوره جمعه"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "جلسه اول: سوره تغابن"
     },
     {
      "title": "جلسه دوم: سوره ملک"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "جلسه اول: سوره نوح"
     },
     {
      "title": "جلسه دوم: سوره مزمل"
     }
    ]
   },
   {
    "chapter": "درس ۱۱",
    "topics": [
     {
      "title": "جلسه اول: سوره نبأ"
     },
     {
      "title": "جلسه دوم: سوره غاشیه"
     }
    ]
   }
  ]
 }
]$books$::jsonb)
 as b(grade text,subject text,fields jsonb,tracks jsonb,chapters jsonb)), expanded as (
 select b.grade,b.subject,f.field,t.track,c.item->>'chapter' chapter,topic.item->>'title' title,
 (topic.item->>'start')::integer page_start,(topic.item->>'end')::integer page_end,topic.ord::integer position
 from data b cross join lateral jsonb_array_elements_text(b.fields) f(field)
 cross join lateral jsonb_array_elements_text(b.tracks) t(track)
 cross join lateral jsonb_array_elements(b.chapters) c(item)
 cross join lateral jsonb_array_elements(c.item->'topics') with ordinality topic(item,ord)
)
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v1:' || field || ':' || grade || ':' || track || ':' || subject || ':' || chapter || ':' || position)::uuid,
 '1405',field,grade,track,subject,chapter,title,page_start,page_end,position from expanded
on conflict (id) do nothing;
