const test = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const read = path => readFileSync(path, 'utf8');

test('student select-course links open the catalog, never the landing page', () => {
  const notice = read('components/dashboard/student-service-notice.tsx');
  const registration = read('app/dashboard/registration/page.tsx');
  const catalog = read('app/courses/page.tsx');
  assert.match(notice, /href=\{studentCourseCatalogPath\(grade, studyField\)\}>انتخاب دوره/);
  assert.match(registration, /href=\{studentCourseCatalogPath\(account\.values\.grade, account\.values\.study_field\)\}>انتخاب دوره/);
  assert.doesNotMatch(notice + registration, /href="\/#find-path">انتخاب دوره/);
  for (const path of ['app/dashboard/student/page.tsx', 'app/dashboard/student/account/page.tsx', 'app/dashboard/student/exams/page.tsx']) {
    const source = read(path);
    assert.match(source, /<StudentServiceNotice status=\{profile\.registration_status\} grade=\{profile\.grade\} studyField=\{profile\.study_field\}/);
  }
  assert.match(catalog, /if \(!context\) return \(/);
  assert.match(catalog, /<form className="course-context-picker" action="\/courses" method="get">/);
  assert.match(catalog, /<select name="grade" defaultValue="" required>/);
  assert.match(catalog, /<select name="field" defaultValue="" required>/);
  assert.match(catalog, /<CourseCards grade=\{context\.grade\} field=\{context\.field\} \/>/);
  assert.match(read('app/courses/[grade]/[field]/[plan]/[months]/page.tsx'), /const registrationHref = courseRegistrationPath\(selection\)/);
});
