import type { Metadata } from "next";
import "@fontsource-variable/vazirmatn";
import "./globals.css";

export const metadata: Metadata = {
  title: "نووا | مسیر روشن موفقیت تحصیلی",
  description: "مشاوره تخصصی و منابع معتبر برای دانش‌آموزان پایه دهم تا دوازدهم",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="fa" dir="rtl">
      <body>{children}</body>
    </html>
  );
}
