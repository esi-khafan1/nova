import assert from "node:assert/strict";
import { readFileSync, existsSync } from "node:fs";
import { coursesFor, courseFields, courseRegistrationPath, parseCourseSelection } from "../lib/courses";
import { emailConfirmationUrl } from "../lib/auth-urls";
import { safeReturnPath } from "../lib/return-path";
for(const grade of [10,11,12])for(const field of courseFields){
 const courses=coursesFor(grade,field);assert.equal(courses.length,9);assert.equal(new Set(courses.map(c=>`${c.course}:${c.months}`)).size,9);
 for(const c of courses){const path=courseRegistrationPath(c);assert.equal(safeReturnPath(path),path);const callback=new URL(emailConfirmationUrl(path));assert.equal(callback.searchParams.get("next"),path);assert.deepEqual(parseCourseSelection(Object.fromEntries(new URL(`https://nova-academy.ir${path}`).searchParams)),c);assert.ok(existsSync(`public/courses/${c.course}-${c.field}.svg`));}
}
assert.equal(coursesFor(9,"humanities").length,0);assert.equal(coursesFor(10,"arts").length,0);
const valid={grade:"10",field:"humanities",course:"with_exam",months:"3"};
for(const bad of [{grade:[]},{grade:["10"]},{field:["humanities"]},{course:"bad"},{months:"4"},{months:["3"]},{grade:"10/../../"}])assert.equal(parseCourseSelection({...valid,...bad}),null);
const read=(p:string)=>readFileSync(p,"utf8");
assert.ok(read("lib/auth.ts").includes('registration_status !== "active" && !allowInactive'));
for(const p of ["app/dashboard/student/page.tsx","app/dashboard/student/exams/page.tsx","app/dashboard/student/account/page.tsx"])assert.ok(read(p).includes('requireProfile(["student"], true)'));
assert.ok(read("app/dashboard/student/page.tsx").includes('profile.registration_status === "active") for'));
assert.ok(read("app/dashboard/student/exams/page.tsx").indexOf('registration_status !== "active"')<read("app/dashboard/student/exams/page.tsx").indexOf('.from("exams")'));
const form=read("components/registration/registration-form.tsx");assert.ok(form.includes('{enrollment && <><section className="registration-payment"'));assert.ok(form.includes('6219861870360897'));assert.ok(form.includes('IR300560611828006622585901'));assert.ok(form.includes('یاسمین شریفی نسب'));
const account=read("app/dashboard/student/account/page.tsx");assert.ok(account.includes('mode="profile"'));assert.ok(account.includes('<DeleteAccount/>'));
const migration=read("supabase/migrations/043_student_course_enrollment.sql");assert.ok(!/drop table|truncate|delete from|alter policy/i.test(migration));assert.ok(migration.includes('revoke all on function public.save_student_account_details(jsonb) from public,anon'));
const manual=read("supabase/migrations/044_admin_manual_student_activation.sql");assert.ok(manual.includes("is distinct from 'admin'"));assert.ok(manual.includes('insert into public.student_manual_activations'));assert.ok(manual.includes("approval_status='approved'"));
console.log("Course combinations, email return URLs, read-only portal and manual activation regression tests passed.");
