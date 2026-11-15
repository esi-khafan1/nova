-- Arabic 112206 and 112207, user-provided 1405 PDFs; printed-page sections.
-- Install once; backfill only untouched original rows.
with installed as (insert into private.planner_seed_installations(seed_key) values ('arabic12-1405-v188') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۱",
    "position": 300,
    "title": "کل درس",
    "start": 1,
    "end": 18
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۱",
    "position": 301,
    "title": "متن: اشعار منسوب به امام علی",
    "start": 2,
    "end": 3
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۱",
    "position": 302,
    "title": "واژگان درس",
    "start": 4,
    "end": 4
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۱",
    "position": 303,
    "title": "حروف مشبهة بالفعل و معانی آن‌ها",
    "start": 5,
    "end": 8
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۱",
    "position": 304,
    "title": "لای نفی جنس",
    "start": 9,
    "end": 10
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۱",
    "position": 305,
    "title": "تمرین‌های درس",
    "start": 11,
    "end": 18
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۲",
    "position": 300,
    "title": "کل درس",
    "start": 19,
    "end": 36
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۲",
    "position": 301,
    "title": "متن: الوجه النافع و الوجه المضر",
    "start": 20,
    "end": 22
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۲",
    "position": 302,
    "title": "واژگان و درک متن",
    "start": 23,
    "end": 24
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۲",
    "position": 303,
    "title": "حال و واو حالیه",
    "start": 25,
    "end": 27
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۲",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 28,
    "end": 36
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۳",
    "position": 300,
    "title": "کل درس",
    "start": 37,
    "end": 52
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۳",
    "position": 301,
    "title": "متن: سه داستان کوتاه",
    "start": 38,
    "end": 40
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۳",
    "position": 302,
    "title": "واژگان و درک متن",
    "start": 41,
    "end": 42
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۳",
    "position": 303,
    "title": "اسلوب استثنا و حصر",
    "start": 43,
    "end": 46
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۳",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 47,
    "end": 52
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۴",
    "position": 300,
    "title": "کل درس",
    "start": 53,
    "end": 70
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۴",
    "position": 301,
    "title": "متن: نظام طبیعت",
    "start": 54,
    "end": 56
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۴",
    "position": 302,
    "title": "واژگان و درک متن",
    "start": 57,
    "end": 58
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۴",
    "position": 303,
    "title": "مفعول مطلق",
    "start": 59,
    "end": 60
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۴",
    "position": 304,
    "title": "مصدرهای باقاعده و بی‌قاعده",
    "start": 61,
    "end": 63
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۴",
    "position": 305,
    "title": "تمرین‌های درس",
    "start": 64,
    "end": 70
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۵",
    "position": 300,
    "title": "کل درس",
    "start": 71,
    "end": 83
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۵",
    "position": 301,
    "title": "متن: یا الهی",
    "start": 72,
    "end": 72
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۵",
    "position": 302,
    "title": "واژگان درس",
    "start": 73,
    "end": 73
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۵",
    "position": 303,
    "title": "اسلوب ندا",
    "start": 74,
    "end": 75
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۵",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 76,
    "end": 82
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۵",
    "position": 305,
    "title": "سخن پایانی",
    "start": 83,
    "end": 83
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۱",
    "position": 300,
    "title": "کل درس",
    "start": 1,
    "end": 16
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۱",
    "position": 301,
    "title": "متن: دین و دینداری",
    "start": 2,
    "end": 3
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۱",
    "position": 302,
    "title": "واژگان درس",
    "start": 4,
    "end": 4
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۱",
    "position": 303,
    "title": "حروف مشبهة بالفعل و معانی آن‌ها",
    "start": 5,
    "end": 7
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۱",
    "position": 304,
    "title": "لای نفی جنس",
    "start": 8,
    "end": 9
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۱",
    "position": 305,
    "title": "تمرین‌های درس",
    "start": 10,
    "end": 15
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۱",
    "position": 306,
    "title": "پژوهش علمی",
    "start": 16,
    "end": 16
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۲",
    "position": 300,
    "title": "کل درس",
    "start": 17,
    "end": 32
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۲",
    "position": 301,
    "title": "متن: مکه مکرمه و مدینه منوره",
    "start": 18,
    "end": 20
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۲",
    "position": 302,
    "title": "واژگان درس",
    "start": 21,
    "end": 21
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۲",
    "position": 303,
    "title": "حال و واو حالیه",
    "start": 22,
    "end": 24
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۲",
    "position": 304,
    "title": "تمرین‌های درس",
    "start": 25,
    "end": 32
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۳",
    "position": 300,
    "title": "کل درس",
    "start": 33,
    "end": 48
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۳",
    "position": 301,
    "title": "متن و درک مطلب: کتاب‌ها غذای فکر",
    "start": 34,
    "end": 37
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۳",
    "position": 302,
    "title": "اسلوب استثنا و حصر",
    "start": 38,
    "end": 41
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۳",
    "position": 303,
    "title": "تمرین‌های درس",
    "start": 42,
    "end": 48
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۴",
    "position": 300,
    "title": "کل درس",
    "start": 49,
    "end": 66
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۴",
    "position": 301,
    "title": "متن: فرزدق",
    "start": 50,
    "end": 51
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۴",
    "position": 302,
    "title": "واژگان درس",
    "start": 52,
    "end": 52
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۴",
    "position": 303,
    "title": "مفعول مطلق",
    "start": 53,
    "end": 54
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۴",
    "position": 304,
    "title": "مصدرهای باقاعده و بی‌قاعده",
    "start": 55,
    "end": 57
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۴",
    "position": 305,
    "title": "تمرین‌های درس",
    "start": 58,
    "end": 64
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۴",
    "position": 307,
    "title": "سخن پایانی",
    "start": 66,
    "end": 66
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۴",
    "position": 306,
    "title": "راهنمای کاربرد فرهنگ لغت",
    "start": 65,
    "end": 65
  }
]$topics$::jsonb) as p(subject text,chapter text,position integer,title text,start integer,"end" integer)),
contexts(subject,field,track) as (values ('عربی ۳ تخصصی','humanities','konkur'),('عربی ۳ تخصصی','humanities','final_exam'),('عربی زبان قرآن ۳','mathematics','final_exam'),('عربی زبان قرآن ۳','experimental_sciences','final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v188:'||c.field||':12:'||c.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',c.field,'12',c.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p join contexts c on c.subject=p.subject cross join installed on conflict(id) do nothing;
with fixes as (select * from jsonb_to_recordset($fixes$[
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۱",
    "position": 1,
    "title": "متن و واژگان: من الأشعار المنسوبة إلی الإمام علی",
    "start": 2,
    "end": 4
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۱",
    "position": 2,
    "title": "قواعد: حروف مشبهة بالفعل و لای نفی جنس",
    "start": 5,
    "end": 10
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۱",
    "position": 3,
    "title": "تمرین‌های درس",
    "start": 11,
    "end": 18
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۲",
    "position": 1,
    "title": "متن و واژگان: الوجه النافع و الوجه المضر",
    "start": 20,
    "end": 24
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۲",
    "position": 2,
    "title": "قواعد: حال",
    "start": 25,
    "end": 27
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۲",
    "position": 3,
    "title": "تمرین‌های درس",
    "start": 28,
    "end": 36
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۳",
    "position": 1,
    "title": "متن و واژگان: ثلاث قصص قصیرة",
    "start": 38,
    "end": 42
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۳",
    "position": 2,
    "title": "قواعد: استثنا و حصر",
    "start": 43,
    "end": 46
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۳",
    "position": 3,
    "title": "تمرین‌های درس",
    "start": 47,
    "end": 52
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۴",
    "position": 1,
    "title": "متن و واژگان: نظام الطبیعة",
    "start": 54,
    "end": 58
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۴",
    "position": 2,
    "title": "قواعد: مفعول مطلق",
    "start": 59,
    "end": 63
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۴",
    "position": 3,
    "title": "تمرین‌های درس",
    "start": 64,
    "end": 70
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۵",
    "position": 1,
    "title": "متن و واژگان: یا إلهی",
    "start": 72,
    "end": 73
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۵",
    "position": 2,
    "title": "قواعد: ندا",
    "start": 74,
    "end": 75
  },
  {
    "subject": "عربی ۳ تخصصی",
    "chapter": "درس ۵",
    "position": 3,
    "title": "تمرین‌های درس",
    "start": 76,
    "end": 82
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۱",
    "position": 1,
    "title": "متن و واژگان: الدین و التدین",
    "start": 2,
    "end": 4
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۱",
    "position": 2,
    "title": "قواعد: حروف مشبهة بالفعل و لای نفی جنس",
    "start": 5,
    "end": 9
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۱",
    "position": 3,
    "title": "تمرین‌های درس",
    "start": 10,
    "end": 16
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۲",
    "position": 1,
    "title": "متن و واژگان: مکة المکرمة و المدینة المنورة",
    "start": 18,
    "end": 21
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۲",
    "position": 2,
    "title": "قواعد: حال",
    "start": 22,
    "end": 24
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۲",
    "position": 3,
    "title": "تمرین‌های درس",
    "start": 25,
    "end": 32
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۳",
    "position": 1,
    "title": "متن و واژگان: الکتب طعام الفکر",
    "start": 34,
    "end": 37
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۳",
    "position": 2,
    "title": "قواعد: استثنا",
    "start": 38,
    "end": 41
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۳",
    "position": 3,
    "title": "تمرین‌های درس",
    "start": 42,
    "end": 48
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۴",
    "position": 1,
    "title": "متن و واژگان: الفرزدق",
    "start": 50,
    "end": 52
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۴",
    "position": 2,
    "title": "قواعد: مفعول مطلق",
    "start": 53,
    "end": 57
  },
  {
    "subject": "عربی زبان قرآن ۳",
    "chapter": "درس ۴",
    "position": 3,
    "title": "تمرین‌های درس",
    "start": 58,
    "end": 64
  }
]$fixes$::jsonb) as p(subject text,chapter text,position integer,title text,start integer,"end" integer)),
contexts(subject,field,track) as (values ('عربی ۳ تخصصی','humanities','konkur'),('عربی ۳ تخصصی','humanities','final_exam'),('عربی زبان قرآن ۳','mathematics','final_exam'),('عربی زبان قرآن ۳','experimental_sciences','final_exam'))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now() from fixes p join contexts c on c.subject=p.subject
where t.id=md5('nova:planner:1405:v1:'||c.field||':12:'||c.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid and t.edition='1405' and t.study_field=c.field and t.grade='12' and t.preparation_track=c.track and t.subject=p.subject and t.chapter=p.chapter and t.position=p.position and t.title=p.title and t.page_start is null and t.page_end is null and t.revision=1;
