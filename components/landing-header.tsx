"use client";

import Link from "next/link";
import { useEffect, useRef, useState } from "react";

const items = [
  { label: "آزمون های من", href: "/dashboard/student/exams", icon: "exam", private: true },
  { label: "برنامه هفتگی", href: "/dashboard/student", icon: "week", private: true },
  { label: "دریافت برنامه روزانه", href: "/dashboard/student#daily-plan", icon: "day", private: true },
  { label: "سوالات متداول", href: "/faq", icon: "help", private: false },
  { label: "درباره ما", href: "/about", icon: "about", private: false },
];

function Icon({ type }: { type: string }) {
  const drawings: Record<string, React.ReactNode> = {
    menu: <path d="M4 6h16M4 12h16M4 18h10" />,
    close: <path d="m6 6 12 12M6 18 18 6" />,
    account: <><circle cx="12" cy="8" r="4" /><path d="M4 21v-2a8 8 0 0 1 16 0v2" /></>,
    cart: <><path d="M3 3h2l3 13h10l3-10H6" /><circle cx="9" cy="21" r="1" /><circle cx="18" cy="21" r="1" /></>,
    exam: <path d="M8 3h8v4H8zM8 5H5v16h14V5h-3M8 12h8M8 16h5" />,
    week: <><rect x="3" y="5" width="18" height="16" rx="2" /><path d="M7 3v4M17 3v4M3 11h18M8 15h2M14 15h2" /></>,
    day: <><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 2" /></>,
    help: <><circle cx="12" cy="12" r="9" /><path d="M9.5 8a2.5 2.5 0 0 1 5 0c0 2-2.5 2-2.5 4M12 16h.01" /></>,
    about: <><circle cx="12" cy="12" r="9" /><path d="M12 11v6M12 7h.01" /></>,
  };
  return <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{drawings[type]}</svg>;
}

export function LandingHeader({ isAuthenticated }: { isAuthenticated: boolean }) {
  const [open, setOpen] = useState(false);
  const trigger = useRef<HTMLButtonElement>(null);
  const panel = useRef<HTMLElement>(null);
  const cart = useRef<HTMLDialogElement>(null);

  function close() { setOpen(false); trigger.current?.focus(); }

  useEffect(() => {
    if (!open) return;
    const previousOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    panel.current?.querySelector<HTMLButtonElement>("button")?.focus();
    const keydown = (event: KeyboardEvent) => {
      if (event.key === "Escape") { setOpen(false); trigger.current?.focus(); }
      if (event.key !== "Tab") return;
      const controls = panel.current?.querySelectorAll<HTMLElement>("a[href], button");
      if (!controls?.length) return;
      const first = controls[0], last = controls[controls.length - 1];
      if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last.focus(); }
      else if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first.focus(); }
    };
    document.addEventListener("keydown", keydown);
    return () => { document.body.style.overflow = previousOverflow; document.removeEventListener("keydown", keydown); };
  }, [open]);

  return <>
    <header className="nova-site-header">
      <div className="nova-header-inner">
        <button ref={trigger} type="button" className="nova-icon-button nova-menu-trigger" aria-label="باز کردن منو" aria-expanded={open} aria-controls="nova-navigation" onClick={() => setOpen(true)}><Icon type="menu" /></button>
        <Link href="/" className="nova-header-brand" aria-label="صفحه اصلی نوا"><img src="/nova/mark.svg" width="84" height="84" alt="لوگوی N نوا" /></Link>
        <div className="nova-header-tools">
          <Link href={isAuthenticated ? "/dashboard" : "/auth?mode=signin"} className="nova-icon-button" aria-label="حساب کاربری"><Icon type="account" /></Link>
          <button type="button" className="nova-icon-button" aria-label="سبد خرید" onClick={() => cart.current?.showModal()}><Icon type="cart" /></button>
        </div>
      </div>
    </header>
    {open && <>
      <button type="button" className="nova-menu-scrim" aria-label="بستن منو" onClick={close} />
      <aside ref={panel} id="nova-navigation" className="nova-menu-panel" role="dialog" aria-modal="true" aria-labelledby="nova-menu-title">
        <div className="nova-panel-heading"><strong id="nova-menu-title">نوا، همراه مسیر تو</strong><button className="nova-icon-button" type="button" aria-label="بستن منو" onClick={close}><Icon type="close" /></button></div>
        <nav aria-label="منوی اصلی">{items.map(item => <Link key={item.href} href={item.private && !isAuthenticated ? `/auth?mode=signin&next=${encodeURIComponent(item.href)}` : item.href} prefetch={false} onClick={close}><Icon type={item.icon} /><span>{item.label}</span></Link>)}</nav>
        <p>آموزش، برنامه‌ریزی و یک آینده روشن‌تر.</p>
      </aside>
    </>}
    <dialog ref={cart} className="nova-cart-dialog" aria-labelledby="nova-cart-title" onClick={event => { if (event.target === cart.current) { const r = cart.current.getBoundingClientRect(); if (event.clientX < r.left || event.clientX > r.right || event.clientY < r.top || event.clientY > r.bottom) cart.current.close(); } }}>
      <div className="nova-panel-heading"><h2 id="nova-cart-title">سبد خرید</h2><button className="nova-icon-button" type="button" aria-label="بستن سبد خرید" onClick={() => cart.current?.close()}><Icon type="close" /></button></div>
      <p>در حال حاضر خرید آنلاین از این بخش فعال نیست.</p>
    </dialog>
  </>;
}
