import "../landing-approved.css";
import "./auth-gradient.css";
import { UnifiedAuth } from "@/components/auth/unified-auth";
import { safeReturnPath } from "@/lib/return-path";
import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";

export default async function AuthPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  const params = await searchParams;
  const initialMode = params.mode === "signup" ? "signup" : "signin";

  const returnTo = safeReturnPath(params.next);
  const { data: { user } } = await (await createClient()).auth.getUser();
  if (user?.email_confirmed_at) redirect(returnTo);
  return <UnifiedAuth initialMode={initialMode} returnTo={returnTo} initialMessage={user || params.error === "unconfirmed" ? "ابتدا لینک تأیید ایمیل را باز کن، سپس وارد حساب شو." : ""} />;
}