-- Geography of Iran, grade 10: study groupings for all catalog fields.
-- Unverified section page spans remain null; do not overwrite administrator edits.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
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
      "title": "تعریف جغرافیا و ارتباط با علوم دیگر"
     },
     {
      "title": "مفاهیم مکان و روابط متقابل انسان و محیط"
     },
     {
      "title": "کل‌نگری و دید ترکیبی در جغرافیا"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "پرسش‌های کلیدی جغرافیا"
     },
     {
      "title": "طرح مسئله و تدوین فرضیه"
     },
     {
      "title": "جمع‌آوری و پردازش اطلاعات"
     },
     {
      "title": "نتیجه‌گیری و ارائه پیشنهادها"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "موقعیت ریاضی یا مطلق ایران"
     },
     {
      "title": "موقعیت نسبی ایران و اهمیت خلیج فارس"
     },
     {
      "title": "تنگه هرمز، دریای عمان و دریای خزر"
     },
     {
      "title": "مرزها و ارتباطات ایران"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "پیدایش و اهمیت ناهمواری‌های ایران"
     },
     {
      "title": "سرزمین‌های کوهستانی ایران"
     },
     {
      "title": "دشت‌ها و جلگه‌های ایران"
     },
     {
      "title": "نقش ناهمواری‌ها در زندگی انسان"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "عوامل مؤثر بر آب و هوای ایران"
     },
     {
      "title": "توده‌های هوا و انواع اقلیم ایران"
     },
     {
      "title": "بیابان‌های ایران"
     },
     {
      "title": "آب و هوا و مسائل محیط زیستی"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "منابع آب سطحی و زیرزمینی"
     },
     {
      "title": "رودها، کانون‌های آبگیر و حوضه‌های آبریز"
     },
     {
      "title": "دریاها و دریاچه‌های ایران"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "پراکندگی جمعیت و عوامل آن"
     },
     {
      "title": "رشد و ساختار جمعیت"
     },
     {
      "title": "مهاجرت و پیامدهای آن"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "سابقه تقسیمات کشوری ایران"
     },
     {
      "title": "استان، شهرستان، بخش و دهستان"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "شکل‌گیری سکونتگاه‌ها و عوامل مؤثر"
     },
     {
      "title": "سکونتگاه‌های شهری، روستایی و عشایری"
     },
     {
      "title": "شکل و تغییر سکونتگاه‌ها"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "کشاورزی، زراعت و باغداری"
     },
     {
      "title": "صنعت و پراکندگی قطب‌های صنعتی"
     },
     {
      "title": "خدمات و گردشگری"
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "جغرافیای ایران",
  "fields": [
   "experimental_sciences",
   "mathematics"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس ۱",
    "topics": [
     {
      "title": "تعریف جغرافیا و ارتباط با علوم دیگر"
     },
     {
      "title": "مفاهیم مکان و روابط متقابل انسان و محیط"
     },
     {
      "title": "کل‌نگری و دید ترکیبی در جغرافیا"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "پرسش‌های کلیدی جغرافیا"
     },
     {
      "title": "طرح مسئله و تدوین فرضیه"
     },
     {
      "title": "جمع‌آوری و پردازش اطلاعات"
     },
     {
      "title": "نتیجه‌گیری و ارائه پیشنهادها"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "موقعیت ریاضی یا مطلق ایران"
     },
     {
      "title": "موقعیت نسبی ایران و اهمیت خلیج فارس"
     },
     {
      "title": "تنگه هرمز، دریای عمان و دریای خزر"
     },
     {
      "title": "مرزها و ارتباطات ایران"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "پیدایش و اهمیت ناهمواری‌های ایران"
     },
     {
      "title": "سرزمین‌های کوهستانی ایران"
     },
     {
      "title": "دشت‌ها و جلگه‌های ایران"
     },
     {
      "title": "نقش ناهمواری‌ها در زندگی انسان"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "عوامل مؤثر بر آب و هوای ایران"
     },
     {
      "title": "توده‌های هوا و انواع اقلیم ایران"
     },
     {
      "title": "بیابان‌های ایران"
     },
     {
      "title": "آب و هوا و مسائل محیط زیستی"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "منابع آب سطحی و زیرزمینی"
     },
     {
      "title": "رودها، کانون‌های آبگیر و حوضه‌های آبریز"
     },
     {
      "title": "دریاها و دریاچه‌های ایران"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "پراکندگی جمعیت و عوامل آن"
     },
     {
      "title": "رشد و ساختار جمعیت"
     },
     {
      "title": "مهاجرت و پیامدهای آن"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "سابقه تقسیمات کشوری ایران"
     },
     {
      "title": "استان، شهرستان، بخش و دهستان"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "شکل‌گیری سکونتگاه‌ها و عوامل مؤثر"
     },
     {
      "title": "سکونتگاه‌های شهری، روستایی و عشایری"
     },
     {
      "title": "شکل و تغییر سکونتگاه‌ها"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "کشاورزی، زراعت و باغداری"
     },
     {
      "title": "صنعت و پراکندگی قطب‌های صنعتی"
     },
     {
      "title": "خدمات و گردشگری"
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
