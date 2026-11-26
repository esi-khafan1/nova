"use client";
import { readReviewSetting, reviewKind, type ReviewSetting } from '@/lib/planner-review-settings';
import type { Grade } from '@/lib/planning-curriculum';
import type { StudyField } from '@/lib/study-catalog';

export function PlannerReviewSettings({subject,grade,field,extra,onChange}:{subject:string;grade:Grade;field:StudyField|null;extra:Record<string,unknown>|null|undefined;onChange:(value:Record<string,unknown>|null)=>void}) {
 const kind=reviewKind(subject,grade,field),saved=readReviewSetting(extra?.review);
 const selected=saved?{...saved,kind}:null;
 const save=(review:ReviewSetting|null)=>{const next={...extra};if(review)next.review=review;else delete next.review;onChange(Object.keys(next).length?next:null)};
 const flip=(key:'reading'|'practice')=>{
  const next={schedule:'spaced4' as const,kind,reading:selected?.reading??false,practice:selected?.practice??false};
  next[key]=!next[key];save(next.reading||next.practice?next:null);
 };
 const labels=kind==='general'?['مطالعه درسنامه','حل نمونه سوال']:['خواندن جمع‌بندی','زدن تست‌های مارکدار'];
 return <div className="plan-review-settings" role="group" aria-label="تنظیم مرور فعالیت">
  <strong>نوع مرور</strong>
  <div className="plan-review-actions" role="group" aria-label="نوع مرور">{(['reading','practice'] as const).map((key,index)=><label key={key}><input type="checkbox" checked={selected?.[key]??false} onChange={()=>flip(key)}/><span>{labels[index]}</span></label>)}</div>
  <small>{selected && 'offset' in selected && selected.offset ? `مرور قبلی: ${selected.offset} روز بعد؛ با تغییر نوع، مرور چهارمرحله‌ای فعال می‌شود.` : 'در صورت انتخاب، مرورها ۳، ۷، ۳۰ و ۹۰ روز پس از اولین تیک ایجاد می‌شوند و تنظیم پس از آن ثابت می‌ماند.'}</small>
 </div>;
}
