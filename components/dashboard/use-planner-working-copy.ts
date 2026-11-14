"use client";
import { useCallback, useEffect, useRef, useState } from 'react';
import { createClient } from '@/lib/supabase/client';
import { createPlannerDraftSession, type PlannerDraftContext, type PlannerDraftEvent } from '@/lib/planner-draft-session';
import { createPlannerDraftTransport } from '@/lib/planner-draft-transport';
import { createPlannerPublicationPreflight, type PlannerEditorSnapshot } from '@/lib/planner-publication-preflight';
import { loadFreshPlannerState } from '@/lib/planner-fresh-state';
import { restorePlannerDraft } from '@/lib/planner-draft-restore';
import { plannerGridFromPlan, plannerSnapshotFromEditor } from '@/lib/planner-plan-adapter';
import { builderItems, builderSnapshot } from '@/lib/planner-builder-adapter';
import { tehranToday } from '@/lib/student-planning';
import type { PlanItem, PlanRoutine } from './weekly-plan-builder';

type Value={title:string;notes:string;items:PlanItem[];routines:PlanRoutine[];weekExtra:Record<string,unknown>};
type Session=ReturnType<typeof createPlannerDraftSession<PlannerEditorSnapshot,string>>;
type Props={enabled:boolean;context:PlannerDraftContext;counselorId:string;planStatus:'published'|'draft'|null;value:Value;onRestore:(value:Value,status:'published'|'draft'|null)=>void;onPublished:(id:string)=>void};
const same=(a:PlannerDraftContext,b:PlannerDraftContext)=>a.studentId===b.studentId&&a.weekStart===b.weekStart&&a.planId===b.planId;
function normalizeRoutines(routines:PlanRoutine[]|undefined):PlanRoutine[] {
 return Array.from({length:7},(_,dayOfWeek)=>{const r=routines?.find(x=>x.dayOfWeek===dayOfWeek);return {dayOfWeek,subject:r?.subject??'',details:r?.details??'',secondSubject:r?.secondSubject??'',secondDetails:r?.secondDetails??''};});
}
/** The legacy form is disabled while a working copy is opening. Context changes
 * must use beforeSwitch so an unsaved revision cannot be abandoned silently. */
