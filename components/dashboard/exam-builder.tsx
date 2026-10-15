"use client";

import { ExamStudentPicker, type ExamStudent } from "@/components/dashboard/exam-student-picker";
import "@/app/exam-designer.css";
import { useEffect, useId, useRef, useState, type FormEvent } from "react";
import { parseExamStartWindow } from "@/lib/floating-exams";
import { remapBookletKeys } from "@/lib/exam-booklet-editing";
import { countBookletKeys } from "@/lib/exam-key-validation";
import { earliestExamSchedule, tehranDateTime, validWindowEnd, timeAfter } from "@/lib/exam-schedule";
import { examPublicationReadiness } from "@/lib/exam-publication";
import { saveExam } from "@/app/dashboard/exams/actions";
import { ExamPdfUpload } from "@/components/dashboard/exam-pdf-upload";
import { PersianNumberStepper } from "@/components/dashboard/persian-number-stepper";
import { PersianDatePicker } from "@/components/dashboard/persian-date-picker";
import { PersianTimePicker } from "@/components/dashboard/persian-time-picker";
import { allKonkurBookletTitles, konkurBookletPresets } from "@/lib/konkur-presets";
import { toPersianDigits } from "@/lib/persian-date";
import { studyFieldLabels, type StudyField } from "@/lib/study-catalog";

type BookletItem = { id: string; title: string; pdfUrl: string; questionCount: number; durationMinutes: number; keyAnswers: Record<string, number> };

