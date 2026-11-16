# Phase 3 item 1 — near-duplicate rows: hide the moved rows from new selection

Branch `arena/9639a778-nova`, school year 1405–1406. Migration
`supabase/migrations/245_planner_phase3_hide_moved_rows_1405.sql`, test
`tests/phase3-near-duplicates-1405.test.cjs`.
Verdict: **DONE — both rows of each near-duplicate pair are kept, and the
old (moved) rows are hidden from the counselor's new-selection list only.**
No row was deleted or merged. The near-duplicates themselves remain an open
user decision only in the sense of follow-up 2 (delete vs. keep both);
hiding is reversible by a future migration, not by the admin UI (see §5).

## 1. The rows

Both pairs are grade 11, field `humanities`, both tracks
(`konkur`, `final_exam`). Ids below were verified independently by
recomputing `md5('nova:planner:1405:v1:humanities:11:<track>:<subject>:<old
chapter>:<position>')` and `md5('nova:planner:1405:v204|v180:...')` in
Python, and match the ids pinned in
`tests/followup-soc-geo-fix-1405.test.cjs`.

### جامعه‌شناسی ۲ — درس ۱۴, pp. 120–123

| row | id | pos | title | pages | rev |
|---|---|---|---|---|---|
| OLD (moved by 241 from درس ۱۵) — **hidden by 245** | konkur `e1f041b8-3698-b415-9346-605aee28bdc0` | 1 | انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم | 120–123 | 2 → **3** |
| OLD (moved by 241 from درس ۱۵) — **hidden by 245** | final_exam `0259b466-5818-af75-41de-dae34dd9d24a` | 1 | انقلاب اسلامی در مقایسه با انقلاب‌های قرن بیستم | 120–123 | 2 → **3** |
| CORRECT (v204, already there) — stays visible | konkur `3f8e8ce1-7250-5670-eabb-02b7b93e8a4c` | 453 | مقایسه انقلاب اسلامی و انقلاب‌های آزادی‌بخش | 120–123 | 1 |
| CORRECT (v204, already there) — stays visible | final_exam `1c627f07-0d65-f180-0f43-f9c6e1bb2591` | 453 | مقایسه انقلاب اسلامی و انقلاب‌های آزادی‌بخش | 120–123 | 1 |

### جغرافیا ۲ — درس ۲, pp. 15–17 / 15–18

| row | id | pos | title | pages | rev |
|---|---|---|---|---|---|
| OLD (moved by 241 from درس ۱) — **hidden by 245** | konkur `15268375-d484-b1fa-0dcf-6f2db3fa14db` | 3 | کانون و مرزهای ناحیه | 15–17 | 2 → **3** |
| OLD (moved by 241 from درس ۱) — **hidden by 245** | final_exam `58396032-946b-72d8-44c8-46d6c8d182aa` | 3 | کانون و مرزهای ناحیه | 15–17 | 2 → **3** |
| CORRECT (v180, already there) — stays visible | konkur `3eb9f3c1-f2cb-e727-0433-46f8eafdd516` | 303 | کانون و مرز ناحیه | 15–18 | 1 |
| CORRECT (v180, already there) — stays visible | final_exam `2b7d8343-c945-c735-85d2-8a20610ab495` | 303 | کانون و مرز ناحیه | 15–18 | 1 |

Note: the moved rows also share their `(chapter, position)` with a
different v1 row already in the target lesson (جامعه‌شناسی ۲ درس ۱۴ pos 1
«جنبش تنباکو و عدالتخانه»; جغرافیا ۲ درس ۲ pos 3 «تغییر نواحی و نقش
تصمیم‌های انسان»). Hiding is therefore per-row by id, never by
`(chapter, position)` — a position-based rule would have hidden the wrong
rows too.

## 2. What was investigated

### Schema — `supabase/migrations/128_planner_topic_bank.sql`

`private.planner_topic_bank` has no `hidden` / `is_active` /
`deprecated` column (confirmed by grep over `lib/planner-topics.ts`,
`lib/study-catalog.ts`, `lib/school-catalog.ts` and the migration). No
other migration ever added a column to this table. Columns:
`id, edition, study_field, grade, preparation_track, subject, chapter,
title, page_start, page_end, position, revision, updated_at`. The table
is revoked from `public`/`anon`/`authenticated`; all access is through
RPCs.

### The list function — 128, re-issued in 192 (current)

