-- Textbook chapter/lesson titles from the sources documented in
-- docs/planner-topic-sources.md. Page spans are NULL unless verified against
-- the target printing. Never overwrite administrator edits.
with books(grade,subject,fields,tracks,chapters) as (values
 ('9','فارسی',array['all'],array['final_exam'],$json$[
  {"chapter":"فصل ۱: زیبایی آفرینش","topics":["درس ۱: آفرینش همه تنبیه خداوند دل است","درس ۲: عجایب صنع حق تعالی"]},
  {"chapter":"فصل ۲: شکفتن","topics":["درس ۳: مثل آیینه، کار و شایستگی","درس ۴: هم‌نشین"]},
  {"chapter":"فصل آزاد: ادبیات بومی ۱","topics":["درس ۵: آزاد"]},
  {"chapter":"فصل ۳: سبک زندگی","topics":["درس ۶: آداب زندگانی","درس ۷: پرتو امید","درس ۸: هم‌زیستی با مام میهن"]},
  {"chapter":"فصل ۴: نام‌ها و یادها","topics":["درس ۹: راز موفقیت","درس ۱۰: آرشی دیگر","درس ۱۱: زن پارسا"]},
  {"chapter":"فصل ۵: اسلام و انقلاب اسلامی","topics":["درس ۱۲: پیام‌آور رحمت","درس ۱۳: آشنای غریبان، میلاد گل","درس ۱۴: پیدای پنهان"]},
  {"chapter":"فصل آزاد: ادبیات بومی ۲","topics":["درس ۱۵: آزاد"]},
  {"chapter":"فصل ۶: ادبیات جهان","topics":["درس ۱۶: آرزو","درس ۱۷: شازده کوچولو"]}
 ]$json$::jsonb),
 ('10','فارسی ۱',array['mathematics','experimental_sciences','humanities'],array['final_exam'],$json$[
  {"chapter":"فصل ۱: ادبیات تعلیمی","topics":["درس ۱: چشمه","درس ۲: از آموختن، ننگ مدار"]},
  {"chapter":"فصل ۲: ادبیات پایداری","topics":["درس ۳: پاسداری از حقیقت","درس ۴: آزاد","درس ۵: بیداد ظالمان"]},
  {"chapter":"فصل ۳: ادبیات غنایی","topics":["درس ۶: مهر و وفا","درس ۷: جمال و کمال"]},
  {"chapter":"فصل ۴: ادبیات سفر و زندگی","topics":["درس ۸: سفر به بصره","درس ۹: کلاس نقاشی"]},
  {"chapter":"فصل ۵: ادبیات انقلاب اسلامی","topics":["درس ۱۰: دریادلان صف‌شکن","درس ۱۱: خاک آزادگان"]},
  {"chapter":"فصل ۶: ادبیات حماسی","topics":["درس ۱۲: رستم و اشکبوس","درس ۱۳: گردآفرید"]},
  {"chapter":"فصل ۷: ادبیات داستانی","topics":["درس ۱۴: طوطی و بقال","درس ۱۵: آزاد","درس ۱۶: خسرو"]},
  {"chapter":"فصل ۸: ادبیات جهان","topics":["درس ۱۷: سپیده‌دم","درس ۱۸: عظمت نگاه"]}
 ]$json$::jsonb),
 ('11','فارسی ۲',array['mathematics','experimental_sciences','humanities'],array['final_exam'],$json$[
  {"chapter":"فصل ۱: ادبیات تعلیمی","topics":["درس ۱: نیکی","درس ۲: قاضی بست"]},
  {"chapter":"فصل ۲: ادبیات پایداری","topics":["درس ۳: در امواج سند","درس ۴: آزاد","درس ۵: آغازگری تنها"]},
  {"chapter":"فصل ۳: ادبیات غنایی","topics":["درس ۶: پرورده عشق","درس ۷: باران محبت"]},
  {"chapter":"فصل ۴: ادبیات سفر و زندگی","topics":["درس ۸: در کوی عاشقان","درس ۹: ذوق لطیف"]},
  {"chapter":"فصل ۵: ادبیات انقلاب اسلامی","topics":["درس ۱۰: بانگ جرس","درس ۱۱: یاران عاشق"]},
  {"chapter":"فصل ۶: ادبیات حماسی","topics":["درس ۱۲: کاوه دادخواه","درس ۱۳: آزاد","درس ۱۴: حمله حیدری"]},
  {"chapter":"فصل ۷: ادبیات داستانی","topics":["درس ۱۵: کبوتر طوق‌دار","درس ۱۶: قصه عینکم"]},
  {"chapter":"فصل ۸: ادبیات جهان","topics":["درس ۱۷: خاموشی دریا","درس ۱۸: خوان عدل"]}
 ]$json$::jsonb),
 ('12','فارسی ۳',array['mathematics','experimental_sciences','humanities'],array['final_exam'],$json$[
  {"chapter":"فصل ۱: ادبیات تعلیمی","topics":["درس ۱: شکر نعمت","درس ۲: مست و هشیار"]},
  {"chapter":"فصل ۲: ادبیات پایداری","topics":["درس ۳: آزادی","درس ۴: آزاد","درس ۵: دماوندیه"]},
  {"chapter":"فصل ۳: ادبیات غنایی","topics":["درس ۶: نی‌نامه","درس ۷: در حقیقت عشق"]},
  {"chapter":"فصل ۴: ادبیات سفر و زندگی","topics":["درس ۸: از پاریز تا پاریس","درس ۹: کویر"]},
  {"chapter":"فصل ۵: ادبیات انقلاب اسلامی","topics":["درس ۱۰: فصل شکوفایی","درس ۱۱: آن شب عزیز"]},
  {"chapter":"فصل ۶: ادبیات حماسی","topics":["درس ۱۲: گذر سیاوش از آتش","درس ۱۳: خوان هشتم"]},
  {"chapter":"فصل ۷: ادبیات داستانی","topics":["درس ۱۴: سی مرغ و سیمرغ","درس ۱۵: آزاد","درس ۱۶: کباب غاز"]},
  {"chapter":"فصل ۸: ادبیات جهان","topics":["درس ۱۷: خنده تو","درس ۱۸: عشق جاودانی"]}
 ]$json$::jsonb),
 ('11','شیمی ۲',array['mathematics','experimental_sciences'],array['konkur','final_exam'],$json$[
  {"chapter":"فصل ۱: قدر هدایای زمینی را بدانیم","topics":["هدایای زمینی","الگوها و روندها در رفتار مواد و عنصرها","رفتار عنصرها و شعاع اتم","دنیایی رنگی با عنصرهای دسته d","عنصرها به چه شکلی در طبیعت یافت می‌شوند","دنیای واقعی واکنش‌ها","نفت، هدیه‌ای شگفت‌انگیز","هیدروکربن‌ها","نفت، ماده‌ای که اقتصاد جهان را دگرگون ساخت"]},
  {"chapter":"فصل ۲: در پی غذای سالم","topics":["مفاهیم اولیه ترموشیمی","جاری شدن انرژی گرمایی","آنتالپی، آنتالپی پیوند، گروه‌های عاملی اکسیژن‌دار و آنتالپی سوختن","تعیین آنتالپی واکنش‌های شیمیایی","سرعت فرایندهای شیمیایی","غذا، پسماند و ردپای آن"]},
  {"chapter":"فصل ۳: پوشاک، نیازی پایان‌ناپذیر","topics":["مفاهیم اولیه تولید پوشاک","الیاف و درشت‌مولکول‌ها","پلی‌استرها، الکل‌ها و اسیدها","واکنش استری شدن","پلی‌آمیدها","پلیمرها، ماندگار یا تخریب‌پذیر"]}
 ]$json$::jsonb)
), expanded as (
 select grade,subject,field,track,c.item->>'chapter' chapter,t.title,t.position::integer position
 from books cross join lateral unnest(fields) field cross join lateral unnest(tracks) track
 cross join lateral jsonb_array_elements(chapters) c(item)
 cross join lateral jsonb_array_elements_text(c.item->'topics') with ordinality t(title,position)
), pages(grade,subject,chapter,starts,ends) as (values
 -- Lesson includes its own text and attached exercise; separate reading and
 -- other named book sections are not silently assigned to the lesson.
 ('11','فارسی ۲','فصل ۱: ادبیات تعلیمی',array[12,17],array[15,23]),
 ('11','فارسی ۲','فصل ۲: ادبیات پایداری',array[28,34,38],array[32,35,44]),
 ('11','فارسی ۲','فصل ۳: ادبیات غنایی',array[52,57],array[55,62]),
 ('11','فارسی ۲','فصل ۴: ادبیات سفر و زندگی',array[66,75],array[73,80]),
 ('11','فارسی ۲','فصل ۵: ادبیات انقلاب اسلامی',array[86,91],array[89,94]),
 ('11','فارسی ۲','فصل ۶: ادبیات حماسی',array[98,107,110],array[105,109,114]),
 ('11','فارسی ۲','فصل ۷: ادبیات داستانی',array[118,124],array[122,131]),
 ('11','فارسی ۲','فصل ۸: ادبیات جهان',array[140,145],array[143,148]),
 ('12','فارسی ۳','فصل ۱: ادبیات تعلیمی',array[12,19],array[17,21]),
 ('12','فارسی ۳','فصل ۲: ادبیات پایداری',array[26,32,36],array[29,33,39]),
 ('12','فارسی ۳','فصل ۳: ادبیات غنایی',array[48,54],array[52,58]),
 ('12','فارسی ۳','فصل ۴: ادبیات سفر و زندگی',array[62,72],array[70,78]),
 ('12','فارسی ۳','فصل ۵: ادبیات انقلاب اسلامی',array[86,90],array[88,97]),
 ('12','فارسی ۳','فصل ۶: ادبیات حماسی',array[102,111],array[109,118]),
 ('12','فارسی ۳','فصل ۷: ادبیات داستانی',array[122,131,134],array[129,133,144]),
 ('12','فارسی ۳','فصل ۸: ادبیات جهان',array[152,157],array[155,158])
)
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v1:' || e.field || ':' || e.grade || ':' || e.track || ':' || e.subject || ':' || e.chapter || ':' || e.position)::uuid,
 '1405',e.field,e.grade,e.track,e.subject,e.chapter,e.title,p.starts[e.position],p.ends[e.position],e.position
from expanded e left join pages p on p.grade=e.grade and p.subject=e.subject and p.chapter=e.chapter
on conflict (id) do nothing;
