import Link from "next/link";

export function Logo() {
  return (
    <Link className="logo" href="/" aria-label="صفحه اصلی نووا">
      <span className="logo-mark" aria-hidden="true">ن</span>
      <span>
        <strong>نووا</strong>
        <small>NOVA</small>
      </span>
    </Link>
  );
}
