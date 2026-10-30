"use client";

import type { FormEvent, InvalidEvent, ReactNode, SyntheticEvent } from "react";

// Keep browser constraint validation (including its bubble beside the field)
// before any server action. Server-side validation still protects direct calls.
export function RequiredFieldsForm({ action, className, children }: {
  action: (formData: FormData) => void | Promise<void>;
  className: string;
  children: ReactNode;
}) {
  function handleInvalid(event: InvalidEvent<HTMLFormElement>) {
    const field = event.target;
    if (field instanceof HTMLInputElement || field instanceof HTMLSelectElement || field instanceof HTMLTextAreaElement) {
      if (field.validity.valueMissing) field.setCustomValidity("لطفاً این فیلد را پر کن.");
    }
  }
  function clearMessage(event: SyntheticEvent<HTMLFormElement>) {
    const field = event.target;
    if (field instanceof HTMLInputElement || field instanceof HTMLSelectElement || field instanceof HTMLTextAreaElement) {
      field.setCustomValidity("");
    }
  }
  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    if (!event.currentTarget.reportValidity()) event.preventDefault();
  }
  return <form action={action} className={className} onSubmit={handleSubmit}
    onInvalidCapture={handleInvalid} onChangeCapture={clearMessage} onInputCapture={clearMessage}>
    {children}
  </form>;
}
