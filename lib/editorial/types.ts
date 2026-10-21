export type EditorialKind = "resources" | "news" | "podcasts";
export const editorialKinds: EditorialKind[] = ["resources", "news", "podcasts"];
export const kindLabels = { resources: "مقاله", news: "خبر", podcasts: "پادکست" };
export const authorPaths = { resources: "content", news: "news", podcasts: "podcasts" };
export const publicPaths = { resources: "mag", news: "news", podcasts: "podcasts" };
export const tableNames = { resources: "resources", news: "konkur_news", podcasts: "podcasts" };
export const reviewLabels = { draft: "پیش‌نویس", pending: "در انتظار بررسی", rejected: "نیازمند اصلاح", published: "منتشرشده" };
export type ReviewState = keyof typeof reviewLabels;
export type EditorialPayload = {
  title: string; summary: string | null; body: string;
  resource_type?: "konkur" | "final_exam"; grade?: number | null; subject?: string | null;
  source_name?: string; source_url?: string; source_published_at?: string;
  audio_url?: string | null; audio_seconds?: number | null;
};
export type Submission = {
 id: string; kind: EditorialKind; content_id: string; author_id: string;
 payload: EditorialPayload; state: ReviewState; version: number;
 rejection_reason: string | null; updated_at: string; submitted_at: string | null;
};
export const submissionFields = "id,kind,content_id,author_id,payload,state,version,rejection_reason,updated_at,submitted_at";
export function editableSubmission(s: Submission) {
 return { ...s.payload, id: s.content_id, resource_type: s.payload.resource_type ?? "konkur" as const,
   grade: s.payload.grade ?? null, subject: s.payload.subject ?? null,
   status: "draft" as const, revision: s.version };
}
