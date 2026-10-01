"use client";

import { useMemo, useState } from "react";

export type ProgressScope = {
  key: "weekly" | "monthly" | "all";
  label: string;
  completedCount: number;
  totalMinutes: number;
  studyMinutes: number;
  testMinutes: number;
  subjects: {
    subject: string;
    plannedMinutes: number;
    completedMinutes: number;
    completionRate: number;
    shareOfCompleted: number;
    monthlyMinutes: number[];
  }[];
};

const faNumber = (value: number) => value.toLocaleString("fa-IR");

function formatDuration(minutes: number) {
  if (minutes < 60) return `${faNumber(minutes)} دقیقه`;
  const hours = minutes / 60;
  return `${hours.toLocaleString("fa-IR", {
    maximumFractionDigits: 1,
  })} ساعت`;
}

export function StudentProgressSummary({
  scopes,
}: {
  scopes: ProgressScope[];
}) {
  const [activeKey, setActiveKey] = useState<ProgressScope["key"]>("weekly");
  const active = scopes.find((scope) => scope.key === activeKey) ?? scopes[0];
  const visibleSubjects = active.subjects.slice(0, 6);

  const monthlyChart = useMemo(() => {
    const weeks = Array.from({ length: 5 }, (_, weekIndex) => ({
      label: `هفته ${faNumber(weekIndex + 1)}`,
      subjects: visibleSubjects.map((subject) => ({
        subject: subject.subject,
        minutes: subject.monthlyMinutes[weekIndex] ?? 0,
      })),
    }));
    const maximum = Math.max(
      1,
      ...weeks.map((week) =>
        week.subjects.reduce((sum, subject) => sum + subject.minutes, 0),
      ),
    );
    return { weeks, maximum };
  }, [visibleSubjects]);

  return (
    <section className="student-progress portal-card">
      <header>
        <div>
          <span>گزارش پیشرفت</span>
          <h2>مطالعه‌های انجام‌شده</h2>
        </div>
        <div className="progress-tabs" role="tablist" aria-label="بازه گزارش">
          {scopes.map((scope) => (
            <button
              type="button"
              role="tab"
              aria-selected={scope.key === activeKey}
              className={scope.key === activeKey ? "active" : ""}
              key={scope.key}
              onClick={() => setActiveKey(scope.key)}
            >
              {scope.label}
            </button>
          ))}
        </div>
      </header>

      <div className="progress-stats">
        <article>
          <span>فعالیت انجام‌شده</span>
          <strong>{faNumber(active.completedCount)}</strong>
        </article>
        <article>
          <span>مجموع زمان</span>
          <strong>{faNumber(active.totalMinutes)} دقیقه</strong>
        </article>
        <article>
          <span>مطالعه و مرور</span>
          <strong>{faNumber(active.studyMinutes)} دقیقه</strong>
        </article>
        <article>
          <span>تست‌زنی</span>
          <strong>{faNumber(active.testMinutes)} دقیقه</strong>
        </article>
      </div>

      {active.subjects.length ? (
        <>
          <div className="subject-progress-chart">
            <div className="progress-chart-heading">
              <div>
                <span>عملکرد درس‌ها</span>
                <h3>
                  {active.key === "all"
                    ? "پایبندی بلندمدت به برنامه"
                    : "انجام‌شده در برابر برنامه‌ریزی‌شده"}
                </h3>
              </div>
              <small>نارنجی: انجام‌شده · کرم: باقی‌مانده</small>
            </div>

            <div className="subject-chart-rows">
              {visibleSubjects.map((subject) => (
                <div className="subject-chart-row" key={subject.subject}>
                  <div className="subject-chart-label">
                    <strong>{subject.subject}</strong>
                    <span>{faNumber(subject.completionRate)}٪</span>
                  </div>
                  <div
                    className="subject-chart-track"
                    role="img"
                    aria-label={`${subject.subject}: ${formatDuration(
                      subject.completedMinutes,
                    )} انجام‌شده از ${formatDuration(
                      subject.plannedMinutes,
                    )} برنامه‌ریزی‌شده`}
                  >
                    <span
                      style={{
                        width: `${Math.min(100, subject.completionRate)}%`,
                      }}
                    />
                  </div>
                  <div className="subject-chart-meta">
                    <span>
                      {formatDuration(subject.completedMinutes)} از{" "}
                      {formatDuration(subject.plannedMinutes)}
                    </span>
                    {active.key === "all" && (
                      <strong>
                        {faNumber(subject.shareOfCompleted)}٪ از کل مطالعه
                      </strong>
                    )}
                  </div>
                </div>
              ))}
            </div>
            {active.subjects.length > visibleSubjects.length && (
              <p className="subject-chart-more">
                {faNumber(active.subjects.length - visibleSubjects.length)} درس
                دیگر نیز در محاسبات گزارش لحاظ شده‌اند.
              </p>
            )}
          </div>

          {active.key === "monthly" && (
            <div className="monthly-subject-chart">
              <div className="progress-chart-heading">
                <div>
                  <span>روند ماهانه</span>
                  <h3>زمان انجام‌شده هر درس در هفته‌های ماه</h3>
                </div>
              </div>
              <div
                className="monthly-chart-plot"
                role="img"
                aria-label="نمودار زمان انجام‌شده درس‌ها در پنج هفته ماه"
              >
                {monthlyChart.weeks.map((week) => {
                  const total = week.subjects.reduce(
                    (sum, subject) => sum + subject.minutes,
                    0,
                  );
                  return (
                    <div className="monthly-week-column" key={week.label}>
                      <strong>{formatDuration(total)}</strong>
                      <div className="monthly-stack">
                        <div
                          className="monthly-stack-total"
                          style={{
                            height: `${Math.max(
                              total ? 8 : 0,
                              (total / monthlyChart.maximum) * 100,
                            )}%`,
                          }}
                        >
                          {week.subjects.map(
                            (subject, subjectIndex) =>
                              subject.minutes > 0 && (
                                <span
                                  className={`subject-color-${subjectIndex + 1}`}
                                  key={subject.subject}
                                  style={{
                                    height: `${(subject.minutes / total) * 100}%`,
                                  }}
                                  title={`${subject.subject}: ${formatDuration(
                                    subject.minutes,
                                  )}`}
                                />
                              ),
                          )}
                        </div>
                      </div>
                      <span>{week.label}</span>
                    </div>
                  );
                })}
              </div>
              <div className="monthly-chart-legend">
                {visibleSubjects.map((subject, index) => (
                  <span key={subject.subject}>
                    <i className={`subject-color-${index + 1}`} />
                    {subject.subject}
                  </span>
                ))}
              </div>
            </div>
          )}
        </>
      ) : (
        <p className="progress-empty">
          هنوز فعالیتی برای محاسبه پیشرفت این بازه وجود ندارد.
        </p>
      )}
    </section>
  );
}
