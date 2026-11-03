"use client";

import { useEffect, useRef, useState, useCallback } from "react";
import { toPersianDigits } from "@/lib/persian-date";
import { boundedPdfPixelRatio, fitPdfScale } from "@/lib/pdf-canvas";

interface PdfViewport {
  width: number;
  height: number;
}

interface PdfRenderTask {
  promise: Promise<void>;
  cancel: () => void;
}

interface PdfPage {
  getViewport: (options: { scale: number }) => PdfViewport;
  render: (options: {
    canvasContext: CanvasRenderingContext2D;
    viewport: PdfViewport;
    transform?: number[];
  }) => PdfRenderTask;
}

interface PdfDocument {
  numPages: number;
  getPage: (pageNumber: number) => Promise<PdfPage>;
  destroy: () => Promise<void>;
}

interface PdfJsLib {
  GlobalWorkerOptions: {
    workerSrc: string;
  };
  getDocument: (options: {
    data: Uint8Array;
    isEvalSupported?: boolean;
    cMapUrl?: string;
    cMapPacked?: boolean;
    standardFontDataUrl?: string;
  }) => {
    promise: Promise<PdfDocument>;
  };
}

interface WindowWithPdfJs extends Window {
  pdfjsLib?: PdfJsLib;
}

interface PdfViewerProps {
  url: string;
  title?: string;
  className?: string;
}

