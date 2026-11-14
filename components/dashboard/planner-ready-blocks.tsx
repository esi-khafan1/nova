"use client";
import { useCallback, useEffect, useRef, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { applyReadyBlock, makeReadyBlock, readReadyBlock, type WeekTemplate } from "@/lib/planner-week-templates";
import type { PlanItem } from "./weekly-plan-builder";
import styles from "./planner-week-templates.module.css";

type ReadyBlock={id:string;name:string;revision:string;payload:WeekTemplate};
function parseList(value:unknown):ReadyBlock[] {
 if(!Array.isArray(value))throw new Error('Invalid ready blocks');
 return value.map(raw=>{
  if(!raw||typeof raw!=='object'||Array.isArray(raw)||typeof raw.id!=='string'||!raw.id||typeof raw.name!=='string'||!raw.name.trim()||raw.name.length>120||typeof raw.revision!=='string'||!/^[1-9][0-9]*$/.test(raw.revision))throw new Error('Invalid ready block');
  readReadyBlock(raw.payload);return {id:raw.id,name:raw.name,revision:raw.revision,payload:raw.payload as WeekTemplate};
 });
}
export function PlannerReadyBlocks({item,onApply}:{item:PlanItem;onApply:(item:PlanItem)=>boolean | void}) {
 const [open,setOpen]=useState(false),[blocks,setBlocks]=useState<ReadyBlock[]|null>(null),[name,setName]=useState(''),[busy,setBusy]=useState(false),[message,setMessage]=useState(''),[error,setError]=useState('');
 const sequence=useRef(0),mutating=useRef(false);
 const load=useCallback(async()=>{
  const id=++sequence.current;setError('');
  try{const {data,error}=await createClient().rpc('planner_list_presets',{target_kind:'block'});if(error)throw error;const parsed=parseList(data);if(id===sequence.current)setBlocks(parsed);}
  catch{if(id===sequence.current){setBlocks(null);setError('دریافت بلوک‌های آماده انجام نشد؛ دوباره تلاش کن.')}}
 },[]);
 useEffect(()=>{const current=sequence;if(open)void load();return()=>{current.current++}},[open,load]);
 const save=async()=>{
  if(mutating.current)return;
  let payload:WeekTemplate;const title=name.trim();
  try{if(!title||title.length>120)throw Error('نام بلوک را وارد کن.');payload=makeReadyBlock(item);}
  catch(e){setError(e instanceof Error&&e.message==='نام بلوک را وارد کن.'?e.message:'مقادیر بلوک را بررسی کن.');return;}
  mutating.current=true;setBusy(true);setError('');setMessage('');
  try{const result=await createClient().rpc('planner_save_preset',{target_id:null,target_kind:'block',target_name:title,target_payload:payload,target_pinned:false,expected_revision:null});if(result.error)throw result.error;await load();setMessage('بلوک آماده ذخیره شد.');}
  catch{setError('ذخیرهٔ بلوک آماده انجام نشد؛ دوباره تلاش کن.');}
  finally{mutating.current=false;setBusy(false);}
 };
 const remove=async(block:ReadyBlock)=>{
  if(mutating.current||!window.confirm(`بلوک آمادهٔ «${block.name}» حذف شود؟`))return;
  mutating.current=true;setBusy(true);setError('');setMessage('');
  try{const result=await createClient().rpc('planner_delete_preset',{target_id:block.id,expected_revision:block.revision});if(result.error)throw result.error;await load();setMessage('بلوک آماده حذف شد.');}
  catch{setError('حذف بلوک انجام نشد. فهرست را تازه‌سازی کن.');}
  finally{mutating.current=false;setBusy(false);}
 };
 const apply=(block:ReadyBlock)=>{
  try{if(onApply(applyReadyBlock(item,block.payload))===false){setMessage('');return;}setError('');setMessage('بلوک آماده در فرم قرار گرفت.');}
  catch(e){setMessage('');setError(e instanceof Error?e.message:'اعمال بلوک انجام نشد.');}
 };
 return <details className={`${styles.wrap} ${styles.ready}`} open={open} onToggle={e=>setOpen(e.currentTarget.open)}>
  <summary>بلوک‌های آماده</summary>
  <p className={styles.intro}>این فعالیت را ذخیره کن یا یک بلوک آماده را در همین فعالیت قرار بده. تیک و اتصال آزمون کپی نمی‌شود.</p>
  <div className={styles.form}><label>نام بلوک<input className={styles.input} maxLength={120} value={name} onChange={e=>setName(e.target.value)} onKeyDown={e=>{if(e.key==='Enter'){e.preventDefault();if(!busy)void save()}}}/></label><button className={styles.button} type="button" disabled={busy} onClick={()=>void save()}>ذخیرهٔ بلوک آماده</button><button className={styles.button} type="button" disabled={busy} onClick={()=>void load()}>تازه‌سازی</button></div>
  {error&&<p className={styles.notice} role="alert">{error}</p>}{message&&<p className={styles.success} role="status">{message}</p>}
  {blocks===null&&!error&&<p className={styles.intro}>در حال دریافت بلوک‌ها...</p>}{blocks?.length===0&&<p className={styles.intro}>هنوز بلوک آماده‌ای ذخیره نشده است.</p>}
  <div className={styles.list}>{blocks?.map(block=><article className={styles.card} key={block.id}><div className={styles.cardHeader}><span className={styles.title}>{block.name}</span><div className={styles.actions}><button className={styles.button} type="button" disabled={busy||Boolean(item.linkedExamId||item.completed||item.locked)} onClick={()=>apply(block)}>استفاده در این فعالیت</button><button className={styles.button} type="button" disabled={busy} onClick={()=>void remove(block)}>حذف</button></div></div></article>)}</div>
 </details>;
}
