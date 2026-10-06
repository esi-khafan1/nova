import "./auth-gradient.css";
import { UnifiedAuth } from "@/components/auth/unified-auth";

export default async function AuthPage({
  searchParams,
}: {
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  const params = await searchParams;
  const initialMode = params.mode === "signup" ? "signup" : "signin";

  return <UnifiedAuth initialMode={initialMode} />;
}