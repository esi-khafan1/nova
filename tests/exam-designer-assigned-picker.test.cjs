const test = require('node:test');
const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const read = path => readFileSync(path, 'utf8');

test('designer picker searches the guarded, paginated student directory', () => {
 const picker = read('components/dashboard/exam-student-picker.tsx');
 const action = read('app/dashboard/exam_designer/actions.ts');
 const edit = read('app/dashboard/exam_designer/[id]/page.tsx');
 assert.match(action, /requireProfile\(\["exam_designer"\]\)/);
 assert.match(action, /supabase\.rpc\("search_exam_students"/);
 assert.match(picker, /searchExamStudents\(query,offset\)/);
 assert.match(picker, /setQuery\(e\.target\.value\);setOffset\(0\)/);
 assert.match(picker, /فقط دانش‌آموزانی که مشاور به آن‌ها تخصیص داده شده/);
 assert.match(edit, /payload\.students\?\?\[\]/);
 assert.match(edit, /payload\.excluded_student_count/);
});
