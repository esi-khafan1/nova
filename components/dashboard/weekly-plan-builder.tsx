"use client";

import { CounselorStudentStudyEditor } from "@/components/dashboard/counselor-student-study-editor";
import { startTransition, useActionState, useEffect, useRef, useState, type FormEvent } from "react";
import Link from "next/link";
import { dayIso, tehranToday, overlapsWindow } from "@/lib/student-planning";
import { formatPersianFullDate, formatPersianWeekRange, formatPersianWeekday, parseIsoDate } from "@/lib/persian-date";
import { saveCurrentWeeklyPlan, saveWeeklyPlan } from "@/app/dashboard/actions";
import { PersianDatePicker } from "@/components/dashboard/persian-date-picker";
import {
  activityTypes,
  studyFieldLabels,
  weekDays,
  type StudyField,
} from "@/lib/study-catalog";

import { planningGrades, curriculumBooks, inferItemGrade, routineSubjectOptions, type Grade, type PreparationTrack } from "@/lib/planning-curriculum";
import { canRecommendPublisher, recommendedPublishers } from "@/lib/recommended-publishers";
import { planNumbers, nextPlanNumber, numberedPlanTitle, type NumberablePlan } from "@/lib/plan-numbering";
import { makeupActivity, makeupTitle } from "@/lib/makeup-plan-box";
import { externalSimulationActivity, externalSimulationPrefix, externalSimulationTitle, simulationProvider, simulationProviderDraft, simulationProviders, simulationSubject } from "@/lib/external-simulation";

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
  activityType: (typeof activityTypes)[number]["value"] | typeof externalSimulationActivity | typeof makeupActivity;
  targetTestCount: number | null;
  details: string;
  sourceGrade: Grade|null;
  preparationTrack: PreparationTrack;
  recommendedPublisher: string | null;
  otherPublisher: boolean;
  otherSimulationProvider?: boolean;
  previousSourceGrade?: Grade | null;
  previousPreparationTrack?: PreparationTrack;
  linkedExamId?: string|null;
  completed?: boolean;
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
    recommended_publisher?:string|null;
    exam_year?:number|null;
    linked_exam_id?:string|null;
  }>;
};

export type RecentCounselorPlan = Pick<CounselorWeeklyPlan, "id" | "student_id" | "week_start" | "title" | "status"> & { counselor_id: string };

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
  recommendedPublisher:null,
  otherPublisher:false,
});
const newStudentItem=(day:number,key:string|undefined,grade:number|null|undefined):PlanItem=>({...newItem(day,key),preparationTrack:grade===9?"final_exam":"konkur"});

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
function firstAvailableDay(start:string){return Math.max(0,weekDays.findIndex((_,i)=>!isPastDay(start,i)));}
function planItems(plan: CounselorWeeklyPlan, completedItemIds: ReadonlySet<string>): PlanItem[] {
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
      recommendedPublisher:item.recommended_publisher??null,
      otherPublisher:Boolean(item.recommended_publisher && !(recommendedPublishers as readonly string[]).includes(item.recommended_publisher)),
      otherSimulationProvider:item.activity_type === externalSimulationActivity && Boolean(simulationProvider(item.subject) && !(simulationProviders as readonly string[]).includes(simulationProvider(item.subject)!)),
      linkedExamId:item.linked_exam_id??null,
      completed:completedItemIds.has(item.id),
    }));
}

