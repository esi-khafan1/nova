"use client";
import {useEffect, useState} from 'react';
import {createClient} from '@/lib/supabase/client';

/** Existing free-text values stay editable when a bank has no chapter list or
 * the optional discovery RPC is unavailable. A failed lookup is never saved. */
export function PlannerBankChapterInput({field,grade,track,subject,value,disabled,onChange,enabled=true}:{field:string;grade:number;track:string;subject:string;value:string;disabled?:boolean;onChange:(value:string)=>void;enabled?:boolean}){
 const [chapters,setChapters]=useState<string[]>([]),[manual,setManual]=useState(false);
 useEffect(()=>{let cancelled=false;setChapters([]);setManual(false);
  if(!enabled||!subject)return;
  void Promise.resolve().then(()=>createClient({planner:true}).rpc('planner_list_topic_chapters',{target_edition:'1405',target_field:field,target_grade:String(grade),target_track:track,target_subject:subject})).then(({data,error})=>{
   if(cancelled||error||!Array.isArray(data)||data.some(x=>typeof x!=='string'||!x.trim()||x.length>160))return;
   setChapters([...new Set(data)]);
  }).catch(()=>{});
  return()=>{cancelled=true};
 },[enabled,field,grade,track,subject]);
 if(!chapters.length)return <input value={value} disabled={disabled} onChange={e=>onChange(e.target.value)} placeholder="نام فصل، درس یا مبحث را وارد کن" maxLength={160}/>;
 return <span style={{display:'grid',gap:6}}>
  {!manual?<select value={chapters.includes(value)?value:value?'__previous':''} disabled={disabled} onChange={e=>{if(e.target.value==='__manual'){setManual(true);return;}if(e.target.value==='__previous')return;onChange(e.target.value);}}>
   <option value="">انتخاب فصل یا مبحث</option>
   {value&&!chapters.includes(value)&&<option value="__previous">{value} (ثبت قبلی)</option>}
   {chapters.map(chapter=><option key={chapter} value={chapter}>{chapter}</option>)}
   <option value="__manual">وارد کردن دستی…</option>
  </select>:<><input value={value} disabled={disabled} onChange={e=>onChange(e.target.value)} placeholder="نام فصل، درس یا مبحث" maxLength={160}/><button type="button" disabled={disabled} onClick={()=>setManual(false)}>انتخاب از بانک</button></>}
 </span>;
}
