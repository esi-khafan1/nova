import { sharedSchoolSubjects } from './school-catalog';
import type { StudyField } from './study-catalog';
import type { Grade } from './planning-curriculum';

export type ReviewSetting = {offset:3|7|30;kind:'general'|'specialist';reading:boolean;practice:boolean};
export function reviewKind(subject:string,grade:Grade,field:StudyField|null):ReviewSetting['kind'] {
  if(grade===9)return ['ریاضی','علوم تجربی','هوش و استعداد تحلیلی'].includes(subject)?'specialist':'general';
  if(field!=='humanities' && ['تاریخ معاصر ایران','علوم اجتماعی'].includes(subject))return 'general';
  return sharedSchoolSubjects(field,grade).includes(subject)?'general':'specialist';
}
export function readReviewSetting(value:unknown):ReviewSetting|null {
  if(!value||typeof value!=='object'||Array.isArray(value))return null;
  const v=value as Record<string,unknown>;
  if(![3,7,30].includes(v.offset as number)||!(v.kind==='general'||v.kind==='specialist')||typeof v.reading!=='boolean'||typeof v.practice!=='boolean'||(!v.reading&&!v.practice))return null;
  return {offset:v.offset as 3|7|30,kind:v.kind,reading:v.reading,practice:v.practice};
}
export function normalizeReviewKind(extra:Record<string,unknown>|null|undefined,subject:string,grade:Grade,field:StudyField|null):Record<string,unknown>|null|undefined {
 const review=readReviewSetting(extra?.review);
 if(!review||!subject)return extra;
 const kind=reviewKind(subject,grade,field);
 return review.kind===kind?extra:{...extra,review:{...review,kind}};
}
export function reviewDescription(setting:ReviewSetting):string {
 const labels=setting.kind==='general'?['مطالعه درسنامه','حل نمونه سوال']:['خواندن جمع‌بندی','زدن تست‌های مارکدار'];
 return [setting.reading?labels[0]:null,setting.practice?labels[1]:null].filter(Boolean).join(' و ');
}
