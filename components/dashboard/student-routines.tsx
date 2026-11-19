"use client";
import {useState,useTransition} from 'react';
import {toggleRoutineCompletion} from '@/app/dashboard/actions';
import {routineEntries,type RoutineCompletion,type StudyPlan} from '@/lib/student-planning';

function RoutineCheck({planId,day,slot,number,subject,details,duration,checked,onSaved}:{planId:string;day:number;slot:1|2;number:number;subject:string;details:string;duration:number|null;checked:boolean;onSaved:(slot:1|2,completed:boolean)=>void}) {
 const [pending,startTransition]=useTransition();
 const [error,setError]=useState(false);
 return <div>
  <label className={`student-plan-check${checked?' checked':''}`}>
   <input type="checkbox" aria-label={`${checked?'برداشتن علامت انجام':'ثبت انجام'} روتین ${new Intl.NumberFormat('fa-IR').format(number)}`} checked={checked} disabled={pending} onChange={event=>{
    const next=event.target.checked;setError(false);
    startTransition(async()=>{try{const result=await toggleRoutineCompletion(planId,day,slot,subject,details,next,duration);if(!result.ok)throw new Error('save');onSaved(slot,next);}catch{setError(true);}});
   }}/><span aria-hidden="true">{checked?'✓':''}</span><strong>انجام داده‌ام</strong>
  </label>
  {error&&<small role="alert">ثبت روتین انجام نشد؛ اگر برنامه تغییر کرده صفحه را تازه‌سازی کن و دوباره تلاش کن.</small>}
 </div>;
}

export function StudentRoutines({plan,day,date,today,audience,completions,onSaved}:{plan:StudyPlan|undefined;day:number;date:string;today:string;audience:'student'|'counselor';completions:RoutineCompletion[];onSaved:(plan:StudyPlan,day:number,slot:1|2,subject:string,details:string,completed:boolean)=>void}) {
 if(!plan)return null;
 const entries=routineEntries(plan,day);
 if(!entries.length)return null;
 const editable=audience==='student' && date<=today;
 return <section className="sp-routines" aria-label="روتین‌های روز">
  <h3>روتین‌های روز</h3>
  {entries.map((entry,index)=>{
   const tick=completions.find(c=>c.plan_id===plan.id&&c.day_of_week===day&&c.slot===entry.slot&&c.subject===entry.subject&&c.details===entry.details);
   return <article className="sp-task sp-routine-task" key={entry.slot}>
    <div><strong>روتین {new Intl.NumberFormat('fa-IR').format(index+1)}</strong>{entry.subject&&<p>درس: {entry.subject}</p>}{entry.details&&<p>{entry.details}</p>}{entry.duration!=null&&<p>{new Intl.NumberFormat("fa-IR").format(entry.duration)} دقیقه</p>}</div>
    {editable?<RoutineCheck key={`${plan.id}:${day}:${entry.slot}`} planId={plan.id} day={day} number={index+1} {...entry} checked={Boolean(tick)} onSaved={(slot,completed)=>onSaved(plan,day,slot,entry.subject,entry.details,completed)}/>:<p className="sp-readonly">{tick?'✓ انجام داده‌ام':date>today?'ثبت انجام در روز روتین فعال می‌شود':'— انجام علامت نخورده'}</p>}
   </article>;
  })}
 </section>;
}
