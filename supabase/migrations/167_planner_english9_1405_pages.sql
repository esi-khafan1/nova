-- Prospect 3 (910), 1405: printed pages, based on the user-provided book.
-- Correct only original unmodified lesson rows; additional sections are installed once.
create table if not exists private.planner_seed_installations (seed_key text primary key);
revoke all on private.planner_seed_installations from public, anon, authenticated;
with lessons as (select * from jsonb_to_recordset($lessons$[
 {
  "position": 1,
  "title": "Personality",
  "start": 15,
  "end": 27
 },
 {
  "position": 2,
  "title": "Travel",
  "start": 29,
  "end": 41
 },
 {
  "position": 3,
  "title": "Festivals and Ceremonies",
  "start": 49,
  "end": 61
 },
 {
  "position": 4,
  "title": "Services",
  "start": 63,
  "end": 75
 },
 {
  "position": 5,
  "title": "Media",
  "start": 81,
  "end": 93
 },
 {
  "position": 6,
  "title": "Health and Injuries",
  "start": 95,
  "end": 107
 }
]$lessons$::jsonb) as p(position integer,title text,start integer,"end" integer))
update private.planner_topic_bank t set page_start=p.start,page_end=p."end",revision=t.revision+1,updated_at=now()
from lessons p
where t.id=md5('nova:planner:1405:v1:all:9:final_exam:زبان انگلیسی:درس‌ها:'||p.position)::uuid
 and t.edition='1405' and t.study_field='all' and t.grade='9' and t.preparation_track='final_exam' and t.subject='زبان انگلیسی' and t.chapter='درس‌ها' and t.title=p.title and t.position=p.position and t.page_start is null and t.page_end is null and t.revision=1;

