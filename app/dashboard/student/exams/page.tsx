import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { requireProfile } from "@/lib/auth";

type StudentExam = { id: string; title: string; description: string | null; mode: "multiple_choice" | "pdf"; audience: string; created_at: string };
type Attempt = { exam_id: string; score: number | null; submitted_at: string };

export default async function StudentExamsPage({ searchParams }: { searchParams: Promise<Record<string, string | undefined>> }) {
  const { supabase, profile } = await requireProfile(["student"]);
  const params = await searchParams;
  const [{ data: assignment }, { data: examsData }, { data: attemptsData }] = await Promise.all([
    supabase.from("counselor_students").select("id").eq("student_id", profile.id).limit(1),
    supabase.from("exams").select("id,title,description,mode,audience,created_at").eq("status", "published").order("created_at", { ascending: false }),
    supabase.from("exam_attempts").select("exam_id,score,submitted_at").eq("student_id", profile.id),
  ]);
  const hasCounselor = Boolean(assignment?.length);
  const exams = (examsData ?? []) as StudentExam[];
  const attempts = new Map(((attemptsData ?? []) as Attempt[]).map((attempt) => [attempt.exam_id, attempt]));
  return <DashboardShell role="student" name={profile.full_name}>
    <section className="portal-heading"><div><span>آزمون‌های من</span><h1>آزمون‌های قابل شرکت</h1><p>فقط آزمون‌هایی را می‌بینی که برای تو منتشر شده‌اند.</p></div></section>
    {params.error && <div className="portal-alert error">آزمون در دسترس نیست.</div>}
    {!hasCounselor ? <section className="portal-card exam-gate"><h2>برای شرکت در آزمون به مشاور نیاز داری</h2><p>بعد از انتخاب مشاور، آزمون‌های مجاز اینجا نمایش داده می‌شوند.</p><Link className="button" href="/dashboard/apply-counselor">درخواست مشاور</Link></section> : <section className="exam-student-grid">{exams.length ? exams.map((exam) => { const attempt = attempts.get(exam.id); return <article className="portal-card exam-student-card" key={exam.id}><span>{exam.mode === "multiple_choice" ? "آزمون تستی" : "آزمون PDF"}</span><h2>{exam.title}</h2><p>{exam.description || "آماده‌ای؟ آزمون را شروع کن."}</p>{attempt ? <div className="exam-completed"><strong>ثبت شده</strong>{attempt.score !== null && <span>نمره: {attempt.score.toLocaleString("fa-IR")}%</span>}</div> : <Link className="button" href={`/dashboard/student/exams/${exam.id}`}>ورود به آزمون</Link>}</article>; }) : <section className="portal-card portal-empty">فعلاً آزمونی برای تو منتشر نشده است.</section>}</section>}
  </DashboardShell>;
}
