"use client";

import { useActionState, useRef, useState } from "react";
import { upload } from "@imagekit/next";
import { useEditor, EditorContent } from "@tiptap/react";
import StarterKit from "@tiptap/starter-kit";
import Link from "@tiptap/extension-link";
import Image from "@tiptap/extension-image";
import {
  saveResourceAction,
  type ContentActionState,
} from "@/app/dashboard/counselor/content/actions";
import { emptyContent, parseContent } from "@/lib/content";

type EditableResource = {
  id: string;
  title: string;
  summary: string | null;
  body: string;
  resource_type: "konkur" | "final_exam";
  grade: number | null;
  subject: string | null;
  status: "draft" | "published" | "archived";
};

const initialState: ContentActionState = {};

function ToolButton({
  active,
  children,
  onClick,
}: {
  active?: boolean;
  children: React.ReactNode;
  onClick: () => void;
}) {
  return (
    <button className={active ? "active" : ""} onClick={onClick} type="button">
      {children}
    </button>
  );
}

export function ContentEditorForm({
  resource,
}: {
  resource?: EditableResource;
}) {
  const [state, formAction, pending] = useActionState(
    saveResourceAction,
    initialState,
  );
  const [body, setBody] = useState(
    JSON.stringify(resource ? parseContent(resource.body) : emptyContent),
  );
  const [uploading, setUploading] = useState(false);
  const [uploadError, setUploadError] = useState("");
  const fileRef = useRef<HTMLInputElement>(null);

  const editor = useEditor({
    immediatelyRender: false,
    extensions: [
      StarterKit.configure({ heading: { levels: [2, 3] } }),
      Link.configure({ openOnClick: false, autolink: true }),
      Image.configure({ allowBase64: false }),
    ],
    content: resource ? parseContent(resource.body) : emptyContent,
    editorProps: {
      attributes: {
        class: "content-editor-area",
        "aria-label": "متن محتوا",
      },
    },
    onUpdate: ({ editor: currentEditor }) => {
      setBody(JSON.stringify(currentEditor.getJSON()));
    },
  });

  function setLink() {
    if (!editor) return;
    const previous = editor.getAttributes("link").href as string | undefined;
    const href = window.prompt("نشانی لینک را وارد کن", previous ?? "https://");
    if (href === null) return;
    if (!href.trim()) {
      editor.chain().focus().extendMarkRange("link").unsetLink().run();
      return;
    }
    editor
      .chain()
      .focus()
      .extendMarkRange("link")
      .setLink({ href: href.trim() })
      .run();
  }

  async function uploadImage(file: File) {
    if (!editor) return;
    setUploadError("");
    if (!file.type.startsWith("image/")) {
      setUploadError("فقط فایل تصویری قابل بارگذاری است.");
      return;
    }
    if (file.size > 8 * 1024 * 1024) {
      setUploadError("حجم تصویر باید کمتر از ۸ مگابایت باشد.");
      return;
    }

    setUploading(true);
    try {
      const authResponse = await fetch("/api/imagekit-auth", {
        cache: "no-store",
      });
      if (!authResponse.ok) {
        const data = (await authResponse.json()) as { error?: string };
        throw new Error(data.error ?? "دسترسی آپلود آماده نیست.");
      }
      const auth = (await authResponse.json()) as {
        token: string;
        expire: number;
        signature: string;
        publicKey: string;
      };
      const result = await upload({
        file,
        fileName: file.name,
        folder: "/nova/resources",
        tags: ["nova", "counselor-content"],
        useUniqueFileName: true,
        token: auth.token,
        expire: auth.expire,
        signature: auth.signature,
        publicKey: auth.publicKey,
      });
      if (!result.url) throw new Error("نشانی تصویر دریافت نشد.");
      editor
        .chain()
        .focus()
        .setImage({ src: result.url, alt: file.name })
        .run();
    } catch (error) {
      setUploadError(
        error instanceof Error ? error.message : "بارگذاری تصویر انجام نشد.",
      );
    } finally {
      setUploading(false);
      if (fileRef.current) fileRef.current.value = "";
    }
  }

  return (
    <form action={formAction} className="content-editor-form">
      {resource && <input name="id" type="hidden" value={resource.id} />}
      <input name="body" type="hidden" value={body} />

      <section className="portal-card content-editor-meta">
        <div className="portal-card-title">
          <div>
            <span>مشخصات محتوا</span>
            <h2>{resource ? "ویرایش محتوا" : "محتوای تازه"}</h2>
          </div>
          {resource && (
            <span className={`content-status ${resource.status}`}>
              {resource.status === "published"
                ? "منتشرشده"
                : resource.status === "archived"
                  ? "بایگانی‌شده"
                  : "پیش‌نویس"}
            </span>
          )}
        </div>

        <div className="content-meta-grid">
          <label className="content-field content-field-wide">
            <span>عنوان</span>
            <input
              defaultValue={resource?.title ?? ""}
              maxLength={160}
              minLength={3}
              name="title"
              placeholder="مثلاً چطور آزمون آزمایشی را تحلیل کنیم؟"
              required
            />
          </label>
          <label className="content-field content-field-wide">
            <span>خلاصه</span>
            <textarea
              defaultValue={resource?.summary ?? ""}
              maxLength={400}
              name="summary"
              placeholder="در دو جمله بگو این محتوا چه کمکی به دانش‌آموز می‌کند."
              rows={3}
            />
          </label>
          <label className="content-field">
            <span>دسته‌بندی</span>
            <select
              defaultValue={resource?.resource_type ?? "konkur"}
              name="resourceType"
            >
              <option value="konkur">کنکور</option>
              <option value="final_exam">امتحان نهایی</option>
            </select>
          </label>
          <label className="content-field">
            <span>پایه</span>
            <select
              defaultValue={resource?.grade?.toString() ?? ""}
              name="grade"
            >
              <option value="">همه پایه‌ها</option>
              <option value="10">دهم</option>
              <option value="11">یازدهم</option>
              <option value="12">دوازدهم</option>
            </select>
          </label>
          <label className="content-field">
            <span>درس یا موضوع</span>
            <input
              defaultValue={resource?.subject ?? ""}
              maxLength={100}
              name="subject"
              placeholder="مثلاً ریاضی، برنامه‌ریزی یا مدیریت زمان"
            />
          </label>
        </div>
      </section>

      <section className="portal-card content-composer">
        <div className="content-toolbar" aria-label="ابزارهای ویرایش متن">
          <ToolButton
            active={editor?.isActive("bold")}
            onClick={() => editor?.chain().focus().toggleBold().run()}
          >
            ضخیم
          </ToolButton>
          <ToolButton
            active={editor?.isActive("heading", { level: 2 })}
            onClick={() =>
              editor?.chain().focus().toggleHeading({ level: 2 }).run()
            }
          >
            تیتر
          </ToolButton>
          <ToolButton
            active={editor?.isActive("heading", { level: 3 })}
            onClick={() =>
              editor?.chain().focus().toggleHeading({ level: 3 }).run()
            }
          >
            زیرتیتر
          </ToolButton>
          <ToolButton
            active={editor?.isActive("bulletList")}
            onClick={() => editor?.chain().focus().toggleBulletList().run()}
          >
            فهرست
          </ToolButton>
          <ToolButton active={editor?.isActive("link")} onClick={setLink}>
            لینک
          </ToolButton>
          <button
            disabled={uploading}
            onClick={() => fileRef.current?.click()}
            type="button"
          >
            {uploading ? "در حال آپلود..." : "افزودن تصویر"}
          </button>
          <input
            accept="image/*"
            className="content-file-input"
            onChange={(event) => {
              const file = event.target.files?.[0];
              if (file) void uploadImage(file);
            }}
            ref={fileRef}
            type="file"
          />
        </div>
        <EditorContent editor={editor} />
        {uploadError && <p className="content-error">{uploadError}</p>}
      </section>

      {(state.error || uploadError) && (
        <div className="portal-alert error">{state.error || uploadError}</div>
      )}

      <div className="content-editor-actions">
        <button
          className="button button-secondary"
          disabled={pending || uploading}
          name="intent"
          type="submit"
          value="draft"
        >
          ذخیره پیش‌نویس
        </button>
        <button
          className="button"
          disabled={pending || uploading}
          name="intent"
          type="submit"
          value="publish"
        >
          {pending ? "در حال ذخیره..." : "انتشار محتوا"}
        </button>
      </div>
    </form>
  );
}
