"use client";

import Link from "next/link";
import { useEffect, useRef, useState, type CSSProperties } from "react";

export type PathFinderDesign = "sky" | "peach" | "horizon";
type Step = "intro" | "grade" | "field" | "result";
const grades = [{ value: 10, label: "دهم", number: "۱۰" }, { value: 11, label: "یازدهم", number: "۱۱" }, { value: 12, label: "دوازدهم", number: "۱۲" }];
const fields = [{ value: "mathematics", label: "ریاضی و فیزیک", symbol: "x²" }, { value: "experimental_sciences", label: "علوم تجربی", symbol: "atom" }, { value: "humanities", label: "علوم انسانی", symbol: "book" }];

function Sparkle({ className, style }: { className?: string; style?: CSSProperties }) {
  return <svg className={className} style={style} viewBox="0 0 40 40" fill="currentColor" aria-hidden="true"><path d="M20 0c3.2 13.2 6.8 16.8 20 20-13.2 3.2-16.8 6.8-20 20C16.8 26.8 13.2 23.2 0 20 13.2 16.8 16.8 13.2 20 0Z" /></svg>;
}

function BackgroundStars() {
  const stars = [[8,20,40,0],[14,37,24,18],[5,57,16,-12],[20,68,52,10],[12,80,18,22],[25,15,14,0],[82,14,38,0],[91,29,18,14],[85,52,56,-8],[95,70,22,6],[78,84,34,0],[69,8,14,15]];
  return <div className="nova-path-stars" aria-hidden="true">{stars.map(([x,y,size,rotation],i)=><Sparkle key={i} style={{left:`${x}%`,top:`${y}%`,width:size,height:size,transform:`rotate(${rotation}deg)`}} />)}</div>;
}

function CompassMark() {
  return <svg viewBox="0 0 48 48" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true"><circle cx="24" cy="24" r="18" /><path d="m31 17-4 10-10 4 4-10 10-4ZM24 2v6M24 40v6M2 24h6M40 24h6" /></svg>;
}

function FieldMark({ symbol }: { symbol: string }) {
  if(symbol === "x²") return <span aria-hidden="true" dir="ltr" className="nova-path-math">x²</span>;
  return <svg viewBox="0 0 32 32" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{symbol === "atom" ? <><ellipse cx="16" cy="16" rx="13" ry="5" transform="rotate(60 16 16)" /><ellipse cx="16" cy="16" rx="13" ry="5" transform="rotate(-60 16 16)" /><ellipse cx="16" cy="16" rx="13" ry="5" /><circle cx="16" cy="16" r="2" /></> : <><path d="M16 7C12 4 6 4 3 5v22c5-1 10 0 13 3 3-3 8-4 13-3V5c-4-1-9-1-13 2ZM16 7v23M7 11l5 1M7 17l5 1M20 12l5-1M20 18l5-1" /></>}</svg>;
}

