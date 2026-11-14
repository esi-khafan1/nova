-- Textbook content and sources: docs/planner-topic-sources.md.
-- Conservative page spans; do not overwrite prior administrator edits.
with data as (select * from jsonb_to_recordset($books$[
 {
  "grade": "11",
  "subject": "علوم و فنون ادبی ۲",
  "fields": [
   "humanities"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱",
    "topics": [
     {
      "title": "تاریخ ادبیات فارسی در قرن‌های هفتم، هشتم و نهم",
      "start": 12,
      "end": 19
     },
     {
      "title": "پایه‌های آوایی",
      "start": 20,
      "end": 25
     },
     {
      "title": "تشبیه",
      "start": 26,
      "end": 33
     }
    ]
   },
   {
    "chapter": "فصل ۲",
    "topics": [
     {
      "title": "سبک‌شناسی قرن‌های هفتم، هشتم و نهم (سبک عراقی)",
      "start": 36,
      "end": 41
     },
     {
      "title": "پایه‌های آوایی همسان ۱",
      "start": 42,
      "end": 50
     },
     {
      "title": "مجاز",
      "start": 51,
      "end": 54
     }
    ]
   },
   {
    "chapter": "فصل ۳",
    "topics": [
     {
      "title": "تاریخ ادبیات فارسی در قرن‌های دهم و یازدهم",
      "start": 58,
      "end": 62
     },
     {
      "title": "پایه‌های آوایی همسان ۲",
      "start": 63,
      "end": 70
     },
     {
      "title": "استعاره",
      "start": 71,
      "end": 76
     }
    ]
   },
   {
    "chapter": "فصل ۴",
    "topics": [
     {
      "title": "سبک‌شناسی قرن‌های دهم و یازدهم (سبک هندی)",
      "start": 80,
      "end": 87
     },
     {
      "title": "پایه‌های آوایی همسان دولختی",
      "start": 88,
      "end": 94
     },
     {
      "title": "کنایه",
      "start": 95,
      "end": 99
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "علوم و فنون ادبی ۳",
  "fields": [
   "humanities"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱",
    "topics": [
     {
      "title": "تاریخ ادبیات قرن‌های دوازدهم و سیزدهم (دوره بازگشت و بیداری)",
      "start": 12,
      "end": 21
     },
     {
      "title": "پایه‌های آوایی ناهمسان",
      "start": 22,
      "end": 28
     },
     {
      "title": "مراعات نظیر، تلمیح و تضمین",
      "start": 29,
      "end": 37
     }
    ]
   },
   {
    "chapter": "فصل ۲",
    "topics": [
     {
      "title": "سبک‌شناسی قرن‌های دوازدهم و سیزدهم (دوره بازگشت و بیداری)",
      "start": 42,
      "end": 47
     },
     {
      "title": "اختیارات شاعری ۱: زبانی",
      "start": 48,
      "end": 56
     },
     {
      "title": "لف و نشر، تضاد و متناقض‌نما",
      "start": 57,
      "end": 63
     }
    ]
   },
   {
    "chapter": "فصل ۳",
    "topics": [
     {
      "title": "تاریخ ادبیات قرن چهاردهم (دوره معاصر و انقلاب اسلامی)",
      "start": 68,
      "end": 82
     },
     {
      "title": "اختیارات شاعری ۲: وزنی",
      "start": 83,
      "end": 87
     },
     {
      "title": "اغراق، ایهام و ایهام تناسب",
      "start": 88,
      "end": 92
     }
    ]
   },
   {
    "chapter": "فصل ۴",
    "topics": [
     {
      "title": "سبک‌شناسی دوره معاصر و انقلاب اسلامی",
      "start": 96,
      "end": 103
     },
     {
      "title": "وزن در شعر نیمایی",
      "start": 104,
      "end": 111
     },
     {
      "title": "حسن تعلیل، حس‌آمیزی و اسلوب معادله",
      "start": 112,
      "end": 117
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "ریاضی و آمار ۲",
  "fields": [
   "humanities"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱",
    "topics": [
     {
      "title": "گزاره‌ها و ترکیب گزاره‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "استدلال ریاضی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲",
    "topics": [
     {
      "title": "توابع ثابت، چندضابطه‌ای و همانی",
      "start": null,
      "end": null
     },
     {
      "title": "توابع پلکانی و قدر مطلقی",
      "start": null,
      "end": null
     },
     {
      "title": "اعمال بر روی توابع",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳",
    "topics": [
     {
      "title": "شاخص‌های آماری",
      "start": null,
      "end": null
     },
     {
      "title": "سری‌های زمانی",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "ریاضی و آمار ۳",
  "fields": [
   "humanities"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱",
    "topics": [
     {
      "title": "شمارش",
      "start": null,
      "end": null
     },
     {
      "title": "احتمال",
      "start": null,
      "end": null
     },
     {
      "title": "چرخه آمار در حل مسائل",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲",
    "topics": [
     {
      "title": "مدل‌سازی و دنباله",
      "start": null,
      "end": null
     },
     {
      "title": "دنباله‌های حسابی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳",
    "topics": [
     {
      "title": "دنباله هندسی",
      "start": null,
      "end": null
     },
     {
      "title": "ریشه nام و توان گویا",
      "start": null,
      "end": null
     },
     {
      "title": "تابع نمایی",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "ریاضی ۳",
  "fields": [
   "experimental_sciences"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: تابع",
    "topics": [
     {
      "title": "توابع چندجمله‌ای، توابع صعودی و نزولی",
      "start": null,
      "end": null
     },
     {
      "title": "ترکیب توابع",
      "start": null,
      "end": null
     },
     {
      "title": "تابع وارون",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: مثلثات",
    "topics": [
     {
      "title": "تناوب و تانژانت",
      "start": null,
      "end": null
     },
     {
      "title": "معادلات مثلثاتی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
    "topics": [
     {
      "title": "حد بی‌نهایت",
      "start": null,
      "end": null
     },
     {
      "title": "حد در بی‌نهایت",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۴: مشتق",
    "topics": [
     {
      "title": "آشنایی با مفهوم مشتق",
      "start": null,
      "end": null
     },
     {
      "title": "مشتق‌پذیری و پیوستگی",
      "start": null,
      "end": null
     },
     {
      "title": "آهنگ تغییر",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۵: کاربردهای مشتق",
    "topics": [
     {
      "title": "اکسترمم‌های تابع",
      "start": null,
      "end": null
     },
     {
      "title": "بهینه‌سازی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۶: هندسه",
    "topics": [
     {
      "title": "تفکر تجسمی و آشنایی با مقاطع مخروطی",
      "start": null,
      "end": null
     },
     {
      "title": "دایره",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۷: احتمال",
    "topics": [
     {
      "title": "قانون احتمال کل",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "حسابان ۲",
  "fields": [
   "mathematics"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: تابع",
    "topics": [
     {
      "title": "تبدیل نمودار توابع",
      "start": null,
      "end": null
     },
     {
      "title": "تابع درجه سوم، توابع یکنوا و بخش‌پذیری و تقسیم",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: مثلثات",
    "topics": [
     {
      "title": "تناوب و تانژانت",
      "start": null,
      "end": null
     },
     {
      "title": "معادلات مثلثاتی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: حدهای نامتناهی و حد در بی‌نهایت",
    "topics": [
     {
      "title": "حدهای نامتناهی",
      "start": null,
      "end": null
     },
     {
      "title": "حد در بی‌نهایت",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۴: مشتق",
    "topics": [
     {
      "title": "آشنایی با مفهوم مشتق",
      "start": null,
      "end": null
     },
     {
      "title": "مشتق‌پذیری و پیوستگی",
      "start": null,
      "end": null
     },
     {
      "title": "آهنگ متوسط تغییر و آهنگ لحظه‌ای تغییر",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۵: کاربردهای مشتق",
    "topics": [
     {
      "title": "اکسترمم‌های یک تابع و توابع صعودی و نزولی",
      "start": null,
      "end": null
     },
     {
      "title": "جهت تقعر نمودار یک تابع و نقطه عطف آن",
      "start": null,
      "end": null
     },
     {
      "title": "رسم نمودار تابع",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "هندسه ۳",
  "fields": [
   "mathematics"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: ماتریس و کاربردها",
    "topics": [
     {
      "title": "ماتریس و اعمال روی ماتریس‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "وارون ماتریس و دترمینان",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: آشنایی با مقاطع مخروطی",
    "topics": [
     {
      "title": "آشنایی با مقاطع مخروطی و مکان هندسی",
      "start": null,
      "end": null
     },
     {
      "title": "دایره",
      "start": null,
      "end": null
     },
     {
      "title": "بیضی و سهمی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: بردارها",
    "topics": [
     {
      "title": "معرفی فضای R3",
      "start": null,
      "end": null
     },
     {
      "title": "ضرب داخلی و ضرب خارجی بردارها",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "ریاضیات گسسته",
  "fields": [
   "mathematics"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: آشنایی با نظریه اعداد",
    "topics": [
     {
      "title": "استدلال ریاضی",
      "start": null,
      "end": null
     },
     {
      "title": "بخش‌پذیری در اعداد صحیح",
      "start": null,
      "end": null
     },
     {
      "title": "هم‌نهشتی در اعداد صحیح و کاربردها",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: گراف و مدل‌سازی",
    "topics": [
     {
      "title": "معرفی گراف",
      "start": null,
      "end": null
     },
     {
      "title": "مدل‌سازی با گراف",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: ترکیبیات",
    "topics": [
     {
      "title": "مباحثی در ترکیبیات",
      "start": null,
      "end": null
     },
     {
      "title": "روش‌هایی برای شمارش",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "شیمی ۱",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: کیهان، زادگاه الفبای هستی",
    "topics": [
     {
      "title": "عنصرها چگونه پدید آمدند؟",
      "start": null,
      "end": null
     },
     {
      "title": "آیا همه اتم‌های یک عنصر پایدارند؟",
      "start": null,
      "end": null
     },
     {
      "title": "طبقه‌بندی عنصرها",
      "start": null,
      "end": null
     },
     {
      "title": "نور، کلید شناخت جهان",
      "start": null,
      "end": null
     },
     {
      "title": "کشف ساختار اتم",
      "start": null,
      "end": null
     },
     {
      "title": "آرایش الکترونی اتم",
      "start": null,
      "end": null
     },
     {
      "title": "ساختار اتم و رفتار آن",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: ردپای گازها در زندگی",
    "topics": [
     {
      "title": "هواکره",
      "start": null,
      "end": null
     },
     {
      "title": "ترکیب اکسیژن با فلزها و نافلزها و ساختار لوویس",
      "start": null,
      "end": null
     },
     {
      "title": "خواص اکسیدهای فلزی و نافلزی",
      "start": null,
      "end": null
     },
     {
      "title": "واکنش‌های شیمیایی و قانون پایستگی جرم",
      "start": null,
      "end": null
     },
     {
      "title": "چه بر سر هواکره می‌آوریم؟",
      "start": null,
      "end": null
     },
     {
      "title": "خواص و رفتار گازها",
      "start": null,
      "end": null
     },
     {
      "title": "استوکیومتری واکنش‌ها",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: آب، آهنگ زندگی",
    "topics": [
     {
      "title": "آب‌کره",
      "start": null,
      "end": null
     },
     {
      "title": "محلول و مقدار حل‌شونده‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "آیا نمک‌ها به یک اندازه در آب حل می‌شوند؟",
      "start": null,
      "end": null
     },
     {
      "title": "رفتار آب و دیگر مولکول‌ها در میدان الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "نیروهای بین‌مولکولی آب، فراتر از انتظار",
      "start": null,
      "end": null
     },
     {
      "title": "آب و دیگر حلال‌ها و انحلال‌پذیری گازها",
      "start": null,
      "end": null
     },
     {
      "title": "ردپای آب در زندگی",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "12",
  "subject": "شیمی ۳",
  "fields": [
   "mathematics",
   "experimental_sciences"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: مولکول‌ها در خدمت تندرستی",
    "topics": [
     {
      "title": "زندگی با شوینده‌ها، آلاینده‌ها و پاک‌کننده‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "پاک‌کننده‌های غیرصابونی و خورنده",
      "start": null,
      "end": null
     },
     {
      "title": "اسیدها و بازها و رسانایی الکتریکی و درجه یونش اسیدها",
      "start": null,
      "end": null
     },
     {
      "title": "سامانه‌های تعادلی و pH محلول‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "واکنش شوینده‌های خورنده",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: آسایش و رفاه در سایه شیمی",
    "topics": [
     {
      "title": "الکتروشیمی و واکنش‌های اکسایش و کاهش",
      "start": null,
      "end": null
     },
     {
      "title": "تبدیل انرژی شیمیایی به الکتریکی",
      "start": null,
      "end": null
     },
     {
      "title": "تولید انرژی سبز با سلول سوختی و برقکافت",
      "start": null,
      "end": null
     },
     {
      "title": "خوردگی و رقابت برای اکسایش",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: شیمی، جلوه‌ای از هنر، زیبایی و ماندگاری",
    "topics": [
     {
      "title": "سیلیس رمز ماندگاری، گرافن و سازه‌های یخی",
      "start": null,
      "end": null
     },
     {
      "title": "رفتار مولکول‌ها و توزیع الکترون‌ها، شاره‌های مولکولی و یونی",
      "start": null,
      "end": null
     },
     {
      "title": "چینش یون‌ها در جامد یونی",
      "start": null,
      "end": null
     },
     {
      "title": "فلزها، عنصرهایی شکل‌پذیر با جلایی زیبا",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر",
    "topics": [
     {
      "title": "کاهش آلودگی هوا و انرژی فعال‌سازی واکنش‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "آمونیاک و بهره‌وری در کشاورزی و تغییر حجم سامانه در تعادل‌های گازی",
      "start": null,
      "end": null
     },
     {
      "title": "ارزش فناوری‌های شیمیایی و سنتز مولکول‌های آلی",
      "start": null,
      "end": null
     },
     {
      "title": "بطری PET و بازیافت آن",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "علوم و فنون ادبی ۱",
  "fields": [
   "humanities"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱",
    "topics": [
     {
      "title": "مبانی تحلیل متن",
      "start": 12,
      "end": 20
     },
     {
      "title": "سازه‌ها و عوامل تأثیرگذار در شعر فارسی",
      "start": 21,
      "end": 25
     },
     {
      "title": "واج‌آرایی، واژه‌آرایی",
      "start": 26,
      "end": 30
     }
    ]
   },
   {
    "chapter": "فصل ۲",
    "topics": [
     {
      "title": "تاریخ ادبیات پیش از اسلام و قرن‌های اولیه هجری",
      "start": 38,
      "end": 46
     },
     {
      "title": "هماهنگی پاره‌های کلام",
      "start": 47,
      "end": 51
     },
     {
      "title": "سجع و انواع آن",
      "start": 52,
      "end": 55
     }
    ]
   },
   {
    "chapter": "فصل ۳",
    "topics": [
     {
      "title": "سبک و سبک‌شناسی (سبک خراسانی)",
      "start": 60,
      "end": 66
     },
     {
      "title": "وزن شعر فارسی",
      "start": 67,
      "end": 72
     },
     {
      "title": "موازنه و ترصیع",
      "start": 73,
      "end": 76
     }
    ]
   },
   {
    "chapter": "فصل ۴",
    "topics": [
     {
      "title": "زبان و ادبیات فارسی در سده‌های پنجم و ششم و ویژگی‌های سبکی آن",
      "start": 80,
      "end": 87
     },
     {
      "title": "قافیه",
      "start": 88,
      "end": 96
     },
     {
      "title": "جناس و انواع آن",
      "start": 97,
      "end": 101
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "ریاضی و آمار ۱",
  "fields": [
   "humanities"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱",
    "topics": [
     {
      "title": "معادله و مسائل توصیفی",
      "start": null,
      "end": null
     },
     {
      "title": "حل معادله درجه دوم و کاربردها",
      "start": null,
      "end": null
     },
     {
      "title": "معادله‌های شامل عبارت‌های گویا",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲",
    "topics": [
     {
      "title": "مفهوم تابع",
      "start": null,
      "end": null
     },
     {
      "title": "ضابطه جبری تابع",
      "start": null,
      "end": null
     },
     {
      "title": "نمودار تابع خطی",
      "start": null,
      "end": null
     },
     {
      "title": "رسم تابع درجه دوم",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳",
    "topics": [
     {
      "title": "گردآوری داده‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "معیارهای گرایش به مرکز",
      "start": null,
      "end": null
     },
     {
      "title": "معیارهای پراکندگی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۴",
    "topics": [
     {
      "title": "نمودارهای یک متغیره",
      "start": null,
      "end": null
     },
     {
      "title": "نمودارهای چند متغیره",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "10",
  "subject": "هندسه ۱",
  "fields": [
   "mathematics"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: ترسیم‌های هندسی و استدلال",
    "topics": [
     {
      "title": "ترسیم‌های هندسی",
      "start": 10,
      "end": 16
     },
     {
      "title": "استدلال",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: قضیه تالس، تشابه و کاربردهای آن",
    "topics": [
     {
      "title": "نسبت و تناسب در هندسه",
      "start": 30,
      "end": 33
     },
     {
      "title": "قضیه تالس",
      "start": 34,
      "end": 37
     },
     {
      "title": "تشابه مثلث‌ها",
      "start": 38,
      "end": 44
     },
     {
      "title": "کاربردهایی از قضیه تالس و تشابه مثلث‌ها",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: چندضلعی‌ها",
    "topics": [
     {
      "title": "چندضلعی‌ها و ویژگی‌هایی از آنها",
      "start": 54,
      "end": 64
     },
     {
      "title": "مساحت و کاربردهای آن",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۴: تجسم فضایی",
    "topics": [
     {
      "title": "خط، نقطه و صفحه",
      "start": 78,
      "end": 86
     },
     {
      "title": "تفکر تجسمی",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "هندسه ۲",
  "fields": [
   "mathematics"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: دایره",
    "topics": [
     {
      "title": "مفاهیم اولیه و زاویه‌ها در دایره",
      "start": null,
      "end": null
     },
     {
      "title": "رابطه‌های طولی در دایره",
      "start": null,
      "end": null
     },
     {
      "title": "چندضلعی‌های محاطی و محیطی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: تبدیل‌های هندسی و کاربردها",
    "topics": [
     {
      "title": "تبدیل‌های هندسی",
      "start": null,
      "end": null
     },
     {
      "title": "کاربرد تبدیل‌ها",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: روابط طولی در مثلث",
    "topics": [
     {
      "title": "قضیه سینوس‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "قضیه کسینوس‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "قضیه نیمسازهای زوایای داخلی و محاسبه طول نیمسازها",
      "start": null,
      "end": null
     },
     {
      "title": "قضیه هرون (محاسبه ارتفاع‌ها و مساحت مثلث)",
      "start": null,
      "end": null
     }
    ]
   }
  ]
 },
 {
  "grade": "11",
  "subject": "آمار و احتمال",
  "fields": [
   "mathematics"
  ],
  "tracks": [
   "konkur",
   "final_exam"
  ],
  "chapters": [
   {
    "chapter": "فصل ۱: آشنایی با مبانی ریاضیات",
    "topics": [
     {
      "title": "آشنایی با منطق ریاضی",
      "start": null,
      "end": null
     },
     {
      "title": "جبر مجموعه‌ها",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۲: احتمال",
    "topics": [
     {
      "title": "مبانی احتمال",
      "start": null,
      "end": null
     },
     {
      "title": "احتمال غیرهم‌شانس",
      "start": null,
      "end": null
     },
     {
      "title": "احتمال شرطی",
      "start": null,
      "end": null
     },
     {
      "title": "پیشامدهای مستقل و وابسته",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۳: آمار توصیفی",
    "topics": [
     {
      "title": "توصیف و نمایش داده‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "معیارهای گرایش به مرکز",
      "start": null,
      "end": null
     },
     {
      "title": "معیارهای پراکندگی",
      "start": null,
      "end": null
     }
    ]
   },
   {
    "chapter": "فصل ۴: آمار استنباطی",
    "topics": [
     {
      "title": "گردآوری داده‌ها",
      "start": null,
      "end": null
     },
     {
      "title": "برآورد",
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
   "mathematics"
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
      "title": "میدان الکتریکی در داخل رساناها",
      "start": null,
      "end": null
     },
     {
      "title": "خازن",
      "start": null,
      "end": null
     },
     {
      "title": "خازن با دی‌الکتریک",
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
    "chapter": "فصل ۳: مغناطیس",
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
     }
    ]
   },
   {
    "chapter": "فصل ۴: القای الکترومغناطیسی و جریان متناوب",
    "topics": [
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
 }
]$books$::jsonb)
 as b(grade text,subject text,fields jsonb,tracks jsonb,chapters jsonb)), expanded as (
 select b.grade,b.subject, f.field,t.track,c.item->>'chapter' chapter,topic.item->>'title' title,
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
