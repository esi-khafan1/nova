import type { ContentMark, ContentNode } from "./content";
import { Fragment, type Schema } from "@tiptap/pm/model";
import type { MarkdownManager } from "@tiptap/markdown";
import type { Selection } from "@tiptap/pm/state";

function isSafeContentUrl(value: string | undefined) {
  if (!value) return false;
  try {
    const url = new URL(value);
    return (
      ["http:", "https:"].includes(url.protocol) &&
      Boolean(url.hostname) &&
      !url.username &&
      !url.password
    );
  } catch {
    return false;
  }
}

function normalizeInlineNode(node: ContentNode): ContentNode | null {
  if (node.type === "image") {
    const src = typeof node.attrs?.src === "string" ? node.attrs.src : "";
    if (!isSafeContentUrl(src)) {
      const alt = typeof node.attrs?.alt === "string" ? node.attrs.alt : "";
      return alt ? { type: "text", text: alt } : null;
    }
    return node;
  }

  if (node.type === "text") {
    const marks = (node.marks ?? []).filter((mark: ContentMark) => {
      if (mark.type !== "link") return true;
      return (
        typeof mark.attrs?.href === "string" &&
        isSafeContentUrl(mark.attrs.href)
      );
    });
    return { ...node, ...(marks.length ? { marks } : { marks: undefined }) };
  }

  return node;
}

/**
 * Markdown supports six heading levels, while the existing visual composer
 * intentionally uses only h2 and h3. Keep the same hierarchy for new Markdown
 * and normalize block images/URLs to the nodes accepted by every content type.
 */
export function normalizeMarkdownDocument(document: ContentNode): ContentNode {
  function normalizeBlock(node: ContentNode): ContentNode[] {
    if (node.type === "image") {
      const image = normalizeInlineNode(node);
      if (image?.type === "image") return [image];
      return image ? [{ type: "paragraph", content: [image] }] : [];
    }

    if (node.type === "paragraph") {
      const children = node.content ?? [];
      if (!children.some((child) => child.type === "image")) {
        return [
          {
            ...node,
            content: children
              .map(normalizeInlineNode)
              .filter((child): child is ContentNode => Boolean(child)),
          },
        ];
      }

      const blocks: ContentNode[] = [];
      let inlineContent: ContentNode[] = [];
      const flushParagraph = () => {
        if (inlineContent.length) {
          blocks.push({ ...node, content: inlineContent });
          inlineContent = [];
        }
      };

      for (const child of children) {
        if (child.type !== "image") {
          const normalized = normalizeInlineNode(child);
          if (normalized) inlineContent.push(normalized);
          continue;
        }

        const image = normalizeInlineNode(child);
        if (image?.type === "image") {
          flushParagraph();
          blocks.push(image);
        } else if (image) {
          inlineContent.push(image);
        }
      }
      flushParagraph();
      return blocks;
    }

    if (node.type === "heading") {
      const level = Number(node.attrs?.level);
      const content = (node.content ?? [])
        .map(normalizeInlineNode)
        .filter((child): child is ContentNode => Boolean(child))
        .map((child) =>
          child.type === "image"
            ? {
                type: "text",
                text:
                  typeof child.attrs?.alt === "string" ? child.attrs.alt : "",
              }
            : child,
        );
      return [
        {
          ...node,
          attrs: { ...node.attrs, level: level <= 2 ? 2 : 3 },
          content,
        },
      ];
    }

    if (node.type === "text") {
      const inline = normalizeInlineNode(node);
      return inline ? [inline] : [];
    }

    return [
      {
        ...node,
        ...(node.content
          ? { content: node.content.flatMap(normalizeBlock) }
          : {}),
      },
    ];
  }

  return {
    ...document,
    content: (document.content ?? []).flatMap(normalizeBlock),
  };
}

/** Serialize the selected ProseMirror slice, not the whole document, as Markdown. */
export function serializeSelectionAsMarkdown(
  selection: Selection,
  schema: Schema,
  markdown: MarkdownManager,
) {
  if (selection.empty) return "";

  const slice = selection.content();
  if (!slice.content.size) return "";

  let selectedContent = slice.content;
  if (selectedContent.firstChild?.isInline) {
    selectedContent = Fragment.from(
      schema.nodes.paragraph.create(null, selectedContent),
    );
  }

  const selectedDocument = schema.topNodeType.createAndFill(
    null,
    selectedContent,
  );
  return selectedDocument ? markdown.serialize(selectedDocument.toJSON()) : "";
}
