import { activityTypes } from "./study-catalog";
import { externalSimulationActivity } from "./external-simulation";
import { makeupActivity } from "./makeup-plan-box";
import { copyPlannerBlock, plannerGridToItems, plannerItemsToGrid } from "./planner-grid";
import type { PlanItem, PlanRoutine } from "../components/dashboard/weekly-plan-builder";

export type WeekTemplate = {version:1; days:PlanItem[][]; routines:PlanRoutine[]};
export type TemplateMode = "empty" | "replace" | "complete";
const record=(x:unknown): x is Record<string,unknown> => Boolean(x && typeof x==='object' && !Array.isArray(x));
const text=(x:unknown,max:number):x is string => typeof x==='string' && x.length<=max;
const activities=new Set<string>([...activityTypes.map(x=>x.value),externalSimulationActivity,makeupActivity]);

/** Strictly parse a counselor-owned JSON snapshot. Never trust stored JSON to
 * inject IDs, completion flags, exam links or arbitrary UI fields. */
export function parseWeekTemplate(value:unknown):WeekTemplate {
 if(!record(value)||value.version!==1||!Array.isArray(value.days)||value.days.length!==7||!Array.isArray(value.routines)||value.routines.length!==7)throw new Error('Invalid template');
 let count=0;
 const days=value.days.map((day:unknown,index:number)=>{
  if(!Array.isArray(day))throw new Error('Invalid template');
  return day.map((raw:unknown,n:number):PlanItem=>{
   count++;if(!record(raw)||!text(raw.subject,100)||!text(raw.chapter,160)||!text(raw.details,500)||
    typeof raw.activityType!=='string'||!activities.has(raw.activityType)||
    typeof raw.durationMinutes!=='number'||!Number.isInteger(raw.durationMinutes)||raw.durationMinutes<15||raw.durationMinutes>720||
    !(raw.targetTestCount===null || (typeof raw.targetTestCount==='number'&&Number.isInteger(raw.targetTestCount)&&raw.targetTestCount>=1&&raw.targetTestCount<=5000))||
    !(raw.sourceGrade===null || [9,10,11,12].includes(raw.sourceGrade as number))||
    !(raw.preparationTrack==='konkur'||raw.preparationTrack==='final_exam')||
    !(raw.recommendedPublisher===null||text(raw.recommendedPublisher,100))||typeof raw.otherPublisher!=='boolean'||
    !(raw.otherSimulationProvider===undefined||typeof raw.otherSimulationProvider==='boolean'))throw new Error('Invalid template block');
   let topics:PlanItem['topics'];
   if(raw.topics!==undefined){
    if(!Array.isArray(raw.topics)||raw.topics.length>50)throw new Error('Invalid template topics');
    topics=raw.topics.map((topic:unknown)=>{
     if(!record(topic)||!text(topic.title,160)||!topic.title.trim()||!(topic.bankId==null||text(topic.bankId,200)))throw new Error('Invalid template topic');
     const start=topic.pageStart??null,end=topic.pageEnd??null;
     if((start===null)!==(end===null)|| (start!==null && (typeof start!=='number'||!Number.isInteger(start)||start<1||start>9999||typeof end!=='number'||!Number.isInteger(end)||end<start||end>9999)))throw new Error('Invalid template pages');
     return {title:topic.title,pageStart:start as number|null,pageEnd:end as number|null,...(typeof topic.bankId==='string'?{bankId:topic.bankId}:{})};
    });
   }
   return {key:`template-${index}-${n}`,dayOfWeek:index,subject:raw.subject,chapter:raw.chapter,details:raw.details,...(topics?{topics}:{}),
    activityType:raw.activityType as PlanItem['activityType'],durationMinutes:raw.durationMinutes,targetTestCount:raw.targetTestCount,
    sourceGrade:raw.sourceGrade as PlanItem['sourceGrade'],preparationTrack:raw.preparationTrack,recommendedPublisher:raw.recommendedPublisher,
    otherPublisher:raw.otherPublisher,otherSimulationProvider:raw.otherSimulationProvider as boolean|undefined,
    id:null,sourceItemId:null,sourceDayOfWeek:null,linkedExamId:null,completed:false};
  });
 });
 if(count>100)throw new Error('Invalid template');
 const routines=value.routines.map((raw:unknown,index:number):PlanRoutine=>{
  if(!record(raw)||raw.dayOfWeek!==index||!text(raw.subject,100)||!text(raw.details,500)||!text(raw.secondSubject,100)||!text(raw.secondDetails,500))throw new Error('Invalid template routine');
  const duration=(value:unknown)=>{if(value==null)return null;if(typeof value!=='number'||!Number.isInteger(value)||value<1||value>1440)throw new Error('Invalid routine duration');return value};
  return {dayOfWeek:index,subject:raw.subject,details:raw.details,secondSubject:raw.secondSubject,secondDetails:raw.secondDetails,durationMinutes:duration(raw.durationMinutes),secondDurationMinutes:duration(raw.secondDurationMinutes)};
 });
 return {version:1,days,routines};
}

