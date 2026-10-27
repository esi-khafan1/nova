"use client";

import { useEffect, useRef, type ReactNode } from "react";

/**
 * Keeps a single line of print text inside its box without ellipsis or wrapping.
 * The base size is the approved larger font; only overly long values shrink.
 * Extreme values are condensed horizontally after the minimum font size.
 */
export function FitText({
  children,
  basePt,
  minPt = 5.5,
  className = "",
}: {
  children: ReactNode;
  basePt: number;
  minPt?: number;
  className?: string;
}) {
  const ref = useRef<HTMLSpanElement>(null);

  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    let cancelled = false;
    let frame = 0;

    const fit = () => {
      if (cancelled || !el.clientWidth) return;
      el.style.width = "";
      el.style.maxWidth = "";
      el.style.transform = "";
      el.style.transformOrigin = "";
      el.dataset.fitScale = "1";

      let size = basePt;
      el.style.fontSize = `${size}pt`;
      while (size > minPt && el.scrollWidth > el.clientWidth + 0.2) {
        size -= 0.15;
        el.style.fontSize = `${size}pt`;
      }
      el.dataset.fitSize = size.toFixed(2);

      if (el.scrollWidth > el.clientWidth + 0.2) {
        const ratio = el.clientWidth / el.scrollWidth;
        el.style.width = `${100 / ratio}%`;
        el.style.maxWidth = "none";
        el.style.transform = `scaleX(${ratio})`;
        el.style.transformOrigin = "right center";
        el.dataset.fitScale = ratio.toFixed(3);
      }
    };

    const schedule = () => {
      cancelAnimationFrame(frame);
      frame = requestAnimationFrame(fit);
    };
    // `beforeprint` must refit synchronously: a queued animation frame may not
    // run before the browser takes its print snapshot.
    const fitForPrint = () => {
      cancelAnimationFrame(frame);
      fit();
    };

    fit();
    if (document.fonts?.ready) document.fonts.ready.then(schedule);
    const observer = new ResizeObserver(schedule);
    if (el.parentElement) observer.observe(el.parentElement);
    window.addEventListener("resize", schedule);
    window.addEventListener("beforeprint", fitForPrint);

    return () => {
      cancelled = true;
      cancelAnimationFrame(frame);
      observer.disconnect();
      window.removeEventListener("resize", schedule);
      window.removeEventListener("beforeprint", fitForPrint);
    };
  }, [basePt, minPt, children]);

  return (
    <span
      ref={ref}
      className={`print-fit-text ${className}`.trim()}
      style={{ fontSize: `${basePt}pt` }}
      data-base-pt={basePt}
      data-min-pt={minPt}
    >
      {children}
    </span>
  );
}
