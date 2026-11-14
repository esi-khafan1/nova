import Link from "next/link";
import { CounselorStudentStudyEditor } from "@/components/dashboard/counselor-student-study-editor";
import { studyFieldLabels, type StudyField } from "@/lib/study-catalog";

type Student = {
  student_id: string;
  full_name: string;
  grade: number | null;
  study_field: StudyField | null;
};

export function CounselorStudentCard({ student }: { student: Student }) {
  return (
    <article className="portal-card" id={`student-${student.student_id}`}>
      <h2>{student.full_name || "دانش‌آموز نووا"}</h2>
      <p>{student.grade ? `پایه ${student.grade.toLocaleString("fa-IR")}` : "پایهٔ نامشخص"} / {student.study_field ? studyFieldLabels[student.study_field] : student.grade === 9 ? "بدون رشته" : "رشتهٔ نامشخص"}</p>
      <div className="cp-student-actions">
        <Link className="button" href={`/dashboard/counselor/plans?student=${student.student_id}`}>برنامه‌ریزی</Link>
        <Link className="button button-secondary" href={`/dashboard/counselor/students/${student.student_id}`}>گزارش</Link>
      </div>
      <details className="counselor-study-details">
        <summary>ویرایش پایه و رشته</summary>
        <CounselorStudentStudyEditor student={student} compact />
      </details>
    </article>
  );
}
