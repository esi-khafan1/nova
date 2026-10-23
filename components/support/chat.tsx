"use client";
import {useSupportLive} from "./use-live";
import {useEffect,useRef,useState} from "react";
type Message={id:number;sender:"visitor"|"support";body:string;created_at:string};
export function SupportChat({thread}:{thread?:string}){
 const [messages,setMessages]=useState<Message[]>([]),[text,setText]=useState(""),[error,setError]=useState(""),[busy,setBusy]=useState(false),[ready,setReady]=useState(false);
 const [topic,setTopic]=useState<string|null>(null),[revision,setRevision]=useState(0);
 const live=useSupportLive(topic,()=>setRevision(r=>r+1));
 const cursor=useRef(0),end=useRef<HTMLDivElement>(null),inFlight=useRef(false);
 const base=thread?`/api/support?staff=1&thread=${encodeURIComponent(thread)}`:"/api/support?visitor=1";
 function append(batch:Message[]){setMessages(old=>{const map=new Map(old.map(m=>[m.id,m]));for(const m of batch)map.set(m.id,m);return [...map.values()].sort((a,b)=>a.id-b.id);});if(batch.length)cursor.current=Math.max(cursor.current,...batch.map(m=>m.id));}
 useEffect(()=>{
  let cancelled=false,timer:ReturnType<typeof setTimeout>;const controller=new AbortController();
  async function read(){
   let more=false;
   try{if(!document.hidden&&!inFlight.current){const response=await fetch(`${base}&after=${cursor.current}`,{cache:"no-store",signal:controller.signal});const data=await response.json();if(!cancelled){if(!response.ok){setError(data.error);if(data.reset||response.status===401||response.status===403){setMessages([]);setText("");setTopic(null);cursor.current=0;setReady(false);}}else{append(data.messages??[]);setTopic(data.realtime_topic??null);setReady(true);setError("");more=data.messages?.length===200;}}}}
   catch{if(!cancelled)setError("ارتباط قطع شد؛ پیام‌ها با برقراری ارتباط دوباره دریافت می‌شوند.");}
   if(!cancelled&&more)timer=setTimeout(read,10);
  }
  read();return()=>{cancelled=true;controller.abort();clearTimeout(timer);};
 },[base,revision]);
 useEffect(()=>{end.current?.scrollIntoView({block:"nearest"});},[messages.length]);
 async function send(e:React.FormEvent){e.preventDefault();if(busy||!ready||!text.trim())return;setBusy(true);inFlight.current=true;setError("");
  try{const response=await fetch(`${base}&after=${cursor.current}`,{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify({message:text})});const data=await response.json();if(!response.ok)setError(data.error);else{append(data.messages??[]);setTopic(data.realtime_topic??null);setText("");}}
  catch{setError("پیام ارسال نشد؛ دوباره تلاش کن.");}finally{setBusy(false);inFlight.current=false;}
 }
 return <div className="support-chat"><p className="support-note" role="status">{live==="idle"?"برای شروع گفت‌وگو پیامت را بنویس.":live==="connected"?"ارتباط زنده برقرار است.":live==="reconnecting"?"اتصال زنده موقتاً برقرار نیست؛ پیام‌ها محفوظ‌اند و دریافت دوباره ادامه دارد.":"پیام‌ها ذخیره می‌شوند؛ اتصال گفت‌وگو در حال آماده‌سازی است."}</p><p className="support-note">پیامت ثبت می‌شود؛ پشتیبانی در اولین فرصت پاسخ می‌دهد.</p><div className="support-messages" role="log" aria-label="پیام‌های پشتیبانی" aria-live="polite">{messages.map(m=><div className={`support-message ${m.sender}`} key={m.id}><strong>{m.sender==="support"?"پشتیبانی نووا":thread?"کاربر":"شما"}</strong><p>{m.body}</p><time>{new Date(m.created_at).toLocaleTimeString("fa-IR",{hour:"2-digit",minute:"2-digit"})}</time></div>)}<div ref={end}/></div><form onSubmit={send}><label htmlFor={`support-text-${thread??"visitor"}`}>پیام شما</label><textarea id={`support-text-${thread??"visitor"}`} maxLength={2000} value={text} onChange={e=>setText(e.target.value)} required rows={2}/><button disabled={busy||!ready||!text.trim()}>{busy?"در حال ارسال…":"ارسال پیام"}</button></form>{error&&<p role="alert">{error}</p>}</div>;
}
