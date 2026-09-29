import { redirect } from "next/navigation";
import { Logo } from "@/components/logo";
import { createClient } from "@/lib/supabase/server";

export default async function Dashboard() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/auth/sign-in");
  const { data: profile } = await supabase.from("profiles").select("full_name, role, grade").eq("id", user.id).single();
  return <main className="dashboard-shell"><section className="dashboard-panel"><Logo /><h1>سلام {profile?.full_name || "دانش‌آموز نووا"}</h1><p>پنل اولیه تو آماده است. در مرحله بعد برنامه درسی، درخواست‌های مشاوره و منابع پیشنهادی اینجا قرار می‌گیرند.</p><div className="empty-state">هنوز برنامه‌ای برایت ثبت نشده است.</div></section></main>;
}
