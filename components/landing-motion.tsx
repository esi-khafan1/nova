"use client";

import { useEffect } from "react";

/** One-shot accents on visible details, never a page-wide translate/reveal of content. */
export function LandingMotion() {
  useEffect(() => {
    const root = document.querySelector<HTMLElement>(".landing-v2d");
    if (!root || typeof window.matchMedia !== "function") return;
    const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
    if (reducedMotion.matches) return;

    // Only the existing details animate: a timeline label, benefit icon, course
    // panel, editorial cover, podcast play badge, news accent or social icon.
    // Text and links are always fully present; no card moves in from offscreen.
    const targets = root.querySelectorAll<HTMLElement>(
      ".proof-item, .nova-why-item, #find-path, " +
      "#mag .nova-mag-article, #podcasts .nova-mag-article, " +
      "#konkur-news .nova-mag-article, #social .social-card",
    );
    const observer = typeof window.IntersectionObserver === "function"
      ? new IntersectionObserver((entries) => {
          for (const entry of entries) {
            if (!entry.isIntersecting || reducedMotion.matches) continue;
            const element = entry.target as HTMLElement;
            element.dataset.landingMotion = "played";
            observer?.unobserve(element);
          }
        }, { rootMargin: "0px 0px -7% 0px", threshold: 0.05 })
      : null;

    // Without IntersectionObserver, all sections stay static and readable.
    // Above-fold/hash-anchored content is left untouched at hydration as well.
    targets.forEach((element) => {
      const rect = element.getBoundingClientRect();
      if (rect.top > window.innerHeight || rect.bottom <= 0) observer?.observe(element);
      // A hash link can land directly on the course finder. Its decorative
      // stars and panel accent may play immediately; no text is masked.
      else if (element.id === "find-path" && observer) element.dataset.landingMotion = "played";
    });

    // A small pointer-following light on the social links (fine pointers only).
    // No global mouse tracking, RAF loop, or custom cursor over the page.
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
