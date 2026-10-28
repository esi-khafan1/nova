const assert = require('node:assert/strict');
const { readFileSync } = require('node:fs');
const page = readFileSync('app/dashboard/student/exams/page.tsx', 'utf8');
const overview = readFileSync('components/dashboard/student-exam-card.tsx', 'utf8');
assert.match(page, /\.order\("starts_at",\s*\{\s*ascending:\s*false\s*\}\)/,
  'The newest scheduled exam must be fetched first.');
assert.match(overview, /exams\.map\(exam\s*=>/,
  'The overview must preserve the server-provided order.');
console.log('Student exams are ordered newest first.');
