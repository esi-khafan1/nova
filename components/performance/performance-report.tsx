"use client";
import {useEffect,useState} from "react";
import type {Timing} from "@/lib/performance/trace";
export function PerformanceReport({route,stages,readyMs}:{route:string;stages:Timing[];readyMs:number|null}) {
 const [copied,setCopied]=useState(false);
 const [browser,setBrowser]=useState<{type:string;duration_ms:number;waiting_ms:number;receiving_ms:number;transfer_bytes:number}[]>([]);
 useEffect(()=>{
  const collect=()=>{
   const entries=[...performance.getEntriesByType("navigation"),...performance.getEntriesByType("resource")];
   const selected=entries.filter(entry=>{try{return new URL(entry.name).origin===location.origin&&new URL(entry.name).pathname===route;}catch{return false;}}).slice(-5) as PerformanceResourceTiming[];
   setBrowser(selected.map(e=>({type:e.entryType,duration_ms:Math.round(e.duration),waiting_ms:Math.max(0,Math.round(e.responseStart-e.requestStart)),receiving_ms:Math.max(0,Math.round(e.responseEnd-e.responseStart)),transfer_bytes:e.transferSize})));
  };
  collect();
  const observer=new PerformanceObserver(collect);observer.observe({type:"resource",buffered:true});
  return ()=>observer.disconnect();
 },[route]);
 const report=JSON.stringify({version:1,route,server_ready_ms:readyMs,stages,browser_requests:browser},null,2);
 return <section className="portal-card" style={{marginBlock:24,overflowWrap:"anywhere"}} aria-label="گزارش تشخیص کندی">
  <h2>اندازه‌گیری موقت سرعت</h2>
  <p>عددها میلی‌ثانیه هستند. زمان آماده‌شدن داده‌ها در سرور، زمان کامل دانلود یا رندر مرورگر نیست. مرحله‌های موازی را با هم جمع نکن.</p>
  <ul>{stages.map((s,i)=><li key={i}><bdi>{s.stage}</bdi>: <bdi>{s.ms} ms</bdi></li>)}</ul>
  {readyMs!==null&&<p>از ورود به middleware تا آماده‌شدن گزارش: <bdi>{readyMs} ms</bdi></p>}
  <p>مرحلهٔ debug_access فقط سربار بررسی مجوز این ابزار است؛ جزو کار اصلی صفحه نیست.</p>
  <button className="button button-secondary" type="button" onClick={async()=>{try{await navigator.clipboard.writeText(report);setCopied(true);}catch{setCopied(false);}}}>{copied?"گزارش کپی شد":"کپی گزارش بدون اطلاعات شخصی"}</button>
  <details><summary>متن گزارش برای کپی دستی</summary><pre dir="ltr" style={{whiteSpace:"pre-wrap",fontSize:12}}>{report}</pre></details>
  {browser.length>0&&<details><summary>زمان درخواست‌های همین مسیر در مرورگر (ممکن است شامل پیش‌واکشی باشد)</summary><ul>{browser.map((b,i)=><li key={i}><bdi>{b.type}: total {b.duration_ms} ms / waiting {b.waiting_ms} ms / receiving {b.receiving_ms} ms / {b.transfer_bytes} bytes</bdi></li>)}</ul></details>}
  <p>برای زمان کامل درخواست و Receiving، تب Network مرورگر را هم کنار این گزارش بررسی کن.</p>
 </section>;
}
