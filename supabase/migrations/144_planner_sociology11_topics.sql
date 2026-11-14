-- Society 2 lessons 4–15: study groupings, see docs/planner-topic-sources.md.
-- Unknown section page spans are null; existing bank edits are never overwritten.
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
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "عقاید و ارزش‌های جهانی اسلام"
     },
     {
      "title": "گسترش فرهنگ اسلامی در عصر نبوی و دوران خلافت"
     },
     {
      "title": "دوران استعمار و بیداری اسلامی"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "باورها و ارزش‌های بنیادین فرهنگ غرب"
     },
     {
      "title": "سکولاریسم و نگاه هستی‌شناختی"
     },
     {
      "title": "اومانیسم و نگاه انسان‌شناختی"
     },
     {
      "title": "روشنگری و نگاه معرفت‌شناختی"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "دوره‌های تاریخی فرهنگ غرب"
     },
     {
      "title": "رنسانس و دگرگونی هنر، دین و فلسفه"
     },
     {
      "title": "تکوین علم و فناوری و اقتصاد جدید"
     },
     {
      "title": "تحولات حقوقی و سیاسی غرب"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "جامعه جهانی و شکل‌های آن"
     },
     {
      "title": "جامعه جهانی پیش از غرب جدید"
     },
     {
      "title": "جامعه جهانی در دوران جدید"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "تحولات اقتصادی و سیاسی نظام جهانی"
     },
     {
      "title": "دولت‌ ملت‌ها و استعمار"
     },
     {
      "title": "جهانی‌شدن و شرکت‌های چندملیتی"
     },
     {
      "title": "رسانه، علم و فرهنگ در نظام جهانی"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "چالش فقر و غنا و لیبرالیسم اولیه"
     },
     {
      "title": "مارکسیسم، سوسیالیسم و کمونیسم"
     },
     {
      "title": "جهان دوقطبی شرق و غرب"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "جنگ‌های جهانی اول و دوم"
     },
     {
      "title": "جنگ سرد و جنگ‌های مناطق پیرامونی"
     },
     {
      "title": "نظریه جنگ تمدن‌ها"
     },
     {
      "title": "شمال و جنوب و مرکز و پیرامون"
     }
    ]
   },
   {
    "chapter": "درس ۱۱",
    "topics": [
     {
      "title": "نظام، تعادل و بحران"
     },
     {
      "title": "بحران‌های اقتصادی و پیامدهای جهانی آنها"
     },
     {
      "title": "بحران‌های زیست‌محیطی"
     }
    ]
   },
   {
    "chapter": "درس ۱۲",
    "topics": [
     {
      "title": "چالش‌های بنیادین فرهنگ غرب"
     },
     {
      "title": "بحران معرفتی و سیر شناخت"
     },
     {
      "title": "بحران معنوی و اخلاقی"
     }
    ]
   },
   {
    "chapter": "درس ۱۳",
    "topics": [
     {
      "title": "رویارویی جوامع اسلامی با جهان غرب"
     },
     {
      "title": "نخستین بیدارگران اسلامی"
     },
     {
      "title": "جنبش‌ها و نقاط ضعف بیداری نخستین"
     }
    ]
   },
   {
    "chapter": "درس ۱۴",
    "topics": [
     {
      "title": "جنبش تنباکو و عدالتخانه"
     },
     {
      "title": "انقلاب مشروطه و برداشت‌های متفاوت"
     },
     {
      "title": "انقلاب اسلامی و بیداری اسلامی"
     }
    ]
   },
   {
    "chapter": "درس ۱۵",
    "topics": [
     {
      "title": "انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم"
     },
     {
      "title": "جغرافیای فرهنگی جهان جدید"
     },
     {
      "title": "افق بیداری اسلامی و مواجهه فرهنگ‌ها"
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
