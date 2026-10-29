import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import {
  isPendingUnassignedReceipt,
  prioritizePendingUnassignedReceipts,
  type RegistrationRow,
} from "../lib/registration";

const base: RegistrationRow = {
  student_id: "student", full_name: "دانش‌آموز آزمایشی", phone: null,
  telegram_id: null, grade: null, study_field: null, province: null, city: null,
  registration_status: "pending", receipt_path: "student/receipt.jpg", receipt_name: "receipt.jpg",
  counselor_name: null, counselor_id: null, created_at: "2026-10-29T00:00:00Z",
};
const row = (id: string, changes: Partial<RegistrationRow> = {}): RegistrationRow => ({ ...base, student_id: id, ...changes });

const original = [
  row("assigned", { counselor_id: "coach" }),
  row("no-receipt", { receipt_path: null }),
  row("new-pending"),
  row("already-active", { registration_status: "active" }),
  row("old-pending"),
  row("incomplete", { registration_status: "incomplete" }),
  row("empty-path", { receipt_path: "" }),
];
assert.equal(isPendingUnassignedReceipt(original[2]), true);
assert.deepEqual(prioritizePendingUnassignedReceipts(original).map(r => r.student_id), [
  "new-pending", "old-pending", "assigned", "no-receipt", "already-active", "incomplete", "empty-path",
]);
assert.deepEqual(original.map(r => r.student_id), [
  "assigned", "no-receipt", "new-pending", "already-active", "old-pending", "incomplete", "empty-path",
], "Sorting the view must not mutate the loader results (also used for CSV export).");

// A qualifying student on a later directory page must still appear first.
const acrossPages = Array.from({ length: 501 }, (_, index) => row(`student-${index}`, { receipt_path: null }));
acrossPages[500] = row("receipt-on-second-page");
const sorted = prioritizePendingUnassignedReceipts(acrossPages);
assert.equal(sorted[0], acrossPages[500]);
assert.equal(sorted[1], acrossPages[0]);
assert.equal(sorted.length, acrossPages.length);
assert.deepEqual(prioritizePendingUnassignedReceipts([]), []);

const component = readFileSync("components/dashboard/registration-directory.tsx", "utf8");
assert.match(component, /const orderedRows = prioritizePendingUnassignedReceipts\(rows\)/);
assert.match(component, /\{orderedRows\.map\(\(row\) =>/);
console.log("Registration activation priority: pending receipt without counselor goes first; other rows stay ordered.");
