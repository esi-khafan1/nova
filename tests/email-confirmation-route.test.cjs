const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
function load(path, dependencies = {}) {
  const module = { exports: {} };
  const code = ts.transpileModule(fs.readFileSync(path, 'utf8'), {
    compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2020 },
  }).outputText;
  vm.runInNewContext(code, { module, exports: module.exports, URL, Response,
    require(name) { if (!(name in dependencies)) throw Error(`Unexpected dependency: ${name}`); return dependencies[name]; },
  });
  return module.exports;
}
const urls = load('lib/auth-urls.ts', { './return-path': load('lib/return-path.ts') });
const security = load('lib/email-confirmation.ts');
let calls = 0;
let outcome = 'success';
const token = 'a'.repeat(56);
const route = load('app/auth/confirm/route.ts', {
  'next/server': { NextResponse: { redirect: (url, init) => new Response(null, { ...init, headers: { ...init.headers, Location: url } }) } },
  '@/lib/auth-urls': urls,
  '@/lib/email-confirmation': security,
  '@/lib/supabase/confirmation': { verifySignupEmailResult: async (hash) => {
    calls++;
    assert.equal(hash, token);
    if (outcome === 'network') throw Error('Network unavailable');
    return {verified:outcome === 'success',next:'/dashboard'};
  } },
});
(async () => {
  const origin = urls.AUTH_SITE_ORIGIN;
  const request = () => new Request(`${origin}/auth/confirm?token_hash=${token}&next=https://evil.example`);
  for (const suffix of ['', '?token_hash=bad', '?token_hash=%22%3E%3Cscript%3E']) {
    const invalid = await route.GET(new Request(`${origin}/auth/confirm${suffix}`));
    assert.equal(invalid.status, 303);
    assert.match(invalid.headers.get('Location'), /error=callback/);
  }
  assert.equal(calls, 0);
  const success = await route.GET(request());
  assert.equal(success.status, 303);
  assert.equal(success.headers.get('Location'), `${origin}/auth?mode=signin&confirmed=1`);
  assert.equal(success.headers.get('set-cookie'), null);
  assert.equal(success.headers.get('Referrer-Policy'), 'no-referrer');
  assert.match(success.headers.get('Cache-Control'), /no-store/);
  assert.equal(await success.text(), '', 'No intermediate confirmation screen');
  for (const result of ['expired', 'network']) {
    outcome = result;
    const failure = await route.GET(request());
    assert.equal(failure.status, 303);
    assert.match(failure.headers.get('Location'), /error=callback/);
    assert.equal(failure.headers.get('Location').includes(token), false);
    assert.equal(new URL(failure.headers.get('Location')).origin, origin);
  }
  assert.equal(route.POST, undefined, 'No second confirmation button or POST step');
  console.log('One-click confirmation route tests passed (mocked verification).');
})().catch(error => { console.error(error); process.exitCode = 1; });
