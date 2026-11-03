"use client";

export function ActivationSubmitButton({ hasReceipt, disabled }: { hasReceipt: boolean; disabled: boolean }) {
  return (
    <button
      className="button"
      type="submit"
      disabled={disabled}
      onClick={(event) => {
        if (!event.currentTarget.form?.reportValidity()) {
          event.preventDefault();
          return;
        }
        const message = hasReceipt
          ? "فیش ثبت‌شده را بررسی کرده‌ای؟ با تأیید، همین فیش تأیید و حساب دانش‌آموز با دورهٔ نهایی انتخابی مدیر (یا بدون دوره) فعال می‌شود. دورهٔ درخواستی دانش‌آموز را هم با فیش تطبیق داده‌ای؟"
          : "برای این دانش‌آموز فیشی ثبت نشده است. حساب بدون فیش با دورهٔ نهایی انتخابی مدیر (یا بدون دوره) فعال و این تصمیم به‌عنوان فعال‌سازی دستی ثبت می‌شود. ادامه می‌دهی؟";
        if (!window.confirm(message)) event.preventDefault();
      }}
    >
      {hasReceipt ? "تأیید فیش و فعال‌سازی" : "فعال‌سازی بدون فیش"}
    </button>
  );
}
