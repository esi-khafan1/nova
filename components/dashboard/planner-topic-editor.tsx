"use client";
import { useEffect, useState } from 'react';
import { createClient } from '@/lib/supabase/client';
import { suggestNextTopic, type BankTopic, type TopicUse } from '@/lib/planner-topics';
import type { PlannerTopic } from '@/lib/planner-grid';
import styles from './planner-week-templates.module.css';

type BankSelection={studentId:string;field:string;grade:number;track:string;subject:string;chapter:string;weekStart:string;date:string;order:number;uses:TopicUse[]};
function parseBank(value:unknown,selection:BankSelection):BankTopic[]{
 if(!Array.isArray(value))throw Error('Invalid bank');
 return value.map(raw=>{
  if(!raw||typeof raw!=='object'||Array.isArray(raw)||typeof raw.id!=='string'||!raw.id||typeof raw.title!=='string'||!raw.title.trim()||raw.title.length>160||!Number.isInteger(raw.order)||raw.order<0||raw.subject!==selection.subject||raw.chapter!==selection.chapter||raw.grade!==String(selection.grade)||raw.track!==selection.track)throw Error('Invalid bank entry');
  const a=raw.pageStart,b=raw.pageEnd;if((a===null)!==(b===null)||(a!==null&&(!Number.isInteger(a)||a<1||!Number.isInteger(b)||b<a||b>9999)))throw Error('Invalid pages');
  return {id:raw.id,subject:raw.subject,grade:selection.grade,chapter:raw.chapter,title:raw.title,pageStart:a,pageEnd:b,order:raw.order};
 });
}
const digits=(value:string)=>value.replace(/[۰-۹٠-٩]/g,c=>String('۰۱۲۳۴۵۶۷۸۹'.includes(c)?'۰۱۲۳۴۵۶۷۸۹'.indexOf(c):'٠١٢٣٤٥٦٧٨٩'.indexOf(c)));
/** Page ranges are committed as a pair, so a partially typed number never
 * enters an autosaved snapshot or silently changes a previously saved topic. */
