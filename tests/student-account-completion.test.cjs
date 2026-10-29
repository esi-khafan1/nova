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
const link = { default: ({ href, children, ...props }) => React.createElement('a', { href, ...props }, children), __esModule: true };
const { StudentProfileCompletionNotice } = load('components/dashboard/student-profile-completion-notice.tsx', {
  'react/jsx-runtime': require('react/jsx-runtime'), 'next/link': link,
});
const complete = {
  full_name: 'نیما حسینی', phone: '09121234567', telegram_id: 'nima_123',
  grade: 10, study_field: 'mathematics', province: 'تهران', city: 'تهران',
};
function setup({ status = 'active', details = null, registrationRow = null, readError = false } = {}) {
  const profile = {
    id: 'student-id', full_name: complete.full_name, phone: complete.phone,
    grade: complete.grade, study_field: complete.study_field, registration_status: status,
  };
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
    '@/lib/auth': { requireProfile: async () => ({ supabase, profile, user: {} }) },
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
    '@/components/registration/registration-form': { RegistrationForm: ({ mode }) => React.createElement('form', { 'data-mode': mode }) },
    '@/app/registration.css': {},
  });
  return renderToStaticMarkup(await Page());
}

test('active student with incomplete legacy registration sees a direct account-form link, not enrollment', async () => {
  const incomplete = { ...complete, telegram_id: null };
  assert.notEqual(registration.validateRegistration(incomplete, true), null);
  const home = await dashboard({ registrationRow: incomplete });
  assert.match(home, /اطلاعات حسابت را تکمیل کن/);
  assert.match(home, /آیدی تلگرام معتبر/);
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

test('active student with no account or registration row is prompted, but a pending student is not', async () => {
  assert.match(await dashboard(), /اطلاعات حسابت را تکمیل کن/);
  assert.match(await account(), /اطلاعات حسابت را تکمیل کن/);
  assert.doesNotMatch(await dashboard({ status: 'pending' }), /اطلاعات حسابت را تکمیل کن/);
  assert.doesNotMatch(await account({ status: 'pending' }), /اطلاعات حسابت را تکمیل کن/);
});

test('temporary read errors are not presented as missing student details', async () => {
  assert.doesNotMatch(await dashboard({ readError: true }), /اطلاعات حسابت را تکمیل کن/);
  const edit = await account({ readError: true });
  assert.doesNotMatch(edit, /اطلاعات حسابت را تکمیل کن/);
  assert.match(edit, /اطلاعات فعلاً دریافت نشد/);
});