export function WeeklyPlanBuilder({
  students,
  plans,
  initialStudentId,
  initialPlanId,
  initialWeekStart,
  initialSaved,
  completedItemIds,
  numberingPlans = [],
  recentPlans = [],
  overlapPlans = plans,
  counselorId,
}: {
  students: Student[];
  plans: CounselorWeeklyPlan[];
  initialStudentId?: string;
  initialPlanId?: string;
  initialWeekStart?: string;
  initialSaved?: string;
  completedItemIds: string[];
  numberingPlans?: NumberablePlan[];
  recentPlans?: RecentCounselorPlan[];
  overlapPlans?: Array<Pick<CounselorWeeklyPlan, "id" | "student_id" | "week_start" | "status"> & {weekly_plan_items:{day_of_week:number}[]}>;
  counselorId?: string;
}) {
  const completedIdSet = new Set(completedItemIds);
  const selectedStudentIndex = Math.max(0, students.findIndex(s => s.student_id === initialStudentId));
  const [studentIndex, setStudentIndex] = useState(selectedStudentIndex);
  const selectedStudentId = students[selectedStudentIndex]?.student_id;
  const selectedStart = initialWeekStart && /^\d{4}-\d{2}-\d{2}$/.test(initialWeekStart) ? initialWeekStart : tehranToday();
  const initialPlan = plans.find(plan => plan.student_id === selectedStudentId && plan.id === initialPlanId)
    ?? plans.find(plan => plan.student_id === selectedStudentId && plan.week_start === selectedStart);
  const initialStart = initialPlan?.week_start ?? selectedStart;
  const [weekStart, setWeekStart] = useState(initialStart);
  const [planId, setPlanId] = useState(initialPlan?.id ?? "");
  const [planStatus, setPlanStatus] = useState<"draft" | "published" | null>(
    initialPlan?.status ?? null,
  );
  const [title, setTitle] = useState(initialPlan?.title ?? "برنامه هفتگی");
  const [notes, setNotes] = useState(initialPlan?.notes ?? "");
  const [routines, setRoutines] = useState<PlanRoutine[]>(() => planRoutines(initialPlan));
  const [items, setItems] = useState<PlanItem[]>(() => [
    ...(initialPlan
      ? planItems(initialPlan, completedIdSet)
      : [newStudentItem(firstAvailableDay(initialStart), "initial-item", students[selectedStudentIndex]?.grade)]),
  ]);

  const student = students[studentIndex] ?? students[0];
  const [saveResult, saveCurrentAction, savingCurrent] = useActionState(saveCurrentWeeklyPlan, null);
  const lastAppliedSave = useRef<string | null>(null);
  useEffect(() => {
    if (!saveResult || lastAppliedSave.current === saveResult.revision) return;
    const saved = plans.find(plan => plan.id === saveResult.savedId);
    if (!saved) return; // Wait for the freshly revalidated authoritative plan.
    lastAppliedSave.current = saveResult.revision;
    // Do not overwrite a different student/week the counselor selected while
    // the request was in flight.
    if (saved.student_id !== student?.student_id || saved.week_start !== weekStart) return;
    setPlanId(saved.id);
    setPlanStatus(saved.status);
    setTitle(saved.title);
    setNotes(saved.notes ?? "");
    setRoutines(planRoutines(saved));
    setItems(planItems(saved, new Set(completedItemIds)));
  }, [saveResult, plans, completedItemIds, student?.student_id, weekStart]);
  const currentUrlPlan = Boolean(initialSaved === "published" && planStatus === "published" && planId && planId===initialPlanId && student?.student_id===initialStudentId && weekStart===initialWeekStart);
  function submitCurrentPlan(event: FormEvent<HTMLFormElement>) {
    if (!currentUrlPlan) return;
    // React automatically resets a form after a successful action. Avoid that:
    // the counselor may have switched students or edited a field during save.
    event.preventDefault();
    if (savingCurrent || !event.currentTarget.reportValidity()) return;
    const fd = new FormData(event.currentTarget);
    fd.set("status", "published"); // This fast path only has the publish button.
    startTransition(() => saveCurrentAction(fd));
  }
  const numbers = planNumbers(numberingPlans.length ? numberingPlans : plans);
  const studentRecentPlans = recentPlans.filter(plan => plan.student_id === student?.student_id).slice(0, 8);
  const selectedNumber = planId ? numbers.get(planId) ?? 1 : nextPlanNumber(numberingPlans.length ? numberingPlans : plans, student?.student_id ?? "", weekStart);
  const itemGrade=(item:PlanItem):Grade=>item.sourceGrade??inferItemGrade({subject:item.subject,source_grade:null},student?.study_field??null,student?.grade??null)??([9,10,11,12].includes(student?.grade??0)?student.grade as Grade:10);
  const itemBooks=(item:PlanItem)=>curriculumBooks(student?.study_field??null,itemGrade(item),item.preparationTrack);
  const chapters=(item:PlanItem)=>itemBooks(item).find(b=>b.subject===item.subject)?.chapters??[];
  const routineSubjects=routineSubjectOptions(student?.study_field??null,student?.grade??null);
  const chooseExternalSimulation=(key:string)=>setItems(current=>current.map(item=>item.key===key?{
    ...item,previousSourceGrade:item.activityType===makeupActivity?item.previousSourceGrade:itemGrade(item),previousPreparationTrack:item.activityType===makeupActivity?item.previousPreparationTrack:item.preparationTrack,
    activityType:externalSimulationActivity,subject:externalSimulationTitle,chapter:"",targetTestCount:null,
    sourceGrade:null,preparationTrack:"konkur",recommendedPublisher:null,otherPublisher:false,otherSimulationProvider:false,
  }:item));
  const chooseMakeup=(key:string)=>setItems(current=>current.map(item=>item.key===key?{
    ...item,previousSourceGrade:item.activityType===externalSimulationActivity?item.previousSourceGrade:itemGrade(item),
    previousPreparationTrack:item.activityType===externalSimulationActivity?item.previousPreparationTrack:item.preparationTrack,
    activityType:makeupActivity,subject:makeupTitle,chapter:"",targetTestCount:null,details:"",
    sourceGrade:null,preparationTrack:"konkur",recommendedPublisher:null,otherPublisher:false,otherSimulationProvider:false,
  }:item));
  const leaveMakeup=(key:string,subject="")=>setItems(current=>current.map(item=>item.key===key?{
    ...item,activityType:"lesson",subject,chapter:"",sourceGrade:item.previousSourceGrade??null,
    preparationTrack:item.previousPreparationTrack??(student?.grade===9?"final_exam":"konkur"),
    previousSourceGrade:undefined,previousPreparationTrack:undefined,
  }:item));
  const leaveExternalSimulation=(key:string,subject="")=>{
    if(subject==="__makeup__") {chooseMakeup(key);return;}
    setItems(current=>current.map(item=>item.key===key?{
      ...item,activityType:"lesson",subject,chapter:"",sourceGrade:item.previousSourceGrade??null,
      preparationTrack:item.previousPreparationTrack??(student?.grade===9?"final_exam":"konkur"),
      previousSourceGrade:undefined,previousPreparationTrack:undefined,otherSimulationProvider:false,
    }:item));
  };
  const changeCurriculum=(key:string,grade:Grade,track:PreparationTrack)=>setItems(current=>current.map(item=>item.key===key?{...item,sourceGrade:grade,preparationTrack:track==='final_exam'&&!curriculumBooks(student?.study_field??null,grade,track).length?'konkur':track,subject:"",chapter:"",recommendedPublisher:track==='konkur'?item.recommendedPublisher:null,otherPublisher:track==='konkur'&&item.otherPublisher}:item));

  const durationField=(item:PlanItem)=>(
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
  );

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
        ? planItems(plan, completedIdSet)
        : [newStudentItem(firstAvailableDay(nextWeek), `week-${nextWeek}`, students.find(s=>s.student_id===studentId)?.grade)],
    );
  };

  const plannedWeeks = Object.fromEntries(
    plans
      .filter((plan) => plan.student_id === student?.student_id)
      .map((plan) => [plan.week_start, plan.status]),
  );

  const isLockedDay = (dayIndex: number) => isPastDay(weekStart, dayIndex);

  const periodEnded = dayIso(weekStart, 6) < tehranToday();
  const hasOverlap = overlapsWindow(weekStart, overlapPlans, student?.student_id ?? "", planId, items.map(item => item.dayOfWeek));
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
        item.key === key ? {
          ...item, [property]: value,
          ...(property === "activityType" && !canRecommendPublisher(item.preparationTrack, String(value))
            ? { recommendedPublisher: null, otherPublisher: false } : {}),
        } : item,
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
    <form action={currentUrlPlan ? saveCurrentAction : saveWeeklyPlan} onSubmit={submitCurrentPlan} className="weekly-builder">
      <section className="portal-card plan-basics">
        <div className="portal-card-title">
          <div>
            <span>تنظیمات برنامه · برنامهٔ {faNumber(selectedNumber)} این دانش‌آموز</span>
            <h2>برنامهٔ هفت‌روزه از چه روزی شروع شود؟</h2>
          </div>
        </div>
        <label>ادامه یا ویرایش برنامهٔ موجود<select aria-label="انتخاب برنامهٔ موجود" value={planId} onChange={event=>{const chosen=plans.find(p=>p.id===event.target.value);const start=chosen?.week_start??tehranToday();setWeekStart(start);loadPlan(student.student_id,start);}}><option value="">ساخت برنامهٔ {faNumber(nextPlanNumber(numberingPlans.length ? numberingPlans : plans, student?.student_id ?? "", weekStart))}</option>{plans.filter(p=>p.student_id===student?.student_id).map(p=><option key={p.id} value={p.id}>{numberedPlanTitle(p.title,numbers.get(p.id)??1)} · {formatPersianFullDate(parseIsoDate(p.week_start))}</option>)}</select></label>
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
                ? "حالت تغییر برنامه فعال است؛ روزهای گذشته ثابت می‌مانند. فعالیت‌های انجام‌شده قابل تغییر یا حذف نیستند؛ حذف باکس متصل به آزمون نیاز به تأیید دارد."
                : "اطلاعات پیش‌نویس بارگذاری شد و می‌توانی ادامه‌اش بدهی."}
            </span>
          </div>
        )}
      </section>

      {hasOverlap && <div className="portal-alert error" role="alert">این بازه با روزهای دارای فعالیتِ برنامهٔ دیگری هم‌پوشانی دارد.</div>}
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
                      setItems((current) => [...current, newStudentItem(dayIndex, undefined, student?.grade)])
                    }
                  >
                    + افزودن فعالیت
                  </button>
                )}
              </header>

              {dayIsLocked ? (
                <div className="plan-locked-day">
                  <p className="plan-day-empty">
                    این روز گذشته و دیگر قابل تغییر نیست.
                  </p>
                  {dayItems.map((item) => (
                    <article className="plan-item-readonly" key={item.key}>
                      <strong>{item.subject}</strong>
                      <span>
                        {item.activityType === makeupActivity ? "" : item.activityType === externalSimulationActivity ? `برگزارکننده: ${simulationProvider(item.subject) ?? "ثبت نشده"} · ` : `${item.chapter || "بدون مبحث"} · `}{" "}
                        {faNumber(item.durationMinutes)} دقیقه
                        {item.activityType === "practice_tests" &&
                          item.targetTestCount &&
                          ` · هدف ${faNumber(item.targetTestCount)} تست`}
                      </span>
                      {item.recommendedPublisher && <small>منبع پیشنهادی کنکور: {item.recommendedPublisher}</small>}
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
                  {dayItems.map((item, index) => item.completed ? (
                    <article className="plan-item-readonly" key={item.key}>
                      <strong>{item.activityType === externalSimulationActivity ? externalSimulationTitle : item.subject}</strong>
                      <span>{item.activityType === makeupActivity ? "" : item.activityType === externalSimulationActivity ? `برگزارکننده: ${simulationProvider(item.subject) ?? "ثبت نشده"} · ` : `${item.chapter || "بدون مبحث"} · `}{faNumber(item.durationMinutes)} دقیقه
                        {item.activityType === "practice_tests" && item.targetTestCount && ` · هدف ${faNumber(item.targetTestCount)} تست`}
                      </span>
                      {item.recommendedPublisher && <small>منبع پیشنهادی کنکور: {item.recommendedPublisher}</small>}
                      {item.details && <small>{item.details}</small>}
                      <p className="plan-exam-box-status" role="status">این باکس انجام شده و قابل تغییر یا حذف نیست.</p>
                    </article>
                  ) : (
                    <article className="plan-item-editor" key={item.key}>
                      <div className="plan-item-number">
                        {faNumber(index + 1)}
                      </div>
                      <div className={`plan-item-fields${item.activityType===externalSimulationActivity?" plan-item-fields--external":""}`}>
                        {item.linkedExamId && (
                          <p className="plan-exam-box-status">
                            این باکس به آزمون متصل است؛ با تأیید هشدار می‌توانی آن را حذف کنی، اما اتصال دانش‌آموز از این باکس به آزمون از بین می‌رود.
                          </p>
                        )}
                        {item.activityType === makeupActivity ? <>
                          <label>باکس
                            <select aria-label="نوع باکس" value="__makeup__" onChange={event=>{
                              if(event.target.value==="__external_simulation__") chooseExternalSimulation(item.key);
                              else leaveMakeup(item.key,event.target.value);
                            }} required>
                              <option value="">انتخاب درس</option>
                              <option value="__makeup__">{makeupTitle}</option>
                              <option value="__external_simulation__">{externalSimulationTitle}</option>
                              {curriculumBooks(student?.study_field??null,item.previousSourceGrade??itemGrade(item),item.previousPreparationTrack??(student?.grade===9?"final_exam":"konkur")).map(book=><option key={book.subject} value={book.subject}>{book.subject}</option>)}
                            </select>
                          </label>
                          {durationField(item)}
                        </> : item.activityType === externalSimulationActivity ? <>
                          <label className="plan-simulation-subject">درس
                            <select
                              aria-label="درس"
                              value="__external_simulation__"
                              onChange={event=>leaveExternalSimulation(item.key,event.target.value)}
                              required
                            >
                              <option value="">انتخاب درس</option>
                              <option value="__external_simulation__">{externalSimulationTitle}</option>
                              <option value="__makeup__">{makeupTitle}</option>
                              {curriculumBooks(
                                student?.study_field??null,
                                item.previousSourceGrade??itemGrade(item),
                                item.previousPreparationTrack??(student?.grade===9?"final_exam":"konkur"),
                              ).map(book=><option key={book.subject} value={book.subject}>{book.subject}</option>)}
                            </select>
                          </label>
                          <label className="plan-simulation-provider">برگزارکنندهٔ آزمون
                            <select
                              value={item.otherSimulationProvider || (simulationProvider(item.subject) && !(simulationProviders as readonly string[]).includes(simulationProvider(item.subject)!)) ? "other" : simulationProvider(item.subject) ?? ""}
                              onChange={event=>setItems(current=>current.map(currentItem=>currentItem.key===item.key?{
                                ...currentItem,otherSimulationProvider:event.target.value==="other",
                                subject:simulationSubject(event.target.value==="other"?"":event.target.value),
                              }:currentItem))}
                              required
                            >
                              <option value="">انتخاب برگزارکننده</option>
                              {simulationProviders.map(name=><option key={name} value={name}>{name}</option>)}
                              <option value="other">سایر</option>
                            </select>
                          </label>
                          {durationField(item)}
                          {item.otherSimulationProvider && <label className="plan-simulation-other">نام برگزارکنندهٔ دیگر
                            <input
                              value={simulationProviderDraft(item.subject)} maxLength={60} minLength={2} required
                              onChange={event=>updateItem(item.key,"subject",`${externalSimulationPrefix}${event.target.value}`)}
                              placeholder="نام برگزارکننده را بنویس"
                            />
                          </label>}
                        </> : <>
                        <label>پایهٔ درس (مستقل از پایهٔ دانش‌آموز)<select value={itemGrade(item)??""} disabled={Boolean(item.linkedExamId)} onChange={e=>changeCurriculum(item.key,Number(e.target.value) as Grade,Number(e.target.value)===9?"final_exam":item.preparationTrack)}>{planningGrades.map(g=><option value={g} key={g}>پایه {faNumber(g)}</option>)}</select></label>
                        <label>مسیر آمادگی<select value={item.preparationTrack} disabled={Boolean(item.linkedExamId)} onChange={e=>changeCurriculum(item.key,itemGrade(item),e.target.value as PreparationTrack)}><option value="konkur">{itemGrade(item)===9?"هوش و استعداد تحلیلی":"کنکور"}</option><option value="final_exam" disabled={!curriculumBooks(student?.study_field??null,itemGrade(item),'final_exam').length}>دروس مدرسه</option></select></label>
                        {durationField(item)}
                        <label>
                          درس
                          {itemBooks(item).length ? (
                            <select
                              value={item.subject}
                              disabled={Boolean(item.linkedExamId)}
                              onChange={(event) => {
                                if(event.target.value === "__external_simulation__") {chooseExternalSimulation(item.key);return;}
                                if(event.target.value === "__makeup__") {chooseMakeup(item.key);return;}
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
                              <option value="__external_simulation__">{externalSimulationTitle}</option>
                              <option value="__makeup__">{makeupTitle}</option>
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
                              disabled={Boolean(item.linkedExamId)}
                              onChange={(event) => event.target.value===externalSimulationTitle
                                ? chooseExternalSimulation(item.key)
                                : event.target.value===makeupTitle ? chooseMakeup(item.key)
                                : updateItem(item.key,"subject",event.target.value)}
                              placeholder="نام درس را وارد کن یا آزمون شبیه‌ساز را انتخاب کن"
                              list={`subjects-${item.key}`}
                              maxLength={100}
                              required
                            />
                          )}
                          {!itemBooks(item).length && <datalist id={`subjects-${item.key}`}><option value={externalSimulationTitle}/><option value={makeupTitle}/></datalist>}
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
                              disabled={!item.subject || Boolean(item.linkedExamId)}
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
                              disabled={Boolean(item.linkedExamId)}
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
                            disabled={Boolean(item.linkedExamId)}
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
                        {itemGrade(item)!==9 && canRecommendPublisher(item.preparationTrack, item.activityType) && (
                          <>
                            <label>منبع پیشنهادی کنکور (اختیاری)
                              <select
                                aria-label="ناشر پیشنهادی کنکور"
                                value={item.otherPublisher ? "other" : item.recommendedPublisher ?? ""}
                                onChange={(event) => {
                                  const other = event.target.value === "other";
                                  setItems(current => current.map(currentItem => currentItem.key === item.key
                                    ? { ...currentItem, otherPublisher: other, recommendedPublisher: other ? null : event.target.value || null }
                                    : currentItem));
                                }}
                              >
                                <option value="">بدون منبع پیشنهادی</option>
                                {recommendedPublishers.map(publisher => <option key={publisher} value={publisher}>{publisher}</option>)}
                                <option value="other">ناشر دیگر</option>
                              </select>
                            </label>
                            {item.otherPublisher && <label>نام ناشر دیگر
                              <input
                                aria-label="نام ناشر دیگر"
                                value={item.recommendedPublisher ?? ""}
                                maxLength={80}
                                onChange={event => updateItem(item.key, "recommendedPublisher", event.target.value)}
                                placeholder="نام ناشر را بنویس"
                              />
                            </label>}
                          </>
                        )}
                        {item.activityType === "exam" && (
                          <p className="plan-exam-box-status" role="status">
                            {item.linkedExamId
                              ? "این باکس آزمون برای طراح آزمون ارسال شده و آزمون به آن متصل است؛ دانش‌آموز از داخل برنامه وارد آزمون می‌شود."
                              : "این باکس با روز و درس برای طراح آزمون ارسال می‌شود تا آزمون مناسب آن ساخته شود."}
                          </p>
                        )}
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
                        </>}
                        {item.activityType !== makeupActivity && <label className="plan-details">
                          {item.activityType==="exam"?"راهنمای طراح آزمون (فقط برای طراح)":"توضیح تکمیلی"}
                          <input
                            value={item.details}
                            onChange={(event) =>
                              updateItem(
                                item.key,
                                "details",
                                event.target.value,
                              )
                            }
                            placeholder={item.activityType==="exam"?"راهنمای ساخت آزمون برای طراح را بنویس":item.activityType===externalSimulationActivity?"مثلاً ساعت شروع یا توضیح آزمون":"مثلاً ۳۰ تست زمان‌دار و تحلیل پاسخ‌ها"}
                            maxLength={500}
                          />
                        </label>}
                      </div>
                      <button
                        type="button"
                        className="plan-remove"
                        aria-label="حذف فعالیت"
                        onClick={() => {
                          if (item.linkedExamId && !window.confirm("این باکس به آزمون متصل است. با حذف آن، دسترسی دانش‌آموز به آزمون از طریق این باکس قطع می‌شود. آزمون و پاسخ‌های ثبت‌شده حذف نمی‌شوند. آیا از حذف باکس مطمئنی؟")) return;
                          setItems(current => current.filter(currentItem => currentItem.key !== item.key));
                        }}
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
                  <p>برای این روز فقط همین یک روتین ثبت می‌شود.</p>
                  <label>درس روتین
                    <select value={routine.subject} onChange={event=>updateRoutine(dayIndex,"subject",event.target.value)}>
                      <option value="">انتخاب درس</option>
                      {routine.subject&&!routineSubjects.includes(routine.subject)&&<option value={routine.subject}>{routine.subject} (ثبت قبلی)</option>}
                      {routineSubjects.map(subject=><option key={subject} value={subject}>{subject}</option>)}
                    </select>
                  </label>
                  <label>توضیح روتین
                    <textarea value={routine.details} maxLength={500} rows={2} onChange={event=>updateRoutine(dayIndex,"details",event.target.value)} placeholder="مثلاً مرور فرمول‌های پرتکرار" />
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
              id: planStatus === "published" && dayIso(weekStart, item.dayOfWeek) === tehranToday() ? item.id ?? null : null,
              dayOfWeek: item.dayOfWeek,
              durationMinutes: item.durationMinutes,
              subject: item.subject,
              chapter: item.chapter,
              activityType: item.activityType,
              targetTestCount: item.targetTestCount,
              details: item.details,
              sourceGrade:item.activityType===externalSimulationActivity||item.activityType===makeupActivity?null:item.completed ? item.sourceGrade : itemGrade(item),
              preparationTrack:item.preparationTrack,
              recommendedPublisher:itemGrade(item)!==9&&canRecommendPublisher(item.preparationTrack,item.activityType)?item.recommendedPublisher?.trim()||null:null,
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
              disabled={savingCurrent || periodEnded || hasOverlap || !editableItems.length}
            >
              ذخیره پیش‌نویس
            </button>
          )}
          <button
            className="button"
            name="status"
            value="published"
            disabled={savingCurrent || periodEnded || hasOverlap || (!editableItems.length && !planId)}
          >
            {planStatus === "published"
              ? "انتشار دوباره تغییرات"
              : "انتشار برای دانش‌آموز"}
          </button>
        </div>
      </section>
    </form>
    {studentRecentPlans.length > 0 && (
      <section className="portal-card recent-plans">
        <div className="portal-card-title">
          <div><span>سوابق</span><h2>برنامه‌های اخیر</h2></div>
        </div>
        <div>
          {studentRecentPlans.map(plan => (
            <article key={plan.id}>
              <div>
                <strong>{student.full_name || "دانش‌آموز نووا"}</strong>
                <span>{numberedPlanTitle(plan.title, numbers.get(plan.id) ?? 1)} · {formatPersianWeekRange(plan.week_start)}</span>
              </div>
              <div className="recent-plan-actions">
                {plan.counselor_id !== counselorId && <small>برنامهٔ مشاور پیشین · فقط مشاهده</small>}
                <span className={`plan-status ${plan.status}`}>
                  {plan.status === "published" ? "منتشرشده" : "پیش‌نویس"}
                </span>
                <Link className="print-plan-link" href={`/dashboard/counselor/plans/${plan.id}/print`}>چاپ A4</Link>
              </div>
            </article>
          ))}
        </div>
      </section>
    )}
    </>
  );
}
