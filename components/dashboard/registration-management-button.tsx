"use client";

export function RegistrationManagementButton({ label, message, className = "button button-secondary", disabled = false }: {
  label: string;
  message: string;
  className?: string;
  disabled?: boolean;
}) {
  return <button type="submit" className={className} disabled={disabled} onClick={event => {
    if (!event.currentTarget.form?.reportValidity() || !window.confirm(message)) event.preventDefault();
  }}>{label}</button>;
}
