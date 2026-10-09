-- Use each editorial seed's own source photograph, without changing its text,
-- publication status/date or author. Preserve any already-added image.
with covers(source_url, image_url, image_alt) as (values
  ('https://www.mehrnews.com/news/6966489', 'https://media.mehrnews.com/d/2026/08/21/4/6140841.jpg?ts=1787300882283', 'داوطلبان در سالن آزمون؛ عکس مطلب اصلی خبرگزاری مهر'),
  ('https://www.mehrnews.com/news/6956825', 'https://media.mehrnews.com/d/2026/08/20/4/6139509.jpg?ts=1787206918124', 'داوطلب در حال پاسخ‌دادن به آزمون؛ عکس مطلب اصلی خبرگزاری مهر'),
  ('https://www.mehrnews.com/news/6955598', 'https://media.mehrnews.com/d/2026/08/20/4/6139846.jpg?ts=1787220322469', 'داوطلبان در حوزه آزمون؛ عکس مطلب اصلی خبرگزاری مهر')
)
update public.konkur_news n
set body = jsonb_set(n.body::jsonb, '{content}',
  jsonb_build_array(
    jsonb_build_object('type','image','attrs',jsonb_build_object('src',covers.image_url,'alt',covers.image_alt)),
    jsonb_build_object('type','paragraph','content',jsonb_build_array(
      jsonb_build_object('type','text','text','عکس: خبرگزاری مهر؛ تصویر مطلب اصلی.','marks',jsonb_build_array(
        jsonb_build_object('type','link','attrs',jsonb_build_object('href',covers.source_url))
      ))
    ))
  ) || (n.body::jsonb -> 'content')
)::text
from covers
where n.source_url = covers.source_url
  and n.author_id is null
  and n.body::jsonb ->> 'type' = 'doc'
  and jsonb_typeof(n.body::jsonb -> 'content') = 'array'
  and not jsonb_path_exists(n.body::jsonb, '$.** ? (@.type == "image")');
