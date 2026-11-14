-- Grade 12 Arabic: edition 1405, study groupings; unverified page spans remain null.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "12",
  "subject": "عربی ۳ تخصصی",
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
      "title": "متن و واژگان: من الأشعار المنسوبة إلی الإمام علی"
     },
     {
      "title": "قواعد: حروف مشبهة بالفعل و لای نفی جنس"
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
      "title": "متن و واژگان: الوجه النافع و الوجه المضر"
     },
     {
      "title": "قواعد: حال"
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
      "title": "متن و واژگان: ثلاث قصص قصیرة"
     },
     {
      "title": "قواعد: استثنا و حصر"
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
      "title": "متن و واژگان: نظام الطبیعة"
     },
     {
      "title": "قواعد: مفعول مطلق"
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
      "title": "متن و واژگان: یا إلهی"
     },
     {
      "title": "قواعد: ندا"
     },
     {
      "title": "تمرین‌های درس"
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "عربی زبان قرآن ۳",
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
      "title": "متن و واژگان: الدین و التدین"
     },
     {
      "title": "قواعد: حروف مشبهة بالفعل و لای نفی جنس"
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
      "title": "متن و واژگان: مکة المکرمة و المدینة المنورة"
     },
     {
      "title": "قواعد: حال"
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
      "title": "متن و واژگان: الکتب طعام الفکر"
     },
     {
      "title": "قواعد: استثنا"
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
      "title": "متن و واژگان: الفرزدق"
     },
     {
      "title": "قواعد: مفعول مطلق"
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
