import planning from "@/lib/podcast-samples/planning.json";
import focus from "@/lib/podcast-samples/focus.json";
import review from "@/lib/podcast-samples/review.json";
const samples: Record<string, { base64: string; seconds: number }> = {
  planning,
  focus,
  review,
};
function response(request: Request, slug: string, head = false) {
  const sample = Object.hasOwn(samples, slug) ? samples[slug] : null;
  if (!sample) return new Response(null, { status: 404 });
  const bytes = Uint8Array.from(atob(sample.base64), (c) => c.charCodeAt(0)),
    length = bytes.length;
  const headers: Record<string, string> = {
    "Content-Type": "audio/mpeg",
    "Accept-Ranges": "bytes",
    "Cache-Control": "public, max-age=86400",
    "X-Content-Type-Options": "nosniff",
  };
  let from = 0,
    to = length - 1,
    status = 200;
  const range = request.headers.get("range");
  if (range) {
    const match = range.match(/^bytes=(\d*)-(\d*)$/);
    if (!match || (!match[1] && !match[2]))
      return new Response(null, {
        status: 416,
        headers: { ...headers, "Content-Range": `bytes */${length}` },
      });
    if (!match[1]) from = Math.max(0, length - Number(match[2]));
    else {
      from = Number(match[1]);
      if (match[2]) to = Math.min(to, Number(match[2]));
    }
    if (
      !Number.isSafeInteger(from) ||
      !Number.isSafeInteger(to) ||
      from < 0 ||
      from > to ||
      from >= length
    )
      return new Response(null, {
        status: 416,
        headers: { ...headers, "Content-Range": `bytes */${length}` },
      });
    status = 206;
    headers["Content-Range"] = `bytes ${from}-${to}/${length}`;
  }
  headers["Content-Length"] = String(to - from + 1);
  return new Response(head ? null : bytes.slice(from, to + 1), {
    status,
    headers,
  });
}
type Context = { params: Promise<{ slug: string }> };
export async function GET(request: Request, { params }: Context) {
  return response(request, (await params).slug);
}
export async function HEAD(request: Request, { params }: Context) {
  return response(request, (await params).slug, true);
}
