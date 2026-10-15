"use client";
import { useEffect, useRef, useState } from "react";
import { searchExamStudents } from "@/app/dashboard/exam_designer/actions";
export type ExamStudent = {id:string;full_name:string;grade:number|null;study_field:string|null};
export function ExamStudentPicker({selected,onChange}:{selected:ExamStudent[];onChange:(students:ExamStudent[])=>void}) {
 const [query,setQuery]=useState(""); const [offset,setOffset]=useState(0);
 const [rows,setRows]=useState<ExamStudent[]>([]); const [more,setMore]=useState(false);const [loading,setLoading]=useState(true);const [error,setError]=useState("");const [retry,setRetry]=useState(0);
 const request=useRef(0);
 useEffect(()=>{const version=++request.current;const timer=setTimeout(async()=>{setLoading(true);setError("");try {const result=await searchExamStudents(query,offset);if(version!==request.current)return;setRows(result.students);setMore(result.hasMore);setError(result.error??"");}catch{if(version===request.current)setError("دریافت فهرست انجام نشد.");}finally{if(version===request.current)setLoading(false);}},250);return()=>{clearTimeout(timer);request.current=version+1;};},[query,offset,retry]);
 const ids=new Set(selected.map(s=>s.id));
 return <section className="exam-student-picker"><h3>انتخاب دانش‌آموزها</h3><p>همهٔ دانش‌آموزها قابل جست‌وجو هستند؛ فقط افراد انتخاب‌شده به این آزمون دسترسی خواهند داشت.</p>
 <label>جست‌وجوی نام دانش‌آموز<input type="search" value={query} maxLength={100} onChange={e=>{setQuery(e.target.value);setOffset(0);setLoading(true);}} placeholder="نام یا نام خانوادگی…"/></label>
 <div className="exam-selected-students" aria-label="دانش‌آموزان انتخاب‌شده">{selected.map(s=><button type="button" key={s.id} onClick={()=>onChange(selected.filter(x=>x.id!==s.id))}>{s.full_name||"دانش‌آموز"} ×</button>)}</div>
 <p aria-live="polite">{selected.length.toLocaleString("fa-IR")} نفر انتخاب شده {loading&&"· در حال جست‌وجو…"}</p>
 {error?<p role="alert">{error} <button type="button" onClick={()=>setRetry(retry+1)}>تلاش دوباره</button></p>:<div className="exam-student-results" aria-busy={loading}>{rows.map(s=><label key={s.id}><input type="checkbox" checked={ids.has(s.id)} onChange={e=>onChange(e.target.checked?[...selected,s]:selected.filter(x=>x.id!==s.id))}/><span>{s.full_name||"دانش‌آموز بدون نام"}<small>{s.grade?`پایه ${s.grade.toLocaleString("fa-IR")}`:"پایه ثبت نشده"}</small></span></label>)}{!rows.length&&!loading&&<p>دانش‌آموزی پیدا نشد.</p>}</div>}
 <div className="exam-actions"><button type="button" className="button secondary" disabled={!offset||loading} onClick={()=>setOffset(Math.max(0,offset-50))}>صفحه قبل</button><button type="button" className="button secondary" disabled={!more||loading} onClick={()=>setOffset(offset+50)}>صفحه بعد</button></div>
 </section>;
}
