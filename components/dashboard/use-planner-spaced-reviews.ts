"use client";
import {useEffect,useRef,useState} from 'react';
import {createClient} from '@/lib/supabase/client';
import {parseSpacedReviews,type SpacedReview} from '@/lib/planner-spaced-reviews';

export function usePlannerSpacedReviews(studentId:string,weekStart:string,enabled:boolean){
 const [state,setState]=useState<{key:string;rows:SpacedReview[];error:string}>({key:'',rows:[],error:''});
 const [attempt,setAttempt]=useState(0),[pending,setPending]=useState(false);
 const busy=useRef(false),key=JSON.stringify([studentId,weekStart]);
 useEffect(()=>{if(!enabled||!studentId)return;let cancelled=false;
  void (async()=>{try{const {data,error}=await createClient({planner:true}).rpc('planner_spaced_reviews_week',{target_student_id:studentId,target_week_start:weekStart});if(error)throw error;const rows=parseSpacedReviews(data);if(!cancelled)setState({key,rows,error:''});}catch{if(!cancelled)setState({key,rows:[],error:'دریافت مرورهای این هفته انجام نشد.'});}})();
  return()=>{cancelled=true};
 },[studentId,weekStart,enabled,attempt,key]);
 const remove=async(row:SpacedReview)=>{
  if(busy.current||state.key!==key||!state.rows.some(r=>r.id===row.id))return;
  if(!window.confirm('فقط این نوبت مرور فوراً حذف شود؟ این تغییر مستقل از انتشار برنامه است.'))return;
  busy.current=true;setPending(true);
  try{const {error}=await createClient({planner:true}).rpc('planner_cancel_spaced_review',{target_review_id:row.id});if(error)throw error;setAttempt(n=>n+1);}
  catch{setState(current=>current.key===key?{...current,error:'حذف مرور انجام نشد؛ دوباره تلاش کن.'}:current);}
  finally{busy.current=false;setPending(false);}
 };
 return {rows:enabled&&state.key===key?state.rows:[],error:enabled&&state.key===key?state.error:'',pending,remove,retry:()=>setAttempt(n=>n+1)};
}
