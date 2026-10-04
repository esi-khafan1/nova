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
  getDocument: (options: {
    data: Uint8Array;
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
  const pageNodesRef = useRef<Map<number, HTMLDivElement>>(new Map());
  const blobUrlRef = useRef<string | null>(null);

  // Default to native view on desktop, canvas on Android
  const [viewMode, setViewMode] = useState<"native" | "canvas">(() => {
    if (typeof window === "undefined") return "native";
    const isAndroid = /Android/i.test(navigator.userAgent);
    return isAndroid ? "canvas" : "native";
  });

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
            resolve(null);
          }
        });
        existingScript.addEventListener("error", () =>
          reject(new Error("خطا در بارگذاری موتور نمایش PDF")),
        );
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

  // Render all pages for the current document & scale (Canvas mode)
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
      // Safely encode URI to handle Persian filenames in URL
      const safeUrl = encodeURI(decodeURI(url));

      // Fetch array buffer to prevent IDM interception and bypass CORS
      const res = await fetch(safeUrl);
      if (!res.ok) throw new Error(`عدم موفقیت در دریافت فایل (${res.status})`);
      const buffer = await res.arrayBuffer();

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
      if (lib) {
        try {
          const loadingTask = lib.getDocument({
            data: new Uint8Array(buffer),
            cMapUrl: "/pdfjs/cmaps/",
            cMapPacked: true,
            standardFontDataUrl: "/pdfjs/standard_fonts/",
          });
          const pdf = await loadingTask.promise;

          pdfDocRef.current = pdf;
          setNumPages(pdf.numPages);
          setCurrentPage(1);

          // Determine initial scale based on container width
          let initialScale = 1.0;
          if (scrollRef.current) {
            const containerWidth = scrollRef.current.clientWidth - 40;
            if (containerWidth > 0) {
              const autoFit = containerWidth / 595;
              initialScale = Math.max(0.6, Math.min(1.8, +autoFit.toFixed(2)));
            }
          }
          setScale(initialScale);

          await renderAllPages(pdf, initialScale);
        } catch (pdfErr) {
          console.warn("PDF.js parse warning:", pdfErr);
        }
      }

      setLoading(false);
    } catch (err: unknown) {
      console.error("PDF Load Error:", err);
      const message =
        err instanceof Error ? err.message : "خطا در بارگذاری دفترچه سؤالات.";
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
      if (blobUrlRef.current) {
        URL.revokeObjectURL(blobUrlRef.current);
        blobUrlRef.current = null;
      }
    };
  }, [loadPdf, cancelAllRenderTasks]);

  // Handle re-rendering when scale changes in canvas mode
  const isInitialMount = useRef(true);
  useEffect(() => {
    if (isInitialMount.current) {
      isInitialMount.current = false;
      return;
    }
    if (viewMode === "canvas" && pdfDocRef.current && !loading) {
      renderAllPages(pdfDocRef.current, scale);
    }
  }, [scale, loading, viewMode, renderAllPages]);

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

  const handleFitWidth = () => {
    if (scrollRef.current) {
      const containerWidth = scrollRef.current.clientWidth - 40;
      if (containerWidth > 0) {
        const autoFit = containerWidth / 595;
        setScale(Math.max(0.6, Math.min(2.2, +autoFit.toFixed(2))));
      }
    }
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
                if (pdfDocRef.current) {
                  renderAllPages(pdfDocRef.current, scale);
                }
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

      {/* Mode 1: Native Browser PDF Viewer (100% Quality, Zero Glitches, IDM Safe) */}
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
