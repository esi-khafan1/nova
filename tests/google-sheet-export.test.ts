import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { exportTokenHash,parseExportToken,formatSheetSnapshot } from "../lib/google-sheet-export";
async function run(){
 const token="nova_sheet_"+"a".repeat(64);
 assert.equal(parseExportToken("Bearer "+token),token);
 for(const bad of [null,"Basic "+token,"Bearer abc",token,"Bearer "+token+" extra"])assert.equal(parseExportToken(bad),null);
 assert.equal(await exportTokenHash(token),createHash("sha256").update(token).digest("hex"));
 const snapshot=formatSheetSnapshot({scope:"counselor",subject_id:"staff",subject_name:"مشاور نمونه",expires_at:"2030-01-01",generated_at:"now",students:[{student_id:"00000000-0000-4000-8000-000000000001",full_name:"دانش‌آموز نمونه",phone:"09121234567",telegram_id:"student_1",study_field:"humanities",registration_status:"active",receipt_path:"never-export-this",has_receipt:true}]});
 assert.equal(snapshot.headers.length,11);assert.equal(snapshot.rows[0].length,11);assert.equal(snapshot.rows[0][1],"09121234567");assert.equal(snapshot.rows[0][10],"https://nova-academy.ir/api/registrations/00000000-0000-4000-8000-000000000001/receipt");assert.ok(!JSON.stringify(snapshot).includes('never-export-this'));
 console.log("Sheet token parsing, hashing, column schema and private receipt-link tests passed.");
}run();
