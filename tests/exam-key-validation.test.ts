import test from "node:test";
import assert from "node:assert/strict";
import { hasCompleteExamKeys, countBookletKeys } from "../lib/exam-key-validation";
test("published keys cover each actual global question, not just object length", () => {
  assert.equal(hasCompleteExamKeys([{questionCount:2,keyAnswers:{1:2,2:3}},{questionCount:2,keyAnswers:{3:1,4:4}}]),true);
  assert.equal(hasCompleteExamKeys([{questionCount:2,keyAnswers:{1:2,2:3}},{questionCount:2,keyAnswers:{1:1,2:4}}]),false);
  assert.equal(hasCompleteExamKeys([{questionCount:2,keyAnswers:{1:2,99:3}}]),false);
  assert.equal(hasCompleteExamKeys([{questionCount:2,keyAnswers:{1:2}}]),false);
  assert.equal(hasCompleteExamKeys([]),false);
});
test("reject invalid choices and shapes", () => {
  for(const value of [0,5,1.5,"2",null,true,{},[]]) assert.equal(hasCompleteExamKeys([{questionCount:1,keyAnswers:{1:value}}]),false);
  for(const keys of [null,[],"key",1]) assert.equal(countBookletKeys(keys,1,2),0);
  assert.equal(countBookletKeys({3:1,4:2,99:2},3,2),2);
});
