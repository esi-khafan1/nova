-- Follow-up 5A (migration 239): books outside the 79-file audit, part A, checked
-- against the user's 1405 PDFs. Insert only. The installation marker prevents
-- reinstating later administrator deletions.
--  * کارگاه کارآفرینی و تولید دهم (code 110224, چاپ دهم 1405, 137 PDF pages,
--    printed 1-128, printed = PDF - 9; SHA-256
--    ce9a2d54482fecb9b6e88d344c40db7f9b55edf5be403813202ada7eea80dbf0):
--    all 32 sections and their subtopics were already seeded (118 rows per
--    field, all paged). Added «منابع و مآخذ» (128-128, the last printed page)
--    under «بخش‌های ۲۸ تا ۳۲», following the batch-4/5/7 precedent of adding
--    the منابع section under the last chapter.
--  * آمادگی دفاعی دهم (code 110215, چاپ دهم 1405, 168 PDF pages, printed
--    1-160, printed = PDF - 8; SHA-256
--    c870f2a5ef4feb7ef463eb62b7b95cd3cb148f6d5633f2b01d6c03496ba51c5d):
--    all 13 lessons and subtopics already seeded (85 rows per field). Added
--    «منابع برای مطالعه بیشتر» (159-160) under «فصل ۴: دفاع غیرنظامی».
--    The four فصل title pages (printed 1, 19, 54, 117) carry no study text
--    (the words «فصل اول» etc. only) and are deliberately NOT added.
--  * هویت اجتماعی دوازدهم (code 112220, چاپ نهم 1405, 104 PDF pages, printed
--    1-93, printed = PDF - 8; SHA-256
--    743a6ab6a27ac2ba0f8953139413ba52d0e8b87099bb3786195e64fc7312eab6):
--    banked as subject «علوم اجتماعی» for mathematics + experimental_sciences,
--    grade 12, final_exam only (the catalog offers «علوم اجتماعی» to
--    non-humanities grade 12 only; humanities students take جامعه‌شناسی ۳
--    instead). All 10 lessons and subtopics already seeded (67 rows per
--    field). Added «اهداف کتاب» (1-1) under «درس ۱: کنش‌های ما» (batch-4
--    precedent: اهداف کتاب added for جامعه‌شناسی ۳) and «منابع» (92-93)
--    under «درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران».
--    The درس ۹ «سندپژوهی» box (p.77) is NOT added: it sits inside the
--    کل درس 72-82 range, and the book's own introduction (p.7 of the PDF
--    front matter) states سندپژوهی is not examined in the final exam.
--  * زمین‌شناسی یازدهم (code 111237, چاپ دهم 1405, 128 PDF pages, printed =
--    PDF page; SHA-256 d3933fd129e01b66c3ab681b1c849175fc6202f59a2fd87eb436522cb8182f54;
--    the imprint year extracts as «1504» from the text layer but renders as
--    ۱۴۰۵ on the page, verified visually): all 7 chapters and subtopics
--    already seeded (42 rows per combo). Added «منابع» (127-127, sharing the
--    page with the end of the واژه‌نامه) under «فصل ۷: زمین‌شناسی ایران».
--    The six full-page photo pages between chapters (22, 40, 58, 76, 92, 108)
--    and the واژه‌نامه (126-127) are deliberately NOT added.
--  * تاریخ (۱) دهم انسانی (code 110219, چاپ یازدهم 1405, 168 PDF pages,
--    printed 1-157, printed = PDF - 10; SHA-256
--    11e8cc7a0eebaf5169b5688231be02a270ab11aa2b06ef4218668111a52f651f):
--    all 16 lessons and subtopics already seeded (198 rows per track).
--    Added the three فصل opener pages, which carry substantive introductory
--    text (batch-3/4/5 precedent), filed under each فصل's first lesson:
--    «آغاز فصل اول: تاریخ‌شناسی؛ کاوش گذشته» (1-1, درس ۱),
--    «آغاز فصل دوم: جهان در عصر باستان؛ میراث بشری» (29-29, درس ۴),
--    «آغاز فصل سوم: ایران در عصر باستان؛ سرآغاز هویت ایرانی» (61-61, درس ۷),
--    and «منابع و مآخذ» (153-157, درس ۱۶).
-- No guarded page-fill (pattern B) applies: across these five books' combos
-- there is exactly one NULL-page row — آمادگی دفاعی درس ۹, position 3, in
-- each of the three fields — and it is revision 2 (its pages were cleared by
-- migration 158 after the 78-vs-87 start dispute), so the revision=1 guard
-- does not match; it is already superseded by the verified row at position
-- 301 («درس ۹ … (بازه تأییدشده)», 87-116) added by migration 161. It is
-- left untouched. The grade-9 آمادگی دفاعی rows (field 'all', grade 9, a
-- different book, code 915) are not touched by this migration.
with installed as (insert into private.planner_seed_installations(seed_key) values ('audit-followup5a-1405-v239') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {"field": "mathematics", "grade": "10", "subject": "کارگاه کارآفرینی و تولید", "chapter": "بخش‌های ۲۸ تا ۳۲", "position": 3000, "title": "منابع و مآخذ", "start": 128, "end": 128, "konkur": false},
 {"field": "experimental_sciences", "grade": "10", "subject": "کارگاه کارآفرینی و تولید", "chapter": "بخش‌های ۲۸ تا ۳۲", "position": 3000, "title": "منابع و مآخذ", "start": 128, "end": 128, "konkur": false},
 {"field": "humanities", "grade": "10", "subject": "کارگاه کارآفرینی و تولید", "chapter": "بخش‌های ۲۸ تا ۳۲", "position": 3000, "title": "منابع و مآخذ", "start": 128, "end": 128, "konkur": false},
 {"field": "mathematics", "grade": "10", "subject": "آمادگی دفاعی", "chapter": "فصل ۴: دفاع غیرنظامی", "position": 3000, "title": "منابع برای مطالعه بیشتر", "start": 159, "end": 160, "konkur": false},
 {"field": "experimental_sciences", "grade": "10", "subject": "آمادگی دفاعی", "chapter": "فصل ۴: دفاع غیرنظامی", "position": 3000, "title": "منابع برای مطالعه بیشتر", "start": 159, "end": 160, "konkur": false},
 {"field": "humanities", "grade": "10", "subject": "آمادگی دفاعی", "chapter": "فصل ۴: دفاع غیرنظامی", "position": 3000, "title": "منابع برای مطالعه بیشتر", "start": 159, "end": 160, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "علوم اجتماعی", "chapter": "درس ۱: کنش‌های ما", "position": 3000, "title": "اهداف کتاب", "start": 1, "end": 1, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "علوم اجتماعی", "chapter": "درس ۱: کنش‌های ما", "position": 3000, "title": "اهداف کتاب", "start": 1, "end": 1, "konkur": false},
 {"field": "mathematics", "grade": "12", "subject": "علوم اجتماعی", "chapter": "درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران", "position": 3000, "title": "منابع", "start": 92, "end": 93, "konkur": false},
 {"field": "experimental_sciences", "grade": "12", "subject": "علوم اجتماعی", "chapter": "درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران", "position": 3000, "title": "منابع", "start": 92, "end": 93, "konkur": false},
 {"field": "experimental_sciences", "grade": "11", "subject": "زمین‌شناسی", "chapter": "فصل ۷: زمین‌شناسی ایران", "position": 3000, "title": "منابع", "start": 127, "end": 127, "konkur": true},
 {"field": "mathematics", "grade": "11", "subject": "زمین‌شناسی", "chapter": "فصل ۷: زمین‌شناسی ایران", "position": 3000, "title": "منابع", "start": 127, "end": 127, "konkur": false},
 {"field": "humanities", "grade": "10", "subject": "تاریخ ۱", "chapter": "درس ۱", "position": 3000, "title": "آغاز فصل اول: تاریخ‌شناسی؛ کاوش گذشته", "start": 1, "end": 1, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "تاریخ ۱", "chapter": "درس ۴", "position": 3000, "title": "آغاز فصل دوم: جهان در عصر باستان؛ میراث بشری", "start": 29, "end": 29, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "تاریخ ۱", "chapter": "درس ۷", "position": 3000, "title": "آغاز فصل سوم: ایران در عصر باستان؛ سرآغاز هویت ایرانی", "start": 61, "end": 61, "konkur": true},
 {"field": "humanities", "grade": "10", "subject": "تاریخ ۱", "chapter": "درس ۱۶", "position": 3000, "title": "منابع و مآخذ", "start": 153, "end": 157, "konkur": true}
]$topics$::jsonb) as p(field text,grade text,subject text,chapter text,position integer,title text,start integer,"end" integer,konkur boolean)),
tracks(track) as (values ('konkur'),('final_exam'))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v239:'||p.field||':'||p.grade||':'||r.track||':'||p.subject||':'||p.chapter||':'||p.position)::uuid,'1405',p.field,p.grade,r.track,p.subject,p.chapter,p.title,p.start,p."end",p.position from topics p cross join tracks r cross join installed where p.konkur or r.track='final_exam' on conflict(id) do nothing;
