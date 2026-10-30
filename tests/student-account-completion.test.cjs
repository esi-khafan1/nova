const test = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const vm = require('node:vm');
const ts = require('typescript');
const React = require('react');
const { renderToStaticMarkup } = require('react-dom/server');

function load(path, deps) {
  const compiled = ts.transpileModule(readFileSync(path, 'utf8'), {
    fileName: path,
    compilerOptions: { jsx: ts.JsxEmit.ReactJSX, module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 },
  }).outputText;
  const mod = { exports: {} };
  vm.runInNewContext(compiled, {
    module: mod, exports: mod.exports, process,
    require(name) {
      if (!(name in deps)) throw Error(`Unexpected import ${name} in ${path}`);
      return deps[name];
    },
  }, { filename: path });
  return mod.exports;
}
const registration = load('lib/registration.ts', {});
const accountLoader = load('lib/load-student-account.ts', {});
const phoneAuth = load('lib/phone-auth.ts', {});
const link = { default: ({ href, children, ...props }) => React.createElement('a', { href, ...props }, children), __esModule: true };
const { StudentProfileCompletionNotice } = load('components/dashboard/student-profile-completion-notice.tsx', {
  'react/jsx-runtime': require('react/jsx-runtime'), 'next/link': link,
});
const complete = {
  full_name: 'نیما حسینی', phone: '09121234567', telegram_id: 'nima_123',
  grade: 10, study_field: 'mathematics', province: 'تهران', city: 'تهران',
};
function setup({ status = 'active', details = null, registrationRow = null, readError = false, authPhone = null, profilePhone = complete.phone, profileGrade = complete.grade, profileName = complete.full_name } = {}) {
  const profile = {
    id: 'student-id', full_name: profileName, phone: profilePhone,
    grade: profileGrade, study_field: complete.study_field, registration_status: status,
  };
  const user = authPhone ? { phone: authPhone, phone_confirmed_at: '2026-10-30T00:00:00Z' } : {};
  const supabase = { from(table) {
    assert.ok(['student_account_details', 'student_registrations'].includes(table));
    return { select() { return this; }, eq() { return this; }, async maybeSingle() {
      return { data: table === 'student_account_details' ? details : registrationRow, error: readError ? new Error('temporary read failure') : null };
    } };
  } };
  const deps = {
    'react/jsx-runtime': require('react/jsx-runtime'),
    '@/components/dashboard/dashboard-shell': { DashboardShell: ({ children }) => React.createElement('main', null, children) },
    '@/components/dashboard/student-service-notice': { StudentServiceNotice: () => null },
    '@/components/dashboard/student-profile-completion-notice': { StudentProfileCompletionNotice },
    '@/lib/auth': { requireProfile: async () => ({ supabase, profile, user }) },
    '@/lib/phone-auth': phoneAuth,
    '@/lib/load-student-account': { loadStudentAccount: accountLoader.loadStudentAccount },
    '@/lib/registration': registration,
  };
  return { profile, supabase, deps };
}
async function dashboard(options) {
  const { deps } = setup(options);
  const { default: Page } = load('app/dashboard/student/page.tsx', {
    ...deps,
    '@/components/dashboard/student-planning-panel': { StudentPlanningPanel: () => React.createElement('div', null, 'برنامه') },
    '@/components/dashboard/student-dashboard-refresh': { StudentDashboardRefresh: () => null },
    '@/lib/load-student-dashboard': { loadStudentDashboard: async () => ({ failed: false, studentId: 'student-id', active: true, plans: [], completions: [] }) },
    '@/lib/student-planning': { tehranToday: () => '2026-10-30' },
  });
  return renderToStaticMarkup(await Page());
}
async function account(options) {
  const { deps } = setup(options);
  const { default: Page } = load('app/dashboard/student/account/page.tsx', {
    ...deps,
    '@/components/dashboard/phone-link': { PhoneLink: () => null },
    '@/components/dashboard/delete-account': { DeleteAccount: () => null },
    '@/components/registration/registration-form': { RegistrationForm: ({ mode, verifiedPhone }) => React.createElement('form', { 'data-mode': mode, 'data-verified-phone': verifiedPhone }) },
    '@/app/registration.css': {},
  });
  return renderToStaticMarkup(await Page());
}

