-- Supplemental educational groupings: see docs/planner-topic-sources.md.
-- IDs use a separate namespace; previous seeds and administrator edits are untouched.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "10",
  "subject": "کارگاه کارآفرینی و تولید",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapters": [
   {
    "chapter": "بخش‌های ۱ تا ۴",
    "topics": [
     {
      "title": "بخش ۱: تعریف تیم و مراحل تشکیل و توسعه"
     },
     {
      "title": "بخش ۱: تفاوت تیم و گروه و ویژگی‌های راهنما"
     },
     {
      "title": "بخش ۱: بازی تیمی برج روزنامه"
     },
     {
      "title": "بخش ۲: عوامل موفقیت کار تیمی"
     },
     {
      "title": "بخش ۲: بوم کار تیمی و تهیه روزنامه دیواری"
     },
     {
      "title": "بخش ۳: موانع کار تیمی اثربخش"
     },
     {
      "title": "بخش ۳: مرحله طوفان و راهکارهای تقویت تیم"
     },
     {
      "title": "بخش ۴: مسئله‌یابی و مراحل حل مسئله"
     },
     {
      "title": "بخش ۴: اصلاح الگوی مصرف"
     }
    ]
   },
   {
    "chapter": "بخش‌های ۵ تا ۹",
    "topics": [
     {
      "title": "بخش ۵: هدف‌گذاری مؤثر"
     },
     {
      "title": "بخش ۵: فرایند تصمیم‌گیری"
     },
     {
      "title": "بخش ۶: تیپ‌های شخصیتی"
     },
     {
      "title": "بخش ۶: شناخت شخصیت و انتخاب شغل"
     },
     {
      "title": "بخش ۷: طراحی مسیر شغلی آینده"
     },
     {
      "title": "بخش ۷: نگرش‌ها و توسعه شخصی"
     },
     {
      "title": "بخش ۸: شناسایی ارزش‌ها"
     },
     {
      "title": "بخش ۸: شناسایی نیازها"
     },
     {
      "title": "بخش ۹: شناسایی مهارت‌ها و استعدادها"
     },
     {
      "title": "بخش ۹: علایق و گرایش‌ها و جمع‌بندی"
     }
    ]
   },
   {
    "chapter": "بخش‌های ۱۰ تا ۱۷",
    "topics": [
     {
      "title": "بخش ۱۰: تفکر انتقادی و جست‌وجوی واقعیت"
     },
     {
      "title": "بخش ۱۰: مدل ایجاد تفکر انتقادی"
     },
     {
      "title": "بخش ۱۱: تفکر خلاق و واگرا"
     },
     {
      "title": "بخش ۱۱: موانع تفکر خلاق"
     },
     {
      "title": "بخش ۱۲: خلاقیت و روش‌های توسعه آن"
     },
     {
      "title": "بخش ۱۲: روش اسکمپر"
     },
     {
      "title": "بخش ۱۳: روش طوفان فکری"
     },
     {
      "title": "بخش ۱۳: روش شکوفه نیلوفر آبی"
     },
     {
      "title": "بخش ۱۴: تشخیص و منابع فرصت"
     },
     {
      "title": "بخش ۱۴: ایده‌پردازی و روش‌های ایده‌یابی"
     },
     {
      "title": "بخش ۱۴: ارزیابی خوب بودن و عملی بودن ایده"
     },
     {
      "title": "بخش ۱۵: ایده‌یابی بر مبنای تجربه"
     },
     {
      "title": "بخش ۱۵: ساختن ایده و الگوبرداری"
     },
     {
      "title": "بخش ۱۶: نوآوری و روش تریز"
     },
     {
      "title": "بخش ۱۶: اصول ابداعی و کاربرد آنها"
     },
     {
      "title": "بخش ۱۷: کارآفرینی و انواع آن"
     },
     {
      "title": "بخش ۱۷: مهارت‌های کارآفرین"
     },
     {
      "title": "بخش ۱۷: تولید ملی و حمایت از کار و سرمایه ایرانی"
     }
    ]
   },
   {
    "chapter": "بخش‌های ۱۸ تا ۲۷",
    "topics": [
     {
      "title": "بخش ۱۸: مفهوم و انواع کسب‌وکار"
     },
     {
      "title": "بخش ۱۸: انتخاب نوع کسب‌وکار"
     },
     {
      "title": "بخش ۱۹: بوم مدل کسب‌وکار"
     },
     {
      "title": "بخش ۱۹: بخش‌بندی و شناسایی مشتریان"
     },
     {
      "title": "بخش ۱۹: ارزیابی مشتری‌شناسی"
     }
    ]
   },
   {
    "chapter": "بخش‌های ۲۸ تا ۳۲",
    "topics": [
     {
      "title": "بخش ۲۹: معرفی و اهداف کسب‌وکار"
     },
     {
      "title": "بخش ۲۹: نام، محصول و محل اجرای طرح"
     },
     {
      "title": "بخش ۲۹: مالکیت و سازماندهی نیروی انسانی"
     },
     {
      "title": "بخش ۳۲: سرمایه‌گذاری و هزینه‌های طرح"
     },
     {
      "title": "بخش ۳۲: برآورد درآمد و سودآوری"
     },
     {
      "title": "بخش ۳۲: برنامه زمان‌بندی و ارائه طرح در نمایشگاه"
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "آمادگی دفاعی",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: آموزه‌های دفاعی",
    "topics": [
     {
      "title": "درس ۱: امنیت و امنیت ملی"
     },
     {
      "title": "درس ۱: صلح و انواع تهدید"
     },
     {
      "title": "درس ۱: حفاظت از اطلاعات کشور"
     },
     {
      "title": "درس ۲: مفهوم و منابع اقتدار"
     },
     {
      "title": "درس ۲: اقتدار و دستاوردهای دفاعی"
     }
    ]
   },
   {
    "chapter": "فصل ۲: فرهنگ دفاع",
    "topics": [
     {
      "title": "درس ۳: انقلاب اسلامی و ضرورت دفاع از آن"
     },
     {
      "title": "درس ۳: دستاوردها و گام دوم انقلاب"
     },
     {
      "title": "درس ۴: ضرورت و تاریخچه تشکیل بسیج"
     },
     {
      "title": "درس ۴: اهداف و مأموریت‌ها"
     },
     {
      "title": "درس ۴: شاخص‌های بسیجی نمونه"
     },
     {
      "title": "درس ۵: دفاع همه‌جانبه و تجربه‌های دفاع مقدس"
     },
     {
      "title": "درس ۵: فرهنگ ایثار و شهادت و سبک زندگی"
     },
     {
      "title": "درس ۵: راهیان نور و آداب سفر"
     },
     {
      "title": "درس ۶: حماسه‌سازان نوجوان"
     },
     {
      "title": "درس ۶: شهدای مدافع حرم و الگوهای پایداری"
     }
    ]
   },
   {
    "chapter": "فصل ۳: دفاع نظامی",
    "topics": [
     {
      "title": "درس ۷: نیروهای مسلح و فرماندهی کل قوا"
     },
     {
      "title": "درس ۷: سربازی و تعیین وضعیت خدمت"
     },
     {
      "title": "درس ۷: مهارت‌آموزی در سربازی"
     },
     {
      "title": "درس ۸: نظام جمع"
     },
     {
      "title": "درس ۸: عوارض زمین و شناسایی آن"
     },
     {
      "title": "درس ۸: اصول نگهبانی"
     },
     {
      "title": "درس ۹: آشنایی با جنگ‌افزارها"
     },
     {
      "title": "درس ۹: اصول و ایمنی تیراندازی"
     }
    ]
   },
   {
    "chapter": "فصل ۴: دفاع غیرنظامی",
    "topics": [
     {
      "title": "درس ۱۰: مفهوم و هدف جنگ نرم"
     },
     {
      "title": "درس ۱۰: حوزه‌های جنگ نرم"
     },
     {
      "title": "درس ۱۰: روش‌ها و مراحل مقابله"
     },
     {
      "title": "درس ۱۱: مفهوم، مأموریت‌ها و اولویت‌های پدافند غیرعامل"
     },
     {
      "title": "درس ۱۱: پدافند سایبری، اقتصادی و زیستی"
     },
     {
      "title": "درس ۱۲: هشدارها و مخاطره"
     },
     {
      "title": "درس ۱۲: نقشه خطر بلایا"
     },
     {
      "title": "درس ۱۲: ایمنی و پیشگیری"
     },
     {
      "title": "درس ۱۳: کمک‌های اولیه و ارزیابی مصدوم"
     },
     {
      "title": "درس ۱۳: خون‌ریزی و شوک"
     },
     {
      "title": "درس ۱۳: سوختگی و آسیب‌های اسکلتی"
     },
     {
      "title": "درس ۱۳: آتش‌سوزی و خروج یا پناه‌گیری ایمن"
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "chapters": [
   {
    "chapter": "درس ۱: هدایت الهی",
    "topics": [
     {
      "title": "کل درس",
      "start": 12,
      "end": 21
     }
    ]
   },
   {
    "chapter": "درس ۲: تداوم هدایت",
    "topics": [
     {
      "title": "کل درس",
      "start": 22,
      "end": 35
     }
    ]
   },
   {
    "chapter": "درس ۳: معجزه جاویدان",
    "topics": [
     {
      "title": "کل درس",
      "start": 36,
      "end": 47
     }
    ]
   },
   {
    "chapter": "درس ۴: مسئولیت‌های پیامبر",
    "topics": [
     {
      "title": "کل درس",
      "start": 48,
      "end": 61
     }
    ]
   },
   {
    "chapter": "درس ۵: امامت، تداوم رسالت",
    "topics": [
     {
      "title": "کل درس",
      "start": 62,
      "end": 73
     }
    ]
   },
   {
    "chapter": "درس ۶: پیشوایان اسوه",
    "topics": [
     {
      "title": "کل درس",
      "start": 74,
      "end": 87
     }
    ]
   },
   {
    "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
    "topics": [
     {
      "title": "کل درس",
      "start": 88,
      "end": 97
     }
    ]
   },
   {
    "chapter": "درس ۸: احیای ارزش‌های راستین",
    "topics": [
     {
      "title": "کل درس",
      "start": 98,
      "end": 109
     }
    ]
   },
   {
    "chapter": "درس ۹: عصر غیبت",
    "topics": [
     {
      "title": "کل درس",
      "start": 110,
      "end": 123
     }
    ]
   },
   {
    "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
    "topics": [
     {
      "title": "کل درس",
      "start": 124,
      "end": 137
     }
    ]
   },
   {
    "chapter": "درس ۱۱: عزت نفس",
    "topics": [
     {
      "title": "کل درس",
      "start": 138,
      "end": 147
     }
    ]
   },
   {
    "chapter": "درس ۱۲: پیوند مقدس",
    "topics": [
     {
      "title": "کل درس"
     }
    ]
   }
  ]
 }
]$books$::jsonb)
 as b(grade text,subject text,fields jsonb,chapters jsonb)), expanded as (
 select b.grade,b.subject,f.field,c.item->>'chapter' chapter,topic.item->>'title' title,
 (topic.item->>'start')::integer page_start,(topic.item->>'end')::integer page_end,100+topic.ord::integer position
 from data b cross join lateral jsonb_array_elements_text(b.fields) f(field)
 cross join lateral jsonb_array_elements(b.chapters) c(item)
 cross join lateral jsonb_array_elements(c.item->'topics') with ordinality topic(item,ord)
)
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v155:' || field || ':' || grade || ':final_exam:' || subject || ':' || chapter || ':' || position)::uuid,
 '1405',field,grade,'final_exam',subject,chapter,title,page_start,page_end,position from expanded
on conflict (id) do nothing;
