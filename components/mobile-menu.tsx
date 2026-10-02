"use client";

import { useState } from "react";
import Link from "next/link";
import { Menu } from "@/components/icons";

export function MobileMenu() {
  const [open, setOpen] = useState(false);

  function close() {
    setOpen(false);
  }

  return (
    <div className="mobile-menu">
      <button
        className={`menu-button${open ? " open" : ""}`}
        type="button"
        aria-label={open ? "بستن منو" : "باز کردن منو"}
        aria-expanded={open}
        aria-controls="mobile-navigation"
        onClick={() => setOpen((current) => !current)}
      >
        {open ? <span aria-hidden="true">×</span> : <Menu />}
      </button>

      {open && (
        <>
          <button
            className="mobile-menu-backdrop"
            type="button"
            aria-label="بستن منو"
            onClick={close}
          />
          <nav id="mobile-navigation" className="mobile-menu-panel">
            <a href="#services" onClick={close}>
              خدمات
            </a>
            <a href="#how" onClick={close}>
              چطور کار می‌کند؟
            </a>
            <Link href="/mag" onClick={close}>
              مجله
            </Link>
            <a href="#about" onClick={close}>
              درباره نووا
            </a>
            <div className="mobile-menu-actions">
              <Link href="/auth?mode=signin" onClick={close}>
                ورود
              </Link>
              <Link
                className="button button-small"
                href="/auth?mode=signup"
                onClick={close}
              >
                ثبت‌نام
              </Link>
            </div>
          </nav>
        </>
      )}
    </div>
  );
}
