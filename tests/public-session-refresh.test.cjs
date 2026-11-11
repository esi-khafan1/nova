// Real Supabase SSR SDK, fake tokens and local mocked Auth only; no live accounts.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const { NextRequest, NextResponse } = require('next/server');
const { createServerClient } = require('@supabase/ssr');
const encode = value => Buffer.from(JSON.stringify(value)).toString('base64url');
const id = '12345678-1234-1234-1234-123456789abc';
const user = { id, aud: 'authenticated', role: 'authenticated' };
const jwt = exp => `${encode({alg:'HS256',typ:'JWT'})}.${encode({sub:id,role:'authenticated',aud:'authenticated',exp})}.signature`;
const now = Math.floor(Date.now()/1000);
const old = {access_token:jwt(now-300), refresh_token:'old-refresh', token_type:'bearer', expires_in:3600, expires_at:now-300, user};
const fresh = {access_token:jwt(now+3600), refresh_token:'rotated-refresh', token_type:'bearer', expires_in:3600, expires_at:now+3600, user};
let refreshes = 0;
const fetchMock = async (input) => {
  const url = new URL(String(input));
  if (url.pathname === '/auth/v1/token' && url.searchParams.get('grant_type') === 'refresh_token') {
    refreshes++;
    return Response.json(fresh);
  }
  if (url.pathname === '/auth/v1/user') return Response.json(user);
  throw Error(`Unexpected network request ${url.pathname}`);
};
const code = ts.transpileModule(fs.readFileSync('middleware.ts', 'utf8'), {compilerOptions:{module:ts.ModuleKind.CommonJS}}).outputText;
const stub = {exports:{}};
vm.runInNewContext(code, {
  module:stub, exports:stub.exports, URL, performance,
  process:{env:{NEXT_PUBLIC_SUPABASE_URL:'https://test.supabase.co', NEXT_PUBLIC_SUPABASE_ANON_KEY:'fake'}},
  require(name) {
    if (name === 'next/server') return {NextRequest, NextResponse};
    if (name === '@supabase/ssr') return {createServerClient:(url,key,options) => createServerClient(url,key,{...options,global:{fetch:fetchMock}})};
    throw Error(name);
  },
});
(async () => {
  const req = new NextRequest('https://nova.example/', {headers:{cookie:`sb-test-auth-token=base64-${encode(old)}`}});
  const res = await stub.exports.middleware(req);
  assert.equal(res.status, 200);
  assert.equal(refreshes, 1);
  const updated = req.cookies.get('sb-test-auth-token');
  assert.ok(updated, 'refreshed cookie reaches Server Components');
  assert.notEqual(updated.value, `base64-${encode(old)}`);
  assert.equal(res.cookies.get('sb-test-auth-token').value, updated.value, 'browser receives rotated cookie');
  // Simulate the following server render using the updated request cookies.
  const renderClient = createServerClient('https://test.supabase.co','fake',{cookies:{getAll:()=>req.cookies.getAll(),setAll:()=>{throw Error('unexpected refresh during render');}},global:{fetch:fetchMock}});
  const result = await renderClient.auth.getUser();
  assert.equal(result.data.user.id,id);
  assert.equal(refreshes,1,'render must not refresh again');
  console.log('Expired public-page session is refreshed and propagated to browser and render.');
})().catch(error => {console.error(error);process.exitCode=1;});
