const test = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');

function load(path, deps, globals = {}) {
  const mod = { exports: {} };
  const compiled = ts.transpileModule(readFileSync(path, 'utf8'), {
    fileName: path, compilerOptions: { jsx: ts.JsxEmit.ReactJSX, module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 },
  }).outputText;
  vm.runInNewContext(compiled, {
    module: mod, exports: mod.exports, FormData, File, ...globals,
    require(name) { if (!(name in deps)) throw Error(`Unexpected import ${name} in ${path}`); return deps[name]; },
  }, { filename: path });
  return mod.exports;
}
const phoneAuth = load('lib/phone-auth.ts', {});
const registration = load('lib/registration.ts', {});
const confirmed = { phone: '+989121234567', phone_confirmed_at: '2026-10-30T00:00:00Z' };
const values = { full_name: 'نیما حسینی', telegram_id: 'nima_123', grade: 10,
  study_field: 'mathematics', province: 'تهران', city: 'تهران', additional_notes: '' };

test('only a confirmed auth phone becomes the registration 09 number', () => {
  assert.equal(phoneAuth.verifiedMobileForAccount(confirmed), '09121234567');
  assert.equal(phoneAuth.verifiedMobileForAccount({ ...confirmed, phone_confirmed_at: null }), null);
  assert.equal(phoneAuth.verifiedMobileForAccount({ ...confirmed, phone: 'not a mobile' }), null);
  assert.equal(phoneAuth.verifiedMobileForAccount({ email_confirmed_at: '2026-10-30', phone: '+989121234567' }), null);
});

function form(verifiedPhone, mode = 'profile') {
  const jsx = (type, props) => ({ type, props });
  const { RegistrationForm } = load('components/registration/registration-form.tsx', {
    react: { useActionState: () => [{}, () => {}, false], startTransition: () => {} },
    'react/jsx-runtime': { jsx, jsxs: jsx },
    './course-price': { CoursePrice: () => null },
    '@/app/dashboard/registration/actions': { submitRegistration: () => {} },
    '@/lib/courses': { courseTypeLabel: () => '', courseDurationLabel: () => '' },
    '@/lib/study-catalog': { studyFieldLabels: {} },
    '@/components/registration/province-city-fields': { ProvinceCityFields: () => null },
  });
  return RegistrationForm({ values: { ...values, phone: '09100000000' }, mode, verifiedPhone });
}
function descendants(node, found = []) {
  if (Array.isArray(node)) { for (const child of node) descendants(child, found); }
  else if (node && typeof node === 'object' && 'props' in node) {
    found.push(node); descendants(node.props.children, found);
  }
  return found;
}
test('both account and enrollment forms show verified number without an input; legacy accounts may enter one', () => {
  for (const mode of ['profile', 'enrollment']) {
    const verified = descendants(form('09121234567', mode));
    assert.ok(verified.some(node => node.props.className === 'registration-verified-phone'));
    assert.ok(verified.some(node => node.type === 'strong' && node.props.children === '09121234567'));
    assert.ok(!verified.some(node => node.type === 'input' && node.props.name === 'phone'));
    const legacy = descendants(form(null, mode));
    assert.ok(legacy.some(node => node.type === 'input' && node.props.name === 'phone' && !node.props.required));
  }
});

test('course-selection page passes the confirmed phone to the enrollment form before activation', async () => {
  const jsx = (type, props) => ({ type, props });
  const selection = { grade: 10, field: 'mathematics', course: 'base', months: 3 };
  const RegistrationForm = () => null;
  let accountPhone;
  const { default: Page } = load('app/dashboard/registration/page.tsx', {
    '@/lib/phone-auth': phoneAuth,
    'next/link': { default: () => null },
    'next/navigation': { redirect(path) { throw Error(`unexpected redirect: ${path}`); } },
    '@/components/dashboard/dashboard-shell': { DashboardShell: () => null },
    '@/lib/auth': { requireProfile: async () => ({ supabase: {}, profile: { registration_status: 'incomplete', full_name: values.full_name } }) },
    '@/lib/supabase/request-auth': { getRequestUser: async () => ({ user: confirmed }) },
    '@/lib/return-path': { safeReturnPath: path => path },
    '@/lib/courses': { parseCourseSelection: () => selection, courseRegistrationPath: () => '/dashboard/registration', studentCourseCatalogPath: () => '/courses' },
    '@/lib/load-student-account': { loadStudentAccount: async (_db, _profile, phone) => { accountPhone = phone; return { values, registration: null, error: false }; } },
    '@/components/registration/registration-form': { RegistrationForm },
    '@/app/registration.css': {},
    'react/jsx-runtime': { jsx, jsxs: jsx },
  });
  const page = await Page({ searchParams: Promise.resolve({ grade: '10', field: 'mathematics', course: 'base', months: '3' }) });
  assert.equal(accountPhone, '09121234567');
  assert.equal(descendants(page).find(node => node.type === RegistrationForm).props.verifiedPhone, '09121234567');
});

