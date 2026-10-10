export const sampleAudioSlugs = ["planning", "focus", "review"] as const;
export const MAX_PODCAST_AUDIO_BYTES = 40 * 1024 * 1024;
const audioTypes: Record<string, string[]> = {
  mp3: ["audio/mpeg", "audio/mp3"],
  m4a: ["audio/mp4", "audio/x-m4a"],
  wav: ["audio/wav", "audio/x-wav", "audio/wave"],
  ogg: ["audio/ogg", "application/ogg", "audio/x-ogg", "audio/opus"],
  webm: ["audio/webm"],
};
export function validateAudioFile(file: {
  name: string;
  type: string;
  size: number;
}) {
  const extension = file.name.split(".").pop()?.toLowerCase() ?? "";
  // Browser/OS MIME labels differ for Ogg/Opus voice notes. Parameters are
  // not part of the base media type. Native decoding still validates the file
  // before upload, including when the OS reports a generic binary MIME.
  const mime = file.type.split(";", 1)[0].trim().toLowerCase();
  const generic = !mime || mime === "application/octet-stream";
  if (
    !audioTypes[extension] ||
    (!generic && !audioTypes[extension].includes(mime))
  )
    return "فایل صوتی MP3، M4A، WAV، OGG یا WebM انتخاب کن.";
  if (file.size <= 0 || file.size > MAX_PODCAST_AUDIO_BYTES)
    return "حجم ویس باید بیشتر از صفر و حداکثر ۴۰ مگابایت باشد.";
  return null;
}
export function isSafePodcastAudioUrl(value: string) {
  if (sampleAudioSlugs.some((slug) => value === `/podcasts/audio/${slug}`))
    return true;
  try {
    const url = new URL(value);
    const base = new URL(process.env.NEXT_PUBLIC_IMAGEKIT_URL_ENDPOINT ?? "");
    const prefix = base.pathname.replace(/\/$/, "") + "/nova/podcasts/";
    return (
      url.protocol === "https:" &&
      url.origin === base.origin &&
      !url.username &&
      !url.password &&
      url.pathname.startsWith(prefix) &&
      !url.hash &&
      !url.search &&
      value.length <= 2048
    );
  } catch {
    return false;
  }
}
export function formatAudioDuration(seconds: number | null) {
  if (!seconds || !Number.isFinite(seconds)) return "پادکست صوتی";
  const minutes = Math.floor(seconds / 60).toLocaleString("fa-IR");
  const remainder = (seconds % 60).toLocaleString("fa-IR", {
    minimumIntegerDigits: 2,
  });
  return `${minutes}:${remainder}`;
}
