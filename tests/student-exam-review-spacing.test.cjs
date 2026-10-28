const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const review = readFileSync('components/dashboard/student-exam-review.tsx', 'utf8');
const page = readFileSync('app/dashboard/student/exams/[id]/review/page.tsx', 'utf8');
const css = readFileSync('components/dashboard/student-exam-review.css', 'utf8');
const studentCss = readFileSync('app/student-panel.css', 'utf8');

assert.match(page, /className="portal-card exam-submitted"/);
assert.match(page, /<StudentExamReview questions=/);
assert.match(review, /className="exam-konkur-container student-exam-review"/);
assert.match(css, /\.student-portal-main\s*>\s*\.exam-submitted\s*\+\s*\.student-exam-review\s*\{\s*margin-block-start:\s*24px\s*\}/);
assert.match(page, /className="exam-result-summary"[\s\S]*?<div className="exam-review-report-action"><Link className="button secondary" href=\{`\/dashboard\/student\/exams\/\$\{id\}\/report`\}>مشاهده و چاپ کارنامه<\/Link><\/div>/);
assert.match(studentCss, /\.student-portal \.exam-review-report-action\{display:flex;justify-content:center;margin-block-start:24px\}/);
console.log('The submitted result has a 24px gap above its report button and another between the result and review panels.');
