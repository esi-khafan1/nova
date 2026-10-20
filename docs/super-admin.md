# Super administrator

Migration 055 adds a server-managed capability in `private.super_admins`.
The account retains `profiles.role = admin`, preserving existing admin RLS,
routes, activation tools and exports. It is labeled سوپرادمین in the directory.
Do not use editable user metadata or a client-writable profile flag for this.

Only a super administrator can promote a non-admin account to admin. Regular
admins retain student/counselor/exam-designer changes. Existing admin accounts
(including super admins) cannot be demoted through this interface. Neither role
can create other super admins from the browser. Capability grants are deliberate
database-owner operations, separate from source migrations.

Enforcement: server action + role-change RPC + profile-role trigger. The trigger
also blocks ordinary admins using direct REST updates to grant admin. Clients
cannot read/write the protected table; an admin-only RPC lists capability IDs
for directory labels and the current actor's role options.

Run `tests/super-admin-permissions.sql` as database owner on seeded data. It tests
regular admin RPC/direct escalation denial, retained role-change access, super
admin promotion, student escalation denial, and protected capability writes.
Successful test mutations are rolled back, as is the outer transaction.
