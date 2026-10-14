# Ice-blue account entry UI

- `/auth` uses the unchanged `LandingHeader` component and the exact `landing-approved.css` stylesheet used by `/`. The centered blue N artwork remains `/nova/mark.svg`; no alternate navbar or logo was introduced.
- The former comet `Logo` component is removed from this page only. The existing approved landing illustration `/nova/hero.svg` is reused as a student mascot, not as a second logo.
- Styling is isolated under `.nova-auth-*` in the auth stylesheet. The form comes before the brand panel on phones. No dashboard, course, receipt, exam or global stylesheet is modified.
- Both sign-in and sign-up submission handlers are unchanged. Email confirmation URLs, metadata, validation, safe return destinations and Supabase calls remain the same. The existing signed-in server redirect is preserved.
- Password visibility and keyboard-operable tabs are UI conveniences only. Messages, busy/disabled states and standard autocomplete roles are retained.
- QA uses the real components with the backend mocked: 1440, 816, 390 and 320px layouts; shared menu focus/Escape and cart dialog; validation; failed/successful auth responses; password visibility; selected-course continuation through tab changes and confirmation callback; unsafe redirects; no real signup or auth writes.
- This redesign requires no database migration. Deploy to the existing feature preview; merging main requires separate approval.