`public.planner_list_topics(edition, field, grade, track, subject,
chapter)` is defined in 128; migrations 130/133/140 only mention it in
comments — 192
(`supabase/migrations/192_planner_topic_super_admin.sql`) is the current
canonical definition. It returns every row matching the six keys,
ordered by `position, id`, with no filtering of any kind. It already
branches on the caller's role (`private.current_user_role()`): counselor
→ `require_planner_preset_access()`; otherwise admin + super-admin
required; students rejected. `planner_list_topic_chapters` (133/140/192)
derives chapter names from the same table; both affected chapters still
contain visible rows, so it needs no change. `planner_save_topic` /
`planner_delete_topic` (128, re-issued in 192) take the row id directly
and touch only the listed columns — they never read or write any flag.

### The two UI paths that call the same RPC

- **New selection (counselor):**
  `components/dashboard/planner-topic-editor.tsx` → `planner_list_topics`
  → renders the bank as a `<select>` dropdown plus a
  `suggestNextTopic` suggestion. Its only renderer is
  `components/dashboard/weekly-plan-builder.tsx:898`, which is rendered
  only by `app/dashboard/counselor/plans/page.tsx` (counselor route).
- **Admin management (super-admin):**
  `components/dashboard/planner-topic-bank-manager.tsx` → the *same*
  `planner_list_topics` RPC → renders each listed row with ویرایش / حذف
  buttons wired to `planner_save_topic` / `planner_delete_topic`. A row
  not in the list cannot be edited or deleted through the UI.

No code anywhere reads `private.planner_topic_bank` directly from the
app (grep over `lib/`, `app/`, `components/`); all bank access goes
through the three RPCs.

### How old plans read back — `lib/planner-topics.ts`, `lib/planner-grid.ts`

Plans store a snapshot per topic: `{ bankId, title, pageStart, pageEnd }`
(`selectBankTopic` copies title/pages out of the bank row at selection
time; `PlannerTopic` type in `lib/planner-grid.ts`). Rendering a saved
plan uses the stored snapshot — **no bank lookup happens at plan read
time**. The only place a stored `bankId` is resolved against the bank is
`suggestNextTopic` (`lib/planner-topics.ts`), which maps stored
`topicIds` from `planner_topic_history` onto the listed bank to find the
next topic. Hiding a row therefore cannot break plan read-back; it only
affects suggestion continuation (see §5 caveat).

## 3. Mechanism chosen

A blanket filter in `planner_list_topics` was **rejected**: it would
hide the four rows from the admin manager too, making them uneditable
and undeletable in the only shipped admin UI — that fails the "without
touching any admin edit" condition. Client-side filtering was also
rejected: it would require editing `planner-topic-editor.tsx` /
`planner-topic-bank-manager.tsx`, which are outside this item's files.
Deleting, merging, or re-positioning the rows was forbidden by the task
(keep both rows).

Chosen mechanism — new column + role-aware filter in the list function:

1. `alter table private.planner_topic_bank add column if not exists
   hidden_from_selection boolean not null default false;`
   New rows (including admin-created ones via `planner_save_topic`,
   whose INSERT lists columns explicitly) default to visible.
2. `planner_list_topics` re-issued **byte-identical to 192 except one
   added predicate** in the `WHERE` clause:
   `and (role='admin'::public.app_role or not t.hidden_from_selection)`.
   Counselors (the new-selection actor) no longer see hidden rows;
   super-admins still see every row, so the manager keeps full
   edit/delete access. The output shape is unchanged, so both callers'
   parsers are unaffected. Grants/revokes and `notify pgrst, 'reload
   schema'` are copied verbatim from 192.
3. Guarded update (pattern B, adapted to the post-241 state) sets
   `hidden_from_selection=true` and bumps `revision` 2 → 3 **only** for
   rows matching: original v1 id formula (computed from the ORIGINAL
   chapter), new chapter, original title, original position, post-241
   pages (120–123 / 15–17), `revision=2`, not already hidden. A row an
   admin edited after 241 (revision bumped, or any field changed) does
   not match and stays visible; a row 241 never moved does not match
   either. No row is inserted or deleted, so an admin-deleted row can
   never be resurrected.

## 4. What changed

Migration 245 only:

- 4 rows hidden (flag `true`, revision 2 → 3, `updated_at` bumped):
  `e1f041b8-…`, `0259b466-…`, `15268375-…`, `58396032-…` (§1).
- 0 rows added, 0 rows removed, 0 titles/pages/positions changed.
- Correct rows (`3f8e8ce1-…`, `1c627f07-…`, `3eb9f3c1-…`,
  `2b7d8343-…`) untouched (revision 1, flag `false`).
- `planner_save_topic` / `planner_delete_topic` /
  `planner_list_topic_chapters` untouched.

## 5. Caveats and open decisions

