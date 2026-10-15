import assert from "node:assert/strict";
import { remapBookletKeys } from "../lib/exam-booklet-editing";
import { hasCompleteExamKeys } from "../lib/exam-key-validation";
import { examSaveErrorCode, examSaveErrorMessage } from "../lib/exam-save-errors";
const original = [
  { id: "math", questionCount: 3, keyAnswers: { "1": 1, "2": 2, "3": 3 } as Record<string,number>, pdfUrl: "https://example.invalid/math.pdf", durationMinutes: 30 },
  { id: "physics", questionCount: 2, keyAnswers: { "4": 4, "5": 1 } as Record<string,number>, pdfUrl: "https://example.invalid/physics.pdf", durationMinutes: 20 },
];
const snapshot = JSON.stringify(original);
const reduced = remapBookletKeys(original, [{ ...original[0], questionCount: 2 }, original[1]]);
assert.deepEqual(reduced.map(b => b.keyAnswers), [{ "1": 1, "2": 2 }, { "3": 4, "4": 1 }]);
assert.equal(hasCompleteExamKeys(reduced),true);
const expanded = remapBookletKeys(original, [{ ...original[0], questionCount: 4 }, original[1]]);
assert.deepEqual(expanded[1].keyAnswers,{ "5": 4, "6": 1 });
assert.equal(expanded[0].keyAnswers["4"],undefined);
assert.equal(hasCompleteExamKeys(expanded),false);
const removed = remapBookletKeys(original,[original[1]]);
assert.deepEqual(removed[0].keyAnswers,{ "1": 4, "2": 1 });
assert.equal(hasCompleteExamKeys(removed),true);
const reordered = remapBookletKeys(original,[original[1],original[0]]);
assert.deepEqual(reordered.map(b=>b.keyAnswers),[{ "1":4,"2":1 },{ "3":1,"4":2,"5":3 }]);
assert.equal(JSON.stringify(original),snapshot);
assert.equal(reduced[1].pdfUrl,original[1].pdfUrl);
assert.equal(reduced[1].durationMinutes,20);
const retitled = remapBookletKeys(original,original.map(b=>({...b,title:"عنوان سفارشی"})));
assert.deepEqual(retitled.map(b=>b.keyAnswers),original.map(b=>b.keyAnswers));
assert.equal(examSaveErrorCode({message:"Published exam requires a valid key for every question"}),"incomplete_key");
assert.equal(examSaveErrorCode({message:"Total exam duration exceeds maximum limit"}),"duration_total");
assert.equal(examSaveErrorCode({message:"Invalid exam metadata or schedule"}),"schedule");
assert.equal(examSaveErrorCode({message:"Only approved counselors can manage exams"}),"permission");
assert.equal(examSaveErrorCode({message:"Unknown private SQL detail"}),"save_failed");
for(const code of [undefined,"__proto__","toString","evil SQL"]) assert.equal(typeof examSaveErrorMessage(code),"string");
assert.ok(!examSaveErrorMessage("evil SQL").includes("evil SQL"));
console.log("Booklet-local key ownership survives count changes, removals and reordering; new questions remain unkeyed; safe save errors passed.");
