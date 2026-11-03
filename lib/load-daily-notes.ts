import type { SupabaseClient } from "@supabase/supabase-js";
import { collectQueryPages } from "@/lib/collect-query-pages";
export type StudentDailyNote = { day: string; note: string };
export function loadDailyNotes(supabase: SupabaseClient, studentId: string) {
  return collectQueryPages<StudentDailyNote>(500,
    (from, to) => supabase.from("student_daily_notes")
      .select("day,note").eq("student_id",studentId).order("day",{ascending:false}).range(from,to),
    "Daily notes unavailable");
}
