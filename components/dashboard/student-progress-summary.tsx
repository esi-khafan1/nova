"use client";

import { useState } from "react";

export type ProgressScope = {
  key: "weekly" | "monthly" | "all";
  label: string;
  completedCount: number;
  totalMinutes: number;
  studyMinutes: number;
  testMinutes: number;
  subjects: {
    subject: string;
    minutes: number;
    chapters: string[];
  }[];
};

const faNumber = (value: number) => value.toLocaleString("fa-IR");

export function StudentProgressSummary({
  scopes,
}: {
  scopes: ProgressScope[];
}) {
  const [activeKey, setActiveKey] = useState<ProgressScope["key"]>("weekly");
  const active = scopes.find((scope) => scope.key === activeKey) ?? scopes[0];

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
        <div className="progress-subjects">
          {active.subjects.map((subject) => (
            <article key={subject.subject}>
              <div>
                <strong>{subject.subject}</strong>
                <span>{faNumber(subject.minutes)} دقیقه</span>
              </div>
              <p>{subject.chapters.join("، ") || "مبحث آزاد"}</p>
            </article>
          ))}
        </div>
      ) : (
        <p className="progress-empty">
          هنوز فعالیت انجام‌شده‌ای در این بازه ثبت نشده است.
        </p>
      )}
    </section>
  );
}