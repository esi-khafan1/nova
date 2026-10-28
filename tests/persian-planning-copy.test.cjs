const test = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');

const paths = [
  'components/dashboard/student-planning-panel.tsx',
  'components/dashboard/exam-box-picker.tsx',
  'components/dashboard/weekly-plan-builder.tsx',
  'app/dashboard/counselor/plans/page.tsx',
  'lib/exam-save-errors.ts',
];
const files = Object.fromEntries(paths.map(path => [path, readFileSync(path, 'utf8')]));
const [student, picker, builder, counselor, errors] = Object.values(files);

test('student planning keeps the original Persian half-spaces in the welcome and empty states', () => {
  assert.match(student, /دانش‌آموز نووا/);
  assert.match(student, /مسیرت را روشن‌تر ببین/);
  assert.match(student, /به معنی انجام‌نشدن برنامه نیست/);
  assert.match(student, /برنامه‌های منتشرشده/);
  assert.match(student, /برنامه و گزارش روز انتخاب‌شده/);
  assert.match(student, /تست زنی، تعداد تست زده شده/);
});

test('exam box, counselor, and routine copy do not join Persian prefixes and suffixes', () => {
  assert.match(picker, /باکس‌های آزمون برنامه‌ریزی‌شده/);
  assert.match(picker, /روزانهٔ همان دانش‌آموز باز شود/);
  assert.match(builder, /دانش‌آموز از داخل برنامه وارد آزمون می‌شود/);
  assert.match(builder, /فقط همین یک روتین ثبت می‌شود/);
  assert.match(counselor, /رشتهٔ دانش‌آموز باشد/);
  assert.match(errors, /باکس‌های آزمون برنامه‌ریزی‌شدهٔ امروز/);
  for (const [path, text] of Object.entries(files)) {
    assert.doesNotMatch(text, /دانشآموز|انجامنشدن|روشنتر|برنامهریزی|باکسهای|فعالیتها|میشود|میشوند|نمیشود|تستزنی|زدهشده/, path);
  }
});
