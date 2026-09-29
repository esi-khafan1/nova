# Nova | نووا

سامانه فارسی مشاوره تحصیلی برای دانش‌آموزان پایه دهم تا دوازدهم.

## فناوری‌ها

- Next.js App Router + TypeScript
- Supabase Auth و PostgreSQL
- Vercel

## اجرای محلی

1. فایل `.env.example` را با نام `.env.local` کپی کنید.
2. متغیرهای Supabase را وارد کنید.
3. اجرا:

```bash
npm install
npm run dev
```

## شاخه‌ها و انتشار

- `main`: نسخه اصلی و Production
- شاخه‌های `feature/*`: پیش‌نمایش Vercel و بررسی قبل از ادغام
- هر Push به شاخه فعال، Preview را به‌صورت خودکار به‌روزرسانی می‌کند.