export function PdfViewer({ url, title, className = "" }: PdfViewerProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const scrollRef = useRef<HTMLDivElement>(null);
  const pagesContainerRef = useRef<HTMLDivElement>(null);

  // References to keep track of active pdf instance and rendering tasks
  const pdfDocRef = useRef<PdfDocument | null>(null);
  const renderTasksRef = useRef<Map<number, PdfRenderTask>>(new Map());
  const pageObserverRef = useRef<IntersectionObserver | null>(null);
  const renderGenerationRef = useRef(0);
  const loadGenerationRef = useRef(0);
  const pageNodesRef = useRef<Map<number, HTMLDivElement>>(new Map());
  const blobUrlRef = useRef<string | null>(null);

  // Keep server and client hydration identical. Embedded native PDF is not
  // reliable on mobile browsers (especially iOS and Android WebViews).
  const [viewMode, setViewMode] = useState<"native" | "canvas">("native");
  useEffect(() => {
    if (/Android|iPhone|iPad|iPod/i.test(navigator.userAgent)) setViewMode("canvas");
  }, []);

  const [blobUrl, setBlobUrl] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [numPages, setNumPages] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [scale, setScale] = useState(1.0);
  const [isFullscreen, setIsFullscreen] = useState(false);

  // Ensure PDF.js script is loaded (using self-hosted local worker and engine)
  const ensurePdfJsLoaded = useCallback(async (): Promise<PdfJsLib | null> => {
    if (typeof window === "undefined") return null;
    const win = window as unknown as WindowWithPdfJs;
    if (win.pdfjsLib) {
      win.pdfjsLib.GlobalWorkerOptions.workerSrc = "/pdfjs/pdf.worker.min.js";
      return win.pdfjsLib;
    }

    return new Promise((resolve, reject) => {
      const existingScript = document.getElementById("pdfjs-lib-script");
      if (existingScript) {
        if (win.pdfjsLib) {
          win.pdfjsLib.GlobalWorkerOptions.workerSrc = "/pdfjs/pdf.worker.min.js";
          resolve(win.pdfjsLib);
          return;
        }
        existingScript.addEventListener("load", () => {
          if (win.pdfjsLib) {
            win.pdfjsLib.GlobalWorkerOptions.workerSrc = "/pdfjs/pdf.worker.min.js";
            resolve(win.pdfjsLib);
          } else {
            existingScript.remove();
            reject(new Error("موتور PDF در دسترس نیست"));
          }
        }, { once: true });
        existingScript.addEventListener("error", () => {
          existingScript.remove();
          reject(new Error("خطا در بارگذاری موتور نمایش PDF"));
        }, { once: true });
        return;
      }

      const script = document.createElement("script");
      script.id = "pdfjs-lib-script";
      script.src = "/pdfjs/pdf.min.js";
      script.async = true;
      script.onload = () => {
        if (win.pdfjsLib) {
          win.pdfjsLib.GlobalWorkerOptions.workerSrc = "/pdfjs/pdf.worker.min.js";
          resolve(win.pdfjsLib);
        } else {
          script.remove();
          reject(new Error("موتور PDF در دسترس نیست"));
        }
      };
      script.onerror = () => { script.remove(); reject(new Error("عدم امکان بارگذاری کتابخانه PDF")); };
      document.head.appendChild(script);
    });
  }, []);

  // Cancel all ongoing render tasks
  const cancelAllRenderTasks = useCallback(() => {
    renderGenerationRef.current += 1;
    pageObserverRef.current?.disconnect();
    pageObserverRef.current = null;
    renderTasksRef.current.forEach((task) => {
      try {
        task.cancel();
      } catch {}
    });
    renderTasksRef.current.clear();
  }, []);

  // PDF pages have different sizes. Observe their placeholders and rasterize
  // near the viewport, not every page at once (mobile memory exhaustion used
  // to leave later pages blank or apparently scrambled).
  const renderAllPages = useCallback(async (pdf: PdfDocument, currentScale: number) => {
    cancelAllRenderTasks();
    const generation = renderGenerationRef.current;
    const container = pagesContainerRef.current;
    if (!container) return;
    container.replaceChildren();
    pageNodesRef.current.clear();
    const visiblePages = new Map<Element, { draw: () => void; clear: () => void }>();
    const observer = typeof IntersectionObserver !== "undefined"
      ? new IntersectionObserver(entries => {
          for (const entry of entries) {
            const view = visiblePages.get(entry.target);
            if (entry.isIntersecting) view?.draw();
            else view?.clear();
          }
        }, { root: scrollRef.current, rootMargin: "600px 0px", threshold: 0 })
      : null;
    pageObserverRef.current = observer;

    for (let pageNum = 1; pageNum <= pdf.numPages; pageNum++) {
      if (generation !== renderGenerationRef.current) return;
      try {
        const page = await pdf.getPage(pageNum);
        if (generation !== renderGenerationRef.current) return;
        const viewport = page.getViewport({ scale: currentScale });
        const pageWrapper = document.createElement("div");
        pageWrapper.id = `pdf-page-${pageNum}`;
        pageWrapper.className = "exam-pdf-page-wrapper";
        pageWrapper.setAttribute("data-page-num", String(pageNum));
        pageWrapper.style.width = `${viewport.width}px`;
        pageWrapper.style.height = `${viewport.height}px`;
        const pageBadge = document.createElement("div");
        pageBadge.className = "exam-pdf-page-badge";
        pageBadge.textContent = `صفحه ${toPersianDigits(pageNum)}`;
        pageWrapper.appendChild(pageBadge);
        const canvas = document.createElement("canvas");
        canvas.className = "exam-pdf-page-canvas";
        canvas.width = 0;
        canvas.height = 0;
        canvas.style.width = `${viewport.width}px`;
        canvas.style.height = `${viewport.height}px`;
        pageWrapper.appendChild(canvas);
        container.appendChild(pageWrapper);
        pageNodesRef.current.set(pageNum, pageWrapper);
        const draw = async () => {
          if (generation !== renderGenerationRef.current || canvas.width || renderTasksRef.current.has(pageNum)) return;
          // Bound each bitmap to ~3 megapixels and at most 2x device pixels.
          const dpr = boundedPdfPixelRatio(viewport.width, viewport.height, window.devicePixelRatio);
          canvas.width = Math.max(1, Math.round(viewport.width * dpr));
          canvas.height = Math.max(1, Math.round(viewport.height * dpr));
          const ctx = canvas.getContext("2d");
          if (generation !== renderGenerationRef.current) return;
          if (!ctx) { setError("نمایش PDF در این مرورگر امکان‌پذیر نیست. نمای مرورگر یا دریافت فایل را امتحان کن."); return; }
          let task: PdfRenderTask | null = null;
          try {
            task = page.render({ canvasContext: ctx, viewport,
              transform: [canvas.width / viewport.width, 0, 0, canvas.height / viewport.height, 0, 0] });
            renderTasksRef.current.set(pageNum, task);
            await task.promise;
          } catch (err: unknown) {
            if (generation === renderGenerationRef.current && (err as { name?: string })?.name !== "RenderingCancelledException") {
              console.error("PDF page render error:", err);
              setError(`نمایش صفحهٔ ${toPersianDigits(pageNum)} انجام نشد. نمای مرورگر یا دریافت فایل را امتحان کن.`);
            }
          } finally {
            if (task && renderTasksRef.current.get(pageNum) === task) renderTasksRef.current.delete(pageNum);
          }
        };
        const clear = () => {
          renderTasksRef.current.get(pageNum)?.cancel();
          renderTasksRef.current.delete(pageNum);
          canvas.width = 0;
          canvas.height = 0;
        };
        if (observer) { visiblePages.set(pageWrapper, { draw, clear }); observer.observe(pageWrapper); }
        else void draw();
      } catch (err) {
        if (generation === renderGenerationRef.current) {
          console.error(`Error loading PDF page ${pageNum}:`, err);
          setError(`بارگذاری صفحهٔ ${toPersianDigits(pageNum)} انجام نشد.`);
        }
      }
    }
  }, [cancelAllRenderTasks]);

  // Load PDF Document when URL changes
  const loadPdf = useCallback(async () => {
    if (!url) {
      setLoading(false);
      setError("آدرس فایل سؤالات موجود نیست.");
      return;
    }

    const generation = ++loadGenerationRef.current;
    setLoading(true);
    setError(null);
    cancelAllRenderTasks();

    try {
      // Safely encode URI to handle Persian filenames in URL
      const safeUrl = encodeURI(decodeURI(url));

      // Fetch array buffer to prevent IDM interception and bypass CORS
      const res = await fetch(safeUrl);
      if (!res.ok) throw new Error(`عدم موفقیت در دریافت فایل (${res.status})`);
      const buffer = await res.arrayBuffer();
      if (generation !== loadGenerationRef.current) return;

      // Revoke old blob URL if existing
      if (blobUrlRef.current) {
        URL.revokeObjectURL(blobUrlRef.current);
      }
      const blob = new Blob([buffer], { type: "application/pdf" });
      const newBlobUrl = URL.createObjectURL(blob);
      blobUrlRef.current = newBlobUrl;
      setBlobUrl(newBlobUrl);

      // Load PDF.js with local CMaps and standard fonts for accurate glyph metrics
      const lib = await ensurePdfJsLoaded();
      if (generation !== loadGenerationRef.current) return;
      if (lib) {
        try {
          const loadingTask = lib.getDocument({
            data: new Uint8Array(buffer),
            isEvalSupported: false,
            cMapUrl: "/pdfjs/cmaps/",
            cMapPacked: true,
            standardFontDataUrl: "/pdfjs/standard_fonts/",
          });
          const pdf = await loadingTask.promise;
          if (generation !== loadGenerationRef.current) { void pdf.destroy(); return; }

          pdfDocRef.current = pdf;
          setNumPages(pdf.numPages);
          setCurrentPage(1);

          // Use this PDF's real page width, not a hard-coded A4 width.
          const firstPage = await pdf.getPage(1);
          const pageWidth = firstPage.getViewport({ scale: 1 }).width;
          const initialScale = fitPdfScale(pageWidth, containerRef.current?.clientWidth ?? 0);
          setScale(initialScale);
        } catch (pdfErr) {
          if (generation !== loadGenerationRef.current) return;
          console.warn("PDF.js parse warning:", pdfErr);
          setError("نمایش این فایل در مرورگر انجام نشد. فایل اصلی را مستقیماً باز یا دریافت کن.");
        }
      } else {
        setError("موتور نمایش PDF در دسترس نیست. فایل اصلی را مستقیماً باز یا دریافت کن.");
      }

      setLoading(false);
    } catch (err: unknown) {
      if (generation !== loadGenerationRef.current) return;
      console.error("PDF Load Error:", err);
      const message =
        err instanceof Error ? err.message : "خطا در بارگذاری دفترچه سؤالات.";
      setError(message);
      setLoading(false);
    }
  }, [url, ensurePdfJsLoaded, cancelAllRenderTasks]);

  useEffect(() => {
    loadPdf();
    return () => {
      loadGenerationRef.current += 1;
      cancelAllRenderTasks();
      if (pdfDocRef.current) {
        try {
          pdfDocRef.current.destroy();
        } catch {}
      }
      if (blobUrlRef.current) {
        URL.revokeObjectURL(blobUrlRef.current);
        blobUrlRef.current = null;
      }
    };
  }, [loadPdf, cancelAllRenderTasks]);

  // Handle re-rendering when scale changes in canvas mode
  useEffect(() => {
    if (viewMode === "canvas" && pdfDocRef.current && !loading) {
      renderAllPages(pdfDocRef.current, scale);
    } else if (viewMode === "native") {
      cancelAllRenderTasks();
    }
  }, [scale, loading, viewMode, renderAllPages, cancelAllRenderTasks]);

  // Track active page while scrolling in canvas mode
  useEffect(() => {
    if (viewMode !== "canvas") return;
    const scrollEl = scrollRef.current;
    if (!scrollEl) return;

    const handleScroll = () => {
      const scrollTop = scrollEl.scrollTop;
      const scrollCenter = scrollTop + scrollEl.clientHeight / 3;

      let activePage = 1;
      for (const [pageNum, node] of pageNodesRef.current.entries()) {
        if (node.offsetTop <= scrollCenter) {
          activePage = pageNum;
        }
      }
      setCurrentPage(activePage);
    };

    scrollEl.addEventListener("scroll", handleScroll, { passive: true });
    return () => scrollEl.removeEventListener("scroll", handleScroll);
  }, [viewMode]);

  // Jump to specific page
  const scrollToPage = (pageNum: number) => {
    const node = pageNodesRef.current.get(pageNum);
    if (node && scrollRef.current) {
      scrollRef.current.scrollTo({
        top: node.offsetTop - 16,
        behavior: "smooth",
      });
      setCurrentPage(pageNum);
    }
  };

  // Zoom controls
  const handleZoomIn = () => {
    setScale((s) => Math.min(2.5, +(s + 0.15).toFixed(2)));
  };

  const handleZoomOut = () => {
    setScale((s) => Math.max(0.5, +(s - 0.15).toFixed(2)));
  };

  const handleFitWidth = async () => {
    if (!pdfDocRef.current) return;
    const page = await pdfDocRef.current.getPage(currentPage);
    const pageWidth = page.getViewport({ scale: 1 }).width;
    setScale(fitPdfScale(pageWidth, containerRef.current?.clientWidth ?? 0));
  };

  // Fullscreen toggle
  const toggleFullscreen = () => {
    if (!containerRef.current) return;

    if (!document.fullscreenElement) {
      containerRef.current
        .requestFullscreen()
        .then(() => setIsFullscreen(true))
        .catch(() => {});
    } else {
      document.exitFullscreen().then(() => setIsFullscreen(false)).catch(() => {});
    }
  };

  useEffect(() => {
    const handleFsChange = () => {
      setIsFullscreen(Boolean(document.fullscreenElement));
    };
    document.addEventListener("fullscreenchange", handleFsChange);
    return () => document.removeEventListener("fullscreenchange", handleFsChange);
  }, []);

  return (
    <div
      ref={containerRef}
      className={`exam-pdf-custom-viewer ${isFullscreen ? "is-fullscreen" : ""} ${className}`}
    >
      {/* Viewer Toolbar */}
      <div className="exam-pdf-toolbar">
        {/* View Mode Switcher (Native vs Canvas) */}
        <div className="exam-pdf-tools-cluster">
          <div className="exam-pdf-view-switch" role="group" aria-label="حالت نمایش دفترچه">
            <button
              type="button"
              className={`exam-pdf-view-switch-btn ${viewMode === "native" ? "is-active" : ""}`}
              onClick={() => setViewMode("native")}
              title="نمایش با موتور اصلی مرورگر (کیفیت اصلی و بدون به‌هم‌ریختگی)"
            >
              🗔 نمای مرورگر (اصلی)
            </button>
            <button
              type="button"
              className={`exam-pdf-view-switch-btn ${viewMode === "canvas" ? "is-active" : ""}`}
              onClick={() => {
                setViewMode("canvas");

              }}
              title="نمایش اسکرول متوالی وب"
            >
              📜 نمای متوالی وب
            </button>
          </div>
        </div>

        {/* Page Nav (Only in Canvas Mode) */}
        {viewMode === "canvas" && (
          <div className="exam-pdf-tools-cluster">
            <button
              type="button"
              className="exam-pdf-btn"
              onClick={() => scrollToPage(currentPage - 1)}
              disabled={currentPage <= 1 || loading}
              title="صفحه قبلی"
            >
              قبلی
            </button>
            <span className="exam-pdf-page-counter">
              صفحه <strong>{toPersianDigits(currentPage)}</strong> از{" "}
              <strong>{toPersianDigits(numPages || 1)}</strong>
            </span>
            <button
              type="button"
              className="exam-pdf-btn"
              onClick={() => scrollToPage(currentPage + 1)}
              disabled={currentPage >= numPages || loading}
              title="صفحه بعدی"
            >
              بعدی
            </button>
          </div>
        )}

        {/* Title indicator if provided */}
        {title && (
          <span className="exam-pdf-title-badge" title={title}>
            {title}
          </span>
        )}

        {/* Zoom Controls (Only in Canvas Mode) */}
        {viewMode === "canvas" && (
          <div className="exam-pdf-tools-cluster">
            <button
              type="button"
              className="exam-pdf-btn icon-only"
              onClick={handleZoomOut}
              disabled={scale <= 0.5 || loading}
              title="کوچک‌نمایی (−)"
            >
              −
            </button>
            <button
              type="button"
              className="exam-pdf-btn zoom-btn"
              onClick={handleFitWidth}
              disabled={loading}
              title="تنظیم عرض صفحه"
            >
              {toPersianDigits(Math.round(scale * 100))}٪
            </button>
            <button
              type="button"
              className="exam-pdf-btn icon-only"
              onClick={handleZoomIn}
              disabled={scale >= 2.5 || loading}
              title="بزرگ‌نمایی (+)"
            >
              +
            </button>
          </div>
        )}

        {/* Action Controls */}
        <div className="exam-pdf-tools-cluster">
          <button
            type="button"
            className="exam-pdf-btn icon-only"
            onClick={toggleFullscreen}
            title={isFullscreen ? "خروج از تمام‌صفحه" : "مشاهده تمام‌صفحه"}
          >
            {isFullscreen ? "✕ خروج" : "⛶ تمام‌صفحه"}
          </button>
          <a
            href={blobUrl || url}
            download={title ? `${title}.pdf` : "booklet.pdf"}
            target="_blank"
            rel="noopener noreferrer"
            className="exam-pdf-btn direct-link"
            title="دانلود یا باز کردن مستقیم فایل PDF"
          >
            دانلود PDF
          </a>
        </div>
      </div>

      {/* Main Content Area */}
      {loading && (
        <div className="exam-pdf-loading-overlay">
          <div className="exam-pdf-spinner" />
          <span>در حال بارگذاری دفترچه سؤالات...</span>
        </div>
      )}

      {error && (
        <div className="exam-pdf-error-overlay">
          <span className="exam-pdf-error-icon">⚠️</span>
          <p>{error}</p>
          <div className="exam-pdf-error-buttons">
            <button type="button" className="button" onClick={loadPdf}>
              تلاش مجدد
            </button>
            <a
              href={url}
              target="_blank"
              rel="noopener noreferrer"
              className="button secondary"
            >
              باز کردن مستقیم فایل PDF
            </a>
          </div>
        </div>
      )}

      {/* Native PDF is an optional fallback: some browsers have no inline PDF viewer. */}
      {!loading && !error && viewMode === "native" && blobUrl && (
        <div className="exam-pdf-native-wrapper">
          <iframe
            src={blobUrl}
            className="exam-pdf-native-iframe"
            title={title || "دفترچه سؤالات آزمون"}
          />
        </div>
      )}

      {/* Mode 2: Continuous Scroll Web Canvas Viewer */}
      {!loading && !error && viewMode === "canvas" && (
        <div ref={scrollRef} className="exam-pdf-scroll-viewport">
          <div ref={pagesContainerRef} className="exam-pdf-pages-stream" />
        </div>
      )}
    </div>
  );
}
