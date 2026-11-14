-- Religion 12 (mathematics/experimental): whole-lesson spans and study groupings.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "12",
  "subject": "تعلیمات دینی ۳",
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
      "title": "کل درس: هستی‌بخش",
      "start": 6,
      "end": 17
     },
     {
      "title": "نیازمندی جهان به خدا در پیدایش"
     },
     {
      "title": "نیازمندی جهان به خدا در بقا"
     },
     {
      "title": "آگاهی، سرچشمه بندگی و نور هستی"
     },
     {
      "title": "ناتوانی در شناخت ذات و چیستی خداوند"
     }
    ]
   },
   {
    "chapter": "درس ۲",
    "topics": [
     {
      "title": "کل درس: یگانه بی‌همتا",
      "start": 18,
      "end": 29
     },
     {
      "title": "توحید و یکتاپرستی"
     },
     {
      "title": "مراتب توحید: خالقیت، مالکیت، ولایت و ربوبیت"
     },
     {
      "title": "شرک و مراتب آن"
     },
     {
      "title": "توسل و شفاعت"
     }
    ]
   },
   {
    "chapter": "درس ۳",
    "topics": [
     {
      "title": "کل درس: توحید و سبک زندگی",
      "start": 30,
      "end": 41
     },
     {
      "title": "بازتاب توحید در زندگی"
     },
     {
      "title": "بعد فردی توحید عملی"
     },
     {
      "title": "بعد اجتماعی توحید عملی"
     },
     {
      "title": "توحید و شرک در جهان امروز"
     }
    ]
   },
   {
    "chapter": "درس ۴",
    "topics": [
     {
      "title": "کل درس: فقط برای تو",
      "start": 42,
      "end": 51
     },
     {
      "title": "اخلاص در بندگی"
     },
     {
      "title": "نیت و حسن فاعلی و فعلی"
     },
     {
      "title": "راه‌های تقویت اخلاص"
     },
     {
      "title": "میوه‌های درخت اخلاص"
     }
    ]
   },
   {
    "chapter": "درس ۵",
    "topics": [
     {
      "title": "کل درس: قدرت پرواز",
      "start": 52,
      "end": 63
     },
     {
      "title": "اختیار و نشانه‌های آن"
     },
     {
      "title": "زمینه‌ساز شکوفایی اختیار"
     },
     {
      "title": "قضا و قدر الهی"
     },
     {
      "title": "اختیار انسان و اراده خدا"
     }
    ]
   },
   {
    "chapter": "درس ۶",
    "topics": [
     {
      "title": "کل درس: سنت‌های خداوند در زندگی",
      "start": 64,
      "end": 75
     },
     {
      "title": "سنت امتحان و ابتلا"
     },
     {
      "title": "سنت امداد و توفیق"
     },
     {
      "title": "سبقت رحمت بر غضب"
     },
     {
      "title": "سنت املا و استدراج"
     },
     {
      "title": "تأثیر اعمال انسان در زندگی"
     }
    ]
   },
   {
    "chapter": "درس ۷",
    "topics": [
     {
      "title": "کل درس: بازگشت",
      "start": 80,
      "end": 93
     },
     {
      "title": "حقیقت توبه و پاکی از گناه"
     },
     {
      "title": "توبه و حیله‌های شیطان"
     },
     {
      "title": "مراحل تکمیلی توبه"
     },
     {
      "title": "توبه اجتماعی"
     }
    ]
   },
   {
    "chapter": "درس ۸",
    "topics": [
     {
      "title": "کل درس: زندگی در دنیای امروز و عمل به احکام الهی",
      "start": 94,
      "end": 107
     },
     {
      "title": "احکام الهی و زندگی امروز"
     },
     {
      "title": "عرصه فرهنگ"
     },
     {
      "title": "عرصه ورزش و بازی"
     },
     {
      "title": "عرصه اقتصاد"
     }
    ]
   },
   {
    "chapter": "درس ۹",
    "topics": [
     {
      "title": "کل درس: پایه‌های استوار",
      "start": 108,
      "end": 125
     },
     {
      "title": "معیار توحید و معاد"
     },
     {
      "title": "معیار ولایت و حکومت"
     },
     {
      "title": "معیار عدالت اجتماعی"
     },
     {
      "title": "جایگاه خانواده"
     },
     {
      "title": "جایگاه علم و دانش"
     }
    ]
   },
   {
    "chapter": "درس ۱۰",
    "topics": [
     {
      "title": "کل درس: تمدن جدید و مسئولیت ما"
     },
     {
      "title": "زمینه‌های پیدایش تمدن جدید"
     },
     {
      "title": "آثار و پیامدهای تمدن جدید در حوزه علم"
     },
     {
      "title": "عدل و قسط و مسئولیت ما"
     },
     {
      "title": "خانواده و مسئولیت ما"
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