export function PlannerTopicEditor({topics,onChange,selection}:{topics:PlannerTopic[];onChange:(topics:PlannerTopic[])=>void;selection:BankSelection}) {
 const [open,setOpen]=useState(false),[bank,setBank]=useState<BankTopic[]|null>(null),[history,setHistory]=useState<TopicUse[]|null>(null),[bankError,setBankError]=useState(false);
 const [title,setTitle]=useState(''),[start,setStart]=useState(''),[end,setEnd]=useState(''),[bankId,setBankId]=useState<string|null>(null),[error,setError]=useState('');
 const [editing,setEditing]=useState<{index:number;original:PlannerTopic}|null>(null);
 const reset=()=>{setEditing(null);setTitle('');setStart('');setEnd('');setBankId(null);setError('');};
 const {field,grade,track,subject,chapter}=selection;
 useEffect(()=>{if(!open||!subject||!chapter){setBank(null);return;}let cancelled=false;setBank(null);setHistory(null);setBankError(false);
  void (async()=>{const client=createClient();const [listed,previous]=await Promise.all([
   client.rpc('planner_list_topics',{target_edition:'1405',target_field:field,target_grade:String(grade),target_track:track,target_subject:subject,target_chapter:chapter}),
   client.rpc('planner_topic_history',{target_student_id:selection.studentId,target_before:selection.weekStart,target_grade:grade,target_track:track,target_subject:subject,target_chapter:chapter}),
  ]);
   try{if(listed.error)throw listed.error;const entries=parseBank(listed.data,{...selection,field,grade,track,subject,chapter});if(!cancelled)setBank(entries);}catch{if(!cancelled)setBankError(true);}
   try{if(previous.error||!Array.isArray(previous.data))throw previous.error??Error('Invalid history');const uses:TopicUse[]=previous.data.map((row:unknown)=>{if(!row||typeof row!=='object'||Array.isArray(row)||typeof (row as {date?:unknown}).date!=='string'||!Number.isInteger((row as {order?:unknown}).order)||!Array.isArray((row as {topicIds?:unknown}).topicIds)||(row as {topicIds:unknown[]}).topicIds.some(x=>typeof x!=='string'))throw Error('Invalid history');const r=row as {date:string;order:number;topicIds:string[]};return {studentId:selection.studentId,subject,grade,chapter,date:r.date,order:r.order,topicIds:r.topicIds};});
   if(!cancelled)setHistory(uses);
  }catch{if(!cancelled)setHistory(null)}})().catch(()=>{if(!cancelled){setBankError(true);setHistory(null)}});return()=>{cancelled=true};
 // Date, order and uses affect the suggestion, not which entries are fetched.
 // eslint-disable-next-line react-hooks/exhaustive-deps
 },[open,field,grade,track,subject,chapter,selection.studentId,selection.weekStart]);
 const suggested=bank&&history?suggestNextTopic(bank,[...history,...selection.uses],{studentId:selection.studentId,subject,chapter,grade,date:selection.date,order:selection.order}):null;
 const choose=(topic:BankTopic)=>{setTitle(topic.title);setStart(topic.pageStart?.toString()??'');setEnd(topic.pageEnd?.toString()??'');setBankId(topic.id);setError('');};
 const add=()=>{
  const name=title.trim(),a=start.trim(),b=end.trim();
  if(!name||name.length>160){setError('عنوان مبحث را وارد کن.');return;}
  if((!a)!==(!b)|| (a&&(!/^[0-9]{1,4}$/.test(a)||!/^[0-9]{1,4}$/.test(b)||Number(a)<1||Number(b)<Number(a)))){setError('ابتدا و انتهای صفحه را درست وارد کن، یا هر دو را خالی بگذار.');return;}
  if(!editing&&topics.length>=50){setError('تعداد مباحث این فعالیت بیشتر از حد مجاز است.');return;}
  const topic={title:name,pageStart:a?Number(a):null,pageEnd:b?Number(b):null,...(bankId?{bankId}:{})};
  if(editing){
   if(JSON.stringify(topics[editing.index])!==JSON.stringify(editing.original)){setError('این مبحث تغییر کرده است؛ ویرایش را لغو و دوباره شروع کن.');return;}
   onChange(topics.map((item,index)=>index===editing.index?topic:item));
  }else onChange([...topics,topic]);
  reset();
 };
 return <details className={`${styles.wrap} ${styles.ready}`} open={open} onToggle={e=>setOpen(e.currentTarget.open)}>
  <summary>زیرمبحث و صفحه</summary>
  <p className={styles.intro}>نام مبحث و در صورت نیاز بازهٔ صفحه را برای همین فعالیت ثبت کن.</p>
  {bankError&&<p className={styles.notice} role="status">بانک مباحث دریافت نشد؛ می‌توانی مبحث را دستی وارد کنی.</p>}
  {bank&&bank.length>0&&!history&&<p className={styles.notice} role="status">پیشنهاد خودکار در دسترس نیست؛ می‌توانی مبحث را از بانک انتخاب کنی.</p>}
  {bank&&bank.length===0&&<p className={styles.intro}>برای این فصل هنوز مبحثی در بانک ثبت نشده است.</p>}
  {suggested&&<div className={styles.card}><span className={styles.title}>پیشنهاد مبحث بعدی: {suggested.title}</span> <button type="button" className={styles.button} onClick={()=>choose(suggested)}>انتخاب پیشنهاد</button></div>}
  {bank&&bank.length>0&&<div className={styles.form}><label>بانک مباحث<select value="" onChange={e=>{const topic=bank.find(x=>x.id===e.target.value);if(topic)choose(topic)}}><option value="">انتخاب مبحث</option>{bank.map(topic=><option key={topic.id} value={topic.id}>{topic.title}{topic.pageStart!=null?` · ${topic.pageStart}–${topic.pageEnd}`:''}</option>)}</select></label></div>}
  {topics.length>0&&<div className={styles.list}>{topics.map((topic,index)=><div className={styles.card} key={`${index}:${topic.bankId??topic.title}`}><div className={styles.cardHeader}><span className={styles.title}>{topic.title}{topic.pageStart!=null&&topic.pageEnd!=null?` · صفحهٔ ${topic.pageStart.toLocaleString('fa-IR')} تا ${topic.pageEnd.toLocaleString('fa-IR')}`:''}</span><div><button type="button" className={styles.button} aria-label={`ویرایش ${topic.title}`} onClick={()=>{setEditing({index,original:topic});setTitle(topic.title);setStart(topic.pageStart?.toString()??'');setEnd(topic.pageEnd?.toString()??'');setBankId(topic.bankId??null);setError('');}}>ویرایش</button> <button type="button" className={styles.button} aria-label={`حذف ${topic.title}`} onClick={()=>{onChange(topics.filter((_,i)=>i!==index));reset();}}>حذف</button></div></div></div>)}</div>}
  <div className={styles.form}><label>نام زیرمبحث<input className={styles.input} value={title} maxLength={160} onChange={e=>{setTitle(e.target.value);setBankId(null)}} onKeyDown={e=>{if(e.key==='Enter'){e.preventDefault();add()}}}/></label><label>از صفحه<input className={styles.input} value={start} inputMode="numeric" maxLength={4} onChange={e=>setStart(digits(e.target.value))}/></label><label>تا صفحه<input className={styles.input} value={end} inputMode="numeric" maxLength={4} onChange={e=>setEnd(digits(e.target.value))}/></label><button type="button" className={styles.button} onClick={add}>{editing?'ثبت ویرایش':'افزودن مبحث'}</button>{editing&&<button type="button" className={styles.button} onClick={reset}>لغو ویرایش</button>}</div>
  {error&&<p className={styles.notice} role="alert">{error}</p>}
 </details>;
}
