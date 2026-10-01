"use client";

import { useMemo, useState } from "react";
import { saveWeeklyPlan } from "@/app/dashboard/actions";
import { PersianDatePicker } from "@/components/dashboard/persian-date-picker";
import {
  activityTypes,
  studyCatalog,
  studyFieldLabels,
  weekDays,
  type StudyField,
} from "@/lib/study-catalog";

type Student = {
  student_id: string;
  full_name: string;
  grade: number | null;
  study_field: StudyField | null;
};

type PlanItem = {
  id?: string;
  key: string;
  dayOfWeek: number;
  durationMinutes: number;
  subject: string;
  chapter: string;
  activityType: (typeof activityTypes)[number]["value"];
  details: string;
};

export type CounselorWeeklyPlan = {
  id: string;
  student_id: string;
  week_start: string;
  title: string;
  notes: string | null;
  status: "draft" | "published";
  weekly_plan_items: Array<{
    id: string;
    day_of_week: number;
    duration_minutes: number;
    subject: string;
    chapter: string | null;
    activity_type: PlanItem["activityType"];
    details: string | null;
    sort_order: number;
  }>;
};

const newItem = (
  dayOfWeek = 0,
  key = `${Date.now()}-${Math.random()}`,
): PlanItem => ({
  key,
  dayOfWeek,
  durationMinutes: 90,
  subject: "",
  chapter: "",
  activityType: "lesson",
  details: "",
});

const faNumber = (value: number) => value.toLocaleString("fa-IR");

