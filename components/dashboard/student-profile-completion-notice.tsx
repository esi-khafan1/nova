import Link from "next/link";

/** A reminder, not a second activation or a paid-service gate. */
export function StudentProfileCompletionNotice({ issue, onAccountPage = false }: {
  issue: string;
  onAccountPage?: boolean;
}) {
  return <section className="student-service-notice" role="status" aria-labelledby="student-profile-completion-title">
    <h2 id="student-profile-completion-title">اطلاعات حسابت را تکمیل کن</h2>
    <p>{issue} حسابت فعال است و برای تکمیل اطلاعات نیازی به انتخاب دوبارهٔ دوره یا ارسال فیش نداری.</p>
    <div><Link className="button" href={onAccountPage ? "#student-account-details" : "/dashboard/student/account#student-account-details"}>تکمیل اطلاعات حساب</Link></div>
  </section>;
}
