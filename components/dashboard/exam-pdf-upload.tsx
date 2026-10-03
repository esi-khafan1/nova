"use client";

import { upload } from "@imagekit/next";
import { useRef, useState } from "react";

export function ExamPdfUpload({
  purpose,
  value,
  onChange,
  label,
}: {
  purpose: "exam-question" | "exam-answer";
  value: string;
  onChange: (url: string) => void;
  label: string;
}) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState("");
  const [selectedFileName, setSelectedFileName] = useState("");

  async function handleFile(file?: File) {
    if (!file) return;
    setError("");
    if (file.type !== "application/pdf") {
      setError("فقط فایل PDF قابل بارگذاری است.");
      return;
    }
    if (file.size > 20 * 1024 * 1024) {
      setError("حجم PDF باید کمتر از ۲۰ مگابایت باشد.");
      return;
    }
    setUploading(true);
    try {
      const response = await fetch(`/api/imagekit-auth?purpose=${purpose}`, {
        cache: "no-store",
      });
      const auth = (await response.json()) as {
        token?: string;
        expire?: number;
        signature?: string;
        publicKey?: string;
        error?: string;
      };
      if (!response.ok || !auth.token || !auth.expire || !auth.signature || !auth.publicKey) {
        throw new Error(auth.error || "دسترسی آپلود آماده نیست.");
      }
      const result = await upload({
        file,
        fileName: file.name,
        folder: purpose === "exam-question" ? "/nova/exams/questions" : "/nova/exams/answers",
        tags: ["nova", purpose],
        useUniqueFileName: true,
        token: auth.token,
        expire: auth.expire,
        signature: auth.signature,
        publicKey: auth.publicKey,
      });
      if (!result.url) throw new Error("نشانی فایل دریافت نشد.");
      onChange(result.url);
    } catch (uploadError) {
      setError(uploadError instanceof Error ? uploadError.message : "بارگذاری انجام نشد.");
    } finally {
      setUploading(false);
      if (inputRef.current) inputRef.current.value = "";
    }
  }

  return (
    <div className="exam-upload">
      <label>
        {label}
        <span className="exam-file-picker">
          <input
            ref={inputRef}
            className="exam-file-input"
            type="file"
            accept="application/pdf,.pdf"
            onChange={(event) => {
              const file = event.target.files?.[0];
              setSelectedFileName(file?.name || "");
              handleFile(file);
            }}
            disabled={uploading}
          />
          <button type="button" onClick={() => inputRef.current?.click()} disabled={uploading}>
            {uploading ? "در حال بارگذاری…" : "انتخاب فایل"}
          </button>
          <span>{selectedFileName || "فایلی انتخاب نشده"}</span>
        </span>
      </label>
      {!uploading && value && <a href={value} target="_blank" rel="noreferrer">مشاهده فایل بارگذاری‌شده</a>}
      {error && <p className="exam-error">{error}</p>}
    </div>
  );
}
