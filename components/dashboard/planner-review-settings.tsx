"use client";
import { readReviewSetting, reviewKind, type ReviewSetting } from '@/lib/planner-review-settings';
import type { Grade } from '@/lib/planning-curriculum';
import type { StudyField } from '@/lib/study-catalog';

export function PlannerReviewSettings({subject,grade,field,extra,onChange}:{subject:string;grade:Grade;field:StudyField|null;extra:Record<string,unknown>|null|undefined;onChange:(value:Record<string,unknown>|null)=>void}) {
 const kind=reviewKind(subject,grade,field),saved=readReviewSetting(extra?.review);
 const selected=saved?{...saved,kind}:null;
 const save=(review:ReviewSetting|null)=>{const next={...extra};if(review)next.review=review;else delete next.review;onChange(Object.keys(next).length?next:null)};
 const flip=(key:'reading'|'practice')=>{if(!selected)return;const next={...selected,[key]:!selected[key]};if(next.reading||next.practice)save(next)};
 const labels=kind==='general'?['مطالعه درسنامه','حل نمونه سوال']:['خواندن جمع‌بندی','زدن تست‌های مارکدار'];
 return <div className="plan-review-settings" role="group" aria-label="تنظیم مرور فعالیت">
  <label className="plan-review-offset">مرور<select aria-label="بازه مرور" value={selected?.offset??''} onChange={e=>{const offset=Number(e.target.value);if(!offset){save(null);return;}if(offset===3||offset===7||offset===30)save({offset,kind,reading:selected?.reading??true,practice:selected?.practice??false});}}><option value="">بدون مرور</option><option value="3">۳ روز بعد</option><option value="7">۱ هفته بعد</option><option value="30">۱ ماه بعد</option></select></label>
  {selected&&<div className="plan-review-actions" role="group" aria-label="نوع مرور">{(['reading','practice'] as const).map((key,index)=><label key={key}><input type="checkbox" checked={selected[key]} disabled={selected[key]&&!selected[key==='reading'?'practice':'reading']} title={selected[key]&&!selected[key==='reading'?'practice':'reading']?'حداقل یک نوع مرور لازم است':undefined} onChange={()=>flip(key)}/><span>{labels[index]}</span></label>)}</div>}
 </div>;
}
