type EditableBooklet = {
  id: string;
  questionCount: number;
  keyAnswers: Record<string, number>;
};

// Keys are global numbers in the payload, but belong to local questions in each
// booklet. Preserve that ownership when earlier counts or booklet order change.
export function remapBookletKeys<T extends EditableBooklet>(
  previous: readonly T[],
  next: readonly T[],
): T[] {
  const originals = new Map<string, { booklet: T; start: number }>();
  let previousStart = 1;
  for (const booklet of previous) {
    originals.set(booklet.id, { booklet, start: previousStart });
    previousStart += booklet.questionCount;
  }
  let nextStart = 1;
  return next.map(booklet => {
    const original = originals.get(booklet.id);
    const keyAnswers: Record<string, number> = {};
    if (original) {
      const retained = Math.min(original.booklet.questionCount, booklet.questionCount);
      for (let index = 0; index < retained; index++) {
        const choice = original.booklet.keyAnswers[String(original.start + index)];
        if (Number.isInteger(choice) && choice >= 1 && choice <= 4)
          keyAnswers[String(nextStart + index)] = choice;
      }
    }
    nextStart += booklet.questionCount;
    return { ...booklet, keyAnswers };
  });
}
