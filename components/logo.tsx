import Link from "next/link";

export function Logo() {
  return (
    <Link className="logo" href="/" aria-label="صفحه اصلی نووا">
      <span className="logo-mark" aria-hidden="true">
        <svg viewBox="0 0 48 48" role="presentation">
          <path className="comet-tail comet-tail-wide" d="M8 36C17 33 24 27 30 19" />
          <path className="comet-tail" d="M14 39C22 34 28 29 33 22" />
          <path
            className="comet-star"
            d="m34 9 2.7 7.3L44 19l-7.3 2.7L34 29l-2.7-7.3L24 19l7.3-2.7L34 9Z"
          />
        </svg>
      </span>
      <span>
        <strong>نووا</strong>
        <small>NOVA</small>
      </span>
    </Link>
  );
}
