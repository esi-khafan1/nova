# Course catalog and one-month pricing

Only Base and Progress are advertised, in duration-first order for 1, 3, 6 and 12 months (eight choices per grade/field). Other plan definitions/labels and historical registrations remain intact; hiding a plan does not delete existing enrollments.

All amounts are **toman**, not rial:

| Grade | Plan | Monthly original | Monthly discounted |
| --- | --- | ---: | ---: |
| 12 | Base | 3,200,000 | 2,290,000 |
| 12 | Progress | 3,500,000 | 2,590,000 |
| 10/11 | Base | 3,000,000 | 2,100,000 |
| 10/11 | Progress | 3,400,000 | 2,390,000 |

Both original and discounted totals multiply the monthly amount by the selected number of months. No additional long-term discount is invented. A shared price helper/component supplies the card, detail page and enrollment summary. Payments remain the existing private receipt/manual approval flow; this is not a new payment processor or a stored invoice-price feature.

## Preserve card sizes

Pricing is in the footer on the right, with the details button on the left. Compact two-line prices fit within the existing button-row height, without resizing the artwork, body or card. Removing the longer legacy plan text would otherwise shrink the carousel's auto-height row. Two invisible, inert reference cells occupy the first grid cell (not extra columns) solely to preserve the prior tallest-card geometry at every responsive width. They have no visible choice, keyboard/assistive-technology interaction, image download or automatic link prefetch. The visible cards retain original responsive column widths, gaps and sizing. Scroll-edge calculations explicitly exclude these reference cells. Details still contain the full descriptions.

Real headless Chromium measurements before and after matched **exactly** on both `/courses` and the landing course carousel at 1440×900, 1366×768, 1024×768, 768×1024, 700×900, 390×844, 375×812 and 320×740; no document-level horizontal overflow. Baseline measurements are in `tests/fixtures/course-card-dimensions.json`. `tests/course-card-layout.browser.cjs` reruns those assertions with a local server, playwright-core and a supplied Chromium executable. Measurements used bundled site fonts, grade 12/sciences and guest placeholder Auth config, not a production user. Other data loads in that preview were not a performance benchmark.

## Enrollment

Migration `068_one_month_courses.sql` was applied to the connected nova database. It extends the existing constraint and registration RPC to accept one month while retaining historical plan codes and prior 3/6/12-month choices. Existing student identity, confirmed email, inactive-account requirement, owned private receipt and pending approval guards are preserved. No registration, receipt, role or activation record was changed by the migration.

Validation: price/combinations/route tests cover every grade and supported field, original/discounted totals and legacy parsing; disposable PostgreSQL tests exercise all durations, historical plan codes and security/error guards. TypeScript, targeted ESLint and production build pass. Older unrelated full-suite baseline failures are not claimed fixed. No production purchase or deployment was performed.


## Footer pricing and Telegram receipt follow-up

The former artwork badge is removed from both shared course carousels. Footer grid placement in RTL puts prices on the right and the unchanged orange details button on the left. Footer-container-based font sizes keep even 12-month totals inside narrow mobile cards. Existing image rules, sizes/aspect ratios, card sizes, responsive columns and sizing references remain unchanged. Updated browser tests passed all 16 catalog/landing viewport cases against the original dimensions and assert price-to-button ordering, price below the image and text containment.

The enrollment payment section now offers a separate alternative receipt channel with a direct `https://t.me/nova_support26` link and visible LTR handle `@nova_support26`. It opens a new tab safely; Telegram/browser handles the app handoff. The ordinary in-site upload and private receipt/approval requirements are unchanged; sending in Telegram is an external support/manual-review path, not an automatic form submission or activation. The link is not shown on profile-only forms. No new database migration or production data change was needed. `tests/receipt-telegram.test.cjs` renders the actual form with mocked dependencies to verify enrollment-only rendering, destination/handle, safe tab attributes and preserved required upload. No live Telegram message was sent.
