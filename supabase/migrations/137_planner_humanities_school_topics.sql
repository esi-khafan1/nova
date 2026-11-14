-- Verified textbook topics; sources and uncertainty are documented in docs/planner-topic-sources.md.
-- NULL page spans are intentional. Administrator edits are not overwritten.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "10",
  "subject": "زبان خارجی ۱",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس‌ها",
    "topics": [
     {
      "title": "درس ۱: Saving Nature",
      "start": 15,
      "end": 41
     },
     {
      "title": "درس ۲: Wonders of Creation",
      "start": 43,
      "end": 69
     },
     {
      "title": "درس ۳: The Value of Knowledge",
      "start": 71,
      "end": 95
     },
     {
      "title": "درس ۴: Traveling the World",
      "start": 97,
      "end": 119
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "سلامت و بهداشت",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس‌ها",
    "topics": [
     {
      "title": "درس ۱: سلامت چیست؟",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۲: سبک زندگی سالم",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۳: برنامه غذایی سالم",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۴: کنترل وزن و تناسب اندام",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۵: بهداشت و ایمنی مواد غذایی",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۶: بیماری‌های غیر واگیر",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۷: بیماری‌های واگیردار",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۸: بهداشت فردی",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۹: بهداشت ازدواج و فرزندآوری",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۱۰: بهداشت روان",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۱۱: مصرف دخانیات و الکل",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۱۲: اعتیاد و عوارض آن",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۱۳: پیشگیری از اختلالات اسکلتی ـ عضلانی (کمردرد)",
      "start": null,
      "end": null
     },
     {
      "title": "درس ۱۴: پیشگیری از حوادث خانگی",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "فلسفه ۱",
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
      "title": "انسان و تفکر",
      "start": null,
      "end": null
     },
     {
      "title": "دو مرتبه از تفکر",
      "start": null,
      "end": null
     },
     {
      "title": "دانش فلسفه",
      "start": null,
      "end": null
     },
     {
      "title": "واژه فلسفه",
      "start": null,
      "end": null
     },
     {
      "title": "ویژگی‌های فلسفه",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "بخش اصلی و ریشه‌ای فلسفه",
      "start": null,
      "end": null
     },
     {
      "title": "شاخه‌های فلسفه",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "معنای زندگی",
      "start": null,
      "end": null
     },
     {
      "title": "برخی فواید تفکر فلسفی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "فلسفه در یونان",
      "start": null,
      "end": null
     },
     {
      "title": "سوفیست‌ها",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "سقراط در برابر دادگاه",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "چیستی معرفت",
      "start": null,
      "end": null
     },
     {
      "title": "امکان معرفت",
      "start": null,
      "end": null
     },
     {
      "title": "پیشرفت پیوسته دانش انسان",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "حس",
      "start": null,
      "end": null
     },
     {
      "title": "عقل",
      "start": null,
      "end": null
     },
     {
      "title": "قلب",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "دوره یونان باستان",
      "start": null,
      "end": null
     },
     {
      "title": "دوره شکوفایی فلسفه در جهان اسلام و ایران",
      "start": null,
      "end": null
     },
     {
      "title": "دوره جدید اروپا",
      "start": null,
      "end": null
     },
     {
      "title": "دو جریان فکری در دوره جدید اروپا",
      "start": null,
      "end": null
     },
     {
      "title": "حرکت به سوی تجربه‌گرایی مطلق",
      "start": null,
      "end": null
     },
     {
      "title": "رشد اندیشه نسبی‌گرایی",
      "start": null,
      "end": null
     },
     {
      "title": "ظهور پراگماتیسم",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "حقیقت انسان چیست؟",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "دیدگاه فیلسوفان مسلمان درباره حقیقت انسان",
      "start": null,
      "end": null
     },
     {
      "title": "از جانب بالا",
      "start": null,
      "end": null
     },
     {
      "title": "حقیقت نورانی نفس",
      "start": null,
      "end": null
     },
     {
      "title": "تا بی‌نهایت",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۱۱",
    "topics": [
     {
      "title": "فعل طبیعی و فعل اخلاقی",
      "start": null,
      "end": null
     },
     {
      "title": "برخی دیدگاه‌ها در معیار فعل اخلاقی",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "جامعه‌شناسی ۱",
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
      "title": "کنش ما انسان‌ها چه ویژگی‌هایی دارد؟",
      "start": null,
      "end": null
     },
     {
      "title": "کنش ما چه آثار و پیامدهایی دارد؟",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "کنش اجتماعی چیست؟",
      "start": null,
      "end": null
     },
     {
      "title": "پدیده‌های اجتماعی کدام‌اند و چگونه شکل می‌گیرند؟",
      "start": null,
      "end": null
     },
     {
      "title": "از من تا ما",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "چه تصوری از جهان اجتماعی دارید؟",
      "start": null,
      "end": null
     },
     {
      "title": "گستره جهان اجتماعی کجاست؟",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "جهان اجتماعی از چه اجزایی تشکیل شده است؟",
      "start": null,
      "end": null
     },
     {
      "title": "لایه‌های جهان اجتماعی کدام‌اند؟",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "جهان اجتماعی یا جهان‌های اجتماعی؟",
      "start": null,
      "end": null
     },
     {
      "title": "آیا جهان‌های اجتماعی تاریخ یکسانی دارند؟",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "آیا جهان اجتماعی صرفاً تابع خواست و اراده افراد است؟",
      "start": null,
      "end": null
     },
     {
      "title": "پیامدهای جهان اجتماعی: محدودیت‌ها و فرصت‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "فرصت‌ها و محدودیت‌های جهان متجدد",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "قلمرو واقعی و آرمانی جهان اجتماعی کدام است؟",
      "start": null,
      "end": null
     },
     {
      "title": "قلمرو واقعی و آرمانی جهان اجتماعی را چگونه ارزیابی کنیم؟",
      "start": null,
      "end": null
     },
     {
      "title": "آیا حق و باطل تابع جهان‌های اجتماعی‌اند؟",
      "start": null,
      "end": null
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
