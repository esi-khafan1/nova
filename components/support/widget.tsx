"use client";
import {usePathname} from "next/navigation";
import {lazy,Suspense,useEffect,useRef,useState} from "react";
import "./support.css";
const Chat=lazy(()=>import('./chat').then(m=>({default:m.SupportChat})));
export function SupportWidget(){
 const pathname=usePathname();
 const [open,setOpen]=useState(false);const trigger=useRef<HTMLButtonElement>(null),panel=useRef<HTMLElement>(null);
 useEffect(()=>{setOpen(false);},[pathname]);
 useEffect(()=>{if(!open)return;panel.current?.querySelector<HTMLButtonElement>('button')?.focus();function key(e:KeyboardEvent){if(e.key==='Escape'){setOpen(false);trigger.current?.focus();}}document.addEventListener('keydown',key);return()=>document.removeEventListener('keydown',key);},[open]);
 return <div className="nova-support" dir="rtl">{open&&<section ref={panel} className="support-popup" role="dialog" aria-label="گفت‌وگو با پشتیبانی نووا"><header><strong>پشتیبانی نووا</strong><button aria-label="بستن پشتیبانی" onClick={()=>{setOpen(false);trigger.current?.focus();}}>×</button></header><Suspense fallback={<p>در حال دریافت گفت‌وگو…</p>}><Chat/></Suspense></section>}<button ref={trigger} className="support-launcher" aria-label="گفت‌وگو با پشتیبانی" aria-expanded={open} onClick={()=>setOpen(o=>!o)}><svg aria-hidden="true" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8"><path d="M4 13v-2a8 8 0 0 1 16 0v2M4 12H2v7h4v-7H4Zm16 0h2v7h-4v-7h2ZM18 19c0 2-3 3-6 3"/></svg></button></div>;
}
