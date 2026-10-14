import type { ExamBooklet } from "@/lib/exams";

export type FloatingExamSession = {
  exam_id: string; student_id: string; started_at: string; expires_at: string;
  current_booklet_index: number; booklet_started_at: string;
  answers: Record<string, number>; updated_at: string; server_now: string;
};
export function parseExamStartWindow(date: string, startTime: string, endTime: string) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(date) || !/^([01]\d|2[0-3]):[0-5]\d$/.test(startTime) || !/^([01]\d|2[0-3]):[0-5]\d$/.test(endTime)) return null;
  const start = new Date(`${date}T${startTime}:00+03:30`);
  const end = new Date(`${date}T${endTime}:00+03:30`);
  if (!Number.isFinite(start.getTime()) || !Number.isFinite(end.getTime()) || end <= start) return null;
  if (new Date(start.getTime() + 210 * 60_000).toISOString().slice(0,10) !== date) return null;
  return { start, end };
}
export function floatingSessionDeadline(session: FloatingExamSession, booklets: ExamBooklet[]) {
  const end = Date.parse(session.expires_at);
  const current = booklets[session.current_booklet_index];
  return current && session.current_booklet_index === booklets.length - 1
    ? Math.min(end, Date.parse(session.booklet_started_at) + current.duration_minutes * 60_000) : end;
}
export function floatingRemainingSeconds(session: FloatingExamSession, booklet: ExamBooklet, now: number) {
  return Math.max(0, Math.ceil((Math.min(Date.parse(session.expires_at),Date.parse(session.booklet_started_at)+booklet.duration_minutes*60_000)-now)/1000));
}
export function getFloatingExamEntryState(startsAt: string, windowEndsAt: string, session: Pick<FloatingExamSession,"expires_at"> | null | undefined, now = new Date()) {
  if (session) return now.getTime() >= Date.parse(session.expires_at) ? "expired" as const : "resumable" as const;
  if (now.getTime() < Date.parse(startsAt)) return "upcoming" as const;
  return now.getTime() >= Date.parse(windowEndsAt) ? "closed" as const : "startable" as const;
}
export function replaceBookletAnswers(base: Record<string,number>, draft: Record<string,number>, booklet: ExamBooklet) {
  const answers = {...base};
  for(let q=booklet.start_question_number;q<=booklet.end_question_number;q++) {
    delete answers[String(q)]; const choice=draft[String(q)];
    if(Number.isInteger(choice) && choice>=1 && choice<=4) answers[String(q)]=choice;
  }
  return answers;
}
export function floatingExamErrorCode(message: string) {
  const text=message.toLowerCase();
  if(text.includes("window is closed")) return "start_closed";
  if(text.includes("has not opened")) return "not_started";
  if(text.includes("has expired") || text.includes("time has expired")) return "session_expired";
  if(text.includes("state changed")) return "progress_changed";
  return "floating_unavailable";
}
export function floatingExamErrorMessage(code: string | undefined) {
  switch(code) {
    case "start_closed": return "مهلت شروع آزمون تمام شده است؛ شروع جدید امکان‌پذیر نیست.";
    case "not_started": return "بازهٔ شروع آزمون هنوز باز نشده است.";
    case "session_expired": return "زمان پاسخ‌گویی شما به پایان رسیده است. پاسخ‌های ذخیره‌شده را ثبت کن.";
    case "progress_changed": return "وضعیت آزمون در صفحهٔ دیگری تغییر کرده است؛ برای ادامه صفحه را دوباره باز کن.";
    default: return "انجام این عملیات فعلاً ممکن نیست. پاسخ‌ها را در همین صفحه نگه دار و دوباره تلاش کن.";
  }
}
