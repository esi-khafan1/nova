export type ContentStatus = "draft" | "published" | "archived";
export type ResourceType = "konkur" | "final_exam";

export type ContentMark = {
  type: string;
  attrs?: Record<string, unknown>;
};

export type ContentNode = {
  type?: string;
  text?: string;
  attrs?: Record<string, unknown>;
  marks?: ContentMark[];
  content?: ContentNode[];
};

export const emptyContent: ContentNode = {
  type: "doc",
  content: [{ type: "paragraph" }],
};

export const resourceTypeLabels: Record<ResourceType, string> = {
  konkur: "کنکور",
  final_exam: "امتحان نهایی",
};

export const contentStatusLabels: Record<ContentStatus, string> = {
  draft: "پیش‌نویس",
  published: "منتشرشده",
  archived: "بایگانی‌شده",
};

export function parseContent(value: string | null | undefined): ContentNode {
  if (!value) return emptyContent;
  try {
    const parsed = JSON.parse(value) as ContentNode;
    return parsed?.type === "doc" ? parsed : emptyContent;
  } catch {
    return {
      type: "doc",
      content: [
        { type: "paragraph", content: [{ type: "text", text: value }] },
      ],
    };
  }
}

export function extractContentText(node: ContentNode): string {
  const ownText = node.text ?? "";
  const childText = (node.content ?? []).map(extractContentText).join(" ");
  return `${ownText} ${childText}`.replace(/\s+/g, " ").trim();
}

export function findFirstImage(node: ContentNode): string | null {
  if (node.type === "image" && typeof node.attrs?.src === "string") {
    return node.attrs.src;
  }
  for (const child of node.content ?? []) {
    const match = findFirstImage(child);
    if (match) return match;
  }
  return null;
}

export function formatPersianDate(value: string | null | undefined) {
  if (!value) return "";
  return new Intl.DateTimeFormat("fa-IR", {
    year: "numeric",
    month: "long",
    day: "numeric",
  }).format(new Date(value));
}
