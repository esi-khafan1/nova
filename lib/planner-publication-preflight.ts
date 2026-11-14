import { plannerSnapshotFromEditor, type PublishedPlannerExtras } from "./planner-plan-adapter";
import { restorePlannerDraft } from "./planner-draft-restore";
import type { PlannerDraftContext } from "./planner-draft-session";
import type { CounselorWeeklyPlan } from "../components/dashboard/weekly-plan-builder";

export type PlannerEditorSnapshot = ReturnType<typeof plannerSnapshotFromEditor>;
export type FreshPlannerState = {
  today: string;
  plan: CounselorWeeklyPlan | null;
  planUpdatedAt: string | null;
  completed: ReadonlySet<string>;
  extras: PublishedPlannerExtras;
};

/** Prepare a durable snapshot just before publication, using freshly loaded
 * authorized state. This is a UX/data-loss guard, NOT authoritative validation;
 * the server publisher remains disabled until server checks are complete. */
export function createPlannerPublicationPreflight(loadFresh: (context: PlannerDraftContext) => Promise<FreshPlannerState>) {
  return async (context: PlannerDraftContext, snapshot: PlannerEditorSnapshot, basePlanUpdatedAt: string | null) => {
    const fresh = await loadFresh(context);
    const restored = restorePlannerDraft({snapshot,context,today:fresh.today,freshPlan:fresh.plan,freshPlanUpdatedAt:fresh.planUpdatedAt,basePlanUpdatedAt,completed:fresh.completed,publishedExtras:fresh.extras});
    if (!restored.canPublish) return {snapshot,blocked:true,message:"برنامه یا وضعیت فعالیت‌ها تغییر کرده است. پیش‌نویس حفظ شد؛ تغییرات را بررسی کن."};
    return {
      blocked:false,
      snapshot:plannerSnapshotFromEditor({title:restored.title,notes:restored.notes,weekStart:context.weekStart,today:fresh.today,planStatus:fresh.plan?.status??null,grid:restored.grid,routines:restored.routines,weekExtra:restored.weekExtra}),
    };
  };
}
