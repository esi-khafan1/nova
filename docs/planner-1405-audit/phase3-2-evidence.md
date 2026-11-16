# Phase 3 item 2 evidence — منابع rows are already optional (no change)

Branch `arena/9639a778-nova`. **Verdict: COMPLETE — nothing changed, deliberately.**
The منابع rows STAY in the bank, and selecting them was already optional:
there is no mechanism anywhere in the planner that requires a bank row —
منابع or any other — so no migration (249 not used) and no code change was
needed. This file records where the rows are, how optionality is actually
represented, and what was verified.

## 1. What counts as a «منابع row»

A back-matter bibliography row: the title is exactly `منابع`, `فهرست منابع`,
`منابع و مآخذ`, `منابع برای مطالعه بیشتر`, starts with `مطالعه بیشتر: منابع`,
or contains `منابع پیشنهادی`. Lesson-content titles that merely contain the
word منابع (e.g. «منابع آب سطحی و زیرزمینی», «منابع معدنی…», «منابع اقتدار
ملی», «منابع کسب آگاهی و معرفت») are **not** in this set — they are ordinary
lesson content, and this item does not touch them. (65 such content rows
exist across the older migrations; none is a back-matter row.)

## 2. Where the منابع rows are — 45 topics / 74 DB rows

Every row below was extracted from the migration JSON and re-verified in
PGlite by the test (§5): each listed topic exists for each stated track with
the exact pages and revision 1. Id formula for every row (all six
migrations):
`md5('nova:planner:1405:v<MIG>:<field>:<grade>:<track>:<subject>:<chapter>:<position>')::uuid`
(spot-checked in the test: حسابان ۲ منابع konkur, تاریخ ۲ منابع
final_exam). All rows sit at position ≥ 3000 (last in their chapter) and all
have non-NULL pages. No back-matter منابع row exists in any migration
before 233 (checked by exact-title grep), and batches 1/2/6/8 added none —
only 233/234/235/237/239/240 did. Note the task brief said "batches 4/5/7";
batch 3 (233) also added 6 such topics, recorded here.

### Migration 233 (batch 3) — 6 topics / 12 rows

| field | grade | subject | chapter | pos | title | pages | tracks |
|---|---|---|---|---|---|---|---|
| humanities | 12 | فلسفه ۲ | درس ۶ | 3000 | مطالعه بیشتر: منابع درس ششم | 51–51 | konkur + final_exam |
| humanities | 12 | فلسفه ۲ | درس ۸ | 3000 | مطالعه بیشتر: منابع درس هشتم | 68–68 | konkur + final_exam |
| mathematics | 10 | فیزیک ۱ | فصل ۵: ترمودینامیک | 3001 | فهرست منابع | 152–152 | konkur + final_exam |
| experimental_sciences | 10 | فیزیک ۱ | فصل ۴: دما و گرما | 3001 | فهرست منابع | 124–125 | konkur + final_exam |
| mathematics | 12 | فیزیک ۳ | فصل ۶: آشنایی با فیزیک هسته‌ای | 3003 | فهرست منابع | 164–165 | konkur + final_exam |
| experimental_sciences | 12 | فیزیک ۳ | فصل ۴: آشنایی با فیزیک اتمی و هسته‌ای | 3003 | فهرست منابع | 132–133 | konkur + final_exam |

### Migration 234 (batch 4) — 9 topics / 18 rows

