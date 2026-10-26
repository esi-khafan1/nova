"use client";

import { CounselorStudentStudyEditor } from "@/components/dashboard/counselor-student-study-editor";
import { useState } from "react";
import { dayIso, tehranToday, overlapsWindow } from "@/lib/student-planning";
import { formatPersianFullDate, formatPersianWeekday, parseIsoDate } from "@/lib/persian-date";
import { saveWeeklyPlan } from "@/app/dashboard/actions";
import { PersianDatePicker } from "@/components/dashboard/persian-date-picker";
import {
  activityTypes,
  studyFieldLabels,
  weekDays,
  type StudyField,
} from "@/lib/study-catalog";

import { planningGrades, curriculumBooks, inferItemGrade, routineSubjectOptions, type Grade, type PreparationTrack } from "@/lib/planning-curriculum";

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
  targetTestCount: number | null;
  details: string;
  sourceGrade: Grade|null;
  preparationTrack: PreparationTrack;
};

export type PlanRoutine = {
  dayOfWeek: number;
  subject: string;
  details: string;
};

export type CounselorWeeklyPlan = {
  id: string;
  student_id: string;
  week_start: string;
  title: string;
  notes: string | null;
  status: "draft" | "published";
  routines?: PlanRoutine[];
  weekly_plan_items: Array<{
    id: string;
    day_of_week: number;
    duration_minutes: number;
    subject: string;
    chapter: string | null;
    activity_type: PlanItem["activityType"];
    target_test_count: number | null;
    details: string | null;
    sort_order: number;
    source_grade?:Grade|null;
    preparation_track?:PreparationTrack;
    exam_year?:number|null;
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
  targetTestCount: null,
  details: "",
  sourceGrade:null,
  preparationTrack:"konkur",
});

const defaultRoutines = (): PlanRoutine[] =>
  weekDays.map((_, dayOfWeek) => ({ dayOfWeek, subject: "", details: "" }));

const planRoutines = (plan?: CounselorWeeklyPlan | null): PlanRoutine[] => {
  const source = Array.isArray(plan?.routines) ? plan!.routines : [];
  return defaultRoutines().map((routine) => {
    const match = source.find((item) => Number(item?.dayOfWeek) === routine.dayOfWeek);
    return {
      dayOfWeek: routine.dayOfWeek,
      subject: typeof match?.subject === "string" ? match.subject : "",
      details: typeof match?.details === "string" ? match.details : "",
    };
  });
};

const faNumber = (value: number) => value.toLocaleString("fa-IR");

function dayDate(weekStart:string,dayIndex:number){return parseIsoDate(dayIso(weekStart,dayIndex));}
function isPastDay(start:string,offset:number){return dayIso(start,offset)<tehranToday();}
function isTodayOrPast(start:string,offset:number){return dayIso(start,offset)<=tehranToday();}
function firstAvailableDay(start:string){return Math.max(0,weekDays.findIndex((_,i)=>!isPastDay(start,i)));}
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
      targetTestCount: item.target_test_count,
      details: item.details ?? "",
      sourceGrade:item.source_grade??null,
      preparationTrack:item.preparation_track??"konkur",
    }));
}

