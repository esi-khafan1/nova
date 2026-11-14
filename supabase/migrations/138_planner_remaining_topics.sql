-- Partial textbook topics; source and verification notes in docs/planner-topic-sources.md.
-- Page spans intentionally unset where boundaries are not verified. Never overwrite edits.
with data as (select * from jsonb_to_recordset($books$[
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
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "در مورد هویت چه می‌دانید؟"
     },
     {
      "title": "هویت فردی و اجتماعی چه نسبتی با هم دارند؟"
     },
     {
      "title": "خودآگاهی یا ناخودآگاهی؟"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "جامعه‌پذیری چه نقشی در بازتولید هویت اجتماعی دارد؟"
     },
     {
      "title": "کنترل اجتماعی چه نقشی در بازتولید هویت اجتماعی دارد؟"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "تحرک اجتماعی چیست؟"
     },
     {
      "title": "فرصت‌ها و محدودیت‌های تغییرات هویتی کدام‌اند؟"
     }
    ]
   },
   {
    "chapter": "درس ۱۱",
    "topics": [
     {
      "title": "هویت جهان اجتماعی چیست؟"
     },
     {
      "title": "فرایند تحولات هویتی جهان اجتماعی چگونه است؟"
     }
    ]
   },
   {
    "chapter": "درس ۱۲",
    "topics": [
     {
      "title": "ارتباط جهان‌های اجتماعی و تحولات فرهنگی"
     },
     {
      "title": "از خودبیگانگی فرهنگی چیست؟"
     }
    ]
   },
   {
    "chapter": "درس ۱۳",
    "topics": [
     {
      "title": "هویت ایرانی در گذر زمان چه تحولاتی به خود دیده است؟"
     },
     {
      "title": "انقلاب اسلامی چه تأثیری بر هویت ایرانی دارد؟"
     }
    ]
   },
   {
    "chapter": "درس ۱۴",
    "topics": [
     {
      "title": "هویت اجتماعی خانوادگی"
     }
    ]
   },
   {
    "chapter": "درس ۱۵",
    "topics": [
     {
      "title": "رابطه جهان اجتماعی و نظام سیاسی"
     },
     {
      "title": "انواع نظام‌های سیاسی"
     }
    ]
   },
   {
    "chapter": "درس ۱۶",
    "topics": [
     {
      "title": "رابطه جمعیت جامعه با هویت آن"
     },
     {
      "title": "هویت اقتصادی جامعه"
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "منطق",
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
      "title": "حیطه کاربرد منطق"
     },
     {
      "title": "دو بخش اصلی منطق: تعریف و استدلال"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "اشتراک لفظ"
     },
     {
      "title": "نحوه دلالت لفظ بر معنا"
     },
     {
      "title": "شیوه نگارش کلمات"
     },
     {
      "title": "ابهام در مرجع ضمیر"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "مفهوم جزئی و مفهوم کلی"
     },
     {
      "title": "رابطه مفاهیم: نسبت‌های چهارگانه"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "تعریف لغوی، مصداقی و مفهومی"
     },
     {
      "title": "شرایط تعریف صحیح"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "استقرای تمثیلی"
     },
     {
      "title": "استقرای تعمیمی"
     },
     {
      "title": "استنتاج بهترین تبیین"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "قضیه و اجزای قضیه حملی"
     },
     {
      "title": "قضایای شخصیه و محصوره"
     },
     {
      "title": "کمیت و کیفیت قضیه"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "روابط تقابل قضایا"
     },
     {
      "title": "عکس مستوی"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "مقدمه، نتیجه و حد وسط"
     },
     {
      "title": "اشکال قیاس اقترانی و اعتبار آن"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "قضیه شرطی متصل و منفصل"
     },
     {
      "title": "اقسام قضیه منفصل"
     },
     {
      "title": "قیاس استثنایی اتصالی و انفصالی"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "تفکر نقادانه"
     },
     {
      "title": "بار ارزشی کلمات"
     },
     {
      "title": "مغالطه در اثر عوامل روانی"
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "روان‌شناسی",
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
      "title": "منابع کسب آگاهی و معرفت"
     },
     {
      "title": "علم تجربی چیست؟"
     },
     {
      "title": "هدف‌های علم روان‌شناسی"
     },
     {
      "title": "روش علمی و محدودیت‌های آن"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "عوامل وراثتی و محیطی رشد"
     },
     {
      "title": "مراحل رشد در فراخنای زندگی"
     },
     {
      "title": "رشد پیش از تولد"
     },
     {
      "title": "رشد در کودکی"
     },
     {
      "title": "رشد در نوجوانی"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "احساس"
     },
     {
      "title": "توجه"
     },
     {
      "title": "ادراک"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "رمزگردانی، ذخیره‌سازی و بازیابی"
     },
     {
      "title": "حافظه حسی، کوتاه‌مدت و بلندمدت"
     },
     {
      "title": "علل فراموشی و خطاهای حافظه"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "انواع مسئله"
     },
     {
      "title": "مراحل حل مسئله"
     },
     {
      "title": "عوامل مؤثر بر حل مسئله"
     },
     {
      "title": "روش‌های اکتشافی حل مسئله"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "انواع تصمیم‌گیری"
     },
     {
      "title": "سبک‌های تصمیم‌گیری"
     },
     {
      "title": "مراحل تصمیم‌گیری"
     },
     {
      "title": "موانع تصمیم‌گیری"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "انگیزه درونی و بیرونی"
     },
     {
      "title": "نگرش و عوامل مؤثر بر آن"
     },
     {
      "title": "ناهماهنگی شناختی"
     },
     {
      "title": "ادراک کنترل و کارایی"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "نقش عوامل روان‌شناختی در سلامت"
     },
     {
      "title": "فشار روانی"
     },
     {
      "title": "مقابله سازگارانه و ناسازگارانه با فشار روانی"
     }
    ]
   }
  ]
 },
 {
  "grade": "9",
  "subject": "علوم تجربی",
  "fields": [
   "all"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: مواد و نقش آنها در زندگی",
    "topics": [
     {
      "title": "مواد فلزی و کاربرد فلزها"
     },
     {
      "title": "واکنش‌پذیری فلزها"
     },
     {
      "title": "نافلزها و نقش آنها در مواد"
     },
     {
      "title": "بسپارهای طبیعی و مصنوعی"
     },
     {
      "title": "بازگردانی پلاستیک‌ها"
     }
    ]
   },
   {
    "chapter": "فصل ۲: رفتار اتم‌ها با یکدیگر",
    "topics": [
     {
      "title": "ذره‌های سازنده مواد"
     },
     {
      "title": "داد و ستد الکترون و پیوند یونی"
     },
     {
      "title": "یون‌ها در بدن ما"
     },
     {
      "title": "ویژگی‌های ترکیب یونی"
     }
    ]
   },
   {
    "chapter": "فصل ۳: به دنبال محیطی بهتر برای زندگی",
    "topics": [
     {
      "title": "چرخه کربن"
     },
     {
      "title": "سوخت‌های فسیلی و محیط زیست"
     },
     {
      "title": "نفت خام و هیدروکربن‌ها"
     },
     {
      "title": "بسپار شدن و پلاستیک‌ها"
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
