"use client";

import { useEffect, useRef, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { parseTodayReviews, type TodayReview } from "@/lib/planner-review-today";
import { reviewDescription } from "@/lib/planner-review-settings";
import styles from "./planner-insights.module.css";

/** The server returns only reviews due today, based on the first activity tick. */
export function PlannerPublishedReviews({studentId,weekStart,canToggle}:{studentId:string;weekStart:string;canToggle:boolean}) {
 const [rows,setRows]=useState<TodayReview[]|null>(null),[error,setError]=useState(''),[pending,setPending]=useState(false),[attempt,setAttempt]=useState(0);
 const running=useRef(false);
 useEffect(()=>{let cancelled=false;setRows(null);setError('');setPending(false);running.current=false;
  void (async()=>{try{const {data,error}=await createClient({planner:true}).rpc('planner_review_today_v2',{target_student_id:studentId});if(error)throw error;const parsed=parseTodayReviews(data);if(!cancelled)setRows(parsed);}catch{if(!cancelled)setError('دریافت مرورهای امروز انجام نشد؛ دوباره تلاش کن.')}})();
  return()=>{cancelled=true};
 },[studentId,weekStart,attempt]);
 const toggle=async(row:TodayReview,checked:boolean)=>{
  if(!canToggle||running.current)return;running.current=true;setPending(true);setError('');
  try{const {error}=await createClient({planner:true}).rpc('planner_set_review_today_v2',{target_item_id:row.itemId,target_completed:checked});if(error)throw error;setAttempt(v=>v+1);}
  catch{setError('ثبت مرور انجام نشد؛ دوباره تلاش کن.');setPending(false);running.current=false;}
 };
 if(rows?.length===0&&!error)return null;
 return <section className={`${styles.panel} ${styles.publishedPanel}`} aria-label="مرورهای امروز">
  <h2>مرورهای امروز</h2>
  {error&&<p role="alert">{error} <button className={styles.retry} type="button" onClick={()=>setAttempt(v=>v+1)}>تلاش دوباره</button></p>}
  {!rows&&!error&&<p role="status">در حال دریافت مرورها...</p>}
  {rows&&<div className={styles.reviewDays}><section className={styles.reviewDay}>{rows.map(row=><label className={styles.review} key={row.itemId}>
   <input type="checkbox" checked={row.completed} disabled={!canToggle||pending} onChange={event=>void toggle(row,event.target.checked)}/>
   <span><strong>{row.subject}</strong> · {row.chapter||'مبحث آزاد'}{row.topics.length?` · ${row.topics.map(topic=>topic.title).join('، ')}`:''} · {reviewDescription(row.setting)}</span>
  </label>)}</section></div>}
 </section>;
}
