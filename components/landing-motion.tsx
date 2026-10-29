"use client";

import { useEffect } from "react";

/** One-shot, progressive enhancement: all content remains visible without JS. */
export function LandingMotion() {
  useEffect(() => {
    const root = document.querySelector<HTMLElement>(".landing-v2d");
    if (!root || typeof window.IntersectionObserver !== "function" || typeof window.matchMedia !== "function") return;
    const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
    if (reducedMotion.matches) return;

    const running = new Set<Animation>();
    const observer = new IntersectionObserver((entries) => {
      for (const entry of entries) {
        if (!entry.isIntersecting) continue;
        observer.unobserve(entry.target);
        const element = entry.target as HTMLElement;
        if (reducedMotion.matches || typeof element.animate !== "function") continue;
        const animation = element.animate(
          [{ opacity: 0.55, transform: "translate3d(0, 16px, 0)" }, { opacity: 1, transform: "translate3d(0, 0, 0)" }],
          { duration: 480, easing: "cubic-bezier(.22, 1, .36, 1)" },
        );
        running.add(animation);
        animation.addEventListener("finish", () => running.delete(animation), { once: true });
      }
    }, { rootMargin: "0px 0px -8% 0px", threshold: 0.05 });

    const targets = root.querySelectorAll<HTMLElement>(
      ".proof-item, .nova-why-heading, .nova-why-item, #find-path .nova-path-panel, " +
      ".nova-magazine .nova-mag-header, .nova-magazine .nova-mag-article, " +
      ".social-head, .social-card",
    );
    // Don't animate what's already on screen when hydration completes or when
    // visiting a hash anchor. Observed content is never hidden while waiting.
    targets.forEach((element) => {
      if (element.getBoundingClientRect().top > window.innerHeight + 24) observer.observe(element);
    });

    const stop = () => {
      observer.disconnect();
      running.forEach((animation) => animation.cancel());
      running.clear();
    };
    const onPreferenceChange = (event: MediaQueryListEvent) => { if (event.matches) stop(); };
    reducedMotion.addEventListener("change", onPreferenceChange);
    return () => {
      reducedMotion.removeEventListener("change", onPreferenceChange);
      stop();
    };
  }, []);

  return null;
}
