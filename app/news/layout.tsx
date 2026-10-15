import type { ReactNode } from "react";
import { LandingHeader } from "@/components/landing-header";
import { createClient } from "@/lib/supabase/server";
import "../landing-approved.css";
import "../mag/magazine-theme.css";
import "../editorial-content.css";

export default async function NewsLayout({ children }: { children: ReactNode }) {
  const { data: { user } } = await (await createClient()).auth.getUser();
  return <div className="magazine-theme news-theme"><LandingHeader isAuthenticated={Boolean(user)} />{children}</div>;
}
