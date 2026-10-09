# NOVA latest magazine theme previews

The user accepted the structure of option 1: exactly three equal-width/equal-height cards in one desktop row. All themes now share that geometry, typography, real articles, crops, date metadata and single-column mobile layout. Removed lead/secondary hierarchy entirely.

Query themes: `?mag=cards#mag` keeps the white baseline; `?mag=sky#mag` is pale blue + white cards with blue CTA; `?mag=warm#mag` is cream + white cards with peach borders/orange CTA; `?mag=navy#mag` is a fixed navy section with slightly lighter navy cards and high-contrast text. Only theme colors change. The rest of the landing theme remains fixed.

The four-step section remains removed. Accepted hero/sticky header, white benefits and approved gray-star selector are retained. Real latest three published Supabase resources and `/mag/:id` links only; no backend writes, fabricated metadata or publishing changes. Empty and cover-free fallback remain included. Draft PR24 only; no main merge or production deployment.


## Final user choice
The user chose warm/cream-orange. Homepage now pins `warm` regardless of old `mag` preview query parameters; the earlier themes remain in historical previews only. Equal-card structure retained.
