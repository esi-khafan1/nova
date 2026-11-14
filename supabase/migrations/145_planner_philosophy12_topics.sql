-- Philosophy 2 lessons 4–12: secondary-source study groupings; see source notes.
-- Unverified page spans remain null; existing bank edits are not overwritten.
with data as (select * from jsonb_to_recordset($books$[
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
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "معانی چهارگانه اتفاق"
     },
     {
      "title": "بررسی ضرورت و سنخیت علت و معلول"
     },
     {
      "title": "غایتمندی جهان و حادثه پیش‌بینی‌نشده"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "خدا در دیدگاه افلاطون و ارسطو"
     },
     {
      "title": "خدا در فلسفه دکارت، هیوم و کانت"
     },
     {
      "title": "باور به خدا و معنای زندگی"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "برهان علیت فارابی"
     },
     {
      "title": "برهان وجوب و امکان ابن‌سینا"
     },
     {
      "title": "امکان فقری و بیان ملاصدرا"
     },
     {
      "title": "خدا و معنای زندگی"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "عقل به عنوان قوه استدلال و عالم عقول"
     },
     {
      "title": "عقل نظری و عقل عملی در اندیشه ارسطو"
     },
     {
      "title": "عقل در دوران کلیسا و عصر جدید اروپا"
     },
     {
      "title": "دیدگاه دکارت و تجربه‌گرایان درباره عقل"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "عقلانیت و مخالفت با فلسفه در جهان اسلام"
     },
     {
      "title": "عالم عقول و عقل فعال"
     },
     {
      "title": "مراتب رشد عقل نزد فارابی و ابن‌سینا"
     },
     {
      "title": "رابطه عقل، دین و راه‌های معرفت"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "زمینه‌های رشد فلسفه در جهان اسلام"
     },
     {
      "title": "ترجمه و گسترش دانش فلسفی"
     },
     {
      "title": "فارابی و حکمت مشاء"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "ابن‌سینا و طبیعت و نظام احسن"
     },
     {
      "title": "سهروردی و حکمت اشراق"
     },
     {
      "title": "نورالانوار و مراتب نور"
     },
     {
      "title": "استدلال و شهود در حکمت اشراقی"
     }
    ]
   },
   {
    "chapter": "درس ۱۱",
    "topics": [
     {
      "title": "فیلسوفان دوره صفوی و حکمت متعالیه"
     },
     {
      "title": "اصالت وجود"
     },
     {
      "title": "وحدت حقیقت وجود"
     },
     {
      "title": "مراتب و شدت و ضعف وجود"
     }
    ]
   },
   {
    "chapter": "درس ۱۲",
    "topics": [
     {
      "title": "حکمت معاصر و رویارویی با فلسفه جدید"
     },
     {
      "title": "علامه طباطبایی و احیای فلسفه و تفسیر"
     },
     {
      "title": "امام خمینی و فلسفه معاصر"
     },
     {
      "title": "نظام فکری و عملی شهید مطهری"
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
