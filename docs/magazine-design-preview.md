# NOVA latest magazine design previews

Removed the entire homepage four-step “از ثبت‌نام تا یک برنامه قابل اجرا” section and its unused CSS/data. Footer programming anchor now points to the retained path finder.

Three server-rendered layouts selectable by `?mag=cards|editorial|digest#mag`:
1. White minimal three-card grid (default).
2. Warm cream editorial layout, newest story large and two compact stories.
3. Pale-blue open digest with lead story and ruled thumbnail list.

All use the same real, latest three published Supabase resources, dates, cover images and `/mag/:id` links. No new articles, invented metadata, fake reading times, newsletter forms, filters or backend writes. A real empty state and image-free cover fallback are included. Alt is empty on redundant decorative cover images because the adjacent article title labels the single link. Native article/date/headings and keyboard focus. Image uses Next Image unoptimized to preserve existing remote URLs without new provider config.

Hero, sticky nav, accepted white benefits and approved star selector are unchanged. Preview only, no main merge or production publication.