export function WeeklyPlanBuilder({
  students,
  plans,
  initialStudentId,
}: {
  students: Student[];
  plans: CounselorWeeklyPlan[];
  initialStudentId?:string;
}) {
  const [studentIndex, setStudentIndex] = useState(Math.max(0,students.findIndex(s=>s.student_id===initialStudentId)));
  const [weekStart, setWeekStart] = useState(tehranToday);
  const initialPlan = plans.find(
    (plan) =>
      plan.student_id === students[Math.max(0,students.findIndex(s=>s.student_id===initialStudentId))]?.student_id &&
      plan.week_start === tehranToday(),
  );
  const [planId, setPlanId] = useState(initialPlan?.id ?? "");
  const [planStatus, setPlanStatus] = useState<"draft" | "published" | null>(
    initialPlan?.status ?? null,
  );
  const [title, setTitle] = useState(initialPlan?.title ?? "برنامه هفتگی");
  const [notes, setNotes] = useState(initialPlan?.notes ?? "");
  const [routines, setRoutines] = useState<PlanRoutine[]>(() => planRoutines(initialPlan));
  const [items, setItems] = useState<PlanItem[]>(() => [
    ...(initialPlan
      ? planItems(initialPlan)
      : [newItem(firstAvailableDay(tehranToday()), "initial-item")]),
  ]);

  const student = students[studentIndex] ?? students[0];
  const itemGrade=(item:PlanItem):Grade=>item.sourceGrade??inferItemGrade({subject:item.subject,source_grade:null},student?.study_field??null,student?.grade??null)??([10,11,12].includes(student?.grade??0)?student.grade as Grade:10);
  const itemBooks=(item:PlanItem)=>curriculumBooks(student?.study_field??null,itemGrade(item),item.preparationTrack);
  const chapters=(item:PlanItem)=>itemBooks(item).find(b=>b.subject===item.subject)?.chapters??[];
  const routineSubjects=routineSubjectOptions(student?.study_field??null,student?.grade??null);
  const changeCurriculum=(key:string,grade:Grade,track:PreparationTrack)=>setItems(current=>current.map(item=>item.key===key?{...item,sourceGrade:grade,preparationTrack:track==='final_exam'&&!curriculumBooks(student?.study_field??null,grade,track).length?'konkur':track,subject:"",chapter:""}:item));

  const loadPlan = (studentId: string, nextWeek: string) => {
    const plan = plans.find(
      (item) => item.student_id === studentId && item.week_start === nextWeek,
    );
    setPlanId(plan?.id ?? "");
    setPlanStatus(plan?.status ?? null);
    setTitle(plan?.title ?? "برنامه هفتگی");
    setNotes(plan?.notes ?? "");
    setRoutines(planRoutines(plan));
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

  const periodEnded = dayIso(weekStart, 6) < tehranToday();
  const hasOverlap = overlapsWindow(weekStart, plans, student?.student_id ?? "", planId);
  const editableItems = items.filter((item) => !isLockedDay(item.dayOfWeek));

  const updateRoutine = <K extends keyof PlanRoutine>(
    dayOfWeek: number,
    property: K,
    value: PlanRoutine[K],
  ) =>
    setRoutines((current) =>
      current.map((routine) =>
        routine.dayOfWeek === dayOfWeek ? { ...routine, [property]: value } : routine,
      ),
    );

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
          منتظر تخصیص دانش‌آموز توسط ادمین باش تا بتوانی
          برنامه هفتگی او را بسازی.
        </p>
      </section>
    );
  }

  return (
    <>
    <CounselorStudentStudyEditor key={student.student_id} student={student} />
    <form action={saveWeeklyPlan} className="weekly-builder">
      <section className="portal-card plan-basics">
        <div className="portal-card-title">
          <div>
            <span>تنظیمات برنامه</span>
            <h2>برنامهٔ هفت‌روزه از چه روزی شروع شود؟</h2>
          </div>
        </div>
        <label>ادامه یا ویرایش برنامهٔ موجود<select aria-label="انتخاب برنامهٔ موجود" value={planId} onChange={event=>{const chosen=plans.find(p=>p.id===event.target.value);const start=chosen?.week_start??tehranToday();setWeekStart(start);loadPlan(student.student_id,start);}}><option value="">ساخت برنامهٔ جدید</option>{plans.filter(p=>p.student_id===student?.student_id).map(p=><option key={p.id} value={p.id}>{p.title} · {formatPersianFullDate(parseIsoDate(p.week_start))}</option>)}</select></label>
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
            شروع برنامهٔ هفت‌روزه
            <PersianDatePicker
              name="week_start"
              value={weekStart}
              plannedWeeks={plannedWeeks}
              selectionMode="range"
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
          {(!student?.study_field || !student?.grade) && (
            <strong>
              برای پیشنهاد درس و فصل، پایه و رشته را در بخش اطلاعات تحصیلی بالا ثبت کن.
            </strong>
          )}
        </div>
        {student?.study_field&&["arts","foreign_languages"].includes(student.study_field)&&<p className="sp-notice">دروس مدرسه برای رشته‌های ریاضی، تجربی و انسانی در دسترس است؛ برای هنر یا زبان، رشتهٔ دیپلم باید مشخص باشد.</p>}
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

      {hasOverlap && <div className="portal-alert error" role="alert">این بازه با برنامهٔ دیگری هم‌پوشانی دارد. تاریخ شروع را بعد از پایان برنامهٔ قبلی انتخاب کن.</div>}
      <div className="weekly-days">
        {weekDays.map((_, dayIndex) => {
          const dayIsLocked = isLockedDay(dayIndex);
          const dayItems = items.filter((item) => item.dayOfWeek === dayIndex);
          const realWeekday = formatPersianWeekday(dayDate(weekStart, dayIndex));
          return (
            <section
              className={`portal-card plan-day${dayIsLocked ? " past" : ""}`}
              key={dayIndex}
              aria-label={realWeekday}
            >
              <header>
                <div>
                  <span>روز {faNumber(dayIndex + 1)}</span>
                  <h2>{formatPersianFullDate(dayDate(weekStart, dayIndex))}</h2>
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
                        {item.activityType === "practice_tests" &&
                          item.targetTestCount &&
                          ` · هدف ${faNumber(item.targetTestCount)} تست`}
                      </span>
                      {item.details && <small>{item.details}</small>}
                    </article>
                  ))}
                  {(() => {
                    const routine = routines[dayIndex];
                    return <article className="plan-routine-readonly" key={`routine-${dayIndex}`}>
                      <strong>روتین</strong>
                      <span>{routine.subject || "درس انتخاب نشده"}</span>
                      {routine.details && <small>{routine.details}</small>}
                    </article>;
                  })()}
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
                        <label>پایهٔ درس (مستقل از پایهٔ دانش‌آموز)<select value={itemGrade(item)??""} onChange={e=>changeCurriculum(item.key,Number(e.target.value) as Grade,item.preparationTrack)}>{planningGrades.map(g=><option value={g} key={g}>پایه {faNumber(g)}</option>)}</select></label>
                        <label>مسیر آمادگی<select value={item.preparationTrack} onChange={e=>changeCurriculum(item.key,itemGrade(item),e.target.value as PreparationTrack)}><option value="konkur">کنکور</option><option value="final_exam" disabled={!curriculumBooks(student?.study_field??null,itemGrade(item),'final_exam').length}>دروس مدرسه</option></select></label>
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
                          {itemBooks(item).length ? (
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
                              {item.subject&&!itemBooks(item).some(b=>b.subject===item.subject)&&<option value={item.subject}>{item.subject} (ثبت قبلی)</option>}
                              {itemBooks(item).map((book) => (
                                <option key={book.subject} value={book.subject}>
                                  {book.subject}{item.preparationTrack==="final_exam"?" — مدرسه":""}
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
                          {chapters(item).length ? (
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
                              {item.chapter&&!chapters(item).includes(item.chapter)&&<option value={item.chapter}>{item.chapter} (ثبت قبلی)</option>}
                              {chapters(item).map((chapter) => (
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
                              placeholder="نام فصل، درس یا مبحث را وارد کن"
                              maxLength={160}
                            />
                          )}
                        </label>
                        <label>
                          نوع فعالیت
                          <select
                            value={item.activityType}
                            onChange={(event) => {
                              const activityType = event.target
                                .value as PlanItem["activityType"];
                              updateItem(
                                item.key,
                                "activityType",
                                activityType,
                              );
                              updateItem(
                                item.key,
                                "targetTestCount",
                                activityType === "practice_tests" ? 20 : null,
                              );
                            }}
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
                        {item.activityType === "practice_tests" && (
                          <label>
                            تعداد تست هدف
                            <input
                              type="number"
                              inputMode="numeric"
                              min={1}
                              max={5000}
                              value={item.targetTestCount ?? ""}
                              onChange={(event) =>
                                updateItem(
                                  item.key,
                                  "targetTestCount",
                                  event.target.value === ""
                                    ? null
                                    : Number(event.target.value),
                                )
                              }
                              required
                            />
                          </label>
                        )}
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
              {!dayIsLocked && (() => {
                const routine = routines[dayIndex];
                return <section className="plan-routine" aria-label={`روتین ${realWeekday}`}>
                  <h3>روتین</h3>
                  <p>برای این روز فقط همین یک روتین ثبت میشود.</p>
                  <label>درس روتین
                    <select value={routine.subject} onChange={event=>updateRoutine(dayIndex,"subject",event.target.value)}>
                      <option value="">انتخاب درس</option>
                      {routine.subject&&!routineSubjects.includes(routine.subject)&&<option value={routine.subject}>{routine.subject} (ثبت قبلی)</option>}
                      {routineSubjects.map(subject=><option key={subject} value={subject}>{subject}</option>)}
                    </select>
                  </label>
                  <label>توضیح روتین
                    <textarea value={routine.details} maxLength={500} rows={2} onChange={event=>updateRoutine(dayIndex,"details",event.target.value)} placeholder="مثلاً مرور فرمولهای پرتکرار" />
                  </label>
                </section>;
              })()}
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
              targetTestCount: item.targetTestCount,
              details: item.details,
              sourceGrade:itemGrade(item),
              preparationTrack:item.preparationTrack,
              examYear:null,
            })),
          )}
        />
        <input type="hidden" name="routines" value={JSON.stringify(routines)} />
        <div>
          {planStatus !== "published" && (
            <button
              className="button button-secondary"
              name="status"
              value="draft"
              disabled={periodEnded || hasOverlap || !editableItems.length}
            >
              ذخیره پیش‌نویس
            </button>
          )}
          <button
            className="button"
            name="status"
            value="published"
            disabled={periodEnded || hasOverlap || (!editableItems.length && !planId)}
          >
            {planStatus === "published"
              ? "انتشار دوباره تغییرات"
              : "انتشار برای دانش‌آموز"}
          </button>
        </div>
      </section>
    </form>
    </>
  );
}