export function makeWeekTemplate(items:readonly PlanItem[],routines:readonly PlanRoutine[]):WeekTemplate {
 const grid=plannerItemsToGrid(items);
 const payload={version:1,days:grid.map((day,i)=>day.filter((x):x is PlanItem=>x!==null).map((x,n)=>copyPlannerBlock(x,i,`template-${i}-${n}-${x.key}`))),routines:routines.map(x=>({...x,secondSubject:x.secondSubject??'',secondDetails:x.secondDetails??''}))};
 return parseWeekTemplate(payload);
}

/** All checks happen before a new result is returned, so a rejected template
 * cannot partially modify a day, routine, completion or linked exam. */
export function applyWeekTemplate(input:{items:readonly PlanItem[];routines:readonly PlanRoutine[];template:WeekTemplate;mode:TemplateMode;selected:boolean[];lockedDays:boolean[];newKey:()=>string}) {
 if(input.selected.length!==7||input.lockedDays.length!==7||!['empty','replace','complete'].includes(input.mode))throw new Error('Invalid template selection');
 const template=parseWeekTemplate(input.template), grid=plannerItemsToGrid(input.items);
 if(input.selected.some((selected,i)=>selected&&input.lockedDays[i]))throw new Error('روز گذشته قابل تغییر نیست.');
 if(input.mode!=='empty'&&grid.some((day,i)=>input.selected[i]&&day.some(x=>x&&(x.completed||x.linkedExamId||x.locked))))throw new Error('روز انتخاب‌شده فعالیت انجام‌شده یا آزمون متصل دارد و جایگزین نمی‌شود.');
 const seen=new Set(input.items.map(x=>x.key));
 for(let day=0;day<7;day++){
  if(!input.selected[day])continue;
  if(input.mode!=='empty')grid[day]=[];
  for(let index=0;index<template.days[day].length;index++){
   if(input.mode==='empty'&&grid[day][index])continue;
   const key=input.newKey();if(!key||seen.has(key))throw new Error('Duplicate template key');seen.add(key);
   grid[day].push(copyPlannerBlock(template.days[day][index],day,key));
  }
 }
 const result=plannerGridToItems(grid);
 if(result.length>100)throw new Error('برنامه نمی‌تواند بیشتر از ۱۰۰ فعالیت داشته باشد.');
 const routines=input.routines.map((routine,i)=>input.mode==='complete'&&input.selected[i]?structuredClone(template.routines[i]):structuredClone(routine));
 return {items:result,routines};
}

/** A ready block contains editor values only, never a student item identity. */
export function makeReadyBlock(item:PlanItem):WeekTemplate {
 const routines=Array.from({length:7},(_,dayOfWeek)=>({dayOfWeek,subject:'',details:'',secondSubject:'',secondDetails:''}));
 return makeWeekTemplate([item],routines);
}
export function readReadyBlock(value:unknown):PlanItem {
 const template=parseWeekTemplate(value),blocks=template.days.flat();
 if(blocks.length!==1)throw new Error('Invalid ready block');
 return blocks[0];
}
export function applyReadyBlock(target:PlanItem,value:unknown):PlanItem {
 if(target.completed||target.linkedExamId||target.locked)throw new Error('این فعالیت محافظت‌شده است و جایگزین نمی‌شود.');
 const block=readReadyBlock(value);
 return {...block,key:target.key,id:target.id??null,sourceItemId:target.sourceItemId??null,sourceDayOfWeek:target.sourceDayOfWeek??null,
  // Opaque metadata belongs to the target, not the preset or its source.
  extra:target.extra?structuredClone(target.extra):null,topics:block.topics??[],
  dayOfWeek:target.dayOfWeek,linkedExamId:null,completed:false,locked:false};
}
