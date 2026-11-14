-- Sources and verification boundaries: docs/planner-topic-sources.md
-- Insert-only so that reapplying seeds never overwrites administrator edits.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "10",
  "subject": "فیزیک ۱",
  "fields": [
   "experimental_sciences"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
    "topics": [
     {
      "title": "فیزیک؛ دانش بنیادی",
      "start": null,
      "end": null
     },
     {
      "title": "مدل‌سازی در فیزیک",
      "start": null,
      "end": null
     },
     {
      "title": "اندازه‌گیری و کمیت‌های فیزیکی",
      "start": null,
      "end": null
     },
     {
      "title": "اندازه‌گیری و دستگاه بین‌المللی یکاها",
      "start": null,
      "end": null
     },
     {
      "title": "اندازه‌گیری و دقت وسیله‌های اندازه‌گیری",
      "start": null,
      "end": null
     },
     {
      "title": "چگالی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
    "topics": [
     {
      "title": "حالت‌های ماده",
      "start": null,
      "end": null
     },
     {
      "title": "نیروهای بین مولکولی",
      "start": null,
      "end": null
     },
     {
      "title": "فشار در شاره‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "شناوری",
      "start": null,
      "end": null
     },
     {
      "title": "شاره در حرکت و اصل برنولی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: کار، انرژی و توان",
    "topics": [
     {
      "title": "انرژی جنبشی",
      "start": null,
      "end": null
     },
     {
      "title": "کار انجام شده توسط نیروی ثابت",
      "start": null,
      "end": null
     },
     {
      "title": "کار و انرژی جنبشی",
      "start": null,
      "end": null
     },
     {
      "title": "کار و انرژی پتانسیل",
      "start": null,
      "end": null
     },
     {
      "title": "پایستگی انرژی مکانیکی",
      "start": null,
      "end": null
     },
     {
      "title": "کار و انرژی درونی",
      "start": null,
      "end": null
     },
     {
      "title": "توان",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۴: دما و گرما",
    "topics": [
     {
      "title": "دما و دماسنجی",
      "start": null,
      "end": null
     },
     {
      "title": "انبساط گرمایی",
      "start": null,
      "end": null
     },
     {
      "title": "گرما",
      "start": null,
      "end": null
     },
     {
      "title": "تغییر حالت‌های ماده",
      "start": null,
      "end": null
     },
     {
      "title": "روش‌های انتقال گرما",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "فیزیک ۱",
  "fields": [
   "mathematics"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: فیزیک و اندازه‌گیری",
    "topics": [
     {
      "title": "فیزیک؛ دانش بنیادی",
      "start": null,
      "end": null
     },
     {
      "title": "مدل‌سازی در فیزیک",
      "start": null,
      "end": null
     },
     {
      "title": "اندازه‌گیری و کمیت‌های فیزیکی",
      "start": null,
      "end": null
     },
     {
      "title": "اندازه‌گیری و دستگاه بین‌المللی یکاها",
      "start": null,
      "end": null
     },
     {
      "title": "اندازه‌گیری و دقت وسیله‌های اندازه‌گیری",
      "start": null,
      "end": null
     },
     {
      "title": "چگالی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: ویژگی‌های فیزیکی مواد",
    "topics": [
     {
      "title": "حالت‌های ماده",
      "start": null,
      "end": null
     },
     {
      "title": "نیروهای بین مولکولی",
      "start": null,
      "end": null
     },
     {
      "title": "فشار در شاره‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "شناوری",
      "start": null,
      "end": null
     },
     {
      "title": "شاره در حرکت و اصل برنولی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: کار، انرژی و توان",
    "topics": [
     {
      "title": "انرژی جنبشی",
      "start": null,
      "end": null
     },
     {
      "title": "کار انجام شده توسط نیروی ثابت",
      "start": null,
      "end": null
     },
     {
      "title": "کار و انرژی جنبشی",
      "start": null,
      "end": null
     },
     {
      "title": "کار و انرژی پتانسیل",
      "start": null,
      "end": null
     },
     {
      "title": "پایستگی انرژی مکانیکی",
      "start": null,
      "end": null
     },
     {
      "title": "کار و انرژی درونی",
      "start": null,
      "end": null
     },
     {
      "title": "توان",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۴: دما و گرما",
    "topics": [
     {
      "title": "دما و دماسنجی",
      "start": null,
      "end": null
     },
     {
      "title": "انبساط گرمایی",
      "start": null,
      "end": null
     },
     {
      "title": "گرما",
      "start": null,
      "end": null
     },
     {
      "title": "تغییر حالت‌های ماده",
      "start": null,
      "end": null
     },
     {
      "title": "روش‌های انتقال گرما",
      "start": null,
      "end": null
     },
     {
      "title": "قوانین گازها",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۵: ترمودینامیک",
    "topics": [
     {
      "title": "معادله حالت و فرآیندهای ترمودینامیکی ایستاوار",
      "start": null,
      "end": null
     },
     {
      "title": "تبادل انرژی",
      "start": null,
      "end": null
     },
     {
      "title": "انرژی درونی و قانون اول ترمودینامیک",
      "start": null,
      "end": null
     },
     {
      "title": "برخی از فرآیندهای ترمودینامیکی",
      "start": null,
      "end": null
     },
     {
      "title": "چرخه ترمودینامیکی",
      "start": null,
      "end": null
     },
     {
      "title": "ماشین‌های گرمایی",
      "start": null,
      "end": null
     },
     {
      "title": "قانون دوم ترمودینامیک به بیان ماشین گرمایی",
      "start": null,
      "end": null
     },
     {
      "title": "قانون دوم ترمودینامیک و یخچال‌ها",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "فیزیک ۲",
  "fields": [
   "experimental_sciences"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: الکتریسیته ساکن",
    "topics": [
     {
      "title": "بار الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "پایستگی و کوانتیده بودن بار الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "قانون کولن",
      "start": null,
      "end": null
     },
     {
      "title": "میدان الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "میدان الکتریکی حاصل از یک ذره باردار",
      "start": null,
      "end": null
     },
     {
      "title": "خطوط میدان الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "انرژی پتانسیل الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "پتانسیل الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "توزیع بار الکتریکی در اجسام رسانا",
      "start": null,
      "end": null
     },
     {
      "title": "خازن",
      "start": null,
      "end": null
     },
     {
      "title": "انرژی خازن",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: جریان الکتریکی و مدارهای جریان مستقیم",
    "topics": [
     {
      "title": "جریان الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "مقاومت الکتریکی و قانون اهم",
      "start": null,
      "end": null
     },
     {
      "title": "عوامل مؤثر بر مقاومت الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "نیروی محرکه الکتریکی و مدارها",
      "start": null,
      "end": null
     },
     {
      "title": "توان در مدارهای الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "ترکیب مقاومت‌ها",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: مغناطیس و القای الکترومغناطیسی",
    "topics": [
     {
      "title": "مغناطیس و قطب‌های مغناطیسی",
      "start": null,
      "end": null
     },
     {
      "title": "میدان مغناطیسی",
      "start": null,
      "end": null
     },
     {
      "title": "نیروی مغناطیسی وارد بر ذره باردار متحرک در میدان مغناطیسی",
      "start": null,
      "end": null
     },
     {
      "title": "نیروی مغناطیسی وارد بر سیم حامل جریان",
      "start": null,
      "end": null
     },
     {
      "title": "میدان مغناطیسی حاصل از جریان الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "ویژگی‌های مغناطیسی مواد",
      "start": null,
      "end": null
     },
     {
      "title": "پدیده القای الکترومغناطیسی",
      "start": null,
      "end": null
     },
     {
      "title": "قانون القای الکترومغناطیسی فاراده",
      "start": null,
      "end": null
     },
     {
      "title": "قانون لنز",
      "start": null,
      "end": null
     },
     {
      "title": "القاگرها",
      "start": null,
      "end": null
     },
     {
      "title": "جریان متناوب",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "فیزیک ۳",
  "fields": [
   "experimental_sciences"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: حرکت بر خط راست",
    "topics": [
     {
      "title": "شناخت حرکت",
      "start": null,
      "end": null
     },
     {
      "title": "حرکت با سرعت ثابت",
      "start": null,
      "end": null
     },
     {
      "title": "حرکت با شتاب ثابت",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: دینامیک",
    "topics": [
     {
      "title": "قوانین حرکت نیوتون",
      "start": null,
      "end": null
     },
     {
      "title": "معرفی برخی از نیروهای خاص",
      "start": null,
      "end": null
     },
     {
      "title": "تکانه و قانون دوم نیوتون",
      "start": null,
      "end": null
     },
     {
      "title": "نیروی گرانشی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: نوسان و موج",
    "topics": [
     {
      "title": "نوسان دوره‌ای",
      "start": null,
      "end": null
     },
     {
      "title": "حرکت هماهنگ ساده",
      "start": null,
      "end": null
     },
     {
      "title": "انرژی در حرکت هماهنگ ساده",
      "start": null,
      "end": null
     },
     {
      "title": "تشدید",
      "start": null,
      "end": null
     },
     {
      "title": "موج و انواع آن",
      "start": null,
      "end": null
     },
     {
      "title": "مشخصه‌های موج",
      "start": null,
      "end": null
     },
     {
      "title": "بازتاب موج",
      "start": null,
      "end": null
     },
     {
      "title": "شکست موج",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای",
    "topics": [
     {
      "title": "اثر فوتوالکتریک و فوتون",
      "start": null,
      "end": null
     },
     {
      "title": "طیف خطی",
      "start": null,
      "end": null
     },
     {
      "title": "مدل اتم رادرفورد-بور",
      "start": null,
      "end": null
     },
     {
      "title": "لیزر",
      "start": null,
      "end": null
     },
     {
      "title": "ساختار هسته",
      "start": null,
      "end": null
     },
     {
      "title": "پرتوزایی طبیعی و نیمه عمر",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "فیزیک ۳",
  "fields": [
   "mathematics"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: حرکت بر خط راست",
    "topics": [
     {
      "title": "شناخت حرکت",
      "start": null,
      "end": null
     },
     {
      "title": "حرکت با سرعت ثابت",
      "start": null,
      "end": null
     },
     {
      "title": "حرکت با شتاب ثابت",
      "start": null,
      "end": null
     },
     {
      "title": "سقوط آزاد",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: دینامیک و حرکت دایره‌ای",
    "topics": [
     {
      "title": "قوانین حرکت نیوتون",
      "start": null,
      "end": null
     },
     {
      "title": "معرفی برخی از نیروهای خاص",
      "start": null,
      "end": null
     },
     {
      "title": "تکانه و قانون دوم نیوتون",
      "start": null,
      "end": null
     },
     {
      "title": "حرکت دایره‌ای یکنواخت",
      "start": null,
      "end": null
     },
     {
      "title": "نیروی گرانشی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: نوسان و موج",
    "topics": [
     {
      "title": "نوسان دوره‌ای",
      "start": null,
      "end": null
     },
     {
      "title": "حرکت هماهنگ ساده",
      "start": null,
      "end": null
     },
     {
      "title": "انرژی در حرکت هماهنگ ساده",
      "start": null,
      "end": null
     },
     {
      "title": "تشدید",
      "start": null,
      "end": null
     },
     {
      "title": "موج و انواع آن",
      "start": null,
      "end": null
     },
     {
      "title": "مشخصه‌های موج",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۴: برهم‌کنش‌های موج",
    "topics": [
     {
      "title": "بازتاب موج",
      "start": null,
      "end": null
     },
     {
      "title": "شکست موج",
      "start": null,
      "end": null
     },
     {
      "title": "پراش موج",
      "start": null,
      "end": null
     },
     {
      "title": "تداخل امواج",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۵: آشنایی با فیزیک اتمی",
    "topics": [
     {
      "title": "اثر فوتوالکتریک و فوتون",
      "start": null,
      "end": null
     },
     {
      "title": "طیف خطی",
      "start": null,
      "end": null
     },
     {
      "title": "مدل اتم رادرفورد-بور",
      "start": null,
      "end": null
     },
     {
      "title": "لیزر",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۶: آشنایی با فیزیک هسته‌ای",
    "topics": [
     {
      "title": "ساختار هسته",
      "start": null,
      "end": null
     },
     {
      "title": "پرتوزایی طبیعی و نیمه عمر",
      "start": null,
      "end": null
     },
     {
      "title": "شکافت هسته‌ای",
      "start": null,
      "end": null
     },
     {
      "title": "گداخت (همجوشی) هسته‌ای",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "نگارش ۱",
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
    "chapter": "درس‌ها",
    "topics": [
     {
      "title": "پرورش موضوع",
      "start": null,
      "end": null
     },
     {
      "title": "عینک نوشتن",
      "start": null,
      "end": null
     },
     {
      "title": "نوشته‌های عینی",
      "start": null,
      "end": null
     },
     {
      "title": "نوشته‌های گزارش‌گونه",
      "start": null,
      "end": null
     },
     {
      "title": "نوشته ذهنی ۱: جانشین‌سازی",
      "start": null,
      "end": null
     },
     {
      "title": "نوشته ذهنی ۲: سنجش و مقایسه",
      "start": null,
      "end": null
     },
     {
      "title": "نوشته ذهنی ۳: ناسازی معنایی یا تضاد مفاهیم",
      "start": null,
      "end": null
     },
     {
      "title": "نوشته‌های داستان‌گونه",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "نگارش ۲",
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
    "chapter": "درس‌ها",
    "topics": [
     {
      "title": "اجزای نوشته: ساختار و محتوا",
      "start": null,
      "end": null
     },
     {
      "title": "گسترش محتوا ۱: زمان و مکان",
      "start": null,
      "end": null
     },
     {
      "title": "گسترش محتوا ۲: شخصیت",
      "start": null,
      "end": null
     },
     {
      "title": "گسترش محتوا ۳: گفت‌وگو",
      "start": null,
      "end": null
     },
     {
      "title": "سفرنامه",
      "start": null,
      "end": null
     },
     {
      "title": "کاهش محتوا: خلاصه‌نویسی",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "نگارش ۳",
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
    "chapter": "درس‌ها",
    "topics": [
     {
      "title": "خاطره‌نگاری",
      "start": 12,
      "end": 26
     },
     {
      "title": "نگارش ادبی ۱: نثر ادبی",
      "start": 30,
      "end": 40
     },
     {
      "title": "نگارش ادبی ۲: قطعه ادبی",
      "start": 44,
      "end": 56
     },
     {
      "title": "نامه‌نگاری",
      "start": 60,
      "end": 75
     },
     {
      "title": "نگارش علمی: مقاله‌نویسی ۱",
      "start": 80,
      "end": 92
     },
     {
      "title": "نگارش علمی: مقاله‌نویسی ۲",
      "start": 96,
      "end": 103
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "انسان و محیط زیست",
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
    "chapter": "درس‌ها",
    "topics": [
     {
      "title": "آب، سرچشمه زندگی",
      "start": null,
      "end": null
     },
     {
      "title": "خاک، بستر زندگی",
      "start": null,
      "end": null
     },
     {
      "title": "هوا، نفس زندگی",
      "start": null,
      "end": null
     },
     {
      "title": "انرژی، حرکت، زندگی",
      "start": null,
      "end": null
     },
     {
      "title": "زباله، فاجعه محیط زیست",
      "start": null,
      "end": null
     },
     {
      "title": "تنوع زیستی، تابلوی زیبای آفرینش",
      "start": null,
      "end": null
     },
     {
      "title": "محیط زیست، بستر گردشگری مسئولانه",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "زبان خارجی ۲",
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
    "chapter": "درس‌ها",
    "topics": [
     {
      "title": "Understanding People",
      "start": 15,
      "end": 47
     },
     {
      "title": "A Healthy Lifestyle",
      "start": 49,
      "end": 79
     },
     {
      "title": "Art and Culture",
      "start": 81,
      "end": 107
     }
    ]
   }
  ]
 },
 {
  "grade": "9",
  "subject": "زبان انگلیسی",
  "fields": [
   "all"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس‌ها",
    "topics": [
     {
      "title": "Personality",
      "start": null,
      "end": null
     },
     {
      "title": "Travel",
      "start": null,
      "end": null
     },
     {
      "title": "Festivals and Ceremonies",
      "start": null,
      "end": null
     },
     {
      "title": "Services",
      "start": null,
      "end": null
     },
     {
      "title": "Media",
      "start": null,
      "end": null
     },
     {
      "title": "Health and Injuries",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "زبان خارجی ۳",
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
    "chapter": "درس‌ها",
    "topics": [
     {
      "title": "Sense of Appreciation",
      "start": 15,
      "end": 41
     },
     {
      "title": "Look it Up!",
      "start": 43,
      "end": 69
     },
     {
      "title": "Renewable Energy",
      "start": 71,
      "end": 99
     }
    ]
   }
  ]
 },
 {
  "grade": "9",
  "subject": "نگارش",
  "fields": [
   "all"
  ],
  "tracks": [
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "درس‌ها",
    "topics": [
     {
      "title": "با ذهنی نظام‌مند و پرورده بنویسیم",
      "start": null,
      "end": null
     },
     {
      "title": "واژه‌ها را بشناسیم، گزینش کنیم و به کار بگیریم",
      "start": null,
      "end": null
     },
     {
      "title": "نوع زبان نوشته را انتخاب کنیم",
      "start": null,
      "end": null
     },
     {
      "title": "فضا و رنگ نوشته را تغییر دهیم",
      "start": null,
      "end": null
     },
     {
      "title": "نوشته را خوش آغاز کنیم؛ زیبا به پایان ببریم و نیکو نام‌گذاری کنیم",
      "start": null,
      "end": null
     },
     {
      "title": "قالبی برای نوشتن برگزینیم",
      "start": null,
      "end": null
     },
     {
      "title": "وسعت و عمق نوشته را بیشتر کنیم",
      "start": null,
      "end": null
     },
     {
      "title": "نوشته را ویرایش کنیم",
      "start": null,
      "end": null
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
