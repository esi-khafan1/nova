"use client";

import { analyzePlannerWeek } from "@/lib/planner-analysis";
import { reviewsForWeek, type PlannerGrid, type ReviewSource } from "@/lib/planner-grid";
import { addDays, formatPersianWeekday, parseIsoDate, persianMonthNames, persianNumber, persianParts, toIsoDate } from "@/lib/persian-date";
import styles from "./planner-insights.module.css";

const number = (n: number) => persianNumber.format(n);
const decimal = new Intl.NumberFormat("fa-IR", { maximumFractionDigits: 1 });
function duration(minutes: number) {
  const whole = Math.round(minutes);
  return `${number(Math.floor(whole / 60))}:${number(whole % 60).padStart(2, "۰")}`;
}
function dayHeading(weekStart: string, day: number) {
  const date = addDays(parseIsoDate(weekStart), day), parts = persianParts(date);
  return `${formatPersianWeekday(date)} ${number(parts.day)} ${persianMonthNames[parts.month - 1]}`;
}

export function PlannerAnalysis({ weekStart, grid }: { weekStart: string; grid: PlannerGrid }) {
  const data = analyzePlannerWeek(grid);
  return <section className={styles.panel} aria-label="تحلیل برنامهٔ هفته">
    <h2>تحلیل برنامهٔ هفته</h2>
    <div className={styles.stats}>
      <div><span>زمان برنامه‌ریزی‌شده</span><strong>{duration(data.minutes)} ساعت</strong></div>
      <div><span>تعداد تست</span><strong>{number(data.tests)}</strong></div>
      <div><span>تست در ساعت</span><strong>{data.testsPerHour === null ? "—" : decimal.format(data.testsPerHour)}</strong></div>
      <div><span>میانگین روزانه</span><strong>{duration(data.meanDailyMinutes)} ساعت</strong></div>
      <div><span>باکس پر / خالی</span><strong><bdi dir="ltr">{number(data.blocks)} / {number(data.emptySlots)}</bdi></strong></div>
    </div>
    {data.subjects.length === 0 ? <p>هنوز فعالیتی در برنامه نیست.</p> : <div className={styles.tableScroll}>
      <table className={styles.table}>
        <caption>سهم درس‌ها و زمان هر روز (ساعت:دقیقه)</caption>
        <thead><tr><th scope="col">درس</th><th scope="col">سهم هفته</th><th scope="col">کل زمان</th><th scope="col">تست</th>{Array.from({length: 7}, (_, day) => <th key={day} scope="col">{dayHeading(weekStart, day)}</th>)}</tr></thead>
        <tbody>{data.subjects.map(row => <tr key={row.subject}>
          <th scope="row">{row.subject}</th><td><div className={styles.barLabel}>{decimal.format(row.percent)}٪</div><div className={styles.bar}><span style={{width:`${row.percent}%`}} /></div></td>
          <td>{duration(row.minutes)}</td><td>{number(row.tests)}</td>{row.days.map((minutes, day) => <td key={day}>{minutes ? duration(minutes) : "—"}</td>)}
        </tr>)}</tbody>
        <tfoot><tr><th scope="row">جمع روز</th><td>{data.minutes ? "۱۰۰٪" : "۰٪"}</td><td>{duration(data.minutes)}</td><td>{number(data.tests)}</td>{data.days.map((day, index) => <td key={index}>{day.minutes ? duration(day.minutes) : "—"}</td>)}</tr></tfoot>
      </table>
    </div>}
  </section>;
}

export function PlannerReviews({weekStart, sources, completed, onToggle}: {
  weekStart: string;
  sources: ReviewSource[];
  completed: ReadonlySet<string>;
  onToggle: (key: string, checked: boolean) => void;
}) {
  const reviews = reviewsForWeek(weekStart, sources);
  return <section className={styles.panel} aria-label="جدول مرور این هفته">
    <h2>جدول مرور این هفته <small>({number(reviews.length)} مرور)</small></h2>
    <p>پیش از مطالعهٔ مبحث جدید همان درس، مطالب قبلی را با کتاب و جزوه مرور کن.</p>
    {reviews.length === 0 ? <p>برای این هفته مروری وجود ندارد.</p> : <div className={styles.reviewDays}>
      {Array.from({length: 7}, (_, day) => {
        const date = addDays(parseIsoDate(weekStart), day);
        const iso = toIsoDate(date);
        const daily = reviews.filter(review => review.date === iso);
        if (!daily.length) return null;
        return <section className={styles.reviewDay} key={iso}>
          <h3>{dayHeading(weekStart, day)}</h3>
          {daily.map(review => <label className={styles.review} key={review.key}>
            <input type="checkbox" checked={completed.has(review.key)} onChange={event => onToggle(review.key, event.target.checked)} />
            <span><strong>{review.subject}</strong> · {review.chapter || "مبحث آزاد"}{review.topics.length ? ` · ${review.topics.map(topic => topic.title).join("، ")}` : ""}</span>
            <small>مرور {number(review.offset)} روز بعد</small>
          </label>)}
        </section>;
      })}
    </div>}
  </section>;
}
