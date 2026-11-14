-- Science 9 study groupings, with sources and limitations in docs/planner-topic-sources.md.
-- Unverified page spans are null; never overwrite administrator edits.
with data as (select * from jsonb_to_recordset($books$[
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
    "chapter": "فصل ۴: حرکت چیست",
    "topics": [
     {
      "title": "مسافت و جابه‌جایی"
     },
     {
      "title": "تندی متوسط و لحظه‌ای"
     },
     {
      "title": "حرکت یکنواخت و سرعت"
     },
     {
      "title": "شتاب متوسط"
     }
    ]
   },
   {
    "chapter": "فصل ۵: نیرو",
    "topics": [
     {
      "title": "نیرو و نیروهای متوازن"
     },
     {
      "title": "قانون‌های نیوتن"
     },
     {
      "title": "نیروی خالص"
     },
     {
      "title": "نیروی وزن"
     },
     {
      "title": "کنش و واکنش"
     }
    ]
   },
   {
    "chapter": "فصل ۶: زمین‌ساخت ورقه‌ای",
    "topics": [
     {
      "title": "قاره‌های متحرک و نظریه وگنر"
     },
     {
      "title": "گسترش بستر اقیانوس‌ها"
     },
     {
      "title": "حرکت ورقه‌های سنگ‌کره"
     },
     {
      "title": "پیامدهای حرکت ورقه‌ها"
     }
    ]
   },
   {
    "chapter": "فصل ۷: آثاری از گذشته زمین",
    "topics": [
     {
      "title": "سنگواره‌ها و شرایط تشکیل آنها"
     },
     {
      "title": "راه‌های تشکیل سنگواره"
     },
     {
      "title": "کاربرد سنگواره‌ها و تعیین سن لایه‌ها"
     }
    ]
   },
   {
    "chapter": "فصل ۸: فشار و آثار آن",
    "topics": [
     {
      "title": "فشار و رابطه نیرو و سطح"
     },
     {
      "title": "فشار مایعات و عوامل مؤثر بر آن"
     },
     {
      "title": "فشار هوا"
     },
     {
      "title": "اصل پاسکال"
     }
    ]
   },
   {
    "chapter": "فصل ۹: ماشین‌ها",
    "topics": [
     {
      "title": "کار و نقش ماشین‌ها"
     },
     {
      "title": "مزیت مکانیکی"
     },
     {
      "title": "اهرم‌ها"
     },
     {
      "title": "قرقره‌ها"
     },
     {
      "title": "سطح شیب‌دار و چرخ و محور"
     }
    ]
   },
   {
    "chapter": "فصل ۱۰: نگاهی به فضا",
    "topics": [
     {
      "title": "کهکشان‌ها"
     },
     {
      "title": "ستاره‌ها و صورت‌های فلکی"
     },
     {
      "title": "سامانه خورشیدی و سیاره‌ها"
     },
     {
      "title": "قمرها و سیارک‌ها"
     },
     {
      "title": "سفر به فضا"
     }
    ]
   },
   {
    "chapter": "فصل ۱۱: گوناگونی جانداران",
    "topics": [
     {
      "title": "گروه‌بندی و کلید شناسایی جانداران"
     },
     {
      "title": "گونه و نام‌گذاری علمی"
     },
     {
      "title": "باکتری‌ها"
     },
     {
      "title": "آغازیان"
     },
     {
      "title": "قارچ‌ها"
     }
    ]
   },
   {
    "chapter": "فصل ۱۲: دنیای گیاهان",
    "topics": [
     {
      "title": "گیاهان بدون آوند و خزه‌ها"
     },
     {
      "title": "گیاهان آونددار و سرخس‌ها"
     },
     {
      "title": "بازدانگان"
     },
     {
      "title": "نهاندانگان و تک‌لپه‌ای و دولپه‌ای"
     }
    ]
   },
   {
    "chapter": "فصل ۱۳: جانوران بی‌مهره",
    "topics": [
     {
      "title": "اسفنج‌ها و کیسه‌تنان"
     },
     {
      "title": "کرم‌ها و نرم‌تنان"
     },
     {
      "title": "بندپایان"
     },
     {
      "title": "خارپوستان"
     }
    ]
   },
   {
    "chapter": "فصل ۱۴: جانوران مهره‌دار",
    "topics": [
     {
      "title": "ماهی‌ها"
     },
     {
      "title": "دوزیستان"
     },
     {
      "title": "خزندگان"
     },
     {
      "title": "پرندگان"
     },
     {
      "title": "پستانداران"
     }
    ]
   },
   {
    "chapter": "فصل ۱۵: باهم‌زیستن",
    "topics": [
     {
      "title": "بوم‌سازگان و اجزای آن"
     },
     {
      "title": "زنجیره و شبکه غذایی"
     },
     {
      "title": "شکار و رقابت"
     },
     {
      "title": "همزیستی: همیاری، همسفرگی و انگلی"
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
