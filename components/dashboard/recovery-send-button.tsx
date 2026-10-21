"use client";

import { useFormStatus } from "react-dom";
export function RecoverySendButton({ disabled }: { disabled: boolean }) {
  const { pending } = useFormStatus();
  return <button className="role-action promote" type="submit" disabled={disabled || pending} aria-busy={pending}>
    {pending ? "در حال ارسال..." : "ارسال ایمیل بازیابی"}
  </button>;
}
