"use client";
import { useRef, useState } from "react";
export function PodcastPlayer({ url, title }: { url: string; title: string }) {
  const [failed, setFailed] = useState(false);
  const audio = useRef<HTMLAudioElement>(null);
  return (
    <section className="podcast-player" aria-label={`پخش ${title}`}>
      <span className="podcast-player-label">گوش کن؛ با سرعت خودت</span>
      <audio
        ref={audio}
        controls
        preload="none"
        src={url}
        aria-label={`ویس ${title}`}
        onError={() => setFailed(true)}
        onCanPlay={() => setFailed(false)}
      >
        مرورگر شما پخش صدا را پشتیبانی نمی‌کند.
      </audio>
      {failed && (
        <div role="alert">
          <p>
            پخش ویس انجام نشد. اتصال اینترنت را بررسی کن یا فایل را مستقیم باز
            کن.
          </p>
          <button
            type="button"
            className="button button-small"
            onClick={() => {
              setFailed(false);
              audio.current?.load();
            }}
          >
            تلاش دوباره
          </button>
        </div>
      )}
      <a href={url} target="_blank" rel="noopener noreferrer">
        باز کردن فایل صوتی ←
      </a>
    </section>
  );
}
