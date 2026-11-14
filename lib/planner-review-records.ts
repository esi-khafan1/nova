import type { PlannerTopic } from "./planner-grid";

export type HistoricalReviewRecord = {
  archiveId: string;
  date: string;
  offset: 1 | 3 | 7;
  subject: string;
  chapter: string;
  topics: PlannerTopic[];
  completed: boolean;
};

/** Transform the authorized RPC result into the keys used by PlannerReviews.
 * Published source blocks must use their database item ID as their grid key. */
export function parsePlannerReviewRecords(value: unknown): { completed: Set<string>; historical: HistoricalReviewRecord[] } {
  if (!Array.isArray(value)) throw new Error("Invalid review response");
  const completed = new Set<string>();
  const historical: HistoricalReviewRecord[] = [];
  const validDate = (v: unknown): v is string => typeof v === "string" && /^\d{4}-\d{2}-\d{2}$/.test(v) &&
    Number.isFinite(Date.parse(`${v}T00:00:00Z`)) && new Date(`${v}T00:00:00Z`).toISOString().slice(0,10) === v;
  for (const raw of value) {
    if (!raw || typeof raw !== "object" || Array.isArray(raw)) throw new Error("Invalid review record");
    const row = raw as Record<string, unknown>;
    if (typeof row.item_id !== "string" || !row.item_id || ![1,3,7].includes(row.offset as number) ||
      typeof row.completed !== "boolean" || typeof row.historical !== "boolean" || !validDate(row.due_date)) {
      throw new Error("Invalid review record");
    }
    const offset = row.offset as 1 | 3 | 7;
    if (!row.historical) {
      if (!validDate(row.source_week_start)) throw new Error("Invalid review source");
      if (row.completed) completed.add(JSON.stringify([row.source_week_start,row.item_id,offset]));
      continue;
    }
    if (typeof row.archive_id !== "string" || !row.archive_id || typeof row.subject !== "string" ||
      !(row.chapter === null || typeof row.chapter === "string") || !Array.isArray(row.topics)) throw new Error("Invalid review history");
    const topics = row.topics.map((topic: unknown): PlannerTopic => {
      if (!topic || typeof topic !== "object" || Array.isArray(topic) || typeof (topic as Record<string,unknown>).title !== "string") throw new Error("Invalid review topic");
      const t = topic as Record<string,unknown>;
      const page = (input: unknown) => {
        if (input == null) return null;
        if (typeof input !== "number" || !Number.isInteger(input) || input < 1) throw new Error("Invalid review topic");
        return input;
      };
      const pageStart=page(t.pageStart),pageEnd=page(t.pageEnd);
      if ((pageStart === null) !== (pageEnd === null) || (pageStart !== null && pageEnd !== null && pageStart > pageEnd) || !(t.bankId == null || typeof t.bankId === "string")) throw new Error("Invalid review topic");
      return {title:t.title as string,pageStart,pageEnd,bankId:t.bankId as string | null | undefined};
    });
    historical.push({archiveId:row.archive_id,date:row.due_date,offset,subject:row.subject,chapter:row.chapter ?? "",topics,completed:row.completed});
  }
  return {completed,historical};
}
