import { studyCatalog, type StudyField, type StudyBook } from "@/lib/study-catalog";
import { schoolBooks } from "./school-catalog";
import { type StudyItem } from "@/lib/student-planning";
export type Grade = 10|11|12;
export type PreparationTrack = "konkur"|"final_exam";
export function availableGrades(grade:number|null):Grade[]{return [10,11,12].filter(g=>grade!==null&&g<=grade) as Grade[];}
export function curriculumBooks(field:StudyField|null,grade:Grade,track:PreparationTrack):StudyBook[]{
 if(!field)return [];
 if(track==='konkur')return studyCatalog[field][grade]??[];
 return schoolBooks(field,grade);
}
export function inferItemGrade(item:Pick<StudyItem,'subject'|'source_grade'>,field:StudyField|null,maxGrade:number|null):Grade|null{
 if(item.source_grade)return item.source_grade;
 const matches=availableGrades(maxGrade).filter(g=>curriculumBooks(field,g,'konkur').some(b=>b.subject===item.subject));
 return matches.length===1?matches[0]:null;
}
export function journeyGroups(items:StudyItem[],field:StudyField|null,maxGrade:number|null){
 const groups=new Map<string,{key:string;subject:string;grade:Grade|null;track:PreparationTrack;chapters:string[];items:StudyItem[]}>();
 const key=(subject:string,grade:Grade|null)=>JSON.stringify([subject,grade]);
 for(const grade of availableGrades(maxGrade))for(const book of curriculumBooks(field,grade,'final_exam'))groups.set(key(book.subject,grade),{key:key(book.subject,grade),subject:book.subject,grade,track:'konkur',chapters:book.chapters,items:[]});
 for(const item of items){const grade=inferItemGrade(item,field,maxGrade),track=item.preparation_track??'konkur',id=key(item.subject,grade);if(!groups.has(id))groups.set(id,{key:id,subject:item.subject,grade,track,chapters:grade?curriculumBooks(field,grade,track).find(b=>b.subject===item.subject)?.chapters??[]:[],items:[]});groups.get(id)!.items.push(item);}
 return [...groups.values()];
}
// Calendar years/months, then remaining days; omit zero units. Future starts do not create negative membership.
export function companionshipDuration(start:string|null,today:string){
 if(!start)return "هنوز برنامه‌ای منتشر نشده";
 if(start>today)return "برنامه‌ریزی به‌زودی شروع می‌شود";
 const begin=new Date(start+'T12:00:00Z'),end=new Date(today+'T12:00:00Z');
 const addMonths=(months:number)=>{const d=new Date(begin);d.setUTCDate(1);d.setUTCMonth(begin.getUTCMonth()+months);const last=new Date(Date.UTC(d.getUTCFullYear(),d.getUTCMonth()+1,0)).getUTCDate();d.setUTCDate(Math.min(begin.getUTCDate(),last));return d;};
 let months=(end.getUTCFullYear()-begin.getUTCFullYear())*12+end.getUTCMonth()-begin.getUTCMonth();if(addMonths(months)>end)months--;
 const days=Math.round((+end-+addMonths(months))/86400000),years=Math.floor(months/12);months%=12;
 const segments=[[years,'سال'],[months,'ماه'],[days,'روز']] as const;
 const text=segments.filter(([n])=>n>0).map(([n,label])=>`${n.toLocaleString('fa-IR')} ${label}`).join(' و ');
 return text?`${text} همراه نووا`:'امروز به خانوادهٔ نووا پیوستی';
}