export type ExamBuilderInitial = {id:string;title:string;description:string|null;examField:StudyField|"";booklets:BookletItem[];students:ExamStudent[];scheduledDate:string;scheduledTime:string;windowEndTime:string|null};
export function ExamBuilder({initial}:{initial?:ExamBuilderInitial}) {
  const uid = useId();
  const [publicationAttempted, setPublicationAttempted] = useState(false);
  const publicationPanel = useRef<HTMLElement>(null);
  const [examField, setExamField] = useState<StudyField | "">(initial?.examField??"");
  const [booklets, setBooklets] = useState<BookletItem[]>(initial?.booklets??[{ id: `${uid}-b1`, title: "ریاضی", pdfUrl: "", questionCount: 20, durationMinutes: 30, keyAnswers: {} }]);
  const [students,setStudents]=useState<ExamStudent[]>(initial?.students??[]);
  const [clock, setClock] = useState(() => Date.now());
  const scheduleBounds = earliestExamSchedule(new Date(clock));
  const today = scheduleBounds.today;
  const [scheduledDate, setScheduledDate] = useState(initial?.scheduledDate ?? tehranDateTime(new Date(clock + 86400000)).date);
  const [scheduledTime, setScheduledTime] = useState(initial?.scheduledTime??"09:00");
  const [schedulingMode, setSchedulingMode] = useState(initial?.windowEndTime?"floating":"fixed");
  const [windowEndTime, setWindowEndTime] = useState(initial?.windowEndTime??"12:00");
  // Refresh an open form after time passes or the tab becomes visible again.
  useEffect(() => {
    const refresh = () => setClock(Date.now());
    const timer = window.setInterval(refresh, 15000);
    window.addEventListener("focus", refresh);
    document.addEventListener("visibilitychange", refresh);
    return () => { window.clearInterval(timer); window.removeEventListener("focus", refresh); document.removeEventListener("visibilitychange", refresh); };
  }, []);
  const todayHasTime = scheduleBounds.date === today;
  useEffect(() => {
    if (scheduledDate === scheduleBounds.date && scheduledTime < scheduleBounds.time) setScheduledTime(scheduleBounds.time);
  }, [scheduledDate, scheduledTime, scheduleBounds.date, scheduleBounds.time]);
  useEffect(() => {
    if (schedulingMode === "floating") setWindowEndTime(previous => validWindowEnd(scheduledTime, previous));
  }, [scheduledTime, schedulingMode]);
  const changeScheduledDate = (date: string) => {
    const bounds = earliestExamSchedule(new Date());
    setClock(Date.now());
    setScheduledDate(date);
    if (date === bounds.today && bounds.date === bounds.today) setScheduledTime(bounds.time);
  };
  const scheduleValid = scheduledDate >= scheduleBounds.date && (scheduledDate !== scheduleBounds.date || scheduledTime >= scheduleBounds.time);
  let currentStart = 1;
  const bookletRanges = booklets.map((b) => { const start = currentStart; const count = Math.max(1, Number(b.questionCount) || 1); const end = start + count - 1; currentStart = end + 1; return { start, end, count }; });
  const totalQuestions = bookletRanges.reduce((acc, r) => acc + r.count, 0);
  const totalDuration = booklets.reduce((acc, b) => acc + (Number(b.durationMinutes) || 0), 0);
  const updateBooklet = (index: number, patch: Partial<BookletItem>) => setBooklets((prev) => remapBookletKeys(prev, prev.map((item, idx) => idx === index ? { ...item, ...patch } : item)));
  const setQuestionKey = (bookletIndex: number, questionNumber: number, option: number) => setBooklets((prev) => prev.map((item, idx) => { if (idx !== bookletIndex) return item; const nextKeys = { ...item.keyAnswers }; if (item.keyAnswers[String(questionNumber)] === option) delete nextKeys[String(questionNumber)]; else nextKeys[String(questionNumber)] = option; return { ...item, keyAnswers: nextKeys }; }));
  const titleSuggestions = examField ? konkurBookletPresets[examField].map((item) => item.title) : allKonkurBookletTitles;
  const addBooklet = () => setBooklets((prev) => [...prev, { id: `${uid}-b${Date.now()}`, title: titleSuggestions[0], pdfUrl: "", questionCount: 25, durationMinutes: 35, keyAnswers: {} }]);
  const removeBooklet = (index: number) => { if (booklets.length > 1) setBooklets((prev) => remapBookletKeys(prev, prev.filter((_, idx) => idx !== index))); };
  const applyExamField = (field: StudyField | "") => { setExamField(field); if (!field) setBooklets([{id:`${uid}-custom`,title:"ریاضی",pdfUrl:"",questionCount:20,durationMinutes:30,keyAnswers:{}}]); if (field) setBooklets(konkurBookletPresets[field].map((preset, index) => ({ id: `${uid}-${field}-${index}-${Date.now()}`, title: preset.title, pdfUrl: "", questionCount: preset.questionCount, durationMinutes: preset.durationMinutes, keyAnswers: {} }))); };
  const windowValid = schedulingMode !== "floating" || Boolean(parseExamStartWindow(scheduledDate,scheduledTime,windowEndTime));
  const readiness = examPublicationReadiness(booklets, students.length, windowValid);
  const { allKeysComplete, durationValid } = readiness;
  const canPublish = readiness.canPublish && scheduleValid;

  const focusPublicationCheck = () => {
    setPublicationAttempted(true);
    publicationPanel.current?.focus({ preventScroll: true });
    publicationPanel.current?.scrollIntoView({ block: "center", behavior: "auto" });
  };
  const checkPublication = (event: FormEvent<HTMLFormElement>) => {
    const submitter = (event.nativeEvent as SubmitEvent).submitter;
    if (submitter?.getAttribute("value") === "published" && !canPublish) {
      event.preventDefault();
      focusPublicationCheck();
    }
  };
  const focusMissingKey = (bookletIndex: number, question: number) => {
    const row = document.getElementById(`${uid}-key-${bookletIndex}-${question}`);
    const accordion = row?.closest("details");
    if (accordion) accordion.open = true;
    row?.scrollIntoView({ block: "center", behavior: "auto" });
    row?.querySelector<HTMLButtonElement>("button")?.focus({ preventScroll: true });
  };

  return <form action={saveExam} onSubmit={checkPublication} className="portal-card exam-builder">
    <input type="hidden" name="exam_id" value={initial?.id??""}/><input type="hidden" name="student_ids" value={JSON.stringify(students.map(s=>s.id))}/><input type="hidden" name="booklets" value={JSON.stringify(booklets)} /><input type="hidden" name="exam_field" value={examField} />
    <div className="portal-card-title"><div><span>آزمون کنکوری</span><h2>{initial?"ویرایش آزمون دفترچه‌ای":"ساخت آزمون دفترچه‌ای"}</h2></div><div className="exam-summary-pill"><span>{toPersianDigits(booklets.length)} دفترچه</span><span>·</span><span>{toPersianDigits(totalQuestions)} سؤال</span><span>·</span><span>{toPersianDigits(totalDuration)} دقیقه</span></div></div>
    <div className="exam-meta-grid">
      <label>رشته امتحانی (اختیاری)<select style={{ color: "#14263b", backgroundColor: "#fffdf8" }} value={examField} onChange={(event) => applyExamField(event.target.value as StudyField | "")}><option style={{ color: "#14263b", backgroundColor: "#fffdf8" }} value="">بدون الگوی رشته</option>{Object.entries(studyFieldLabels).map(([value, label]) => <option style={{ color: "#14263b", backgroundColor: "#fffdf8" }} key={value} value={value}>{label}</option>)}</select></label>
      <label>عنوان آزمون<input name="title" defaultValue={initial?.title} required minLength={3} maxLength={160} placeholder="مثلاً شبیه‌ساز کنکور تجربی مرحله ۱" /></label>

      <label>نوع زمان‌بندی<select name="scheduling_mode" value={schedulingMode} onChange={event=>setSchedulingMode(event.target.value)}><option value="fixed">شروع هم‌زمان (حالت فعلی)</option><option value="floating">بازهٔ شروع شناور</option></select></label>
      <label>روز برگزاری<PersianDatePicker name="scheduled_date" value={scheduledDate} onChange={changeScheduledDate} selectionMode="day" minDate={scheduleBounds.date} todayDate={today} /></label>
      <label>{schedulingMode === "floating" ? "ابتدای بازهٔ شروع" : "ساعت شروع"}<PersianTimePicker name="scheduled_time" value={scheduledTime} onChange={setScheduledTime} minTime={scheduledDate === scheduleBounds.date ? scheduleBounds.time : undefined} disabled={scheduledDate === today && !todayHasTime} /></label>
      {schedulingMode === "floating" && <><label>پایان بازهٔ شروع<PersianTimePicker name="start_window_end_time" value={windowEndTime} onChange={setWindowEndTime} minTime={timeAfter(scheduledTime, 1) ?? undefined} disabled={!timeAfter(scheduledTime, 1)}/></label><p className="exam-field-wide exam-timing-hint">شروع جدید فقط از ابتدای بازه تا قبل از ساعت پایان آن ممکن است. هر دانش‌آموز از لحظهٔ شروع، تمام مدت تعیین‌شدهٔ آزمون را دارد؛ بسته‌شدن بازه، آزمونِ شروع‌شده را قطع نمی‌کند. ساعت‌ها به وقت تهران هستند.</p></>}
      <label className="exam-field-wide">توضیحات و راهنمای آزمون<textarea defaultValue={initial?.description??""} name="description" maxLength={3000} rows={2} placeholder="توضیحات کلی درباره شرایط آزمون، نمره منفی و ترتیب دفترچه‌ها..." /></label>
    </div>
    {scheduledDate === today && <p className="exam-schedule-hint" role="status">{todayHasTime ? `ساعت‌ها به وقت تهران هستند؛ اولین زمان مجاز امروز ${toPersianDigits(scheduleBounds.time)} است (حداقل ۵ دقیقه پس از زمان فعلی).` : "برای امروز زمان مجازی باقی نمانده است؛ روز بعد را انتخاب کن."}</p>}
    <ExamStudentPicker selected={students} onChange={setStudents}/>
    {examField&&<p className="portal-alert success">الگوی استاندارد کنکور (ساختار تأییدشدهٔ ۱۴۰۴) فعال است؛ تعداد، ترتیب، زمان و بازهٔ دروس ثابت‌اند. فقط PDF و کلید را وارد کن. برای آزمون سفارشی «بدون الگوی رشته» را انتخاب کن.</p>}
    <div className="exam-booklets-section"><div className="exam-booklets-heading"><div><h3>دفترچه‌های آزمون</h3><p>مانند کنکور سراسری، هر دفترچه شامل فایل سؤالات، تعداد سؤال و زمان‌بندی مستقل خود است.</p></div></div><div className="exam-booklets-list">
      {booklets.map((booklet, bIndex) => { const range = bookletRanges[bIndex]; const qList = Array.from({ length: range.count }, (_, i) => range.start + i); return <article key={booklet.id} className="exam-booklet-card">
        <div className="exam-booklet-header"><div className="exam-booklet-header-title"><span className="exam-booklet-badge">دفترچه {toPersianDigits(bIndex + 1)}</span><span className="exam-booklet-range">سؤالات {toPersianDigits(range.start)} تا {toPersianDigits(range.end)}</span><span className="exam-booklet-time">{toPersianDigits(booklet.durationMinutes)} دقیقه</span></div>{!examField && booklets.length > 1 && <button type="button" className="exam-booklet-delete" onClick={() => removeBooklet(bIndex)}>حذف دفترچه</button>}</div>
        {examField ? <div className="exam-template-subjects"><strong>{booklet.title} · {toPersianDigits(booklet.questionCount)} سؤال · {toPersianDigits(booklet.durationMinutes)} دقیقه</strong>{konkurBookletPresets[examField][bIndex]?.subjects.map(subject=><span key={subject.id}>{subject.title}: سؤال {toPersianDigits(subject.start)} تا {toPersianDigits(subject.end)}</span>)}</div> : <>
        <div className="exam-booklet-fields"><label>عنوان دفترچه<select required value={booklet.title} onChange={(e) => updateBooklet(bIndex, { title: e.target.value })}>{titleSuggestions.map((title) => <option key={title} value={title}>{title}</option>)}</select></label><label>تعداد سؤالات این دفترچه<PersianNumberStepper min={1} max={200} value={booklet.questionCount} label={`تعداد سؤالات ${booklet.title}`} onChange={(value) => updateBooklet(bIndex, { questionCount: value })} /></label><label>مدت پاسخگویی این دفترچه (دقیقه)<PersianNumberStepper min={1} max={360} value={booklet.durationMinutes} label={`مدت پاسخگویی ${booklet.title}`} onChange={(value) => updateBooklet(bIndex, { durationMinutes: value })} /></label></div></>}

        <div className="exam-booklet-upload"><ExamPdfUpload purpose="exam-question" value={booklet.pdfUrl} onChange={(url) => updateBooklet(bIndex, { pdfUrl: url })} label={`فایل PDF سؤالات ${booklet.title}`} /></div>
        <details className="exam-key-accordion" open><summary><span>کلید سؤالات {toPersianDigits(range.start)} تا {toPersianDigits(range.end)} (تصحیح خودکار)</span><span className="exam-key-count">{toPersianDigits(countBookletKeys(booklet.keyAnswers, range.start, range.count))} از {toPersianDigits(range.count)} تعیین شده</span></summary><div className="exam-key-content"><div className="exam-key-grid">{qList.map((qNum) => { const selected = booklet.keyAnswers[String(qNum)]; return <div key={qNum} id={`${uid}-key-${bIndex}-${qNum}`} className="exam-key-item" data-incomplete={publicationAttempted && countBookletKeys(booklet.keyAnswers, qNum, 1) === 0 || undefined}><span className="exam-key-num">{toPersianDigits(qNum)}</span><div className="exam-key-options">{[1,2,3,4].map((opt) => <button type="button" key={opt} aria-label={`سؤال ${toPersianDigits(qNum)}، گزینهٔ ${toPersianDigits(opt)}`} aria-pressed={selected === opt} className={`exam-key-btn ${selected === opt ? "selected" : ""}`} onClick={() => setQuestionKey(bIndex, qNum, opt)}>{toPersianDigits(opt)}</button>)}</div></div>; })}</div></div></details>
      </article>; })}
    </div>{!examField&&<button type="button" className="button secondary exam-add-booklet-btn" onClick={addBooklet}>+ افزودن درس / دفترچه جدید</button>}</div>
    <section className={`exam-publication-check${canPublish ? " is-ready" : ""}`} ref={publicationPanel} tabIndex={-1} id={`${uid}-publication`} aria-labelledby={`${uid}-publication-title`}>
      <h3 id={`${uid}-publication-title`}>آمادگی انتشار آزمون</h3>
      {publicationAttempted && !canPublish && <p className="exam-publication-error" role="alert">انتشار انجام نشد؛ موارد زیر را کامل کن. اطلاعات فرم حفظ شده‌اند.</p>}
      <ul className="exam-publication-summary">
        <li data-ready={students.length > 0}><span aria-hidden="true">{students.length ? "✓" : "!"}</span>{students.length ? `${toPersianDigits(students.length)} دانش‌آموز انتخاب شده` : "حداقل یک دانش‌آموز را انتخاب کن."}</li>
        <li data-ready={readiness.allBookletsHavePdf}><span aria-hidden="true">{readiness.allBookletsHavePdf ? "✓" : "!"}</span>فایل PDF: {toPersianDigits(readiness.progress.filter(item => item.hasPdf).length)} از {toPersianDigits(booklets.length)} دفترچه بارگذاری شده</li>
        <li data-ready={allKeysComplete}><span aria-hidden="true">{allKeysComplete ? "✓" : "!"}</span>کلید پاسخ: {toPersianDigits(readiness.completedKeys)} از {toPersianDigits(readiness.totalQuestions)} سؤال تعیین شده</li>
      </ul>
      {readiness.progress.filter(item => !item.hasPdf).map(item => <p key={`pdf-${item.index}`} className="exam-publication-gap">دفترچه {toPersianDigits(item.index + 1)} ({item.title}): فایل PDF هنوز بارگذاری نشده است.</p>)}
      {readiness.progress.filter(item => item.missing.length > 0).map(item => <div key={item.index} className="exam-publication-gap">
        <p>دفترچه {toPersianDigits(item.index + 1)} ({item.title}): {toPersianDigits(item.missing.length)} سؤال بدون کلید؛ شماره‌ها: {item.missing.slice(0, 12).map(question => toPersianDigits(question)).join("، ")}{item.missing.length > 12 ? ` و ${toPersianDigits(item.missing.length - 12)} سؤال دیگر` : ""}.</p>
        <button type="button" onClick={() => focusMissingKey(item.index, item.missing[0])}>تکمیل کلید دفترچه {toPersianDigits(item.index + 1)}</button>
      </div>)}
      {readiness.progress.filter(item => !item.validCount).map(item => <p key={`count-${item.index}`} className="exam-publication-gap">دفترچه {toPersianDigits(item.index + 1)}: تعداد سؤال باید بین ۱ تا ۲۰۰ باشد.</p>)}
      {!scheduleValid && <p className="exam-publication-gap">زمان شروع باید در آینده باشد. روز و ساعت آزمون را دوباره انتخاب کن؛ ساعت‌ها به وقت تهران هستند.</p>}
      {!windowValid && <p className="exam-publication-gap">پایان بازه باید بعد از شروع بازه و در همان روز باشد.</p>}
      {!durationValid && <p className="exam-publication-gap">زمان هر دفترچه باید بین ۱ تا ۳۶۰ دقیقه و مجموع زمان دفترچه‌ها حداکثر ۶۰۰ دقیقه باشد.</p>}
      {canPublish && <p className="exam-publication-ready" role="status">دانش‌آموزها، PDFها و کلیدها کامل‌اند؛ آزمون آمادهٔ انتشار است.</p>}
    </section>
    <p role="status">{!windowValid ? "پایان بازه باید بعد از شروع بازه و در همان روز باشد." : !durationValid ? "مجموع زمان دفترچه‌ها نباید بیشتر از ۶۰۰ دقیقه باشد." : !allKeysComplete && "برای انتشار آزمون، گزینهٔ صحیح تمام سؤال‌ها را مشخص کن. ذخیرهٔ پیش‌نویس با کلید ناقص ممکن است."}</p>
    <div className="exam-actions">
      <button className="button secondary" name="status" value="draft" disabled={!durationValid || !windowValid}>ذخیره پیش‌نویس</button>
      <button className="button" name="status" value="published" aria-describedby={`${uid}-publication`} onClick={event => { if (!canPublish) { event.preventDefault(); focusPublicationCheck(); } }} title={canPublish ? "آزمون آمادهٔ انتشار است" : "موارد باقی‌مانده در بخش آمادگی انتشار نمایش داده می‌شوند"}>انتشار آزمون کنکوری</button>
    </div>
  </form>;
}