function toIsoDate(date: Date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function currentWeekSaturday() {
  const date = new Date();
  date.setHours(12, 0, 0, 0);
  date.setDate(date.getDate() - ((date.getDay() + 1) % 7));
  return toIsoDate(date);
}

function dayDate(weekStart: string, dayIndex: number) {
  const [year, month, day] = weekStart.split("-").map(Number);
  const date = new Date(year, month - 1, day, 12);
  date.setDate(date.getDate() + dayIndex);
  return date;
}

function isPastDay(weekStart: string, dayIndex: number) {
  const today = new Date();
  today.setHours(12, 0, 0, 0);
  return dayDate(weekStart, dayIndex) < today;
}

function isTodayOrPast(weekStart: string, dayIndex: number) {
  const today = new Date();
  today.setHours(12, 0, 0, 0);
  return dayDate(weekStart, dayIndex) <= today;
}

function firstAvailableDay(weekStart: string) {
  return weekDays.findIndex((_, index) => !isPastDay(weekStart, index));
}

function planItems(plan: CounselorWeeklyPlan): PlanItem[] {
  return [...plan.weekly_plan_items]
    .sort(
      (first, second) =>
        first.day_of_week - second.day_of_week ||
        first.sort_order - second.sort_order,
    )
    .map((item) => ({
      id: item.id,
      key: item.id,
      dayOfWeek: item.day_of_week,
      durationMinutes: item.duration_minutes,
      subject: item.subject,
      chapter: item.chapter ?? "",
      activityType: item.activity_type,
      details: item.details ?? "",
    }));
}

export function WeeklyPlanBuilder({
  students,
  plans,
}: {
  students: Student[];
  plans: CounselorWeeklyPlan[];
}) {
  const [studentIndex, setStudentIndex] = useState(0);
  const [weekStart, setWeekStart] = useState(currentWeekSaturday);
  const initialPlan = plans.find(
    (plan) =>
      plan.student_id === students[0]?.student_id &&
      plan.week_start === currentWeekSaturday(),
  );
  const [planId, setPlanId] = useState(initialPlan?.id ?? "");
  const [planStatus, setPlanStatus] = useState<"draft" | "published" | null>(
    initialPlan?.status ?? null,
  );
  const [title, setTitle] = useState(initialPlan?.title ?? "برنامه هفتگی");
  const [notes, setNotes] = useState(initialPlan?.notes ?? "");
  const [items, setItems] = useState<PlanItem[]>(() => [
    ...(initialPlan
      ? planItems(initialPlan)
      : [newItem(firstAvailableDay(currentWeekSaturday()), "initial-item")]),
  ]);

  const student = students[studentIndex] ?? students[0];
  const books = useMemo(() => {
    if (!student?.study_field || !student.grade) return [];
    return (
      studyCatalog[student.study_field][student.grade as 10 | 11 | 12] ?? []
    );
  }, [student]);

  const chapters = (subject: string) =>
    books.find((book) => book.subject === subject)?.chapters ?? [];

  const loadPlan = (studentId: string, nextWeek: string) => {
    const plan = plans.find(
      (item) => item.student_id === studentId && item.week_start === nextWeek,
    );
    setPlanId(plan?.id ?? "");
    setPlanStatus(plan?.status ?? null);
    setTitle(plan?.title ?? "برنامه هفتگی");
    setNotes(plan?.notes ?? "");
    setItems(
      plan
        ? planItems(plan)
        : [newItem(firstAvailableDay(nextWeek), `week-${nextWeek}`)],
    );
  };

  const plannedWeeks = Object.fromEntries(
    plans
      .filter((plan) => plan.student_id === student?.student_id)
      .map((plan) => [plan.week_start, plan.status]),
  );

  const isLockedDay = (dayIndex: number) =>
    planStatus === "published"
      ? isTodayOrPast(weekStart, dayIndex)
      : isPastDay(weekStart, dayIndex);

  const editableItems = items.filter((item) => !isLockedDay(item.dayOfWeek));

  const updateItem = <K extends keyof PlanItem>(
    key: string,
    property: K,
    value: PlanItem[K],
  ) =>
    setItems((current) =>
      current.map((item) =>
        item.key === key ? { ...item, [property]: value } : item,
      ),
    );

  if (!students.length) {
    return (
      <section className="portal-card portal-empty plan-empty">
        <div className="portal-empty-icon">✦</div>
        <h2>اول یک دانش‌آموز انتخاب کن</h2>
        <p>
          از فهرست دانش‌آموزان، یک نفر را به لیست مشاوره‌ات اضافه کن تا بتوانی
          برنامه هفتگی او را بسازی.
        </p>
      </section>
    );
  }

  return (
    <form action={saveWeeklyPlan} className="weekly-builder">
      <section className="portal-card plan-basics">
        <div className="portal-card-title">
          <div>
            <span>تنظیمات برنامه</span>
            <h2>برنامه برای چه هفته‌ای است؟</h2>
          </div>
        </div>
        <div className="plan-basics-grid">
          <label>
            دانش‌آموز
            <select
              name="student_id"
              value={student?.student_id ?? ""}
              onChange={(event) => {
                const nextIndex = students.findIndex(
                  (item) => item.student_id === event.target.value,
                );
                setStudentIndex(nextIndex >= 0 ? nextIndex : 0);
                loadPlan(event.target.value, weekStart);
              }}
              required
            >
              {students.map((item) => (
                <option key={item.student_id} value={item.student_id}>
                  {item.full_name || "دانش‌آموز نووا"}
                </option>
              ))}
            </select>
          </label>
          <label>
            شروع هفته
            <PersianDatePicker
              name="week_start"
              value={weekStart}
              plannedWeeks={plannedWeeks}
              onChange={(nextWeek) => {
                setWeekStart(nextWeek);
                loadPlan(student.student_id, nextWeek);
              }}
            />
          </label>
          <label>
            عنوان برنامه
            <input
              name="title"
              value={title}
              onChange={(event) => setTitle(event.target.value)}
              maxLength={120}
              required
            />
          </label>
        </div>
        <div className="student-study-meta">
          <span>
            پایه:{" "}
            {student?.grade ? `پایه ${faNumber(student.grade)}` : "ثبت نشده"}
          </span>
          <span>
            رشته:{" "}
            {student?.study_field
              ? studyFieldLabels[student.study_field]
              : "ثبت نشده"}
          </span>
          {!books.length && (
            <strong>
              برای پیشنهاد درس و فصل، دانش‌آموز باید پایه و رشته‌اش را در
              پروفایل ثبت کند.
            </strong>
          )}
        </div>
        {planStatus && (
          <div className={`plan-edit-notice ${planStatus}`}>
            <strong>
              {planStatus === "published"
                ? "این هفته قبلاً منتشر شده است."
                : "برای این هفته یک پیش‌نویس داری."}
            </strong>
            <span>
              {planStatus === "published"
                ? "حالت تغییر برنامه فعال است؛ امروز و روزهای گذشته ثابت می‌مانند و فقط روزهای آینده با انتشار مجدد تغییر می‌کنند."
                : "اطلاعات پیش‌نویس بارگذاری شد و می‌توانی ادامه‌اش بدهی."}
            </span>
          </div>
        )}
      </section>

      <div className="weekly-days">
        {weekDays.map((day, dayIndex) => {
          const dayIsLocked = isLockedDay(dayIndex);
          const dayItems = items.filter((item) => item.dayOfWeek === dayIndex);
          return (
            <section
              className={`portal-card plan-day${dayIsLocked ? " past" : ""}`}
              key={day}
            >
              <header>
                <div>
                  <span>روز {faNumber(dayIndex + 1)}</span>
                  <h2>{day}</h2>
                </div>
                {!dayIsLocked && (
                  <button
                    type="button"
                    className="plan-add"
                    onClick={() =>
                      setItems((current) => [...current, newItem(dayIndex)])
                    }
                  >
                    + افزودن فعالیت
                  </button>
                )}
              </header>

              {dayIsLocked ? (
                <div className="plan-locked-day">
                  <p className="plan-day-empty">
                    {planStatus === "published" &&
                    !isPastDay(weekStart, dayIndex)
                      ? "برنامه امروز منتشر شده و دیگر قابل تغییر نیست."
                      : "این روز گذشته و دیگر قابل تغییر نیست."}
                  </p>
                  {dayItems.map((item) => (
                    <article className="plan-item-readonly" key={item.key}>
                      <strong>{item.subject}</strong>
                      <span>
                        {item.chapter || "بدون مبحث"} ·{" "}
                        {faNumber(item.durationMinutes)} دقیقه
                      </span>
                      {item.details && <small>{item.details}</small>}
                    </article>
                  ))}
                </div>
              ) : dayItems.length === 0 ? (
                <p className="plan-day-empty">برای این روز فعالیتی ثبت نشده.</p>
              ) : (
                <div className="plan-item-list">
                  {dayItems.map((item, index) => (
                    <article className="plan-item-editor" key={item.key}>
                      <div className="plan-item-number">
                        {faNumber(index + 1)}
                      </div>
                      <div className="plan-item-fields">
                        <label>
                          مدت (دقیقه)
                          <select
                            value={item.durationMinutes}
                            onChange={(event) =>
                              updateItem(
                                item.key,
                                "durationMinutes",
                                Number(event.target.value),
                              )
                            }
                          >
                            {[30, 45, 60, 75, 90, 120, 150, 180].map(
                              (duration) => (
                                <option key={duration} value={duration}>
                                  {faNumber(duration)} دقیقه
                                </option>
                              ),
                            )}
                          </select>
                        </label>
                        <label>
                          درس
                          {books.length ? (
                            <select
                              value={item.subject}
                              onChange={(event) => {
                                updateItem(
                                  item.key,
                                  "subject",
                                  event.target.value,
                                );
                                updateItem(item.key, "chapter", "");
                              }}
                              required
                            >
                              <option value="">انتخاب درس</option>
                              {books.map((book) => (
                                <option key={book.subject} value={book.subject}>
                                  {book.subject}
                                </option>
                              ))}
                            </select>
                          ) : (
                            <input
                              value={item.subject}
                              onChange={(event) =>
                                updateItem(
                                  item.key,
                                  "subject",
                                  event.target.value,
                                )
                              }
                              placeholder="نام درس را وارد کن"
                              maxLength={100}
                              required
                            />
                          )}
                        </label>
                        <label>
                          فصل یا مبحث
                          {books.length ? (
                            <select
                              value={item.chapter}
                              onChange={(event) =>
                                updateItem(
                                  item.key,
                                  "chapter",
                                  event.target.value,
                                )
                              }
                              disabled={!item.subject}
                            >
                              <option value="">
                                {item.subject
                                  ? "انتخاب فصل یا مبحث"
                                  : "ابتدا درس را انتخاب کن"}
                              </option>
                              {chapters(item.subject).map((chapter) => (
                                <option key={chapter} value={chapter}>
                                  {chapter}
                                </option>
                              ))}
                            </select>
                          ) : (
                            <input
                              value={item.chapter}
                              onChange={(event) =>
                                updateItem(
                                  item.key,
                                  "chapter",
                                  event.target.value,
                                )
                              }
                              placeholder="فصل یا مبحث را وارد کن"
                              maxLength={160}
                            />
                          )}
                        </label>
                        <label>
                          نوع فعالیت
                          <select
                            value={item.activityType}
                            onChange={(event) =>
                              updateItem(
                                item.key,
                                "activityType",
                                event.target.value as PlanItem["activityType"],
                              )
                            }
                          >
                            {activityTypes.map((activity) => (
                              <option
                                key={activity.value}
                                value={activity.value}
                              >
                                {activity.label}
                              </option>
                            ))}
                          </select>
                        </label>
                        <label className="plan-details">
                          توضیح تکمیلی
                          <input
                            value={item.details}
                            onChange={(event) =>
                              updateItem(
                                item.key,
                                "details",
                                event.target.value,
                              )
                            }
                            placeholder="مثلاً ۳۰ تست زمان‌دار و تحلیل پاسخ‌ها"
                            maxLength={500}
                          />
                        </label>
                      </div>
                      <button
                        type="button"
                        className="plan-remove"
                        aria-label="حذف فعالیت"
                        onClick={() =>
                          setItems((current) =>
                            current.filter(
                              (currentItem) => currentItem.key !== item.key,
                            ),
                          )
                        }
                      >
                        حذف
                      </button>
                    </article>
                  ))}
                </div>
              )}
            </section>
          );
        })}
      </div>

      <section className="portal-card plan-publish">
        <input type="hidden" name="plan_id" value={planId} />
        <label>
          یادداشت کلی برای دانش‌آموز
          <textarea
            name="notes"
            rows={4}
            maxLength={2000}
            value={notes}
            onChange={(event) => setNotes(event.target.value)}
            placeholder="هدف هفته، نکات اجرایی یا روتین ثابت را بنویس..."
          />
        </label>
        <input
          type="hidden"
          name="items"
          value={JSON.stringify(
            editableItems.map((item) => ({
              dayOfWeek: item.dayOfWeek,
              durationMinutes: item.durationMinutes,
              subject: item.subject,
              chapter: item.chapter,
              activityType: item.activityType,
              details: item.details,
            })),
          )}
        />
        <div>
          {planStatus !== "published" && (
            <button
              className="button button-secondary"
              name="status"
              value="draft"
              disabled={!editableItems.length}
            >
              ذخیره پیش‌نویس
            </button>
          )}
          <button
            className="button"
            name="status"
            value="published"
            disabled={!editableItems.length && !planId}
          >
            {planStatus === "published"
              ? "انتشار دوباره تغییرات"
              : "انتشار برای دانش‌آموز"}
          </button>
        </div>
      </section>
    </form>
  );
}
