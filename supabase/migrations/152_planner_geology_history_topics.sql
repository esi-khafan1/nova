-- Geology study groupings and history whole-lesson entries; unverified pages are null.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "11",
  "subject": "زمین‌شناسی",
  "fields": [
   "experimental_sciences"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: آفرینش کیهان و تکوین زمین",
    "topics": [
     {
      "title": "آفرینش کیهان و تشکیل عناصر"
     },
     {
      "title": "کهکشان راه شیری و سامانه خورشیدی"
     },
     {
      "title": "تکوین زمین و آغاز زندگی در آن"
     },
     {
      "title": "سن زمین و زمان در زمین‌شناسی"
     },
     {
      "title": "تغییرات آب و هوایی"
     }
    ]
   },
   {
    "chapter": "فصل ۲: منابع معدنی و ذخایر انرژی، زیربنای تمدن و توسعه",
    "topics": [
     {
      "title": "منابع معدنی در زندگی و غلظت عناصر در پوسته زمین"
     },
     {
      "title": "کانی‌های سیلیکاتی و سری واکنش بوون"
     },
     {
      "title": "کانه، کانسنگ و طبقه‌بندی کانسنگ‌ها"
     },
     {
      "title": "اکتشاف، استخراج و فراوری ماده معدنی"
     },
     {
      "title": "گوهرها و کانی‌ها"
     },
     {
      "title": "سوخت‌های فسیلی"
     }
    ]
   },
   {
    "chapter": "فصل ۳: منابع آب و خاک",
    "topics": [
     {
      "title": "آب جاری"
     },
     {
      "title": "آب زیرزمینی و فرونشست زمین"
     },
     {
      "title": "منابع خاک و فرسایش"
     }
    ]
   },
   {
    "chapter": "فصل ۴: پویایی زمین",
    "topics": [
     {
      "title": "چرخه ویلسون"
     },
     {
      "title": "تنش، موقعیت لایه‌ها و شکستگی‌ها"
     },
     {
      "title": "چین‌خوردگی"
     },
     {
      "title": "آتشفشان و فواید آن"
     },
     {
      "title": "زمین‌لرزه و امواج لرزه‌ای"
     },
     {
      "title": "اندازه‌گیری، پیش‌بینی و ایمنی در برابر زمین‌لرزه"
     }
    ]
   },
   {
    "chapter": "فصل ۵: زمین‌شناسی و سلامت",
    "topics": [
     {
      "title": "زمین‌شناسی پزشکی و چرخه بیوژئوشیمیایی"
     },
     {
      "title": "تقسیم‌بندی بیوشیمیایی عناصر"
     },
     {
      "title": "منشأ بیماری‌های زمین‌زاد"
     },
     {
      "title": "توفان‌های گردوغبار و ریزگردها"
     },
     {
      "title": "کاربرد کانی‌ها در داروسازی و صنایع بهداشتی"
     }
    ]
   },
   {
    "chapter": "فصل ۶: زمین‌شناسی و سازه‌های مهندسی",
    "topics": [
     {
      "title": "مکان‌یابی سازه‌ها و عوامل مؤثر بر آن"
     },
     {
      "title": "مکان مناسب برای ساخت سد"
     },
     {
      "title": "مکان مناسب برای ساخت تونل و فضاهای زیرزمینی"
     },
     {
      "title": "مکان‌یابی سازه‌های دریایی"
     },
     {
      "title": "شاخص‌های مهندسی و مصالح موردنیاز سازه‌ها"
     }
    ]
   },
   {
    "chapter": "فصل ۷: زمین‌شناسی ایران",
    "topics": [
     {
      "title": "تاریخچه و نقشه‌های زمین‌شناسی ایران"
     },
     {
      "title": "پهنه‌های زمین‌شناسی ایران"
     },
     {
      "title": "منابع معدنی و ذخایر انرژی ایران"
     },
     {
      "title": "گسل‌ها و آتشفشان‌های ایران"
     },
     {
      "title": "زمین‌گردشگری و ژئوپارک"
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "زمین‌شناسی",
  "fields": [
   "mathematics"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: آفرینش کیهان و تکوین زمین",
    "topics": [
     {
      "title": "آفرینش کیهان و تشکیل عناصر"
     },
     {
      "title": "کهکشان راه شیری و سامانه خورشیدی"
     },
     {
      "title": "تکوین زمین و آغاز زندگی در آن"
     },
     {
      "title": "سن زمین و زمان در زمین‌شناسی"
     },
     {
      "title": "تغییرات آب و هوایی"
     }
    ]
   },
   {
    "chapter": "فصل ۲: منابع معدنی و ذخایر انرژی، زیربنای تمدن و توسعه",
    "topics": [
     {
      "title": "منابع معدنی در زندگی و غلظت عناصر در پوسته زمین"
     },
     {
      "title": "کانی‌های سیلیکاتی و سری واکنش بوون"
     },
     {
      "title": "کانه، کانسنگ و طبقه‌بندی کانسنگ‌ها"
     },
     {
      "title": "اکتشاف، استخراج و فراوری ماده معدنی"
     },
     {
      "title": "گوهرها و کانی‌ها"
     },
     {
      "title": "سوخت‌های فسیلی"
     }
    ]
   },
   {
    "chapter": "فصل ۳: منابع آب و خاک",
    "topics": [
     {
      "title": "آب جاری"
     },
     {
      "title": "آب زیرزمینی و فرونشست زمین"
     },
     {
      "title": "منابع خاک و فرسایش"
     }
    ]
   },
   {
    "chapter": "فصل ۴: پویایی زمین",
    "topics": [
     {
      "title": "چرخه ویلسون"
     },
     {
      "title": "تنش، موقعیت لایه‌ها و شکستگی‌ها"
     },
     {
      "title": "چین‌خوردگی"
     },
     {
      "title": "آتشفشان و فواید آن"
     },
     {
      "title": "زمین‌لرزه و امواج لرزه‌ای"
     },
     {
      "title": "اندازه‌گیری، پیش‌بینی و ایمنی در برابر زمین‌لرزه"
     }
    ]
   },
   {
    "chapter": "فصل ۵: زمین‌شناسی و سلامت",
    "topics": [
     {
      "title": "زمین‌شناسی پزشکی و چرخه بیوژئوشیمیایی"
     },
     {
      "title": "تقسیم‌بندی بیوشیمیایی عناصر"
     },
     {
      "title": "منشأ بیماری‌های زمین‌زاد"
     },
     {
      "title": "توفان‌های گردوغبار و ریزگردها"
     },
     {
      "title": "کاربرد کانی‌ها در داروسازی و صنایع بهداشتی"
     }
    ]
   },
   {
    "chapter": "فصل ۶: زمین‌شناسی و سازه‌های مهندسی",
    "topics": [
     {
      "title": "مکان‌یابی سازه‌ها و عوامل مؤثر بر آن"
     },
     {
      "title": "مکان مناسب برای ساخت سد"
     },
     {
      "title": "مکان مناسب برای ساخت تونل و فضاهای زیرزمینی"
     },
     {
      "title": "مکان‌یابی سازه‌های دریایی"
     },
     {
      "title": "شاخص‌های مهندسی و مصالح موردنیاز سازه‌ها"
     }
    ]
   },
   {
    "chapter": "فصل ۷: زمین‌شناسی ایران",
    "topics": [
     {
      "title": "تاریخچه و نقشه‌های زمین‌شناسی ایران"
     },
     {
      "title": "پهنه‌های زمین‌شناسی ایران"
     },
     {
      "title": "منابع معدنی و ذخایر انرژی ایران"
     },
     {
      "title": "گسل‌ها و آتشفشان‌های ایران"
     },
     {
      "title": "زمین‌گردشگری و ژئوپارک"
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "تاریخ ۱",
  "fields": [
   "humanities"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس ۱",
    "topics": [
     {
      "title": "کل درس: تاریخ و تاریخ‌نگاری",
      "start": 2,
      "end": 11
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "کل درس: تاریخ: زمان و مکان",
      "start": 12,
      "end": 19
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "کل درس: باستان‌شناسی: در جست‌وجوی میراث فرهنگی",
      "start": 20,
      "end": 28
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "کل درس: پیدایش تمدن: بین‌النهرین و مصر",
      "start": 30,
      "end": 41
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "کل درس: هند و چین",
      "start": 42,
      "end": 49
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "کل درس: یونان و روم",
      "start": 50,
      "end": 60
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "کل درس: مطالعه و کاوش در گذشته‌های دور",
      "start": 62,
      "end": 69
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "کل درس: سپیده‌دم تمدن ایرانی",
      "start": 70,
      "end": 79
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "کل درس: از ورود آریایی‌ها تا پایان هخامنشیان",
      "start": 80,
      "end": 89
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "کل درس: اشکانیان و ساسانیان",
      "start": 90,
      "end": 98
     }
    ]
   },
   {
    "chapter": "درس ۱۱",
    "topics": [
     {
      "title": "کل درس: آیین کشورداری",
      "start": 99,
      "end": 108
     }
    ]
   },
   {
    "chapter": "درس ۱۲",
    "topics": [
     {
      "title": "کل درس: جامعه و خانواده",
      "start": 109,
      "end": 117
     }
    ]
   },
   {
    "chapter": "درس ۱۳",
    "topics": [
     {
      "title": "کل درس: اقتصاد و معیشت"
     }
    ]
   },
   {
    "chapter": "درس ۱۴",
    "topics": [
     {
      "title": "کل درس: دین و اعتقادات"
     }
    ]
   },
   {
    "chapter": "درس ۱۵",
    "topics": [
     {
      "title": "کل درس: زبان، علم و آموزش",
      "start": 136,
      "end": 142
     }
    ]
   },
   {
    "chapter": "درس ۱۶",
    "topics": [
     {
      "title": "کل درس: هنر و معماری",
      "start": 143,
      "end": 152
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "تاریخ ۲",
  "fields": [
   "humanities"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس ۱",
    "topics": [
     {
      "title": "کل درس: منابع پژوهش در تاریخ اسلام و ایران دوران اسلامی",
      "start": 2,
      "end": 12
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "کل درس: روش پژوهش در تاریخ؛ بررسی و سنجش اعتبار شواهد و مدارک",
      "start": 13,
      "end": 18
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "کل درس: اسلام در مکه",
      "start": 20,
      "end": 30
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "کل درس: امت و حکومت نبوی در مدینه",
      "start": 31,
      "end": 43
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "کل درس: تثبیت و گسترش اسلام در دوران خلفای نخستین",
      "start": 44,
      "end": 55
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "کل درس: امویان بر مسند قدرت",
      "start": 56,
      "end": 68
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "کل درس: جهان اسلام در عصر خلافت عباسی",
      "start": 69,
      "end": 82
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "کل درس: اسلام در ایران؛ زمینه‌های ظهور تمدن اسلامی ـ ایرانی",
      "start": 84,
      "end": 94
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "کل درس: ظهور و گسترش تمدن ایرانی ـ اسلامی",
      "start": 95,
      "end": 108
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "کل درس: ایران در دوران غزنوی، سلجوقی و خوارزمشاهی",
      "start": 109,
      "end": 123
     }
    ]
   },
   {
    "chapter": "درس ۱۱",
    "topics": [
     {
      "title": "کل درس: حکومت، جامعه و اقتصاد در عصر مغول ـ تیموری",
      "start": 124,
      "end": 134
     }
    ]
   },
   {
    "chapter": "درس ۱۲",
    "topics": [
     {
      "title": "کل درس: فرهنگ و هنر در عصر مغول ـ تیموری",
      "start": 135,
      "end": 146
     }
    ]
   },
   {
    "chapter": "درس ۱۳",
    "topics": [
     {
      "title": "کل درس: تحولات سیاسی و اقتصادی ایران در دوره صفوی",
      "start": 147,
      "end": 161
     }
    ]
   },
   {
    "chapter": "درس ۱۴",
    "topics": [
     {
      "title": "کل درس: فرهنگ و تمدن در عصر صفوی",
      "start": 162,
      "end": 172
     }
    ]
   },
   {
    "chapter": "درس ۱۵",
    "topics": [
     {
      "title": "کل درس: قرون وسطا",
      "start": 174,
      "end": 187
     }
    ]
   },
   {
    "chapter": "درس ۱۶",
    "topics": [
     {
      "title": "کل درس: رنسانس و عصر جدید",
      "start": 188,
      "end": 201
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "تاریخ معاصر ایران",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس ۱",
    "topics": [
     {
      "title": "کل درس: حکومت قاجار از آقامحمدخان تا محمدشاه"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "کل درس: دوران ناصرالدین شاه"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "کل درس: زمینه‌های نهضت مشروطه"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "کل درس: آغاز حرکت مردم علیه استبداد داخلی و استعمار خارجی"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "کل درس: مشروطه در دوره محمدعلی شاه"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "کل درس: دوره دوم مشروطه"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "کل درس: کودتای ۱۲۹۹"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "کل درس: رضاخان؛ تثبیت قدرت"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "کل درس: ویژگی‌های حکومت رضاشاه"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "کل درس: سقوط رضاشاه"
     }
    ]
   },
   {
    "chapter": "درس ۱۱",
    "topics": [
     {
      "title": "کل درس: اشغال ایران توسط متفقین و آثار آن"
     }
    ]
   },
   {
    "chapter": "درس ۱۲",
    "topics": [
     {
      "title": "کل درس: نهضت ملی شدن صنعت نفت"
     }
    ]
   },
   {
    "chapter": "درس ۱۳",
    "topics": [
     {
      "title": "کل درس: زمینه‌های کودتای ۲۸ مرداد"
     }
    ]
   },
   {
    "chapter": "درس ۱۴",
    "topics": [
     {
      "title": "کل درس: کودتای بیست و هشتم مرداد"
     }
    ]
   },
   {
    "chapter": "درس ۱۵",
    "topics": [
     {
      "title": "کل درس: ربع قرن سیطره آمریکا بر ایران"
     }
    ]
   },
   {
    "chapter": "درس ۱۶",
    "topics": [
     {
      "title": "کل درس: زمینه‌ها و هدف‌های اصلاحات آمریکایی در ایران"
     }
    ]
   },
   {
    "chapter": "درس ۱۷",
    "topics": [
     {
      "title": "کل درس: پیدایش نهضت روحانیت و اوج‌گیری بیداری اسلامی"
     }
    ]
   },
   {
    "chapter": "درس ۱۸",
    "topics": [
     {
      "title": "کل درس: قیام ۱۵ خرداد"
     }
    ]
   },
   {
    "chapter": "درس ۱۹",
    "topics": [
     {
      "title": "کل درس: تحولات ایران پس از تبعید امام خمینی"
     }
    ]
   },
   {
    "chapter": "درس ۲۰",
    "topics": [
     {
      "title": "کل درس: ایران در مسیر انقلاب اسلامی"
     }
    ]
   },
   {
    "chapter": "درس ۲۱",
    "topics": [
     {
      "title": "کل درس: پیروزی انقلاب اسلامی ایران"
     }
    ]
   },
   {
    "chapter": "درس ۲۲",
    "topics": [
     {
      "title": "کل درس: دولت موقت مهندس مهدی بازرگان"
     }
    ]
   },
   {
    "chapter": "درس ۲۳",
    "topics": [
     {
      "title": "کل درس: اولین دوره ریاست جمهوری در ایران"
     }
    ]
   },
   {
    "chapter": "درس ۲۴",
    "topics": [
     {
      "title": "کل درس: جنگ تحمیلی رژیم بعثی حاکم بر عراق علیه ایران"
     }
    ]
   },
   {
    "chapter": "درس ۲۵",
    "topics": [
     {
      "title": "کل درس: آرمان‌ها و دستاوردهای انقلاب اسلامی ایران"
     }
    ]
   },
   {
    "chapter": "درس ۲۶",
    "topics": [
     {
      "title": "کل درس: جمهوری اسلامی ایران پس از جنگ تحمیلی هشت‌ساله در جهان جدید"
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
