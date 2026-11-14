import type { PlannerTopic } from "./planner-grid";

/** The bank is edition-specific; identifiers remain stable when page text changes. */
export type BankTopic = {
  id: string;
  subject: string;
  grade: number | "comprehensive";
  chapter: string;
  title: string;
  pageStart: number | null;
  pageEnd: number | null;
  order: number;
};
export type TopicUse = {
  studentId: string;
  subject: string;
  grade: number | "comprehensive";
  chapter: string;
  /** ISO calendar date and order in that day, not the time a user clicked. */
  date: string;
  order: number;
  topicIds: string[];
};

/** Suggestions never include another student or activities after the insertion point. */
export function suggestNextTopic(bank: readonly BankTopic[], uses: readonly TopicUse[], target: {
  studentId: string;
  subject: string;
  grade: number | "comprehensive";
  chapter: string;
  date: string;
  order: number;
}): BankTopic | null {
  const validDate = (value: string) => /^\d{4}-\d{2}-\d{2}$/.test(value) &&
    Number.isFinite(Date.parse(`${value}T00:00:00Z`)) && new Date(`${value}T00:00:00Z`).toISOString().slice(0,10) === value;
  if (!target.studentId || !validDate(target.date) || !Number.isInteger(target.order) || target.order < 0) throw new RangeError("Invalid insertion position");
  const options = bank.filter(topic => topic.subject === target.subject && topic.grade === target.grade && topic.chapter === target.chapter)
    .slice().sort((a,b) => a.order - b.order || a.id.localeCompare(b.id));
  if (!options.length) return null;
  if (options.some(topic => !topic.id || !Number.isInteger(topic.order)) || new Set(options.map(topic => topic.id)).size !== options.length) throw new RangeError("Invalid topic bank");
  const positions = new Map(options.map((topic, index) => [topic.id, index]));
  const earlier = uses.filter(use => use.studentId === target.studentId && use.subject === target.subject && use.grade === target.grade && use.chapter === target.chapter && validDate(use.date) && Number.isInteger(use.order) && use.order >= 0 &&
    (use.date < target.date || (use.date === target.date && use.order < target.order)))
    .slice().sort((a,b) => b.date.localeCompare(a.date) || b.order - a.order);
  for (const use of earlier) {
    // In a multi-topic activity the last known bank entry is the continuation point.
    for (let i = use.topicIds.length - 1; i >= 0; i--) {
      const index = positions.get(use.topicIds[i]);
      if (index !== undefined) return options[index + 1] ?? null;
    }
  }
  return options[0];
}

/** Copy defaults, leaving the bank untouched so each block can adjust its pages. */
export function selectBankTopic(topic: BankTopic, pages?: { start: number | null; end: number | null }): PlannerTopic {
  const pageStart = pages ? pages.start : topic.pageStart;
  const pageEnd = pages ? pages.end : topic.pageEnd;
  if ((pageStart !== null && (!Number.isInteger(pageStart) || pageStart < 1)) ||
      (pageEnd !== null && (!Number.isInteger(pageEnd) || pageEnd < 1)) ||
      ((pageStart === null) !== (pageEnd === null)) ||
      (pageStart !== null && pageEnd !== null && pageStart > pageEnd)) {
    throw new RangeError("Invalid topic page range");
  }
  return { bankId: topic.id, title: topic.title, pageStart, pageEnd };
}
