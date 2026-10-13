"use client";
import { useTransition } from "react";
import { useRouter } from "next/navigation";
export function ReportRefreshButton(){const router=useRouter();const [pending,startTransition]=useTransition();return <button type="button" className="cp-refresh" disabled={pending} onClick={()=>startTransition(()=>router.refresh())}>{pending?"در حال دریافت گزارش…":"به‌روزرسانی گزارش"}</button>;}
