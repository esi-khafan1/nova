import type { StudyField } from "@/lib/study-catalog";

export type ExamSubjectRange = { id: string; title: string; start: number; end: number };
export type KonkurBookletPreset = { title: string; questionCount: number; durationMinutes: number; subjects: ExamSubjectRange[] };
// Versioned, regular national entrance exam; excludes teacher-training and nursing extras.
// Sources and verified ranges are documented in docs/konkur-templates.md.
export const konkurTemplateVersion = "national-1404-v1";
export const konkurBookletPresets: Record<StudyField, KonkurBookletPreset[]> = {
 mathematics: [
  {title:"ریاضی",questionCount:40,durationMinutes:70,subjects:[{id:"math",title:"ریاضی",start:1,end:40}]},
  {title:"فیزیک و شیمی",questionCount:65,durationMinutes:75,subjects:[{id:"physics",title:"فیزیک",start:41,end:75},{id:"chemistry",title:"شیمی",start:76,end:105}]},
 ],
 experimental_sciences: [
  {title:"زیست‌شناسی",questionCount:45,durationMinutes:45,subjects:[{id:"biology",title:"زیست‌شناسی",start:1,end:45}]},
  {title:"فیزیک و شیمی",questionCount:65,durationMinutes:75,subjects:[{id:"physics",title:"فیزیک",start:46,end:75},{id:"chemistry",title:"شیمی",start:76,end:110}]},
  {title:"ریاضی و زمین‌شناسی",questionCount:45,durationMinutes:60,subjects:[{id:"math",title:"ریاضی",start:111,end:140},{id:"geology",title:"زمین‌شناسی",start:141,end:155}]},
 ],
 humanities: [
  {title:"ریاضی، ادبیات، علوم اجتماعی و روان‌شناسی",questionCount:80,durationMinutes:85,subjects:[{id:"math",title:"ریاضی",start:1,end:20},{id:"literature",title:"زبان و ادبیات فارسی",start:21,end:50},{id:"social",title:"علوم اجتماعی",start:51,end:65},{id:"psychology",title:"روان‌شناسی",start:66,end:80}]},
  {title:"عربی، تاریخ، جغرافیا، فلسفه و منطق و اقتصاد",questionCount:80,durationMinutes:75,subjects:[{id:"arabic",title:"زبان عربی",start:81,end:100},{id:"history",title:"تاریخ",start:101,end:113},{id:"geography",title:"جغرافیا",start:114,end:125},{id:"philosophy",title:"فلسفه و منطق",start:126,end:145},{id:"economics",title:"اقتصاد",start:146,end:160}]},
 ],
 arts: [{title:"دروس تخصصی هنر",questionCount:100,durationMinutes:115,subjects:[{id:"art",title:"درک عمومی هنر",start:1,end:50},{id:"art-math",title:"درک عمومی ریاضی و فیزیک",start:51,end:80},{id:"visual",title:"خلاقیت تصویری و تجسمی",start:81,end:100}]}],
 foreign_languages: [{title:"زبان تخصصی",questionCount:70,durationMinutes:105,subjects:[{id:"language",title:"زبان تخصصی",start:1,end:70}]}],
};
export const allKonkurBookletTitles = Array.from(new Set(Object.values(konkurBookletPresets).flatMap(booklets=>booklets.flatMap(b=>b.subjects.map(s=>s.title)))));
export function matchesKonkurTemplate(field: StudyField, booklets: {title?:string;questionCount?:number;durationMinutes?:number}[]) {
 const expected=konkurBookletPresets[field];
 return booklets.length===expected.length && expected.every((b,i)=>b.title===booklets[i].title && b.questionCount===booklets[i].questionCount && b.durationMinutes===booklets[i].durationMinutes);
}
