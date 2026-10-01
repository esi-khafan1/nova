"use client";

import { useState } from "react";
import type { ProgressScope } from "@/lib/progress";

const faNumber = (value: number) => value.toLocaleString("fa-IR");

function formatDuration(minutes: number) {
  if (minutes < 60) return `${faNumber(minutes)} دقیقه`;
  return `${(minutes / 60).toLocaleString("fa-IR", {
    maximumFractionDigits: 1,
  })} ساعت`;
}

export function StudentProgressSummary({
  scopes,
  title = "مطالعه‌های انجام‌شده",
  eyebrow = "گزارش پیشرفت",
}: {
  scopes: ProgressScope[];
  title?: string;
  eyebrow?: string;
}) {
  const [activeKey, setActiveKey] = useState<ProgressScope["key"]>("weekly");
  const [metric, setMetric] = useState<"time" | "tests">("time");
  const [selectedSubject, setSelectedSubject] = useState("");
  const active = scopes.find((scope) => scope.key === activeKey) ?? scopes[0];
  const subject =
    active.subjects.find((item) => item.subject === selectedSubject) ??
    active.subjects[0];

  return (
    <section className="student-progress portal-card">
      <header>
        <div>
          <span>{eyebrow}</span>
          <h2>{title}</h2>
        </div>
        <div className="progress-tabs" role="tablist" aria-label="بازه گزارش">
          {scopes.map((scope) => (
            <button
              type="button"
              role="tab"
              aria-selected={scope.key === activeKey}
              className={scope.key === activeKey ? "active" : ""}
              key={scope.key}
              onClick={() => {
                setActiveKey(scope.key);
                setSelectedSubject("");
              }}
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
          <strong>{formatDuration(active.totalMinutes)}</strong>
        </article>
        <article>
          <span>تست هدف</span>
          <strong>{faNumber(active.targetTests)}</strong>
        </article>
        <article>
          <span>تست انجام‌شده</span>
          <strong>{faNumber(active.completedTests)}</strong>
        </article>
      </div>

      {subject ? (
        <div className="chapter-progress-report">
          <div className="progress-report-controls">
            <label>
              درس
              <select
                value={subject.subject}
                onChange={(event) => setSelectedSubject(event.target.value)}
              >
                {active.subjects.map((item) => (
                  <option key={item.subject} value={item.subject}>
                    {item.subject}
                  </option>
                ))}
              </select>
            </label>
            <div className="progress-metric-tabs" aria-label="معیار نمودار">
              <button
                type="button"
                className={metric === "time" ? "active" : ""}
                onClick={() => setMetric("time")}
              >
                زمان مطالعه
              </button>
              <button
                type="button"
                className={metric === "tests" ? "active" : ""}
                onClick={() => setMetric("tests")}
              >
                تعداد تست
              </button>
            </div>
          </div>

          <div className="chapter-chart-legend">
            {metric === "time" ? (
              <>
                <span className="study-key">مطالعه و مرور</span>
                <span className="test-key">تست و آزمون</span>
                <span className="remaining-key">باقی‌مانده</span>
              </>
            ) : (
              <>
                <span className="test-key">تست انجام‌شده</span>
                <span className="remaining-key">باقی‌مانده تا هدف</span>
              </>
            )}
          </div>

          <div className="chapter-chart-rows">
            {subject.chapters.map((chapter) => {
              const target =
                metric === "time"
                  ? chapter.plannedMinutes
                  : chapter.targetTests;
              const completed =
                metric === "time"
                  ? chapter.completedMinutes
                  : chapter.completedTests;
              const rate = target ? Math.round((completed / target) * 100) : 0;
              const monthlyValues =
                metric === "time"
                  ? chapter.monthlyMinutes
                  : chapter.monthlyTests;
              const monthlyMaximum = Math.max(1, ...monthlyValues);
              return (
                <div className="chapter-chart-row" key={chapter.chapter}>
                  <div className="chapter-chart-title">
                    <strong>{chapter.chapter}</strong>
                    <span>{faNumber(rate)}٪</span>
                  </div>
                  <div className="chapter-chart-track">
                    {metric === "time" ? (
                      <>
                        <span
                          className="study-segment"
                          style={{
                            width: `${Math.min(
                              100,
                              target
                                ? (chapter.studyMinutes / target) * 100
                                : 0,
                            )}%`,
                          }}
                        />
                        <span
                          className="test-segment"
                          style={{
                            width: `${Math.min(
                              Math.max(
                                0,
                                100 -
                                  (chapter.studyMinutes / Math.max(1, target)) *
                                    100,
                              ),
                              target ? (chapter.testMinutes / target) * 100 : 0,
                            )}%`,
                          }}
                        />
                      </>
                    ) : (
                      <span
                        className="test-segment"
                        style={{ width: `${Math.min(100, rate)}%` }}
                      />
                    )}
                  </div>
                  <div className="chapter-chart-meta">
                    <span>
                      {metric === "time"
                        ? `${formatDuration(completed)} از ${formatDuration(target)}`
                        : `${faNumber(completed)} از ${faNumber(target)} تست`}
                    </span>
                    {metric === "tests" && completed > target && target > 0 && (
                      <strong>
                        {faNumber(completed - target)} تست بیشتر از هدف
                      </strong>
                    )}
                  </div>
                  {active.key === "monthly" && (
                    <div
                      className="chapter-monthly-trend"
                      aria-label="روند پنج هفته ماه"
                    >
                      {monthlyValues.map((value, index) => (
                        <span key={index}>
                          <i
                            style={{
                              height: `${(value / monthlyMaximum) * 100}%`,
                            }}
                          />
                          <small>هفته {faNumber(index + 1)}</small>
                        </span>
                      ))}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      ) : (
        <p className="progress-empty">
          هنوز فعالیتی برای محاسبه پیشرفت این بازه وجود ندارد.
        </p>
      )}
    </section>
  );
}
