-- History 12: study groupings; unverified page ranges remain null.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "12",
  "subject": "تاریخ ۳",
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
      "title": "تاریخ‌نگاری سنتی"
     },
     {
      "title": "تاریخ‌نگاری جدید"
     },
     {
      "title": "منابع مکتوب: تاریخ‌ها، خاطرات و سفرنامه‌ها"
     },
     {
      "title": "اسناد و منابع غیرمکتوب"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "ایران پس از صفویه: افشاریه و زندیه"
     },
     {
      "title": "حکومت، جامعه و اقتصاد در افشاریه و زندیه"
     },
     {
      "title": "اروپا و گسترش استعمار"
     },
     {
      "title": "انقلاب صنعتی و پیامدهای آن"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "نظام سیاسی و جایگاه شاه"
     },
     {
      "title": "تشکیلات اداری و نظامی قاجار"
     },
     {
      "title": "روابط خارجی و جنگ‌های ایران و روسیه"
     },
     {
      "title": "اصلاحات و روابط خارجی در دوره ناصرالدین شاه"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "اوضاع اجتماعی و شیوه‌های زندگی"
     },
     {
      "title": "کشاورزی، صنعت و تجارت"
     },
     {
      "title": "فرهنگ، ادبیات و هنر"
     },
     {
      "title": "آموزش سنتی و مراکز آموزشی جدید"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "زمینه‌های نهضت مشروطه"
     },
     {
      "title": "مهاجرت صغری و کبری و پیروزی مشروطه"
     },
     {
      "title": "مجلس و قانون اساسی"
     },
     {
      "title": "محمدعلی شاه، استبداد صغیر و مقاومت"
     },
     {
      "title": "دوره دوم مشروطه و چالش‌ها"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "زمینه‌ها و آغاز جنگ جهانی اول"
     },
     {
      "title": "جبهه‌های جنگ و پیامدهای آن"
     },
     {
      "title": "ایران در جنگ جهانی اول"
     },
     {
      "title": "قرارداد ۱۹۱۹ و واکنش‌ها"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "کودتای ۱۲۹۹ و قدرت‌گیری رضاشاه"
     },
     {
      "title": "حکومت و اقدامات رضاشاه"
     },
     {
      "title": "سیاست فرهنگی و محدودیت روحانیت"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "جهان در فاصله دو جنگ و زمینه‌های جنگ جهانی دوم"
     },
     {
      "title": "آغاز و روند جنگ جهانی دوم"
     },
     {
      "title": "ایران در جنگ جهانی دوم"
     },
     {
      "title": "پیامدهای جنگ و تحولات جهان پس از آن"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "نفت و زمینه‌های نهضت ملی شدن"
     },
     {
      "title": "مبارزه برای ملی شدن صنعت نفت"
     },
     {
      "title": "دولت مصدق و چالش‌های ملی شدن نفت"
     },
     {
      "title": "کودتای ۲۸ مرداد"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "اوضاع ایران پس از کودتای ۲۸ مرداد"
     },
     {
      "title": "آغاز نهضت اسلامی و قیام ۱۵ خرداد"
     },
     {
      "title": "مبارزه سیاسی، فرهنگی و مسلحانه"
     },
     {
      "title": "رویدادهای ۱۳۵۶ و ۱۳۵۷ و پیروزی انقلاب"
     }
    ]
   },
   {
    "chapter": "درس ۱۱",
    "topics": [
     {
      "title": "استقرار نظام جمهوری اسلامی"
     },
     {
      "title": "نهادهای انقلاب و قانون اساسی"
     },
     {
      "title": "چالش‌ها و توطئه‌های داخلی و خارجی"
     }
    ]
   },
   {
    "chapter": "درس ۱۲",
    "topics": [
     {
      "title": "آغاز جنگ تحمیلی و دفاع مردم"
     },
     {
      "title": "آزادسازی مناطق اشغالی"
     },
     {
      "title": "رهبری و نقش مردم در دفاع مقدس"
     },
     {
      "title": "پایان جنگ و دستاوردهای دفاع مقدس"
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
