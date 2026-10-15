import assert from 'node:assert/strict';
import {konkurBookletPresets,matchesKonkurTemplate} from '../lib/konkur-presets';
import {calculateBookletResults,type ExamBooklet} from '../lib/exams';
const totals={mathematics:[2,105,145],experimental_sciences:[3,155,180],humanities:[2,160,160],arts:[1,100,115],foreign_languages:[1,70,105]};
for(const [field,booklets] of Object.entries(konkurBookletPresets)){
 let next=1;
 assert.deepEqual([booklets.length,booklets.reduce((s,b)=>s+b.questionCount,0),booklets.reduce((s,b)=>s+b.durationMinutes,0)],totals[field as keyof typeof totals]);
 for(const b of booklets){const start=next;for(const subject of b.subjects){assert.equal(subject.start,next);assert.ok(subject.end>=subject.start);next=subject.end+1;}assert.equal(next-start,b.questionCount);}
 assert.equal(matchesKonkurTemplate(field as keyof typeof konkurBookletPresets,booklets),true);
 assert.equal(matchesKonkurTemplate(field as keyof typeof konkurBookletPresets,booklets.map((b,i)=>({...b,questionCount:b.questionCount+(i===0?1:0)}))),false);
}
for(const field of ['mathematics','experimental_sciences'] as const){
 const b=konkurBookletPresets[field][1];const start=b.subjects[0].start,end=b.subjects.at(-1)!.end;
 const booklet:ExamBooklet={id:'qa',title:b.title,pdf_url:'',question_count:b.questionCount,start_question_number:start,end_question_number:end,duration_minutes:b.durationMinutes,sort_order:1,subject_ranges:b.subjects,key_answers:Object.fromEntries(Array.from({length:b.questionCount},(_,i)=>[String(start+i),1]))};
 const answers=Object.fromEntries(Array.from({length:b.questionCount},(_,i)=>[String(start+i),start+i<=75?1:2]));
 const rows=calculateBookletResults([booklet],answers);assert.equal(rows[0].title,'فیزیک');assert.equal(rows[0].percentage,100);assert.equal(rows[1].title,'شیمی');assert.equal(rows[1].percentage,-33.33);assert.equal(rows[0].total,field==='mathematics'?35:30);assert.equal(rows[1].total,field==='mathematics'?30:35);
 const boundary=calculateBookletResults([booklet],{'75':1,'76':2});assert.equal(boundary[0].correct,1);assert.equal(boundary[0].incorrect,0);assert.equal(boundary[1].correct,0);assert.equal(boundary[1].incorrect,1);
}
const legacy:ExamBooklet={id:'old',title:'فیزیک',pdf_url:'',question_count:3,start_question_number:1,end_question_number:3,duration_minutes:1,sort_order:0,key_answers:{'1':1,'2':1,'3':1}};
assert.equal(calculateBookletResults([legacy],{'1':1,'2':2})[0].percentage,22.22);
assert.equal(calculateBookletResults([legacy],null)[0].unanswered,3);
console.log('PASS: all five templates, exact ranges, frozen structure, physics/chemistry boundary isolation, negative marks, fractions and legacy booklet fallback.');
