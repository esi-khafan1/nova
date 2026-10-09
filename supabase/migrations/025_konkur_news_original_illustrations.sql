-- Replace only the three untouched editorial source-image/credit pairs.
-- AI-generated assets are pinned to the dedicated feature-branch asset commit.
-- Original news text, source, status and dates remain unchanged.
with illustrations(source_url, old_image_url, image_url, image_alt) as (values
  ('https://www.mehrnews.com/news/6966489', 'https://media.mehrnews.com/d/2026/08/21/4/6140841.jpg?ts=1787300882283', 'https://raw.githubusercontent.com/esi-khafan1/nova/9606bbb182d0e5a916b944e6b3c349951a7d7568/public/news/generated/konkur-results.svg', 'تصویرسازی اختصاصی نووا درباره اعلام نتایج کنکور؛ لپ‌تاپ، دفتر و پاکت نتیجه'),
  ('https://www.mehrnews.com/news/6956825', 'https://media.mehrnews.com/d/2026/08/20/4/6139509.jpg?ts=1787206918124', 'https://raw.githubusercontent.com/esi-khafan1/nova/9606bbb182d0e5a916b944e6b3c349951a7d7568/public/news/generated/academic-records.svg', 'تصویرسازی اختصاصی نووا درباره سوابق تحصیلی؛ دو دفتر و پوشه مدارک'),
  ('https://www.mehrnews.com/news/6955598', 'https://media.mehrnews.com/d/2026/08/20/4/6139846.jpg?ts=1787220322469', 'https://raw.githubusercontent.com/esi-khafan1/nova/9606bbb182d0e5a916b944e6b3c349951a7d7568/public/news/generated/exam-subjects.svg', 'تصویرسازی اختصاصی نووا درباره دروس و ضرایب؛ دفتر، گونیا، ظرف آزمایشگاهی و برگ')
)
update public.konkur_news n
set body = jsonb_set(
  jsonb_set(n.body::jsonb, '{content,0,attrs}',
    (n.body::jsonb #> '{content,0,attrs}') || jsonb_build_object('src',illustrations.image_url,'alt',illustrations.image_alt)
  ),
  '{content,1}',
  jsonb_build_object('type','paragraph','content',jsonb_build_array(
    jsonb_build_object('type','text','text','تصویرسازی اختصاصی نووا با هوش مصنوعی؛ عکس واقعی رویداد نیست.')
  ))
)::text
from illustrations
where n.source_url = illustrations.source_url
  and n.author_id is null
  and n.body::jsonb #>> '{content,0,type}' = 'image'
  and n.body::jsonb #>> '{content,0,attrs,src}' = illustrations.old_image_url
  and n.body::jsonb #>> '{content,1,content,0,text}' = 'عکس: خبرگزاری مهر؛ تصویر مطلب اصلی.'
  and n.body::jsonb #>> '{content,1,content,0,marks,0,attrs,href}' = illustrations.source_url;
