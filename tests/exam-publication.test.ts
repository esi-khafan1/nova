import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { examPublicationReadiness } from "../lib/exam-publication";
import { konkurBookletPresets } from "../lib/konkur-presets";
import { hasCompleteExamKeys } from "../lib/exam-key-validation";

for (const presets of Object.values(konkurBookletPresets)) {
  let start = 1;
  const booklets = presets.map(preset => {
    const keyAnswers = Object.fromEntries(Array.from({ length: preset.questionCount }, (_, i) => [String(start + i), 3]));
    start += preset.questionCount;
    return { ...preset, keyAnswers, pdfUrl: "https://example.invalid/questions.pdf" };
  });
  const ready = examPublicationReadiness(booklets, 1, true);
  assert.equal(ready.canPublish, true);
  assert.equal(ready.completedKeys, ready.totalQuestions);
  assert.equal(ready.allKeysComplete, hasCompleteExamKeys(booklets));
  assert.ok(ready.progress.every(item => item.missing.length === 0));
  assert.equal(examPublicationReadiness(booklets, 0, true).canPublish, false);
  assert.equal(examPublicationReadiness(booklets, 1, false).canPublish, false);
  for (const [i, booklet] of booklets.entries()) {
    const question = ready.progress[i].start + booklet.questionCount - 1;
    const copy = booklets.map(b => ({ ...b, keyAnswers: { ...b.keyAnswers } }));
    delete copy[i].keyAnswers[String(question)];
    const missing = examPublicationReadiness(copy, 1, true);
    assert.equal(missing.canPublish, false);
    assert.equal(missing.completedKeys, ready.totalQuestions - 1);
    assert.deepEqual(missing.progress[i].missing, [question]);
    // Stray keys cannot hide a missing actual question.
    copy[i].keyAnswers["999"] = 3;
    assert.deepEqual(examPublicationReadiness(copy, 1, true).progress[i].missing, [question]);
    copy[i].keyAnswers[String(question)] = 2;
    assert.equal(examPublicationReadiness(copy, 1, true).canPublish, true);
    copy[i].pdfUrl = "";
    assert.equal(examPublicationReadiness(copy, 1, true).canPublish, false);
    assert.equal(examPublicationReadiness(copy, 1, true).progress[i].hasPdf, false);
  }
}
const custom = { title: "ریاضی", questionCount: 2, durationMinutes: 30, pdfUrl: "https://example.invalid/math.pdf", keyAnswers: { 1: 1, 2: 4 } };
assert.equal(examPublicationReadiness([custom], 1, true).canPublish, true);
assert.equal(examPublicationReadiness([{ ...custom, durationMinutes: 0 }], 1, true).canPublish, false);
assert.equal(examPublicationReadiness([{ ...custom, durationMinutes: 601 }], 1, true).canPublish, false);
assert.equal(examPublicationReadiness([], 1, true).canPublish, false);
assert.equal(examPublicationReadiness([{ ...custom, questionCount: 201 }], 1, true).canPublish, false);
assert.equal(examPublicationReadiness([{ ...custom, pdfUrl: "http://example.invalid" }], 1, true).canPublish, false);
assert.deepEqual(examPublicationReadiness([{ ...custom, keyAnswers: { 1: 1, 2: "4" } as unknown as Record<string, number> }], 1, true).progress[0].missing, [2]);
const builder = readFileSync("components/dashboard/exam-builder.tsx", "utf8");
assert.ok(builder.includes("onSubmit={checkPublication}"));
assert.ok(builder.includes('event.preventDefault()'));
assert.ok(builder.includes('focusMissingKey(item.index, item.missing[0])'));
assert.ok(builder.includes('accordion.open = true'));
assert.ok(builder.includes('aria-pressed={selected === opt}'));
const action = readFileSync("app/dashboard/exams/actions.ts", "utf8");
assert.ok(action.includes('status === "published" && !hasCompleteExamKeys(booklets)'));
assert.ok(action.includes('status === "published" && studentIds.length === 0'));
console.log("Publication readiness: all 5 complete templates publishable; exact global key gaps, PDFs, students, invalid timing/duration and server guards verified.");
