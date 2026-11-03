// Shared, browser-independent PDF canvas sizing. The uploaded booklet may be
// A4, landscape, or a custom page size; 595pt must never be assumed.
export function fitPdfScale(pageWidth: number, containerWidth: number) {
  if (!Number.isFinite(pageWidth) || pageWidth <= 0 || !Number.isFinite(containerWidth) || containerWidth <= 32) return 1;
  return Math.max(0.25, Math.min(2, (containerWidth - 32) / pageWidth));
}

export function boundedPdfPixelRatio(width: number, height: number, deviceRatio: number) {
  if (width <= 0 || height <= 0) return 1;
  return Math.max(0.1, Math.min(deviceRatio || 1, 2, Math.sqrt(3_000_000 / (width * height))));
}
