const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
function load(path, dependencies) {
  const module = { exports: {} };
  const code = ts.transpileModule(fs.readFileSync(path, 'utf8'), { compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2020 } }).outputText;
  vm.runInNewContext(code, { module, exports: module.exports, URL, Response, require(name) {
    if (!(name in dependencies)) throw Error(`Unexpected dependency: ${name}`);
    return dependencies[name];
  } });
  return module.exports;
}
const password = load('lib/password-input.ts', {});
const security = load('lib/email-confirmation.ts', {});
let cookie = 'a'.repeat(56);
let verified = 0, updated = 0, signedOut = 0;
let verifyFails = false;
let updateFails = false, loginFails = false;
let sessionsSaved = 0;
let suppliedPassword;
const actions = load('app/auth/recovery/actions.ts', {
  'next/headers': { cookies: async () => ({ get: () => cookie ? { value: cookie } : undefined, set: (_name, value) => { cookie = value; } }) },
  '@/lib/supabase/server': { createClient: async () => ({ auth: { setSession: async session => {
    assert.equal(session.access_token, 'test-access');
    assert.equal(session.refresh_token, 'test-refresh');
    sessionsSaved++;
    return { error: loginFails ? {} : null };
  } } }) },
  '@/lib/password-input': password,
  '@/lib/email-confirmation': security,
  '@/lib/supabase/recovery': { recoveryCookie: 'nova-password-recovery', recoveryClient: () => ({ auth: {
    verifyOtp: async input => { assert.equal(input.type, 'recovery'); verified++; return { error: verifyFails ? {} : null, data: { session: verifyFails ? null : {} } }; },
    updateUser: async input => { suppliedPassword = input.password; updated++; return { error: updateFails ? {} : null }; },
    getSession: async () => ({ data: { session: { access_token: 'test-access', refresh_token: 'test-refresh' } }, error: null }),
    signOut: async () => { signedOut++; return { error: null }; },
  } }) },
});
const mutations = [];
const route = load('app/auth/recovery/route.ts', {
  'next/server': { NextResponse: { redirect: (url, init) => { const response = new Response(null, { ...init, headers: { ...init.headers, Location: url } }); response.cookies = { set: (...args) => mutations.push(args) }; return response; } } },
  '@/lib/auth-urls': { AUTH_SITE_ORIGIN: 'https://nova-academy.ir' },
  '@/lib/email-confirmation': security,
  '@/lib/supabase/recovery': { recoveryCookie: 'nova-password-recovery' },
});
(async () => {
  assert.equal((await actions.saveRecoveredPassword('رمزعبور۱۲۳')).ok, false);
  assert.equal((await actions.saveRecoveredPassword('short')).ok, false);
  assert.equal(verified, 0);
  cookie = '';
  assert.equal((await actions.saveRecoveredPassword('NewPassword123!')).ok, false);
  assert.equal(updated, 0);
  cookie = 'a'.repeat(56);
  verifyFails = true;
  assert.equal((await actions.saveRecoveredPassword('NewPassword123!')).ok, false);
  assert.equal(updated, 0);
  assert.equal(sessionsSaved, 0);
  assert.equal(cookie, '');
  cookie = 'a'.repeat(56); verifyFails = false;
  assert.equal((await actions.saveRecoveredPassword('NewPassword123!')).ok, true);
  assert.equal(updated, 1); assert.equal(signedOut, 0); assert.equal(sessionsSaved, 1);
  assert.equal(suppliedPassword, 'NewPassword123!');
  assert.equal(cookie, '');
  assert.equal((await actions.saveRecoveredPassword('DifferentPass123!')).ok, false);
  assert.equal(updated, 1, 'Cookie removed after one use');
  cookie = 'a'.repeat(56); updateFails = true;
  assert.equal((await actions.saveRecoveredPassword('NewPassword123!')).ok, false);
  assert.equal(sessionsSaved, 1, 'No login before successful password update');
  assert.equal(signedOut, 1);
  cookie = 'a'.repeat(56); updateFails = false; loginFails = true;
  assert.equal((await actions.saveRecoveredPassword('NewPassword123!')).ok, false);
  assert.equal(cookie, '');
  const response = await route.GET(new Request('https://nova-academy.ir/auth/recovery?token_hash=' + 'a'.repeat(56)));
  assert.equal(response.status, 303);
  assert.equal(response.headers.get('Location'), 'https://nova-academy.ir/auth?mode=reset');
  assert.equal(await response.text(), '');
  const options = mutations.at(-1)[2];
  assert.equal(options.httpOnly, true); assert.equal(options.secure, true);
  assert.equal(options.path, '/auth'); assert.equal(options.maxAge, 600);
  assert.equal(options.sameSite, 'lax');
  const invalid = await route.GET(new Request('https://nova-academy.ir/auth/recovery?token_hash=bad'));
  assert.match(invalid.headers.get('Location'), /error=recovery/);
  assert.equal(mutations.at(-1)[2].maxAge, 0);
  console.log('Password recovery flow tests passed (mocked Auth; no email sent).');
})().catch(error => { console.error(error); process.exitCode = 1; });
