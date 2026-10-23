"use client";
import {useEffect,useState} from "react";
import {useSupportLive} from "./use-live";
import {SupportChat} from "./chat";
import "./support.css";
type Thread={id:string;visitor_name:string;preview:string;updated_at:string;total_count:number};
export function SupportInbox(){
 const [state,setState]=useState('unanswered'),[page,setPage]=useState(0),[rows,setRows]=useState<Thread[]>([]),[chosen,setChosen]=useState<Thread|null>(null),[error,setError]=useState('');
 const [topic,setTopic]=useState<string|null>(null),[revision,setRevision]=useState(0);
 const live=useSupportLive(topic,()=>setRevision(r=>r+1));
 useEffect(()=>{let stopped=false;const controller=new AbortController();async function load(){try{if(!document.hidden){const response=await fetch(`/api/support?staff=1&state=${state}&page=${page}`,{cache:'no-store',signal:controller.signal});const data=await response.json();if(!stopped){if(response.ok){setRows(data.threads??[]);setTopic(data.realtime_topic??null);setError('');}else {setError(data.error);if(response.status===401||response.status===403){setRows([]);setChosen(null);setTopic(null);}}}}}catch{if(!stopped)setError('دریافت گفت‌وگوها انجام نشد.');}}load();return()=>{stopped=true;controller.abort();};},[state,page,revision]);
 return <><p role="status">{live==="connected"?"ارتباط زنده برقرار است.":"اتصال زنده در حال برقراری است؛ گفت‌وگوها ذخیره می‌شوند."}</p><nav className="support-tabs" aria-label="وضعیت گفت‌وگو"><button aria-pressed={state==='unanswered'} onClick={()=>{setState('unanswered');setPage(0);setChosen(null);}}>بدون پاسخ</button><button aria-pressed={state==='answered'} onClick={()=>{setState('answered');setPage(0);setChosen(null);}}>پاسخ‌داده‌شده</button></nav>{error&&<p role="alert">{error}</p>}<div className="support-inbox"><section className="portal-card"><h2>گفت‌وگوها</h2>{rows.map(t=><button className="support-thread" key={t.id} onClick={()=>setChosen(t)} aria-pressed={chosen?.id===t.id}><strong>{t.visitor_name}</strong><span>{t.preview}</span></button>)}{!rows.length&&<p>گفت‌وگویی در این بخش نیست.</p>}<div className="support-tabs"><button disabled={page===0} onClick={()=>setPage(p=>p-1)}>قبلی</button><button disabled={Number(rows[0]?.total_count??0)<=(page+1)*50} onClick={()=>setPage(p=>p+1)}>بعدی</button></div></section><section className="portal-card">{chosen?<><h2>{chosen.visitor_name}</h2><SupportChat key={chosen.id} thread={chosen.id}/></>:<p>یک گفت‌وگو را برای پاسخ انتخاب کن.</p>}</section></div></>;
}
