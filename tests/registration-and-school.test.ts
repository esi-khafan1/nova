import assert from "node:assert/strict";
import { normalizeDigits,validateRegistration,receiptImageType,csvCell } from "../lib/registration";
import { schoolBooks } from "../lib/school-catalog";
import { curriculumBooks,journeyGroups,planningGrades } from "../lib/planning-curriculum";
import type { StudyItem } from "../lib/student-planning";
const valid={first_name:"علی",last_name:"احمدی",phone:"09121234567",telegram_id:"student_1",grade:11,study_field:"humanities",province:"تهران",city:"تهران"};
assert.equal(validateRegistration(valid),null);
for(const key of Object.keys(valid))assert.notEqual(validateRegistration({...valid,[key]:""}),null,`${key} required`);
assert.equal(normalizeDigits("۰۹۱۲١٢٣۴۵۶۷"),"09121234567");
assert.equal(validateRegistration({...valid,grade:9}),"پایه و رشته را انتخاب کن.");
assert.equal(receiptImageType(new TextEncoder().encode('<svg></svg>')),null);
assert.equal(receiptImageType(Uint8Array.from([137,80,78,71,13,10,26,10]))?.mime,"image/png");
assert.equal(csvCell('=IMPORTXML("evil")'),'"\'=IMPORTXML(""evil"")"');
assert.equal(csvCell('  @evil'),'"\'  @evil"');
for(const field of ["mathematics","experimental_sciences","humanities"] as const)for(const grade of [10,11,12] as const){
 const books=schoolBooks(field,grade);assert.ok(books.length>=10);assert.equal(new Set(books.map(b=>b.subject)).size,books.length);assert.ok(books.some(b=>b.subject.startsWith('فارسی')));assert.ok(books.some(b=>b.subject.startsWith('نگارش')));assert.ok(books.some(b=>b.subject.startsWith('عربی')));assert.deepEqual(curriculumBooks(field,grade,'final_exam'),books);
}
const base={id:"one",plan_id:"plan",day_of_week:0,duration_minutes:60,subject:"ریاضی ۱",chapter:"فصل ۵: تابع",activity_type:"lesson",target_test_count:null,details:null,sort_order:0,source_grade:10} as StudyItem;
const groups=journeyGroups([base,{...base,id:"two",preparation_track:"final_exam"}],"experimental_sciences",11);
assert.equal(groups.filter(g=>g.subject==='ریاضی ۱').length,1);assert.equal(groups.find(g=>g.subject==='ریاضی ۱')?.items.length,2);
assert.ok(groups.some(g=>g.subject==='فارسی ۱'));assert.ok(!groups.some(g=>g.grade===12));
assert.equal(validateRegistration({...valid,full_name:"سارا محمدی راد"}),null);
assert.equal(validateRegistration({...valid,first_name:undefined,last_name:undefined,full_name:"سارا محمدی راد"}),null);
assert.notEqual(validateRegistration({...valid,full_name:""}),null);
assert.notEqual(validateRegistration({...valid,full_name:"سارا"}),null);
assert.deepEqual(planningGrades,[10,11,12]);
assert.ok(journeyGroups([{...base,source_grade:12,subject:"شیمی ۳"}],"experimental_sciences",10).some(g=>g.grade===12&&g.items.length===1));
console.log('Registration, CSV safety, and school curriculum tests passed.');