export function PathFinder({ design = "sky" }: { design?: PathFinderDesign }) {
  const [step,setStep] = useState<Step>("intro");
  const [grade,setGrade] = useState<number | null>(null);
  const [field,setField] = useState<string | null>(null);
  const heading = useRef<HTMLHeadingElement>(null);
  const hasNavigated = useRef(false);
  const currentGrade = grades.find(g=>g.value===grade);
  const currentField = fields.find(f=>f.value===field);
  const stepIndex = step === "grade" ? 0 : step === "field" ? 1 : 2;

  useEffect(()=>{ if(hasNavigated.current) heading.current?.focus({preventScroll:true}); },[step]);
  function navigate(next:Step) { hasNavigated.current = true; setStep(next); }
  function reset() { setGrade(null);setField(null);navigate("intro"); }

  const title = step === "intro" ? "مسیر مناسب خودت رو پیدا کن" : step === "grade" ? "انتخاب پایه تحصیلی" : step === "field" ? "انتخاب رشته تحصیلی" : "انتخابت مشخص شد";
  const introHeading = <header className="nova-path-heading">
    <p className="nova-path-eyebrow">یک شروع روشن، به سبک خودت</p>
    <h2 id="nova-path-title" ref={heading} tabIndex={-1}>{step === "intro" ? <><span>مسیر مناسب خودت رو</span>{" "}<span className="nova-path-title-tail">پیدا کن</span></> : title}</h2>
    <p className="nova-path-subtitle">{step === "intro" ? "با دو انتخاب ساده، پایه و رشته‌ات رو مشخص کن." : step === "grade" ? "الان در کدام پایه درس می‌خوانی؟" : step === "field" ? "رشته تحصیلی‌ات رو مشخص کن تا انتخابت کامل بشه." : "پایه و رشته‌ای که انتخاب کردی، این‌ها هستند."}</p>
  </header>;

  return <section id="find-path" className={`nova-path nova-path--${design}`} aria-labelledby="nova-path-title" data-design={design} data-step={step}>
    {design === "sky" ? <div className="nova-path-approved-clusters" aria-hidden="true"><span className="cluster-left" /><span className="cluster-upper" /><span className="cluster-lower" /></div> : <BackgroundStars />}
    <div className="nova-path-inner">
      {design === "horizon" && introHeading}
      <div className={`nova-path-panel ${step === "intro" ? "is-intro" : "is-selecting"}`}>
        {design === "peach" && step === "intro" && <div className="nova-path-identity" aria-hidden="true"><div className="nova-path-orbit"><CompassMark /><Sparkle className="nova-path-orbit-star one" /><Sparkle className="nova-path-orbit-star two" /><Sparkle className="nova-path-orbit-star three" /></div><p>از دهم تا دوازدهم<br /><strong>مسیرت رو روشن کن.</strong></p></div>}
        <div className="nova-path-content">
          {step === "intro" && <div className="nova-path-symbol"><CompassMark /></div>}
          {design !== "horizon" && introHeading}
          {step === "intro" ? <>
            {design === "horizon" && <div className="nova-path-intro-points"><p><span>۰۱</span>پایهٔ تحصیلی تو</p><p><span>۰۲</span>رشتهٔ تحصیلی تو</p><p><Sparkle />یک شروع مشخص</p></div>}
            <button type="button" className="nova-path-primary" onClick={()=>navigate("grade")}>شروع کن <span aria-hidden="true">←</span></button>
            <p className="nova-path-footnote">فقط برای پایه‌های دهم، یازدهم و دوازدهم</p>
          </> : <>
            <ol className="nova-path-steps" aria-label="مراحل انتخاب">{["پایه تحصیلی","رشته تحصیلی","انتخاب تو"].map((label,i)=><li key={label} aria-current={stepIndex === i ? "step" : undefined} className={stepIndex >= i ? "is-active" : ""}><span aria-hidden="true">{["۱","۲","۳"][i]}</span>{label}</li>)}</ol>
            {step === "grade" && <fieldset className="nova-path-choices grade-choices"><legend className="nova-path-sr-only">انتخاب پایه تحصیلی</legend>{grades.map(g=><label className={`nova-path-choice ${grade===g.value ? "is-selected" : ""}`} key={g.value}><input type="radio" name={`grade-${design}`} value={g.value} checked={grade===g.value} aria-label={`پایه ${g.label}`} onChange={()=>setGrade(g.value)} /><span className="nova-path-choice-mark" aria-hidden="true">{g.number}</span><strong>{g.label}</strong></label>)}</fieldset>}
            {step === "field" && <fieldset className="nova-path-choices field-choices"><legend className="nova-path-sr-only">انتخاب رشته تحصیلی</legend>{fields.map(f=><label className={`nova-path-choice ${field===f.value ? "is-selected" : ""}`} key={f.value}><input type="radio" name={`field-${design}`} value={f.value} checked={field===f.value} aria-label={f.label} onChange={()=>setField(f.value)} /><span className="nova-path-choice-mark"><FieldMark symbol={f.symbol} /></span><strong>{f.label}</strong></label>)}</fieldset>}
            {step === "result" && <div className="nova-path-result"><dl><div><dt>پایه تحصیلی</dt><dd>{currentGrade?.label}</dd></div><div><dt>رشته تحصیلی</dt><dd>{currentField?.label}</dd></div></dl><p role="status" className="nova-path-preview-note">این بخش فعلاً پیش‌نمایش طراحی است؛ انتخاب‌ها ذخیره نمی‌شوند و هنوز پیشنهاد دورهٔ واقعی نمایش داده نمی‌شود.</p><Link href="/mag" className="nova-path-resource-link">مطالعهٔ راهنماهای نووا <span aria-hidden="true">←</span></Link></div>}
            <div className="nova-path-actions"><button type="button" className="nova-path-secondary" onClick={()=>navigate(step === "grade" ? "intro" : step === "field" ? "grade" : "field")}>بازگشت</button>{step === "result" ? <button type="button" className="nova-path-primary" onClick={reset}>انتخاب دوباره</button> : <button type="button" className="nova-path-primary" disabled={step === "grade" ? grade===null : field===null} onClick={()=>navigate(step === "grade" ? "field" : "result")}>{step === "grade" ? "ادامه" : "دیدن نتیجه انتخاب"}<span aria-hidden="true">←</span></button>}</div>
          </>}
        </div>
      </div>
    </div>
  </section>;
}
