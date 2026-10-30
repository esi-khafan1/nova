"use client";
import Link from "next/link";
import { useEffect, useRef } from "react";

/** Remind on panel entry without changing activation or requiring a second receipt. */
export function StudentProfileCompletionNotice({ issue, onAccountPage = false, onRegistrationPage = false, active = true }: {
  issue: string;
  onAccountPage?: boolean;
  onRegistrationPage?: boolean;
  active?: boolean;
}) {
  const dialogRef = useRef<HTMLDialogElement>(null);
  const href = onAccountPage ? "#student-account-details" : onRegistrationPage ? "#student-registration-details" : "/dashboard/student/account#student-account-details";
  const explanation = active
    ? "حسابت فعال است. برای تکمیل این اطلاعات نیازی به انتخاب دوبارهٔ دوره یا ارسال فیش نداری."
    : "برای تکمیل اطلاعات حساب نیازی به انتخاب دوره یا ارسال فیش نداری. فعال‌سازی خدمات طبق روال جداگانه انجام می‌شود.";

  useEffect(() => {
    const dialog = dialogRef.current;
    if (!dialog || (onAccountPage && window.location.hash === "#student-account-details") ||
      (onRegistrationPage && window.location.hash === "#student-registration-details")) return;
    if (!dialog.open) dialog.showModal();
    return () => { if (dialog.open) dialog.close(); };
  }, [issue, onAccountPage, onRegistrationPage]);

  return <>
    <section className="student-service-notice" role="status" aria-labelledby="student-profile-completion-title">
      <h2 id="student-profile-completion-title">اطلاعات حسابت را تکمیل کن</h2>
      <p>{issue} {explanation}</p>
      <div><Link className="button" href={href}>تکمیل اطلاعات حساب</Link></div>
    </section>
    <dialog ref={dialogRef} className="student-profile-completion-dialog" aria-labelledby="student-profile-dialog-title" aria-modal="true">
      <h2 id="student-profile-dialog-title">اطلاعات حسابت را تکمیل کن</h2>
      <p>{issue} {explanation}</p>
      <div className="student-profile-dialog-actions">
        <Link className="button" href={href} onClick={() => dialogRef.current?.close()}>تکمیل اطلاعات حساب</Link>
        <button type="button" className="button button-secondary" onClick={() => dialogRef.current?.close()}>بعداً</button>
      </div>
    </dialog>
  </>;
}
