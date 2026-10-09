# بخش انتخاب مسیر نووا — پیش‌نمایش طراحی

## تصمیم‌های صاحب پروژه

- بخش «چرا موسسه مشاوره نووا؟» روی طرح سفید و مینیمال ثابت شده است.
- بخش بعدی، یک انتخاب‌گر با پس‌زمینهٔ متفاوت و ستاره‌های چهارپر ظریف است.
- انتخاب پایه فقط: دهم، یازدهم، دوازدهم.
- مرحلهٔ انتخاب هدف به‌کلی حذف شده است.
- Navbar قبلی در موبایل و دسکتاپ sticky باقی می‌ماند.
- این کار فقط روی برنچ feature و Preview انجام می‌شود؛ ادغام با main و انتشار Production مجاز نیست.

## بررسی مرجع

سایت https://alphaschool.ir/ در مرورگر بررسی شد. بخش مورد نظر یک کارت درجا است: شروع → پایه تحصیلی → رشته تحصیلی → هدف. در نووا، جریان طراحی به «شروع → پایه → رشته → خلاصه انتخاب» محدود شده است. هیچ فایل تصویری، CSS یا کد آلفا کپی نشده است؛ هندسهٔ ستاره‌ها و چیدمان‌ها مستقل‌اند.

## سه جهت

- `?path=sky#find-path` — آبی روشن، کارت مرکزی سفید و کادر آبی؛ نزدیک‌تر به ساختار مرجع.
- `?path=peach#find-path` — زمینهٔ هلویی، کارت دو‌بخشی و نشان قطب‌نما.
- `?path=horizon#find-path` — زمینهٔ ترکیبی آبی/کرم، عنوان خارج از کارت و چیدمان باز.

## محدوده عملکرد

گزینه‌های پایه و رشته واقعاً قابل انتخاب‌اند. دکمهٔ ادامه تا انتخاب معتبر غیرفعال است. بازگشت، حفظ انتخاب در رفت‌وبرگشت و شروع دوباره پیاده‌سازی شده‌اند. گزینه‌های رشته، سه مسیر رایج موجود در مدل پروژه‌اند: ریاضی و فیزیک، علوم تجربی و علوم انسانی.

این انتخاب‌گر فعلاً بک‌اند، ذخیرهٔ انتخاب یا پیشنهاد دوره ندارد؛ هیچ درخواست ثبت اطلاعات ارسال نمی‌کند و هیچ دوره، قیمت یا موجودی ساختگی نشان نمی‌دهد. نتیجه، خلاصهٔ انتخاب و توضیح صریح پیش‌نمایش را نمایش می‌دهد؛ تنها لینک محتوا به صفحهٔ واقعی مجله نووا است. اتصال به فهرست دوره‌ها نیازمند درخواست جداگانهٔ صاحب پروژه است.


## Approved sky cluster artwork
The sky option replaces scattered blue/peach stars with the exact user-supplied transparent PNG, losslessly embedded in a self-contained SVG. Gray decoration is an explicitly requested exception to the previous brand palette. The supplied internal layout and colors are unchanged; 15% CSS opacity keeps decoration subordinate to the white card. No generated replacements, animations, glow, or hotlinked resources. Peach/horizon are unchanged. Mobile uses three cropped windows of the same asset and repositions whole clusters around the card, never individual stars.