| field | grade | subject | chapter | pos | title | pages | tracks |
|---|---|---|---|---|---|---|---|
| mathematics | 11 | فیزیک ۲ | فصل ۴: القای الکترومغناطیسی و جریان متناوب | 3001 | فهرست منابع | 134–135 | konkur + final_exam |
| experimental_sciences | 11 | فیزیک ۲ | فصل ۳: مغناطیس و القای الکترومغناطیسی | 3001 | فهرست منابع | 108–109 | konkur + final_exam |
| mathematics | 12 | ریاضیات گسسته | فصل ۳: ترکیبیات | 3002 | منابع | 85–85 | konkur + final_exam |
| mathematics | 12 | هندسه ۳ | فصل ۳: بردارها | 3000 | منابع | 87–87 | konkur + final_exam |
| mathematics | 11 | هندسه ۲ | فصل ۳: روابط طولی در مثلث | 3000 | منابع | 76–77 | konkur + final_exam |
| mathematics | 11 | حسابان ۱ | فصل ۵: حد و پیوستگی | 3000 | منابع | 152–153 | konkur + final_exam |
| mathematics | 12 | حسابان ۲ | فصل ۵: کاربردهای مشتق | 3003 | منابع | 145–145 | konkur + final_exam |
| humanities | 12 | جامعه‌شناسی ۳ | درس ۱۰ | 3000 | منابع | 116–119 | konkur + final_exam |
| humanities | 11 | جامعه‌شناسی ۲ | درس ۱۵ | 3000 | منابع | 137–138 | konkur + final_exam |

### Migration 235 (batch 5) — 6 topics / 8 rows

| field | grade | subject | chapter | pos | title | pages | tracks |
|---|---|---|---|---|---|---|---|
| humanities | 10 | جامعه‌شناسی ۱ | درس ۱۶ | 3000 | منابع | 142–144 | konkur + final_exam |
| all | 9 | کار و فناوری | پودمان ۱۱: صنایع دستی (برجسته‌کاری روی فلز مس) | 3000 | منابع و مآخذ | 152–152 | final_exam only |
| humanities | 10 | منطق | درس ۱۰ | 3001 | منابع | 124–125 | konkur + final_exam |
| mathematics | 12 | مدیریت خانواده و سبک زندگی | دختران — صحنه ۱۰: زندگی با طعم مسئولیت | 3000 | دختران — منابع پیشنهادی برای مطالعه | 193–193 | final_exam only |
| experimental_sciences | 12 | مدیریت خانواده و سبک زندگی | دختران — صحنه ۱۰: زندگی با طعم مسئولیت | 3000 | دختران — منابع پیشنهادی برای مطالعه | 193–193 | final_exam only |
| humanities | 12 | مدیریت خانواده و سبک زندگی | دختران — صحنه ۱۰: زندگی با طعم مسئولیت | 3000 | دختران — منابع پیشنهادی برای مطالعه | 193–193 | final_exam only |

### Migration 237 (batch 7) — 12 topics / 21 rows

| field | grade | subject | chapter | pos | title | pages | tracks |
|---|---|---|---|---|---|---|---|
| experimental_sciences | 11 | ریاضی ۲ | فصل ۷: آمار و احتمال | 3000 | منابع | 167–167 | konkur + final_exam |
| experimental_sciences | 12 | ریاضی ۳ | فصل ۷: احتمال | 3000 | منابع | 149–151 | konkur + final_exam |
| humanities | 10 | ریاضی و آمار ۱ | فصل ۴ | 3004 | منابع | 118–118 | konkur + final_exam |
| humanities | 11 | ریاضی و آمار ۲ | فصل ۳ | 3002 | منابع | 71–71 | konkur + final_exam |
| humanities | 12 | ریاضی و آمار ۳ | فصل ۳ | 3004 | منابع | 105–105 | konkur + final_exam |
| mathematics | 12 | سلامت و بهداشت | درس‌ها | 3007 | منابع | 185–185 | final_exam only |
| experimental_sciences | 12 | سلامت و بهداشت | درس‌ها | 3007 | منابع | 185–185 | final_exam only |
| humanities | 12 | سلامت و بهداشت | درس‌ها | 3007 | منابع | 185–185 | final_exam only |
| mathematics | 10 | شیمی ۱ | فصل ۳: آب، آهنگ زندگی | 3001 | منابع | 126–126 | konkur + final_exam |
| experimental_sciences | 10 | شیمی ۱ | فصل ۳: آب، آهنگ زندگی | 3001 | منابع | 126–126 | konkur + final_exam |
| mathematics | 12 | شیمی ۳ | فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر | 3001 | منابع | 126–126 | konkur + final_exam |
| experimental_sciences | 12 | شیمی ۳ | فصل ۴: شیمی، راهی به سوی آینده‌ای روشن‌تر | 3001 | منابع | 126–126 | konkur + final_exam |

