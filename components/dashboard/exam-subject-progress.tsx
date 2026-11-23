import { toPersianDigits } from "@/lib/persian-date";

export type SubjectHistoryRow = {
  exam_id: string;
  exam_title: string;
  starts_at: string;
  subject_title: string;
  percentage: number | string;
};

const colors = ["#246789", "#c45c20", "#8056a2", "#288364", "#c2416c", "#8b6b20", "#277a78", "#5264a8"];
const percentage = (value: number) => `${toPersianDigits(value.toLocaleString("fa-IR", { maximumFractionDigits: 2 }))}٪`;
const dateFormatter = new Intl.DateTimeFormat("fa-IR", { year: "2-digit", month: "numeric", day: "numeric", timeZone: "Asia/Tehran" });
const chartY = (value: number) => 18 + ((100 - Math.max(-33.33, Math.min(100, value))) / 133.33) * 90;

/** The server returns at most six results for each subject, ordered oldest first. */
export function ExamSubjectProgress({ rows, unavailable }: { rows: SubjectHistoryRow[]; unavailable: boolean }) {
  const grouped = new Map<string, SubjectHistoryRow[]>();
  for (const row of rows) {
    if (!Number.isFinite(Number(row.percentage)) || !Number.isFinite(Date.parse(row.starts_at))) continue;
    const list = grouped.get(row.subject_title) ?? [];
    list.push(row);
    grouped.set(row.subject_title, list);
  }
  const subjects = Array.from(grouped, ([subject, points]) => ({
    subject,
    points: [...points].sort((a, b) => a.starts_at.localeCompare(b.starts_at) || a.exam_id.localeCompare(b.exam_id)),
  }));
  return <section className="exam-report-chart-card">
    <h2>روند پیشرفت دروس</h2>
    {unavailable ? <p className="exam-progress-message">دریافت روند پیشرفت انجام نشد؛ دوباره تلاش کنید.</p>
      : subjects.length === 0 ? <p className="exam-progress-message">هنوز نتیجهٔ درسی قابل نمایش وجود ندارد.</p>
      : <div className="exam-subject-charts">{subjects.map(({ subject, points }, index) => {
        const color = colors[index % colors.length];
        const x = (i: number) => points.length === 1 ? 170 : 48 + (i * 244) / (points.length - 1);
        const line = points.map((point, i) => `${x(i)},${chartY(Number(point.percentage))}`).join(" ");
        return <article className="exam-subject-chart" key={subject}>
          <div className="exam-subject-chart-heading"><strong><i style={{ background: color }} />{subject}</strong><span>آخرین نتیجه <b style={{ color }}>{percentage(Number(points[points.length - 1].percentage))}</b></span></div>
          <svg viewBox="0 0 320 143" className="exam-subject-chart-svg" role="img" aria-label={`روند پیشرفت ${subject}`}>
            {[100, 50, 0, -33.33].map(tick => <g key={tick}><line x1="36" x2="304" y1={chartY(tick)} y2={chartY(tick)} className={tick === 0 ? "axis-zero" : "grid-line"} /><text x="27" y={chartY(tick) + 3} className="axis-label">{toPersianDigits(tick)}</text></g>)}
            {points.length > 1 && <polyline points={line} className="performance-line" style={{ stroke: color }} />}
            {points.map((point, i) => <g key={point.exam_id}>
              <title>{`${point.exam_title} · ${dateFormatter.format(new Date(point.starts_at))} · ${percentage(Number(point.percentage))}`}</title>
              <circle cx={x(i)} cy={chartY(Number(point.percentage))} r="4.5" className="performance-dot" style={{ stroke: color }} />
              <text x={x(i)} y={chartY(Number(point.percentage)) - 9} className="exam-subject-value" style={{ fill: color }}>{percentage(Number(point.percentage))}</text>
              <text x={x(i)} y="130" className="exam-date-label">{dateFormatter.format(new Date(point.starts_at))}</text>
            </g>)}
          </svg>
        </article>;
      })}</div>}
  </section>;
}
