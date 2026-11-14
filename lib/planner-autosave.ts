/** Serialize autosaves so an older response cannot overwrite a newer draft. */
export type DraftSaveState = "idle" | "dirty" | "saving" | "saved" | "error";
export type DraftSaveResult = { revision: string };
export type DraftSaveQueue<T> = {
  update: (snapshot: T) => void;
  flush: () => Promise<boolean>;
  retry: () => Promise<boolean>;
  dispose: () => void;
};

export function createDraftSaveQueue<T>(options: {
  revision: string | null;
  save: (snapshot: T, expectedRevision: string | null) => Promise<DraftSaveResult>;
  onState: (state: DraftSaveState, error?: unknown) => void;
  delayMs?: number;
  clone?: (snapshot: T) => T;
}): DraftSaveQueue<T> {
  const delay = options.delayMs ?? 800;
  if (!Number.isFinite(delay) || delay < 0) throw new RangeError("Invalid autosave delay");
  let revision = options.revision;
  let latest: { value: T; version: number } | null = null;
  let savedVersion = 0;
  let nextVersion = 0;
  let failure: unknown = null;
  let disposed = false;
  let timer: ReturnType<typeof setTimeout> | null = null;
  let running: Promise<boolean> | null = null;
  const notify = (state: DraftSaveState, error?: unknown) => { if (!disposed) options.onState(state, error); };
  const clearTimer = () => { if (timer !== null) clearTimeout(timer); timer = null; };
  const flush = (): Promise<boolean> => {
    clearTimer();
    if (disposed || failure) return Promise.resolve(false);
    if (running) return running;
    if (!latest || latest.version === savedVersion) return Promise.resolve(true);
    running = (async () => {
      while (!disposed) {
        if (!latest || latest.version === savedVersion) {
          notify("saved");
          // Status listeners can themselves queue an edit; flush must include it
          // before a caller is allowed to proceed to publication or navigation.
          if (latest && latest.version !== savedVersion) continue;
          return true;
        }
        const submitted = latest;
        notify("saving");
        try {
          const result = await options.save(submitted.value, revision);
          if (!result || typeof result.revision !== "string" || !result.revision) throw new Error("Invalid draft revision");
          revision = result.revision;
          savedVersion = submitted.version;
        } catch (error) {
          failure = error || new Error("Draft save failed");
          notify("error", failure);
          return false;
        }
      }
      return false;
    })().finally(() => {
      running = null;
      // A listener may have queued another edit during the final status callback.
      if (!disposed && !failure && latest && latest.version !== savedVersion) {
        clearTimer();
        timer = setTimeout(() => { void flush(); }, delay);
      }
    });
    return running;
  };
  return {
    update(snapshot) {
      if (disposed) throw new Error("Autosave queue is disposed");
      latest = { value: options.clone ? options.clone(snapshot) : structuredClone(snapshot), version: ++nextVersion };
      if (failure) return; // A conflict/error needs an explicit decision before retrying.
      notify("dirty");
      if (!running) { clearTimer(); timer = setTimeout(() => { void flush(); }, delay); }
    },
    flush,
    retry() {
      if (disposed) return Promise.resolve(false);
      failure = null;
      return flush();
    },
    dispose() { disposed = true; clearTimer(); },
  };
}
