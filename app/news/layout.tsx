import type { ReactNode } from "react";
import { LandingHeader } from "@/components/landing-header";
import { getRequestUser } from "@/lib/supabase/request-auth";
import "../landing-approved.css";
import "../mag/magazine-theme.css";
import "../editorial-content.css";

export default async function NewsLayout({ children }: { children: ReactNode }) {
  const { user } = await getRequestUser();
  return <div className="magazine-theme news-theme"><LandingHeader isAuthenticated={Boolean(user)} />{children}</div>;
}
