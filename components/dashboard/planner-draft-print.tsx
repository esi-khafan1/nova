"use client";
import { useEffect, useRef, useState } from "react";
import { createPortal } from "react-dom";
import { createClient } from "@/lib/supabase/client";
import type { PlannerGrid } from "@/lib/planner-grid";
import type { PrintableReviewRecord } from "@/lib/planner-review-records";
import { printableSpacedReviews } from "@/lib/planner-spaced-reviews";
import { printableTodayReviews } from "@/lib/planner-review-today";
import type { StudyField } from "@/lib/study-catalog";
import type { PrintablePlan, PrintableWeekDetails } from "./print-weekly-plan";
import { PlannerPrintSuite } from "./planner-print-suite";
import styles from "./planner-draft-print.module.css";

type Props={plan:PrintablePlan;student:{full_name:string;grade:number|null;study_field:StudyField|null};counselorName:string;weekDetails:PrintableWeekDetails;grid:PlannerGrid;onBack:()=>void};
/** This preview uses the editor's in-memory snapshot, not an exposed draft URL.
 * Published ticks stay separate from speculative draft reviews. */
export function PlannerDraftPrint({plan,student,counselorName,weekDetails,onBack}:Props){
 const overlay=useRef<HTMLDivElement>(null);
 const [mounted,setMounted]=useState(false),[rows,setRows]=useState<PrintableReviewRecord[]|null>(null),[error,setError]=useState(false),[attempt,setAttempt]=useState(0);
 useEffect(()=>{setMounted(true)},[]);
 useEffect(()=>{if(!mounted)return;const before=document.activeElement instanceof HTMLElement?document.activeElement:null;overlay.current?.focus();const key=(event:KeyboardEvent)=>{if(event.key==='Escape'){event.preventDefault();onBack()}};window.addEventListener('keydown',key);return()=>{window.removeEventListener('keydown',key);before?.focus()};},[mounted,onBack]);
 useEffect(()=>{let cancelled=false;setRows(null);setError(false);
  void (async()=>{try{
   const client=createClient({planner:true});
   const [legacy,spaced]=await Promise.all([client.rpc("planner_review_today_v2",{target_student_id:plan.student_id}),client.rpc("planner_spaced_reviews_week",{target_student_id:plan.student_id,target_week_start:plan.week_start})]);
   if(legacy.error||spaced.error)throw legacy.error||spaced.error;
   const end=new Date(Date.parse(`${plan.week_start}T00:00:00Z`)+6*86400000).toISOString().slice(0,10);
   const rows=[...printableTodayReviews(legacy.data),...printableSpacedReviews(spaced.data)].filter(row=>row.date>=plan.week_start&&row.date<=end);
   if(!cancelled)setRows(rows);
  }catch{if(!cancelled)setError(true)}})();return()=>{cancelled=true};
 },[plan.student_id,plan.week_start,attempt]);
 if(!mounted)return null;
 return createPortal(<div ref={overlay} className={`planner-draft-print-overlay ${styles.overlay}`} dir="rtl" role="dialog" aria-modal="true" aria-label="پیش‌نمایش چاپ پیش‌نویس" tabIndex={-1}>
  {!rows?<section className={styles.message} role={error?"alert":"status"}>{error?<><p>دریافت مرورهای منتشرشده انجام نشد؛ برای جلوگیری از چاپ اطلاعات ناقص دوباره تلاش کن.</p><button type="button" onClick={()=>setAttempt(n=>n+1)}>تلاش دوباره</button>{" "}<button type="button" onClick={onBack}>بازگشت به برنامه</button></>:<p>در حال آماده‌سازی پیش‌نمایش...</p>}</section>:
  <PlannerPrintSuite plan={plan} student={student} counselorName={counselorName} backHref="/dashboard/counselor/plans" onBack={onBack} weekDetails={weekDetails} sources={[]} completed={new Set()} reviewRows={rows} draftPreview/>}
 </div>,document.body);
}
