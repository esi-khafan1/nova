-- Shared school books: printed sections and study groups; unknown page ranges stay null.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "10",
  "subject": "کارگاه کارآفرینی و تولید",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "بخش‌های ۱ تا ۴",
    "topics": [
     {
      "title": "بخش ۱: تشکیل تیم"
     },
     {
      "title": "بخش ۲: کار تیمی موفق"
     },
     {
      "title": "بخش ۳: تقویت کار تیمی"
     },
     {
      "title": "بخش ۴: حل مسئله"
     }
    ]
   },
   {
    "chapter": "بخش‌های ۵ تا ۹",
    "topics": [
     {
      "title": "بخش ۵: هدف‌گذاری و تصمیم‌گیری"
     },
     {
      "title": "بخش ۶: خودشناسی"
     },
     {
      "title": "بخش ۷: طراحی مسیر شغلی: کارگاه توسعه شخصی"
     },
     {
      "title": "بخش ۸: طراحی مسیر شغلی: شناسایی ارزش‌ها و نیازها"
     },
     {
      "title": "بخش ۹: طراحی مسیر شغلی: شناسایی مهارت‌ها، استعدادها و علایق"
     }
    ]
   },
   {
    "chapter": "بخش‌های ۱۰ تا ۱۷",
    "topics": [
     {
      "title": "بخش ۱۰: تفکر"
     },
     {
      "title": "بخش ۱۱: تفکر خلاق (واگرا)"
     },
     {
      "title": "بخش ۱۲: توسعه خلاقیت فردی"
     },
     {
      "title": "بخش ۱۳: توسعه خلاقیت تیمی"
     },
     {
      "title": "بخش ۱۴: تشخیص فرصت، ایده‌پردازی و ارزیابی ایده"
     },
     {
      "title": "بخش ۱۵: ایده‌یابی، ساختن ایده و الگوبرداری"
     },
     {
      "title": "بخش ۱۶: نوآوری و تریز"
     },
     {
      "title": "بخش ۱۷: سنجش کارآفرینی"
     }
    ]
   },
   {
    "chapter": "بخش‌های ۱۸ تا ۲۷",
    "topics": [
     {
      "title": "بخش ۱۸: تعیین نوع کسب و کار",
      "start": 79,
      "end": 80
     },
     {
      "title": "بخش ۱۹: مدل کسب و کار: مشتری‌شناسی",
      "start": 81,
      "end": 84
     },
     {
      "title": "بخش ۲۰: مدل کسب و کار: طراحی ارزش پیشنهادی",
      "start": 85,
      "end": 88
     },
     {
      "title": "بخش ۲۱: مدل کسب و کار: تعیین کانال توزیع",
      "start": 89,
      "end": 90
     },
     {
      "title": "بخش ۲۲: مدل کسب و کار: ارتباط با مشتریان",
      "start": 91,
      "end": 92
     },
     {
      "title": "بخش ۲۳: مدل کسب و کار: درآمدزایی",
      "start": 93,
      "end": 96
     },
     {
      "title": "بخش ۲۴: مدل کسب و کار: منبع‌یابی",
      "start": 97,
      "end": 98
     },
     {
      "title": "بخش ۲۵: مدل کسب و کار: فعالیت‌های کلیدی",
      "start": 99,
      "end": 100
     },
     {
      "title": "بخش ۲۶: مدل کسب و کار: شریک‌یابی",
      "start": 101,
      "end": 102
     },
     {
      "title": "بخش ۲۷: مدل کسب و کار: برآورد هزینه",
      "start": 103,
      "end": 104
     }
    ]
   },
   {
    "chapter": "بخش‌های ۲۸ تا ۳۲",
    "topics": [
     {
      "title": "بخش ۲۸: طرح کسب و کار",
      "start": 105,
      "end": 108
     },
     {
      "title": "بخش ۲۹: نگارش طرح: معرفی کسب و کار و برنامه نیروی انسانی",
      "start": 109,
      "end": 114
     },
     {
      "title": "بخش ۳۰: نگارش طرح: بازار و بازاریابی",
      "start": 115,
      "end": 118
     },
     {
      "title": "بخش ۳۱: نگارش طرح: برنامه تولید",
      "start": 119,
      "end": 122
     },
     {
      "title": "بخش ۳۲: نگارش طرح: برنامه مالی و زمان‌بندی",
      "start": 123,
      "end": 127
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "آمادگی دفاعی",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: آموزه‌های دفاعی",
    "topics": [
     {
      "title": "درس ۱: امنیت پایدار",
      "start": 2,
      "end": 10
     },
     {
      "title": "درس ۲: اقتدار دفاعی",
      "start": 11,
      "end": 18
     }
    ]
   },
   {
    "chapter": "فصل ۲: فرهنگ دفاع",
    "topics": [
     {
      "title": "درس ۳: انقلاب اسلامی"
     },
     {
      "title": "درس ۴: آشنایی با بسیج"
     },
     {
      "title": "درس ۵: علوم و معارف دفاع مقدس"
     },
     {
      "title": "درس ۶: الگوها و اسوه‌های پایداری و مقاومت"
     }
    ]
   },
   {
    "chapter": "فصل ۳: دفاع نظامی",
    "topics": [
     {
      "title": "درس ۷: آشنایی با نیروهای مسلح و خدمت مقدس سربازی"
     },
     {
      "title": "درس ۸: نظام جمع و شیوه‌های رزم انفرادی"
     },
     {
      "title": "درس ۹: جنگ‌افزارشناسی و اصول تیراندازی",
      "start": 78,
      "end": 116
     }
    ]
   },
   {
    "chapter": "فصل ۴: دفاع غیرنظامی",
    "topics": [
     {
      "title": "درس ۱۰: شناخت و مقابله با جنگ نرم",
      "start": 118,
      "end": 125
     },
     {
      "title": "درس ۱۱: پدافند غیرعامل",
      "start": 126,
      "end": 135
     },
     {
      "title": "درس ۱۲: ایمنی و پیشگیری",
      "start": 136,
      "end": 145
     },
     {
      "title": "درس ۱۳: امداد و نجات"
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "علوم اجتماعی",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس ۱: کنش‌های ما",
    "topics": [
     {
      "title": "کنش و کنشگر"
     },
     {
      "title": "آگاهی، اراده و هدف در کنش"
     },
     {
      "title": "آثار و پیامدهای کنش"
     }
    ]
   },
   {
    "chapter": "درس ۲: پدیده‌های اجتماعی",
    "topics": [
     {
      "title": "کنش اجتماعی"
     },
     {
      "title": "شکل‌گیری و انواع پدیده‌های اجتماعی"
     },
     {
      "title": "پیوند کنش‌ها و پدیده‌های اجتماعی"
     }
    ]
   },
   {
    "chapter": "درس ۳: جامعه و فرهنگ",
    "topics": [
     {
      "title": "جامعه و فرهنگ"
     },
     {
      "title": "الزامات و فرصت‌های جهان اجتماعی"
     },
     {
      "title": "محدودیت‌های جامعه و فرهنگ"
     }
    ]
   },
   {
    "chapter": "درس ۴: ارزیابی فرهنگ‌ها",
    "topics": [
     {
      "title": "فرهنگ واقعی و فرهنگ آرمانی"
     },
     {
      "title": "فرهنگ حق و فرهنگ باطل"
     },
     {
      "title": "معیار ارزیابی فرهنگ‌ها"
     }
    ]
   },
   {
    "chapter": "درس ۵: هویت",
    "topics": [
     {
      "title": "هویت فردی و اجتماعی"
     },
     {
      "title": "نسبت هویت فرد و جامعه"
     },
     {
      "title": "خودآگاهی و هویت"
     }
    ]
   },
   {
    "chapter": "درس ۶: بازتولید هویت اجتماعی",
    "topics": [
     {
      "title": "جامعه‌پذیری"
     },
     {
      "title": "کنترل اجتماعی و روش‌های آن"
     },
     {
      "title": "تحرک اجتماعی"
     }
    ]
   },
   {
    "chapter": "درس ۷: تحولات هویتی جامعه",
    "topics": [
     {
      "title": "علل درونی تحولات هویتی"
     },
     {
      "title": "تعامل فرهنگی جوامع"
     },
     {
      "title": "خودباختگی فرهنگی"
     }
    ]
   },
   {
    "chapter": "درس ۸: بعد فرهنگی هویت ایران",
    "topics": [
     {
      "title": "ویژگی‌های هویت فرهنگی ایران"
     },
     {
      "title": "نقش اسلام در هویت ایرانی"
     },
     {
      "title": "انقلاب اسلامی و هویت فرهنگی"
     }
    ]
   },
   {
    "chapter": "درس ۹: بعد سیاسی هویت ایران",
    "topics": [
     {
      "title": "رابطه نظام سیاسی و فرهنگ"
     },
     {
      "title": "انواع نظام سیاسی"
     },
     {
      "title": "هویت سیاسی ایران و جمهوری اسلامی"
     }
    ]
   },
   {
    "chapter": "درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران",
    "topics": [
     {
      "title": "جمعیت و هویت اجتماعی"
     },
     {
      "title": "وضعیت جمعیت ایران"
     },
     {
      "title": "اقتصاد و هویت اقتصادی ایران"
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "تعلیمات دینی ۲",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس ۱: هدایت الهی",
    "topics": [
     {
      "title": "نیازهای طبیعی و نیازهای برتر"
     },
     {
      "title": "پاسخ به نیازهای برتر"
     },
     {
      "title": "شیوه هدایت خداوند"
     }
    ]
   },
   {
    "chapter": "درس ۲: تداوم هدایت",
    "topics": [
     {
      "title": "فطرت مشترک و دین واحد"
     },
     {
      "title": "علل فرستادن پیامبران متعدد"
     },
     {
      "title": "ختم نبوت و عوامل آن"
     }
    ]
   },
   {
    "chapter": "درس ۳: معجزه جاویدان",
    "topics": [
     {
      "title": "معجزه پیامبران و معجزه جاویدان"
     },
     {
      "title": "تحدی قرآن"
     },
     {
      "title": "جنبه‌های اعجاز قرآن"
     }
    ]
   },
   {
    "chapter": "درس ۴: مسئولیت‌های پیامبر",
    "topics": [
     {
      "title": "دریافت و ابلاغ وحی"
     },
     {
      "title": "مرجعیت دینی و تبیین قرآن"
     },
     {
      "title": "ولایت ظاهری و معنوی"
     },
     {
      "title": "عصمت پیامبر"
     }
    ]
   },
   {
    "chapter": "درس ۵: امامت، تداوم رسالت",
    "topics": [
     {
      "title": "استمرار امامت"
     },
     {
      "title": "تعیین امام"
     },
     {
      "title": "آیات و احادیث امامت"
     }
    ]
   },
   {
    "chapter": "درس ۶: پیشوایان اسوه",
    "topics": [
     {
      "title": "اسوه‌های رهبری"
     },
     {
      "title": "ویژگی‌های سیره پیامبر"
     },
     {
      "title": "رهبری و اصلاحات امام علی"
     }
    ]
   },
   {
    "chapter": "درس ۷: وضعیت فرهنگی، اجتماعی و سیاسی مسلمانان پس از رحلت پیامبر",
    "topics": [
     {
      "title": "رویدادهای پس از رحلت پیامبر"
     },
     {
      "title": "چالش‌های سیاسی، اجتماعی و فرهنگی عصر امامان"
     },
     {
      "title": "تحریف معارف و جعل حدیث"
     }
    ]
   },
   {
    "chapter": "درس ۸: احیای ارزش‌های راستین",
    "topics": [
     {
      "title": "احیای معارف اسلامی"
     },
     {
      "title": "مجاهده در راستای ولایت ظاهری"
     },
     {
      "title": "وظیفه ما در برابر پیامبر و امامان"
     }
    ]
   },
   {
    "chapter": "درس ۹: عصر غیبت",
    "topics": [
     {
      "title": "غیبت صغری و کبری"
     },
     {
      "title": "رهبری امام در عصر غیبت"
     },
     {
      "title": "انتظار و آمادگی برای ظهور"
     }
    ]
   },
   {
    "chapter": "درس ۱۰: مرجعیت و ولایت فقیه",
    "topics": [
     {
      "title": "تداوم مسئولیت‌های امام در عصر غیبت"
     },
     {
      "title": "مرجع تقلید و شرایط آن"
     },
     {
      "title": "ولایت فقیه و انتخاب رهبر"
     }
    ]
   },
   {
    "chapter": "درس ۱۱: عزت نفس",
    "topics": [
     {
      "title": "عزت و ذلت"
     },
     {
      "title": "راه‌های تقویت عزت نفس"
     },
     {
      "title": "اسوه‌های عزت نفس"
     },
     {
      "title": "ایستادگی در برابر تمایلات پست"
     }
    ]
   },
   {
    "chapter": "درس ۱۲: پیوند مقدس",
    "topics": [
     {
      "title": "اهمیت ازدواج و تشکیل خانواده"
     },
     {
      "title": "ویژگی‌های زن و مرد و زندگی مشترک"
     },
     {
      "title": "مسئولیت و روابط اعضای خانواده"
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