function actionContext(user, status = 'active') {
  const calls = [];
  const supabase = {
    rpc: async (name, args) => { calls.push({ name, args }); return { error: null }; },
    from: () => ({ select() { return this; }, eq() { return this; }, async maybeSingle() {
      return { data: { receipt_path: 'student-id/receipt.png', receipt_name: 'receipt.png', course_type: 'base' }, error: null };
    } }),
  };
  const { submitRegistration } = load('app/dashboard/registration/actions.ts', {
    '@/lib/phone-auth': phoneAuth,
    'next/cache': { revalidatePath() {} },
    'next/navigation': { redirect(path) { throw Error(`REDIRECT:${path}`); } },
    '@/lib/auth': { requireProfile: async () => ({ supabase, user, profile: { id: 'student-id', registration_status: status } }) },
    '@/lib/registration': registration,
    '@/lib/courses': { parseCourseSelection: () => ({ grade: 10, field: 'mathematics', course: 'base', months: 3 }) },
  });
  return { submitRegistration, calls };
}
function data(mode, phone) {
  const fd = new FormData();
  for (const [key, value] of Object.entries({ ...values, form_mode: mode, phone })) fd.set(key, String(value));
  return fd;
}
test('profile save uses verified auth number, ignoring forged form phone; legacy remains editable', async () => {
  const { submitRegistration, calls } = actionContext(confirmed);
  assert.ok((await submitRegistration({}, data('profile', '09100000000'))).success);
  assert.equal(calls[0].name, 'save_student_account_details');
  assert.equal(calls[0].args.payload.phone, '09121234567');
  const missing = actionContext(confirmed);
  assert.ok((await missing.submitRegistration({}, data('profile', ''))).success, 'No phone field is needed in the verified form');
  assert.equal(missing.calls[0].args.payload.phone, '09121234567');
  const legacy = actionContext({ email_confirmed_at: '2026-10-30T00:00:00Z' });
  assert.ok((await legacy.submitRegistration({}, data('profile', '09111111111'))).success);
  assert.equal(legacy.calls[0].args.payload.phone, '09111111111');
});
test('account save and course enrollment accept empty optional name and Telegram, but not missing grade or location', async () => {
  const sparse = data('profile', '');
  sparse.set('full_name', '');
  sparse.set('telegram_id', '');
  const legacy = actionContext({ email_confirmed_at: '2026-10-30T00:00:00Z' });
  assert.ok((await legacy.submitRegistration({}, sparse)).success);
  assert.equal(legacy.calls[0].args.payload.full_name, null);
  assert.equal(legacy.calls[0].args.payload.phone, null);
  assert.equal(legacy.calls[0].args.payload.telegram_id, null);
  const missingGrade = data('profile', '');
  missingGrade.set('grade', '');
  assert.match((await legacy.submitRegistration({}, missingGrade)).error, /پایه و رشته/);
  const missingCity = data('profile', '');
  missingCity.set('city', '');
  assert.match((await legacy.submitRegistration({}, missingCity)).error, /استان و شهر/);
  assert.equal(legacy.calls.length, 1, 'Invalid submissions must not call the account RPC.');
  sparse.set('form_mode', 'enrollment');
  const enrolling = actionContext(confirmed, 'incomplete');
  await assert.rejects(enrolling.submitRegistration({}, sparse), /REDIRECT:\/dashboard\/registration/);
  assert.equal(enrolling.calls[0].args.payload.telegram_id, null);
  assert.equal(enrolling.calls[0].args.payload.phone, '09121234567');
});

test('course enrollment also stores the confirmed auth phone, not a submitted value', async () => {
  const { submitRegistration, calls } = actionContext(confirmed, 'incomplete');
  await assert.rejects(submitRegistration({}, data('enrollment', '09100000000')), /REDIRECT:\/dashboard\/registration/);
  assert.equal(calls[0].name, 'submit_student_registration');
  assert.equal(calls[0].args.payload.phone, '09121234567');
});
