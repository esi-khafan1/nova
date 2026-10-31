"use client";

import { useEffect } from "react";
import { animate } from "motion";

/** The reference site's one-shot, 22px / 600ms spring reveal, adapted to Nova's sections. */
export function LandingMotion() {
  useEffect(() => {
    const root = document.querySelector<HTMLElement>(".landing-v2d");
    if (!root || typeof window.matchMedia !== "function") return;
    const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
    if (reducedMotion.matches || typeof window.IntersectionObserver !== "function") return;

    const targets = root.querySelectorAll<HTMLElement>(
      ".proof-item, .nova-why-heading, .nova-why-item, #find-path .nova-path-inner, " +
      ".nova-magazine .nova-mag-header, .nova-magazine .nova-mag-article, .nova-magazine .nova-mag-empty, " +
      "#social .social-head, #social .social-card, " +
      ".site-footer .footer-grid > *, .site-footer .footer-bottom",
    );
    const running = new Map<HTMLElement, ReturnType<typeof animate>>();
    let stopped = false;
    const expose = (element: HTMLElement) => {
      running.get(element)?.stop();
      running.delete(element);
      element.dataset.landingMotion = "played";
      element.style.removeProperty("opacity");
      element.style.removeProperty("transform");
      observer.unobserve(element);
    };
    const observer = new IntersectionObserver((entries) => {
      for (const entry of entries) {
        if (!entry.isIntersecting || stopped) continue;
        const element = entry.target as HTMLElement;
        if (element.dataset.landingMotion !== "pending") continue;
        observer.unobserve(element);
        if (reducedMotion.matches) { expose(element); continue; }
        element.dataset.landingMotion = "animating";
        const delay = Number(element.dataset.landingDelay || 0);
        // The deployed reference uses spring { bounce: 0, duration: .6 }.
        const controls = animate(element, { opacity: [0, 1], y: [22, 0] },
          { type: "spring", bounce: 0, duration: .6, delay });
        running.set(element, controls);
        void controls.then(() => {
          if (!stopped && element.dataset.landingMotion === "animating") expose(element);
        });
      }
    }, { rootMargin: "0px 0px -80px 0px", threshold: 0 });

    // Grouped delays match the reference's short, staggered card sequence.
    const groups = new Map<Element, number>();
    targets.forEach((element) => {
      const group = element.parentElement;
      const index = group ? groups.get(group) ?? 0 : 0;
      if (group) groups.set(group, index + 1);
      element.dataset.landingDelay = String(Math.min(index * .08, .24));
      // Avoid making already-visible content disappear during hydration or on
      // a deep link; animate only elements entirely below the visible screen.
      if (element.getBoundingClientRect().top > window.innerHeight + 16) {
        element.dataset.landingMotion = "pending";
        observer.observe(element);
      }
    });

    const onFocus = (event: FocusEvent) => {
      const element = (event.target as Element).closest<HTMLElement>('[data-landing-motion="pending"], [data-landing-motion="animating"]');
      if (element) expose(element);
    };
    root.addEventListener("focusin", onFocus);
    const onPreferenceChange = () => {
      if (reducedMotion.matches) {
        targets.forEach((element) => {
          if (element.dataset.landingMotion === "pending" || element.dataset.landingMotion === "animating") expose(element);
        });
      }
    };
    reducedMotion.addEventListener("change", onPreferenceChange);
    return () => {
      stopped = true;
      observer.disconnect();
      root.removeEventListener("focusin", onFocus);
      reducedMotion.removeEventListener("change", onPreferenceChange);
      targets.forEach((element) => {
        running.get(element)?.stop();
        element.style.removeProperty("opacity");
        element.style.removeProperty("transform");
        delete element.dataset.landingMotion;
        delete element.dataset.landingDelay;
      });
      running.clear();
    };
  }, []);
  return null;
}
