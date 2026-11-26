"use client";
import {useEffect,useRef,useState} from "react";
import {createClient} from "@/lib/supabase/client";
import {parseTodayReviews,type TodayReview} from "@/lib/planner-review-today";
import {parseSpacedReviews,type SpacedReview} from "@/lib/planner-spaced-reviews";
import {reviewDescription} from "@/lib/planner-review-settings";
import styles from "./planner-insights.module.css";

type Row=({source:'legacy'} & TodayReview)|({source:'spaced'} & SpacedReview);
/** Keep legacy reviews intact while each new occurrence has an independent tick. */
export function PlannerPublishedReviews({studentId,weekStart,canToggle,includeSpaced=true}:{studentId:string;weekStart:string;canToggle:boolean;includeSpaced?:boolean}) {
 const [rows,setRows]=useState<Row[]|null>(null),[error,setError]=useState(''),[pending,setPending]=useState(false),[attempt,setAttempt]=useState(0);
 const running=useRef(false);
 useEffect(()=>{let cancelled=false;setRows(null);setError('');setPending(false);running.current=false;
  void (async()=>{try{const client=createClient({planner:true});const [legacy,spaced]=await Promise.all([
   client.rpc('planner_review_today_v2',{target_student_id:studentId}),
   includeSpaced?client.rpc('planner_spaced_reviews_week',{target_student_id:studentId,target_week_start:weekStart}):Promise.resolve({data:[],error:null})
  ]);if(legacy.error||spaced.error)throw legacy.error||spaced.error;
  const parsed:Row[]=[...parseTodayReviews(legacy.data).map(r=>({...r,source:'legacy' as const})),...parseSpacedReviews(spaced.data).filter(r=>r.date===weekStart).map(r=>({...r,source:'spaced' as const}))];if(!cancelled)setRows(parsed);
  }catch{if(!cancelled)setError('دریافت مرورهای امروز انجام نشد؛ دوباره تلاش کن.')}})();
  return()=>{cancelled=true};
 },[studentId,weekStart,attempt,includeSpaced]);
 const toggle=async(row:Row,checked:boolean)=>{
  if(!canToggle||running.current)return;running.current=true;setPending(true);setError('');
  try{const client=createClient({planner:true});const {error}=row.source==='spaced'?await client.rpc('planner_set_spaced_review_completed',{target_review_id:row.id,target_completed:checked}):await client.rpc('planner_set_review_today_v2',{target_item_id:row.itemId,target_completed:checked});if(error)throw error;setAttempt(v=>v+1);}
  catch{setError('ثبت مرور انجام نشد؛ دوباره تلاش کن.');setPending(false);running.current=false;}
 };
 if(rows?.length===0&&!error)return null;
 return <section className={`${styles.panel} ${styles.publishedPanel}`} aria-label="مرورهای امروز">
  <h2>مرورهای امروز</h2>
  {error&&<p role="alert">{error} <button className={styles.retry} type="button" onClick={()=>setAttempt(v=>v+1)}>تلاش دوباره</button></p>}
  {!rows&&!error&&<p role="status">در حال دریافت مرورها...</p>}
  {rows&&<div className={styles.reviewDays}><section className={styles.reviewDay}>{rows.map(row=><label className={styles.review} key={row.source==='spaced'?row.id:`legacy:${row.itemId}`}>
   <input type="checkbox" checked={row.completed} disabled={!canToggle||pending} onChange={event=>void toggle(row,event.target.checked)}/>
   <span><strong>{row.subject}</strong> · {row.chapter||'مبحث آزاد'}{row.topics.length?` · ${row.topics.map(topic=>topic.title).join('، ')}`:''} · {reviewDescription(row.setting)}{row.source==='spaced'?` · ${new Intl.NumberFormat('fa-IR').format(row.offset)} روز بعد`:''}</span>
  </label>)}</section></div>}
 </section>;
}
