"use client";

import { useState } from "react";
import Link from "next/link";
import { PrintWeeklyPlan, type PrintablePlan, type PrintableWeekDetails } from "./print-weekly-plan";
import { analyzePlannerWeek } from "@/lib/planner-analysis";
import { reviewsForWeek, type PlannerGrid, type ReviewSource } from "@/lib/planner-grid";
import type { HistoricalReviewRecord } from "@/lib/planner-review-records";
import type { StudyField } from "@/lib/study-catalog";
import { addDays, formatPersianFullDate, formatPersianWeekday, parseIsoDate, persianNumber, toIsoDate } from "@/lib/persian-date";
import styles from "./planner-print-suite.module.css";

const formatNumber = (n: number) => persianNumber.format(n);
const decimal = new Intl.NumberFormat("fa-IR", { maximumFractionDigits: 1 });
function duration(minutes: number) {
  const rounded = Math.round(minutes);
  return `${formatNumber(Math.floor(rounded / 60))}:${formatNumber(rounded % 60).padStart(2,"۰")}`;
}

export function PlannerPrintSuite({plan, student, counselorName, backHref, visibleDays = 7, weekDetails, sources, completed, historical = []}: {
  plan: PrintablePlan;
  student: {full_name:string;grade:number|null;study_field:StudyField|null} | undefined;
  counselorName: string;
  backHref: string;
  visibleDays?: number;
  weekDetails?: PrintableWeekDetails;
  sources: ReviewSource[];
  completed: ReadonlySet<string>;
  historical?: HistoricalReviewRecord[];
}) {
  const [sections,setSections] = useState({week:true,analysis:true,reviews:true});
  const grid: PlannerGrid = Array.from({length:7},()=>[]);
  for (const item of [...plan.weekly_plan_items].sort((a,b)=>a.day_of_week-b.day_of_week || a.sort_order-b.sort_order)) {
    if (item.day_of_week < 0 || item.day_of_week >= visibleDays) continue;
    grid[item.day_of_week].push({key:item.id,id:item.id,dayOfWeek:item.day_of_week,subject:item.subject,chapter:item.chapter??"",activityType:item.activity_type,durationMinutes:item.duration_minutes,targetTestCount:item.target_test_count,details:item.details??""});
  }
  const analysis = analyzePlannerWeek(grid);
  const end=toIsoDate(addDays(parseIsoDate(plan.week_start),6));
  const reviews=[
    ...reviewsForWeek(plan.week_start,sources).map(review=>({...review,checked:completed.has(review.key),historical:false})),
    ...historical.filter(review=>review.date>=plan.week_start&&review.date<=end).map(review=>({...review,key:`archive:${review.archiveId}`,checked:review.completed,historical:true})),
  ].sort((a,b)=>a.date.localeCompare(b.date)||a.subject.localeCompare(b.subject,"fa")||a.key.localeCompare(b.key));
  const anySelected=Object.values(sections).some(Boolean);
  return <main className={styles.suite} dir="rtl">
    <div className={styles.controls} data-print-hide>
      <div className={styles.controlsHead}><div><h1>پیش‌نمایش چاپ</h1><p>صفحه‌های موردنظر را انتخاب کن.</p></div><Link className={styles.back} href={backHref}>بازگشت به برنامه</Link></div>
      <div className={styles.controlRow}>
        <div className={styles.choices}>
          {([{key:"week",label:"برنامهٔ هفته"},{key:"analysis",label:"تحلیل برنامه"},{key:"reviews",label:`جدول مرور (${formatNumber(reviews.length)})`}] as const).map(({key,label})=><label key={key}><input type="checkbox" checked={sections[key]} onChange={event=>setSections(current=>({...current,[key]:event.target.checked}))}/>{label}</label>)}
        </div>
        <button type="button" className={styles.printButton} disabled={!anySelected} onClick={()=>window.print()}>چاپ / ذخیره PDF</button>
      </div>
      {!anySelected && <p role="status">حداقل یک صفحه را انتخاب کن.</p>}
    </div>
    {sections.week && <div className={styles.page} data-section="week"><div className={styles.planPreview}><PrintWeeklyPlan plan={plan} student={student} counselorName={counselorName} backHref={backHref} visibleDays={visibleDays} weekDetails={weekDetails}/></div></div>}
    {sections.analysis && <article className={`${styles.page} ${styles.paper}`} data-section="analysis">
      <header className={styles.header}><div><strong>نووا</strong><h2>تحلیل برنامهٔ هفته</h2></div><div>{student?.full_name||"دانش‌آموز نووا"} · {plan.title}</div></header>
      <div className={styles.stats}>
        <div><span>زمان هفته</span><strong>{duration(analysis.minutes)} ساعت</strong></div><div><span>تعداد تست</span><strong>{formatNumber(analysis.tests)}</strong></div><div><span>تست در ساعت</span><strong>{analysis.testsPerHour === null?"—":decimal.format(analysis.testsPerHour)}</strong></div><div><span>میانگین روزانه</span><strong>{duration(analysis.meanDailyMinutes)} ساعت</strong></div>
      </div>
      <table className={styles.table}><caption>سهم درس‌ها و زمان هر روز (ساعت:دقیقه)</caption><thead><tr><th scope="col">درس</th><th scope="col">سهم هفته</th><th scope="col">کل زمان</th><th scope="col">تست</th>{Array.from({length:visibleDays},(_,i)=><th key={i} scope="col">{formatPersianWeekday(addDays(parseIsoDate(plan.week_start),i))}</th>)}</tr></thead>
        <tbody>{analysis.subjects.map(subject=><tr key={subject.subject}><th scope="row">{subject.subject}</th><td>{decimal.format(subject.percent)}٪<div className={styles.bar}><span style={{width:`${subject.percent}%`}}/></div></td><td>{duration(subject.minutes)}</td><td>{formatNumber(subject.tests)}</td>{subject.days.slice(0,visibleDays).map((n,i)=><td key={i}>{n?duration(n):"—"}</td>)}</tr>)}
          {!analysis.subjects.length&&<tr><td colSpan={4+visibleDays}>هنوز فعالیتی ثبت نشده است.</td></tr>}
        </tbody><tfoot><tr><th scope="row">جمع روز</th><td>{analysis.minutes?"۱۰۰٪":"۰٪"}</td><td>{duration(analysis.minutes)}</td><td>{formatNumber(analysis.tests)}</td>{analysis.days.slice(0,visibleDays).map((day,i)=><td key={i}>{day.minutes?duration(day.minutes):"—"}</td>)}</tr></tfoot>
      </table>
    </article>}
    {sections.reviews && <article className={`${styles.page} ${styles.paper}`} data-section="reviews">
      <header className={styles.header}><div><strong>نووا</strong><h2>جدول مرور این هفته</h2></div><div>{student?.full_name||"دانش‌آموز نووا"} · {plan.title}</div></header>
      <p className={styles.description}>پیش از مبحث جدید همان درس، مطالب قبلی را با کتاب و جزوه مرور کن. مرورها برای یک، سه و هفت روز بعد در نظر گرفته شده‌اند.</p>
      {!reviews.length?<p>برای این هفته مروری وجود ندارد.</p>:<div className={styles.reviewColumns}>{Array.from({length:7},(_,day)=>{
        const date=addDays(parseIsoDate(plan.week_start),day),iso=toIsoDate(date),items=reviews.filter(review=>review.date===iso);
        if(!items.length)return null;
        return <section className={styles.reviewDay} key={iso}><h3>{formatPersianFullDate(date)}</h3>{items.map(review=><div className={styles.reviewRow} key={review.key}>
          <span className={styles.box} aria-label={review.checked?"انجام شده":"انجام نشده"}>{review.checked?"✓":""}</span><span><strong>{review.subject}</strong> · {review.chapter||"مبحث آزاد"}{review.topics.length?` · ${review.topics.map(topic=>topic.title).join("، ")}`:""}{review.historical?" (مرور ثبت‌شده از فعالیت تغییرکرده)":""}</span><small>{formatNumber(review.offset)} روز بعد</small>
        </div>)}</section>;
      })}</div>}
    </article>}
  </main>;
}
