import type { PlannerTopic } from './planner-grid';
const isRecord=(value:unknown):value is Record<string,unknown>=>Boolean(value&&typeof value==='object'&&!Array.isArray(value));
/** Read only public-facing topic fields; never serialize opaque item metadata. */
export function parsePublishedTopics(value:unknown):Record<string,PlannerTopic[]> {
 if(!isRecord(value))throw new Error('Invalid published item metadata');
 const out:Record<string,PlannerTopic[]>=Object.create(null);
 for(const [id,extra] of Object.entries(value)){
  if(!isRecord(extra))throw new Error('Invalid published item metadata');
  if(extra.topics===undefined)continue;
  if(!Array.isArray(extra.topics)||extra.topics.length>50)throw new Error('Invalid published topics');
  out[id]=extra.topics.map((raw:unknown)=>{
   if(!isRecord(raw)||typeof raw.title!=='string'||!raw.title.trim()||raw.title.length>160)throw new Error('Invalid published topic');
   const start=raw.pageStart??null,end=raw.pageEnd??null;
   if((start===null)!==(end===null)||(start!==null&&(typeof start!=='number'||!Number.isInteger(start)||start<1||start>9999||typeof end!=='number'||!Number.isInteger(end)||end<start||end>9999)))throw new Error('Invalid published pages');
   return {title:raw.title,pageStart:start as number|null,pageEnd:end as number|null};
  });
 }
 return out;
}
export function displayPublishedTopic(topic:PlannerTopic):string {
 return `${topic.title}${topic.pageStart!=null&&topic.pageEnd!=null?` (صفحهٔ ${topic.pageStart.toLocaleString('fa-IR')} تا ${topic.pageEnd.toLocaleString('fa-IR')})`:''}`;
}
