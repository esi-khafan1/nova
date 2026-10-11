// Keys are numbered globally across booklets, just like the student answer sheet.
export function countBookletKeys(keys: unknown, start: number, count: number): number {
  if (!keys || typeof keys !== "object" || Array.isArray(keys)) return 0;
  const answers = keys as Record<string, unknown>;
  let completed = 0;
  for (let n = start; n < start + count; n++) {
    const choice = answers[String(n)];
    if (typeof choice === "number" && Number.isInteger(choice) && choice >= 1 && choice <= 4) completed++;
  }
  return completed;
}
export function hasCompleteExamKeys(booklets: readonly { questionCount?: unknown; keyAnswers?: unknown }[]): boolean {
  if (!booklets.length) return false;
  let start = 1;
  for (const booklet of booklets) {
    const count = Number(booklet.questionCount);
    if (!Number.isInteger(count) || count < 1 || count > 200 || countBookletKeys(booklet.keyAnswers, start, count) !== count) return false;
    start += count;
  }
  return true;
}
