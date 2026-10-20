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
let fail = false;
const route = load('app/auth/confirm/route.ts', {
  'next/server': { NextResponse: { redirect: (url, init) => new Response(null, { ...init, headers: { ...init.headers, Location: url } }) } },
  '@/lib/auth-urls': urls,
  '@/lib/email-confirmation': security,
  '@/lib/supabase/server': { createClient: async () => ({ auth: { verifyOtp: async (input) => {
    calls++;
    assert.equal(input.type, 'signup');
    assert.equal(input.token_hash, 'a'.repeat(56));
    return { error: fail ? { message: 'expired' } : null };
  } } }) },
});
(async () => {
  const origin = urls.AUTH_SITE_ORIGIN;
  const token = 'a'.repeat(56);
  const page = await route.GET(new Request(`${origin}/auth/confirm?token_hash=${token}`));
  assert.equal(page.status, 200);
  assert.equal(calls, 0, 'GET scanners must not consume the token');
  assert.equal(page.headers.get('Referrer-Policy'), 'same-origin');
  assert.match(await page.text(), /method="post"/);
  assert.equal((await route.GET(new Request(`${origin}/auth/confirm`))).status, 303);
  const post = (requestOrigin = origin) => new Request(`${origin}/auth/confirm`, {
    method: 'POST', headers: { Origin: requestOrigin }, body: new URLSearchParams({ token_hash: token }),
  });
  assert.equal((await route.POST(post('https://evil.example'))).status, 403);
  assert.equal(calls, 0);
  const success = await route.POST(post());
  assert.equal(success.status, 303);
  assert.equal(success.headers.get('Location'), `${origin}/dashboard`);
  const nullOrigin = new Request(`${origin}/auth/confirm`, {
    method: 'POST', headers: { Origin: 'null', 'Sec-Fetch-Site': 'same-origin' },
    body: new URLSearchParams({ token_hash: token }),
  });
  assert.equal((await route.POST(nullOrigin)).headers.get('Location'), `${origin}/dashboard`);
  assert.equal((await route.POST(post('null'))).status, 403);
  const crossSite = new Request(`${origin}/auth/confirm`, {
    method: 'POST', headers: { Origin: 'null', 'Sec-Fetch-Site': 'cross-site' },
    body: new URLSearchParams({ token_hash: token }),
  });
  assert.equal((await route.POST(crossSite)).status, 403);
  fail = true;
  const expired = await route.POST(post());
  assert.match(expired.headers.get('Location'), /error=callback/);
  assert.equal(expired.headers.get('Location').includes(token), false);
  console.log('Email confirmation route tests passed (mocked Auth).');
})().catch(error => { console.error(error); process.exitCode = 1; });
