import { createDraftSaveQueue, type DraftSaveQueue, type DraftSaveState } from "./planner-autosave";

export type PlannerDraftContext = { studentId: string; weekStart: string; planId: string | null };
export type LoadedPlannerDraft<T> = { planId: string | null; basePlanUpdatedAt: string | null; revision: string; snapshot: T };
export type PlannerDraftTransport<T, Published> = {
  load: (context: PlannerDraftContext) => Promise<LoadedPlannerDraft<T> | null>;
  save: (context: PlannerDraftContext, snapshot: T, expectedRevision: string | null, expectedBasePlanUpdatedAt: string | null) => Promise<{ revision: string; basePlanUpdatedAt: string | null }>;
  publish: (context: PlannerDraftContext, expectedRevision: string) => Promise<Published>;
  discard?: (context: PlannerDraftContext, expectedRevision: string) => Promise<void>;
};
export type PlannerDraftEvent<T> =
  | { type: "opened"; context: PlannerDraftContext; snapshot: T; restored: boolean; basePlanUpdatedAt: string | null }
  | { type: "save-state"; context: PlannerDraftContext; state: DraftSaveState; error?: unknown }
  | { type: "busy"; operation: "open" | "publish" | "discard" | null }
  | { type: "error"; operation: "open" | "publish" | "discard"; error: unknown }
  | { type: "published"; context: PlannerDraftContext };

type Active<T> = { context: PlannerDraftContext; queue: DraftSaveQueue<T>; revision: string | null; basePlanUpdatedAt: string | null; snapshot: T; saveState: DraftSaveState };

/**
 * Coordinates one editor instance. A context switch flushes the previous draft
 * before loading the next; a failed flush/load never discards the current one.
 * Publication freezes edits, flushes, and uses that exact saved revision.
 * The transport is responsible for authenticated RPCs and server validation.
 */
