import Link from "next/link";
import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { ExamBuilder } from "@/components/dashboard/exam-builder";
import { requireProfile } from "@/lib/auth";

type CounselorExam = {
  id: string;
  title: string;
  description: string | null;
  mode: "multiple_choice" | "pdf";
  audience: "own_students" | "all_assigned_students";
  status: "draft" | "published" | "archived";
  created_at: string;
  exam_questions: { id: string }[];
  exam_attempts: { id: string }[];
};

export default async function CounselorExamsPage({ searchParams }: { searchParams: Promise<Record<string, string | undefined>> }) {
  const { supabase, profile } = await requireProfile(["counselor"]);
  const params = await searchParams;
  const { data } = await supabase
    .from("exams")
    .select("id,title,description,mode,audience,status,created_at,exam_questions(id),exam_attempts(id)")
    .eq("counselor_id", profile.id)
    .order("created_at", { ascending: false });
  const exams = (data ?? []) as CounselorExam[];

  return (
    <DashboardShell role="counselor" name={profile.full_name}>
      <section className="portal-heading"><div><span>مرکز آزمون</span><h1>آزمون بساز و نتیجه‌ها را یک‌جا ببین</h1><p>آزمون را فقط برای دانش‌آموزان خودت یا برای همه دانش‌آموزانی که مشاور دارند منتشر کن.</p></div></section>
      {params.saved && <div className="portal-alert success">{params.saved === "published" ? "آزمون منتشر شد." : "پیش‌نویس آزمون ذخیره شد."}</div>}
      {params.error && <div className="portal-alert error">ذخیره آزمون انجام نشد. سؤال‌ها و فایل را بررسی کن.</div>}
      <ExamBuilder />
      <section className="portal-card exam-list-section">
        <div className="portal-card-title"><div><span>آزمون‌های من</span><h2>سوابق آزمون‌ها</h2></div><strong>{exams.length.toLocaleString("fa-IR")} آزمون</strong></div>
        {exams.length ? <div className="exam-list">{exams.map((exam) => (
          <article key={exam.id}>
            <div><span className={`content-status ${exam.status}`}>{exam.status === "published" ? "منتشرشده" : exam.status === "draft" ? "پیش‌نویس" : "بایگانی"}</span><h3>{exam.title}</h3><p>{exam.mode === "multiple_choice" ? `${exam.exam_questions.length.toLocaleString("fa-IR")} سؤال تستی` : "PDF سؤال و پاسخ"} · {exam.audience === "own_students" ? "دانش‌آموزان خودم" : "همه دانش‌آموزان دارای مشاور"}</p></div>
            <div className="exam-list-actions"><span>{exam.exam_attempts.length.toLocaleString("fa-IR")} پاسخ</span><Link className="button secondary" href={`/dashboard/counselor/exams/${exam.id}`}>مشاهده نتایج</Link></div>
          </article>
        ))}</div> : <p className="portal-empty">هنوز آزمونی ساخته نشده است.</p>}
      </section>
    </DashboardShell>
  );
}
