"use client";

import { useEffect } from "react";

/** Progressive enhancement: content stays readable without JS, observers or WAAPI. */
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

        // Distinct one-shot entrances for the timeline, benefits, course finder,
        // articles, podcasts, news and social links. Keep the first keyframe
        // partly visible so delayed/hydrating content never disappears.
        const index = Array.prototype.indexOf.call(element.parentElement?.children ?? [], element) as number;
        const stagger = Math.min(Math.max(index, 0), 4) * 65;
        let start: Keyframe = { opacity: 0.6, transform: "translate3d(0, 18px, 0)" };
        let duration = 520;
        if (element.matches(".proof-item")) {
          start = { opacity: 0.65, transform: "translate3d(0, 22px, 0) scale(.96)" };
          duration = 460;
        } else if (element.matches(".nova-why-item")) {
          start = { opacity: 0.62, transform: `translate3d(${index % 2 ? "-22" : "22"}px, 0, 0)` };
          duration = 480;
        } else if (element.matches(".nova-path-panel")) {
          start = { opacity: 0.62, transform: "scale(.97)" };
          duration = 590;
        } else if (element.matches(".nova-mag-article")) {
          if (element.closest(".nova-podcasts")) start = { opacity: 0.65, transform: "translate3d(0, 12px, 0) scale(.95)" };
          else if (element.closest(".nova-konkur-news")) start = { opacity: 0.65, transform: "translate3d(-24px, 0, 0)" };
          else start = { opacity: 0.65, transform: "translate3d(0, 24px, 0)" };
          duration = 540;
        } else if (element.matches(".social-card")) {
          start = { opacity: 0.68, transform: `translate3d(0, 12px, 0) scale(.96) rotate(${index % 2 ? 1.5 : -1.5}deg)` };
          duration = 560;
        }
        const animation = element.animate(
          [start, { opacity: 1, transform: "none" }],
          { duration, delay: element.matches(".proof-item, .nova-why-item, .nova-mag-article, .social-card") ? stagger : 0,
            easing: "cubic-bezier(.22, 1, .36, 1)", fill: "backwards" },
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
    // Do not animate elements already visible at hydration or a hash anchor.
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
