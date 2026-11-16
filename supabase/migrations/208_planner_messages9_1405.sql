-- Messages of Heaven 9 (902), user PDF 1405, printed pages.
with installed as (insert into private.planner_seed_installations(seed_key) values ('messages9-1405-v208') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "chapter": "درس ۱: تو را چگونه بشناسم؟",
  "title": "کل درس",
  "start": 11,
  "end": 19,
  "position": 1
 },
 {
  "chapter": "درس ۱: تو را چگونه بشناسم؟",
  "title": "راه‌های شناخت صفات خداوند: تفکر در کتاب آسمانی",
  "start": 12,
  "end": 14,
  "position": 10
 },
 {
  "chapter": "درس ۱: تو را چگونه بشناسم؟",
  "title": "تفکر در کتاب خلقت",
  "start": 15,
  "end": 15,
  "position": 11
 },
 {
  "chapter": "درس ۱: تو را چگونه بشناسم؟",
  "title": "پرسش درباره نسبت دادن صفات مخلوقات به خدا",
  "start": 16,
  "end": 16,
  "position": 12
 },
 {
  "chapter": "درس ۱: تو را چگونه بشناسم؟",
  "title": "حمد و تسبیح",
  "start": 17,
  "end": 17,
  "position": 13
 },
 {
  "chapter": "درس ۱: تو را چگونه بشناسم؟",
  "title": "خودت را امتحان کن",
  "start": 18,
  "end": 18,
  "position": 14
 },
 {
  "chapter": "درس ۱: تو را چگونه بشناسم؟",
  "title": "نیایش",
  "start": 19,
  "end": 19,
  "position": 15
 },
 {
  "chapter": "درس ۲: در پناه ایمان",
  "title": "کل درس",
  "start": 21,
  "end": 29,
  "position": 1
 },
 {
  "chapter": "درس ۲: در پناه ایمان",
  "title": "حقیقت ایمان",
  "start": 22,
  "end": 22,
  "position": 10
 },
 {
  "chapter": "درس ۲: در پناه ایمان",
  "title": "آثار ایمان: آرامش و رهایی از سردرگمی",
  "start": 23,
  "end": 23,
  "position": 11
 },
 {
  "chapter": "درس ۲: در پناه ایمان",
  "title": "راه‌های دستیابی و تقویت ایمان: یاد خدا",
  "start": 24,
  "end": 25,
  "position": 12
 },
 {
  "chapter": "درس ۲: در پناه ایمان",
  "title": "کار نیک، دوری از گناه و الگوهای مؤمن",
  "start": 26,
  "end": 26,
  "position": 13
 },
 {
  "chapter": "درس ۲: در پناه ایمان",
  "title": "نشانه‌های انسان مؤمن",
  "start": 27,
  "end": 27,
  "position": 14
 },
 {
  "chapter": "درس ۲: در پناه ایمان",
  "title": "خودت را امتحان کن",
  "start": 28,
  "end": 28,
  "position": 15
 },
 {
  "chapter": "درس ۲: در پناه ایمان",
  "title": "نیایش",
  "start": 29,
  "end": 29,
  "position": 16
 },
 {
  "chapter": "درس ۳: راهنمایان الهی",
  "title": "کل درس",
  "start": 33,
  "end": 43,
  "position": 1
 },
 {
  "chapter": "درس ۳: راهنمایان الهی",
  "title": "تسلیم در برابر امر خداوند",
  "start": 34,
  "end": 34,
  "position": 10
 },
 {
  "chapter": "درس ۳: راهنمایان الهی",
  "title": "استقامت و پایداری در راه خدا",
  "start": 35,
  "end": 38,
  "position": 11
 },
 {
  "chapter": "درس ۳: راهنمایان الهی",
  "title": "مبارزه با عقاید باطل و خرافات",
  "start": 39,
  "end": 41,
  "position": 12
 },
 {
  "chapter": "درس ۳: راهنمایان الهی",
  "title": "فعالیت و خودت را امتحان کن",
  "start": 42,
  "end": 42,
  "position": 13
 },
 {
  "chapter": "درس ۳: راهنمایان الهی",
  "title": "نیایش",
  "start": 43,
  "end": 43,
  "position": 14
 },
 {
  "chapter": "درس ۴: خورشید پنهان",
  "title": "کل درس",
  "start": 45,
  "end": 53,
  "position": 1
 },
 {
  "chapter": "درس ۴: خورشید پنهان",
  "title": "عقیده‌ای اثرگذار",
  "start": 46,
  "end": 46,
  "position": 10
 },
 {
  "chapter": "درس ۴: خورشید پنهان",
  "title": "پرسش درباره طول عمر و زمان قیام امام مهدی",
  "start": 47,
  "end": 47,
  "position": 11
 },
 {
  "chapter": "درس ۴: خورشید پنهان",
  "title": "پرسش درباره اتفاقات پس از قیام",
  "start": 48,
  "end": 48,
  "position": 12
 },
 {
  "chapter": "درس ۴: خورشید پنهان",
  "title": "یاران امام و منتظران حقیقی",
  "start": 49,
  "end": 51,
  "position": 13
 },
 {
  "chapter": "درس ۴: خورشید پنهان",
  "title": "خودت را امتحان کن",
  "start": 52,
  "end": 52,
  "position": 14
 },
 {
  "chapter": "درس ۴: خورشید پنهان",
  "title": "نیایش و عهد",
  "start": 53,
  "end": 53,
  "position": 15
 },
 {
  "chapter": "درس ۵: رهبری در دوران غیبت",
  "title": "کل درس",
  "start": 55,
  "end": 63,
  "position": 1
 },
 {
  "chapter": "درس ۵: رهبری در دوران غیبت",
  "title": "هدایتگران عصر غیبت",
  "start": 56,
  "end": 58,
  "position": 10
 },
 {
  "chapter": "درس ۵: رهبری در دوران غیبت",
  "title": "بیدارگر قرن",
  "start": 59,
  "end": 61,
  "position": 11
 },
 {
  "chapter": "درس ۵: رهبری در دوران غیبت",
  "title": "خودت را امتحان کن",
  "start": 62,
  "end": 62,
  "position": 12
 },
 {
  "chapter": "درس ۵: رهبری در دوران غیبت",
  "title": "نیایش",
  "start": 63,
  "end": 63,
  "position": 13
 },
 {
  "chapter": "درس ۶: وضو، غسل و تیمم",
  "title": "کل درس",
  "start": 67,
  "end": 75,
  "position": 1
 },
 {
  "chapter": "درس ۶: وضو، غسل و تیمم",
  "title": "شرایط وضوی صحیح: پاک و مطلق بودن آب",
  "start": 68,
  "end": 68,
  "position": 10
 },
 {
  "chapter": "درس ۶: وضو، غسل و تیمم",
  "title": "شرایط وضوی صحیح: مباح بودن و پاک بودن اعضا، ترتیب و موالات",
  "start": 69,
  "end": 69,
  "position": 11
 },
 {
  "chapter": "درس ۶: وضو، غسل و تیمم",
  "title": "فعالیت بررسی صحت وضو",
  "start": 70,
  "end": 70,
  "position": 12
 },
 {
  "chapter": "درس ۶: وضو، غسل و تیمم",
  "title": "غسل ترتیبی و موارد تیمم",
  "start": 71,
  "end": 71,
  "position": 13
 },
 {
  "chapter": "درس ۶: وضو، غسل و تیمم",
  "title": "شیوه انجام تیمم",
  "start": 72,
  "end": 72,
  "position": 14
 },
 {
  "chapter": "درس ۶: وضو، غسل و تیمم",
  "title": "باطل‌کننده‌های وضو و تیمم",
  "start": 73,
  "end": 73,
  "position": 15
 },
 {
  "chapter": "درس ۶: وضو، غسل و تیمم",
  "title": "دعای وضو",
  "start": 74,
  "end": 75,
  "position": 16
 },
 {
  "chapter": "درس ۷: احکام نماز",
  "title": "کل درس",
  "start": 77,
  "end": 83,
  "position": 1
 },
 {
  "chapter": "درس ۷: احکام نماز",
  "title": "مبطلات نماز",
  "start": 78,
  "end": 78,
  "position": 10
 },
 {
  "chapter": "درس ۷: احکام نماز",
  "title": "ادامه مبطلات و مسائل مهم نماز",
  "start": 79,
  "end": 79,
  "position": 11
 },
 {
  "chapter": "درس ۷: احکام نماز",
  "title": "مسائل مهم نماز",
  "start": 80,
  "end": 80,
  "position": 12
 },
 {
  "chapter": "درس ۷: احکام نماز",
  "title": "فعالیت و خودت را امتحان کن",
  "start": 81,
  "end": 81,
  "position": 13
 },
 {
  "chapter": "درس ۷: احکام نماز",
  "title": "حدیث‌هایی درباره نماز",
  "start": 82,
  "end": 82,
  "position": 14
 },
 {
  "chapter": "درس ۷: احکام نماز",
  "title": "دعای بعد از نماز",
  "start": 83,
  "end": 83,
  "position": 15
 },
 {
  "chapter": "درس ۸: همدلی و همراهی",
  "title": "کل درس",
  "start": 87,
  "end": 97,
  "position": 1
 },
 {
  "chapter": "درس ۸: همدلی و همراهی",
  "title": "انتخاب سرنوشت‌ساز و بهترین دوست",
  "start": 88,
  "end": 88,
  "position": 10
 },
 {
  "chapter": "درس ۸: همدلی و همراهی",
  "title": "ویژگی‌های دوست: اندیشه و دوری از گناه",
  "start": 89,
  "end": 89,
  "position": 11
 },
 {
  "chapter": "درس ۸: همدلی و همراهی",
  "title": "خیرخواهی دوست",
  "start": 90,
  "end": 91,
  "position": 12
 },
 {
  "chapter": "درس ۸: همدلی و همراهی",
  "title": "حدود و وظایف دوستی",
  "start": 92,
  "end": 92,
  "position": 13
 },
 {
  "chapter": "درس ۸: همدلی و همراهی",
  "title": "میانه‌روی در دوستی",
  "start": 93,
  "end": 93,
  "position": 14
 },
 {
  "chapter": "درس ۸: همدلی و همراهی",
  "title": "من و تنهایی",
  "start": 94,
  "end": 94,
  "position": 15
 },
 {
  "chapter": "درس ۸: همدلی و همراهی",
  "title": "دوستی در فضای مجازی",
  "start": 95,
  "end": 95,
  "position": 16
 },
 {
  "chapter": "درس ۸: همدلی و همراهی",
  "title": "خودت را امتحان کن",
  "start": 96,
  "end": 96,
  "position": 17
 },
 {
  "chapter": "درس ۸: همدلی و همراهی",
  "title": "نیایش",
  "start": 97,
  "end": 97,
  "position": 18
 },
 {
  "chapter": "درس ۹: انقلاب اسلامی ایران",
  "title": "کل درس",
  "start": 101,
  "end": 109,
  "position": 1
 },
 {
  "chapter": "درس ۹: انقلاب اسلامی ایران",
  "title": "مقایسه دیروز با امروز",
  "start": 102,
  "end": 104,
  "position": 10
 },
 {
  "chapter": "درس ۹: انقلاب اسلامی ایران",
  "title": "نقشه‌های شیطانی",
  "start": 105,
  "end": 105,
  "position": 11
 },
 {
  "chapter": "درس ۹: انقلاب اسلامی ایران",
  "title": "شبیخون فرهنگی",
  "start": 106,
  "end": 107,
  "position": 12
 },
 {
  "chapter": "درس ۹: انقلاب اسلامی ایران",
  "title": "فعالیت و خودت را امتحان کن",
  "start": 108,
  "end": 108,
  "position": 13
 },
 {
  "chapter": "درس ۹: انقلاب اسلامی ایران",
  "title": "نیایش",
  "start": 109,
  "end": 109,
  "position": 14
 },
 {
  "chapter": "درس ۱۰: مسئولیت همگانی",
  "title": "کل درس",
  "start": 111,
  "end": 119,
  "position": 1
 },
 {
  "chapter": "درس ۱۰: مسئولیت همگانی",
  "title": "امر به معروف و نهی از منکر",
  "start": 112,
  "end": 113,
  "position": 10
 },
 {
  "chapter": "درس ۱۰: مسئولیت همگانی",
  "title": "آثار ترک امر به معروف و نهی از منکر",
  "start": 114,
  "end": 115,
  "position": 11
 },
 {
  "chapter": "درس ۱۰: مسئولیت همگانی",
  "title": "سرگذشت اهل شنبه",
  "start": 116,
  "end": 116,
  "position": 12
 },
 {
  "chapter": "درس ۱۰: مسئولیت همگانی",
  "title": "شیوه‌های امر به معروف و نهی از منکر",
  "start": 117,
  "end": 117,
  "position": 13
 },
 {
  "chapter": "درس ۱۰: مسئولیت همگانی",
  "title": "فعالیت و خودت را امتحان کن",
  "start": 118,
  "end": 118,
  "position": 14
 },
 {
  "chapter": "درس ۱۰: مسئولیت همگانی",
  "title": "نیایش",
  "start": 119,
  "end": 119,
  "position": 15
 },
 {
  "chapter": "درس ۱۱: انفاق",
  "title": "کل درس",
  "start": 121,
  "end": 131,
  "position": 1
 },
 {
  "chapter": "درس ۱۱: انفاق",
  "title": "انفاق",
  "start": 122,
  "end": 123,
  "position": 10
 },
 {
  "chapter": "درس ۱۱: انفاق",
  "title": "انواع انفاق: زکات",
  "start": 124,
  "end": 124,
  "position": 11
 },
 {
  "chapter": "درس ۱۱: انفاق",
  "title": "خمس",
  "start": 125,
  "end": 125,
  "position": 12
 },
 {
  "chapter": "درس ۱۱: انفاق",
  "title": "انفاق مستحب و قرض",
  "start": 126,
  "end": 126,
  "position": 13
 },
 {
  "chapter": "درس ۱۱: انفاق",
  "title": "وقف",
  "start": 127,
  "end": 129,
  "position": 14
 },
 {
  "chapter": "درس ۱۱: انفاق",
  "title": "خودت را امتحان کن",
  "start": 130,
  "end": 130,
  "position": 15
 },
 {
  "chapter": "درس ۱۱: انفاق",
  "title": "نیایش",
  "start": 131,
  "end": 131,
  "position": 16
 },
 {
  "chapter": "درس ۱۲: جهاد",
  "title": "کل درس",
  "start": 133,
  "end": 143,
  "position": 1
 },
 {
  "chapter": "درس ۱۲: جهاد",
  "title": "جهاد در اسلام",
  "start": 134,
  "end": 136,
  "position": 10
 },
 {
  "chapter": "درس ۱۲: جهاد",
  "title": "انواع جهاد: جهاد دفاعی",
  "start": 137,
  "end": 138,
  "position": 11
 },
 {
  "chapter": "درس ۱۲: جهاد",
  "title": "جهاد ابتدایی",
  "start": 139,
  "end": 139,
  "position": 12
 },
 {
  "chapter": "درس ۱۲: جهاد",
  "title": "کسب آمادگی برای دفاع",
  "start": 140,
  "end": 141,
  "position": 13
 },
 {
  "chapter": "درس ۱۲: جهاد",
  "title": "خودت را امتحان کن",
  "start": 142,
  "end": 142,
  "position": 14
 },
 {
  "chapter": "درس ۱۲: جهاد",
  "title": "سرمایه‌ای از جوانی",
  "start": 143,
  "end": 143,
  "position": 15
 }
]$topics$::jsonb) as p(chapter text,title text,start integer,"end" integer,position integer))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v208:all:9:final_exam:پیام‌های آسمان:'||p.chapter||':'||p.position)::uuid,'1405','all','9','final_exam','پیام‌های آسمان',p.chapter,p.title,p.start,p."end",p.position
from topics p cross join installed on conflict(id) do nothing;
