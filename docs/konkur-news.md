# اخبار کنکور نووا

## Scope

- Branch: `feature/konkur-news`; no push or merge to `main`.
- Separate landing section directly after `MagazineLatest`, using its existing warm magazine theme.
- Desktop section uses the existing `100svh - header height` pattern; mobile cards stack naturally.
- Public archive: `/news`; published news detail: `/news/[id]`.
- Counselor list/editor: `/dashboard/counselor/news`, `/new`, `/[id]`.
- Existing article table, enums, policies, article queries, routes and magazine component/CSS remain unchanged.
- Shared editor adds an opt-in `news` mode only; original article defaults remain unchanged. News uses an explicit hidden submit intent to avoid losing the clicked button value while React updates pending state.

## Database rollout

Schema and seed migrations were applied to the connected Nova database after the user requested activation. For a new environment, apply in order:

1. `supabase/migrations/022_konkur_news.sql`
2. `supabase/migrations/023_seed_konkur_news.sql`

Use the project's normal reviewed migration process; do not reset the database. Migration 022 only creates the new table, policies, indexes and update-time trigger. Migration 023 inserts three editorial summaries with stable IDs, without changing existing data. Editorial seeds have no fabricated counselor author. The original source date is separate from the Nova publication timestamp. Re-running the seed inserts does not duplicate or overwrite records.

Only published news is publicly readable. Approved counselor authors can insert and manage their own news. Other counselors cannot edit or archive someone else's news. Students and anonymous visitors cannot write. Editorial seeds cannot be claimed by counselor writes; admins can manage them under RLS. No service-role secret is added to the application.

News validation requires title, meaningful rich text, source name, HTTP(S) source link and a valid non-future source date. Invalid JSON and unsafe rich-text image/link schemes are rejected. Source credibility still requires editorial review: a valid URL is not proof of truth.

## Initial source-backed summaries

These are dated summaries, **not live feeds or current deadline promises**:

- Initial 1405 entrance exam results, source published 2026-10-03: https://www.mehrnews.com/news/6966489
- Definite effect of grade 11/12 academic records for the 1406 exam, source published 2026-09-24: https://www.mehrnews.com/news/6956825
- Academic-record subjects and coefficients for the 1406 exam, source published 2026-09-23: https://www.mehrnews.com/news/6955598

Each detail page shows its original source date, clickable source and a reminder to check the latest official notice. Historical selection deadlines are explicitly identified as the originally reported period.

## Verification

Unit tests (no live database):

```sh
./node_modules/.bin/tsc --target ES2020 --module commonjs --outDir /tmp/nova-news-tests --skipLibCheck lib/content.ts lib/news-validation.ts tests/news-validation.test.ts tests/news-archive.test.ts
node --test /tmp/nova-news-tests/tests/*.test.js
```

Type checking: `./node_modules/.bin/tsc --noEmit`.

Verified locally: 11 tests (validation and archive regressions), TypeScript, production build, and lint on changed files. Browser smoke tests used an isolated mock backend (no production data): public source/detail/404 routes, anonymous counselor-route protection, draft → publish → archive, and article-form defaults. Layout checked at 1440×900, 1366×768, 1024×768 and 390×844 with no horizontal overflow; desktop news section fits within the viewport minus the existing header.

Lint only modified TypeScript/TSX files, since full-project `npm run lint` also scans the unchanged vendored `public/pdfjs/pdf.min.js` and currently reports existing errors there.

Before production activation, verify against staging Supabase (mock UI tests cannot establish real database RLS behavior):

- Approved counselor creates a draft; anonymous readers cannot list or open it.
- Publish, edit and archive own news; home/archive/detail views update correctly.
- A second counselor cannot edit/archive the first counselor's news, including direct REST calls.
- Students, pending/revoked counselors and anonymous users cannot insert/update/delete.
- Counselor writes cannot claim or edit editorial seed records.
- Article creation, publication and existing `/mag` routes still work.
- Check image uploads with staging ImageKit credentials; the existing approved-counselor content upload endpoint is reused.


## News archive refinement

The `/news` route now has a dedicated archive layout, independent from `KonkurNewsLatest`: a page-level H1, breadcrumb/back link, latest-story spotlight and a full two-column archive. The landing still shows its existing three equal warm cards and its all-news CTA; the archive no longer repeats that CTA. All additional CSS is scoped under `.news-archive`; existing magazine/global styles are unchanged.

Migration `024_konkur_news_source_images.sql` adds each original Mehr story photograph to the three editorial seeds, with source credit. It preserves existing text, publication dates, status and author, skips records that already have an image, and never modifies counselor-authored news. Images are referenced at their original source URLs, retaining source branding; availability depends on that source.

Archive QA: production build, TypeScript and changed-file lint passed; browser tests checked the landing→archive navigation, missing self-CTA, source images, three detail pages, desktop/tablet/mobile layouts, empty/error states and unchanged magazine. Photos were loaded from locally cached copies of the exact source images for deterministic visual testing.

Migration 024 was applied to the connected Nova database in this follow-up; all three source-image URLs and credit links were verified. No deployment or main-branch write/merge was performed.
