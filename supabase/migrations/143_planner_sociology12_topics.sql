-- Society 3 lessons 3–10: secondary-source study groupings, see source notes.
-- Section page ranges remain null until verified in the 1405 textbook.
with data as (select * from jsonb_to_recordset($books$[
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
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "نظم اجتماعی و قواعد زندگی جمعی"
     },
     {
      "title": "آشنایی‌زدایی و شناخت نظم اجتماعی"
     },
     {
      "title": "دانش عملی و دانش علمی درباره نظم"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "کنش اجتماعی و ساختار اجتماعی"
     },
     {
      "title": "تأثیر کنش‌ها بر حفظ و تغییر جامعه"
     },
     {
      "title": "پیامدهای نادیده گرفتن معنای کنش اجتماعی"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "پرسش از معنای زندگی و معنای کنش"
     },
     {
      "title": "پیچیدگی پدیده‌های انسانی و اجتماعی"
     },
     {
      "title": "رویکرد تفسیری به معنای زندگی"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "قدرت اجتماعی، مقبولیت و مشروعیت"
     },
     {
      "title": "قدرت سخت و قدرت نرم"
     },
     {
      "title": "سیاست و انواع نظام سیاسی"
     },
     {
      "title": "جامعه‌شناسی و ارزش‌های سیاسی"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "تفاوت‌های اسمی و رتبه‌ای"
     },
     {
      "title": "نابرابری اجتماعی و توزیع فرصت‌ها"
     },
     {
      "title": "رویکردهای نابرابری اجتماعی"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "هویت ملی و شکل‌گیری سیاست‌گذاری هویتی"
     },
     {
      "title": "سیاست همانندسازی هویت‌ها"
     },
     {
      "title": "سیاست تکثرگرایی و تنوع هویت‌ها"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "علوم نافع و روش‌های شناخت"
     },
     {
      "title": "علوم اجتماعی در قرآن و سنت‌های الهی"
     },
     {
      "title": "متفکران مسلمان و علوم اجتماعی"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "ویژگی‌های تمدن اسلامی"
     },
     {
      "title": "مسئله‌ها و نیازهای علوم اجتماعی جهان اسلام"
     },
     {
      "title": "آگاهی و عمل در حیات اجتماعی"
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
