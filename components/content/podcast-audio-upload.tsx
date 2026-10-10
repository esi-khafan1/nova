"use client";
import { useEffect, useRef, useState } from "react";
import { upload } from "@imagekit/next";
import { isSafePodcastAudioUrl, validateAudioFile } from "@/lib/podcast-media";
import "@/app/podcasts/podcasts.css";
function getDuration(file: File): Promise<number> {
  return new Promise((resolve, reject) => {
    const a = document.createElement("audio"),
      url = URL.createObjectURL(file);
    let finished = false;
    const cleanup = () => {
      URL.revokeObjectURL(url);
      a.removeAttribute("src");
      clearTimeout(timer);
    };
    const finish = (duration: number | null) => {
      if (finished) return;
      finished = true;
      cleanup();
      if (duration && Number.isFinite(duration) && duration <= 10800)
        resolve(Math.ceil(duration));
      else
        reject(new Error("ویس قابل پخش نیست یا مدت آن بیشتر از سه ساعت است."));
    };
    const timer = setTimeout(() => finish(null), 12000);
    a.preload = "metadata";
    a.onloadedmetadata = () => finish(a.duration);
    a.onerror = () => finish(null);
    a.src = url;
  });
}
export function PodcastAudioUpload({
  initialUrl,
  initialSeconds,
  onBusyChange,
  disabled = false,
}: {
  initialUrl: string;
  initialSeconds: number | null;
  onBusyChange: (busy: boolean) => void;
  disabled?: boolean;
}) {
  const [url, setUrl] = useState(initialUrl),
    [seconds, setSeconds] = useState<number | null>(initialSeconds),
    [error, setError] = useState(""),
    [busy, setBusy] = useState(false),
    [progress, setProgress] = useState(0);
  const controller = useRef<AbortController | null>(null),
    input = useRef<HTMLInputElement>(null);
  useEffect(
    () => () => {
      controller.current?.abort();
    },
    [],
  );
  async function uploadAudio(file: File) {
    setError("");
    const problem = validateAudioFile(file);
    if (problem) {
      setError(problem);
      if (input.current) input.current.value = "";
      return;
    }
    setBusy(true);
    onBusyChange(true);
    setProgress(0);
    const ctrl = new AbortController();
    controller.current = ctrl;
    try {
      const duration = await getDuration(file);
      if (ctrl.signal.aborted) throw new Error("بارگذاری لغو شد.");
      const response = await fetch("/api/imagekit-auth?purpose=podcast-audio", {
        cache: "no-store",
        signal: ctrl.signal,
      });
      const auth = await response.json();
      if (!response.ok)
        throw new Error(auth.error ?? "دسترسی آپلود آماده نیست.");
      const result = await upload({
        file,
        fileName: file.name,
        folder: "/nova/podcasts/audio",
        tags: ["nova", "podcast-audio"],
        useUniqueFileName: true,
        token: auth.token,
        expire: auth.expire,
        signature: auth.signature,
        publicKey: auth.publicKey,
        abortSignal: ctrl.signal,
        onProgress: (e) => {
          if (e.lengthComputable)
            setProgress(Math.round((e.loaded / e.total) * 100));
        },
      });
      if (!result.url || !isSafePodcastAudioUrl(result.url))
        throw new Error("نشانی معتبر ویس دریافت نشد.");
      setUrl(result.url);
      setSeconds(duration);
    } catch (e) {
      setError(
        ctrl.signal.aborted
          ? "بارگذاری لغو شد؛ ویس قبلی تغییر نکرد."
          : e instanceof Error
            ? e.message
            : "بارگذاری ویس انجام نشد.",
      );
    } finally {
      setBusy(false);
      onBusyChange(false);
      controller.current = null;
      if (input.current) input.current.value = "";
    }
  }
  return (
    <section
      className="portal-card podcast-upload"
      aria-labelledby="podcast-upload-title"
    >
      <h2 id="podcast-upload-title">ویس پادکست</h2>
      <p>
        فایل صوتی خودت را بارگذاری کن. انتشار پادکست به ویس نیاز دارد؛ پیش‌نویس
        را می‌توانی بدون ویس ذخیره کنی.
      </p>
      <input type="hidden" name="audioUrl" value={url} />
      <input type="hidden" name="audioSeconds" value={seconds ?? ""} />
      <label htmlFor="podcast-audio-file">انتخاب فایل صوتی</label>
      <input
        ref={input}
        id="podcast-audio-file"
        type="file"
        accept="audio/mpeg,audio/mp4,audio/wav,audio/x-wav,audio/ogg,application/ogg,audio/x-ogg,audio/opus,audio/webm,.mp3,.m4a,.wav,.ogg,.webm"
        disabled={busy || disabled}
        onChange={(e) => {
          const file = e.target.files?.[0];
          if (file) void uploadAudio(file);
        }}
      />
      <small>
        MP3، M4A، WAV، OGG یا WebM؛ حداکثر ۴۰ مگابایت و سه ساعت. فقط صدایی را
        بارگذاری کن که اجازه انتشار آن را داری.
      </small>
      {busy && (
        <div role="status">
          <p>در حال بارگذاری ویس… {progress.toLocaleString("fa-IR")}٪</p>
          <progress
            value={progress}
            max={100}
            aria-label="پیشرفت بارگذاری ویس"
          />
          <button
            type="button"
            className="button button-secondary button-small"
            onClick={() => controller.current?.abort()}
          >
            لغو بارگذاری
          </button>
        </div>
      )}
      {url && (
        <>
          <audio
            key={url}
            controls
            preload="none"
            src={url}
            aria-label="پیش‌نمایش ویس پادکست"
          />
          <button
            className="button button-secondary button-small"
            disabled={busy || disabled}
            type="button"
            onClick={() => {
              setUrl("");
              setSeconds(null);
            }}
          >
            حذف ویس از این پادکست
          </button>
        </>
      )}
      {error && (
        <p className="content-error" role="alert">
          {error}
        </p>
      )}
    </section>
  );
}
