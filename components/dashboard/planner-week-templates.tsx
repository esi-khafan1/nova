"use client";
import { useCallback, useEffect, useRef, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import { addDays, formatPersianWeekday, parseIsoDate } from "@/lib/persian-date";
import { applyWeekTemplate, makeWeekTemplate, parseWeekTemplate, type TemplateMode, type WeekTemplate } from "@/lib/planner-week-templates";
import type { PlanItem, PlanRoutine } from "./weekly-plan-builder";
import styles from "./planner-week-templates.module.css";

type Preset={id:string;name:string;revision:string;pinned:boolean;template:WeekTemplate};
function parsePresets(value:unknown):Preset[] {
 if(!Array.isArray(value))throw new Error('Invalid presets');
 return value.map(raw=>{
  if(!raw||typeof raw!=='object'||Array.isArray(raw)||typeof raw.id!=='string'||!raw.id||typeof raw.name!=='string'||!raw.name.trim()||raw.name.length>120||typeof raw.pinned!=='boolean'||typeof raw.revision!=='string'||!/^[1-9][0-9]*$/.test(raw.revision))throw new Error('Invalid preset');
  return {id:raw.id,name:raw.name,pinned:raw.pinned,revision:raw.revision,template:parseWeekTemplate(raw.payload)};
 });
}
function freshKey(){return `preset-${Array.from(crypto.getRandomValues(new Uint32Array(4)),n=>n.toString(16).padStart(8,'0')).join('')}`;}
export function PlannerWeekTemplates({weekStart,items,routines,lockedDays,onApply}:{weekStart:string;items:PlanItem[];routines:PlanRoutine[];lockedDays:boolean[];onApply:(items:PlanItem[],routines:PlanRoutine[])=>void}) {
 const [open,setOpen]=useState(false),[presets,setPresets]=useState<Preset[]|null>(null),[name,setName]=useState(''),[rename,setRename]=useState<Record<string,string>>({});
 const [mode,setMode]=useState<TemplateMode>('empty'),[selected,setSelected]=useState<boolean[]>(()=>lockedDays.map(locked=>!locked));
 const [busy,setBusy]=useState(false),[message,setMessage]=useState(''),[error,setError]=useState('');
 const sequence=useRef(0),mutating=useRef(false);
 const load=useCallback(async()=>{
  const id=++sequence.current;setError('');
  try{const {data,error}=await createClient().rpc('planner_list_presets',{target_kind:'week'});if(error)throw error;const result=parsePresets(data);if(id===sequence.current)setPresets(result);}
  catch{if(id===sequence.current){setPresets(null);setError('دریافت قالب‌ها انجام نشد؛ دوباره تلاش کن.');}}
 },[]);
 useEffect(()=>{const current=sequence;if(open)void load();return()=>{current.current++}},[open,load]);
 const change=async(operation:()=>PromiseLike<{error:unknown}>,success:string)=>{
  if(mutating.current)return;mutating.current=true;setBusy(true);setError('');setMessage('');
  try{const result=await operation();if(result.error)throw result.error;await load();setMessage(success);}
  catch{setError('تغییر قالب ثبت نشد. دوباره تلاش کن؛ اگر قالب در دستگاه دیگری تغییر کرده، فهرست را تازه‌سازی کن.');}
  finally{mutating.current=false;setBusy(false);}
 };
 const save=()=>{
  try{
   const title=name.trim();if(!title||title.length>120)throw new Error('نام قالب را وارد کن.');
   const payload=makeWeekTemplate(items,routines);
   void change(()=>createClient().rpc('planner_save_preset',{target_id:null,target_kind:'week',target_name:title,target_payload:payload,target_pinned:false,expected_revision:null}),'قالب هفته ذخیره شد.');
  }catch(e){setError(e instanceof Error&&e.message==='نام قالب را وارد کن.'?e.message:'قالب ذخیره نشد؛ مقدار فعالیت‌ها را بررسی کن.');}
 };
 const update=(preset:Preset,patch:{name?:string;pinned?:boolean})=>{
  const title=(patch.name??preset.name).trim();if(!title||title.length>120){setError('نام قالب را وارد کن.');return;}
  void change(()=>createClient().rpc('planner_save_preset',{target_id:preset.id,target_kind:'week',target_name:title,target_payload:preset.template,target_pinned:patch.pinned??preset.pinned,expected_revision:preset.revision}),'قالب به‌روز شد.');
 };
 const apply=(preset:Preset)=>{
  try{if(!selected.some(Boolean))throw new Error('حداقل یک روز قابل ویرایش انتخاب کن.');
   const result=applyWeekTemplate({items,routines,template:preset.template,mode,selected,lockedDays,newKey:freshKey});onApply(result.items,result.routines);
   setError('');setMessage('قالب به فرم برنامه اضافه شد؛ برای نمایش به دانش‌آموز باید برنامه را منتشر کنی.');
  }catch(e){setError(e instanceof Error?e.message:'اعمال قالب انجام نشد.');setMessage('');}
 };
 return <details className={styles.wrap} open={open} onToggle={e=>setOpen(e.currentTarget.open)}>
  <summary>قالب‌های هفته</summary>
  <p className={styles.intro}>هفتهٔ فعلی را به‌عنوان قالب شخصی ذخیره کن. تیک‌ها، شناسه‌ها و اتصال آزمون در قالب کپی نمی‌شوند.</p>
  <div className={styles.form}><label>نام قالب<input className={styles.input} value={name} maxLength={120} onChange={e=>setName(e.target.value)} onKeyDown={e=>{if(e.key==='Enter'){e.preventDefault();if(!busy)save()}}}/></label><button className={styles.button} type="button" disabled={busy} onClick={save}>ذخیرهٔ هفته به‌عنوان قالب</button><button className={styles.button} type="button" disabled={busy} onClick={()=>void load()}>تازه‌سازی فهرست</button></div>
  <label className={styles.mode}>روش اعمال<select value={mode} onChange={e=>setMode(e.target.value as TemplateMode)}><option value="empty">فقط جای خالی</option><option value="replace">جایگزینی فعالیت‌ها</option><option value="complete">جایگزینی همراه روتین</option></select></label>
  <p className={styles.intro}>روزهای مقصد را انتخاب کن. فعالیت انجام‌شده، آزمون متصل و روز گذشته جایگزین نمی‌شوند.</p>
  <div className={styles.days}>{lockedDays.map((locked,i)=><label key={i}><input type="checkbox" disabled={locked} checked={selected[i]&&!locked} onChange={e=>setSelected(current=>current.map((x,n)=>n===i?e.target.checked:x))}/>{formatPersianWeekday(addDays(parseIsoDate(weekStart),i))}</label>)}</div>
  {error&&<p className={styles.notice} role="alert">{error}</p>}{message&&<p className={styles.success} role="status">{message}</p>}
  {presets===null&&!error&&<p className={styles.intro}>در حال دریافت قالب‌ها...</p>}
  {presets?.length===0&&<p className={styles.intro}>هنوز قالبی ذخیره نشده است.</p>}
  <div className={styles.list}>{presets?.map(preset=><article className={styles.card} key={preset.id}>
   <div className={styles.cardHeader}><span className={styles.title}>{preset.name} {preset.pinned&&<span className={styles.pin}>سنجاق‌شده</span>}</span><div className={styles.actions}><button className={styles.button} type="button" disabled={busy} onClick={()=>apply(preset)}>اعمال روی هفته</button><button className={styles.button} type="button" disabled={busy} onClick={()=>update(preset,{pinned:!preset.pinned})}>{preset.pinned?'برداشتن سنجاق':'سنجاق کردن'}</button><button className={styles.button} type="button" disabled={busy} onClick={()=>{if(window.confirm(`قالب «${preset.name}» حذف شود؟`))void change(()=>createClient().rpc('planner_delete_preset',{target_id:preset.id,expected_revision:preset.revision}),'قالب حذف شد.')}}>حذف</button></div></div>
   <div className={styles.form}><label>تغییر نام<input className={styles.input} value={rename[preset.id]??preset.name} maxLength={120} onChange={e=>setRename(current=>({...current,[preset.id]:e.target.value}))} onKeyDown={e=>{if(e.key==='Enter'){e.preventDefault();if(!busy)update(preset,{name:rename[preset.id]??preset.name})}}}/></label><button className={styles.button} type="button" disabled={busy} onClick={()=>update(preset,{name:rename[preset.id]??preset.name})}>ثبت نام</button></div>
  </article>)}</div>
 </details>;
}