### Migration 239 (follow-up 5A) — 11 topics / 13 rows

This matches the follow-up 5A record: 13 of the migration's 21 DB rows
(16 topics) are منابع rows.

| field | grade | subject | chapter | pos | title | pages | tracks |
|---|---|---|---|---|---|---|---|
| mathematics | 10 | کارگاه کارآفرینی و تولید | بخش‌های ۲۸ تا ۳۲ | 3000 | منابع و مآخذ | 128–128 | final_exam only |
| experimental_sciences | 10 | کارگاه کارآفرینی و تولید | بخش‌های ۲۸ تا ۳۲ | 3000 | منابع و مآخذ | 128–128 | final_exam only |
| humanities | 10 | کارگاه کارآفرینی و تولید | بخش‌های ۲۸ تا ۳۲ | 3000 | منابع و مآخذ | 128–128 | final_exam only |
| mathematics | 10 | آمادگی دفاعی | فصل ۴: دفاع غیرنظامی | 3000 | منابع برای مطالعه بیشتر | 159–160 | final_exam only |
| experimental_sciences | 10 | آمادگی دفاعی | فصل ۴: دفاع غیرنظامی | 3000 | منابع برای مطالعه بیشتر | 159–160 | final_exam only |
| humanities | 10 | آمادگی دفاعی | فصل ۴: دفاع غیرنظامی | 3000 | منابع برای مطالعه بیشتر | 159–160 | final_exam only |
| mathematics | 12 | علوم اجتماعی | درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران | 3000 | منابع | 92–93 | final_exam only |
| experimental_sciences | 12 | علوم اجتماعی | درس ۱۰: ابعاد جمعیتی و اقتصادی هویت ایران | 3000 | منابع | 92–93 | final_exam only |
| experimental_sciences | 11 | زمین‌شناسی | فصل ۷: زمین‌شناسی ایران | 3000 | منابع | 127–127 | konkur + final_exam |
| mathematics | 11 | زمین‌شناسی | فصل ۷: زمین‌شناسی ایران | 3000 | منابع | 127–127 | final_exam only |
| humanities | 10 | تاریخ ۱ | درس ۱۶ | 3000 | منابع و مآخذ | 153–157 | konkur + final_exam |

### Migration 240 (follow-up 5B) — 1 topic / 2 rows

| field | grade | subject | chapter | pos | title | pages | tracks |
|---|---|---|---|---|---|---|---|
| humanities | 11 | تاریخ ۲ | درس ۱۶ | 3000 | منابع و مآخذ | 202–205 | konkur + final_exam |

## 3. How optionality is represented (it is structural, not a flag)

There is **no optional/required flag anywhere**, and none is needed, because
no part of the planner treats any bank row as required. Optionality is the
absence of any forcing mechanism at every layer:

### (a) Schema — `supabase/migrations/128_planner_topic_bank.sql`

