export type ReviewStatus = "correct" | "incorrect" | "unanswered" | "ungraded";
export type ExamReviewQuestion = {
  booklet_id: string;
  booklet_title: string;
  pdf_url: string;
  sort_order: number;
  question_number: number;
  student_choice: number | null;
  correct_choice: number | null;
  answer_status: ReviewStatus;
};
export type ReviewFilter = "all" | ReviewStatus;
export function reviewCounts(questions: ExamReviewQuestion[]) {
  return questions.reduce((counts, question) => {
    counts.all += 1;
    counts[question.answer_status] += 1;
    return counts;
  }, { all: 0, correct: 0, incorrect: 0, unanswered: 0, ungraded: 0 });
}
export function filterReview(questions: ExamReviewQuestion[], filter: ReviewFilter, bookletId: string) {
  return questions.filter(question => (filter === "all" || question.answer_status === filter)
    && (bookletId === "all" || question.booklet_id === bookletId));
}
