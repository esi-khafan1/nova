# Renewal discount operations

The renewal workflow is separate from existing registrations and does not alter
an active student's service, assignment or old receipt. An administrator must
review the newly submitted receipt and independently manage the service.
The fixed percentage applies to the currently configured period price and is
recorded in a 24-hour, single-use quote. Only active, unblocked students with a
confirmed contact can request a quote; unsuccessful code checks are rate-limited.

Migration 257 deliberately does not contain the secret. Before enabling the
frontend, an authorized operator must provision exactly one row in
`private.renewal_discount_secret` using a random 32-byte salt and the SHA-256
of that salt concatenated with the UTF-8, trimmed, uppercase code. Do not put
the code, salt/hash pair, or provisioning command in Git or public logs. A
missing secret fails closed. Rotate the salt and digest together if necessary.
A discount code is not an authentication credential: keep the eligibility,
rate-limit and manual receipt review protections even if the code is private.
