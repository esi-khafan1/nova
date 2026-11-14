import type { SupabaseClient } from "@supabase/supabase-js";
import { loadCounselorEditorPage } from "./load-counselor-plans";
import { tehranToday } from "./student-planning";
import type { CounselorWeeklyPlan } from "../components/dashboard/weekly-plan-builder";
import type { PlannerDraftContext } from "./planner-draft-session";
import type { FreshPlannerState } from "./planner-publication-preflight";

const record = (x:unknown): x is Record<string,unknown> => Boolean(x && typeof x === "object" && !Array.isArray(x));
/** Reload before restore and publication. All reads run under the caller's
 * session and fail closed on missing data or changed counselor/plan identity. */
export async function loadFreshPlannerState(client:SupabaseClient, context:PlannerDraftContext, counselorId:string):Promise<FreshPlannerState> {
 const [auth, loaded, completed] = await Promise.all([
  client.auth.getUser(), loadCounselorEditorPage<CounselorWeeklyPlan>(client,false), client.rpc('counselor_completed_plan_item_ids'),
 ]);
 if(auth.error || !auth.data.user || auth.data.user.id!==counselorId || loaded.counselorId!==counselorId || completed.error || !Array.isArray(completed.data) || completed.data.some((x:unknown)=>!record(x)||typeof x.item_id!=='string')) throw new Error('Planner data unavailable');
 const matches=loaded.plans.filter(p=>p.student_id===context.studentId && p.week_start===context.weekStart);
 if(matches.length>1 || (matches[0]?.id??null)!==context.planId)throw new Error('Plan context changed');
 const plan=matches[0]??null;
 if(plan && (typeof plan.updated_at!=='string' || !Number.isFinite(Date.parse(plan.updated_at))))throw new Error('Plan version unavailable');
 let extras:{week:Record<string,unknown>;items:Record<string,Record<string,unknown>>}={week:{},items:{}};
 if(plan?.status==='published'){
  const result=await client.rpc('planner_get_published_extras',{target_plan_id:plan.id});
  if(result.error||!record(result.data)||!record(result.data.week)||!record(result.data.items)||Object.values(result.data.items).some(value=>!record(value)))throw new Error('Plan metadata unavailable');
  extras={week:result.data.week,items:result.data.items as Record<string,Record<string,unknown>>};
 }
 return {today:tehranToday(),plan,planUpdatedAt:plan?.updated_at??null,completed:new Set(completed.data.map((row:{item_id:string})=>row.item_id)),extras};
}
