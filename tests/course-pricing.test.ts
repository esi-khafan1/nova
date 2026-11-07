import assert from "node:assert/strict";
import {coursesFor,coursePrice,courseDetailsPath,courseRegistrationPath,parseCourseSelection,courseDurationLabel,studentCourseCatalogPath} from "../lib/courses";
for(const grade of [10,11,12])for(const field of ["mathematics","experimental_sciences","humanities"]){
 const courses=coursesFor(grade,field);assert.equal(courses.length,8);
 assert.deepEqual(courses.map(c=>c.course),["base","progress","base","progress","base","progress","base","progress"]);
 assert.deepEqual(courses.map(c=>c.months),[1,1,3,3,6,6,12,12]);
 for(const c of courses){
  const monthly=grade===12?(c.course==="base"?2700000:3000000):(c.course==="base"?2490000:2790000);
  assert.equal(coursePrice(c),monthly*c.months);
  assert.deepEqual(parseCourseSelection(Object.fromEntries(new URL(courseRegistrationPath(c),'https://example.com').searchParams)),c);
  assert.ok(courseDetailsPath(c).endsWith(`/${c.course}/${c.months}`));
 }
}
assert.equal(studentCourseCatalogPath(12,'experimental_sciences'),'/courses?grade=12&field=experimental_sciences');
assert.equal(studentCourseCatalogPath(10,'humanities'),'/courses?grade=10&field=humanities');
assert.equal(studentCourseCatalogPath(9,null),'/courses?grade=9');
for(const c of coursesFor(9,null)) {
 assert.deepEqual(coursePrice(c),coursePrice({...c,grade:10,field:'mathematics'}));
 assert.deepEqual(parseCourseSelection(Object.fromEntries(new URL(courseRegistrationPath(c),'https://example.com').searchParams)),c);
 assert.equal(parseCourseSelection({grade:9,field:'none',course:c.course,months:c.months})?.field,null);
 assert.match(courseDetailsPath(c),/^\/courses\/9\/none\//);
}
assert.equal(coursesFor(9,null).length,8);
assert.equal(parseCourseSelection({grade:9,field:'humanities',course:'base',months:3}),null);
assert.equal(parseCourseSelection({grade:9,field:null,course:'vip',months:3}),null);
for(const [grade,field] of [[null,null],[12,null],[null,'humanities'],[9,'mathematics'],[12,'arts']]){
 assert.equal(studentCourseCatalogPath(grade as number|null,field as string|null),'/courses');
}
assert.equal(courseDurationLabel(1),'۱ ماهه');
assert.ok(parseCourseSelection({grade:11,field:'humanities',course:'vip',months:3}),'historical selections stay readable');
assert.equal(parseCourseSelection({grade:11,field:'humanities',course:'base',months:2}),null);
console.log('All grades/fields, two advertised plans, four durations, exact prices and registration route round trips passed.');
