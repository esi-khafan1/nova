import type { SupabaseClient } from '@supabase/supabase-js';
import { collectQueryPages } from './collect-query-pages';
import type { RoutineCompletion } from './student-planning';

/** Read all ticks under the caller's RLS; never interpret a failed read as empty. */
export function loadRoutineProgress(client:SupabaseClient, studentId:string) {
 return collectQueryPages<RoutineCompletion>(500,(from,to)=>client.from('weekly_plan_routine_completions')
  .select('plan_id,student_id,day_of_week,slot,subject,details,checked_at')
  .eq('student_id',studentId).order('plan_id').order('day_of_week').order('slot').range(from,to),'Routine progress unavailable');
}
