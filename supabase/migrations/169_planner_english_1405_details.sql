-- 1405 textbooks supplied by the user: Vision 1–3 and Prospect 3 Workbook.
-- All pages refer to the printed textbook page numbers. Installed once so reruns
-- never resurrect deletions or overwrite administrator edits. Requires migration 167.
with installed as (insert into private.planner_seed_installations(seed_key) values ('english-vision-workbook-1405-v169') on conflict do nothing returning seed_key),
books as (select * from jsonb_to_recordset($books$[
 {
  "grade": "10",
  "subject": "زبان خارجی ۱",
  "fields": [
   "mathematics",
   "experimental_sciences",
   "humanities"
  ],
  "topics": [
   {
    "position": 101,
    "title": "درس 1: Saving Nature — Get Ready",
    "start": 17,
    "end": 18
   },
   {
    "position": 102,
    "title": "درس 1: Saving Nature — Conversation",
    "start": 19,
    "end": 19
   },
   {
    "position": 103,
    "title": "درس 1: Saving Nature — New Words & Expressions",
    "start": 20,
    "end": 21
   },
   {
    "position": 104,
    "title": "درس 1: Saving Nature — Reading: Endangered Animals",
    "start": 22,
    "end": 23
   },
   {
    "position": 105,
    "title": "درس 1: Saving Nature — Grammar: Future Tense (will)",
    "start": 24,
    "end": 28
   },
   {
    "position": 106,
    "title": "درس 1: Saving Nature — See Also: be going to",
    "start": 29,
    "end": 29
   },
   {
    "position": 107,
    "title": "درس 1: Saving Nature — Listening & Speaking: Schedules and Plans",
    "start": 30,
    "end": 31
   },
   {
    "position": 108,
    "title": "درس 1: Saving Nature — Pronunciation: Falling Intonation",
    "start": 32,
    "end": 33
   },
   {
    "position": 109,
    "title": "درس 1: Saving Nature — Writing: Noun",
    "start": 34,
    "end": 36
   },
   {
    "position": 110,
    "title": "درس 1: Saving Nature — Writing: Singular & Plural",
    "start": 37,
    "end": 37
   },
   {
    "position": 111,
    "title": "درس 1: Saving Nature — Writing: Types of Nouns",
    "start": 38,
    "end": 38
   },
   {
    "position": 112,
    "title": "درس 1: Saving Nature — Writing: Noun Markers",
    "start": 39,
    "end": 39
   },
   {
    "position": 113,
    "title": "درس 1: Saving Nature — What You Learned",
    "start": 41,
    "end": 41
   },
   {
    "position": 201,
    "title": "درس 2: Wonders of Creation — Get Ready",
    "start": 45,
    "end": 46
   },
   {
    "position": 202,
    "title": "درس 2: Wonders of Creation — Conversation",
    "start": 47,
    "end": 47
   },
   {
    "position": 203,
    "title": "درس 2: Wonders of Creation — New Words & Expressions",
    "start": 48,
    "end": 49
   },
   {
    "position": 204,
    "title": "درس 2: Wonders of Creation — Reading: A Wonderful Liquid",
    "start": 50,
    "end": 51
   },
   {
    "position": 205,
    "title": "درس 2: Wonders of Creation — Grammar: Adjectives",
    "start": 52,
    "end": 56
   },
   {
    "position": 206,
    "title": "درس 2: Wonders of Creation — See Also: Comparative & Superlative Adjectives",
    "start": 57,
    "end": 57
   },
   {
    "position": 207,
    "title": "درس 2: Wonders of Creation — Listening & Speaking: Asking about Details",
    "start": 58,
    "end": 59
   },
   {
    "position": 208,
    "title": "درس 2: Wonders of Creation — Pronunciation: Rising Intonation",
    "start": 60,
    "end": 61
   },
   {
    "position": 209,
    "title": "درس 2: Wonders of Creation — Writing: Kinds of Adjectives",
    "start": 62,
    "end": 64
   },
   {
    "position": 210,
    "title": "درس 2: Wonders of Creation — Writing: Place of Adjectives",
    "start": 65,
    "end": 65
   },
   {
    "position": 211,
    "title": "درس 2: Wonders of Creation — Writing: Spelling Hints",
    "start": 66,
    "end": 67
   },
   {
    "position": 212,
    "title": "درس 2: Wonders of Creation — What You Learned",
    "start": 69,
    "end": 69
   },
   {
    "position": 301,
    "title": "درس 3: The Value of Knowledge — Get Ready",
    "start": 73,
    "end": 75
   },
   {
    "position": 302,
    "title": "درس 3: The Value of Knowledge — Conversation",
    "start": 76,
    "end": 76
   },
   {
    "position": 303,
    "title": "درس 3: The Value of Knowledge — New Words & Expressions",
    "start": 77,
    "end": 79
   },
   {
    "position": 304,
    "title": "درس 3: The Value of Knowledge — Reading: No Pain No Gain",
    "start": 80,
    "end": 81
   },
   {
    "position": 305,
    "title": "درس 3: The Value of Knowledge — Grammar: Past Progressive",
    "start": 82,
    "end": 85
   },
   {
    "position": 306,
    "title": "درس 3: The Value of Knowledge — See Also: Self Pronouns",
    "start": 86,
    "end": 86
   },
   {
    "position": 307,
    "title": "درس 3: The Value of Knowledge — Listening & Speaking: Narrating a Story",
    "start": 87,
    "end": 88
   },
   {
    "position": 308,
    "title": "درس 3: The Value of Knowledge — Pronunciation: Emphatic Stress",
    "start": 89,
    "end": 90
   },
   {
    "position": 309,
    "title": "درس 3: The Value of Knowledge — Writing: Action & State Verbs",
    "start": 91,
    "end": 92
   },
   {
    "position": 310,
    "title": "درس 3: The Value of Knowledge — Writing: Simple & Continuous Verbs",
    "start": 93,
    "end": 93
   },
   {
    "position": 311,
    "title": "درس 3: The Value of Knowledge — What You Learned",
    "start": 95,
    "end": 95
   },
   {
    "position": 401,
    "title": "درس 4: Traveling the World — Get Ready",
    "start": 99,
    "end": 101
   },
   {
    "position": 402,
    "title": "درس 4: Traveling the World — Conversation",
    "start": 102,
    "end": 102
   },
   {
    "position": 403,
    "title": "درس 4: Traveling the World — New Words & Expressions",
    "start": 103,
    "end": 104
   },
   {
    "position": 404,
    "title": "درس 4: Traveling the World — Reading: Iran, A True Paradise",
    "start": 105,
    "end": 106
   },
   {
    "position": 405,
    "title": "درس 4: Traveling the World — Grammar: Modals",
    "start": 107,
    "end": 109
   },
   {
    "position": 406,
    "title": "درس 4: Traveling the World — See Also: Prepositions",
    "start": 110,
    "end": 111
   },
   {
    "position": 407,
    "title": "درس 4: Traveling the World — Listening & Speaking: Obligations and Necessities",
    "start": 112,
    "end": 113
   },
   {
    "position": 408,
    "title": "درس 4: Traveling the World — Pronunciation: Contrastive Stress",
    "start": 114,
    "end": 114
   },
   {
    "position": 409,
    "title": "درس 4: Traveling the World — Writing: Adverbs",
    "start": 115,
    "end": 115
   },
   {
    "position": 410,
    "title": "درس 4: Traveling the World — Writing: How to Make -ly Adverbs",
    "start": 116,
    "end": 116
   },
   {
    "position": 411,
    "title": "درس 4: Traveling the World — Writing: Irregular Adverbs",
    "start": 117,
    "end": 117
   },
   {
    "position": 412,
    "title": "درس 4: Traveling the World — What You Learned",
    "start": 119,
    "end": 119
   },
   {
    "position": 901,
    "title": "Appendix: Irregular Verbs",
    "start": 122,
    "end": 125
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
  "topics": [
   {
    "position": 101,
    "title": "درس 1: Understanding People — Get Ready",
    "start": 17,
    "end": 18
   },
   {
    "position": 102,
    "title": "درس 1: Understanding People — Conversation",
    "start": 19,
    "end": 20
   },
   {
    "position": 103,
    "title": "درس 1: Understanding People — New Words & Expressions",
    "start": 21,
    "end": 23
   },
   {
    "position": 104,
    "title": "درس 1: Understanding People — Reading: Languages of the World",
    "start": 24,
    "end": 26
   },
   {
    "position": 105,
    "title": "درس 1: Understanding People — Reading Strategy: Scanning",
    "start": 25,
    "end": 26
   },
   {
    "position": 106,
    "title": "درس 1: Understanding People — Vocabulary Development: Synonyms",
    "start": 27,
    "end": 27
   },
   {
    "position": 107,
    "title": "درس 1: Understanding People — Grammar: Countable & Uncountable Nouns",
    "start": 28,
    "end": 31
   },
   {
    "position": 108,
    "title": "درس 1: Understanding People — See Also: Numbers",
    "start": 32,
    "end": 33
   },
   {
    "position": 109,
    "title": "درس 1: Understanding People — Listening & Speaking: Prices and Numbers",
    "start": 34,
    "end": 35
   },
   {
    "position": 110,
    "title": "درس 1: Understanding People — Pronunciation: Teen and Ten Numbers",
    "start": 36,
    "end": 36
   },
   {
    "position": 111,
    "title": "درس 1: Understanding People — Writing: Simple Sentences",
    "start": 37,
    "end": 45
   },
   {
    "position": 112,
    "title": "درس 1: Understanding People — What You Learned",
    "start": 47,
    "end": 47
   },
   {
    "position": 201,
    "title": "درس 2: A Healthy Lifestyle — Get Ready",
    "start": 51,
    "end": 52
   },
   {
    "position": 202,
    "title": "درس 2: A Healthy Lifestyle — Conversation",
    "start": 53,
    "end": 54
   },
   {
    "position": 203,
    "title": "درس 2: A Healthy Lifestyle — New Words & Expressions",
    "start": 55,
    "end": 57
   },
   {
    "position": 204,
    "title": "درس 2: A Healthy Lifestyle — Reading: Having a Healthier and Longer Life",
    "start": 58,
    "end": 60
   },
   {
    "position": 205,
    "title": "درس 2: A Healthy Lifestyle — Reading Strategy: Skimming",
    "start": 59,
    "end": 60
   },
   {
    "position": 206,
    "title": "درس 2: A Healthy Lifestyle — Vocabulary Development: Prefixes & Suffixes",
    "start": 61,
    "end": 63
   },
   {
    "position": 207,
    "title": "درس 2: A Healthy Lifestyle — Grammar: Present Perfect",
    "start": 64,
    "end": 67
   },
   {
    "position": 208,
    "title": "درس 2: A Healthy Lifestyle — See Also: Phrasal Verbs",
    "start": 68,
    "end": 68
   },
   {
    "position": 209,
    "title": "درس 2: A Healthy Lifestyle — Listening & Speaking: Past Experiences",
    "start": 69,
    "end": 70
   },
   {
    "position": 210,
    "title": "درس 2: A Healthy Lifestyle — Pronunciation: Phrasal Verbs",
    "start": 71,
    "end": 71
   },
   {
    "position": 211,
    "title": "درس 2: A Healthy Lifestyle — Writing: Gerunds",
    "start": 72,
    "end": 77
   },
   {
    "position": 212,
    "title": "درس 2: A Healthy Lifestyle — What You Learned",
    "start": 79,
    "end": 79
   },
   {
    "position": 301,
    "title": "درس 3: Art and Culture — Get Ready",
    "start": 83,
    "end": 84
   },
   {
    "position": 302,
    "title": "درس 3: Art and Culture — Conversation",
    "start": 85,
    "end": 86
   },
   {
    "position": 303,
    "title": "درس 3: Art and Culture — New Words & Expressions",
    "start": 87,
    "end": 89
   },
   {
    "position": 304,
    "title": "درس 3: Art and Culture — Reading: Art, Culture and Society",
    "start": 90,
    "end": 92
   },
   {
    "position": 305,
    "title": "درس 3: Art and Culture — Reading Strategy: Recognizing Reference Words",
    "start": 91,
    "end": 92
   },
   {
    "position": 306,
    "title": "درس 3: Art and Culture — Vocabulary Development: Antonyms",
    "start": 93,
    "end": 94
   },
   {
    "position": 307,
    "title": "درس 3: Art and Culture — Grammar: Conditional Type I",
    "start": 95,
    "end": 97
   },
   {
    "position": 308,
    "title": "درس 3: Art and Culture — See Also: Past Participles",
    "start": 98,
    "end": 98
   },
   {
    "position": 309,
    "title": "درس 3: Art and Culture — Listening & Speaking: Conditions and Future Results",
    "start": 99,
    "end": 100
   },
   {
    "position": 310,
    "title": "درس 3: Art and Culture — Pronunciation: Intonation of Conditional Sentences",
    "start": 101,
    "end": 101
   },
   {
    "position": 311,
    "title": "درس 3: Art and Culture — Writing: Infinitives",
    "start": 102,
    "end": 105
   },
   {
    "position": 312,
    "title": "درس 3: Art and Culture — What You Learned",
    "start": 107,
    "end": 107
   },
   {
    "position": 901,
    "title": "Appendix: Irregular Verbs",
    "start": 108,
    "end": 110
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
  "topics": [
   {
    "position": 101,
    "title": "درس 1: Sense of Appreciation — Get Ready",
    "start": 17,
    "end": 18
   },
   {
    "position": 102,
    "title": "درس 1: Sense of Appreciation — Conversation",
    "start": 19,
    "end": 20
   },
   {
    "position": 103,
    "title": "درس 1: Sense of Appreciation — New Words & Expressions",
    "start": 21,
    "end": 23
   },
   {
    "position": 104,
    "title": "درس 1: Sense of Appreciation — Reading: Respect Your Parents",
    "start": 24,
    "end": 26
   },
   {
    "position": 105,
    "title": "درس 1: Sense of Appreciation — Reading Strategy: Question Generation",
    "start": 25,
    "end": 26
   },
   {
    "position": 106,
    "title": "درس 1: Sense of Appreciation — Vocabulary Development: Collocations",
    "start": 27,
    "end": 28
   },
   {
    "position": 107,
    "title": "درس 1: Sense of Appreciation — Grammar: Passive Voice",
    "start": 29,
    "end": 30
   },
   {
    "position": 108,
    "title": "درس 1: Sense of Appreciation — See Also: Tag Questions",
    "start": 31,
    "end": 31
   },
   {
    "position": 109,
    "title": "درس 1: Sense of Appreciation — Listening & Speaking: Agreement and Uncertainty",
    "start": 32,
    "end": 33
   },
   {
    "position": 110,
    "title": "درس 1: Sense of Appreciation — Writing: Compound Sentences",
    "start": 34,
    "end": 39
   },
   {
    "position": 111,
    "title": "درس 1: Sense of Appreciation — What You Learned",
    "start": 41,
    "end": 41
   },
   {
    "position": 201,
    "title": "درس 2: Look it Up! — Get Ready",
    "start": 45,
    "end": 46
   },
   {
    "position": 202,
    "title": "درس 2: Look it Up! — Conversation",
    "start": 47,
    "end": 48
   },
   {
    "position": 203,
    "title": "درس 2: Look it Up! — New Words & Expressions",
    "start": 49,
    "end": 51
   },
   {
    "position": 204,
    "title": "درس 2: Look it Up! — Reading: How to Use a Dictionary",
    "start": 52,
    "end": 54
   },
   {
    "position": 205,
    "title": "درس 2: Look it Up! — Reading Strategy: Highlighting",
    "start": 53,
    "end": 54
   },
   {
    "position": 206,
    "title": "درس 2: Look it Up! — Vocabulary Development: Word Part Families",
    "start": 55,
    "end": 56
   },
   {
    "position": 207,
    "title": "درس 2: Look it Up! — Grammar: Relative Clauses",
    "start": 57,
    "end": 59
   },
   {
    "position": 208,
    "title": "درس 2: Look it Up! — See Also: Conditional Sentences Type II",
    "start": 60,
    "end": 60
   },
   {
    "position": 209,
    "title": "درس 2: Look it Up! — Listening & Speaking: Imaginary Situations",
    "start": 61,
    "end": 62
   },
   {
    "position": 210,
    "title": "درس 2: Look it Up! — Writing: Paragraph and Topic Sentence",
    "start": 63,
    "end": 67
   },
   {
    "position": 211,
    "title": "درس 2: Look it Up! — What You Learned",
    "start": 69,
    "end": 69
   },
   {
    "position": 301,
    "title": "درس 3: Renewable Energy — Get Ready",
    "start": 73,
    "end": 74
   },
   {
    "position": 302,
    "title": "درس 3: Renewable Energy — Conversation",
    "start": 75,
    "end": 76
   },
   {
    "position": 303,
    "title": "درس 3: Renewable Energy — New Words & Expressions",
    "start": 77,
    "end": 79
   },
   {
    "position": 304,
    "title": "درس 3: Renewable Energy — Reading: Earth for Our Children",
    "start": 80,
    "end": 82
   },
   {
    "position": 305,
    "title": "درس 3: Renewable Energy — Reading Strategy: Note Taking",
    "start": 81,
    "end": 82
   },
   {
    "position": 306,
    "title": "درس 3: Renewable Energy — Vocabulary Development: Proverbs",
    "start": 83,
    "end": 85
   },
   {
    "position": 307,
    "title": "درس 3: Renewable Energy — Grammar: Passive Voice with Modals",
    "start": 86,
    "end": 87
   },
   {
    "position": 308,
    "title": "درس 3: Renewable Energy — See Also: Past Perfect Tense",
    "start": 88,
    "end": 88
   },
   {
    "position": 309,
    "title": "درس 3: Renewable Energy — Listening & Speaking: Earlier Past Activity",
    "start": 89,
    "end": 90
   },
   {
    "position": 310,
    "title": "درس 3: Renewable Energy — Writing: Supporting Sentences",
    "start": 91,
    "end": 91
   },
   {
    "position": 311,
    "title": "درس 3: Renewable Energy — Writing: Concluding Sentence",
    "start": 92,
    "end": 92
   },
   {
    "position": 312,
    "title": "درس 3: Renewable Energy — Writing: Paragraph Practice",
    "start": 93,
    "end": 97
   },
   {
    "position": 313,
    "title": "درس 3: Renewable Energy — What You Learned",
    "start": 99,
    "end": 99
   },
   {
    "position": 901,
    "title": "Appendix: Irregular Verbs",
    "start": 100,
    "end": 102
   }
  ]
 },
 {
  "grade": "9",
  "subject": "کتاب کار زبان انگلیسی",
  "fields": [
   "all"
  ],
  "topics": [
   {
    "position": 101,
    "title": "درس 1: Personality — کل درس",
    "start": 7,
    "end": 19
   },
   {
    "position": 102,
    "title": "درس 1: Personality — تمرین 1: انتخاب شکل صحیح",
    "start": 8,
    "end": 8
   },
   {
    "position": 103,
    "title": "درس 1: Personality — تمرین 2: افعال to be",
    "start": 8,
    "end": 8
   },
   {
    "position": 104,
    "title": "درس 1: Personality — تمرین 3: مرتب کردن جمله‌ها",
    "start": 9,
    "end": 9
   },
   {
    "position": 105,
    "title": "درس 1: Personality — تمرین 4: وصل کردن جمله و تصویر",
    "start": 10,
    "end": 10
   },
   {
    "position": 106,
    "title": "درس 1: Personality — تمرین 5: نوشتن جمله برای تصویر",
    "start": 11,
    "end": 11
   },
   {
    "position": 107,
    "title": "درس 1: Personality — تمرین 6: واژگان شخصیت",
    "start": 12,
    "end": 13
   },
   {
    "position": 108,
    "title": "درس 1: Personality — تمرین 7: ویرایش متن",
    "start": 14,
    "end": 14
   },
   {
    "position": 109,
    "title": "درس 1: Personality — تمرین 8: نوشتن درباره خود و خانواده",
    "start": 15,
    "end": 15
   },
   {
    "position": 110,
    "title": "درس 1: Personality — تمرین 9: پرسش بله یا خیر",
    "start": 16,
    "end": 16
   },
   {
    "position": 111,
    "title": "درس 1: Personality — تمرین 10: خواندن و افعال to be",
    "start": 17,
    "end": 19
   },
   {
    "position": 201,
    "title": "درس 2: Travel — کل درس",
    "start": 21,
    "end": 33
   },
   {
    "position": 202,
    "title": "درس 2: Travel — تمرین 1: انتخاب شکل صحیح",
    "start": 22,
    "end": 22
   },
   {
    "position": 203,
    "title": "درس 2: Travel — تمرین 2: زمان حال استمراری",
    "start": 22,
    "end": 22
   },
   {
    "position": 204,
    "title": "درس 2: Travel — تمرین 3: مرتب کردن جمله‌ها",
    "start": 23,
    "end": 23
   },
   {
    "position": 205,
    "title": "درس 2: Travel — تمرین 4: نوشتن عبارت برای تصویر",
    "start": 23,
    "end": 24
   },
   {
    "position": 206,
    "title": "درس 2: Travel — تمرین 5: نوشتن جمله برای تصویر",
    "start": 25,
    "end": 26
   },
   {
    "position": 207,
    "title": "درس 2: Travel — تمرین 6: واژگان سفر",
    "start": 27,
    "end": 27
   },
   {
    "position": 208,
    "title": "درس 2: Travel — تمرین 7: ویرایش متن",
    "start": 28,
    "end": 28
   },
   {
    "position": 209,
    "title": "درس 2: Travel — تمرین 8: ترتیب و نوشتن درباره سفر",
    "start": 29,
    "end": 30
   },
   {
    "position": 210,
    "title": "درس 2: Travel — تمرین 9: تکمیل جمله درباره خود",
    "start": 30,
    "end": 31
   },
   {
    "position": 211,
    "title": "درس 2: Travel — تمرین 10: خواندن و زمان حال استمراری",
    "start": 32,
    "end": 33
   },
   {
    "position": 301,
    "title": "درس 3: Festivals and Ceremonies — کل درس",
    "start": 35,
    "end": 51
   },
   {
    "position": 302,
    "title": "درس 3: Festivals and Ceremonies — تمرین 1: انتخاب شکل صحیح",
    "start": 36,
    "end": 36
   },
   {
    "position": 303,
    "title": "درس 3: Festivals and Ceremonies — تمرین 2: زمان حال ساده",
    "start": 37,
    "end": 37
   },
   {
    "position": 304,
    "title": "درس 3: Festivals and Ceremonies — تمرین 3: صفات ملکی",
    "start": 38,
    "end": 38
   },
   {
    "position": 305,
    "title": "درس 3: Festivals and Ceremonies — تمرین 4: عبارت‌ها و تصاویر",
    "start": 39,
    "end": 40
   },
   {
    "position": 306,
    "title": "درس 3: Festivals and Ceremonies — تمرین 5: تکمیل جمله با تصویر",
    "start": 41,
    "end": 41
   },
   {
    "position": 307,
    "title": "درس 3: Festivals and Ceremonies — تمرین 6: تکمیل متن نوروز",
    "start": 42,
    "end": 42
   },
   {
    "position": 308,
    "title": "درس 3: Festivals and Ceremonies — تمرین 7: واژگان جشن‌ها",
    "start": 43,
    "end": 44
   },
   {
    "position": 309,
    "title": "درس 3: Festivals and Ceremonies — تمرین 8: ویرایش و بازنویسی",
    "start": 45,
    "end": 46
   },
   {
    "position": 310,
    "title": "درس 3: Festivals and Ceremonies — تمرین 9: پرسش بله یا خیر",
    "start": 47,
    "end": 47
   },
   {
    "position": 311,
    "title": "درس 3: Festivals and Ceremonies — تمرین 10: متن و پرسش‌های جشن‌ها",
    "start": 48,
    "end": 51
   },
   {
    "position": 401,
    "title": "درس 4: Services — کل درس",
    "start": 53,
    "end": 65
   },
   {
    "position": 402,
    "title": "درس 4: Services — تمرین 1: انتخاب پرسش صحیح",
    "start": 54,
    "end": 54
   },
   {
    "position": 403,
    "title": "درس 4: Services — تمرین 2: ساخت پرسش با do و does",
    "start": 55,
    "end": 55
   },
   {
    "position": 404,
    "title": "درس 4: Services — تمرین 3: وصل کردن پرسش و پاسخ",
    "start": 56,
    "end": 56
   },
   {
    "position": 405,
    "title": "درس 4: Services — تمرین 4: قیدهای تکرار",
    "start": 57,
    "end": 57
   },
   {
    "position": 406,
    "title": "درس 4: Services — تمرین 5: پرسش‌های wh",
    "start": 58,
    "end": 58
   },
   {
    "position": 407,
    "title": "درس 4: Services — تمرین 6: تصاویر و پرسش و پاسخ",
    "start": 59,
    "end": 59
   },
   {
    "position": 408,
    "title": "درس 4: Services — تمرین 7: واژگان خدمات",
    "start": 60,
    "end": 61
   },
   {
    "position": 409,
    "title": "درس 4: Services — تمرین 8: ویرایش جمله‌ها",
    "start": 62,
    "end": 62
   },
   {
    "position": 410,
    "title": "درس 4: Services — تمرین 9: پرسش بله یا خیر",
    "start": 63,
    "end": 63
   },
   {
    "position": 411,
    "title": "درس 4: Services — تمرین 10: متن و قیدهای تکرار",
    "start": 64,
    "end": 65
   },
   {
    "position": 501,
    "title": "درس 5: Media — کل درس",
    "start": 67,
    "end": 81
   },
   {
    "position": 502,
    "title": "درس 5: Media — تمرین 1: زمان گذشته",
    "start": 68,
    "end": 68
   },
   {
    "position": 503,
    "title": "درس 5: Media — تمرین 2: بازنویسی به زمان گذشته",
    "start": 69,
    "end": 69
   },
   {
    "position": 504,
    "title": "درس 5: Media — تمرین 3: تکمیل جدول پاسخ",
    "start": 70,
    "end": 70
   },
   {
    "position": 505,
    "title": "درس 5: Media — تمرین 4: مرتب کردن جمله‌ها",
    "start": 71,
    "end": 71
   },
   {
    "position": 506,
    "title": "درس 5: Media — تمرین 5: پاسخ به پرسش‌ها",
    "start": 72,
    "end": 72
   },
   {
    "position": 507,
    "title": "درس 5: Media — تمرین 6: مرتب کردن مکالمه",
    "start": 73,
    "end": 73
   },
   {
    "position": 508,
    "title": "درس 5: Media — تمرین 7: واژگان رسانه",
    "start": 73,
    "end": 75
   },
   {
    "position": 509,
    "title": "درس 5: Media — تمرین 8: ویرایش و بازنویسی متن",
    "start": 76,
    "end": 77
   },
   {
    "position": 510,
    "title": "درس 5: Media — تمرین 9: انتخاب شکل صحیح",
    "start": 78,
    "end": 78
   },
   {
    "position": 511,
    "title": "درس 5: Media — تمرین 10: خواندن گزارش و پرسش‌ها",
    "start": 79,
    "end": 81
   },
   {
    "position": 601,
    "title": "درس 6: Health and Injuries — کل درس",
    "start": 83,
    "end": 95
   },
   {
    "position": 602,
    "title": "درس 6: Health and Injuries — تمرین 1: انتخاب پاسخ صحیح",
    "start": 84,
    "end": 84
   },
   {
    "position": 603,
    "title": "درس 6: Health and Injuries — تمرین 2: تکمیل مکالمه با did",
    "start": 85,
    "end": 85
   },
   {
    "position": 604,
    "title": "درس 6: Health and Injuries — تمرین 3: ساخت پرسش",
    "start": 86,
    "end": 86
   },
   {
    "position": 605,
    "title": "درس 6: Health and Injuries — تمرین 4: ساخت جمله",
    "start": 87,
    "end": 87
   },
   {
    "position": 606,
    "title": "درس 6: Health and Injuries — تمرین 5: گزارش مصدومان",
    "start": 88,
    "end": 88
   },
   {
    "position": 607,
    "title": "درس 6: Health and Injuries — تمرین 6: پرسش درباره زندگی پارسا",
    "start": 89,
    "end": 89
   },
   {
    "position": 608,
    "title": "درس 6: Health and Injuries — تمرین 7: واژگان سلامت و آسیب‌ها",
    "start": 90,
    "end": 91
   },
   {
    "position": 609,
    "title": "درس 6: Health and Injuries — تمرین 8: ویرایش و بازنویسی متن",
    "start": 91,
    "end": 92
   },
   {
    "position": 610,
    "title": "درس 6: Health and Injuries — تمرین 9: پرسش درباره خود",
    "start": 93,
    "end": 93
   },
   {
    "position": 611,
    "title": "درس 6: Health and Injuries — تمرین 10: داستان و پرسش‌ها",
    "start": 94,
    "end": 95
   },
   {
    "position": 612,
    "title": "درس 6: Health and Injuries — تمرین 11: پاسخ به پرسش‌ها",
    "start": 95,
    "end": 95
   }
  ]
 }
]$books$::jsonb) as b(grade text,subject text,fields jsonb,topics jsonb)),
expanded as (select b.grade,b.subject,f.field,(p.item->>'position')::integer position,p.item->>'title' title,(p.item->>'start')::integer page_start,(p.item->>'end')::integer page_end from books b cross join lateral jsonb_array_elements_text(b.fields) f(field) cross join lateral jsonb_array_elements(b.topics) p(item))
insert into private.planner_topic_bank(id,edition,study_field,grade,preparation_track,subject,chapter,title,page_start,page_end,position)
select md5('nova:planner:1405:v169:'||field||':'||grade||':final_exam:'||subject||':درس‌ها:'||position)::uuid, '1405',field,grade,'final_exam',subject,'درس‌ها',title,page_start,page_end,position from expanded cross join installed
on conflict(id) do nothing;
