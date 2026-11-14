-- Arabic 11 and geography 11/12, 1405: study groupings; unverified page spans remain null.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "11",
  "subject": "عربی ۲ تخصصی",
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
      "title": "متن و واژگان: مواعظ قیمة"
     },
     {
      "title": "قواعد: اسم تفضیل و اسم مکان"
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
      "title": "متن و واژگان: صناعة التلمیع فی الأدب الفارسی"
     },
     {
      "title": "قواعد: اسم فاعل، اسم مفعول و اسم مبالغه"
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
      "title": "متن و واژگان: عجائب المخلوقات"
     },
     {
      "title": "قواعد: اسلوب شرط و ادوات آن"
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
      "title": "متن و واژگان: تأثیر اللغة الفارسیة علی اللغة العربیة"
     },
     {
      "title": "قواعد: معرفه و نکره و ترجمه فعل مضارع"
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
      "title": "متن و واژگان: الصدق"
     },
     {
      "title": "قواعد: جمله بعد از نکره"
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
      "title": "متن و واژگان: ارحموا ثلاثاً"
     },
     {
      "title": "قواعد: ترجمه فعل مضارع"
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
      "title": "متن و واژگان: لا تقنطوا"
     },
     {
      "title": "قواعد: افعال ناقصه"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "عربی زبان قرآن ۲",
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
      "title": "متن و واژگان: من آیات الأخلاق"
     },
     {
      "title": "قواعد: اسم تفضیل و اسم مکان"
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
      "title": "متن و واژگان: فی محضر المعلم"
     },
     {
      "title": "قواعد: اسلوب شرط و ادوات آن"
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
      "title": "متن و واژگان: عجائب الأشجار"
     },
     {
      "title": "قواعد: معرفه و نکره"
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
      "title": "متن و واژگان: آداب الکلام"
     },
     {
      "title": "قواعد: ترجمه فعل مضارع"
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
      "title": "متن و واژگان: الکذب مفتاح لکل شر"
     },
     {
      "title": "قواعد: ترجمه فعل مضارع"
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
      "title": "متن و واژگان: آنّه ماری شیمل"
     },
     {
      "title": "قواعد: ترجمه فعل مضارع"
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
      "title": "متن و واژگان: تأثیر اللغة الفارسیة علی اللغة العربیة"
     },
     {
      "title": "قواعد: افعال ناقصه"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "جغرافیا ۲",
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
      "title": "مفهوم ناحیه و ویژگی‌های آن"
     },
     {
      "title": "معیارهای طبیعی و انسانی ناحیه‌بندی"
     },
     {
      "title": "کانون و مرزهای ناحیه"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "تعامل انسان و ناحیه"
     },
     {
      "title": "تأثیر ناحیه بر فعالیت انسان"
     },
     {
      "title": "تغییر نواحی و نقش تصمیم‌های انسان"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "هوا، آب و هوا و هواکره"
     },
     {
      "title": "عوامل پیدایش نواحی آب و هوایی"
     },
     {
      "title": "طبقه‌بندی اقلیم‌ها"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "هوازدگی و فرسایش"
     },
     {
      "title": "اشکال ناهمواری‌ها"
     },
     {
      "title": "نقشه‌های توپوگرافی"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "بوم‌سازگان و زیست‌بوم"
     },
     {
      "title": "زیست‌بوم‌های جهان"
     },
     {
      "title": "حفاظت از نواحی زیستی"
     },
     {
      "title": "مطالعه موردی ۱: نپال، زندگی در بلندی‌ها"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "مفهوم ناحیه فرهنگی"
     },
     {
      "title": "زبان، دین و نواحی فرهنگی جهان"
     },
     {
      "title": "پخش فرهنگی"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "فعالیت‌های اقتصادی و کشاورزی"
     },
     {
      "title": "نواحی کشاورزی و دامداری جهان"
     },
     {
      "title": "نواحی صنعتی"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "نابرابری اقتصادی و توسعه"
     },
     {
      "title": "اقتصاد جهانی و تجارت"
     },
     {
      "title": "همکاری و اتحادیه‌های اقتصادی"
     },
     {
      "title": "مطالعه موردی ۲: ناحیه فرهنگی جهان اسلام"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "مفهوم و ارکان ناحیه سیاسی"
     },
     {
      "title": "انواع نواحی سیاسی"
     },
     {
      "title": "جغرافیای سیاسی"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "کشور و قلمرو"
     },
     {
      "title": "جمعیت و حکومت"
     },
     {
      "title": "مرز و مدیریت کشور"
     }
    ]
   },
   {
    "chapter": "درس ۱۱",
    "topics": [
     {
      "title": "ژئوپلیتیک و قدرت"
     },
     {
      "title": "عوامل جغرافیایی مؤثر بر قدرت"
     },
     {
      "title": "مناطق ژئوپلیتیکی"
     },
     {
      "title": "مطالعه موردی ۳: ناحیه ژئوپلیتیکی خلیج فارس"
     },
     {
      "title": "مطالعه موردی ۴: ناحیه ژئوپلیتیکی اتحادیه اروپا"
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "جغرافیا ۳",
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
      "title": "هسته اولیه و موقعیت سکونتگاه‌ها"
     },
     {
      "title": "تفاوت‌ها و روابط شهر و روستا"
     },
     {
      "title": "تغییر سکونتگاه‌ها و شهرگرایی"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "مدیریت سکونتگاه‌های شهری و روستایی"
     },
     {
      "title": "مسائل شهرها و روستاها"
     },
     {
      "title": "برنامه‌ریزی و توسعه پایدار"
     },
     {
      "title": "فنون و مهارت‌های جغرافیایی ۱"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "مفهوم و اهمیت حمل و نقل"
     },
     {
      "title": "حمل و نقل جاده‌ای و ریلی"
     },
     {
      "title": "حمل و نقل آبی، هوایی و خطوط لوله"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "مدیریت و حمل و نقل پایدار"
     },
     {
      "title": "حمل و نقل چندوجهی و ایمنی"
     },
     {
      "title": "حمل و نقل عمومی شهری"
     },
     {
      "title": "فنون و مهارت‌های جغرافیایی ۲"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "مفهوم و انواع مخاطرات طبیعی"
     },
     {
      "title": "زمین‌لرزه و آتشفشان"
     },
     {
      "title": "سیل و خشکسالی"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "مفهوم مدیریت مخاطرات"
     },
     {
      "title": "اقدامات پیش از وقوع مخاطرات"
     },
     {
      "title": "اقدامات هنگام و پس از وقوع مخاطرات"
     },
     {
      "title": "فنون و مهارت‌های جغرافیایی ۳"
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
