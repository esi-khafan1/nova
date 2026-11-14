-- Grade 10 Arabic, distinct humanities and science/mathematics books.
-- Page spans not verified; preserve administrator edits.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "10",
  "subject": "عربی ۱ تخصصی",
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
      "title": "متن و واژگان: ذاک هو الله"
     },
     {
      "title": "قواعد: افعال، ضمایر و اسم اشاره"
     },
     {
      "title": "گفت‌وگو: التعارف"
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
      "title": "متن و واژگان: إنکم مسؤولون"
     },
     {
      "title": "قواعد: اعداد از یک تا صد"
     },
     {
      "title": "گفت‌وگو: فی مطار النجف"
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
      "title": "متن و واژگان: مطر السمک"
     },
     {
      "title": "قواعد: فعل ثلاثی مجرد و مزید ۱"
     },
     {
      "title": "گفت‌وگو: فی قسم الجوازات"
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
      "title": "متن و واژگان: التعایش السلمی"
     },
     {
      "title": "قواعد: فعل ثلاثی مزید ۲"
     },
     {
      "title": "گفت‌وگو: فی صالة التفتیش"
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
      "title": "متن و واژگان: هذا خلق الله"
     },
     {
      "title": "قواعد: جمله اسمیه و فعلیه"
     },
     {
      "title": "گفت‌وگو: مع سائق سیارة الأجرة"
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
      "title": "متن و واژگان: المعالم الخلابة"
     },
     {
      "title": "قواعد: اعراب اجزای جمله اسمیه و فعلیه"
     },
     {
      "title": "گفت‌وگو: فی الصیدلیة"
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
      "title": "متن و واژگان: صناعة النفط"
     },
     {
      "title": "قواعد: فعل معلوم و مجهول"
     },
     {
      "title": "گفت‌وگو: مع مسؤول استقبال الفندق"
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
      "title": "متن و واژگان: یا من فی البحار عجائبه"
     },
     {
      "title": "قواعد: جار و مجرور و نون وقایه"
     },
     {
      "title": "گفت‌وگو: مع مشرف خدمات الفندق"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "عربی زبان قرآن ۱",
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
      "title": "متن و واژگان: ذاک هو الله"
     },
     {
      "title": "قواعد: افعال، ضمایر و اسم اشاره"
     },
     {
      "title": "گفت‌وگو: التعارف"
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
      "title": "متن و واژگان: المواعظ العددیة"
     },
     {
      "title": "قواعد: اعداد از یک تا صد"
     },
     {
      "title": "گفت‌وگو: فی مطار النجف"
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
      "title": "متن و واژگان: مطر السمک"
     },
     {
      "title": "قواعد: اشکال افعال ۱"
     },
     {
      "title": "گفت‌وگو: فی قسم الجوازات"
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
      "title": "متن و واژگان: التعایش السلمی"
     },
     {
      "title": "قواعد: اشکال افعال ۲"
     },
     {
      "title": "گفت‌وگو: فی صالة التفتیش"
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
      "title": "متن و واژگان: هذا خلق الله"
     },
     {
      "title": "قواعد: جمله فعلیه و اسمیه"
     },
     {
      "title": "گفت‌وگو: مع سائق سیارة الأجرة"
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
      "title": "متن و واژگان: ذوالقرنین"
     },
     {
      "title": "قواعد: فعل مجهول"
     },
     {
      "title": "گفت‌وگو: مع مسؤول استقبال الفندق"
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
      "title": "متن و واژگان: یا من فی البحار عجائبه"
     },
     {
      "title": "قواعد: جار و مجرور و نون وقایه"
     },
     {
      "title": "گفت‌وگو: مع مشرف خدمات الفندق"
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
      "title": "متن و واژگان: صناعة التلمیع فی الأدب الفارسی"
     },
     {
      "title": "قواعد: اسم فاعل، اسم مفعول و اسم مبالغه"
     },
     {
      "title": "گفت‌وگو: شراء شریحة الهاتف الجوال"
     },
     {
      "title": "تمرین‌های درس"
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