`private.planner_topic_bank` has exactly 13 columns — `id, edition,
study_field, grade, preparation_track, subject, chapter, title, page_start,
page_end, position, revision, updated_at` — verified against
`information_schema` in the test. No `is_required` / `required` / `optional`
column exists, and the only `required` words in migration 128 are the role
error messages ("Counselor or administrator required", "Administrator
required"). No check constraint mentions coverage or completeness.

### (b) Listing — `planner_list_topics` (migration 128, lines 21–37)

Returns **all** rows for `(edition, study_field, grade, preparation_track,
subject, chapter)` ordered by `position, id`, as JSON objects with exactly
the keys `id, edition, studyField, grade, track, subject, chapter, title,
pageStart, pageEnd, order, revision` — no required/optional key, no
filtering, no ordering that promotes منابع (they sort last by their
position ≥ 3000). A منابع row is listed exactly like any other row.

### (c) Selection — `lib/planner-topics.ts` (`selectBankTopic`, `suggestNextTopic`)

- `selectBankTopic(topic, pages?)` copies **one** caller-chosen topic into
  a plan item (`{bankId, title, pageStart, pageEnd}`) and only validates
  the page range. It accepts any bank row and never inspects other rows.
- `suggestNextTopic(bank, uses, target)` returns a **single** next topic
  (or `null` when the chapter is exhausted) based on chronological use.
  It is a suggestion: the UI must explicitly apply it, and it never throws
  or blocks when a row is skipped or absent.
- Neither function contains the word "required" or any select-all logic
  (asserted in the test by reading the file).

### (d) Selector UI — `components/dashboard/planner-topic-editor.tsx`

One `<select>` dropdown with the placeholder option `انتخاب مبحث`
("choose a topic"), one topic chosen at a time via `choose(topic)`; the
suggestion appears as a card with an `انتخاب پیشنهاد` ("choose suggestion")
button that the counselor must click. There is no "select all", no default
selection, and no validation that anything was picked: a topic can also be
typed in manually as free text (`می‌توانی مبحث را دستی وارد کنی` when the
bank is unavailable), and a plan item may carry zero bank topics
(`bankId` is optional in `PlannerTopic`, `lib/planner-grid.ts:2`).
The admin bank manager (`planner-topic-bank-manager.tsx`) likewise lists
every row identically, with per-row edit/delete and no required marker.

### (e) "Completion" — plan items, not bank coverage

"Completed" in this codebase means a **plan activity was ticked done**
(`weekly_plan_item_completions`, `planner_review_completions`), per item —
it is never computed from bank coverage. No coverage computation exists:
`lib/planner-analysis.ts` contains no reference to the bank or topics at
all, and no code path compares a plan's used `bankId`s against the bank.

### (f) Publication validation — `supabase/migrations/126_planner_publish_validation.sql`

The authoritative validator never references `planner_topic_bank` at all.
For topics it checks only shape: title non-empty and ≤ 160 chars, `bankId`
optional (`topic ? 'bankId' and jsonb_typeof(topic->'bankId') not in
('string','null')` → raise, i.e. a missing `bankId` is fine), pages paired
and valid, and at most 50 topics per item (`jsonb_array_length(extra->'topics')>50`
— an upper bound, no minimum). The only "missing" check is
`Missing plan activities`, which fires when the snapshot has **zero plan
items** (and no prior published plan) — items, not topics. A plan whose
items carry no topics, or topics with no منابع row, passes validation as
far as the bank is concerned.

### The one nuance, stated plainly

Because منابع rows sit at the highest positions in their chapter,
`suggestNextTopic` will eventually **suggest** a منابع row once every
earlier topic in that chapter has been used — and after it is used, the
suggestion becomes `null`. That is a sequential suggestion, not a
requirement: the counselor can ignore it, pick any other topic, or type a
manual topic, and nothing errors. This is verified in the test (§5), not
assumed.

## 4. What changed

**Nothing.** No migration (249 unused — no `supabase/migrations/249_*`
file was created), no code change, no bank row added/edited/deleted. The
current behaviour already satisfies "منابع rows stay, selecting them is
optional", and adding a flag/column would be a gratuitous schema change
with migration, UI and admin-surface costs and no behavioural gain. If the
user later wants منابع rows visually marked "(اختیاری)" in the dropdown,
that is a pure UI label change, not a data-model change — not done here
because it was not asked for and no forcing behaviour exists to fix.

Guardrails respected: no commit/push/PR, `main` untouched, no PDFs in git,
no `git checkout/pull/reset/merge` run; only the two files in §6 were
written; `docs/planner-1405-audit-inventory.md`,
`docs/planner-topic-sources.md` and
`tests/planner-audit-full-chain-1405.test.cjs` were not edited.

## 5. Test results

`tests/phase3-manabe-optional-1405.test.cjs` — plain node script, PGlite
(minimal DB: migrations 128 + 167 + 233/234/235/237/239/240 only, so the
assertions are about the shipped rows and logic, not the full seed chain).
Run from the repo root:

```
node tests/phase3-manabe-optional-1405.test.cjs
PASS: Phase 3 item 2 — 45 منابع topics / 74 rows exist as ordinary selectable rows (migrations 233/234/235/237/239/240); no required/optional mechanism in schema, list, selection, suggestion or publication validation; a plan without any منابع row is valid; admin delete/edit protection holds
```

Exit code 0. What it asserts:

1. All 45 back-matter topics from the six migration files exist in the DB
   for each applicable track with exact title/pages/revision 1 — 74 rows
   total; per-migration counts 12/18/8/21/13/2; all pages non-NULL; all
   positions ≥ 3000; two id-formula spot checks (حسابان ۲, تاریخ ۲).
2. Schema has exactly the 13 known columns; no required/optional column;
   migration 128 has no required-flag logic.
3. `planner_list_topics` for حسابان ۲ / فصل ۵ (konkur) returns 4 rows,
   منابع last, with exactly the 12 known JSON keys and pages 145–145.
4. Selection: `selectBankTopic` works on the منابع row itself (it is
   selectable, not hidden); with no history the suggestion is the first
   تمرین row, not منابع; after the three تمرین rows are used the
   suggestion is منابع (advisory); after منابع is used the suggestion is
   `null` (chapter done, no error); a 3-topic plan set with no منابع row
   selects cleanly and the suggestion path works on the reduced bank,
   ending in `null`.
5. Static file checks: no "required"/select-all in `lib/planner-topics.ts`
   or the topic editor; editor has the `انتخاب مبحث` placeholder and
   manual-entry fallback; migration 126 never mentions
   `planner_topic_bank`, treats `bankId` as optional, caps topics at 50
   with no minimum, and its only missing-check is about plan items.
6. Admin delete of two منابع rows (حسابان ۲ konkur; ریاضیات گسسته
   final_exam) leaves selection working on the remaining rows; admin edit
   of the هندسه ۳ منابع row survives a re-run of all six migrations, and
   neither deleted row is resurrected (install-marker gating) — the re-run
   is a byte-identical no-op on the bank snapshot.

Two test bugs were found and fixed during development (both in the test,
not the product): an SQL `AND`/`OR` precedence error in the shared
منابع predicate, and a wrong expected title (`تمرین رسم نمودار یک تابع`
vs the actual `تمرین رسم نمودار تابع`) plus a `page_start`/`pageStart`
column-name mix-up in the test's row mapper.

## 6. Files written (only these)

- `tests/phase3-manabe-optional-1405.test.cjs`
- `docs/planner-1405-audit/phase3-2-evidence.md` (this file)

## 7. Verdict

**COMPLETE.** The منابع rows (45 topics / 74 rows, §2) stay in the bank and
are already ordinary, optional, selectable rows: no schema flag, no
list/selection/suggestion forcing, no publication or completion check
requires them, and a plan without any منابع row is valid. Nothing changed,
for the reason stated in §4.

## 8. Uncertainties / what was not verified

- Publication validation (migration 126) was verified by reading the
  function text, not by executing a live publish: the publisher depends on
  `profiles`/`weekly_plans` tables and is itself marked revoked/candidate
  in its header comment, so a live publish run was out of scope for this
  item. The file-text facts (no bank reference, optional `bankId`, 50-item
  cap, items-only missing check) are exact quotes from the file.
- The PGlite test uses a minimal DB (128 + 167 + the six migrations), not
  the full seed chain, so it proves the منابع rows and the selection logic
  in isolation; it does not re-prove the full-chain counts (those belong
  to the coordinator's full-chain test, which was not edited).
- The "65 content rows" count for lesson-content titles containing منابع
  comes from a JSON-object scan of the migrations; a few very old
  migrations use non-JSON seed formats, so that count is approximate and
  immaterial — the back-matter set (§2) is exact, since every back-matter
  row lives in the six JSON migrations listed.
- Whether the user wants a visible "(اختیاری)" label on منابع rows in the
  dropdown is a UX preference, not a correctness gap: no decision was
  taken here.
