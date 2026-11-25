"use client";

import { useRef } from "react";
import { useFormStatus } from "react-dom";

type Props = {
  studentId: string;
  studentName: string;
  blocked: boolean;
  search: string;
  page: number;
  filter: string;
  action: (data: FormData) => void | Promise<void>;
};

function ConfirmButton({ blocked }: { blocked: boolean }) {
  const { pending } = useFormStatus();
  return <button className="user-block-confirm" type="submit" disabled={pending}>
    {pending ? "در حال ثبت..." : blocked ? "رفع مسدودی" : "مسدود کردن"}
  </button>;
}

/** Presentation only. A server action must enforce authorization and state. */
export function StudentAccountBlockForm({ studentId, studentName, blocked, search, page, filter, action }: Props) {
  const dialog = useRef<HTMLDialogElement>(null);
  const titleId = `student-block-title-${studentId}`;
  const textId = `student-block-description-${studentId}`;
  return <div className="user-state-actions">
    <button className={`user-block-button${blocked ? " unblock" : ""}`} type="button"
      onClick={() => dialog.current?.showModal()}>
      {blocked ? "رفع مسدودی حساب" : "مسدود کردن حساب"}
    </button>
    <dialog ref={dialog} className="user-block-dialog" aria-labelledby={titleId} aria-describedby={textId}>
      <h2 id={titleId}>{blocked ? "رفع مسدودی حساب؟" : "مسدود کردن حساب؟"}</h2>
      <p id={textId}>{blocked
        ? `دسترسی ${studentName || "این دانش‌آموز"} دوباره فعال می‌شود و حساب در فهرست دانش‌آموزان نمایش داده می‌شود.`
        : `دسترسی ${studentName || "این دانش‌آموز"} متوقف می‌شود و حساب از فهرست دانش‌آموزان ادمین و مشاور پنهان می‌شود. سوابق محفوظ می‌ماند.`}</p>
      <form action={action}>
        <input type="hidden" name="user_id" value={studentId}/>
        <input type="hidden" name="blocked" value={blocked ? "false" : "true"}/>
        <input type="hidden" name="directory_search" value={search}/>
        <input type="hidden" name="directory_page" value={page}/>
        <input type="hidden" name="directory_filter" value={filter}/>
        <div className="user-block-dialog-actions">
          <button className="user-block-cancel" type="button" onClick={() => dialog.current?.close()}>انصراف</button>
          <ConfirmButton blocked={blocked}/>
        </div>
      </form>
    </dialog>
  </div>;
}
