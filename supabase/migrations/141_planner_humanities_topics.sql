-- Partial topic groupings from the 1405 textbook text; see docs/planner-topic-sources.md.
-- Page spans are unset until the exact section boundaries are verified.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "11",
  "subject": "جامعه‌شناسی ۲",
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
      "title": "جهان انسانی و بخش‌های فردی و اجتماعی"
     },
     {
      "title": "جهان تکوینی و بخش‌های طبیعت و فوق طبیعت"
     },
     {
      "title": "تعامل جهان‌های ذهنی، فرهنگی و تکوینی"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "فرهنگ جهانی و شرایط جهانی‌شدن فرهنگ‌ها"
     },
     {
      "title": "فرهنگ سلطه و فرهنگ جهانی مطلوب"
     },
     {
      "title": "حقیقت، معنویت، عدالت و آزادی"
     },
     {
      "title": "تعهد و مسئولیت و عقلانیت در فرهنگ جهانی"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "جهان‌گشایی و امپراتوری"
     },
     {
      "title": "غلبه نظامی و غلبه فرهنگی"
     },
     {
      "title": "امپریالیسم و استعمار"
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "جامعه‌شناسی ۳",
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
      "title": "ذخیره دانشی و نقش آن در زندگی"
     },
     {
      "title": "دانش عمومی"
     },
     {
      "title": "دانش علمی"
     },
     {
      "title": "تعامل و تعارض دانش عمومی و دانش علمی"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "علوم انسانی و علوم اجتماعی"
     },
     {
      "title": "فواید علوم اجتماعی"
     },
     {
      "title": "شاخه‌های علوم اجتماعی"
     },
     {
      "title": "جامعه‌شناسی خرد و کلان و رویکردهای جامعه‌شناسی"
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "فلسفه ۲",
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
      "title": "هستی و چیستی و ویژگی‌های ماهیت"
     },
     {
      "title": "تمایز وجود و ماهیت در اندیشه فارابی و ابن‌سینا"
     },
     {
      "title": "استدلال ابن‌سینا درباره مغایرت وجود و ماهیت"
     },
     {
      "title": "گذری تاریخی بر تأثیر بحث وجود و ماهیت"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "نسبت‌های سه‌گانه وجوب، امکان و امتناع"
     },
     {
      "title": "واجب‌الوجود، ممکن‌الوجود و ممتنع‌الوجود"
     },
     {
      "title": "امکان ذاتی و خروج از امکان به واسطه علت"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "رابطه علیت و تفاوت آن با سایر روابط"
     },
     {
      "title": "منشأ درک علیت و دیدگاه فیلسوفان"
     },
     {
      "title": "وجوب علّی و معلولی"
     },
     {
      "title": "سنخیت علت و معلول و نتایج آن"
     }
    ]
   }
  ]
 },
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
    "chapter": "درس ۱",
    "topics": [
     {
      "title": "فراز و فرود کسب‌وکارها"
     },
     {
      "title": "نقش و ویژگی‌های کارآفرینان"
     },
     {
      "title": "هزینه‌های تولید، درآمد، سود و زیان"
     },
     {
      "title": "مسئولیت اخلاقی در کسب‌وکار"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "سازمان تولید و مالکیت کسب‌وکار"
     },
     {
      "title": "کسب‌وکار شخصی و مزایا و معایب آن"
     },
     {
      "title": "شرکت سهامی و سهامداران"
     },
     {
      "title": "تعاونی‌ها"
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
