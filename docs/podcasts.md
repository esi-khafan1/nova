# Podcasts

## Public experience

- The landing adds a warm full-section `PodcastsLatest` directly after the magazine and before the latest Konkur news section. It reuses magazine card geometry and colors without altering the article/news tables or those components' behavior.
- `/podcasts` shows three equal cards per desktop row, two on tablets, one on mobile. Cards have an image, category, duration, title, summary and publication date.
- `/podcasts/[id]` shows a native accessible audio player, direct audio link, rich text and images. Playback is user-initiated, never autoplay; audio uses `preload="none"`. Player errors have a retry/direct-link fallback. Published-only queries protect draft/archived pages.
- Sitemap includes the podcast archive and published podcast entries.

## Counselor workflow

- Navigation and dashboard entry link to `/dashboard/counselor/podcasts`; list/new/edit screens support draft, publish, edit and archive.
- Podcast mode is opt-in on the existing rich-content form: title, summary, Konkur/final-exam category, grade, subject, rich text headings/formatting/lists/links/images, plus a separate audio upload panel. Article/news defaults are unchanged.
- Uploads go directly to ImageKit in `/nova/podcasts/audio` through the existing signed-upload endpoint, using the new approved-counselor-only `podcast-audio` purpose. No new credentials were created or exposed. Existing ImageKit keys and `NEXT_PUBLIC_IMAGEKIT_URL_ENDPOINT` are required.
- MP3, M4A, WAV, OGG and WebM are accepted, with client file-type/extension/size and native-decode validation. Limit: 40 MiB and 3 hours. Progress and cancel are supported. A failed replacement retains the previous audio. Client checks are convenience checks, not a server/provider antivirus guarantee.
- Server validation accepts only the configured ImageKit origin/path for uploaded audio, or one of the three bundled sample routes. Rejects untrusted schemes, external providers, invalid rich-document image/link URLs, invalid metadata/IDs, and publication without audio.
- Drafts may omit audio. Podcast metadata stays controlled so React form reset on a server validation error does not clear the author's title/summary/category/subject.
- Recording from a microphone is not implemented; upload a recorded voice file from the user's device.
- Authenticated actions verify counselor approval and author ownership. RLS independently enforces approval, ownership, and public visibility. Editorial samples cannot be edited by another counselor. An admin can manage editorial records through authorized database tools.

## Three original samples

1. برنامه هفتگی که واقعاً اجرا می‌شود (planning, approximately 99 seconds)
2. تمرکز را با یک قدم کوچک برگردان (focus, approximately 103 seconds)
3. بعد از آزمون، خودت را قضاوت نکن (review, approximately 100 seconds)

All have an original educational script/full transcript, original image-tool-generated photography and synthesized Persian narration (`fa-IR-DilaraNeural`). Both the spoken intro and visible sample notice disclose synthetic speech; no real counselor's identity or voice is claimed. The focus sample explicitly says it is not diagnosis/treatment.

Generated photographs are actual optimized WebP raster images inside text-safe SVG containers, not drawn substitutes. Covers are pinned to immutable GitHub asset commit `6ad3055579eb53da9844c1dac9726934baeb9030`.

Because the GitHub MCP writes UTF-8 text rather than binary, the original MP3 bytes are stored as base64 in three JSON files under `lib/podcast-samples`. `/podcasts/audio/[slug]` decodes only those allowlisted files, serves `audio/mpeg`, supports GET/HEAD and HTTP byte ranges (including suffix ranges), and returns 404/416 appropriately. Uploaded counselor audio is not embedded into the Worker and continues to use ImageKit. Do not add a growing podcast catalog into the Worker bundle; these three files are only the requested samples.

## Database and rollout

- `026_podcasts.sql`: independent table, indexes, updated-at trigger, publication/audio constraints, approved-owner RLS and explicit grants.
- `027_seed_podcasts.sql`: inserts three fixed editorial sample IDs; conflict handling does not overwrite existing data. No existing resource/news records are updated.
- Both migrations were applied to the connected Nova Supabase project through the official MCP. Three persisted samples were verified. Existing environments should apply migrations through their normal reviewed process.
- Feature branch only. No main merge or production frontend deployment is authorized by this implementation task. Cloudflare's feature preview will use the existing database, so the sample rows are ready there.

## Verification

- Production Next build, TypeScript and changed-file lint passed.
- 20 unit tests across existing news and new podcast validation/media tests passed.
- Local production browser tests with a mock backend verified: section placement/viewport fit at 1440/1366/1024px and mobile; equal archive geometry at desktop/tablet/mobile; actual immutable image hosting; all three MP3s decode/play/seek and HTTP 206 range responses; anonymous counselor redirect; no-audio publish rejection; MIME rejection; draft/publish/edit/archive; upload progress path and persistence with a mocked ImageKit provider; missing/empty/backend-error states; unchanged article/news form defaults.
- Real Supabase policy tests ran inside a rollback-only transaction: an approved counselor can create/update own draft, another approved counselor cannot update it or forge its author, a student cannot insert, anonymous reads see exactly the three published samples and not the temporary draft. All test writes rolled back.
- Real ImageKit upload using a signed-in counselor account has not been exercised; the provider was mocked for browser workflow tests. Verify one real upload before release if the integration's production configuration has changed.

## Follow-up: OGG compatibility and placement

- OGG file labels now accept application/ogg, audio/x-ogg and audio/opus as well as audio/ogg. MIME matching is case-insensitive and ignores codec parameters. A missing or generic application/octet-stream label is allowed only with an existing allowlisted audio extension; the native browser decode/duration check still runs before upload. HTML MIME, unknown extensions, empty/oversized files and corrupt non-audio payloads remain rejected.
- Podcast cards sit between magazine and Konkur news in the landing.
- The hamburger link is removed. The section's all-podcasts link, footer link and counselor dashboard navigation remain available.