with installed as (insert into private.planner_seed_installations(seed_key) values ('english9-1405-v167') on conflict do nothing returning seed_key),
topics as (select * from jsonb_to_recordset($topics$[
 {
  "position": 111,
  "title": "درس 1: Personality — Conversation",
  "start": 16,
  "end": 16
 },
 {
  "position": 112,
  "title": "درس 1: Personality — Practice 1",
  "start": 17,
  "end": 17
 },
 {
  "position": 113,
  "title": "درس 1: Personality — Practice 2",
  "start": 17,
  "end": 17
 },
 {
  "position": 114,
  "title": "درس 1: Personality — Vocabulary",
  "start": 18,
  "end": 19
 },
 {
  "position": 115,
  "title": "درس 1: Personality — Language Melody",
  "start": 20,
  "end": 20
 },
 {
  "position": 116,
  "title": "درس 1: Personality — Grammar",
  "start": 21,
  "end": 24
 },
 {
  "position": 117,
  "title": "درس 1: Personality — See Also",
  "start": 22,
  "end": 22
 },
 {
  "position": 118,
  "title": "درس 1: Personality — Listening, Reading and Writing",
  "start": 24,
  "end": 25
 },
 {
  "position": 119,
  "title": "درس 1: Personality — Reading, Speaking, Listening and Writing — Role Play",
  "start": 26,
  "end": 27
 },
 {
  "position": 121,
  "title": "درس 2: Travel — Conversation",
  "start": 30,
  "end": 30
 },
 {
  "position": 122,
  "title": "درس 2: Travel — Practice 1",
  "start": 31,
  "end": 31
 },
 {
  "position": 123,
  "title": "درس 2: Travel — Practice 2",
  "start": 31,
  "end": 31
 },
 {
  "position": 124,
  "title": "درس 2: Travel — Vocabulary",
  "start": 32,
  "end": 33
 },
 {
  "position": 125,
  "title": "درس 2: Travel — Language Melody",
  "start": 34,
  "end": 34
 },
 {
  "position": 126,
  "title": "درس 2: Travel — Grammar",
  "start": 35,
  "end": 38
 },
 {
  "position": 127,
  "title": "درس 2: Travel — See Also",
  "start": 36,
  "end": 36
 },
 {
  "position": 128,
  "title": "درس 2: Travel — Listening, Reading and Writing",
  "start": 38,
  "end": 39
 },
 {
  "position": 129,
  "title": "درس 2: Travel — Reading, Speaking, Listening and Writing — Role Play",
  "start": 40,
  "end": 41
 },
 {
  "position": 131,
  "title": "درس 3: Festivals and Ceremonies — Conversation",
  "start": 50,
  "end": 50
 },
 {
  "position": 132,
  "title": "درس 3: Festivals and Ceremonies — Practice 1",
  "start": 51,
  "end": 51
 },
 {
  "position": 133,
  "title": "درس 3: Festivals and Ceremonies — Practice 2",
  "start": 51,
  "end": 51
 },
 {
  "position": 134,
  "title": "درس 3: Festivals and Ceremonies — Vocabulary",
  "start": 52,
  "end": 53
 },
 {
  "position": 135,
  "title": "درس 3: Festivals and Ceremonies — Language Melody",
  "start": 54,
  "end": 54
 },
 {
  "position": 136,
  "title": "درس 3: Festivals and Ceremonies — Grammar",
  "start": 55,
  "end": 58
 },
 {
  "position": 137,
  "title": "درس 3: Festivals and Ceremonies — See Also",
  "start": 56,
  "end": 56
 },
 {
  "position": 138,
  "title": "درس 3: Festivals and Ceremonies — Listening, Reading and Writing",
  "start": 58,
  "end": 59
 },
 {
  "position": 139,
  "title": "درس 3: Festivals and Ceremonies — Reading, Speaking, Listening and Writing — Role Play",
  "start": 60,
  "end": 61
 },
 {
  "position": 141,
  "title": "درس 4: Services — Conversation",
  "start": 64,
  "end": 64
 },
 {
  "position": 142,
  "title": "درس 4: Services — Practice 1",
  "start": 65,
  "end": 65
 },
 {
  "position": 143,
  "title": "درس 4: Services — Practice 2",
  "start": 65,
  "end": 65
 },
 {
  "position": 144,
  "title": "درس 4: Services — Vocabulary",
  "start": 66,
  "end": 67
 },
 {
  "position": 145,
  "title": "درس 4: Services — Language Melody",
  "start": 68,
  "end": 68
 },
 {
  "position": 146,
  "title": "درس 4: Services — Grammar",
  "start": 69,
  "end": 72
 },
 {
  "position": 147,
  "title": "درس 4: Services — See Also",
  "start": 70,
  "end": 70
 },
 {
  "position": 148,
  "title": "درس 4: Services — Listening, Reading and Writing",
  "start": 72,
  "end": 73
 },
 {
  "position": 149,
  "title": "درس 4: Services — Reading, Speaking, Listening and Writing — Role Play",
  "start": 74,
  "end": 75
 },
 {
  "position": 151,
  "title": "درس 5: Media — Conversation",
  "start": 82,
  "end": 82
 },
 {
  "position": 152,
  "title": "درس 5: Media — Practice 1",
  "start": 83,
  "end": 83
 },
 {
  "position": 153,
  "title": "درس 5: Media — Practice 2",
  "start": 83,
  "end": 83
 },
 {
  "position": 154,
  "title": "درس 5: Media — Vocabulary",
  "start": 84,
  "end": 85
 },
 {
  "position": 155,
  "title": "درس 5: Media — Language Melody",
  "start": 86,
  "end": 86
 },
 {
  "position": 156,
  "title": "درس 5: Media — Grammar",
  "start": 87,
  "end": 90
 },
 {
  "position": 157,
  "title": "درس 5: Media — See Also",
  "start": 88,
  "end": 88
 },
 {
  "position": 158,
  "title": "درس 5: Media — Listening, Reading and Writing",
  "start": 90,
  "end": 91
 },
 {
  "position": 159,
  "title": "درس 5: Media — Reading, Speaking, Listening and Writing — Role Play",
  "start": 92,
  "end": 93
 },
 {
  "position": 161,
  "title": "درس 6: Health and Injuries — Conversation",
  "start": 96,
  "end": 96
 },
 {
  "position": 162,
  "title": "درس 6: Health and Injuries — Practice 1",
  "start": 97,
  "end": 97
 },
 {
  "position": 163,
  "title": "درس 6: Health and Injuries — Practice 2",
  "start": 97,
  "end": 97
 },
 {
  "position": 164,
  "title": "درس 6: Health and Injuries — Vocabulary",
  "start": 98,
  "end": 99
 },
 {
  "position": 165,
  "title": "درس 6: Health and Injuries — Language Melody",
  "start": 100,
  "end": 100
 },
 {
  "position": 166,
  "title": "درس 6: Health and Injuries — Grammar",
  "start": 101,
  "end": 104
 },
 {
  "position": 167,
  "title": "درس 6: Health and Injuries — See Also",
  "start": 102,
  "end": 102
 },
 {
  "position": 168,
  "title": "درس 6: Health and Injuries — Listening, Reading and Writing",
  "start": 104,
  "end": 105
 },
 {
  "position": 169,
  "title": "درس 6: Health and Injuries — Reading, Speaking, Listening and Writing — Role Play",
  "start": 106,
  "end": 107
 },
 {
  "position": 201,
  "title": "Review 1",
  "start": 42,
  "end": 47
 },
 {
  "position": 202,
  "title": "Review 2",
  "start": 76,
  "end": 79
 },
 {
  "position": 203,
  "title": "Review 3",
  "start": 108,
  "end": 111
 },
 {
  "position": 211,
  "title": "Photo Dictionary — Lesson 1: Personality",
  "start": 113,
  "end": 115
 },
 {
  "position": 212,
  "title": "Photo Dictionary — Lesson 2: Travel",
  "start": 116,
  "end": 118
 },
 {
  "position": 213,
  "title": "Photo Dictionary — Lesson 3: Festivals and Ceremonies",
  "start": 119,
  "end": 121
 },
 {
  "position": 214,
  "title": "Photo Dictionary — Lesson 4: Services",
  "start": 122,
  "end": 124
 },
 {
  "position": 215,
  "title": "Photo Dictionary — Lesson 5: Media",
  "start": 125,
  "end": 127
 },
 {
  "position": 216,
  "title": "Photo Dictionary — Lesson 6: Health and Injuries",
  "start": 128,
  "end": 130
 },
 {
  "position": 217,
  "title": "Irregular Verbs",
  "start": 131,
  "end": 133
 },
 {
  "position": 231,
  "title": "Review 1 — Theme and Function",
  "start": 42,
  "end": 42
 },
 {
  "position": 232,
  "title": "Review 1 — Language Melody",
  "start": 43,
  "end": 43
 },
 {
  "position": 233,
  "title": "Review 1 — Vocabulary",
  "start": 43,
  "end": 44
 },
 {
  "position": 234,
  "title": "Review 1 — Grammar",
  "start": 45,
  "end": 47
 },
 {
  "position": 241,
  "title": "Review 2 — Theme and Function",
  "start": 76,
  "end": 76
 },
 {
  "position": 242,
  "title": "Review 2 — Language Melody",
  "start": 77,
  "end": 77
 },
 {
  "position": 243,
  "title": "Review 2 — Vocabulary",
  "start": 77,
  "end": 78
 },
 {
  "position": 244,
  "title": "Review 2 — Grammar",
  "start": 79,
  "end": 79
 },
 {
  "position": 251,
  "title": "Review 3 — Theme and Function",
  "start": 108,
  "end": 108
 },
 {
  "position": 252,
  "title": "Review 3 — Language Melody",
  "start": 109,
  "end": 109
 },
 {
  "position": 253,
  "title": "Review 3 — Vocabulary",
  "start": 109,
  "end": 110
 },
 {
  "position": 254,
  "title": "Review 3 — Grammar",
  "start": 111,
  "end": 111
 }
]$topics$::jsonb) as p(position integer,title text,start integer,"end" integer))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v167:all:9:final_exam:زبان انگلیسی:درس‌ها:'||p.position)::uuid,
 '1405','all','9','final_exam','زبان انگلیسی','درس‌ها',p.title,p.start,p."end",p.position from topics p cross join installed
on conflict(id) do nothing;
