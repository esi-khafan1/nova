# Approved N logo and favicon

Homepage footer now uses the exact `/nova/mark.svg` used by the centered navbar, replacing only its old comet/wordmark. Shared `Logo` elsewhere is unchanged.

`app/icon.svg` now contains the same self-contained N artwork. Root metadata includes a stable `/favicon.png` icon and shortcut, with a square 96×96 transparent PNG derived from that artwork. The static route decodes committed base64 bytes so the published resource is an actual image/png, not HTML or a screenshot. It is unauthenticated and excluded by the existing image middleware matcher. Existing canonical and robots settings are retained.

This prepares the search-result favicon; it does not guarantee Google's choice or timing. The main production site must first receive an explicitly approved release, then Google must recrawl. No Search Console submissions, production merge or main changes performed.

Warm magazine theme is now the accepted homepage default and old query variants cannot override it.
