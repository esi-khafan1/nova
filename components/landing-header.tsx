"use client";

import Link from "next/link";
import { useEffect, useRef, useState } from "react";
import { AnimatePresence, motion, useReducedMotion } from "motion/react";

const items = [
  { label: "آزمون‌های من", href: "/dashboard/student/exams", icon: "exam", private: true },
  { label: "برنامه هفتگی", href: "/dashboard/student", icon: "week", private: true },
  { label: "دریافت برنامه روزانه", href: "/dashboard/student#daily-plan", icon: "day", private: true },
  { label: "سوالات متداول", href: "/faq", icon: "help", private: false },
  { label: "درباره ما", href: "/about", icon: "about", private: false },
];

function Icon({ type }: { type: string }) {
  const drawings: Record<string, React.ReactNode> = {
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

// The reference's bars: ±6.5px to a cross, with the middle sliding out.
function MenuBars({ open, enter = false }: { open: boolean; enter?: boolean }) {
  const reduced = useReducedMotion();
  const spring = reduced ? { duration: 0 } : { type: "spring" as const, bounce: 0, duration: .4 };
  return <>
    <motion.span initial={enter && !reduced ? { y: -6.5, rotate: 0 } : false} animate={{ y: open ? 0 : -6.5, rotate: open ? 45 : 0 }} transition={spring} />
    <motion.span initial={enter && !reduced ? { opacity: 1, x: 0 } : false} animate={{ opacity: open ? 0 : 1, x: open ? 8 : 0 }} transition={{ duration: reduced ? 0 : .2 }} />
    <motion.span initial={enter && !reduced ? { y: 6.5, rotate: 0 } : false} animate={{ y: open ? 0 : 6.5, rotate: open ? -45 : 0 }} transition={spring} />
  </>;
}

const counselorItems = [{label:"نمای کلی",href:"/dashboard/counselor",icon:"about",private:true},{label:"دانش‌آموزان و گزارش‌ها",href:"/dashboard/counselor/students",icon:"day",private:true},{label:"برنامه‌های هفتگی",href:"/dashboard/counselor/plans",icon:"week",private:true},{label:"آزمون‌ها",href:"/dashboard/counselor/exams",icon:"exam",private:true},{label:"استودیوی محتوا",href:"/dashboard/counselor/content",icon:"exam",private:true},{label:"اخبار کنکور",href:"/dashboard/counselor/news",icon:"exam",private:true},{label:"پادکست‌ها",href:"/dashboard/counselor/podcasts",icon:"about",private:true},{label:"مشاهده سایت",href:"/",icon:"about",private:false}];

const examDesignerItems = [
  { label: "نمای کلی", href: "/dashboard/exam_designer", icon: "exam", private: true },
  { label: "مشاهده سایت", href: "/", icon: "about", private: false },
];

const contentManagerItems = [
  { label: "میز بررسی محتوا", href: "/dashboard/content_manager", icon: "about", private: true },
  { label: "حساب کاربری", href: "/dashboard/account", icon: "account", private: true },
  { label: "مشاهده سایت", href: "/", icon: "about", private: false },
];
const supportAgentItems = [
  { label: "گفت‌وگو با کاربران", href: "/dashboard/support_agent", icon: "day", private: true },
  { label: "حساب کاربری", href: "/dashboard/account", icon: "account", private: true },
  { label: "مشاهده سایت", href: "/", icon: "about", private: false },
];

export function LandingHeader({ isAuthenticated, studentPanel = false, counselorPanel = false, examDesignerPanel = false, contentManagerPanel = false, supportAgentPanel = false }: { isAuthenticated: boolean; studentPanel?: boolean; counselorPanel?: boolean; examDesignerPanel?: boolean; contentManagerPanel?: boolean; supportAgentPanel?: boolean }) {
  const [open, setOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const reduced = useReducedMotion();
  const trigger = useRef<HTMLButtonElement>(null);
  const panel = useRef<HTMLElement>(null);
  const cart = useRef<HTMLDialogElement>(null);

  function close() { setOpen(false); trigger.current?.focus(); }

  useEffect(() => {
    const update = () => setScrolled(window.scrollY > 16);
    update();
    window.addEventListener("scroll", update, { passive: true });
    return () => window.removeEventListener("scroll", update);
  }, []);

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
    <header className={`nova-site-header${scrolled ? " nova-site-header--scrolled" : ""}`}>
      <div className="nova-header-inner">
        <button ref={trigger} type="button" className="nova-icon-button nova-menu-trigger nova-burger" aria-label="باز کردن منو" aria-expanded={open} aria-controls="nova-navigation" onClick={() => setOpen(true)}><MenuBars open={open} /></button>
        <Link href="/" className="nova-header-brand" aria-label="صفحه اصلی نوا"><img src="/nova/mark.svg" width="84" height="84" alt="لوگوی N نوا" /></Link>
        <div className="nova-header-tools">
          <Link href={examDesignerPanel ? "/dashboard/exam_designer" : counselorPanel ? "/dashboard/counselor" : contentManagerPanel || supportAgentPanel ? "/dashboard/account" : studentPanel ? "/dashboard/student/account" : isAuthenticated ? "/dashboard" : "/auth?mode=signin"} className="nova-icon-button" aria-label="حساب کاربری"><Icon type="account" /></Link>
          <button type="button" className="nova-icon-button" aria-label="سبد خرید" onClick={() => cart.current?.showModal()}><Icon type="cart" /></button>
        </div>
      </div>
    </header>
    <AnimatePresence>
      {open && <motion.button key="backdrop" type="button" className="nova-menu-scrim" aria-label="بستن منو"
        initial={reduced ? false : { opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
        transition={{ duration: reduced ? 0 : .25 }} onClick={close} />}
      {open && <motion.aside key="panel" ref={panel} id="nova-navigation" className="nova-menu-panel" role="dialog" aria-modal="true" aria-labelledby="nova-menu-title"
          initial={reduced ? false : { opacity: 0, scale: .76, y: -12, borderRadius: 14 }}
          animate={{ opacity: 1, scale: 1, y: 0, borderRadius: 28 }}
          exit={{ opacity: 0, scale: .76, y: -12, borderRadius: 14 }}
          transition={reduced ? { duration: 0 } : { type: "spring", stiffness: 260, damping: 28, mass: .9 }}>
          <div className="nova-panel-heading"><strong id="nova-menu-title">نوا، همراه مسیر تو</strong><button className="nova-icon-button nova-burger" type="button" aria-label="بستن منو" onClick={close}><MenuBars open enter /></button></div>
          <nav aria-label="منوی اصلی">{(examDesignerPanel ? examDesignerItems : counselorPanel ? counselorItems : contentManagerPanel ? contentManagerItems : supportAgentPanel ? supportAgentItems : items).map((item, index) =>
            <motion.div key={item.href} initial={reduced ? false : { opacity: 0, x: 18 }} animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 18 }} transition={reduced ? { duration: 0 } : { type: "spring", bounce: .2, duration: .5, delay: .18 + index * .05 }}>
              <Link href={studentPanel && item.icon === "week" ? "/dashboard/student#weekly-plan" : item.private && !isAuthenticated ? `/auth?mode=signin&next=${encodeURIComponent(item.href)}` : item.href} prefetch={false} onClick={close}><Icon type={item.icon} /><span>{item.label}</span></Link>
            </motion.div>)}</nav>
          <motion.p initial={reduced ? false : { opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}
            transition={reduced ? { duration: 0 } : { type: "spring", bounce: 0, duration: .5, delay: .32 }}>آموزش، برنامه‌ریزی و یک آینده روشن‌تر.</motion.p>
        </motion.aside>}
    </AnimatePresence>
    <dialog ref={cart} className="nova-cart-dialog" aria-labelledby="nova-cart-title" onClick={event => { if (event.target === cart.current) { const r = cart.current.getBoundingClientRect(); if (event.clientX < r.left || event.clientX > r.right || event.clientY < r.top || event.clientY > r.bottom) cart.current.close(); } }}>
      <div className="nova-panel-heading"><h2 id="nova-cart-title">سبد خرید</h2><button className="nova-icon-button" type="button" aria-label="بستن سبد خرید" onClick={() => cart.current?.close()}><Icon type="close" /></button></div>
      <p>در حال حاضر خرید آنلاین از این بخش فعال نیست.</p>
    </dialog>
  </>;
}
