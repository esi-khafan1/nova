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
  key: string;
  dayOfWeek: number;
  durationMinutes: number;
  subject: string;
  chapter: string;
  activityType: (typeof activityTypes)[number]["value"];
  details: string;
};

const newItem = (dayOfWeek = 0, key = `${Date.now()}-${Math.random()}`): PlanItem => ({
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

function firstAvailableDay(weekStart: string) {
  return weekDays.findIndex((_, index) => !isPastDay(weekStart, index));
}

export function WeeklyPlanBuilder({ students }: { students: Student[] }) {
  const [studentIndex, setStudentIndex] = useState(0);
  const [weekStart, setWeekStart] = useState(currentWeekSaturday);
  const [items, setItems] = useState<PlanItem[]>(() => [
    newItem(firstAvailableDay(currentWeekSaturday()), "initial-item"),
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
              onChange={(nextWeek) => {
                setWeekStart(nextWeek);
                setItems([
                  newItem(firstAvailableDay(nextWeek), `week-${nextWeek}`),
                ]);
              }}
            />
          </label>
          <label>
            عنوان برنامه
            <input
              name="title"
              defaultValue="برنامه هفتگی"
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
      </section>

      <div className="weekly-days">
        {weekDays.map((day, dayIndex) => {
          const dayHasPassed = isPastDay(weekStart, dayIndex);
          const dayItems = items.filter(
            (item) => item.dayOfWeek === dayIndex,
          );
          return (
            <section
              className={`portal-card plan-day${dayHasPassed ? " past" : ""}`}
              key={day}
            >
              <header>
                <div>
                  <span>روز {faNumber(dayIndex + 1)}</span>
                  <h2>{day}</h2>
                </div>
                {!dayHasPassed && (
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

              {dayHasPassed ? (
                <p className="plan-day-empty">
                  این روز گذشته و دیگر قابل برنامه‌ریزی نیست.
                </p>
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
                          <textarea
                            rows={2}
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
        <label>
          یادداشت کلی برای دانش‌آموز
          <textarea
            name="notes"
            rows={4}
            maxLength={2000}
            placeholder="هدف هفته، نکات اجرایی یا روتین ثابت را بنویس..."
          />
        </label>
        <input
          type="hidden"
          name="items"
          value={JSON.stringify(
            items.map((item) => ({
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
          <button className="button button-secondary" name="status" value="draft">
            ذخیره پیش‌نویس
          </button>
          <button className="button" name="status" value="published">
            انتشار برای دانش‌آموز
          </button>
        </div>
      </section>
    </form>
  );
}