export function usePlannerWorkingCopy(props:Props) {
 const latest=useRef(props);latest.current=props;
 const session=useRef<Session|null>(null),active=useRef<PlannerDraftContext|null>(null),baseline=useRef('');
 const [phase,setPhase]=useState<'opening'|'ready'|'error'|'switching'|'publishing'>(props.enabled?'opening':'ready');
 const phaseRef=useRef(phase);phaseRef.current=phase;
 const [status,setStatus]=useState(''),[warning,setWarning]=useState('');
 const contextKey=JSON.stringify(props.context);
 useEffect(()=>{
  if(!props.enabled)return;
  const context=JSON.parse(contextKey) as PlannerDraftContext,counselorId=props.counselorId;
  if(!context.studentId||!counselorId)return;
  let cancelled=false;
  setPhase('opening');setStatus('در حال دریافت پیش‌نویس خصوصی...');setWarning('');active.current=null;
  const client=createClient();
  const transport=createPlannerDraftTransport<PlannerEditorSnapshot>(client,value=>value as PlannerEditorSnapshot);
  let draft:Session|null=null;
  void (async()=>{
   try{
    const fresh=await loadFreshPlannerState(client,context,counselorId);
    if(cancelled)return;
    const current=latest.current.value;
    const grid=fresh.plan?plannerGridFromPlan(fresh.plan,fresh.completed,fresh.extras,fresh.today):null;
    // A new plan has no published grid; retain the initial form's own blocks.
    const initialSnapshot=grid?plannerSnapshotFromEditor({title:fresh.plan!.title,notes:fresh.plan!.notes??'',weekStart:context.weekStart,today:fresh.today,planStatus:fresh.plan!.status,grid,routines:normalizeRoutines(fresh.plan!.routines),weekExtra:fresh.extras.week}):latestSnapshot(current,context,null);
    let opened:Extract<PlannerDraftEvent<PlannerEditorSnapshot>,{type:'opened'}>|null=null;
    // open emits synchronously after load; use a dedicated transport wrapper to
    // capture the response without ever writing over a stored draft on failure.
    const loaded=await transport.load(context);
    if(cancelled)return;
    const restored=loaded?restorePlannerDraft({snapshot:loaded.snapshot,context,today:fresh.today,freshPlan:fresh.plan,freshPlanUpdatedAt:fresh.planUpdatedAt,basePlanUpdatedAt:loaded.basePlanUpdatedAt,completed:fresh.completed,publishedExtras:fresh.extras}):null;
    // Reuse the already-loaded value; a second network load could observe a
    // different revision. CAS still rejects concurrent changes after this read.
    let firstLoad=true;
    const oneShotTransport={...transport,load:async(c:PlannerDraftContext)=>{if(firstLoad){firstLoad=false;return loaded;}return transport.load(c);}};
    const real=createPlannerDraftSession<PlannerEditorSnapshot,string>({transport:oneShotTransport,preparePublication:createPlannerPublicationPreflight(c=>loadFreshPlannerState(client,c,counselorId)),onEvent:event=>{
     if(cancelled)return;
     if(event.type==='opened')opened=event;
     if(event.type==='save-state') {
      setStatus(event.state==='saved'?'پیش‌نویس خصوصی ذخیره شد.':event.state==='saving'?'در حال ذخیرهٔ پیش‌نویس...':event.state==='dirty'?'تغییرات در انتظار ذخیره است.':event.state==='error'?'ذخیرهٔ پیش‌نویس انجام نشد.':'');
      if(event.state==='error')setWarning('تغییرات هنوز در این صفحه هستند، اما ذخیره نشده‌اند. دوباره تلاش کن یا پس از بررسی، پیش‌نویس را حذف کن.');
     }
     if(event.type==='error')setWarning(event.error instanceof Error?event.error.message:'عملیات انجام نشد؛ پیش‌نویس حفظ شده است.');
    }});
    draft=real;session.current=real;
    if(!(await real.open(context,initialSnapshot,fresh.planUpdatedAt))||cancelled||!opened)throw new Error('دریافت پیش‌نویس انجام نشد.');
    const value:Value=restored?{title:restored.title,notes:restored.notes,items:builderItems(restored.grid),routines:restored.routines,weekExtra:restored.weekExtra}:{title:initialSnapshot.title,notes:initialSnapshot.notes,items:builderItems(initialSnapshot.editor.grid),routines:initialSnapshot.routines,weekExtra:initialSnapshot.editor.weekExtra};
    if(restored?.conflicts.length)setWarning('برنامه یا وضعیت فعالیت‌ها تغییر کرده است. پیش‌نویس حفظ شد؛ پیش از انتشار تعارض‌ها را بررسی کن.');
    baseline.current=JSON.stringify(value);active.current=context;latest.current.onRestore(value,fresh.plan?.status??null);setPhase('ready');setStatus(loaded?'پیش‌نویس خصوصی بازیابی شد.':'آمادهٔ ذخیرهٔ خصوصی تغییرات');
   }catch{if(!cancelled){setPhase('error');setStatus('');setWarning('دریافت اطلاعات یا پیش‌نویس انجام نشد. صفحه را تازه‌سازی کن؛ هیچ تغییری منتشر نشده است.');}}
  })();
  return()=>{cancelled=true;draft?.dispose();if(session.current===draft)session.current=null;active.current=null;};
 },[props.enabled,contextKey,props.counselorId]);
 useEffect(()=>{
  if(!props.enabled||phase!=='ready'||!active.current||!same(active.current,props.context)||!session.current)return;
  const signature=JSON.stringify(props.value);if(signature===baseline.current)return;
  try{const snapshot=latestSnapshot(props.value,props.context,props.planStatus);session.current.update(snapshot);baseline.current=signature;}
  catch{setWarning('ذخیرهٔ خودکار ممکن نشد؛ مقادیر برنامه را بررسی کن.');}
 },[props.enabled,props.value,props.context,props.planStatus,phase]);
 useEffect(()=>{
  if(!props.enabled)return;
  const handler=(event:BeforeUnloadEvent)=>{if(session.current?.hasPendingWork()||JSON.stringify(latest.current.value)!==baseline.current){event.preventDefault();event.returnValue='';}};
  const navigate=(event:MouseEvent)=>{
   if(event.defaultPrevented||event.button!==0||event.metaKey||event.ctrlKey||event.shiftKey||event.altKey||!session.current||(!session.current.hasPendingWork()&&JSON.stringify(latest.current.value)===baseline.current))return;
   const link=event.target instanceof Element?event.target.closest('a[href]') as HTMLAnchorElement|null:null;
   if(!link||link.target&&link.target!=='_self'||link.hasAttribute('download'))return;
   const target=new URL(link.href,location.href);
   if(target.origin!==location.origin)return; // The browser's beforeunload guard handles external navigation.
   event.preventDefault();event.stopPropagation();
   if(phaseRef.current!=='ready'){setWarning('ابتدا منتظر پایان عملیات بمان.');return;}
   const selected=session.current;phaseRef.current='switching';setPhase('switching');
   void Promise.resolve().then(()=>{
    if(JSON.stringify(latest.current.value)!==baseline.current){selected.update(latestSnapshot(latest.current.value,latest.current.context,latest.current.planStatus));baseline.current=JSON.stringify(latest.current.value);}
    return selected.flush();
   }).then(ok=>{if(ok)window.location.assign(target.href);else{setPhase('ready');setWarning('تغییرات ذخیره نشده‌اند؛ ابتدا مشکل ذخیره را برطرف کن.');}}).catch(()=>{setPhase('ready');setWarning('تغییرات ذخیره نشده‌اند؛ مقادیر برنامه را بررسی کن.');});
  };
  window.addEventListener('beforeunload',handler);document.addEventListener('click',navigate,true);
  return()=>{window.removeEventListener('beforeunload',handler);document.removeEventListener('click',navigate,true);};
 },[props.enabled]);
 const beforeSwitch=useCallback(async()=>{
  if(!latest.current.enabled)return true;
  if(phase!=='ready'||phaseRef.current!=='ready'||!session.current)return false;
  phaseRef.current='switching';setPhase('switching');
  try{
   if(JSON.stringify(latest.current.value)!==baseline.current){session.current.update(latestSnapshot(latest.current.value,latest.current.context,latest.current.planStatus));baseline.current=JSON.stringify(latest.current.value);}
   const ok=await session.current.flush();setPhase('ready');
   if(!ok)setWarning('تغییرات ذخیره نشده‌اند؛ ابتدا مشکل ذخیره را برطرف کن.');return ok;
  }catch{setPhase('ready');setWarning('تغییرات ذخیره نشده‌اند؛ دوباره تلاش کن.');return false;}
 },[phase]);
 const retry=useCallback(async()=>{if(session.current){setWarning('');await session.current.retry();}},[]);
 const discard=useCallback(async()=>{
  if(!session.current||phaseRef.current!=='ready')return;
  phaseRef.current='switching';setPhase('switching');setWarning('');
  try{if(await session.current.discard()){baseline.current=JSON.stringify(latest.current.value);window.location.reload();return;}}
  catch{/* Keep the editor and draft intact. */}
  setPhase('ready');setWarning('حذف پیش‌نویس انجام نشد؛ تغییرات حفظ شده‌اند.');
 },[]);
 const publish=useCallback(async()=>{
  if(!session.current||phase!=='ready'||phaseRef.current!=='ready')return;
  try{session.current.update(latestSnapshot(latest.current.value,latest.current.context,latest.current.planStatus));baseline.current=JSON.stringify(latest.current.value);}
  catch{setWarning('مقادیر برنامه برای ذخیره معتبر نیست.');return;}
  phaseRef.current='publishing';setPhase('publishing');setWarning('');const id=await session.current.publish();
  if(id){setStatus('برنامه منتشر شد.');latest.current.onPublished(id);}else setPhase('ready');
 },[phase]);
 return {phase,status,warning,beforeSwitch,retry,publish,discard};
}
function latestSnapshot(value:Value,context:PlannerDraftContext,status:'published'|'draft'|null):PlannerEditorSnapshot {
 return builderSnapshot({...value,weekStart:context.weekStart,today:tehranToday(),planStatus:status});
}
