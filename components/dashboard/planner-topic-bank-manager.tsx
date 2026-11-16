"use client";
import { useCallback, useEffect, useState } from 'react';
import { createClient } from '@/lib/supabase/client';
import { curriculumBooks, type Grade, type PreparationTrack } from '@/lib/planning-curriculum';
import { PlannerBankChapterInput } from '@/components/dashboard/planner-bank-chapter-input';
import { studyFieldLabels, type StudyField } from '@/lib/study-catalog';
import styles from './planner-week-templates.module.css';
type Topic={id:string;revision:string;title:string;pageStart:number|null;pageEnd:number|null;order:number;hiddenFromSelection:boolean};
const fields:StudyField[]=['mathematics','experimental_sciences','humanities','arts','foreign_languages'];
function parse(value:unknown):Topic[]{
 if(!Array.isArray(value))throw Error('Invalid topics');
 return value.map(x=>{if(!x||typeof x!=='object'||typeof x.id!=='string'||typeof x.revision!=='string'||!/^[1-9][0-9]*$/.test(x.revision)||typeof x.title!=='string'||!Number.isInteger(x.order)||!(x.pageStart===null||Number.isInteger(x.pageStart))||!(x.pageEnd===null||Number.isInteger(x.pageEnd))||(x.hiddenFromSelection!==undefined&&typeof x.hiddenFromSelection!=='boolean'))throw Error('Invalid topic');return {id:x.id,revision:x.revision,title:x.title,pageStart:x.pageStart,pageEnd:x.pageEnd,order:x.order,hiddenFromSelection:x.hiddenFromSelection===true}});
}
export function PlannerTopicBankManager(){
 const [field,setField]=useState<StudyField>('experimental_sciences'),[grade,setGrade]=useState<Grade>(12),[track,setTrack]=useState<PreparationTrack>('konkur'),[subject,setSubject]=useState(''),[chapter,setChapter]=useState('');
 const [topics,setTopics]=useState<Topic[]|null>(null),[loading,setLoading]=useState(false),[error,setError]=useState(''),[notice,setNotice]=useState('');
 const [editing,setEditing]=useState<Topic|null>(null),[title,setTitle]=useState(''),[start,setStart]=useState(''),[end,setEnd]=useState(''),[position,setPosition]=useState('0');
 const books=curriculumBooks(grade===9?null:field,grade,track),chapters=books.find(x=>x.subject===subject)?.chapters??[];
 const load=useCallback(async()=>{
  if(!subject||!chapter){setTopics(null);return false;}
  setLoading(true);setError('');try{const {data,error}=await createClient().rpc('planner_list_topics',{target_edition:'1405',target_field:grade===9?'all':field,target_grade:String(grade),target_track:track,target_subject:subject,target_chapter:chapter});if(error)throw error;setTopics(parse(data));return true;}
  catch{setTopics(null);setError('دریافت بانک مباحث انجام نشد.');return false;}finally{setLoading(false)}
 },[field,grade,track,subject,chapter]);
 useEffect(()=>{let cancelled=false;if(!subject||!chapter){setTopics(null);return;}
  setTopics(null);setError('');setLoading(true);
  void createClient().rpc('planner_list_topics',{target_edition:'1405',target_field:grade===9?'all':field,target_grade:String(grade),target_track:track,target_subject:subject,target_chapter:chapter}).then(({data,error})=>{
   if(cancelled)return;try{if(error)throw error;setTopics(parse(data));}catch{setError('دریافت بانک مباحث انجام نشد.');}finally{setLoading(false)}
  });return()=>{cancelled=true};
 },[field,grade,track,subject,chapter]);
 const reset=()=>{setEditing(null);setTitle('');setStart('');setEnd('');setPosition(String(topics?.length??0));};
 const save=async()=>{
  if(loading)return;const a=start.trim(),b=end.trim(),n=position.trim();
  if(!subject||!chapter||!title.trim()||title.length>160||!/^\d{1,5}$/.test(n)||Number(n)>10000||(!a)!==(!b)||(a&&(!/^\d{1,4}$/.test(a)||!/^\d{1,4}$/.test(b)||Number(a)<1||Number(b)<Number(a)))){setError('درس، فصل، عنوان، ترتیب و بازهٔ صفحه را بررسی کن.');return;}
  setLoading(true);setError('');setNotice('');
  try{const {error}=await createClient().rpc('planner_save_topic',{target_id:editing?.id??null,expected_revision:editing?.revision??null,target_edition:'1405',target_field:grade===9?'all':field,target_grade:String(grade),target_track:track,target_subject:subject,target_chapter:chapter,target_title:title.trim(),target_page_start:a?Number(a):null,target_page_end:b?Number(b):null,target_position:Number(n)});if(error)throw error;await load();reset();setNotice('مبحث ثبت شد.');}
  catch{setError('ثبت انجام نشد؛ اگر مبحث در جای دیگری تغییر کرده فهرست را تازه کن.');}finally{setLoading(false)}
 };
 const remove=async(topic:Topic)=>{if(loading||!window.confirm(`مبحث «${topic.title}» از بانک حذف شود؟ برنامه‌های قبلی حذف نمی‌شوند.`))return;setLoading(true);setError('');
  try{const {error}=await createClient().rpc('planner_delete_topic',{target_id:topic.id,expected_revision:topic.revision});if(error)throw error;await load();setNotice('مبحث از بانک حذف شد.');}catch{setError('حذف انجام نشد؛ فهرست را تازه کن.')}finally{setLoading(false)}};
 const restore=async(topic:Topic)=>{if(loading||editing)return;setLoading(true);setError('');setNotice('');
  try{const {error}=await createClient().rpc('planner_restore_hidden_topic',{target_id:topic.id,expected_revision:topic.revision});if(error)throw error;if(await load())setNotice('مبحث دوباره در انتخابگر نمایش داده می‌شود.');}
  catch{setError('نمایش دوباره انجام نشد؛ ممکن است مبحث تغییر کرده باشد. فهرست را تازه کن.')}finally{setLoading(false)}};
 return <section className={`portal-card ${styles.wrap}`}>
  <p className={styles.intro}>فقط اطلاعاتی را وارد کن که برای چاپ ۱۴۰۵ راستی‌آزمایی شده‌اند؛ صفحه‌های نامعلوم را خالی بگذار.</p>
  <div className={styles.form}>
   <label>رشته<select value={field} disabled={loading||grade===9} onChange={e=>{setField(e.target.value as StudyField);setSubject('');setChapter('');reset()}}>{fields.map(f=><option key={f} value={f}>{studyFieldLabels[f]}</option>)}</select></label>
   <label>پایه<select value={grade} disabled={loading} onChange={e=>{setGrade(Number(e.target.value) as Grade);setSubject('');setChapter('');reset()}}>{[9,10,11,12].map(g=><option value={g} key={g}>پایه {g.toLocaleString('fa-IR')}</option>)}</select></label>
   <label>مسیر<select value={track} disabled={loading} onChange={e=>{setTrack(e.target.value as PreparationTrack);setSubject('');setChapter('');reset()}}><option value="konkur">کنکور</option><option value="final_exam">دروس مدرسه</option></select></label>
   <label>درس<select value={subject} disabled={loading} onChange={e=>{setSubject(e.target.value);setChapter('');reset()}}><option value="">انتخاب درس</option>{books.map(b=><option key={b.subject} value={b.subject}>{b.subject}</option>)}</select></label>
   <label>فصل{chapters.length?<select value={chapter} disabled={loading} onChange={e=>{setChapter(e.target.value);reset()}}><option value="">انتخاب فصل</option>{chapters.map(c=><option key={c} value={c}>{c}</option>)}</select>:<PlannerBankChapterInput field={grade===9?'all':field} grade={grade} track={track} subject={subject} value={chapter} disabled={loading} onChange={value=>{setChapter(value);reset()}}/>}</label>
  </div>
  {error&&<p className={styles.notice} role="alert">{error}</p>}{notice&&<p className={styles.success} role="status">{notice}</p>}
  {subject&&chapter&&<><div className={styles.form}>
   <label>عنوان زیرمبحث<input className={styles.input} value={title} maxLength={160} onChange={e=>setTitle(e.target.value)}/></label>
   <label>از صفحه<input className={styles.input} value={start} inputMode="numeric" onChange={e=>setStart(e.target.value)}/></label><label>تا صفحه<input className={styles.input} value={end} inputMode="numeric" onChange={e=>setEnd(e.target.value)}/></label>
   <label>ترتیب<input className={styles.input} value={position} inputMode="numeric" onChange={e=>setPosition(e.target.value)}/></label>
   <button type="button" className={styles.button} disabled={loading} onClick={()=>void save()}>{editing?'ثبت ویرایش':'افزودن مبحث'}</button>{editing&&<button type="button" className={styles.button} onClick={reset}>انصراف</button>}
   <button type="button" className={styles.button} disabled={loading} onClick={()=>void load()}>تازه‌سازی</button>
  </div>
  {topics?.length===0&&<p className={styles.intro}>برای این فصل هنوز مبحثی ثبت نشده است.</p>}
  <div className={styles.list}>{topics?.map(topic=><article className={styles.card} key={topic.id}><div className={styles.cardHeader}><span className={styles.title}>{topic.title} {topic.pageStart!==null?`· صفحهٔ ${topic.pageStart.toLocaleString('fa-IR')} تا ${topic.pageEnd?.toLocaleString('fa-IR')}`:''}{topic.hiddenFromSelection&&' · پنهان از انتخابگر'}</span><div className={styles.actions}>{topic.hiddenFromSelection&&<button type="button" className={styles.button} disabled={loading||editing!==null} onClick={()=>void restore(topic)}>نمایش دوباره</button>}<button type="button" className={styles.button} disabled={loading} onClick={()=>{setEditing(topic);setTitle(topic.title);setStart(topic.pageStart?.toString()??'');setEnd(topic.pageEnd?.toString()??'');setPosition(String(topic.order))}}>ویرایش</button><button type="button" className={styles.button} disabled={loading} onClick={()=>void remove(topic)}>حذف</button></div></div></article>)}</div></>}
 </section>;
}
