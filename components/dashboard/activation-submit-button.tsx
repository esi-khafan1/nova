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
          ? "فیش ثبت‌شده را بررسی کرده‌ای؟ با تأیید، همین فیش تأیید و حساب دانش‌آموز فعال می‌شود."
          : "برای این دانش‌آموز فیشی ثبت نشده است. حساب بدون فیش فعال و این تصمیم به‌عنوان فعال‌سازی دستی ثبت می‌شود. ادامه می‌دهی؟";
        if (!window.confirm(message)) event.preventDefault();
      }}
    >
      {hasReceipt ? "تأیید فیش و فعال‌سازی" : "فعال‌سازی بدون فیش"}
    </button>
  );
}
