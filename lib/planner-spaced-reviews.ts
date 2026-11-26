import {readReviewSetting, type ReviewSetting} from './planner-review-settings';
import type {PlannerTopic} from './planner-grid';
import type {PrintableReviewRecord} from './planner-review-records';

export type SpacedReview = {id:string;itemId:string;date:string;offset:3|7|30|90;subject:string;chapter:string;topics:PlannerTopic[];setting:ReviewSetting;completed:boolean};
export function parseSpacedReviews(data:unknown):SpacedReview[] {
 if(!Array.isArray(data)) throw Error('Invalid reviews');
 const seen=new Set<string>();
 return data.map((raw:unknown)=>{
  if(!raw||typeof raw!=='object'||Array.isArray(raw))throw Error('Invalid review');
  const r=raw as Record<string,unknown>,setting=readReviewSetting(r.review);
  if(typeof r.id!=='string'||!r.id||seen.has(r.id)||typeof r.item_id!=='string'||!r.item_id||typeof r.due_date!=='string'||!/^\d{4}-\d{2}-\d{2}$/.test(r.due_date)||!Number.isFinite(Date.parse(`${r.due_date}T00:00:00Z`))||new Date(`${r.due_date}T00:00:00Z`).toISOString().slice(0,10)!==r.due_date||![3,7,30,90].includes(r.offset as number)||typeof r.subject!=='string'||!(r.chapter===null||typeof r.chapter==='string')||!Array.isArray(r.topics)||typeof r.completed!=='boolean'||!setting||setting.schedule!=='spaced4')throw Error('Invalid review');
  seen.add(r.id);
  const topics=r.topics.map((t:unknown)=>{if(!t||typeof t!=='object'||Array.isArray(t)||typeof (t as Record<string,unknown>).title!=='string')throw Error('Invalid topic');return t as PlannerTopic});
  return {id:r.id,itemId:r.item_id,date:r.due_date,offset:r.offset as 3|7|30|90,subject:r.subject,chapter:r.chapter??'',topics,setting,completed:r.completed};
 });
}
export function printableSpacedReviews(data:unknown):PrintableReviewRecord[] {
 return parseSpacedReviews(data).map(r=>({key:`spaced:${r.id}`,date:r.date,offset:r.offset,subject:r.subject,chapter:r.chapter,topics:r.topics,checked:r.completed,historical:false,itemId:r.itemId,archiveId:null,setting:r.setting}));
}
