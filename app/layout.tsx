import type { Metadata } from "next";
import "@fontsource-variable/estedad";
import "./globals.css";

export const metadata: Metadata = {
  metadataBase: new URL("https://nova-academy.ir"),
  title: "نووا | مسیر روشن موفقیت تحصیلی",
  description: "مشاوره تخصصی و منابع معتبر برای دانش‌آموزان پایه دهم تا دوازدهم",
  openGraph: {
    title: "نووا | مسیر روشن موفقیت تحصیلی",
    description: "مشاوره تخصصی و منابع معتبر برای دانش‌آموزان پایه دهم تا دوازدهم",
    url: "https://nova-academy.ir",
    siteName: "آکادمی نووا",
    locale: "fa_IR",
    type: "website",
  },
  alternates: {
    canonical: "https://nova-academy.ir",
  },
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="fa" dir="rtl">
      <body>{children}</body>
    </html>
  );
}
