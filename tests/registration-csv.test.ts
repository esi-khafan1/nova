import assert from "node:assert/strict";
import { readFileSync, writeFileSync } from "node:fs";
import { buildRegistrationCsv, registrationCsvHeaders, registrationCsvValues } from "../lib/registration-csv";
import { prioritizePendingUnassignedReceipts, type RegistrationRow } from "../lib/registration";
import { loadRegistrationDirectory } from "../lib/load-registration-directory";

const base: RegistrationRow = {
  student_id: "00000000-0000-0000-0000-000000000001", full_name: "دانش آموز آزمایشی",
  phone: "09121234567", telegram_id: "student_test", grade: 12,
  study_field: "mathematics", province: "تهران", city: "تهران",
  registration_status: "pending", counselor_name: null, receipt_path: "private/receipt.jpg",
  receipt_name: "فیش.jpg", created_at: "2026-10-15T00:00:00Z",
};
const notes = 'خط اول، با ویرگول, و "نقل قول"\nخط دوم\r\nخط سوم';
const complete = { ...base, course_type: "with_exam", course_duration_months: 12, additional_notes: notes };
assert.equal(registrationCsvHeaders.length, 14);
assert.deepEqual(registrationCsvHeaders.slice(11), ["نوع دوره", "مدت دوره (ماه)", "توضیحات تکمیلی"]);
assert.deepEqual(registrationCsvValues(complete).slice(11), ["مشاوره با آزمون", 12, notes]);
assert.deepEqual(registrationCsvValues(base).slice(11), ["", "", ""]);
for (const [type, label] of [["with_exam", "مشاوره با آزمون"], ["with_support", "مشاوره با پشتیبان"], ["simple_consultant", "مشاوره ساده"]]) {
  for (const months of [3, 6, 12]) {
    assert.deepEqual(registrationCsvValues({ ...base, course_type: type, course_duration_months: months }).slice(11), [label, months, ""]);
  }
}
assert.equal(registrationCsvValues({ ...base, receipt_path: null })[10], "");
assert.ok(String(registrationCsvValues(base)[10]).endsWith(`/api/registrations/${base.student_id}/receipt`));
const csv = buildRegistrationCsv([complete, base]);
assert.ok(csv.startsWith("\uFEFF"));
assert.ok(!csv.includes("private/receipt.jpg"));
assert.ok(csv.includes('"خط اول، با ویرگول, و ""نقل قول""\nخط دوم\r\nخط سوم"'));
for (const malicious of ["=1+1", "+1+1", "@SUM(A1)", "-1+1", " \t=HYPERLINK(\"bad\")"]) {
  assert.ok(buildRegistrationCsv([{ ...base, additional_notes: malicious }]).includes(`"'${malicious.replaceAll('"', '""')}"`));
}
assert.ok(buildRegistrationCsv([]).startsWith("\uFEFF"));
const route = readFileSync("app/api/registrations/export/route.ts", "utf8");
assert.ok(route.includes('requireProfile(["admin"])'));
assert.ok(route.includes('"Cache-Control":"private, no-store"'));
assert.ok(route.includes("buildRegistrationCsv(rows)"));

// Verify actual enrichment, including account-only records and multiple batches,
// without reading or writing any real student's data.
async function checkDirectory() {
  const source = Array.from({ length: 501 }, (_, i) => ({ ...base, student_id: String(i), receipt_path: i === 500 ? "500/receipt.jpg" : null }));
  const ranges: number[] = [];
  const batches: number[] = [];
  const mock = {
    rpc(name: string) {
      assert.equal(name, "registration_directory");
      return { async range(start: number, end: number) {
        ranges.push(start);
        return { data: source.slice(start, end + 1), error: null };
      } };
    },
    from(table: string) {
      return { select() { return { in(_key: string, ids: string[]) {
        batches.push(ids.length);
        const data = table === "student_registrations"
          ? ids.filter(id => id === "0").map(student_id => ({ student_id, course_type: "with_exam", course_duration_months: 6, additional_notes: "توضیحات خرید" }))
          : table === "student_account_details"
            ? ids.filter(id => id === "0" || id === "500").map(student_id => ({ student_id, telegram_id: "account_test", province: "فارس", city: "شیراز", additional_notes: "توضیحات حساب" }))
            : [];
        return table === "counselor_students"
          ? { order: async () => ({ data, error: null }) }
          : Promise.resolve({ data, error: null });
      } }; } };
    },
  };
  const rows = await loadRegistrationDirectory(mock as unknown as Parameters<typeof loadRegistrationDirectory>[0]);
  assert.deepEqual(ranges, [0, 500]);
  assert.deepEqual(batches, [200, 200, 200, 200, 200, 200, 101, 101, 101]);
  assert.equal(prioritizePendingUnassignedReceipts(rows)[0].student_id, "500", "Receipt on a later page must appear first in the activation view.");
  assert.equal(rows[0].student_id, "0", "The loader / CSV order must not change.");
  assert.deepEqual(registrationCsvValues(rows[0]).slice(11), ["مشاوره با آزمون", 6, "توضیحات خرید"]);
  assert.deepEqual(registrationCsvValues(rows[500]).slice(11), ["", "", "توضیحات حساب"]);
  assert.deepEqual(registrationCsvValues(rows[1]).slice(11), ["", "", ""]);
  const failure = { ...mock, from() { return { select() { return { in() { return { order: async () => ({ data: null, error: new Error("denied") }) }; } }; } }; } };
  await assert.rejects(() => loadRegistrationDirectory(failure as unknown as Parameters<typeof loadRegistrationDirectory>[0]), /Registration details unavailable/);
}
checkDirectory().then(() => {
  if (process.env.CSV_QA_PATH) writeFileSync(process.env.CSV_QA_PATH, csv, "utf8");
  console.log("Registration CSV: all enrollment fields, legacy rows, permissions, pagination, quoting and formula safety passed.");
}).catch(error => { console.error(error); process.exitCode = 1; });
