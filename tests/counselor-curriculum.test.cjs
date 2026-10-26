const assert = require("node:assert/strict");
const esbuild = require("esbuild");
const path = require("node:path");
const os = require("node:os");
const fs = require("node:fs");

const dir = fs.mkdtempSync(path.join(os.tmpdir(), "nova-curriculum-"));
try {
  const output = path.join(dir, "curriculum.cjs");
  esbuild.buildSync({
    entryPoints: ["lib/planning-curriculum.ts"],
    bundle: true,
    platform: "node",
    format: "cjs",
    outfile: output,
    alias: { "@": process.cwd() },
  });
  const c = require(output);

  assert.deepEqual(c.availableGrades(11), [10, 11]);
  assert.deepEqual(c.availableGrades(12), [10, 11, 12]);

  for (const grade of [10, 11, 12]) {
    for (const field of ["mathematics", "experimental_sciences", "humanities"]) {
      const books = c.curriculumBooks(field, grade, "final_exam");
      assert.ok(books.length >= 10, `${field}/${grade} final school subjects missing`);
      assert.equal(new Set(books.map((book) => book.subject)).size, books.length, "subjects must be unique");
      assert.equal(c.curriculumBooks(field, grade, "final_exam").length, books.length);
    }
    for (const field of ["arts", "foreign_languages"]) {
      assert.equal(c.curriculumBooks(field, grade, "final_exam").length, 0);
    }
  }

  const lab = "آزمایشگاه علوم تجربی";
  assert.ok(!c.curriculumBooks("mathematics", 11, "final_exam").some((book) => book.subject.includes(lab)));
  assert.ok(c.curriculumBooks("experimental_sciences", 11, "final_exam").some((book) => book.subject.includes(lab)));
  assert.ok(c.curriculumBooks("mathematics", 11, "final_exam").some((book) => book.subject === "زمین\u200cشناسی"));

  assert.equal(c.companionshipDuration("2026-10-10", "2026-10-13"), "۳ روز همراه نووا");
  assert.equal(c.companionshipDuration("2025-10-13", "2026-10-13"), "۱ سال همراه نووا");
  assert.equal(c.companionshipDuration("2026-09-13", "2026-10-13"), "۱ ماه همراه نووا");
  assert.equal(c.inferItemGrade({ subject: "زبان تخصصی" }, "foreign_languages", 12), null);

  const item = (id, subject, grade, track = "konkur") => ({
    id,
    subject,
    source_grade: grade,
    preparation_track: track,
    chapter: null,
  });
  const groups = c.journeyGroups(
    [item("a", "ریاضی ۱", 10), item("b", "ریاضی ۱", 10, "final_exam")],
    "experimental_sciences",
    11,
  );
  const riyaziGroups = groups.filter((group) => group.subject === "ریاضی ۱");
  assert.equal(riyaziGroups.length, 1);
  assert.equal(riyaziGroups[0].items.length, 2);
  assert.equal(
    groups.find((group) => group.subject === "ریاضی ۱" && group.track === "konkur").items.length,
    2,
  );

  console.log("PASS: multi-grade curriculum, field-specific school subjects, elapsed units, legacy grade inference, track separation");
} finally {
  fs.rmSync(dir, { recursive: true, force: true });
}
