import { countBookletKeys, hasCompleteExamKeys } from "./exam-key-validation";

type PublicationBooklet = {
  title: string; questionCount: number; durationMinutes: number;
  pdfUrl: string; keyAnswers: Record<string, number>;
};

// Use the same strict, globally numbered key validation as the save action.
// Never invent answers or accept an object's length as proof of completeness.
export function examPublicationReadiness(booklets: readonly PublicationBooklet[], studentCount: number, windowValid: boolean) {
  let start = 1;
  const progress = booklets.map((booklet, index) => {
    const count = booklet.questionCount;
    const validCount = Number.isInteger(count) && count >= 1 && count <= 200;
    const completed = validCount ? countBookletKeys(booklet.keyAnswers, start, count) : 0;
    const missing: number[] = [];
    if (validCount) for (let question = start; question < start + count; question++) {
      if (countBookletKeys(booklet.keyAnswers, question, 1) === 0) missing.push(question);
    }
    const result = { index, title: booklet.title, start, count, completed, missing, validCount, hasPdf: Boolean(booklet.pdfUrl?.startsWith("https://")) };
    start += validCount ? count : 0;
    return result;
  });
  const totalQuestions = progress.reduce((sum, item) => sum + (item.validCount ? item.count : 0), 0);
  const completedKeys = progress.reduce((sum, item) => sum + item.completed, 0);
  const durationValid = booklets.length > 0 && booklets.every(b => Number.isInteger(b.durationMinutes) && b.durationMinutes >= 1 && b.durationMinutes <= 360) && booklets.reduce((sum, b) => sum + b.durationMinutes, 0) <= 600;
  const allBookletsHavePdf = booklets.length > 0 && progress.every(item => item.hasPdf);
  const allKeysComplete = hasCompleteExamKeys(booklets);
  return {
    progress, totalQuestions, completedKeys, durationValid, allBookletsHavePdf, allKeysComplete,
    canPublish: studentCount > 0 && allBookletsHavePdf && allKeysComplete && durationValid && windowValid,
  };
}