export function createPlannerDraftSession<T, Published>(options: {
  transport: PlannerDraftTransport<T, Published>;
  onEvent: (event: PlannerDraftEvent<T>) => void;
  /** Optional UI preflight against freshly loaded data; not server authorization. */
  preparePublication?: (context: PlannerDraftContext, snapshot: T, basePlanUpdatedAt: string | null) => Promise<{snapshot: T; blocked: boolean; message?: string}>;
  delayMs?: number;
  clone?: (snapshot: T) => T;
}) {
  const clone = options.clone ?? ((value: T) => structuredClone(value));
  let active: Active<T> | null = null;
  let busy: "open" | "publish" | "discard" | null = null;
  let disposed = false;
  const emit = (event: PlannerDraftEvent<T>) => { if (!disposed) options.onEvent(event); };
  const setBusy = (operation: typeof busy) => { busy = operation; emit({type: "busy", operation}); };
  const requireIdle = () => {
    if (disposed) throw new Error("Draft session is closed");
    if (busy) throw new Error("Draft session is busy");
  };
  const sameContext = (a: PlannerDraftContext, b: PlannerDraftContext) => a.studentId === b.studentId && a.weekStart === b.weekStart && a.planId === b.planId;
  const open = async (context: PlannerDraftContext, initial: T, initialBasePlanUpdatedAt: string | null = null): Promise<boolean> => {
    requireIdle();
    if (active && sameContext(active.context, context)) return true;
    setBusy("open");
    try {
      if (active && !(await active.queue.flush())) return false;
      const loaded = await options.transport.load({...context});
      if (disposed) return false;
      if (loaded && (loaded.planId !== context.planId || !/^[1-9][0-9]*$/.test(loaded.revision) ||
          ((loaded.planId === null) !== (loaded.basePlanUpdatedAt === null)) ||
          (loaded.basePlanUpdatedAt !== null && (typeof loaded.basePlanUpdatedAt !== "string" || !Number.isFinite(Date.parse(loaded.basePlanUpdatedAt)))))) throw new Error("Draft does not match this plan");
      const selected: Active<T> = {
        context: {...context}, snapshot: clone(loaded ? loaded.snapshot : initial),
        revision: loaded?.revision ?? null, basePlanUpdatedAt: loaded?.basePlanUpdatedAt ?? initialBasePlanUpdatedAt, saveState: "idle", queue: null as unknown as DraftSaveQueue<T>,
      };
      selected.queue = createDraftSaveQueue<T>({
        revision: selected.revision,
        delayMs: options.delayMs,
        clone,
        save: async (snapshot, revision) => {
          const result = await options.transport.save({...selected.context}, snapshot, revision, selected.basePlanUpdatedAt);
          if (!/^[1-9][0-9]*$/.test(result.revision) ||
              ((selected.context.planId === null) !== (result.basePlanUpdatedAt === null)) ||
              (result.basePlanUpdatedAt !== null && !Number.isFinite(Date.parse(result.basePlanUpdatedAt)))) throw new Error("Invalid saved revision");
          selected.revision = result.revision;
          selected.basePlanUpdatedAt = result.basePlanUpdatedAt;
          return result;
        },
        onState: (state, error) => {
          selected.saveState = state;
          emit({type:"save-state", context:{...selected.context}, state, error});
        },
      });
      active?.queue.dispose();
      active = selected;
      emit({type:"opened", context:{...selected.context}, snapshot:clone(selected.snapshot), restored:Boolean(loaded), basePlanUpdatedAt:loaded?.basePlanUpdatedAt ?? null});
      return true;
    } catch (error) {
      emit({type:"error", operation:"open", error});
      return false;
    } finally { setBusy(null); }
  };
  const update = (snapshot: T) => {
    requireIdle();
    if (!active) throw new Error("No draft is open");
    active.snapshot = clone(snapshot);
    active.queue.update(active.snapshot);
  };
  const flush = async () => {
    requireIdle();
    if (!active) throw new Error("No draft is open");
    return active.queue.flush();
  };
  const retry = async () => {
    requireIdle();
    if (!active) throw new Error("No draft is open");
    return active.queue.retry();
  };
  const publish = async (): Promise<Published | null> => {
    requireIdle();
    if (!active) throw new Error("No draft is open");
    const selected = active;
    setBusy("publish");
    try {
      // An untouched new plan still requires a durable, revisioned snapshot.
      if (selected.revision === null) selected.queue.update(selected.snapshot);
      // A previous autosave failure leaves the queue deliberately latched. A
      // fresh publication click is an explicit retry of the latest snapshot;
      // the original revision is still checked by the server, so conflicts or
      // a lost save acknowledgement cannot silently overwrite another draft.
      const saved = selected.saveState === "error" ? await selected.queue.retry() : await selected.queue.flush();
      if (!saved || disposed || !selected.revision) return null;
      if (options.preparePublication) {
        const prepared = await options.preparePublication({...selected.context}, clone(selected.snapshot), selected.basePlanUpdatedAt);
        if (disposed) return null;
        if (prepared.blocked) throw new Error(prepared.message || "Draft conflicts with the current plan");
        // Recomputed dates, protection flags and payload must themselves be
        // durable before publishing the exact new revision.
        selected.snapshot = clone(prepared.snapshot);
        selected.queue.update(selected.snapshot);
        if (!(await selected.queue.flush()) || disposed || !selected.revision) return null;
      }
      const published = await options.transport.publish({...selected.context}, selected.revision);
      if (disposed) return null;
      selected.queue.dispose(); active = null;
      emit({type:"published", context:{...selected.context}});
      return published;
    } catch (error) {
      emit({type:"error", operation:"publish", error});
      return null;
    } finally { setBusy(null); }
  };
  const discard = async (): Promise<boolean> => {
    requireIdle();
    if (!active || !options.transport.discard) throw new Error("Draft cannot be discarded");
    const selected=active;setBusy("discard");
    try {
      // Wait for any in-flight write before deleting: otherwise a late save
      // could recreate the draft after the user has discarded it. A failed
      // flush need not trap a user who explicitly confirmed discard: delete
      // only the last revision we actually observed, using the server's CAS.
      // If an unacknowledged first save might have succeeded, check the server.
      // Never guess a revision or erase a draft that could belong to another tab.
      const flushed = await selected.queue.flush();
      if (disposed) return false;
      if (!flushed && !selected.revision) {
        const remote = await options.transport.load({...selected.context});
        if (disposed || remote) return false;
      }
      if (selected.revision) await options.transport.discard({...selected.context},selected.revision);
      if (disposed) return false;
      selected.queue.dispose();active=null;return true;
    } catch (error) {emit({type:"error",operation:"discard",error});return false;}
    finally {setBusy(null);}
  };
  return {
    open, update, flush, retry, publish, discard,
    /** Used by the UI's navigation / beforeunload guard. */
    hasPendingWork() { return Boolean(busy || (active && ["dirty", "saving", "error"].includes(active.saveState))); },
    /** Call flush before disposing when navigation can be delayed. */
    dispose() { disposed = true; active?.queue.dispose(); active = null; },
  };
}
