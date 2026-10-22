const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const { NextRequest, NextResponse } = require('next/server');
const { unstable_doesMiddlewareMatch } = require('next/experimental/testing/server');
const moduleStub = { exports: {} };
let claims = { sub: 'account' }, authError = null, claimCalls = 0;
const code = ts.transpileModule(fs.readFileSync('middleware.ts', 'utf8'), { compilerOptions: { module: ts.ModuleKind.CommonJS } }).outputText;
vm.runInNewContext(code, {
  module: moduleStub, exports: moduleStub.exports, URL, Headers, performance,
  process: { env: { NEXT_PUBLIC_SUPABASE_URL: 'https://test.supabase.co', NEXT_PUBLIC_SUPABASE_ANON_KEY: 'test', AUTH_PERF_LOG: '1' } },
  require(name) {
    if (name === 'next/server') return { NextRequest, NextResponse };
    if (name === '@supabase/ssr') return { createServerClient: (_url, _key, options) => ({ auth: {
      getUser: () => { throw Error('Middleware must not repeat full getUser'); },
      getClaims: async () => {
        claimCalls++;
        options.cookies.setAll([{ name: 'sb-test-session', value: 'refreshed', options: { path: '/', httpOnly: true } }]);
        return { data: claims ? { claims } : null, error: authError };
      },
    } }) };
    throw Error(name);
  },
});
const { config, middleware } = moduleStub.exports;
const matches = path => unstable_doesMiddlewareMatch({ config, nextConfig: {}, url: `https://nova-academy.ir${path}` });
for (const path of ['/', '/about', '/faq', '/mag', '/mag/article', '/news', '/podcasts', '/courses', '/fonts/estedad-arabic-wght-normal.woff2', '/_next/static/app.js', '/api/imagekit-auth', '/auth/callback', '/auth/confirm', '/auth/recovery']) {
  assert.equal(matches(path), false, `Public/handler request unexpectedly matched: ${path}`);
}
for (const path of ['/dashboard', '/dashboard/student', '/dashboard/admin/users', '/dashboard/counselor', '/dashboard/exam_designer', '/dashboard/registration', '/auth', '/auth/sign-in', '/auth/sign-up']) {
  assert.equal(matches(path), true, `Protected/session route missing: ${path}`);
}
(async () => {
  const request = new NextRequest('https://nova-academy.ir/dashboard/student');
  const response = await middleware(request);
  assert.equal(response.status, 200);
  assert.equal(response.cookies.get('sb-test-session').value, 'refreshed');
  assert.equal(request.cookies.get('sb-test-session').value, 'refreshed');
  assert.match(response.headers.get('Server-Timing'), /auth_claims;dur=/);
  const measured=await middleware(new NextRequest('https://nova-academy.ir/dashboard/content_manager', {headers:{cookie:'nova-perf=1','x-nova-perf-start-ms':'forged','x-nova-perf-claims-ms':'forged'}}));
  assert.match(measured.headers.get('x-middleware-request-x-nova-perf-start-ms'),/^\d+$/);
  assert.match(measured.headers.get('x-middleware-request-x-nova-perf-claims-ms'),/^\d+$/);
  assert.match(measured.headers.get('x-middleware-request-cookie'),/sb-test-session=refreshed/);
  assert.equal(measured.cookies.get('sb-test-session').value,'refreshed');
  const stripped=await middleware(new NextRequest('https://nova-academy.ir/dashboard',{headers:{'x-nova-perf-start-ms':'forged'}}));
  assert.equal(stripped.headers.get('x-middleware-request-x-nova-perf-start-ms'),null);
  claims = null;
  const guest = await middleware(new NextRequest('https://nova-academy.ir/dashboard/student/plans?week=1'));
  assert.equal(guest.status, 307);
  const destination = new URL(guest.headers.get('location'));
  assert.equal(destination.pathname, '/auth');
  assert.equal(destination.searchParams.get('next'), '/dashboard/student/plans?week=1');
  assert.equal(guest.cookies.get('sb-test-session').value, 'refreshed');
  claims = { sub: 'forged' }; authError = { message: 'Invalid signature' };
  const invalid = await middleware(new NextRequest('https://nova-academy.ir/dashboard/student'));
  assert.equal(invalid.status, 307);
  assert.equal(claimCalls, 5);
  console.log('Middleware matcher, verified-claims, refresh cookies and guest redirect tests passed.');
})().catch(error => { console.error(error); process.exitCode = 1; });