- **Suggestion fallback (narrow, by design).** The counselor's list
  feeds both the dropdown and `suggestNextTopic`. If a student's most
  recent plan topic is a hidden row, `suggestNextTopic` skips that id
  (`positions.get(...)` → `undefined`) and falls back to an earlier
  topic id in the same activity, or to the first topic of the chapter.
  Plan contents are unaffected; only the "next topic" suggestion can
  restart at the chapter start for plans whose last topic was a moved
  row. Verified by reading `lib/planner-topics.ts` (`suggestNextTopic`,
  lines ~20–50); not exercised end-to-end in the test because the
  function lives in TS and the test harness is PGlite/SQL.
- **Super-admins still see hidden rows in the selector.** If a
  super-admin ever opens the counselor plan builder, the hidden rows
  appear in their dropdown (the filter keys on role, and super-admins
  are the bank managers). Counselors — the actual new-selection users —
  do not see them. Accepted as the price of keeping admin management
  intact without touching UI files.
- **No UI unhide control.** The manager lists hidden rows but has no
  "unhide" affordance, and `planner_save_topic` deliberately does not
  touch the flag (so an admin edit preserves `hidden=true`). Unhiding
  needs a future migration (or a UI change, which is outside this
  item). An admin edit of a hidden row keeps it hidden; an admin
  delete of a hidden row still works.
- **Open decision (carried from follow-up 2, not decided here):**
  whether the near-duplicates should eventually be deleted/merged or
  kept hidden-but-present. This item implements the "keep both, hide
  the old ones" branch; it does not settle delete-vs-keep.

## 6. Tests

`node tests/phase3-near-duplicates-1405.test.cjs` — **PASS, exit 0**
(PGlite; `node_modules/@electric-sql/pglite` present in the clone).
Chain: stubs (roles, `current_user_role`/`is_super_admin`/
`require_planner_preset_access` test doubles, install-marker table,
`published_snapshot`) + deps 128, 144, 148, 167, 180, 204, 229, 230 +
241 + 245. Assertions:

- Pre-state: 4 old rows exist, NULL pages, revision 1, old chapters.
- After 241 + 245: exactly the 4 moved rows changed (revision 3,
  flag `true`); no row added/removed; correct rows untouched
  (revision 1, flag `false`).
- Counselor list (approved counselor) for جامعه‌شناسی ۲ درس ۱۴ and
  جغرافیا ۲ درس ۲, both tracks: old ids absent, correct ids present;
  an unrelated row (جغرافیا ۲ درس ۱۰ «مهارت نقشه مرزهای ایران و
  همسایگان») still listed.
- Super-admin list: old ids present with revision `'3'` (manager can
  still edit/delete them); student role still rejected.
- Old-plan read-back: stored snapshots `{bankId, title, pageStart,
  pageEnd}` for an old id in each subject still resolve by id with
  identical title/pages, and the admin list returns them.
- Re-running 245 is a no-op (bank snapshot unchanged).
- Simulated super-admin edit of a hidden row (via
  `planner_save_topic`, revision 3 → 4) survives a re-run, keeps the
  flag `true`, stays hidden from counselors and listed for admins.
- Simulated super-admin delete of a hidden row is NOT resurrected
  by a re-run.
- A brand-new admin-created row defaults to visible and is listed to
  counselors.
- Guard instance A (edit + delete *before* 241): edited row untouched
  by both migrations (still درس ۱۵, NULL pages, revision 2, **visible**
  — counselor list still shows it); deleted row not resurrected;
  the other two pristine rows moved and hidden.
- Guard instance B (edit *between* 241 and 245): edited moved row
  stays visible (revision 3, admin title preserved); the other three
  moved rows hidden; re-run is a no-op.
- `published_snapshot` unchanged throughout.

Regression: `node tests/followup-soc-geo-fix-1405.test.cjs` still
**PASS, exit 0**. The full-chain test was not edited (coordinator's
file); it does not apply 245, and its phase-1 count (migrations
128–244 = 117 files) is unaffected by adding 245.

## 7. Files written (only these)

- `supabase/migrations/245_planner_phase3_hide_moved_rows_1405.sql`
- `tests/phase3-near-duplicates-1405.test.cjs`
- `docs/planner-1405-audit/phase3-1-evidence.md` (this file)

Nothing committed, pushed, or PR'd; `main` untouched; no PDF in git.
No other file was edited.

## 8. Uncertainties / not verified

- The role-aware filter was verified in PGlite with the test doubles
  for `current_user_role()` / `is_super_admin()` (same doubles the
  follow-up-2 test uses), not against a live Supabase with real
  `profiles` rows. The live `private.current_user_role()` reads
  `public.profiles` (`002_harden_rls_functions_and_indexes.sql`); the
  filter uses the same `role` variable the 192 function already
  computes, so no new role plumbing is introduced.
- The `suggestNextTopic` fallback (§5) was verified by code reading,
  not by an end-to-end browser run.
