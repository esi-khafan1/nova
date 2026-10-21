// Run: node --conditions=react-server tests/request-auth-cache.test.cjs
// Uses real React.cache, with a request-local test dispatcher for React 19.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const { AsyncLocalStorage } = require('node:async_hooks');
const requests = new AsyncLocalStorage();
const internals = React.__SERVER_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE;
assert.ok(internals, 'Run with --conditions=react-server');
const original = internals.A;
internals.A = { getCacheForType(factory) {
  const request = requests.getStore();
  if (!request.roots.has(factory)) request.roots.set(factory, factory());
  return request.roots.get(factory);
} };
function load(path, dependencies) {
  const module = { exports: {} };
  const code = ts.transpileModule(fs.readFileSync(path, 'utf8'), { compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2020 } }).outputText;
  vm.runInNewContext(code, { module, exports: module.exports, performance, process, console, require(name) {
    if (!(name in dependencies)) throw Error(`Unexpected import ${name}`);
    return dependencies[name];
  } });
  return module.exports;
}
const shared = load('lib/supabase/request-auth.ts', {
  react: React,
  '@/lib/supabase/server': { createClient: async () => {
    const req = requests.getStore();
    req.clients++;
    return { auth: { getUser: async () => { req.users++; return { data: { user: req.user } }; } },
      from(table) {
        assert.equal(table, 'profiles');
        return { select() { return this; }, eq(field, id) { assert.equal(field, 'id'); assert.equal(id, req.user.id); return this; },
          single: async () => { req.profiles++; return { data: req.profile }; } };
      },
    };
  } },
});
const auth = load('lib/auth.ts', {
  react: React,
  '@/lib/supabase/request-auth': shared,
  'next/navigation': { redirect: url => { const error = Error('redirect'); error.url = url; throw error; } },
});
const fixture = (id, role, status = 'active', confirmed = true) => ({ roots: new Map(), clients: 0, users: 0, profiles: 0,
  user: id ? { id, email_confirmed_at: confirmed ? '2026-01-01' : null } : null,
  profile: id ? { id, role, registration_status: status } : null,
});
async function expectRedirect(fn, url) { await assert.rejects(fn, error => error.url === url); }
(async () => {
  const alice = fixture('alice', 'admin');
  const bob = fixture('bob', 'student', 'pending');
  // Concurrent requests use separate cache roots, never another user's profile.
  await Promise.all([
    requests.run(alice, async () => {
      const results = await Promise.all([shared.getRequestUser(), auth.requireProfile(['admin']), auth.requireProfile(['admin'], true)]);
      assert.equal(results[1].profile.id, 'alice');
      await expectRedirect(() => auth.requireProfile(['counselor']), '/dashboard');
      assert.equal(alice.users, 1); assert.equal(alice.profiles, 1);
    }),
    requests.run(bob, async () => {
      const result = await auth.requireProfile(['student'], true);
      assert.equal(result.profile.id, 'bob');
      await expectRedirect(() => auth.requireProfile(['student']), '/dashboard/registration');
      assert.equal(bob.users, 1); assert.equal(bob.profiles, 1);
    }),
  ]);
  const next = fixture('alice', 'counselor');
  await requests.run(next, async () => {
    assert.equal((await auth.requireProfile(['counselor'])).profile.role, 'counselor');
    assert.equal(next.users, 1); assert.equal(next.profiles, 1);
  });
  const guest = fixture(null);
  await requests.run(guest, () => expectRedirect(() => auth.requireProfile(), '/auth/sign-in'));
  assert.equal(guest.profiles, 0);
  const unconfirmed = fixture('eve', 'student', 'active', false);
  await requests.run(unconfirmed, () => expectRedirect(() => auth.requireProfile(['student'], true), '/auth?mode=signin&error=unconfirmed'));
  const missing = fixture('missing', 'student'); missing.profile = null;
  await requests.run(missing, () => expectRedirect(() => auth.requireProfile(), '/auth/sign-in'));
  console.log('Real React request-cache tests passed: 1 user/profile read per render, cross-user isolation and authorization preserved.');
})().catch(error => { console.error(error); process.exitCode = 1; }).finally(() => { internals.A = original; });
