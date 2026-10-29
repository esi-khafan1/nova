// Mock-browser DOM integration: intercepted Auth transport, no real SMS or accounts.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const { JSDOM, VirtualConsole } = require('jsdom');
const React = require('react');
const { act } = React;

function load(file, dependencies = {}) {
  const moduleStub = { exports: {} };
  vm.runInNewContext(ts.transpileModule(fs.readFileSync(file, 'utf8'), {
    fileName: file,
    compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022, jsx: ts.JsxEmit.ReactJSX, esModuleInterop: true },
  }).outputText, {
    module: moduleStub, exports: moduleStub.exports,
    require(name) {
      if (name in dependencies) return dependencies[name];
      throw Error(`Unexpected import: ${name}`);
    },
    window: global.window, document: global.document, FormData: global.FormData,
    fetch: global.fetch, AbortSignal, URL, Date, console,
  });
  return moduleStub.exports;
}

const virtualConsole = new VirtualConsole();
// jsdom cannot navigate to /dashboard after a successful mocked OTP.
virtualConsole.on('jsdomError', error => { if (!error.message.includes('navigation')) throw error; });
const dom = new JSDOM('<!doctype html><html><body><div id="root"></div></body></html>', {
  url: 'https://nova.test/auth?mode=signup', pretendToBeVisual: true, virtualConsole,
});
global.window = dom.window;
global.document = dom.window.document;
global.navigator = dom.window.navigator;
global.HTMLElement = dom.window.HTMLElement;
global.FormData = dom.window.FormData;
global.IS_REACT_ACT_ENVIRONMENT = true;
const { createRoot } = require('react-dom/client');

const phoneAuth = load('lib/phone-auth.ts');
const passwords = load('lib/password-input.ts');
const requests = [];
global.fetch = async (url, options) => {
  assert.equal(url, '/api/auth/phone');
  const request = JSON.parse(options.body);
  requests.push(request);
  const ok = request.action !== 'signin' && !(request.action === 'verify' && request.token === '000000');
  return { ok, json: async () => ({ ok, message: ok ? 'ok' : 'کد صحیح نیست یا منقضی شده است.' }) };
};
const Link = ({ href, children }) => React.createElement('a', { href }, children);
const { UnifiedAuth } = load('components/auth/unified-auth.tsx', {
  react: React,
  'react/jsx-runtime': require('react/jsx-runtime'),
  'next/navigation': { useRouter: () => ({ replace() {}, refresh() {} }) },
  'next/link': Link,
  '@/components/landing-header': { LandingHeader: () => null },
  '@/lib/return-path': { safeReturnPath: value => value || '/dashboard' },
  '@/lib/password-input': passwords,
  '@/app/auth/recovery/actions': { saveRecoveredPassword: async () => ({ ok: false, message: 'mock' }) },
  '@/lib/phone-auth': phoneAuth,
});
const root = createRoot(document.getElementById('root'));
const input = id => document.getElementById(id);
function setNativeValue(element, value) {
  Object.getOwnPropertyDescriptor(dom.window.HTMLInputElement.prototype, 'value').set.call(element, value);
  element.dispatchEvent(new dom.window.Event('input', { bubbles: true }));
}
const fill = async (element, value) => { await act(async () => { setNativeValue(element, value); }); };
const submit = async () => { await act(async () => { document.querySelector('form').dispatchEvent(new dom.window.Event('submit', { bubbles: true, cancelable: true })); }); };

(async () => {
  await act(async () => root.render(React.createElement(UnifiedAuth, { initialMode: 'signup', phoneSignup: true, returnTo: '/dashboard' })));
  assert.ok(!document.querySelector('.nova-auth-form-panel').textContent.includes('ایمیل'));
  await fill(input('signup-name'), 'Test Student');
  await fill(input('signup-email'), '۰۹۱۲۰۰۰۰۰۰۰');
  assert.equal(input('signup-email').value, '', 'Non-ASCII digits must not replace the phone value.');
  assert.match(document.body.textContent, /شماره تلفن همراه را با اعداد انگلیسی وارد کن/);
  await fill(input('signup-email'), '09120000000');
  await fill(input('signup-password'), 'Pass۱۲۳456');
  assert.equal(input('signup-password').value, '', 'Non-English password input must be refused.');
  await fill(input('signup-password'), 'TestPass123!');
  assert.equal(input('signup-password').value, 'TestPass123!');
  await submit();
  assert.equal(requests.length, 1);
  assert.equal(requests[0].action, 'signup');
  assert.equal(requests[0].password, 'TestPass123!');
  assert.equal(input('signup-email').value, '09120000000');
  assert.equal(input('signup-password').value, 'TestPass123!');
  assert.equal(input('signup-email').readOnly, true);

  await fill(input('signup-code'), '000000');
  await submit();
  assert.equal(requests.at(-1).action, 'verify');
  assert.equal(requests.at(-1).password, 'TestPass123!');
  assert.equal(input('signup-email').value, '09120000000', 'Rejected OTP must not erase the phone.');
  assert.equal(input('signup-password').value, 'TestPass123!', 'Rejected OTP must not erase the password.');
  assert.equal(input('signup-code').value, '000000', 'Rejected OTP must remain editable.');

  await fill(input('signup-code'), '123456');
  await submit();
  assert.equal(requests.at(-1).action, 'verify');
  assert.equal(input('signup-email').value, '09120000000', 'Successful OTP should keep the number until navigation.');
  assert.equal(input('signup-password').value, 'TestPass123!', 'Successful OTP should not clear the password before navigation.');

  await act(async () => root.unmount());
  const signinRoot = createRoot(document.getElementById('root'));
  await act(async () => signinRoot.render(React.createElement(UnifiedAuth, { initialMode: 'signin', phoneSignup: true })));
  await fill(input('signin-email'), '۰۹۱۲۰۰۰۰۰۰۰');
  assert.equal(input('signin-email').value, '');
  await fill(input('signin-email'), '09120000000');
  await fill(input('signin-password'), 'رمزعبور');
  assert.equal(input('signin-password').value, '');
  await fill(input('signin-password'), 'TestPass123!');
  const beforeSignin = requests.length;
  await submit();
  assert.equal(requests.length, beforeSignin + 1);
  assert.equal(requests.at(-1).action, 'signin');
  assert.equal(requests.at(-1).phone, '09120000000');
  assert.equal(input('signin-email').value, '09120000000');
  assert.equal(input('signin-password').value, 'TestPass123!');
  await fill(input('signin-email'), 'legacy@example.com');
  await submit();
  assert.equal(requests.at(-1).email, 'legacy@example.com', 'Keep quiet legacy email/password signin.');
  assert.equal(requests.at(-1).phone, undefined);
  await act(async () => signinRoot.unmount());
  dom.window.close();
  console.log('Mock DOM auth: English-only phone/password on signup and signin, OTP retry/success retains credentials, legacy email login works; no SMS sent.');
})().catch(error => { console.error(error); process.exitCode = 1; dom.window.close(); });
