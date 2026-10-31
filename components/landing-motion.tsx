"use client";

import { useEffect } from "react";

/** Opt-in, one-shot section reveals; without JS/IO or with reduced motion nothing is hidden. */
export function LandingMotion() {
  useEffect(() => {
    const root = document.querySelector<HTMLElement>(".landing-v2d");
    if (!root || typeof window.matchMedia !== "function") return;
    const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
    if (reducedMotion.matches) return;

    const targets = root.querySelectorAll<HTMLElement>(
      ".proof-item, .nova-why-item, #find-path, " +
      ".nova-magazine .nova-mag-header, .nova-magazine .nova-mag-article, " +
      "#social .social-head, #social .social-card",
    );
    const observer = typeof window.IntersectionObserver === "function"
      ? new IntersectionObserver((entries) => {
          for (const entry of entries) {
            // IntersectionObserver also reports an initial intersection of 0.
            // Wait until a meaningful part of the item is inside the inner 70%
            // of the viewport, so its animation plays while it is in view.
            if (!entry.isIntersecting || entry.intersectionRatio < 0.12 || reducedMotion.matches) continue;
            const element = entry.target as HTMLElement;
            element.dataset.landingMotion = "played";
            observer?.unobserve(element);
          }
        }, { rootMargin: "0px 0px -30% 0px", threshold: [0, 0.12] })
      : null;

    // Arm only items that were already fully below the viewport at hydration.
    // Never make a visible item (or a hash-anchored section) disappear on load.
    // No observer means no pending attribute and therefore no hidden content.
    if (observer) targets.forEach((element) => {
      if (element.getBoundingClientRect().top > window.innerHeight + 16) {
        element.dataset.landingMotion = "pending";
        observer.observe(element);
      }
    });

    const onFocus = (event: FocusEvent) => {
      const pending = (event.target as Element).closest<HTMLElement>('[data-landing-motion="pending"]');
      if (pending) {
        pending.dataset.landingMotion = "played";
        observer?.unobserve(pending);
      }
    };
    root.addEventListener("focusin", onFocus);

    // Keep the existing fine-pointer social spotlight, scoped to its section.
    const finePointer = window.matchMedia("(hover: hover) and (pointer: fine)");
    const social = root.querySelector<HTMLElement>("#social");
    const onPointerMove = (event: PointerEvent) => {
      const card = (event.target as Element).closest<HTMLElement>(".social-card");
      if (!card || reducedMotion.matches) return;
      const rect = card.getBoundingClientRect();
      if (!rect.width || !rect.height) return;
      card.style.setProperty("--motion-x", `${Math.max(0, Math.min(100, ((event.clientX - rect.left) / rect.width) * 100))}%`);
      card.style.setProperty("--motion-y", `${Math.max(0, Math.min(100, ((event.clientY - rect.top) / rect.height) * 100))}%`);
    };
    if (finePointer.matches) social?.addEventListener("pointermove", onPointerMove, { passive: true });

    const stop = () => {
      observer?.disconnect();
      // If the preference changes or the component unmounts, expose anything
      // still waiting; no content remains blank after motion is disabled.
      targets.forEach((element) => {
        if (element.dataset.landingMotion === "pending") delete element.dataset.landingMotion;
      });
      root.removeEventListener("focusin", onFocus);
      social?.removeEventListener("pointermove", onPointerMove);
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
