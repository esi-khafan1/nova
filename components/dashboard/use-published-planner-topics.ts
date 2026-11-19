"use client";
import { useEffect, useState } from 'react';
import { createClient } from '@/lib/supabase/client';
import { parsePublishedTopics } from '@/lib/planner-published-topics';
import type { PlannerTopic } from '@/lib/planner-grid';
export function usePublishedPlannerTopics(planId:string|undefined){
 const [state,setState]=useState<{planId:string;topics:Record<string,PlannerTopic[]>;failed:boolean}|null>(null);
 useEffect(()=>{if(!planId)return;let cancelled=false;
  void (async()=>{try{const {data,error}=await createClient().rpc('planner_get_published_extras',{target_plan_id:planId});
   if(error)throw error;
   if(!data||typeof data!=='object'||Array.isArray(data))throw Error('Invalid plan metadata');
   const topics=parsePublishedTopics(data.items);if(!cancelled)setState({planId,topics,failed:false});
  }catch{if(!cancelled)setState({planId,topics:{},failed:true});}})();return()=>{cancelled=true};
 },[planId]);
 return state && state.planId===planId?state:{planId:planId??'',topics:{},failed:false};
}
