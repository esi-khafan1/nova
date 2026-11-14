import type { SupabaseClient } from "@supabase/supabase-js";
import type { PlannerDraftContext, PlannerDraftTransport } from "./planner-draft-session";

/** Adapter for the draft RPCs. Caller must validate the snapshot before publication. */
export function createPlannerDraftTransport<T>(client: SupabaseClient, parseSnapshot: (value: unknown) => T): PlannerDraftTransport<T, string> {
  const contextArgs = (context: PlannerDraftContext) => ({target_student_id:context.studentId, target_week_start:context.weekStart});
  return {
    async load(context) {
      const {data,error} = await client.rpc("planner_get_working_draft",contextArgs(context));
      if (error) throw error;
      if (data === null) return null;
      if (typeof data !== "object" || Array.isArray(data) || typeof data.revision !== "string" ||
          !(data.plan_id === null || typeof data.plan_id === "string") || !("snapshot" in data)) throw new Error("Invalid draft response");
      return {planId:data.plan_id, revision:data.revision, snapshot:parseSnapshot(data.snapshot)};
    },
    async save(context, snapshot, expectedRevision) {
      const {data,error} = await client.rpc("planner_save_working_draft",{
        ...contextArgs(context), target_plan_id:context.planId, target_snapshot:snapshot, expected_revision:expectedRevision,
      });
      if (error) throw error;
      if (!data || typeof data !== "object" || Array.isArray(data) || typeof data.revision !== "string") throw new Error("Invalid saved draft response");
      return {revision:data.revision};
    },
    async publish(context, expectedRevision) {
      const {data,error} = await client.rpc("planner_publish_working_draft",{...contextArgs(context),expected_revision:expectedRevision});
      if (error) throw error;
      if (typeof data !== "string" || !data) throw new Error("Invalid published plan response");
      return data;
    },
  };
}
