"use client";
import { useEffect, useState } from 'react';
import { createClient } from '@/lib/supabase/client';
import styles from './planner-published-week-details.module.css';

type Details={goal:string;wakeTime:string;sleepTime:string;mobileLimit:string};
function parse(value:unknown):Details {
 if(!value||typeof value!=='object'||Array.isArray(value))throw Error('Invalid details');
 const raw=value as Record<string,unknown>;
 const get=(key:keyof Details,max:number)=>{const v=raw[key];if(v==null)return '';if(typeof v!=='string'||v.length>max)throw Error('Invalid details');return v;};
 return {goal:get('goal',300),wakeTime:get('wakeTime',5),sleepTime:get('sleepTime',5),mobileLimit:get('mobileLimit',100)};
}
/** Only published extras are returned by this RPC; private drafts never appear. */
export function PlannerPublishedWeekDetails({planId}:{planId:string}){
 const [data,setData]=useState<Details|null>(null),[failed,setFailed]=useState(false);
 useEffect(()=>{let cancelled=false;setData(null);setFailed(false);
  void (async()=>{try{const result=await createClient({planner:true}).rpc('planner_get_published_extras',{target_plan_id:planId});
   if(result.error){if(result.error.code==='PGRST202'||result.error.code==='42883')return;throw result.error;}
   if(!result.data||typeof result.data!=='object'||Array.isArray(result.data))throw Error('Invalid response');
   const value=parse(result.data.week);if(!cancelled)setData(value);
  }catch{if(!cancelled)setFailed(true)}})();return()=>{cancelled=true};
 },[planId]);
 if(failed)return <p className={styles.error} role="status">جزئیات هفته دریافت نشد؛ برای تلاش دوباره صفحه را تازه‌سازی کن.</p>;
 if(!data||!Object.values(data).some(Boolean))return null;
 return <section className={styles.details} aria-label="جزئیات هفته"><h3>هدف و برنامهٔ روزانه</h3><dl>
  {data.goal&&<div><dt>هدف هفته</dt><dd>{data.goal}</dd></div>}
  {data.wakeTime&&<div><dt>بیداری</dt><dd dir="auto">{data.wakeTime}</dd></div>}
  {data.sleepTime&&<div><dt>خواب</dt><dd dir="auto">{data.sleepTime}</dd></div>}
  {data.mobileLimit&&<div><dt>استفاده از موبایل</dt><dd>{data.mobileLimit}</dd></div>}
 </dl></section>;
}
