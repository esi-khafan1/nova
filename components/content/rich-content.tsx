import type { ReactNode } from "react";
import type { ContentMark, ContentNode } from "@/lib/content";

function withMarks(content: ReactNode, marks: ContentMark[] = []) {
  return marks.reduce<ReactNode>((result, mark, index) => {
    if (mark.type === "bold") return <strong key={index}>{result}</strong>;
    if (mark.type === "italic") return <em key={index}>{result}</em>;
    if (mark.type === "strike") return <s key={index}>{result}</s>;
    if (mark.type === "code") return <code key={index}>{result}</code>;
    if (mark.type === "link" && typeof mark.attrs?.href === "string") {
      const external = mark.attrs.href.startsWith("http");
      return (
        <a
          key={index}
          href={mark.attrs.href}
          rel={external ? "noreferrer" : undefined}
          target={external ? "_blank" : undefined}
        >
          {result}
        </a>
      );
    }
    return result;
  }, content);
}

function renderNode(node: ContentNode, key: number | string): ReactNode {
  const children = (node.content ?? []).map((child, index) =>
    renderNode(child, `${key}-${index}`),
  );

  if (node.type === "text") {
    return <span key={key}>{withMarks(node.text ?? "", node.marks)}</span>;
  }
  if (node.type === "paragraph") return <p key={key}>{children}</p>;
  if (node.type === "heading") {
    const level = Number(node.attrs?.level);
    if (level === 2) return <h2 key={key}>{children}</h2>;
    return <h3 key={key}>{children}</h3>;
  }
  if (node.type === "bulletList") return <ul key={key}>{children}</ul>;
  if (node.type === "orderedList") return <ol key={key}>{children}</ol>;
  if (node.type === "listItem") return <li key={key}>{children}</li>;
  if (node.type === "blockquote")
    return <blockquote key={key}>{children}</blockquote>;
  if (node.type === "hardBreak") return <br key={key} />;
  if (node.type === "horizontalRule") return <hr key={key} />;
  if (node.type === "image" && typeof node.attrs?.src === "string") {
    return (
      // ImageKit URLs are dynamic and already optimized at delivery time.
      // eslint-disable-next-line @next/next/no-img-element
      <img
        key={key}
        src={node.attrs.src}
        alt={typeof node.attrs.alt === "string" ? node.attrs.alt : ""}
        loading="lazy"
      />
    );
  }
  return <div key={key}>{children}</div>;
}

export function RichContent({ document }: { document: ContentNode }) {
  return (
    <div className="article-rich-content">
      {(document.content ?? []).map((node, index) => renderNode(node, index))}
    </div>
  );
}