test('active student with incomplete legacy registration sees a direct account-form link, not enrollment', async () => {
  const incomplete = { ...complete, city: null };
  assert.notEqual(registration.validateRegistration(incomplete, true), null);
  const home = await dashboard({ registrationRow: incomplete });
  assert.match(home, /اطلاعات حسابت را تکمیل کن/);
  assert.match(home, /استان و شهر محل سکونت/);
  assert.match(home, /href="\/dashboard\/student\/account#student-account-details"/);
  assert.doesNotMatch(home, /href="\/dashboard\/registration"/);
  const edit = await account({ registrationRow: incomplete });
  assert.match(edit, /href="#student-account-details"/);
  assert.match(edit, /id="student-account-details"/);
  assert.match(edit, /data-mode="profile"/);
});

test('complete account details take priority over older incomplete registration and hide the notice', async () => {
  assert.equal(registration.validateRegistration(complete, true), null);
  const options = { details: complete, registrationRow: { ...complete, city: null } };
  assert.doesNotMatch(await dashboard(options), /اطلاعات حسابت را تکمیل کن/);
  assert.doesNotMatch(await account(options), /اطلاعات حسابت را تکمیل کن/);
});

test('optional legacy contact fields alone never trigger the completion reminder', async () => {
  const options = { details: { ...complete, phone: null, telegram_id: 'bad' }, profilePhone: null };
  assert.notEqual(registration.validateRegistration(options.details, true), null, 'Optional values are checked if submitted.');
  assert.equal(registration.requiredStudentFieldsIssue(options.details, true), null);
  assert.doesNotMatch(await dashboard(options), /اطلاعات حسابت را تکمیل کن/);
  assert.doesNotMatch(await account(options), /اطلاعات حسابت را تکمیل کن/);
});

test('missing or incomplete signup name prompts active students to complete their name', async () => {
  for (const name of ['', 'نیما']) {
    const options = { profileName: name, details: { ...complete, full_name: null } };
    assert.match(await dashboard(options), /نام و نام خانوادگی را کامل وارد کن/);
    assert.match(await account(options), /نام و نام خانوادگی را کامل وارد کن/);
  }
});

test('active student with no account or registration row is prompted, but a pending student is not', async () => {
  assert.match(await dashboard(), /اطلاعات حسابت را تکمیل کن/);
  assert.match(await account(), /اطلاعات حسابت را تکمیل کن/);
  assert.doesNotMatch(await dashboard({ status: 'pending' }), /اطلاعات حسابت را تکمیل کن/);
  assert.doesNotMatch(await account({ status: 'pending' }), /اطلاعات حسابت را تکمیل کن/);
});

test('verified signup phone satisfies completion even when no stored phone exists', async () => {
  const options = { authPhone: '+989121234567', profilePhone: null, details: { ...complete, phone: null } };
  assert.doesNotMatch(await dashboard(options), /شمارهٔ همراه را/);
  assert.doesNotMatch(await dashboard(options), /اطلاعات حسابت را تکمیل کن/);
  assert.doesNotMatch(await account(options), /اطلاعات حسابت را تکمیل کن/);
  assert.match(await account(options), /data-verified-phone="09121234567"/);
  assert.match(await account({ ...options, status: 'pending' }), /data-verified-phone="09121234567"/);
  assert.doesNotMatch(await dashboard({ ...options, authPhone: null }), /اطلاعات حسابت را تکمیل کن/);
  assert.match(await dashboard({ ...options, profileGrade: null, details: { ...complete, grade: null } }), /پایه و رشته را انتخاب کن/);
});

test('temporary read errors are not presented as missing student details', async () => {
  assert.doesNotMatch(await dashboard({ readError: true }), /اطلاعات حسابت را تکمیل کن/);
  const edit = await account({ readError: true });
  assert.doesNotMatch(edit, /اطلاعات حسابت را تکمیل کن/);
  assert.match(edit, /اطلاعات فعلاً دریافت نشد/);
});
