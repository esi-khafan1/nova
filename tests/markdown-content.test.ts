import { test } from "node:test";
import assert from "node:assert/strict";
import StarterKit from "@tiptap/starter-kit";
import Link from "@tiptap/extension-link";
import Image from "@tiptap/extension-image";
import { getSchema, type JSONContent } from "@tiptap/core";
import { TextSelection } from "@tiptap/pm/state";
import { Markdown, MarkdownManager } from "@tiptap/markdown";
import type { ContentNode } from "../lib/content";
import {
  normalizeMarkdownDocument,
  serializeSelectionAsMarkdown,
} from "../lib/markdown";

const extensions = [
  StarterKit.configure({ heading: { levels: [2, 3] }, link: false }),
  Link.configure({ openOnClick: false, autolink: true }),
  Image.configure({ allowBase64: false }),
  Markdown,
];
const markdownManager = new MarkdownManager({ extensions });

test("Markdown headings and formatting round-trip to the visual editor schema", () => {
  const parsed = normalizeMarkdownDocument(
    markdownManager.parse(
      "# Main\n\n### Subheading\n\n**bold**, *italic*, ~~strike~~ and `code`.\n\n- first\n- [second](https://example.com)\n\n> quoted text\n\n```ts\nconst answer = 42;\n```\n\n---",
    ) as ContentNode,
  );

  assert.deepEqual(
    parsed.content
      ?.filter((node) => node.type === "heading")
      .map((node) => node.attrs?.level),
    [2, 3],
  );
  const markdown = markdownManager.serialize(parsed as JSONContent);
  assert.match(markdown, /## Main/);
  assert.match(markdown, /### Subheading/);
  assert.match(markdown, /\*\*bold\*\*/);
  assert.match(markdown, /\*italic\*/);
  assert.match(markdown, /~~strike~~/);
  assert.match(markdown, /`code`/);
  assert.match(markdown, /- first/);
  assert.match(markdown, /\[second\]\(https:\/\/example\.com\)/);
  assert.match(markdown, /> quoted text/);
  assert.match(markdown, /```ts[\s\S]*const answer = 42;[\s\S]*```/);
  assert.match(markdown, /---/);
});

test("copying a selected rich-text range uses Markdown instead of HTML", () => {
  const schema = getSchema(extensions);
  const document = schema.nodeFromJSON({
    type: "doc",
    content: [
      {
        type: "paragraph",
        content: [
          { type: "text", text: "copy " },
          { type: "text", text: "bold", marks: [{ type: "bold" }] },
          { type: "text", text: " text" },
        ],
      },
    ],
  });
  const selection = TextSelection.create(document, 6, 10);

  assert.equal(
    serializeSelectionAsMarkdown(selection, schema, markdownManager),
    "**bold**",
  );
});

test("block images are lifted out of paragraphs and unsafe URLs are removed", () => {
  const parsed = normalizeMarkdownDocument(
    markdownManager.parse(
      "Before ![safe](https://example.com/safe.png) after.\n\n- nested ![list image](https://example.com/list.png) tail\n\n[unsafe](javascript:alert(1))\n\n![blocked](data:image/svg+xml,unsafe)",
    ) as ContentNode,
  );

  assert.deepEqual(
    parsed.content?.map((node) => node.type),
    ["paragraph", "image", "paragraph", "bulletList", "paragraph", "paragraph"],
  );
  const schema = getSchema(extensions);
  assert.doesNotThrow(() =>
    schema.nodeFromJSON(parsed as JSONContent).check(),
  );
  const text = JSON.stringify(parsed);
  assert.ok(!text.includes("javascript:"));
  assert.ok(!text.includes("data:image"));
  assert.ok(text.includes("https://example.com/safe.png"));
  assert.ok(text.includes("blocked"));
});
