const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const moduleStub = { exports: {} };
let error = null, failNetwork = false;
const logs = [];
const code = ts.transpileModule(fs.readFileSync('lib/supabase/confirmation.ts', 'utf8'), { compilerOptions: { module: ts.ModuleKind.CommonJS } }).outputText;
vm.runInNewContext(code, {
  module: moduleStub, exports: moduleStub.exports,
  process: { env: { NEXT_PUBLIC_SUPABASE_URL: 'https://test.supabase.co', NEXT_PUBLIC_SUPABASE_ANON_KEY: 'test-key' } },
  console: { warn: value => logs.push(value) },
  require(name) {
    assert.equal(name, '@supabase/supabase-js');
    return { createClient: (_url, _key, options) => {
      assert.equal(options.auth.persistSession, false);
      return { auth: { verifyOtp: async input => {
        assert.equal(input.type, 'signup');
        if (failNetwork) throw Error('private-upstream-url');
        return { error };
      } } };
    } };
  },
});
(async () => {
  const verify = moduleStub.exports.verifySignupEmail;
  assert.equal(await verify('private-token'), 'confirmed');
  error = { code: 'otp_expired', status: 403, message: 'private-token' };
  assert.equal(await verify('private-token'), 'expired');
  error = { code: 'over_request_rate_limit', status: 429 };
  assert.equal(await verify('private-token'), 'rate_limit');
  error = { code: 'unexpected_failure', status: 500 };
  assert.equal(await verify('private-token'), 'unavailable');
  failNetwork = true;
  assert.equal(await verify('private-token'), 'unavailable');
  assert.equal(logs.join('').includes('private-token'), false);
  assert.equal(logs.join('').includes('private-upstream-url'), false);
  console.log('Signup confirmation error classification and sanitized logging tests passed.');
})().catch(error => { console.error(error); process.exitCode = 1; });
