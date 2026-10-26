const assert = require("node:assert/strict");
const esbuild = require("esbuild");
const path = require("node:path");
const os = require("node:os");
const fs = require("node:fs");

const dir = fs.mkdtempSync(path.join(os.tmpdir(), "nova-routine-subjects-"));
try {
  const curriculumOutput = path.join(dir, "curriculum.cjs");
  const schoolOutput = path.join(dir, "school.cjs");
  esbuild.buildSync({
    entryPoints: ["lib/planning-curriculum.ts"],
    bundle: true,
    platform: "node",
    format: "cjs",
    outfile: curriculumOutput,
    alias: { "@": process.cwd() },
  });
  esbuild.buildSync({
    entryPoints: ["lib/school-catalog.ts"],
    bundle: true,
    platform: "node",
    format: "cjs",
    outfile: schoolOutput,
    alias: { "@": process.cwd() },
  });
  const curriculum = require(curriculumOutput);
  const school = require(schoolOutput);

  const lab = "آزمایشگاه علوم تجربی";
  const geology = "زمین\u200cشناسی";
  const math11 = curriculum.routineSubjectOptions("mathematics", 11);
  const experimental11 = curriculum.routineSubjectOptions("experimental_sciences", 11);
  const humanities11 = curriculum.routineSubjectOptions("humanities", 11);
  const all11 = curriculum.routineSubjectOptions(null, 11);
  const math10 = curriculum.routineSubjectOptions("mathematics", 10);

  assert.ok(!math11.some((subject) => subject.includes(lab)), "math must not offer the lab");
  assert.ok(!humanities11.some((subject) => subject.includes(lab)), "humanities must not offer the lab");
  assert.ok(experimental11.some((subject) => subject.includes(lab)), "experimental sciences must offer the lab");
  assert.ok(math11.includes(geology), "mathematics keeps its grade-11 geology school subject");
  assert.ok(experimental11.includes(geology), "experimental sciences keeps geology");
  assert.ok(all11.some((subject) => subject.includes(lab)), "no-field shows lab from its own field");
  assert.ok(all11.includes(geology), "no-field shows geology");
  assert.ok(all11.includes("زبان تخصصی"), "no-field includes foreign-language subjects");
  assert.ok(all11.length > math11.length && all11.length > experimental11.length, "no-field is a superset");
  assert.deepEqual(curriculum.routineSubjectOptions("legacy-invalid-field", 11), all11, "invalid field falls back to all");
  assert.ok(!math10.includes("حسابان ۱"), "grade 10 does not offer grade-11 calculus");
  assert.ok(math10.includes("ریاضی ۱"), "grade 10 offers its own specialist subjects");

  for (const options of [math11, experimental11, humanities11, all11, math10]) {
    assert.equal(new Set(options).size, options.length, "routine subject options must be unique");
  }

  assert.ok(!school.schoolBooks("mathematics", 11).some((book) => book.subject.includes(lab)));
  assert.ok(school.schoolBooks("experimental_sciences", 11).some((book) => book.subject.includes(lab)));
  assert.ok(school.schoolBooks("experimental_sciences", 10).some((book) => book.subject.includes(lab)));
  assert.ok(!school.schoolBooks("mathematics", 10).some((book) => book.subject.includes(lab)));
  assert.ok(school.schoolBooks("mathematics", 11).some((book) => book.subject === geology));

  console.log("PASS: routine subjects are field-specific, lab stays with experimental sciences, no-field shows all");
} finally {
  fs.rmSync(dir, { recursive: true, force: true });
}
