-- Economics 10 lessons 3–14, study groupings from secondary lesson summaries.
-- Pages remain null until the 1405 textbook section boundaries are checked.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "10",
  "subject": "اقتصاد",
  "fields": [
   "humanities"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "هزینه فرصت و بده‌بستان"
     },
     {
      "title": "شناسایی منابع کمیاب"
     },
     {
      "title": "قید بودجه"
     },
     {
      "title": "هزینه‌های دررفته"
     },
     {
      "title": "مقایسه هزینه‌ها و منافع"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "الگوی مرز امکانات تولید"
     },
     {
      "title": "نقاط کارا، ناکارا و دست‌نیافتنی"
     },
     {
      "title": "هزینه فرصت اجتماع"
     },
     {
      "title": "انتقال مرز امکانات تولید"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "جریان چرخشی خانوار و بنگاه"
     },
     {
      "title": "بازار کالا و خدمات و تقاضا"
     },
     {
      "title": "عرضه و عوامل مؤثر بر آن"
     },
     {
      "title": "تعادل بازار، کمبود و مازاد"
     },
     {
      "title": "بازار رقابتی و انواع بازار"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "نقش دولت و خدمات عمومی"
     },
     {
      "title": "مالیات مستقیم و غیرمستقیم"
     },
     {
      "title": "مالیات بر ارزش افزوده و عوارض گمرکی"
     },
     {
      "title": "سایر درآمدهای دولت"
     },
     {
      "title": "جایگاه دولت در جریان چرخشی درآمد"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "دلایل تجارت بین کشورها و صادرات و واردات"
     },
     {
      "title": "مزیت مطلق و نسبی و هزینه فرصت"
     },
     {
      "title": "سیاست تجاری دولت‌ها و تعرفه‌ها"
     },
     {
      "title": "جنگ تجاری، تحریم و استقلال اقتصادی"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "رکود و منابع بیکار"
     },
     {
      "title": "جمعیت فعال و نرخ بیکاری"
     },
     {
      "title": "انواع بیکاری"
     },
     {
      "title": "پیامدهای رکود و بیکاری و فقر"
     },
     {
      "title": "فقر مطلق و نسبی و سیاست‌های فقرزدایی"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "پول و تاریخچه مبادله"
     },
     {
      "title": "وظایف پول و نقدینگی"
     },
     {
      "title": "تورم و قدرت خرید"
     },
     {
      "title": "شاخص قیمت مصرف‌کننده و محاسبه نرخ تورم"
     },
     {
      "title": "پیامدها و علل تورم و نقش دولت"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "مسیر تاریخی اقتصاد ایران"
     },
     {
      "title": "مقاوم‌سازی اقتصاد و تاب‌آوری"
     },
     {
      "title": "اقتصاد مقاومتی و استقلال اقتصادی"
     }
    ]
   },
   {
    "chapter": "درس ۱۱",
    "topics": [
     {
      "title": "رشد اقتصادی و مرز امکانات تولید"
     },
     {
      "title": "تولید ناخالص داخلی و درآمد سرانه"
     },
     {
      "title": "توزیع درآمد و شاخص دهک‌ها"
     },
     {
      "title": "شاخص توسعه انسانی"
     },
     {
      "title": "الگوی پیشرفت اسلامی ایرانی"
     }
    ]
   },
   {
    "chapter": "درس ۱۲",
    "topics": [
     {
      "title": "درآمد و مخارج خانوار"
     },
     {
      "title": "مراحل بودجه‌ریزی ماهانه"
     },
     {
      "title": "هزینه‌های ثابت و متغیر"
     },
     {
      "title": "خمس و سال مالی در برنامه مخارج"
     }
    ]
   },
   {
    "chapter": "درس ۱۳",
    "topics": [
     {
      "title": "خرید هوشمندانه"
     },
     {
      "title": "خرید مقایسه‌ای و معیارهای انتخاب"
     },
     {
      "title": "الگوی خرج کردن و مصرف‌گرایی"
     }
    ]
   },
   {
    "chapter": "درس ۱۴",
    "topics": [
     {
      "title": "پس‌انداز و سرمایه‌گذاری"
     },
     {
      "title": "سهام و اوراق مشارکت"
     },
     {
      "title": "خرید طلا"
     },
     {
      "title": "بیمه و پوشش خطر سرمایه‌گذاری"
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
