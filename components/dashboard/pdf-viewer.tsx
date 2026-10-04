"use client";

import { useEffect, useRef, useState, useCallback } from "react";
import { toPersianDigits } from "@/lib/persian-date";

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
  getDocument: (options: { data: Uint8Array }) => {
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
  const pageNodesRef = useRef<Map<number, HTMLDivElement>>(new Map());

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [numPages, setNumPages] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [scale, setScale] = useState(1.0);
  const [isFullscreen, setIsFullscreen] = useState(false);

  // Ensure PDF.js script is loaded
  const ensurePdfJsLoaded = useCallback(async (): Promise<PdfJsLib | null> => {
    if (typeof window === "undefined") return null;
    const win = window as unknown as WindowWithPdfJs;
    if (win.pdfjsLib) return win.pdfjsLib;

    return new Promise((resolve, reject) => {
      const existingScript = document.getElementById("pdfjs-lib-script");
      if (existingScript) {
        if (win.pdfjsLib) {
          const workerSrc = "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js";
          try {
            const blob = new Blob([`importScripts("${workerSrc}");`], { type: "application/javascript" });
            win.pdfjsLib.GlobalWorkerOptions.workerSrc = URL.createObjectURL(blob);
          } catch {
            win.pdfjsLib.GlobalWorkerOptions.workerSrc = workerSrc;
          }
          resolve(win.pdfjsLib);
          return;
        }
        existingScript.addEventListener("load", () => resolve(win.pdfjsLib ?? null));
        existingScript.addEventListener("error", () => reject(new Error("خطا در بارگذاری موتور نمایش PDF")));
        return;
      }

      const script = document.createElement("script");
      script.id = "pdfjs-lib-script";
      script.src = "/pdfjs/pdf.min.js";
      script.async = true;
      script.onload = () => {
        if (win.pdfjsLib) {
          const workerSrc = "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js";
          try {
            const blob = new Blob([`importScripts("${workerSrc}");`], { type: "application/javascript" });
            win.pdfjsLib.GlobalWorkerOptions.workerSrc = URL.createObjectURL(blob);
          } catch {
            win.pdfjsLib.GlobalWorkerOptions.workerSrc = workerSrc;
          }
          resolve(win.pdfjsLib);
        } else {
          reject(new Error("موتور PDF در دسترس نیست"));
        }
      };
      script.onerror = () => reject(new Error("عدم امکان بارگذاری کتابخانه PDF"));
      document.head.appendChild(script);
    });
  }, []);

  // Cancel all ongoing render tasks
  const cancelAllRenderTasks = useCallback(() => {
    renderTasksRef.current.forEach((task) => {
      try {
        task.cancel();
      } catch {}
    });
    renderTasksRef.current.clear();
  }, []);

  // Render all pages for the current document & scale
  const renderAllPages = useCallback(
    async (pdf: PdfDocument, currentScale: number) => {
      cancelAllRenderTasks();
      const container = pagesContainerRef.current;
      if (!container) return;

      container.innerHTML = "";
      pageNodesRef.current.clear();

      const dpr = typeof window !== "undefined" ? window.devicePixelRatio || 1 : 1;

      for (let pageNum = 1; pageNum <= pdf.numPages; pageNum++) {
        // Page wrapper
        const pageWrapper = document.createElement("div");
        pageWrapper.id = `pdf-page-${pageNum}`;
        pageWrapper.className = "exam-pdf-page-wrapper";
        pageWrapper.setAttribute("data-page-num", String(pageNum));

        // Page header badge (e.g. صفحه ۱)
        const pageBadge = document.createElement("div");
        pageBadge.className = "exam-pdf-page-badge";
        pageBadge.textContent = `صفحه ${toPersianDigits(pageNum)}`;
        pageWrapper.appendChild(pageBadge);

        // Canvas for page
        const canvas = document.createElement("canvas");
        canvas.className = "exam-pdf-page-canvas";
        pageWrapper.appendChild(canvas);

        container.appendChild(pageWrapper);
        pageNodesRef.current.set(pageNum, pageWrapper);

        try {
          const page = await pdf.getPage(pageNum);
          const viewport = page.getViewport({ scale: currentScale });

          canvas.width = Math.floor(viewport.width * dpr);
          canvas.height = Math.floor(viewport.height * dpr);
          canvas.style.width = `${Math.floor(viewport.width)}px`;
          canvas.style.height = `${Math.floor(viewport.height)}px`;

          const ctx = canvas.getContext("2d");
          if (!ctx) continue;

          const renderContext = {
            canvasContext: ctx,
            viewport,
            transform: dpr !== 1 ? [dpr, 0, 0, dpr, 0, 0] : undefined,
          };

          const renderTask = page.render(renderContext);
          renderTasksRef.current.set(pageNum, renderTask);

          await renderTask.promise.catch((err: unknown) => {
            const errorObj = err as { name?: string };
            if (errorObj?.name !== "RenderingCancelledException") {
              console.error("PDF page render error:", err);
            }
          });
        } catch (err: unknown) {
          const errorObj = err as { name?: string };
          if (errorObj?.name !== "RenderingCancelledException") {
            console.error(`Error loading page ${pageNum}:`, err);
          }
        }
      }
    },
    [cancelAllRenderTasks],
  );

  // Load PDF Document when URL changes
  const loadPdf = useCallback(async () => {
    if (!url) {
      setLoading(false);
      setError("آدرس فایل سؤالات موجود نیست.");
      return;
    }

    setLoading(true);
    setError(null);
    cancelAllRenderTasks();

    try {
      const lib = await ensurePdfJsLoaded();
      if (!lib) throw new Error("کتابخانه PDF بارگذاری نشد.");

      // Safely encode URI to handle Persian filenames in URL
      const safeUrl = encodeURI(decodeURI(url));

      // Fetch array buffer to prevent any cross-origin worker restriction
      const res = await fetch(safeUrl);
      if (!res.ok) throw new Error(`عدم موفقیت در دریافت فایل (${res.status})`);
      const buffer = await res.arrayBuffer();

      const loadingTask = lib.getDocument({ data: new Uint8Array(buffer) });
      const pdf = await loadingTask.promise;

      pdfDocRef.current = pdf;
      setNumPages(pdf.numPages);
      setCurrentPage(1);

      // Determine initial scale based on container width
      let initialScale = 1.0;
      if (scrollRef.current) {
        const containerWidth = scrollRef.current.clientWidth - 40;
        if (containerWidth > 0) {
          // Standard A4 width is ~595pt
          const autoFit = containerWidth / 595;
          initialScale = Math.max(0.6, Math.min(1.8, +(autoFit).toFixed(2)));
        }
      }
      setScale(initialScale);

      await renderAllPages(pdf, initialScale);
      setLoading(false);
    } catch (err: unknown) {
      console.error("PDF Load Error:", err);
      const message = err instanceof Error ? err.message : "خطا در بارگذاری دفترچه سؤالات.";
      setError(message);
      setLoading(false);
    }
  }, [url, ensurePdfJsLoaded, cancelAllRenderTasks, renderAllPages]);

  useEffect(() => {
    loadPdf();
    return () => {
      cancelAllRenderTasks();
      if (pdfDocRef.current) {
        try {
          pdfDocRef.current.destroy();
        } catch {}
      }
    };
  }, [loadPdf, cancelAllRenderTasks]);

  // Handle re-rendering when scale changes (after initial load)
  const isInitialMount = useRef(true);
  useEffect(() => {
    if (isInitialMount.current) {
      isInitialMount.current = false;
      return;
    }
    if (pdfDocRef.current && !loading) {
      renderAllPages(pdfDocRef.current, scale);
    }
  }, [scale, loading, renderAllPages]);

  // Track active page while scrolling
  useEffect(() => {
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
  }, []);

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

  const handleFitWidth = () => {
    if (scrollRef.current) {
      const containerWidth = scrollRef.current.clientWidth - 40;
      if (containerWidth > 0) {
        const autoFit = containerWidth / 595;
        setScale(Math.max(0.6, Math.min(2.2, +(autoFit).toFixed(2))));
      }
    }
  };

  // Fullscreen toggle
  const toggleFullscreen = () => {
    if (!containerRef.current) return;

    if (!document.fullscreenElement) {
      containerRef.current.requestFullscreen().then(() => setIsFullscreen(true)).catch(() => {});
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
        {/* Page Nav */}
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

        {/* Title indicator if provided */}
        {title && (
          <span className="exam-pdf-title-badge" title={title}>
            {title}
          </span>
        )}

        {/* Zoom Controls */}
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
            href={url}
            target="_blank"
            rel="noopener noreferrer"
            className="exam-pdf-btn direct-link"
            title="باز کردن مستقیم PDF در تب جدید"
          >
            دانلود PDF
          </a>
        </div>
      </div>

      {/* Scrollable Document Area */}
      <div ref={scrollRef} className="exam-pdf-scroll-viewport">
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

        <div
          ref={pagesContainerRef}
          className={`exam-pdf-pages-stream ${loading ? "is-hidden" : ""}`}
        />
      </div>
    </div>
  );
}
