import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { coursesFor } from "../lib/courses";
import { citiesForProvince } from "../lib/iran-cities";
import { provinces } from "../lib/registration";
for (const grade of [10, 11, 12]) for (const field of ["mathematics", "experimental_sciences", "humanities"]) {
  const courses = coursesFor(grade, field);
  assert.deepEqual(courses.map(c => c.months), [3,3,3,6,6,6,12,12,12]);
  for (let start=0; start<9; start+=3) assert.deepEqual(courses.slice(start,start+3).map(c=>c.course), ["with_exam","with_support","simple_consultant"]);
}
assert.equal(provinces.length, 31);
for (const province of provinces) {
  const cities=citiesForProvince(province);
  assert.ok(cities.length > 0, `${province} has city options`);
  assert.equal(cities.length, new Set(cities).size);
  assert.ok(cities.every(city=>city.length>=2 && city.length<=60));
}
assert.ok(citiesForProvince("تهران").includes("تهران"));
assert.ok(citiesForProvince("فارس").includes("شیراز"));
assert.ok(!citiesForProvince("تهران").includes("شیراز"));
assert.deepEqual(citiesForProvince("invalid"),[]);
assert.deepEqual(citiesForProvince("__proto__"),[]);
const form=readFileSync("components/registration/registration-form.tsx","utf8");
assert.ok(form.includes('<ProvinceCityFields values={values}/>'));
assert.ok(form.includes('required={!values.receipt_name}'));
const fields=readFileSync("components/registration/province-city-fields.tsx","utf8");
assert.ok(fields.includes('setSelectedCity("")'));
assert.ok(fields.includes('setCustomCity("")'));
assert.ok(fields.includes('disabled={!province}'));
const css=readFileSync("app/courses.css","utf8");
assert.ok(css.includes('--course-columns:3'));
assert.ok(css.includes('--course-columns:2'));
assert.ok(css.includes('overflow-x:auto'));
assert.ok(!css.includes('max-width:1160px'));
console.log("Duration-first carousel, all 31 province catalogs, dependent selection and existing receipt requirements passed.");

const cards=readFileSync("components/registration/course-cards.tsx","utf8");
assert.ok(!cards.includes("nova-course-scroll-tools"));
assert.ok(!cards.includes("aria-describedby"));
assert.ok(cards.includes('data-visible={limits.previous}'));
assert.ok(cards.includes('data-visible={limits.next}'));
assert.ok(cards.includes('event.key === "ArrowLeft"'));
assert.ok(css.includes('pointer-events:none'));
assert.ok(css.includes('height:var(--path-panel-height)'));
console.log("Quiet edge cues, keyboard navigation and shared responsive panel-height guards passed.");
