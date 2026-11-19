"use client";

import { useEffect, useRef, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { parsePrintableReviewRecords, type PrintableReviewRecord } from "@/lib/planner-review-records";
import { formatPersianFullDate, parseIsoDate, persianNumber } from "@/lib/persian-date";
import styles from "./planner-insights.module.css";

/** Published reviews are read independently of the working copy. Students can
 * update their own ticks; counselors only observe those ticks. */
export function PlannerPublishedReviews({studentId,weekStart,canToggle}:{studentId:string;weekStart:string;canToggle:boolean}) {
  const [rows,setRows] = useState<PrintableReviewRecord[] | null>(null);
  const [error,setError] = useState("");
  const [missing,setMissing] = useState(false);
  const [pending,setPending] = useState(false);
  const [attempt,setAttempt] = useState(0);
  const running = useRef(false);
  useEffect(() => {
    let cancelled = false;
    setRows(null);setError("");setMissing(false);setPending(false);running.current=false;
    (async () => {
      try {
        const {data,error:err} = await createClient({planner:true}).rpc("planner_review_week",{target_student_id:studentId,target_week_start:weekStart});
        if (cancelled) return;
        if (err && (err.code === "PGRST202" || err.code === "42883")) {setMissing(true);return;}
        if (err) throw err;
        const end = new Date(Date.parse(`${weekStart}T00:00:00Z`) + 6 * 86400000).toISOString().slice(0,10);
        const parsed = parsePrintableReviewRecords(data);
        if (parsed.some(row=>row.date<weekStart || row.date>end)) throw new Error("Invalid review date");
        setRows(parsed);
      } catch {if (!cancelled) setError("دریافت مرورها انجام نشد؛ دوباره تلاش کن.");}
    })();
    return () => {cancelled=true;};
  },[studentId,weekStart,attempt]);
  const toggle = async (row:PrintableReviewRecord,checked:boolean) => {
    if (!canToggle || running.current) return;
    running.current=true;setPending(true);setError("");
    try {
      const client=createClient({planner:true});
      const result=row.historical
        ? await client.rpc("planner_set_historical_review_completed",{target_archive_id:row.archiveId,target_completed:checked})
        : await client.rpc("planner_set_review_completed",{target_item_id:row.itemId,target_offset:row.offset,target_completed:checked});
      if (result.error) throw result.error;
      // Reload from the server. The item may have been replaced while the tick
      // was in flight; do not claim success based on a stale local snapshot.
      setAttempt(value=>value+1);
    } catch {setError("ثبت مرور انجام نشد؛ دوباره تلاش کن.");setPending(false);running.current=false;}
  };
  if (missing) return null; // Gradual rollout: existing plans remain usable before migration.
  const sorted=[...(rows??[])].sort((a,b)=>a.date.localeCompare(b.date)||a.subject.localeCompare(b.subject,"fa")||a.key.localeCompare(b.key));
  return <section className={`${styles.panel} ${styles.publishedPanel}`} aria-label="مرور برنامه‌های منتشرشده">
    <h2>مرور برنامه‌های منتشرشده</h2>
    <p>مرورهای یک، سه و هفت روز بعد؛ تغییرات پیش‌نویس تا انتشار در این جدول دیده نمی‌شوند.</p>
    {error && <p role="alert">{error} <button className={styles.retry} type="button" onClick={()=>setAttempt(value=>value+1)}>تلاش دوباره</button></p>}
    {!rows && !error && <p role="status">در حال دریافت مرورها...</p>}
    {rows && !rows.length && <p>برای این هفته مروری وجود ندارد.</p>}
    {sorted.length>0 && <div className={styles.reviewDays}>{[...new Set(sorted.map(row=>row.date))].map(date=><section className={styles.reviewDay} key={date}>
      <h3>{formatPersianFullDate(parseIsoDate(date))}</h3>
      {sorted.filter(row=>row.date===date).map(row=><label className={styles.review} key={row.key}>
        <input type="checkbox" checked={row.checked} disabled={!canToggle || pending} onChange={event=>void toggle(row,event.target.checked)}/>
        <span><strong>{row.subject}</strong> · {row.chapter || "مبحث آزاد"}{row.topics.length ? ` · ${row.topics.map(topic=>topic.title).join("، ")}` : ""}{row.historical && <small className={styles.historyLabel}> · مرور ثبت‌شده از فعالیت تغییرکرده</small>}</span>
        <small>مرور {persianNumber.format(row.offset)} روز بعد</small>
      </label>)}
    </section>)}</div>}
  </section>;
}
