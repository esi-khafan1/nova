import { studyCatalog, type StudyBook, type StudyField } from "./study-catalog";
// School subjects, independent of any particular entrance-exam year.
// Reuse chapter lists already in the specialist catalog; do not invent missing chapters.
// Grade nine has no high-school study field. Keep its school textbooks separate
// from analytical aptitude, which is entrance-exam preparation, not a textbook.
export const gradeNineSchoolSubjects = [
 "ریاضی", "علوم تجربی", "فارسی", "نگارش", "مطالعات اجتماعی", "عربی",
 "زبان انگلیسی", "کتاب کار زبان انگلیسی", "آموزش قرآن", "پیام‌های آسمان",
 "کار و فناوری", "فرهنگ و هنر", "تفکر و سبک زندگی", "آمادگی دفاعی",
] as const;
const common: Record<10|11|12,string[]> = {
 10:["فارسی ۱","نگارش ۱","تعلیمات دینی ۱","زبان خارجی ۱","عربی زبان قرآن ۱","جغرافیای ایران","تفکر و سواد رسانه‌ای","آمادگی دفاعی","کارگاه کارآفرینی و تولید","تربیت بدنی ۱"],
 11:["فارسی ۲","نگارش ۲","تعلیمات دینی ۲","زبان خارجی ۲","عربی زبان قرآن ۲","انسان و محیط زیست","تربیت بدنی ۲"],
 12:["فارسی ۳","نگارش ۳","تعلیمات دینی ۳","زبان خارجی ۳","عربی زبان قرآن ۳","سلامت و بهداشت","مدیریت خانواده و سبک زندگی","تربیت بدنی ۳"],
};
/** Shared school subjects genuinely offered across the academic fields. */
export function sharedSchoolSubjects(field:StudyField|null,grade:10|11|12):string[]{
 if(!field||!["mathematics","experimental_sciences","humanities"].includes(field))return [];
 return common[grade].filter(subject=>field!=="humanities"||!subject.startsWith("عربی زبان قرآن"));
}

export function schoolBooks(field:StudyField|null,grade:9|10|11|12):StudyBook[]{
 if(grade===9)return gradeNineSchoolSubjects.map(subject=>({subject,chapters:[]}));
 if(!field||!["mathematics","experimental_sciences","humanities"].includes(field))return [];
 const specialist=studyCatalog[field][grade]??[];
 const shared=sharedSchoolSubjects(field,grade);
 const commonExtras=field==="humanities"?[]:grade===11?["تاریخ معاصر ایران",...(field==="mathematics"?["زمین‌شناسی"]:[])]:grade===12?["علوم اجتماعی"]:[];
 const labExtras=field==="experimental_sciences"?(grade===10?["آزمایشگاه علوم تجربی ۱"]:grade===11?["آزمایشگاه علوم تجربی ۲"]:[]):[];
 const extras=[...commonExtras,...labExtras];
 return [...new Set([...specialist.map(book=>book.subject),...shared,...extras])].map(subject=>({subject,chapters:specialist.find(book=>book.subject===subject)?.chapters??[]}));
}
