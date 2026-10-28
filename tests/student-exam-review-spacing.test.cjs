const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const review = readFileSync('components/dashboard/student-exam-review.tsx', 'utf8');
const page = readFileSync('app/dashboard/student/exams/[id]/review/page.tsx', 'utf8');
const css = readFileSync('components/dashboard/student-exam-review.css', 'utf8');

assert.match(page, /className="portal-card exam-submitted"/);
assert.match(page, /<StudentExamReview questions=/);
assert.match(review, /className="exam-konkur-container student-exam-review"/);
assert.match(css, /\.student-portal-main\s*>\s*\.exam-submitted\s*\+\s*\.student-exam-review\s*\{\s*margin-block-start:\s*24px\s*\}/);
console.log('The submitted result and answer-review panel have a 24px gap.');
